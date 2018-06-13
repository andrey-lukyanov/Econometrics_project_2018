gen lnc=ln(c)
gen lnq=ln(q)
gen lnpw=ln(pw)
gen lnpk=ln(pk)
gen lnpf=ln(pf)
//OLS
reg lnc lnq lnpw lnpf lnpk, vce(robust)
//Asy Wald test
test (lnpw+lnpk+lnpf=1)

//incorporating constraint
gen lnck=lnc-lnpk
gen lnpwk=lnpw-lnpk
gen lnpfk=lnpf-lnpk
reg lnck lnq lnpwk lnpfk, vce(robust)

//NLS with zero initial values (default)
nl (lnck={cons}+{lnq}*lnq+{lnpwk}*lnpwk+{lnpfk}*lnpfk+{alpha6}*lnq*(1+exp(-(lnq-{alpha7})))^(-1)), vce(robust)
//NLS with specified initial values
nl (lnck={cons}+{lnq}*lnq+{lnpwk}*lnpwk+{lnpfk}*lnpfk+{alpha6}*lnq*(1+exp(-(lnq-{alpha7})))^(-1)), in(cons 0 lnq 0 lnpwk 0 lnpfk 0 alpha6 0 alpha7 6.55) vce(robust)

//Conventional smooth transition model
nl (lnck={cons}+{lnq}*lnq*(1-(1+exp(-(lnq-{alpha7})))^(-1))+{lnpwk}*lnpwk+{lnpfk}*lnpfk+{alpha6}*lnq*(1+exp(-(lnq-{alpha7})))^(-1)), in(cons 0 lnq 0 lnpwk 0 lnpfk 0 alpha6 0 alpha7 6.55) vce(robust)