*### PARAMETERS ###


scalars

Msec_per_year / 31.6 /
t_step        / 10   /



*nitrousoxide emission is added-fmk (3-10 times regular emission which is 0.01gperkwh)
*TTW_N2O for 0.1gperkWh /13.41/
TTW_N2O MtCO2eqperEJ_for 0.03gperkWh /4.023/

*methane slip for the naturalgas
*WTT_CH4 MtCO2eqperEJ_for 0.5% leakage /3.12/
WTT_CH4 MtCO2eqperEJ_for 1% leakage /6.24/
*WTT_CH4 MtCO2eqperEJ_for 1.5% leakage /9.36/
*WTT_CH4 MtCO2eqperEJ_for 2% leakage /12.48/


*methane slip for the liquid methane to distribution

Distrib_LCH4 MtCO2eqperEJ_for 0.5% leakage /3.12/
*Distrib_LCH4 MtCO2eqperEJ_for 1% leakage /6.24/
*Distrib_LCH4 MtCO2eqperEJ_for 2% leakage /12.48/
;
parameters
*methane slip is updated-fmk (1-5 gperkwh)
*extra_emis_CH4 /0/
*extra_emis_CH4 MtCO2eqperEJ_for_1gperkWh /3.75/
*extra_emis_CH4 MtCO2eqperEJ_for_2gperkWh /7.5/
*extra_emis_CH4 MtCO2eqperEJ_for_4gperkWh /15/
*extra_emis_CH4 MtCO2eqperEJ_for_5gperkWh /18.75/
*$ontext
extra_emis_CH4(heavy_mode) MtCO2eqperEJ_for_2gperkWh
/f_cargo_short   15
p_ferry_short    15
p_ferry_long     15
f_othership      15
f_container      3.75
f_cargo_bulk     3.75
f_oiltanker      3.75
f_gastanker      3.75
/
;
*$offtext
parameter
ship_levy(t)
*tax om shipping emission in kUSD2010/tCO2
*$ontext
/2010       0
2020        0
2030        0
2040        0
2050        0
2060        0
2070        0
2080        0
2090        0
2100        0
2110        0
2120        0
2130        0
2140        0
2150        0/
*$offtext

$ontext
/2010       0
2020        0
2030        0.050
2040        0.100
2050        0.150
2060        0.150
2070        0.150
2080        0.150
2090        0.150
2100        0.150
2110        0.150
2120        0.150
2130        0.150
2140        0.150
2150        0.150 /
$offtext


parameters
supply_pot(primary, reg,t)                               max supply potential
effic(energy, en_out, type,reg, t)                       energy conv effic
life_plant(en_in, en_out, type)                          life time
life_eng(trsp_fuel, engine_type, trsp_mode)              life time
lf_infra(trsp_fuel)                                      loadfactor
vehicle_cost(trsp_mode)                                  basic cost for vehicle w gasoline or marin gas oil IC engine
t_tech_plant(en_in, en_out, type)                        technology developm time
t_tech_eng(trsp_fuel, engine_type, trsp_mode)            technology developm time
t_tech_effic(en_in, type, en_out)
effic_current(en_in, type, en_out)
max_beccs
Cum_CO2_emis
distance (reg, reg)                                      [km]
imp_cost_lin(second_in)                                  linear import  cost based on distance


OM_cost_fr(en_in, en_out)  operation & maintanance cost as fraction of capital cost

year(t)  ;
year(t)=2010+(ord(t)-1)*10;



table price(fuels, reg)               basic fuel prices USD per GJ (GUSD per EJ)
          AFR        CPA        EUR        FSU        LAM        MEA        NAM        PAO        PAS        SAS
