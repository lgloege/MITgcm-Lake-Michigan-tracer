c $Header: /u/gcmpack/MITgcm/pkg/lakeice/lakeice_fields.h,v 1.12 2005/06/28 22:05:49 heimbach Exp $
c
c
c     ==================================================================
c     HEADER lakeice_fields
c     ==================================================================
c
c     o Header file for the surface flux data.
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-2000
c     changed: field swap in adj. mode; heimbach@mit.edu 10-Jan-2002
c     included runoff D. Stammer, Nov. 25, 2001
c     mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     HEADER lakeice_fields
c     ==================================================================
c
c
c     Field definitions, units, and sign conventions:
c     ===============================================
c
c     NOTES:
c     ======
c
c     All surface forcing fields are defined at the center of
c     each grid (the rVel location in model/inc/GRID.h) with
c     one exception.  When both ALLOW_BULKFORMULAE and
c     USE_LAKEICE_INTERPOLATION are undefined, ustress and vstress are
c     defined at the Southwest C-grid U and V points, respectively.
c
c     Input and output units and sign conventions can be customized
c     using variables lakeice_inscal_* and lakeice_outscal_*, which are set
c     by lakeice_readparms.F
c
c     Output fields fu, fv, Qnet, Qsw, and EmPmR are
c     defined in FFIELDS.h
c
c     #ifndef SHORTWAVE_HEATING, hflux includes shortwave,
c     that is, hflux = latent + sensible + lwflux +swflux
c
c     Arrays *0 and *1 below are used for temporal interpolation.
c
      common /lakeice_icefrac_r/ icefrac
      _RL icefrac(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /lakeice_icefract_r1/ icefrac0, icefrac1
      _RL icefrac0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL icefrac1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
