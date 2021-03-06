C $Header: /u/gcmpack/MITgcm/pkg/timeave/timeave_surf_flux.F,v 1.3 2004/10/19 02:41:31 jmc Exp $
C $Name:  $
#include "TIMEAVE_OPTIONS.h"

      SUBROUTINE TIMEAVE_SURF_FLUX(
     I     bi, bj, myTime, myIter, myThid)
C     *==========================================================*
C     | SUBROUTINE TIMEAVE_SURF_FLUX                             |
C     | o Time averaging routine for surface (forcing) fluxes    |
C     *==========================================================*
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "SURFACE.h"
#include "FFIELDS.h"
#include "TIMEAVE_STATV.h"

C     == Routine arguments ==
C     bi, bj :: current tile indices
C     myTime :: Current time of simulation ( s )
C     myIter :: Iteration number
C     myThid :: Thread number for this instance of the routine.
      INTEGER bi, bj
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

#ifdef ALLOW_TIMEAVE

C     == Local variables ==
      INTEGER I, J, K
      _RL DDTT
      _RL tmpFld (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
 
C-    Time Averages of surface fluxes
       IF ( usingPCoords ) THEN
        k=Nr
       ELSE
        k=1
       ENDIF

C-    uFlux (surface momentum flux [Pa=N/m2], positive <-> increase u)
c      DO j=1,sNy
c       DO i=1,sNx
c        tmpFld(i,j)=fu(i,j,bi,bj)*foFacMom*_maskW(i,j,k,bi,bj)
c       ENDDO
c      ENDDO
c      CALL TIMEAVE_CUMUL_1T(uFluxtave,tmpFld,1,
c    &                                   deltaTclock, bi, bj, myThid)
       DDTT = deltaTclock*foFacMom
       CALL TIMEAVE_CUMULATE( uFluxtave, fu, 1,
     &                                   DDTT, bi, bj, myThid)

C-    vFlux (surface momentum flux [Pa=N/m2], positive <-> increase v)
c      DO j=1,sNy
c       DO i=1,sNx
c        tmpFld(i,j)=fv(i,j,bi,bj)*foFacMom*_maskS(i,j,k,bi,bj)
c       ENDDO
c      ENDDO
c      CALL TIMEAVE_CUMUL_1T(vFluxtave,tmpFld,1,
c    &                                   deltaTclock, bi, bj, myThid)
       DDTT = deltaTclock*foFacMom
       CALL TIMEAVE_CUMULATE( vFluxtave, fv, 1,
     &                                   DDTT, bi, bj, myThid)

C     tFlux (=Heat flux [W/m2], positive <-> increasing Theta)
       DO j=1,sNy
        DO i=1,sNx
         tmpFld(i,j) =
#ifdef SHORTWAVE_HEATING
     &    -Qsw(i,j,bi,bj)+
#endif
     &    (surfaceForcingT(i,j,bi,bj)+surfaceForcingTice(I,J,bi,bj))
     &    *HeatCapacity_Cp*recip_horiVertRatio*rhoConst
        ENDDO
       ENDDO
#ifdef NONLIN_FRSURF
       IF ( (nonlinFreeSurf.GT.0 .OR. usingPCoords)
     &     .AND. useRealFreshWaterFlux ) THEN
        DO j=1,sNy
         DO i=1,sNx
           tmpFld(i,j) = tmpFld(i,j) 
     &      + PmEpR(i,j,bi,bj)*rhoConstFresh
     &                        *theta(i,j,k,bi,bj)*HeatCapacity_Cp
         ENDDO
        ENDDO
       ENDIF
#endif /* NONLIN_FRSURF */
       CALL TIMEAVE_CUMUL_1T( tFluxtave, tmpFld, 1,
     &                                   deltaTclock, bi, bj, myThid)

C     sFlux (=salt flux [psu.kg/m2/s], positive <-> increasing Theta)
       DO j=1,sNy
        DO i=1,sNx
         tmpFld(i,j)=
     &    surfaceForcingS(i,j,bi,bj)*
     &    recip_horiVertRatio*rhoConst
        ENDDO
       ENDDO
#ifdef NONLIN_FRSURF
       IF ( (nonlinFreeSurf.GT.0 .OR. usingPCoords)
     &     .AND. useRealFreshWaterFlux ) THEN
        DO j=1,sNy
         DO i=1,sNx
           tmpFld(i,j) = tmpFld(i,j) 
     &      + PmEpR(i,j,bi,bj)*rhoConstFresh
     &                        *salt(i,j,k,bi,bj)
         ENDDO
        ENDDO
       ENDIF
#endif /* NONLIN_FRSURF */
       CALL TIMEAVE_CUMUL_1T( sFluxtave, tmpFld, 1,
     &                                   deltaTclock, bi, bj, myThid)

#endif /* ALLOW_TIMEAVE */ 

      RETURN
      END
