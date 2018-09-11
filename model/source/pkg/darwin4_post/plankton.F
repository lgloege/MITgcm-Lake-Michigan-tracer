#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c ====================================================================
c SUBROUTINE PLANKTON
c 1. Local ecological interactions for models with many phytoplankton
c    "functional groups" 
c 2. Timestep plankton and nutrients locally 
c 3. Includes explicit DOM and POM
c 4. Remineralization of detritus also determined in routine
c 5. NOT in this routine: sinking of particles and iron chemistry
c
c Mick Follows, Scott Grant, Fall/Winter 2005
c modified Stephanie Dutkiewicz Spring 2006
c ====================================================================
         SUBROUTINE PLANKTON(phyto, zooP, zooN, zooFe, zooSi, PP, 
     &                       PO4local, NO3local, FeTlocal, Silocal,
     &                       NO2local, NH4local, 
     &                       DOPlocal, DONlocal, DOFelocal,
     &                       POPlocal, PONlocal, POFelocal, PSilocal,
     &                       phytoup, popuplocal, ponuplocal, 
     &                       pofeuplocal, psiuplocal,
     &                       PARlocal,Tlocal, Slocal,
     &                       freefelocal, inputFelocal,
     &                       bottom, dzlocal,
     &                       dphytodt, dzooPdt, dzooNdt, dzooFedt,
     &                       dzooSidt,
     &                       dPO4dt, dNO3dt, dFeTdt, dSidt,
     &                       dNH4dt, dNO2dt,
     &                       dDOPdt, dDONdt, dDOFedt, 
     &                       dPOPdt, dPONdt, dPOFedt, dPSidt,
     &                       debug,
     &                       MyThid)
         implicit none
         include "PLANKTON.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
      INTEGER myThid
CEOP
c === GLOBAL VARIABLES =====================
c npmax = no of phyto functional groups
c nzmax = no of grazer species
c phyto = phytoplankton
c zoo   = zooplankton
         _RL phyto(npmax)
         _RL zooP(nzmax)
         _RL zooN(nzmax)
         _RL zooFe(nzmax)
         _RL zooSi(nzmax)
         _RL PP(npmax)
         _RL PO4local
         _RL NO3local
         _RL FeTlocal
         _RL Silocal
         _RL NO2local
         _RL NH4local
         _RL DOPlocal
         _RL DONlocal
         _RL DOFelocal
         _RL POPlocal 
         _RL PONlocal
         _RL POFelocal
         _RL PSilocal
         _RL phytoup(npmax)
         _RL POPuplocal
         _RL PONuplocal
         _RL POFeuplocal
         _RL PSiuplocal 
         _RL PARlocal
         _RL Tlocal
         _RL Slocal
         _RL freefelocal
         _RL inputFelocal
         _RL bottom
         _RL dzlocal
         INTEGER debug
         _RL dphytodt(npmax)
         _RL dzooPdt(nzmax)
         _RL dzooNdt(nzmax)
         _RL dzooFedt(nzmax)
         _RL dzooSidt(nzmax)
         _RL dPO4dt
         _RL dNO3dt
         _RL dNO2dt
         _RL dNH4dt
         _RL dFeTdt
         _RL dSidt
         _RL dDOPdt
         _RL dDONdt
         _RL dDOFedt
         _RL dPOPdt
         _RL dPONdt
         _RL dPOFedt
         _RL dPSidt

c LOCAL VARIABLES
c -------------------------------------------------------------

c WORKING VARIABLES
c np = phytoplankton index
         integer np
c nz = zooplankton index
         integer nz

c variables for phytoplankton growth rate/nutrient limitation
c phytoplankton specific nutrient limitation term
         _RL limit(npmax)
c phytoplankton light limitation term
         _RL ilimit(npmax)
         _RL PspecificPO4(npmax)
         _RL phytoTempFunction(npmax)
         _RL dummy
         _RL Ndummy
         _RL Nsourcelimit(npmax)

c  variables for zooplankton grazing rates
         _RL zooTempFunction(nzmax)
         _RL grazing_phyto(npmax)
         _RL grazingP(nzmax)
         _RL grazingN(nzmax)
         _RL grazingFe(nzmax)
         _RL grazingSi(nzmax)

c variables for nutrient uptake
         _RL consumpPO4
         _RL consumpNO3
         _RL consumpNO2
         _RL consumpNH4
         _RL consumpFeT
         _RL consumpSi

