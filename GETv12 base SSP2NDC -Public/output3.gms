Sets
metatypes /date, filename, extime, objvalue, CO2curve, allowedCCS/
;

Parameters
metainfo(metatypes)
report_tot_cost

*======= EMISSIONS & CARBON =======
report_c(*,reg,t)
emission(reg, en_out,t)
cc(reg, en_out,t)
cs(reg,t)
cc_flows(reg,carbonsource,t)

*======= ENERGY SUPPLY & CONVERSION =======
report_supply1(reg, *,t)
report_import(reg, second_in, t)
report_export(reg, second_in, t)
report_en_conv(reg, en_in, en_out, type, t)

*======= ELECTRICITY SECTOR =======
report_elec_gen_summedslices(en_in,type,reg,t)
report_capital_region(en_in, type, reg, t)
marginal_el_price(reg,allslices,t)
elprices(reg,t)
curtailment(en_in,type,reg,t,allslices)
report_from_storage(t,reg,allslices)
report_to_storage(t,reg,allslices)
report_elec_gen_slice(en_in,type,reg,t,allslices)
report_slice_lng(reg,allslices)

*======= TRANSPORT SECTOR =======
report_transport_energy(reg, trsp_mode, trsp_fuel,engine_type, t)
report_ship_emis(reg,t)
marg_cO2ship(heavy_mode,reg, t)
report_transport_mode_emis(reg, trsp_mode, t)
transp_km(reg,trsp_mode, trsp_fuel, t)

*======= FUEL PRODUCTION =======
H2(reg, en_in,type,t)
MeOH(reg, en_in,type,t)
NH3(reg, en_in,type,t)
h2_use(reg, en_out,t)
MeOH_use(reg, en_out,t)
NH3_use(reg, en_out,t)
petro_use(reg, en_out,t)
LCH4_use(reg, en_out,t)

*======= OTHER SECTORS =======
feed_stock(reg, en_in,type,t)
agrifeedstock(reg, en_in,type,t)
non_solid_heat(reg, en_in,type, t)
solid_heat(reg, en_in,type,t)
urban_heat(reg,en_in,*,t)
rural_heat(reg, en_in,type,t)

*======= INVESTMENT & CAPACITY =======
report_capital(reg, en_in, en_out, type, t)
report_invest(reg,en_in, en_out, type, t)

*======= UPSTREAM EMISSIONS =======
report_Upp_Emis_Elec_Avr(reg,t)
report_Upp_Emis_H2_Avr(reg,t)
report_Upp_Emis_MeOH_Avr(reg,t)
report_Upp_Emis_NH3_Avr(reg,t)
report_Upp_Emis_LH2_Avr(reg,t)
report_Upp_Emis_LCH4_Avr(reg,t)
report_Upp_Emis_CH2_Avr(reg,t)

*======= PRICES =======
prices(*,reg,t)
trsp_price(trsp_mode,reg,t)
marginal_fuel_price(en_out, reg, t) "USD/GJ"
trspfuel_price(trsp_fuel, trsp_mode, reg,t)
;
*======
*Code to prepare the outputparameters we want to analyse
*======

*To sheet Info
metainfo("date")=jnow;
metainfo("extime")=TimeElapsed;
metainfo("objvalue")=GET_12.objval;

