C $Header: /u/gcmpack/MITgcm/pkg/ecco/cost_driftw.F,v 1.3 2005/03/28 23:49:49 heimbach Exp $

#include "COST_CPPOPTIONS.h"


      subroutine cost_driftw(
     I                       myiter,
     I                       mytime,
     I                       mythid
     &                     )

c     ==================================================================
c     SUBROUTINE cost_Driftw
c     ==================================================================
c
c     o Evaluate cost function contribution of the w difference
c       between the first and the last year.
c
c     started: from cost_drift
c
c     Armin Koehl  akoehl@ucsd.edu  26-Feb-2002
c
c     ==================================================================
c     SUBROUTINE cost_Driftw
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "DYNVARS.h"

#include "cal.h"
#include "ecco_cost.h"
#include "ctrl.h"
#include "ctrl_dummy.h"
#include "optim.h"

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==

      _RS        one_rs
      parameter( one_rs = 1. )

      integer bi,bj
      integer i,j,k
      integer itlo,ithi
      integer jtlo,jthi
      integer jmin,jmax
      integer imin,imax
      integer irec
      integer ilw
      integer nf, nl

      _RL fctilew
      _RL fcthread_wdrift

      character*(80) fnamew

      logical doglobalread
      logical ladinit

      character*(MAX_LEN_MBUF) msgbuf

c     == external functions ==

      integer  ilnblnk
      external ilnblnk

c     == end of interface ==

      jtlo = mybylo(mythid)
      jthi = mybyhi(mythid)
      itlo = mybxlo(mythid)
      ithi = mybxhi(mythid)
      jmin = 1
      jmax = sny
      imin = 1
      imax = snx

c--   Read tiled data.
      doglobalread = .false.
      ladinit      = .false.

#ifdef ALLOW_DRIFTW_COST_CONTRIBUTION

      if (optimcycle .ge. 0) then
        ilw = ilnblnk( wbarfile )
        write(fnamew(1:80),'(2a,i10.10)')
     &    wbarfile(1:ilw),'.',optimcycle
      endif
      
      if (nmonsrec.lt.12) then 
        print*
        print*,' cost_Driftw: assimilation period smaller' 
        print*,'             than 1 year, no drift computed.'
        print*
        stop   '  ... stopped in cost_Driftw.'
      endif

      fcthread_wdrift = 0. _d 0
      
      do bj = jtlo,jthi
        do bi = itlo,ithi
          do k = 1,nr     
            do j = jmin,jmax
              do i = imin,imax
                wfmean(i,j,k,bi,bj) = 0.0
                wlmean(i,j,k,bi,bj) = 0.0
              enddo
            enddo                
          enddo
        enddo
      enddo
      
      nf = 0
      nl = 0

c--   Loop over records.
      do irec = 1,12

c--     Read time averages and the monthly mean data.
        call active_read_xyz( fnamew, wbar, irec,
     &                        doglobalread, ladinit,
     &                        optimcycle, mythid,
     &                        xx_wbar_mean_dummy )
     
        nf = nf + 1
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr     
              do j = jmin,jmax
                do i = imin,imax
                  wfmean(i,j,k,bi,bj) = wfmean(i,j,k,bi,bj) + 
     &                  wbar(i,j,k,bi,bj)
                enddo
              enddo                
            enddo
          enddo
        enddo
        
      enddo
        
      do irec = nmonsrec-12+1, nmonsrec

c--     Read time averages and the monthly mean data.
        call active_read_xyz( fnamew, wbar, irec,
     &                        doglobalread, ladinit,
     &                        optimcycle, mythid,
     &                        xx_wbar_mean_dummy )
     
        nl = nl + 1  
     
        do bj = jtlo,jthi
          do bi = itlo,ithi
            do k = 1,nr     
              do j = jmin,jmax
                do i = imin,imax
                  wlmean(i,j,k,bi,bj) = wlmean(i,j,k,bi,bj) + 
     &                  wbar(i,j,k,bi,bj)
                enddo
              enddo                
            enddo
          enddo
        enddo
      
      enddo
 
        
      do bj = jtlo,jthi
        do bi = itlo,ithi

c--       Loop over the model layers
          fctilew = 0. _d 0
          
          do k = 1,nr

c--         Compute model misfit and cost function term for
c           the vertical velovity field. The error is 1e-4 m/s.
            do j = jmin,jmax
             do i = imin,imax
              if (_hFacC(i,j,k,bi,bj) .ne. 0.) then
                     fctilew = fctilew +
     &                  (2.5e11*cosphi(i,j,bi,bj)*
     &          (wlmean(i,j,k,bi,bj)/nl - wfmean(i,j,k,bi,bj)/nf)*
     &          (wlmean(i,j,k,bi,bj)/nl - wfmean(i,j,k,bi,bj)/nf))
                     if ( cosphi(i,j,bi,bj) .ne. 0. )
     &                 num_wdrift(bi,bj) = num_wdrift(bi,bj) + 1. _d 0
              endif
             enddo
            enddo

          enddo
c--       End of loop over layers.

          fcthread_wdrift    = fcthread_wdrift    + fctilew
          objf_wdrift(bi,bj) = objf_wdrift(bi,bj) + fctilew

#ifdef ECCO_VERBOSE
c--       Print cost function for each tile in each thread.
          write(msgbuf,'(a)') ' '
          call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
          write(msgbuf,'(a,i8.8,1x,i3.3,1x,i3.3)')
     &        ' cost_Driftw: irec,bi,bj          =  ',irec,bi,bj
          call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
          write(msgbuf,'(a,d22.15)')
     &        '     cost function (wvel) = ',
     &        fctilet+fctiles
          call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
          write(msgbuf,'(a)') ' '
          call print_message( msgbuf, standardmessageunit,
     &                          SQUEEZE_RIGHT , mythid)
#endif

        enddo
      enddo

#ifdef ECCO_VERBOSE
c--     Print cost function for all tiles.
        _GLOBAL_SUM_R8( fcthread_tdrift , myThid )
        _GLOBAL_SUM_R8( fcthread_tdrifs , myThid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,i8.8)')
     &    ' cost_Drift: irec = ',irec
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a,d22.15)')
     &    '  cost function value',
     &    ' (wvel) = ',fcthread_tdrifw
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
#endif

#else
c--   Do not enter the calculation of the drift contribution to
c--   the final cost function.

      _BEGIN_MASTER( mythid )
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a)')
     &    ' cost_Driftw: no contribution of drift between the first ',
     &                 'and the last year to cost function.'
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a,a,i9.8)')
     &    ' cost_Driftw: number of records that would have',
     &                ' been processed: ',nmonsrec
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        write(msgbuf,'(a)') ' '
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
      _END_MASTER( mythid )
#endif

      return
      end

