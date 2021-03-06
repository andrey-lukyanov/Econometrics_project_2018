clear 
set more off

set obs 500

local beta1=1
local beta2=2
local gamma=0.5

gen e=sqrt(3)*invnorm(uniform())
gen x1=invnorm(uniform())
gen x2=uniform()
gen y=`beta1'*x1+`beta2'*x2^`gamma'+e

*Nonlinear Least Squares
nl (y={beta1}*x1+{beta2}*x2^{gamma})

*Nonlinear GMM
gmm (y-{beta1}*x1-{beta2}*x2^{gamma}),  instruments(x1 x2)

gmm (y-{beta1=1}*x1-{beta2=2}*x2^{gamma=0.5}),  instruments(x1 x2)

*ML
program nonlinl
version 10
args lnf beta1 beta2 gamma sigma
quietly replace `lnf'=ln(normalden(y,`beta1'*x1+`beta2'*x2^`gamma',`sigma'))-ln(`sigma')
end

ml model lf nonlinl (beta1: ) (beta2: ) (gamma: ) (sigma: )
ml max
