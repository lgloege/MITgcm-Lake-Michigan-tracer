C $Header: /u/gcmpack/MITgcm/pkg/exch2/exch2_uv_xy_rx.template,v 1.7 2005/11/04 01:31:04 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"
#include "W2_OPTIONS.h"

CBOP

C     !ROUTINE: EXCH_UV_XY_RL

C     !INTERFACE:
      SUBROUTINE EXCH2_UV_XY_RL(
     U                       Uphi, Vphi, withSigns,
     I                       myThid )
      IMPLICIT NONE
C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE EXCH_UV_XY_RL
C     | o Handle exchanges for _RL, two-dimensional arrays.
C     *==========================================================*
C     | Driver exchange routine which branches to cube sphere or
C     | global, simple cartesian index grid. Exchange routine is
C     | called with two arrays that are components of a vector.
C     | These components are rotated and interchanged on the
C     | rotated grid during cube exchanges.
C     *==========================================================*

C     !USES:
C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "W2_EXCH2_TOPOLOGY.h"
#include "W2_EXCH2_PARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     Uphi      :: Arrays with overlap regions are to be exchanged
C     Vphi         Note - The interface to EXCH_ assumes that
C                  the standard Fortran 77 sequence association rules
C                  apply.
C     myThid    :: My thread id.
C     withSigns :: Flag controlling whether vector is signed.
      _RL Uphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL Vphi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      LOGICAL withSigns
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     OL[wens]       :: Overlap extents in west, east, north, south.
C     exchWidth[XY]  :: Extent of regions that will be exchanged.
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY, myNz
      INTEGER bi, bj, myTile, j
#ifdef W2_FILL_NULL_REGIONS
      INTEGER i
#endif
CEOP

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy
      myNz       = 1
C     ** NOTE ** The exchange routine we use here does not
C                require the preceeding and following barriers.
C                However, the slow, simple exchange interface
C                that is calling it here is meant to ensure
C                that threads are synchronised before exchanges
C                begine.
      IF (useCubedSphereExchange) THEN

       CALL EXCH2_RL2_CUBE( Uphi, Vphi, withSigns, 'UV',
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
       CALL EXCH2_RL2_CUBE( Uphi, Vphi, withSigns, 'UV',
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
       CALL EXCH2_RL2_CUBE( Uphi, Vphi, withSigns, 'UV',
     I            OLw, OLe, OLs, OLn, myNz,
     I            exchWidthX, exchWidthY,
     I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )

       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         myTile = W2_myTileList(bi)

         IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &        exch2_isSedge(myTile) .EQ. 1 ) THEN
C         Uphi(snx+1,    0,bi,bj)= vPhi(snx+1,    1,bi,bj)
          DO j=1-olx,0
           Uphi(snx+1,    j,bi,bj)= vPhi(snx+(1-j),    1,bi,bj)
          ENDDO
         ENDIF
         IF ( withSigns ) THEN
          IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &         exch2_isNedge(myTile) .EQ. 1 ) THEN
C          Uphi(snx+1,sny+1,bi,bj)=-vPhi(snx+1,sny+1,bi,bj)
           DO j=1,olx
            Uphi(snx+1,sny+j,bi,bj)=-vPhi(snx+j,sny+1,bi,bj)
           ENDDO
          ENDIF
         ELSE
          IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &         exch2_isNedge(myTile) .EQ. 1 ) THEN
C          Uphi(snx+1,sny+1,bi,bj)= vPhi(snx+1,sny+1,bi,bj)
           DO j=1,olx
            Uphi(snx+1,sny+j,bi,bj)= vPhi(snx+j,sny+1,bi,bj)
           ENDDO
          ENDIF
         ENDIF

C--      Now zero out the null areas that should not be used in the numerics
C        Also add one valid u,v value next to the corner, that allows
C         to compute vorticity on a wider stencil (e.g., vort3(0,1) & (1,0))

         IF ( exch2_isWedge(myTile) .EQ. 1 .AND.
     &        exch2_isSedge(myTile) .EQ. 1 ) THEN
C         Zero SW corner points
#ifdef W2_FILL_NULL_REGIONS
          DO J=1-OLx,0
           DO I=1-OLx,0
            uPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
          DO J=1-OLx,0
           DO I=1-OLx,0
            vPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
#endif
            uPhi(0,0,bi,bj)=vPhi(1,0,bi,bj)
            vPhi(0,0,bi,bj)=uPhi(0,1,bi,bj)
         ENDIF

         IF ( exch2_isWedge(myTile) .EQ. 1 .AND.
     &        exch2_isNedge(myTile) .EQ. 1 ) THEN
C         Zero NW corner points
#ifdef W2_FILL_NULL_REGIONS
          DO J=sNy+1,sNy+OLy
           DO I=1-OLx,0
            uPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
          DO J=sNy+2,sNy+OLy
           DO I=1-OLx,0
            vPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
#endif
          IF ( withSigns ) THEN
            uPhi(0,sNy+1,bi,bj)=-vPhi(1,sNy+2,bi,bj)
            vPhi(0,sNy+2,bi,bj)=-uPhi(0,sNy,bi,bj)
          ELSE
            uPhi(0,sNy+1,bi,bj)= vPhi(1,sNy+2,bi,bj)
            vPhi(0,sNy+2,bi,bj)= uPhi(0,sNy,bi,bj)
          ENDIF
         ENDIF

         IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &        exch2_isSedge(myTile) .EQ. 1 ) THEN
C         Zero SE corner points
#ifdef W2_FILL_NULL_REGIONS
          DO J=1-OLx,0
           DO I=sNx+2,sNx+OLx
            uPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
          DO J=1-OLx,0
           DO I=sNx+1,sNx+OLx
            vPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
#endif
          IF ( withSigns ) THEN
            uPhi(sNx+2,0,bi,bj)=-vPhi(sNx,0,bi,bj)
            vPhi(sNx+1,0,bi,bj)=-uPhi(sNx+2,1,bi,bj)
          ELSE
            uPhi(sNx+2,0,bi,bj)= vPhi(sNx,0,bi,bj)
            vPhi(sNx+1,0,bi,bj)= uPhi(sNx+2,1,bi,bj)
          ENDIF
         ENDIF

         IF ( exch2_isEedge(myTile) .EQ. 1 .AND.
     &        exch2_isNedge(myTile) .EQ. 1 ) THEN
C         Zero NE corner points
#ifdef W2_FILL_NULL_REGIONS
          DO J=sNy+1,sNy+OLy
           DO I=sNx+2,sNx+OLx
            uPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
          DO J=sNy+2,sNy+OLy
           DO I=sNx+1,sNx+OLx
            vPhi(I,J,bi,bj)=e2FillValue_RL
           ENDDO
          ENDDO
#endif
            uPhi(sNx+2,sNy+1,bi,bj)=vPhi(sNx,sNy+2,bi,bj)
            vPhi(sNx+1,sNy+2,bi,bj)=uPhi(sNx+2,sNy,bi,bj)
         ENDIF

C-      end bi,bj loops.
        ENDDO
       ENDDO

      ELSE

c      CALL EXCH_RL( Uphi,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
c      CALL EXCH_RL( Vphi,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
c_jmc: for JAM compatibility, replace the 2 CALLs above by the 2 CPP_MACROs:
       _EXCH_XY_RL( Uphi, myThid )
       _EXCH_XY_RL( Vphi, myThid )

      ENDIF

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
