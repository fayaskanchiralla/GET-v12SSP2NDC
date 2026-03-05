Sets
metatypes /date, filename, extime, objvalue, CO2curve, allowedCCS/

parameters
metainfo(metatypes)
report_tot_cost
report_c(*,reg,t)
report_capital(reg, en_in, en_out, type, t)
report_supply1(reg, *,t)
report_import(reg, second_in, t)
report_export(reg, second_in, t)
report_engines(reg, car_truck_ships, engine_type,trsp_fuel,  t)
report_ships(reg, heavy_mode, engine_type,trsp_fuel,  t)
report_invest(reg,en_in, en_out, type, t)
infrastruc(reg, trsp_fuel, t)
report_transport_energy(reg, trsp_mode, trsp_fuel,engine_type, t)
report_en_conv(reg, en_in, en_out, type, t)
report_marginals(*,reg, primary,t)
end_use_price(sector,reg,t)
invest_gdp(*,t)
total_cap(t)
demand_out(reg, *,t)
report_elec_gen(en_in,type,reg,allslices,t)
total_elec_gen(reg,allslices,t)
report_elec_use(reg,elecsector,allslices,t)
report_lfs(en_in, type,reg,allslices)
report_slice_lng(reg,allslices)
report_capital_region(en_in, type, reg, t)
report_elec_gen_slice(en_in,type,reg,t,allslices)
report_elec_gen_summedslices(en_in,type,reg,t)
report_storage_transfers_2100(storage_tech,reg,allslices,allslices)
report_from_storage(t,reg,allslices)
report_to_storage(t,reg,allslices)
report_capital_class(class_tech,class,reg,t)
report_elec_solarwind(class_tech,reg,allslices,t)
report_elec_class_slice(class_tech,class,reg,allslices,t)
potential_generation(en_in,type,reg,allslices,t)
curtailment(en_in,type,reg,t,allslices)
report_H2_prod(sliced_H2,type,reg,allslices,t)
potential_production_h2(reg,t)
production_h2(reg,t)
lf_el2h2(reg,t)
MeOH2airfuel(reg,t)

feed_stock(reg, en_in,type,t)
non_solid_heat(reg, en_in,type, t)
solid_heat(reg, en_in,type,t)
rural_heat(reg, en_in,type,t)
urban_heat(reg,en_in,*,t)
elec(reg,calibration_set,type,t)
nuclear(reg, nuclear_fuel, en_out,type,t)
H2(reg, en_in,type,t)
NH3(reg, en_in,type,t)
MeOH(reg, en_in,type,t)
LCH4(reg, en_in,type,t)
CH4(reg, en_in,type,t)
biomass(reg, en_out,type,t)
NG(reg, en_out,type,t)
Coal(reg, en_out,type,t)
h2_use(reg, en_out,t)
MeOH_use(reg, en_out,t)
oils(reg, oil_fuel, en_out,type,t)
prices(*,reg,t)
cc(reg, en_out,t)
cs(reg,t)
transp_energy(reg, trsp_fuel,t)
transp_km(reg,trsp_mode, trsp_fuel, t)
emission(reg, en_out,t)
marginal_el_price(reg,allslices,t)
report_ship_emis(reg,t)
test_1(en_out,en_in, type, reg,t)
test_2(en_out,en_in, type, reg,t)
test_3(trsp_fuel, engine_type, car_truck_ships, t)
test_4(reg,t)
test_5(class,reg,allslices,t)
liquids(reg,en_in,t)
ship_energy(reg,trsp_fuel, t)
air_energy(reg,air_mode,trsp_fuel,t)
air_energy_2(reg,air_mode,trsp_fuel,engine_type, t)
report_eng_invest(reg,trsp_mode,trsp_fuel, engine_type,  t)

report_Upp_Emis_Elec_Avr(reg,t)
report_Upp_Emis_H2_Avr(reg,t)
report_Upp_Emis_MeOH_Avr(reg,t)

emis_LC_MeOH_0(energy,reg,t)
emis_LC_MeOH_cc(energy,reg,t)
;

parameter emis_count(en_in) /
CH4   15.4
petro 22
oil   20
coal  24.7
bio   0
/;


