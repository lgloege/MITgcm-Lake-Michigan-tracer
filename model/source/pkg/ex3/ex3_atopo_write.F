C $Header: /u/gcmpack/MITgcm/pkg/ex3/ex3_atopo_write.F,v 1.3 2006/02/06 21:09:54 edhill Exp $
C $Name:  $

#include "EX3_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP             
C     !ROUTINE: EX3_ATOPO_WRITE

C     !INTERFACE:
      SUBROUTINE EX3_ATOPO_WRITE

C     !DESCRIPTION:
C     Write the EX3 tile topology information to a "flat" ASCII text
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
      INTEGER ii, jj, kk, k, ic, nneigh


      IL = ILNBLNK(EX3_ATOPO_ONAME)
      iUnit = eeDataUnit
      OPEN(UNIT=iUnit,FILE=EX3_ATOPO_ONAME(1:IL),
     &     status='unknown',err=100,IOSTAT=errIO)
      IF ( errIO .GE. 0 ) GOTO 200
 100  CONTINUE
      WRITE(msgBuf,'(A)')
     &     'S/R EX3_ATOPO_WRITE'
      CALL PRINT_ERROR( msgBuf , 1)
      WRITE(msgBuf,'(3A)')
     &     'Unable to open file "',EX3_ATOPO_ONAME(1:IL),'"'
      CALL PRINT_ERROR( msgBuf , 1)
      STOP 'ABNORMAL END: S/R EX3_ATOPO_WRITE'
      
 200  CONTINUE

C     ========  ASCII FORMAT  ========
 650  FORMAT(10i12)
C     The above format is not the most efficient way to pack the
C     topology data.  But it does NOT matter!  Considering a
C     hypothetical system with 10,000 tiles (one full order of magnitude
C     larger than any MITgcm run performed through 2005), the file size
C     would still be less than 10MB:
C
C     (10000 tiles) * (~5500 bytes / 6 tiles) = 9.2 MB
C     
C     and this is orders of magnitude smaller than any binary data files
C     that would be needed by such a run.
C
C     Write the topo-file version string :
C     =           0         0
C     =  123456789 123456789 
C     =  EXCH2TOPO ver 001
C     =  EX3TOPO ver 001
C     =              ===
C     ========  ASCII FORMAT  ========

      IF ( EX3_ATOPO_OVER(1:3) .EQ. '001' ) THEN

        WRITE(iUnit,'(a)') '#'
        WRITE(iUnit,'(a)') '#  MODEL GENERATED'
        WRITE(iUnit,'(a)') '#'
        WRITE(iUnit,'(a)') 'EX3TOPO ver 001'
        WRITE(iUnit,650) ex3_t_num
        DO k = 1,ex3_t_num
          
          WRITE(iUnit,650) k
          WRITE(iUnit,650)
     &         ex3_t_iproc(k), ex3_t_ori(k),
     &         (ex3_t_nxy(ii,k), ii=1,2)
          WRITE(iUnit,650) ex3_f_ind(k),
     &         (ex3_f_nxy(ii,k), ii=1,2), (ex3_f_oij(ii,k), ii=1,2)
          WRITE(iUnit,650) ex3_e_n(k)
          WRITE(iUnit,650) (ex3_e_iam(ii,k), ii=1,ex3_e_n(k))
          WRITE(iUnit,650) (ex3_e_iopt(ii,k), ii=1,ex3_e_n(k))
          WRITE(iUnit,650) (ex3_e_iope(ii,k), ii=1,ex3_e_n(k))
          DO ii = 1,ex3_e_n(k)
            WRITE(iUnit,650)
     &           ((ex3_e_dat(kk,jj,ii,k), kk=1,3), jj=1,2)
          ENDDO
          WRITE(iUnit,650) (ex3_c_n(ii,k), ii=1,4)
          DO ii = 1,4
            WRITE(iUnit,650)
     &           (ex3_c_ind(jj,ii,k), jj=1,ex3_c_n(ii,k))
            WRITE(iUnit,650)
     &           (ex3_c_num(jj,ii,k), jj=1,ex3_c_n(ii,k))
            WRITE(iUnit,650)
     &           (ex3_c_ori(jj,ii,k), jj=1,ex3_c_n(ii,k))
          ENDDO
          
        ENDDO

      ELSE

        WRITE(msgBuf,'(A)')
     &       'S/R EX3_ATOPO_WRITE'
        CALL PRINT_ERROR( msgBuf , 1)
        WRITE(msgBuf,'(3A)')
     &       'Unknown topology version ''',EX3_ATOPO_OVER(1:3),''''
        CALL PRINT_ERROR( msgBuf , 1)
        WRITE(msgBuf,'(3A)')
     &       'Currently, valid values are ''001'''
        CALL PRINT_ERROR( msgBuf , 1)
        STOP 'ABNORMAL END: S/R EX3_ATOPO_WRITE'

      ENDIF

      CLOSE(iUnit)

      RETURN
      END
