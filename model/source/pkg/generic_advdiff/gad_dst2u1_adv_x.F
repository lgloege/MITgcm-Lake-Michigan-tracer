C $Header: /u/gcmpack/MITgcm/pkg/generic_advdiff/gad_dst2u1_adv_x.F,v 1.1 2005/10/22 19:56:33 jmc Exp $
C $Name:  $

#include "GAD_OPTIONS.h"

CBOP
C !ROUTINE: GAD_DST2U1_ADV_X

C !INTERFACE: ==========================================================
      SUBROUTINE GAD_DST2U1_ADV_X( 
     I           bi,bj,k, advectionScheme,
     I           deltaTloc, uTrans, uVel,
     I           tracer,
     O           uT,
     I           myThid )

C !DESCRIPTION:
C  Calculates the area integrated zonal flux due to advection
C  of a tracer using second-order Direct Space and Time (DST-2) 
C  interpolation (=Lax-Wendroff) or simple 1rst order upwind scheme.

C !USES: ===============================================================
      IMPLICIT NONE
#include "SIZE.h"
#include "GRID.h"
#include "GAD.h"

C !INPUT PARAMETERS: ===================================================
C  bi,bj             :: tile indices
C  k                 :: vertical level
C  advectionScheme   :: advection scheme to use: either 2nd Order DST 
C                                                or 1rst Order Upwind
C  uTrans            :: zonal volume transport
C  uVel              :: zonal flow
C  tracer            :: tracer field
C  myThid            :: thread number
      INTEGER bi,bj,k
      INTEGER advectionScheme
      _RL deltaTloc
      _RL uTrans(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL uVel  (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL tracer(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C !OUTPUT PARAMETERS: ==================================================
C  uT                :: zonal advective flux
      _RL uT    (1-OLx:sNx+OLx,1-OLy:sNy+OLy)

C !LOCAL VARIABLES: ====================================================
C  i,j               :: loop indices
C  rLimit            :: centered (vs upwind) fraction
C  uFld              :: velocity [m/s], zonal component
C  uCFL              :: Courant-Friedrich-Levy number
      INTEGER i,j
      _RL uFld, uCFL, xLimit
CEOP

      xLimit = 0. _d 0
      IF ( advectionScheme.EQ.ENUM_DST2 ) xLimit = 1. _d 0

      DO j=1-Oly,sNy+Oly
       uT(1-Olx,j)=0.
       DO i=1-Olx+1,sNx+Olx

c       uFld = uVel(i,j,k,bi,bj)
        uFld = uTrans(i,j)*recip_dyG(i,j,bi,bj)
     &        *recip_drF(k)*recip_hFacW(i,j,k,bi,bj)
        uCFL = ABS(uFld*deltaTloc*recip_dxC(i,j,bi,bj))

        uT(i,j) = 
     &     uTrans(i,j)*(Tracer(i-1,j)+Tracer(i,j))*0.5 _d 0
     &   + ( 1. _d 0 - xLimit*(1. _d 0 - uCFL) )*ABS(uTrans(i,j))
     &                *(tracer(i-1,j)-tracer(i,j))*0.5 _d 0
       ENDDO
      ENDDO

      RETURN
      END
