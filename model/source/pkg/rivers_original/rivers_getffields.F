C $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_getffields.F,v 1.31 2006/03/02 15:30:10 heimbach Exp $
C $Name:  $

#include "RIVERS_OPTIONS.h"
c$$$
      subroutine rivers_getffields( mytime, myiter, mythid )

c     ==================================================================
c     SUBROUTINE rivers_getffields
c     ==================================================================
c
c     o Read-in river flows from files.
c     Val Bennington Feb 2010
c     ==================================================================
c     SUBROUTINE rivers_getffields
c     ==================================================================

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
      integer myiter
      _RL     mytime

c     == local variables ==

      integer i, j, bi, bj, interp_method
      parameter(interp_method=1)

c     == end of interface ==

c--   read forcing fields from files and temporal interpolation

      call rivers_set_gen  ( 
     &     rivflowfile, rivflowstartdate, rivflowperiod, 
     &     rivflowstartdate1, rivflowstartdate2,
     &     rivers_inscal_rivflow,
     &     rivflow_riversremo_intercept, rivflow_riversremo_slope,
     &     rivflow, rivflow0, rivflow1, rivflowmask, 
#ifdef USE_RIVERS_INTERPOLATION
     &     rivflow_lon0, rivflow_lon_inc, rivflow_lat0, rivflow_lat_inc,
     &     rivflow_nlon, rivflow_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )

      call rivers_set_gen  (
     &     rivalkfile, rivalkstartdate, rivalkperiod, 
     &     rivalkstartdate1, rivalkstartdate2,
     &     rivers_inscal_rivalk,
     &     rivalk_riversremo_intercept, rivalk_riversremo_slope,
     &     rivalk, rivalk0, rivalk1, rivalkmask, 
#ifdef USE_RIVERS_INTERPOLATION
     &     rivalk_lon0, rivalk_lon_inc, rivalk_lat0, rivalk_lat_inc,
     &     rivalk_nlon, rivalk_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )

      call rivers_set_gen  (
     &     rivdicfile, rivdicstartdate, rivdicperiod, 
     &     rivdicstartdate1, rivdicstartdate2,
     &     rivers_inscal_rivdic,
     &     rivdic_riversremo_intercept, rivdic_riversremo_slope,
     &     rivdic, rivdic0, rivdic1, rivdicmask, 
#ifdef USE_RIVERS_INTERPOLATION
     &     rivdic_lon0, rivdic_lon_inc, rivdic_lat0, rivdic_lat_inc,
     &     rivdic_nlon, rivdic_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )

      call rivers_set_gen  ( 
     &     rivdocfile, rivdocstartdate, rivdocperiod, 
     &     rivdocstartdate1, rivdocstartdate2,
     &     rivers_inscal_rivdoc,
     &     rivdoc_riversremo_intercept, rivdoc_riversremo_slope,
     &     rivdoc, rivdoc0, rivdoc1, rivdocmask, 
#ifdef USE_RIVERS_INTERPOLATION
     &     rivdoc_lon0, rivdoc_lon_inc, rivdoc_lat0, rivdoc_lat_inc,
     &     rivdoc_nlon, rivdoc_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )

      return
      end
