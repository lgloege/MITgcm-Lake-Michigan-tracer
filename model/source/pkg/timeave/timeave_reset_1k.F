C $Header: /u/gcmpack/MITgcm/pkg/timeave/timeave_reset_1k.F,v 1.2 2003/10/09 04:19:20 edhill Exp $
C $Name:  $
#include "TIMEAVE_OPTIONS.h"

CStartofinterface
      SUBROUTINE TIMEAVE_RESET_1K( fldtave, bi, bj, K, myThid )
C     /==========================================================\
C     | SUBROUTINE TIMEAVE_RESET_1K                              |
C     | o Initialize 1 level of a 3D array                       |
C     |  (replace "timeaver_ini_xyz" and use the same argments)  |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
C     fldtave - time averaged Field
      INTEGER bi, bj, K, myThid
      _RL fldtave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)

CEndofinterface

C     == Local variables ==
C     i,j,k,bi,bj  - Loop counters
      INTEGER i, j
 
C     DO bj = myByLo(myThid), myByHi(myThid)
C      DO bi = myBxLo(myThid), myBxHi(myThid)
C       DO k=1,Nr
         DO j=1,sNy
          DO i=1,sNx
             fldtave(i,j,k,bi,bj) = 0. _d 0
          ENDDO
         ENDDO
C       ENDDO
C      ENDDO
C     ENDDO
 
      RETURN
      END
