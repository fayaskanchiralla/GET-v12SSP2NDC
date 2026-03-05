*### DECLARE VARIABLES AND EQUATIONS ###

variables
tot_cost  G USD2010
C_emission(reg,t_a)
agg_emis  MtCO2
Tot_emis(t_a) MtCO2
transp_emis(reg,t) MtCO2
ship_emis(reg,t) MtCO2
ship_emis2(heavy_mode,reg,t)
emiss_upstream(reg,t) MtCO2
Ship_upstream(reg,t) MtCO2;

positive variables

supply_1(primary,reg, t) The amount of primary energy extracted in each region and time period (EJ per yr)
en_conv(energy, en_out, type, reg,t) The amount of energy in each region converted from energy to e_out expressed in primary energy terms in each time period (EJ per yr)
supply_2(energy,reg, t) The amount of primary energy used in a region and time period after importand export (EJ per yr)
energy_prod(energy,reg, t)
energy_prod2(en_in, en_out, type, reg,t)
energy_deliv(energy,reg, t)
elec_decarb(reg,t)
export(second_in, reg,t)
import(second_in, reg,t)
import_from(second_in, reg, reg_exp, t)
cost_feebate_fossil(reg,t)
cost_feebate_zero_fuel(reg,t)
waste_fl (wastes, reg, t)
agg_waste
pu_stock(reg,t)

supply_sec(energy,reg,t)
supply_sec2(en_in,energy,type,reg,t)

trsp_energy(trsp_fuel, engine_type, trsp_mode, reg,t) EJ fuel used in the transport sector
engines(trsp_fuel, engine_type, trsp_mode, reg,t)
*extra_ship_fuel(trsp_fuel, IC_FC, heavy_mode, reg,t)

capital(energy, en_out, type,reg, t)
infra(trsp_fuel,reg, t)

cap_invest(energy, en_out, type,reg, t)
eng_invest(trsp_fuel, engine_type, trsp_mode, reg,t)
infra_invest(trsp_fuel, trsp_mode, reg, t)

elec_deliv(reg,allslices,t)
elec_gen(en_in,type,reg,allslices,t)
elec_use(elecsector,reg,allslices,t)
storage_slice_transfer(storage_tech,reg,allslices,allslices,t)
elec_losses(reg,t)
capital_class(class_tech,class,reg,t)
elec_gen_class(class_tech,class,reg,allslices,t)

H2_prod(sliced_H2,type,reg,allslices,t)
H2_prod_class(class,reg,allslices,t)
capital_class_H2( class,reg,t)

cost_fuel(reg,t) GUSD
dist_cost(t)    GUSD
cost_cap(reg,t)  GUSD
tax(reg,t)  GUSD
OM_cost(t)   GUSD
cost_C_bio_trsp(t)  GUSD
cost_C_strg(t)   GUSD
cost_capt_air (t)   GUSD
ship_levy_cost(t) GUSD
feebate(reg,t)

annual_cost(t)  GUSD

C_capt_tot(reg,t) MtCO2
C_strg_tot(reg,t)  MtCO2
C_capt_air (reg, t) MtCO2 
ship_emis(reg,t) emissions from shipping sector

C_strg_agg MtCO2


;

equations
supply_pot_Q(primary,reg, t)
reserves_Q(stock, reg)
supply_1_Q(primary, reg,t)
*export_import_balance(second_in, t)
export_import_balance_1(second_in,reg_exp, t)
export_import_balance_2(second_in,reg_imp, t)
supply_2_Q(second_in, reg,t)
supply_loop_Q(second_in,reg,t)
no_stock_Q(no_stock,reg,t)
no_stock2_Q(no_stock2,reg,t)
waste_fl_Q(wastes, reg, t)
agg_waste_Q(wastes)
q_Saved_pu(reg,t)
q_start_pu(reg)

energy_prod_Q(en_out,reg,t)
energy_prod_elec_Q(reg,t)
energy_prod2_Q(en_in, en_out, type, reg,t)
energy_deliv_Q(en_out,reg ,t)
supply_sec_Q(energy,reg,t)
supply_sec2_Q(en_in,energy,type, reg,t)
nuclear_gen_Q(second_in,reg,t)
*feedstock_NH3_Q(reg,t)
*feedstock_ammonia(feed_si,en_out,t)
*supply_sec_breeder_lag_Q(reg,t)
*supply_sec_breeder_lag2_Q(en_in,type,reg,t)
*supply_sec_rep_lag_Q(reg,t)
*supply_sec_rep_lag2_Q(en_in,type,reg,t)
Breeder_lag_Q(type,reg)
Breeder_lag_Q2( type,reg, t)

trsp_demand_Q(trsp_mode, reg,t)
vehicle_lim_Q(trsp_fuel, non_phev, trsp_mode, reg, t)
vehicle_lim_PHEV_Q(road_fuel_liquid, engine_type, trsp_mode,reg, t)
elec_frac_PHEV_Q(car_or_truck,engine_type,reg, t)
lim_elec_veh(car_or_truck,elec_veh,reg, t)
*q_sea (engine_type, heavy_mode ,reg, t)
Deliv_Q(sector,reg, t)
Deliv_Solid_heat_Q(sector,reg, t)

