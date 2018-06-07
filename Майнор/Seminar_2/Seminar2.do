/*Seminar 2*/
/*Use data 1.3.xls. Import them to Stata*/

ren A n
ren B date

/*Generate variables*/
gen y_delta=DELTA-RKFREE

drop if n==.

gen x=MARKET-RKFREE

/*Regression*/
reg y_delta x

/*Loop*/

for var BOISE CITCRP CONED ///
CONTIL DATGEN DEC GENMIL ///
GERBER IBM MOTOR PANAM PSNH ///
TANDY TEXACO WEYER: gen y_X=X-RKFREE

/*Another approach*/

/* foreach i of var  BOISE CITCRP CONED ///
CONTIL DATGEN DEC GENMIL ///
GERBER IBM MOTOR PANAM PSNH ///
TANDY TEXACO WEYER {
gen y_`i'=`i'-RKFREE 
}
*/


foreach i of var  BOISE CITCRP CONED ///
CONTIL DATGEN DEC GENMIL ///
GERBER IBM MOTOR PANAM PSNH ///
TANDY TEXACO WEYER {
reg y_`i' x
}

/*Testing hypothesis*/

test x=1


