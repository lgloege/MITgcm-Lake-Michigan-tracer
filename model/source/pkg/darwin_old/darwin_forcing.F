#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c=============================================================
c subroutine NPZD2Fe_forcing
c step forward bio-chemical tracers in time
C==============================================================
         SUBROUTINE DARWIN_Forcing(PO4,NO3,FeT,Si,
     &                  DOP,DON,DOFe,
     &                  Zoo1P,Zoo1N,Zoo1Fe,Zoo1Si,
     &                  Zoo2P,Zoo2N,Zoo2Fe,Zoo2Si,
     &                  POP,PON,POFe,PSi,
     &                  NH4,NO2,
     &                  Phy1,Phy2,Phy3,Phy4,Phy5,Phy6,
     &                  Phy7,Phy8,Phy9,Phy10,Phy11,Phy12,
     &                  Phy13,Phy14,Phy15,Phy16,Phy17,Phy18,
     &                  Phy19,Phy20,Phy21,Phy22,Phy23,Phy24,
     &                  Phy25,Phy26,Phy27,Phy28,Phy29,Phy30,
     &                  Phy31,Phy32,Phy33,Phy34,Phy35,
     &                  Phy36,Phy37,Phy38,Phy39,
     &                  Phy40,Phy41,Phy42,Phy43,Phy44,
     &                  Phy45,Phy46,Phy47,Phy48,Phy49,
     &                  Phy50,Phy51,Phy52,Phy53,Phy54,
     &                  Phy55,Phy56,Phy57,Phy58,Phy59,
     &                  Phy60,Phy61,Phy62,Phy63,Phy64,
     &                  Phy65,Phy66,Phy67,Phy68,Phy69,
     &                  Phy70,Phy71,Phy72,Phy73,Phy74,
     &                  Phy75,Phy76,Phy77,Phy78,
     &                  bi,bj,imin,imax,jmin,jmax,
     &                  myIter,myTime,myThid)
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
CMICK #include "NPZD2Fe.h"
#include "DARWIN-SMALL.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "GCHEM.h"
#include "PLANKTON.h"
#include "DYNVARS.h"

