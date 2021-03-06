C $Header: /u/gcmpack/MITgcm/model/src/the_correction_step.F,v 1.29 2005/04/15 14:06:14 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: THE_CORRECTION_STEP
C     !INTERFACE:
      SUBROUTINE THE_CORRECTION_STEP(myTime, myIter, myThid)
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE THE_CORRECTION_STEP                            
C     *==========================================================*
C     |1rst Part : Update U,V,T,S.
C     |
C     | The arrays used for time stepping are cycled.
C     | Tracers:
C     |           T(n) = Gt(n)
C     | Momentum:
C     |           V(n) = Gv(n) - dt * grad Eta
C     |
C     |part1: update U,V,T,S                                      
C     |  U*,V* (contained in gU,gV) have the surface        
C     |     pressure gradient term added and the result stored    
C     |     in U,V (contained in uVel, vVel)                      
C     |  T* (contained in gT) is copied to T (theta)           
C     |  S* (contained in gS) is copied to S (salt)            
C     |                                                           
C     |part2: Adjustments & Diagnostics                                        
C     |   o Convective Adjustment                                 
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myTime - Current time in simulation
C     myIter - Current iteration number in simulation
C     myThid - Thread number for this instance of the routine.
      _RL myTime
      INTEGER myIter
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables
      _RL phiSurfX(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL phiSurfY(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER iMin,iMax
      INTEGER jMin,jMax
      INTEGER bi,bj
      INTEGER k,i,j

CEOP

      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)

C--     Set up work arrays that need valid initial values
        DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
          phiSurfX(i,j)=0.
          phiSurfY(i,j)=0.
         ENDDO
        ENDDO

C       Loop range: Gradients of Eta are evaluated so valid
C       range is all but first row and column in overlaps.
        iMin = 1-OLx+1
        iMax = sNx+OLx
        jMin = 1-OLy+1
        jMax = sNy+OLy

C-      Calculate gradient of surface Potentiel
        CALL CALC_GRAD_PHI_SURF(
     I       bi,bj,iMin,iMax,jMin,jMax,
     I       etaN,
     O       phiSurfX,phiSurfY,
     I       myThid )

C--     Loop over all layers, top to bottom
        DO K=1,Nr

C-        Update velocity fields:  V(n) = V** - dt * grad Eta
          IF (momStepping)
     &      CALL CORRECTION_STEP(
     I         bi,bj,iMin,iMax,jMin,jMax,K,
     I         phiSurfX,phiSurfY,myTime,myThid )

C-        Update tracer fields:  T(n) = T**
          IF (tempStepping)
     &      CALL CYCLE_TRACER(
     I           bi,bj,K,
     U           theta,gT,
     I           myTime,myIter,myThid )
          IF (saltStepping)
     &      CALL CYCLE_TRACER(
     I           bi,bj,K,
     U           salt,gS,
     I           myTime,myIter,myThid )

#ifdef    ALLOW_OBCS
          IF (useOBCS) THEN
            CALL OBCS_APPLY_UV(bi,bj,K,uVel,vVel,myThid)
          ENDIF
#endif    /* ALLOW_OBCS */

C--     End DO K=1,Nr
        ENDDO

C--- 2nd Part : Adjustment.
C
C       Static stability is calculated and the tracers are
C       convective adjusted where statically unstable.

C--     Convectively adjust new fields to be statically stable
        iMin = 1
        iMax = sNx
        jMin = 1
        jMax = sNy
         CALL CONVECTIVE_ADJUSTMENT(
     I        bi, bj, iMin, iMax, jMin, jMax,
     I        myTime, myIter, myThid )

C--    End of 1rst bi,bj loop
       ENDDO
      ENDDO

      RETURN
      END
