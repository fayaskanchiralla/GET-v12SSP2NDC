* Instruction: Activate the correct file depending on SSP and RCP.
*$CALL GDXXRW.EXE input_SSP1_19.xls @import_SSPdata.txt
*$CALL GDXXRW.EXE input_SSP1_26.xls @import_SSPdata.txt
*$CALL GDXXRW.EXE input_SSP2_19.xls @import_SSPdata.txt
$CALL GDXXRW.EXE input_SSP2_26.xls @import_SSPdata.txt
*$CALL GDXXRW.EXE input_SSP3_34.xls @import_SSPdata.txt
*$CALL GDXXRW.EXE input_SSP3_base.xls @import_SSPdata.txt

parameter  population ( reg, t_1 ) ;
parameter dem_base(energy, reg,t)  ;
parameter init_capital ( energy, en_out, type, reg) ;
*parameter init_energy( energy, en_out, type, reg) ;
parameter ptrsp( trsp_mode, reg,t_1) ;
parameter num_veh(trsp_mode,reg,t) ;
parameter frgt( trsp_mode, reg,t_1);
*parameter num_trucks( region, reg,t_1) ;
*parameter C_conc_trajectory(t)  ;
*parameter GDP(reg,t);
parameter scenario(scen,reg,t);
parameter supply_1_imp(primary, t, reg) ;
parameter elec_imp (second_in, t, en_out, type, reg);

*Remeber to change here as well when changing SSP demand
*$GDXIN input_SSP1_19.gdx
*$GDXIN input_SSP1_26.gdx
*$GDXIN input_SSP2_19.gdx
$GDXIN input_SSP2_26.gdx
*$GDXIN input_SSP3_34.gdx
*$GDXIN input_SSP3_base.gdx

$LOAD population
$LOAD dem_base
$LOAD init_capital
*$LOAD init_energy
$LOAD ptrsp
$LOAD num_veh
$LOAD frgt
*$LOAD C_conc_trajectory
*$LOAD GDP

$LOAD scenario
*$LOAD supply_1_imp
*$LOAD elec_imp
$GDXIN

parameters
trsp_demand_base(trsp_mode, reg,t)
dem(energy, reg,t) demand given in EJ
trsp_demand(trsp_mode, reg,t)   demand given in EJ
freight_demand(trsp_mode, reg,t) demand given in EJ
trajec(reg,t)
;

dem_base(sector, reg,t_ext) = dem_base(sector,reg, "2130");
num_veh(trsp_mode,reg,t_ext)=num_veh(trsp_mode, reg,"2130");
trsp_demand_base(trsp_mode, reg,t_1) = ptrsp( trsp_mode, reg,t_1)  ;
trsp_demand_base(frgt_mode , reg,t_1) = frgt( frgt_mode , reg,t_1)  ;
trsp_demand_base(trsp_mode, reg,t_ext) = trsp_demand_base(trsp_mode, reg,"2130") ;

dem(sector,reg, t) = dem_base(sector,reg,t);
trsp_demand(trsp_mode, reg,t) = trsp_demand_base(trsp_mode, reg,t) ;
*freight_demand("f_road",reg,t)=sum(heavy_mode, trsp_demand(heavy_mode,reg,t));
*???


$CALL GDXXRW.EXE tech-data.xls @import.txt
Parameter cost_inv_base (en_in, type, en_out) Mature investment cost (USD2010 per kW);
Parameter cost_inv_0 (en_in, type, en_out) Investment cost in 2010 (USD2010 per kW);
Parameter cost_eng_base(trsp_fuel, engine_type, trsp_mode) ;
parameter effic_0(energy, type, en_out);
Parameter heat_effic (en_in, type, en_out, energy);
Parameter capt_effic (energy, type, en_out);
parameter lf(en_in, type, en_out);
parameter elec_dem(reg,allslices,t);
parameter infra_cost(en_in, type, en_out);
parameter import_cost(second_in);
parameter emis_fact(energy);
parameter trsp_conv (trsp_fuel, engine_type, trsp_mode);
parameter cost_eng_0(trsp_fuel, engine_type, trsp_mode)      initial vehicle investment cost (vehicle + engine)
$GDXIN tech-data.gdx
$LOAD cost_inv_base
$LOAD cost_inv_0
$LOAD cost_eng_base
$LOAD effic_0
$LOAD heat_effic
$LOAD capt_effic
$LOAD lf
$LOAD infra_cost
$LOAD import_cost
$LOAD trsp_conv
$LOAD emis_fact
$LOAD cost_eng_0
$GDXIN







