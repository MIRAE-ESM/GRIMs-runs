*-----------------------------------------------
* set parameters .....
*
*                                 experiments
  expn=2
  exp.1=test
  exp.2=test  
  nexp.1=exp.1
  nexp.2=exp.2
*                                 make directory for saving plots
  gdir='_gt'
 '!mkdir -p 'gdir''
*----------------------------------------------------------------------
* open ctl files
  n = 1
  nobs = 0
  while (n <= expn)
   fname = '/disk8/kyosun/SCM/skh/20100318/run/arm97_test/subA/pa.ctl'
  'open 'fname
   say fname
   n = n + 1
   nobs = nobs + 1
  endwhile
*
  tim1='01z20dec1992'
  tim2='00z26dec1992'
*----------------------------------------------------------------------
*
 'set display color white'
 'run bw_wv.gs' 
 'clear'
*
 'set x 1'
 'set y 1'
*
 'set z 1 40'
  n = 1
  while (n <= expn)
  'define t'n' = ave(tmp.'n',time='tim1',time='tim2')'
  'define r'n' = ave(rh.'n',time='tim1',time='tim2')'
   n = n + 1
  endwhile
*
*----------------------------------------------------------------------
 'set vpage 0.0 11.0 0.0 8.5'
 'clear'
 'set string 6 r 3'
 'set strsiz 0.10'
 'draw string 10.0 8.3 TOGA_1220_case NML/Yonsei Univ'
 'set string 1 l 3'
 'set strsiz 0.15'
 'draw string 1.0 8.3 difference from 'nexp.1
 'enable print 'gdir'/trh-prof.plt'
*
 'set time 'tim1
  x1 = 1.0
  y1 = 1.0
  x2 = x1 + 4.3
  y2 = y1 + 5.0
 'set parea 'x1' 'x2' 'y1' 'y2''
 'set xlopts 1 2 0.13'
 'set ylopts 1 2 0.13'
 'set clopts 1 2 0.13'
 'set grads off'
 'set string 1 l 3 0'
 'set strsiz 0.15'
 'draw string 'x1+0.1' 'y2+0.2' (c) Temperature difference (K)'
  limit ='-2 2 1'
 'set xlint 1'
*
  fn = 2
  fnum = expn
  while (fn <= fnum)
    if (fn=2); fp='t2-t1'; cap=nexp.2; endif;
    if (fn=3); fp='t3-t1'; cap=nexp.3; endif;
    if (fn=4); fp='t4-t1'; cap=nexp.4; endif;
    if (fn=5); fp='t5-t1'; cap=nexp.5; endif;
    fp=vrtplot(fp,cap,x1,y1,x2,y2,fn,limit)
    fn = fn + 1
  endwhile
 'set string 1 c 3 90'
 'set strsiz 0.15'
  yy1 = (y1+y2)*0.5
 'draw string 'x1-0.60' 'yy1' Pressure (hPa)'
 'set vpage off'
*
  x1 = 6.3
  y1 = 1.0
  x2 = x1 + 4.3
  y2 = y1 + 5.0
 'set parea 'x1' 'x2' 'y1' 'y2''
 'set xlopts 1 2 0.13'
 'set ylopts 1 2 0.13'
 'set clopts 1 2 0.13'
 'set grads off'
 'set string 1 l 3 0'
 'set strsiz 0.15'
 'draw string 'x1+0.1' 'y2+0.2' (d) RH difference (%)'
  limit ='-10 10 2'
 'set xlint 2 '
*
  fn = 2
  fnum = expn
  while (fn <= fnum)
    if (fn=2); fp='r2-r1'; cap=nexp.2; endif;
    if (fn=3); fp='r3-r1'; cap=nexp.3; endif;
    if (fn=4); fp='r4-r1'; cap=nexp.4; endif;
    if (fn=5); fp='r5-r1'; cap=nexp.5; endif;
    fp=vrtplot(fp,cap,x1,y1,x2,y2,fn,limit)
    fn = fn + 1
  endwhile
 'set string 1 c 3 90'
 'set strsiz 0.15'
  yy1 = (y1+y2)*0.5
 'draw string 'x1-0.60' 'yy1' Pressure (hPa)'
 'set vpage off'
*
 'print'
 'disable print'
*
*----------------------------------------------------------------------
  function vrtplot(fp,cap,x1,y1,x2,y2,fn,limit)
*
  if (fn=1); clno=55; csno=1; cmno=0; cthk=7; endif;
  if (fn=2); clno=1;  csno=1; cmno=2; cthk=5; endif;
  if (fn=3); clno=1;  csno=1; cmno=1; cthk=5; endif;
  if (fn=4); clno=1;  csno=1; cmno=5; cthk=5; endif;
  if (fn=5); clno=1;  csno=1; cmno=0; cthk=7; endif;
  xx1 = x2 - 1.5
  yy1 = y1 + 1.5 - fn*0.3
*
 'set grads off'
 'set axlim 'limit
 'set gxout line'
 'set ccolor 'clno
 'set cstyle 'csno
 'set cmark 'cmno
 'set cthick 'cthk
 'd 'fp
 'run line_label.gs 'xx1' 'yy1' 'cap' 'clno' 'csno' 'cthk' 'cmno' 0.13'
*
  return