*======= EMISSIONS & CARBON =======
report_c("CO2 emissions",reg,t) = c_emission.L(reg,t)+eps;
report_c("CO2 concentration",reg,t) = ATM_CCONT.L(t)+eps;
report_c("CO2 capture",reg,t) = C_capt_tot.L(reg, t)+eps;
report_c("emission.M",reg,t) = emission_Q.M(reg,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
report_c("abatement cost",reg, t) = 1000*emission_Q.m(reg, t)*((1+R)**((ord(t)-1)*t_step))/t_step;

cc(reg, en_out,t)$ capt_effic("coal","dec",en_out)  =sum((C_capt,ccs_fuel), en_conv.l(ccs_fuel, en_out, C_capt,reg, t)*emis_fact(ccs_fuel)*capt_effic(ccs_fuel,c_capt,en_out)  )+
         sum( (C_capt),(en_conv.l("bio", en_out, C_capt,reg, t)*110 *capt_effic("bio",c_capt,en_out)+
         en_conv.l("biogas", en_out, C_capt,reg, t)*50 *capt_effic("biogas",c_capt,en_out)+
         en_conv.l("pellets", en_out, C_capt,reg, t)*80 *capt_effic("pellets",c_capt,en_out) ))  + eps;

cs(reg,t)  =  C_strg_tot.l(reg,t) + eps;

cc_flows(reg,"coal",t)=sum((C_capt,en_out), en_conv.l("oil", en_out, C_capt,reg, t)*emis_fact(en_out)*capt_effic("oil",c_capt,en_out)  )+eps;
cc_flows(reg,"oil",t)=sum((C_capt,en_out), en_conv.l("oil", en_out, C_capt,reg, t)*emis_fact(en_out)*capt_effic("oil",c_capt,en_out)  )+eps;
cc_flows(reg,"CH4",t)=sum((C_capt,en_out), en_conv.l("CH4", en_out, C_capt,reg, t)*emis_fact(en_out)*capt_effic("CH4",c_capt,en_out)  )+eps;
cc_flows(reg,"bio",t)= sum( (C_capt, en_out),(en_conv.l("bio", en_out, C_capt,reg, t)*110 *capt_effic("bio",c_capt,en_out)+
en_conv.l("biogas", en_out, C_capt,reg, t)*50 *capt_effic("biogas",c_capt,en_out)+
en_conv.l("pellets", en_out, C_capt,reg, t)*80 *capt_effic("pellets",c_capt,en_out) ))  + eps;
cc_flows(reg,"air",t)=C_capt_air.l(reg, t) +eps;

*======= ENERGY SUPPLY & CONVERSION =======
report_supply1(reg, primary,t) = supply_1.L(primary,reg, t)+eps;
report_import(reg, second_in, t)=import.l(second_in, reg, t)+eps;
report_export(reg, second_in, t)=export.l(second_in, reg, t)+eps;
report_en_conv(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) =  en_conv.L(en_in, en_out, type, reg,t)+eps;

*======= ELECTRICITY SECTOR =======
report_elec_gen_summedslices(en_in,type,reg,t)$effic(en_in,"elec",type,reg,t) = sum(slice, elec_gen.l(en_in,type,reg,slice,t))+eps;
report_capital_region(en_in, type, reg, t)$effic(en_in, "elec", type, reg,t) = capital.l(en_in, "elec", type,reg, t)+eps;
marginal_el_price(reg,slice,t) = sliced_elec_balance.m(reg,slice,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
elprices(reg,t) = sum(slice,sliced_elec_balance.m(reg,slice,t))*((1+R)**((ord(t)-1)*t_step))/t_step/card(slice)+eps;

*Calculate curtailment
curtailment(en_in,type,reg,t,slice) $ effic(en_in,"elec",type,reg,t) =
    max(eps, slice_lng(reg,slice) * Msec_per_year * capital.l(en_in,"elec",type,reg,t) * lfs(en_in,type,reg,slice,"elec") 
    - elec_gen.l(en_in,type,reg,slice,t));

report_from_storage(t,reg,slice2) = sum((storage_tech,slice), storage_slice_transfer.l(storage_tech,reg,slice,slice2,t) * effic(storage_tech,"elec","0",reg,t))+eps;
report_to_storage(t,reg,slice) = sum((storage_tech,slice2), storage_slice_transfer.l(storage_tech,reg,slice,slice2,t))+eps;
report_elec_gen_slice(en_in,type,reg,t,slice)$effic(en_in, "elec", type, reg,t)= elec_gen.l(en_in,type,reg,slice,t)+eps;
report_slice_lng(reg,slice) = slice_lng(reg,slice);

*======= TRANSPORT SECTOR =======
report_transport_energy(reg,trsp_mode,trsp_fuel,engine_type, t)$trsp_conv(trsp_fuel, engine_type, trsp_mode)= trsp_energy.L(trsp_fuel, engine_type, trsp_mode,reg, t)+eps;
report_ship_emis(reg,t)=ship_emis.l(reg,t);
marg_cO2ship(heavy_mode,reg, t)=1000*shipping_emis.m(reg,t)* ((1+r)**(ord(t)-1)*t_step) /t_step+eps;

*Transport mode emissions - aggregated by mode
report_transport_mode_emis(reg, trsp_mode, t) = 
    sum((trsp_fuel, engine_type), trsp_energy.L(trsp_fuel, engine_type, trsp_mode, reg, t) * emis_fact2(trsp_fuel)) + eps;

transp_km(reg, trsp_mode,trsp_fuel, t) =sum(engine_type, trsp_energy.L(trsp_fuel, engine_type, trsp_mode, reg,t)*trsp_conv(trsp_fuel, engine_type, trsp_mode))+eps   ;

*======= FUEL PRODUCTION =======
h2(reg, en_in,type, t)$effic(en_in, "h2", type, reg,t)=en_conv.l(en_in, "h2", type, reg,t) * effic(en_in, "h2", type, reg,t)+ eps;
MeOH(reg, en_in,type, t)$ effic(en_in, "MeOH", type,reg, t)= en_conv.l(en_in, "MeOH", type, reg,t) * effic(en_in, "MeOH", type,reg, t)+ eps;
NH3(reg, en_in,type, t)$ effic(en_in, "NH3", type,reg, t)= en_conv.l(en_in, "NH3", type, reg,t) * effic(en_in, "NH3", type,reg, t)+ eps;

*Fuel use by end-use sector
h2_use(reg, en_out,t)$effic( "h2",en_out, "0", reg,t)= sum(type, en_conv.l("h2", en_out, type, reg,t) ) + eps;
MeOH_use(reg, en_out,t)$effic( "MeOH",en_out, "0", reg,t)= sum(type, en_conv.l("MeOH", en_out, type, reg,t) ) + eps;
NH3_use(reg, en_out,t)$effic( "NH3",en_out, "0", reg,t)= sum(type, en_conv.l("NH3", en_out, type, reg,t) ) + eps;
petro_use(reg, en_out,t)$effic( "petro",en_out, "0", reg,t)= sum(type, en_conv.l("petro", en_out, type, reg,t) ) + eps;
LCH4_use(reg, en_out,t)$effic( "LCH4",en_out, "0", reg,t)= sum(type, en_conv.l("LCH4", en_out, type, reg,t) ) + eps;

*======= OTHER SECTORS =======
feed_stock(reg, en_in,type,t)$effic(en_in, "feed-stock", type, reg,t)= en_conv.l(en_in, "feed-stock", type,reg, t) * effic(en_in, "feed-stock", type, reg,t) + eps;
agrifeedstock(reg, en_in,type,t)$effic(en_in, "agrifeedstock", type, reg,t)= en_conv.l(en_in, "agrifeedstock", type,reg, t) * effic(en_in, "agrifeedstock", type, reg,t) + eps;
non_solid_heat(reg, en_in,type, t)$effic(en_in, "non_solid_heat", type,reg, t)= en_conv.l(en_in, "non_solid_heat", type,reg, t) * effic(en_in, "non_solid_heat", type,reg, t)+ eps;
solid_heat(reg, en_in, type,t)$effic(en_in, "solid_heat", type,reg, t)= en_conv.l(en_in, "solid_heat", type,reg,t) * effic(en_in, "solid_heat", type,reg, t)+ eps ;
rural_heat(reg, en_in,type,t)$effic(en_in, "dist_heat", type, reg,t)= en_conv.l(en_in, "dist_heat", type, reg,t) * effic(en_in, "dist_heat", type, reg,t)+ eps;
urban_heat(reg, en_in,type,t)$effic(en_in, "central_heat", type, reg,t)= en_conv.l(en_in, "central_heat", type, reg,t) * effic(en_in, "central_heat", type, reg,t) + eps;
urban_heat(reg, en_in,"waste_heat",t)=  sum( cg_type, en_conv.l(en_in, "elec", cg_type,reg, t)*heat_effic(en_in, cg_type, "elec","central_heat")   )+ eps;

*======= INVESTMENT & CAPACITY =======
report_capital(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) = capital.L(en_in, en_out, type,reg, t)+eps;
report_invest(reg, en_in, en_out, type, t)$effic(en_in, en_out, type, reg,t) = cap_invest.l(en_in, en_out, type,reg, t)+eps;

*======= UPSTREAM EMISSIONS =======
report_Upp_Emis_Elec_Avr(reg,t)=
(sum(en_in, en_conv.l(en_in,"elec","0",reg,t)*emis_fact(en_in)+ en_conv.l(en_in,"elec","cg",reg,t)*emis_fact(en_in))
+ sum((c_capt,en_in), en_conv.l(en_in,"elec",c_capt,reg,t)*emis_fact(en_in)*(1-capt_effic(en_in, c_capt, "elec")))
- sum(c_capt, en_conv.l("bio", "elec", c_capt, reg, t)*110 *capt_effic("bio",c_capt,"elec"))
)/energy_prod.l("elec", reg,t)+eps;

report_Upp_Emis_H2_Avr(reg,t)$energy_prod.l("H2", reg,t)=
(sum(sliced_H2_no_elec, en_conv.l(sliced_H2_no_elec,"H2","0",reg,t)*emis_fact(sliced_H2_no_elec)
    + en_conv.l(sliced_H2_no_elec,"H2","cg",reg,t)*emis_fact(sliced_H2_no_elec))
    + sum((c_capt,sliced_H2_no_elec), en_conv.l(sliced_H2_no_elec,"H2",c_capt,reg,t)*emis_fact(sliced_H2_no_elec)*(1-capt_effic(sliced_H2_no_elec, c_capt, "H2")))
    + sum(type, en_conv.l("elec","H2",type,reg,t))* report_Upp_Emis_Elec_Avr(reg,t)
    - sum(c_capt, en_conv.l("bio", "H2", c_capt, reg, t)*110 *capt_effic("bio",c_capt,"H2")))
    /(energy_prod.l("H2", reg,t)-supply_sec.l("H2",reg,t))+eps;

report_Upp_Emis_MeOH_Avr(reg,t)$ energy_prod.l("MeOH", reg,t)=
(sum(sliced_H2_no_elec, en_conv.l(sliced_H2_no_elec,"MeOH","0",reg,t)*(emis_fact(sliced_H2_no_elec)-emis_fact("MeOH")*effic("bio", "MeOH", "0",reg,t))+
     en_conv.l(sliced_H2_no_elec,"MeOH","cg",reg,t)*(emis_fact(sliced_H2_no_elec)-emis_fact("MeOH")*effic("bio", "MeOH", "0",reg,t)))
    + sum((c_capt,sliced_H2_no_elec), en_conv.l(sliced_H2_no_elec,"MeOH",c_capt,reg,t)*(emis_fact(sliced_H2_no_elec)-emis_fact("MeOH")*effic("bio", "MeOH", "dec",reg,t))*(1-capt_effic(sliced_H2_no_elec, c_capt, "MeOH")))
    + sum(type, en_conv.l("H2","MeOH",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))+sum(type, en_conv.l("H2","MeOH",type,reg,t)*(-emis_fact("MeOH")*effic("H2", "MeOH", "0",reg,t)))*(C_capt_air.l(reg,t)/C_capt_tot.l(reg,t))
    )/(energy_prod.l("MeOH", reg,t)-supply_sec.l("MeOH",reg,t))+eps;

report_Upp_Emis_NH3_Avr(reg,t)$ energy_prod.l("NH3", reg,t)=
sum(type, en_conv.l("H2","NH3",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))/energy_prod.l("NH3", reg,t);

report_Upp_Emis_LH2_Avr(reg,t)$ energy_prod.l("LH2", reg,t)=
sum(type, en_conv.l("H2","LH2",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))/energy_prod.l("LH2", reg,t);

report_Upp_Emis_LCH4_Avr(reg,t)$ energy_prod.l("LCH4", reg,t)=
(sum(type, en_conv.l("bio","CH4",type,reg,t)*(emis_fact("bio")-emis_fact("CH4")*effic("bio", "CH4", "0",reg,t))* effic("bio", "LCH4", type, reg,t))
+sum(type, en_conv.l("H2","LCH4",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))+sum(type, en_conv.l("H2","LCH4",type,reg,t)*(-emis_fact("LCH4")*effic("H2", "LCH4", "0",reg,t)))*(C_capt_air.l(reg,t)/C_capt_tot.l(reg,t))
+sum(type,en_conv.l("CH4","LCH4", type,reg,t)*Distrib_LCH4))/energy_prod.l("LCH4", reg,t);

report_Upp_Emis_CH2_Avr(reg,t)$ energy_prod.l("CH2", reg,t)=
sum(type, en_conv.l("H2","CH2",type,reg,t)* report_Upp_Emis_H2_Avr(reg,t))/energy_prod.l("CH2", reg,t);

*======= PRICES =======
prices(primary,reg,t)= supply_1_Q.m(primary, reg,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
marginal_fuel_price(en_out, reg, t) = 
    sum((en_in, type)$effic(en_in, en_out, type, reg, t),
        en_conv.m(en_in, en_out, type, reg, t) * ((1+r)**(ord(t)-1)*t_step) / t_step /effic(en_in, en_out, type, reg, t)) + eps;
trsp_price(trsp_mode,reg,t)=trsp_demand_Q.m(trsp_mode, reg, t)*((1+R)**((ord(t)-1)*t_step))/t_step;
trspfuel_price(trsp_fuel, trsp_mode, reg,t) =sum(engine_type,trsp_energy.m(trsp_fuel, engine_type, trsp_mode, reg,t))*((1+R)**((ord(t)-1)*t_step))/t_step;

execute_unload "results3.gdx"
metainfo
report_c
report_supply1
report_import
report_export
report_en_conv
report_capital
report_invest
report_elec_gen_summedslices
report_capital_region
marginal_el_price
elprices
report_slice_lng
curtailment
report_from_storage
report_to_storage
report_elec_gen_slice
report_transport_energy
report_ship_emis
report_transport_mode_emis
feed_stock
agrifeedstock
urban_heat
rural_heat
solid_heat
non_solid_heat
h2
MeOH
NH3
h2_use
MeOH_use
NH3_use
petro_use
LCH4_use
cc
cs
cc_flows
report_Upp_Emis_Elec_Avr
report_Upp_Emis_H2_Avr
report_Upp_Emis_MeOH_Avr
report_Upp_Emis_NH3_Avr
report_Upp_Emis_LH2_Avr
report_Upp_Emis_LCH4_Avr
report_Upp_Emis_CH2_Avr
marginal_fuel_price
marg_cO2ship
prices
trsp_price
trspfuel_price
transp_km

execute 'gdxxrw.exe results3.gdx @output_parameters3.txt'