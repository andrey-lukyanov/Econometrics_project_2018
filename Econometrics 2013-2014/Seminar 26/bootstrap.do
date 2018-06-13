*Author: Eugenia Nazrullaeva

clear 

set seed 12345
set obs 1000

local beta1=1
local beta2=0.5

gen e=sqrt(3)*invnorm(uniform())
gen x1=invnorm(uniform())
gen x2=invnorm(uniform())
gen y=`beta1'*x1+`beta2'*x2+e

reg y x1 x2, noc

*Bootstrapped standard errors
bootstrap, reps(1000) l(95): reg y x1 x2, noc
reg y x1 x2, noc vce(bootstrap, reps(1000))

*Bootstrapped vs asy distributions
  program reg_boot, rclass
          version 10
          reg y x1 x2, noc
          return scalar theta = _b[x1]/_b[x2]
  end
  
  bootstrap r(theta), reps(1000) seed(4567) saving(mydata, replace): reg_boot
  
  clear
  use mydata
  kdensity _bs_1, nor
  quantile _bs_1