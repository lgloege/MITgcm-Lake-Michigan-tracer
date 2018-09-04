c
#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

c===============================================================================
C===============================================================================
CStartofinterface
      SUBROUTINE NPZDCAR_INIT_FIXED(myThid)                        
C     =============== Global data ==========================================
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"
#include "GCHEM.h"

        INTEGER myThid
C============== Local variables ============================================
      INTEGER i,j,k,bi,bj
      INTEGER tmp
      INTEGER prec
      CHARACTER*(MAX_LEN_MBUF) fn
C     /--------------------------------------------------------------\
C     |  initialise common block biochemical parameters               |
C     \--------------------------------------------------------------/

      k0=        4.d-2                   !atten coefficient water(m^-1)
      kc=        5.d-2                   !atten coefficient chl (m2 (mg chl)-1)
      phygrow=   1.D0 /(1.D0*86400.d0)   !max dino growth rate (s-1)
      phygrow2=  1.D0 /(.8D0*86400.d0)   !max diatom growth rate (s-1)
      zoograze=  1.D0 /(1.6D0*86400.d0)   !max zoo grazing rate (s-1)
      mort=      1.D0 /(15.D0*86400.d0)  !dino mortality rate (s-1)
      mort2=     1.D0 /(15.D0*86400.d0)  !diatom mortality rate (s-1)
      mortz=     1.D0 /(30.D0*86400.d0)  !zoo mortality rate (s-1)
c     mortz=     0.2 /86400.d0 *16.d0    !for quadratic
      ilim=      15.d0                   !dino light 1/2 saturation (W/m2)
      ilim2 =    12.d0                   !diatom light 1/2 saturation (W/m2)
      nlim=      0.05                    !dino po4 1/2 saturation (uM)
      nlim2 =    0.1                     !diatom po4 1/2 saturation (uM)
      slim2=     2.d0                    !diatom sio2 1/2 saturation (uM)
      flim=      1d-5                    !dino fe 1/2 saturation (uM)
      flim2=     5d-5                    !diatom fe 1/2 saturation (uM)
      zplat=     1.d0                    !palatability of dino
      zplat2=    4.d-1                   !palatability of diatoms
      plim=      1.2d0 /16.d0            !zoo phy 1/2 saturation (uM)
      reminn=    1.D0 /(70.D0*86400.d0)  !remin rate of DOP/POP (s-1)
      remins=    1.d0 /(360.D0*86400.d0) !remin rate of DOS/POS (s-1)
      reminf=    1.D0 /(70.D0*86400.d0)  !remin rate of DOF/POF (s-1)
      reminc=    1.D0 /(70.D0*86400.d0)  !remin rate of DOP/POP (s-1)
      dissc=     1.d0 /(360.D0*86400.d0) !dissolution rate PIC (s-1)
      gampn=     0.3d0                   !zoo dino assimilation coeff
      gampn2=    0.3d0                   !zoo diatom assimilation coeff
      donfracmn1 = 0.5d0                 !fraction of mortality to DOP/POP
      donfracmn2 = 0.2d0
      donfracmn = 0.2d0
      donfracgn= 0.5d0                   !fraction of grazing to DOP/POP
      donfracmf1= 0.5d0                  !fraction of mortality to DOF/POF
      donfracmf2= 0.2d0
      donfracmf=0.2d0
      donfracgf= 0.5d0                   !fraction of grazing to DOF/POF
      donfracmc1= 0.5d0                  !fraction of mortality to DOF/POF
      donfracmc2= 0.2d0
      donfracmc=0.2d0
      donfracgc= 0.5d0                   !fraction of grazing to DOF/POF
      Rsip2=     25.d0                   !ratio Si to P in diatoms
      Rfep=      1.0d-4                  !ratio Fe to P in dino
      Rfep2=     1.0d-3                  !ratio Fe to P in diatoms
      Rcp=      120                      !ratio C to P in dino
      Rcp2=      120                     !ratio C to P in diatoms
      Rop=       170                     !ratio O to P for plankton
      Rnp=        16                     !ratio N to P in ocean             
      alpfe=     0.025                   !solubility of Fe dust
      scav=      0.4/(360.d0*86400.d0)   !iron chem scavenging rate (s-1)
      freefemax = .3e-3                  ! max free fe
      ligand_tot=1.d-3                   !total ligand (uM)
      ligand_stab=1.d5                   !ligand stability rate ratio
      rainratio=0.07                     !rain ratio
      o2crit= 4.0d-6                     !critical O2 concentration
c minimum populations
      phymin=    1.d-5                   !seed population of phy (uM)
      grazlim=   5.d-4                   !grazlim (uM)
      zoomin=    1.d-4                   !egg population of zoo (uM)
      zoominfe=  zoomin*Rfep2
      zoominc=   zoomin*Rcp2
cQQ make sure wn_sink*dt<delz
      wn_sink= 2900.d0/(360.d0*86400.d0) !sinking rate of POP (m/s)
      ws_sink= 4000.d0/(360.d0*86400.d0) !sinking rate of POS (m/s)
      wf_sink= 2900.d0/(360.d0*86400.d0) !sinking rate of POF (m/s)
      wc_sink= 2900.d0/(360.d0*86400.d0) !sinking rate of POC (m/s)
      wpic_sink= 4000.d0/(360.d0*86400.d0) !sinking rate of PIC (m/s)
c for chl
      chlpmax=40.d0                      ! mg Chl/mmolP
      chlpmin=16.d0                      ! mg Chl/mmolP
      istar=70                           ! uEin/m2/d
c for temperature function of growth rate
      temp_coeff_base=1.066              ! unitless, Eppley
      temp_coeff_norm=3.6296             ! normalization, -2:35 mean=1
c
ccccccccccccccccccccccccccccccccc
c parameters for air-sea parts
ccccccccccccccccccccccccccccccccc
C set up coefficients for DIC chemistry
C define Schmidt no. coefficients for CO2
      sca1 = 2073.1
      sca2 = -125.62
      sca3 =    3.6276
      sca4 =   -0.043219
C define Schmidt no. coefficients for O2
C based on Keeling et al [GBC, 12, 141, (1998)]
      sox1 = 1638.0
      sox2 = -81.83
      sox3 =    1.483
      sox4 =   -0.008004

C coefficients for determining saturation O2
      oA0=  2.00907
      oA1=  3.22014
      oA2=  4.05010
      oA3=  4.94457
      oA4= -2.56847E-1
      oA5=  3.88767
      oB0= -6.24523E-3
      oB1= -7.37614E-3
      oB2= -1.03410E-2
      oB3= -8.17083E-3
      oC0= -4.88682E-7


C set carbon mol/m3 <---> mol/kg conversion factor
      permil = 1.0 / 1024.5

#ifdef ALLOW_MNC
      IF ( useMNC ) THEN
        CALL NPZDCAR_MNC_INIT( myThid )
      ENDIF
#endif /* ALLOW_MNC */


        RETURN
        END
C============================================================================
#endif
#endif

