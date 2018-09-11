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
CMICK #include "NPZD2Fe.h"
#include "DARWIN-SMALL.h"
#include "GCHEM.h"
#include "PLANKTON.h"

        INTEGER myThid
C============== Local variables ============================================
      INTEGER i,j,k,bi,bj
      INTEGER tmp
      INTEGER prec
      CHARACTER*(MAX_LEN_MBUF) fn
      INTEGER np
      INTEGER nz
C     /--------------------------------------------------------------\
C     |  initialise common block biochemical parameters               |
C     \--------------------------------------------------------------/

      print*,'QQ loading parameters'

c set some general parameters
      k0=        4.d-2                   !atten coefficient water(m^-1)
cswd  kc=        4.d-2*16.d0*1.d0        !atten coefficient phy((uM m)-1)
      kc=        4.d-2*16.d0*1.d0/10.d0  !atten coefficient phy((uM m)-1)
c for chl
      chlpmax=40.d0                      ! mg Chl/mmolP
      chlpmin=16.d0                      ! mg Chl/mmolP
      istar=90                           ! w/m2
c iron related
      alpfe=     0.02                    !solubility of Fe dust
      scav=      0.4/(360.d0*86400.d0)  !iron chem scavenging rate (s-1)
      ligand_tot=1.d-3                   !total ligand (uM)
      ligand_stab=2.d5                   !ligand stability rate ratio
      freefemax = .4e-3                  ! max free fe
c mick - what are units of ligand_stab?

c particulate detritus sinking rates
c make sure wn_sink*dt<delz for numerical stability!!!
c     wn_sink= 10.d0/(86400.d0) !sinking rate of POP (m/s)
c     wsi_sink= 20.d0/(86400.d0) !sinking rate of POS (m/s)
c     wf_sink= 10.d0/(86400.d0) !sinking rate of POF (m/s)


c generate phytoplankton functional groups...
      do np = 1, npmax
         CALL GENERATE_PHYTO(MyThid, np)
      end do
 
c set up zooplankton groups
c     zoograze=  1.D0 /(.8D0*86400.d0)   !max zoo grazing rate (s-1)
c     mortz=     1.D0 /(30.D0*86400.d0)  !zoo mortality rate (s-1)
c     phymin=    1.d-5                   !seed population of phy (uM)
c     grazlim=   5.d-4                   !grazlim (uM)
c     zoomin=    1.d-4                   !egg population of zoo (uM)
c     plim=       0.1d0                  !zoo phy 1/2 saturation (uM)
c     reminn=    1.D0 /(100.D0*86400.d0)  !remin rate of DOP/POP (s-1)
c     remins=    1.d0 /(320.D0*86400.d0) !remin rate of DOS/POS (s-1)
c     reminf=    1.D0 /(100.D0*86400.d0)  !remin rate of DOF/POF (s-1)



c plot initial NO3 field
c     CALL PLOT_FIELD_XYZRL( Nit, 'Initial Nitrate' ,
c    &                       Nr, 1, myThid )

        RETURN
        END
C============================================================================
#endif
#endif

