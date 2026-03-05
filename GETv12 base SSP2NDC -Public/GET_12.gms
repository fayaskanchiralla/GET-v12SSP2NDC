*###############################################################################
*### GET version 12.0
*###
*### Updated by Fayas Malik and Maria OL 
*### Extensive updation of transport sector
*### Eight ship types: Container, general cargo and bulk, liquid tanker, gaseous tanker, cargo short, ferry short, ferry long, other ship
*### Four aircraft types: short distance, medium and long distance passenger aircraft,and freight aircraft
*### Three truck types: LCV, MFT, HFT
*### To DO:
*### - The climate 
*### - Add truck type
*### - Biomass categories
*### - Agriculture feedstock-ammonia
*### - Result excel sheet correction and simplification
*### - equations for sensitivity assessment for varying range and other Parameters
*### - Aviation technical details
*### - Adding Sustainable aviation fuels
*### - Add FCREEV
*### - modify industrial feedstock e.g. iron and steel etc.
*### - Carbon budget revisions and nuclear investment
*###############################################################################

*execseed = 1+gmillisec(jnow);
*this should be addedd if running montecarlo simulations

$ include "sets.gms";

$ include "params.gms";

*### EQUATIONS ###

$ include "declare.gms";

*### supply and conversion to delivered energy forms ###

supply_pot_Q(primary, reg,t)..
    supply_pot(primary, reg,t) =G= supply_1(primary,reg, t);

supply_1_Q(primary,reg, t)..
    supply_1(primary, reg,t)  =E= sum( (type, en_out), en_conv(primary, en_out, type, reg, t) );


*export_import_balance(second_in, t)..
*sum(reg, export(second_in, reg,t))=e=sum(reg, import( second_in, reg, t));

*$ontext
export_import_balance_1(second_in, reg_exp, t)..
         export(second_in, reg_exp,t)=e=sum(reg_imp, import_from(second_in, reg_imp, reg_exp, t));

export_import_balance_2(second_in, reg_imp, t)..
         import(second_in, reg_imp,t)=e=sum(reg_exp, import_from(second_in, reg_imp, reg_exp, t));

*$offtext

supply_2_Q(second_in,reg, t)..
    supply_2(second_in, reg,t)-export(second_in, reg,t)+import(second_in,reg,t) =e= sum( (type, en_out), en_conv(second_in, en_out, type,reg, t) ) ;

supply_loop_Q(second_in,reg,t)..
    supply_2(second_in, reg,t) =L= energy_prod(second_in, reg,t);

energy_prod_Q(en_out,reg,t) $ (not sameas(en_out,"elec"))..
    energy_prod(en_out,reg,t) =E=
        sum((type,en_in), en_conv(en_in,en_out,type,reg, t) * effic(en_in, en_out, type, reg,t))
        + supply_sec(en_out,reg,t);

energy_prod_elec_Q(reg,t)..
    energy_prod("elec",reg,t) =E=
        sum((type,en_in) $ (not sameas(en_in,"solar") and not sameas(en_in,"wind")),
                            en_conv(en_in,"elec",type,reg,t) * effic(en_in,"elec",type,reg,t))
        + supply_sec("elec",reg,t) - elec_losses(reg,t);

energy_prod2_Q(en_in, en_out, type, reg,t)..
    energy_prod2(en_in, en_out, type,reg,t) =E=
         en_conv(en_in, en_out, type,reg, t) * effic(en_in, en_out, type, reg,t)+supply_sec2(en_in, en_out, type, reg,t);
         

*MOL: the below equation constraints the en_prod from nuclear, taking into account the the supply_2 (imports and exports of each region)
*For each timestep t+1, the total energy supplied by nuclear cannot increase versus to the time step t more than the energy produced by one reactor of 1 GW per region, assuming a load factor of 0.80
*0.025 EJ is equivalent to 1 GW reactor to be built in each region, in a period of 10 years.
*1 GW = 0.001 TW * 365 d * 24 h * 0.8 (lf) = 7 TWh / 277.8 = 0.025 EJ         
nuclear_gen_Q(second_in,reg,t) $ (nuclear_just(second_in))..         
 energy_prod(second_in, reg,t+1)  =l= energy_prod(second_in, reg,t) + 0.025;

reserves_Q(stock, reg).. sum(t, t_step*supply_1(stock, reg,t) )=L= supply_pot_0(stock, reg);

no_stock_Q(no_stock,reg,t) ..
energy_prod(no_stock, reg,t)=e= sum( (type, en_out), en_conv(no_stock, en_out, type,reg, t) ) ;

