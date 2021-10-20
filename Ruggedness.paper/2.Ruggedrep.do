/*-----------------------------------------------------------------------
*PROJECT		: 'Ruggedness: The blessing of bad geography in Africa': The Differential Effect of Slavery and Natural Resources Rents 
*PURPUSE		: Follow Nunn and Puga methodology to study differential effect of ruggedness and natural resources rents 
*INPUTS		    : rugged_data.dta
*COMMENTS       : Stata do file to extent Nathan Nunn and Diego Puga analysis 
-----------------------------------------------------------------------*/

* Select paper dataset 
use rugged_data.dta, clear

******************************************************************

*Analysis Approach 2

*********************************************************************
*We select 2005 period to study the long-term effects of ruggedness in  the life expectancy.  
*It is necessary to download other development indicators variables: GDP per capita,  and population growth. 
*Also, we are interested on the natural rents effect. 
*If through the income of natural resources, the quality of life of people can be improved.


* Natural Resources Rents Data
* Source: World Bank, World Development Indicator

merge 1:1 isocode using natural.rents_2005.dta

rename natural_rents_2005 naturalrents
keep if _m==3

* GDP per capita
* Source: World Bank, World Development Indicator

merge 1:1 isocode using GDP_p_2005.dta

* Life expentancy and Scholarity data
* Source: Life Expectancy Indicator
*Authors: Debananda Sarkar, Zhanyi Su, Junting He, Joshua Lim

merge 1:1 country using life_expectancy_data_processed2005.dta
keep if m==3

* Rule of Law 2005
* Source: World Wide Governance indicators (WGI).

merge 1:m isocode using rule_law_2005.dta


* Population Growth 
* Source: World Bank, World Development Indicator

merge 1:1 isocode using pop_growth2005.dta

save rugged_data.dta, clear

*** Final database is ready.
** Run Nunn and Puga variables.
clear all
set more off

use rugged_data, clear

* Intereaction between Natural Rents and Africa Countries
for @ in any cont_africa: gen naturalrents_x_@=naturalrents*@
label var naturalrents_x_cont_africa "Natural Resources Rent*Africa"

* Intereaction between Natural Rents and Africa Countries
for @ in any cont_africa: gen q_rule_law_x_@=q_rule_law*@
label var q_rule_law_x_cont_africa "Africa*Rule of Law"

* Natural Resources Rents 2005 and Quality of Instituions (1996- 2000)

for @ in any q_rule_law: gen naturalrents_x_@=naturalrents*@
label var naturalrents_x_q_rule_law "Natural Resources Rent*Rule of Law"


* Natural Resources Rents 2005 and Africa Continent

for @ in any cont_africa: gen fuel_2005_x_@=fuel_2005*@
label var fuel_2005_x_cont_africa "Natural Resources Rent*Rule of Law"

* Natural Resources Rents 2005 and Quality of Instituions Index 2005

for @ in any rlaw: gen naturalrents_x_@=naturalrents*@
label var naturalrents_x_rlaw "Natural Resources Rent*Rule of Law"

* Quality of Institutions 2005 and Africa Continent
for @ in any cont_africa: gen rlaw_x_@=rlaw*@
label var rlaw_x_cont_africa "Natural Resources Rent*Rule of Law"

* Fuel Rents 2005 and Quality of Institutions 2005 

for @ in any rlaw: gen fuel_2005_x_@=fuel_2005*@
label var fuel_2005_x_rlaw "Fuel Resources Rents*Rule of Law"


*** Generate Ln of GDP per capita for 2005

capture gen ln_GDP=ln(GDP_p_2005)
label var ln_GDP "Ln(Per Capita GDP)"

