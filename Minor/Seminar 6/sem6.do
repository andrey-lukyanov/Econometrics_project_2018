*set mem 300m
log using sem6.log, text replace

/*	**************************************************/
/*     	File Name:	sem6.do					            */
/*     	Date:   	June, 2017					*/
/*      Author: 	Elena S. Vakulenko					*/
/*      Purpose:	Time series analysis                 */
/*      Input File:	crisis.dta							*/
/*      Output File:	sem6.log					    */	
/*	*****************************************************/


/*See seminar 6*/ 

**1**
gen n=_n
tsset n, monthly


reg rwage u oil_b_rub

**2**
*Testing autocorrelation
predict resid, resid
twoway dot resid n
twoway dot resid L.resid

*Durbin-Watson test
estat dwatson

*Breusch-Godfrey
estat bgodfrey
estat bgodfrey, lags(1/2)

*Newey-West estimators
newey rwage u oil_b_rub, lag(1)


**3**
corrgram resid, lags(25)


**4**

twoway line labor n
tsline labor
twoway line u n 
twoway line rwage n 
twoway line oil_b_rub n

**5**
*Correlograms

corrgram labor, lags(25)
corrgram D.labor, lags(25)

ac labor, saving(ac)
pac labor, saving(pac)
graph combine ac.gph pac.gph,  title("Correlograms")

corrgram u, lags(25)
corrgram D.u, lags(25)
corrgram rwage, lags(25)
corrgram D.rwage, lags(25)
corrgram oil_b_rub, lags(25)
corrgram D.oil_b_rub, lags(25)


**6**
dfuller labor, trend regress lags(2)
dfuller labor, regress lags(2)
dfuller D.labor

dfuller oil_b_rub, trend regress lags(1)
dfuller oil_b_rub, regress lags(1)

dfuller D.oil_b_rub, trend regress lags(1)
dfuller D.oil_b_rub,  regress lags(1)

**7**
*ARIMA models

arima labor, ar(1) ma(1)

*Information criteria
estat ic

*Prediction

tsappend, add(12)

predict labor_p, xb 


predict labor_p1, y 

arima labor, arima(1,1,0)

*As example

arima labor, ar(1)
est store ar1c
arima labor, ar(1/2)
est store ar12c
arima labor, ar(1/3)
est store ar123c
est tab ar1c ar12c ar123c, stats(aic bic) title(Labor) 

*Another variant
arima labor, ar(1)
outreg2 using sem6.doc, replace word dec(3) ///
alpha(.01 , .05, .1) symbol(*** , **, *) label

arima labor, ar(1/2)
outreg2 using sem6.doc, append word dec(3) ///
alpha(.01 , .05, .1) symbol(*** , **, *) label

arima labor, ar(1/3)
outreg2 using sem6.doc, append word dec(3) ///
alpha(.01 , .05, .1) symbol(*** , **, *) label


log close
*clear
*exit
