c $Header: /u/gcmpack/MITgcm/pkg/npzdcar/npzdcar_swapffields.F,v 1.4 2003/10/09 04:19:19 edhill Exp $

#include "NPZDCAR_OPTIONS.h"


      subroutine npzdcar_SwapFFields(
     U                            ffld0,
     U                            ffld1,
     I                            mythid
     &                          )

c     ==================================================================
c     SUBROUTINE npzdcar_SwapFFields
c     ==================================================================
c
c     o Copy a forcing field ffld1 to ffld0 and set ffld0 to zero.
c
c     started: Christian Eckert eckert@mit.edu  30-Jun-1999
c
c     changed: Christian Eckert eckert@mit.edu  14-Jan-2000
c
c              - Restructured the code in order to create a package
c                for the MITgcmUV.
c
c              Christian Eckert eckert@mit.edu  12-Feb-2000
c
c              - Changed Routine names (package prefix: npzdcar_)
c
c     ==================================================================
c     SUBROUTINE npzdcar_SwapFFields
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"

c     == routine arguments ==

      integer mythid
      _RL ffld0(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)
      _RL ffld1(1-olx:snx+olx,1-oly:sny+oly,nsx,nsy)

c     == local variables ==

      integer bi
      integer bj
      integer  i
      integer  j
      integer  itlo,ithi
      integer  jtlo,jthi

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)

      do bj = jtlo,jthi
        do bi = itlo,ithi
          do j = 1,sny
            do i = 1,snx
              ffld0(i,j,bi,bj) = ffld1(i,j,bi,bj)
              ffld1(i,j,bi,bj) = 0. _d 0
            enddo
          enddo
        enddo
      enddo

      end

c$$$      subroutine exf_SwapFFields_3d(
c$$$     U                            ffld0,
c$$$     U                            ffld1,
c$$$     I                            mythid
c$$$     &                          )
c$$$
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_SwapFFields_3d
c$$$c     ==================================================================
c$$$c
c$$$c     o Copy a forcing field ffld1 to ffld0 and set ffld0 to zero.
c$$$c
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_SwapFFields
c$$$c     ==================================================================
c$$$
c$$$      implicit none
c$$$
c$$$c     == global variables ==
c$$$
c$$$#include "EEPARAMS.h"
c$$$#include "SIZE.h"
c$$$
c$$$c     == routine arguments ==
c$$$
c$$$      integer mythid
c$$$      _RL ffld0(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
c$$$      _RL ffld1(1-olx:snx+olx,1-oly:sny+oly,nr,nsx,nsy)
c$$$
c$$$c     == local variables ==
c$$$
c$$$      integer bi
c$$$      integer bj
c$$$      integer  i
c$$$      integer  j
c$$$      integer  k
c$$$      integer  itlo,ithi
c$$$      integer  jtlo,jthi
c$$$
c$$$c     == end of interface ==
c$$$
c$$$      jtlo = mybylo(mythid)
c$$$      jthi = mybyhi(mythid)
c$$$      itlo = mybxlo(mythid)
c$$$      ithi = mybxhi(mythid)
c$$$
c$$$      do bj = jtlo,jthi
c$$$        do bi = itlo,ithi
c$$$          do k = 1,nr
c$$$            do j = 1,sny
c$$$              do i = 1,snx
c$$$                ffld0(i,j,k,bi,bj) = ffld1(i,j,k,bi,bj)
c$$$                ffld1(i,j,k,bi,bj) = 0. _d 0
c$$$              enddo
c$$$            enddo
c$$$          enddo
c$$$        enddo
c$$$      enddo
c$$$
c$$$      end
c$$$
c$$$      subroutine exf_swapffields_xz(
c$$$     U                               ffld0,
c$$$     U                               ffld1,
c$$$     I                               mythid
c$$$     &                             )
c$$$
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_swapffields_xz
c$$$c     ==================================================================
c$$$c
c$$$c     o Copy a forcing field ffld1 to ffld0 and set ffld0 to zero.
c$$$c
c$$$c     started: heimbach@mit.edu 01-May-2001
c$$$c
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_swapffields_xz
c$$$c     ==================================================================
c$$$
c$$$      implicit none
c$$$
c$$$c     == global variables ==
c$$$
c$$$#include "EEPARAMS.h"
c$$$#include "SIZE.h"
c$$$
c$$$c     == routine arguments ==
c$$$
c$$$      integer mythid
c$$$      _RL ffld0(1-olx:snx+olx,Nr,nsx,nsy)
c$$$      _RL ffld1(1-olx:snx+olx,Nr,nsx,nsy)
c$$$
c$$$c     == local variables ==
c$$$
c$$$      integer bi, bj
c$$$      integer  i, k
c$$$      integer  itlo,ithi
c$$$      integer  jtlo,jthi
c$$$
c$$$c     == end of interface ==
c$$$
c$$$      jtlo = mybylo(mythid)
c$$$      jthi = mybyhi(mythid)
c$$$      itlo = mybxlo(mythid)
c$$$      ithi = mybxhi(mythid)
c$$$
c$$$      do bj = jtlo,jthi
c$$$        do bi = itlo,ithi
c$$$          do k = 1,Nr
c$$$            do i = 1,snx
c$$$              ffld0(i,k,bi,bj) = ffld1(i,k,bi,bj)
c$$$              ffld1(i,k,bi,bj) = 0. _d 0
c$$$            enddo
c$$$          enddo
c$$$        enddo
c$$$      enddo
c$$$
c$$$      end
c$$$
c$$$      subroutine exf_swapffields_yz(
c$$$     U                               ffld0,
c$$$     U                               ffld1,
c$$$     I                               mythid
c$$$     &                             )
c$$$
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_swapffields_yz
c$$$c     ==================================================================
c$$$c
c$$$c     o Copy a forcing field ffld1 to ffld0 and set ffld0 to zero.
c$$$c
c$$$c     started: heimbach@mit.edu 01-May-2001
c$$$c
c$$$c     ==================================================================
c$$$c     SUBROUTINE exf_swapffields_yz
c$$$c     ==================================================================
c$$$
c$$$      implicit none
c$$$
c$$$c     == global variables ==
c$$$
c$$$#include "EEPARAMS.h"
c$$$#include "SIZE.h"
c$$$
c$$$c     == routine arguments ==
c$$$
c$$$      integer mythid
c$$$      _RL ffld0(1-oly:sny+oly,Nr,nsx,nsy)
c$$$      _RL ffld1(1-oly:sny+oly,Nr,nsx,nsy)
c$$$
c$$$c     == local variables ==
c$$$
c$$$      integer bi, bj
c$$$      integer  j, k
c$$$      integer  itlo,ithi
c$$$      integer  jtlo,jthi
c$$$
c$$$c     == end of interface ==
c$$$
c$$$      jtlo = mybylo(mythid)
c$$$      jthi = mybyhi(mythid)
c$$$      itlo = mybxlo(mythid)
c$$$      ithi = mybxhi(mythid)
c$$$
c$$$      do bj = jtlo,jthi
c$$$        do bi = itlo,ithi
c$$$          do k = 1,Nr
c$$$            do j = 1,sny
c$$$              ffld0(j,k,bi,bj) = ffld1(j,k,bi,bj)
c$$$              ffld1(j,k,bi,bj) = 0. _d 0
c$$$            enddo
c$$$          enddo
c$$$        enddo
c$$$      enddo
c$$$
c$$$      end
