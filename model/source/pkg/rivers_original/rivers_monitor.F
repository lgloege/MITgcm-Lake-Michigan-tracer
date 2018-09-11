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
        CALL MON_PRINTSTATS_RL(1,rivalk,'_rivalk',
     &       maskH,maskH,rA,drF,myThid)
        CALL MON_PRINTSTATS_RL(1,rivdic,'_rivdic',
     &       maskH,maskH,rA,drF,myThid)
        CALL MON_PRINTSTATS_RL(1,rivdoc,'_rivdoc',
     &       maskH,maskH,rA,drF,myThid)

#endif /* ALLOW_MONITOR */

      RETURN
      END
