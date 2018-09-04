#include "GCHEM_OPTIONS.h"

c NPZD2Fe.h
c --------------------------------------------------------------------
c  Description:  global arrays for ten compartment ecosystem
c                model: 2 phytoplankton and 1 zooplankton class
c                includes P, Si, Fe and Fe chemistry
c                3 additional POM fields (not ad/diff)
c --------------------------------------------------------------------      
c    fice           - ice fraction
c    inputFe        - aeolian input of iron
c    k0, kc         - light attentuation coefficients
c    phymin         - minimum phytoplankton (seed stage?)
c    zoomin         - minimum zooplankton (egg stage?)
c    scav           - chemical scavenging rate for iron
c    ligand_tot     - total organic ligand (assumed constant)
c    ligand_stab    - ligand stability
c    chlpmax        - chl:p max ratio
c    chlpmin        - chl:p min ratio
c    istar          - photoadaptation light limit
c
c --------------------------------------------------------------------
c 
      COMMON /NPZD2Fe_PARM01/
     &       fice, inputFe,
     &       k0, kc,
     &       alpfe, scav, ligand_tot, ligand_stab,
     &       freefemax,
     &       chlpmax, chlpmin, istar
c
       _RL   fice(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   inputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   k0, kc
       _RL   alpfe, scav, ligand_tot, ligand_stab
       _RL   freefemax
       _RL   chlpmax, chlpmin, istar

c
      COMMON /NPZD2Fe_PARM03/
     &      Phygrow1ave, Phygrow2ave, Zoograzave,
     &      Parave, Chlave,
     &      npzd_timeave
#ifdef PTR_CALC_TERMS
     &      ,wopave, uopave, vopave
     &      ,wipave, uipave, vipave
     &      ,wosave, uosave, vosave
     &      ,wisave, uisave, visave
     &      ,wofave, uofave, vofave
     &      ,wifave, uifave, vifave
#endif
c  
       _RL  Phygrow1ave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Phygrow2ave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Zoograzave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Parave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  Chlave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  NPZD_timeave(nR,nSx,nSy)
#ifdef PTR_CALC_TERMS
       _RL  wopave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uopave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  vopave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  wipave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uipave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  vipave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  wosave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uosave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  vosave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  wisave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uisave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  visave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  wofave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uofave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  vofave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  wifave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  uifave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
       _RL  vifave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nR,nSx, nSy)
#endif

