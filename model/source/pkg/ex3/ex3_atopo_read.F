C $Header: /u/gcmpack/MITgcm/pkg/ex3/ex3_atopo_read.F,v 1.3 2006/02/06 21:09:54 edhill Exp $
C $Name:  $

#include "EX3_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP             
C     !ROUTINE: EX3_ATOPO_READ

C     !INTERFACE:
      SUBROUTINE EX3_ATOPO_READ

C     !DESCRIPTION:
C     Read in the EX3 tile topology information from a "flat" ASCII text
C     file that contains a version string.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "EESUPPORT.h"
#include "EX3_SIZE.h"
#include "EX3_PARAMS.h"
#include "EX3_TOPOLOGY.h"
      INTEGER  IFNBLNK
      EXTERNAL IFNBLNK
      INTEGER  ILNBLNK
      EXTERNAL ILNBLNK
CEOP

C     !LOCAL VARIABLES:
C     iUnit  :: Work variable for IO unit number
C     errIO  :: IO unit error flag
C     IL     :: Temp. for index strings
C     msgBuf :: Temp. for textual I/O
C     line   :: Temp. for textual I/O
      INTEGER IL, errIO, iUnit
      CHARACTER*(MAX_LEN_MBUF) msgBuf
      CHARACTER*(MAX_LEN_PREC) line
      INTEGER ii, jj, kk, k, it, ntile, nneigh

C     Intialize the affine transformation matrix
      DO ii = 1,8
        DO jj = 1,4
          ex3_affm(jj,ii) = 0
        ENDDO
      ENDDO
C     -------------------   1 :   I
      ex3_affm(1,1) =  1
      ex3_affm(4,1) =  1
C     -------------------   2 :   Iu-
      ex3_affm(1,2) = -1
      ex3_affm(4,2) =  1
C     -------------------   3 :   Iv-
      ex3_affm(1,3) =  1
      ex3_affm(4,3) = -1
C     -------------------   4 :  -I
      ex3_affm(1,4) = -1
      ex3_affm(4,4) = -1
C     -------------------   5 :   P
      ex3_affm(2,5) =  1
      ex3_affm(3,5) =  1
C     -------------------   6 :   Pu-
      ex3_affm(2,6) = -1
      ex3_affm(3,6) =  1
C     -------------------   7 :   Pv-
      ex3_affm(2,7) =  1
      ex3_affm(3,7) = -1
C     -------------------   8 :  -P
      ex3_affm(2,8) = -1
      ex3_affm(3,8) = -1

C     Make scratch copies of input data file with and without comments
#ifdef TARGET_BGL
      OPEN(UNIT=scrUnit1,FILE='scratch1',STATUS='UNKNOWN')
#else
      OPEN(UNIT=scrUnit1,STATUS='SCRATCH')
#endif
      IL = ILNBLNK(EX3_ATOPO_INAME)
      OPEN(UNIT=eeDataUnit,FILE=EX3_ATOPO_INAME(1:IL),
     &     STATUS='OLD',err=100,IOSTAT=errIO)
      IF ( errIO .GE. 0 ) GOTO 200
 100  CONTINUE
      WRITE(msgBuf,'(A)')
     &     'S/R EX3_ATOPO_READ'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(A)')
     &      'Unable to open EX3 ASCII topology'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(3A)')
     &     'file ''',EX3_ATOPO_INAME(1:IL),''''
      CALL PRINT_ERROR( msgBuf , 1)
      STOP 'ABNORMAL END: S/R EX3_ATOPO_READ'
 200  CONTINUE
 300  CONTINUE
      READ(eeDataUnit,FMT='(A)',END=400) LINE
      IL = MAX(ILNBLNK(LINE),1)
      IF ( LINE(1:1) .NE. commentCharacter ) THEN
        WRITE(UNIT=scrUnit1,FMT='(A)') LINE(:IL)
      ENDIF
      GOTO 300
 400  CONTINUE
      CLOSE(eeDataUnit)

      iUnit = scrUnit1
      REWIND(iUnit)
 450  READ(UNIT=iUnit,FMT='(A)',END=500) LINE
      IF ( LINE(1:7) .EQ. 'EX3TOPO' ) GOTO 600
      GOTO 450
 500  CONTINUE
#ifndef TARGET_PWR3
      WRITE(msgBuf,'(A)')
     &     'S/R EX3_ATOPO_READ'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(A)')
     &     'Error reading EX3 ASCII topology'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(3A)')
     &     'file "',EX3_ATOPO_INAME(1:IL),'"'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(A)')
     &     'Cannot locate the ''EX3TOPO'' header string'
      CALL PRINT_ERROR( msgBuf , 1)
      STOP 'ABNORMAL END: S/R EX3_ATOPO_READ'
#endif

 600  CONTINUE
C     Parse the topo-file version string :
C     =           0         0
C     =  123456789 123456789 
C     =  EXCH2TOPO ver 001
C     =  EX3TOPO ver 001
C     =              ===

 650  FORMAT(10i12)

      IF ( LINE(13:15) .EQ. '001' ) GOTO 700
C     Other versions go here...

      GOTO 900

 700  CONTINUE
C     VERSION :  "001"
      READ(iUnit,650) ntile
      DO k = 1,ntile

        READ(iUnit,650) it
        READ(iUnit,650)
     &       ex3_t_iproc(it), ex3_t_ori(it),
     &       (ex3_t_nxy(ii,it), ii=1,2)
        READ(iUnit,650) ex3_f_ind(it),
     &       (ex3_f_nxy(ii,it), ii=1,2), (ex3_f_oij(ii,it), ii=1,2)
        READ(iUnit,650) ex3_e_n(it)
        READ(iUnit,650) (ex3_e_iam(ii,it), ii=1,ex3_e_n(it))
        READ(iUnit,650) (ex3_e_iopt(ii,it), ii=1,ex3_e_n(it))
        READ(iUnit,650) (ex3_e_iope(ii,it), ii=1,ex3_e_n(it))
        DO ii = 1,ex3_e_n(it)
          READ(iUnit,650)
     &         ((ex3_e_dat(kk,jj,ii,it), kk=1,3), jj=1,2)
        ENDDO
        READ(iUnit,650) (ex3_c_n(ii,it), ii=1,4)
        DO ii = 1,4
          READ(iUnit,650)
     &         (ex3_c_ind(jj,ii,it), jj=1,ex3_c_n(ii,it))
          READ(iUnit,650)
     &         (ex3_c_num(jj,ii,it), jj=1,ex3_c_n(ii,it))
          READ(iUnit,650)
     &         (ex3_c_ori(jj,ii,it), jj=1,ex3_c_n(ii,it))
        ENDDO


      ENDDO

      GOTO 999

 900  CONTINUE
C     Unknown version string
      WRITE(msgBuf,'(A)')
     &     'S/R EX3_ATOPO_READ'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(3A)')
     &     ' Error: EXCH2TOPO version string "', LINE(1:9), '"'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(A)')
     &     ' is not understood'
      CALL PRINT_ERROR( msgBuf , 1)
      STOP 'ABNORMAL END: S/R EX3_ATOPO_READ'

 999  CONTINUE
      CLOSE(iUnit)

      RETURN
      END