$CALL GDXXRW.EXE GISoutput.xlsx @importGIS.txt
parameter caplimit_windonshoreA(class, reg);
parameter caplimit_windonshoreB(class, reg);
parameter caplimit_windoffshore(class, reg);
parameter caplimit_pvrooftop(class, reg);
parameter caplimit_pvplantA(class, reg);
parameter caplimit_pvplantB(class, reg);
parameter caplimit_cspplantA(class, reg);
parameter caplimit_cspplantB(class, reg);
parameter caplimit_H2(class, reg);
*load factors for sliced wind and solar
parameter lf_windonshoreA(allslices, class, reg);
parameter lf_windonshoreB(allslices, class, reg);
parameter lf_windoffshore(allslices, class, reg);
parameter lf_pvrooftop(allslices, class, reg);
parameter lf_pvplantA(allslices, class, reg);
parameter lf_pvplantB(allslices, class, reg);
parameter lf_cspplantA(allslices, class, reg);
parameter lf_cspplantB(allslices, class, reg);
parameter lf_H2(allslices, class, reg);
*slice length (for capacities)
parameter lng(allslices, reg);
*unit of storage_slice_transfer_times is hours/year
parameter storage_slice_transfer_times(storage_tech,reg,allslices,allslices);
$GDXIN GISoutput.gdx
$LOAD caplimit_windonshoreA
$LOAD caplimit_windonshoreB
$LOAD caplimit_windoffshore
$LOAD caplimit_pvrooftop
$LOAD caplimit_pvplantA
$LOAD caplimit_pvplantB
$LOAD caplimit_cspplantA
$LOAD caplimit_cspplantB
$LOAD caplimit_H2
$LOAD lf_windonshoreA
$LOAD lf_windonshoreB
$LOAD lf_windoffshore
$LOAD lf_pvrooftop
$LOAD lf_pvplantA
$LOAD lf_pvplantB
$LOAD lf_cspplantA
$LOAD lf_cspplantB
$LOAD lf_H2
$LOAD lng
$LOAD storage_slice_transfer_times
$GDXIN

* NNN card() is a GAMS function that returns the number of elements in a set (no need for a num_slices parameter)
parameter slice_lng(reg, allslices);
slice_lng(reg, slice) = lng(slice, reg);
* slice_lng(reg,slice) = 1/card(slice);

parameter class_capacity_limit(class_tech, class, reg);
parameter class_capacity_limit_H2(class, reg);
class_capacity_limit("windonshoreA", class, reg) = caplimit_windonshoreA(class, reg) / 1000;
class_capacity_limit("windonshoreB", class, reg) = caplimit_windonshoreB(class, reg) / 1000;
class_capacity_limit("windoffshore", class, reg) = caplimit_windoffshore(class, reg) / 1000;
class_capacity_limit("pvrooftop", class, reg) = caplimit_pvrooftop(class, reg) / 1000;
class_capacity_limit("pvplantA", class, reg) = caplimit_pvplantA(class, reg) / 1000;
class_capacity_limit("pvplantB", class, reg) = caplimit_pvplantB(class, reg) / 1000;
class_capacity_limit("cspplantA", class, reg) = caplimit_cspplantA(class, reg) / 1000;
class_capacity_limit("cspplantB", class, reg) = caplimit_cspplantB(class, reg) / 1000;
class_capacity_limit_H2(class, reg) = caplimit_H2(class, reg) / 1000;

*load factors for sliced wind and solar
parameter lfsl(class_tech, class, reg, allslices);
parameter lfsl_H2(class, reg, allslices);
lfsl("windonshoreA", class, reg, slice) = lf_windonshoreA(slice, class, reg);
lfsl("windonshoreB", class, reg, slice) = lf_windonshoreB(slice, class, reg);
lfsl("windoffshore", class, reg, slice) = lf_windoffshore(slice, class, reg);
lfsl("pvrooftop", class, reg, slice) = lf_pvrooftop(slice, class, reg);
lfsl("pvplantA", class, reg, slice) = lf_pvplantA(slice, class, reg);
lfsl("pvplantB", class, reg, slice) = lf_pvplantB(slice, class, reg);
lfsl("cspplantA", class, reg, slice) = lf_cspplantA(slice, class, reg);
lfsl("cspplantB", class, reg, slice) = lf_cspplantB(slice, class, reg);
lfsl_H2(class, reg, slice) = lf_H2(slice, class, reg);

* make an indicator parameter to identify class_techs
* (can't use lfsl() because some combinations of class & slice are 0)
parameter is_class_tech(en_in);
is_class_tech(en_in) = 0;
is_class_tech(class_tech) = 1;

parameter lfs(en_in, type, reg, allslices, en_out);
lfs(en_in, type, reg, slice, en_out) =  lf(en_in, type, en_out);


parameter sliced_demand_baseline_regional(reg,allslices);
parameter sliced_demand(reg,allslices);
sliced_demand_baseline_regional(reg,allslices) = sliced_demand_baseline(allslices);
sliced_demand_baseline_regional(reg,allslices) $ (lf_pvplantA(allslices,'c4',reg) <= 0.05) = 1;
sliced_demand(reg,slice) = sliced_demand_baseline_regional(reg,slice) / sum(slice2, slice_lng(reg,slice2) * sliced_demand_baseline_regional(reg,slice2));
elec_dem(reg,slice,t) = dem("elec",reg,t) * slice_lng(reg,slice) * sliced_demand(reg,slice);


display sliced_demand_baseline_regional;

display caplimit_pvplantA;
display caplimit_windonshoreA;
display class_capacity_limit;
display lfsl;
display lng;
display slice_lng;
display storage_slice_transfer_times;
display effic_0;
display dem_base;
display num_veh;

