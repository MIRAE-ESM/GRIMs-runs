      program map
      call opngks
c
      NAMELIST /rdomain/proj,truth,cotru,orient,delx,dely,cenlat,cenlon,
     &                   xleftgrd,botmgrd,igrd,jgrd
c
      READ(*,rdomain)
      write(6,rdomain)
c
      true= truth
      cotru= cotru
      glatc=cenlat
      glonc=cenlon
      rot=orient
      im=igrd+1
      jm=jgrd+1
      xleft=xleftgrd
c      jbotm=botmgrd
c      ileft=leftgrd
c      jbotm=botmgrd
c
      call pltgrd(proj,true,cotru,glatc,glonc,rot,delx,dely,im,jm,xleft,
     1        botmgrd)
c
      call clsgks
      stop
      end
        subroutine pltgrd(proj,true,cotr,glatc,glonc,rot,dx,dy,
     1                    im,jm,xleft,botmgrd)
      parameter (xyint = 10.)
c     parameter (xyint = 5.)
      dimension flat(im,jm),flon(im,jm)
      character ch*3
c
      hfpi = dasin(1.0d0)
      pi = 2.0 * hfpi
      twopi = 2.0 * pi
      rad = pi / 180.
c
      QTPI = HFPI * 0.5
      RAD = PI / 180.
      DELX = dx
      DELY = dy
C
C --------- SETUP REGIONAL LAT/LON AND MAP FACTOR -----
C
C IF PROJ=0  DO MERCATER PROJECTION
C IF PROJ=1  DO NORTH POLAR PROJECTION
C IF PROJ=-1 DO SOUTH POLAR PROJECTION
C
      NPROJ = PROJ
C
      IF( NPROJ.EQ.1 .OR. NPROJ.EQ.-1 ) THEN
C ++++++++++++++++++++++++++++++++++++++
C POLAR PROJECTION
C ++++++++++++++++++++++++++++++++++++++
      TRUTH  = true * RAD
      TRUTH  = NPROJ * TRUTH
      ORIENT  = rot * RAD
      DLAMDA0 = ORIENT + HFPI
      A2 =  6371200.0 * ( 1.0 + SIN(TRUTH) )
      RADLAT = glatc * RAD
      RADLON = glonc * RAD - DLAMDA0
      RADLAT = NPROJ * RADLAT
      RADLON = NPROJ * RADLON
      YYY = A2 * COS( RADLAT )/(1. + SIN( RADLAT ) )
      CENLAT = glatc
      IF( ABS(CENLAT) .EQ. 90. ) THEN YYY = 0.0
      Y00 = YYY * SIN( RADLON ) - ( botmgrd -1.) * DELY
      X00 = YYY * COS( RADLON ) - ( xleft -1.) * DELX
      PRINT *,' DELX X00 Y00 ',DELX,X00,Y00
C
C =========
C           LAT LOOP
      DO 100 J = 1,jm
      LATS = J
      YS = Y00 + (LATS-1)*DELY
C
      DO 100 I=1,im
      X = X00 + (I-1)*DELX
      IF( X .GT. 0. ) THEN
         FLONS = ATAN(YS/X)
      ELSE IF ( X .LT. 0. ) THEN
         FLONS = PI + ATAN(YS/X)
      ELSE
         FLONS = HFPI
         IF( YS .LT. 0. ) FLONS = FLONS * 3.0
      ENDIF
      FLONS = FLONS + DLAMDA0
      FLONS = AMOD(FLONS,TWOPI)
      FLONS = NPROJ * FLONS 
      IF(FLONS.LT.0. ) FLONS = TWOPI + FLONS
C
      RSOA2 = SQRT( X*X + YS*YS )/A2
      FLATS = HFPI - 2.0 * ATAN(RSOA2)
      FLAT(I,J) = NPROJ * FLATS
      FLON(I,J) = FLONS
C
 100  CONTINUE
C
      ELSE IF ( NPROJ.EQ.0 ) THEN
C
C ++++++++++++++++++++++++++++
C DO MERCATER
C ++++++++++++++++++++++++++++
      TRUTH  = true * RAD
      CENLAT = glatc * RAD
      CENLON = glonc * RAD 
      A2 =  6371200.0 * COS( TRUTH ) 
      X0 = 0.0
      Y0 = A2 * LOG( ABS( TAN( QTPI + 0.5 * CENLAT ) ) )
      X00 = - ( xleft - 1.0 ) * DELX
      Y00 = - ( botmgrd - 1.0 ) * DELY
      DLAMDA0 = 0.0
C
      DO 200 J = 1,jm
      LATS = J
      YS = Y00 + (LATS-1)*DELY + Y0
C
       DO 200 I=1,im
         X = X00 + (I-1)*DELX + X0
         FLONS = X / A2 + CENLON
         FLONS = AMOD(FLONS,TWOPI)
         IF(FLONS.LT.0. ) FLONS = TWOPI + FLONS
C
         FLATS = 2.0 *( ATAN( EXP( YS/A2 ) ) - QTPI )
         FLAT(I,J) = FLATS
         FLON(I,J) = FLONS
C
C
 200  CONTINUE
C
      ELSE IF ( NPROJ.EQ.2 .OR. NPROJ.EQ.-2 ) THEN
