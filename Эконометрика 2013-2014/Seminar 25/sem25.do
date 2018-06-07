set more off

log using sem25.log, text replace

/*	*****************************************************/
/*     	File Name:	sem25.do					        */
/*     	Date:   	April 1, 2014				    */
/*      Author: 	Elena S. Vakulenko					*/
/*      Purpose:	Nonparametric            */
/*      Input File:	schooling.dta							*/
/*      Output File:	sem25.log					    */	
/*	*****************************************************/

kdensity lwage76

kdensity lwage76, kernel(gaussian) normal

scatter lwage76 exp76

scatter lwage76 age76

reg lwage76 exp76 

reg lwage76 age76

lpoly  lwage76 exp76

lpoly  lwage76 exp76, noscatter

lpoly  lwage76 exp76, noscatter ci

*lpoly lwage76 exp76,  kernel(...)  bwidth(...) degree(...) 

lpoly lwage76 age76, noscatter generate (x y)

lowess  lwage76 age76,  generate (y1) 

twoway dot lwage age76 || dot y x || dot y1 age76

twoway dot y x || dot y1 age76

*lowess  lwage76 age76, bwidth(...) 

reg lwage76 ed76 exp76  exp762 black smsa76 south76

net search plreg

plreg lwage76 ed76 black smsa76 south76, nlf(exp76) wh

plreg lwage76 ed76 black smsa76 south76, nlf(exp76) wh gen(f_hat) order(2)

net search semipar 

semipar lwage76 ed76 black smsa76 south76, nonpar(exp76)  

semipar lwage76 ed76 black smsa76 south76, nonpar(exp76) ci

semipar lwage76 ed76 black smsa76 south76, nonpar(exp76) test(2) 
