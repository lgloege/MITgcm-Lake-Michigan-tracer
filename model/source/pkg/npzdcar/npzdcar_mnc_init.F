#include "GCHEM_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: NPZDCAR_MNC_INIT

C     !INTERFACE:
      SUBROUTINE NPZDCAR_MNC_INIT( myThid )

C     !DESCRIPTION:
C     Initialize MNC for NPZDCAR

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     !INPUT PARAMETERS:
C     myThid               :: thread number
      INTEGER myThid
CEOP

#ifdef ALLOW_NPZDCAR
#ifdef ALLOW_MNC

      IF ( useMNC ) THEN

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_phygrow1_ave', 'Cen_xy_Hn__C__t', 4,5, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_phygrow1_ave','units','mmol P/m^3/s', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_phygrow1_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_phygrow2_ave', 'Cen_xy_Hn__C__t', 4,5, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_phygrow2_ave','units','mmol P/m^3/s', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_phygrow2_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_zoograz_ave', 'Cen_xy_Hn__C__t', 4,5, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_zoograz_ave','units','mmol P/m^3/s', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_zoograz_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_par_ave', 'Cen_xy_Hn__C__t', 4,5, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_par_ave','units','W/m^2', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_par_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_chl_ave', 'Cen_xy_Hn__C__t', 4,5, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_chl_ave','units','mg Chl/m^3', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_chl_ave','description',
     &     '', myThid)


      CALL MNC_CW_ADD_VNAME(
     &     'npzd_flxCO2_ave', 'Cen_xy_Hn__-__t', 3,4, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_flxCO2_ave','units','mmol C/m2/s', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_flxCO2_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_flxO2_ave', 'Cen_xy_Hn__-__t', 3,4, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_flxO2_ave','units','mmol O/m2/s', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_flxO2_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_pH_ave', 'Cen_xy_Hn__-__t', 3,4, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_pH_ave','units','-', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_pH_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_pCO2_ave', 'Cen_xy_Hn__-__t', 3,4, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_pCO2_ave','units','-', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_pCO2_ave','description',
     &     '', myThid)

      CALL MNC_CW_ADD_VNAME(
     &     'npzd_virtCO2flux_ave', 'Cen_xy_Hn__-__t', 3,4, myThid)
      CALL MNC_CW_ADD_VATTR_TEXT(
     &     'npzd_virtCO2flux_ave','units','-', myThid)
      CALL MNC_CW_ADD_VATTR_TEXT('npzd_virtCO2flux_ave','description',
     &     '', myThid)


      ENDIF

#endif /* ALLOW_MNC */
#endif /* ALLOW_NPZDCAR */

      RETURN
      END
