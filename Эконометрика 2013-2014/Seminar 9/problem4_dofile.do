tsset n
reg ibm crsp
*Durbin-Watson d statistic to test for first-order serial correlation
estat dwatson  
*Test for ARCH effects in the residuals
estat archlm, lags(1)  
*Breusch-Godfrey test for higher-order serial correlation         
estat bgodfrey, lags(7)

*Regression with Newey-West standard errors, bandwidth [4(n/100)^{1/3}] ~ Andrews (1991)
newey ibm crsp, lag(11)
vce
