C $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_getffields.F,v 1.31 2006/03/02 15:30:10 heimbach Exp $
C $Name:  $

#include "LAKEICE_OPTIONS.h"
c$$$
      subroutine lakeice_getffields( mytime, myiter, mythid )

c     ==================================================================
c     SUBROUTINE lakeice_getffields
c     ==================================================================
c
c     o Read-in atmospheric state and/or surface fluxes from files.
c
c       heimbach@mit.edu, 23-May-2003 totally re-structured
c       5-Aug-2003: added USE_LAKEICE_INTERPOLATION for arbitrary input grid
c
c     ==================================================================
c     SUBROUTINE lakeice_getffields
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"

#include "lakeice_param.h"
#include "lakeice_fields.h"
c$$$#include "exf_param.h"
c$$$#include "exf_fields.h"
c$$$#include "exf_constants.h"

c$$$#ifdef ALLOW_AUTODIFF
c$$$# include "ctrl.h"
c$$$# include "ctrl_dummy.h"
c$$$#endif

c     == routine arguments ==

      integer mythid
      integer myiter
      _RL     mytime

c     == local variables ==

      integer i, j, bi, bj, interp_method
      parameter(interp_method=1)

c     == end of interface ==

c--   read forcing fields from files and temporal interpolation

c$$$c     Zonal and meridional wind stress.
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$      call exf_set_uv(
c$$$     &     ustressfile, ustressstartdate, ustressperiod,
c$$$     &     ustressstartdate1, ustressstartdate2,
c$$$     &     exf_inscal_ustress, ustress, ustress0, ustress1, ustressmask,
c$$$     &     ustress_lon0, ustress_lon_inc, ustress_lat0, ustress_lat_inc,
c$$$     &     ustress_nlon, ustress_nlat,
c$$$     &     ustress_exfremo_intercept, ustress_exfremo_slope,
c$$$     &     vstressfile, vstressstartdate, vstressperiod,
c$$$     &     vstressstartdate1, vstressstartdate2,
c$$$     &     exf_inscal_vstress, vstress, vstress0, vstress1, vstressmask,
c$$$     &     vstress_lon0, vstress_lon_inc, vstress_lat0, vstress_lat_inc,
c$$$     &     vstress_nlon, vstress_nlat,
c$$$     &     vstress_exfremo_intercept, vstress_exfremo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#else /* ifndef USE_EXF_INTERPOLATION */
c$$$      call exf_set_gen( 
c$$$     &     ustressfile, ustressstartdate, ustressperiod,
c$$$     &     ustressstartdate1, ustressstartdate2,
c$$$     &     exf_inscal_ustress,
c$$$     &     ustress_exfremo_intercept, ustress_exfremo_slope,
c$$$     &     ustress, ustress0, ustress1, ustressmask,
c$$$     &     mytime, myiter, mythid )
c$$$      call exf_set_gen(
c$$$     &     vstressfile, vstressstartdate, vstressperiod,
c$$$     &     ustressstartdate1, ustressstartdate2,
c$$$     &     exf_inscal_vstress,
c$$$     &     vstress_exfremo_intercept, vstress_exfremo_slope,
c$$$     &     vstress, vstress0, vstress1, vstressmask,
c$$$     &     mytime, myiter, mythid )
c$$$#endif /* USE_EXF_INTERPOLATION */
c$$$
c$$$#ifdef ALLOW_ATM_WIND

c$$$c     Zonal and meridional wind.
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$      call exf_set_uv(
c$$$     &     uwindfile, uwindstartdate, uwindperiod,
c$$$     &     uwindstartdate1, uwindstartdate2,
c$$$     &     exf_inscal_uwind, uwind, uwind0, uwind1, uwindmask,
c$$$     &     uwind_lon0, uwind_lon_inc, uwind_lat0, uwind_lat_inc,
c$$$     &     uwind_nlon, uwind_nlat,
c$$$     &     uwind_exfremo_intercept, uwind_exfremo_slope,
c$$$     &     vwindfile, vwindstartdate, vwindperiod,
c$$$     &     vwindstartdate1, vwindstartdate2,
c$$$     &     exf_inscal_vwind, vwind, vwind0, vwind1, vwindmask,
c$$$     &     vwind_lon0, vwind_lon_inc, vwind_lat0, vwind_lat_inc,
c$$$     &     vwind_nlon, vwind_nlat,
c$$$     &     vwind_exfremo_intercept, vwind_exfremo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#else /* ifndef USE_EXF_INTERPOLATION */
c$$$      call exf_set_gen(
c$$$     &     uwindfile, uwindstartdate, uwindperiod,
c$$$     &     uwindstartdate1, uwindstartdate2,
c$$$     &     exf_inscal_uwind,
c$$$     &     uwind_exfremo_intercept, uwind_exfremo_slope,
c$$$     &     uwind, uwind0, uwind1, uwindmask,
c$$$     &     mytime, myiter, mythid )
c$$$      call exf_set_gen(
c$$$     &     vwindfile, vwindstartdate, vwindperiod,
c$$$     &     vwindstartdate1, vwindstartdate2,
c$$$     &     exf_inscal_vwind,
c$$$     &     vwind_exfremo_intercept, vwind_exfremo_slope,
c$$$     &     vwind, vwind0, vwind1, vwindmask,
c$$$     &     mytime, myiter, mythid )
c$$$#endif /* USE_EXF_INTERPOLATION */
c$$$
c$$$#endif /* ALLOW_ATM_WIND */

C     call exf_set_gen  ( 
c     ice mask data for physical process
      call lakeice_set_gen  ( 
     &     icefracfile, icefracstartdate, icefracperiod, 
     &     icefracstartdate1, icefracstartdate2,
     &     lakeice_inscal_icefrac,
     &     icefrac_lakeiceremo_intercept, icefrac_lakeiceremo_slope,
     &     icefrac, icefrac0, icefrac1, icefracmask, 
#ifdef USE_LAKEICE_INTERPOLATION
     &     icefrac_lon0, icefrac_lon_inc, icefrac_lat0, icefrac_lat_inc,
     &     icefrac_nlon, icefrac_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )


c$$$     added by Val Bennington Jan 2008:
c$$$ 	  allows for file of latent heat due to ice melt/formation
C     call exf_set_gen  ( 
c     ice latent heat data for physical process
#ifdef ALLOW_ICELATENT
      call lakeice_set_gen  ( 
     &     icelatentfile, icelatentstartdate, icelatentperiod, 
     &     icelatentstartdate1, icelatentstartdate2,
     &     lakeice_inscal_icelatent,
     &     icelatent_lakeiceremo_intercept, icelatent_lakeiceremo_slope,
     &     icelatent, icelatent0, icelatent1, icelatentmask, 
#ifdef USE_LAKEICE_INTERPOLATION
     &     icelatent_lon0, icelatent_lon_inc, icelatent_lat0, 
     &     icelatent_lat_inc,
     &     icelatent_nlon, icelatent_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )
#endif /* ALLOW_ICELATENT */  


c$$$      write(6,*) 'in lakeice_getffields.F icefrac=',icefrac

c$$$c     Salt flux.
c$$$      call exf_set_gen  ( 
c$$$     &     sfluxfile, sfluxstartdate, sfluxperiod, 
c$$$     &     sfluxstartdate1, sfluxstartdate2,
c$$$     &     exf_inscal_sflux,
c$$$     &     sflux_exfremo_intercept, sflux_exfremo_slope,
c$$$     &     sflux, sflux0, sflux1, sfluxmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     sflux_lon0, sflux_lon_inc, sflux_lat0, sflux_lat_inc,
c$$$     &     sflux_nlon, sflux_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$
c$$$#ifdef ALLOW_ATM_TEMP

c$$$c     Atmospheric temperature.
c$$$      call exf_set_gen( 
c$$$     &     atempfile, atempstartdate, atempperiod, 
c$$$     &     atempstartdate1, atempstartdate2,
c$$$     &     exf_inscal_atemp,
c$$$     &     atemp_exfremo_intercept, atemp_exfremo_slope,
c$$$     &     atemp, atemp0, atemp1, atempmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     atemp_lon0, atemp_lon_inc, atemp_lat0, atemp_lat_inc,
c$$$     &     atemp_nlon, atemp_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$      do bj = mybylo(mythid),mybyhi(mythid)
c$$$       do bi = mybxlo(mythid),mybxhi(mythid)
c$$$        do j = 1,sny
c$$$         do i = 1,snx
c$$$          atemp(i,j,bi,bj) = atemp(i,j,bi,bj) + exf_offset_atemp
c$$$         enddo
c$$$        enddo
c$$$       enddo
c$$$      enddo

c$$$c     Atmospheric humidity.
c$$$      call exf_set_gen( 
c$$$     &     aqhfile, aqhstartdate, aqhperiod, 
c$$$     &     aqhstartdate1, aqhstartdate2,
c$$$     &     exf_inscal_aqh,
c$$$     &     aqh_exfremo_intercept, aqh_exfremo_slope,
c$$$     &     aqh, aqh0, aqh1, aqhmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     aqh_lon0, aqh_lon_inc, aqh_lat0, aqh_lat_inc,
c$$$     &     aqh_nlon, aqh_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )

c$$$c     Net long wave radiative flux.
c$$$      call exf_set_gen( 
c$$$     &     lwfluxfile, lwfluxstartdate, lwfluxperiod, 
c$$$     &     lwfluxstartdate1, lwfluxstartdate2,
c$$$     &     exf_inscal_lwflux,
c$$$     &     lwflux_exfremo_intercept, lwflux_exfremo_slope,
c$$$     &     lwflux, lwflux0, lwflux1, lwfluxmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     lwflux_lon0, lwflux_lon_inc, lwflux_lat0, lwflux_lat_inc,
c$$$     &     lwflux_nlon, lwflux_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )

c$$$c     Precipitation.
c$$$      call exf_set_gen( 
c$$$     &     precipfile, precipstartdate, precipperiod, 
c$$$     &     precipstartdate1, precipstartdate2,
c$$$     &     exf_inscal_precip,
c$$$     &     precip_exfremo_intercept, precip_exfremo_slope,
c$$$     &     precip, precip0, precip1, precipmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     precip_lon0, precip_lon_inc, precip_lat0, precip_lat_inc,
c$$$     &     precip_nlon, precip_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$
c$$$#endif /* ALLOW_ATM_TEMP */

c$$$#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
c$$$c     Net short wave radiative flux.
c$$$      call exf_set_gen  ( 
c$$$     &     swfluxfile, swfluxstartdate, swfluxperiod, 
c$$$     &     swfluxstartdate1, swfluxstartdate2,
c$$$     &     exf_inscal_swflux,
c$$$     &     swflux_exfremo_intercept, swflux_exfremo_slope,
c$$$     &     swflux, swflux0, swflux1, swfluxmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     swflux_lon0, swflux_lon_inc, swflux_lat0, swflux_lat_inc,
c$$$     &     swflux_nlon, swflux_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef EXF_READ_EVAP
c$$$c     Evaporation
c$$$      call exf_set_gen  ( 
c$$$     &     evapfile, evapstartdate, evapperiod, 
c$$$     &     evapstartdate1, evapstartdate2,
c$$$     &     exf_inscal_evap,
c$$$     &     evap_exfremo_intercept, evap_exfremo_slope,
c$$$     &     evap, evap0, evap1, evapmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     evap_lon0, evap_lon_inc, evap_lat0, evap_lat_inc,
c$$$     &     evap_nlon, evap_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$
c$$$c     Downward shortwave radiation.
c$$$      call exf_set_gen  ( 
c$$$     &     swdownfile, swdownstartdate, swdownperiod, 
c$$$     &     swdownstartdate1, swdownstartdate2,
c$$$     &     exf_inscal_swdown,
c$$$     &     swdown_exfremo_intercept, swdown_exfremo_slope,
c$$$     &     swdown, swdown0, swdown1, swdownmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     swdown_lon0, swdown_lon_inc, swdown_lat0, swdown_lat_inc,
c$$$     &     swdown_nlon, swdown_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )

c$$$c     Downward longwave radiation.
c$$$      call exf_set_gen  ( 
c$$$     &     lwdownfile, lwdownstartdate, lwdownperiod, 
c$$$     &     lwdownstartdate1, lwdownstartdate2,
c$$$     &     exf_inscal_lwdown,
c$$$     &     lwdown_exfremo_intercept, lwdown_exfremo_slope,
c$$$     &     lwdown, lwdown0, lwdown1, lwdownmask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     lwdown_lon0, lwdown_lon_inc, lwdown_lat0, lwdown_lat_inc,
c$$$     &     lwdown_nlon, lwdown_nlat, xC, yC, interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$
c$$$#endif

c$$$#ifdef ATMOSPHERIC_LOADING
c$$$c     Atmos. pressure forcing
c$$$      call exf_set_gen  ( 
c$$$     &     apressurefile, apressurestartdate, apressureperiod, 
c$$$     &     apressurestartdate1, apressurestartdate2,
c$$$     &     exf_inscal_apressure,
c$$$     &     apressure_exfremo_intercept, apressure_exfremo_slope,
c$$$     &     apressure, apressure0, apressure1, apressuremask, 
c$$$#ifdef USE_EXF_INTERPOLATION
c$$$     &     apressure_lon0, apressure_lon_inc, apressure_lat0,
c$$$     &     apressure_lat_inc, apressure_nlon, apressure_nlat, xC, yC,
c$$$     &     interp_method,
c$$$#endif
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$c-- Control variables for atmos. state
c$$$
c$$$#ifdef ALLOW_ATEMP_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$     &     xx_atemp_file, xx_atempstartdate, xx_atempperiod,
c$$$     &     maskc, atemp, xx_atemp0, xx_atemp1, xx_atemp_dummy,
c$$$     &     xx_atemp_remo_intercept, xx_atemp_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_AQH_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$     &     xx_aqh_file, xx_aqhstartdate, xx_aqhperiod,
c$$$     &     maskc, aqh, xx_aqh0, xx_aqh1, xx_aqh_dummy,
c$$$     &     xx_aqh_remo_intercept, xx_aqh_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_PRECIP_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$     &     xx_precip_file, xx_precipstartdate, xx_precipperiod,
c$$$     &     maskc, precip, xx_precip0, xx_precip1, xx_precip_dummy,
c$$$     &     xx_precip_remo_intercept, xx_precip_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_SWFLUX_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$     &     xx_swflux_file, xx_swfluxstartdate, xx_swfluxperiod,
c$$$     &     maskc, swflux, xx_swflux0, xx_swflux1, xx_swflux_dummy,
c$$$     &     xx_swflux_remo_intercept, xx_swflux_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_SWDOWN_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$     &     xx_swdown_file, xx_swdownstartdate, xx_swdownperiod,
c$$$     &     maskc, swdown, xx_swdown0, xx_swdown1, xx_swdown_dummy,
c$$$     &     xx_swdown_remo_intercept, xx_swdown_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif

c$$$#ifdef ALLOW_UWIND_CONTROL
c$$$      call ctrl_get_gen (
c$$$     &     xx_uwind_file, xx_uwindstartdate, xx_uwindperiod,
c$$$     &     maskc, uwind, xx_uwind0, xx_uwind1, xx_uwind_dummy,
c$$$     &     xx_uwind_remo_intercept, xx_uwind_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif /* ALLOW_UWIND_CONTROL */

c$$$#ifdef ALLOW_VWIND_CONTROL
c$$$      call ctrl_get_gen (
c$$$     &     xx_vwind_file, xx_vwindstartdate, xx_vwindperiod,
c$$$     &     maskc, vwind, xx_vwind0, xx_vwind1, xx_vwind_dummy,
c$$$     &     xx_vwind_remo_intercept, xx_vwind_remo_slope,
c$$$     &     mytime, myiter, mythid )
c$$$#endif /* ALLOW_VWIND_CONTROL */

c$$$#ifdef ALLOW_LWFLUX_CONTROL
c$$$      call ctrl_get_gen ( 
c$$$NOT YET IMPLEMENTED
c$$$     &     mytime, myiter, mythid )
c$$$#endif

      return
      end