C ++++++++++++++++++++++++++++++++++++++
C LAMBERT CONFORMAL
C ++++++++++++++++++++++++++++++++++++++
      IS = 1
      IF( NPROJ.LT.0 ) IS = -1
      TRUTH  = true * RAD
      COTRU  = cotr * rad
      TRUTH  = IS * TRUTH
      COTRU  = IS * COTRU
      ORIENT  = rot * RAD
      DLAMDA0 = ORIENT
      IF( TRUTH.EQ.COTRU ) THEN
         CONE= COS (HFPI-TRUTH)
      ELSE
         CONE=(LOG(COS(TRUTH))-LOG(COS(COTRU)))/
     &        (LOG(TAN(QTPI-TRUTH/2))-LOG(TAN(QTPI-COTRU/2)))
      ENDIF
!
      A2 =  6371200.0/CONE*COS(TRUTH)/(TAN(QTPI-TRUTH/2))**CONE
      RADLAT = glatc * RAD
      RADLON = glonc * RAD - DLAMDA0
      RADLAT = IS * RADLAT
      RADLON = IS * RADLON
      YYY = A2 * (TAN(QTPI-RADLAT/2))**CONE
      CENLAT = glatc
      IF( ABS(CENLAT) .EQ. 90. ) YYY = 0.0
      Y00 = YYY * SIN( CONE * RADLON ) - ( BOTMGRD -1.) * DELY
      X00 = YYY * COS( CONE * RADLON ) - ( XLEFT -1.) * DELX
      print *,' delx x00 y00 ',delx,x00,y00,cenlat,a2,yyy,cone,orient
C
C =========
C           LAT LOOP
      print*,' im jm ',im,jm
      DO 300 J = 1,jm
      LATS = J
      YS = Y00 + (LATS-1)*DELY
C
      DO 300 I=1,im
      X = X00 + (I-1)*DELX
      FLONS = -ATAN(x/YS)/CONE
      FLONS = FLONS + DLAMDA0
      FLONS = AMOD(FLONS,TWOPI)
      FLONS = IS * FLONS 
      IF(FLONS.LT.0. ) FLONS = TWOPI + FLONS
C
      RSOA2 = SQRT( X*X + YS*YS )/A2
      RSOA2 = RSOA2 ** (1./CONE)
      FLATS = HFPI - 2.0 * ATAN(RSOA2)
      FLAT(I,J) = IS * FLATS
      FLON(I,J) = FLONS
      if(j.eq.1) then
        print*,' i ys x dlamda0 ',i,ys,x,dlamda0,rsoa2,
     1           flats*180./3.14,flons*180./3.14
      endif
C
 300  CONTINUE
C
      ENDIF
C
c
      flat00= flat(1,1) / rad
      flat0h= flat(11,11) / rad
      flat01= flat(1,jm) / rad
      flat10= flat(im,1) / rad
      flat11= flat(im,jm) / rad
      flatc= flat(im/2+1,jm/2+1) / rad
      flon00= flon(1,1) / rad
      flon0h= flon(11,11) / rad
      flon01= flon(1,jm) / rad
      flon10= flon(im,1) / rad
      flon11= flon(im,jm) / rad
      flonc= flon(im/2+1,jm/2+1) / rad
      print *,' flat00 flon00 ',flat00,flon00
      print *,' flat01 flon01 ',flat01,flon01
      print *,' flat10 flon10 ',flat10,flon10
      print *,' flat11 flon11 ',flat11,flon11
      print *,' flat_cen flon_cen ',flatc,flonc
      print *,'  true cotru rot  ',true,cotr,rot

      cntr = dlamda0/rad - 90.0
      if( cntr.lt.-180.0 ) cntr = cntr + 360.0
      call setusv('LW',900)
      if( nproj.eq.0 ) then
      call supmap(9,0.,0.,0.,flat00,flon00,flat11,flon11,2,
     1            10,1,0,ierr)
      else if (abs(nproj).eq.1) then
      call supmap(1,90.,cntr,0.,flat00,flon00,flat11,flon11,2,
     1            10,1,0,ierr)
      else if (abs(nproj).eq.2) then
      call supmap(3,true,rot,cotr,flat01,flon01,flat10,flon10,2,
     1            10,1,0,ierr)
      endif
      call getset(dl,dr,db,dt,ul,ur,ub,ut,isc)
      fim=im
      fjm=jm
      call    set(dl,dr,db,dt,1.,fim,1.,fjm,isc)
!     call    set( 0.,1.,0.,1.,0.1, 0.9,0.1,0.9,1)
      im1=im-1
      jm1=jm-1
      call perim(1,im1,1,jm1)
c
      if(test.eq.test ) then
      scalx=(fim-1.)/(dr-dl)
      scaly=(fjm-1.)/(dt-db)
      ux0=1-scalx*dl
      ux1=fim+scalx*(1.-dr)
      uy0=1.-scaly*db
      uy1=fjm+scaly*(1.-dt)
      call    set(0.,1.,0.,1.,ux0,ux1,uy0,uy1,1)
      y0=1.
      y1=fjm
      do i=xyint,im,xyint
      x=i
      call line(x,y0,x,y1)
      write(ch,121) i
121   format(i3)
      call wtstr(x,y0-3.,ch,1,0,0)
      enddo
      x0=1.
      x1=fim
      do j=xyint,jm,xyint
      y=j
      call line(x0,y,x1,y)
      write(ch,121) j
      call wtstr(x0-xyint,y,ch,1,0,0)
      enddo
      endif
      call frame
c
      return
      end
