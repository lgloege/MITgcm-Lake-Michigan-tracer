C $Header: /u/gcmpack/MITgcm/eesupp/src/mds_byteswapr4.F,v 1.1 2005/08/23 13:21:08 jmc Exp $
C $Name:  $

#include "CPP_EEOPTIONS.h"

      subroutine MDS_BYTESWAPR4( n, arr )
C IN:
C   n		integer - Number of 4-byte words in arr
C IN/OUT:
C   arr		real*4  - Array declared as real*4(n)
C
C Created: 05/05/99 adcroft@mit.edu (This is an unfortunate hack!!)

      implicit none
C Arguments
      integer n
      character*(*) arr
C Local
      integer i
      character*(1) cc
C     ------------------------------------------------------------------
      do i=1,4*n,4
       cc=arr(i:i)
       arr(i:i)=arr(i+3:i+3)
       arr(i+3:i+3)=cc
       cc=arr(i+1:i+1)
       arr(i+1:i+1)=arr(i+2:i+2)
       arr(i+2:i+2)=cc
      enddo
C     ------------------------------------------------------------------
      return
      end
