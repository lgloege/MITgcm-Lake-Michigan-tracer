c $Header: /u/gcmpack/MITgcm/pkg/rivers/rivers_init.F,v 1.9 2004/07/02 00:48:23 heimbach Exp $

#include "RIVERS_OPTIONS.h"

C      subroutine exf_init( mythid )
      subroutine rivers_init( mythid )

c     ==================================================================
c     SUBROUTINE rivers_init
c     ==================================================================
c
c     o This routine initialises the forcing
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-20000
c     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     SUBROUTINE rivers_init
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

C Luke added ptracers
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"

#include "cal.h"
C#include "rivers.h"
#include "rivers_param.h"
#include "rivers_fields.h"
C#include "exf.h"
C#include "exf_param.h"
C#include "exf_fields.h"

c     == routine arguments ==

      integer mythid
      integer iTracer

c     == local variables ==

c     == end of interface ==

C     initialzation of river mask 
      DO iTracer = 1, PTRACERS_num 
          call rivers_init_gen (
     &        rivflowconst, 
     &        rivflow(:,:,:,:,iTracer), 
     &        rivflow0(:,:,:,:,iTracer), 
     &        rivflow1(:,:,:,:,iTracer), mythid )
      enddo
c      call rivers_init_gen (
c     &     rivalkconst, rivalk, rivalk0, rivalk1, mythid )
c      call rivers_init_gen (
c     &     rivdicconst, rivdic, rivdic0, rivdic1, mythid )
c      call rivers_init_gen (
c     &     rivdocconst, rivdoc, rivdoc0, rivdoc1, mythid )
c
      return
      end
