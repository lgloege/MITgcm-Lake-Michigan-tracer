C $Header: /u/gcmpack/MITgcm/pkg/fizhi/fizhi_init_vegsurftiles.F,v 1.6 2005/08/23 18:25:33 molod Exp $
C $Name:  $

#include "FIZHI_OPTIONS.h"
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: FIZHI_INIT_VEGSURFTILES
C     !INTERFACE:
      subroutine fizhi_init_vegsurftiles(nymd,nhms,prec,myThid)

C     !DESCRIPTION:
C      Read in grid space values of the land state 
C      and then convert to vegetation tile space

C     !USES:
C      Calls routine grd2msc to do grid to tile space for each bi bj
      implicit none
#include "SIZE.h"
#include "fizhi_SIZE.h"
#include "fizhi_land_SIZE.h"
#include "fizhi_coms.h"
#include "fizhi_land_coms.h"
#include "fizhi_earth_coms.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#ifdef ALLOW_EXCH2
#include "W2_EXCH2_TOPOLOGY.h"
#include "W2_EXCH2_PARAMS.h"
#endif /* ALLOW_EXCH2 */

C     !INPUT/OUTPUT PARAMETERS:
      CHARACTER*1 prec
      INTEGER nhms,nymd
      INTEGER myThid

      EXTERNAL ILNBLNK
      INTEGER ILNBLNK
      INTEGER MDS_RECLEN
CEOP
C     !LOCAL VARIABLES:
      CHARACTER*80 fn
      integer ihour
      integer i,j,n
      integer bislot,bjslot,iunit
      integer recl
      integer bi,bj,fileprec
      integer xsize, ysize
#if defined(ALLOW_EXCH2)
       PARAMETER ( xsize = exch2_domain_nxt * sNx )
       PARAMETER ( ysize = exch2_domain_nyt * sNy )
#else
       PARAMETER ( xsize = Nx )
       PARAMETER ( ysize = Ny )
#endif
      Real*8 globalarr(xsize,ysize,8)
      _RL tempgrid(sNx,sNy)
      _RL temptile(nchp)
      _RL fracland(sNx,sNy,Nsx,Nsy)

      ihour = nhms/10000
      WRITE(fn,'(a,I8,a,I2.2,a)')'vegtiles_cs32.d',nymd,'z',ihour,'.bin'
      fileprec = 64

      call MDSFINDUNIT( iunit, mythid )
      recl=MDS_RECLEN( fileprec, Nx*Ny*8, mythid )

C Only do I/O if I am the master thread
      _BEGIN_MASTER( myThid )

      open(iUnit,file=fn,status='old',access='direct',recl=recl)
      read(iunit,rec=1) globalarr
      close( iunit )
      _END_MASTER( myThid )


#ifdef _BYTESWAPIO
       call MDS_BYTESWAPR8( Nx*Ny*8, globalarr )
#endif

      DO bj = myByLo(myThid), myByHi(myThid)
      DO bi = myBxLo(myThid), myBxHi(myThid)

#if defined(ALLOW_EXCH2)
       bislot = exch2_txglobalo(W2_myTileList(bi))-1
       bjslot = exch2_tyglobalo(W2_myTileList(bi))-1
#else
       bislot = myXGlobalLo-1+(bi-1)*sNx
       bjslot = myYGlobalLo-1+(bj-1)*sNy
#endif /* ALLOW_EXCH2 */

      call get_landfrac(sNx,sNy,Nsx,Nsy,bi,bj,maxtyp,
     .        surftype,tilefrac,fracland(1,1,bi,bj))

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,1)
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        tcanopy(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,2)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = globalarr(i+bislot,j+bjslot,1) - 0.5
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        tdeep(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,3)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.01
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        ecanopy(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,4)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.7
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        swetshal(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,5)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.5
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        swetroot(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,6)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.3
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        swetdeep(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,7)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        snodep(n,bi,bj) = temptile(n)
       enddo

       do j = 1,sNy
       do i = 1,sNx
        tempgrid(i,j) = globalarr(i+bislot,j+bjslot,8)
        if (tempgrid(i,j).gt.1.e14 .and. fracland(i,j,bi,bj).gt.0.0001)
     .    tempgrid(i,j) = 0.
       enddo
       enddo
       call grd2msc(tempgrid,sNx,sNy,igrd,temptile,nchp,nchptot(bi,bj))
       do n = 1,nchp
        capac(n,bi,bj) = temptile(n)
       enddo

       close(iunit)

C End of bi bj loop
      enddo
      enddo

      RETURN
      END
