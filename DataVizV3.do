*** Program for data visuzlization
*** Created by Chamara on 07 Oct, 2017
*** Input:
*** Output:

clear all
set more off
version 14

cd "C:\Users\kcanu\OneDrive - University of Calgary\GEOG647\Project"
*** Create data file

	use "E:\Micro Data\Data\Canadian_Community_Health_Surveys2014\cchs14a_stata\cchs14a.dta",clear

*Rename variables
	lookfor heart
	tab CCC_121,m
	rename CCC_121 hdisease
	rename dhhgage age
	rename DHH_SEX sex
	rename geodpmf hregion
	rename geogprv prov
	rename WTS_M pwt
	rename incdrca income
	rename CCC_101 diab
	rename CCC_131 cancer	

*Keep selected variables for the analysis
	keep hdisease age sex hregion prov pwt  diab cancer income
	gen id=_n

	order id
	l in 1/10
	codebook diab hdisease cance
	replace diab=2 if diab==.
	replace hdisease=2 if hdisease==.
	replace cancer=2 if cancer==.
	egen dgroup1=group(diab hdisease cancer),label
	numlabel dgroup1,add
	tab dgroup1
	
	tab income
	recode income 1/2=1 3/4=2 5/6=3 7/8=4 9/10=5,gen(incq)
	label var incq "Income quintile"
	label define quintile 1 "Poorest" 2 "2nd poorest" 3 "Middle" 4 "2nd Richest" 5 "Richest"
	label val incq quintile
	
*Create variable for merge
	rename sex sex2
	gen sex="m" if sex2==1
	replace sex="f" if sex2==2
	tab sex
	gen agecat=age
	drop id
	
	
*Save selected data file
	save "Temp/cchs2014.dta",replace
	drop if dgroup1==8
	
*Save filtered data
	save "filtered_CCHS.dta",replace
	use "filtered_CCHS.dta",clear

* Select a province
	levelsof prov
	foreach num of numlist `r(levels)' {
		use "filtered_CCHS.dta",clear
		keep if prov==`num'
		gsort agecat sex dgroup incq
		bys agecat sex (dgroup incq): gen id=_n
		merge  1:1 agecat sex id using "Temp/circle.dta"
		save "Temp/prov`num'.dta",replace
	}
		
	
	
	
	
foreach num of numlist 10 11 12 13 24 35 46 47 48 59 60 {	
	
	use "Temp/prov`num'.dta",clear
	local rgb1 ="127 201 127"
	local rgb2 ="190 174 212"
	local rgb3 ="253 192 134"
	local rgb4 ="255 255 153"
	local rgb5 ="56 108 176"
	local rgb6 ="240 2 127"
	local rgb7 ="191 91 23"
	local rgb8 ="102 102 102"
 
	local 	rgb1	=	"228 26 28"
	local 	rgb2	=	"55 126 184"
	local 	rgb3	=	"77 175 74"
	local 	rgb4	=	"152 78 163"
	local 	rgb5	=	"255 127 0"
	local 	rgb6	=	"255 255 51"
	local 	rgb7	=	"166 86 40"
	local 	rgb8	=	"247 129 191"
	 
	scatter y x if  _merge>=2, msize(*.3) msymbol(none) || ///
	scatter y x if incq==1, msize(*.3) mcolor(black*0.2) || ///
	scatter y x if incq==2, msize(*.4) mcolor(black*0.3) || ///
	scatter y x if incq==3, msize(*.5) mcolor(black*0.4) || /// 
	scatter y x if incq==4, msize(*.6) mcolor(black*0.5) || ///
	scatter y x if incq==5, msize(*.7) mcolor(black*0.6) || /// 	
	scatter y x if dgroup==1, msize(*.2) mcolor("`rgb1'") || ///
	scatter y x if dgroup==2, msize(*.2) mcolor("`rgb2'") || ///
	scatter y x if dgroup==3, msize(*.2) mcolor("`rgb3'") || /// 
	scatter y x if dgroup==4, msize(*.2) mcolor("`rgb4'") || ///
	scatter y x if dgroup==5, msize(*.2) mcolor("`rgb5'") || ///
	scatter y x if dgroup==6, msize(*.2) mcolor("`rgb6'") || ///
	scatter y x if dgroup==7, msize(*.2) mcolor("`rgb7'") || ///
	scatter y x if dgroup==8, msize(*.2) mcolor("`rgb8'")  aspectratio(1) legend(off) plotregion(fcolor(white)) ///
	yscale(off) ylabel(,nogrid) xscale(off) graphregion(margin(zero))  ///
	plotregion(fcolor(white)) xsize(4.5) ysize(4.5)
	 
	graph export gaph`num'.png, width(800) height(800)
}

	
	/*
	scatter y x if incq==1, msize(*.2) mcolor(black*0.1) || ///
	scatter y x if incq==2, msize(*.3) mcolor(black*0.2) || ///
	scatter y x if incq==3, msize(*.4) mcolor(black*0.3) || /// 
	scatter y x if incq==4, msize(*.5) mcolor(black*0.4) || ///
	scatter y x if incq==5, msize(*.6) mcolor(black*0.5)  aspectratio(1) legend(off)

	*/

*Create bar graph
	use "filtered_CCHS.dta",clear
	drop if incq==.
	tab dgroup1,gen(d)
	collapse (sum) d? [pw=pwt],by(prov incq)
	egen rowt=rowtotal(d?)
	bys prov: egen totdis=sum(rowt)
	foreach var of varlist d? {
		replace `var'=`var'/totdis*100
	
	}
	label define quintile 2 "" 4 "",modify
	save "Temp/temp.dta",replace
	foreach num of numlist 10 11 12 13 24 35 46 47 48 59 60 {
		local 	rgb1	=	"228 26 28"
		local 	rgb2	=	"55 126 184"
		local 	rgb3	=	"77 175 74"
		local 	rgb4	=	"152 78 163"
		local 	rgb5	=	"255 127 0"
		local 	rgb6	=	"255 255 51"
		local 	rgb7	=	"166 86 40"
		local 	rgb8	=	"247 129 191"
		capture graph bar (asis) d? if prov==`num', over(incq, gap(0))  yscale(range(0 33.2)) outergap(-20) stack ///
		bar(1,color("`rgb1'")) bar(2,color("`rgb2'")) bar(3,color("`rgb3'")) bar(4,color("`rgb4'")) bar(5,color("`rgb5'")) bar(6,color("`rgb6'")) bar(7,color("`rgb7'")) ///
		ylabel(,nogrid) graphregion(margin(zero)) graphregion(color(white)) ///
		plotregion(fcolor(white)) xsize(4.5) ysize(4.5) legend(off) 
		capture graph export "e:/bg`num'.png",replace 
	}
