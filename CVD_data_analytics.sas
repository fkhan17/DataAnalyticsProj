PROC IMPORT DATAFILE="/home/fahadk/CSV/DIGOXIN.csv" DBMS=CSV OUT=DIGOXINdat 
		REPLACE;
RUN;

Data digoxinhyp;
	Set DIGOXINdat;

	If SYSBP >=140 or DIABP >=90 Then
		Hypertension="YES";
	Else
		Hypertension="No";
run;

Proc freq data=digoxinhyp;
	tables Hypertension*DIABETES;
run;

*there are 707 people with diabetes and hypertension;

Proc means data=digoxinhyp;
	class CVD;
	var BMI;
run;

*Average BMI of people with CVD is 27.16;

data agegroupdata;
	set digoxinhyp;

	If AGE<30 then
		AGEGROUP="Young Adult";
	else if AGE >=65 then
		AGEGROUP="Older Adult";
	else
		AGEGROUP="Adult";
run;

proc freq data=agegroupdata;
	tables AGEGROUP;
run;

*There are 26 young adults, 3369 adults, and 3405 older adults in the study;

proc ttest data=digoxinhyp;
	class SEX;
	var AGE;
run;

*Looking at the equality of variances the p-value is above 5% so the
results of the t-test are considered by looking at the equal variance.
The p-value is greater than the alpha 0.05 therefore the age difference between males 
and females is insignificant.
;

proc freq data=digoxinhyp;
	tables TRTMT*CVD/CHISQ;
run;

*There is correlation between people that took the active drug (TRTMT) and lower
risk of cardiovascular disease. The p-value<5% making the data statistically significant.
