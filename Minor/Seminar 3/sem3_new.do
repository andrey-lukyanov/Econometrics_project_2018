/*Seminar 3*/

/*1 use data housing.dta*/

/*2*/
sum

/*3*/
twoway dot price lotsize || lfit price lotsize
twoway dot price bedrooms || lfit price bedrooms
twoway scatter price bathrms || lfit  price bathrms
twoway dot price bathrms if bathrms!=4 || lfit  price bathrms if bathrms!=4
twoway dot price bedrooms || dot  price bathrms 

/*4*/
hist price, norm
twoway hist price ||kdensity  price

/*5*/
reg price lotsize bedrooms bathrms airco

/*7*/

predict resid_a, resid
predict price_hat, xb

gen n=_n
twoway scatter resid_a n
twoway scatter resid_a price
twoway dot price_hat price || line price price

/*8*/

hist resid_a, norm
sktest resid_a
swilk resid_a
