C $Header: /u/gcmpack/MITgcm/model/src/calc_buoyancy.F,v 1.8 2002/09/25 19:36:50 mlosch Exp $
C $Name:  $

#include "CPP_OPTIONS.h"

      SUBROUTINE CALC_BUOYANCY(
     I      bi, bj, iMin, iMax, jMin, jMax,  k, rhoLoc,
     O      buoy,
     I      myThid )

C     /==========================================================\
C     | o SUBROUTINE BUOYANCY                                    |
C     |   Calculates buoyancy for an XY slice of a tile.         |
C     |==========================================================|
C     |                                                          |
C     | k - is the density level                                 |
C     |                                                          |
C     \==========================================================/
      IMPLICIT NONE

C--   == Global data ==
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C--   == Routine arguments ==
      INTEGER bi,bj,iMin,iMax,jMin,jMax
      INTEGER k			
      _RL rhoLoc(1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      _RL buoy  (1-Olx:sNx+Olx,1-Oly:sNy+Oly)
      INTEGER myThid

C--   == Local variables ==
      INTEGER i,j

      IF    ( buoyancyRelation .eq. 'ATMOSPHERIC'  ) THEN

       DO j=jMin,jMax
        DO i=iMin,iMax
         buoy(i,j)=(theta(i,j,k,bi,bj)-tRef(K))/tRef(K)
        ENDDO
       ENDDO
       
      ELSEIF ( buoyancyRelation .eq. 'OCEANIC' ) THEN

       DO j=jMin,jMax
        DO i=iMin,iMax
         buoy(i,j)=-Gravity*recip_rhoConst*rholoc(i,j)
        ENDDO
       ENDDO

      ELSEIF ( buoyancyRelation .eq. 'OCEANICP' ) THEN

       DO j=jMin,jMax
        DO i=iMin,iMax
         if ( rholoc(i,j) .ne. 0. ) then
          rholoc(i,j) = 1./rholoc(i,j)
          buoy(i,j)=rholoc(i,j)
         endif
        ENDDO
       ENDDO

      ELSE

       STOP 
     &'CALC_BUOANCY: variable "buoyancyRelation" has an illegal value'

      ENDIF


      RETURN
      END
