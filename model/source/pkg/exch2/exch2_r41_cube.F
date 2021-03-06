C $Header: /u/gcmpack/MITgcm/pkg/exch2/exch2_rx1_cube.template,v 1.3 2005/07/22 18:21:55 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"

#undef  Dbg

CBOP
C     !ROUTINE: EXCH_R4_CUBE

C     !INTERFACE:
      SUBROUTINE EXCH2_R41_CUBE( 
     U            array, fieldCode,
     I            myOLw, myOLe, myOLn, myOLs, myNz,
     I            exchWidthX, exchWidthY,
     I            simulationMode, cornerMode, myThid )
      IMPLICIT NONE

C     !DESCRIPTION:

C     !USES:
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EXCH.h"
#include "W2_EXCH2_TOPOLOGY.h"
#include "W2_EXCH2_PARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     array :: Array with edges to exchange.
C     myOLw :: West, East, North and South overlap region sizes.
C     myOLe
C     myOLn
C     myOLs
C     exchWidthX :: Width of data regi exchanged in X.
C     exchWidthY :: Width of data region exchanged in Y.
C     myThid         :: Thread number of this instance of S/R EXCH...
      CHARACTER*2 fieldCode
      INTEGER myOLw
      INTEGER myOLe
      INTEGER myOLs
      INTEGER myOLn
      INTEGER myNz
      INTEGER exchWidthX
      INTEGER exchWidthY
      INTEGER simulationMode
      INTEGER cornerMode
      INTEGER myThid
      _R4 array(1-myOLw:sNx+myOLe,
     &          1-myOLs:sNy+myOLn, 
     &          myNZ, nSx, nSy)

C     !LOCAL VARIABLES:
C     theSimulationMode :: Holds working copy of simulation mode
C     theCornerMode     :: Holds working copy of corner mode
C     I,J,K,bl,bt,bn,bs :: Loop and index counters
C     be,bw
      INTEGER theSimulationMode
      INTEGER theCornerMode
c     INTEGER I,J,K
c     INTEGER bl,bt,bn,bs,be,bw
      INTEGER I
C     Variables for working through W2 topology
      INTEGER e2_msgHandles(2,MAX_NEIGHBOURS, nSx)
      INTEGER thisTile, farTile, N, nN, oN
      INTEGER tIlo, tIhi, tJlo, tJhi, tKlo, tKhi
      INTEGER tIStride, tJStride, tKStride
      INTEGER i1Lo, i1Hi, j1Lo, j1Hi, k1Lo, k1Hi
      INTEGER bi1Lo, bi1Hi, bj1Lo, bj1Hi
C     == Statement function ==
C     tilemod - Permutes indices to return neighboring tile index on
C               six face cube.
c     INTEGER tilemod

C     MPI stuff (should be in a routine call)
#ifdef ALLOW_USE_MPI
      INTEGER mpiStatus(MPI_STATUS_SIZE)
      INTEGER mpiRc
      INTEGER wHandle
#endif
CEOP

      theSimulationMode = simulationMode
      theCornerMode     = cornerMode

C     For now tile<->tile exchanges are sequentialised through
C     thread 1. This is a temporary feature for preliminary testing until
C     general tile decomposistion is in place (CNH April 11, 2001)
      CALL BAR2( myThid )

C     Post sends as messages or buffer copies
      DO I=myBxLo(myThid), myBxHi(myThid)
       thisTile=W2_myTileList(I)
       nN=exch2_nNeighbours(thisTile)
       DO N=1,nN
        farTile=exch2_neighbourId(N,thisTile)
        tIlo =exch2_itlo_c(N,thisTile)
        tIhi =exch2_ithi_c(N,thisTile)
        tJlo =exch2_jtlo_c(N,thisTile)
        tJhi =exch2_jthi_c(N,thisTile)
        CALL EXCH2_GET_SEND_BOUNDS(
     I       fieldCode, exchWidthX,
     O       tiStride, tjStride,
     U       tIlo, tiHi, tjLo, tjHi )
        tKLo=1
        tKHi=myNz
        tKStride=1
        i1Lo  = 1-myOLw
        i1Hi  = sNx+myOLe
        j1Lo  = 1-myOLs
        j1Hi  = sNy+myOLs
        k1Lo  = 1
        k1Hi  = myNz
        bi1Lo = I
        bi1Hi = I
        bj1Lo = 1
        bj1Hi = 1
