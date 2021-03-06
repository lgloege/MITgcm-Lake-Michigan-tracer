c $Header: /u/gcmpack/MITgcm/pkg/exf/exf_bulkformulae.F,v 1.11 2005/12/13 19:46:46 heimbach Exp $

#include "EXF_OPTIONS.h"

      subroutine exf_bulkformulae(mycurrenttime, mycurrentiter, mythid)

c     ==================================================================
c     SUBROUTINE exf_bulkformulae
c     ==================================================================
c
c     o Use bulk formulae to estimate turbulent and/or radiative
c       fluxes at the surface.
c
c     NOTES:
c     ======
c
c     See EXF_OPTIONS.h for a description of the various possible
c     ocean-model forcing configurations.
c
c     The bulk formulae of pkg/exf are not valid for sea-ice covered
c     oceans but they can be used in combination with a sea-ice model,
c     for example, pkg/seaice, to specify open water flux contributions.
c
c     ==================================================================
c
c       The calculation of the bulk surface fluxes has been adapted from
c       the NCOM model which uses the formulae given in Large and Pond
c       (1981 & 1982 )
c
c
c       Header taken from NCOM version: ncom1.4.1
c       -----------------------------------------
c
c       Following procedures and coefficients in Large and Pond
c       (1981 ; 1982)
c
c       Output: Bulk estimates of the turbulent surface fluxes.
c       -------
c
c       hs  - sensible heat flux  (W/m^2), into ocean
c       hl  - latent   heat flux  (W/m^2), into ocean
c
c       Input:
c       ------
c
c       us  - mean wind speed (m/s)     at height hu (m)
c       th  - mean air temperature (K)  at height ht (m)
c       qh  - mean air humidity (kg/kg) at height hq (m)
c       sst - sea surface temperature (K)
c       tk0 - Kelvin temperature at 0 Celsius (K)
c
c       Assume 1) a neutral 10m drag coefficient =
c
c                 cdn = .0027/u10 + .000142 + .0000764 u10
c
c              2) a neutral 10m stanton number =
c
c                 ctn = .0327 sqrt(cdn), unstable
c                 ctn = .0180 sqrt(cdn), stable
c
c              3) a neutral 10m dalton number =
c
c                 cen = .0346 sqrt(cdn)
c
c              4) the saturation humidity of air at
c
c                 t(k) = exf_BulkqSat(t)  (kg/m^3)
c
c       Note:  1) here, tstar = <wt>/u*, and qstar = <wq>/u*.
c              2) wind speeds should all be above a minimum speed,
c                 say 0.5 m/s.
c              3) with optional iteration loop, niter=3, should suffice.
c              4) this version is for analyses inputs with hu = 10m and
c                 ht = hq.
c              5) sst enters in Celsius.
c
c     ==================================================================
c
c       started: Christian Eckert eckert@mit.edu 27-Aug-1999
c
c       changed: Christian Eckert eckert@mit.edu 14-Jan-2000
c              - restructured the original version in order to have a
c                better interface to the MITgcmUV.
c
c              Christian Eckert eckert@mit.edu  12-Feb-2000
c              - Changed Routine names (package prefix: exf_)
c
c              Patrick Heimbach, heimbach@mit.edu  04-May-2000
c              - changed the handling of precip and sflux with respect
c                to CPP options ALLOW_BULKFORMULAE and ALLOW_ATM_TEMP
c              - included some CPP flags ALLOW_BULKFORMULAE to make
c                sure ALLOW_ATM_TEMP, ALLOW_ATM_WIND are used only in
c                conjunction with defined ALLOW_BULKFORMULAE
c              - statement functions discarded
c
c              Ralf.Giering@FastOpt.de 25-Mai-2000
c              - total rewrite using new subroutines
c
c              Detlef Stammer: include river run-off. Nov. 21, 2001
c
c              heimbach@mit.edu, 10-Jan-2002
c              - changes to enable field swapping
c
c       mods for pkg/seaice: menemenlis@jpl.nasa.gov 20-Dec-2002
c
c     ==================================================================
c     SUBROUTINE exf_bulkformulae
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "LAKEICE_OPTIONS.h"

#include "exf_param.h"
#include "exf_fields.h"
#include "exf_constants.h"

#ifdef ALLOW_AUTODIFF_TAMC
#include "tamc.h"
#endif

#ifdef ALLOW_LAKEICE
c#include "lakeice_param.h"
#include "lakeice_fields.h"
#endif

c     == routine arguments ==

      integer mythid
      integer mycurrentiter
      _RL     mycurrenttime

