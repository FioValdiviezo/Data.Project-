/**************************************************************
*PROJECT		: The long term effects of the Peruvian Mining Mita on Economic Development 
*INPUTS		    :	2008-2014 (ENAHO Data) +  municipality_data ( MEF, Peru)
*COMMENTS	    : ENAHO dataset of many years was cleaned and generated previously by Sebastion Sardon. For more details, check his Github page. 	
		
*****************************************************************/
* We use nationally representative sample of Peruvian households over the 2008-2014 period. The raw data comes from Peru's National Household Survey (in Spanish, "ENAHO"), conducted by the National Institute of Informatics and Statistics (in Spanish, "INEI").
*  This database is located here: https://github.com/PeruData/ENAHO

global root "C:\Users\Z50-CORE-I5\Desktop\RSE.project"
cd "$root"
global raw	"${root}\main_results"
global codes	"${root}\02_codes"
global cleandata	"${root}\03_cleandata"
global analysis "${root}\Analysis"
global results	"${root}\05_results"



* Municipality data contains informatio about canon transfers per districts. 
* Dataset
use "${raw}\2008-2014.dta",clear

merge m:1 ubigeo year using "${raw}\municipality_data.dta"

save "${raw}\2008-2014.dta", replace


*OUTCOME VARIABLES: HH INCOME AND EXPENDITURE
******************************************
* Generate districs municipality variables 
/* Fuente: Aragón, Fernando M., and Juan Pablo Rud. 2013. 
 	"Natural Resources and Local Communities: Evidence from a Peruvian Gold Mine." 
	American Economic Journal: Economic Policy, 5 (2): 1-25. */

	capture drop ln_y
gen ln_y=ln(y)
label var ln_y "ln nominal income per capita"
capture drop ln_yrel
gen ln_yrel=ln(y/linea)
label var ln_yrel "Ln real income per capita"

*********************************************
* Create Variables for the Analysis 
*********************************************
* Dummy for rural people
generate rural=.
replace rural= 1 if urban == 0
replace rural = 0 if missing(rural)

* **Create the interaction between Mining Rents and Quality of Institutions 
rename trust_index govinst
rename pothuan_mita mita

* Step 1: Mining rents - quality of institutions interactions
for @ in any govinst : gen canon_p_x_@=canon_p*@
label var canon_p_x_govinst "Mining Rents * Trust in Goverment."

* Step 2: Create the interaction between Quality of insitutions and Mita Dummy (slavery indicator)

for @ in any govinst : gen @_x_mita=@*mita
label var govinst_x_mita    "Trust in Goverment*Mita"


* Step 3: Create the interaction between Years of education and Born in the district where people live now. 
* Born here: this variable is equal to one, if the individual born in the districts where they currently live.
for @ in any educ : gen @_x_born_here=@*born_here
label var educ_x_born_here 

* Step 4: Create the interaction between Years of education and pothuan_mita 
for @ in any educ : gen @_x_mita=@*mita
label var educ_x_mita "Education * Mita"

* Step 4: Create the interaction between Literacy and labot experience 

for @ in any born_here : gen @_x_literacy=@*literacy
label var born_here_x_literacy "Experience * Literacy"

*Step 5 : Create the interaction between Mining Rent and Poor

for @ in any canon_p : gen @_x_poor=@*poor
label var canon_p_x_poor "Canon*Poor"

*Step 5 : Create the interaction between Mining Rent and Poor

for @ in any canon_p : gen @_x_mita=@*mita
label var canon_p_x_mita "Canon*mita"

** Run the model 

*Table 1 - Effect of Mining Rents and Slavery in Ln Nominal Income Per capita  
********************************************************************************
local stdcontrols "poor rural experience electricity water isfemale"
xi: areg ln_y canon_p govinst canon_p*govinst educ educ*mita poor rural experience electricity water isfemale  i.year  if  ocu500==1  & codpers==1 [pweight=factor07], abs(ubigeo) cluster(ubigeo) level(90)
outreg2 using myreg2.doc, replace 
xi: areg ln_y canon_p govinst canon_p*govinst educ educ*born_here poor ' rural experience electricity water isfemale i.year  if  ocu500==1  & codpers==1 [pweight=factor07], abs(ubigeo) cluster(ubigeo) level(90)
outreg2 using myreg2.doc, append addtext(Districts FE, YES, Year FE, YES)
xi: areg ln_y canon_p govinst canon_p*poor  govinst*mita  educ  educ*born_here poor  rural experience electricity water isfemale i.year  if  ocu500==1  & codpers==1 [pweight=factor07], abs(ubigeo) cluster(ubigeo) level(90)
outreg2 using myreg2.doc, append addtext(Districts FE, YES, Year FE, YES)

* Table 2 - Effect of Mining Rents and Slavery in Ln Real Income Per capita
**************************************************************************************
local stdcontrols "poor rural experience electricity water isfemale"
xi: areg ln_yrel canon_p govinst canon_p*govinst educ educ*mita poor rural experience electricity water isfemale i.year  if  ocu500==1  & codpers==1 [pweight=factor07], abs(ubigeo) cluster(ubigeo) level(90)
outreg2 using myreg2.doc, replace 
xi: areg ln_yrel canon_p govinst canon_p*poor govinst*mita  educ  educ*born_here poor rural experience electricity water isfemale i.year  if  ocu500==1  & codpers==1 [pweight=factor07], abs(ubigeo) cluster(ubigeo) level(90)
outreg2 using myreg2.doc, append addtext(Districts FE, YES, Year FE, YES)













