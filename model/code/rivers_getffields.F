C $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_getffields.F,v 1.31 2006/03/02 15:30:10 heimbach Exp $
C $Name:  $
C Luke added: PTRACERS_OPTIONS.h, PTRACERS_SIZE.h, PTRACERS.h

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

C Luke added ptracers
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"

#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
C
#include "rivers_param.h"
#include "rivers_fields.h"

c     == routine arguments ==

      integer mythid
      integer myiter
      _RL     mytime

c     == local variables ==

      integer i, j, bi, bj, interp_method
      integer iTracer
      parameter(interp_method=1)

c     == end of interface ==

c--   read forcing fields from files and temporal interpolation
      DO iTracer = 1, PTRACERS_num
      call rivers_set_gen  ( 
     &     rivflowfile(iTracer), rivflowstartdate, rivflowperiod, 
     &     rivflowstartdate1, rivflowstartdate2,
     &     rivers_inscal_rivflow,
     &     rivflow_riversremo_intercept, rivflow_riversremo_slope,
     &     rivflow(:,:,:,:,iTracer), 
     &     rivflow0(:,:,:,:,iTracer), 
     &     rivflow1(:,:,:,:,iTracer), 
     &     rivflowmask, 
#ifdef USE_RIVERS_INTERPOLATION
     &     rivflow_lon0, rivflow_lon_inc, rivflow_lat0, rivflow_lat_inc,
     &     rivflow_nlon, rivflow_nlat, xC, yC, interp_method,
#endif
     &     mytime, myiter, mythid )
      ENDDO

c      call rivers_set_gen  (
c     &     rivalkfile, rivalkstartdate, rivalkperiod, 
c     &     rivalkstartdate1, rivalkstartdate2,
c     &     rivers_inscal_rivalk,
c     &     rivalk_riversremo_intercept, rivalk_riversremo_slope,
c     &     rivalk, rivalk0, rivalk1, rivalkmask, 
c#ifdef USE_RIVERS_INTERPOLATION
c     &     rivalk_lon0, rivalk_lon_inc, rivalk_lat0, rivalk_lat_inc,
c     &     rivalk_nlon, rivalk_nlat, xC, yC, interp_method,
c#endif
c     &     mytime, myiter, mythid )

c      call rivers_set_gen  (
c     &     rivdicfile, rivdicstartdate, rivdicperiod, 
c     &     rivdicstartdate1, rivdicstartdate2,
c     &     rivers_inscal_rivdic,
c     &     rivdic_riversremo_intercept, rivdic_riversremo_slope,
c     &     rivdic, rivdic0, rivdic1, rivdicmask, 
c#ifdef USE_RIVERS_INTERPOLATION
c     &     rivdic_lon0, rivdic_lon_inc, rivdic_lat0, rivdic_lat_inc,
c    &     rivdic_nlon, rivdic_nlat, xC, yC, interp_method,
c#endif
c     &     mytime, myiter, mythid )

c      call rivers_set_gen  ( 
c     &     rivdocfile, rivdocstartdate, rivdocperiod, 
c     &     rivdocstartdate1, rivdocstartdate2,
c     &     rivers_inscal_rivdoc,
c     &     rivdoc_riversremo_intercept, rivdoc_riversremo_slope,
c     &     rivdoc, rivdoc0, rivdoc1, rivdocmask, 
c#ifdef USE_RIVERS_INTERPOLATION
c     &     rivdoc_lon0, rivdoc_lon_inc, rivdoc_lat0, rivdoc_lat_inc,
c     &     rivdoc_nlon, rivdoc_nlat, xC, yC, interp_method,
c#endif
c     &     mytime, myiter, mythid )

      return
      end
