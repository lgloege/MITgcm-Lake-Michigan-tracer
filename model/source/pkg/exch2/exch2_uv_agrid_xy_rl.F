C $Header: /u/gcmpack/MITgcm/pkg/exch2/exch2_uv_agrid_xy_rx.template,v 1.5 2004/11/19 02:36:17 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"

      SUBROUTINE EXCH2_UV_AGRID_XY_RL(
     U                                 component1, component2,
     I                                 withSigns, myThid )

C*=====================================================================*
C  Purpose: SUBROUTINE EXCH2_UV_AGRID_XY_RL will
C      handle exchanges for a 2D vector field on an A-grid.  
C
C  Input: component1(lon,lat,bi,bj) - first component of vector
C         component2(lon,lat,bi,bj) - second component of vector
C         withSigns (logical)       - true to use sign of components
C         myThid                    - Thread number
C
C  Output: component1 and component2 are updated (halo regions filled)
C
C  Calls: exch (exch2_xy_rx ) - twice, once for the first-component,
C                                      once for second.
C
C*=====================================================================*

      IMPLICIT NONE

#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "W2_EXCH2_TOPOLOGY.h"
#include "W2_EXCH2_PARAMS.h"

C     == Argument list variables ==
      _RL component1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL component2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      LOGICAL withSigns
      INTEGER myThid