* Generate Nunn and Puga variables: 
* log real gdp per person
gen ln_rgdppc_2000=ln(rgdppc_2000)
label var ln_rgdppc_2000 "Log real GDP per person 2000 --- World Bank"
gen ln_rgdppc_1950_m=ln(rgdppc_1950_m)
label var ln_rgdppc_1950_m "Log real GDP per person 1950 --- Maddison"
gen ln_rgdppc_1975_m=ln(rgdppc_1975_m)
label var ln_rgdppc_1975_m "Log real GDP per person 1975 --- Maddison"
gen ln_rgdppc_2000_m=ln(rgdppc_2000_m)
label var ln_rgdppc_2000_m "Log real GDP per person 2000 --- Maddison"
gen ln_rgdppc_1950_2000_m=ln(rgdppc_1950_2000_m)
label var ln_rgdppc_1950_2000_m "Log real GDP per person 1950--2000 average --- Maddison"
* diamonds
gen diamonds = gemstones/(land_area/100)
label var diamonds   "Diamonds"
* slave exports
gen ln_slave_exports_area=ln(1+slave_exports/(land_area/100))
label var ln_slave_exports_area "Slave export intensity"
* historical population density
gen ln_pop_dens1400=ln(1+pop_1400/(land_area/100))
label var ln_pop_dens1400 "Log pop. density 1400"
* ruggedness - africa interactions
gen rugged_x_africa=rugged*cont_africa
label var rugged_x_africa        "Ruggedness $\cdot I^{\text{Africa}}$"
for @ in any n s e w c: gen rugged_x_africa_@=rugged*africa_region_@
label var rugged_x_africa_n "Ruggedness $\cdot I^{\text{North Africa}}$"
label var rugged_x_africa_s "Ruggedness $\cdot I^{\text{South Africa}}$"
label var rugged_x_africa_e "Ruggedness $\cdot I^{\text{East Africa}}$"
label var rugged_x_africa_w "Ruggedness $\cdot I^{\text{West Africa}}$"
label var rugged_x_africa_c "Ruggedness $\cdot I^{\text{Central Africa}}$"
* ruggedness - colonizer interactions
for @ in any esp gbr fra prt oeu: gen rugged_x_colony_@=rugged*colony_@
label var rugged_x_colony_esp "Ruggedness $\cdot I^{\text{Spanish col. orig.}}$"
label var rugged_x_colony_gbr "Ruggedness $\cdot I^{\text{British col. orig.}}$"
label var rugged_x_colony_fra "Ruggedness $\cdot I^{\text{French col. orig.}}$"
label var rugged_x_colony_prt "Ruggedness $\cdot I^{\text{Portuguese col. orig.}}$"
label var rugged_x_colony_oeu "Ruggedness $\cdot I^{\text{Other European col. orig.}}$"
* ruggedness - legal origin interactions
for @ in any gbr fra deu sca soc: gen rugged_x_legor_@=rugged*legor_@
label var rugged_x_legor_gbr "Ruggedness $\cdot I^{\text{Common law}}$"
label var rugged_x_legor_fra "Ruggedness $\cdot I^{\text{French civil law}}$"
label var rugged_x_legor_deu "Ruggedness $\cdot I^{\text{German civil law}}$"
label var rugged_x_legor_sca "Ruggedness $\cdot I^{\text{Scandinavian law}}$"
label var rugged_x_legor_soc "Ruggedness $\cdot I^{\text{Socialist law}}$"
* ruggedness - geography interactions
for @ in any tropical soil: gen rugged_x_@=rugged*@
label var rugged_x_tropical "Ruggedness $\cdot$ \% Tropical cl."
label var rugged_x_soil     "Ruggedness $\cdot$ \% Fertile soil"
* africa - geography interactions
for @ in any soil tropical dist_coast diamonds: gen @_x_africa=@*cont_africa
label var tropical_x_africa    "\% Tropical climate $\cdot I^{\text{Africa}}$"
label var dist_coast_x_africa  "Distance to coast $\cdot I^{\text{Africa}}$"
label var soil_x_africa        "\% Fertile soil $\cdot I^{\text{Africa}}$"
label var diamonds_x_africa    "Diamonds $\cdot I^{\text{Africa}}$"
* africa - legal origin interactions
for @ in any gbr fra: gen legor_@_x_africa=legor_@*cont_africa
label var legor_gbr_x_africa " $ I^{\text{Common law}} \cdot I^{\text{Africa}}$"
label var legor_fra_x_africa " $ I^{\text{French civil law}} \cdot I^{\text{Africa}}$"
* re-label variables for tables
label var rugged     "Ruggedness"
label var tropical   "\% Tropical climate"
label var dist_coast "Distance to coast"
label var soil       "\% Fertile soil"
label var desert     "\% Desert"
label var dist_slavemkt_saharan  "Dist. Saharan slave market"
label var dist_slavemkt_atlantic "Dist. Atlantic slave market"
label var dist_slavemkt_redsea   "Dist. Red Sea slave market"
label var dist_slavemkt_indian   "Dist. Indian slave market"
label var rugged_popw "Ruggedness (pop. weighted)"
label var africa_region_n " $ I^{\text{North Africa}}$"
label var africa_region_s " $ I^{\text{South Africa}}$"
label var africa_region_e " $ I^{\text{East Africa}}$"
label var africa_region_w " $ I^{\text{West Africa}}$"
label var africa_region_c " $ I^{\text{Central Africa}}$"
label var cont_africa        " $ I^{\text{Africa}}$"
label var colony_esp " $ I^{\text{Spanish col. orig.}}$"
label var colony_gbr " $ I^{\text{British col. orig.}}$"
label var colony_fra " $ I^{\text{French col. orig.}}$"
label var colony_prt " $ I^{\text{Portuguese col. orig.}}$"
label var colony_oeu " $ I^{\text{Other European col. orig.}}$"
label var legor_gbr " $ I^{\text{Common law}}$"
label var legor_fra " $ I^{\text{French civil law}}$"
label var legor_deu " $ I^{\text{German civil law}}$"
label var legor_sca " $ I^{\text{Scandinavian law}}$"
label var legor_soc " $ I^{\text{Socialist law}}$"


