#include "CPP_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c ==========================================================
c SUBROUTINE DARWIN_INIT_VARI()
c initialize stuff for generalized plankton model
c 
CMICK        SUBROUTINE DARWIN_INIT_VARI()
        SUBROUTINE DARWIN_INIT_VARI(myThid)

        IMPLICIT NONE

#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "PLANKTON.h"
#include "GCHEM.h"

C !INPUT PARAMETERS: ===================================================
C  myThid               :: thread number
      INTEGER myThid

CEOP

 
        _RL RandNo
        INTEGER np
        INTEGER nz
        INTEGER nrand
        INTEGER Iseed
        INTEGER IRand

c test....................
c       write(6,*)'testing in npzd2fe_init_vari '
c test....................
     

c set up ecosystem coefficients
c
c seed randomization
         Iseed = gchem_int1
         do nrand = 1,Iseed
           Irand = 0
           RandNo = rand(Irand)
         end do
         print*,'QQ random', Iseed, RandNo

c initialize total number of functional groups tried
         ngroups = 0
         do np = 1, npmax
            call generate_phyto(MyThid, np)
         end do

c %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c    for zooplankton
c assume zoo(1) = small, zoo(2) = big
c then grazing efficiency according to size
         zoosize(1) = 0.0d0
         zoosize(2) = 1.0d0

c grazing rates according to "allometry"
c big grazers preferentially eat big phyto etc...
         do np=1,npmax
           do nz=1,nzmax
             if(zoosize(nz) .eq. physize(np))then
               graze(np,nz) = GrazeFast 
             else 
               graze(np,nz) = GrazeSlow 
             end if
           end do
         end do

c zooplankton export/mortality       
c small zooplankton (zoosize = 0.) lower export fraction
         do nz = 1, nzmax
           if(zoosize(nz) .eq. 0.0)then 
             ExportFracZ(nz) = ZooexfacSmall
             mortzoo(nz) = ZoomortSmall
           else
             ExportFracZ(nz) = ZooexfacBig
             mortzoo(nz) = ZoomortBig
           endif
         end do

c write out initial phyto characteristics
         open(15,file='plankton-ini-char.dat',status='unknown')
         open(16,file='plankton_ini_char_nohead.dat',status='unknown')
         write(15,*)'diat diaz size   mu  mort   Rnp  Rfep   Rsip wsink 
     &  KsP  KsN   KsFe    KsSi     g1      g2     Kpar  Kinh  Topt nsrc 
     & np'
         do np = 1, npmax
           write(15,110)diatom(np),diazotroph(np),physize(np),
     &                   1.0/(mu(np)*86400.), 1.0/(mortphy(np)*86400.),
     &                   R_NP(np),R_FeP(np)*1000.,R_SiP(np),
     &                   wsink(np),
     &                   KsatPO4(np),KsatNO3(np),KsatFeT(np)*1000.
     &                  ,KsatSi(np),
     &                   graze(np,1),graze(np,2),
     &                   KsatPAR(np),Kinhib(np),
     &                   phytoTempOptimum(np),nsource(np),np
            write(16,110)diatom(np),diazotroph(np),physize(np),
     &                   1.0/(mu(np)*86400.),1.0/(mortphy(np)*86400.),
     &                   R_NP(np),R_FeP(np)*1000.,R_SiP(np),
     &                   wsink(np),
     &                   KsatPO4(np),KsatNO3(np),KsatFeT(np)*1000.
     &                  ,KsatSi(np),
     &                   graze(np,1),graze(np,2),
     &                   KsatPAR(np),Kinhib(np),
     &                   phytoTempOptimum(np),nsource(np),np
         end do
         close(15)
         close(16)
 110     format(3f5.0,f6.2,4f6.0,f6.1,4f7.3,2e10.1,3f6.1,2i5)


c test....................
c       write(6,*)'finishing npzd2fe_init_vari '
c test....................

         RETURN 
         END 
#endif  /*DARWIN*/
#endif  /*ALLOW_PTRACERS*/
c ==========================================================

