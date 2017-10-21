clear		
set obs 100

	local i=1 // file number and r
	local j=0.5
	clear
	foreach num of numlist 12 12 12 12 12 12 12 12 16 24 24 48 52 108 192 248 308 308 308 416 {
		dis `num'
		set obs `num'
		gen i=_n
		gen ang=360/`num'
		replace ang=0 in 1
		gen cumang=sum(ang)

		gen yf`i'=(`j')*`i'*sin(_pi*cumang/180) 
		gen xf`i'=(`j')*`i'*cos(_pi*cumang/180)
		
		gen ym`i'=(`j'+0.7)*`i'*sin(_pi*cumang/180) 
		gen xm`i'=(`j'+0.7)*`i'*cos(_pi*cumang/180)
		
		
		save "temp/f`i'",replace
		local i=`i'+1
		local j=`j'+1
		clear
		
	}

	clear
	foreach num of numlist 1/20 {
		append using temp/f`num'
	}
	
	save "Temp/dots.dta",replace
	use "Temp/dots.dta",clear
	keep x* y*
	drop ??1 ??2 ??3 ??5
* Rename variables
	local i=1
	foreach num of numlist 4 6/20 {
		rename xf`num' xf`i'
		rename xm`num' xm`i'
		rename yf`num' yf`i'
		rename ym`num' ym`i'		
		local i= `i'+1
	}
	save "Temp/dot.dta",replace
	foreach num of numlist 1/16 {
		use "Temp/dot.dta",clear
		keep xf`num' yf`num'
		drop if xf==.
		rename xf x
		rename yf y
		gen catname="xf`num'"
		save "Temp/f`num'.dta",replace
		
	}
	
	foreach num of numlist 1/16 {
		use "Temp/dot.dta",clear
		keep xm`num' ym`num'
		drop if xm==.
		rename xm x
		rename ym y
		gen catname="xm`num'"
		save "Temp/m`num'.dta",replace
		
	}
	
	clear
	foreach num of numlist 1/16 {
		append using "Temp/m`num'"
		append using "Temp/f`num'"
	}
	gen order=_n
	bys catname (order): gen id=_n
	
	scatter yf1 xf1,msymbol(none) || scatter ym1 xm1,msymbol(none) || ///
	scatter yf2 xf2,msymbol(none) || scatter ym2 xm2,msymbol(none) || ///
	scatter yf3 xf3,msymbol(none) || scatter ym3 xm3,msymbol(none) || ///
	scatter yf4 xf4, msize(vsmall)|| scatter ym4 xm4,msize(vsmall) || ///
	scatter yf5 xf5,msymbol(none) || scatter ym5 xm5,msymbol(none) || ///
	scatter yf6 xf6,msize(vsmall) || scatter ym6 xm6,msize(vsmall) || ///
	scatter yf7 xf7,msize(vsmall) || scatter ym7 xm7,msize(vsmall) || ///
	scatter yf8 xf8,msize(vsmall) || scatter ym8 xm8,msize(vsmall) || ///
	scatter yf9 xf9,msize(vsmall) || scatter ym9 xm9,msize(vsmall) || ///
	scatter yf10 xf10,msize(vsmall) || scatter ym10 xm10,msize(vsmall) || ///
	scatter yf11 xf11,msize(vsmall) || scatter ym11 xm11,msize(vsmall) || ///
	scatter yf12 xf12,msize(vsmall) || scatter ym12 xm12,msize(vsmall) || ///
	scatter yf13 xf13,msize(vsmall) || scatter ym13 xm13,msize(vsmall) || ///
	scatter yf14 xf14,msize(vsmall) || scatter ym14 xm14,msize(vsmall) || ///
	scatter yf15 xf15,msize(vsmall) || scatter ym15 xm15,msize(vsmall) || ///	
	scatter yf16 xf16,msize(vsmall) || scatter ym16 xm16,msize(vsmall) || ///
	scatter yf17 xf17,msize(vsmall) || scatter ym17 xm17,msize(vsmall) || ///
	scatter yf18 xf18,msize(vsmall) || scatter ym18 xm18,msize(vsmall) || ///
	scatter yf19 xf19,msize(vsmall) || scatter ym19 xm19,msize(vsmall) || ///	
	scatter yf20 xf20,msize(vsmall) || scatter ym20 xm20, msize(vsmall)aspectratio(1) legend(off) ///
	graphregion(fcolor(white)) legend(off) plotregion(margin(zero)) ///
	ylabel("",nogrid)xlabel("") yscale(off) xscale(off)
	
	
	
	scatter yf4 xf4, msize(vsmall)|| scatter ym4 xm4,msize(vsmall) || ///
	scatter yf6 xf6,msize(vsmall) || scatter ym6 xm6,msize(vsmall) || ///
	scatter yf7 xf7,msize(vsmall) || scatter ym7 xm7,msize(vsmall) || ///
	scatter yf8 xf8,msize(vsmall) || scatter ym8 xm8,msize(vsmall) || ///
	scatter yf9 xf9,msize(vsmall) || scatter ym9 xm9,msize(vsmall) || ///
	scatter yf10 xf10,msize(vsmall) || scatter ym10 xm10,msize(vsmall) || ///
	scatter yf11 xf11,msize(vsmall) || scatter ym11 xm11,msize(vsmall) || ///
	scatter yf12 xf12,msize(vsmall) || scatter ym12 xm12,msize(vsmall) || ///
	scatter yf13 xf13,msize(vsmall) || scatter ym13 xm13,msize(vsmall) || ///
	scatter yf14 xf14,msize(vsmall) || scatter ym14 xm14,msize(vsmall) || ///
	scatter yf15 xf15,msize(vsmall) || scatter ym15 xm15,msize(vsmall) || ///	
	scatter yf16 xf16,msize(vsmall) || scatter ym16 xm16,msize(vsmall) || ///
	scatter yf17 xf17,msize(vsmall) || scatter ym17 xm17,msize(vsmall) || ///
	scatter yf18 xf18,msize(vsmall) || scatter ym18 xm18,msize(vsmall) || ///
	scatter yf19 xf19,msize(vsmall) || scatter ym19 xm19,msize(vsmall) || ///	
	scatter yf20 xf20,msize(vsmall) || scatter ym20 xm20, msize(vsmall)aspectratio(1) legend(off) ///
	graphregion(fcolor(white)) legend(off) plotregion(margin(zero)) ///
	ylabel("",nogrid)xlabel("") yscale(off) xscale(off)
	
