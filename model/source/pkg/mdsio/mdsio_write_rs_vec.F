C $Header: /u/gcmpack/MITgcm/pkg/mdsio/mdsio_write_rs_vec.F,v 1.3 2004/11/30 16:11:10 heimbach Exp $
C $Name:  $

#include "MDSIO_OPTIONS.h"

      subroutine MDS_WRITE_RS_VEC( dUnit, irec, narr, arr, mythid )
C IN:
C   dunit	integer - 'Opened' I/O channel
C   irec	integer - record number to write
C   narr	integer - dimension off array "arr"
C   arr		_RS     - model tiled vector
C   mythid      integer - thread id
C
C Created: 03/29/99 eckert@mit.edu + adcroft@mit.edu

      implicit none

#include "EEPARAMS.h"
#include "SIZE.h"
#include "PARAMS.h"

C Arguments
      integer dUnit
      integer irec
      integer narr
      integer mythid
      _RS arr(narr)
C Local
      character*(max_len_mbuf) msgbuf
C     ------------------------------------------------------------------
      if ( debugLevel .GE. debLevB ) then
       write(msgbuf,'(a,i9.8,2x,i9.8)')
     &  ' MDS_WRITE_RS_VEC: irec = ',irec,narr
       call print_message( msgbuf, standardmessageunit,
     &                    SQUEEZE_RIGHT , mythid)
      endif

      write(dUnit,rec=irec) arr
C     ------------------------------------------------------------------
      return
      end
