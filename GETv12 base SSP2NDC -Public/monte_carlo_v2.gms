*execseed = 1+gmillisec(jnow);

*** stochastics and statistics ***
set n_scen /1*2/
*n_scen /1*2/
*n_scen /1*300/
*set n_scen /1*100/
*set n_scen /1*400/

*MOL: added LCH4, LH2, and CH2
liquids_set(en_in) /coal, oil, petro, MeOH, H2, CH4, elec, LCH4, LH2, CH2/
;
parameters
mc_C_strg_agg(n_scen)
mc_tot_cost(n_scen)
mc_eltoH2(reg, t, n_scen)
mc_H2toMeOH(reg, t, n_scen)
mc_MeOHtotrsp(reg, t, n_scen)
mc_eltoH2_2070(reg, n_scen)
mc_H2toMeOH_2070(reg, n_scen)
mc_MeOHtotrsp_2070(reg, n_scen)
mc_electrolyser(n_scen)
mc_fuelsynthesis(n_scen)
mc_storage_max(n_scen)
mc_VRE(n_scen)
mc_FC_lim(n_scen)
mc_batteries_lim(n_scen)
mc_supply_pot_0(primary,reg)
mc_cost_infra(trsp_fuel, trsp_mode)
mc_bio(n_scen)
*mc_H2_trans(n_scen)
mc_infra_lim(n_scen)
mc_cost_strg(n_scen)
mc_CO2aircapt_cost(n_scen)
mc_FC_lim(n_scen)
mc_batteries_lim(n_scen)
mc_eff_el2h2(n_scen)
mc_eff_h22meoh(n_scen)
mc_report_c(reg,t, n_scen)
mc_lf_el2h2(reg,t,n_scen)
mc_MeOH2airfuel(reg,t,n_scen)
mc_to_storage(t,reg,n_scen)
potential_production_h2(reg,t)
production_h2(reg,t)
mc_carbon_budget(n_scen)
mc_liquids_2050(liquids_set, n_scen)
mc_meohfeed_2050(en_in, n_scen)
mc_h2feed_2050(en_in, n_scen)
mc_cost_eng_base(trsp_fuel, engine_type, trsp_mode)
mc_cost_inv_base(en_in,type, en_out)
$ontext
mc_meoh2050(n_scen)
mc_h22050(n_scen)
mc_elec2050(n_scen)
$offtext

storage_max
n_stat
VRE
bio_lim
H2_trans
infra_lim
cost_strg
fc_lim
batteries_lim
CO2aircapt_cost
;

mc_cost_inv_base("windonshoreA", "0", "elec")=cost_inv_base("windonshoreA", "0", "elec");
mc_cost_inv_base("windonshoreB", "0", "elec")=cost_inv_base("windonshoreB", "0", "elec");
mc_cost_inv_base("windoffshore", "0", "elec")=cost_inv_base("windoffshore", "0", "elec");
mc_cost_inv_base("pvrooftop", "0", "elec")=cost_inv_base("pvrooftop", "0", "elec");
mc_cost_inv_base("pvplantA", "0", "elec")=cost_inv_base("pvplantA", "0", "elec");
mc_cost_inv_base("pvplantB", "0", "elec")=cost_inv_base("pvplantB", "0", "elec");
mc_cost_inv_base("cspplantA", "0", "elec")=cost_inv_base("cspplantA", "0", "elec");
mc_cost_inv_base("cspplantB", "0", "elec")=cost_inv_base("cspplantB", "0", "elec");
mc_cost_inv_base("solar", "0", "H2")=cost_inv_base("solar", "0", "H2");
mc_cost_eng_base(FC_fuels, "FC", car_truck_ships)=cost_eng_base(FC_fuels, "FC", car_truck_ships);
mc_cost_eng_base(trsp_fuel, "PHEV", car_or_truck)=cost_eng_base(trsp_fuel, "PHEV", car_or_truck);
cost_eng_base("elec", "BEV", car_truck_ships)=cost_eng_base("elec", "BEV", car_truck_ships);

mc_supply_pot_0 ("bio1", reg)=supply_pot_0 ("bio1", reg);
mc_supply_pot_0 ("bio2", reg)=supply_pot_0 ("bio2", reg);
mc_supply_pot_0 ("bio3", reg)=supply_pot_0 ("bio3", reg);