bio1      1.6        2.2        2.4        2.1        2.4        2.5        2.7        2.7        1.9        1.5
bio2      2.7        3.7        3.0        2.3        2.0        12.7        3.1       3.5        2.9        3.1
bio3      3.9        6.5        4.2        3.6        3.1        13.9        5.4       4.5        3.7        4.8
coal1     1.5        1.5        1.5        1.5        1.5        1.5        1.5        1.5        1.5        1.5
coal2     3          3          3          3          3          3          3          3          3          3
oil1      4          4          4          4          4          4          4          4          4          4
oil2      6          6          6          6          6          6          6          6          6          6
oil3      10         10         10         10         10         10         10         10         10         10
gas1      2.5        2.5        2.5        2.5        2.5        2.5        2.5        2.5        2.5        2.5
gas2      5          5          5          5          5          5          5          5          5          5
gas3      7          7          7          7          7          7          7          7          7          7
uranium1  0.07       0.07       0.07       0.07       0.07       0.07       0.07       0.07       0.07       0.07
uranium2  0.14       0.14       0.14       0.14       0.14       0.14       0.14       0.14       0.14       0.14
uranium3  0.23       0.23       0.23       0.23       0.23       0.23       0.23       0.23       0.23       0.23
uranium4  0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4
uranium5  1.3        1.3        1.3        1.3        1.3        1.3        1.3        1.3        1.3        1.3
;

*$ontext
table distance (reg, reg)    km
         NAM     EUR     PAO     FSU     AFR     PAS     LAM     MEA     CPA     SAS
NAM      0       6800    9600    7900    10400   13300   8100    10000   10100   12800
EUR      6800    0       9700    2500    4200    9400    8713    3200    8200    7000
PAO      9600    9700    0       7500    12200   4600    17700   9600    2100    6700
FSU      7900    2500    7500    0       5200    7100    11200   2900    5800    5000
AFR      10400   4200    12200   5200    0       9200    7600    2600    10100   6200
PAS      13300   9400    4600    7100    9200    0       16600   7300    3300    3000
LAM      8100    8713    17700   11200   7600    16600   0       9900    16900   13800
MEA      10000   3200    9600    2900    2600    7300    9900    0       7600    4400
CPA      10100   8200    2100    5800    10100   3300    16900   7600    0       4800
SAS      12800   7000    6700    5000    6200    3000    13800   4400    4800    0
*$offtext
;

parameters
imp_cost_lin(second_in)
/
bio              0.000033
oil              0.000015
LH2              0.00015
CH2              0.0004
elec             0.009
MeOH             0.000033
biogas           0.00003
ethanol          0.000048
biodiesel        0.00003
petro            0.000015
air_fuel         0.000015
LCH4             0.00003
coal             0.000015
pellets          0.000033
EU4              0.000015
EU1              0.000015
Pu               0.000015
FBF              0.000015
MOX              0.000015
Rep1             0.0009
Rep2             0.0009
Rep3             0.0009
sLWRf            0.000015
BrProd           0.000015
sCANDUf          0.0009
sMoxf            0.0009
NH3              0.000045
/
;


table supply_pot_0 (primary, reg)     max supply potential (EJ) - annual for renewables and aggregated for fossils
            AFR        CPA        EUR        FSU        LAM        MEA        NAM        PAO        PAS        SAS
*bio1        1.5        2.5        2          0.5        2          0.5        2          0.5        0.5        2
*bio2        9          1          1.5        2.5        5.5        0          4          2          2.5        0.5
*bio3        8          1          1.5        2.5        4.5        0          2.5        2          2          0.5
bio1        3          5          4          1          4          1          4          1          1          4
bio2        18         2          3          5          11         0          8          4          5          1
bio3        16         2          3          5          9          0          5          4          4          1
coal1       744        3795       408        2952       240        48         5520       1080       360        2325
coal2       1080       18305      1680       13920      600        240        14280      2880       960        8614
oil1        677        188        153        927        903        4203       628        37         140        44
oil2        1708       904        671        2257       2196       6405       1525       183        458        246
oil3        427        649        183        2196       2745       61         7869       793        31         123
gas1        507        73         234        2379       351        296        351        156        351        123
gas2        1755       176        975        3705       1170       4095       1170       390        975        214
gas3        1365       714        122        1170       2145       780        2535       780        585        846
uranium1    140        21         0          29         82         0          214        0          0          0
uranium2    314        72         4          452        143        65         284        0          942        0
uranium3    606        82         50         789        176        76         404        7          977        47
uranium4    612        86         78         1014       178        79         594        7          981        47
uranium5    10000      10000      10000      10000      10000      10000      10000      10000      10000      10000
wind        100        100        100        100        100        100        100        100        100        100
*not really used for wind and solar
hydro       2.6        3.8        2.8        8.0        7.7        0.4        3.0        0.6        2.7        1.6
solar       200        200        200        200        200        200        200        200        200        200
;

