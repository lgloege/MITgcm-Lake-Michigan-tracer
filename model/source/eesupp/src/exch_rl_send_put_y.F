C $Header: /u/gcmpack/MITgcm/eesupp/src/exch_rx_send_put_y.template,v 1.6 2005/11/11 03:01:26 cnh Exp $
C $Name:  $
#include "CPP_EEOPTIONS.h"

CBOP
C     !ROUTINE: EXCH_RL_SEND_PUT_Y

C     !INTERFACE:
      SUBROUTINE EXCH_RL_SEND_PUT_Y( array,
     I             myOLw, myOLe, myOLs, myOLn, myNz,
     I             exchWidthX, exchWidthY,
     I             thesimulationMode, thecornerMode, myThid )
      IMPLICIT NONE
C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE SEND_PUT_Y                                     
C     | o "Send" or "put" Y edges for RL array.                   
C     *==========================================================*
C     | Routine that invokes actual message passing send or       
C     | direct "put" of data to update Y faces of an XY[R] array. 
C     *==========================================================*

C     !USES:
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EXCH.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     array :: Array with edges to exchange.
C     myOLw :: West, East, North and South overlap region sizes.
C     myOLe
C     myOLn
C     myOLs
C     exchWidthX :: Width of data region exchanged.
C     exchWidthY
C     theSimulationMode :: Forward or reverse mode exchange ( provides 
C                          support for adjoint integration of code. )
C                          Note - the reverse mode for an assignment 
C                                 is an accumulation. This means that 
C                                 put implementations that do leary things
C                                 like writing to overlap regions in a 
C                                 remote process need to be even more
C                                 careful. You need to be pretty careful
C                                 in forward mode too!
C     theCornerMode     :: Flag indicating whether corner updates are 
C                          needed.
C     myThid            :: Thread number of this instance of S/R EXCH...
C     eBl               :: Edge buffer level
      INTEGER myOLw
      INTEGER myOLe
      INTEGER myOLs
      INTEGER myOLn
      INTEGER myNz
      _RL array(1-myOLw:sNx+myOLe,
     &          1-myOLs:sNy+myOLn, 
     &          myNZ, nSx, nSy)
      INTEGER exchWidthX
      INTEGER exchWidthY
      INTEGER theSimulationMode
      INTEGER theCornerMode
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     I, J, K, jMin, jMax, iB    - Loop counters and extents
C     bi, bj  
C     biS, bjS                   - South tile indices
C     biN, bjN                   - North tile indices
C     eBl                        - Current exchange buffer level
C     theProc, theTag, theType,  - Variables used in message building
C     theSize
C     southCommMode              - Working variables holding type
C     northCommMode                of communication a particular
C                                  tile face uses.
      INTEGER I, J, K, jMin, jMax, iMin, iMax, iB
      INTEGER bi, bj, biS, bjS, biN, bjN
      INTEGER eBl
      INTEGER northCommMode
      INTEGER southCommMode
#ifdef ALLOW_USE_MPI
      INTEGER theProc, theTag, theType, theSize, mpiRc
#endif

C--   Write data to exchange buffer
C     Various actions are possible depending on the communication mode 
C     as follows:
C       Mode      Action
C     --------   ---------------------------
C     COMM_NONE  Do nothing
C
C     COMM_MSG   Message passing communication ( e.g. MPI )
C                Fill south send buffer from this tile.
C                Send data with tag identifying tile and direction.
C                Fill north send buffer from this tile.
C                Send data with tag identifying tile and direction.
C
C     COMM_PUT   "Put" communication ( UMP_, shmemput, etc... )
C                Fill south receive buffer of south-neighbor tile
C                Fill north receive buffer of north-neighbor tile
C                Sync. memory
C                Write data-ready Ack for north edge of south-neighbor
C                tile
C                Write data-ready Ack for south edge of north-neighbor
C                tile
C                Sync. memory
CEOP

       INTEGER myBxLoSave(MAX_NO_THREADS)
       INTEGER myBxHiSave(MAX_NO_THREADS)
       INTEGER myByLoSave(MAX_NO_THREADS)
       INTEGER myByHiSave(MAX_NO_THREADS)
       LOGICAL doingSingleThreadedComms

       doingSingleThreadedComms = .FALSE.
