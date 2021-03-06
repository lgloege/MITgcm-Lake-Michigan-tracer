C $Header: /u/gcmpack/MITgcm/pkg/seaice/groatb.F,v 1.12 2004/12/27 20:34:11 dimitri Exp $
C $Name:  $

#include "SEAICE_OPTIONS.h"

CStartOfInterface
      SUBROUTINE groatb( A22, myThid )
C     /==========================================================\
C     | SUBROUTINE groatb                                        |
C     | o Calculate ice growth                                   |
C     |==========================================================|
C     \==========================================================/
      IMPLICIT NONE
 
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "FFIELDS.h"
#include "SEAICE.h"
#include "SEAICE_FFIELDS.h"

#ifdef ALLOW_AUTODIFF_TAMC
# include "tamc.h"
#endif

       COMMON /SEAICE_BOUND_RL/
     &    MAX_HEFF, MIN_ATEMP, MIN_LWDOWN, MAX_TICE, MIN_TICE,
     &    SEAICE_EPS, SEAICE_EPS_SQ
      _RL SEAICE_EPS, SEAICE_EPS_SQ
      _RL MAX_HEFF, MIN_ATEMP, MIN_LWDOWN, MAX_TICE, MIN_TICE

C     === Routine arguments ===
C     myThid - Thread no. that called this routine.
      _RL A22
      INTEGER myThid
CEndOfInterface

C     === Local variables ===
C     i,j,bi,bj - Loop counters

      INTEGER i, j, bi, bj
      INTEGER KOPEN
      _RL SPEED_SQ
      _RL HICE (1-OLx:sNx+OLx, 1-OLy:sNy+OLy)
      _RL UG   (1-OLx:sNx+OLx, 1-OLy:sNy+OLy)

#ifdef SEAICE_MULTILEVEL
      INTEGER it
      INTEGER ilockey
      _RL RK
      _RL HICEP(1-OLx:sNx+OLx, 1-OLy:sNy+OLy)
      _RL FICEP(1-OLx:sNx+OLx, 1-OLy:sNy+OLy)
#endif

CADJ loop = parallel
      DO bj=myByLo(myThid),myByHi(myThid)
CADJ loop = parallel
       DO bi=myBxLo(myThid),myBxHi(myThid)
cph(
#ifdef ALLOW_AUTODIFF_TAMC
          act1 = bi - myBxLo(myThid)
          max1 = myBxHi(myThid) - myBxLo(myThid) + 1
          act2 = bj - myByLo(myThid)
          max2 = myByHi(myThid) - myByLo(myThid) + 1
          act3 = myThid - 1
          max3 = nTx*nTy
          act4 = ikey_dynamics - 1
          iicekey = (act1 + 1) + act2*max1
     &                      + act3*max1*max2
     &                      + act4*max1*max2*max3
#endif /* ALLOW_AUTODIFF_TAMC */
c
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE area(:,:,:,bi,bj) = comlev1_bibj, 
CADJ &                         key = iicekey, byte = isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
cph)

C DETERMINE AMOUNT OF OPEN WATER AND ICE THICKNESS
        DO J=1,sNy
         DO I=1,sNx
          AREA(I,J,2,bi,bj)=MAX(A22,AREA(I,J,2,bi,bj))
          FHEFF(I,J,bi,bj)=0.0 _d 0
#ifdef SEAICE_MULTILEVEL
          FICEP(I,J)=0.0 _d 0
#endif
         ENDDO
        ENDDO
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE area(:,:,:,bi,bj) = comlev1_bibj, 
CADJ &                         key = iicekey, byte = isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
        DO J=1,sNy
         DO I=1,sNx
          HICE(I,J)=HEFF(I,J,2,bi,bj)/AREA(I,J,2,bi,bj)
         ENDDO
        ENDDO

C NOW DETERMINE MIXED LAYER TEMPERATURE
        DO J=1,sNy
         DO I=1,sNx
          TMIX(I,J,bi,bj)=theta(I,J,1,bi,bj)+273.16 _d +00
#ifdef SEAICE_DEBUG
          TMIX(I,J,bi,bj)=MAX(TMIX(I,J,bi,bj),271.2 _d +00)
#endif
         ENDDO
        ENDDO

        DO J=1,sNy
         DO I=1,sNx
          SPEED_SQ = UWIND(I,J,bi,bj)**2 + VWIND(I,J,bi,bj)**2
          IF ( SPEED_SQ .LE. SEAICE_EPS_SQ ) THEN
             UG(I,J)=SEAICE_EPS
          ELSE
             UG(I,J)=SQRT(SPEED_SQ)
          ENDIF
         ENDDO
        ENDDO

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE atemp(:,:,bi,bj)  = comlev1_bibj, 
CADJ &                           key = iicekey, byte = isbyte
CADJ STORE lwdown(:,:,bi,bj) = comlev1_bibj, 
CADJ &                           key = iicekey, byte = isbyte
#endif /* ALLOW_AUTODIFF_TAMC */

C NOW DETERMINE GROWTH RATES
C FIRST DO OPEN WATER
        KOPEN=-1
        CALL BUDGET(UG, TMIX, HICE, FO, KOPEN, bi, bj)

C NOW DO ICE
        KOPEN=1
#ifdef SEAICE_MULTILEVEL
C--  Start loop over muli-levels
        DO IT=1,MULTDIM
#ifdef ALLOW_AUTODIFF_TAMC
         ilockey = (iicekey-1)*MULTDIM + IT
CADJ STORE atemp(:,:,bi,bj)    = comlev1_multdim, 
CADJ &                           key = ilockey, byte = isbyte
CADJ STORE lwdown(:,:,bi,bj)   = comlev1_multdim, 
CADJ &                           key = ilockey, byte = isbyte
CADJ STORE tices(:,:,it,bi,bj) = comlev1_multdim, 
CADJ &                           key = ilockey, byte = isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
         DO J=1,sNy
          DO I=1,sNx
           RK=IT*1.0
           HICEP(I,J)=(HICE(I,J)/7.0 _d 0)*((2.0 _d 0*RK)-1.0 _d 0)
           TICE(I,J,bi,bj)=TICES(I,J,IT,bi,bj)
          ENDDO
         ENDDO
         CALL BUDGET(UG, TICE, HICEP, FICE, KOPEN, bi, bj)
         DO J=1,sNy
          DO I=1,sNx
           FICEP(I,J)=(FICE(I,J,bi,bj)/7.0 _d 0)+FICEP(I,J)
           TICES(I,J,IT,bi,bj)=TICE(I,J,bi,bj)
          ENDDO
         ENDDO
        ENDDO
C--  End loop over muli-levels
        DO J=1,sNy
         DO I=1,sNx
          FICE(I,J,bi,bj)=FICEP(I,J)
         ENDDO
        ENDDO
#else  /* SEAICE_MULTILEVEL */
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE atemp(:,:,bi,bj)   = comlev1_bibj, 
CADJ &                           key = iicekey, byte = isbyte
CADJ STORE lwdown(:,:,bi,bj)  = comlev1_bibj, 
CADJ &                           key = iicekey, byte = isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
        CALL BUDGET(UG, TICE, HICE, FICE, KOPEN, bi, bj)
#endif /* SEAICE_MULTILEVEL */

       ENDDO
      ENDDO

      RETURN
      END
