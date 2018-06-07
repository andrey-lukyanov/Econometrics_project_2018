
********** DATA DESCRIPTION **********

* Subset of data in P. Deb, M. Munkin and P.K. Trivedi (2006)
* "Bayesian Analysis of Two-Part Model with Endogeneity", Journal of Applied Econometrics, 21, 1081-1100
* Only the data for year 2001 are used

* Dependent variable is 
*      ambexp   Ambulatory medical expenditures (excluding dental and outpatient mental) 
*      dambexp  1 if ambexp > 0 and 0 otherwise
* Regressors are 
*  - Health insurance measures
*       ins either PPO or HMO type insurance
*  - Health status measures
*       totchr     number of chronic diseases
*  - Socioeconomic characteristics
*       age     age in years/10 
*       female   1 for females, zero otherwise
*       educ     years of schooling of decision maker
*       blhisp   either black or hispanic 
*        

summarize ambexp age female educ blhisp totchr ins 
summarize ambexp, detail
summarize ambexp if ambexp >0, detail 

*Linear regression
reg ambexp c.age i.female c.educ i.blhisp c.totchr i.ins 
est store reg_1
reg ambexp c.age i.female c.educ i.blhisp c.totchr i.ins if dambexp==1
est store reg_2
est tab reg_1 reg_2

*Tobit model
tobit ambexp c.age i.female c.educ i.blhisp c.totchr i.ins, ll(0) 
est store tobit_1
est tab reg_1 reg_2 tobit_1

* Prediction
*Pr(ambexp is observed)
predict tobit_pr, p(0,.)
*E(y|x,y>0)
predict tobit_cond, e(0,.)
*E(ambexp*)
predict tobit_hat, xb
sum tobit_pr tobit_cond tobit_hat ambexp

*Marginal effects
* ME on censored expected value E(y|x,y>0)
margins, dydx(*) predict(e(0,.)) atmean noatlegend
* ME without censoring on E(y|x)
margins, dydx(*) predict(ystar(0,.)) atmean noatlegend
* ME when E(y|0<y<535)
margins, dydx(*) predict(e(0,535)) atmean noatlegend
* ME on Pr(5000<ambexp<10000)  
margins, dydx(*) predict(pr(5000,10000)) atmean noatlegend

*Test tobit against a model that is non-linear in the regressors and contains an error term that can be heteroskedastic and non-normally distributed
bctobit
*Tobit with heteroskedastisity
tobithetm ambexp age female educ blhisp totchr ins, het(age female educ blhisp totchr ins)

*Two-part model
* Part 1 of the two-part model
probit dambexp c.age i.female c.educ i.blhisp c.totchr i.ins, nolog
scalar llprobit = e(ll)

* Part 2 of the two-part model
regress ambexp c.age i.female c.educ i.blhisp c.totchr i.ins if dambexp==1
scalar lllognormal = e(ll)
predict res_ambexp, residuals

* Create two-part model log likelihood 
scalar lltwopart = llprobit + lllognormal  //two-part model log likelihood
display "lltwopart = " lltwopart

* hettest and sktest commands
hettest
sktest res_ambexp

*Selection model
* Heckman MLE without exclusion restrictions
heckman ambexp c.age i.female , select(dambexp = c.age i.female)

* Heckman 2-step without exclusion restrictions
heckman ambexp c.age i.female c.educ i.blhisp c.totchr i.ins, select(dambexp = c.age i.female c.educ i.blhisp c.totchr i.ins) twostep
 
* Heckman 2-step with exclusion restrictions
heckman ambexp c.age i.female c.educ i.blhisp c.totchr i.ins, select(dambexp = c.age i.female c.educ i.blhisp c.totchr i.ins income) twostep

*Marginal effects
* ME on censored expected value E(y|x,y>0)
margins, dydx(*) predict(e(0,.)) atmean noatlegend
* ME without censoring on E(y|x)
margins, dydx(*) predict(ystar(0,.)) atmean noatlegend
* ME when E(y|0<y<535)
margins, dydx(*) predict(e(0,535)) atmean noatlegend
* ME on Pr(5000<ambexp<10000)  
margins, dydx(*) predict(pr(5000,10000)) atmean noatlegend

*Predictions for Heckman model
*Pr(ambexp is observed)
predict ambexp_pr, psel
*E(ambexp|ambexp is observed)
predict ambexp_cond, ycond
*E(ambexp*)
predict ambexp_hat, yexpected
sum ambexp_pr ambexp_cond ambexp_hat ambexp

