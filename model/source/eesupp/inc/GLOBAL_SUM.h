C $Header: /u/gcmpack/MITgcm/eesupp/inc/GLOBAL_SUM.h,v 1.5 2005/09/28 01:58:25 edhill Exp $
C $Name:  $
CBOP
C     !ROUTINE: GLOBAL_SUM.h
C     !INTERFACE:
C     include "GLOBAL_SUM.h"
C     !DESCRIPTION:
C     *==========================================================*
C     | GLOBAL\_SUM.h                                             |
C     | o Globals used by Fortran global sum routine.            |
C     *==========================================================*
C     | The global sum shared memory scheme uses global heap data|
C     | structures (.i.e COMMON blocks ). Each thread writes to  |
C     | an its own element of the shared memory array and then   |
C     | one thread reads all the entries and sums them. The sum  |
C     | result is then read by all threads.                      |
C     | Remember - you are working with regions of memory that   |
C     | are being updated concurrently by different threads.     |
C     | What happens, when it happens and who gets to see what   |
C     | happens at what stage depends on the computer systems    |
C     | memory model. Every computer has a different memory model|
C     | and they are never simple. In all current platforms it is|
C     | possible for one thread to see events happening in a     |
C     | different order from the order they are written in the   |
C     | code.                                                    |
C     | Unless you understand this it is not a good idea to      |
C     | make modifications te way these header files are setup or|
C     | the way the global sum routines work.                    |
C     *==========================================================*
CEOP

      COMMON / GSUM_COMMON_R8 / phiGSRL, phiVGSRL
      Real*8  phiGSRL (lShare8, MAX_NO_THREADS )
      Real*8  phivGSRL(MAX_VGS, MAX_NO_THREADS )

      COMMON / GSUM_COMMON_R4 / phiGSRS, phiVGSRS
      Real*4  phiGSRS (lShare4, MAX_NO_THREADS )
      Real*4  phivGSRS(MAX_VGS, MAX_NO_THREADS )

      COMMON / GSUM_COMMON_I  / phiGSI, phiVGSI
      INTEGER phiGSI  (lShare4, MAX_NO_THREADS )
      INTEGER phivGSI (MAX_VGS, MAX_NO_THREADS )

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***