$ontext
* Code to modify the biomass supply potential. To activate the code remove the dollar signs (ontext/offtext). Change the default factor 3 the rows below.
* When the factors are changed the values in the tables will change accordingly.
*Conflictual_liquidfuelspaper
supply_pot_0 ("bio1", reg)= 3* supply_pot_0 ("bio1", reg);
supply_pot_0 ("bio2", reg)= 3* supply_pot_0 ("bio2", reg);
supply_pot_0 ("bio3", reg)= 3* supply_pot_0 ("bio3", reg);
$offtext

supply_pot(primary, reg,t) = supply_pot_0(primary,reg);

table min_bio(reg, t)
           2010        2020        2030        2040        2050        2060        2070        2080        2090        2100     2110    2120        2130        2140
AFR        1.09        1.12        0.80        0.56        0.40        0.37        0.35        0.32        0.30        0.28     0.28    0.28        0.28        0.28
CPA        0.80        0.44        0.37        0.32        0.27        0.25        0.22        0.20        0.19        0.17     0.17    0.17        0.17        0.17
EUR        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00     0.00    0.00        0.00        0.00
FSU        0.02        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00     0.00    0.00        0.00        0.00
LAM        0.22        0.32        0.10        0.06        0.05        0.03        0.03        0.02        0.02        0.02     0.02    0.02        0.02        0.02
MEA        0.05        0.05        0.04        0.03        0.02        0.02        0.02        0.01        0.01        0.01     0.01    0.01        0.01        0.01
NAM        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00     0.00    0.00        0.00        0.00
PAO        0.01        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00        0.00     0.00    0.00        0.00        0.00
PAS        0.28        0.17        0.11        0.07        0.03        0.00        0.00        0.00        0.00        0.00     0.00    0.00        0.00        0.00
SAS        1.17        1.10        0.85        0.65        0.50        0.46        0.42        0.39        0.36        0.33     0.33    0.33        0.33        0.33
;

table el_2010(reg, calibration_set)
           bio         coal           EU4         CH4        hydro        oil         wind           solar
AFR        0.00        1.13251        0.04        0.13        0.30        0.04        0.00553        0.005
CPA        0.00        10.19588       0.24        0.21        2.47        0.16        0.13962        0.000
EUR        0.26        3.55821        3.62        2.82        2.16        0.29        0.59749        0.000
FSU        0.01        0.93831        0.83        2.39        0.77        0.09        0              0.000
LAM        0.01        0.12           0.10        0.51        2.44        0.72        0              0.000
MEA        0.00        0.24045        0.00        2.25        0.19        1.14        0.01122        0.003
NAM        0.34        8.17594        3.30        2.56        2.34        0.11        0.33385        0.020
PAO        0.13        1.83545        1.17        0.86        0.49        0.32        0.03784        0.020
PAS        0.00        2.07964        0.67        1.27        0.18        0.31        0              0.003
SAS        0.01        2.49357        0.08        0.44        0.66        0.18        0.0812         0.000

;
PARAMETERS
*calibrations for 2020 based on BP statistics for 2016 (commented values)
*MOL: the updated 2020 values are based on BP 2020 statistics

solar_pv_2020(reg)/

*MOL: Values with BP statistics 2020 real data
AFR        0.026279790
CPA        1.033911729
EUR        0.644034848
FSU        0.016919865
LAM        0.107999136
MEA        0.065879473
NAM        0.498236014
PAO        0.300014400
PAS        0.050759594
SAS        0.220318237
/

wind_2020(reg) /

*MOL: Values with BP statistics 2020 real data
AFR        0.034559724
CPA        1.691086471
EUR        1.836345309
FSU        0.008999928
LAM        0.337317301
MEA        0.046079631
NAM        1.357189142
PAO        0.117719058
PAS         0.021599827
SAS         0.229318165
/

nuclear_2020(reg) /

*MOL: Values with BP statistics 2020 real data
AFR        0.056700000
CPA        1.891350000
EUR        3.013200000
FSU        0.781650000
LAM        0.133650000
MEA        0.028350000
NAM        3.345300000
PAO        0.153900000
PAS        0.275400000
SAS        0.194400000
/

hydro_2020(reg) /

*MOL: Values with BP statistics 2020 real data
AFR       0.457650000
CPA        5.026050000
EUR        2.357100000
FSU        0.931500000
LAM        2.174850000
MEA        0.137700000
NAM       2.421900000
PAO        0.419820000
PAS        0.194400000
SAS        0.753300000
/

