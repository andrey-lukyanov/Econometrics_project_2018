//    Seminar 19 November

gen smoke=1 if q34==1|q34==2
replace smoke=0 if q34==3|q34==5
gen alco=1 if q47==1
replace alco=0 if q47==2|q47==3
gen female=q1-1
gen age=q2
gen educ_3=0 
replace educ_3=1 if q2==7|q2==8
gen smoke_14=1 if q41==1
replace smoke_14=0 if q41==2
gen income=q99 if q99!=9
gen income_norm=income/q76


tab smoke alco
corr smoke alco
by alco, sort: sum female age educ_3 smoke_14 income_norm

//Separate probit models
probit smoke i.female c.age c.age#c.age i.educ_3 i.smoke_14 c.income_norm
est store probit_smoke
predict prob_smoke, p
margins, dydx(female age) atmeans

probit alco i.female c.age c.age#c.age i.educ_3 i.smoke_14 c.income_norm
est store probit_alco
predict prob_alco, p
margins, dydx(female age) atmeans

//Bivariate probit
biprobit smoke alco i.female c.age c.age#c.age i.educ_3 i.smoke_14 c.income_norm
est store biprobit1
//Predicted probabilities
//P(smoke=1)
predict biprob_smoke1, pmarg1
//P(alco=1)
predict biprob_alco1, pmarg2
//P(smoke=1,alco=1)
predict biprob_smoke1alco1, p11
//Marginal effects
margins, dydx(female age) atmeans predict(pmarg1)
margins, dydx(female age) atmeans predict(pmarg2)
margins, dydx(female age) atmeans predict(p00)
margins, dydx(female age) atmeans predict(p01)
margins, dydx(female age) atmeans predict(p10)
margins, dydx(female age) atmeans predict(p11)

est tab probit_smoke probit_alco biprobit1
sum smoke alco prob_smoke prob_alco biprob_smoke1 biprob_alco1 biprob_smoke1alco1

//Bivariate probit with different sets of regressors
biprobit (smoke i.female c.age c.age#c.age i.educ_3 i.smoke_14 c.income_norm) (alco i.female c.age c.age#c.age i.educ_3 c.income_norm)
