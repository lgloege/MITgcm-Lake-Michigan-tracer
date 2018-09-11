#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c ==========================================================
c SUBROUTINE GENERATE_PHYTO
c generate parameters for "functional group" of phyto (index np)
c using a "Monte Carlo" approach
c Mick Follows, Scott Grant Fall/Winter 2005
c modified Stephanie Dutkiewicz Spring 2005
c ==========================================================
        SUBROUTINE GENERATE_PHYTO(myThid, np)

        implicit none
cmick   include "PLANKTON.h"
#include "PLANKTON.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
        INTEGER myThid
CEOP


c local variables
        _RL RandNo
        _RL growthdays
        _RL mortdays
        _RL pday
        _RL year
        _RL month
        _RL fiveday
        _RL rtime
        _RL standin
        INTEGER np
        INTEGER nz
        INTEGER Irand
        INTEGER signvar
c
        standin=0.d0

c length of day (seconds)
        pday = 86400.0d0

c each time generate another functional group add one to ngroups
        ngroups = ngroups + 1

c RANDOM NUMBERS
c phyto either "small" (physize(np)=0.0) or "big" (physize(np)=1.0)
c at this point independent of whether diatom or not
        Irand = 0
        RandNo = rand(Irand)
        if(RandNo .gt. 0.500d0)then
          physize(np) = 1.0d0
        else
          physize(np) = 0.0d0
        end if
c
c phyto either diatoms (diatom=1.0) and use silica or not (diatom=0.0)
c if they are large
        if (physize(np).eq.1.0d0) then
          Irand = 0
          RandNo = rand(Irand)
          if(RandNo .gt. 0.500d0)then
            diatom(np) = 1.0d0
          else
            diatom(np) = 0.0d0
          end if
        else
           diatom(np) = 0.0d0
        endif
c TEST ...........................................
c       diatom(np) = 0.0d0
c       write(6,*)'FIXED - no DIATOM '
c TEST ...........................................



c phyto either diazotrophs (diazotroph=1.0) or not (diazotroph=0.0)
        Irand = 0
        RandNo = rand(Irand)
        if(RandNo .gt. 0.500d0)then
          diazotroph(np) = 1.0d0
        else
          diazotroph(np) = 0.0d0
        end if
c TEST ...........................................
        diazotroph(np) = 0.0d0
        write(6,*)'FIXED - no DIAZO '
c TEST ...........................................


c growth rates
        Irand = 0
        RandNo = rand(Irand)
c big/small phyto growth rates..
        if(physize(np) .eq. 1.0d0)then
c         growthdays = .50d0 + RandNo
          growthdays = Biggrow
        else
c         growthdays = 1.d0 + RandNo
          growthdays = Smallgrow
        end if
c but diazotrophs always slower due to energetics
        if(diazotroph(np) .eq. 1.0)growthdays = 1.6d0 + RandNo*0.5
c now convert to a growth rate
        mu(np) = 1.0d0/(growthdays*pday)

c mortality and export fraction rates
        Irand = 0
        RandNo = rand(Irand)
c big/small phyto mortality rates..
        if(physize(np) .eq. 1.0d0)then
c         mortdays = RandNo*Bigmort
          mortdays = Bigmort
          ExportFracP(np)=Bigexport
        else
c         mortdays = 1.d0 + RandNo
          mortdays = Smallmort
          ExportFracP(np)=Smallexport
        end if
c but diazotrophs always slower due to energetics
c       if(diazotroph(np) .eq. 1.0)growthdays = 1.6d0 + RandNo*0.5
c now convert to a growth rate
        mortphy(np) = 1.0d0/(mortdays*pday)



c nutrient source 
         if(diazotroph(np) .ne. 1.0)then
           Irand = 0
           RandNo = rand(Irand)
           if(RandNo .gt. 0.670d0)then
             nsource(np) = 1
           elseif(RandNo .lt. 0.33d0)then
             nsource(np) = 2
           else
             nsource(np) = 3
           endif 
         end if 

c..........................................................
c generate phyto Temperature Function parameters  
c.......................................................
        phytoTempCoeff(np) = 1.0d0
        phytoTempExp1(np) = 0.063d0 
        phytoTempExp2(np) = 0.002d0  

        Irand = 0
        RandNo = rand(Irand)
cswd    phytoTempOptimum(np) = 30.0d0 - RandNo*28.0d0 
        phytoTempOptimum(np) = 32.0d0 - RandNo*30.0d0
        phytoDecayPower(np) = 3.0d0 
        
        write(6,*)'generate Phyto: np = ',np,' Topt =',
     &    phytoTempOptimum(np)


c ...............................................
        write(6,*)'generate phyto: np = ',np,' growthdays = ',growthdays
c ...............................................

c stoichiometric ratios for each functional group of phyto 
c relative to phosphorus  - the base currency nutrient
c set Si:P
        if(diatom(np) .eq. 1.0)then
          R_SiP(np) = 16.0d0
        else
          R_SiP(np) = 0.0d0
        end if
c set N:P and iron requirement according to diazotroph status
        if(diazotroph(np) .eq. 1.0)then
          R_NP(np) = 40.0d0
          R_FeP(np) = 7.5d-3 
        else
          R_NP(np) = 16.0d0
          R_FeP(np) = 2.5d-3
        end if
c set sinking rates according to allometry
        if(physize(np) .eq. 1.0)then
           wsink(np) = BigSink
        else 
           wsink(np) = SmallSink
        end if 
c half-saturation coeffs 

        Irand = 0
        RandNo = rand(Irand)
        if(physize(np) .eq. 1.0)then
           ksatPO4(np) = BigPsat + RandNo*0.01
        else
           ksatPO4(np) = SmallPsat + RandNo*0.01
        endif
        ksatNO3(np) = ksatPO4(np)*R_NP(np)
        ksatNO2(np) = ksatNO3(np)
c Made ksatNH4 smaller since it is the prefered source
        ksatNH4(np) = ksatNO3(np)*0.5d0
        ksatFeT(np) = ksatPO4(np)*R_FeP(np)
        ksatSi(np)  = 2.0


cNEW Light parameters:
c     ksatPAR {0.1 - 1.3}
c     0.35=Av High Light Adapted, 0.8=Av Low Light Adapted
c     kinhib  {0.0 - 3.0}
c     0.5 =Av High Light Adapted, 2.0=Av Low Light Adapted
c High Light Groups for Large size:
              if(physize(np) .eq. 1.0d0)then
                 Irand = 0
                 RandNo = rand(Irand)
                 call invnormal(standin,RandNo,Bigksatpar,Bigksatparstd)
                 ksatPAR(np) = abs(standin)

                 Irand = 0
                 RandNo = rand(Irand)
                 CALL invnormal(standin,RandNo,Bigkinhib,Bigkinhibstd)
                 kinhib(np) = abs(standin)
              else
c Low Light Groups for Small size:
                 Irand = 0
                 RandNo = rand(Irand)
                 CALL invnormal(standin,RandNo,smallksatpar,
     &                                               smallksatparstd)
                 ksatPAR(np) = abs(standin)

                 Irand = 0
                 RandNo = rand(Irand)
                 CALL invnormal(standin,RandNo,smallkinhib,
     &                                                smallkinhibstd)
                 kinhib(np) = abs(standin)
              endif
         write(6,*)'generate Phyto: np = ',np,' ksatPAR, kinhib =',
     &          ksatPAR(np), kinhib(np)

        RETURN
        END
#endif  /*DARWIN*/
#endif  /*ALLOW_PTRACERS*/

c ===========================================================
