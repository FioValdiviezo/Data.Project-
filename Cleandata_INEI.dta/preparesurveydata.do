
/*********************************************************************************************
*Project	:	Long term effect of Peruvian Mining Mita on Economic Development (2008 - 2014)
*Objetive	: 	
*Author		:  	
*Inputs		:	ENAHO (2008-2014)
*Outputs	:	Graphs and tables
*Comments	:	ENAHO dataset of many years was cleaned and generated previously by Sebastion Sardon. For more details, check his Github page. 
		
*************************************************************************************************/
* We use nationally representative sample of Peruvian households over the 2008-2014 period. The raw data comes from Peru's National Household Survey (in Spanish, "ENAHO"), conducted by the National Institute of Informatics and Statistics (in Spanish, "INEI").
*  This database is located here: https://github.com/PeruData/ENAHO

clear all
set more off

global dir "C:\Users\Z50-CORE-I5\Desktop\RSE.project\Cleandata_INEI\"
cd "$dir"

use "$dir\1997-2018.dta"

* For the project porpose, we only used the years 2008 to 2014.

drop if year<2008 | year>2014

save "$dir\1997-2018.dta", replace
* Merge Household data with historical variables (obtained from Melissa Dell paper ):

use "$dir\1997-2018.dta", clear 
merge m:1 ubigeo using "HVMell.dta"
drop if lon == . 
drop _m 

* Now we have 69,141 observations for the study. 

save "$dir\2008-2014.dta"

* Our sample includes the states richest in mineral resources: Apurimac, Arequipa, Cusco, and Puno. 

