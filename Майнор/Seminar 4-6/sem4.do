*set mem 300m
log using sem4.log, text replace

/*	*****************************************************/
/*     	File Name:	sem3.do					            */
/*     	Date:   	November 19, 2014					*/
/*      Author: 	Elena S. Vakulenko					*/
/*      Purpose:	Regression analysis 2               */
/*      Input File:	housing.dta							*/
/*      Output File:	sem3.log					    */	
/*	*****************************************************/


/*See seminar 4*/ 

**2**

reg  price lotsize bedrooms bathrms airco driveway recroom fullbase gashw stories garagepl prefarea

**3**


/*Создание логарифма переменной price*/
	gen lnprice=ln(price)

/*Оценивание регрессии с логарифмом цены*/
	reg  lnprice lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea

	gen lnlotsize=ln(lotsize)
	reg  lnprice lnlotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea

**4**
	
/*Преобразование Зарембки*/

	sum lnprice 
	gen mean_lnprice=r(mean)
	gen price_new=price/exp(mean_lnprice)
	gen lnprice_new=ln(price_new)

/*Тест Бокса-Кокса*/
	reg  price_new lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	scalar rss1=e(rss)

	reg  lnprice_new lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	scalar rss2=e(rss)
	scalar N=e(N)

	scalar chi2=(N/2)*abs(ln(rss1/rss2))
	scalar pvalue=chi2tail(1,chi2)
	scalar list chi2 pvalue rss1 rss2

**5**

gen bedrooms2=0
replace bedrooms2=1 if bedrooms<3

gen bedrooms3=0
replace bedrooms3=1 if bedrooms==3

gen bedrooms4=0
replace bedrooms4=1 if bedrooms==4

gen bedrooms5=0
replace bedrooms5=1 if bedrooms>4



reg  lnprice lnlotsize bathrms stories driveway recroom fullbase gashw airco garagepl prefarea bedrooms2 bedrooms3 bedrooms4

**6**
reg  lnprice lnlotsize  bathrms stories driveway recroom fullbase gashw airco garagepl prefarea bedrooms2 bedrooms3 bedrooms4 bedrooms5

*another way
xi: reg  lnprice lnlotsize i.bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea 

*Without constant
reg  lnprice lnlotsize bathrms stories driveway recroom fullbase gashw airco garagepl prefarea bedrooms2 bedrooms3 bedrooms4 bedrooms5, noc

**7-11 see previous seminar

**13**

*Chow test
	
	reg  lnprice lnlotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
scalar r_all=e(rss)
scalar n_all=e(N)

	reg  lnprice lnlotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea if bedrooms<3
scalar r_1=e(rss)
scalar n_1=e(N)

	reg  lnprice lnlotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea if bedrooms>2
scalar r_2=e(rss)
scalar n_2=e(N)

scalar ddf=n_1+n_2-12*2
scalar r_tot=r_1+r_2
scalar F1=((r_all-r_tot)/(12))/(r_tot/ddf)
scalar pval1=Ftail(12,ddf,F1)
scalar list ddf F1 pval1

***Another variant

for var lnlotsize bedrooms bathrms stories driveway ///
recroom fullbase gashw airco garagepl prefarea: gen X_bedrooms2=X*bedrooms2

reg lnprice lnlotsize bedrooms bathrms stories driveway recroom ///
fullbase gashw airco garagepl prefarea *bedrooms2

testparm *bedrooms2
	
log close

*clear
*exit
