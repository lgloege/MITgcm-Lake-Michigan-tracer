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

c     == routine arguments ==

      integer mythid
      integer mycurrentiter
      _RL     mycurrenttime

c     == local variables ==

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
c
         CALL DIAGNOSTICS_FILL(rivflow,'RIVERflo',0,1,0,1,1,myThid)
         CALL DIAGNOSTICS_FILL(rivalk,'RIVERalk',0,1,0,1,1,myThid)
         CALL DIAGNOSTICS_FILL(rivdic,'RIVERdic',0,1,0,1,1,myThid)
         CALL DIAGNOSTICS_FILL(rivdoc,'RIVERdoc',0,1,0,1,1,myThid)
c
      ENDIF
#endif /* ALLOW_DIAGNOSTICS */

      end