table battery_cost(elec_veh, car_truck_ships)
            p_car        f_road       p_bus    f_container  f_cargo_bulk  f_oiltanker  f_gastanker  f_cargo_short  p_ferry_short  p_ferry_long  f_othership
PHEV        250          4500         4500     0            0             0            0            0              0              0             0
BEV         1000         13500        13500    0            0             0            0            1250           750            0             0
;
*used in monte-carlo runs need to checked with original: Fayas20241007
table veh_FC_cost(FC_fuels, car_truck_ships)
            p_car        f_road       p_bus    f_container  f_cargo_bulk  f_oiltanker  f_gastanker  f_cargo_short  p_ferry_short  p_ferry_long  f_othership
MeOH        1400         4400         4400     3501          7089          7089        7089         750            750             7089         0
LCH4        0            0            0        5764          10051         10051       10051        1098           1098            10051        0
CH2         1500         10800       10800     15538         24286         24286       24286        2454           2454            24286        0
LH2         0            0            0        5764          10051         10051       10051        1098           1098            10051        0
NH3         0            0            0        5764          10051         10051       10051        1098           1098            10051        0

;

n_stat=0;

loop ( n_scen,
    n_stat=n_stat+1;

*Availability of storage
    storage_max=uniform(0,30)*100000;
    C_strg_agg.up=storage_max;
*0;
*storage_max;

*Carbon budget
*    Cum_CO2_emis= uniform(700000,1255000);

*Cost of renewable Hydrogen investment

    cost_inv_base("elec", "0", "H2")=uniform(300,700);
    cost_inv_base("bio", "0", "H2")=uniform(1800,2500);
    cost_inv_base("bio", "dec", "H2")=uniform(2200,2800);

*Changed range to uniform(300,700), previously uniform(300,1300) to make variations symmetric from the base price
*Cost of MeOH production
    cost_inv_base("H2","0", "MeOH")=uniform(250,500);
    cost_inv_base("bio","0", "MeOH")=uniform(1500,2500);
    
*Cost of NH3 production

*    cost_inv_base("H2","0", "NH3")=uniform(400,800);


*Cost of VRE
    VRE=uniform(0.5,1.5);
    cost_inv_base("windonshoreA", "0", "elec")=mc_cost_inv_base("windonshoreA", "0", "elec")*VRE;
    cost_inv_base("windonshoreB", "0", "elec")=mc_cost_inv_base("windonshoreB", "0", "elec")*VRE;
    cost_inv_base("windoffshore", "0", "elec")=mc_cost_inv_base("windoffshore", "0", "elec")*VRE;
    cost_inv_base("pvrooftop", "0", "elec")=mc_cost_inv_base("pvrooftop", "0", "elec")*VRE;
    cost_inv_base("pvplantA", "0", "elec")=mc_cost_inv_base("pvplantA", "0", "elec")*VRE;
    cost_inv_base("pvplantB", "0", "elec")=mc_cost_inv_base("pvplantB", "0", "elec")*VRE;
    cost_inv_base("cspplantA", "0", "elec")=mc_cost_inv_base("cspplantA", "0", "elec")*VRE;
    cost_inv_base("cspplantB", "0", "elec")=mc_cost_inv_base("cspplantB", "0", "elec")*VRE;
    cost_inv_base("solar", "0", "H2")=mc_cost_inv_base("solar", "0", "H2")*VRE;

*$ontext
*Cost of FC (in vechicles and for electricity prod from H2)

    FC_lim=uniform(-1,1);
    cost_inv_base("H2", "0", "elec")=800+FC_lim*400;
    cost_inv_base("H2", "0", "elec")=800+FC_lim*400;
    cost_inv_base("H2", "cg", "elec")=1000+FC_lim*500;

    cost_eng_base(FC_fuels, "FC", car_truck_ships)=mc_cost_eng_base(FC_fuels, "FC", car_truck_ships)+FC_lim*veh_FC_cost(FC_fuels, car_truck_ships);

    cost_inv(en_in, en_out, type, t) $ (((ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type)) < 1) =
    cost_inv_0(en_in, type, en_out)-(cost_inv_0(en_in, type, en_out)-cost_inv_base(en_in, type, en_out))* ((ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type));

    cost_inv(en_in, en_out, type, t) $ (((ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type)) >= 1) =
    cost_inv_base(en_in, type, en_out);
*$offtext

*$ontext
*Cost of batteries (in vechicles and for electricity prod from H2)
    batteries_lim=uniform(-1,1);

    cost_eng_base(trsp_fuel, "PHEV", car_truck_ships)=mc_cost_eng_base(trsp_fuel, "PHEV", car_truck_ships)+batteries_lim*battery_cost("PHEV", car_truck_ships);
    cost_eng_base("elec", "BEV", car_truck_ships)=mc_cost_eng_base("elec", "BEV", car_truck_ships)+batteries_lim*battery_cost("BEV", car_truck_ships);


*$offtext
* Availability of biomass
    bio_lim=uniform(10,30);

    supply_pot_0 ("bio1", reg)= mc_supply_pot_0 ("bio1", reg)*bio_lim*10/134;
    supply_pot_0 ("bio2", reg)= mc_supply_pot_0 ("bio2", reg)*bio_lim*10/134;
    supply_pot_0 ("bio3", reg)= mc_supply_pot_0 ("bio3", reg)*bio_lim*10/134;

    supply_pot("bio1", reg,t)=supply_pot_0 ("bio1", reg);
    supply_pot("bio2", reg,t)=supply_pot_0 ("bio2", reg);
    supply_pot("bio3", reg,t)=supply_pot_0 ("bio3", reg);

$ontext
*H2 in transport
    H2_trans=uniformInt(0,1);
    engines.up("H2", engine_type, car_truck_ships, reg,t)=1000*H2_trans;
$offtext

*Infrastructure cost
*Varies the cost for methanol and H2 for all transport modes

$ontext
*### Transportation parameters ###
table cost_infra(trsp_fuel, car_truck_ships)  infrastr costs (USD per kW)
                 p_car f_road    p_bus  f_container   f_coast  f_ocean
      petro      700    700      700     100          100      100
      MeOH       1200   1200     1200    200          200      200
      H2         2700   2700     2700    2100         2100     2100
      CH4        2200   2200     2200    1600         1600     1600
*##########################################################################################################################
$offtext

infra_lim=uniform(-1,1);
mc_cost_infra("MeOH",car_or_truck)= cost_infra("MeOH",car_or_truck);
mc_cost_infra("MeOH",heavy_mode)= cost_infra("MeOH",heavy_mode);
mc_cost_infra("NH3",car_or_truck)= cost_infra("NH3",car_or_truck);
mc_cost_infra("NH3",heavy_mode)= cost_infra("NH3",heavy_mode);
mc_cost_infra("CH2",car_or_truck)= cost_infra("CH2",car_or_truck);
mc_cost_infra("CH2",heavy_mode)= cost_infra("CH2",heavy_mode);
mc_cost_infra("LH2",car_or_truck)= cost_infra("LH2",car_or_truck);
mc_cost_infra("LH2",heavy_mode)= cost_infra("LH2",heavy_mode);
mc_cost_infra("elec",car_or_truck)= cost_infra("elec",car_or_truck);
mc_cost_infra("elec",heavy_mode)= cost_infra("elec",heavy_mode);




cost_infra("MeOH",car_or_truck )= mc_cost_infra("MeOH",car_or_truck)+infra_lim*300;
cost_infra("MeOH",heavy_mode )= mc_cost_infra("MeOH",heavy_mode)+infra_lim*100;

cost_infra("NH3",car_or_truck )= mc_cost_infra("NH3",car_or_truck )+infra_lim*1000;
cost_infra("NH3",heavy_mode )= mc_cost_infra("NH3",heavy_mode)+infra_lim*200;

*MOL: added CH2, replacing H2; Adding LCH4, replacing CH4 --> discuss this in road.
cost_infra("CH2",car_or_truck )= mc_cost_infra("CH2",car_or_truck )+infra_lim*1500;
cost_infra("CH2",heavy_mode )= mc_cost_infra("CH2",heavy_mode )+infra_lim*1500;


cost_infra("LH2",car_or_truck )= mc_cost_infra("LH2",car_or_truck )+infra_lim*1500;
cost_infra("LH2",heavy_mode )= mc_cost_infra("LH2",heavy_mode )+infra_lim*1500;

cost_infra("elec",car_or_truck )= mc_cost_infra("elec",car_or_truck )+infra_lim*150;
cost_infra("elec",heavy_mode )= mc_cost_infra("elec",heavy_mode )+infra_lim*250;


*cost_eng_0(trsp_fuel, engine_type, car_truck_ships) = cost_eng_base(trsp_fuel, engine_type, car_truck_ships)*1.5;
cost_eng(trsp_fuel, engine_type, trsp_mode, t) =
 max( cost_eng_base(trsp_fuel, engine_type, trsp_mode),
    cost_eng_0(trsp_fuel, engine_type, trsp_mode) -
    (cost_eng_0(trsp_fuel, engine_type, trsp_mode)-cost_eng_base(trsp_fuel, engine_type, trsp_mode))*
    ((ord(t)-1)*t_step/t_tech_eng(trsp_fuel, engine_type, trsp_mode)) )
    + vehicle_cost(trsp_mode);

cost_inv_mod(en_in, en_out, type, t)= cost_inv(en_in, en_out, type, t);

cost_eng_mod(trsp_fuel, engine_type, trsp_mode, t) = cost_eng(trsp_fuel, engine_type, trsp_mode, t)          ;
*    (r_invest + 1/life_eng(road_fuel, engine_type, car_or_truck))/(r+1/life_eng(road_fuel, engine_type, car_or_truck));

cost_infra_mod(trsp_fuel, trsp_mode) = cost_infra(trsp_fuel, trsp_mode)         ;
*    (r_invest + 1/life_infra(new_trsp_fuel)) / (r + 1/life_infra(new_trsp_fuel))


*Cost of CO2 storage
     cost_strg=uniform(0.005,0.015);
*base cost_strg / 0.010 /

*Cost of air capture
     CO2aircapt_cost=uniform(0.03,0.90);
     
*base CO2aircapt_cost /0.5/

*efficiencies

effic_0("elec", "0", "H2" ) =uniform(0.60,0.80);

effic_0("H2", "0", "MeOH") = uniform(0.70,0.88);
effic_0("H2", "0", "NH3") = uniform(0.75,0.90);
effic_0("H2", "0", "CH2") = uniform(0.80,0.95);
effic_0("H2", "0", "LH2") = uniform(0.65,0.80);
*$ontext
effic(en_in, en_out, type, ROW,t)$(effic_0(en_in, type, en_out)>0.11 and effic_0(en_in, type, en_out)<0.95 ) = min(effic_0(en_in, type, en_out),
   (effic_0(en_in, type, en_out)-(effic_current(en_in, type, en_out)*0.7))/
      t_tech_effic(en_in, type, en_out)*((ord(t)-1)*t_step)+
        effic_current(en_in, type, en_out)*0.7 );

effic(en_in, en_out, type, ROW,t)$(effic_0(en_in, type, en_out)>=0.95 and effic(en_in, en_out, type, ROW,t)=0  )=effic_0(en_in, type, en_out);

effic(en_in, en_out, type, MIC,t)$(effic_0(en_in, type, en_out)>0.11 and effic_0(en_in, type, en_out)<0.95 ) = min(effic_0(en_in, type, en_out),
   (effic_0(en_in, type, en_out)-(effic_current(en_in, type, en_out)*0.8))/
      t_tech_effic(en_in, type, en_out)*((ord(t)-1)*t_step)+ effic_current(en_in, type, en_out)*0.8 );

effic(en_in, en_out, type, MIC,t)$(effic_0(en_in, type, en_out)>=0.95 and effic(en_in, en_out, type, MIC,t)=0  )=effic_0(en_in, type, en_out);

effic(en_in, en_out, type, OECD,t)$(effic_0(en_in, type, en_out)>0.11 and effic_0(en_in, type, en_out)<0.95  ) = min(effic_0(en_in, type, en_out),
   (effic_0(en_in, type, en_out)-(effic_current(en_in, type, en_out)*0.9))/
      t_tech_effic(en_in, type, en_out)*((ord(t)-1)*t_step)+
        effic_current(en_in, type, en_out)*0.9 );

effic(en_in, en_out, type, OECD,t)$(effic_0(en_in, type, en_out)>=0.95 and effic(en_in, en_out, type, OECD,t)=0  )=effic_0(en_in, type, en_out);


    OPTION bratio=1;
    SOLVE GET_12 USING LP MINIMIZING TOT_COST ;

mc_C_strg_agg(n_scen) = C_strg_agg.l +eps ;
mc_tot_cost(n_scen) = tot_cost.l+eps;
mc_eltoH2(reg, t, n_scen) =  en_conv.l( "elec","H2", "0", reg,t) * effic("elec","H2", "0",reg, t)+ eps;
mc_H2toMeOH(reg, t, n_scen) =  en_conv.l( "H2","MeOH", "0", reg,t) * effic("H2","MeOH", "0",reg, t)+ eps;
mc_MeOHtotrsp(reg, t, n_scen) = sum((engine_type,trsp_mode), trsp_energy.L("MeOH", engine_type, trsp_mode, reg,t))+eps;
mc_eltoH2_2070(reg,n_scen) =  en_conv.l( "elec","H2", "0", reg,"2070") * effic("elec","H2", "0",reg, "2070")+ eps;
mc_H2toMeOH_2070(reg,n_scen) =  en_conv.l( "H2","MeOH", "0", reg,"2070") * effic("H2","MeOH", "0",reg, "2070")+ eps;
mc_MeOHtotrsp_2070(reg,n_scen) = sum((engine_type,trsp_mode), trsp_energy.L("MeOH", engine_type, trsp_mode, reg,"2070"))+eps;
mc_storage_max(n_scen)= storage_max;
mc_electrolyser(n_scen)=  cost_inv_base("elec", "0", "H2")+eps;
mc_fuelsynthesis(n_scen)= cost_inv_base("H2", "0", "MeOH")+eps;
mc_VRE(n_scen)=VRE+eps;
mc_bio(n_scen)=bio_lim+eps;
*mc_H2_trans(n_scen)=H2_trans+eps;
mc_infra_lim(n_scen) =  infra_lim+eps;
mc_cost_strg(n_scen) =cost_strg+eps;
mc_CO2aircapt_cost(n_scen)=CO2aircapt_cost+eps;
mc_fc_lim(n_scen)=fc_lim+eps;
mc_batteries_lim(n_scen)=batteries_lim+eps;
mc_eff_el2h2(n_scen)=effic_0("elec","0", "H2")+eps;
mc_eff_h22meoh(n_scen)=effic_0("H2", "0", "MeOH")+eps;
mc_report_c(reg,t,n_scen) = emission_Q.M(reg,t)*((1+R)**((ord(t)-1)*t_step))/t_step+eps;
potential_production_h2(reg,t) =  Msec_per_year * capital.l("elec","H2","0",reg,t);
production_h2(reg,t) =  en_conv.L("elec","H2","0", reg,t)*effic("elec","H2","0", reg,t);
mc_lf_el2h2(reg,t,n_scen)$ potential_production_h2(reg,t)  = production_h2(reg,t)/potential_production_h2(reg,t);
mc_MeOH2airfuel(reg,t,n_scen) =  en_conv.L("MeOH","air_fuel","0", reg,t)*effic("MeOH","air_fuel","0", reg,t)+eps;
mc_to_storage(t,reg,n_scen) = sum((storage_tech,slice,slice2), storage_slice_transfer.l(storage_tech,reg,slice,slice2,t))+eps;
mc_carbon_budget(n_scen) =  Cum_CO2_emis;
mc_liquids_2050 (liquids_set, n_scen) =sum((type,reg), (en_conv.l(liquids_set, "trsp", type,reg, "2050") * effic(liquids_set, "trsp", type, reg,"2050")))+ sum((type,reg), (en_conv.l(liquids_set, "feed-stock", type,reg, "2050") * effic(liquids_set, "feed-stock", type, reg, "2050"))) + eps;
mc_meohfeed_2050(en_in, n_scen)=sum((type,reg), en_conv.l(en_in, "MeOH", type,reg, "2050"))+eps;
mc_h2feed_2050(en_in, n_scen)=sum((type,reg), en_conv.l(en_in, "H2", type,reg, "2050"))+eps;

$ontext
mc_meoh2050 (n_scen)= sum((type,reg), (en_conv.l("MeOH", "trsp", type,reg, "2050") * effic("MeOH", "trsp", type, reg,"2050")))+ sum((type,reg), (en_conv.l("MeOH", "feed-stock", type,reg, "2050") * effic("MeOH", "feed-stock", type, reg, "2050")))/
sum((type,reg, liquids_set), (en_conv.l(liquids_set, "trsp", type,reg, "2050") * effic(liquids_set, "trsp", type, reg,"2050")))+ sum((type,reg, liquids_set), (en_conv.l(liquids_set, "feed-stock", type,reg, "2050") * effic(liquids_set, "feed-stock", type, reg, "2050"))) + eps;
mc_h22050 (n_scen)= (sum((type,reg), (en_conv.l("H2", "trsp", type,reg, "2050") * effic("H2", "trsp", type, reg,"2050")))+
(sum((type,reg), (en_conv.l("H2", "feed-stock", type,reg, "2050") * effic("H2", "feed-stock", type, reg, "2050"))))/
sum((type,reg, liquids_set), (en_conv.l(liquids_set, "trsp", type,reg, "2050") * effic(liquids_set, "trsp", type, reg,"2050")))+
sum((type,reg, liquids_set), (en_conv.l(liquids_set, "feed-stock", type,reg, "2050") * effic(liquids_set, "feed-stock", type, reg, "2050")))) + eps;
mc_elec2050 (n_scen)= sum((type,reg), (en_conv.l("elec", "trsp", type,reg, "2050") * effic("elec", "trsp", type, reg,"2050")))+ sum((type,reg), (en_conv.l("elec", "feed-stock", type,reg, "2050") * effic("elec", "feed-stock", type, reg, "2050")))/
sum((type,reg, liquids_set), (en_conv.l(liquids_set, "trsp", type,reg, "2050") * effic(liquids_set, "trsp", type, reg,"2050")))+ sum((type,reg, liquids_set), (en_conv.l(liquids_set, "feed-stock", type,reg, "2050") * effic(liquids_set, "feed-stock", type, reg, "2050"))) + eps;
$offtext

);


