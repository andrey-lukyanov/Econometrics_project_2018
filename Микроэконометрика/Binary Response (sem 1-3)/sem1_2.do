//new variable
gen smoke=0 if cigs==0
replace smoke=1 if cigs>0&cigs!=.

//descriptive stats
sum smoke faminc cigtax cigprice fatheduc motheduc parity white
sum smoke faminc cigtax cigprice fatheduc motheduc parity white if fatheduc!=.&motheduc!=.

//linear probability model
reg smoke faminc cigtax cigprice fatheduc motheduc parity white if fatheduc!=.&motheduc!=.
est store lin1

//estimated p(smoke=1|x)
predict prob_ols, xb
//estimated smoke
gen smoke_ols=1 if prob_ols>0.5&prob_ols!=.
replace smoke_ols=0 if prob_ols<=0.5&prob_ols!=.
count if smoke_ols==smoke
tab smoke_ols smoke

//logistic regression
logit smoke faminc cigtax cigprice fatheduc motheduc parity white if fatheduc!=.&motheduc!=.
est store logit1
//classification table
estat classification

//LPM and logit
est tab lin1 logit1

//estimated p(smoke=1|x)
predict prob_logit, p
//estimated p(smoke=1|x) with all variables but faminc held at median for logit
prgen faminc, generate(logit) rest(median) ncases(20)
//estimated p(smoke=1|x) with all variables but faminc held at median for LPM
est restore lin1
egen med_cigtax=median( cigtax) in 1/20
egen med_cigprice =median( cigprice ) in 1/20
egen med_fatheduc =median( fatheduc ) in 1/20
egen med_motheduc =median( motheduc ) in 1/20
egen med_parity =median( parity ) in 1/20
egen med_white =median(white) in 1/20
gen linearp1=_b[_cons]+_b[faminc]*logitx+_b[cigtax]*med_cigtax+_b[cigprice]*med_cigprice+_b[fatheduc]*med_fatheduc+_b[motheduc]*med_motheduc+_b[parity]*med_parity+_b[white]*med_white

//graph for estimated p(smoke=1|x) with all variables but faminc held at median
twoway (line logitp1 logitx) (line linearp1 logitx)

//ROC curve for logit
est restore logit1
lroc

//Measures of Fit for logit
fitstat

//Wald test
test (fatheduc=0) (motheduc=0)
test fatheduc motheduc

//LR-test
logit smoke faminc cigtax cigprice parity white if fatheduc!=.&motheduc!=.
est store logit2
lrtest logit1
lrtest logit1 logit2
lrtest logit2 logit1

est restore logit1

//Marginal effect for any point
margins, dydx(*) at(faminc=(0.5(10)65) (mean) cigtax cigprice fatheduc motheduc (p50) parity white)
//Marginal effect at mean
margins, dydx(*) atmean
//Average marginal effect
margins, dydx(*)
//Graph for Margins
marginsplot