c variables for reminerlaization of DOM and POM
         _RL DOPremin
         _RL DONremin
         _RL DOFeremin
         _RL preminP
         _RL preminN
         _RL preminFe
         _RL preminSi

c for sinking matter
         _RL psinkP
         _RL psinkN
         _RL psinkFe
         _RL psinkSi
         _RL psinkphy(npmax)

c variables for conversions from phyto and zoo to DOM and POM
         _RL totphy_dop
         _RL totphy_pop
         _RL totphy_don
         _RL totphy_pon
         _RL totphy_dofe
         _RL totphy_pofe
         _RL totphy_dosi
         _RL totphy_posi

         _RL totzoo_dop
         _RL totzoo_pop
         _RL totzoo_don
         _RL totzoo_pon
         _RL totzoo_dofe
         _RL totzoo_pofe
         _RL totzoo_posi

         _RL NO2prod
         _RL NO3prod
  
         _RL facpz

         integer ITEST
c.................................................................

c set sum totals to zero
         totphy_pop = 0.d0
         totphy_dop = 0.d0
         totphy_don = 0.d0
         totphy_pon = 0.d0
         totphy_dofe = 0.d0
         totphy_pofe = 0.d0
         totphy_posi = 0.d0

         totzoo_dop = 0.d0
         totzoo_pop = 0.d0
         totzoo_don = 0.d0
         totzoo_pon = 0.d0
         totzoo_dofe = 0.d0
         totzoo_pofe = 0.d0
         totzoo_posi = 0.d0

         consumpPO4 = 0.0d0
         consumpNO3 = 0.0d0
         consumpNO2 = 0.0d0
         consumpNH4 = 0.0d0
         consumpFeT = 0.0d0
         consumpSi  = 0.0d0

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Determine ZooPlankton Temp Dep. Function: will affect maximum
c grazing rates
          do nz = 1,nzmax  
c              zooTempFunction(nz) = zooTempCoeff(nz)*EXP(
c    &             zooTempExp(nz)*(Tlocal - zooTempOptimum(nz)))
            zooTempFunction(nz) = 1.0d0
          end do   
Ccccccccccccccccccccccccccccccccccc ccccccccccccccccccccccccccccccc


c ******************** GROWTH OF PHYTO ****************************
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Determine phytoplantkon light limitation: will affect growth rate
          do np = 1, npmax
            ilimit(np)=(1.0d0 - EXP(-PARlocal*ksatPAR(np)/10))
     &                  *(EXP(-PARlocal*kinhib(np)/1000)**1.5)
          enddo
          if (debug.eq.1) print*,'ilimit',ilimit, PARlocal
c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Determine temperature Dependent Growth function for Phyto
          do np=1, npmax
c           phytoTempFunction(np) = phytoTempCoeff(np)*
c    &        EXP(phytoTempExp1(np)*(Tlocal - phytoTempOptimum(np))
c    &                            - phytoTempExp2(np)*
c    &       (abs(Tlocal - phytoTempOptimum(np)))**phytoDecayPower(np))
c New Temp Function With Eppley Envelope
               phytoTempFunction(np) = phytoTempCoeff(np)*
     &    (log(2.D0)/86400.D0)*(0.851D0*(1.066D0)**Tlocal)*
     &    exp(- phytoTempExp2(np)*
     &    (abs(Tlocal - phytoTempOptimum(np)))**phytoDecayPower(np))/
     &    tempnorm
c no temp limitation
c             phytoTempFunction(np) = 1.0d0
          enddo
          if (debug.eq.1) print*,'phytoTempFunction',
     &                          phytoTempFunction, Tlocal
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Determine phytoplankton nutrient limitation as mimimum of 
c P,N,Si,Fe. However N can be utilized in several forms, so
c also determine which is used
          do np=1, npmax
            limit(np) = 1.0d0
c P limitation
            dummy = PO4local/(PO4local+ksatPO4(np))
            if(dummy .lt. limit(np)) limit(np) = dummy
c Fe limitation
            dummy = FeTlocal/(FeTlocal+ksatFeT(np))
            if(dummy .lt. limit(np))limit(np) = dummy
c Si limiation
            if(R_SiP(np) .ne. 0.0)then
               dummy = Silocal/(Silocal+ksatSi(np))
               if(dummy .lt. limit(np))limit(np) = dummy
            endif
