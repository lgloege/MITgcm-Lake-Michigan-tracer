C $Header: /u/gcmpack/MITgcm/pkg/mdsio/mdsio_readtile.F,v 1.2 2005/11/02 14:51:25 jmc Exp $
C $Name:  $

#include "MDSIO_OPTIONS.h"

      SUBROUTINE MDS_READTILE(
     I   fName,
     I   filePrec,
     I   arrType,
     I   nNz,
     O   arr,
     I   bi, bj,
     I   irecord,
     I   myThid )
C
C Arguments:
C
C fName		string	base name for file to read
C filePrec	integer	number of bits per word in file (32 or 64)
C arrType	char(2)	declaration of "arr": either "RS" or "RL"
C nNz		integer	size of third dimension: normally either 1 or Nr
C arr		RS/RL	array to read into, arr(:,:,nNz,:,:)
C irecord	integer	record number to read
C myThid	integer thread identifier
C
C MDS_READTILE first checks to see if the file "fName" exists, then
C if the file "fName.data" exists and finally the tiled files of the
C form "fName.xxx.yyy.data" exist. Currently, the meta-files are not
C read because it is difficult to parse files in fortran.
C The precision of the file is decsribed by filePrec, set either
C to floatPrec32 or floatPrec64. The precision or declaration of
C the array argument must be consistently described by the char*(2)
C string arrType, either "RS" or "RL". nNz allows for both 2-D and
C 3-D arrays to be handled. nNz=1 implies a 2-D model field and
C nNz=Nr implies a 3-D model field. irecord is the record number
C to be read and must be >= 1. The file data is stored in
C arr *but* the overlaps are *not* updated. ie. An exchange must
C be called. This is because the routine is sometimes called from
C within a MASTER_THID region.
C
C Created: 03/16/99 adcroft@mit.edu

      implicit none
C Global variables / common blocks
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C Routine arguments
      character*(*) fName
      integer filePrec
      character*(2) arrType
      integer nNz
      Real arr(*)
      integer bi, bj
      integer irecord
      integer myThid
C Functions
      integer ILNBLNK
      integer MDS_RECLEN
C Local variables
      character*(MAX_LEN_FNAM) dataFName
      integer iG,jG,irec,j,k,dUnit,IL
      logical exst
      Real*4 r4seg(sNx)
      Real*8 r8seg(sNx)
      logical globalFile,fileIsOpen
      integer length_of_rec
      character*(max_len_mbuf) msgbuf
C     ------------------------------------------------------------------

C Only do I/O if I am the master thread
      _BEGIN_MASTER( myThid )

C Record number must be >= 1
      if (irecord .LT. 1) then
       write(msgbuf,'(a,i9.8)')
     &   ' MDS_READTILE: argument irecord = ',irecord
       call print_message( msgbuf, standardmessageunit,
     &                     SQUEEZE_RIGHT , mythid)
       write(msgbuf,'(a)')
     &   ' MDS_READTILE: Invalid value for irecord'
       call print_error( msgbuf, mythid )
       stop 'ABNORMAL END: S/R MDS_READTILE'
      endif

C Assume nothing
      globalFile = .FALSE.
      fileIsOpen = .FALSE.
      IL=ILNBLNK( fName )

C Assign a free unit number as the I/O channel for this routine
      call MDSFINDUNIT( dUnit, mythid )

C Check first for global file with simple name (ie. fName)
      dataFName = fName
      inquire( file=dataFname, exist=exst )
      if (exst) then
       write(msgbuf,'(a,a)')
     &   ' MDS_READTILE: opening global file: ',dataFName(1:IL)
       call print_message( msgbuf, standardmessageunit,
     &                     SQUEEZE_RIGHT , mythid)
       globalFile = .TRUE.
      endif

C If negative check for global file with MDS name (ie. fName.data)
      if (.NOT. globalFile) then
       write(dataFname,'(2a)') fName(1:IL),'.data'
       inquire( file=dataFname, exist=exst )
       if (exst) then
        write(msgbuf,'(a,a)')
     &    ' MDS_READTILE: opening global file: ',dataFName(1:IL+5)
        call print_message( msgbuf, standardmessageunit,
     &                      SQUEEZE_RIGHT , mythid)
        globalFile = .TRUE.
       endif
      endif

C If we are reading from a global file then we open it here
      if (globalFile) then
       length_of_rec=MDS_RECLEN( filePrec, sNx, mythid )
       open( dUnit, file=dataFName, status='old',
     &      access='direct', recl=length_of_rec )
       fileIsOpen=.TRUE.
      endif

