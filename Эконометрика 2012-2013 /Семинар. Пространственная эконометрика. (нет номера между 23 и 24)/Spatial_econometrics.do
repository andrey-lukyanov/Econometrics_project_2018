log using sem_spa_ec.log, text replace

/*	*****************************************************/
/*     	File Name:	Spatial_econometrics.do		        */
/*     	Date:   	February 12, 2013				    */
/*     Lecturer: 	Elena S. Vakulenko					*/
/*      Purpose:	Spatial Econometrics models         */
/*      Input File:	EU27.dta							*/
/*      Output File:	sem_spa_ec.log			        */	
/*	*****************************************************/

*Author: A. Niebuhr "Spatial Econometrics", Kiel University. 

*cd "D:\"

net search spatwmat
net search spatdiag
net search spatlsa
net search spatgsa
net search spatreg
net search spatcorr

* Generate average annual growth rates for GDP p.c. and the natural log of GDP p.c. in 1995 
 
gen y9504 = (1/9)*ln(y04/y95)

gen lny95 = ln(y95)

* Investigate differences in growth and y95 between new and old EU member states

sort  nms_dummy
by  nms_dummy: summ y9504 lny95 


* Important: sort again by region_id otherwise order of regions in data set and spatial weights
* matrix will not coincide

sort region_id 

* Estimate absolute convergence model taking into account possible heterogeneity (robust se)

reg y9504 lny95

reg y9504 lny95, ro


* Is the process of convergence primarily driven by a catching-up process of the new member states?

reg y9504 lny95 nms_dummy, ro

sort nms_dummy

by nms_dummy: reg y9504 lny95, ro

sort region_id

* Test for spatial autocorrelation of the dependent and independent variable 
* of the absolute convergence model

spatwmat using inverse_travel_time_EU27.dta, name(W1) standardize

set matsize 5000

spatgsa y9504 lny95, w(W1) moran 

*Investigate spatial autocorrelation of residuals in absolute convergence model

reg y9504 lny95
spatdiag, weights(W1)

reg y9504 lny95, ro
spatdiag, weights(W1)

quietly: reg y9504 lny95
predict e1, residuals
spatgsa e1, w(W1) moran 

spatlsa e1, weights(W1) moran graph(moran) symbol(id) id(region_id) savegraph(moran_e1.wmf, replace)
summ e1
summ e1 if at==1
summ e1 if be==1
summ e1 if cz==1
summ e1 if dk==1
***

* Absolute convergence - spatial regression models (ML)
* Generate eigenvalues

spatwmat using inverse_travel_time_EU27.dta, name(W1) eigenval(E1) standardize
spatreg y9504 lny95, weights(W1) eigenval(E1) model(lag)
spatreg y9504 lny95, weights(W1) eigenval(E1) model(error)


* Estimate conditional convergence model (including country dummies, Germany used as reference)

reg y9504 lny95 at be cz dk ee es fi fr gr hu ie it lt lu nl pl pt se si sk uk, ro

* Investigate spatial autocorrelation of residuals in conditional convergence model
reg y9504 lny95 at be cz dk ee es fi fr gr hu ie it lt lu nl pl pt se si sk uk, ro

spatdiag, weights(W1)

quietly: reg y9504 lny95 at be cz dk ee es fi fr gr hu ie it lt lu nl pl pt se si sk uk, ro

predict e2, residuals


spatlsa e2, weights(W1) moran graph(moran) symbol(id) id(region_id) savegraph(moran_e2.wmf, replace)

* Conditional convergence - spatial regression models (ML)

spatreg y9504 lny95 at be cz dk ee es fi fr gr hu ie it lt lu nl pl pt se si sk uk, weights(W1) eigenval(E1) model(lag)

spatreg y9504 lny95 at be cz dk ee es fi fr gr hu ie it lt lu nl pl pt se si sk uk, weights(W1) eigenval(E1) model(error)

log close

*exit