C     === Global variables ===
c tracers
      _RL  PO4(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  NO3(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  FeT(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Si(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DOP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DOFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo1P(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo1N(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo1Fe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo1Si(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo2P(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo2N(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo2Fe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo2Si(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy1(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy3(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy4(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy5(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy6(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy7(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy8(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy9(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy10(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy11(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy12(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy13(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy14(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy15(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy16(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy17(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy18(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy19(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy20(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy21(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy22(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy23(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy24(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy25(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy26(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy27(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy28(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy29(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy30(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy31(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy32(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy33(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy34(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy35(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy36(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy37(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy38(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy39(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy40(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy41(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy42(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy43(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy44(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy45(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy46(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy47(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy48(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy49(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy50(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy51(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy52(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy53(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy54(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy55(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy56(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy57(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy58(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy59(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy60(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy61(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy62(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy63(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy64(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy65(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy66(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy67(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy68(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy69(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy70(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy71(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy72(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy73(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy74(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy75(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy76(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy77(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy78(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  POP(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  PON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  POFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  PSi(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  NH4(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  NO2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
       INTEGER myIter
       _RL myTime
       INTEGER myThid
       INTEGER bi,bj,imin,imax,jmin,jmax


C============== Local variables ============================================
c plankton arrays
      _RL  ZooP(nzmax)
      _RL  ZooN(nzmax)
      _RL  ZooFe(nzmax)
      _RL  ZooSi(nzmax)
      _RL  Phy(npmax)
c iron partitioning
      _RL  freefe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
c some working variables
      _RL  sumpy(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL  sumpyup(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
c light variables
      _RL  PAR(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      _RL  sfac(1-OLy:sNy+OLy)
      _RL  atten,lite
      _RL  newtime

c tendencies due to particle flux divergence
      _RL  psinkP(Nr)
      _RL  psinkN(Nr)
      _RL  psinkFe(Nr)
      _RL  psinkSi(Nr)

c some local variables
       _RL PO4l
       _RL NO3l
       _RL FeTl
       _RL Sil
       _RL DOPl
       _RL DONl
       _RL DOFel
       _RL POPl
       _RL PONl
       _RL POFel
       _RL PSil
       _RL POPupl
       _RL PONupl
       _RL POFeupl
       _RL PSiupl
       _RL Tlocal
       _RL Slocal
       _RL NH4l
       _RL NO2l
       _RL PARl
       _RL dzlocal
       _RL dtplankton
       _RL bottom
       _RL hfacclocal
       _RL PP(npmax)


      INTEGER I,J,K,it, ktmp
      INTEGER np

c test......................................
c            write(6,*)'in npzd2fe_forcing: NOTE - NO SELF-SHADING'
c             write(6,*)'in npzd2fe_forcing: NOTE - TESTING SELF-SHADING'
c...........................................
c
       DO j=1-OLy,sNy+OLy
       DO i=1-OLx,sNx+OLx
        do k=1,Nr
           freefe(i,j,k,bi,bj)=0.d0
        enddo
       ENDDO
       ENDDO
c
c bio-chemical time loop
c--------------------------------------------------
       do it=1,nsubtime
c -------------------------------------------------
         newtime=myTime-deltaTtracer+
     &           float(it)*deltaTtracer/float(nsubtime)
c        print*,'it  ',it,newtime,nsubtime,myTime


c determine iron partitioning  - solve for free iron
         call fe_chem(bi,bj,iMin,iMax,jMin,jMax, FeT, freefe,
     &                myIter, mythid)

 
c determine incident light
         DO j=1-OLy,sNy+OLy
          sfac(j)=0.d0
         ENDDO
         call INSOL(newTime,sfac,bj)

c attenuation of light ... PAR
         do j=1-OLy,sNy+OLy 
          do i=1-OLx,sNx+OLx
           atten=0.d0
           lite=sfac(j)
           sumpy(i,j) = 0.0d0
           do k=1,NR
             do np = 1, npmax
               sumpyup(i,j) = sumpy(i,j)
               sumpy(i,j) = sumpy(i,j) + Phy1(i,j,k,bi,bj)
     &                                 + Phy2(i,j,k,bi,bj)
     &                                 + Phy3(i,j,k,bi,bj)
     &                                 + Phy4(i,j,k,bi,bj)
     &                                 + Phy5(i,j,k,bi,bj)
     &                                 + Phy6(i,j,k,bi,bj)
     &                                 + Phy7(i,j,k,bi,bj)
     &                                 + Phy8(i,j,k,bi,bj)
     &                                 + Phy9(i,j,k,bi,bj)
     &                                 + Phy10(i,j,k,bi,bj)
     &                                 + Phy11(i,j,k,bi,bj)
     &                                 + Phy12(i,j,k,bi,bj)
     &                                 + Phy13(i,j,k,bi,bj)
     &                                 + Phy14(i,j,k,bi,bj)
     &                                 + Phy15(i,j,k,bi,bj)
     &                                 + Phy16(i,j,k,bi,bj)
     &                                 + Phy17(i,j,k,bi,bj)
     &                                 + Phy18(i,j,k,bi,bj)
     &                                 + Phy19(i,j,k,bi,bj)
     &                                 + Phy20(i,j,k,bi,bj)
     &                                 + Phy21(i,j,k,bi,bj)
     &                                 + Phy22(i,j,k,bi,bj)
     &                                 + Phy23(i,j,k,bi,bj)
     &                                 + Phy24(i,j,k,bi,bj)
     &                                 + Phy25(i,j,k,bi,bj)
     &                                 + Phy26(i,j,k,bi,bj)
     &                                 + Phy27(i,j,k,bi,bj)
     &                                 + Phy28(i,j,k,bi,bj)
     &                                 + Phy29(i,j,k,bi,bj)
     &                                 + Phy30(i,j,k,bi,bj)
     &                                 + Phy31(i,j,k,bi,bj)
     &                                 + Phy32(i,j,k,bi,bj)
     &                                 + Phy33(i,j,k,bi,bj)
     &                                 + Phy34(i,j,k,bi,bj)
     &                                 + Phy35(i,j,k,bi,bj)
     &                                 + Phy36(i,j,k,bi,bj)
     &                                 + Phy37(i,j,k,bi,bj)
     &                                 + Phy38(i,j,k,bi,bj)
     &                                 + Phy39(i,j,k,bi,bj)
     &                                 + Phy40(i,j,k,bi,bj)
     &                                 + Phy41(i,j,k,bi,bj)
     &                                 + Phy42(i,j,k,bi,bj)
     &                                 + Phy43(i,j,k,bi,bj)
     &                                 + Phy44(i,j,k,bi,bj)
     &                                 + Phy45(i,j,k,bi,bj)
     &                                 + Phy46(i,j,k,bi,bj)
     &                                 + Phy47(i,j,k,bi,bj)
     &                                 + Phy48(i,j,k,bi,bj)
     &                                 + Phy49(i,j,k,bi,bj)
     &                                 + Phy50(i,j,k,bi,bj)
     &                                 + Phy51(i,j,k,bi,bj)
     &                                 + Phy52(i,j,k,bi,bj)
     &                                 + Phy53(i,j,k,bi,bj)
     &                                 + Phy54(i,j,k,bi,bj)
     &                                 + Phy55(i,j,k,bi,bj)
     &                                 + Phy56(i,j,k,bi,bj)
     &                                 + Phy57(i,j,k,bi,bj)
     &                                 + Phy58(i,j,k,bi,bj)
     &                                 + Phy59(i,j,k,bi,bj)
     &                                 + Phy60(i,j,k,bi,bj)
     &                                 + Phy61(i,j,k,bi,bj)
     &                                 + Phy62(i,j,k,bi,bj)
     &                                 + Phy63(i,j,k,bi,bj)
     &                                 + Phy64(i,j,k,bi,bj)
     &                                 + Phy65(i,j,k,bi,bj)
     &                                 + Phy66(i,j,k,bi,bj)
     &                                 + Phy67(i,j,k,bi,bj)
     &                                 + Phy68(i,j,k,bi,bj)
     &                                 + Phy69(i,j,k,bi,bj)
     &                                 + Phy70(i,j,k,bi,bj)
     &                                 + Phy71(i,j,k,bi,bj)
     &                                 + Phy72(i,j,k,bi,bj)
     &                                 + Phy73(i,j,k,bi,bj)
     &                                 + Phy74(i,j,k,bi,bj)
     &                                 + Phy75(i,j,k,bi,bj)
     &                                 + Phy76(i,j,k,bi,bj)
     &                                 + Phy77(i,j,k,bi,bj)
     &                                 + Phy78(i,j,k,bi,bj)
             end do
             if (k.eq.1)then
               atten= 0.D0
             end if
             atten= atten + (k0 + kc*sumpy(i,j))*5.D-1*drF(k)      
c   TEST
c            atten= atten + k0*drF(k)      

cccccccccccccccccccccccccccccccccccccccccccc
c            if(k .le. 3)then
c              write(6,*)'i,j,k, k0, kc, sumpy, kc*sumpy', 
c    &                       i,j,k, k0, kc, sumpy(i,j),kc*sumpy(i,j)
c            end if
ccccccccccccccccccccccccccccccccccccccccccc

             if (k.gt.1)then
               atten = atten + (k0+kc*sumpyup(i,j))*5.D-1*drF(k-1)     
c   TEST
c              atten = atten + k0*drF(k-1)     
             endif
c PAR, including account for albedo of ice cover
             PAR(i,j,k) = lite*(1.d0-fice(i,j,bi,bj))*exp(-atten)

ccc TEST ccccccccccccccccccccccccccccccccccccccccc
c            write(6,*)'i,j,k,k0,lite,par ',i,j,k,k0,lite,PAR(i,j,k)
cccccccccccccccccccccccccccccccccccccccccccccccccc
           end do
          end do
         end do
C.................................................................
C.................................................................


         DO j=1-OLy,sNy+OLy 
          DO i=1-OLx,sNx+OLx

c initialize tendencies from sinking particle fluxes
c         do k= 1, NR   
c             psinkP(k)  = 0.0d0
c             psinkN(k)  = 0.0d0
c             psinkFe(k)  = 0.0d0
c             psinkSi(k)  = 0.0d0
c         end do

c for each layer ...   
          do k= 1, NR   
           if (hFacC(i,j,k,bi,bj).gt.0.d0) then

c make sure we only deal with positive definite numbers
c brute force...
             po4l = max(PO4(i,j,k,bi,bj),0.D0)
             no3l = max(NO3(i,j,k,bi,bj),0.D0)
             fetl = max(FeT(i,j,k,bi,bj),0.D0)
             sil  = max(Si(i,j,k,bi,bj),0.D0)
             dopl = max(DOP(i,j,k,bi,bj),0.D0)
             donl = max(DON(i,j,k,bi,bj),0.D0)
             doFel   = max(DOFe(i,j,k,bi,bj),0.D0)
             zoop(1)  = max(Zoo1P(i,j,k,bi,bj),0.D0)
             zoon(1)  = max(Zoo1N(i,j,k,bi,bj),0.D0)
             zooFe(1) = max(Zoo1Fe(i,j,k,bi,bj),0.D0)
             zooSi(1)  = max(Zoo1Si(i,j,k,bi,bj),0.D0)
             zoop(2)  = max(Zoo2P(i,j,k,bi,bj),0.D0)
             zoon(2)  = max(Zoo2N(i,j,k,bi,bj),0.D0)
             zooFe(2) = max(Zoo2Fe(i,j,k,bi,bj),0.D0)
             zooSi(2)  = max(Zoo2Si(i,j,k,bi,bj),0.D0)
             Phy(1) = max(Phy1(i,j,k,bi,bj),0.D0)
             Phy(2)  = max(Phy2(i,j,k,bi,bj),0.D0)
             Phy(3)  = max(Phy3(i,j,k,bi,bj),0.D0)
             Phy(4)  = max(Phy4(i,j,k,bi,bj),0.D0)
             Phy(5)  = max(Phy5(i,j,k,bi,bj),0.D0)
             Phy(6)  = max(Phy6(i,j,k,bi,bj),0.D0)
             Phy(7)  = max(Phy7(i,j,k,bi,bj),0.D0)
             Phy(8)  = max(Phy8(i,j,k,bi,bj),0.D0)
             Phy(9)  = max(Phy9(i,j,k,bi,bj),0.D0)
             Phy(10)  = max(Phy10(i,j,k,bi,bj),0.D0)
             Phy(11)  = max(Phy11(i,j,k,bi,bj),0.D0)
             Phy(12)  = max(Phy12(i,j,k,bi,bj),0.D0)
             Phy(13)  = max(Phy13(i,j,k,bi,bj),0.D0)
             Phy(14)  = max(Phy14(i,j,k,bi,bj),0.D0)
             Phy(15)  = max(Phy15(i,j,k,bi,bj),0.D0)
             Phy(16)  = max(Phy16(i,j,k,bi,bj),0.D0)
             Phy(17)  = max(Phy17(i,j,k,bi,bj),0.D0)
             Phy(18)  = max(Phy18(i,j,k,bi,bj),0.D0)
             Phy(19)  = max(Phy19(i,j,k,bi,bj),0.D0)
             Phy(20)  = max(Phy20(i,j,k,bi,bj),0.D0)
             Phy(21)  = max(Phy21(i,j,k,bi,bj),0.D0)
             Phy(22)  = max(Phy22(i,j,k,bi,bj),0.D0)
             Phy(23)  = max(Phy23(i,j,k,bi,bj),0.D0)
             Phy(24)  = max(Phy24(i,j,k,bi,bj),0.D0)
             Phy(25)  = max(Phy25(i,j,k,bi,bj),0.D0)
             Phy(26)  = max(Phy26(i,j,k,bi,bj),0.D0)
             Phy(27)  = max(Phy27(i,j,k,bi,bj),0.D0)
             Phy(28)  = max(Phy28(i,j,k,bi,bj),0.D0)
             Phy(29)  = max(Phy29(i,j,k,bi,bj),0.D0)
             Phy(30)  = max(Phy30(i,j,k,bi,bj),0.D0)
             Phy(31)  = max(Phy31(i,j,k,bi,bj),0.D0)
             Phy(32)  = max(Phy32(i,j,k,bi,bj),0.D0)
             Phy(33)  = max(Phy33(i,j,k,bi,bj),0.D0)
             Phy(34)  = max(Phy34(i,j,k,bi,bj),0.D0)
             Phy(35)  = max(Phy35(i,j,k,bi,bj),0.D0)
             Phy(36)  = max(Phy36(i,j,k,bi,bj),0.D0)
             Phy(37)  = max(Phy37(i,j,k,bi,bj),0.D0)
             Phy(38)  = max(Phy38(i,j,k,bi,bj),0.D0)
             Phy(39)  = max(Phy39(i,j,k,bi,bj),0.D0)
             Phy(40)  = max(Phy40(i,j,k,bi,bj),0.D0)
             Phy(41)  = max(Phy41(i,j,k,bi,bj),0.D0)
             Phy(42)  = max(Phy42(i,j,k,bi,bj),0.D0)
             Phy(43)  = max(Phy43(i,j,k,bi,bj),0.D0)
             Phy(44)  = max(Phy44(i,j,k,bi,bj),0.D0)
             Phy(45)  = max(Phy45(i,j,k,bi,bj),0.D0)
             Phy(46)  = max(Phy46(i,j,k,bi,bj),0.D0)
             Phy(47)  = max(Phy47(i,j,k,bi,bj),0.D0)
             Phy(48)  = max(Phy48(i,j,k,bi,bj),0.D0)
             Phy(49)  = max(Phy49(i,j,k,bi,bj),0.D0)
             Phy(50)  = max(Phy50(i,j,k,bi,bj),0.D0)
             Phy(51)  = max(Phy51(i,j,k,bi,bj),0.D0)
             Phy(52)  = max(Phy52(i,j,k,bi,bj),0.D0)
             Phy(53)  = max(Phy53(i,j,k,bi,bj),0.D0)
             Phy(54)  = max(Phy54(i,j,k,bi,bj),0.D0)
             Phy(55)  = max(Phy55(i,j,k,bi,bj),0.D0)
             Phy(56)  = max(Phy56(i,j,k,bi,bj),0.D0)
             Phy(57)  = max(Phy57(i,j,k,bi,bj),0.D0)
             Phy(58)  = max(Phy58(i,j,k,bi,bj),0.D0)
             Phy(59)  = max(Phy59(i,j,k,bi,bj),0.D0)
             Phy(60)  = max(Phy60(i,j,k,bi,bj),0.D0)
             Phy(61)  = max(Phy61(i,j,k,bi,bj),0.D0)
             Phy(62)  = max(Phy62(i,j,k,bi,bj),0.D0)
             Phy(63)  = max(Phy63(i,j,k,bi,bj),0.D0)
             Phy(64)  = max(Phy64(i,j,k,bi,bj),0.D0)
             Phy(65)  = max(Phy65(i,j,k,bi,bj),0.D0)
             Phy(66)  = max(Phy66(i,j,k,bi,bj),0.D0)
             Phy(67)  = max(Phy67(i,j,k,bi,bj),0.D0)
             Phy(68)  = max(Phy68(i,j,k,bi,bj),0.D0)
             Phy(69)  = max(Phy69(i,j,k,bi,bj),0.D0)
             Phy(70)  = max(Phy70(i,j,k,bi,bj),0.D0)
             Phy(71)  = max(Phy71(i,j,k,bi,bj),0.D0)
             Phy(72)  = max(Phy72(i,j,k,bi,bj),0.D0)
             Phy(73)  = max(Phy73(i,j,k,bi,bj),0.D0)
             Phy(74)  = max(Phy74(i,j,k,bi,bj),0.D0)
             Phy(75)  = max(Phy75(i,j,k,bi,bj),0.D0)
             Phy(76)  = max(Phy76(i,j,k,bi,bj),0.D0)
             Phy(77)  = max(Phy77(i,j,k,bi,bj),0.D0)
             Phy(78)  = max(Phy78(i,j,k,bi,bj),0.D0)
             POPl = max(POP(i,j,k,bi,bj),0.D0)
             PONl = max(PON(i,j,k,bi,bj),0.D0)
             POFel = max(POFe(i,j,k,bi,bj),0.D0)
             PSil = max(Psi(i,j,k,bi,bj),0.D0)
             NH4l = max(NH4(i,j,k,bi,bj),0.D0)
             NO2l = max(NO2(i,j,k,bi,bj),0.D0)

             PARl = PAR(i,j,k)
             
             Tlocal = theta(i,j,k,bi,bj)
             Slocal = salt(i,j,k,bi,bj)
             dzlocal = drF(k)
             dtplankton = deltaTclock/float(nsubtime)

c if explicit sinking of particulate matter
             if (k.eq.1) then
                popupl =0.d0
                ponupl =0.d0
                pofeupl = 0.d0
                psiupl = 0.d0
             else
                popupl = max(POP(i,j,k-1,bi,bj),0.D0)
                ponupl = max(PON(i,j,k-1,bi,bj),0.D0)
                pofeupl = max(POFe(i,j,k-1,bi,bj),0.d0)
                psiupl = max(PSi(i,j,k-1,bi,bj),0.d0)
             endif

c set bottom=1.0 if the layer below is not ocean
             ktmp=min(nR,k+1)
             if(hFacC(i,j,ktmp,bi,bj).eq.0.d0.or.k.eq.Nr) then
               bottom = 1.0
             else 
               bottom = 0.0
             endif

c set local hfacc
c hfacc is fraction of cell volume actually ocean - for shaved
c or lopped cells in MITgcm
             hfacclocal = hFacC(i,j,k,bi,bj)

c test......................................
c            if(i .eq. 10 .and. j .eq. 10 .and. k .eq. 1)then
c              write(6,*)'before plankton i,j,k ',i,j,k
c              do np = 1,nzmax 
c                write(6,*)'np, zooP ',np,zooP(np)
c              enddo 
c            endif
c...........................................

CMICK ==========================================================
CMICK --- PARTICLE FLUX DIVERGENCE OUTSIDE MAIN PLANKTON ROUTINE
c determine flux divergence of sinking particulate
c put in one-dimensional array
c step forward after finishing z loop
            if(bottom .eq. 1.0)then
              psinkP(k)  = (wp_sink*POPupl)/(dzlocal*hfacclocal)
              psinkN(k)  = (wn_sink*PONupl)/(dzlocal*hfacclocal)
              psinkFe(k) = (wfe_sink*POFeupl)/(dzlocal*hfacclocal)
              psinkSi(k) = (wsi_sink*PSiupl)/(dzlocal*hfacclocal)
            else
              psinkP(k)  = (wp_sink*(POPupl-POPl))/
     &                                   (dzlocal*hfacclocal)
              psinkN(k)  = (wn_sink*(PONupl-PONl))/
     &                                   (dzlocal*hfacclocal)
              psinkFe(k) = (wfe_sink*(POFeupl-POFel))/
     &                                   (dzlocal*hfacclocal)
              psinkSi(k) = (wsi_sink*(PSiupl-PSil))/
     &                                   (dzlocal*hfacclocal)
            endif
CMICK ==========================================================


             CALL PLANKTON(Phy, zooP, zooN, zooFe, zooSi, PP,
     &                     PO4l, NO3l, FeTl, Sil,
     &                     NO2l, NH4l,
     &                     DOPl, DONl, DOFel,
     &                     POPl,PONl,POFel,PSil,
C     &                     POPupl,PONupl,POFeupl,PSiupl,
     &                     PARl,Tlocal,Slocal,
     &                     dtplankton,dzlocal,
     &                     hfacclocal, bottom,
     &                     MyThid)

c test......................................
c            if(i .eq. 10 .and. j .eq. 10 .and. k .eq. 1)then
c              write(6,*)'after plankton i,j,k ',i,j,k
c              do np = 1,nzmax 
c                write(6,*)'np, zooP ',np,zooP(np)
c              enddo
c            endif
c...........................................

c now pass local values back to the main tracer arrays
             PO4(i,j,k,bi,bj) = po4l
             NO3(i,j,k,bi,bj) = no3l
             FeT(i,j,k,bi,bj) = fetl
             Si(i,j,k,bi,bj) = sil
             DOP(i,j,k,bi,bj) = dopl
             DON(i,j,k,bi,bj) = donl
             DOFe(i,j,k,bi,bj) = doFel
             Zoo1P(i,j,k,bi,bj) = zoop(1)
             Zoo1N(i,j,k,bi,bj) = zoon(1)
             Zoo1Fe(i,j,k,bi,bj) = zooFe(1)
             Zoo1Si(i,j,k,bi,bj) = zooSi(1)
             Zoo2P(i,j,k,bi,bj) = zoop(2)
             Zoo2N(i,j,k,bi,bj) = zoon(2)
             Zoo2Fe(i,j,k,bi,bj) = zooFe(2)
             Zoo2Si(i,j,k,bi,bj) = zooSi(2)
             Phy1(i,j,k,bi,bj) = Phy(1)
             Phy2(i,j,k,bi,bj) = Phy(2)
             Phy3(i,j,k,bi,bj) = Phy(3)
             Phy4(i,j,k,bi,bj) = Phy(4)
             Phy5(i,j,k,bi,bj) = Phy(5)
             Phy6(i,j,k,bi,bj) = Phy(6)
             Phy7(i,j,k,bi,bj) = Phy(7)
             Phy8(i,j,k,bi,bj) = Phy(8)
             Phy9(i,j,k,bi,bj) = Phy(9)
             Phy10(i,j,k,bi,bj) = Phy(10)
             Phy11(i,j,k,bi,bj) = Phy(11)
             Phy12(i,j,k,bi,bj) = Phy(12)
             Phy13(i,j,k,bi,bj) = Phy(13)
             Phy14(i,j,k,bi,bj) = Phy(14)
             Phy15(i,j,k,bi,bj) = Phy(15)
             Phy16(i,j,k,bi,bj) = Phy(16)
             Phy17(i,j,k,bi,bj) = Phy(17)
             Phy18(i,j,k,bi,bj) = Phy(18)
             Phy19(i,j,k,bi,bj) = Phy(19)
             Phy20(i,j,k,bi,bj) = Phy(20)
             Phy21(i,j,k,bi,bj) = Phy(21)
             Phy22(i,j,k,bi,bj) = Phy(22)
             Phy23(i,j,k,bi,bj) = Phy(23)
             Phy24(i,j,k,bi,bj) = Phy(24)
             Phy25(i,j,k,bi,bj) = Phy(25)
             Phy26(i,j,k,bi,bj) = Phy(26)
             Phy27(i,j,k,bi,bj) = Phy(27)
             Phy28(i,j,k,bi,bj) = Phy(28)
             Phy29(i,j,k,bi,bj) = Phy(29)
             Phy30(i,j,k,bi,bj) = Phy(30)
             Phy31(i,j,k,bi,bj) = Phy(31)
             Phy32(i,j,k,bi,bj) = Phy(32)
             Phy33(i,j,k,bi,bj) = Phy(33)
             Phy34(i,j,k,bi,bj) = Phy(34)
             Phy35(i,j,k,bi,bj) = Phy(35)
             Phy36(i,j,k,bi,bj) = Phy(36)
             Phy37(i,j,k,bi,bj) = Phy(37)
             Phy38(i,j,k,bi,bj) = Phy(38)
             Phy39(i,j,k,bi,bj) = Phy(39)
             Phy40(i,j,k,bi,bj) = Phy(40)
             Phy41(i,j,k,bi,bj) = Phy(41)
             Phy42(i,j,k,bi,bj) = Phy(42)
             Phy43(i,j,k,bi,bj) = Phy(43)
             Phy44(i,j,k,bi,bj) = Phy(44)
             Phy45(i,j,k,bi,bj) = Phy(45)
             Phy46(i,j,k,bi,bj) = Phy(46)
             Phy47(i,j,k,bi,bj) = Phy(47)
             Phy48(i,j,k,bi,bj) = Phy(48)
             Phy49(i,j,k,bi,bj) = Phy(49)
             Phy50(i,j,k,bi,bj) = Phy(50)
             Phy51(i,j,k,bi,bj) = Phy(51)
             Phy52(i,j,k,bi,bj) = Phy(52)
             Phy53(i,j,k,bi,bj) = Phy(53)
             Phy54(i,j,k,bi,bj) = Phy(54)
             Phy55(i,j,k,bi,bj) = Phy(55)
             Phy56(i,j,k,bi,bj) = Phy(56)
             Phy57(i,j,k,bi,bj) = Phy(57)
             Phy58(i,j,k,bi,bj) = Phy(58)
             Phy59(i,j,k,bi,bj) = Phy(59)
             Phy60(i,j,k,bi,bj) = Phy(60)
             Phy61(i,j,k,bi,bj) = Phy(61)
             Phy62(i,j,k,bi,bj) = Phy(62)
             Phy63(i,j,k,bi,bj) = Phy(63)
             Phy64(i,j,k,bi,bj) = Phy(64)
             Phy65(i,j,k,bi,bj) = Phy(65)
             Phy66(i,j,k,bi,bj) = Phy(66)
             Phy67(i,j,k,bi,bj) = Phy(67)
             Phy68(i,j,k,bi,bj) = Phy(68)
             Phy69(i,j,k,bi,bj) = Phy(69)
             Phy70(i,j,k,bi,bj) = Phy(70)
             Phy71(i,j,k,bi,bj) = Phy(71)
             Phy72(i,j,k,bi,bj) = Phy(72)
             Phy73(i,j,k,bi,bj) = Phy(73)
             Phy74(i,j,k,bi,bj) = Phy(74)
             Phy75(i,j,k,bi,bj) = Phy(75)
             Phy76(i,j,k,bi,bj) = Phy(76)
             Phy77(i,j,k,bi,bj) = Phy(77)
             Phy78(i,j,k,bi,bj) = Phy(78)
             POP(i,j,k,bi,bj) = POPl
             PON(i,j,k,bi,bj) = PONl
             POFe(i,j,k,bi,bj) = POFel  
             Psi(i,j,k,bi,bj) = PSil
             NH4(i,j,k,bi,bj) = NH4l   
             NO2(i,j,k,bi,bj) = NO2l

#ifdef ALLOW_TIMEAVE
c save averages
c            Phygrow1ave(i,j,k,bi,bj)=Phygrow1ave(i,j,k,bi,bj)+
c    &                             mu1*py1*deltaTclock
c    &                       /float(nsubtime)
c            Phygrow2ave(i,j,k,bi,bj)=Phygrow2ave(i,j,k,bi,bj)+
c    &                             mu2*py2*deltaTclock
c    &                       /float(nsubtime)
c            Zoograzave(i,j,k,bi,bj)=Zoograzave(i,j,k,bi,bj)+
c    &                      (gampn1*graz1*zo +gampn2*graz2*zo)*
c    &                       deltaTclock/float(nsubtime)
c            Parave(i,j,k,bi,bj)=Parave(i,j,k,bi,bj)+
c    &                           lite*exp(-atten)*
c    &                           deltaTclock/float(nsubtime)
c            Chlave(i,j,k,bi,bj)=Chlave(i,j,k,bi,bj)+
c    &           (chlpmax-(chlpmax-chlpmin)*
c    &           min(lite*exp(-atten)/istar, 1.d0) )*
c    &           (py1*min(nu/(nu+nlim1),fu/(fu+flim1)) +
c    &            py2*min(fu/(fu+flim2),
c    &                      min(nu/(nu+nlim2),si/(si+slim2)) )  )
c    &                          * deltaTclock/float(nsubtime)
#endif
          endif  
c end if hFac>0
         enddo
c end layer loop
c

c timestep for vertical flux divergenoce of particulate
          do k= 1, NR   
           if (hFacC(i,j,k,bi,bj).gt.0.d0) then
             POP(i,j,k,bi,bj)  = POP(i,j,k,bi,bj) + dtplankton*psinkP(k)
             PON(i,j,k,bi,bj)  = PON(i,j,k,bi,bj) + dtplankton*psinkN(k)
             POFe(i,j,k,bi,bj) = POFe(i,j,k,bi,bj) + 
     &                             dtplankton*PsinkFe(k)
             PSi(i,j,k,bi,bj) = PSi(i,j,k,bi,bj) + 
     &                             dtplankton*PsinkSi(k)
c and iron chemistry
             freefu = max(freefe(i,j,k,bi,bj),0.d0)
             FeT(i,j,k,bi,bj) = FeT(i,j,k,bi,bj) -
     &                          scav*freefu*dtplankton
             if (k.eq.1) then 
               FeT(i,j,k,bi,bj) = FeT(i,j,k,bi,bj) +
     &                      (alpfe*inputFe(i,j,bi,bj)/drF(1))*dtplankton
             endif
            endif  
          end do


       ENDDO
       ENDDO

c determine iron partitioning  - solve for free iron
         call fe_chem(bi,bj,iMin,iMax,jMin,jMax, FeT, freefe,
     &                myIter, mythid)


c
#ifdef ALLOW_TIMEAVE
c save averages
c      do k=1,nR
c        npzd_timeave(k,bi,bj)=npzd_timeave(k,bi,bj)
c    &                         +deltaTclock
c    &                       /float(nsubtime)
c      enddo
#endif
c
c -----------------------------------------------------
       ENDDO
c -----------------------------------------------------
c end of bio-chemical time loop
c 
        RETURN
        END
#endif  /*DARWIN*/
#endif  /*ALLOW_PTRACERS*/

C============================================================================
