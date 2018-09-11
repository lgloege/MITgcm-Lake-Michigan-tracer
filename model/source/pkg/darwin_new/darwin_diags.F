#include "CPP_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

      SUBROUTINE DARWIN_DIAGS( myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE NPZD2Fe_DIAGS                                 | 
C     | o Do POM diagnostic output and                           |
C     |   POM and total tracer monitoring                        |           
C     \==========================================================/
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "MONITOR.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "DARWIN_IO.h"
#include "PLANKTON.h"

C     == Routine arguments ==
C     myTime - Current time of simulation ( s )
C     myIter - Iteration number
C     myThid -  Number of this instance of INI_FORCING
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

C     == Local variables ==
      LOGICAL  DIFFERENT_MULTIPLE
      EXTERNAL DIFFERENT_MULTIPLE
      INTEGER i,j,k,bi, bj
      CHARACTER*(MAX_LEN_MBUF) suff
      CHARACTER*(MAX_LEN_MBUF) msgBuf

      _RL tmpn(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      _RL tmps(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      _RL tmpf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      INTEGER iTracer

Cmick #ifdef ALLOW_TIMEAVE
Cmick
CmickC     Dump files and restart average computation if needed
Cmick      IF ( 
Cmick     &     DIFFERENT_MULTIPLE(taveFreq,myTime,myTime-deltaTClock)
Cmick     &     ) THEN
Cmick         
CmickC      Normalize by integrated time
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick        DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick         CALL TIMEAVE_NORMALIZ(PPave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Zoograzave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Parave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick        CALL TIMEAVE_NORMALIZ(Chlave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick        ENDDO
Cmick       ENDDO
Cmick         
Cmick       WRITE(suff,'(I10.10)') myIter
Cmick
Cmick       CALL WRITE_FLD_XYZ_RL('DARWIN_PP.',suff,PPave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('DARWIN_zoograz.',suff,Zoograzave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('DARWIN_par.',suff,Parave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('DARWIN_chl.',suff,Chlave,
Cmick     &     myIter,myThid)
Cmick         
CmickC      Reset averages to zero
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick        DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick         CALL TIMEAVE_RESET(PPave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Zoograzave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Parave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Chlave,Nr,bi,bj,myThid)
Cmick         do k=1,nR
Cmick           NPZD_TimeAve(k,bi,bj)=0.d0
Cmick         enddo
Cmick        ENDDO
Cmick       ENDDO
Cmick      
Cmick       ENDIF
Cmick         
Cmick
Cmick#endif /* ALLOW_TIMEAVE */
Cmick
      
      RETURN
      END
#endif /* DARWIN      */
#endif

