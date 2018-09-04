c
#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c===============================================================================
C===============================================================================
CStartofinterface
      SUBROUTINE DARWIN_INIT_FIXED(myThid)                        
C     =============== Global data ==========================================
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "DARWIN_IO.h"
#include "GCHEM.h"
#include "PLANKTON.h"

        INTEGER myThid
C============== Local variables ============================================
      _RL pday
      INTEGER i,j,k,bi,bj
      INTEGER tmp
      INTEGER prec
      CHARACTER*(MAX_LEN_MBUF) fn
C     /--------------------------------------------------------------\
C     |  initialise common block biochemical parameters               |
C     \--------------------------------------------------------------/

      print*,'QQ loading parameters'

c c define 1 day in seconds
         pday = 86400.0d0

c attenuation coefficients
      k0=        4.d-2                   !atten coefficient water(m^-1)
cswd  kc=        4.d-2*16.d0*1.d0        !atten coefficient phy((uM m)-1)
      kc=        4.d-2*16.d0*1.d0        !atten coefficient phy((uM m)-1)
c for chl
      chlpmax=40.d0                      ! mg Chl/mmolP
      chlpmin=16.d0                      ! mg Chl/mmolP
      istar=90                           ! w/m2
c iron related
      alpfe=     0.04                    !solubility of Fe dust
      scav=      0.4/(360.d0*86400.d0)  !iron chem scavenging rate (s-1)
      ligand_tot=1.d-3                   !total ligand (uM)
      ligand_stab=2.d5                   !ligand stability rate ratio
      freefemax = .4e-3                  ! max free fe
c
       kgrazesat = 0.1d0
c
c oxidation rates for ammonium and nitrite
c i.e. Knita ...    NH4 -> NO2
c i.e. Knitb ...    NO2 -> NO3
       Knita = 1.0d0/(10.0*pday)
       Knitb = 1.0d0/(30.0*pday)

c set growth days ...small or big organism?
       Smallgrow = .7d0
       Biggrow   = .45d0
       Smallgrowrange = 0.d0
       Biggrowrange = 0.d0
c set mort days ...small or big organism?
       Smallmort = 10.d0
       Bigmort   = 10.d0
       Smallmortrange = 0.d0
       Bigmortrange = 0.d0
c set export fraction ...small or big organism?
       Smallexport = 0.2d0
       Bigexport   = 0.5d0
c set sinking rates (m/s)... small or big organism?
       SmallSink = 0.0d0/pday
       BigSink =  0.5d0/pday   !0.5d0/pday
c set parameters for light function for phyto growth
       smallksatpar =    0.12d0 ! 0.8d0
       smallksatparstd = 0.10    ! 0.3d0
       smallkinhib =     6.0     ! 2.0d0
       smallkinhibstd =  0.10    ! 0.5d0
       Bigksatpar =      0.12d0  ! 0.35d0
       Bigksatparstd =   0.03d0  ! 0.1d0
       Bigkinhib =       1.0d0   ! 0.5d0
       Bigkinhibstd =    0.05d0   ! 0.1d0
c set temperature function
       tempcoeff1 = 1.d0/3.d0
       tempcoeff2_small = 0.001d0
       tempcoeff2_big   = 0.0003d0
       tempcoeff3 = 1.04d0
       tempmax = 30.d0      ! 32.d0
       temprange = 32.d0    ! 30.d0
       tempnorm = 0.3  ! 1.d0
       tempdecay = 4.d0
c set phosphate half stauration constants .. small or big organism
       SmallPsat=0.015d0
       BigPsat=0.035d0
       SmallPsatrange=0.02d0
       BigPsatrange=0.02d0
c set NH4/NO2 frac, so that NH4/NO2 can be preferred nitrogen source
       ksatNH4fac=0.2d0
       ksatNO2fac=.75d0
c ammonia and nitrite inhibition
       sig1 = 4.6
       sig2 = 4.6
       sig3 = 4.6
       ngrowfac = .9d0
       ilight = 30.d0
c set si half sat
       val_ksatsi=2.d0
c set nutrient ratios for phyto
       val_R_SiP_diatom=16.0d0
       val_R_NP_diaz=40.0d0
       val_RFeP_diaz=7.5d-3
       val_R_NP=16.0d0
       val_RFeP=2.5d-3/2
c set grazing rates .. small or big organism?
       GrazeFast = 1.0d0/(5.0d0*pday)
       GrazeSlow = 1.0d0/(30.0d0*pday)
c set grazing effeciency
       GrazeEffsmall=0.6
       GrazeEffbig  =0.2
c set zoo mortality
       ZoomortSmall = 1.0d0/(30.0*pday)
       ZoomortBig = 1.0d0/(30.0*pday)
c set zoo exportfrac
       ZooexfacSmall = 0.2d0
       ZooexfacBig = 0.5d0
c minimum phyto (below which grazing and mortality doesn't happen)
       phymin = 1e-10
c DOM remin rates
         Kdop = 1.0d0/(360.0d0*pday)
         Kdon = 1.0d0/(360.0d0*pday)
         KdoFe = 1.0d0/(360.0d0*pday)
c Particulate detritus remin rates
c z* = wx_sink/Kremin_X
c for e-folding length scale, z* = 300 m
c choose Kremin_X = 1/30 day-1, wx_sink = 10 m day-1
         Kpremin_P = 1.0d0/(30.0d0*pday)
         Kpremin_N = Kpremin_P
         Kpremin_Fe = Kpremin_P
         Kpremin_Si = 1.0d0/(300.0d0*pday)
c sinking rate for particulate matter (m/s)
         wp_sink = 10.0/pday
         wn_sink = wp_sink
         wfe_sink = wp_sink
         wsi_sink = wp_sink


        RETURN
        END
C============================================================================
#endif
#endif