C       Send to neighbour N to fill neighbor points 
C       (tIlo:tIhi:tiStride,tJlo:tJhi,tJStride,tKlo:tKhi,tKStride)
C       in its copy of "array".
        CALL EXCH2_SEND_R41(
     I       tIlo, tIhi, tiStride, 
     I       tJlo, tJhi, tjStride, 
     I       tKlo, tKhi, tkStride,
     I       thisTile, N,
     I       e2Bufr1_R4(1,N,I,1), e2BufrRecSize,
     I       array(1-myOLw,1-myOLs,1,I,1),
     I       i1Lo, i1Hi, j1Lo, j1Hi, k1Lo, k1Hi,
     O       e2_msgHandles(1,N,I), 
     I       W2_myCommFlag(N,I),
     I       myThid )
       ENDDO
      ENDDO

C     Receive messages or extract buffer copies
      DO I=myBxLo(myThid), myBxHi(myThid)
       thisTile=W2_myTileList(I)
       nN=exch2_nNeighbours(thisTile)
       DO N=1,nN
        farTile=exch2_neighbourId(N,thisTile)
        oN=exch2_opposingSend_Record(N,thisTile)
        tIlo =exch2_itlo_c(oN,farTile)
        tIhi =exch2_ithi_c(oN,farTile)
        tJlo =exch2_jtlo_c(oN,farTile)
        tJhi =exch2_jthi_c(oN,farTile)
        CALL EXCH2_GET_RECV_BOUNDS(
     I       fieldCode, exchWidthX,
     O       tiStride, tjStride,
     U       tIlo, tiHi, tjLo, tjHi )
        tKLo=1
        tKHi=myNz
        tKStride=1
        i1Lo  = 1-myOLw
        i1Hi  = sNx+myOLe
        j1Lo  = 1-myOLs
        j1Hi  = sNy+myOLs
        k1Lo  = 1
        k1Hi  = myNz
        bi1Lo = I
        bi1Hi = I
        bj1Lo = 1
        bj1Hi = 1

C       Receive from neighbour N to fill my points 
C       (tIlo:tIhi:tiStride,tJlo:tJhi,tJStride,tKlo:tKhi,tKStride)
C       in "array". 
C       Note: when transferring data within a process:
C             o e2Bufr entry to read is entry associated with opposing send record
C             o e2_msgHandle entry to read is entry associated with opposing send
C               record.
        CALL EXCH2_RECV_R41(
     I       tIlo, tIhi, tiStride, 
     I       tJlo, tJhi, tjStride, 
     I       tKlo, tKhi, tkStride,
     I       thisTile, I, N,
     I       e2Bufr1_R4, e2BufrRecSize,
     I       MAX_NEIGHBOURS, nSx,
     I       array(1-myOLw,1-myOLs,1,I,1),
     I       i1Lo, i1Hi, j1Lo, j1Hi, k1Lo, k1Hi,
     U       e2_msgHandles, 
     I       W2_myTileList,
     I       W2_myCommFlag(N,I),
     I       myThid )
       ENDDO
      ENDDO

C     Clear message handles/locks
      DO I=1,nSx
       thisTile=W2_myTileList(I)
       nN=exch2_nNeighbours(thisTile)
       DO N=1,nN
C       Note: In a between process tile-tile data transport using
C             MPI the sender needs to clear an Isend wait handle here.
C             In a within process tile-tile data transport using true
C             shared address space/or direct transfer through commonly
C             addressable memory blocks the receiver needs to assert 
C             that is has consumed the buffer the sender filled here.
        farTile=exch2_neighbourId(N,thisTile)
        IF     ( W2_myCommFlag(N,I) .EQ. 'M' ) THEN
#ifdef ALLOW_USE_MPI
         wHandle = e2_msgHandles(1,N,I)
         CALL MPI_Wait( wHandle, mpiStatus, mpiRc )
#endif
        ELSEIF ( W2_myCommFlag(N,I) .EQ. 'P' ) THEN
        ELSE
        ENDIF
       ENDDO
      ENDDO

      CALL BAR2(myThid)
  
      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