Elec_Deliv_Dem_Q(reg,allslices,t)
elec_deliv_Q(reg,allslices,t)
elec_use_Q(elecsector,reg,allslices,t)
sliced_elec_balance(reg,allslices,t)
total_losses_Q(reg,t)
elec_gen_Q(en_in, type,reg, t)
thermal_limit(thermalelec,type,reg,allslices,allslices,t)
elec_capital_lim_class(class_tech,class,reg,allslices,t)
elec_capital_lim_Q(en_in,type,reg,allslices,t)
storage_capital_lim_Q(storage_tech,reg,allslices,allslices,t)
capital_class_limit(class_tech,class,reg,t)
elec_class_aggregation(class_tech,reg,allslices,t)
capital_class_aggregation(class_tech,reg,t)
wind_elec_aggregation(reg,allslices,t)
wind_capital_aggregation(reg,t)
pv_elec_aggregation(reg,allslices,t)
pv_capital_aggregation(reg,t)
csp_elec_aggregation(reg,allslices,t)
csp_capital_aggregation(en_in,reg,t)

H2_prod_balance_Q(sliced_H2,reg,type,t)
H2_capital_lim1(sliced_H2, type,reg,allslices,t)
H2_capital_lim_class(class,reg,allslices,t)
H2_capital_class_limit(class,reg,t)
H2_class_aggregation(reg,allslices,t)
H2_capital_class_aggregation(reg,t)

capital_lim_Q(energy, en_out, type,reg, t)
infra_lim_Q(trsp_fuel,reg, t)
C_capt_air_g_lim_Q(reg, t)

init_invest_Q(energy, en_out, type,reg, init_year)
capital_Q(en_in, en_out, type, reg,t)
engines_Q(trsp_fuel, engine_type, trsp_mode,reg, t)
infra_Q(trsp_fuel,reg, t)

cost_fuel_Q(reg, t)
cost_cap_Q(reg,t)
cost_C_strg_Q(t)
cost_capt_air_Q(t)
tax_Q(reg,t)
OM_cost_Q(t)
dist_cost_Q(t)
annual_cost_Q(t)
Ship_levy_Q(t)
tot_cost_Q

cogen_e_Q(reg,t)
max_solar_q(heat,reg,t)
max_chips(reg,t)
max_feed_stock(feed,reg,t)
max_heat_pump(heat,reg,t)
*min_feed_stock(reg, t)
*q_max_beccs(c_capt,en_out,reg,t)


infra_lim1_Q(trsp_fuel,reg, t)
cap_g_lim_Q(en_in, en_out, type,reg, t)
coal_lim_Q(sector1, type, reg, t)
bio_lim_Q(second_in, en_out, type, reg, t)
*eng_g_lim_Q( trsp_fuel,engine_type,car_truck_ships,reg, t)
*eng_g_lim_Q2( trsp_fuel,engine_type,car_truck_ships,reg, t)
eng_g_lim_Q4(  engine_type,trsp_mode,reg, t)
*Q_car_balance(trsp_mode,reg,t)
supp_lim_Q(fuels,reg, t)

emission_Q(reg,t)
carbon_balance_Q(reg,t)
hist_emission(t_h)
agg_emis_Q
*annual_emis(reg,t)
*q_global_cap(t)
*q_global_cap_2
CO2_cumulative_cap_Q
q_tot_emis(t_a)
*C_emissions_cons_1(reg,t)
*C_emissions_cons_2(reg,t)
*C_strg_tot_Q(reg,t)
C_capt_tot_Q(reg,t)
C_strg_agg_Q
shipping_emis(reg,t)
elec_dec_Q(reg,t)
transport_emis(reg,t)
emiss_upstream_Q(reg,t)
shipping_emis2(heavy_mode,reg,t)
*cost_feebate_Q1(reg,t)
*cost_feebate_Q2(reg,t)
*feebate_reg_Q(t)

transp_q(trsp_fuel,reg,t)
pilot_fuel_Q(engine_type,heavy_mode, reg,t)

Cal_CH4(reg)
Cal_oil(reg)
Cal_coal(reg)
Cal_bio_global
Cal_bio_EUR
Cal_bio_AFR
*Cal_road(reg, trsp_fuel)
post2100_emis_constraint1(t)
*ship_upstream_Q(reg,t)
CO2_cumulative_cap_Q_2020(reg)
vehicle_lim_FCREEV_Q(FC_fuels, engine_type, trsp_mode, reg, t)
elec_frac_FCREEV_Q(car_or_truck, engine_type, reg, t)
NDC_Q1(NDC_2050,t)
NDC_Q2(NDC_2060,t)
NDC_Q3(NDC_2070,t);