solar_pv_2030(reg)/

*MOL: Values with BP statistics 2022 real data
AFR        0.04068
CPA        1.348549
EUR        0.704154
FSU        0.0144
LAM        0.154439
MEA        0.065159
NAM        0.614155
PAO         0.312521
PAS          0.05076
SAS          0.255598
/

wind_2030(reg) /

*MOL: Values with BP statistics 2022 real data
AFR        0.04176
CPA        2.380301
EUR        1.810786
FSU        0.01656
LAM        0.42717
MEA        0.05004
NAM        1.507308
PAO        0.134999
PAS         0.02124
SAS         0.259918
/


emissions_2010(reg)/
AFR        685.90
CPA        7141.94
EUR        3817.11
FSU        2105.71
LAM       1431.82
MEA       5027.93
NAM       5400.61
PAO       1520.56
PAS        1854.50
SAS        4487.49

/

emissions_2020(reg)/

AFR       838.30
CPA       10829.0
EUR       3596.80
FSU       2006.30
LAM       1317.60
MEA       2404.80
NAM       4974.90
PAO       1433.40
PAS       1723.30
SAS       2617.10
/
;
table primary_cal_2020(reg, calibration_set)
        oil       CH4      coal
AFR      5         2         4
CPA      31       12         81
EUR      34       36         17
FSU      40        32       14
LAM      52        35       15
MEA       2        2         0
NAM       8        7         1
PAO      10        6         7
PAS      18        7         11
SAS      11        5         20
;
table    trsp_cal_road_2020(reg, trsp_fuel)
           LCH4        petro        elec        MeOH    CH2
AFR        0.02        4.24        0.00        0.02     0.00
CPA        1.44        11.11       0.03        0.34     0.00
EUR        0.11        16          0.01        0.04     0.00
FSU        0.04        4.18        0.00        0.63     0.00
LAM        0.22        9.37        0.00        1.55     0.00
MEA        0.29        6.83        0.00        0.00     0.00
NAM        0.17        26          0.00        0.01     0.00
PAO        0.16        5.52        0.00        0.15     0.00
PAS        0.25        7.32        0.00        0.14     0.00
SAS        0.08        6           0.00        0.15     0.00
;


Parameters
* Test different disc. rents. (Remember r and r_invest, they must be the same)
r         discount rate
    / 0.05 /
*    / 0.03 /
r_invest  interest rate applied to investments
    / 0.05 /
*    / 0.03 /
C_tax(reg,t)  (kUSD per ton C)

Pu_start/
AFR   0
CPA   0
EUR   0
FSU   0
LAM   0
MEA   0
NAM   0
PAO   0
PAS   0
SAS   0
 /

*-----------Direct air capture------------------

CO2aircapt_cost  cost for capturing CO2 from air  (GUSD per MtCO2)
/0.5/

heat_CO2aircapture heat demand for capturing CO2 from air (EJ per Mt CO2 capture)
/0.0047/
El_DAC electricity demand for DAC (EJ per Mt CO2 capture)
/0.00252/
cost_strg    carbon transport and storage cost(GUSD per MtCO2)
/ 0.010 /


*max_beccs
* /1/

dec_elec(en_in)   electricity requirements for heat generation with C capture
/     bio   0.04
      coal  0.04
      oil   0.03
      CH4   0.025  /;

*### Technology and sector paramaters ###
parameters

district_cost  cost to distribute wasteheat to central_heat
         /5/
cogen_fr_h   max fraction of urban heat from cogeneration
    / 0.6 /

C_capt_heat(dec_heat)  max fraction of sector that can use C_capt
/central_heat     0.7
solid_heat      0.5
non_solid_heat  0.5  /

max_feed(feed)  Feedstock fractions
*biogas ethanol and biodiesel are at the moment not activated in the model (methanol is the proxy for all type liquid synthetic fuels)
*From the current perspective, and according to FUTNERC input, at the moment very little chemical industries use directly crude oil to produce e.g., plastics), and the ones that use have some kind of internal processing.
*Accordingly, at the moment, crude oil is not being directly used as feedstock, but instead petro represented refined oil that can be used directly as feedstock.
*FUTNERC also suggested to dismiss coal directly as feedstock
*For future work, looking at the possibility of CH4 being also used to produce petro (paper 4 Maria OL)
*Coal was added back
*FMK comment oil can be also considered as low cost fraction like naphtha is used in industry
/CH4     0.1
biogas   0.1
ethanol   1
biodiesel 1
coal      0.1
oil       0.1
petro     1
MeOH      1/
;