#ifdef ALLOW_BULKFORMULAE

c     == local variables ==

      integer bi,bj
      integer i,j,k

      _RL     aln

c model has built in shortwave albedo of 0.1
c with ice, this will differ in reality
c make fraction-weighted albedo (icealbedo)
#ifdef ALLOW_LAKEICE
      _RL     icealbedo
c luke comment
c      _RL     icefrac
#endif /* ALLOW_LAKEICE */

#ifdef ALLOW_DIAGNOSTICS
      CHARACTER*8 diagName
      _RL sensht(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL latht(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL evapr(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL swht(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL lwht(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
#endif /* ALLOW_DIAGNOSTICS */

#ifdef ALLOW_ATM_TEMP
      integer iter
      _RL     delq
      _RL     deltap
      _RL     hqol
      _RL     htol
      _RL     huol
      _RL     psimh
      _RL     psixh
      _RL     qstar
      _RL     rd
      _RL     re
      _RL     rdn
      _RL     rh
      _RL     ssttmp
      _RL     ssq
      _RL     stable
      _RL     tstar
      _RL     t0
      _RL     ustar
      _RL     uzn
      _RL     shn
      _RL     xsq
      _RL     x
      _RL     tau
#ifdef ALLOW_AUTODIFF_TAMC
      integer ikey_1
      integer ikey_2
#endif
#endif /* ALLOW_ATM_TEMP */

      _RL     ustmp
      _RL     us
      _RL     cw
      _RL     sw
      _RL     sh
      _RL     hfl
      _RL     tmpbulk

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

      _RL       exf_BulkqSat
      external  exf_BulkqSat
      _RL       exf_BulkCdn
      external  exf_BulkCdn
      _RL       exf_BulkRhn
      external  exf_BulkRhn

#ifndef ALLOW_ATM_WIND
      _RL       TMP1
      _RL       TMP2
      _RL       TMP3
      _RL       TMP4
      _RL       TMP5
#endif

c     == end of interface ==

cph   This statement cannot be a PARAMETER statement in the header,
cph   but must come here; it's not fortran77 standard
      aln = log(ht/zref)

c--   Use atmospheric state to compute surface fluxes.

c     Loop over tiles.
#ifdef ALLOW_AUTODIFF_TAMC
C--   HPF directive to help TAMC
CHPF$ INDEPENDENT
#endif
      do bj = mybylo(mythid),mybyhi(mythid)
#ifdef ALLOW_AUTODIFF_TAMC
C--    HPF directive to help TAMC
CHPF$  INDEPENDENT
#endif
        do bi = mybxlo(mythid),mybxhi(mythid)

          k = 1

          do j = 1,sny
            do i = 1,snx
c get ice fraction and fractionally-weighted albedo: 
#ifdef ALLOW_LAKEICE
              icealbedo = 0.
              icefrac(i,j,bi,bj) = icefrac(i,j,bi,bj)*maskc(i,j,1,bi,bj)
              icealbedo = 0.5 * icefrac(i,j,bi,bj)
     &                     + (1-icefrac(i,j,bi,bj))*0.1
#endif /* ALLOW_LAKEICE */

#ifdef ALLOW_AUTODIFF_TAMC
               act1 = bi - myBxLo(myThid)
               max1 = myBxHi(myThid) - myBxLo(myThid) + 1
               act2 = bj - myByLo(myThid)
               max2 = myByHi(myThid) - myByLo(myThid) + 1
               act3 = myThid - 1
               max3 = nTx*nTy
               act4 = ikey_dynamics - 1

               ikey_1 = i
     &              + sNx*(j-1)
     &              + sNx*sNy*act1
     &              + sNx*sNy*max1*act2
     &              + sNx*sNy*max1*max2*act3
     &              + sNx*sNy*max1*max2*max3*act4
#endif

#ifdef ALLOW_DOWNWARD_RADIATION
c--   Compute net from downward and downward from net longwave and
c     shortwave radiation, if needed.
c     lwflux = Stefan-Boltzmann constant * emissivity * SST - lwdown
c     swflux = - ( 1 - albedo ) * swdown

#ifdef ALLOW_ATM_TEMP
      if ( lwfluxfile .EQ. ' ' .AND. lwdownfile .NE. ' ' )
     &     lwflux(i,j,bi,bj) = 5.5 _d -08 *
     &              ((theta(i,j,k,bi,bj)+cen2kel)**4)
     &              - lwdown(i,j,bi,bj)
      if ( lwfluxfile .NE. ' ' .AND. lwdownfile .EQ. ' ' )
     &     lwdown(i,j,bi,bj) = 5.5 _d -08 *
     &              ((theta(i,j,k,bi,bj)+cen2kel)**4)
     &              - lwflux(i,j,bi,bj)
#endif

#if defined(ALLOW_ATM_TEMP) || defined(SHORTWAVE_HEATING)
      if ( swfluxfile .EQ. ' ' .AND. swdownfile .NE. ' ' )
     &     swflux(i,j,bi,bj) = -(1.0-exf_albedo) * swdown(i,j,bi,bj)
      if ( swfluxfile .NE. ' ' .AND. swdownfile .EQ. ' ' )
     &     swdown(i,j,bi,bj) = -swflux(i,j,bi,bj) / (1.0-exf_albedo)
#ifdef ALLOW_LAKEICE
           swflux(i,j,bi,bj) = -(1.0-icealbedo) * swdown(i,j,bi,bj)
#endif /* ALLOW_LAKEICE */

#endif

#endif /* ALLOW_DOWNWARD_RADIATION */

c--   Compute the turbulent surface fluxes.

#ifdef ALLOW_ATM_WIND
c             Wind speed and direction.
              ustmp = uwind(i,j,bi,bj)*uwind(i,j,bi,bj) +
     &                vwind(i,j,bi,bj)*vwind(i,j,bi,bj)
              if ( ustmp .ne. 0. _d 0 ) then
                us = sqrt(ustmp)
                cw = uwind(i,j,bi,bj)/us
                sw = vwind(i,j,bi,bj)/us
              else
                us = 0. _d 0
                cw = 0. _d 0
                sw = 0. _d 0
              endif
              sh = max(us,umin)
#else  /* ifndef ALLOW_ATM_WIND */
#ifdef ALLOW_ATM_TEMP

c             The variables us, sh and rdn have to be computed from
c             given wind stresses inverting relationship for neutral
c             drag coeff. cdn.
c             The inversion is based on linear and quadratic form of
c             cdn(umps); ustar can be directly computed from stress;

              ustmp = ustress(i,j,bi,bj)*ustress(i,j,bi,bj) + 
     &                vstress(i,j,bi,bj)*vstress(i,j,bi,bj)
              if ( ustmp .ne. 0. _d 0 ) then
                ustar = sqrt(ustmp/atmrho)
                cw = ustress(i,j,bi,bj)/sqrt(ustmp)
                sw = vstress(i,j,bi,bj)/sqrt(ustmp)
              else
                 ustar = 0. _d 0
                 cw    = 0. _d 0
                 sw    = 0. _d 0
              endif

              if ( ustar .eq. 0. _d 0 ) then
                us = 0. _d 0
              else if ( ustar .lt. ustofu11 ) then
                tmp1 = -cquadrag_2/cquadrag_1/2
                tmp2 = sqrt(tmp1*tmp1 + ustar*ustar/cquadrag_1)
                us   = sqrt(tmp1 + tmp2)
              else
                tmp3 = clindrag_2/clindrag_1/3
                tmp4 = ustar*ustar/clindrag_1/2 - tmp3**3
                tmp5 = sqrt(ustar*ustar/clindrag_1*
     &                      (ustar*ustar/clindrag_1/4 - tmp3**3))
                us   = (tmp4 + tmp5)**(1/3) +
     &                 tmp3**2 * (tmp4 + tmp5)**(-1/3) - tmp3
              endif

              if ( us .ne. 0 ) then
                 rdn = ustar/us
              else
                 rdn = 0. _d 0
              end if

              sh    = max(us,umin)
#endif /* ALLOW_ATM_TEMP */
#endif /* ifndef ALLOW_ATM_WIND */

#ifdef ALLOW_ATM_TEMP

c             Initial guess: z/l=0.0; hu=ht=hq=z
c             Iterations:    converge on z/l and hence the fluxes.
c             t0     : virtual temperature (K)
c             ssq    : sea surface humidity (kg/kg)
c             deltap : potential temperature diff (K)

              if ( atemp(i,j,bi,bj) .ne. 0. _d 0 ) then
                t0     = atemp(i,j,bi,bj)*
     &                   (exf_one + humid_fac*aqh(i,j,bi,bj))
                ssttmp = theta(i,j,k,bi,bj)
                tmpbulk= exf_BulkqSat(ssttmp + cen2kel)
                ssq    = saltsat*tmpbulk/atmrho
                deltap = atemp(i,j,bi,bj)   + gamma_blk*ht -
     &                   ssttmp - cen2kel
                delq   = aqh(i,j,bi,bj) - ssq
                stable = exf_half + sign(exf_half, deltap)
#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE sh     = comlev1_exf_1, key = ikey_1
#endif
                tmpbulk= exf_BulkCdn(sh)
                rdn    = sqrt(tmpbulk)
                ustar  = rdn*sh
                tmpbulk= exf_BulkRhn(stable)
                tstar  = tmpbulk*deltap 
                qstar  = cdalton*delq 

                do iter = 1,niter_bulk

#ifdef ALLOW_AUTODIFF_TAMC
                   ikey_2 = iter
     &                  + niter_bulk*(i-1)
     &                  + niter_bulk*sNx*(j-1)
     &                  + niter_bulk*sNx*sNy*act1
     &                  + niter_bulk*sNx*sNy*max1*act2
     &                  + niter_bulk*sNx*sNy*max1*max2*act3
     &                  + niter_bulk*sNx*sNy*max1*max2*max3*act4

CADJ STORE rdn    = comlev1_exf_2, key = ikey_2
CADJ STORE ustar  = comlev1_exf_2, key = ikey_2
CADJ STORE qstar  = comlev1_exf_2, key = ikey_2
CADJ STORE tstar  = comlev1_exf_2, key = ikey_2
CADJ STORE sh     = comlev1_exf_2, key = ikey_2
CADJ STORE us     = comlev1_exf_2, key = ikey_2
#endif

                  huol   = czol*(tstar/t0 +
     &                     qstar/(exf_one/humid_fac+aqh(i,j,bi,bj)))/
     &                           ustar**2
                  huol   = max(huol,zolmin)
                  stable = exf_half + sign(exf_half, huol)
                  htol   = huol*ht/hu
                  hqol   = huol*hq/hu

c                 Evaluate all stability functions assuming hq = ht.
                  xsq    = max(sqrt(abs(exf_one - 16.*huol)),exf_one)
                   x     = sqrt(xsq)
                  psimh  = -psim_fac*huol*stable +
     &                     (exf_one - stable)*
     &                     (log((exf_one + x*(exf_two + x))*
     &                     (exf_one + xsq)/8.) - exf_two*atan(x) +
     &                     pi*exf_half)
                  xsq    = max(sqrt(abs(exf_one - 16.*htol)),exf_one)
                  psixh  = -psim_fac*htol*stable + (exf_one - stable)*
     &                     exf_two*log((exf_one + xsq)/exf_two)

c                 Shift wind speed using old coefficient
ccc                  rd   = rdn/(exf_one + rdn/karman*
ccc     &                 (log(hu/zref) - psimh) )
                  rd     = rdn/(exf_one - rdn/karman*psimh )
                  shn    = sh*rd/rdn
                  uzn    = max(shn, umin)

c                 Update the transfer coefficients at 10 meters
c                 and neutral stability.

                  tmpbulk= exf_BulkCdn(uzn)
                  rdn    = sqrt(tmpbulk)

c                 Shift all coefficients to the measurement height
c                 and stability.
c                 rd = rdn/(exf_one + rdn/karman*(log(hu/zref) - psimh))
                  rd     = rdn/(exf_one - rdn/karman*psimh)
                  tmpbulk= exf_BulkRhn(stable)
                  rh     = tmpbulk/( exf_one + 
     &                               tmpbulk/karman*(aln - psixh) )
                  re     = cdalton/( exf_one + 
     &                               cdalton/karman*(aln - psixh) )

c                 Update ustar, tstar, qstar using updated, shifted
c                 coefficients.
                  ustar  = rd*sh  
                  qstar  = re*delq 
                  tstar  = rh*deltap
                  tau    = atmrho*ustar**2
                  tau    = tau*us/sh

                enddo

#ifdef ALLOW_AUTODIFF_TAMC
CADJ STORE ustar  = comlev1_exf_1, key = ikey_1
CADJ STORE qstar  = comlev1_exf_1, key = ikey_1
CADJ STORE tstar  = comlev1_exf_1, key = ikey_1
CADJ STORE tau    = comlev1_exf_1, key = ikey_1
CADJ STORE cw     = comlev1_exf_1, key = ikey_1
CADJ STORE sw     = comlev1_exf_1, key = ikey_1
#endif

                hs(i,j,bi,bj)      = atmcp*tau*tstar/ustar
                hl(i,j,bi,bj)      = flamb*tau*qstar/ustar
#ifdef ALLOW_LAKEICE
c added by val bennington 5-30-08
c hs = sensible heat based on air temp, wind, ref temp, wind ref
c hl = latent heat based on specific heat, winds, ref humidity, wind reference
c assume fraction of ice is fraction of this exchange that is blocked
                hs(i,j,bi,bj) = atmcp*tau*tstar/ustar
     &                            *(1-icefrac(i,j,bi,bj))
                hl(i,j,bi,bj) = flamb*tau*qstar/ustar
     &                            *(1-icefrac(i,j,bi,bj))
#endif /* ALLOW_LAKEICE */
#ifdef ALLOW_DIAGNOSTICS

#endif /* ALLOW_DIAGNOSTICS */


#ifndef EXF_READ_EVAP
cdm             evap(i,j,bi,bj)    = tau*qstar/ustar
cdm !!! need to change sign and to convert from kg/m^2/s to m/s !!!
                evap(i,j,bi,bj)    = -recip_rhonil*tau*qstar/ustar
#endif
cc modified by val bennington 5-28-2008 to include reduced evap from ice presence:
#ifdef ALLOW_LAKEICE
                evap(i,j,bi,bj) = -recip_rhonil*tau*qstar/ustar
     &                             *(1.d0-icefrac(i,j,bi,bj))
#endif
                ustress(i,j,bi,bj) = tau*cw
                vstress(i,j,bi,bj) = tau*sw
              else
                ustress(i,j,bi,bj) = 0. _d 0
                vstress(i,j,bi,bj) = 0. _d 0
                hflux  (i,j,bi,bj) = 0. _d 0
                hs(i,j,bi,bj)      = 0. _d 0
                hl(i,j,bi,bj)      = 0. _d 0
              endif

#else  /* ifndef ALLOW_ATM_TEMP */
#ifdef ALLOW_ATM_WIND
              tmpbulk= exf_BulkCdn(sh)
              ustress(i,j,bi,bj) = atmrho*tmpbulk*us*
     &                             uwind(i,j,bi,bj)
              vstress(i,j,bi,bj) = atmrho*tmpbulk*us*
     &                             vwind(i,j,bi,bj)
#endif
#endif /* ifndef ALLOW_ATM_TEMP */
#ifdef ALLOW_DIAGNOSTICS
            sensht(i,j,bi,bj) = hs(i,j,bi,bj)
            latht(i,j,bi,bj) = hl(i,j,bi,bj)
            evapr(i,j,bi,bj) = evap(i,j,bi,bj)
            swht(i,j,bi,bj) = swflux(i,j,bi,bj)
            lwht(i,j,bi,bj) = lwflux(i,j,bi,bj)
#endif /* ALLOW_DIAGNOSTICS */
#ifdef ALLOW_DIAGNOSTICS
       IF ( useDiagnostics ) THEN
        diagName = 'sensht  '
        if (k.eq.1) CALL DIAGNOSTICS_FILL(sensht,diagName,
     &                                k,1, 2,bi,bj,myThid)
        diagName = 'latht   '
        if (k.eq.1) CALL DIAGNOSTICS_FILL(latht,diagName,
     &                                k,1, 2,bi,bj,myThid)
        diagName = 'evapr   '
        if (k.eq.1) CALL DIAGNOSTICS_FILL(evapr,diagName,
     &                                k,1, 2,bi,bj,myThid)
        diagName = 'swht    '
        if (k.eq.1) CALL DIAGNOSTICS_FILL(swht,diagName,
     &                                k,1, 2,bi,bj,myThid)
        diagName = 'lwht    '
        if (k.eq.1) CALL DIAGNOSTICS_FILL(lwht,diagName,
     &                                k,1, 2,bi,bj,myThid)
       ENDIF
#endif /* ALLOW_DIAGNOSTICS */
c
            enddo
          enddo
        enddo
      enddo

c     Add all contributions.
      do bj = mybylo(mythid),mybyhi(mythid)
        do bi = mybxlo(mythid),mybxhi(mythid)
          do j = 1,sny
            do i = 1,snx
c             Net surface heat flux.
#ifdef ALLOW_ATM_TEMP
              hfl = 0. _d 0
              hfl = hfl - hs(i,j,bi,bj)
              hfl = hfl - hl(i,j,bi,bj)
              hfl = hfl + lwflux(i,j,bi,bj)
#ifndef SHORTWAVE_HEATING
              hfl = hfl + swflux(i,j,bi,bj)
#endif
c             Heat flux:
              hflux(i,j,bi,bj) = hfl
c             Salt flux from Precipitation and Evaporation.
              sflux(i,j,bi,bj) = evap(i,j,bi,bj) - precip(i,j,bi,bj)
#endif /* ALLOW_ATM_TEMP */

            enddo
          enddo
        enddo
      enddo

#endif /* ALLOW_BULKFORMULAE */

      end
