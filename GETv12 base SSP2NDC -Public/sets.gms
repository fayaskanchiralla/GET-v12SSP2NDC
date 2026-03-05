*### SETS ###

sets

t_a     / 1800, 1810, 1820, 1830, 1840, 1850, 1860, 1870, 1880, 1890,
          1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990,
          2000, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090,
          2100, 2110, 2120, 2130, 2140 ,2150 /

t (t_a) /  2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080,
          2090, 2100, 2110, 2120, 2130, 2140, 2150 /

t_h(t_a) / 1800, 1810, 1820, 1830, 1840, 1850, 1860, 1870, 1880, 1890,
           1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980 ,1990, 2000/

t_1 (t) / 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080,
          2090, 2100, 2110, 2120, 2130 /

t_ext (t) / 2110,2120,2130,2140, 2150 /

init_year (t) / 2010/
end_year (t) /2100/
scen/ 400, 450, 500/

reg /EUR, NAM, PAO, FSU, LAM, CPA, AFR, SAS, PAS, MEA/
OECD(reg)/EUR, NAM, PAO/
MIC(reg) /FSU, LAM, CPA/
ROW(reg) /AFR, SAS, PAS, MEA/
reg_imp(reg)/EUR, NAM, PAO, FSU, LAM, CPA, AFR, SAS, PAS, MEA/
reg_exp(reg)/EUR, NAM, PAO, FSU, LAM, CPA, AFR, SAS, PAS, MEA/
NDC_2050(reg)/EUR, NAM, PAO,LAM/
NDC_2060(reg)/CPA,AFR,FSU,MEA,PAS/
NDC_2070(reg)/SAS/
* NNN the star syntax defines a sequence of elements: /c1*c5/ = /c1,c2,c3,c4,c5/
class /c1*c5/


* use this for k-means clusters
*$ontext
allslices /s01*s99/
;


scalar numclusters /16/;

set slice(allslices);
slice(allslices) $ (ord(allslices) <= numclusters) = yes;
*$offtext


* use this for solar & wind slices
$ontext
allslices /s10,s11*s19,s1A,s1B,s1C,s1D,s1E,s1F,
              s21*s29,s2A,s2B,s2C,s2D,s2E,s2F,
              s31*s39,s3A,s3B,s3C,s3D,s3E,s3F,
              s41*s49,s4A,s4B,s4C,s4D,s4E,s4F,
              s51*s59,s5A,s5B,s5C,s5D,s5E,s5F,
              s61*s69,s6A,s6B,s6C,s6D,s6E,s6F,
              s71*s79,s7A,s7B,s7C,s7D,s7E,s7F,
              s81*s89,s8A,s8B,s8C,s8D,s8E,s8F,
              s91*s99,s9A,s9B,s9C,s9D,s9E,s9F,
              sA1*sA9,sAA,sAB,sAC,sAD,sAE,sAF,
              sB1*sB9,sBA,sBB,sBC,sBD,sBE,sBF,
              sC1*sC9,sCA,sCB,sCC,sCD,sCE,sCF,
              sD1*sD9,sDA,sDB,sDC,sDD,sDE,sDF,
              sE1*sE9,sEA,sEB,sEC,sED,sEE,sEF,
              sF1*sF9,sFA,sFB,sFC,sFD,sFE,sFF /
;


scalar numsolarslices /3/;
scalar numwindslices /3/;

set slice(allslices);
slice(allslices) $ ((mod(ord(allslices)-2, 15) < numwindslices) and (floor((ord(allslices)-2)/15) < numsolarslices)) = yes;
slice('s10') = no;
$offtext





sets

energy /oil1,oil2,oil3, bio, bio1, bio2, bio3,hydro, wind, solar, gas1, gas2, gas3, oil, coal1,coal2, coal,
          MeOH, H2,  elec, petro, air_fuel,trsp, pellets, CH4 , central_heat, dist_heat, solid_heat
         non_solid_heat, feed-stock,  uranium1, uranium2, uranium3, uranium4, uranium5, biogas, ethanol, biodiesel,
          PuR, EU4, EU1, Pu,FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf, waste, CANDUw, MOXw, Brwaste,
          windonshoreA, windonshoreB, windoffshore, pvrooftop, pvplantA, pvplantB, cspplantA, cspplantB,
          storage_12h, storage_24h, storage_48h, storage_96h, air, CO2, NH3, LCH4, LH2, CH2,agrifeedstock /
          
