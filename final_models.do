clear all

*************************************
***********MADRES Y PADRES***********
*************************************
import excel "C:\Users\alons\OneDrive\Documentos\Master UAM\TFM\Data\Final_prev_dummies_father_mother.xlsx", sheet("Sheet1") cellrange(B1:BB1189) firstrow clear

/*Education*/
label variable c_best_edu_ "Children Education"
tab c_best_edu_, gen(dummy_children_education)

label variable best_edu_ "Father Education"
tab best_edu_, gen(dummy_father_education)
label variable best_edu_mother "Mother Education"
replace best_edu_mother = "No Schooling" if best_edu_mother == "No schooling"
tab best_edu_mother, gen(dummy_mother_education)

/*Alcohol consumption*/
label variable a_hllfalc_ "Alcohol father consumption"
tab a_hllfalc_, gen(dummy_alc_consumption_father)
label variable a_hllfalc_mother "Alcohol mother consumption"
tab a_hllfalc_mother, gen(dummy_alc_consumption_mother)

/*Exercise*/
label variable a_hllfexer_ "Exercise father habits"
tab a_hllfexer_, gen(dummy_father_exercise)
label variable a_hllfexer_mother "Exercise mother habits"
tab a_hllfexer_mother, gen(dummy_mother_exercise)

/*Smoking consumption*/
label variable a_hllfsmk_ "Smoking consumption"
tab a_hllfsmk_, gen(dummy_smk_consumption)
label variable a_hllfsmk_mother "Smoking mother consumption"
tab a_hllfsmk_mother, gen(dummy_smk_mother_consumption)

/*Employment status*/
label variable empl_stat_ "Employment father Status"
tab empl_stat_, gen(dummy_empl_status_father)
label variable empl_stat_mother "Employment mother Status"
tab empl_stat_mother, gen(dummy_empl_status_mother)

/*Age*/
label variable c_best_age_yrs_ "Child age"
label variable best_age_yrs_ "Father age"
label variable best_age_yrs_mother "Mother age"

/*Gender*/
label variable c_best_gen_ "Child gender"
label variable best_gen_ "Adult gender"
gen child_gender = 0
replace child_gender = 1 if c_best_gen_=="Male"
gen adult_gender = 0
replace adult_gender = 1 if best_gen_=="Male"

/*BMI*/
label variable BMI_child "Child BMI"
label variable BMI_adult "Father BMI"
label variable BMI_adultmother "Mother BMI"
gen log_BMI_child = log(BMI_child)
gen log_BMI_adult = log(BMI_adult)
gen log_BMI_adultmother = log(BMI_adultmother)
label variable log_BMI_child "log of Child BMI"
label variable log_BMI_adult "log of father BMI"
label variable log_BMI_adultmother "log of mother BMI"


*******MODELOS********
*Pooled OLS
reg log_BMI_child log_BMI_adult log_BMI_adultmother, rob

*Pooled OLS with children controls
reg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ child_gender dummy_children_education1 dummy_children_education3 dummy_children_education4, rob

*Pooled OLS with children and adult controls
reg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ child_gender dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_mother best_age_yrs_ dummy_father_education2 dummy_father_education3 dummy_father_education4 dummy_mother_education2 dummy_mother_education3 dummy_mother_education4 dummy_alc_consumption_father1 dummy_alc_consumption_mother1 dummy_father_exercise3 dummy_father_exercise1 dummy_mother_exercise3 dummy_mother_exercise1 dummy_smk_consumption2 dummy_empl_status_father1 dummy_empl_status_father2 dummy_empl_status_mother1 dummy_empl_status_mother2, rob


*FE models (El estimador de xtreg log_BMI_child log_BMI_adult, fe es lo mismo que reg log_BMI_child log_BMI_adult i.c_pid, rob)
egen pair_id=group(c_best_fthpid_ c_pid)
xtset pair_id
*FE baseline model
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother, fe

*FE model with children controls
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4, fe

*FE model with children and adult controls
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_mother best_age_yrs_ dummy_father_education2 dummy_father_education3 dummy_father_education4 dummy_mother_education2 dummy_mother_education3 dummy_mother_education4 dummy_alc_consumption_father1 dummy_alc_consumption_mother1 dummy_father_exercise3 dummy_father_exercise1 dummy_mother_exercise3 dummy_mother_exercise1 dummy_smk_consumption2 dummy_empl_status_father1 dummy_empl_status_father2 dummy_empl_status_mother1 dummy_empl_status_mother2, fe

