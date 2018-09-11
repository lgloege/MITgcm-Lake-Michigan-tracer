C; $Header: /u/gcmpack/models/MITgcmUV/model/src/calc_gs.F,v 1.11 1998/07/15 22:22:24 adcroft Exp $

#include "CPP_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

CStartOfInterFace
      SUBROUTINE Fe_CHEM(
     I           bi,bj,iMin,iMax,jMin,jMax,
     I           fe, freefe,
     I           myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE Fe_chem                                       |
C     |                                                          |
C     | o Calculate L,FeL,Fe concentration                       |
C     |==========================================================|
      IMPLICIT NONE

C     == GLobal variables ==
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"

C     == Routine arguments ==                
C     bi, bj, iMin, iMax, jMin, jMax - Range of points for which calculation
C                                      results will be set.
C     myThid - Instance number for this innvocation of CALC_GT
      _RL  freefe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  fe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      INTEGER bi,bj,iMin,iMax,jMin,jMax
      INTEGER myIter,myThid
CEndOfInterface


      INTEGER I,J,K
      _RL  lig, FeL

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
CC
CC ADAPTED FROM PAYAL
CC
CC
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc

C ligand balance in surface layer
C in surface layer

       DO j=jMin,jMax
        DO i=iMin,iMax
         DO k=1,nR
          IF(hFacC(i,j,k,bi,bj) .gt. 0.0)THEN

C   Ligand,FeL,Fe calculation
            
              lig=(-ligand_stab*max(0.d0,fe (i,j,k,bi,bj))+
     &              ligand_stab*ligand_tot-1
     &             +((ligand_stab*max(0.d0,fe (i,j,k,bi,bj))
     &                -ligand_stab*ligand_tot+1)**2+4
     &                *ligand_stab*ligand_tot)**0.5)/(2*ligand_stab)
 
              FeL = ligand_tot-lig
              freefe(i,j,k,bi,bj) = fe (i,j,k,bi,bj)-FeL
              freefe(i,j,k,bi,bj) = min(freefe(i,j,k,bi,bj),freefemax)
              fe(i,j,k,bi,bj) = FeL+freefe(i,j,k,bi,bj)
          END IF  
         ENDDO
        ENDDO
       ENDDO    
c
        RETURN
        END                      