execute_unload "monte_carlo.gdx"   mc_C_strg_agg, mc_tot_cost, mc_eltoH2, mc_H2toMeOH, mc_MeOHtotrsp, mc_eltoH2_2070, mc_H2toMeOH_2070,
                                   mc_MeOHtotrsp_2070, mc_electrolyser, mc_storage_max, mc_VRE, mc_bio, mc_infra_lim,mc_fuelsynthesis,
                                   mc_cost_strg, mc_CO2aircapt_cost, mc_eff_el2h2,mc_eff_h22meoh, mc_report_c, mc_lf_el2h2,
                                   mc_MeOH2airfuel, mc_carbon_budget mc_liquids_2050, mc_meohfeed_2050,mc_h2feed_2050, mc_batteries_lim,
                                   mc_fc_lim

execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_tot_cost rng=tot_cost! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_C_strg_agg rng=C_strg_agg! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_storage_max  rng=storage_max! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_eltoH2 rng=eltoH2! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_H2toMeOH rng=H2toMeOH! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_MeOHtotrsp rng=MeOHtotrsp! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_eltoH2_2070 rng=Efuels!B25:ALN35 Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_H2toMeOH_2070 rng=Efuels!B13:ALN23 Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_MeOHtotrsp_2070 rng=Efuels!B1:ALN11 Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_electrolyser rng=electrolyser! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_fuelsynthesis rng=fuelsynthesis! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_VRE rng=VRE! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_bio rng=bio! Cdim=1'
*execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_H2_trans rng=H2_trans! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_infra_lim rng=Infra_lim! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_fc_lim rng=fc_lim! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_batteries_lim rng=batteries_lim! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_cost_strg rng=cost_strg! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_CO2aircapt_cost rng=CO2aircapt_cost! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_eff_el2h2 rng=eff_el2h2! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_eff_h22meoh rng=eff_h22meoh! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_report_c rng=carbon_price! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_lf_el2h2 rng=mc_lf_el2h2! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_MeOH2airfuel rng=mc_MeOH2airfuel! Cdim=2'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_carbon_budget rng=mc_carbon_budget! Cdim=1'
*execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_meoh2050 rng=mc_meoh2050! Cdim=1'
*execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_h22050 rng=mc_h22050! Cdim=1'
*execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_elec2050 rng=mc_elec2050! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_liquids_2050 rng=mc_liquids_2050! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_meohfeed_2050 rng=mc_meohfeed_2050! Cdim=1'
execute 'gdxxrw.exe monte_carlo.gdx epsout=0 par=mc_h2feed_2050 rng=mc_h2feed_2050! Cdim=1'

