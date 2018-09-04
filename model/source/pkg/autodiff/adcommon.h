C--   These common blocks are extracted from the
C--   automatically created tangent linear code.
C--   You need to make sure that they are up-to-date
C--   (i.e. in right order), and customize them
C--   accordingly.
C--
C--   heimbach@mit.edu 11-Jan-2001

#ifdef ALLOW_AUTODIFF_MONITOR

#include "PACKAGES_CONFIG.h"

#ifdef ALLOW_EXF
# include "EXF_OPTIONS.h"
#endif
#ifdef ALLOW_SEAICE
# include "SEAICE_OPTIONS.h"
#endif


      common /addynvars_r/
     &                     adetan,
     &                     aduvel, advvel, adwvel,
     &                     adtheta, adsalt, 
     &                     adgu, adgv, adgt, adgs, 
     &                     adgunm1, adgvnm1, adgtnm1, adgsnm1
      _RL adetan(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adgs(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgsnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgt(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgtnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgu(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgunm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgv(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adgvnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adsalt(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adtheta(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL aduvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL advvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adwvel(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)

      common /addynvars_r_2/
     &                     adetah
      _RL adetah(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

#ifdef ALLOW_CD_CODE
      common /addynvars_cd/ 
     &                      aduveld, advveld,
     &                       adetanm1, 
     &                      adunm1, advnm1
      _RL aduveld(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL advveld(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL adetanm1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adunm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
      _RL advnm1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
#endif

      common /adffields/
     &                   adfu, adfv
     &                 , adqnet, adempmr
cph     &                 , adsst, adsss
      _RL adfu(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adfv(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adqnet(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adempmr(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
cph      _RL adsst(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
cph      _RL adsss(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

#ifdef ALLOW_DIFFKR_CONTROL
      COMMON /ADDYNVARS_DIFFKR/
     &                       addiffKr
      _RL  addiffKr (1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
#endif 
#if (defined (ALLOW_EDTAUX_CONTROL) || defined (ALLOW_EDTAUY_CONTROL))
      double precision adeddytaux(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,
     $nsy)
      double precision adeddytauy(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,
     $nsy)
      common /adedtauffields/ adeddytaux, adeddytauy

#endif

#ifdef ALLOW_EXF
      _RL adhflux(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adsflux(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_hsflux_r/ adhflux, adsflux
      _RL adustress(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL advstress(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_stress_r/ adustress, advstress
# ifdef ALLOW_ATM_TEMP
      _RL adatemp     (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adaqh       (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adlwflux    (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adprecip    (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_atm_temp_r/ adatemp, adaqh, adlwflux, adprecip
# endif
# ifdef ALLOW_ATM_WIND
      _RL aduwind     (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL advwind     (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_atm_wind_r/ aduwind, advwind
# endif
# ifdef ALLOW_DOWNWARD_RADIATION
      _RL adswdown    (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL adlwdown    (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_rad_down_r/
     &     adswdown, adlwdown
# endif
# ifdef ALLOW_CLIMSST_RELAXATION
      _RL adclimsst(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_clim_sst_r/ adclimsst
# endif
# ifdef ALLOW_CLIMSSS_RELAXATION
      _RL adclimsss(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adexf_clim_sss_r/ adclimsss
# endif
#endif

#ifdef ALLOW_SEAICE
      _RL adarea(1-olx:snx+olx,1-oly:sny+oly,3,nsx,nsy)
      common /adseaice_dynvars_1/ adarea
c
      _RL adheff(1-olx:snx+olx,1-oly:sny+oly,3,nsx,nsy)
      _RL adhsnow(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      common /adseaice_trans/ adheff, adhsnow
# ifdef SEAICE_ALLOW_DYNAMICS
      _RL aduice(1-olx:snx+olx,1-oly:sny+oly,3,nsx,nsy)
      _RL advice(1-olx:snx+olx,1-oly:sny+oly,3,nsx,nsy)
      common /adseaice_dynvars_2/ aduice, advice
# endif
#endif

#endif /* ALLOW_AUTODIFF_MONITOR */
