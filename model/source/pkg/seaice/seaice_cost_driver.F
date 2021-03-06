C $Header: /u/gcmpack/MITgcm/pkg/seaice/seaice_cost_driver.F,v 1.1 2005/09/01 05:34:31 heimbach Exp $

#include "SEAICE_OPTIONS.h"

      subroutine seaice_cost_driver( myiter, mytime, mythid )

c     ==================================================================
c     SUBROUTINE seaice_cost_driver
c     ==================================================================
c
c     o Evaluate cost function contributions of 
c       seaice observations
c
c     ==================================================================
c     SUBROUTINE seaice_cost_driver
c     ==================================================================

      implicit none

c     == global variables ==
#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"
#include "GRID.h"

#ifdef ALLOW_CAL
# include "cal.h"
#endif
#ifdef ALLOW_COST
# include "ctrl.h"
# include "ctrl_dummy.h"
# include "ecco_cost.h"
# include "SEAICE_COST.h"
#endif

c     == routine arguments ==

      integer myiter
      _RL     mytime
      integer mythid

c     == local variables ==
      character*(max_len_mbuf) msgbuf

      integer nnzbar
      integer nnzobs
      integer nrecloc
      _RL spminloc
      _RL spmaxloc
      _RL spzeroloc
      _RL localperiod

c     == end of interface ==


#ifdef ALLOW_SEAICE_COST_SMR_AREA
      write(msgbuf,'(a)') 'ph-cost call cost_smrarea'
      call print_message( msgbuf, standardmessageunit,
     &     SQUEEZE_RIGHT , mythid)
      nnzbar = 1
      nnzobs = 1
      nrecloc = ndaysrec
      spminloc = 0.
      spmaxloc = 1.
      spzeroloc = -9999.
      localperiod = 86400.
      call cost_generic(
     &     nnzbar, smrareabarfile, smrareabar, xx_smrareabar_mean_dummy,
     &     nnzobs, smrareadatfile, smrareadat, mult_smrarea,
     &     nrecloc, modelstartdate, localperiod,
     &     maskC, wsmrarea,
     &     spminloc, spmaxloc, spzeroloc,
     &     objf_smrarea, num_smrarea,
     &     myiter, mytime, mythid )
#endif

      end
