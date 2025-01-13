Appendix G:
Victoria B. Pogonyaylova EBGN 590A
Program File for Technical Consulting Report
import delimited "C:\users\crossover\My Documents\Studies\EBGN590_Econometrics\Project due mid April\Econometric Analysis Data.csv"
//initial data imported from BlackBoard
gen VMT=vmt_state*1000000
gen VMA=VMT/adult_pop
gen vma=ln(VMA)
gen VEH=(no_auto+no_truck)/adult_pop
gen veh=ln(VEH)
gen F=fuel_intensity
gen PF=(gas_price+state_gas_tax+fed_gas_tax)/(cpi_87/100)
gen PM=PF*F
gen ln_PM=ln(PM)
egen mean_lnPM=mean(ln(PM))
gen pm=ln(PM)-mean_lnPM
gen INC=(state_income/(cpi_87/100))/state_population
gen ln_INC=ln(INC)
egen mean_ln_INC=mean(ln(INC))
gen inc=ln_INC-mean_ln_INC
gen ARM=adult_pop/road_mileage
gen arm=ln(ARM)
gen POPA=state_population/adult_pop
gen popa=ln(POPA)
gen URB=urbanization
egen mean_URB=mean(URB)
gen urb=URB-mean_URB
rename railpop RAILPOP
gen D7479=0
replace D7479=1 if year==1974
replace D7479=1 if year==1979
gen TREND=year-1966
gen pf=ln(PF)
gen PV=new_car_price/100
gen pv=ln(PV)
gen LA=lic_driver/adult_pop
gen la=ln(LA)
rename cafe_strictness cafe
summarize VMT VMA vma VEH veh F PF PM pm INC inc ARM arm POPA popa URB urb RAILPOP D7479 TREND pf PV pv LA la cafe
format VMT VMA vma VEH veh F PF PM pm INC inc ARM arm POPA popa URB urb RAILPOP D7479 TREND pf PV pv LA la cafe %09.3fc
summarize VMT VMA vma VEH veh F PF PM pm INC inc ARM arm POPA popa URB urb RAILPOP D7479 TREND pf PV pv LA la cafe, format
xtset id year
reg vma pm veh inc arm popa urb RAILPOP D7479 TREND
xtreg vma pm veh inc arm popa urb RAILPOP D7479 TREND, fe
gen pm2=pm^2
gen inc_pm=inc*pm
gen urb_pm=urb*pm
xtreg vma pm pm2 inc_pm urb_pm veh inc arm popa urb RAILPOP D7479 TREND, fe
gen rebound=_b[pm]+_b[pm2]*pm*2+_b[inc_pm]*inc+_b[urb_pm]*urb
sum rebound

sort year
by year: egen rebound_a_yr=mean(rebound)
sum rebound_a_yr if id==1

by year: egen yearmean=mean(rebound)
by year: egen yearmin=min(rebound)
by year: egen yearmax=max(rebound)
list year yearmean yearmin yearmax if id==1
tsline yearmean yearmax yearmin if id==1

sort state
by state: egen rebound_a_state=mean(rebound)
sum rebound_a_state if year==2000

by state: egen statemean=mean(rebound)
by state: egen statemin=min(rebound)
by state: egen statemax=max(rebound)
list state statemean statemax statemin if year==2000

reg vma pm veh inc arm popa urb RAILPOP D7479 TREND 
estimates store m1, title(Ordinary Least Squares)
xtreg vma pm veh inc arm popa urb RAILPOP D7479 TREND, fe
estimates store m2, title(State-Level Fixed Effect)
xtreg vma pm pm2 inc_pm urb_pm veh inc arm popa urb RAILPOP D7479 TREND, fe
estimates store m3, title(A Variable Cofficient Model with Fixed Effect)
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)) t(star fmt(3))) legend label varlabels(_cons constant)stats(r2 df_r bic, fmt(3 0 1) label(R-sqr dfres BIC))
