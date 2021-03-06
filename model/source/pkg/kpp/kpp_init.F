C $Header: /u/gcmpack/MITgcm/pkg/kpp/kpp_init.F,v 1.12 2004/10/17 23:05:09 jmc Exp $
C $Name:  $

#include "KPP_OPTIONS.h"
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP 0
C     !ROUTINE: KPP_INIT

C     !INTERFACE:
      SUBROUTINE KPP_INIT( myThid )

C     !DESCRIPTION:
C     Routine to initialize KPP parameters and variables.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "KPP.h"
#include "KPP_PARAMS.h"

C     !INPUT PARAMETERS:
      INTEGER myThid
CEOP

C     !LOCAL VARIABLES:
#ifdef ALLOW_KPP
C     i,j,k,bi,bj - Loop counters
C     zehat       - zeta * ustar**3
C     zeta        - Stability parameter d/l

      INTEGER i, j, k, bi, bj
      _KPP_RL zehat
      _KPP_RL zeta
      _KPP_RL usta

C-----------------------------------------------------------------------
C Initialize constants that depend on parameters in data.kpp
C-----------------------------------------------------------------------

      Vtc     = concv * sqrt(0.2/concs/epsilon) / vonk**2 / Ricr
      cg      = cstar * vonk * (concs * vonk * epsilon)**(1./3.)

c-----------------------------------------------------------------------
c construct the wm and ws lookup tables
c-----------------------------------------------------------------------

      deltaz = (zmax - zmin)/(nni + 1)
      deltau = (umax - umin)/(nnj + 1)
 
      do i = 0, nni + 1
         zehat = deltaz*i + zmin
         do j = 0, nnj + 1
            usta = deltau*j + umin
            zeta = zehat / max(phepsi,usta**3)
            if (zehat .ge. 0.) then
               wmt(i,j) = vonk*usta/(1. + conc1*zeta)
               wst(i,j) = wmt(i,j)
            else
               if (zeta .gt. zetam) then
                  wmt(i,j) = vonk*usta*(1. - conc2*zeta)**(1./4.)
               else
                  wmt(i,j) = vonk*(conam*usta**3 - concm*zehat)**(1./3.)
               endif
               if (zeta .gt. zetas) then
                  wst(i,j) = vonk*usta*(1. - conc3*zeta)**(1./2.)
               else
                  wst(i,j) = vonk*(conas*usta**3 - concs*zehat)**(1./3.)
               endif
            endif
         end do
      end do

C-----------------------------------------------------------------------
C     calculate mask pMask for pressure/tracer cells
C        (0 => land, 1 => water)
C     compute maximum number of wet levels in each column
C-----------------------------------------------------------------------

      do bj = myByLo(myThid), myByHi(myThid)
         do bi = myBxLo(myThid), myBxHi(myThid)
             do j = 1-OLy, sNy+OLy
               do i = 1-OLx, sNx+OLx
                  nzmax(i,j,bi,bj) = 0
                  do k = 1, Nr
c                    if (_hFacC(i,j,k,bi,bj).eq.0.) then
c                       pMask (i,j,k,bi,bj) = 0.
c                    else
c                       pMask (i,j,k,bi,bj) = 1.
c                    endif
                     nzmax(i,j,bi,bj) = nzmax(i,j,bi,bj)
     &                                + INT(maskC(i,j,k,bi,bj))
c    &                                + INT(pMask(i,j,k,bi,bj))
                  end do
               end do
            end do
          end do
      end do
      
C-----------------------------------------------------------------------
C     vertical grid
C-----------------------------------------------------------------------

      zgrid(0)  =  phepsi
      hwide(0)  =  phepsi
c     zgrid(1)  = -drF(1)*0.5
c     hwide(1)  =  drF(1)
c     do k = 2, Nr
c        zgrid(k) = zgrid(k-1) - (drF(k-1)+drF(k))*0.5
c        hwide(k) = drF(k)
c     end do
C- jmc : use the model vertical grid :
      do k = 1, Nr
         zgrid(k) = rC(k)
         hwide(k) = drF(k)
      enddo

      zgrid(Nrp1) = zgrid(Nr) * 100.

      hwide(Nrp1) = phepsi

C-----------------------------------------------------------------------
C Initialize KPP variables KPPhbl, KPPghat, KPPviscAz,
C    KPPdiffKzT, and KPPdiffKzS
C-----------------------------------------------------------------------

      do bj = myByLo(myThid), myByHi(myThid)
         do bi = myBxLo(myThid), myBxHi(myThid)
            do j = 1-OLy, sNy+OLy
               do i = 1-OLx, sNx+OLx
                  KPPhbl(i,j,bi,bj) = 0.
               end do
            end do
            do k = 1, Nr
               do j = 1-OLy, sNy+OLy
                  do i = 1-OLx, sNx+OLx
                     KPPghat       (i,j,k,bi,bj) = 0.
                     KPPviscAz  (i,j,k,bi,bj) = viscAr
                     KPPdiffKzT (i,j,k,bi,bj) = diffKrNrT(k)
                     KPPdiffKzS (i,j,k,bi,bj) = diffKrNrS(k)
                  end do
               end do
            end do
          end do
      end do

#endif /* ALLOW_KPP */

      return
      end