$ontext
*MOL: ammonia required for fertilizers each year. It is connected to the equation feedstock_NH3_Q(reg,t)
table feedstock_NH3(reg,t)

            2010        2020        2030        2040        2050        2060        2070        2080        2090        2100        2110
AFR     0.0166      0.0194      0.0407      0.0517      0.0722      0.1042      0.1566      0.2408      0.3581      0.5042      0.5042
CPA     0.4511      0.5602      1.3540      1.2896      1.2528      1.1711      1.0748      0.9845      0.9076      0.8626      0.8626
EUR     0.3743      0.4163      0.4483      0.3892      0.3610      0.3274      0.2781      0.2441      0.2160      0.1952      0.1952
FSU     0.2121      0.2820      0.3498      0.3052      0.2933      0.2833      0.2713      0.2603      0.2483      0.2456      0.2456
LAM     0.2599      0.3479      0.5066      0.5598      0.6259      0.6806      0.7259      0.7633      0.7987      0.8365      0.8365
MEA     0.5405      0.5631      0.6107      0.5223      0.4887      0.4501      0.4033      0.3306      0.2759      0.2362      0.2362
NAM     0.1408      0.1559      0.1622      0.1325      0.1183      0.1037      0.0883      0.0691      0.0554      0.0452     0.0452
PAO     0.3501      0.5000      0.6996      0.7186      0.7385      0.7457      0.7419      0.7311      0.7100      0.7010      0.7010
PAS     0.1415      0.2289      0.4202      0.5050      0.6000      0.6849      0.7511      0.8012      0.8345      0.8884      0.8884
SAS     0.3231      0.3602      0.3844      0.3356      0.3134      0.2845      0.2394      0.2088      0.1839      0.1652      0.1652
;
$offtext
Parameters

$ontext
max_emis(t) maximum emissions
/2010        31029
2020        34286
2030        24552
2040        10276
2050        3138
2060        -431
2070        -2215
2080        -3108
2090        -3554
2100        -3473
2110        -3210
2120        -2815
2130        -2222
2140        -1333
2150        0/
$offtext

emis_fact2 shipping emissions
/MeOH      65
LH2        0
CH2        0
elec       0
petro      65
air_fuel   65
LCH4       52
biogas      0
ethanol     0
biodiesel   0
NH3         0
CH4        52/

Shipping_emis_cons(t) constraint on shipping emissions
/2010       50000
2020        50000
2030        50000
2040        50000
2050        50000
2060        50000
2070        50000
2080        50000
2090        50000
2100        50000
2110        50000
2120        50000
2130        50000
2140        50000
2150        50000 /


max_chip maximum wood chips in industry
   /0.67/   ;

table max_solar(heat,reg) maximum solar
                    AFR        CPA        EUR        FSU        LAM        MEA        NAM        PAO        PAS        SAS
central_heat        0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2
dist_heat           0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4        0.4
 ;

table max_pump(heat,reg)   maximum heat pumps
                 AFR        CPA        EUR        FSU        LAM        MEA        NAM        PAO        PAS        SAS
central_heat     0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2        0.2
dist_heat        0.6        0.6        0.6        0.6        0.6        0.6        0.6        0.6        0.6        0.6
;

table ramp_lim(thermalelec,type)
        0    cg   dec   cg_dec
bio     0.5  0.5  0.5   0.5
oil     0.2  0.2  0.2   0.2
CH4     0.2  0.2  0.2   0.2
coal    0.5  0.5  0.5   0.5
EU4     0.7  0.7  0.7   0.7
EU1     0.7  0.7  0.7   0.7
FBF     0.7  0.7  0.7   0.7
MOX     0.7  0.7  0.7   0.7
hydro   0.2  0.2  0.2   0.2;
;
$ontext
        0    cg   dec   cg_dec
bio     0.35 0.35 0.35  0.35
oil     0.1  0.1  0.1   0.1
CH4     0.1  0.1  0.1   0.1
coal    0.35 0.35 0.35  0.35
EU4     0.7  0.7  0.7   0.7
EU1     0.7  0.7  0.7   0.7
FBF     0.7  0.7  0.7   0.7
MOX     0.7  0.7  0.7   0.7
hydro   0.1  0.1  0.1   0.1;
$offtext
Parameters

