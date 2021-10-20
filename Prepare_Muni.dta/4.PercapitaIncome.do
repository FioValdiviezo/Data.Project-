
global root "C:\Users\Z50-CORE-I5\Desktop\RSE.project\MEF_data\munis"
cd "$root"
global raw	"${root}\1.MunicipalLevel_data"
global results "${root}\2.Final_data"


merge m:1 ubigeo using "${root}\POPULATION.dta"

**********************************
*Generate Transfers per capita
**********************************
capture drop canon_p

capture gen canon_p = canon/population/1000

label var canon_p "Canon minero per capita"


*MUNICIPALITIES REVENUE AND EXPENDITURE
**************************************

capture drop ejecute_p
capture drop PIM_p


capture gen ejecute_p=ejecute/population/1000
capture gen PIM_p=PIM/population/1000

capture gen ln_canon_p=ln(canon_p+1)
capture gen ln_PIM_p=ln(PIM_p)
capture gen ln_ejecute_p=ln(ejecute_p)
capture gen ln_population=ln(population)

label var ln_canon_p "Ln(canon per capita) received by district"
label var ln_PIM_p "Ln(total municipal revenue per capita)"
label var ln_ejecute_p "Ln(total municipal expenditure per capita)"
label var ln_population "ln(district population)"


save "${root}\1.MunicipalLevel_data", replace 





