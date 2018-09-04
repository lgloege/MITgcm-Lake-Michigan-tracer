C $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_diagnostics_init.F,v 1.2 2005/06/28 22:05:49 heimbach Exp $
C $Name:  $

#include "LAKEICE_OPTIONS.h"

CBOP
C     !ROUTINE: LAKEICE_DIAGNOSTICS_INIT
C     !INTERFACE:
      SUBROUTINE LAKEICE_DIAGNOSTICS_INIT( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE LAKEICE_DIAGNOSTICS_INIT
C     | o Routine to initialize list of all available diagnostics
C     |   for LAKEICE package
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

C      diagName  = 'LAKEicefrac   '
      diagName  = 'LAKEicef   '
      diagTitle = 'Ice fraction  '
      diagUnits = 'No-unit           '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )

c$$$  modified Val Bennington Jan 2008     
C      diagName  = 'LAKEicefrac   '
      diagName  = 'ICElat   '
      diagTitle = 'Ice latent heat'
      diagUnits = 'W/m2              '
      diagCode  = 'SM      U1      '
      CALL DIAGNOSTICS_ADD2LIST( diagNum,
     I     diagName, diagCode, diagUnits, diagTitle, myThid )     
c$$$  modified Val Bennington May 2008     
c      diagName  = 'SWice    '
c      diagTitle = 'shortwave after ice'
c      diagUnits = 'W/m2              '
c      diagCode  = 'SM      U1      '
c      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c     I     diagName, diagCode, diagUnits, diagTitle, myThid )     

c$$$      diagName  = 'LAKEICEhs   '
c$$$      diagTitle = 'Sensible heat flux into ocean, >0 increases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEhl   '
c$$$      diagTitle = 'Latent heat flux into ocean, >0 increases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICElwnet'
c$$$      diagTitle = 'Net upward longwave radiation, >0 decreases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$      
c$$$      diagName  = 'LAKEICEswnet'
c$$$      diagTitle = 'Net upward shortwave radiation, >0 decreases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$      
c$$$      diagName  = 'LAKEICElwdn '
c$$$      diagTitle = 'Downward longwave radiation, >0 increases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$      
c$$$      diagName  = 'LAKEICEswdn '
c$$$      diagTitle = 'Downward shortwave radiation, >0 increases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEqnet '
c$$$      diagTitle = 'Net upward heat flux (turb+rad), >0 decreases theta'
c$$$      diagUnits = 'W/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$      
c$$$C--   surface fluxes:
c$$$      diagName  = 'LAKEICEtaux '
c$$$      diagTitle = 'zonal surface wind stress, >0 increases uVel    '
c$$$      diagUnits = 'N/m^2           '
c$$$      diagCode  = 'SU      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEtauy '
c$$$      diagTitle = 'meridional surface wind stress, >0 increases vVel'
c$$$      diagUnits = 'N/m^2           '
c$$$      diagCode  = 'SV      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEuwind'
c$$$      diagTitle = 'zonal 10-m wind speed, >0 increases uVel'
c$$$      diagUnits = 'm/s             '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I     diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEvwind'
c$$$      diagTitle = 'meridional 10-m wind speed, >0 increases uVel'
c$$$      diagUnits = 'm/s             '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEatemp'
c$$$      diagTitle = 'surface (2-m) air temperature'
c$$$      diagUnits = 'degK            '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEaqh  '
c$$$      diagTitle = 'surface (2-m) specific humidity'
c$$$      diagUnits = 'kg/kg           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEevap '
c$$$      diagTitle = 'evaporation, > 0 increases salinity'
c$$$      diagUnits = 'm/s             '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEpreci'
c$$$      diagTitle = 'evaporation, > 0 decreases salinity'
c$$$      diagUnits = 'm/s             '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEempmr'
c$$$      diagTitle = 'net upward freshwater flux, > 0 increases salinity'
c$$$      diagUnits = 'm/s             '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )
c$$$
c$$$      diagName  = 'LAKEICEpress'
c$$$      diagTitle = 'atmospheric pressure field'
c$$$      diagUnits = 'N/m^2           '
c$$$      diagCode  = 'SM      U1      '
c$$$      CALL DIAGNOSTICS_ADD2LIST( diagNum,
c$$$     I          diagName, diagCode, diagUnits, diagTitle, myThid )


#endif /* ALLOW_DIAGNOSTICS */

      RETURN
      END