#ifdef ALLOW_USE_MPI
#ifndef ALWAYS_USE_MPI
      IF ( usingMPI ) THEN
#endif
C      Set default behavior to have MPI comms done by a single thread.
C      Most MPI implementations don't support concurrent comms from
C      several threads.
       IF ( nThreads .GT. 1 ) THEN
        _BARRIER
        _BEGIN_MASTER( myThid )
         DO I=1,nThreads
          myBxLoSave(I) = myBxLo(I)
          myBxHiSave(I) = myBxHi(I)
          myByLoSave(I) = myByLo(I)
          myByHiSave(I) = myByHi(I)
         ENDDO
C        Comment out loop below and myB[xy][Lo|Hi](1) settings below
C        if you want to get multi-threaded MPI comms.
         DO I=1,nThreads
          myBxLo(I) = 0
          myBxHi(I) = -1
          myByLo(I) = 0
          myByHi(I) = -1
         ENDDO
         myBxLo(1) = 1
         myBxHi(1) = nSx
         myByLo(1) = 1
         myByHi(1) = nSy
         doingSingleThreadedComms = .TRUE.
        _END_MASTER( myThid )
        _BARRIER
      ENDIF
#ifndef ALWAYS_USE_MPI
      ENDIF
#endif
#endif
C      
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)

        ebL = exchangeBufLevel(1,bi,bj)
        southCommMode  = _tileCommModeS(bi,bj)
        northCommMode  = _tileCommModeN(bi,bj)
        biS =  _tileBiS(bi,bj)
        bjS =  _tileBjS(bi,bj)
        biN =  _tileBiN(bi,bj)
        bjN =  _tileBjN(bi,bj)
        iMin = 1
        iMax = sNx
        IF ( theCornerMode .EQ. EXCH_UPDATE_CORNERS ) THEN
         iMin =   1-exchWidthX
         iMax = sNx+exchWidthX
        ENDIF


c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> FORWARD RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

C       o Send or Put south edge
        IF     ( _theSimulationMode .EQ. FORWARD_SIMULATION ) THEN
         jMin = 1
         jMax = 1+exchWidthY-1
        IF ( southCommMode .EQ. COMM_MSG  ) THEN
         iB = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            southSendBuf_RL(iB,eBl,bi,bj) = array(I,J,K,bi,bj)
           ENDDO
          ENDDO
         ENDDO
C        Send the data
#ifdef ALLOW_USE_MPI
#ifndef ALWAYS_USE_MPI
         IF ( usingMPI ) THEN
#endif
          theProc = tilePidS(bi,bj)
          theTag  = _tileTagSendS(bi,bj)
          theSize = iB
          theType = _MPI_TYPE_RL
          exchNreqsY(1,bi,bj) = exchNreqsY(1,bi,bj)+1
          CALL MPI_Isend(southSendBuf_RL(1,eBl,bi,bj), theSize, theType,
     &                   theProc, theTag, MPI_COMM_MODEL,
     &                   exchReqIdY(exchNreqsY(1,bi,bj),1,bi,bj), mpiRc)
#ifndef ALWAYS_USE_MPI
         ENDIF
#endif
#endif /* ALLOW_USE_MPI */
         northRecvAck(eBl,biS,bjS) = 1.
        ELSEIF ( southCommMode .EQ. COMM_PUT  ) THEN
         iB  = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            northRecvBuf_RL(iB,eBl,biS,bjS) = array(I,J,K,bi,bj)
           ENDDO
          ENDDO
         ENDDO
        ELSEIF ( southCommMode .NE. COMM_NONE 
     &   .AND.   southCommMode .NE. COMM_GET ) THEN
         STOP ' S/R EXCH: Invalid commS mode.'
        ENDIF

