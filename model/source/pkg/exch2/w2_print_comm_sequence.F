C $Header: /u/gcmpack/MITgcm/pkg/exch2/w2_print_comm_sequence.F,v 1.2 2005/07/22 18:21:55 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"

CBOP             
C     !ROUTINE: W2_PRINT_COMM_SEQUENCE

C     !INTERFACE:
      SUBROUTINE W2_PRINT_COMM_SEQUENCE
      IMPLICIT NONE

C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE W2_PRINT_COMM_SEQUENCE                            
C     | o Write communication sequence for a given WRAPPER2 
C     |   toplogy
C     *==========================================================*
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "W2_EXCH2_TOPOLOGY.h"
#include "W2_EXCH2_PARAMS.h"

C     == Local variables ==
      CHARACTER*(MAX_LEN_MBUF) msgBuffer
      INTEGER myTileId, nN
c     INTEGER PI_TC2SC(2), PJ_TC2SC(2), O_TC2SC(2)
c     _RL     SXDIR_TX2CX(2), SYDIR_TX2CX(2)
      INTEGER targetIlo, targetIhi, targetJlo, targetJhi
      INTEGER sourceIlo, sourceIhi, sourceJlo, sourceJhi
      INTEGER I, N, targetTile, myThid, targetProc, sourceProc
      INTEGER iStride, jStride
      INTEGER pi(2), pj(2), oi, oj, tN

      myThid = 1

C     Send loop for cell centered
      DO I=1,nSx
       myTileId=W2_myTileList(I)
       nN=exch2_nNeighbours(myTileId)
       sourceProc=exch2_tProc(myTileId)
       DO N=1,nN
        targetTile=exch2_neighbourId(N,myTileId)
        targetProc=exch2_tProc(targetTile)
        targetIlo =exch2_itlo_c(N,myTileId)
        targetIhi =exch2_ithi_c(N,myTileId)
        targetJlo =exch2_jtlo_c(N,myTileId)
        targetJhi =exch2_jthi_c(N,myTileId)
        pi(1)     =exch2_pi(1,N,myTileId)
        pi(2)     =exch2_pi(2,N,myTileId)
        pj(1)     =exch2_pj(1,N,myTileId)
        pj(2)     =exch2_pj(2,N,myTileId)
        oi        =exch2_oi(N,myTileId)
        oj        =exch2_oj(N,myTileId)
        IF ( targetIlo .EQ. targetIhi .AND. targetIlo .EQ. 0 ) THEN
C        Sending to a west edge
         targetIlo=1-OLx
         targetIhi=0
         istride=1
         IF ( targetJlo .LE. targetJhi ) THEN
          targetJlo=targetJlo-OLx+1
          targetJhi=targetJhi+OLx-1
          jstride=1
         ELSE
          targetJlo=targetJlo+OLx-1
          targetJhi=targetJhi-OLx+1
          jstride=-1
         ENDIF
        ENDIF
        IF ( targetIlo .EQ. targetIhi .AND. targetIlo .GT. 1 ) THEN
C        Sending to an east edge
         targetIhi=targetIhi+OLx-1
         istride=1
         IF ( targetJlo .LE. targetJhi ) THEN
          targetJlo=targetJlo-OLx+1
          targetJhi=targetJhi+OLx-1
          jstride=1
         ELSE
          targetJlo=targetJlo+OLx-1
          targetJhi=targetJhi-OLx+1
          jstride=-1
         ENDIF
        ENDIF
        IF ( targetJlo .EQ. targetJhi .AND. targetJlo .EQ. 0 ) THEN
C        Sending to a south edge
         targetJlo=1-OLx
         targetJhi=0
         jstride=1
         IF ( targetIlo .LE. targetIhi ) THEN
          targetIlo=targetIlo-OLx+1
          targetIhi=targetIhi+OLx-1
          istride=1
         ELSE
          targetIlo=targetIlo+OLx-1
          targetIhi=targetIhi-OLx+1
          istride=-1
         ENDIF
        ENDIF
        IF ( targetJlo .EQ. targetJhi .AND. targetJlo .GT. 1 ) THEN
C        Sending to an north edge
         targetJhi=targetJhi+OLx-1
         jstride=1
         IF ( targetIlo .LE. targetIhi ) THEN
          targetIlo=targetIlo-OLx+1
          targetIhi=targetIhi+OLx-1
          istride=1
         ELSE
          targetIlo=targetIlo+OLx-1
          targetIhi=targetIhi-OLx+1
          istride=-1
         ENDIF
        ENDIF
        sourceIlo=pi(1)*targetIlo+pi(2)*targetJlo+oi
        sourceJlo=pj(1)*targetIlo+pj(2)*targetJlo+oj
        sourceIhi=pi(1)*targetIhi+pi(2)*targetJhi+oi
        sourceJhi=pj(1)*targetIhi+pj(2)*targetJhi+oj
