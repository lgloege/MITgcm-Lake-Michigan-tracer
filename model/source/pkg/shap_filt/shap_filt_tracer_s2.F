C $Header: /u/gcmpack/MITgcm/pkg/shap_filt/shap_filt_tracer_s2.F,v 1.10 2005/10/07 14:19:42 jmc Exp $
C $Name:  $

#include "SHAP_FILT_OPTIONS.h"

CBOP
C     !ROUTINE: SHAP_FILT_TRACER_S2
C     !INTERFACE:
      SUBROUTINE SHAP_FILT_TRACER_S2(
     U           field, tmpFld,
     I           nShapTr, kSize, myTime, myThid )
C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R SHAP_FILT_TRACER_S2
C     | o Applies Shapiro filter to 2D field (cell center).
C     | o use filtering function "S2" = [1 - (d_xx+d_yy)^n]
C     | o Options for computational filter (no grid spacing)
C     |   or physical space filter (with grid spacing) or both.
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "SHAP_FILT.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments
C     field :: cell-centered 2D field on which filter applies
C     tmpFld :: working temporary array
C     nShapTr :: (total) power of the filter for this tracer
C     kSize :: length of 3rd Dim : either =1 (2D field) or =Nr (3D field)
C     myTime :: Current time in simulation
C     myThid :: Thread number for this instance of SHAP_FILT_TRACER_S2
      INTEGER nShapTr, kSize
      _RL field(1-OLx:sNx+OLx,1-OLy:sNy+OLy,kSize,nSx,nSy)
      _RL tmpFld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,kSize,nSx,nSy)
      _RL     myTime
      INTEGER myThid

#ifdef ALLOW_SHAP_FILT