* define standard set of controls: Control by geographic and economics variables
local stdcontrols " pop_growth2005 ln_GDP slave_exports diamonds diamonds_x_africa soil soil_x_africa tropical tropical_x_africa dist_coast dist_coast_x_africa"

/* table 1: the differential effects of natural rents */
* table 1, column (1)
reg life_expectancy naturalrents q_rule_law naturalrents_x_cont_africa  ln_slave_exports_area schooling ln_GDP pop_growth2005 rugged rugged_x_africa cont_africa, robust
outreg2 using myreg.doc, replace  
* table 1, column (2)
reg life_expectancy  naturalrents q_rule_law naturalrents_x_cont_africa naturalrents_x_q_rule_law ln_slave_exports_area schooling ln_GDP pop_growth2005 rugged rugged_x_africa cont_africa  dist_coast dist_coast_x_africa, robust
outreg2 using myreg.doc, append 
* table 1, column (3)
reg  life_expectancy  naturalrents q_rule_law  naturalrents_x_cont_africa q_rule_law_x_cont_africa  ln_slave_exports_area schooling ln_GDP pop_growth2005 rugged rugged_x_africa cont_africa dist_coast dist_coast_x_africa, robust
outreg2 using myreg.doc, append 


********** Replicate Table 5 of the paper ***********
clear all
cd ""

use rugged_data.dta
// Generate labels
gen ln_rgdppc_2000=ln(rgdppc_2000)
gen diamonds = gemstones/(land_area/100)
gen diamonds_x_africa=diamonds*cont_africa
gen ln_slave_exports_area=ln(1+slave_exports/(land_area/100))
gen ln_pop_dens1400=ln(1+pop_1400/(land_area/100))
gen rugged_x_africa=rugged*cont_africa
gen soil_x_africa = soil*cont_africa
gen tropical_x_africa = tropical*cont_africa
gen dist_coast_x_africa = dist_coast*cont_africa

/* table 5: the impact and determinants of slave exports */
* table 5, column (1)
reg ln_rgdppc_2000 ln_slave_exports_area rugged rugged_x_africa cont_africa, robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", replace
* table 5, column (2)
reg ln_rgdppc_2000 ln_slave_exports_area rugged cont_africa, robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append
* table 5, column (3)
reg ln_rgdppc_2000 ln_slave_exports_area rugged rugged_x_africa cont_africa diamonds diamonds_x_africa soil soil_x_africa tropical tropical_x_africa dist_coast dist_coast_x_africa `stdcontrols', robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append
* table 5, column (4)
reg ln_rgdppc_2000 ln_slave_exports_area rugged cont_africa diamonds diamonds_x_africa soil soil_x_africa tropical tropical_x_africa dist_coast dist_coast_x_africa `stdcontrols', robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append
* table 5, column (5)
reg ln_slave_exports_area rugged if cont_africa == 1 & !missing(ln_rgdppc_2000), robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append
* table 5, column (6)
reg ln_slave_exports_area rugged diamonds soil tropical dist_coast if cont_africa == 1 & !missing (ln_rgdppc_2000), robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append
* table 5, column (7)
reg ln_slave_exports_area rugged diamonds soil tropical dist_coast ln_pop_dens1400 dist_slavemkt* if cont_africa == 1 & !missing(ln_rgdppc_2000), robust
outreg2 using "C:/Users/Antti/Desktop/Tapa Ittes Vitun Hintti/RT", append