low_infra_cap_factor 33% utilisation factor multiply by factor of 3 /3/
high_infra_cap_factor 50% utilisation factor /2/;

*### Transportation parameters ###
table cost_infra(trsp_fuel, trsp_mode)  infrastr costs (USD per kW) 
                 p_car   f_LCV   f_MDT_LH   f_MDT_RD  f_HDT_LH  f_HDT_RD  p_bus  f_container f_cargo_bulk   f_oiltanker   f_gastanker   f_cargo_short   p_ferry_short   p_ferry_long   p_air_short   p_air_medium   p_air_long   f_air   p_rail   f_rail  f_othership
      petro      700     700     700        700       700       700       700    100         100            100           100           100             100             100            100           100            100          100     1        1       100
      MeOH       1200    1200    1200       1200      1200      1200      1200   200         200            200           200           200             200             200            200           200            200          200     1        1       200 
      ethanol    1200    1200    1200       1200      1200      1200      1200   200         200            200           200           200             200             200            200           200            200          200     1        1       200
      CH2        3500    3500    3500       3500      3500      3500      3500   4500        4500           4500          4500          4500            4500            4500           4500          4500           4500         4500    1        1       4500
      LH2        2700    2700    2700       2700      2700      2700      2700   3500        3500           3500          3500          3500            3500            3500           3500          3500           3500         3500    1        1       3500
      LCH4       2200    2200    2200       2200      2200      2200      2200   1600        1600           1600          1600          1600            1600            1600           1600          1600           1600         1600    1        1       1600
      biogas     2200    2200    2200       2200      2200      2200      2200   1600        1600           1600          1600          1600            1600            1600           1600          1600           1600         1600    1        1       1600
      biodiesel  720     720     720        720       720       720       720    200         200            200           200           200             200             200            200           200            200          200     1        1       200
      NH3        2400    2400    2400       2400      2400      2400      2400   400         400            400           400           400             400             400            400           400            400          400     1        1       400
      elec       350     350     350        350       400       400       350    500         500            500           500           500             500             500            500           500            500          500     1        1       500
;
$ontext
* The capacity factor can be included in the cost calculation

cost_infra (trsp_fuel, trsp_mode)$(not sameas(trsp_fuel,"elec"))= high_infra_cap_factor * cost_infra (trsp_fuel, trsp_mode);
cost_infra ("elec", trsp_mode)= low_infra_cap_factor * cost_infra ("elec", trsp_mode);
$offtext

parameters
life_infra(trsp_fuel)  life time for infrastructure
    / petro      50
      MeOH       50
      LH2        50
      CH2        50
      LCH4       50
      biogas     50
      ethanol    50
      biodiesel  50
      NH3        50/

elec_frac_PHEV(car_or_truck)
/p_car      0.60
f_LCV       0.60
f_MDT_LH    0.30
f_MDT_RD    0.50
f_HDT_LH    0.30
f_HDT_RD    0.50
p_bus       0.60/;

parameter sliced_demand_baseline(allslices);
sliced_demand_baseline(allslices) = 1.15;


table frac_engine(engine_type, car_or_truck)
         p_car   f_LCV   f_MDT_LH  f_MDT_RD  f_HDT_LH  f_HDT_RD  p_bus
0        1       1       1         1         1         1         1
FC       1       1       1         1         1         1         1
hyb      1       1       1         1         1         1         1
PHEV     1       1       1         1         1         1         1
BEV      1       0.9     0.5       0.7       0.5       0.7       0.7
FCREEV   1       1       1         1         1         1         1;


table high_speed_train(t,reg)  fraction of hsp mode using electricity
             AFR        CPA         EUR        FSU          LAM        MEA          NAM        PAO          PAS        SAS