report_tot_cost = tot_cost.l+eps;
report_supply1(reg, primary,t) = supply_1.L(primary,reg, t)+eps;
*report_supply1(reg, Rep1,t) = sum((en_out,type), en_conv.l(Rep,en_out, type, reg, t))+eps;
*report_supply1(reg, "PuR",t) = sum((en_out,type), en_conv.l("PuR",en_out, type, reg, t))+eps;
report_import(reg, second_in, t)=import.l(second_in, reg, t)+eps;
report_export(reg, second_in, t)=export.l(second_in, reg, t)+eps;
report_c("CO2 emissions",reg,t) = c_emission.L(reg,t)+eps;
report_c("CO2 concentration",reg,t) = ATM_CCONT.L(t)+eps;
report_c("CO2 capture",reg,t) = C_capt_tot.L(reg, t)+eps;
report_c("emission.M",reg,t) = emission_Q.M(reg,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
report_c("annual cost",reg, t) = annual_cost.l(t);
report_capital(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) = capital.L(en_in, en_out, type,reg, t)+eps;
report_engines(reg, car_truck_ships, engine_type,trsp_fuel,  t)$trsp_conv(trsp_fuel, engine_type, car_truck_ships) = engines.l(trsp_fuel, engine_type, car_truck_ships,reg, t)+eps;
report_ships(reg, heavy_mode, engine_type,trsp_fuel,  t)$trsp_conv(trsp_fuel, engine_type, heavy_mode) = trsp_energy.l(trsp_fuel, engine_type, heavy_mode,reg, t)+eps;
report_invest(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) = cap_invest.l(en_in, en_out, type,reg, t)+eps;
end_use_price(sector,reg,t)=-deliv_q.m(sector,reg,t)*(1+r)**((ord(t)-1)*t_step)/t_step +eps  ;
report_transport_energy(reg,trsp_mode,trsp_fuel,engine_type, t) = trsp_energy.L(trsp_fuel, engine_type, trsp_mode,reg, t)+eps;
transp_energy(reg, trsp_fuel,t) = sum((engine_type,trsp_mode), trsp_energy.L(trsp_fuel, engine_type, trsp_mode, reg,t))+eps;
ship_energy(reg,trsp_fuel, t)= sum((engine_type,heavy_mode), trsp_energy.L(trsp_fuel, engine_type, heavy_mode, reg,t))+eps;
air_energy(reg,air_mode,trsp_fuel, t)= sum((engine_type), trsp_energy.L(trsp_fuel, engine_type, air_mode, reg,t))+eps;
air_energy_2(reg,air_mode,trsp_fuel,engine_type, t)= trsp_energy.L(trsp_fuel, engine_type, air_mode, reg,t)+eps;
transp_km(reg, trsp_mode,trsp_fuel, t) =sum(engine_type, trsp_energy.L(trsp_fuel, engine_type, trsp_mode, reg,t)*trsp_conv(trsp_fuel, engine_type, trsp_mode))+eps   ;
report_en_conv(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) =  en_conv.L(en_in, en_out, type, reg,t)+eps;
nuclear(reg, nuclear_fuel, en_out,type,t)$ effic(nuclear_fuel, en_out, type, reg,t)  =   en_conv.L(nuclear_fuel, en_out, type, reg,t)*effic(nuclear_fuel, en_out, type, reg,t)+eps;
oils(reg, oil_fuel, en_out,type,t)$effic(oil_fuel, en_out, type, reg,t)  =   en_conv.L(oil_fuel, en_out, type, reg,t)*effic(oil_fuel, en_out, type, reg,t)+eps;
feed_stock(reg, en_in,type,t)$effic(en_in, "feed-stock", type, reg,t)= en_conv.l(en_in, "feed-stock", type,reg, t) * effic(en_in, "feed-stock", type, reg,t) + eps;
liquids(reg, en_in,t)=sum(type, en_conv.l(en_in, "trsp", type,reg, t) * effic(en_in, "trsp", type, reg,t))+ sum(type, en_conv.l(en_in, "feed-stock", type,reg, t) * effic(en_in, "feed-stock", type, reg,t)) + eps;
non_solid_heat(reg, en_in,type, t)$effic(en_in, "non_solid_heat", type,reg, t)= en_conv.l(en_in, "non_solid_heat", type,reg, t) * effic(en_in, "non_solid_heat", type,reg, t)+ eps;
solid_heat(reg, en_in, type,t)$effic(en_in, "solid_heat", type,reg, t)= en_conv.l(en_in, "solid_heat", type,reg,t) * effic(en_in, "solid_heat", type,reg, t)+ eps ;
rural_heat(reg, en_in,type,t)$effic(en_in, "dist_heat", type, reg,t)= en_conv.l(en_in, "dist_heat", type, reg,t) * effic(en_in, "dist_heat", type, reg,t)+ eps;
urban_heat(reg, en_in,type,t)$effic(en_in, "central_heat", type, reg,t)= en_conv.l(en_in, "central_heat", type, reg,t) * effic(en_in, "central_heat", type, reg,t) + eps;
urban_heat(reg, en_in,"waste_heat",t)=  sum( cg_type, en_conv.l(en_in, "elec", cg_type,reg, t)*heat_effic(en_in, cg_type, "elec","central_heat")   )+ eps;
elec(reg, calibration_set ,type, t)$effic(calibration_set, "elec", type,reg, t)= en_conv.l(calibration_set, "elec", type, reg,t) * effic(calibration_set, "elec", type,reg, t)+ eps;
h2(reg, en_in,type, t)$effic(en_in, "h2", type, reg,t)=en_conv.l(en_in, "h2", type, reg,t) * effic(en_in, "h2", type, reg,t)+ eps;
NH3(reg, en_in,type, t)$effic(en_in, "NH3", type, reg,t)=en_conv.l(en_in, "NH3", type, reg,t) * effic(en_in, "NH3", type, reg,t)+ eps;
MeOH(reg, en_in,type, t)$ effic(en_in, "MeOH", type,reg, t)= en_conv.l(en_in, "MeOH", type, reg,t) * effic(en_in, "MeOH", type,reg, t)+ eps;
LCH4(reg, en_in,type, t)$ effic(en_in, "LCH4", type,reg, t)= en_conv.l(en_in, "LCH4", type, reg,t) * effic(en_in, "LCH4", type,reg, t)+ eps;
CH4(reg, en_in,type, t)$ effic(en_in, "CH4", type,reg, t)= en_conv.l(en_in, "CH4", type, reg,t) * effic(en_in, "CH4", type,reg, t)+ eps;
biomass(reg, en_out,type,t)$ effic("bio", en_out, type,reg, t)= en_conv.l("bio", en_out, type,reg, t)   +eps;
NG(reg, en_out,type,t)$ effic("CH4", en_out, type,reg, t)= en_conv.l("CH4", en_out, type,reg, t)    +eps;
Coal(reg, en_out,type,t)$ effic("coal", en_out, type,reg, t)= en_conv.l("coal", en_out, type,reg, t)    +eps;
h2_use(reg, en_out,t)$effic( "h2",en_out, "0", reg,t)= sum(type, en_conv.l("h2", en_out, type, reg,t) ) + eps;
MeOH_use(reg, en_out,t)$effic( "MeOH",en_out, "0", reg,t)= sum(type, en_conv.l("MeOH", en_out, type, reg,t) ) + eps;
prices(primary,reg,t)=supply_1_Q.m(primary, reg,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
report_elec_gen(en_in,type,reg,slice,t)$effic(en_in,"elec",type,reg,t)= elec_gen.l(en_in,type,reg,slice,t)+eps;
report_elec_gen_summedslices(en_in,type,reg,t)$effic(en_in,"elec",type,reg,t) = sum(slice, elec_gen.l(en_in,type,reg,slice,t))+eps;
report_elec_gen_slice(en_in,type,reg,t,slice)$effic(en_in, "elec", type, reg,t)= elec_gen.l(en_in,type,reg,slice,t)+eps;
total_elec_gen(reg,slice,t) = sum((en_in,type), elec_gen.l(en_in,type,reg,slice,t));
report_elec_use(reg,elecsector,slice,t) = elec_use.l(elecsector,reg,slice,t);
cc(reg, en_out,t)$ capt_effic("coal","dec",en_out)  =sum((C_capt,ccs_fuel), en_conv.l(ccs_fuel, en_out, C_capt,reg, t)*emis_fact(ccs_fuel)*capt_effic(ccs_fuel,c_capt,en_out)  )*t_step+
         sum( (C_capt),(en_conv.l("bio", en_out, C_capt,reg, t)*110 *capt_effic("bio",c_capt,en_out)+
         en_conv.l("biogas", en_out, C_capt,reg, t)*50 *capt_effic("biogas",c_capt,en_out)+
         en_conv.l("pellets", en_out, C_capt,reg, t)*80 *capt_effic("pellets",c_capt,en_out) ))*t_step  + eps;
cs(reg,t)  =  C_strg_tot.l(reg,t) + eps;
report_storage_transfers_2100(storage_tech,reg,slice,slice2) = storage_slice_transfer.l(storage_tech,reg,slice,slice2,"2100")+eps;
report_from_storage(t,reg,slice2) = sum((storage_tech,slice), storage_slice_transfer.l(storage_tech,reg,slice,slice2,t) * effic(storage_tech,"elec","0",reg,t))+eps;
report_to_storage(t,reg,slice) = sum((storage_tech,slice2), storage_slice_transfer.l(storage_tech,reg,slice,slice2,t))+eps;

* calculate curtailment
potential_generation(en_in,type,reg,slice,t) = slice_lng(reg,slice) * Msec_per_year *
                        capital.l(en_in,"elec",type,reg,t) * lfs(en_in,type,reg,slice,"elec");
potential_generation(class_tech,"0",reg,slice,t) = slice_lng(reg,slice) * Msec_per_year *
                        sum(class, capital_class.l(class_tech,class,reg,t) * lfsl(class_tech,class,reg,slice));
curtailment(en_in,type,reg,t,slice) $ effic(en_in,"elec",type,reg,t) =
                        max(eps, potential_generation(en_in,type,reg,slice,t) - elec_gen.l(en_in,type,reg,slice,t));
* calculate load factor for electrolyser
potential_production_h2(reg,t) =  Msec_per_year * capital.l("elec","H2","0",reg,t);
production_h2(reg,t) =  en_conv.L("elec","H2","0", reg,t)*effic("elec","H2","0", reg,t);
lf_el2h2(reg,t)=0;
lf_el2h2(reg,t)$ potential_production_h2(reg,t) = production_h2(reg,t)/potential_production_h2(reg,t);
MeOH2airfuel(reg,t) =  en_conv.L("MeOH","air_fuel","0", reg,t)*effic("MeOH","air_fuel","0", reg,t)+eps;

demand_out(reg, energy,t) = dem(energy,reg,t);
report_lfs(en_in, type,reg,slice)$effic(en_in, "elec", type, reg,"2070") = lfs(en_in , type,reg,slice, "elec");
report_slice_lng(reg,slice) = slice_lng(reg,slice);
report_capital_region(en_in, type, reg, t)$effic(en_in, "elec", type, reg,t) = capital.l(en_in, "elec", type,reg, t)+eps;
report_capital_class(class_tech,class,reg,t) = capital_class.l(class_tech,class,reg,t)+eps;
report_elec_solarwind(class_tech,reg,slice,t) = elec_gen.l(class_tech,"0",reg,slice,t)+eps;
report_elec_class_slice(class_tech,class,reg,slice,t) = elec_gen_class.l(class_tech,class,reg,slice,t)+eps;
marginal_el_price(reg,slice,t) = Elec_Deliv_Dem_Q.m(reg,slice,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
report_H2_prod(sliced_H2,type,reg,allslices,t)$effic(sliced_H2,"H2",type,reg,t) = H2_prod.l(sliced_H2,type,reg,allslices,t);
report_ship_emis(reg,t)=ship_emis.l(reg,t);

test_1(en_out,en_in, type, reg,t)=en_conv.l(en_in,en_out, type,reg,t)*emis_fact(en_in)*effic(en_in, en_out, type,reg,t);
test_2(en_out,en_in, type, reg,t)=en_conv.l(en_in,en_out, type,reg,t)*emis_fact(en_out)*effic(en_in, en_out, type,reg,t);
test_3(trsp_fuel, engine_type, car_truck_ships, t)= cost_eng(trsp_fuel, engine_type, car_truck_ships, t);
test_4(reg,t)=en_conv.l("H2","MeOH","0", reg, t)*emis_fact("MeOH")*(1-effic("H2","MeOH","0",reg,t));
test_5(class,reg,slice,t)=H2_prod_class.l(class,reg,slice,t) ;
*report_emis2(en_in, reg,t)= sum((type,en_out),en_conv.l(en_in,en_out, type,reg,t)*emis_fact(en_in));
report_eng_invest(reg,trsp_mode,trsp_fuel, engine_type,  t)=eng_invest.l(trsp_fuel, engine_type, trsp_mode, reg,t);

*h�r �r jag och jobbar nu
emis_LC_MeOH_0 (energy, reg,t)=emis_fact(energy);
emis_LC_MeOH_0 ("bio", reg, t)= -emis_fact("MeOH")*effic("bio", "MeOH", "0",reg,t);
emis_LC_MeOH_cc (energy, reg,t)=emis_fact(energy);
emis_LC_MeOH_cc ("bio", reg, t)= -emis_fact("MeOH")*effic("bio", "MeOH", "dec",reg,t);
*emis_LC_MeOH ("bio")= - emis_fact("MeOH")*effic("bio", "MeOH, type,reg,t)


report_Upp_Emis_Elec_Avr(reg,t)=
(sum(en_in, en_conv.l(en_in,"elec","0",reg,t)*emis_fact(en_in)+ en_conv.l(en_in,"elec","cg",reg,t)*emis_fact(en_in))
+ sum((c_capt,en_in), en_conv.l(en_in,"elec",c_capt,reg,t)*emis_fact(en_in)*(1-capt_effic(en_in, c_capt, "elec")))
- sum(c_capt, en_conv.l("bio", "elec", c_capt, reg, t)*110 *capt_effic("bio",c_capt,"elec"))
)/(energy_prod.l("elec", reg,t)+eps);

report_Upp_Emis_H2_Avr(reg,t)=
(sum(sliced_H2_no_elec, en_conv.l(sliced_H2_no_elec,"H2","0",reg,t)*emis_fact(sliced_H2_no_elec)
+ en_conv.l(sliced_H2_no_elec,"H2","cg",reg,t)*emis_fact(sliced_H2_no_elec))
+ sum((c_capt,sliced_H2_no_elec), en_conv.l(sliced_H2_no_elec,"H2",c_capt,reg,t)*emis_fact(sliced_H2_no_elec)*(1-capt_effic(sliced_H2_no_elec, c_capt, "H2")))
+ sum(type, en_conv.l("elec","H2",type,reg,t))* report_Upp_Emis_Elec_Avr(reg,t)
- sum(c_capt, en_conv.l("bio", "H2", c_capt, reg, t)*110 *capt_effic("bio",c_capt,"H2"))
)/(energy_prod.l("H2", reg,t)+eps);

report_Upp_Emis_MeOH_Avr(reg,t)=
(sum(sliced_H2_no_elec, en_conv.l(sliced_H2_no_elec,"MeOH","0",reg,t)*emis_LC_MeOH_0(sliced_H2_no_elec, reg,t)+ en_conv.l(sliced_H2_no_elec,"MeOH","cg",reg,t)*emis_LC_MeOH_0(sliced_H2_no_elec,reg,t))
+ sum((c_capt,sliced_H2_no_elec), en_conv.l(sliced_H2_no_elec,"MeOH",c_capt,reg,t)*emis_fact(sliced_H2_no_elec)*(1-capt_effic(sliced_H2_no_elec, c_capt, "MeOH")))
+sum(c_capt, en_conv.l("bio","MeOH",c_capt,reg,t)*emis_LC_MeOH_cc("bio",reg,t))
+ sum(type, en_conv.l("H2","MeOH",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))
-sum(c_capt, en_conv.l("bio", "MeOH", c_capt, reg, t)*110 *capt_effic("bio",c_capt,"MeOH"))
-(10*C_capt_air.l(reg,t)*(C_capt_tot.l(reg,t)-C_strg_tot.l(reg,t))/C_capt_tot.l(reg,t))
)/energy_prod.l("MeOH", reg,t)+eps;


metainfo("date")=jnow;
metainfo("extime")=TimeElapsed;
metainfo("objvalue")=GET_12.objval;


*$ontext
* To run ambitious

execute_unload "results.gdx" oils report_supply1 report_c report_capital report_engines report_ships report_invest report_elec_gen total_elec_gen elec_dem report_elec_use
        report_en_conv urban_heat elec h2 NH3 MeOH LCH4 CH4 report_transport_energy  nuclear feed_stock non_solid_heat solid_heat rural_heat end_use_price  report_elec_gen_slice
        demand_out biomass NG Coal h2_use prices cc cs transp_energy emission transp_km report_export report_import report_tot_cost report_lfs report_slice_lng
        report_capital_region report_storage_transfers_2100 report_from_storage report_to_storage report_capital_class report_elec_solarwind report_elec_class_slice
        curtailment report_elec_gen_summedslices marginal_el_price report_H2_prod C_capt_air.L energy_deliv.l energy_prod.l MeOH_use
         test_1 test_2 test_3 test_4 test_5 lf_el2h2 MeOH2airfuel report_ship_emis liquids metainfo ship_energy air_energy report_eng_invest
         import_from.l air_energy_2, report_Upp_Emis_Elec_Avr,report_Upp_Emis_H2_Avr,report_Upp_Emis_MeOH_Avr effic
         
execute 'gdxxrw.exe results.gdx @output_parameters.txt'
*$offtext


$ontext
* To run incremental

execute_unload "resultsincremental.gdx" oils report_supply1 report_c report_capital report_engines report_ships report_invest report_elec_gen total_elec_gen elec_dem report_elec_use
        report_en_conv urban_heat elec h2 NH3 MeOH LCH4 CH4 report_transport_energy  nuclear feed_stock non_solid_heat solid_heat rural_heat end_use_price  report_elec_gen_slice
        demand_out biomass NG Coal h2_use prices cc cs transp_energy emission transp_km report_export report_import report_tot_cost report_lfs report_slice_lng
        report_capital_region report_storage_transfers_2100 report_from_storage report_to_storage report_capital_class report_elec_solarwind report_elec_class_slice
        curtailment report_elec_gen_summedslices marginal_el_price report_H2_prod C_capt_air.L energy_deliv.l energy_prod.l MeOH_use
         test_1 test_2 test_3 test_4 test_5 lf_el2h2 MeOH2airfuel report_ship_emis liquids metainfo ship_energy air_energy report_eng_invest
         import_from.l air_energy_2, report_Upp_Emis_Elec_Avr,report_Upp_Emis_H2_Avr,report_Upp_Emis_MeOH_Avr effic

execute 'gdxxrw.exe resultsincremental.gdx @output_parameters.txt'
$offtext

$ontext
* To run conflictual

execute_unload "resultsconflictual.gdx" oils report_supply1 report_c report_capital report_engines report_ships report_invest report_elec_gen total_elec_gen elec_dem report_elec_use
        report_en_conv urban_heat elec h2 NH3 MeOH LCH4 CH4 report_transport_energy  nuclear feed_stock non_solid_heat solid_heat rural_heat end_use_price  report_elec_gen_slice
        demand_out biomass NG Coal h2_use prices cc cs transp_energy emission transp_km report_export report_import report_tot_cost report_lfs report_slice_lng
        report_capital_region report_storage_transfers_2100 report_from_storage report_to_storage report_capital_class report_elec_solarwind report_elec_class_slice
        curtailment report_elec_gen_summedslices marginal_el_price report_H2_prod C_capt_air.L energy_deliv.l energy_prod.l MeOH_use
         test_1 test_2 test_3 test_4 test_5 lf_el2h2 MeOH2airfuel report_ship_emis liquids metainfo ship_energy air_energy report_eng_invest
         import_from.l air_energy_2, report_Upp_Emis_Elec_Avr,report_Upp_Emis_H2_Avr,report_Upp_Emis_MeOH_Avr effic

execute 'gdxxrw.exe resultsconflictual.gdx @output_parameters.txt'
$offtext


$ontext


emission(reg, en_out,t)= sum((C_capt,ccs_fuel), en_conv.l(ccs_fuel, en_out, C_capt, reg,t)*emis_fact(ccs_fuel)*(1-capt_effic(ccs_fuel,c_capt,en_out) ) )-
                     sum(C_capt, en_conv.l("bio", en_out, C_capt, reg,t)*110*(1- capt_effic("bio",c_capt,en_out) ))
         +sum((non_ccs,en_in), en_conv.l(en_in, en_out, non_CCS, reg,t)*emis_count(en_in)  )+eps ;

$offtext
