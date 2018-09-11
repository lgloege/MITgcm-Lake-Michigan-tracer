c $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_summary.F,v 1.7 2003/10/20 06:25:16 dimitri Exp $

#include "LAKEICE_OPTIONS.h"

      subroutine lakeice_Summary(
     I                        mythid
     &                      )

c     ==================================================================
c     SUBROUTINE lakeice_Summary
c     ==================================================================
c
c     o List all the settings of the external forcing.
c
c     started: Christian Eckert eckert@mit.edu 11-Jan-1999
c
c     changed: Christian Eckert eckert@mit.edu 12-Feb-2000
c              - changed routine names (package prefix: lakeice_)
c
c     changed: Patrick Heimbach heimbach@mit.edu 04-May-2000
c              - changed the handling of precip and sflux with respect
c                to CPP options ALLOW_BULKFORMULAE and ALLOW_ATM_TEMP
c
c     changed: Dimitris Menemenlis menemenlis@jpl.nasa.gov 20-Dec-2002
c              - modifications for using pkg/lakeice with pkg/seaice
c
c     ==================================================================
c     SUBROUTINE lakeice_Summary
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "cal.h"
#include "lakeice.h"
#include "lakeice_param.h"
C#include "exf.h"
C#include "exf_param.h"

c     == routine arguments ==

c     mythid  - thread number for this instance of the routine.

      integer mythid

c     == local variables ==

      integer il

      character*(max_len_mbuf) msgbuf

c     == external ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// External forcing configuration ICE-Phys >>> START <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a)')
     &'External forcing version: ',lakeiceexternalforcingversion
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a)')
     &'Uses Calendar version:    ',uselakeicescalendarversion
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)

c--   Print settings of some CPP flags.

#ifdef ALLOW_LAKEICE
      write(msgbuf,'(a)')
     &'// ALLOW_LAKEICE:                     defined'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#else
      write(msgbuf,'(a)')
     &'// ALLOW_LAKEICE:                 NOT defined'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif

c$$$ modified by Val Bennington Jan 2008
#ifdef ALLOW_ICELATENT
      write(msgbuf,'(a)')
     &'// ALLOW_ICELATENT:                     defined'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#else
      write(msgbuf,'(a)')
     &'// ALLOW_ICELATENT:                 NOT defined'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif /* ALLOW_ICELATENT */
c$$$#ifdef ALLOW_ATM_TEMP
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_ATM_TEMP:                     defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_ATM_TEMP:                 NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_ATM_WIND
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_ATM_WIND:                     defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_ATM_WIND:                 NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_DOWNWARD_RADIATION
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_DOWNWARD_RADIATION:           defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_DOWNWARD_RADIATION:       NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_BULKFORMULAE
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_BULKFORMULAE:                 defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_BULKFORMULAE:             NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif

c--   For each data set used the summary prints the calendar data
c     and the corresponding file from which the data will be read.

#ifndef ALLOW_LAKEICE
c--   ice fraction
      il = ilnblnk(icefracfile)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,f12.0)')
     &'   Ice fraction forcing starts at         ',
     &    icefracstartdate
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,f12.0)')
     &'   Ice fraction forcing period is         ',
     &    icefracperiod
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'   Ice fraction  forcing is read from file:'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a,a)')
     &'   >>  ',icefracfile(1:il),'  <<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif


cccccccc modified by Val Bennington Jan 2008
#ifndef ALLOW_ICELATENT
c--   ice latent heat
      il = ilnblnk(icelatentfile)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,f12.0)')
     &'   Ice latent forcing starts at          ',
     &    icefracstartdate
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,f12.0)')
     &'   Ice latent forcing period is          ',
     &    icelatentperiod 
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'   Ice latent forcing is read from file:'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a,a,a)')
     &'   >>  ',icelatentfile(1:il),'  <<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
#endif


