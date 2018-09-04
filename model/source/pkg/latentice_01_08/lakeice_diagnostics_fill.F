c $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_diagnostics_fill.F,v 1.2 2005/06/29 07:11:18 heimbach Exp $

#include "LAKEICE_OPTIONS.h"

      subroutine lakeice_diagnostics_fill(
     &           mycurrenttime, mycurrentiter, mythid )

c     ==================================================================
c     SUBROUTINE lakeice_diagnostics_fill
c     ==================================================================
c
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"

#include "lakeice_param.h"
#include "lakeice_fields.h"
C#include "exf_constants.h"

c     == routine arguments ==

      integer mythid
      integer mycurrentiter
      _RL     mycurrenttime

c     == local variables ==

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
c
         CALL DIAGNOSTICS_FILL(icefrac,'LAKEicef',0,1,0,1,1,myThid)
         
c  modified by Val Bennington Jan 2008
#ifdef ALLOW_ICELATENT
         CALL DIAGNOSTICS_FILL(icelatent,'ICElat',0,1,0,1,1,myThid)
#endif /* ALLOW_ICELATENT */      
c$$$         CALL DIAGNOSTICS_FILL(ustress,'LAKEICEtaux ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(vstress,'LAKEICEtauy ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(sflux,  'LAKEICEempmr',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hflux,  'LAKEICEqnet ',0,1,0,1,1,myThid)
c$$$#ifdef SHORTWAVE_HEATING
c$$$         CALL DIAGNOSTICS_FILL(swflux, 'LAKEICEswnet',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_ATM_WIND
c$$$         CALL DIAGNOSTICS_FILL(uwind,  'LAKEICEuwind',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(vwind,  'LAKEICEvwind',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_ATM_TEMP
c$$$         CALL DIAGNOSTICS_FILL(atemp,  'LAKEICEatemp',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(aqh,    'LAKEICEaqh  ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hs    , 'LAKEICEhs   ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(hl    , 'LAKEICEhl   ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(lwflux, 'LAKEICElwnet',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(precip, 'LAKEICEpreci',0,1,0,1,1,myThid)
c$$$#endif
c$$$#if (defined (ALLOW_ATM_TEMP) || defined (LAKEICE_READ_EVAP))
c$$$         CALL DIAGNOSTICS_FILL(evap,   'LAKEICEevap ',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$         CALL DIAGNOSTICS_FILL(lwdown, 'LAKEICElwdn ',0,1,0,1,1,myThid)
c$$$         CALL DIAGNOSTICS_FILL(swdown, 'LAKEICEswdn ',0,1,0,1,1,myThid)
c$$$#endif
c$$$#ifdef ATMOSPHERIC_LOADING
c$$$         CALL DIAGNOSTICS_FILL(apressure,'LAKEICEpress',0,1,0,1,1,myThid)
c$$$#endif
c
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

      end
