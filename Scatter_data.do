*** Program to create circle dot points
*** Created by Chamara on 18 Oct 2017
	
	clear all
	set more off
*Female
	foreach num of numlist 1/16 {
		clear
		matrix fr = [1.623380396,1.814366324,2.005352253,2.196338182,2.387324111,2.57831004,2.769295969,3.08760585,3.405915732,3.724225613,4.042535495,4.360845376,4.679155258,4.997465139,5.315775021,5.634084902]
		matrix fd = [122,137,151,166,180,194,209,233,257,281,305,329,353,377,401,425]
		local obsnum=fd[1,`num']
		set obs `obsnum'
		gen i=_n
		gen ang=360/`obsnum'
		replace ang=0 in 1
		gen cumang=sum(ang)
		
		local cir_r=fr[1,`num']
		
		gen y=`cir_r'*sin(_pi*cumang/180) 
		gen x=`cir_r'*cos(_pi*cumang/180) 
		save "temp/f`num'",replace	
	}
		

	clear
	foreach num of numlist 1/16 {
		append using "temp/f`num'"
	}

*Male
	foreach num of numlist 1/16 {	
		clear
		matrix mr = [1.687042372,1.878028301,2.06901423,2.260000159,2.450986087,2.641972016,2.832957945,3.151267827,3.469577708,3.78788759,4.106197471,4.424507353,4.742817234,5.061127116,5.379436997,5.697746879]
		matrix md = [127,142,156,170,185,199,214,238,262,286,310,334,358,382,406,430]
		local obsnum=md[1,`num']
		set obs `obsnum'
		gen i=_n
		gen ang=360/`obsnum'
		replace ang=0 in 1
		gen cumang=sum(ang)
		
		local cir_r=mr[1,`num']
		
		gen y=`cir_r'*sin(_pi*cumang/180) 
		gen x=`cir_r'*cos(_pi*cumang/180) 
		save "temp/m`num'",replace	
	}
	

	clear
	gen cat=""
	foreach num of numlist 1/16 {
		append using "temp/f`num'"
		replace cat="f`num'" if cat==""
		append using "temp/m`num'"
		replace cat="m`num'" if cat==""
	}
	drop ang cumang
	destring cat,ignore("mf") gen(numv)
 
	scatter y x ,msize(*.2) mcolor(red*0.5) aspectratio(1)
	rename numv agecat
	replace cat=substr(cat,1,1)
	compress cat
	rename cat sex
	rename i id
	order id
	scatter y x if id<100 ,msize(*.2) mcolor(red*0.5) aspectratio(1)
	save "Temp/circle.dta",replace
