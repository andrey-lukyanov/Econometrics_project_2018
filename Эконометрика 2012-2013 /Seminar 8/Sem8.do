set more off
log using sem8.log, text replace

/*	*******************************************************/
/*     	File Name:	sem8.do					*/
/*     	Date:   	November 7, 2012		            */
/*      Author: 	Elena S. Vakulenko				*/
/*      Purpose:	Specification testing, Multicollinearity	*/
/*      Input File:		housing.dta					*/
/*      Output File:	sem8.log					*/	
/*	*******************************************************/

/*Part 1*/

/*���������� ���������*/
	reg  price lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea

/*���� ������*/
	estat ovtest

/*�������� ��������� ���������� price*/
	gen lnprice=ln(price)

/*���������� ��������� � ���������� ����*/
	reg  lnprice lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea

/*�������������� ��������*/

	sum lnprice 
	gen mean_lnprice=r(mean)
	gen price_new=price/exp(mean_lnprice)
	gen lnprice_new=ln(price_new)

/*���� �����-�����*/
	reg  price_new lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	scalar rss1=e(rss)

	reg  lnprice_new lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	scalar rss2=e(rss)
	scalar n=e(N)

	scalar chi2=(n/2)*abs(ln(rss1/rss2))
	scalar pvalue=chi2tail(1,chi2)
	scalar list chi2 pvalue

/*�������� ���� ��������*/
	reg  lnprice lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	predict residual, res	

/*�������� �������� ���������� lnprice_new*/
	
	reg  lnprice lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea
	predict lnprice_hat, xb	

/*��������� ������� �������� � ����������� �� ��������*/
	twoway dot residual lnprice_hat

/*������ ������ ��������� ������ �������*/
 	rvfplot   

/*������������ ��������������������*/
	Vif

/*������ ������� ���������������*/

mkmat lotsize bedrooms bathrms stories driveway recroom fullbase gashw airco garagepl prefarea, matrix(X)

matrix XX= X'*X

/*Create matrix EV containing the eigenvectors of XX and vector lambda containing the eigenvalues of XX*/

matrix symeigen EV lambda = XX

matrix list lambda


log close
*clear
*exit


*************************************************************************************
/*Part 2*/
 

	/************************************************/
	/* ������������� ����������� 	             	*/
	/************************************************/

clear
matrix M = (2 , 6, 8)
matrix C = (10 , 7, 5 \ 7 , 6, 4 \ 5, 4, 2.73)
set seed 50
  drawnorm x1 x2 x3, means(M) cov(C) n(50)
  scatter x1 x2
  scatter x1 x3
  scatter x2 x3

		/* ������������� ����������� ���������� ��������� �������� */
  
  drawnorm epsilon
  hist epsilon
  twoway kdensity epsilon

		/* ������������� ��������� ���������� */
		
  generat y = -5 + 3*x1 - 8*x2 + 2*x3 + epsilon

 		 /* ������������ ���������� ���������� */
  summarize y x1 x2 x3

 		 /* �������������� ������� */  
  correlate y x1 x2 x3
  
  
		/* ���������� ��������� */
  
regress y x1 x2 x3
regress y x1 x2
regress y x1 x3
regress y x2 x3

		/* ������ VIF */
 vif

	matrix cov=e(V) /*������� � ������ �������������� ������� �������������*/
	matrix list cov /*����� ���� ������� �� �����*/

		/* ������ ������� ��������������� */
matrix XX=X'*X

/*Create matrix EV containing the eigenvectors of XX and vector lambda containing the eigenvalues of XX*/

matrix symeigen EV lambda = XX
matrix list lambda


		/* ����� ������� ��������� */
pca x1 x2 x3
pca x1 x2 x3, comp(1)
matrix comp=e(L)
matrix list comp

		/*�������� ������� �� ����������*/
mkmat x1 x2 x3, matrix(X)
matrix list X

matrix z=X*comp
svmat z /*�������� ���������� �� �������*/

		/* ���������� ��������� �� ������� ���������� */
reg y z1



	/************************************************/
	/* ������ ����� ����������                     	*/
	/************************************************/
clear

matrix M = (2 , 6, 8)
matrix C = (10 , 7, 5 \ 7 , 6, 4 \ 5, 4, 2.73)
set seed 50
  drawnorm x1 x2 x3, means(M) cov(C) n(1000)
  scatter x1 x2 x3

		/* ������������� ����������� ���������� ��������� �������� */
  
  drawnorm epsilon
  hist epsilon
  twoway kdensity epsilon

		/* ������������� ��������� ���������� */
		
  generat y = -5 + 3*x1 - 8*x2 + 2*x3 + epsilon

 		 /* ������������ ���������� ���������� */
  summarize y x1 x2 x3

 		 /* �������������� ������� */  
  correlate y x1 x2 x3
  
		/* ���������� ��������� */
  
regress y x1 x2 x3
regress y x1 x2
regress y x1 x3
regress y x2 x3

		/* ������ VIF */
 vif

	matrix cov=e(V) /*������� � ������ �������������� ������� �������������*/
	matrix list cov /*����� ���� ������� �� �����*/

	/* ������ ������� ��������������� */
matrix XX=X'*X

/*Create matrix EV containing the eigenvectors of XX and vector lambda containing the eigenvalues of XX*/

matrix symeigen EV lambda = XX
matrix list lambda
  
log close
*clear
*exit