carbonsource(energy)/CH4,coal,oil,bio,air/

sector(energy) /elec, central_heat, dist_heat, solid_heat
         non_solid_heat, feed-stock ,h2,  MeOH, biogas, ethanol, biodiesel,oil, NH3, LCH4, LH2, CH2,agrifeedstock  /

solid_heat_elec(sector)  /elec, solid_heat /

en_in (energy)  / oil2, oil1,oil3, coal1, coal2,  bio1, bio2, bio3, bio, hydro, wind, solar, gas1, gas2, gas3, oil, coal,
                   MeOH, biogas, ethanol, biodiesel, H2, elec, petro, air_fuel, CH4, pellets, uranium1, uranium2, uranium3, uranium4, uranium5,
                  PuR, EU4, EU1, Pu, FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf,
                  windonshoreA, windonshoreB, windoffshore, pvrooftop, pvplantA, pvplantB, cspplantA, cspplantB,
                  storage_12h, storage_24h, storage_48h, storage_96h, air, NH3, LCH4, LH2, CH2 /

end_use(energy)    / central_heat, dist_heat, solid_heat
                 non_solid_heat, feed-stock,agrifeedstock/

en_out (energy)  / oil,  elec, MeOH, biogas, ethanol, biodiesel, H2,  petro, air_fuel ,trsp, CH4, coal, central_heat, dist_heat, solid_heat
                 non_solid_heat, feed-stock,agrifeedstock, pellets, bio, EU4, EU1, Pu, FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf, waste, CANDUw, MOXw, PuR, Brwaste, NH3, LCH4, LH2, CH2, CO2/

elecsector(en_out) / trsp, central_heat, dist_heat, solid_heat, non_solid_heat /
* H2 modelled separately
sliced_H2(en_in) /bio, biogas, CH4, coal, elec, oil, petro, solar/
sliced_H2_no_elec(en_in) /bio, biogas, CH4, coal, oil, petro, solar/

thermalelec(en_in) / bio, oil, CH4, coal, EU4, EU1, FBF, MOX, hydro /

class_tech(en_in) / windonshoreA, windonshoreB, windoffshore, pvrooftop, pvplantA, pvplantB, cspplantA, cspplantB /

storage_tech(energy) / storage_12h, storage_24h, storage_48h, storage_96h /

no_stock(energy) /sLWRf, BrProd, sMoxf, sCanduf,Rep1, Rep2, Rep3/

nuclear_fuel(energy) /  sLWRf, BrProd, sMoxf, sCanduf,FBF, MOX, Rep1, Rep2, Rep3 ,EU4, EU1, Pu, PuR ,uranium1, uranium2, uranium3, uranium4, uranium5   /

no_stock1(en_in) /sLWRf, BrProd, sMoxf, sCanduf, Rep1, Rep2, Rep3 /

wastes(en_out) /waste, MOXw, CANDUw, Brwaste/

Rep(en_in) /Rep1, Rep2, Rep3/

sector1(en_out) /elec, central_heat, dist_heat, solid_heat
         non_solid_heat, feed-stock/

solid(en_in) /bio, pellets, coal/
dec_heat(en_out) /central_heat, solid_heat, non_solid_heat/

heat(en_out) /central_heat, dist_heat/

cg_fuel (en_in)  / bio, CH4,biogas, oil, coal, H2 /

primary (en_in) / bio1, bio2, bio3, hydro, wind, solar, gas1, gas2, gas3, oil2,  oil1,oil3, coal1, coal2,
                  uranium1, uranium2, uranium3, uranium4, uranium5 /

second_in (energy) / bio, oil, elec, MeOH, biogas, ethanol, biodiesel, petro, air_fuel, coal, pellets, EU4, EU1, Pu, FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf, NH3, CH4, LCH4, LH2, CH2,H2 /
*We might need a specific set including only energy carriers that can be traded between regions

*MOL: set created for the equation nuclear_gen(second_in,reg,t) to make sure that picks the nuclear reactors included in second_in
nuclear_just (second_in) / EU4, EU1, Pu, FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf /

no_stock2(second_in) /air_fuel, NH3/