2010        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04
2020        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04        0.04
2030        0.04        0.04        0.06        0.04        0.04        0.04        0.06        0.06        0.04        0.04
2040        0.04        0.04        0.1         0.04        0.04        0.04        0.1         0.1         0.04        0.04
2050        0.04        0.04        0.14        0.04        0.04        0.04        0.14        0.14        0.04        0.04
2060        0.04        0.04        0.2         0.04        0.04        0.04        0.2         0.2         0.04        0.04
2070        0.04        0.04        0.24        0.04        0.04        0.04        0.24        0.24        0.04        0.04
2080        0.04        0.04        0.26        0.04        0.04        0.04        0.26        0.26        0.04        0.04
2090        0.04        0.04        0.28        0.04        0.04        0.04        0.28        0.28        0.04        0.04
2100        0.04        0.04        0.3         0.04        0.04        0.04        0.3         0.3         0.04        0.04
2110        0.04        0.04        0.3         0.04        0.04        0.04        0.3         0.3         0.04        0.04
2120        0.04        0.04        0.3         0.04        0.04        0.04        0.3         0.3         0.04        0.04
2130        0.04        0.04        0.3         0.04        0.04        0.04        0.3         0.3         0.04        0.04
   ;

*### Expansion constraints parameters ###

Parameters

cap_g_lim    /0.25/
*  / 0.20 /
init_plant   /0.0002/
*/ 0.0001 /

supply_lim /0.1/
init_supply /4/

infra_g_lim    infrastr relative growth limit
    / 0.1 /
*    / 0.10 /
init_infra     initial unrestricted infrastr growth (TW per decade)
    / 0.01 /
eng_g_lim  / 0.2/
*eng_g_lim  / 0.20 /
init_eng /0.01/

marketshare_eng /0.25/ ;
*marketshare_eng /0.25/ ;

*############################################################
$ include "indata.gms";
*############################################################

lf_infra(trsp_fuel)=0.7;
life_infra(trsp_fuel) = 50;
life_plant(en_in, en_out, type) = 25;
life_plant("hydro", "elec", "0") = 40;
life_plant("EU4", "elec", "0") = 40;
life_plant("EU1", "elec", "0") = 40;
life_plant("MOX", "elec", "0") = 40;
life_plant("FBF", "elec", "0") = 40;
life_plant("EU4", "H2", "cg") = 40;
life_eng(trsp_fuel, engine_type, trsp_mode) = 30;
life_eng(trsp_fuel, engine_type, car_or_truck) = 15;


C_tax(reg,t) = 0;
OM_cost_fr(en_in, en_out) = 0.04;
OM_cost_fr("EU1", "elec") = 0.015;
OM_cost_fr("EU4", "elec") = 0.015;
OM_cost_fr("MOX", "elec") = 0.015;
OM_cost_fr("FBF", "elec") = 0.015;
OM_cost_fr("storage_12h", "elec") = 0.015;
OM_cost_fr("storage_24h", "elec") = 0.015;
OM_cost_fr("storage_48h", "elec") = 0.015;
OM_cost_fr("storage_96h", "elec") = 0.015;

*### time dependent technology costs and efficiencies ###

effic_current(en_in, type, en_out)=effic_0(en_in, type, en_out);
t_tech_effic(en_in, type, en_out) = 40;

* time depend costs now disabled
*cost_inv_0(en_in, en_out, type) = cost_inv_base(en_in, type, en_out);
*$ontext
* time and region dependent efficiency
effic(en_in, en_out, type, reg,t) = effic_0(en_in, type, en_out);

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
*$offtext

effic(nuclear_fuel, en_out , type, reg,t)= effic_0(nuclear_fuel, type, en_out);
*$offtext

Parameters
cost_infra_mod(trsp_fuel, trsp_mode)  d:o adjusted for different investm and discount rates

cost_inv(en_in, en_out, type, t)      time dependent plant investment cost
cost_inv_mod(en_in, en_out, type, t)  d:o adjusted for different investm and discount rates

cost_eng(trsp_fuel, engine_type, trsp_mode, t)     time dependent vehicle investment cost (vehicle + engine)
cost_eng_mod(trsp_fuel, engine_type, trsp_mode, t) d:o adjusted for different investm and discount rates;