C       o Send or Put north edge
         jMin = sNy-exchWidthY+1
         jMax = sNy
        IF ( northCommMode .EQ. COMM_MSG  ) THEN
         iB = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            northSendBuf_RL(iB,eBl,bi,bj) = array(I,J,K,bi,bj)
           ENDDO
          ENDDO
         ENDDO
C        Send the data
#ifdef ALLOW_USE_MPI
#ifndef ALWAYS_USE_MPI
         IF ( usingMPI ) THEN
#endif
         theProc = tilePidN(bi,bj)
         theTag  = _tileTagSendN(bi,bj)
         theSize = iB
         theType = _MPI_TYPE_RL
         exchNreqsY(1,bi,bj) = exchNreqsY(1,bi,bj)+1
         CALL MPI_Isend(northSendBuf_RL(1,eBl,bi,bj), theSize, theType,
     &                  theProc, theTag, MPI_COMM_MODEL,
     &                  exchReqIdY(exchNreqsY(1,bi,bj),1,bi,bj), mpiRc )
#ifndef ALWAYS_USE_MPI
         ENDIF
#endif
#endif /* ALLOW_USE_MPI */
         southRecvAck(eBl,biN,bjN) = 1.
        ELSEIF ( northCommMode .EQ. COMM_PUT  ) THEN
         iB  = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            southRecvBuf_RL(iB,eBl,biN,bjN) = array(I,J,K,bi,bj)
           ENDDO
          ENDDO
         ENDDO
        ELSEIF ( northCommMode .NE. COMM_NONE
     &   .AND.   northCommMode .NE. COMM_GET  ) THEN
         STOP ' S/R EXCH: Invalid commN mode.'
        ENDIF

c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>> ADJOINT RUN <<<<<<<<<<<<<<<<<<<
c     >>>>>>>>>>>>>>>>>>>             <<<<<<<<<<<<<<<<<<<

        ELSEIF ( _theSimulationMode .EQ. REVERSE_SIMULATION ) THEN
         jMin = 1-exchWidthY
         jMax = 0
        IF ( southCommMode .EQ. COMM_MSG  ) THEN
         iB = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            southSendBuf_RL(iB,eBl,bi,bj) = array(I,J,K,bi,bj)
            array(I,J,K,bi,bj) = 0.0
           ENDDO
          ENDDO
         ENDDO
C        Send the data
#ifdef ALLOW_USE_MPI
#ifndef ALWAYS_USE_MPI
         IF ( usingMPI ) THEN
#endif
          theProc = tilePidS(bi,bj)
          theTag  = _tileTagSendS(bi,bj)
          theSize = iB
          theType = _MPI_TYPE_RL
          exchNreqsY(1,bi,bj) = exchNreqsY(1,bi,bj)+1
          CALL MPI_Isend(southSendBuf_RL(1,eBl,bi,bj), theSize, theType,
     &                   theProc, theTag, MPI_COMM_MODEL,
     &                   exchReqIdY(exchNreqsY(1,bi,bj),1,bi,bj), mpiRc)
#ifndef ALWAYS_USE_MPI
         ENDIF
#endif
#endif /* ALLOW_USE_MPI */
         northRecvAck(eBl,biS,bjS) = 1.
        ELSEIF ( southCommMode .EQ. COMM_PUT  ) THEN
         iB  = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            northRecvBuf_RL(iB,eBl,biS,bjS) = array(I,J,K,bi,bj)
            array(I,J,K,bi,bj) = 0.0
           ENDDO
          ENDDO
         ENDDO
        ELSEIF ( southCommMode .NE. COMM_NONE 
     &   .AND.   southCommMode .NE. COMM_GET ) THEN
         STOP ' S/R EXCH: Invalid commS mode.'
        ENDIF

C       o Send or Put north edge
         jMin = sNy+1
         jMax = sNy+exchWidthY
        IF ( northCommMode .EQ. COMM_MSG  ) THEN
         iB = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            northSendBuf_RL(iB,eBl,bi,bj) = array(I,J,K,bi,bj)
            array(I,J,K,bi,bj) = 0.0
           ENDDO
          ENDDO
         ENDDO
