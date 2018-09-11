c $Header: /u/gcmpack/MITgcm/pkg/exf/exf_check.F,v 1.2 2006/01/02 21:17:02 heimbach Exp $

#include "LAKEICE_OPTIONS.h"

      subroutine lakeice_check( mythid )

c     ==================================================================
c     SUBROUTINE lakeice_check
c     ==================================================================
c
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "FFIELDS.h"
#include "GRID.h"

#include "lakeice_param.h"
#include "lakeice_fields.h"
C#include "exf_constants.h"
C#include "exf_fields.h"
C#include "exf_clim_fields.h"
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
     &     (lakeice_iprec .EQ. 32 .OR. lakeice_iprec .EQ. 64)
     &     ) then
         stop 'stop in exf_readparms: value of exf_iprec not allowed'
      else if (.NOT. 
     &        (lakeice_yftype .EQ. 'RS' .OR. 
     &         lakeice_yftype .EQ. 'RL')
     &        ) then
         stop 'stop in exf_readparms: value of exf_yftype not allowed'
      end if

c$$$      if ( useCubedSphereExchange ) then
c$$$cph         if ( uvecfile .NE. ' ' .and. vvecfile .NE. ' ' ) then
c$$$c     some restrictions that can be relaxed later on
c$$$cph            if ( uvecstartdate .ne. vvecstartdate .or.
c$$$cph     &           uvecperiod    .ne. vvecperiod ) then
c$$$cph               print*,'For useCubedSphereExchange, S/R exf_set_uv.F'
c$$$cph               print*,'assumes that the u and v wind or wind stress'
c$$$cph               print*,'files have the same startdate and period.'
c$$$cph               stop
c$$$cph            endif
c$$$cph         endif
c$$$      endif
c$$$
c$$$#ifdef ALLOW_CLIMTEMP_RELAXATION
c$$$      STOP 'ALLOW_CLIMTEMP_RELAXATION no longer supported. Use pkg/rbcs'
c$$$#endif
c$$$
c$$$
c$$$#ifdef ALLOW_CLIMSALT_RELAXATION
c$$$      STOP 'ALLOW_CLIMSALT_RELAXATION no longer supported. Use pkg/rbcs'
c$$$#endif
      return
      end
