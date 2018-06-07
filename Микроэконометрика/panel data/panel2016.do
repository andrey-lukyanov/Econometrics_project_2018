*Panel Data Seminar /Bashina A.S./
*based on A.C. Cameron, P.K. Trivedi Microeconometrics Using Stata
*Data from the Panel Study of Income Dynamics (PSID) 


*Describe data (only variables for seminar)
describe lwage exp wks ed
*Descriptive statistics
sum lwage exp exp2 wks ed
*Histogram for dependent variable
hist lwage

*Declare panel data structure
xtset id t
*Describe panel structure (balanced/unbalanced panel)
xtdescribe
*Generate variables containing means of variables for each year
egen lwage_m=mean(lwage), by(t)
egen exp_m=mean(exp), by(t)
egen wks_m=mean(wks), by(t)
egen ed_m=mean(ed), by(t)
*Plots for generated variables
twoway (line lwage_m t, sort) 
twoway (line exp_m t, sort) 
twoway (line wks_m t, sort) 
twoway (line ed_m t, sort)
*Scatterplots for initial variables
twoway (scatter lwage exp) 
twoway (scatter lwage wks) 
twoway (scatter lwage ed)
*Correlations for initial variables
pwcorr lwage exp  wks ed, sig

*Pooled OLS 
reg lwage c.exp##c.exp wks ed
est store reg1
*Pooled OLS with cluster-robust standard errors
reg lwage c.exp##c.exp wks ed, vce(cluster id)
est store reg_robust
*Autocorrelation for residuals
predict uhat1, residuals
corr uhat1 l.uhat1
corr uhat1 l2.uhat1
corr uhat1 l3.uhat1
corr uhat1 l4.uhat1
corr uhat1 l5.uhat1
corr uhat1 l6.uhat1

*FE estimator with cluster-robust standard errors
xtreg lwage c.exp##c.exp wks ed, fe vce(cluster id)
est store reg_fe
*Comparison of POLS and FE
est tab reg_robust reg_fe, se stats(F)
*LSDV model using OLS
set matsize 800
quietly reg lwage c.exp##c.exp wks ed i.id, vce(cluster id)
est store reg_lsdv
*Comparison of LSDV and FE
est tab reg_fe reg_lsdv, keep(c.exp##c.exp wks ed _cons) se

*RE estimator with cluster-robust standard errors
xtreg lwage c.exp##c.exp wks ed, re vce(cluster id)
est store reg_re
*Comparison of POLS, FE and RE
est tab reg_robust reg_fe reg_re, se stats(F)

*RE vs POLS using Breush-Pagan test (after RE estimator)
xttest0
*FE vs RE using Hausman test (cannot be used with robust standard errors, see modification in Cameron, Trivedi)
quietly xtreg lwage c.exp##c.exp wks, fe
est store reg_fe1
quietly xtreg lwage c.exp##c.exp wks, re
est store reg_re1
hausman reg_fe1 reg_re1

*RE estimator with time dummies
xtreg lwage c.exp##c.exp wks ed i.t , re vce(cluster id)
test 2.t 3.t 4.t 5.t 6.t 7.t


