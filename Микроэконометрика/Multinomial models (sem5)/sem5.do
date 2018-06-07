// Use data from mus15data.dta

describe
sum
tab mode
*case-specific variable income
table mode, contents( N income mean income sd income)
*alternative-specific variables
table mode, contents( mean pbeach mean ppier mean pprivate mean pcharter)
table mode, contents( mean qbeach mean qpier mean qprivate mean qcharter)
*unrestricted model (case specific, coefficients like in binary logit for choise between base output and another option)
mlogit mode income, baseoutcome(1)
est store model1
*relative risk ratios instead of coefficients: P(yi=j)/P(yi=1)
mlogit mode income, rr baseoutcome(1)
*multinomial logit (case specific)
mlogit mode income, baseoutcome(1)
*Wald test for significance of income
test income
*LR-test for significance of income
est store unrestr
mlogit mode, baseoutcome(1)
est store restr
lrtest unrestr restr

est restore model1
*predicted probabilities (NOTE: means are equal)
predict pmlogit1 pmlogit2 pmlogit3 pmlogit4, pr
sum pmlogit* dbeach dpier dprivate dcharter, separator(4)
*average predicted probability for outcome 3
margins, predict(outcome(3))
*marginal effect at mean
margins, dydx(*) predict(outcome(3)) atmean

*data from wide form to long form (wide: one observation = data for all alternatives)
gen id= _n
reshape long d p q, i(id) j( fishmode beach pier private charter) string
*now one observation = data about only one alternative
*conditional multinomial logit model (alternative-specific coefficients+case-specific-coefficients)
asclogit d p q, case(id) alternatives(fishmode) casevars(income) basealternative(beach)
*multinomial logit is a special case of conditional multinomial logit
asclogit d, case(id) alternatives(fishmode) casevars(income) basealternative(beach)
asclogit d p q, case(id) alternatives(fishmode) casevars(income) basealternative(beach)
*predicted probabilities (NOTE: means are equal)
predict pasclogit, pr
table fishmode, contents( mean d mean pasclogit sd pasclogit)
estat alternatives
*marginal effect at mean for p
estat mfx, varlist(income)
*tree preparation for nested logit
nlogitgen type= fishmode(shore: pier | beach, boat: private | charter)
nlogittree fishmode type, choice(d)
*nested logit
nlogit d p q || type:, base(shore) || fishmode: income, case(id) nolog
*predicted probabilities (NOTE: means are not equal)
predict plevel1 plevel2, pr
tab fishmode, sum (plevel2)
