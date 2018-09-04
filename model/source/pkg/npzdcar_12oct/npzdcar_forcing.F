#include "CPP_OPTIONS.h"
#include "PTRACERS_OPTIONS.h"
#include "GCHEM_OPTIONS.h"

#ifdef ALLOW_PTRACERS
#ifdef ALLOW_NPZDCAR

c=============================================================
c subroutine NPZDCAR_forcing
c step forward bio-chemical tracers in time
C==============================================================
         SUBROUTINE NPZDCAR_Forcing(Nut,Phy,Phy2,Zoo,DON,PON,
     &                              Sil,POS,FeT,ZFe,DOF,POF,
     &                              DIC,ZoC,DOC,POC,PIC,Oxy,Alk,
     &                       bi,bj,imin,imax,jmin,jmax,
     &                        myIter,myTime,myThid)
#include "SIZE.h"
#include "DYNVARS.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS.h"
#include "NPZDCAR.h"
#include "GCHEM.h"

C     === Global variables ===
c tracers
      _RL  Nut(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Phy2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Zoo(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  PON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Sil(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  POS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  FeT(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  ZFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DOF(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  POF(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  ZoC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  DOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  POC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  PIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Oxy(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  Alk(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
       INTEGER myIter
       _RL myTime
       INTEGER myThid
       INTEGER bi,bj,imin,imax,jmin,jmax


C============== Local variables ============================================
c tracer tendencies
      _RL  GNut(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPhy(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPhy2(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GZoo(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GDON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPON(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GSil(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPOS(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GFeT(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GZFe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GDOF(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPOF(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GDIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GZoC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GDOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPOC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GPIC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GOxy(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)
      _RL  GAlk(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx, nSy)

c
      _RL  freefe(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr,nSx,nSy)
      _RL  SURC(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  SURO(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  SURA(1-OLx:sNx+OLx,1-OLy:sNy+OLy,nSx,nSy)
      _RL  CHL(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
c light variables
      _RL  sfac(1-OLy:sNy+OLy)
      _RL  atten, lite
      _RL  atten0
c
      _RL  mu, mu2, graz, graz2
      _RL  nu, py, py2, zo, dn
      _RL  pyup, py2up 
      _RL  pym, py2m,  zom, zfm, zcm
      _RL  pn,  pnup
      _RL  zeep, zp
      _RL  si, ps, psup
      _RL  fu, zf, df,pf, pfup
      _RL  ca, zc, dc, pc, pcup, pcc, pccup
      _RL  ox, al
      _RL  freefu
      _RL  tempfunc
      _RL  newtime
        INTEGER I,J,K,it, ktmp
c
       DO j=1-OLy,sNy+OLy
       DO i=1-OLx,sNx+OLx
        surc(i,j,bi,bj)=0.d0
        suro(i,j,bi,bj)=0.d0
        sura(i,j,bi,bj)=0.d0
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
         newtime=myTime-dTtracerLev(1)+
     &           float(it)*dTtracerLev(1)/float(nsubtime)
c        print*,'it  ',it,newtime,nsubtime,myTime

c carbon air-sea interaction
       CALL DIC_SURFFORCING( DIC, ALK, Nut, Sil,
     &                     SURC,
     &                    bi,bj,imin,imax,jmin,jmax,
     &                    myIter,myTime,myThid)

c      print*,'forc, co2 flux',SURC(10,10,1,1)
c
c alkalinity air-sea interaction
       CALL ALK_SURFFORCING( ALK, SURA,
     &                    bi,bj,imin,imax,jmin,jmax,
     &                    myIter,myTime,myThid)

c      print*,'forc, alk flux',SURA(10,10,1,1)
c
c carbon air-sea interaction
       CALL O2_SURFFORCING( Oxy, SURO,
     &                    bi,bj,imin,imax,jmin,jmax,
     &                    myIter,myTime,myThid)

c       print*,'forc, o2 flux',SURO(10,10,1,1)
c
c find free iron
         call fe_chem(bi,bj,iMin,iMax,jMin,jMax, FeT, freefe,
     &                myIter, mythid)
c find incidence light
#ifndef  READ_PAR
         DO j=1-OLy,sNy+OLy
          sfac(j)=0.d0
         ENDDO
         call insol(newTime,sfac,bj)
         DO j=1-OLy,sNy+OLy
         DO i=1-OLx,sNx+OLx
           sur_par(i,j,bi,bj)=sfac(j)*maskC(i,j,1,bi,bj)
         ENDDO
         ENDDO
#endif
c
         DO j=1-OLy,sNy+OLy 
         DO i=1-OLx,sNx+OLx
          atten=0.d0
c for each layer find
          do k= 1, NR   
           if (hFacC(i,j,k,bi,bj).gt.0.d0) then
c
c make sure we only deal with positive definite
c numbers
             nu  = max(Nut(i,j,k,bi,bj),0.D0)
             py =  max(Phy(i,j,k,bi,bj),0.D0)
             py2 = max(Phy2(i,j,k,bi,bj),0.D0)
             zo  = max(Zoo(i,j,k,bi,bj),0.D0)
             dn  = max(DON(i,j,k,bi,bj),0.D0)
             if (k.eq.1) then
              pyup = 0.d0
              py2up = 0.d0
             else
              pyup = max(Phy(i,j,k-1,bi,bj),0.D0)
              py2up = max(Phy2(i,j,k-1,bi,bj),0.D0)
             endif
             si = max(Sil(i,j,k,bi,bj),0.d0)
             fu = max(FeT(i,j,k,bi,bj),0.d0)
             zf = max(ZFe(i,j,k,bi,bj),0.d0)
             df = max(DOF(i,j,k,bi,bj),0.d0)
             freefu = max(freefe(i,j,k,bi,bj),0.d0)
             ca = max(DIC(i,j,k,bi,bj),0.d0)
             zc = max(ZoC(i,j,k,bi,bj),0.d0)
             dc = max(DOC(i,j,k,bi,bj),0.d0)
             ox = max(Oxy(i,j,k,bi,bj),0.d0)
             al = max(Alk(i,j,k,bi,bj),0.d0)
             if (k.lt.5) then
               pym = max((py-phymin),0.D0)
               py2m =max((py2-phymin),0.D0)
               zom = max((zo-zoomin),0.D0)
               zfm = max((zf-zoominfe),0.D0)
               zcm = max((zc-zoominc),0.D0)
             else
               pym = py
               py2m = py2
               zom = zo
               zfm = zf
               zcm = zc
             endif
c if explicit sinking of particulate matter
             pn  = max(PON(i,j,k,bi,bj),0.D0)
             ps  = max(POS(i,j,k,bi,bj),0.D0)
             pf  = max(POF(i,j,k,bi,bj),0.D0)
             pc  = max(POC(i,j,k,bi,bj),0.D0)
             pcc  = max(PIC(i,j,k,bi,bj),0.D0) 
             if (k.eq.1) then
               pnup =0.d0
               psup = 0.d0
               pfup = 0.d0
               pcup = 0.d0
               pccup = 0.d0
             else
               pnup = max(PON(i,j,k-1,bi,bj),0.D0)
               psup = max(POS(i,j,k-1,bi,bj),0.d0)
               pfup = max(POF(i,j,k-1,bi,bj),0.d0)
               pcup = max(POC(i,j,k-1,bi,bj),0.d0)
               pccup = max(PIC(i,j,k-1,bi,bj),0.d0)
             endif
c for start, provide value to par (need to make better)
            if (myIter.eq.nIter0) then
             if (k.eq.1) atten0= 0.D0
             atten0= atten0 +( k0 +kc*((py+py2)*16) )*5.D-1*(drF(k))
             if (k.gt.1) atten0 = atten0
     &            +( k0+kc*(CHL(i,j,k-1)) )*5.D-1*(drF(k-1))
             PAR(i,j,k,bi,bj)=
     &          sur_par(i,j,bi,bj)*(1.d0-fice(i,j,bi,bj))*exp(-atten0)
            endif
c cholorphyll concentrations
            CHL(i,j,k)=(chlpmax-(chlpmax-chlpmin)*
     &           min(PAR(i,j,k,bi,bj)/istar, 1.d0) )*
     &           (py*min(nu/(nu+nlim),fu/(fu+flim)) +
     &            py2*min(fu/(fu+flim2),
     &                      min(nu/(nu+nlim2),si/(si+slim2)) )  )
c attenuate light
             if (k.eq.1) atten= 0.D0
             atten= atten +( k0 +kc*(CHL(i,j,k)) )*5.D-1*(drF(k))      
             if (k.gt.1) atten = atten                 
     &            +( k0+kc*(CHL(i,j,k-1)) )*5.D-1*(drF(k-1))     
             PAR(i,j,k,bi,bj)=
     &          sur_par(i,j,bi,bj)*(1.d0-fice(i,j,bi,bj))*exp(-atten)
             lite=PAR(i,j,k,bi,bj)
c phytoplankton growth rates
             mu= phygrow*lite/(ilim+lite)   
             mu= mu* min(nu/(nu+nlim),fu/(fu+flim))
             mu2= phygrow2*lite/(ilim2+lite)
             mu2= mu2* min(fu/(fu+flim2),
     &                      min(nu/(nu+nlim2),si/(si+slim2)) )
c take into account ice coverage
             mu= (1.d0 -fice(i,j,bi,bj))*mu
             mu2= (1.d0 -fice(i,j,bi,bj))*mu2
c temperature function
             tempfunc=1.d0/temp_coeff_norm * 
     &          temp_coeff_base**theta(i,j,k,bi,bj)
             mu = mu * tempfunc
             mu2 = mu2 * tempfunc
c zooplankton grazing rates
             zeep= zplat*py + zplat2*py2
             zp=max(zeep-grazlim,0.d0)
             if (zeep.gt.0.d0) then
               graz= zoograze*zplat*py/zeep*
     &                          (zp)/(zp+plim)
               graz2= zoograze*zplat2*py2/zeep*
     &                          (zp)/(zp+plim)
             else
               graz=0.d0
               graz2=0.d0
             endif
c
c calculate tendency terms
             GNut(i,j,k,bi,bj)=
     &              -mu*py -mu2*py2 +reminn*dn
             GPhy(i,j,k,bi,bj)=
     &              +mu*py -mort*pym -graz*zo
             GPhy2(i,j,k,bi,bj)=
     &              +mu2*py2 -mort2*py2m -graz2*zo
             GZoo(i,j,k,bi,bj)=
     &              +gampn*graz*zo +gampn2*graz2*zo
     &              -mortz*zom
             GDON(i,j,k,bi,bj)=
     &              +donfracmn1*mort*pym
     &              +donfracmn2*mort2*py2m
     &              +donfracmn*mortz*zom
     &              +donfracgn*
     &               ( (1.d0-gampn)*graz*zo 
     &                +(1.d0-gampn2)*graz2*zo )
     &              -reminn*dn
c
             GSil(i,j,k,bi,bj)=
     &              -Rsip2*mu2*py2 
c
             GFeT(i,j,k,bi,bj)=
     &              -Rfep*mu*py -Rfep2*mu2*py2 
     &              +reminf*df -scav*freefu
             if (k.eq.1)  GFeT(i,j,k,bi,bj)=
     &              GFeT(i,j,k,bi,bj) 
     &              +alpfe*inputFe(i,j,bi,bj)/drF(1)
             GZFe(i,j,k,bi,bj)= 
     &              +Rfep*gampn*graz*zo + Rfep2*gampn2*graz2*zo
     &              -mortz*zfm
             GDOF(i,j,k,bi,bj)=
     &              +Rfep*( donfracmf1*mort*pym
     &                     +donfracgf*(1.d0-gampn)*graz*zo )
     &              +Rfep2*( donfracmf2*mort2*py2m
     &                      +donfracgf*(1.d0-gampn2)*graz2*zo )
     &              +donfracmf*mortz*zfm
     &              -reminf*df
c
            GDIC(i,j,k,bi,bj)=
     &              -Rcp*(1.d0+rainratio)*mu*py -Rcp2*mu2*py2
     &              +reminc*dc 
            if (k.eq.1)  GDIC(i,j,k,bi,bj)=
     &              GDIC(i,j,k,bi,bj)
     &              +SURC(i,j,bi,bj)
             GZoC(i,j,k,bi,bj)=
     &              +Rcp*gampn*graz*zo + Rcp2*gampn2*graz2*zo
     &              -mortz*zcm
             GDOC(i,j,k,bi,bj)=
     &              +Rcp*( donfracmc1*mort*pym
     &                     +donfracgc*(1.d0-gampn)*graz*zo )
     &              +Rcp2*( donfracmc2*mort2*py2m
     &                      +donfracgc*(1.d0-gampn2)*graz2*zo )
     &              +donfracmc*mortz*zcm
     &              -reminc*dc
             GPIC(i,j,k,bi,bj)=Rcp*rainratio*mu*py
             GOxy(i,j,k,bi,bj)=Rop*(mu*py +mu2*py2
     &               -reminn*dn - reminn*pn)
             if (k.eq.1)  GOxy(i,j,k,bi,bj)=
     &              GOxy(i,j,k,bi,bj)
     &              +SURO(i,j,bi,bj) 
c
c particulate matter for each layer
             GPON(i,j,k,bi,bj)=
     &            +(1.D0 -donfracmn1)*mort*pym
     &            +(1.D0 -donfracmn2)*mort2*py2m
     &            +(1.D0 -donfracmn)*mortz*zom
     &            +(1.D0 -donfracgn)*
     &              ( (1.d0 -gampn)*graz*zo 
     &               +(1.d0 -gampn2)*graz2*zo)
             GPOS(i,j,k,bi,bj)=
     &            +Rsip2*
     &             ( (1.D0)*(mort2*py2m)
     &              +(1.D0)*(graz2*zo) )
             GPOF(i,j,k,bi,bj)=
     &            (1.D0 -donfracmf1)*Rfep*mort*pym
     &           +(1.D0 -donfracmf2)*Rfep2*mort2*py2m
     &           +(1.D0 -donfracmf)*mortz*zfm
     &           +(1.D0 -donfracgf)*
     &              ( Rfep*(1.d0-gampn)*graz*zo
     &               +Rfep2*(1.d0-gampn2)*graz2*zo )
             GPOC(i,j,k,bi,bj)=
     &            (1.D0 -donfracmc1)*Rcp*mort*pym
     &           +(1.D0 -donfracmc2)*Rcp2*mort2*py2m
     &           +(1.D0 -donfracmc)*mortz*zcm
     &           +(1.D0 -donfracgc)*
     &              ( Rcp*(1.d0-gampn)*graz*zo
     &               +Rcp2*(1.d0-gampn2)*graz2*zo )

c for implicit sinking
c pom out of bottom is instantly remineralized
             ktmp=min(nR,k+1)
             if (hFacC(i,j,ktmp,bi,bj).eq.0.d0.or.k.eq.Nr) then
               GPON(i,j,k,bi,bj)=GPON(i,j,k,bi,bj)
     &            +wn_sink*(pnup)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOS(i,j,k,bi,bj)=GPOS(i,j,k,bi,bj)
     &            +ws_sink*(psup)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOF(i,j,k,bi,bj)=GPOF(i,j,k,bi,bj)
     &            +wf_sink*(pfup)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOC(i,j,k,bi,bj)=GPOC(i,j,k,bi,bj)
     &            +wc_sink*(pcup)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPIC(i,j,k,bi,bj)=GPIC(i,j,k,bi,bj)
     &            +wpic_sink*(pccup)/(drf(k)*hFacC(i,j,k,bi,bj))
             else 
               GPON(i,j,k,bi,bj)=GPON(i,j,k,bi,bj)
     &            +wn_sink*(pnup-pn)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOS(i,j,k,bi,bj)=GPOS(i,j,k,bi,bj)
     &            +ws_sink*(psup-ps)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOF(i,j,k,bi,bj)=GPOF(i,j,k,bi,bj)
     &            +wf_sink*(pfup-pf)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPOC(i,j,k,bi,bj)=GPOC(i,j,k,bi,bj)
     &            +wc_sink*(pcup-pc)/(drf(k)*hFacC(i,j,k,bi,bj))
               GPIC(i,j,k,bi,bj)=GPIC(i,j,k,bi,bj)
     &            +wpic_sink*(pccup-pcc)/(drf(k)*hFacC(i,j,k,bi,bj))
             endif
c remineralization of pom
             GPON(i,j,k,bi,bj)=GPON(i,j,k,bi,bj) -reminn*pn
             GPOS(i,j,k,bi,bj)=GPOS(i,j,k,bi,bj) -remins*ps
             GPOF(i,j,k,bi,bj)=GPOF(i,j,k,bi,bj) -reminf*pf
             GPOC(i,j,k,bi,bj)=GPOC(i,j,k,bi,bj) -reminc*pc
             GPIC(i,j,k,bi,bj)=GPIC(i,j,k,bi,bj) -dissc*pcc
c
             GNUT(i,j,k,bi,bj)=GNUT(i,j,k,bi,bj) +reminn*pn
             GSIL(i,j,k,bi,bj)=GSIL(i,j,k,bi,bj) +remins*ps
             GFeT(i,j,k,bi,bj)=GFeT(i,j,k,bi,bj) +reminf*pf
             GDIC(i,j,k,bi,bj)=GDIC(i,j,k,bi,bj) +reminf*pc
     &                                           +dissc*pcc
c
           GALK(i,j,k,bi,bj)=-Rnp*GNut(i,j,k,bi,bj)
     &                        -2.d0*GPIC(i,j,k,bi,bj) 
           if (k.eq.1)  GALK(i,j,k,bi,bj)=
     &              GALK(i,j,k,bi,bj)
     &              +SURA(i,j,bi,bj)
#ifdef ALLOW_TIMEAVE
c save averages
             Phygrow1ave(i,j,k,bi,bj)=Phygrow1ave(i,j,k,bi,bj)+
     &                             mu*py*dTtracerLev(k)
     &                       /float(nsubtime)
             Phygrow2ave(i,j,k,bi,bj)=Phygrow2ave(i,j,k,bi,bj)+
     &                             mu2*py2*dTtracerLev(k)
     &                       /float(nsubtime)
             Zoograzave(i,j,k,bi,bj)=Zoograzave(i,j,k,bi,bj)+
     &                      (gampn*graz*zo +gampn2*graz2*zo)*
     &                       dTtracerLev(k)/float(nsubtime)
             Parave(i,j,k,bi,bj)=Parave(i,j,k,bi,bj)+
     &                           PAR(i,j,k,bi,bj)*
     &                           dTtracerLev(k)/float(nsubtime)
             Chlave(i,j,k,bi,bj)=Chlave(i,j,k,bi,bj)+
     &                           CHL(i,j,k)
     &                          * dTtracerLev(k)/float(nsubtime)
             if (k.eq.1) then
               FluxCO2ave(i,j,bi,bj)= FluxCO2ave(i,j,bi,bj)+
     &               FluxCO2(i,j,bi,bj)*dTtracerLev(k)/float(nsubtime)
               FluxO2ave(i,j,bi,bj)= FluxO2ave(i,j,bi,bj)+
     &               FluxO2(i,j,bi,bj)*dTtracerLev(k)/float(nsubtime)
               pHave(i,j,bi,bj)=pHave(i,j,bi,bj)+
     &               pH(i,j,bi,bj)*dTtracerLev(k)/float(nsubtime)
             endif
#endif
          endif  
c end if hFac>0
         enddo
c end layer loop
c
c step forward in time
        do  k=1,Nr
         Nut(i,j,k,bi,bj) = Nut(i,j,k,bi,bj) +
     &                      GNut(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Phy(i,j,k,bi,bj) = Phy(i,j,k,bi,bj)+
     &                       GPhy(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Phy2(i,j,k,bi,bj) = Phy2(i,j,k,bi,bj)+
     &                       GPhy2(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Zoo(i,j,k,bi,bj) = Zoo(i,j,k,bi,bj) +
     &                      GZoo(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         DON(i,j,k,bi,bj) = DON(i,j,k,bi,bj) +
     &                      GDON(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Sil(i,j,k,bi,bj) = Sil(i,j,k,bi,bj) +
     &                      GSil(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         FeT(i,j,k,bi,bj) = FeT(i,j,k,bi,bj) +
     &                      GFeT(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
cQQQ - add 31/08/03
c        FeT(i,j,k,bi,bj) = min(FeT(i,j,k,bi,bj),ligand_tot)
cQQQ - end add 
         Zfe(i,j,k,bi,bj) = Zfe(i,j,k,bi,bj)+
     &                      GZfe(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         DOF(i,j,k,bi,bj) = DOF(i,j,k,bi,bj) +
     &                      GDOF(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         DIC(i,j,k,bi,bj) = DIC(i,j,k,bi,bj) +
     &                      GDIC(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         ZoC(i,j,k,bi,bj) = ZoC(i,j,k,bi,bj) +
     &                      GZoC(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         DOC(i,j,k,bi,bj) = DOC(i,j,k,bi,bj) +
     &                      GDOC(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Oxy(i,j,k,bi,bj) = Oxy(i,j,k,bi,bj) +
     &                      GOxy(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         Alk(i,j,k,bi,bj) = Alk(i,j,k,bi,bj) +
     &                      GAlk(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
c for explicit sinking particulate matter
         PON(i,j,k,bi,bj) = PON(i,j,k,bi,bj) +
     &                      GPON(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         POS(i,j,k,bi,bj) = POS(i,j,k,bi,bj) +
     &                      GPOS(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         POF(i,j,k,bi,bj) = POF(i,j,k,bi,bj) +
     &                      GPOF(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         POC(i,j,k,bi,bj) = POC(i,j,k,bi,bj) +
     &                      GPOC(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
         PIC(i,j,k,bi,bj) = PIC(i,j,k,bi,bj) +
     &                      GPIC(i,j,k,bi,bj)*dTtracerLev(k)
     &                       /float(nsubtime)
        enddo
       ENDDO
       ENDDO

c find free iron
         call fe_chem(bi,bj,iMin,iMax,jMin,jMax, FeT, freefe,
     &                myIter, mythid)

c
#ifdef ALLOW_TIMEAVE
c save averages
       do k=1,nR
         npzd_timeave(k,bi,bj)=npzd_timeave(k,bi,bj)
     &                         +dTtracerLev(k)
     &                       /float(nsubtime)
       enddo
#endif
c
c -----------------------------------------------------
       ENDDO
c -----------------------------------------------------
c end of bio-chemical time loop
c 
        RETURN
        END
#endif  /*NPZDCAR*/
#endif  /*ALLOW_PTRACERS*/

C============================================================================
