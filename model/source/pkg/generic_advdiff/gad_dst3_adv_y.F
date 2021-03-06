C $Header: /u/gcmpack/MITgcm/pkg/generic_advdiff/gad_dst3_adv_y.F,v 1.6 2005/10/14 21:51:05 jmc Exp $
C $Name:  $

#include "GAD_OPTIONS.h"

      SUBROUTINE GAD_DST3_ADV_Y( 
     I           bi,bj,k,deltaTloc,
     I           vTrans, vVel,
     I           maskLocS, tracer,
     O           vT,
     I           myThid )
C     /==========================================================\
C     | SUBROUTINE GAD_DST3_ADV_Y                                |
C     | o Compute Meridional advective Flux of Tracer using      |
C     |   3rd Order DST Sceheme                                  |
C     |==========================================================|
      IMPLICIT NONE

C     == GLobal variables ==
#include "SIZE.h"
#include "GRID.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GAD.h"

C     == Routine arguments ==
      INTEGER bi,bj,k
      _RL deltaTloc
      _RL vTrans(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vVel(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RS maskLocS(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL tracer(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL vT    (1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER myThid

C     == Local variables ==
C     vFld    :: velocity [m/s], meridional component
      INTEGER i,j
      _RL Rjm,Rj,Rjp,cfl,d0,d1
      _RL psiP,psiM,thetaP,thetaM
      _RL vFld
      _RL smallNo
c     _RL Rjjm,Rjjp

      IF (inAdMode) THEN
       smallNo = 1.0D-20
      ELSE
       smallNo = 1.0D-20
      ENDIF

      DO i=1-Olx,sNx+Olx
       vT(i,1-Oly)=0.
       vT(i,2-Oly)=0.
       vT(i,sNy+Oly)=0.
      ENDDO
      DO j=1-Oly+2,sNy+Oly-1
       DO i=1-Olx,sNx+Olx
        Rjp=(tracer(i,j+1)-tracer(i, j ))*maskLocS(i,j+1)
        Rj =(tracer(i, j )-tracer(i,j-1))*maskLocS(i, j )
        Rjm=(tracer(i,j-1)-tracer(i,j-2))*maskLocS(i,j-1)

c       vFld = vVel(i,j,k,bi,bj)
        vFld = vTrans(i,j)*recip_dxG(i,j,bi,bj)
     &       *recip_drF(k)*recip_hFacS(i,j,k,bi,bj)
        cfl=abs(vFld*deltaTloc*recip_dyC(i,j,bi,bj))
        d0=(2.-cfl)*(1.-cfl)*oneSixth
        d1=(1.-cfl*cfl)*oneSixth
#ifdef ALLOW_MATRIX
        IF (.NOT.useMATRIX) THEN
#endif /* ALLOW_MATRIX */
        IF ( ABS(Rj).LT.smallNo .OR.
     &       ABS(Rjm).LT.smallNo ) THEN
         thetaP=0.
         psiP=0.
        ELSE   
         thetaP=(Rjm+smallNo)/(smallNo+Rj)
         psiP=d0+d1*thetaP
        ENDIF
        IF ( ABS(Rj).LT.smallNo .OR.
     &       ABS(Rjp).LT.smallNo ) THEN
         thetaM=0.
         psiM=0.
        ELSE
         thetaM=(Rjp+smallNo)/(smallNo+Rj)
         psiM=d0+d1*thetaM
        ENDIF
        vT(i,j)=
     &   0.5*(vTrans(i,j)+abs(vTrans(i,j)))
     &      *( Tracer(i,j-1) + psiP*Rj )
     &  +0.5*(vTrans(i,j)-abs(vTrans(i,j)))
     &      *( Tracer(i, j ) - psiM*Rj )
#ifdef ALLOW_MATRIX
        ELSE     
          vT(i,j)=
     &     0.5*(vTrans(i,j)+abs(vTrans(i,j)))
     &        *( Tracer(i,j-1) + (d0*Rj+d1*Rjm) )
     &    +0.5*(vTrans(i,j)-abs(vTrans(i,j)))
     &        *( Tracer(i, j ) - (d0*Rj+d1*Rjp) )
        ENDIF
#endif /* ALLOW_MATRIX */     

       ENDDO
      ENDDO

      RETURN
      END
