C $Header: /u/gcmpack/MITgcm/pkg/mom_common/mom_v_bottomdrag.F,v 1.5 2005/09/29 18:36:43 jmc Exp $
C $Name:  $

#include "MOM_COMMON_OPTIONS.h"

crg butterflies
crg using undefined values of kapparv in mom_v_bottomdrag
crg mom_v_bottomdrag must have iMin,iMax,jMin,jMax as arguments
crg and only use values being calculated in calc_viscosity
crg There are probably many more routines in mom_fluxform and mom_vecin
crg using undefined values.

CBOP
C !ROUTINE: MOM_V_BOTTOMDRAG

C !INTERFACE: ==========================================================
      SUBROUTINE MOM_V_BOTTOMDRAG(
     I        bi,bj,k,
     I        vFld, KE, KappaRV,
     O        vDragTerms,
     I        myThid)

C !DESCRIPTION:
C Calculates the drag due to friction and the no-slip condition at bottom:
C \begin{equation*}
C G^v_{drag} = - ( r_b + C_D |v| + \frac{2}{\Delta r_c} ) v
C \end{equation*}

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"

C !INPUT PARAMETERS: ===================================================
C  bi,bj                :: tile indices
C  k                    :: vertical level
C  vFld                 :: meridional flow
C  KE                   :: Kinetic energy
C  KappaRV              :: vertical viscosity
C  myThid               :: thread number
      INTEGER bi,bj,k
      _RL vFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL KE(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL KappaRV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      _RL viscFac
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
C  vDragTerms           :: drag term
      _RL vDragTerms(1-OLx:sNx+OLx,1-OLy:sNy+OLy)

C !LOCAL VARIABLES: ====================================================
C  i,j                  :: loop indices
C  Kp1                  :: =k+1 for k<Nr, =Nr for k>=Nr
      INTEGER I,J,kDown,kDownC,kBottom
      _RL rdrckp1,maskDown
CEOP

C-  No-slip BCs impose a drag at bottom
      IF ( usingZCoords ) THEN
       kBottom = Nr
       kDown   = min(k+1,kBottom)
       kDownC  = kDown
      ELSE
       kBottom = 1
       kDown   = max(k-1,kBottom)
       kDownC  = k
      ENDIF
      rdrckp1=recip_drC(kDownC)
      viscFac=0.
      IF (no_slip_bottom) viscFac=1.
      IF (k.EQ.kBottom) rdrckp1=recip_drF(k)
      DO j=1-Oly+1,sNy+Oly-1
       DO i=1-Olx,sNx+Olx-1
        maskDown=_maskS(i,j,kdown,bi,bj)
        IF (k.EQ.kBottom) maskDown=0.
        vDragTerms(i,j)=
     &   -_recip_hFacS(i,j,k,bi,bj)*recip_drF(k)
     &   *( 
     &      2.*KappaRV(i,j,kDownC)*rdrckp1*viscFac
#if (defined (ALLOW_AUTODIFF_TAMC) && \
    defined (ALLOW_BOTTOMDRAG_CONTROL))
     &     + bottomdragfld(i,j,bi,bj)
#else
     &     + bottomDragLinear
#endif
     &    )*(1.-maskDown)*vFld(i,j)
        IF ( (KE(i,j)+KE(i,j-1)) .NE. 0. ) THEN
         vDragTerms(i,j)=vDragTerms(i,j)
     &    -_recip_hFacS(i,j,k,bi,bj)*recip_drF(k)
     &    *bottomDragQuadratic*sqrt(KE(i,j)+KE(i,j-1))
     &    *(1.-maskDown)*vFld(i,j)
        ENDIF
       ENDDO
      ENDDO

#ifdef ALLOW_DIAGNOSTICS
      IF (useDiagnostics) THEN
        CALL DIAGNOSTICS_FILL(vDragTerms,'VBotDrag',k,1,2,bi,bj,myThid)
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

      RETURN
      END
