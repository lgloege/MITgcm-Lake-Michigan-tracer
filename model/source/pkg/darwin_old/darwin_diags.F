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
CMICK#include "NPZD2Fe.h"
#include "DARWIN-SMALL.h"

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
Cmickc set arrays to zero if first timestep
Cmickcswdterm -- add ----
Cmick#ifdef PTR_CALC_TERMS
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick       DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick        DO j=1-OLy,sNy+OLy
Cmick        DO i=1-OLx,sNx+OLx
Cmick         do k=1,Nr
Cmick          uipave(i,j,k,bi,bj)= uipave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,1)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,1)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,1) )
Cmick          vipave(i,j,k,bi,bj)= vipave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,1)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,1)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,1) )
Cmick          wipave(i,j,k,bi,bj)= wipave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,1)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,1)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,1))
Cmickc
Cmick          do iTracer=2,6
Cmick           uopave(i,j,k,bi,bj)= uopave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,iTracer) )
Cmick           vopave(i,j,k,bi,bj)= vopave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,iTracer) )
Cmick           wopave(i,j,k,bi,bj)= wopave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,iTracer) )
Cmick     &        +ptr_impldiff(i,j,k,bi,bj,iTracer)
Cmick          enddo
Cmick          uisave(i,j,k,bi,bj)= uisave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,7)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,7)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,7) )
Cmick          visave(i,j,k,bi,bj)= visave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,7)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,7)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,7) )
Cmick          wisave(i,j,k,bi,bj)= wisave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,7)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,7)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,7))
Cmick     &        +ptr_impldiff(i,j,k,bi,bj,7)
Cmick          uosave(i,j,k,bi,bj)= uosave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,8)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,8)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,8) )+
Cmick     &        deltaTclock*Rsip2*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,3) )
Cmick          vosave(i,j,k,bi,bj)= vosave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,8)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,8)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,8) )+
Cmick     &        deltaTclock*Rsip2*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,3) )
Cmick          wosave(i,j,k,bi,bj)= wosave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,8)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,8)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,8))
Cmick     &        +ptr_impldiff(i,j,k,bi,bj,8)+
Cmick     &        deltaTclock*Rsip2*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,3) )
Cmick     &        +Rsip2*ptr_impldiff(i,j,k,bi,bj,3)
Cmick
Cmick          uifave(i,j,k,bi,bj)= uifave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,9)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,9)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,9) )
Cmick          vifave(i,j,k,bi,bj)= vifave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,9)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,9)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,9) )
Cmick          wifave(i,j,k,bi,bj)= wifave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,9)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,9)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,9))
Cmick     &        +ptr_impldiff(i,j,k,bi,bj,9)
Cmick
Cmick          do iTracer=10,12
Cmick           uofave(i,j,k,bi,bj)= uofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,iTracer) )
Cmick           vofave(i,j,k,bi,bj)= vofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,iTracer) )
Cmick           wofave(i,j,k,bi,bj)= wofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,iTracer)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,iTracer) )
Cmick     &        +ptr_impldiff(i,j,k,bi,bj,iTracer)
Cmick          enddo
Cmick         uofave(i,j,k,bi,bj)= uofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*Rfep*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,2)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,2)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,2) ) +
Cmick     &        deltaTclock*Rfep2*
Cmick     &      ( ptr_adv_x(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_x(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_x(i,j,k,bi,bj,3) )
Cmick          vofave(i,j,k,bi,bj)= vofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*Rfep*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,2)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,2)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,2) ) +
Cmick     &        deltaTclock*Rfep2*
Cmick     &      ( ptr_adv_y(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_y(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_y(i,j,k,bi,bj,3) )
Cmick          wofave(i,j,k,bi,bj)= wofave(i,j,k,bi,bj)+
Cmick     &        deltaTclock*Rfep*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,2)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,2)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,2) ) +
Cmick     &        +Rfep*ptr_impldiff(i,j,k,bi,bj,2) +
Cmick     &        deltaTclock*Rfep2*
Cmick     &      ( ptr_adv_r(i,j,k,bi,bj,3)+
Cmick     &        ptr_diff_r(i,j,k,bi,bj,3)+
Cmick     &        ptr_gmdiff_r(i,j,k,bi,bj,3) ) +
Cmick     &        +Rfep2*ptr_impldiff(i,j,k,bi,bj,3)
Cmick         enddo
Cmick        ENDDO
Cmick        ENDDO
Cmick       ENDDO
Cmick       ENDDO
Cmick#endif
Cmickcswdterm -- end add ---
Cmick
CmickC     Dump files and restart average computation if needed
Cmick      IF ( 
Cmick     &     DIFFERENT_MULTIPLE(taveFreq,myTime,myTime-deltaTClock)
Cmick     &     ) THEN
Cmick         
CmickC      Normalize by integrated time
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick        DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Phygrow1ave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Phygrow2ave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Zoograzave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(Parave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick        CALL TIMEAVE_NORMALIZ(Chlave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmickcswdterms -- add ---
Cmick#ifdef PTR_CALC_TERMS
Cmick         CALL TIMEAVE_NORMALIZ(wopave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uopave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(vopave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(wipave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uipave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(vipave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(wosave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uosave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(vosave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(wisave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uisave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(visave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(wofave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uofave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(vofave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(wifave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(uifave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick         CALL TIMEAVE_NORMALIZ(vifave, NPZD_timeave, nR ,
Cmick     &                 bi,bj,myThid)
Cmick#endif
Cmickcswdterms -- end add ---
Cmick        ENDDO
Cmick       ENDDO
Cmick         
Cmick       WRITE(suff,'(I10.10)') myIter
Cmick
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_phygrow1.',suff,Phygrow1ave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_phygrow2.',suff,Phygrow2ave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_zoograz.',suff,Zoograzave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_par.',suff,Parave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_chl.',suff,Chlave,
Cmick     &     myIter,myThid)
Cmickcswdterms -- add ---
Cmick#ifdef PTR_CALC_TERMS
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wop.',suff,wopave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uop.',suff,uopave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vop.',suff,vopave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wip.',suff,wipave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uip.',suff,uipave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vip.',suff,vipave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wos.',suff,wosave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uos.',suff,uosave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vos.',suff,vosave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wis.',suff,wisave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uis.',suff,uisave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vis.',suff,visave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wof.',suff,wofave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uof.',suff,uofave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vof.',suff,vofave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_wif.',suff,wifave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_uif.',suff,uifave,
Cmick     &     myIter,myThid)
Cmick       CALL WRITE_FLD_XYZ_RL('NPZD_vif.',suff,vifave,
Cmick     &     myIter,myThid)
Cmick#endif
Cmick
Cmick
Cmick         
CmickC      Reset averages to zero
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick        DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick         CALL TIMEAVE_RESET(Phygrow1ave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Phygrow2ave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Zoograzave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Parave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(Chlave,Nr,bi,bj,myThid)
Cmickcswdterms -- add --
Cmick#ifdef PTR_CALC_TERMS
Cmick         CALL TIMEAVE_RESET(wopave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uopave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(vopave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(wipave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uipave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(vipave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(wosave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uosave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(vosave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(wisave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uisave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(visave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(wofave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uofave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(vofave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(wifave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(uifave,Nr,bi,bj,myThid)
Cmick         CALL TIMEAVE_RESET(vifave,Nr,bi,bj,myThid)
Cmick#endif
Cmickcswdterms -- end add ---
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
CmickC monitor total tracers
Cmick          IF ( 
Cmick     &        DIFFERENT_MULTIPLE(monitorFreq,myTime,myTime-deltaTClock)
Cmick     &     ) THEN
Cmick       _BEGIN_MASTER(myThid)
Cmickc
Cmick       DO bj = myByLo(myThid), myByHi(myThid)
Cmick       DO bi = myBxLo(myThid), myBxHi(myThid)
Cmick        DO j=1-OLy,sNy+OLy
Cmick        DO i=1-OLx,sNx+OLx
Cmick         do k=1,Nr
Cmick           tmpn(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,1)+
Cmick     &                       ptracer(i,j,k,bi,bj,2)+
Cmick     &                       ptracer(i,j,k,bi,bj,3)+
Cmick     &                       ptracer(i,j,k,bi,bj,4)+
Cmick     &                       ptracer(i,j,k,bi,bj,5)+
Cmick     &                       ptracer(i,j,k,bi,bj,6)+
Cmick     &                       ptracer(i,j,k,bi,bj,7)+
Cmick     &                       ptracer(i,j,k,bi,bj,8)+
Cmick     &                       ptracer(i,j,k,bi,bj,9)+
Cmick     &                       ptracer(i,j,k,bi,bj,10)
Cmick           tmps(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,11)+
Cmick     &                       Rsip1*ptracer(i,j,k,bi,bj,2)+
Cmick     &                       Rsip2*ptracer(i,j,k,bi,bj,3)+
Cmick     &                       Rsip3*ptracer(i,j,k,bi,bj,4)+
Cmick     &                       Rsip4*ptracer(i,j,k,bi,bj,5)+
Cmick     &                       Rsip5*ptracer(i,j,k,bi,bj,6)+
Cmick     &                       Rsip6*ptracer(i,j,k,bi,bj,7)+
Cmick     &                       ptracer(i,j,k,bi,bj,12)
Cmick           tmpf(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,13)+
Cmick     &                       Rfep1*ptracer(i,j,k,bi,bj,2)+
Cmick     &                       Rfep2*ptracer(i,j,k,bi,bj,3)+
Cmick     &                       Rfep3*ptracer(i,j,k,bi,bj,4)+
Cmick     &                       Rfep4*ptracer(i,j,k,bi,bj,5)+
Cmick     &                       Rfep5*ptracer(i,j,k,bi,bj,6)+
Cmick     &                       Rfep6*ptracer(i,j,k,bi,bj,7)+
Cmick     &                       ptracer(i,j,k,bi,bj,14)+
Cmick     &                       ptracer(i,j,k,bi,bj,15)+
Cmick     &                       ptracer(i,j,k,bi,bj,16)
Cmick         enddo
Cmick        ENDDO
Cmick        ENDDO
Cmick       ENDDO
Cmick       ENDDO
Cmick        WRITE(msgBuf,'(A)')
Cmick     &'// ======================================================='
Cmick        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)
Cmick        WRITE(msgBuf,'(A)') '// MONITOR total tracer field statistics'
Cmick        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit,
Cmick     &                    SQUEEZE_RIGHT , 1)
Cmick        WRITE(msgBuf,'(A)')
Cmick     &'// ======================================================='
Cmick        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)
Cmick       _END_MASTER(myThid)
Cmick
CmickC      Print the time to make grepping the stdout easier
Cmick       CALL MON_SET_PREF('ptracer_',myThid)
Cmick       CALL GCHEM_PRINT(Nr,tmpn,'macro-nutrient',
Cmick     &                        maskC,maskC,rA ,drC,myThid)
Cmick       CALL GCHEM_PRINT(Nr,tmps,'silica-nutrient',
Cmick     &                        maskC,maskC,rA ,drC,myThid)
Cmick       CALL GCHEM_PRINT(Nr,tmpf,'iron-nutrient',
Cmick     &                        maskC,maskC,rA ,drC,myThid)
Cmick       ENDIF
Cmick      
      
      RETURN
      END
#endif /* DARWIN      */
#endif