*FE models (El estimador de xtreg log_BMI_child log_BMI_adult, fe es lo mismo que reg log_BMI_child log_BMI_adult i.c_pid, rob)

*MODELS controlando por non-adults fixed effects
xtset c_pid
*FE baseline model
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother, fe

*FE model with children controls
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4, fe

*FE model with children and adult controls
xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_mother best_age_yrs_ dummy_father_education2 dummy_father_education3 dummy_father_education4 dummy_mother_education2 dummy_mother_education3 dummy_mother_education4 dummy_alc_consumption_father1 dummy_alc_consumption_mother1 dummy_father_exercise3 dummy_father_exercise1 dummy_mother_exercise3 dummy_mother_exercise1 dummy_smk_consumption2 dummy_empl_status_father1 dummy_empl_status_father2 dummy_empl_status_mother1 dummy_empl_status_mother2, fe

*MODELS controlando por household fixed effects
egen hh_id=group(c_best_fthpid_ c_best_mthpid_)
xtset hh_id
*FE baseline model
eststo: xtreg log_BMI_child log_BMI_adult log_BMI_adultmother, fe

*FE model with children controls
eststo: xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4, fe

*FE model with children and adult controls
eststo: xtreg log_BMI_child log_BMI_adult log_BMI_adultmother c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_mother best_age_yrs_ dummy_father_education2 dummy_father_education3 dummy_father_education4 dummy_mother_education2 dummy_mother_education3 dummy_mother_education4 dummy_alc_consumption_father1 dummy_alc_consumption_mother1 dummy_father_exercise3 dummy_father_exercise1 dummy_mother_exercise3 dummy_mother_exercise1 dummy_smk_consumption2 dummy_empl_status_father1 dummy_empl_status_father2 dummy_empl_status_mother1 dummy_empl_status_mother2, fe


************************
*******MADRES***********
************************
clear all
import excel "C:\Users\alons\OneDrive\Documentos\Master UAM\TFM\Data\Final_prev_dummies_mother.xlsx", sheet("Sheet1") cellrange(B1:AH3697) firstrow clear


/*Education*/
label variable c_best_edu_ "Children Education"
tab c_best_edu_, gen(dummy_children_education)

label variable best_edu_ "Adult Education"
replace best_edu_ = "No Schooling" if best_edu_ == "No schooling"
tab best_edu_, gen(dummy_adult_education)

/*Alcohol consumption*/
label variable a_hllfalc_ "Alcohol consumption"
tab a_hllfalc_, gen(dummy_alc_consumption)

/*Exercise*/
label variable a_hllfexer_ "Exercise habits"
tab a_hllfexer_, gen(dummy_exercise)

/*Smoking consumption*/
label variable a_hllfsmk_ "Smoking consumption"
tab a_hllfsmk_, gen(dummy_smk_consumption)

/*Employment status*/
label variable empl_stat_ "Employment Status"
tab empl_stat_, gen(dummy_empl_status)

/*Age*/
label variable c_best_age_yrs_ "Child age"
label variable best_age_yrs_ "Adult age"

/*Gender*/
label variable c_best_gen_ "Child gender"
label variable best_gen_ "Adult gender"
gen child_gender = 0
replace child_gender = 1 if c_best_gen_=="Male"

/*BMI*/
label variable BMI_child "Child BMI"
label variable BMI_adult "Adult BMI"
gen log_BMI_child = log(BMI_child)
gen log_BMI_adult = log(BMI_adult)
label variable log_BMI_child "log of Child BMI"
label variable log_BMI_adult "log of Adult BMI"


*******MODELOS********

*Pooled OLS with child and adult controls without differentiating by children gender
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, rob

*Pooled OLS with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, rob

*Pooled OLS with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, rob

*Generating the identifier
egen pair_id=group(c_best_mthpid_ c_pid)
xtset pair_id

*FE with child and adult controls without differentiating by children gender
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, fe


*MODELS controlando por non-adults fixed effects
xtset c_pid
*FE model with children and adult controls
xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*MODELS controlando por household fixed effects
xtset c_best_mthpid_
*FE model with children and adult controls
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, fe

*Para generar las tablas esttab using TablasMADRE.rtf

************************
*******PADRES***********
************************
clear all
import excel "C:\Users\alons\OneDrive\Documentos\Master UAM\TFM\Data\Final_prev_dummies_father.xlsx", sheet("Sheet1") cellrange(B1:AH1625) firstrow


