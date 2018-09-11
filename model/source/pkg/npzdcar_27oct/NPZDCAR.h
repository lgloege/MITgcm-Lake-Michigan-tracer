#include "GCHEM_OPTIONS.h"

c NPZDCAR.h
c --------------------------------------------------------------------
c  Description:  global arrays for ten compartment ecosystem
c                model: 2 phytoplankton and 1 zooplankton class
c                includes P, Si, Fe and Fe chemistry
c                3 additional POM fields (not ad/diff)
c --------------------------------------------------------------------      
c    fice           - ice fraction
c    inputFe        - aeolian input of iron
c    k0, kc         - light attentuation coefficients
c    phygrow/2      - phytoplankton maximum growth rate
c    mort/2         - mortality of phytoplankton
c    zoograze       - maximum grazing rate by zooplankton
c    mortz          - mortality of zooplankton (linear)
c    phymin         - minimum phytoplankton (seed stage?)
c    zoomin/fe/c    - minimum zooplankton (egg stage?)
c    ilim/2         - limiting light
c    nlim/2         - P half-saturation
c    slim2          - Si half-saturation
c    flim/2         - Fe half-saturation
c    plim           - limiting phytoplankton (for zooplankton)
c    reminn/s/f/c   - reminerilization rate for POM and DOM
c    dissc          - dissolution rate PIC to DIC
c    plim           - limiting phytoplankton (for zooplankton) 
c    gampn/2        - zooplankton assilimilation efficiency
c    donfracmn/f  - fraction of dead matter going to DOM
c    donfracgn/f  - fraction left over grazing material going to DOM
c    wn/s/f/c/pic_sink    - sinking rates of POM
c    Rfep/2. Rsip2, Rcp/2, Rop, Rnp  - ratios Fe,Si to P in phytoplankton
c    scav           - chemical scavenging rate for iron
c    ligand_tot     - total organic ligand (assumed constant)
c    ligand_stab    - ligand stability
c    rainratio      - rain ratio
c    chlpmax        - chl:p max ratio
c    chlpmin        - chl:p min ratio
c    istar          - photoadaptation light limit
c
c --------------------------------------------------------------------
c 
c forcing variables
      COMMON /NPZDCAR_PARM01/
     &       fice, inputFe, wspeed, sur_par, atmosp, PAR
c
       _RL   fice(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   inputFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   wspeed(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   sur_par(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   atmosp(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL   PAR(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)

c ecosystem parameters
       COMMON /NPZDCAR_PARM02/
     &       k0, kc,
     &       phygrow, phygrow2, mort, mort2, 
     &       zoograze, mortz, 
     &       phymin, grazlim, zoomin,
     &       zoominfe, zoominc,
     &       ilim, nlim, ilim2, nlim2, 
     &       flim, slim2, flim2,
     &       zplat, zplat2, plim,
     &       reminn, remins, reminf, reminc, dissc,
     &       gampn, gampn2, 
     &       donfracmn1, donfracmn2, donfracmn,
     &       donfracmf1, donfracmf2, donfracmf, 
     &       donfracmc1, donfracmc2, donfracmc,
     &       donfracgn, donfracgf, donfracgc,
     &       wn_sink, ws_sink, wf_sink, wc_sink, wpic_sink,
     &       Rfep, Rsip2, Rfep2, Rcp, Rcp2, Rop, Rnp,
     &       alpfe, scav, ligand_tot, ligand_stab, freefemax,
     &       rainratio, o2crit,
     &       chlpmax, chlpmin, istar,
     &       temp_coeff_base, temp_coeff_norm
c
       _RL   k0, kc
       _RL   phygrow, phygrow2, mort, mort2
       _RL   zoograze, mortz
       _RL   phymin, grazlim, zoomin
       _RL   zoominfe, zoominc
       _RL   ilim, nlim, ilim2, nlim2
       _RL   flim, slim2, flim2
       _RL   zplat, zplat2, plim
       _RL   reminn, remins, reminf, reminc, dissc
       _RL   gampn, gampn2
       _RL   donfracmn1, donfracmn2, donfracmn 
       _RL   donfracmf1, donfracmf2, donfracmf
       _RL   donfracmc1, donfracmc2, donfracmc
       _RL   donfracgn, donfracgf, donfracgc
       _RL   wn_sink, ws_sink, wf_sink, wc_sink, wpic_sink
       _RL   Rfep, Rsip2, Rfep2, Rcp, Rcp2, Rop, Rnp
       _RL   alpfe, scav, ligand_tot, ligand_stab, freefemax
       _RL   rainratio, o2crit
       _RL   chlpmax, chlpmin, istar
       _RL   temp_coeff_base, temp_coeff_norm

c air-sea flux info
       COMMON /NPZDCAR_PARM03/
     &  FluxCO2, FluxO2, pH, pCO2, AtmospCO2,
     &  gsm_s, gsm_dic, gsm_alk, permil
        _RL  FluxCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
        _RL  FluxO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
        _RL  pH(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
	_RL  pCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
	_RL  AtmospCO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
	_RL  gsm_s, gsm_dic, gsm_alk
	_RL  permil

c
c diagnostic averages
      COMMON /NPZDCAR_PARM04/
     &      Phygrow1ave, Phygrow2ave, Zoograzave,
     &      Parave, Chlave, FluxCO2ave, FluxO2ave, pHave,
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
       _RL  FluxCO2ave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL  FluxO2ave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
       _RL  pHave(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx, nSy)
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

	COMMON /CARBON_CHEM/
     &                     ak0,ak1,ak2,akw,akb,aks,akf,
     &                     ak1p,ak2p,ak3p,aksi,
     &                     ff,ft,st,bt
       _RL  ak0(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ak1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ak2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  akw(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  akb(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  aks(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  akf(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ak1p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ak2p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ak3p(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  aksi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ff(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  ft(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  st(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
       _RL  bt(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)


	COMMON /OXYGEN_CHEM/
     &              oA0,oA1,oA2,oA3,oA4,oA5,
     &              oB0,oB1,oB2,oB3,
     &              oC0
        _RL oA0,oA1,oA2,oA3,oA4,oA5
        _RL oB0,oB1,oB2,oB3
        _RL oC0

C schmidt number coefficients
	  COMMON /SCHMIDT_NO/
     &                    sca1, sca2, sca3, sca4,
     &                    sox1, sox2, sox3, sox4
         _RL  sca1
         _RL  sca2
         _RL  sca3
         _RL  sca4
         _RL  sox1
         _RL  sox2
         _RL  sox3
         _RL  sox4