c N limitation
c Determine Which Nsource is Limiting for Consumption
c Will only consume least limiting
c nsource: genetic preference for {1:NH4&NO2 2:NH4 3:ALL Sources}
c Nsourcelimit marker for which nsource will be consumed {1:NO3 2:NO2 3:NH4}
            if(diazotroph(np) .ne. 1.0)then
               Ndummy = NH4local/(NH4local+ksatNH4(np))
               Nsourcelimit(np) = 3 
               if(nsource(np) .eq. 3)then
                   dummy = NO3local/(NO3local+ksatNO3(np))
                   if(dummy .gt. Ndummy)then
                        Nsourcelimit(np) = 1
                        Ndummy = dummy
                   endif   
               endif
               if((nsource(np).eq.1).OR.(nsource(np).eq.3)) then
                   dummy = NO2local/(NO2local+ksatNO2(np))
                   if(dummy .gt. Ndummy)then
                       Nsourcelimit(np) = 2
                       Ndummy = dummy
                   endif   
                endif
c Now Check Against General Nutrient Limiting Tendency
                if(Ndummy .lt. limit(np))limit(np) = Ndummy
             endif
           enddo
          if (debug.eq.1) print*,'nut limit',
     &                          limit, Tlocal
          if (debug.eq.1) print*,'Nsourcelimit',
     &                 Nsourcelimit
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c nutrient uptake by each phytoplankton
           do np=1, npmax
               PspecificPO4(np) = mu(np)*limit(np)*ilimit(np)*
     &                            phytoTempFunction(np)*phyto(np)
c        write(6,*)'np =',np, ' PspecificPO4 ='
c     &              ,PspecificPO4(np)
           enddo
           if (debug.eq.1) print*,'pspecificpo4', PspecificPO4
c ******************* END GROWTH PHYTO ******************************* 


c------------------------------------------------------------------------
c GRAZING sum contributions of all zooplankton
           do np=1,npmax
              grazing_phyto(np) = 0.0d0
              do nz = 1, nzmax
                   grazing_phyto(np) = grazing_phyto(np)
     &               + graze(np,nz)*zooP(nz)*zooTempFunction(nz)
              enddo
           enddo
           if (debug.eq.2) print*,'grazing_phyto',grazing_phyto
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c accumulate particulate and dissolved detritus
           do np=1, npmax
               totphy_pop=totphy_pop+
     &                     ExportFracP(np)*mortphy(np)*phyto(np)
               totphy_dop=totphy_dop+
     &                    (1.d0-ExportFracP(np))*mortphy(np)*phyto(np)
               totphy_pon=totphy_pon+ R_NP(np)*
     &                     ExportFracP(np)*mortphy(np)*phyto(np)
               totphy_don=totphy_don+ R_NP(np)*
     &                    (1.d0-ExportFracP(np))*mortphy(np)*phyto(np)
               totphy_pofe=totphy_pofe+ R_FeP(np)*
     &                     ExportFracP(np)*mortphy(np)*phyto(np)
               totphy_dofe=totphy_dofe+ R_FeP(np)*
     &                    (1.d0-ExportFracP(np))*mortphy(np)*phyto(np)
               totphy_posi=totphy_posi+ R_SiP(np)*
     &                     mortphy(np)*phyto(np)
            enddo 
            if (debug.eq.3) print*,'tot_phy_pop',totphy_pop
            if (debug.eq.3) print*,'tot_phy_dop',totphy_dop
            if (debug.eq.3) print*,'tot_phy_pon',totphy_pon
            if (debug.eq.3) print*,'tot_phy_don',totphy_don
            if (debug.eq.3) print*,'tot_phy_pofe',totphy_pofe
            if (debug.eq.3) print*,'tot_phy_dofe',totphy_dofe
            if (debug.eq.3) print*,'tot_phy_posi',totphy_posi


c cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c ****************** ZOO GRAZING RATE ****************************
c determine zooplankton grazing rates 
            do nz = 1, nzmax
