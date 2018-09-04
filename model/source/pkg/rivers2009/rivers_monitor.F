C $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_monitor.F,v 1.6 2006/01/13 17:19:32 heimbach Exp $
C $Name:  $

#include "RIVERS_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: RIVERS_MONITOR

C     !INTERFACE:
      SUBROUTINE RIVERS_MONITOR(
     I     myIter, myTime, myThid )

C     !DESCRIPTION:
C     Print some statistics about input forcing fields.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "EESUPPORT.h"
#include "GRID.h"
#ifdef ALLOW_MONITOR
# include "MONITOR.h"
#endif
#include "rivers_fields.h"
C#include "rivers_clim_fields.h"

C     !INPUT PARAMETERS:
      INTEGER myIter
      _RL myTime
      INTEGER myThid
CEOP

#ifdef ALLOW_MONITOR

C       Print some statistics about input forcing fields
        CALL MON_SET_PREF('rivers',myThid)
        CALL MON_PRINTSTATS_RL(1,rivflow,'_rivflow',
     &       maskH,maskH,rA,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,ustress,'_ustress',
c$$$     &       maskH,maskH,rAw,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,vstress,'_vstress',
c$$$     &       maskH,maskH,rAs,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,hflux,'_hflux',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,sflux,'_sflux',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#ifdef ALLOW_ATM_WIND
c$$$        CALL MON_PRINTSTATS_RL(1,uwind,'_uwind',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,vwind,'_vwind',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif /* ALLOW_ATM_WIND */
c$$$#ifdef ALLOW_ATM_TEMP
c$$$        CALL MON_PRINTSTATS_RL(1,atemp,'_atemp',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,aqh,'_aqh',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,lwflux,'_lwflux',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,precip,'_precip',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif /* ALLOW_ATM_TEMP */
c$$$#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
c$$$        CALL MON_PRINTSTATS_RL(1,swflux,'_swflux',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#if defined(ALLOW_ATM_TEMP) || defined(RIVERS_READ_EVAP)
c$$$        CALL MON_PRINTSTATS_RL(1,evap,'_evap',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$        CALL MON_PRINTSTATS_RL(1,swdown,'_swdown',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$        CALL MON_PRINTSTATS_RL(1,lwdown,'_lwdown',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#ifdef ATMOSPHERIC_LOADING
c$$$        CALL MON_PRINTSTATS_RL(1,apressure,'_apressure',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#if defined (ALLOW_RUNOFF) || defined (ALLOW_SEAICE)
c$$$        CALL MON_PRINTSTATS_RL(1,runoff,'_runoff',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#ifdef ALLOW_CLIMSST_RELAXATION
c$$$        CALL MON_PRINTSTATS_RL(1,climsst,'_climsst',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif
c$$$#ifdef ALLOW_CLIMSSS_RELAXATION
c$$$        CALL MON_PRINTSTATS_RL(1,climsss,'_climsss',
c$$$     &       maskH,maskH,rA ,drF,myThid)
c$$$#endif

#endif /* ALLOW_MONITOR */

      RETURN
      END
