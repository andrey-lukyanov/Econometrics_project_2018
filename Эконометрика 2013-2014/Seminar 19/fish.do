log using sem19.log, text replace

/*	*****************************************************/
/*     	File Name:	fish.do					        */
/*     	Date:   	February 10, 2014				    */
/*      Author: 	Elena S. Vakulenko					*/
/*      Purpose:	Logit,Poisson models           */
/*      Input File:	fish.dta							*/
/*      Output File:	sem19.log					    */	
/*	*****************************************************/



gen fish=0
replace fish=1 if count>0
sum
hist count

*Lodit model
logit fish  camper child persons
estat class
lroc
lsens

mfx

net search margeff
margeff, dummies(camper)
margins, dydx(child camper persons) at(child=1 camper=1 persons=3)

*Poisson model
poisson  count child camper persons
estat gof
margins, dydx(child camper persons)

margins, dydx(child camper persons) at(child=1 camper=1 persons=3)

predict count_p, n 