C       Tile XX sends to points i=ilo:ihi,j=jlo:jhi in tile YY
        WRITE(msgBuffer,
     &        '(A,I4,A,I4,A,A,I4,A,I4,A,I4,A,I4)')
     &   'Tile ',myTileId
     &   ,'(proc =',sourceProc,')',
     &   ' sends points i=',sourceIlo,
     &   ':',sourceIhi,
     &   ', j=',sourceJlo,
     &   ':',sourceJhi
         CALL PRINT_MESSAGE(msgBuffer,standardMessageUnit,
     &         SQUEEZE_RIGHT,myThid)
        WRITE(msgBuffer,
     &        '(A,I4,A,I4,A,I4,A,I4,A,I4,A,I4,A)')
     &   '                         to points i=',targetIlo,
     &   ':',targetIhi,
     &   ', j=',targetJlo,
     &   ':',targetJhi,
     &   ' in tile ',targetTile,
     &   '(proc =',targetProc,')'
         CALL PRINT_MESSAGE(msgBuffer,standardMessageUnit,
     &         SQUEEZE_RIGHT,myThid)
       ENDDO
      ENDDO

C     Recv loop for cell centered
      DO I=1,nSx
       myTileId=W2_myTileList(I)
       nN=exch2_nNeighbours(myTileId)
       sourceProc=exch2_tProc(myTileId)
       DO N=1,nN
        targetTile=exch2_neighbourId(N,myTileId)
        targetProc=exch2_tProc(targetTile)
C       Find entry for tile targetTile entry that sent to this edge.
        tN=exch2_opposingSend_record(N,myTileId)
C       Get the range of points associated with that entry
        targetIlo =exch2_itlo_c(tN,targetTile)
        targetIhi =exch2_ithi_c(tN,targetTile)
        targetJlo =exch2_jtlo_c(tN,targetTile)
        targetJhi =exch2_jthi_c(tN,targetTile)
        IF ( targetIlo .EQ. targetIhi .AND. targetIlo .EQ. 0 ) THEN
C        Sending to a west edge
         targetIlo=1-OLx
         targetIhi=0
         istride=1
         IF ( targetJlo .LE. targetJhi ) THEN
          targetJlo=targetJlo-OLx+1
          targetJhi=targetJhi+OLx-1
          jstride=1
         ELSE
          targetJlo=targetJlo+OLx-1
          targetJhi=targetJhi-OLx+1
          jstride=-1
         ENDIF
        ENDIF
        IF ( targetIlo .EQ. targetIhi .AND. targetIlo .GT. 1 ) THEN
C        Sending to an east edge
         targetIhi=targetIhi+OLx-1
         istride=1
         IF ( targetJlo .LE. targetJhi ) THEN
          targetJlo=targetJlo-OLx+1
          targetJhi=targetJhi+OLx-1
          jstride=1
         ELSE
          targetJlo=targetJlo+OLx-1
          targetJhi=targetJhi-OLx+1
          jstride=-1
         ENDIF
        ENDIF
        IF ( targetJlo .EQ. targetJhi .AND. targetJlo .EQ. 0 ) THEN
C        Sending to a south edge
         targetJlo=1-OLx
         targetJhi=0
         jstride=1
         IF ( targetIlo .LE. targetIhi ) THEN
          targetIlo=targetIlo-OLx+1
          targetIhi=targetIhi+OLx-1
          istride=1
         ELSE
          targetIlo=targetIlo+OLx-1
          targetIhi=targetIhi-OLx+1
          istride=-1
         ENDIF
        ENDIF
        IF ( targetJlo .EQ. targetJhi .AND. targetJlo .GT. 1 ) THEN
C        Sending to an north edge
         targetJhi=targetJhi+OLx-1
         jstride=1
         IF ( targetIlo .LE. targetIhi ) THEN
          targetIlo=targetIlo-OLx+1
          targetIhi=targetIhi+OLx-1
          istride=1
         ELSE
          targetIlo=targetIlo+OLx-1
          targetIhi=targetIhi-OLx+1
          istride=-1
         ENDIF
        ENDIF
C       Tile XX receives points i=ilo:ihi,j=jlo:jhi in tile YY
        WRITE(msgBuffer,
     &        '(A,I4,A,I4,A,A,I4,A,I4,A,I4,A,I4,A,I4,A,I4,A)')
     &   'Tile ',myTileId
     &   ,'(proc =',targetProc,')',
     &   'recv to points i=',targetIlo,
     &   ':',targetIhi,
     &   ', j=',targetJlo,
     &   ':',targetJhi,
     &   'from tile',targetTile,
     &   '(proc =',targetProc,')'
         CALL PRINT_MESSAGE(msgBuffer,standardMessageUnit,
     &         SQUEEZE_RIGHT,myThid)
       ENDDO
      ENDDO

      RETURN
      END