vehicle_cost("p_car")  = 10000;
vehicle_cost("f_LCV") = 40000;
vehicle_cost("f_MDT_LH") = 120000;
vehicle_cost("f_MDT_RD") = 100000;
vehicle_cost("f_HDT_LH") = 180000;
vehicle_cost("f_HDT_RD") = 150000;
vehicle_cost("p_bus") = 80000;
vehicle_cost("f_container") = 125000;
vehicle_cost("p_air_short") = 15260;
vehicle_cost("p_air_medium") = 76300;
vehicle_cost("p_air_long") = 198000;
vehicle_cost("f_air") = 76300;
vehicle_cost("f_rail") = 0;
vehicle_cost("p_rail") = 0;
vehicle_cost("f_cargo_bulk") = 80000;
vehicle_cost("f_oiltanker") = 80000;
vehicle_cost("f_gastanker") = 100000;
vehicle_cost("f_cargo_short") = 10000;
vehicle_cost("p_ferry_short") = 10000;
vehicle_cost("p_ferry_long") = 100000;
vehicle_cost("f_othership") = 20000;
*vehicle cost for cars, trucks and bus in GUSD/G road vehicles
*vehicle cost for rest in GUSD/M vehicles

*cost_eng_0(trsp_fuel, engine_type, trsp_mode) = cost_eng_base(trsp_fuel, engine_type, trsp_mode)*1.5;
*Why times 1.5????

t_tech_plant(en_in, en_out, type) = 40;
t_tech_eng(trsp_fuel, engine_type, trsp_mode) = 40;

$ontext
*H�r varierar vi om vi vill �ndra kostnaden f�r f�rnybar elproduktion  fr�n sol och vind. F�ljande �r 20 % l�gre �n basecase. 20 % �r valt f�r att f�ljer teorin med l�rkurvor,d�r vid varje f�rdubbling av prod.cap. s�nks inv.cost med 20 %.
cost_inv_base ("windonshoreA", "0", "elec") = 960;
cost_inv_base ("windonshoreB", "0", "elec") = 1080;
cost_inv_base ("windoffshore", "0", "elec") = 2400;
cost_inv_base ("pvrooftop", "0", "elec") = 400;
cost_inv_base ("pvplantA", "0", "elec") = 360;
cost_inv_base ("pvplantB", "0", "elec") = 480;
cost_inv_base ("cspplantA", "0", "elec") = 2800;
cost_inv_base ("cspplantB", "0", "elec") = 3000;

*F�ljande v�rden �r base case, radera inte dessa v�rden
*windonshoreA    1200
*windonshoreB    1350
*windoffshore    3000
*pvrooftop       500
*pvplantA        450
*pvplantB        600
*cspplantA       3500
*cspplantB       3750
$offtext

cost_inv(en_in, en_out, type, t) $ (((ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type)) < 1) =
    cost_inv_0(en_in, type, en_out)-((cost_inv_0(en_in, type, en_out)-cost_inv_base(en_in, type, en_out))* (ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type)) ;

cost_inv(en_in, en_out, type, t) $ (((ord(t)-1)*t_step/t_tech_plant(en_in, en_out, type)) >= 1) =
 cost_inv_base(en_in, type, en_out);

* D:o, and basic vehicle cost added
cost_eng(trsp_fuel, engine_type, trsp_mode, t) =

*cost_eng_base(road_fuel, engine_type, car_truck_ships)
*             + vehicle_cost(car_truck_ships) ;

 max( cost_eng_base(trsp_fuel, engine_type, trsp_mode),
    cost_eng_0(trsp_fuel, engine_type, trsp_mode) -
    (cost_eng_0(trsp_fuel, engine_type, trsp_mode)-cost_eng_base(trsp_fuel, engine_type, trsp_mode))*
    ((ord(t)-1)*t_step/t_tech_eng(trsp_fuel, engine_type, trsp_mode)) )
    + vehicle_cost(trsp_mode);

cost_inv_mod(en_in, en_out, type, t) = cost_inv(en_in, en_out, type, t);
*    (r_invest + 1/life_plant(en_in, en_out, type))/(r+1/life_plant(en_in, en_out, type));

cost_eng_mod(trsp_fuel, engine_type, trsp_mode, t) = cost_eng(trsp_fuel, engine_type, trsp_mode, t)          ;
*    (r_invest + 1/life_eng(road_fuel, engine_type, car_or_truck))/(r+1/life_eng(road_fuel, engine_type, car_or_truck));

cost_infra_mod(trsp_fuel, trsp_mode) = cost_infra(trsp_fuel, trsp_mode)         ;
*    (r_invest + 1/life_infra(new_trsp_fuel)) / (r + 1/life_infra(new_trsp_fuel))


$ontext
*MOL:Test of higher import cost, in order to limit the trade between regions - conflictual for liquidfuelspaper.
import_cost(second_in) = 5 * import_cost(second_in);
$offtext