no_stock2_Q(no_stock2,reg,t) ..
energy_prod(no_stock2, reg,t)-export(no_stock2, reg,t)+import(no_stock2,reg,t)=e= sum( type,  en_conv(no_stock2, "trsp", type,reg, t) );
*sum( (type, en_in), en_conv(en_in, no_stock2, type,reg, t)* effic(en_in, no_stock2, type, reg,t)-export(no_stock2, reg,t)+import(no_stock2,reg,t)=e= sum( type,  en_conv(no_stock2, "trsp", type,reg, t) ;

waste_fl_Q(wastes, reg, t) ..
waste_fl(wastes, reg, t)  =e= (sum((en_in), en_conv (en_in, wastes, "0", reg, t)* effic(en_in, wastes, "0", reg, t))) ;

q_Saved_pu(reg,t)$(year(t)>=2000)..
         Pu_stock(reg, t+1)=e= Pu_stock(reg, t)+en_conv ("Rep2", "PuR", "0", reg, t)* effic("Rep2","PuR", "0", reg, t)-sum(en_out, en_conv ("PuR", en_out, "0", reg, t)  )    ;

q_start_pu(reg)..
         Pu_stock(reg, "2010")=e= Pu_start( reg);

agg_waste_Q(wastes)..
    agg_waste(wastes) =E= sum((t,reg), t_step * waste_fl(wastes, reg, t));

*### energy delivered ###

energy_deliv_Q(en_out, reg,t)..
    energy_deliv(en_out, reg,t) =e= energy_prod(en_out,reg, t)  -supply_2(en_out,reg, t);

supply_sec_Q(energy,reg,t)  ..
supply_sec(energy,reg,t)=e= sum( (en_in, type, en_out), en_conv(en_in, en_out, type,reg, t)*heat_effic(en_in, type, en_out, energy) );

supply_sec2_Q(en_in, energy,type, reg,t)  ..
supply_sec2(en_in, energy, type,reg,t)=e= sum( ( en_out), en_conv(en_in, en_out, type,reg, t)*heat_effic(en_in, type, en_out, energy) );

Breeder_lag_Q(type,reg) ..
en_conv("Rep3", "FBF", type,reg, "2030")=e=en_conv("Rep2", "FBF", type,reg, "2030")*effic("Rep2", "FBF", type, reg,"2030")+ en_conv("Pu", "FBF", type,reg, "2030")*effic("Pu", "FBF", type, reg,"2030")+ en_conv("EU4", "FBF", type,reg, "2030")*effic("EU4", "FBF", type, reg,"2030")  ;

Breeder_lag_Q2(type,reg, t) $(year(t)>2030) ..
en_conv("Rep3", "FBF", type,reg, t)=e=en_conv("Rep2", "FBF", type,reg, t)*effic("Rep2", "FBF", type, reg,t)+ en_conv("Pu", "FBF", type,reg, t)*effic("Pu", "FBF", type, reg,t)+ en_conv("EU4", "FBF", type,reg, t)*effic("EU4", "FBF", type, reg,t)+ en_conv("Rep3", "FBF", type,reg, t-1)  ;

$ontext

*Reprocessing delays for nuclear

supply_sec_Q(energy,reg,t) $ ((not sameas(energy, 'BrProd')) and ( not sameas (energy, "sLWRf"))) ..
   supply_sec(energy,reg,t)=e= sum( (en_in, type, en_out), en_conv(en_in, en_out, type,reg, t)*heat_effic(en_in, type, en_out, energy) );

supply_sec2_Q(en_in, energy,type, reg,t) $ ((not sameas(energy, 'BrProd')) and ( not sameas (energy, "sLWRf"))) ..
supply_sec2(en_in, energy, type,reg,t)=e= sum( ( en_out), en_conv(en_in, en_out, type,reg, t)*heat_effic(en_in, type, en_out, energy) );

supply_sec_breeder_lag_Q(reg,t) ..
   supply_sec('BrProd',reg,t)=e= sum( (en_in, type, en_out), en_conv(en_in, en_out, type,reg, t-1)*heat_effic(en_in, type, en_out, 'BrProd') );

supply_sec_breeder_lag2_Q(en_in,type, reg,t) ..
supply_sec2(en_in, "BrProd",type, reg,t)=e= sum( ( en_out), en_conv(en_in, en_out, type,reg, t-1)*heat_effic(en_in, type, en_out, "BrProd") );

supply_sec_rep_lag_Q(reg,t) ..
   supply_sec('sLWRf',reg,t)=e= sum( (en_in, type, en_out), en_conv(en_in, en_out, type,reg, t-1)*heat_effic(en_in, type, en_out, 'sLWRf') );

supply_sec_rep_lag2_Q(en_in,type, reg,t) ..
supply_sec2(en_in, "sLWRf",type,reg,t)=e= sum( (  en_out), en_conv(en_in, en_out, type,reg, t-1)*heat_effic(en_in, type, en_out, "sLWRf") );
$offtext

*--------------transportation module--------------------------

transp_q(trsp_fuel,reg,t)..
         sum( (trsp_mode, engine_type), trsp_energy(trsp_fuel, engine_type, trsp_mode, reg,t) )=e=
         sum(type, en_conv(trsp_fuel, "trsp", type, reg,t)*effic(trsp_fuel, "trsp", type,reg,t));

trsp_demand_Q(trsp_mode, reg,t)..
    trsp_demand(trsp_mode, reg,t) =e= sum( (trsp_fuel, engine_type),
    trsp_energy(trsp_fuel, engine_type, trsp_mode,reg, t)*trsp_conv(trsp_fuel, engine_type, trsp_mode) );

vehicle_lim_FCREEV_Q(FC_fuels, engine_type, car_or_truck, reg,t)..
    trsp_energy(FC_fuels, "FCREEV", car_or_truck, reg,t) =e=
        engines(FC_fuels, "FCREEV", car_or_truck, reg,t)/
           num_veh(car_or_truck,reg, t)*(1-elec_frac_PHEV(car_or_truck))*
              trsp_demand(car_or_truck,reg, t)/(trsp_conv(FC_fuels, "FCREEV", car_or_truck)+0.0001);

elec_frac_FCREEV_Q(car_or_truck, engine_type, reg,t)..
     sum(FC_fuels, trsp_energy(FC_fuels, "FCREEV", car_or_truck, reg, t)*
         trsp_conv(FC_fuels, "FCREEV", car_or_truck))/(1-elec_frac_PHEV(car_or_truck)) =e=
            trsp_energy("elec", "FCREEV", car_or_truck, reg, t)*
               trsp_conv("elec", "FCREEV", car_or_truck)/(elec_frac_PHEV(car_or_truck));

vehicle_lim_Q(trsp_fuel, non_phev, trsp_mode_no_train, reg,t)..
    trsp_energy(trsp_fuel, non_phev, trsp_mode_no_train, reg,t)*trsp_conv(trsp_fuel, non_phev, trsp_mode_no_train) =l=
        engines(trsp_fuel, non_phev, trsp_mode_no_train, reg, t)/num_veh(trsp_mode_no_train,reg, t)*
        trsp_demand(trsp_mode_no_train, reg,t);

vehicle_lim_PHEV_Q(road_fuel_liquid,engine_type, car_or_truck, reg,t)..
    trsp_energy(road_fuel_liquid, "PHEV", car_or_truck, reg,t) =e=
        engines(road_fuel_liquid, "PHEV", car_or_truck, reg,t)/
           num_veh(car_or_truck,reg, t)*(1-elec_frac_PHEV(car_or_truck))*
              trsp_demand(car_or_truck,reg, t)/(trsp_conv(road_fuel_liquid, "PHEV", car_or_truck)+0.0001);

elec_frac_PHEV_Q(car_or_truck,  engine_type,reg,t)..
     sum(road_fuel_liquid, trsp_energy(road_fuel_liquid, "PHEV", car_or_truck,reg, t)*
         trsp_conv (road_fuel_liquid, "PHEV", car_or_truck))/(1-elec_frac_PHEV(car_or_truck)) =e=
            trsp_energy( "elec", "PHEV", car_or_truck,reg, t)*
               trsp_conv ("elec", "PHEV", car_or_truck)/(elec_frac_PHEV(car_or_truck));

lim_elec_veh(car_or_truck,elec_veh,reg,t)..
         sum(trsp_fuel, engines(trsp_fuel, elec_veh, car_or_truck, reg,t))=l=
          frac_engine(elec_veh, car_or_truck)*num_veh(car_or_truck, reg,t) ;
          

*To make sure there is 5% pilot fuel for H2 and NH3 ICE
pilot_fuel_Q(engine_type,heavy_mode, reg,t)..
 sum(can_be_pilot, trsp_energy(can_be_pilot, "0", heavy_mode, reg,t) )=G=0.05*sum(need_pilot, trsp_energy(need_pilot, "0", heavy_mode, reg,t));

*### balance demand and supply ###

Deliv_Q(sector,reg,t) $ (not sameas(sector,"elec")and not sameas(sector,"solid_heat") ) ..
    energy_deliv(sector,reg,t) =e= dem(sector,reg,t);

Deliv_Solid_heat_Q("solid_heat",reg, t)..
energy_deliv ("solid_heat", reg, t)  =e=  dem ("solid_heat", reg, t)+ C_capt_air (reg, t)*heat_CO2aircapture;


*----------------electricity sector----------------------------
* to do:
* hydro - split between storage & run of river, annual inflow, put x% of hydro storage in run of river to reflect regulations
* sliced central_heat sector (may overinvest in capacity to profit from low elec prices)
* timeshifting of demand in central_heat, solid_heat, non_solid_heat, trsp (implement as a storage technology)
* BUT only central_heat and trsp matter, other sectors phase out electricity
* storage technologies with characteristic timescales (pumped hydro, compressed air, batteries)

Elec_Deliv_Dem_Q(reg,slice,t)..
    elec_deliv(reg,slice,t) =e= elec_dem(reg,slice,t)
*+0.053*en_conv("h2", "NH3", "0",reg, t)/ effic("h2", "NH3", "0",reg, t)* slice_lng(reg,slice) * sliced_demand(reg,slice)
;

elec_deliv_Q(reg,slice,t)..
    elec_deliv(reg,slice,t) =e= energy_deliv("elec",reg, t) * slice_lng(reg,slice) * sliced_demand(reg,slice)+C_capt_air (reg, t)*El_DAC;

elec_use_Q(elecsector,reg,slice,t)..
    elec_use(elecsector,reg,slice,t)=e=
        en_conv("elec",elecsector,"0",reg,t) * slice_lng(reg,slice) * sliced_demand(reg,slice);

sliced_elec_balance(reg,slice,t)..
* avoid double counting solar & wind (subtechs represented both individually & collectively)
    sum((en_in,type) $ (not sameas(en_in,"solar") and not sameas(en_in,"wind")), elec_gen(en_in,type,reg,slice,t)) =e=
        elec_dem(reg,slice,t)
        + sum(elecsector, elec_use(elecsector,reg,slice,t))
        - sum((storage_tech, slice2), storage_slice_transfer(storage_tech,reg,slice2,slice,t) * effic(storage_tech,"elec","0",reg,t))
        + sum((storage_tech, slice2), storage_slice_transfer(storage_tech,reg,slice,slice2,t))
        + H2_prod("elec","0",reg,slice,t) / effic("elec","H2","0",reg,t);

total_losses_Q(reg,t)..
    elec_losses(reg,t) =E= sum((storage_tech,slice,slice2), storage_slice_transfer(storage_tech,reg,slice2,slice,t) * (1-effic(storage_tech,"elec","0",reg,t)));

elec_gen_Q(en_in,type,reg,t)..
    sum(slice, elec_gen(en_in,type,reg,slice,t)) =e= en_conv(en_in,"elec",type,reg,t) * effic(en_in,"elec",type,reg,t);

* equation rearranged to avoid division-by-zero error if a slice has zero length
thermal_limit(thermalelec,type,reg,slice,slice2,t)..
*        elec_gen(thermalelec,type,reg,slice,t) / slice_lng(reg,slice) =G= ramp_lim(thermalelec,type) * elec_gen(thermalelec,type,reg,slice2,t) / slice_lng(reg,slice2);
        elec_gen(thermalelec,type,reg,slice,t) * slice_lng(reg,slice2) =G= ramp_lim(thermalelec,type) * elec_gen(thermalelec,type,reg,slice2,t) * slice_lng(reg,slice);

elec_capital_lim_class(class_tech,class,reg,slice,t) ..
    elec_gen_class(class_tech,class,reg,slice,t) =L= capital_class(class_tech,class,reg,t) *
                                       lfsl(class_tech,class,reg,slice) * Msec_per_year * slice_lng(reg,slice);

* make exception for hydro
elec_capital_lim_Q(en_in,type,reg,slice,t) $ (not is_class_tech(en_in)) ..
    elec_gen(en_in,type,reg,slice,t) =L= capital(en_in,"elec",type,reg,t) *
                                       lfs(en_in,type,reg,slice,"elec") * Msec_per_year * slice_lng(reg,slice);

* above constraint invalid for storage techs (lfs = 0), here's the real one
* unit of storage_slice_transfer_times is hours/year, capital is TW and all energy units are EJ
storage_capital_lim_Q(storage_tech,reg,slice,slice2,t)..
    storage_slice_transfer(storage_tech,reg,slice,slice2,t) =L= capital(storage_tech, "elec","0",reg,t) *
                                        storage_slice_transfer_times(storage_tech,reg,slice,slice2) * 3600 / 1e6;

capital_class_limit(class_tech,class,reg,t)..
    capital_class(class_tech,class,reg,t) =L= class_capacity_limit(class_tech, class, reg);

elec_class_aggregation(class_tech,reg,slice,t)..
    sum(class, elec_gen_class(class_tech,class,reg,slice,t)) =E= elec_gen(class_tech,"0",reg,slice,t);

capital_class_aggregation(class_tech,reg,t)..
    sum(class, capital_class(class_tech,class,reg,t)) =E= capital(class_tech,"elec","0",reg,t);

wind_elec_aggregation(reg,slice,t)..
    elec_gen("windonshoreA","0",reg,slice,t) + elec_gen("windonshoreB","0",reg,slice,t) +
                elec_gen("windoffshore","0",reg,slice,t) =E= elec_gen("wind","0",reg,slice,t);

wind_capital_aggregation(reg,t)..
    capital("windonshoreA","elec","0",reg,t) + capital("windonshoreB","elec","0",reg,t) +
                capital("windoffshore","elec","0",reg,t) =E= capital("wind","elec","0",reg,t);

pv_elec_aggregation(reg,slice,t)..
    elec_gen("pvrooftop","0",reg,slice,t) + elec_gen("pvplantA","0",reg,slice,t) +
                elec_gen("pvplantB","0",reg,slice,t) =E= elec_gen("solar","0",reg,slice,t);

pv_capital_aggregation(reg,t)..
    capital("pvrooftop","elec","0",reg,t) + capital("pvplantA","elec","0",reg,t) +
                capital("pvplantB","elec","0",reg,t) =E= capital("solar","elec","0",reg,t);

csp_elec_aggregation(reg,slice,t)..
    elec_gen("cspplantA","0",reg,slice,t) + elec_gen("cspplantB","0",reg,slice,t)
                                                    =E= elec_gen("solar","cg",reg,slice,t);

csp_capital_aggregation(en_in,reg,t)..
    capital("cspplantA","elec","0",reg,t) + capital("cspplantB","elec","0",reg,t)
                                                    =E= capital("solar","elec","cg",reg,t);

*### Hydrogen ###

H2_prod_balance_Q(sliced_H2,reg,type,t)..
    sum(slice, H2_prod(sliced_H2,type,reg,slice,t)) =e= en_conv(sliced_H2,"H2",type,reg,t) * effic(sliced_H2,"H2",type,reg,t);

H2_capital_lim1(sliced_H2,type,reg,slice,t) ..
    H2_prod(sliced_H2,type,reg,slice,t) $ (not sameas(sliced_H2,"solar"))=L=
        capital(sliced_H2,"H2",type,reg,t) * lfs(sliced_H2,type,reg,slice,"H2") * Msec_per_year * slice_lng(reg,slice);

*Solar hydrogen

H2_capital_lim_class(class,reg,slice,t)..
    H2_prod_class(class,reg,slice,t) =L= capital_class_H2( class,reg,t)* lfsl_H2(class,reg,slice)* Msec_per_year * slice_lng(reg,slice);

H2_capital_class_limit(class,reg,t)..
    capital_class_H2(class,reg,t) =L= class_capacity_limit_H2(class, reg);

H2_class_aggregation(reg,slice,t)..
    sum(class, H2_prod_class(class,reg,slice,t)) =E= H2_prod("solar","0",reg,slice,t);

H2_capital_class_aggregation(reg,t)..
    sum(class, capital_class_H2(class,reg,t)) =E= capital("solar","H2","0",reg,t);

*### use limited by capital ###

capital_lim_Q(en_in, en_out, type,reg, t) $ (not sameas(en_out, "elec") and not sameas(en_out, "H2")) ..
    en_conv(en_in, en_out, type, reg,t)* effic(en_in, en_out, type, reg,t) =L= capital(en_in, en_out, type,reg, t)
                                       *lf(en_in, type, en_out)*Msec_per_year;
                                       

infra_lim_Q(trsp_fuel, reg,t)..
    sum(type, en_conv(trsp_fuel, "trsp", type, reg,t)* effic(trsp_fuel, "trsp", type,reg, t))
          =L= infra(trsp_fuel,reg, t)*lf_infra(trsp_fuel)*Msec_per_year;

*### investments and depreciation ###

init_invest_Q(en_in, en_out, type, reg,init_year)..
    capital(en_in, en_out, type, reg,init_year) =E= init_capital(en_in, en_out, type, reg)
                   + t_step *cap_invest(en_in, en_out, type,reg, init_year);

capital_Q(en_in, en_out, type, reg,t+1)..
    capital(en_in, en_out, type, reg,t+1) =E= t_step * cap_invest(en_in, en_out, type, reg,t+1)
           + capital(en_in, en_out, type, reg,t)*exp(t_step*log(1-1/life_plant(en_in, en_out, type)));

engines_Q(trsp_fuel, engine_type, trsp_mode_no_train, reg,t+1)..
    engines(trsp_fuel, engine_type, trsp_mode_no_train,reg, t+1) =E= t_step * eng_invest(trsp_fuel, engine_type, trsp_mode_no_train,reg, t+1)
           + engines(trsp_fuel, engine_type, trsp_mode_no_train, reg,t)*
             exp(t_step*log(1-1/life_eng(trsp_fuel, engine_type, trsp_mode_no_train)));

infra_Q(trsp_fuel,reg, t+1)..
    infra(trsp_fuel, reg,t+1) =E= t_step * sum(trsp_mode_no_train, infra_invest(trsp_fuel,trsp_mode_no_train,reg, t+1))
           + infra(trsp_fuel,reg, t) * exp(t_step*log(1-1/life_infra(trsp_fuel)));


*### annual and total costs ###

cost_fuel_Q(reg,t)..
    cost_fuel(reg,t) =E= sum(fuels, supply_1(fuels, reg,t)*price(fuels, reg))+sum(second_in, import(second_in, reg,t)*import_cost(second_in))
         +sum((reg_exp, second_in), import_from(second_in, reg, reg_exp, t)*distance(reg, reg_exp)*imp_cost_lin(second_in));
*;

Ship_levy_Q(t)..
ship_levy_cost(t)=e= sum(reg, ship_emis(reg,t))*ship_levy(t);
*-------------FMK 20250511---------------Activate for all scenarios except for 2tier mechanism and feebate for shipping---------- 
*$ontext
cost_cap_Q(reg,t)..

    cost_cap(reg,t) =E=
    sum( (en_in, en_out, type),
        cap_invest(en_in, en_out, type,reg, t)*cost_inv(en_in, en_out, type, t) )+
    sum( (trsp_fuel, engine_type, trsp_mode_no_train),
        eng_invest(trsp_fuel, engine_type, trsp_mode_no_train, reg,t)*(cost_eng(trsp_fuel, engine_type, trsp_mode_no_train, t)) )+
    sum( (trsp_fuel,trsp_mode_no_train),
        infra_invest(trsp_fuel,trsp_mode_no_train, reg, t)*cost_infra_mod(trsp_fuel, trsp_mode_no_train) );
*$offtext
*--------------FMK 20250511--------------Activate only for feebate  for shipping-----------------------------------------------
$ontext
cost_feebate_Q1(reg,t)..
    cost_feebate_fossil(reg,t) =E=sum((trsp_fuel, engine_type, heavy_mode)$(not zero_fuels(trsp_fuel)),
        eng_invest(trsp_fuel, engine_type, heavy_mode, reg,t)*(cost_eng(trsp_fuel, engine_type, heavy_mode, t)) );
cost_feebate_Q2(reg,t)..        
    cost_feebate_zero_fuel(reg,t) =E= sum((zero_fuels, engine_type, heavy_mode),
        eng_invest(zero_fuels, engine_type, heavy_mode, reg,t)*(cost_eng(zero_fuels, engine_type, heavy_mode, t)) )-feebate(reg,t);
 
feebate_reg_Q(t)..
        ship_levy_cost(t)*0.2=E=sum(reg, feebate(reg,t));       

cost_cap_Q(reg,t)..
    cost_cap(reg,t) =E=
    sum( (en_in, en_out, type),
        cap_invest(en_in, en_out, type,reg, t)*cost_inv(en_in, en_out, type, t) )+
    sum( (trsp_fuel, engine_type, trsp_mode_no_train)$(not heavy_mode(trsp_mode_no_train)),
        eng_invest(trsp_fuel, engine_type, trsp_mode_no_train, reg,t)*(cost_eng(trsp_fuel, engine_type, trsp_mode_no_train, t)) )+
    sum( (trsp_fuel,trsp_mode_no_train),
        infra_invest(trsp_fuel,trsp_mode_no_train, reg, t)*cost_infra_mod(trsp_fuel, trsp_mode_no_train) )+
    cost_feebate_fossil(reg,t)+ cost_feebate_zero_fuel(reg,t);

$offtext

cost_C_strg_Q(t)..
    cost_C_strg(t) =E=   sum( reg, C_strg_tot(reg,t) )*cost_strg;
*total cost of storing and transporting CO2

cost_capt_air_Q(t)..
cost_capt_air(t)=E=sum(reg, C_capt_air (reg, t))*CO2aircapt_cost;
*total cost of capturing CO2 from air


tax_Q(reg,t)..
    tax(reg,t) =E= C_emission(reg,t)*C_tax(reg,t);


OM_cost_Q(t)..
    OM_cost(t) =E= sum( (en_in, en_out, type, reg), OM_cost_fr(en_in, en_out) * cost_inv(en_in, en_out, type, t) *
        en_conv(en_in, en_out, type,reg, t) * effic(en_in, en_out, type,reg, t) / Msec_per_year/(lf(en_in, type, en_out)+0.000001)) ;

dist_cost_Q(t)..
      dist_cost(t)=e=sum( (en_in, type, en_out, reg), en_conv(en_in, en_out, type,reg, t)*infra_cost(en_in, type, en_out))
         +sum(reg, supply_sec("central_heat",reg,t)*district_cost);

annual_cost_Q(t)..
    annual_cost(t) =E= sum(reg, cost_fuel(reg, t)) +
                     sum(reg, cost_cap(reg, t)) +
                     OM_cost(t) +
                     dist_cost(t) +
                     cost_C_strg(t) +
                     cost_C_bio_trsp(t)  +
                     cost_capt_air(t)+
                     sum(reg, tax(reg,t))
                     +ship_levy_cost(t) ;

tot_cost_Q..
    tot_cost =E= sum(t, t_step * annual_cost(t)/((1+r)**(t_step*(ord(t)-1))));

*### technology restrictions ###

cogen_e_Q(reg,t)..
    sum( (cg_fuel, cg_type), en_conv(cg_fuel, "elec", cg_type,reg, t)*
                 heat_effic (cg_fuel, cg_type, "elec", "central_heat")) =L= cogen_fr_h * dem("central_heat",reg, t);

max_solar_q(heat, reg,t)..
    en_conv("solar", heat, "0",reg,t)=l=dem(heat,reg,t)*max_solar(heat,reg)     ;

max_heat_pump(heat,reg,t)..
    en_conv("elec", heat, "0",reg,t)=l=dem(heat,reg,t)*max_pump(heat,reg)     ;

max_chips(reg,t)..
     sum(type,  en_conv("bio", "solid_heat", type,reg,t)*effic("bio", "solid_heat", type,reg, t))=l=dem("solid_heat",reg,t)*max_chip  ;

max_feed_stock(feed,reg, t)..
     sum(type,  en_conv(feed, "feed-stock", type,reg,t)*effic(feed, "feed-stock", type,reg, t))=l=dem("feed-stock",reg,t)*max_feed(feed)  ;
     

*### Expansion rate constraints ###

supp_lim_Q(fuels, reg,t+1)..  supply_1(fuels, reg,t+1) =L=
    supply_1(fuels, reg,t) * (1+supply_lim)**t_step + init_supply;

infra_lim1_Q(trsp_fuel, reg,t+1).. infra(trsp_fuel,reg, t+1) =L=
    infra(trsp_fuel, reg,t) * (1+infra_g_lim)**t_step+init_infra ;

$ontext

eng_g_lim_Q(trsp_fuel, engine_type,car_truck_ships,reg, t+1)..
         engines(trsp_fuel, engine_type, car_truck_ships,reg, t+1)/num_veh(car_truck_ships,reg,t+1)=L=
         marketshare_eng+engines(trsp_fuel, engine_type, car_truck_ships,reg, t)/num_veh(car_truck_ships,reg,t)   ;

eng_g_lim_Q2(trsp_fuel, engine_type,car_truck_ships,reg, t+1)..
         engines(trsp_fuel, engine_type, car_truck_ships,reg, t+1)/num_veh(car_truck_ships,reg,t+1)=G=
         engines(trsp_fuel, engine_type, car_truck_ships,reg, t)/num_veh(car_truck_ships,reg,t)-marketshare_eng   ;
$offtext

eng_g_lim_Q4( engine_type,trsp_mode_no_train,reg, t+1)..
 sum (trsp_fuel, engines(trsp_fuel, engine_type, trsp_mode_no_train,reg, t+1))=L=
 sum(trsp_fuel, engines(trsp_fuel, engine_type, trsp_mode_no_train,reg, t))*(1+eng_g_lim)**t_step+init_eng;

*Q_car_balance(trsp_mode,reg,t)$ (not sameas(trsp_mode, "f_rail") and not sameas(trsp_mode, "p_rail")and not sameas(trsp_mode, "p_air_short")and not sameas(trsp_mode, "p_air_medium")and not sameas(trsp_mode, "p_air_long")and not sameas(trsp_mode, "f_air"))..
*sum((engine_type,trsp_fuel),engines(trsp_fuel, engine_type, trsp_mode,reg, t))=l= num_veh(trsp_mode,reg,t)+0.1;

cap_g_lim_Q(en_in, en_out, type,reg, t+1)..
    cap_invest(en_in, en_out, type,reg, t+1) =L=
    cap_invest(en_in, en_out, type, reg,t) * (1+cap_g_lim)**t_step+init_plant;

coal_lim_Q(sector1, type, reg, t+1) $ (year(t)=2010)..
      energy_prod2("coal", sector1, type,reg, t+1)=g= energy_prod2("coal", sector1, type,reg, t)* 0.9;

bio_lim_Q(second_in, en_out, type, reg, t+1) $ (year(t)>=2050)..
      energy_prod2("bio", en_out, type, reg, t+1)=L= 1.2* energy_prod2("bio", en_out,type,reg, t) ;

C_capt_air_g_lim_Q(reg, t+1)..
    C_capt_air (reg, t+1) =L=
    C_capt_air (reg, t) * (1+cap_g_lim)**t_step+init_plant;

*### C cycle model ###

$ include "c_mod.gms";


*--------------------emissions, capture, utlisation and storage------------------------------------------


emiss_upstream_Q(reg,t)..
emiss_upstream(reg,t) =E= sum(en_out $ (not sameas(en_out,'trsp')), (sum((en_in, type), en_conv(en_in,en_out, type,reg,t)
         *(emis_fact(en_in)-emis_fact(en_out)*effic(en_in, en_out, type,reg,t)))))
         - C_strg_tot(reg,t) + sum(en_out, (sum((natural_gas, type), en_conv(natural_gas,'CH4', type,reg,t)))*WTT_CH4)
         + sum(en_out, (sum((en_in, type), en_conv('LCH4','trsp', type,reg,t))+sum((en_in, type), en_conv('CH4','trsp', type,reg,t))+sum((en_in, type), en_conv('LCH4','trsp', type,reg,t)))*Distrib_LCH4);



shipping_emis2(heavy_mode,reg,t)..
 ship_emis2(heavy_mode,reg,t)=e= sum((trsp_fuel, engine_type), trsp_energy(trsp_fuel, engine_type, heavy_mode, reg,t) *emis_fact2(trsp_fuel));

shipping_emis(reg,t)..
 ship_emis(reg,t)=e=sum(heavy_mode,ship_emis2(heavy_mode,reg,t))
                    +(sum(heavy_mode, trsp_energy ("LCH4", "0", heavy_mode,reg, t)*extra_emis_CH4(heavy_mode)))
                    +(sum(heavy_mode, trsp_energy ("NH3", "0", heavy_mode,reg, t)* TTW_N2O));         

transport_emis(reg,t)..
transp_emis(reg,t) =e=sum(engine_type, (sum((trsp_fuel, trsp_mode)$ (not heavy_mode (trsp_mode)), trsp_energy(trsp_fuel, engine_type, trsp_mode, reg,t)*emis_fact2(trsp_fuel))));
    
emission_Q(reg,t)..
C_emission(reg,t) =E= emiss_upstream(reg,t)+ ship_emis(reg,t)+transp_emis(reg,t);


NDC_Q1(NDC_2050,t)..
C_emission(NDC_2050,t)$(year (t) > 2030)=l=0.5*C_emission(NDC_2050,"2020");
NDC_Q2(NDC_2060,t)..
C_emission(NDC_2060,t)$(year (t) > 2040)=l=0.4*C_emission(NDC_2060,"2020");
NDC_Q3(NDC_2070,t)..
C_emission(NDC_2070,t)$(year (t) > 2050)=l=0.4*C_emission(NDC_2070,"2020");

carbon_balance_Q(reg,t)..
en_conv("H2","MeOH","0", reg, t)*emis_fact("MeOH")* effic("H2","MeOH","0",reg,t)
    +en_conv("H2","LCH4","0", reg, t)*emis_fact("LCH4")* effic("H2","LCH4","0",reg,t)
    =e=  C_capt_tot(reg,t)-C_strg_tot(reg,t) ;

q_tot_emis(t)..
         sum(reg, C_emission(reg,t))=e=Tot_emis(t)     ;

hist_emission(t_h)..  Tot_emis(t_h) =E= (hist_fos_emis(t_h)+HIST_luc_EMIS(t_h))*3.7    ;

agg_emis_Q..
    agg_emis =E= sum((t,reg), t_step * C_emission(reg, t));

$ontext
*emission trajectories
*NB! Mark in/take away right trajectory in constraints
annual_emis(reg,t)$(year(t)<2060)..
         C_emission(reg,t)=l=trajec(reg,t);

q_global_cap(t)..
         sum(reg, C_emission(reg,t))=l=sum(reg,trajec(reg,t));
$offtext

*$ontext
*cumulative emission cap
*NB! Mark in/take away right number in constraints
*q_global_cap_2..
*sum((t,reg), t_step * C_emission(reg, t)$(year(t)< 2110)) =l= Cum_CO2_emis;

*MOL: uncomment when using callibration factor of real data up to and including 2020
*When using this equation, we need to comment the q_global_cap_2 and change the cap in the constraints 
CO2_cumulative_cap_Q..
sum((t,reg), t_step * C_emission(reg, t)$(year (t) > 2010 and year(t)< 2110)) =l= Cum_CO2_emis;

CO2_cumulative_cap_Q_2020(reg)..
sum((t), t_step * C_emission(reg, '2020'))=g=7*emissions_2020(reg);

post2100_emis_constraint1(t)$(year(t) > 2100)..
   Tot_emis(t) =L= Tot_emis(t-1);
   
$ontext

C_emissions_cons_1(reg,t+1)..
C_emission(reg, t+1)  =g= C_emission(reg, t)*0.5-200;

C_emissions_cons_2(reg,t+1)..
C_emission(reg, t+1)  =l= C_emission(reg, t)*1.5+200;


$offtext
*C_strg_tot_Q(reg,t)..
*        C_strg_tot(reg,t) =E=  sum( (ccs_fuel, en_out, C_capt),
C_capt_tot_Q(reg,t)..
C_capt_tot(reg,t) =E= sum( (ccs_fuel, en_out, C_capt),
    en_conv(ccs_fuel, en_out, C_capt,reg, t)*emis_fact(ccs_fuel)*capt_effic(ccs_fuel,c_capt,en_out) )
    + sum( (en_out, C_capt), en_conv("bio", en_out, C_capt,reg, t)*110 *capt_effic("bio",c_capt,en_out))
    + sum( (en_out, C_capt), en_conv("biogas", en_out, C_capt,reg, t)*50 *capt_effic("biogas",c_capt,en_out))
    + sum( (en_out, C_capt), en_conv("pellets", en_out, C_capt,reg, t)*80 *capt_effic("pellets",c_capt,en_out))
    +C_capt_air (reg,t);
*110gCO2 per MJ for BECCS
*ML not sure the numbers for biogas and pellets are correct
C_strg_agg_Q..
    C_strg_agg =E= sum((t,reg), C_strg_tot(reg,t))*t_step;

*q_max_beccs(c_capt,en_out,reg,t)..
*    en_conv("bio", en_out,c_capt,reg,t)=l=en_conv("coal", en_out,c_capt,reg,t)*max_beccs  ;

*annual_emis(t)..
*     sum(reg,C_emission(reg,t))=l=100000;
*max_emis(t);
*=l=100000;
*=e=max_emis(t);



elec_dec_Q(reg,t)..
     elec_decarb(reg,t) =E= sum( (fuels, dec_heat) , en_conv(fuels, dec_heat,"dec",reg, t)*dec_elec(fuels) );
*$ontext
Cal_CH4(reg)..
en_conv("gas1", "CH4", "0", reg, "2020")+ en_conv("gas2", "CH4", "0", reg, "2020")+en_conv("gas3", "CH4", "0", reg, "2020")=l= primary_cal_2020( reg,"CH4")*1.05 ;
Cal_oil(reg)..
en_conv("oil1", "oil", "0", reg, "2020")+ en_conv("oil2", "oil", "0", reg, "2020")+en_conv("oil3", "oil", "0", reg, "2020")=l= primary_cal_2020( reg, "oil")*1.05 ;
Cal_coal(reg)..
en_conv("coal1", "coal", "0", reg, "2020")+ en_conv("coal2", "coal", "0", reg, "2020")=l= primary_cal_2020( reg, "coal")*1.05 ;
Cal_bio_global..
sum(reg, en_conv("bio1", "bio", "0", reg, "2020")+ en_conv("bio2", "bio", "0", reg, "2020")+ en_conv("bio3", "bio", "0", reg, "2020"))=l= 60*1.10;
Cal_bio_EUR..
 en_conv("bio1", "bio", "0", "EUR", "2020")+ en_conv("bio2", "bio", "0", "EUR", "2020")+ en_conv("bio3", "bio", "0", "EUR", "2020")=g= 7.52*0.90;
Cal_bio_AFR..
 en_conv("bio1", "bio", "0", "AFR", "2020")+ en_conv("bio2", "bio", "0", "AFR", "2020")+ en_conv("bio3", "bio", "0", "AFR", "2020")=g= 15.4*0.90;



$ontext
Cal_road(reg, trsp_fuel)..
 sum( (car_or_bus, engine_type), trsp_energy(trsp_fuel, engine_type, car_or_bus, reg,"2020") )=l=  trsp_cal_road_2020(reg, trsp_fuel)*1.05;
$offtext

*#############################################################################################

model GET_12 /all/;

*#############################################################################################

$ include "constraints.gms"

*#############################################################################################

OPTION LIMROW = 0;
OPTION LIMCOL = 0;
OPTION ITERLIM = 999999999;
OPTION reslim = 999999999;
option solveopt=replace;
option sysout = off ;
option solprint = off   ;
$offlisting


option lp = cplex;
GET_12.optfile = 1;
solve GET_12 using LP minimizing tot_cost;


*display cost_inv
*display H2_prod.l ;

$include output3.gms
*$include output2.gms
*$include monte_carlo_v2.gms
