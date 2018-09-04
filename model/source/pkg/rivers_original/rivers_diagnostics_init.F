C $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_diagnostics_init.F,v 1.2 2005/06/28 22:05:49 heimbach Exp $
C $Name:  $

#include "RIVERS_OPTIONS.h"

CBOP
C     !ROUTINE: RIVERS_DIAGNOSTICS_INIT
C     !INTERFACE:
      SUBROUTINE RIVERS_DIAGNOSTICS_INIT( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE RIVERS_DIAGNOSTICS_INIT
C     | o Routine to initialize list of all available diagnostics
C     |   for RIVERS package
C     *==========================================================*
C     \ev
C     !USES:
      IMPLICIT NONE

C     === Global variables ===
#include "EEPARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid ::  my Thread Id number
      INTEGER myThid
CEOP

#ifdef ALLOW_DIAGNOSTICS
C     !LOCAL VARIABLES:
C     === Local variables ===
C     diagNum   :: diagnostics number in the (long) list of available diag.
C     diagName  :: local short name (8c) of a diagnostics
C     diagCode  :: local parser field with characteristics of the diagnostics
C              cf head of S/R DIAGNOSTICS_INIT_EARLY or DIAGNOSTICS_MAIN_INIT
C     diagUnits :: local string (16c): physical units of a diagnostic field
C     diagTitle :: local string (80c): description of field in diagnostic
      INTEGER       diagNum
      CHARACTER*8   diagName
      CHARACTER*16  diagCode
      CHARACTER*16  diagUnits
      CHARACTER*(80) diagTitle

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

      diagName  = 'RIVERflo   '
      diagTitle = 'River Flow '
      diagUnits = 'm^3/sec    '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )

      diagName  = 'RIVERalk   '
      diagTitle = 'River ALK  '
      diagUnits = 'mol/m3     '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )

      diagName  = 'RIVERdic   '
      diagTitle = 'River DIC  '
      diagUnits = 'mol/m3     '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )

      diagName  = 'RIVERdoc   '
      diagTitle = 'River DOC  '
      diagUnits = 'mol/m3     '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )
#endif /* ALLOW_DIAGNOSTICS */

      RETURN
      END
