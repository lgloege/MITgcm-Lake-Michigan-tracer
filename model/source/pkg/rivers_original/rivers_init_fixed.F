C $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_init_fixed.F,v 1.1 2005/05/05 16:41:54 dimitri Exp $
C $Name:  $

#include "RIVERS_OPTIONS.h"

CBOP
C     !ROUTINE: RIVERS_INIT_FIXED
C     !INTERFACE:
C      SUBROUTINE EXF_INIT_FIXED( myThid )
      SUBROUTINE RIVERS_INIT_FIXED( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE RIVERS_INIT_FIXED
C     | o Routine to initialize GM/Redi variables 
C     |   that are kept fixed during the run.
C     *==========================================================*
C     \ev
C     !USES:
      IMPLICIT NONE

C     === Global variables ===
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"

C     !INPUT/OUTPUT PARAMETERS:
C     === Routine arguments ===
C     myThid ::  my Thread Id number
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
C     === Local variables ===

#ifdef ALLOW_DIAGNOSTICS
      IF ( useDiagnostics ) THEN
C        CALL EXF_DIAGNOSTICS_INIT( myThid )
        CALL RIVERS_DIAGNOSTICS_INIT( myThid )
      ENDIF
#endif

      RETURN
      END