C Loop over all tiles
c     do bj=1,nSy
c      do bi=1,nSx

C If we are reading from a tiled MDS file then we open each one here
        if (.NOT. globalFile) then
         iG=bi+(myXGlobalLo-1)/sNx ! Kludge until unstructered tiles
         jG=bj+(myYGlobalLo-1)/sNy ! Kludge until unstructered tiles
         write(dataFname,'(2a,i3.3,a,i3.3,a)')
     &              fName(1:IL),'.',iG,'.',jG,'.data'
         inquire( file=dataFname, exist=exst )
C Of course, we only open the file if the tile is "active"
C (This is a place-holder for the active/passive mechanism
         if (exst) then
          write(msgbuf,'(a,a)')
     &      ' MDS_READTILE: opening file: ',dataFName(1:IL+13)
          call print_message( msgbuf, standardmessageunit,
     &                        SQUEEZE_RIGHT , mythid)
          length_of_rec=MDS_RECLEN( filePrec, sNx, mythid )
          open( dUnit, file=dataFName, status='old',
     &        access='direct', recl=length_of_rec )
          fileIsOpen=.TRUE.
         else
          fileIsOpen=.FALSE.
          write(msgbuf,'(a,a)')
     &      ' MDS_READTILE: filename: ',dataFName(1:IL+13)
          call print_message( msgbuf, standardmessageunit,
     &                        SQUEEZE_RIGHT , mythid)
          write(msgbuf,'(a)')
     &      ' MDS_READTILE: File does not exist'
          call print_error( msgbuf, mythid )
          stop 'ABNORMAL END: S/R MDS_READTILE'
         endif
        endif

        if (fileIsOpen) then
         do k=1,nNz
          do j=1,sNy
           if (globalFile) then
            iG = myXGlobalLo-1 + (bi-1)*sNx
            jG = myYGlobalLo-1 + (bj-1)*sNy
            irec=1 + INT(iG/sNx) + nSx*nPx*(jG+j-1) + nSx*nPx*Ny*(k-1)
     &             + nSx*nPx*Ny*nNz*(irecord-1)
           else
            iG = 0
            jG = 0
            irec=j + sNy*(k-1) + sNy*nNz*(irecord-1)
           endif
           if (filePrec .eq. precFloat32) then
            read(dUnit,rec=irec) r4seg
#ifdef _BYTESWAPIO
            call MDS_BYTESWAPR4( sNx, r4seg )
#endif
            if (arrType .eq. 'RS') then
             call MDS_SEG4toRS( j,bi,bj,k,nNz, r4seg, .TRUE., arr )
            elseif (arrType .eq. 'RL') then
             call MDS_SEG4toRL( j,bi,bj,k,nNz, r4seg, .TRUE., arr )
            else
             write(msgbuf,'(a)')
     &         ' MDS_READTILE: illegal value for arrType'
             call print_error( msgbuf, mythid )
             stop 'ABNORMAL END: S/R MDS_READTILE'
            endif
           elseif (filePrec .eq. precFloat64) then
            read(dUnit,rec=irec) r8seg
#ifdef _BYTESWAPIO
            call MDS_BYTESWAPR8( sNx, r8seg )
#endif
            if (arrType .eq. 'RS') then
             call MDS_SEG8toRS( j,bi,bj,k,nNz, r8seg, .TRUE., arr )
            elseif (arrType .eq. 'RL') then
             call MDS_SEG8toRL( j,bi,bj,k,nNz, r8seg, .TRUE., arr )
            else
             write(msgbuf,'(a)')
     &         ' MDS_READTILE: illegal value for arrType'
             call print_error( msgbuf, mythid )
             stop 'ABNORMAL END: S/R MDS_READTILE'
            endif
           else
            write(msgbuf,'(a)')
     &        ' MDS_READTILE: illegal value for filePrec'
            call print_error( msgbuf, mythid )
            stop 'ABNORMAL END: S/R MDS_READTILE'
           endif
C End of j loop
          enddo
C End of k loop
         enddo
         if (.NOT. globalFile) then
          close( dUnit )
          fileIsOpen = .FALSE.
         endif
        endif

C End of bi,bj loops
c      enddo
c     enddo

C If global file was opened then close it
      if (fileIsOpen .AND. globalFile) then
       close( dUnit )
       fileIsOpen = .FALSE.
      endif

      _END_MASTER( myThid )

C     ------------------------------------------------------------------
      return
      end