C     !LOCAL VARIABLES:
C     == Local variables ==
      INTEGER nShapComput
      INTEGER bi,bj,k,i,j,n
      _RL tmpGrd(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL tmpFdx(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL tmpFdy(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
CEOP

      IF (nShapTr.GT.0) THEN
C-------
C  Apply computational filter ^(nShap-nShapPhys) without grid factor
C  then apply Physical filter ^nShapPhys  with grid factors
C-------
        nShapComput = nShapTr - nShapTrPhys

        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
          DO k=1,kSize
           DO j=1-Oly,sNy+Oly
            DO i=1-Olx,sNx+Olx
             tmpFld(i,j,k,bi,bj)=field(i,j,k,bi,bj)
            ENDDO
           ENDDO
          ENDDO
         ENDDO
        ENDDO


C      ( d_xx +d_yy )^n tmpFld

       DO n=1,nShapTr

        IF ( MOD(n,2).EQ.1 .OR. Shap_alwaysExchTr ) THEN
         IF (kSize.EQ.Nr) THEN
          _EXCH_XYZ_R8( tmpFld, myThid )
         ELSEIF (kSize.EQ.1) THEN
          _EXCH_XY_R8( tmpFld, myThid )
         ELSE
          STOP 'S/R SHAP_FILT_TRACER_S2: kSize is wrong'
         ENDIF
        ENDIF

        DO bj=myByLo(myThid),myByHi(myThid)
         DO bi=myBxLo(myThid),myBxHi(myThid)
          DO k=1,kSize

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C--        Calculate gradient in X direction:
#ifndef ALLOW_AUTODIFF_TAMC
           IF ( .NOT.Shap_alwaysExchTr
     &          .AND. useCubedSphereExchange ) THEN
C          to compute d/dx(tmpFld), fill corners with appropriate values:
             CALL FILL_CS_CORNER_TR_RL( .TRUE., 
     &                                 tmpFld(1-Olx,1-Oly,k,bi,bj), 
     &                                 bi,bj, myThid )
           ENDIF
#endif
           IF ( n.LE.nShapComput ) THEN
C-         Computational space: del_i
             DO j=0,sNy+1
              DO i=0,sNx+2
               tmpFdx(i,j) = 
     &            ( tmpFld(i,j,k,bi,bj)-tmpFld(i-1,j,k,bi,bj) )
     &                     *_maskW(i,j,k,bi,bj)
              ENDDO
             ENDDO
           ELSE
C-         Physical space: grad_x
             DO j=0,sNy+1
              DO i=0,sNx+2
               tmpFdx(i,j) = 
     &            ( tmpFld(i,j,k,bi,bj)-tmpFld(i-1,j,k,bi,bj) )
     &                     *_hFacW(i,j,k,bi,bj)
     &                     *dyG(i,j,bi,bj)*recip_dxC(i,j,bi,bj)
              ENDDO
             ENDDO
           ENDIF

C--        Calculate gradient in Y direction:
#ifndef ALLOW_AUTODIFF_TAMC
           IF ( .NOT.Shap_alwaysExchTr
     &          .AND. useCubedSphereExchange ) THEN
C          to compute d/dy(tmpFld), fill corners with appropriate values:
             CALL FILL_CS_CORNER_TR_RL(.FALSE., 
     &                                 tmpFld(1-Olx,1-Oly,k,bi,bj), 
     &                                 bi,bj, myThid )
           ENDIF
#endif
           IF ( n.LE.nShapComput ) THEN
C-         Computational space: del_j
             DO j=0,sNy+2
              DO i=0,sNx+1
               tmpFdy(i,j) = 
     &            ( tmpFld(i,j,k,bi,bj)-tmpFld(i,j-1,k,bi,bj) )
     &                     *_maskS(i,j,k,bi,bj)
              ENDDO
             ENDDO
           ELSE
C-         Physical space: grad_y
             DO j=0,sNy+2
              DO i=0,sNx+1
               tmpFdy(i,j) = 
     &            ( tmpFld(i,j,k,bi,bj)-tmpFld(i,j-1,k,bi,bj) )
     &                     *_hFacS(i,j,k,bi,bj)
     &                     *dxG(i,j,bi,bj)*recip_dyC(i,j,bi,bj)
              ENDDO
             ENDDO
           ENDIF

C--        Calculate (d_xx + d_yy) tmpFld :
           DO j=0,sNy+1
             DO i=0,sNx+1
               tmpGrd(i,j) = ( tmpFdx(i+1,j) - tmpFdx(i,j) )
     &                     + ( tmpFdy(i,j+1) - tmpFdy(i,j) )
             ENDDO
           ENDDO

C--        Computational space Filter 
           IF ( n.LE.nShapComput ) THEN
             DO j=0,sNy+1
              DO i=0,sNx+1
               tmpFld(i,j,k,bi,bj) = -0.125*tmpGrd(i,j)
              ENDDO
             ENDDO
C--        Physical space Filter 
           ELSEIF (Shap_TrLength.LE.0.) THEN
             DO j=0,sNy+1
              DO i=0,sNx+1
               tmpFld(i,j,k,bi,bj) = -0.125*tmpGrd(i,j)
     &             *recip_hFacC(i,j,k,bi,bj)
              ENDDO
             ENDDO
           ELSE
             DO j=0,sNy+1
              DO i=0,sNx+1
               tmpFld(i,j,k,bi,bj) = -0.125*tmpGrd(i,j)
     &             *recip_hFacC(i,j,k,bi,bj)*recip_rA(i,j,bi,bj)
     &             *Shap_TrLength*Shap_TrLength
              ENDDO
             ENDDO
           ENDIF
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C      end k,bi,bj loop:
          ENDDO
         ENDDO
        ENDDO
C      end loop n=1,nShapTr
       ENDDO

C      F <-  [1 - (d_xx+d_yy)^n *deltaT/tau].F
       DO bj=myByLo(myThid),myByHi(myThid)
        DO bi=myBxLo(myThid),myBxHi(myThid)
         DO k=1,kSize
          DO j=1,sNy
           DO i=1,sNx
            field(i,j,k,bi,bj)=field(i,j,k,bi,bj)
     &            -tmpFld(i,j,k,bi,bj)*dTtracerLev(1)/Shap_Trtau
            tmpFld(i,j,k,bi,bj)= -tmpFld(i,j,k,bi,bj)/Shap_Trtau
           ENDDO
          ENDDO
         ENDDO
        ENDDO
       ENDDO

c       IF (kSize.EQ.Nr) THEN
c         _EXCH_XYZ_R8( field, myThid )
c       ELSEIF (kSize.EQ.1) THEN
c         _EXCH_XY_R8( field, myThid )
c       ELSE
c         STOP 'S/R SHAP_FILT_TRACER_S2: kSize is wrong'
c       ENDIF

      ENDIF
#endif /* ALLOW_SHAP_FILT */

      RETURN
      END
