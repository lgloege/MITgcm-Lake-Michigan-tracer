C $Header: /u/gcmpack/MITgcm/pkg/cost/cost_readparms.F,v 1.9 2005/10/13 04:35:54 heimbach Exp $

#include "COST_CPPOPTIONS.h"

      subroutine cost_readparms( mythid )

c     ==================================================================
c     SUBROUTINE cost_readparms
c     ==================================================================
c
c     o This routine initialises the package cost.
c
c     started: Ralf Giering 18-Jan-2001
c
c     ==================================================================
c     SUBROUTINE cost_readparms
c     ==================================================================

      implicit none

c     == global variables ==

#include "EEPARAMS.h"
#include "SIZE.h"
#include "GRID.h"
#include "PARAMS.h"

#include "cost.h"

c     == routine arguments ==
      integer mythid

c     == local variables ==
      character*(max_len_mbuf) msgbuf
      integer iUnit

c     == end of interface ==

c--   Read the namelist input.
      namelist /cost_nml/ 
     &         mult_atl, mult_test, mult_tracer
     &       , multTheta, multSalt, multUvel, multVvel, multEtan
     &       , lastinterval

      _BEGIN_MASTER( myThid )

c--     Set default values.
        mult_atl              =      0. _d 0
        mult_test             =      0. _d 0
        mult_tracer           =      0. _d 0
        multTheta             =      0. _d 0
        multSalt              =      0. _d 0
        multUvel              =      0. _d 0
        multVvel              =      0. _d 0
        multEtan              =      0. _d 0

c--     30*24*3600 = 2592000 = 1 model month
        lastinterval = 2592000.

c--     Next, read the cost data file.
        WRITE(msgBuf,'(A)') 'COST_READPARMS: opening data.cost'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                    SQUEEZE_RIGHT , 1)

        CALL OPEN_COPY_DATA_FILE(
     I                          'data.cost', 'COST_READPARMS',
     O                          iUnit,
     I                          myThid )

        READ(  iUnit, nml = cost_nml )

        WRITE(msgBuf,'(A)') 'COST_READPARMS: finished reading data.cost'
        CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
     &                  SQUEEZE_RIGHT , 1)

        CLOSE( iUnit )

        IF ( MOD(lastinterval,deltaTclock) .GT. 0. ) 
     &       lastinterval = MAX(
     &       INT(lastinterval/deltaTclock-1)*deltaTclock,deltaTclock)

      _END_MASTER( mythid )

      _BARRIER

      end