c grazing: sum contribution from all phytoplankton
              grazingP(nz) = 0.0d0
              grazingN(nz) = 0.0d0
              grazingFe(nz) = 0.0d0
              grazingSi(nz) = 0.0d0
              do np = 1, npmax
               facpz = (phyto(np)/(phyto(np) + kgrazesat))
     &                  *zooTempFunction(nz)
               grazingP(nz) = grazingP(nz) + 
     &                         graze(np,nz)*facpz
               grazingN(nz) = grazingN(nz) + 
     &                         graze(np,nz)*R_NP(np)*facpz
               grazingFe(nz) = grazingFe(nz) + 
     &                          graze(np,nz)*R_FeP(np)*facpz
               grazingSi(nz) = grazingSi(nz) + 
     &                          graze(np,nz)*R_SiP(np)*facpz
              enddo
            enddo
            if (debug.eq.4) print*,'grazingP', grazingP
            if (debug.eq.4) print*,'grazingN', grazingN
            if (debug.eq.4) print*,'grazingFe', grazingFe
            if (debug.eq.4) print*,'grazingSi', grazingSi
c *************  END ZOO GRAZING *********************************
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c accumulate particulate and dissolved detritus
            do nz=1, nzmax
               totzoo_pop=totzoo_pop+
     &                     ExportFracZ(nz)*mortzoo(nz)*zooP(nz)
               totzoo_dop=totzoo_dop+
     &                    (1.d0-ExportFracZ(nz))*mortzoo(nz)*zooP(nz)
               totzoo_pon=totzoo_pon+ 
     &                     ExportFracZ(nz)*mortzoo(nz)*zooN(nz)
               totzoo_don=totzoo_don+
     &                    (1.d0-ExportFracZ(nz))*mortzoo(nz)*zooN(nz)
               totzoo_pofe=totzoo_pofe+
     &                     ExportFracZ(nz)*mortzoo(nz)*zooFe(nz)
               totzoo_dofe=totzoo_dofe+
     &                    (1.d0-ExportFracZ(nz))*mortzoo(nz)*zooFe(nz)
               totzoo_posi=totzoo_posi+ 
     &                     mortzoo(nz)*zooSi(nz)
            enddo
            if (debug.eq.5) print*,'totzoo_pop',totzoo_pop
            if (debug.eq.5) print*,'totzoo_dop',totzoo_dop
            if (debug.eq.5) print*,'totzoo_pon',totzoo_pon
            if (debug.eq.5) print*,'totzoo_don',totzoo_don
            if (debug.eq.5) print*,'totzoo_pofe',totzoo_pofe
            if (debug.eq.5) print*,'totzoo_dofe',totzoo_dofe
            if (debug.eq.5) print*,'totzoo_posi',totzoo_posi
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c ********************* NUTRIENT UPTAKE *******************************
c determine nutrient uptake
c consumption - sum of phytoplankton contributions
            do np = 1, npmax
c phospate uptake by each phytoplankton
               PspecificPO4(np) = mu(np)*limit(np)*ilimit(np)*
     &                            phytoTempFunction(np)*phyto(np)
c        write(6,*)'np =',np, ' PspecificPO4 ='
c     &              ,PspecificPO4(np)
               consumpPO4 = consumpPO4 + PspecificPO4(np)
               consumpFeT = consumpFeT + PspecificPO4(np)*R_FeP(np)
               consumpSi  = consumpSi  + PspecificPO4(np)*R_SiP(np)
c New Way of doing Nitrogen Consumption .......................
               if(diazotroph(np) .ne. 1.0)then
                 if(Nsourcelimit(np) .eq. 1)then
                    consumpNO3 = consumpNO3 + PspecificPO4(np)*R_NP(np)
                 elseif(Nsourcelimit(np) .eq. 2)then
                   consumpNO2 = consumpNO2 + PspecificPO4(np)*R_NP(np)
                 elseif(Nsourcelimit(np) .eq. 3)then
                    consumpNH4 = consumpNH4 + PspecificPO4(np)*R_NP(np)
                 end if
               end if
            enddo
           if (debug.eq.6) print*,'pspecificpo4', PspecificPO4
           if (debug.eq.6) print*,'consumpPO4', consumpPO4
           if (debug.eq.6) print*,'consumpFeT', consumpFeT
           if (debug.eq.6) print*,'consumpSi ', consumpsi 
           if (debug.eq.6) print*,'consumpNO3', consumpNO3
           if (debug.eq.6) print*,'consumpNO2', consumpNO2
           if (debug.eq.6) print*,'consumpNH4', consumpNH4
c ****************** END NUTRIENT UPTAKE ****************************

