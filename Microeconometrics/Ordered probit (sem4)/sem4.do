*descriptive statistics
sum
tab so urb
tab tradrole

*ordered probit model
oprobit  tradrole  c.age i.cath i.fpro c.adjinc c.meduc  i.mw14 i.nonint c.nsibs  i.so i.urb
est store oprob1
*test
test 1.cath 1.fpro
*nonlinear age
oprobit  tradrole  c.age##c.age i.cath i.fpro c.adjinc c.meduc  i.mw14 i.nonint c.nsibs  i.so i.urb
est store oprob2
*test
test age c.age#c.age
*working mother
oprobit  tradrole  c.age i.cath i.fpro c.adjinc c.meduc i.nonint c.nsibs  i.so i.urb i.mw14 i.mw14#(i.cath i.fpro)
est store oprob3
*test
test 1.mw14#1.cath 1.mw14#1.fpro
*to the first model
est restore oprob1
*test
test 1.so 1.urb
*final model
oprobit  tradrole  c.age i.cath i.fpro c.adjinc c.meduc  i.mw14 i.nonint c.nsibs
est store oprob4
*marginal effects for outcome 4 for the respondent with specific characteristics
margins, dydx(adjinc) predict(outcome(4)) at(age=(16(1)20) cath=1 fpro=0 nsibs=0 adjinc=9000 nonint=0 meduc=13 mw14=1)
*average marginal effects for outcome 4
margins, dydx(*) predict(outcome(4))
*predicted probabilities
predict p1oprobit p2oprobit p3oprobit p4oprobit, pr
predict y_star, xb
*prediction for observation #14
list p1oprobit p2oprobit p3oprobit p4oprobit y_star in 14

















