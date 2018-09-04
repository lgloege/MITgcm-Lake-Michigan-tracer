c $Header: /u/gcmpack/MITgcm/pkg/exf/exf_check.F,v 1.2 2006/01/02 21:17:02 heimbach Exp $

#include "RIVERS_OPTIONS.h"

      subroutine rivers_check( mythid )

c     ==================================================================
c     SUBROUTINE rivers_check
c     ==================================================================
c
      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

C Luke added ptracers
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"

#include "PARAMS.h"
#include "FFIELDS.h"
#include "GRID.h"

#include "rivers_param.h"
#include "rivers_fields.h"
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
     &     (rivers_iprec .EQ. 32 .OR. rivers_iprec .EQ. 64)
     &     ) then
         stop 'stop (rivers) in rivers_readparms: value of rivers_iprec 
     &       not allowed'
      else if (.NOT. 
     &        (rivers_yftype .EQ. 'RS' .OR. 
     &         rivers_yftype .EQ. 'RL')
     &        ) then
         stop 'stop in (rivers) rivers_readparms: value of rivers_yftype 
     &        not allowed'
      end if

      return
      end
