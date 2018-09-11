#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_DARWIN

c=============================================================
c subroutine DARWIN_forcing
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
#include "DARWIN_IO.h"
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
      _RL  Phyup(npmax)
c iron partitioning
      _RL  freefe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
c some working variables
      _RL  sumpy
      _RL  sumpyup
c light variables
      _RL  PAR(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      _RL  sfac(1-OLy:sNy+OLy)
      _RL  atten,lite
      _RL  newtime

c   
      _RL freefu
      _RL inputFel

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
       _RL PP(npmax)

c local tendencies
       _RL dphy(npmax)
       _RL dzoop(nzmax)
       _RL dzoon(nzmax)
       _RL dzoofe(nzmax)
       _RL dzoosi(nzmax)
       _RL dPO4l
       _RL dNO3l
       _RL dFeTl
       _RL dSil
       _RL dDOPl
       _RL dDONl
       _RL dDOFel
       _RL dPOPl
       _RL dPONl
       _RL dPOFel
       _RL dPSil
       _RL dNH4l
       _RL dNO2l


      INTEGER i,j,k,it, ktmp
      INTEGER np, nz
      INTEGER debug


c
       DO j=1-OLy,sNy+OLy
       DO i=1-OLx,sNx+OLx
        do k=1,Nr
           freefe(i,j,k,bi,bj)=0.d0
           PAR(i,j,k) = 0.d0
        enddo
       ENDDO
       ENDDO
c
c bio-chemical time loop
c--------------------------------------------------
       do it=1,nsubtime
c -------------------------------------------------
         newtime=myTime-dTtracerLev(1)+
     &           float(it)*dTtracerLev(1)/float(nsubtime)
c        print*,'it  ',it,newtime,nsubtime,myTime


c determine iron partitioning  - solve for free iron
c ---------------------------
         call fe_chem(bi,bj,iMin,iMax,jMin,jMax, FeT, freefe,
     &                myIter, mythid)
c --------------------------

 
c find light in each grid cell
c ---------------------------
c determine incident light
#ifndef  READ_PAR
         DO j=1-OLy,sNy+OLy
          sfac(j)=0.d0
         ENDDO
         call INSOL(newTime,sfac,bj)
         DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
           sur_par(i,j,bi,bj)=sfac(j)*maskC(i,j,1,bi,bj)
         ENDDO
         ENDDO
#endif

C.................................................................
C.................................................................


         DO j=1-OLy,sNy+OLy 
          DO i=1-OLx,sNx+OLx

c surface PAR
c take ice coverage into account
           lite=sur_par(i,j,bi,bj)*(1.d0-fice(i,j,bi,bj))
           atten=0.d0
           sumpy = 0.0d0

c for each layer ...   
          do k= 1, NR   
           if (HFacC(i,j,k,bi,bj).gt.0.d0) then

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

c find local light
             sumpyup = sumpy
             sumpy = 0.d0
             do np=1,npmax
                sumpy = sumpy + Phy(np)
             enddo
             atten= atten + (k0 + kc*sumpy)*5.D-1*drF(k)
             if (k.gt.1)then
               atten = atten + (k0+kc*sumpyup)*5.D-1*drF(k-1)
             endif
             PAR(i,j,k) = lite*exp(-atten)


c for explicit sinking of particulate matter and phytoplankton
             if (k.eq.1) then
                popupl =0.d0
                ponupl =0.d0
                pofeupl = 0.d0
                psiupl = 0.d0
                do np=1,npmax
                  Phyup(np)=0.d0
                enddo
             endif


             PARl = PAR(i,j,k)
             
             Tlocal = theta(i,j,k,bi,bj)
             Slocal = salt(i,j,k,bi,bj)

             freefu = max(freefe(i,j,k,bi,bj),0.d0)
             if (k.eq.1) then
               inputFel = inputFe(i,j,bi,bj)
             else
               inputFel = 0.d0
             endif

             dzlocal = drF(k)*HFacC(i,j,k,bi,bj)
c set bottom=1.0 if the layer below is not ocean
             ktmp=min(nR,k+1)
             if(hFacC(i,j,ktmp,bi,bj).eq.0.d0.or.k.eq.Nr) then
               bottom = 1.0
             else
               bottom = 0.0
             endif

c set tendencies to 0
             do np=1,npmax
               dphy(np)=0.d0
             enddo
             do nz=1,nzmax
               dzoop(nz)=0.d0
               dzoon(nz)=0.d0
               dzoofe(nz)=0.d0
               dzoosi(nz)=0.d0
             enddo
             dPO4l=0.d0
             dNO3l=0.d0
             dFeTl=0.d0
             dSil=0.d0
             dDOPl=0.d0
             dDONl=0.d0
             dDOFel=0.d0
             dPOPl=0.d0
             dPONl=0.d0
             dPOFel=0.d0
             dPSil=0.d0
             dNH4l=0.d0
             dNO2l=0.d0


            debug=0
c           if (i.eq.20.and.j.eq.20.and.k.eq.1) debug=8
            if (i.eq.10.and.j.eq.10.and.k.ge.1) debug=10

            if (debug.eq.7) print*,'PO4, DOP, POP, ZooP',
     &                       PO4l,  DOPl, POPl, zooP
            if (debug.eq.7) print*,'NO3, NO2, NH4, DON, PON, ZooN', 
     &                       NO3l,NO2l,NH4l, DONl, PONl, ZooN
            if (debug.eq.7) print*,'FeT, DOFe, POFe, Zoofe', 
     &                       FeTl,  DOFel, POFel, zooFe
            if (debug.eq.7) print*,'Si, Psi, zooSi', 
     &                       Sil, PSil, zooSi

            if (debug.eq.8) print*,'k, PARl, inputFel, dzlocal',
     &                        PARl, inputFel, dzlocal

             CALL PLANKTON(Phy, zooP, zooN, zooFe, zooSi, PP,
     &                     PO4l, NO3l, FeTl, Sil,
     &                     NO2l, NH4l,
     &                     DOPl, DONl, DOFel,
     &                     POPl,PONl,POFel,PSil,
     &                     Phyup, popupl, ponupl, pofeupl, psiupl,
     &                     PARl,Tlocal,Slocal, 
     &                     freefu, inputFel,
     &                     bottom, dzlocal,
     &                     dphy, dzoop, dzoon, dzoofe, dzoosi,
     &                     dPO4l, dNO3l, dFeTl, dSil, 
     &                     dNH4l, dNO2l,
     &                     dDOPl, dDONl, dDOFel,
     &                     dPOPl, dPONl, dPOFel, dPSil,
     &                     debug,
     &                     MyThid)
c
             popupl = POPl
             ponupl = PONl
             pofeupl = POFel
             psiupl = PSil
             do np=1,npmax
               Phyup(np) = Phy(np) 
             enddo
c
c now update main tracer arrays
             dtplankton = dTtracerLev(k)/float(nsubtime)
             PO4(i,j,k,bi,bj) = PO4(i,j,k,bi,bj)+
     &                                dtplankton*dpo4l
             NO3(i,j,k,bi,bj) = NO3(i,j,k,bi,bj) +
     &                                dtplankton*dno3l
             FeT(i,j,k,bi,bj) = FeT(i,j,k,bi,bj) +
     &                                dtplankton*dfetl
             Si(i,j,k,bi,bj) = Si(i,j,k,bi,bj) +
     &                                dtplankton*dsil
             DOP(i,j,k,bi,bj) = DOP(i,j,k,bi,bj) +
     &                                dtplankton*ddopl
             DON(i,j,k,bi,bj) = DON(i,j,k,bi,bj) +
     &                                dtplankton*ddonl
             DOFe(i,j,k,bi,bj) = DOFe(i,j,k,bi,bj) +
     &                                dtplankton*ddoFel
             Zoo1P(i,j,k,bi,bj) = Zoo1P(i,j,k,bi,bj) +
     &                                dtplankton*dzoop(1)
             Zoo1N(i,j,k,bi,bj) = Zoo1N(i,j,k,bi,bj) +
     &                                dtplankton*dzoon(1)
             Zoo1Fe(i,j,k,bi,bj) = Zoo1Fe(i,j,k,bi,bj) +
     &                                dtplankton*dzooFe(1)
             Zoo1Si(i,j,k,bi,bj) = Zoo1Si(i,j,k,bi,bj) +
     &                                dtplankton*dzooSi(1)
             Zoo2P(i,j,k,bi,bj) = Zoo2P(i,j,k,bi,bj) +
     &                                dtplankton*dzoop(2)
             Zoo2N(i,j,k,bi,bj) = Zoo2N(i,j,k,bi,bj) +
     &                                dtplankton*dzoon(2)
             Zoo2Fe(i,j,k,bi,bj) = Zoo2Fe(i,j,k,bi,bj) +
     &                                dtplankton*dzooFe(2)
             Zoo2Si(i,j,k,bi,bj) = Zoo2Si(i,j,k,bi,bj) +
     &                                dtplankton*dzooSi(2)
             Phy1(i,j,k,bi,bj) = Phy1(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(1)
             Phy2(i,j,k,bi,bj) = Phy2(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(2)
             Phy3(i,j,k,bi,bj) = Phy3(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(3)
             Phy4(i,j,k,bi,bj) = Phy4(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(4)
             Phy5(i,j,k,bi,bj) = Phy5(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(5)
             Phy6(i,j,k,bi,bj) = Phy6(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(6)
             Phy7(i,j,k,bi,bj) = Phy7(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(7)
             Phy8(i,j,k,bi,bj) = Phy8(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(8)
             Phy9(i,j,k,bi,bj) = Phy9(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(9)
             Phy10(i,j,k,bi,bj) = Phy10(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(10)
             Phy11(i,j,k,bi,bj) = Phy11(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(11)
             Phy12(i,j,k,bi,bj) = Phy12(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(12)
             Phy13(i,j,k,bi,bj) = Phy13(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(13)
             Phy14(i,j,k,bi,bj) = Phy14(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(14)
             Phy15(i,j,k,bi,bj) = Phy15(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(15)
             Phy16(i,j,k,bi,bj) = Phy16(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(16)
             Phy17(i,j,k,bi,bj) = Phy17(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(17)
             Phy18(i,j,k,bi,bj) = Phy18(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(18)
             Phy19(i,j,k,bi,bj) = Phy19(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(19)
             Phy20(i,j,k,bi,bj) = Phy20(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(20)
             Phy21(i,j,k,bi,bj) = Phy21(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(21)
             Phy22(i,j,k,bi,bj) = Phy22(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(22)
             Phy23(i,j,k,bi,bj) = Phy23(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(23)
             Phy24(i,j,k,bi,bj) = Phy24(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(24)
             Phy25(i,j,k,bi,bj) = Phy25(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(25)
             Phy26(i,j,k,bi,bj) = Phy26(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(26)
             Phy27(i,j,k,bi,bj) = Phy27(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(27)
             Phy28(i,j,k,bi,bj) = Phy28(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(28)
             Phy29(i,j,k,bi,bj) = Phy29(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(29)
             Phy30(i,j,k,bi,bj) = Phy30(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(30)
             Phy31(i,j,k,bi,bj) = Phy31(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(31)
             Phy32(i,j,k,bi,bj) = Phy32(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(32)
             Phy33(i,j,k,bi,bj) = Phy33(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(33)
             Phy34(i,j,k,bi,bj) = Phy34(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(34)
             Phy35(i,j,k,bi,bj) = Phy35(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(35)
             Phy36(i,j,k,bi,bj) = Phy36(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(36)
             Phy37(i,j,k,bi,bj) = Phy37(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(37)
             Phy38(i,j,k,bi,bj) = Phy38(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(38)
             Phy39(i,j,k,bi,bj) = Phy39(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(39)
             Phy40(i,j,k,bi,bj) = Phy40(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(40)
             Phy41(i,j,k,bi,bj) = Phy41(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(41)
             Phy42(i,j,k,bi,bj) = Phy42(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(42)
             Phy43(i,j,k,bi,bj) = Phy43(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(43)
             Phy44(i,j,k,bi,bj) = Phy44(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(44)
             Phy45(i,j,k,bi,bj) = Phy45(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(45)
             Phy46(i,j,k,bi,bj) = Phy46(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(46)
             Phy47(i,j,k,bi,bj) = Phy47(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(47)
             Phy48(i,j,k,bi,bj) = Phy48(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(48)
             Phy49(i,j,k,bi,bj) = Phy49(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(49)
             Phy50(i,j,k,bi,bj) = Phy50(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(50)
             Phy51(i,j,k,bi,bj) = Phy51(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(51)
             Phy52(i,j,k,bi,bj) = Phy52(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(52)
             Phy53(i,j,k,bi,bj) = Phy53(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(53)
             Phy54(i,j,k,bi,bj) = Phy54(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(54)
             Phy55(i,j,k,bi,bj) = Phy55(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(55)
             Phy56(i,j,k,bi,bj) = Phy56(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(56)
             Phy57(i,j,k,bi,bj) = Phy57(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(57)
             Phy58(i,j,k,bi,bj) = Phy58(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(58)
             Phy59(i,j,k,bi,bj) = Phy59(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(59)
             Phy60(i,j,k,bi,bj) = Phy60(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(60)
             Phy61(i,j,k,bi,bj) = Phy61(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(61)
             Phy62(i,j,k,bi,bj) = Phy62(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(62)
             Phy63(i,j,k,bi,bj) = Phy63(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(63)
             Phy64(i,j,k,bi,bj) = Phy64(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(64)
             Phy65(i,j,k,bi,bj) = Phy65(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(65)
             Phy66(i,j,k,bi,bj) = Phy66(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(66)
             Phy67(i,j,k,bi,bj) = Phy67(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(67)
             Phy68(i,j,k,bi,bj) = Phy68(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(68)
             Phy69(i,j,k,bi,bj) = Phy69(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(69)
             Phy70(i,j,k,bi,bj) = Phy70(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(70)
             Phy71(i,j,k,bi,bj) = Phy71(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(71)
             Phy72(i,j,k,bi,bj) = Phy72(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(72)
             Phy73(i,j,k,bi,bj) = Phy73(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(73)
             Phy74(i,j,k,bi,bj) = Phy74(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(74)
             Phy75(i,j,k,bi,bj) = Phy75(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(75)
             Phy76(i,j,k,bi,bj) = Phy76(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(76)
             Phy77(i,j,k,bi,bj) = Phy77(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(77)
             Phy78(i,j,k,bi,bj) = Phy78(i,j,k,bi,bj) +
     &                                dtplankton*dPhy(78)
             POP(i,j,k,bi,bj) = POP(i,j,k,bi,bj) +
     &                                dtplankton*dPOPl
             PON(i,j,k,bi,bj) = PON(i,j,k,bi,bj) +
     &                                dtplankton*dPONl
             POFe(i,j,k,bi,bj) = POFe(i,j,k,bi,bj) +
     &                                dtplankton*dPOFel  
             Psi(i,j,k,bi,bj) = Psi(i,j,k,bi,bj) +
     &                                dtplankton*dPSil
             NH4(i,j,k,bi,bj) = NH4(i,j,k,bi,bj) +
     &                                dtplankton*dNH4l   
             NO2(i,j,k,bi,bj) = NO2(i,j,k,bi,bj) +
     &                                dtplankton*dNO2l

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