C     == Local variables ==
C     i,j,bi,bj  are DO indices.
C     OL[wens] - Overlap extents in west, east, north, south.
C     exchWidth[XY] - Extent of regions that will be exchanged.
C     dummy[12] - copies of the vector components with haloes filled.

      INTEGER i,j,bi,bj
      INTEGER OLw, OLe, OLn, OLs, exchWidthX, exchWidthY, myNz
      _RL dummy1(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL dummy2(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER mytile, myface

      OLw        = OLx
      OLe        = OLx
      OLn        = OLy
      OLs        = OLy
      exchWidthX = OLx
      exchWidthY = OLy
      myNz       = 1

      IF ( useCubedSphereExchange ) THEN

C First CALL the exchanges for the two components

       CALL EXCH2_XY_RL( component1, myThid )
       CALL EXCH2_XY_RL( component2, myThid )

C Then if we are on the sphere we may need to switch u and v components
C and/or the signs depending on which cube face we are located.

C--    Loops on tile indices:
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)

C First we need to copy the component info into dummy arrays
          DO j = 1-OLy,sNy+OLy
           DO i = 1-OLx,sNx+OLx
             dummy1(i,j) = component1(i,j,bi,bj)
             dummy2(i,j) = component2(i,j,bi,bj)
           ENDDO
          ENDDO

C Now choose what to DO at each edge of the halo based on which face
C    (we assume that bj is always=1)

          mytile = W2_myTileList(bi)
          myface = exch2_myFace(mytile)
C odd faces share disposition of all sections of the halo
          IF ( MOD(myface,2).EQ.1 ) THEN
C east (nothing to change)
c          IF (exch2_isEedge(mytile).EQ.1) THEN
c            DO j = 1,sNy
c             DO i = 1,exchWidthX
c              component1(sNx+i,j,bi,bj) = dummy1(sNx+i,j)
c              component2(sNx+i,j,bi,bj) = dummy2(sNx+i,j)
c             ENDDO
c            ENDDO
c          ENDIF
C west
           IF (exch2_isWedge(mytile).EQ.1) THEN
            IF (withSigns) THEN
             DO j = 1,sNy
              DO i = 1,exchWidthX
               component1(i-OLx,j,bi,bj) =  dummy2(i-OLx,j)
               component2(i-OLx,j,bi,bj) = -dummy1(i-OLx,j)
              ENDDO
             ENDDO
            ELSE
             DO j = 1,sNy
              DO i = 1,exchWidthX
               component1(i-OLx,j,bi,bj) =  dummy2(i-OLx,j)
               component2(i-OLx,j,bi,bj) =  dummy1(i-OLx,j)
              ENDDO
             ENDDO
            ENDIF
           ENDIF
C north
           IF (exch2_isNedge(mytile).EQ.1) THEN
            IF (withSigns) THEN
             DO j = 1,exchWidthY
              DO i = 1,sNx
               component1(i,sNy+j,bi,bj) = -dummy2(i,sNy+j)
               component2(i,sNy+j,bi,bj) =  dummy1(i,sNy+j)
              ENDDO
             ENDDO
            ELSE
             DO j = 1,exchWidthY
              DO i = 1,sNx
               component1(i,sNy+j,bi,bj) =  dummy2(i,sNy+j)
               component2(i,sNy+j,bi,bj) =  dummy1(i,sNy+j)
              ENDDO
             ENDDO
            ENDIF
           ENDIF
C south (nothing to change)
c          IF (exch2_isSedge(mytile).EQ.1) THEN
c            DO j = 1,exchWidthY
c             DO i = 1,sNx
c              component1(i,j-OLx,bi,bj) = dummy1(i,j-OLx)
c              component2(i,j-OLx,bi,bj) = dummy2(i,j-OLx)
c             ENDDO
c            ENDDO
c          ENDIF

          ELSE
C now the even faces (share disposition of all sections of the halo)

C east
           IF (exch2_isEedge(mytile).EQ.1) THEN
            IF (withSigns) THEN
             DO j = 1,sNy
              DO i = 1,exchWidthX
               component1(sNx+i,j,bi,bj) =  dummy2(sNx+i,j)
               component2(sNx+i,j,bi,bj) = -dummy1(sNx+i,j)
              ENDDO
             ENDDO
            ELSE
             DO j = 1,sNy
              DO i = 1,exchWidthX
               component1(sNx+i,j,bi,bj) =  dummy2(sNx+i,j)
               component2(sNx+i,j,bi,bj) = -dummy1(sNx+i,j)
              ENDDO
             ENDDO
            ENDIF
           ENDIF
C west (nothing to change)
c          IF (exch2_isWedge(mytile).EQ.1) THEN
c            DO j = 1,sNy
c             DO i = 1,exchWidthX
c              component1(i-OLx,j,bi,bj) = dummy1(i-OLx,j)
c              component2(i-OLx,j,bi,bj) = dummy2(i-OLx,j)
c             ENDDO
c            ENDDO
c          ENDIF
C north (nothing to change)
c          IF (exch2_isNedge(mytile).EQ.1) THEN
c            DO j = 1,exchWidthY
c             DO i = 1,sNx
c              component1(i,sNy+j,bi,bj) = dummy1(i,sNy+j)
c              component2(i,sNy+j,bi,bj) = dummy2(i,sNy+j)
c             ENDDO
c            ENDDO
c          ENDIF
C south
           IF (exch2_isSedge(mytile).EQ.1) THEN
            IF (withSigns) THEN
             DO j = 1,exchWidthY
              DO i = 1,sNx
               component1(i,j-OLy,bi,bj) = -dummy2(i,j-OLy)
               component2(i,j-OLy,bi,bj) =  dummy1(i,j-OLy)
              ENDDO
             ENDDO
            ELSE
             DO j = 1,exchWidthY
              DO i = 1,sNx
               component1(i,j-OLy,bi,bj) =  dummy2(i,j-OLy)
               component2(i,j-OLy,bi,bj) =  dummy1(i,j-OLy)
              ENDDO
             ENDDO
            ENDIF
           ENDIF

C end odd / even faces
          ENDIF

C--    end of Loops on tile indices (bi,bj).
        ENDDO
       ENDDO

      ELSE

c      CALL EXCH_RL( component1,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
c      CALL EXCH_RL( component2,
c    I            OLw, OLe, OLs, OLn, myNz,
c    I            exchWidthX, exchWidthY,
c    I            FORWARD_SIMULATION, EXCH_UPDATE_CORNERS, myThid )
C_jmc: for JAM compatibility, replace the 2 CALLs above by the 2 CPP_MACROs:
       _EXCH_XY_RL( component1, myThid )
       _EXCH_XY_RL( component2, myThid )

      ENDIF

      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
