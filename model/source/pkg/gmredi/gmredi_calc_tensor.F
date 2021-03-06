C $Header: /u/gcmpack/MITgcm/pkg/gmredi/gmredi_calc_tensor.F,v 1.22 2005/12/08 03:29:32 jmc Exp $
C $Name:  $

#include "GMREDI_OPTIONS.h"

CStartOfInterface
      SUBROUTINE GMREDI_CALC_TENSOR(
     I             bi, bj, iMin, iMax, jMin, jMax,
     I             sigmaX, sigmaY, sigmaR,
     I             myThid )
C     /==========================================================\
C     | SUBROUTINE GMREDI_CALC_TENSOR                            |
C     | o Calculate tensor elements for GM/Redi tensor.          |
C     |==========================================================|
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GMREDI.h"
#include "GMREDI_TAVE.h"

#ifdef ALLOW_AUTODIFF_TAMC
#include "tamc.h"
#include "tamc_keys.h"
#endif /* ALLOW_AUTODIFF_TAMC */

C     == Routine arguments ==
C
      _RL sigmaX(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      _RL sigmaY(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      _RL sigmaR(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      INTEGER bi,bj,iMin,iMax,jMin,jMax
      INTEGER myThid
CEndOfInterface

#ifdef ALLOW_GMREDI

C     == Local variables ==
      INTEGER i,j,k,kp1
      _RL SlopeX(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL SlopeY(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL dSigmaDx(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL dSigmaDy(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL dSigmaDr(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL SlopeSqr(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL taperFct(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL maskp1, Kgm_tmp
      _RL ldd97_LrhoC(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL ldd97_LrhoW(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL ldd97_LrhoS(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL Cspd, LrhoInf, LrhoSup, fCoriLoc

#ifdef GM_VISBECK_VARIABLE_K
      _RL deltaH,zero_rs
      PARAMETER(zero_rs=0.D0)
      _RL N2,SN
      _RL Ssq(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
#endif

#ifdef ALLOW_DIAGNOSTICS
      LOGICAL  doDiagRediFlx
      LOGICAL  DIAGNOSTICS_IS_ON
      EXTERNAL DIAGNOSTICS_IS_ON
      INTEGER  km1
      _RL dTdz
      _RL tmp1k(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
#endif

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

#ifdef ALLOW_AUTODIFF_TAMC
          act1 = bi - myBxLo(myThid)
          max1 = myBxHi(myThid) - myBxLo(myThid) + 1
          act2 = bj - myByLo(myThid)
          max2 = myByHi(myThid) - myByLo(myThid) + 1
          act3 = myThid - 1
          max3 = nTx*nTy
          act4 = ikey_dynamics - 1
          igmkey = (act1 + 1) + act2*max1
     &                      + act3*max1*max2
     &                      + act4*max1*max2*max3
#endif /* ALLOW_AUTODIFF_TAMC */

#ifdef ALLOW_DIAGNOSTICS
      doDiagRediFlx = .FALSE.
      IF ( useDiagnostics ) THEN
        doDiagRediFlx = DIAGNOSTICS_IS_ON('GM_KuzTz', myThid )
        doDiagRediFlx = doDiagRediFlx .OR. 
     &                  DIAGNOSTICS_IS_ON('GM_KvzTz', myThid )
      ENDIF
#endif
     
#ifdef GM_VISBECK_VARIABLE_K
      DO j=1-Oly,sNy+Oly
       DO i=1-Olx,sNx+Olx
        VisbeckK(i,j,bi,bj) = 0. _d 0
       ENDDO
      ENDDO
#endif

C--   set ldd97_Lrho (for tapering scheme ldd97):
      IF (GM_taper_scheme.EQ.'ldd97') THEN
       Cspd = 2. _d 0
       LrhoInf = 15. _d 3
       LrhoSup = 100. _d 3
C-     Tracer point location (center):
       DO j=1-Oly,sNy+Oly
        DO i=1-Olx,sNx+Olx
         IF (fCori(i,j,bi,bj).NE.0.) THEN
           ldd97_LrhoC(i,j) = Cspd/ABS(fCori(i,j,bi,bj))
         ELSE
           ldd97_LrhoC(i,j) = LrhoSup
         ENDIF
         ldd97_LrhoC(i,j) = MAX(LrhoInf,MIN(ldd97_LrhoC(i,j),LrhoSup))
        ENDDO
       ENDDO
C-     U point location (West):
       DO j=1-Oly,sNy+Oly
        ldd97_LrhoW(1-Olx,j) = LrhoSup
        DO i=1-Olx+1,sNx+Olx
         fCoriLoc = op5*(fCori(i-1,j,bi,bj)+fCori(i,j,bi,bj))
         IF (fCoriLoc.NE.0.) THEN
           ldd97_LrhoW(i,j) = Cspd/ABS(fCoriLoc)
         ELSE
           ldd97_LrhoW(i,j) = LrhoSup
         ENDIF
         ldd97_LrhoW(i,j) = MAX(LrhoInf,MIN(ldd97_LrhoW(i,j),LrhoSup))
        ENDDO
       ENDDO
C-     V point location (South):
       DO i=1-Olx+1,sNx+Olx
         ldd97_LrhoS(i,1-Oly) = LrhoSup
       ENDDO
       DO j=1-Oly+1,sNy+Oly
        DO i=1-Olx,sNx+Olx
         fCoriLoc = op5*(fCori(i,j-1,bi,bj)+fCori(i,j,bi,bj))
         IF (fCoriLoc.NE.0.) THEN
           ldd97_LrhoS(i,j) = Cspd/ABS(fCoriLoc)
         ELSE
           ldd97_LrhoS(i,j) = LrhoSup
         ENDIF
         ldd97_LrhoS(i,j) = MAX(LrhoInf,MIN(ldd97_LrhoS(i,j),LrhoSup))
        ENDDO
       ENDDO
      ELSE
C-    Just initialize to zero (not use anyway)
       DO j=1-Oly,sNy+Oly
        DO i=1-Olx,sNx+Olx
          ldd97_LrhoC(i,j) = 0. _d 0
          ldd97_LrhoW(i,j) = 0. _d 0
          ldd97_LrhoS(i,j) = 0. _d 0
        ENDDO
       ENDDO
      ENDIF
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      DO k=2,Nr
C-- 1rst loop on k : compute Tensor Coeff. at W points.

#ifdef ALLOW_AUTODIFF_TAMC
       kkey = (igmkey-1)*Nr + k
       DO j=1-Oly,sNy+Oly
        DO i=1-Olx,sNx+Olx
         SlopeX(i,j)       = 0. _d 0
         SlopeY(i,j)       = 0. _d 0
         dSigmaDx(i,j)     = 0. _d 0
         dSigmaDy(i,j)     = 0. _d 0
         dSigmaDr(i,j)     = 0. _d 0
         SlopeSqr(i,j)     = 0. _d 0
         taperFct(i,j)     = 0. _d 0
         Kwx(i,j,k,bi,bj)  = 0. _d 0
         Kwy(i,j,k,bi,bj)  = 0. _d 0
         Kwz(i,j,k,bi,bj)  = 0. _d 0
# ifdef GM_NON_UNITY_DIAGONAL
         Kux(i,j,k,bi,bj)  = 0. _d 0
         Kvy(i,j,k,bi,bj)  = 0. _d 0
# endif
# ifdef GM_EXTRA_DIAGONAL
         Kuz(i,j,k,bi,bj)  = 0. _d 0
         Kvz(i,j,k,bi,bj)  = 0. _d 0
# endif
# ifdef GM_BOLUS_ADVEC
         GM_PsiX(i,j,k,bi,bj)  = 0. _d 0
         GM_PsiY(i,j,k,bi,bj)  = 0. _d 0
# endif
        ENDDO
       ENDDO
#endif

      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1
C      Gradient of Sigma at rVel points
        dSigmaDx(i,j)=op25*( sigmaX(i+1, j ,k-1) +sigmaX(i,j,k-1)
     &                    +sigmaX(i+1, j , k ) +sigmaX(i,j, k ) )
     &                  *maskC(i,j,k,bi,bj)
        dSigmaDy(i,j)=op25*( sigmaY( i ,j+1,k-1) +sigmaY(i,j,k-1)
     &                    +sigmaY( i ,j+1, k ) +sigmaY(i,j, k ) )
     &                  *maskC(i,j,k,bi,bj)
        dSigmaDr(i,j)=sigmaR(i,j,k)
       ENDDO
      ENDDO

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE dSigmaDx(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDy(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDr(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */

C     Calculate slopes for use in tensor, taper and/or clip
      CALL GMREDI_SLOPE_LIMIT(
     O             SlopeX, SlopeY,
     O             SlopeSqr, taperFct,
     U             dSigmaDr,
     I             dSigmaDx, dSigmaDy,
     I             ldd97_LrhoC,rF(k),k,
     I             bi, bj, myThid )

      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1

C       Mask Iso-neutral slopes
        SlopeX(i,j)=SlopeX(i,j)*maskC(i,j,k,bi,bj)
        SlopeY(i,j)=SlopeY(i,j)*maskC(i,j,k,bi,bj)
        SlopeSqr(i,j)=SlopeSqr(i,j)*maskC(i,j,k,bi,bj)

       ENDDO
      ENDDO

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE SlopeX(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE SlopeY(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE SlopeSqr(:,:)     = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDr(:,:)     = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE taperFct(:,:)     = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */

      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1

C       Components of Redi/GM tensor 
        Kwx(i,j,k,bi,bj)= SlopeX(i,j)*taperFct(i,j)
        Kwy(i,j,k,bi,bj)= SlopeY(i,j)*taperFct(i,j)
        Kwz(i,j,k,bi,bj)= SlopeSqr(i,j)*taperFct(i,j)

#ifdef GM_VISBECK_VARIABLE_K

C- note (jmc) : moved here since only used in VISBECK_VARIABLE_K 
C           but do not know if *taperFct (or **2 ?) is necessary 
        Ssq(i,j)=SlopeSqr(i,j)*taperFct(i,j)

C--     Depth average of M^2/N^2 * N

C       Calculate terms for mean Richardson number
C       which is used in the "variable K" parameterisaton.
C       Distance between interface above layer and the integration depth
        deltaH=abs(GM_Visbeck_depth)-abs(rF(k))
C       If positive we limit this to the layer thickness
        deltaH=min(deltaH,drF(k))
C       If negative then we are below the integration level
        deltaH=max(deltaH,zero_rs)
C       Now we convert deltaH to a non-dimensional fraction
        deltaH=deltaH/GM_Visbeck_depth

        IF (K.eq.2) VisbeckK(i,j,bi,bj)=0.
        IF ( Ssq(i,j).NE.0. .AND. dSigmaDr(i,j).NE.0. ) THEN
         N2= -Gravity*recip_RhoConst*dSigmaDr(i,j)
         SN=sqrt(Ssq(i,j)*N2)
         VisbeckK(i,j,bi,bj)=VisbeckK(i,j,bi,bj)+deltaH
     &      *GM_Visbeck_alpha*GM_Visbeck_length*GM_Visbeck_length*SN
        ENDIF

#endif /* GM_VISBECK_VARIABLE_K */

       ENDDO
      ENDDO

C-- end 1rst loop on vertical level index k
      ENDDO


#ifdef GM_VISBECK_VARIABLE_K
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE VisbeckK(:,:,bi,bj) = comlev1_bibj, key=igmkey, byte=isbyte
#endif
      IF ( GM_Visbeck_alpha.NE.0. ) THEN
C-     Limit range that KapGM can take
       DO j=1-Oly+1,sNy+Oly-1
        DO i=1-Olx+1,sNx+Olx-1
         VisbeckK(i,j,bi,bj)=
     &       MIN(VisbeckK(i,j,bi,bj),GM_Visbeck_maxval_K)
        ENDDO
       ENDDO
      ENDIF
cph( NEW
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE VisbeckK(:,:,bi,bj) = comlev1_bibj, key=igmkey, byte=isbyte
#endif
cph)
#endif /* GM_VISBECK_VARIABLE_K */


C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C-- 2nd loop on k : compute Tensor Coeff. at U,V levels.
      DO k=1,Nr
       kp1 = MIN(Nr,k+1)
       maskp1 = 1. _d 0
       IF (k.GE.Nr) maskp1 = 0. _d 0

#ifdef ALLOW_AUTODIFF_TAMC
       kkey = (igmkey-1)*Nr + k
#if (defined (GM_NON_UNITY_DIAGONAL) || \
     defined (GM_VISBECK_VARIABLE_K))
CADJ STORE Kwx(:,:,k,bi,bj) = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE Kwy(:,:,k,bi,bj) = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE Kwz(:,:,k,bi,bj) = comlev1_bibj_k, key=kkey, byte=isbyte
#endif
#endif

C-    express the Tensor in term of Diffusivity (= m**2 / s )
      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1
        Kgm_tmp = GM_isopycK + GM_skewflx*GM_background_K
#ifdef GM_VISBECK_VARIABLE_K
     &          + VisbeckK(i,j,bi,bj)*(1. _d 0 + GM_skewflx)     
#endif
        Kwx(i,j,k,bi,bj)= Kgm_tmp*Kwx(i,j,k,bi,bj)
        Kwy(i,j,k,bi,bj)= Kgm_tmp*Kwy(i,j,k,bi,bj)
        Kwz(i,j,k,bi,bj)= ( GM_isopycK
#ifdef GM_VISBECK_VARIABLE_K
     &                    + VisbeckK(i,j,bi,bj)
#endif
     &                    )*Kwz(i,j,k,bi,bj)
       ENDDO
      ENDDO

#if ( defined (GM_NON_UNITY_DIAGONAL) || defined (GM_EXTRA_DIAGONAL) )

C     Gradient of Sigma at U points
      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1
        dSigmaDx(i,j)=sigmaX(i,j,k)
     &          *_maskW(i,j,k,bi,bj)
        dSigmaDy(i,j)=op25*( sigmaY(i-1,j+1,k) +sigmaY(i,j+1,k)
     &                      +sigmaY(i-1, j ,k) +sigmaY(i, j ,k) )
     &          *_maskW(i,j,k,bi,bj)
        dSigmaDr(i,j)=op25*( sigmaR(i-1,j, k ) +sigmaR(i,j, k )
     &                  +maskp1*(sigmaR(i-1,j,kp1) +sigmaR(i,j,kp1)) )
     &          *_maskW(i,j,k,bi,bj)
       ENDDO
      ENDDO

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE SlopeSqr(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDx(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDy(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDr(:,:)   = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */

C     Calculate slopes for use in tensor, taper and/or clip
      CALL GMREDI_SLOPE_LIMIT(
     O             SlopeX, SlopeY,
     O             SlopeSqr, taperFct,
     U             dSigmaDr,
     I             dSigmaDx, dSigmaDy,
     I             ldd97_LrhoW,rC(k),k,
     I             bi, bj, myThid )

cph( NEW
#ifdef ALLOW_AUTODIFF_TAMC
cph(
CADJ STORE SlopeSqr(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE taperFct(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
cph)
#endif /* ALLOW_AUTODIFF_TAMC */
cph)

#ifdef GM_NON_UNITY_DIAGONAL
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kux(i,j,k,bi,bj) =
     &     ( GM_isopycK
#ifdef GM_VISBECK_VARIABLE_K
     &     +op5*(VisbeckK(i,j,bi,bj)+VisbeckK(i-1,j,bi,bj))
#endif
     &     )
     &     *taperFct(i,j)
         ENDDO
        ENDDO
#ifdef ALLOW_AUTODIFF_TAMC
# ifdef GM_EXCLUDE_CLIPPING
CADJ STORE Kux(:,:,k,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
# endif
#endif
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kux(i,j,k,bi,bj) = MAX( Kux(i,j,k,bi,bj), GM_Kmin_horiz )
         ENDDO
        ENDDO
#endif /* GM_NON_UNITY_DIAGONAL */

#ifdef GM_EXTRA_DIAGONAL

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE SlopeX(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE taperFct(:,:)     = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
      IF (GM_ExtraDiag) THEN
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kuz(i,j,k,bi,bj) =
     &     ( GM_isopycK - GM_skewflx*GM_background_K
#ifdef GM_VISBECK_VARIABLE_K
     &     +op5*(VisbeckK(i,j,bi,bj)+VisbeckK(i-1,j,bi,bj))*GM_advect
#endif
     &     )*SlopeX(i,j)*taperFct(i,j)
         ENDDO
        ENDDO
      ENDIF
#endif /* GM_EXTRA_DIAGONAL */

#ifdef ALLOW_DIAGNOSTICS
      IF (doDiagRediFlx) THEN
        km1 = MAX(k-1,1)
        DO j=1,sNy
         DO i=1,sNx+1
C         store in tmp1k Kuz_Redi
          tmp1k(i,j) = ( GM_isopycK
#ifdef GM_VISBECK_VARIABLE_K
     &     +(VisbeckK(i,j,bi,bj)+VisbeckK(i-1,j,bi,bj))*0.5 _d 0
#endif
     &                 )*SlopeX(i,j)*taperFct(i,j)
         ENDDO
        ENDDO
        DO j=1,sNy
         DO i=1,sNx+1
C-        Vertical gradients interpolated to U points
          dTdz = (
     &     +recip_drC(k)*
     &       ( maskC(i-1,j,k,bi,bj)*
     &           (theta(i-1,j,km1,bi,bj)-theta(i-1,j,k,bi,bj))
     &        +maskC( i ,j,k,bi,bj)*
     &           (theta( i ,j,km1,bi,bj)-theta( i ,j,k,bi,bj))
     &       )
     &     +recip_drC(kp1)*
     &       ( maskC(i-1,j,kp1,bi,bj)*
     &           (theta(i-1,j,k,bi,bj)-theta(i-1,j,kp1,bi,bj))
     &        +maskC( i ,j,kp1,bi,bj)*
     &           (theta( i ,j,k,bi,bj)-theta( i ,j,kp1,bi,bj))
     &       )      ) * 0.25 _d 0
           tmp1k(i,j) = dyG(i,j,bi,bj)*drF(k)*hFacW(i,j,k,bi,bj)
     &                * tmp1k(i,j) * dTdz
         ENDDO
        ENDDO
        CALL DIAGNOSTICS_FILL(tmp1k, 'GM_KuzTz', k,1,2,bi,bj,myThid)
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

C     Gradient of Sigma at V points
      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx+1,sNx+Olx-1
        dSigmaDx(i,j)=op25*( sigmaX(i, j ,k) +sigmaX(i+1, j ,k)
     &                    +sigmaX(i,j-1,k) +sigmaX(i+1,j-1,k) )
     &          *_maskS(i,j,k,bi,bj)
        dSigmaDy(i,j)=sigmaY(i,j,k)
     &          *_maskS(i,j,k,bi,bj)
        dSigmaDr(i,j)=op25*( sigmaR(i,j-1, k ) +sigmaR(i,j, k )
     &                  +maskp1*(sigmaR(i,j-1,kp1) +sigmaR(i,j,kp1)) )
     &          *_maskS(i,j,k,bi,bj)
       ENDDO
      ENDDO

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE dSigmaDx(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDy(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE dSigmaDr(:,:)   = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */

C     Calculate slopes for use in tensor, taper and/or clip
      CALL GMREDI_SLOPE_LIMIT(
     O             SlopeX, SlopeY,
     O             SlopeSqr, taperFct,
     U             dSigmaDr,
     I             dSigmaDx, dSigmaDy,
     I             ldd97_LrhoS,rC(k),k,
     I             bi, bj, myThid )

cph(
#ifdef ALLOW_AUTODIFF_TAMC
cph(
CADJ STORE taperfct(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
cph)
#endif /* ALLOW_AUTODIFF_TAMC */
cph)

#ifdef GM_NON_UNITY_DIAGONAL
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kvy(i,j,k,bi,bj) =
     &     ( GM_isopycK
#ifdef GM_VISBECK_VARIABLE_K
     &     +op5*(VisbeckK(i,j,bi,bj)+VisbeckK(i,j-1,bi,bj))
#endif
     &     )
     &     *taperFct(i,j)
         ENDDO
        ENDDO
#ifdef ALLOW_AUTODIFF_TAMC
# ifdef GM_EXCLUDE_CLIPPING
CADJ STORE Kvy(:,:,k,bi,bj)  = comlev1_bibj_k, key=kkey, byte=isbyte
# endif
#endif
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kvy(i,j,k,bi,bj) = MAX( Kvy(i,j,k,bi,bj), GM_Kmin_horiz )
         ENDDO
        ENDDO
#endif /* GM_NON_UNITY_DIAGONAL */

#ifdef GM_EXTRA_DIAGONAL

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE SlopeY(:,:)       = comlev1_bibj_k, key=kkey, byte=isbyte
CADJ STORE taperFct(:,:)     = comlev1_bibj_k, key=kkey, byte=isbyte
#endif /* ALLOW_AUTODIFF_TAMC */
      IF (GM_ExtraDiag) THEN
        DO j=1-Oly+1,sNy+Oly-1
         DO i=1-Olx+1,sNx+Olx-1
          Kvz(i,j,k,bi,bj) =
     &     ( GM_isopycK - GM_skewflx*GM_background_K
#ifdef GM_VISBECK_VARIABLE_K
     &     +op5*(VisbeckK(i,j,bi,bj)+VisbeckK(i,j-1,bi,bj))*GM_advect
#endif
     &     )*SlopeY(i,j)*taperFct(i,j)
         ENDDO
        ENDDO
      ENDIF
#endif /* GM_EXTRA_DIAGONAL */

#ifdef ALLOW_DIAGNOSTICS
      IF (doDiagRediFlx) THEN
c       km1 = MAX(k-1,1)
        DO j=1,sNy+1
         DO i=1,sNx
C         store in tmp1k Kvz_Redi
          tmp1k(i,j) = ( GM_isopycK
#ifdef GM_VISBECK_VARIABLE_K
     &     +(VisbeckK(i,j,bi,bj)+VisbeckK(i,j-1,bi,bj))*0.5 _d 0
#endif
     &                 )*SlopeY(i,j)*taperFct(i,j)
         ENDDO
        ENDDO
        DO j=1,sNy+1
         DO i=1,sNx
C-        Vertical gradients interpolated to U points
          dTdz = (
     &     +recip_drC(k)*
     &       ( maskC(i,j-1,k,bi,bj)*
     &           (theta(i,j-1,km1,bi,bj)-theta(i,j-1,k,bi,bj))
     &        +maskC(i, j ,k,bi,bj)*
     &           (theta(i, j ,km1,bi,bj)-theta(i, j ,k,bi,bj))
     &       )
     &     +recip_drC(kp1)*
     &       ( maskC(i,j-1,kp1,bi,bj)*
     &           (theta(i,j-1,k,bi,bj)-theta(i,j-1,kp1,bi,bj))
     &        +maskC(i, j ,kp1,bi,bj)*
     &           (theta(i, j ,k,bi,bj)-theta(i, j ,kp1,bi,bj))
     &       )      ) * 0.25 _d 0
           tmp1k(i,j) = dxG(i,j,bi,bj)*drF(k)*hFacS(i,j,k,bi,bj)
     &                * tmp1k(i,j) * dTdz
         ENDDO
        ENDDO
        CALL DIAGNOSTICS_FILL(tmp1k, 'GM_KvzTz', k,1,2,bi,bj,myThid)
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

#endif /* GM_NON_UNITY_DIAGONAL || GM_EXTRA_DIAGONAL */

C-- end 2nd loop on vertical level index k
      ENDDO


#ifdef GM_BOLUS_ADVEC
      IF (GM_AdvForm) THEN
        CALL GMREDI_CALC_PSI_B(
     I             bi, bj, iMin, iMax, jMin, jMax,
     I             sigmaX, sigmaY, sigmaR,
     I             ldd97_LrhoW, ldd97_LrhoS,
     I             myThid ) 
      ENDIF
#endif

#ifdef ALLOW_TIMEAVE
C--   Time-average
      IF ( taveFreq.GT.0. ) THEN

         CALL TIMEAVE_CUMULATE( GM_Kwx_T, Kwx, Nr,
     &                          deltaTclock, bi, bj, myThid )
         CALL TIMEAVE_CUMULATE( GM_Kwy_T, Kwy, Nr,
     &                          deltaTclock, bi, bj, myThid )
         CALL TIMEAVE_CUMULATE( GM_Kwz_T, Kwz, Nr,
     &                          deltaTclock, bi, bj, myThid )
#ifdef GM_VISBECK_VARIABLE_K
       IF ( GM_Visbeck_alpha.NE.0. ) THEN
         CALL TIMEAVE_CUMULATE( Visbeck_K_T, VisbeckK, 1,
     &                          deltaTclock, bi, bj, myThid )
       ENDIF
#endif
#ifdef GM_BOLUS_ADVEC
       IF ( GM_AdvForm ) THEN
         CALL TIMEAVE_CUMULATE( GM_PsiXtave, GM_PsiX, Nr,
     &                          deltaTclock, bi, bj, myThid )
         CALL TIMEAVE_CUMULATE( GM_PsiYtave, GM_PsiY, Nr,
     &                          deltaTclock, bi, bj, myThid )
       ENDIF
#endif
       DO k=1,Nr
         GM_TimeAve(k,bi,bj)=GM_TimeAve(k,bi,bj)+deltaTclock
       ENDDO

      ENDIF
#endif /* ALLOW_TIMEAVE */

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
       CALL GMREDI_DIAGNOSTICS_DRIVER(bi,bj,myThid)
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

#endif /* ALLOW_GMREDI */

      RETURN
      END


      SUBROUTINE GMREDI_CALC_TENSOR_DUMMY(
     I             bi, bj, iMin, iMax, jMin, jMax,
     I             sigmaX, sigmaY, sigmaR,
     I             myThid )
C     /==========================================================\
C     | SUBROUTINE GMREDI_CALC_TENSOR                            |
C     | o Calculate tensor elements for GM/Redi tensor.          |
C     |==========================================================|
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "GMREDI.h"

C     == Routine arguments ==
C
      _RL sigmaX(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      _RL sigmaY(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      _RL sigmaR(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr)
      INTEGER bi,bj,iMin,iMax,jMin,jMax
      INTEGER myThid
CEndOfInterface

      INTEGER i, j, k

#ifdef ALLOW_GMREDI

      DO k=1,Nr
       DO j=1-Oly+1,sNy+Oly-1
        DO i=1-Olx+1,sNx+Olx-1
         Kwx(i,j,k,bi,bj) = 0.0
         Kwy(i,j,k,bi,bj) = 0.0
         Kwz(i,j,k,bi,bj) = 0.0
        ENDDO
       ENDDO
      ENDDO
#endif /* ALLOW_GMREDI */

      RETURN
      END
