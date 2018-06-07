*Instrumental variables

ssc install outreg2, replace
set more off

//log using "D:\log.txt", text replace
//use "D:\Funds.dta"
local file "D:\r.xls"

*OLS regression
regress loge logsize
est store ols
outreg2 using `file', append

*IV regression
ivregress 2sls loge (logsize=age)
est store iv
outreg2 using `file', append

*Two step LS procedure
regress logsize age
predict logsize_hat
regress loge logsize_hat
est store tsls
outreg2 using `file', append


est tab ols iv tsls, b se stats(N r2)