c sinking phytoplankton and POM
             if(bottom .eq. 1.0)then
              psinkP  = (wp_sink*POPuplocal)/(dzlocal)
              psinkN  = (wn_sink*PONuplocal)/(dzlocal)
              psinkFe = (wfe_sink*POFeuplocal)/(dzlocal)
              psinkSi = (wsi_sink*PSiuplocal)/(dzlocal)
              do np=1,npmax
               psinkPhy(np) =
     &                     (wsink(np)*Phytoup(np))/(dzlocal)
              enddo
            else
              psinkP  = (wp_sink*(POPuplocal-POPlocal))/(dzlocal)
              psinkN  = (wn_sink*(PONuplocal-PONlocal))/(dzlocal)
              psinkFe = (wfe_sink*(POFeuplocal-POFelocal))/(dzlocal)
              psinkSi = (wsi_sink*(PSiuplocal-PSilocal))/(dzlocal)
              do np=1,npmax
               psinkPhy(np) =
     &                  (wsink(np))*(Phytoup(np)-Phyto(np))/(dzlocal)
              enddo
            endif

c DOM remineralization rates
            DOPremin =  Kdop * DOPlocal
            DONremin =  Kdon * DONlocal
            DOFeremin =  KdoFe * DOFelocal

c remineralization of sinking particulate
            preminP  = Kpremin_P*POPlocal
            preminN  = Kpremin_N*PONlocal
            preminFe = Kpremin_Fe*POFelocal
            preminSi = Kpremin_Si*PSilocal

c chemistry
c NH4 -> NO2 -> NO3 by bacterial action
            NO2prod =  knita*NH4local
            NO3prod =  knitb*NO2local

c -------------------------------------------------------------------
c calculate tendency terms
c ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c phytoplankton
            do np=1,npmax
              dphytodt(np) =   PspecificPO4(np)
     &                        - grazing_phyto(np)*
     &              (phyto(np)/(phyto(np) + kgrazesat))
     &                        - mortphy(np)*phyto(np)
     &                        + psinkphy(np)
            enddo
c zooplankton
            do nz=1,nzmax
c zoo in P currency
              dzooPdt(nz)  = grazingP(nz)*zooP(nz) 
     &                           - mortzoo(nz)*zooP(nz)
c zooplankton in other currencies
C zooplankton stoichiometry varies according to food source
              dzooNdt(nz)  = grazingN(nz)*zooP(nz) 
     &                           - mortzoo(nz)*zooN(nz)
              dzooFedt(nz) = grazingFe(nz)*zooP(nz) 
     &                           - mortzoo(nz)*zooFe(nz)
              dzooSidt(nz) = grazingSi(nz)*zooP(nz) 
     &                           - mortzoo(nz)*zooSi(nz)
            enddo

c sum contributions to inorganic nutrient tendencies
            dPO4dt =  - consumpPO4 +  preminP  + DOPremin
            dNH4dt =  - consumpNH4 +  preminN  + DONremin 
     &                                   - NO2prod
            dNO2dt =  - consumpNO2                        
     &                                   + NO2prod - NO3prod
            dNO3dt =  - consumpNO3             
     &                                   + NO3prod
c-ONLYNO3   dNO3dt =  - consumpNO3 +  preminN  + DONremin
            dFeTdt =  - consumpFeT +  preminFe + DOFeremin
     &                 - scav*freefelocal + alpfe*inputFelocal/dzlocal
            dSidt  =  - consumpSi  +  preminSi

c tendency of dissolved organic pool
            dDOPdt  = totphy_dop  + totzoo_dop  - DOPremin 
            dDONdt  = totphy_don  + totzoo_don  - DONremin 
            dDOFedt = totphy_dofe + totzoo_dofe - DOFeremin 
c tendency of particulate detritus pools
            dpopdt  = totphy_pop  + totzoo_pop   - preminP + psinkP
            dpondt  = totphy_pon  + totzoo_pon   - preminN + psinkN
            dpofedt = totphy_pofe + totzoo_pofe  - preminFe + psinkFe
            dpSidt  = totphy_posi + totzoo_posi  - preminSi + psinkSi
c
c -------------------------------------------------------------------
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c --------------------------------------------------------------------------

         RETURN
         END
#endif  /*DARWIN*/
#endif  /*ALLOW_PTRACERS*/
c ==================================================================
