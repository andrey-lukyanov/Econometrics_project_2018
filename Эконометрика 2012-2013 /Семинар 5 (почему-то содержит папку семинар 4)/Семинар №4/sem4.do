version 10.0
set more off
log using sem4.log, text replace

/*	****************************************************************	*/
/*     	File Name:	sem4.do					*/
/*     	Date:   	September 23, 2011						*/
/*      Author: 	Elena S. Vakulenko					*/
/*      Purpose:	Regression analysis,constraints, Chow test*/
/*      Input File:	mrw.dta							*/
/*      Output File:	sem4.log					*/	
/*	****************************************************************	*/


/*See Article*/ 
/*Mankiw G.N., David Romer, Weil D.N. A Contribution to the Empirics of Economic Growth // Quarterly Journal of Economics. 1992.  Vol. 107. No. 2. P. 407-437*/
		
		/*Generation of new variables*/

gen lngdp85=ln(gdp85)
gen lngdp60=ln(gdp60)
gen lngdpgrow=ln(gdpgrow)
gen lnngdelta=ln(popgrow/100+0.05)
gen lninv=ln(inv/100)
gen lnschool=ln(school)

		/*ESTIMATION OF THE  TEXTBOOK SOLOW MODEL*/

reg lngdp85 lnngdelta lninv if nonoil==1
reg lngdp85 lnngdelta lninv if intermed==1
reg lngdp85 lnngdelta lninv if oecd==1


		/*Test linear hypothesis*/

test lnngdelta + lninv = 0




		/*ESTIMATION OF THE AUGMENTED SOLOW MODEL WITH CONSTRAINTS*/

constraint 1 lnngdelta=-lninv
cnsreg lngdp85 lnngdelta lninv if nonoil==1, constraints(1)
cnsreg lngdp85 lnngdelta lninv if intermed==1, constraints(1)
cnsreg lngdp85 lnngdelta lninv if oecd==1, constraints(1)

		/*ESTIMATION OF THE AUGMENTED SOLOW MODEL WITH CONSTRAINTS (2)*/

gen lninv_lnngdelta=lninv-lnngdelta
reg lngdp85 lninv_lnngdelta if nonoil==1
reg lngdp85 lninv_lnngdelta if intermed==1
reg lngdp85 lninv_lnngdelta if oecd==1

		/*Chow test*/

reg lngdp85 lnngdelta lninv
scalar r_all=e(rss)
scalar n_all=e(N)

reg lngdp85 lnngdelta lninv if nonoil==1
scalar r_noil=e(rss)
scalar n_noil=e(N)

reg lngdp85 lnngdelta lninv if nonoil==0
scalar r_oil=e(rss)
scalar n_oil=e(N)


scalar ddf=n_noil+n_oil-3*2
scalar r_tot=r_noil+r_oil
scalar fh1=((r_all-r_tot)/(3))/(r_tot/ddf)
scalar pval1=Ftail(3,ddf,fh1)
scalar list ddf fh1 pval1


		/*ESTIMATION OF THE AUGMENTED SOLOW MODEL*/

reg lngdp85 lnngdelta lninv lnschool if nonoil==1
reg lngdp85 lnngdelta lninv lnschool if intermed==1
reg lngdp85 lnngdelta lninv lnschool if oecd==1

		/*Test for unconditional convergence*/

gen lngdp85_lngdp60=lngdp85-lngdp60
reg lngdp85_lngdp60 lngdp60 if nonoil==1
reg lngdp85_lngdp60 lngdp60 if intermed==1
reg lngdp85_lngdp60 lngdp60 if oecd==1

scatter lngdp85_lngdp60 lngdp60

log close
*clear
*exit
