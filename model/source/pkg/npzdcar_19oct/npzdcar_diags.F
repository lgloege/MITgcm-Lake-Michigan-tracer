#include "CPP_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

      SUBROUTINE NPZDCAR_DIAGS( myTime, myIter, myThid )
C     /==========================================================\
C     | SUBROUTINE NPZDCAR_DIAGS                                 | 
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
#include "NPZDCAR.h"

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
      _RL tmpc(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      _RL tmpo(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      _RL tmpa(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
      INTEGER iTracer

#ifdef ALLOW_TIMEAVE


C     Dump files and restart average computation if needed
      IF ( myIter.gt.nIter0.and.  
     &     DIFFERENT_MULTIPLE(taveFreq,myTime,deltaTClock)
     &     ) THEN
         
C      Normalize by integrated time
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_NORMALIZ(Phygrow1ave, NPZD_timeave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(Phygrow2ave, NPZD_timeave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(Zoograzave, NPZD_timeave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(Parave, NPZD_timeave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(Chlave, NPZD_timeave, nR ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(FluxCO2ave, NPZD_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(FluxO2ave, NPZD_timeave, 1 ,
     &                 bi,bj,myThid)
         CALL TIMEAVE_NORMALIZ(pHave, NPZD_timeave, 1 ,
     &                 bi,bj,myThid)
        ENDDO
       ENDDO

       print*,'NPZD timeave write'
         
       IF ( PTRACERS_timeave_mdsio )  THEN
         WRITE(suff,'(I10.10)') myIter

         CALL WRITE_FLD_XYZ_RL('NPZD_phygrow1.',suff,Phygrow1ave,
     &       myIter,myThid)
         CALL WRITE_FLD_XYZ_RL('NPZD_phygrow2.',suff,Phygrow2ave,
     &       myIter,myThid)
         CALL WRITE_FLD_XYZ_RL('NPZD_zoograz.',suff,Zoograzave,
     &       myIter,myThid)
         CALL WRITE_FLD_XYZ_RL('NPZD_par.',suff,Parave,
     &       myIter,myThid)
         CALL WRITE_FLD_XYZ_RL('NPZD_chl.',suff,Chlave,
     &       myIter,myThid)
         CALL WRITE_FLD_XY_RL('NPZD_fluxco2.',suff,FluxCO2ave,
     &       myIter,myThid)
         CALL WRITE_FLD_XY_RL('NPZD_fluxo2.',suff,FluxO2ave,
     &       myIter,myThid)
         CALL WRITE_FLD_XY_RL('NPZD_pH.',suff,pHave,
     &       myIter,myThid)

       ENDIF

#ifdef ALLOW_MNC
       IF ( PTRACERS_timeave_mnc ) THEN
         CALL MNC_CW_SET_UDIM('npzd_tave', -1, myThid)
         CALL MNC_CW_RL_W_S('D','npzd_tave',0,0,'T',myTime,myThid)
         CALL MNC_CW_SET_UDIM('npzd_tave', 0, myThid)
         CALL MNC_CW_I_W_S('I','npzd_tave',0,0,'iter',myIter,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_phygrow1_ave',Phygrow1ave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_phygrow2_ave',Phygrow2ave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_zoograz_ave',Zoograzave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_par_ave',Parave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_chl_ave',Chlave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_flxCO2_ave',FluxCO2ave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_flxO2_ave',FluxO2ave,myThid)
         CALL MNC_CW_RL_W(
     &     'D','npzd_tave',0,0,'npzd_pH_ave',pHave,myThid)
       ENDIF
#endif

C      Reset averages to zero
       DO bj = myByLo(myThid), myByHi(myThid)
        DO bi = myBxLo(myThid), myBxHi(myThid)
         CALL TIMEAVE_RESET(Phygrow1ave,Nr,bi,bj,myThid)
         CALL TIMEAVE_RESET(Phygrow2ave,Nr,bi,bj,myThid)
         CALL TIMEAVE_RESET(Zoograzave,Nr,bi,bj,myThid)
         CALL TIMEAVE_RESET(Parave,Nr,bi,bj,myThid)
         CALL TIMEAVE_RESET(Chlave,Nr,bi,bj,myThid)
         CALL TIMEAVE_RESET(FluxCO2ave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(FluxO2ave,1,bi,bj,myThid)
         CALL TIMEAVE_RESET(pHave,1,bi,bj,myThid)
         do k=1,nR
           NPZD_TimeAve(k,bi,bj)=0.d0
         enddo
        ENDDO
       ENDDO
      
       ENDIF
         

#endif /* ALLOW_TIMEAVE */

C monitor total tracers
          IF ( 
     &        DIFFERENT_MULTIPLE(monitorFreq,myTime,deltaTClock)
     &     ) THEN
       _BEGIN_MASTER(myThid)
c
       DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO j=1-OLy,sNy+OLy
        DO i=1-OLx,sNx+OLx
         do k=1,Nr
           tmpn(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,1)+
     &                       ptracer(i,j,k,bi,bj,2)+
     &                       ptracer(i,j,k,bi,bj,3)+
     &                       ptracer(i,j,k,bi,bj,4)+
     &                       ptracer(i,j,k,bi,bj,5)+
     &                       ptracer(i,j,k,bi,bj,6)
           tmps(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,7)+
     &                       Rsip2*ptracer(i,j,k,bi,bj,3)+
     &                       ptracer(i,j,k,bi,bj,8)
           tmpf(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,9)+
     &                       Rfep*ptracer(i,j,k,bi,bj,2)+
     &                       Rfep2*ptracer(i,j,k,bi,bj,3)+
     &                       ptracer(i,j,k,bi,bj,10)+
     &                       ptracer(i,j,k,bi,bj,11)+
     &                       ptracer(i,j,k,bi,bj,12)
           tmpc(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,13)+
     &                       Rcp*ptracer(i,j,k,bi,bj,2)+
     &                       Rcp2*ptracer(i,j,k,bi,bj,3)+
     &                       ptracer(i,j,k,bi,bj,14)+
     &                       ptracer(i,j,k,bi,bj,15)+
     &                       ptracer(i,j,k,bi,bj,16)+
     &                       ptracer(i,j,k,bi,bj,17)
           tmpo(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,18)
           tmpa(i,j,k,bi,bj)=ptracer(i,j,k,bi,bj,19)
         enddo
        ENDDO
        ENDDO
       ENDDO
       ENDDO
        WRITE(msgBuf,'(A)')
     &'// ======================================================='
        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A)') '// MONITOR total tracer field statistics'
        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit,
     &                    SQUEEZE_RIGHT , 1)
        WRITE(msgBuf,'(A)')
     &'// ======================================================='
        CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)
       _END_MASTER(myThid)

C      Print the time to make grepping the stdout easier
       CALL MON_SET_PREF('npzd_',myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmpn,'macro-nutrient',
     &                        maskC,hFacC,rA ,drF,myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmps,'silica-nutrient',
     &                        maskC,hFacC,rA ,drF,myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmpf,'iron-nutrient',
     &                        maskC,hFacC,rA ,drF,myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmpc,'carbon',
     &                        maskC,hFacC,rA ,drF,myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmpo,'oxygen',
     &                        maskC,hFacC,rA ,drF,myThid)
       CALL MON_PRINTSTATS_RL(Nr,tmpa,'alkalinity',
     &                        maskC,hFacC,rA ,drF,myThid)
         WRITE(msgBuf,'(2A)') '// ==========================',
     &        '============================='
         CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)
         WRITE(msgBuf,'(A)')
     &        '// End MONITOR total tracer field statistics'
         CALL PRINT_MESSAGE( msgBuf, mon_ioUnit,
     &        SQUEEZE_RIGHT , 1)
         WRITE(msgBuf,'(2A)') '// ==========================',
     &        '============================='
         CALL PRINT_MESSAGE( msgBuf, mon_ioUnit, SQUEEZE_RIGHT , 1)

       ENDIF
      
      
      RETURN
      END
#endif /* NPZDCAR      */
#endif

