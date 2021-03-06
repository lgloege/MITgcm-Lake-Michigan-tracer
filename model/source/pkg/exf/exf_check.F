c $Header: /u/gcmpack/MITgcm/pkg/exf/exf_check.F,v 1.2 2006/01/02 21:17:02 heimbach Exp $

#include "EXF_OPTIONS.h"

      subroutine exf_check( mythid )

c     ==================================================================
c     SUBROUTINE exf_check
c     ==================================================================
c
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "FFIELDS.h"
#include "GRID.h"

#include "exf_param.h"
#include "exf_constants.h"
#include "exf_fields.h"
#include "exf_clim_fields.h"
c     == routine arguments ==

c     mythid - thread number for this instance of the routine.

      integer mythid

c     == local variables ==

      integer bi,bj
      integer i,j
      integer jtlo
      integer jthi
      integer itlo
      integer ithi
      integer jmin
      integer jmax
      integer imin
      integer imax

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1-oly
      jmax = sny+oly
      imin = 1-olx
      imax = snx+olx

c     check for consistency
      if (.NOT. 
     &     (exf_iprec .EQ. 32 .OR. exf_iprec .EQ. 64)
     &     ) then
         stop 'stop in exf_readparms: value of exf_iprec not allowed'
      else if (.NOT. 
     &        (exf_yftype .EQ. 'RS' .OR. 
     &        exf_yftype .EQ. 'RL')
     &        ) then
         stop 'stop in exf_readparms: value of exf_yftype not allowed'
      end if

      if ( useCubedSphereExchange ) then
cph         if ( uvecfile .NE. ' ' .and. vvecfile .NE. ' ' ) then
c     some restrictions that can be relaxed later on
cph            if ( uvecstartdate .ne. vvecstartdate .or.
cph     &           uvecperiod    .ne. vvecperiod ) then
cph               print*,'For useCubedSphereExchange, S/R exf_set_uv.F'
cph               print*,'assumes that the u and v wind or wind stress'
cph               print*,'files have the same startdate and period.'
cph               stop
cph            endif
cph         endif
      endif

#ifdef ALLOW_CLIMTEMP_RELAXATION
      STOP 'ALLOW_CLIMTEMP_RELAXATION no longer supported. Use pkg/rbcs'
#endif


#ifdef ALLOW_CLIMSALT_RELAXATION
      STOP 'ALLOW_CLIMSALT_RELAXATION no longer supported. Use pkg/rbcs'
#endif

      end
