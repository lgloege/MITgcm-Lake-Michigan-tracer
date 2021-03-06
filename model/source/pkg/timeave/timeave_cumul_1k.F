C $Header: /u/gcmpack/MITgcm/pkg/timeave/timeave_cumul_1k.F,v 1.4 2005/08/19 22:50:26 heimbach Exp $
C $Name:  $
#include "CPP_EEOPTIONS.h"

CStartofinterface
      SUBROUTINE TIMEAVE_CUMUL_1K( fld, fldtave, deltaTloc, 
     &                             bi, bj, K, myThid )
C     /==========================================================\
C     | SUBROUTINE TIMEAVE_CUMUL_1K                              |
C     | o Sum over time a single array and a single level        |
C     |  (replace "timeaver_1fld_xyz" and use the same argments) |
C     \==========================================================/
      IMPLICIT NONE

C     == Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"

C     == Routine arguments ==
C     myThid - Thread number for this instance of the routine.
C     fld  - Input Field
C     fldtave - time averaged Field
      _RL fld(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL fldtave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL deltaTloc
      INTEGER bi, bj, K, myThid

CEndofinterface

C     == Local variables ==
C     i,j,k,bi,bj  - Loop counters
      INTEGER i, j
 
C     DO bj = myByLo(myThid), myByHi(myThid)
C      DO bi = myBxLo(myThid), myBxHi(myThid)
C       DO K=1,Nr
         DO j=1,sNy
          DO i=1,sNx
             fldtave(i,j,K,bi,bj)=
     &       fldtave(i,j,K,bi,bj)+fld(i,j,K,bi,bj)*deltaTloc
           ENDDO
          ENDDO
C        ENDDO
C       ENDDO
C      ENDDO
 
      RETURN
      END