/*CREATING THE EXPLANATORY VARIABLES*/

/*Education*/
label variable c_best_edu_ "Children Education"
tab c_best_edu_, gen(dummy_children_education)

label variable best_edu_ "Adult Education"
tab best_edu_, gen(dummy_adult_education)

/*Alcohol consumption*/
label variable a_hllfalc_ "Alcohol consumption"
tab a_hllfalc_, gen(dummy_alc_consumption)

/*Exercise*/
label variable a_hllfexer_ "Exercise habits"
tab a_hllfexer_, gen(dummy_exercise)

/*Smoking consumption*/
label variable a_hllfsmk_ "Smoking consumption"
tab a_hllfsmk_, gen(dummy_smk_consumption)

/*Employment status*/
label variable empl_stat_ "Employment Status"
tab empl_stat_, gen(dummy_empl_status)

/*Age*/
label variable c_best_age_yrs_ "Child age"
label variable best_age_yrs_ "Adult age"

/*Gender*/
label variable c_best_gen_ "Child gender"
label variable best_gen_ "Adult gender"
gen child_gender = 0
replace child_gender = 1 if c_best_gen_=="Male"


/*BMI*/
label variable BMI_child "Child BMI"
label variable BMI_adult "Adult BMI"
gen log_BMI_child = log(BMI_child)
gen log_BMI_adult = log(BMI_adult)
label variable log_BMI_child "log of Child BMI"
label variable log_BMI_adult "log of Adult BMI"



*******MODELOS********
*Pooled OLS with child and adult controls without differentiating by children gender
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, rob


*Pooled OLS with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, rob

*Pooled OLS with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, rob

*Generating the identifier
egen pair_id=group(c_best_fthpid_ c_pid)
xtset pair_id

*FE with child and adult controls without differentiating by children gender
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, fe

*MODELS controlando por non-adults fixed effects
xtset c_pid
*FE model with children and adult controls
xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*MODELS controlando por household fixed effects
xtset c_best_fthpid_
*FE model with children and adult controls
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==1)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==1, fe

*FE with child and adult controls differentiating by children gender (boys; child_gender==0)
eststo: xtreg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if child_gender==0, fe

*Para generar las tablas esttab using TablasPADRE.rtf

*CREO NUEVO DATAFRAME PARA PODER HACER TEST DE HIPOTESIS
*HYPOTHESIS TEST (AVISAR DE QUE SUEST PRODUCE ERRORES ROBUSTOS DE MENOR TAMAÑO)
clear all
use Final_prev_dummies_mother.dta
append using Final_prev_dummies_father.dta

gen adult_gender = 0
replace adult_gender = 1 if best_gen_ == "Male"
gen child_gender = 0
replace child_gender = 1 if c_best_gen_=="Male"

reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if adult_gender==1
estimates store cequalzero
reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if adult_gender==0
estimates store cequalone
*TESTING IF THE TRANSMISSION FOR FATHERS IS STRONGER THAN THE ONE FOR MOTHERS
suest cequalzero cequalone, vce(robust)
test [cequalzero_mean]log_BMI_adult-[cequalone_mean]log_BMI_adult = 0

reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if (adult_gender==0&child_gender==1)
estimates store cequaltwo
reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if (adult_gender==0&child_gender==0)
estimates store cequalthree
*TESTING IF THE TRANSMISSION FOR THE PAIR MOTHER-DAUGHTER IS STRONGER THAN THE MOTHER-SONS
suest cequaltwo cequalthree, vce(robust)
test [cequaltwo_mean]log_BMI_adult-[cequalthree_mean]log_BMI_adult = 0

reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if (adult_gender==1&child_gender==1)
estimates store cequalfour
reg log_BMI_child log_BMI_adult c_best_age_yrs_ dummy_children_education1 dummy_children_education3 dummy_children_education4 best_age_yrs_ dummy_adult_education2 dummy_adult_education3 dummy_adult_education4 dummy_alc_consumption1 dummy_exercise1 dummy_exercise3 dummy_smk_consumption2 dummy_empl_status1 dummy_empl_status2 if (adult_gender==1&child_gender==0)
estimates store cequalfive
*TESTING IF THE TRANSMISSION FOR THE PAIR MOTHER-DAUGHTER IS STRONGER THAN THE MOTHER-SONS
suest cequalfour cequalfive, vce(robust)
test [cequalfour_mean]log_BMI_adult-[cequalfive_mean]log_BMI_adult = 0




