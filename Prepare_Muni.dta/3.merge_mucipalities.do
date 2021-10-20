/**************************************************************
*Project	:	,
*Objetive	: 	Merge the data of each municipality
*Author		:  	
*Inputs		:   1.MunicipalLevel_data: MuniCusco.dta / MuniPuno.dta / MuniAyacucho.dta / MuniArequipa.dta / MuniApurimac.dta
*Outputs	:	2.Final_data
*Comments	:	Municipalities datasets are collectoed from: MEF (Consulta Amigable), and MEF ( Transfers to local government)
		
*****************************************************************/

global root "C:\Users\Z50-CORE-I5\Desktop\RSE.project\MEF_data\munis"
cd "$root"
global raw	"${root}\1.MunicipalLevel_data"
global results "${root}\2.Final_data"

*Merge Municipal Data 

* Cusco + Puno
use "${raw}\MuniCusco.dta",clear
append using "${raw}\MuniPuno.dta"
save tmp_CuscoPuno

* Cusco + Puno + Ayacucho
use "${raw}\MuniAyacucho.dta",clear
append using "${root}\tmp_CuscoPuno.dta"
save tmp_AyacuCuscoPuno

* Cusco + Puno + Ayacucho + Arequipa
use "${raw}\MuniArequipa.dta",clear
append using "${root}\tmp_AyacuCuscoPuno.dta"
drop _m
save tmp_AreqAyacuCuscoPuno

* Cusco + Puno + Ayacucho + Arequipa + Apurimac

use "${raw}\MuniApurimac.dta",clear
append using "${root}\tmp_AreqAyacuCuscoPuno.dta"
drop _m
save "${results}\municipality_data"

*cleaning 

erase tmp_CuscoPuno.dta
erase tmp_AyacuCuscoPuno.dta
erase tmp_AreqAyacuCuscoPuno.dta


**** Add population variable by year:

merge m:1 ubigeo using "${root}\POPULATION.dta"

rename 2008 pop2008
