c $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_init.F,v 1.9 2004/07/02 00:48:23 heimbach Exp $

#include "LAKEICE_OPTIONS.h"


C      subroutine exf_init( mythid )
      subroutine lakeice_init( mythid )

c     ==================================================================
c     SUBROUTINE lakeice_init
c     ==================================================================
c
c     o This routine initialises the forcing
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-20000
c     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     SUBROUTINE lakeice_init
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "cal.h"
C#include "lakeice.h"
#include "lakeice_param.h"
#include "lakeice_fields.h"
C#include "exf.h"
C#include "exf_param.h"
C#include "exf_fields.h"

c     == routine arguments ==

      integer mythid

c     == local variables ==

c     == end of interface ==

C     initialzation of ice mask
      call lakeice_init_gen (
     &     icefracconst, icefrac, icefrac0, icefrac1, mythid )
     

C modified by Val Bennington Jan 2008
C use if applying file with heat from latent ice melt/formation
#ifdef ALLOW_ICELATENT 
      call lakeice_init_gen (
     &     icelatentconst, icelatent, icelatent0, icelatent1, mythid )
#endif /* ALLOW_ICELATENT */


c$$$      call exf_init_gen (
c$$$     &     ustressconst, ustress, ustress0, ustress1, mythid )
c$$$      call exf_init_gen (
c$$$     &     vstressconst, vstress, vstress0, vstress1, mythid )
c$$$
c$$$#ifdef ALLOW_ATM_WIND 
c$$$      call exf_init_gen (
c$$$     &     uwindconst, uwind, uwind0, uwind1, mythid )
c$$$      call exf_init_gen (
c$$$     &     vwindconst, vwind, vwind0, vwind1, mythid )
c$$$#endif
c$$$
c$$$      call exf_init_gen (
c$$$     &     hfluxconst, hflux, hflux0, hflux1, mythid )
c$$$      call exf_init_gen (
c$$$     &     sfluxconst, sflux, sflux0, sflux1, mythid )
c$$$
c$$$#ifdef ALLOW_ATM_TEMP
c$$$      call exf_init_gen (
c$$$     &     atempconst, atemp, atemp0, atemp1, mythid )
c$$$      call exf_init_gen (
c$$$     &     aqhconst, aqh, aqh0, aqh1, mythid )
c$$$      call exf_init_gen (
c$$$     &     lwfluxconst, lwflux, lwflux0, lwflux1, mythid )
c$$$      call exf_init_gen (
c$$$     &     precipconst, precip, precip0, precip1, mythid )
c$$$#endif
c$$$
c$$$#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
c$$$      call exf_init_gen (
c$$$     &     swfluxconst, swflux, swflux0, swflux1, mythid )
c$$$#endif
c$$$
c$$$#if defined(ALLOW_ATM_TEMP) || defined(EXF_READ_EVAP)
c$$$      call exf_init_gen (
c$$$     &     evapconst, evap, evap0, evap1, mythid )
c$$$#endif
c$$$
c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$      call exf_init_gen (
c$$$     &     swdownconst, swdown, swdown0, swdown1, mythid )
c$$$      call exf_init_gen (
c$$$     &     lwdownconst, lwdown, lwdown0, lwdown1, mythid )
c$$$#endif
c$$$
c$$$#ifdef ATMOSPHERIC_LOADING
c$$$      call exf_init_gen (
c$$$     &     apressureconst, apressure, apressure0, apressure1, mythid )
c$$$#endif
c$$$
c$$$#if (defined (ALLOW_RUNOFF) || defined (ALLOW_SEAICE))
c$$$      call exf_init_runoff   ( mythid )
c$$$#endif
c$$$
c$$$c     Initialize climatological fields
c$$$      call exf_clim_init     ( mythid )
      return
      end