calibration_set (energy) / bio, hydro, wind, solar, oil, H2, elec, MeOH, biogas, ethanol, biodiesel, petro, air_fuel, CH4, coal, pellets, EU4, EU1, Pu, FBF, MOX, Rep1, Rep2, Rep3, sLWRf, BrProd, sCANDUf, sMoxf /

fuels (primary) / bio1, bio2, bio3, coal1, coal2, oil1, oil2,oil3, gas1, gas2, gas3, uranium1, uranium2, uranium3, uranium4, uranium5 /

stock (primary) /coal1, coal2, oil1, oil2,oil3, gas1, gas2, gas3, uranium1, uranium2, uranium3, uranium4, uranium5/

oil_fuel(energy) /oil1, oil2, oil3, petro, oil/
natural_gas(energy) /gas1, gas2, gas3/
c_fuel (energy) /  coal, oil, CH4 /
ccs_fuel (energy) /  coal, oil, CH4 , bio, biogas, pellets/

*MOL: not considering oil as feedstock, reccommendation of FUTNERC (14/02/2025)
*From the current perspective, and according to FUTNERC input, at the moment very little chemical industries use directly crude oil to produce e.g., plastics), and the ones that use have some kind of internal processing.
*Accordingly, at the moment, crude oil is not being directly used as feedstock, but instead petro represented refined oil that can be used directly as feedstock.
*Added ammonia as feedstock - fertilizers
*For future work, looking at the possibility of CH4 being also used to produce petro (paper 4 Maria OL)

feed(energy) /coal, petro, MeOH, biogas, ethanol, biodiesel, CH4, oil/


type           /  0, cg, dec, cg_dec /
C_capt (type)  / dec, cg_dec/
CG_type (type) / cg, cg_dec /


trsp_fuel (energy)             / elec, MeOH, biogas, ethanol, biodiesel, petro, NH3, LCH4, LH2, CH2, CH4/
road_fuel_liquid(trsp_fuel)    / MeOH, biogas, ethanol, biodiesel,  petro, CH2, LCH4 /
FC_fuels (trsp_fuel)           /MeOH, NH3, LCH4, LH2, CH2/
need_pilot(trsp_fuel)          /NH3, LCH4, LH2, CH2/
can_be_pilot(trsp_fuel)        /petro, MeOH/
zero_fuels(trsp_fuel) /elec, MeOH, NH3, LH2, CH2/

engine_type   / 0, FC , hyb, BEV, PHEV, FCREEV/
elec_veh(engine_type) /BEV, PHEV, FCREEV/
non_phev(engine_type) /   0, FC , hyb, BEV/
IC_FC(engine_type) /0, FC/

trsp_mode  /p_car, p_air_short, p_air_medium, p_air_long, p_bus, p_rail, f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, f_air, f_rail, f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, p_ferry_short, p_ferry_long,f_othership/
trsp_mode_no_train (trsp_mode) /p_car, p_air_short, p_air_medium, p_air_long, p_bus, f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, f_air, f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, p_ferry_short, p_ferry_long,f_othership/
car_truck_ships (trsp_mode)    / p_car, f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, p_bus, f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, p_ferry_short, p_ferry_long, f_othership /
car_or_truck (trsp_mode) / p_car, f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, p_bus/
heavy_mode (trsp_mode) /  f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, p_ferry_short, p_ferry_long, f_othership /
Engine4S(trsp_mode) /f_cargo_short, p_ferry_short, p_ferry_long, f_othership/
Engine2S(trsp_mode) /f_container, f_cargo_bulk, f_oiltanker, f_gastanker/
frgt_mode (trsp_mode)   / f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, f_air, f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, f_rail, f_othership /
freight_bus_mode (trsp_mode)  / f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD, p_bus, f_container, f_cargo_bulk, f_oiltanker, f_gastanker, f_cargo_short, p_ferry_short, p_ferry_long, f_othership /
air_mode (trsp_mode) / p_air_short, p_air_medium, p_air_long, f_air /
truck(trsp_mode)/f_LCV, f_MDT_LH, f_MDT_RD, f_HDT_LH , f_HDT_RD/
car_or_bus(trsp_mode) /p_car,p_bus/
;

alias (t_a, t_b);
alias (slice, slice2);
