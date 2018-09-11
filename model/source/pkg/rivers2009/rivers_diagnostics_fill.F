c $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_diagnostics_fill.F,v 1.2 2005/06/29 07:11:18 heimbach Exp $

#include "RIVERS_OPTIONS.h"

      subroutine rivers_diagnostics_fill(
     &           mycurrenttime, mycurrentiter, mythid )

c     ==================================================================
c     SUBROUTINE rivers_diagnostics_fill
c     ==================================================================
c
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"

#include "rivers_param.h"
#include "rivers_fields.h"
C#include "exf_constants.h"

c     == routine arguments ==

      integer mythid
      integer mycurrentiter
      _RL     mycurrenttime

c     == local variables ==

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
c
         CALL DIAGNOSTICS_FILL(rivflow,'RIVERflo',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(ustress,'RIVERStaux ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(vstress,'RIVERStauy ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(sflux,  'RIVERSempmr',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hflux,  'RIVERSqnet ',0,1,0,1,1,myThid)
c$$$#ifdef SHORTWAVE_HEATING
c$$$         CALL DIAGNOSTICS_FILL(swflux, 'RIVERSswnet',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_ATM_WIND
c$$$         CALL DIAGNOSTICS_FILL(uwind,  'RIVERSuwind',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(vwind,  'RIVERSvwind',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_ATM_TEMP
c$$$         CALL DIAGNOSTICS_FILL(atemp,  'RIVERSatemp',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(aqh,    'RIVERSaqh  ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hs    , 'RIVERShs   ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hl    , 'RIVERShl   ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(lwflux, 'RIVERSlwnet',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(precip, 'RIVERSpreci',0,1,0,1,1,myThid)
c$$$#endif
c$$$#if (defined (ALLOW_ATM_TEMP) || defined (RIVERS_READ_EVAP))
c$$$         CALL DIAGNOSTICS_FILL(evap,   'RIVERSevap ',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$         CALL DIAGNOSTICS_FILL(lwdown, 'RIVERSlwdn ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(swdown, 'RIVERSswdn ',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ATMOSPHERIC_LOADING
c$$$         CALL DIAGNOSTICS_FILL(apressure,'RIVERSpress',0,1,0,1,1,myThid)
c$$$#endif
c
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

      end
