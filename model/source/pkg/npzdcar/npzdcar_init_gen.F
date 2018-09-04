#include "NPZDCAR_OPTIONS.h"
      subroutine npzdcar_init_gen ( 
     &     genconst, genfld, gen0, gen1, mythid )

c     ==================================================================
c     SUBROUTINE npzdcar_init_gen
c     ==================================================================
c
c     o 
c
c     started: Ralf.Giering@FastOpt.de 25-Mai-2000
c     changed: heimbach@mit.edu 10-Jan-2002
c              heimbach@mit.edu: totally re-organized npzdcar_set_... 
c              replaced all routines by one generic routine
c
c     ==================================================================
c     SUBROUTINE npzdcar_init_gen
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

#include "npzdcar_param.h"

c     == routine arguments ==

      _RL genconst
      _RL genfld(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL gen0  (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL gen1  (1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      integer mythid

c     == local variables ==

      integer bi, bj
      integer i, j

c     == end of interface ==

      do bj = mybylo(mythid), mybyhi(mythid)
        do bi = mybxlo(mythid), mybxhi(mythid)
          do j = 1-oly, sny+oly
            do i = 1-olx, snx+olx
              genfld(i,j,bi,bj)  = genconst
              gen0(i,j,bi,bj)    = genconst
              gen1(i,j,bi,bj)    = genconst
            enddo
          enddo
        enddo
      enddo

      end
