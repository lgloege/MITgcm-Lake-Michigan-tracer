C $Header: /u/gcmpack/MITgcm/pkg/ptracers/ptracers_integrate.F,v 1.30 2006/03/07 15:28:39 jmc Exp $
C $Name:  $

#include "PTRACERS_OPTIONS.h"

CBOP
C !ROUTINE: PTRACERS_INTEGRATE

C !INTERFACE: ==========================================================
      SUBROUTINE PTRACERS_INTEGRATE(
     I                               bi,bj,k,
     I                               xA,yA,uTrans,vTrans,rTrans,
     I                               rTransKp1,maskUp,
     X                               rFlx,KappaRtr,
     I                               myIter,myTime,myThid )

C !DESCRIPTION:
C     Calculates tendency for passive tracers and integrates forward
C     in time.

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "GAD.h"

C !INPUT PARAMETERS: ===================================================
C  bi,bj                :: tile indices
C  k                    :: vertical level number
C  xA                   :: face area at U points in level k
C  yA                   :: face area at V points in level k
C  uTrans               :: zonal transport in level k
C  vTrans               :: meridional transport in level k
C  rTrans               :: vertical volume transport at interface k
C  rTransKp1            :: vertical volume transport at interface k+1
C  maskUp               :: mask for vertical transport
C  rFlx			:: vertical flux
C  KappaRtr		:: vertical diffusion of passive tracers, interf k
C  myIter               :: time-step number
C  myTime               :: model time
C  myThid               :: thread number
      INTEGER bi,bj,k
      _RS xA      (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RS yA      (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL uTrans  (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vTrans  (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL rTrans  (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL rTransKp1(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RS maskUp  (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL rFlx(1-OLx:sNx+OLx,1-OLy:sNy+OLy,2,PTRACERS_num)
      _RL KappaRtr(1-Olx:sNx+Olx,1-Oly:sNy+Oly,PTRACERS_num)
      INTEGER myIter
      _RL myTime
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
C  none

#ifdef ALLOW_PTRACERS

C !LOCAL VARIABLES: ====================================================
C  iTracer              :: tracer index
C  iMin,iMax,jMin,jMax  :: loop ranges
C  kUp,kDown            :: toggle indices for even/odd level fluxes
C  km1                  :: =min(1,k-1)
C  GAD_TR               :: passive tracer id (GAD_TR1+iTracer-1)
      INTEGER iTracer
      INTEGER iMin,iMax,jMin,jMax
      INTEGER kUp,kDown,km1
      INTEGER GAD_TR
      LOGICAL calcAdvection
      INTEGER iterNb
CEOP

C Loop over tracers
      DO iTracer=1,PTRACERS_numInUse

C Loop ranges for daughter routines
       iMin = 1-OLx+2
       iMax = sNx+OLx-1
       jMin = 1-OLy+2
       jMax = sNy+OLy-1

       km1  = MAX(1,k-1)
       kUp  = 1+MOD(k+1,2)
       kDown= 1+MOD(k,2)

C Calculate active tracer tendencies (gPtr) due to internal processes
C (advection, [explicit] diffusion, parameterizations,...)
       calcAdvection = .NOT.multiDimAdvection
     &      .OR. PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_2ND
     &      .OR. PTRACERS_advScheme(iTracer).EQ.ENUM_UPWIND_3RD
     &      .OR. PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_4TH
       GAD_TR = GAD_TR1 + iTracer - 1
       CALL GAD_CALC_RHS(
     I                   bi,bj,iMin,iMax,jMin,jMax,k,kM1,kUp,kDown,
     I                   xA,yA,uTrans,vTrans,rTrans,rTransKp1,maskUp,
     I                   uVel, vVel, wVel,
     I                   PTRACERS_diffKh(iTracer),
     I                   PTRACERS_diffK4(iTracer),
     I                   KappaRtr(1-Olx,1-Oly,iTracer),
     I                   gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),
     I                   pTracer(1-Olx,1-Oly,1,1,1,iTracer),
     I                   GAD_TR,
     I                   PTRACERS_advScheme(iTracer),
     I                   PTRACERS_advScheme(iTracer),
     I                   calcAdvection, PTRACERS_ImplVertAdv(iTracer),
     I                   .FALSE.,
     U                   rFlx(1-Olx,1-Oly,1,iTracer),
     U                   gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     I                   myTime, myIter, myThid )

C External forcing term(s)
       IF ( tracForcingOutAB.NE.1 )
     &   CALL PTRACERS_FORCING(
     I                      bi,bj,iMin,iMax,jMin,jMax,k,iTracer,
     U                      gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     I                      surfaceForcingPtr(1-Olx,1-Oly,1,1,iTracer),
     I                      myIter,myTime,myThid)

C If using Adams-Bashforth II, then extrapolate tendencies
C gPtr is now the tracer tendency for explicit advection/diffusion
      IF ( PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_2ND
     & .OR.PTRACERS_advScheme(iTracer).EQ.ENUM_UPWIND_3RD
     & .OR.PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_4TH ) THEN
#ifdef ALLOW_MATRIX
C  If matrix is being computed, block call to S/R ADAMS_BASHFORTH2 to 
C  prevent gPtr from being replaced by the average of gPtr and gPtrNm1.    
        IF (.NOT.useMATRIX) THEN
#endif          
        iterNb = myIter
        IF (staggerTimeStep) iterNb = myIter - 1
        CALL ADAMS_BASHFORTH2(
     I                        bi,bj,K,
     U                        gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     U                        gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),
     I                        iterNb, myThid )
#ifdef ALLOW_MATRIX
        ENDIF
#endif     
      ENDIF

C External forcing term(s)
       IF ( tracForcingOutAB.EQ.1 )
     &   CALL PTRACERS_FORCING(
     I                      bi,bj,iMin,iMax,jMin,jMax,k,iTracer,
     U                      gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     I                      surfaceForcingPtr(1-Olx,1-Oly,1,1,iTracer),
     I                      myIter,myTime,myThid)

#ifdef NONLIN_FRSURF
C Account for change in level thickness
      IF (nonlinFreeSurf.GT.0) THEN
        CALL FREESURF_RESCALE_G(
     I                          bi,bj,K,
     U                          gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     I                          myThid )
        IF ( PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_2ND
     &   .OR.PTRACERS_advScheme(iTracer).EQ.ENUM_UPWIND_3RD
     &   .OR.PTRACERS_advScheme(iTracer).EQ.ENUM_CENTERED_4TH )
     &  CALL FREESURF_RESCALE_G(
     I                          bi,bj,K,
     U                          gPtrNm1(1-Olx,1-Oly,1,1,1,iTracer),
     I                          myThid )
      ENDIF
#endif /* NONLIN_FRSURF */

C Integrate forward in time, storing in gPtr:  G=T+dt*G
         CALL TIMESTEP_TRACER(
     I                        bi,bj,iMin,iMax,jMin,jMax,k,
     I                        PTRACERS_advScheme(iTracer),
     I                        pTracer(1-Olx,1-Oly,1,1,1,iTracer),
     I                        gPtr(1-Olx,1-Oly,1,1,1,iTracer),
     I                        myIter,myThid )

#ifdef   ALLOW_OBCS
C Apply open boundary conditions
         IF (useOBCS) THEN
          CALL OBCS_APPLY_PTRACER( 
     I         bi, bj, k, iTracer, 
     U         gPtr(1-Olx,1-Oly,k,bi,bj,iTracer),
     I         myThid )
         END IF
#endif   /* ALLOW_OBCS */
C end of tracer loop
      ENDDO

#endif /* ALLOW_PTRACERS */

      RETURN
      END