C        Send the data
#ifdef ALLOW_USE_MPI
#ifndef ALWAYS_USE_MPI
         IF ( usingMPI ) THEN
#endif
         theProc = tilePidN(bi,bj)
         theTag  = _tileTagSendN(bi,bj)
         theSize = iB
         theType = _MPI_TYPE_RL
         exchNreqsY(1,bi,bj) = exchNreqsY(1,bi,bj)+1
         CALL MPI_Isend(northSendBuf_RL(1,eBl,bi,bj), theSize, theType,
     &                  theProc, theTag, MPI_COMM_MODEL,
     &                  exchReqIdY(exchNreqsY(1,bi,bj),1,bi,bj), mpiRc )
#ifndef ALWAYS_USE_MPI
         ENDIF
#endif
#endif /* ALLOW_USE_MPI */
         southRecvAck(eBl,biN,bjN) = 1.
        ELSEIF ( northCommMode .EQ. COMM_PUT  ) THEN
         iB  = 0
         DO K=1,myNz
          DO J=jMin,jMax
           DO I=iMin,iMax
            iB = iB + 1
            southRecvBuf_RL(iB,eBl,biN,bjN) = array(I,J,K,bi,bj)
            array(I,J,K,bi,bj) = 0.0
           ENDDO
          ENDDO
         ENDDO
        ELSEIF ( northCommMode .NE. COMM_NONE
     &   .AND.   northCommMode .NE. COMM_GET  ) THEN
         STOP ' S/R EXCH: Invalid commN mode.'
        ENDIF
        endif
       ENDDO
      ENDDO

C--   Signal completetion ( making sure system-wide memory state is
C--                         consistent ).

C     ** NOTE ** We are relying on being able to produce strong-ordered
C     memory semantics here. In other words we assume that there is a
C     mechanism which can ensure that by the time the Ack is seen the
C     overlap region data that will be exchanged is up to date.
      IF ( exchNeedsMemSync  ) CALL MEMSYNC

      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        ebL = exchangeBufLevel(1,bi,bj)
        biS = _tileBiS(bi,bj)
        bjS = _tileBjS(bi,bj)
        biN = _tileBiN(bi,bj)
        bjN = _tileBjN(bi,bj)
        southCommMode = _tileCommModeS(bi,bj)
        northCommMode = _tileCommModeN(bi,bj)
        IF ( southCommMode .EQ. COMM_PUT ) northRecvAck(eBl,biS,bjS) = 1.
        IF ( northCommMode .EQ. COMM_PUT ) southRecvAck(eBl,biN,bjN) = 1.
        IF ( southCommMode .EQ. COMM_GET ) northRecvAck(eBl,biS,bjS) = 1.
        IF ( northCommMode .EQ. COMM_GET ) southRecvAck(eBl,biN,bjN) = 1.
       ENDDO
      ENDDO

C--   Make sure "ack" setting is seen system-wide.
C     Here strong-ordering is not an issue but we want to make
C     sure that processes that might spin on the above Ack settings
C     will see the setting.
C     ** NOTE ** On some machines we wont spin on the Ack setting
C     ( particularly the T90 ), instead we will use s system barrier.
C     On the T90 the system barrier is very fast and switches out the 
C     thread while it waits. On most machines the system barrier
C     is much too slow and if we own the machine and have one thread
C     per process preemption is not a problem.
      IF ( exchNeedsMemSync  ) CALL MEMSYNC

      _BARRIER
      IF ( doingSingleThreadedComms ) THEN
C      Restore saved settings that were stored to allow
C      single thred comms.
       _BEGIN_MASTER(myThid)
        DO I=1,nThreads
         myBxLo(I) = myBxLoSave(I)
         myBxHi(I) = myBxHiSave(I)
         myByLo(I) = myByLoSave(I)
         myByHi(I) = myByHiSave(I)
        ENDDO
       _END_MASTER(myThid)
      ENDIF                
      _BARRIER

      RETURN 
      END