c$$$#ifndef ALLOW_ATM_WIND
c$$$c--   Zonal wind stress.
c$$$      il = ilnblnk(ustressfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Zonal wind stress forcing starts at         ',
c$$$     &    ustressstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Zonal wind stress forcing period is         ',
c$$$     &    ustressperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Zonal wind stress forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',ustressfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Meridional wind stress.
c$$$      il = ilnblnk(vstressfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Meridional wind stress forcing starts at    ',
c$$$     &    vstressstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Meridional wind stress forcing period is    ',
c$$$     &    vstressperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Meridional wind stress forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',vstressfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifndef ALLOW_ATM_TEMP
c$$$c--   Heat flux.
c$$$      il = ilnblnk(hfluxfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Heat flux forcing starts at                ',
c$$$     &    hfluxstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Heat flux forcing period is                 ',
c$$$     &    hfluxperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Heat flux forcing is read from file:        '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',hfluxfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Salt flux.
c$$$      il = ilnblnk(sfluxfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Salt flux forcing starts at                 ',
c$$$     &    sfluxstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Salt flux forcing period is                 ',
c$$$     &    sfluxperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Salt flux forcing is read from file:        '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',sfluxfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
c$$$c--   Net shortwave.
c$$$      il = ilnblnk(swfluxfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Net shortwave flux forcing starts at      ',
c$$$     &    swfluxstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Net shortwave flux forcing period is      ',
c$$$     &    swfluxperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Net shortwave flux forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',swfluxfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_ATM_WIND
c$$$c--   Zonal wind.
c$$$      il = ilnblnk(uwindfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Zonal wind forcing starts at                ',
c$$$     &    uwindstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Zonal wind forcing period is                ',
c$$$     &    uwindperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Zonal wind forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',uwindfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Meridional wind.
c$$$      il = ilnblnk(vwindfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Meridional wind forcing starts at           ',
c$$$     &    vwindstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Meridional wind forcing period is           ',
c$$$     &    vwindperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Meridional wind forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',vwindfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_ATM_TEMP
c$$$c--   Atmospheric temperature.
c$$$      il = ilnblnk(atempfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric temperature starts at           ',
c$$$     &    atempstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric temperature period is           ',
c$$$     &    atempperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Atmospheric temperature is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',atempfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Atmospheric specific humidity.
c$$$      il = ilnblnk(aqhfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric specific humidity starts at     ',
c$$$     &    aqhstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric specific humidity period is     ',
c$$$     &    aqhperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Atmospheric specific humidity is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',aqhfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Net longwave.
c$$$      il = ilnblnk(lwfluxfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Net longwave flux forcing starts at       ',
c$$$     &    lwfluxstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Net longwave flux forcing period is       ',
c$$$     &    lwfluxperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Net longwave flux forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',lwfluxfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Precipitation.
c$$$      il = ilnblnk(precipfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Precipitation data set starts at            ',
c$$$     &    precipstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Precipitation data period is                ',
c$$$     &    precipperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Precipitation data is read from file:       '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',precipfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef EXF_READ_EVAP
c$$$c--   Evaporation.
c$$$      write(msgbuf,'(a)')
c$$$     &'// EXF_READ_EVAP:                      defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      il = ilnblnk(evapfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Evaporation starts at     ',
c$$$     &    evapstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Evaporation period is     ',
c$$$     &    evapperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Evaporation is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',evapfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else
c$$$      write(msgbuf,'(a)')
c$$$     &'// EXF_READ_EVAP:                  NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ALLOW_RUNOFF
c$$$c--   Runoff.
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_RUNOFF:                       defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      il = ilnblnk(runofffile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Runnoff starts at     ',
c$$$     &    runoffstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Runoff period is     ',
c$$$     &    runoffperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Runoff is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',runofffile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#else /* ALLOW_RUNOFF */
c$$$      write(msgbuf,'(a)')
c$$$     &'// ALLOW_RUNOFF:                   NOT defined'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif /* ALLOW_RUNOFF */
c$$$
c$$$#ifdef DOWNWARD_RADIATION
c$$$c--   Downward shortwave.
c$$$      il = ilnblnk(swdownfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Downward shortwave flux forcing starts at      ',
c$$$     &    swdownstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Downward shortwave flux forcing period is      ',
c$$$     &    swdownperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Downward shortwave flux forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',swdownfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$
c$$$c--   Downward longwave.
c$$$      il = ilnblnk(lwdownfile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Downward longwave flux forcing starts at       ',
c$$$     &    lwdownstartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Downward longwave flux forcing period is       ',
c$$$     &    lwdownperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Downward longwave flux forcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',lwdownfile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
c$$$#ifdef ATMOSPHERIC_LOADING
c$$$c--   Atmospheric pressure.
c$$$      il = ilnblnk(apressurefile)
c$$$      write(msgbuf,'(a)')
c$$$     &' '
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric pressure forcing starts at      ',
c$$$     &    apressurestartdate
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,f12.0)')
c$$$     &'   Atmospheric pressure forcing period is      ',
c$$$     &    apressureperiod
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a)')
c$$$     &'   Atmospheric pressureforcing is read from file:'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$      write(msgbuf,'(a,a,a)')
c$$$     &'   >>  ',apressurefile(1:il),'  <<'
c$$$      call print_message( msgbuf, standardmessageunit,
c$$$     &                    SQUEEZE_RIGHT , mythid)
c$$$#endif
c$$$
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ICE External forcing configuration  >>> END <<<'
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &'// ======================================================='
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      write(msgbuf,'(a)')
     &' '
      call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      return
      end
