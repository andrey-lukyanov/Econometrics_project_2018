*OLS estimation
gen lex2=lex^2 
reg y male dex lex lex2, robust

*Wald test
test lex lex2
test lex2

*LR test
reg y male dex lex lex2 
est store ur
reg y male dex 
est store r
lrtest ur r

*Marginal effect of education & mean productivity
*Chow test
twoway dot y lex
lpoly y lex

twoway dot y lex if male==0 || dot y lex if male==1

gen malelex=male*lex 
gen malelex2=male*lex2
gen maledex=male*dex
reg y male dex lex lex2 maledex malelex malelex2 
test male maledex malelex malelex2

*Marginal effects
gen margeff_male=_b[lex]+_b[malelex]+2*(_b[lex2]+_b[malelex2])*lex
gen margeff_female=_b[lex]+2*_b[lex2]*lex

graph twoway line (margeff_male margeff_female lex)

*Mean productivity
egen meandex=mean(dex)
reg y male dex lex lex2
gen mean_y_overall=_b[_cons]+_b[dex]*meandex+_b[lex]*lex+_b[lex2]*lex2
reg y dex lex lex2 if male==1
gen mean_y_male=_b[_cons]+_b[dex]*meandex+_b[lex]*lex+_b[lex2]*lex2
reg y dex lex lex2 if male==0
gen mean_y_female=_b[_cons]+_b[dex]*meandex+_b[lex]*lex+_b[lex2]*lex2
graph twoway scatter (mean_y_male mean_y_female mean_y_overall lex)


*Bootstrap: bootstrap vs. bsample
  program reg_bt, rclass
          version 10
          reg y male dex lex lex2
          return scalar lex_star = -_b[lex]/(2*_b[lex2])
  end
  
  bootstrap r(lex_star), reps(1000) seed(4567) saving(mydata, replace): reg_bt
  
*Quantile regression
ssc install qreg2, replace
qreg2 y male dex lex lex2, quant(.05) 
qreg2 y male dex lex lex2, quant(.25) 
qreg2 y male dex lex lex2, quant(.50) 
qreg2 y male dex lex lex2, quant(.75) 
qreg2 y male dex lex lex2, quant(.95)

*Bootstrap standard errors
set seed 1001

bsqreg y male dex lex lex2

***Quantile regression: graphics
qreg y male dex lex lex2, vce(robust)

qreg y male dex lex lex2
grqreg, cons ci  title(Fig.1a Fig.1b Fig.1c Fig.1d Fig.1e) 

qreg y male dex lex lex2
grqreg, cons ci ols olsci title(Fig.1a Fig.1b Fig.1c Fig.1d Fig.1e) 

qreg y male dex lex lex2
grqreg, cons ci ols olsci title(Fig.1a Fig.1b Fig.1c Fig.1d Fig.1e) qstep (0.1)

qreg y male dex lex lex2
grqreg, cons ci ols olsci title(Fig.1a Fig.1b Fig.1c Fig.1d Fig.1e) qstep (0.2)

qreg y male dex lex lex2
grqreg dex male, compare

bsqreg y male dex lex lex2
grqreg, cons ci ols olsci title(Fig.1a Fig.1b Fig.1c Fig.1d Fig.1e) qstep (0.1)



*Simultaneous-quantile regression
*Stata can perform simultaneous-quantile regression. 
*With simultaneous-quantile regression, we can estimate multiple quantile regressions simultaneously:

set seed 1001

sqreg y male dex lex lex2, q(.25 .5 .75)

*We can test whether the effect of weight is the same at the 25th and 75th percentiles:
test[q25]dex = [q75]dex

*We can obtain a confidence interval for the difference in
*the effect of dex at the 25th and 75th percentiles:
lincom [q75]dex-[q25]dex

*Stata also performs interquantile regression, which focuses on one quantile comparison:
set seed 1001

iqreg y male dex lex lex2, q(.25 .75)

