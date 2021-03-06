C $Header: /u/gcmpack/MITgcm/model/src/cg2d.F,v 1.44 2005/11/04 01:19:25 jmc Exp $
C $Name:  $

#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: CG2D
C     !INTERFACE:
      SUBROUTINE CG2D(  
     I                cg2d_b,
     U                cg2d_x,
     O                firstResidual,
     O                lastResidual,
     U                numIters,
     I                myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE CG2D                                           
C     | o Two-dimensional grid problem conjugate-gradient         
C     |   inverter (with preconditioner).                         
C     *==========================================================*
C     | Con. grad is an iterative procedure for solving Ax = b.   
C     | It requires the A be symmetric.                           
C     | This implementation assumes A is a five-diagonal          
C     | matrix of the form that arises in the discrete            
C     | representation of the del^2 operator in a                 
C     | two-dimensional space.                                    
C     | Notes:                                                    
C     | ======                                                    
C     | This implementation can support shared-memory              
C     | multi-threaded execution. In order to do this COMMON       
C     | blocks are used for many of the arrays - even ones that    
C     | are only used for intermedaite results. This design is     
C     | OK if you want to all the threads to collaborate on        
C     | solving the same problem. On the other hand if you want    
C     | the threads to solve several different problems            
C     | concurrently this implementation will not work.           
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global data ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "CG2D.h"
#include "SURFACE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid    - Thread on which I am working.
C     cg2d_b    - The source term or "right hand side"
C     cg2d_x    - The solution
C     firstResidual - the initial residual before any iterations
C     lastResidual  - the actual residual reached
C     numIters  - Entry: the maximum number of iterations allowed
C                 Exit:  the actual number of iterations used
      _RL  cg2d_b(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  cg2d_x(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  firstResidual
      _RL  lastResidual
      INTEGER numIters
      INTEGER myThid

C     !LOCAL VARIABLES:
C     === Local variables ====
C     actualIts      - Number of iterations taken
C     actualResidual - residual
C     bi          - Block index in X and Y.
C     bj
C     eta_qrN     - Used in computing search directions
C     eta_qrNM1     suffix N and NM1 denote current and
C     cgBeta        previous iterations respectively.
C     alpha  
C     sumRHS      - Sum of right-hand-side. Sometimes this is a
C                   useful debuggin/trouble shooting diagnostic.
C                   For neumann problems sumRHS needs to be ~0.
C                   or they converge at a non-zero residual.
C     err         - Measure of residual of Ax - b, usually the norm.
C     I, J, N     - Loop counters ( N counts CG iterations )
      INTEGER actualIts
      _RL    actualResidual
      INTEGER bi, bj              
      INTEGER I, J, it2d
      _RL    err,errTile
      _RL    eta_qrN,eta_qrNtile
      _RL    eta_qrNM1
      _RL    cgBeta
      _RL    alpha,alphaTile
      _RL    sumRHS,sumRHStile
      _RL    rhsMax
      _RL    rhsNorm
CEOP


CcnhDebugStarts
C     CHARACTER*(MAX_LEN_FNAM) suff
CcnhDebugEnds


C--   Initialise inverter
      eta_qrNM1 = 1. _d 0

CcnhDebugStarts
C     _EXCH_XY_R8( cg2d_b, myThid )
C     CALL PLOT_FIELD_XYRL( cg2d_b, 'CG2D.0 CG2D_B' , 1, myThid )
C     suff = 'unnormalised'
C     CALL WRITE_FLD_XY_RL (  'cg2d_b.',suff,    cg2d_b, 1, myThid)
C     STOP
CcnhDebugEnds

C--   Normalise RHS
      rhsMax = 0. _d 0
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          cg2d_b(I,J,bi,bj) = cg2d_b(I,J,bi,bj)*cg2dNorm
          rhsMax = MAX(ABS(cg2d_b(I,J,bi,bj)),rhsMax)
         ENDDO
        ENDDO
       ENDDO
      ENDDO

      IF (cg2dNormaliseRHS) THEN
C-  Normalise RHS :
#ifdef LETS_MAKE_JAM
C     _GLOBAL_MAX_R8( rhsMax, myThid )
      rhsMax=1.
#else
      _GLOBAL_MAX_R8( rhsMax, myThid )
Catm  rhsMax=1.
#endif
      rhsNorm = 1. _d 0
      IF ( rhsMax .NE. 0. ) rhsNorm = 1. _d 0 / rhsMax
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        DO J=1,sNy
         DO I=1,sNx
          cg2d_b(I,J,bi,bj) = cg2d_b(I,J,bi,bj)*rhsNorm
          cg2d_x(I,J,bi,bj) = cg2d_x(I,J,bi,bj)*rhsNorm
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C- end Normalise RHS
      ENDIF

C--   Update overlaps
      _EXCH_XY_R8( cg2d_b, myThid )
      _EXCH_XY_R8( cg2d_x, myThid )
CcnhDebugStarts
C     CALL PLOT_FIELD_XYRL( cg2d_b, 'CG2D.1 CG2D_B' , 1, myThid )
C     suff = 'normalised'
C     CALL WRITE_FLD_XY_RL (  'cg2d_b.',suff,    cg2d_b, 1, myThid)
CcnhDebugEnds

C--   Initial residual calculation
      err    = 0. _d 0
      sumRHS = 0. _d 0
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)
        sumRHStile = 0. _d 0
        errTile    = 0. _d 0
        DO J=1,sNy
         DO I=1,sNx
          cg2d_s(I,J,bi,bj) = 0.
          cg2d_r(I,J,bi,bj) = cg2d_b(I,J,bi,bj) -
     &    (aW2d(I  ,J  ,bi,bj)*cg2d_x(I-1,J  ,bi,bj)
     &    +aW2d(I+1,J  ,bi,bj)*cg2d_x(I+1,J  ,bi,bj)
     &    +aS2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J-1,bi,bj)
     &    +aS2d(I  ,J+1,bi,bj)*cg2d_x(I  ,J+1,bi,bj)
     &    -aW2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
     &    -aW2d(I+1,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
     &    -aS2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
     &    -aS2d(I  ,J+1,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
     &    -freeSurfFac*_rA(i,j,bi,bj)*recip_Bo(i,j,bi,bj)* 
     &     cg2d_x(I  ,J  ,bi,bj)/deltaTMom/deltaTfreesurf*cg2dNorm
     &    )
          errTile        = errTile        + 
     &     cg2d_r(I,J,bi,bj)*cg2d_r(I,J,bi,bj)
          sumRHStile        = sumRHStile        +
     &     cg2d_b(I,J,bi,bj)
         ENDDO
        ENDDO
        sumRHS = sumRHS + sumRHStile
        err    = err    + errTile
       ENDDO
      ENDDO
C     _EXCH_XY_R8( cg2d_r, myThid )
#ifdef LETS_MAKE_JAM
      CALL EXCH_XY_O1_R8_JAM( cg2d_r )
#else
      CALL EXCH_XY_RL( cg2d_r, myThid )
#endif
C     _EXCH_XY_R8( cg2d_s, myThid )
#ifdef LETS_MAKE_JAM
      CALL EXCH_XY_O1_R8_JAM( cg2d_s )
#else
      CALL EXCH_XY_RL( cg2d_s, myThid )
#endif
       _GLOBAL_SUM_R8( sumRHS, myThid )
       _GLOBAL_SUM_R8( err   , myThid )
       err = SQRT(err)
       actualIts      = 0
       actualResidual = err

       IF ( debugLevel .GE. debLevZero ) THEN
        _BEGIN_MASTER( myThid )
        write(standardmessageunit,'(A,1P2E22.14)')
     &  ' cg2d: Sum(rhs),rhsMax = ',
     &                                  sumRHS,rhsMax 
        _END_MASTER( myThid )
       ENDIF
C     _BARRIER
c     _BEGIN_MASTER( myThid )
c      WRITE(standardmessageunit,'(A,I6,1PE30.14)') 
c    & ' CG2D iters, err = ', 
c    & actualIts, actualResidual
c     _END_MASTER( myThid )
      firstResidual=actualResidual

      IF ( err .LT. cg2dTolerance ) GOTO 11

C     >>>>>>>>>>>>>>> BEGIN SOLVER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
      DO 10 it2d=1, numIters

CcnhDebugStarts
C      WRITE(*,*) ' CG2D: Iteration ',it2d-1,' residual = ',
C    &  actualResidual
CcnhDebugEnds
C--    Solve preconditioning equation and update
C--    conjugate direction vector "s".
       eta_qrN = 0. _d 0
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         eta_qrNtile = 0. _d 0
         DO J=1,sNy
          DO I=1,sNx
           cg2d_q(I,J,bi,bj) = 
     &      pC(I  ,J  ,bi,bj)*cg2d_r(I  ,J  ,bi,bj)
     &     +pW(I  ,J  ,bi,bj)*cg2d_r(I-1,J  ,bi,bj)
     &     +pW(I+1,J  ,bi,bj)*cg2d_r(I+1,J  ,bi,bj)
     &     +pS(I  ,J  ,bi,bj)*cg2d_r(I  ,J-1,bi,bj)
     &     +pS(I  ,J+1,bi,bj)*cg2d_r(I  ,J+1,bi,bj)
CcnhDebugStarts
C          cg2d_q(I,J,bi,bj) = cg2d_r(I  ,J  ,bi,bj)
CcnhDebugEnds
           eta_qrNtile = eta_qrNtile
     &     +cg2d_q(I,J,bi,bj)*cg2d_r(I,J,bi,bj)
          ENDDO
         ENDDO
         eta_qrN = eta_qrN + eta_qrNtile
        ENDDO
       ENDDO

       _GLOBAL_SUM_R8(eta_qrN, myThid)
CcnhDebugStarts
C      WRITE(*,*) ' CG2D: Iteration ',it2d-1,' eta_qrN = ',eta_qrN
CcnhDebugEnds
       cgBeta   = eta_qrN/eta_qrNM1
CcnhDebugStarts
C      WRITE(*,*) ' CG2D: Iteration ',it2d-1,' beta = ',cgBeta
CcnhDebugEnds
       eta_qrNM1 = eta_qrN

       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         DO J=1,sNy
          DO I=1,sNx
           cg2d_s(I,J,bi,bj) = cg2d_q(I,J,bi,bj)
     &                       + cgBeta*cg2d_s(I,J,bi,bj)
          ENDDO
         ENDDO
        ENDDO
       ENDDO

C--    Do exchanges that require messages i.e. between
C--    processes.
C      _EXCH_XY_R8( cg2d_s, myThid )
#ifdef LETS_MAKE_JAM
      CALL EXCH_XY_O1_R8_JAM( cg2d_s )
#else
      CALL EXCH_XY_RL( cg2d_s, myThid )
#endif

C==    Evaluate laplace operator on conjugate gradient vector
C==    q = A.s
       alpha = 0. _d 0
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         alphaTile = 0. _d 0
         DO J=1,sNy
          DO I=1,sNx
           cg2d_q(I,J,bi,bj) = 
     &     aW2d(I  ,J  ,bi,bj)*cg2d_s(I-1,J  ,bi,bj)
     &    +aW2d(I+1,J  ,bi,bj)*cg2d_s(I+1,J  ,bi,bj)
     &    +aS2d(I  ,J  ,bi,bj)*cg2d_s(I  ,J-1,bi,bj)
     &    +aS2d(I  ,J+1,bi,bj)*cg2d_s(I  ,J+1,bi,bj)
     &    -aW2d(I  ,J  ,bi,bj)*cg2d_s(I  ,J  ,bi,bj)
     &    -aW2d(I+1,J  ,bi,bj)*cg2d_s(I  ,J  ,bi,bj)
     &    -aS2d(I  ,J  ,bi,bj)*cg2d_s(I  ,J  ,bi,bj)
     &    -aS2d(I  ,J+1,bi,bj)*cg2d_s(I  ,J  ,bi,bj)
     &    -freeSurfFac*_rA(i,j,bi,bj)*recip_Bo(i,j,bi,bj)* 
     &     cg2d_s(I  ,J  ,bi,bj)/deltaTMom/deltaTfreesurf*cg2dNorm
          alphaTile = alphaTile+cg2d_s(I,J,bi,bj)*cg2d_q(I,J,bi,bj)
          ENDDO
         ENDDO
         alpha = alpha + alphaTile
        ENDDO
       ENDDO
       _GLOBAL_SUM_R8(alpha,myThid)
CcnhDebugStarts
C      WRITE(*,*) ' CG2D: Iteration ',it2d-1,' SUM(s*q)= ',alpha
CcnhDebugEnds
       alpha = eta_qrN/alpha
CcnhDebugStarts
C      WRITE(*,*) ' CG2D: Iteration ',it2d-1,' alpha= ',alpha
CcnhDebugEnds
     
C==    Update solution and residual vectors
C      Now compute "interior" points.
       err = 0. _d 0
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         errTile = 0. _d 0
         DO J=1,sNy
          DO I=1,sNx
           cg2d_x(I,J,bi,bj)=cg2d_x(I,J,bi,bj)+alpha*cg2d_s(I,J,bi,bj)
           cg2d_r(I,J,bi,bj)=cg2d_r(I,J,bi,bj)-alpha*cg2d_q(I,J,bi,bj)
           errTile = errTile+cg2d_r(I,J,bi,bj)*cg2d_r(I,J,bi,bj)
          ENDDO
         ENDDO
         err = err + errTile
        ENDDO
       ENDDO

       _GLOBAL_SUM_R8( err   , myThid )
       err = SQRT(err)
       actualIts      = it2d
       actualResidual = err
       IF ( err .LT. cg2dTolerance ) GOTO 11
C      _EXCH_XY_R8(cg2d_r, myThid )
#ifdef LETS_MAKE_JAM
      CALL EXCH_XY_O1_R8_JAM( cg2d_r )
#else
      CALL EXCH_XY_RL( cg2d_r, myThid )
#endif

   10 CONTINUE
   11 CONTINUE

      IF (cg2dNormaliseRHS) THEN
C--   Un-normalise the answer
        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
          DO J=1,sNy
           DO I=1,sNx
            cg2d_x(I  ,J  ,bi,bj) = cg2d_x(I  ,J  ,bi,bj)/rhsNorm
           ENDDO
          ENDDO
         ENDDO
        ENDDO
      ENDIF

C     The following exchange was moved up to solve_for_pressure
C     for compatibility with TAMC.
C     _EXCH_XY_R8(cg2d_x, myThid )
c     _BEGIN_MASTER( myThid )
c      WRITE(*,'(A,I6,1PE30.14)') ' CG2D iters, err = ', 
c    & actualIts, actualResidual
c     _END_MASTER( myThid )

C--   Return parameters to caller
      lastResidual=actualResidual
      numIters=actualIts

CcnhDebugStarts
C     CALL PLOT_FIELD_XYRL( cg2d_x, 'CALC_MOM_RHS CG2D_X' , 1, myThid )
C     err    = 0. _d 0
C     DO bj=myByLo(myThid),myByHi(myThid)
C      DO bi=myBxLo(myThid),myBxHi(myThid)
C       DO J=1,sNy
C        DO I=1,sNx
C         cg2d_r(I,J,bi,bj) = cg2d_b(I,J,bi,bj) -
C    &    (aW2d(I  ,J  ,bi,bj)*cg2d_x(I-1,J  ,bi,bj)
C    &    +aW2d(I+1,J  ,bi,bj)*cg2d_x(I+1,J  ,bi,bj)
C    &    +aS2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J-1,bi,bj)
C    &    +aS2d(I  ,J+1,bi,bj)*cg2d_x(I  ,J+1,bi,bj)
C    &    -aW2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
C    &    -aW2d(I+1,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
C    &    -aS2d(I  ,J  ,bi,bj)*cg2d_x(I  ,J  ,bi,bj)
C    &    -aS2d(I  ,J+1,bi,bj)*cg2d_x(I  ,J  ,bi,bj))
C         err            = err            + 
C    &     cg2d_r(I,J,bi,bj)*cg2d_r(I,J,bi,bj)
C        ENDDO
C       ENDDO
C      ENDDO
C     ENDDO
C     _GLOBAL_SUM_R8( err   , myThid )
C     write(*,*) 'cg2d: Ax - b = ',SQRT(err)
CcnhDebugEnds

      RETURN
      END
