C $Header: /u/gcmpack/MITgcm/model/src/timestep_wvel.F,v 1.2 2006/02/23 20:55:49 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: TIMESTEP_WVEL
C     !INTERFACE:
      SUBROUTINE TIMESTEP_WVEL(
     I                          myTime, myIter, myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R TIMESTEP_WVEL
C     | o Step model vertical velocity forward in time
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "NH_VARS.h"
c #include "SURFACE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine Arguments ==
      _RL     myTime
      INTEGER myIter, myThid

#ifdef ALLOW_NONHYDROSTATIC
C     !LOCAL VARIABLES:
C     == Local variables ==
      INTEGER k,bi,bj
      INTEGER iMin,iMax,jMin,jMax
      INTEGER i,j
      _RL     gWtmp(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL     tmpFac, nh_Fac, igwFac
CEOP

      iMin = 1
      iMax = sNx
      jMin = 1
      jMax = sNy

      igwFac = 0.
      IF ( implicitIntGravWave ) igwFac = horiVertRatio*horiVertRatio

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C     tile loops :
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)

       IF ( nonHydrostatic ) THEN
        nh_Fac = 0.
        IF ( nh_Am2.NE.0. ) nh_Fac = 1. _d 0 / nh_Am2

        k = 1
        DO j=1-Oly,sNy+Oly
          DO i=1-Olx,sNx+Olx
            gW(i,j,k,bi,bj) = wVel(i,j,k,bi,bj)
          ENDDO
        ENDDO

        DO k=2,Nr

C     apply mask to gW and keep a copy of wVel in gW:
         DO j=1-Oly,sNy+Oly
          DO i=1-Olx,sNx+Olx
            gWtmp(i,j) = gW(i,j,k,bi,bj)
     &             *maskC(i,j,k,bi,bj)*maskC(i,j,k-1,bi,bj)
            gW(i,j,k,bi,bj) = wVel(i,j,k,bi,bj)
          ENDDO
         ENDDO
C     Step forward vertical velocity
         tmpFac = nh_Fac + igwFac*dBdrRef(k)*deltaTMom*dTtracerLev(k)
         IF (tmpFac.GT.0. ) tmpFac = 1. _d 0 / tmpFac
         DO j=jMin,jMax
          DO i=iMin,iMax
            wVel(i,j,k,bi,bj) = wVel(i,j,k,bi,bj)
     &                        + deltaTmom*tmpFac*gWtmp(i,j)
          ENDDO
         ENDDO

C-    End of k loop
        ENDDO

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

#ifdef ALLOW_OBCS
C--   This call is aesthetic: it makes the W field
C     consistent with the OBs but this has no algorithmic
C     impact. This is purely for diagnostic purposes.
        IF (useOBCS) THEN
         DO k=1,Nr
          CALL OBCS_APPLY_W( bi, bj, k, wVel, myThid )
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS */

       ELSEIF ( implicitIntGravWave ) THEN
C     keep a copy of wVel in gW:
        DO k=1,Nr
         DO j=1-Oly,sNy+Oly
          DO i=1-Olx,sNx+Olx
            gW(i,j,k,bi,bj) = wVel(i,j,k,bi,bj)
          ENDDO
         ENDDO
        ENDDO

C-    End if nonHydrostatic / elseif implicitIntGravWave
       ENDIF

C-    End of bi,bj loops
       ENDDO
      ENDDO

#endif /* ALLOW_NONHYDROSTATIC */

      RETURN
      END
