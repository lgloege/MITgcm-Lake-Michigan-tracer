c PLANKTON.h 
c description: Key parameter arrays for generalized ecosystem model 
c Mick Follows, Stephanie Dutkiewicz Dec 2004
c
c
c npmax = no of "functional groups" of phytoplankton
c nzmax = no of "functional groups" of zooplankton
c
c
c mu = max growth rate (s-1)
c ksat = half sat coeff, phyto specific for each nutrient
c ksatlight = half sat coeff wrt light, phyto specific 
c graze = grazing rate, phyto specific for each zooplankton
c mortzoo = mortality rate for each zooplankton
c wsink = sinking speed, phyto specific
c R_XY = stoichiometric ratios of nutrients in phytoplankton
c        specific to each functional group, relative to Phos
c physize = size class of phytoplankton; 0.0="small", 1.0="big"
c diatom: 1.0 uses silica, 0.0 does not use silica
c diazotrph: 1.0 fixes nitrogen, 0.0 does not fix nitrogen
c zoosize = size class of zooplankton; 0.0="small", 1.0="big"
c ExportFracZ(nzmax) = fraction of Z mortality sinking out:
c                      rest remineralizes locally 
c Kpremin_xx = remin rate constant for particulate detritus
c ngroups = tracks how many different "functional groups" of phyto
c           have been tried


         INTEGER npmax
         INTEGER nzmax
         PARAMETER(npmax=78,nzmax=2)


         COMMON/ecoparam/mu,ksatPO4,ksatNO3,ksatNO2,ksatNH4,
     &          ksatSi,ksatFeT,ksatPAR,
     &          graze,mortzoo,wsink,R_NP,R_FeP,R_SiP,physize,
     &          diatom,diazotroph,zoosize,ExportFracZ,
     &          Kpremin_P, Kpremin_N, Kpremin_Fe, Kpremin_Si,
     &          phytoTempCoeff, phytoTempExp1, 
     &          phytoTempExp2, phytoTempOptimum, phytoDecayPower,
     &          zooTempCoeff, zooTempExp, zooTempOptimum, kinhib,
     &          nsource,ngroups
    
         real*8 mu(npmax)
         real*8 ksatPO4(npmax)
         real*8 ksatNO3(npmax)
         real*8 ksatNO2(npmax)
         real*8 ksatNH4(npmax)
         real*8 ksatSi(npmax)
         real*8 ksatFeT(npmax)
         real*8 ksatPAR(npmax)
         real*8 graze(npmax,nzmax)
         real*8 mortzoo(nzmax)
         real*8 wsink(npmax)
         real*8 R_NP(npmax)
         real*8 R_FeP(npmax)
         real*8 R_SiP(npmax)
         real*8 physize(npmax)
         real*8 diatom(npmax)
         real*8 diazotroph(npmax)
         real*8 zoosize(nzmax)
         real*8 ExportFracZ(nzmax)
         real*8 Kpremin_P
         real*8 Kpremin_N
         real*8 Kpremin_Fe
         real*8 Kpremin_Si
         real*8 phytoTempCoeff(npmax)
         real*8 phytoTempExp1(npmax)
         real*8 phytoTempExp2(npmax)     
         real*8 phytoTempOptimum(npmax)
         real*8 phytoDecayPower(npmax)
         real*8 zooTempCoeff(nzmax)
         real*8 zooTempExp(nzmax) 
         real*8 zooTempOptimum(nzmax)
         real*8 kinhib(npmax)
         INTEGER nsource(npmax)
         INTEGER ngroups


         COMMON/detritus/wp_sink,wn_sink,wfe_sink,wsi_sink,
     &          Kdop,Kdon,KdoFe,SmallSink,BigSink,
     &          Knita, Knitb
         real*8 wp_sink
         real*8 wn_sink
         real*8 wfe_sink
         real*8 wsi_sink
         real*8 Kdop
         real*8 Kdon
         real*8 KdoFe
         real*8 SmallSink
         real*8 BigSink
         real*8 Knita
         real*8 Knitb

