USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_PW_Death_REG]    Script Date: 09/26/2024 14:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*    
[Schedule_PHC_SubCenter_Village_Day_PW_Death_REG] 34
*/        
ALTER proc [dbo].[Schedule_PHC_SubCenter_Village_Day_PW_Death_REG]    
(    
@State_Code int=0    
)    
as    
begin    
/* 
because same is using in Schedule_PHC_SubCenter_Village_Day_MH_REG and Schedule_PHC_SubCenter_Village_Day_PW_Death_REG is calling in 
Schedule_PHC_SubCenter_Village_Day_MH_REG

truncate table t_temp_ReportMasterDate    
insert into t_temp_ReportMasterDate(Created_On,State_Code,PHC_Code,SubCentre_Code,Village_Code)    
select GETDATE(),State_Code,PHC_Code,SubCentre_Code,Village_Code     
from t_Schedule_Date where Mother_Registration_date is not null  
group by State_Code,PHC_Code,SubCentre_Code,Village_Code     
*/
delete a from  Scheduled_PHC_SubCenter_Village_Day_PW_Death_REG a    
inner join t_temp_ReportMasterDate b on a.State_Code=b.State_Code and a.HealthFacility_Code=b.PHC_Code and a.HealthSubFacility_Code=b.SubCentre_Code    
and a.Village_Code=b.Village_Code    

insert into Scheduled_PHC_SubCenter_Village_Day_PW_Death_REG(State_Code,Healthfacility_Code,HealthSubfacility_Code,Village_Code,[EC_Wife_Cureent_age_LessThen_19],[EC_Wife_Cureent_age_20_To_24]    
,[EC_Wife_Cureent_age_25_To_29],[EC_Wife_Cureent_age_30_To_34],[EC_Wife_Cureent_age_35_To_39],[EC_Wife_Cureent_age_40_To_44],[EC_Wife_Cureent_age_45_To_49]    
,[Estimated_PW_Total],[Registered_PW_Total],[Reg_Hindu_Total],[Reg_Muslim_Total],[Reg_Sikh_Total],[Reg_Christian_Total],[Reg_Other_Relegion_Total],[Reg_SC]    
,[Reg_ST],[Reg_Other_Caste_Total],[Reg_APL_Total],[Reg_BPL_Total],[Reg_APLBPL_NotKnown_Total],[Reg_PW_Register_Less_Than_19Yr_Age],[Reg_With_Aadhaar_No]    
,[Reg_Without_Aadhaar_No],[Reg_With_Bank_Details],[Reg_Without_Bank_Details],[Reg_With_Self_Mob_No],[Reg_With_Other_Mob_No],[Reg_Without_Mob_No],[Reg_Entited_JSY_Benifit]    
,[Reg_Received_JSY_Benifit],[Reg_NotReceived_JSY_Benifit],[Reg_PW_HighRisk],[Reg_PW_1st_Trimester_Total],[Reg_PW_2nd_Trimester_Total],[Reg_PW_3rd_Trimester_Total]    
,[Med_RTI_STI],[Med_HIV_Postive],[Med_Repeated_Abortion],[Med_Sill_Birth],[Med_Caesarean_Section],[Med_Antepartum_haemorrhage],[Med_VDRL_Test],[Med_VDRL_Test_Positive]    
,[Med_HIV_Test],[Med_HIV_Test_Positive],[Med_Blood_Group_Done],[ANC_ANC1_Total],[ANC_ANC1_within_12Weeks],[ANC_ANC2_Total],[ANC_ANC2_within_26Weeks]    
,[ANC_ANC3_Total],[ANC_ANC3_within_34Weeks],[ANC_ANC4_Total],[ANC_Any3_ANC_Total],[ANC_All4_ANC_Total],[ANC_TT1_Total],[ANC_TT2_Total],[ANC_TTBooster_Total]    
,[ANC_FA_Total],[ANC_100IFA_Total],[ANC_FullANC_Total],[ANC_Blood_Sugar_Fasting_Unique_PW],[ANC_Urine_Test_Done_Unique_PW],[ANC_Urine_Sugar_Unique_PW]    
,[ANC_Urine_Albumin_Unique_PW],[ANC_Urine_Test_Done_ANC1],[ANC_Urine_Test_Done_ANC2],[ANC_Urine_Test_Done_ANC3],[ANC_Urine_Test_Done_ANC4],[ANC_BP_Unique_PW]    
,[ANC_PW_BP_ANC1],[ANC_PW_BP_ANC2],[ANC_PW_BP_ANC3],[ANC_PW_BP_ANC4],[ANC_Weight_Unique_PW],[ANC_PW_Weight_ANC1],[ANC_PW_Weight_ANC2],[ANC_PW_Weight_ANC3]    
,[ANC_PW_Weight_ANC4],[ANC_HB_Level_Unique_PW],[ANC_PW_HB_Level_ANC1],[ANC_PW_HB_Level_ANC2],[ANC_PW_HB_Level_ANC3],[ANC_PW_HB_Level_ANC4],[ANC_High_Risk_Pregnancy_Unique_PW]    
,[ANC_PW_High_Risk_Pregnancy_ANC1],[ANC_PW_High_Risk_Pregnancy_ANC2],[ANC_PW_High_Risk_Pregnancy_ANC3],[ANC_PW_High_Risk_Pregnancy_ANC4],[ANC_Severe_Anaemic_Unique_PW]    
,[ANC_Moderate_Anaemic_Unique_PW],[ANC_Mild_Anaemic_Unique_PW],[ANC_Severe_Anaemic_ANC1],[ANC_Moderate_Anaemic_ANC1],[ANC_Mild_Anaemic_ANC1],[ANC_Severe_Anaemic_ANC2]    
,[ANC_Moderate_Anaemic_ANC2],[ANC_Mild_Anaemic_ANC2],[ANC_Severe_Anaemic_ANC3],[ANC_Moderate_Anaemic_ANC3],[ANC_Mild_Anaemic_ANC3],[ANC_Severe_Anaemic_ANC4]    
,[ANC_Moderate_Anaemic_ANC4],[ANC_Mild_Anaemic_ANC4],[ANC_MD_Total],[ANC_MD_Eclampsia],[ANC_MD_Haemorrhage],[ANC_MD_High_Fever],[ANC_MD_Abortion],[ANC_Abortion_Total]    
,[ANC_Abortion_Spontaneous_Total],[ANC_Abortion_Induced_Total],[ANC_Abortion_at_Public_Inst],[ANC_Abortion_at_Public_Inst_Less_Than_12Week],[ANC_Abortion_at_Public_Inst_More_Than_12Week]    
,[ANC_Abortion_at_Private_Inst],[ANC_Abortion_at_Private_Inst_Less_Than_12Week],[ANC_Abortion_at_Private_Inst_More_Than_12Week],[Del_Rep_Total],[Del_Rep_at_Home]    
,[Del_Rep_at_Public],[Del_Rep_at_Private],[Del_MD_Total],[Del_MD_Home_Total],[Del_MD_Public_Intitution_Total],[Del_MD_Private_Intitution_Total],[Del_EDD]    
,[Del_Rep_at_Pvt_AH],[Del_During_Transit],[Del_at_Home_by_SBA],[Del_at_Home_by_NonSBA],[Del_Rep_at_DH],[Del_Rep_at_FRU],[Del_Rep_at_CHC],[Del_Rep_at_PHC]    
,[Del_Rep_at_Sub_Center],[Del_Rep_at_Other_Public_Facility]
,Delivery_Place_RH,Delivery_Place_ODH,Delivery_Place_OMCH,Delivery_Place_Others
,[Del_Normal_Delivery],[Del_Assisted_Delivery],[Del_Caseriean_Delivery],[Del_Caseriean_at_Public]    
,[Del_Caseriean_at_Private],[Del_Caseriean_at_PvtAF],[Del_Caseriean_at_DH],[Del_Caseriean_at_FRU],[Del_Caseriean_at_CHC],[Del_Caseriean_at_PHC],[Del_Caseriean_at_Other_Public_Facility]    
,[Del_PreTerm_Less_Than_37weeks],[Del_PPH],[Del_Retained_Placenta],[Del_Obstructed_Labour],[Del_Prolapsed_Cord],[Del_Twins_pregnancy],[Del_Convulsions]    
,[Del_Within_48_Hours],[Del_Between_2_5_days],[Del_After_5_days],[Del_Total_Birth],[Del_Live_Birth],[Del_Still_Births],[Del_Institutional_Delivery_Total]--Remove    
,[Del_Home_Delivery_Total]--Remove    
,[Del_MD_Home_Delivery_by_SBA],[Del_MD_Home_Delivery_by_NonSBA],[Del_MD_Transit_Total],[PNC_MD_Total],[PNC_PNC_Recevied_Total],[PNC_No_PNC_Recevied_Total]    
,[PNC_M_delivered_at_Home_Received_No_PNC],[PNC_M_delivered_at_Home_Received_Full_PNC],[PNC_PNC1_Total]    
,[PNC_PNC1_Within_24hr_After_del]--PNC1type will come if pnc is given on delivery+one day    
,[PNC_PNC2_Total],[PNC_PNC2_3rd_Day_of_del]--PNC2type will come if pnc is given on delivery+3rd day    
,[PNC_PNC3_Total],[PNC_PNC3_7th_Day_of_del],[PNC_PNC4_Total],[PNC_PNC4_14th_Day_of_del],[PNC_PNC5_Total],[PNC_PNC5_21th_Day_of_del],[PNC_PNC6_Total]    
,[PNC_PNC6_28th_Day_of_del],[PNC_PNC7_Total],[PNC_PNC7_42th_Day_of_del],[PNC_100IFA_Tab_Receive],[PNC_M_Identify_With_Danger_Signs_Total]    
,LM_Received4PNC,LM_Completed42D_Del,Breastfeedwithin_1hr,Infant_death_Reported,Live_Male,Live_Female    
,[PW_With_Address],[Mother_P],[Mother_T],[Mother_U],[ANC1_P],[ANC1_T],[ANC1_U],[ANC2_P],[ANC2_T],[ANC2_U],[ANC3_P],[ANC3_T],[ANC3_U],[ANC4_P]    
,[ANC4_T],[ANC4_U],[TT1_P],[TT1_T],[TT1_U],[TT2_P],[TT2_T],[TT2_U],[TTB_P],[TTB_T],[TTB_U],[PNC1_P],[PNC1_T],[PNC1_U],[PNC2_P],[PNC2_T],[PNC2_U]    
,[PNC3_P],[PNC3_T],[PNC3_U],[PNC4_P],[PNC4_T],[PNC4_U],[PNC5_P],[PNC5_T],[PNC5_U],[PNC6_P],[PNC6_T],[PNC6_U],[PNC7_P],[PNC7_T],[PNC7_U],[Delivery_P]    
,[Delivery_T],[Delivery_U],[LMP_P],[LMP_T],[LMP_U]    
,[Year_ID],[Month_ID],[Day_ID]--,Days_Left
,[AsOnDate],[IsActive],Fin_Yr,Total_Death,PW_With_UID_Mob    
,Reg_Validate_Ph,Reg_with_UIDlinked,JSY_With_UID,JSY_Validate_Ph,JSY_With_Bank,JSY_With_UID_Linked,JSY_With_Self_Ph    
,HR_Del_Pub,Teen_Age_Count  
--------------------covid  
,ANC_Is_ILI_Symptom_done ,ANC_Is_contact_Covid_done ,ANC_Covid_test_done ,ANC_Covid_test_result_done   
,del_Is_ILI_Symptom_done ,del_Is_contact_Covid_done ,del_Covid_test_done ,del_Covid_test_result_done   
,PNC_Is_ILI_Symptom_done ,PNC_Is_contact_Covid_done ,PNC_Covid_test_done ,PNC_Covid_test_result_done   
,ANC_Is_ILI_Symptom_NotDone ,ANC_Is_contact_Covid_NotDone ,ANC_Covid_test_NotDone ,ANC_Covid_test_result_NotDone   
,del_Is_ILI_Symptom_NotDone ,del_Is_contact_Covid_NotDone ,del_Covid_test_NotDone ,del_Covid_test_result_NotDone   
,PNC_Is_ILI_Symptom_NotDone ,PNC_Is_contact_Covid_NotDone ,PNC_Covid_test_NotDone ,PNC_Covid_test_result_NotDone  
,PW_High_risk_MD_Total,ALLPNC,is_verified,HRP_Managed,Mother_HealthIdNumber,run_date

)    
SELECT StateID as State_Code    
      ,PHC_ID as Healthfacility_Code    
      ,SubCentre_ID as HealthSubfacility_Code    
      ,Village_ID    
      ,SUM((case when Wife_current_age<19 then 1 else 0 end))  [EC_Wife_Cureent_age_LessThen_19]    
      ,SUM((case when Wife_current_age between 20 and 24 then 1 else 0 end))  [EC_Wife_Cureent_age_20_To_24]    
      ,SUM((case when Wife_current_age between 25 and 29 then 1 else 0 end))[EC_Wife_Cureent_age_25_To_29]    
      ,SUM((case when Wife_current_age between 30 and 34 then 1 else 0 end))[EC_Wife_Cureent_age_30_To_34]    
      ,SUM((case when Wife_current_age between 35 and 39 then 1 else 0 end))[EC_Wife_Cureent_age_35_To_39]    
      ,SUM((case when Wife_current_age between 40 and 44 then 1 else 0 end))[EC_Wife_Cureent_age_40_To_44]    
      ,SUM((case when Wife_current_age between 45 and 49 then 1 else 0 end))[EC_Wife_Cureent_age_45_To_49]    
      ,0 as [Estimated_PW_Total]    
      ,count(a.Registration_no)[Registered_PW_Total]    
      ,SUM(Convert(int,Religion_Hindu))[Reg_Hindu_Total]    
      ,SUM(Convert(int,Religion_Muslim))[Reg_Muslim_Total]    
      ,SUM(Convert(int,Religion_Sikh))[Reg_Sikh_Total]    
      ,SUM(Convert(int,Religion_Christian))[Reg_Christian_Total]    
      ,SUM(Convert(int,Religion_Other))[Reg_Other_Relegion_Total]    
      ,SUM(Convert(int,Caste_SC))[Reg_SC]    
      ,SUM(Convert(int,Caste_ST))[Reg_ST]    
      ,SUM(Convert(int,Caste_Others))[Reg_Other_Caste_Total]    
      ,SUM(Convert(int,Economic_Status_APL))[Reg_APL_Total]    
      ,SUM(Convert(int,Economic_Status_BPL))[Reg_BPL_Total]    
      ,SUM(Convert(int,Economic_Status_Not_Known))[Reg_APLBPL_NotKnown_Total]    
      ,SUM((case when Mother_Age<19 then 1 else 0 end)) [Reg_PW_Register_Less_Than_19Yr_Age]    
      ,SUM(Convert(int,PW_Aadhar_No_Present))[Reg_With_Aadhaar_No]    
      ,SUM(Convert(int,PW_Aadhar_No_Absent))[Reg_Without_Aadhaar_No]    
      ,SUM(Convert(int,PW_Bank_Name_Present))[Reg_With_Bank_Details]    
      ,SUM(Convert(int,PW_Bank_Name_Absent))[Reg_Without_Bank_Details]    
      ,SUM((case when (Whose_mobile_Wife=1 or Whose_mobile_Husband=1) then 1 else 0 end))[Reg_With_Self_Mob_No]    
      ,SUM(Convert(int,Whose_mobile_Others))[Reg_With_Other_Mob_No]    
      ,SUM(Convert(int,Whose_mobile_Not_Present))[Reg_Without_Mob_No]    
      ,SUM(Convert(int,JSY_Beneficiary_Y))[Reg_Entited_JSY_Benifit]    
      ,SUM(Convert(int,JSY_Payment_Received_Y))[Reg_Received_JSY_Benifit]    
      ,SUM(Convert(int,JSY_Payment_Received_N))[Reg_NotReceived_JSY_Benifit]    
      ,SUM(CONVERT(int,High_risk_Severe))[Reg_PW_HighRisk]--HR    
      ,SUM((Case when DATEDIFF(month,LMP_Date,a.Mother_Registration_Date) between 1 and 3 then 1 else 0 end))[Reg_PW_1st_Trimester_Total]    
      ,SUM((Case when DATEDIFF(month,LMP_Date,a.Mother_Registration_Date) between 4 and 6  then 1 else 0 end))[Reg_PW_2nd_Trimester_Total]    
      ,SUM((Case when DATEDIFF(month,LMP_Date,a.Mother_Registration_Date) between 7 and 9  then 1 else 0 end))[Reg_PW_3rd_Trimester_Total]    
      ,SUM(Convert(int,Pastillness_STI_RTI))[Med_RTI_STI]    
      ,SUM(Convert(int,Pastillness_HIV_POS))[Med_HIV_Postive]    
      ,SUM((Case when LastPregComp_Repeatedabortion=1 or L2LPregComp_Repeatedabortion=1  then 1 else 0 end))[Med_Repeated_Abortion]    
      ,SUM((Case when LastPregComp_Stillbirth=1 or L2LPregComp_Stillbirth=1  then 1 else 0 end))[Med_Sill_Birth]    
      ,SUM((Case when LastPregComp_CSection=1 or L2LPregComp_CSection=1  then 1 else 0 end))[Med_Caesarean_Section]    
      ,SUM((Case when LastPregComp_APH=1 or L2LPregComp_APH=1  then 1 else 0 end))[Med_Antepartum_haemorrhage]    
      ,SUM(Convert(int,VDRL_TEST_Done))[Med_VDRL_Test]    
      ,SUM(Convert(int,VDRL_Result_Positive))[Med_VDRL_Test_Positive]    
      ,SUM(Convert(int,HIV_TEST_Done))[Med_HIV_Test]    
      ,SUM(Convert(int,HIV_Result_Positive))[Med_HIV_Test_Positive]    
      ,SUM(Convert(int,Blood_Test_Done))[Med_Blood_Group_Done]    
      ,SUM(Convert(int,ANC1_Present))[ANC_ANC1_Total]    
      ,SUM(Convert(int,ANC1_Within12_Week))[ANC_ANC1_within_12Weeks]    
      ,SUM(Convert(int,ANC2_Present))[ANC_ANC2_Total]    
      ,SUM(Convert(int,ANC2_Within26_Week))[ANC_ANC2_within_26Weeks]    
      ,SUM(Convert(int,ANC3_Present))[ANC_ANC3_Total]    
      ,SUM(Convert(int,ANC3_Within34_Week))[ANC_ANC3_within_34Weeks]    
      ,SUM(Convert(int,ANC4_Present))[ANC_ANC4_Total]    
      ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)>=3 then 1 else 0 end))[ANC_Any3_ANC_Total]    
      ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)=4 then 1 else 0 end))[ANC_All4_ANC_Total]    
      ,SUM(Convert(int,TT1_Present))[ANC_TT1_Total]    
      ,SUM(Convert(int,TT2_Present))[ANC_TT2_Total]    
      ,SUM(Convert(int,TTB_Present))[ANC_TTBooster_Total]    
      ,SUM((Case when CONVERT(int,ANC1_FA_Given_Present)+CONVERT(int,ANC2_FA_Given_Present)+CONVERT(int,ANC3_FA_Given_Present)+CONVERT(int,ANC4_FA_Given_Present)>0 then 1 else 0 end))[ANC_FA_Total]    
      ,SUM((Case when CONVERT(int,ANC1_IFA_Given_Present)+CONVERT(int,ANC2_IFA_Given_Present)+CONVERT(int,ANC3_IFA_Given_Present)+CONVERT(int,ANC4_IFA_Given_Present)>0 then 1 else 0 end))[ANC_100IFA_Total]    
      ,SUM((Case when ANC1_Present=1 and ANC2_Present=1 and ANC3_Present=1 and ANC4_Present=1and ((TT1_Present=1 and TT2_Present=1)OR TTB_Present=1)    
       and (CONVERT(int,ANC1_IFA_Given_Present)+CONVERT(int,ANC2_IFA_Given_Present)+CONVERT(int,ANC3_IFA_Given_Present)+CONVERT(int,ANC4_IFA_Given_Present))>0 then 1 else 0 end))[ANC_FullANC_Total]    
      ,SUM((Case when CONVERT(int,ANC1_Blood_Sugar_Fasting_Present)+CONVERT(int,ANC2_Blood_Sugar_Fasting_Present)+CONVERT(int,ANC3_Blood_Sugar_Fasting_Present)+CONVERT(int,ANC4_Blood_Sugar_Fasting_Present)>0 then 1 else 0 end))[ANC_Blood_Sugar_Fasting_Unique_PW]    
      ,SUM((Case when CONVERT(int,ANC1_Urine_Test_Done)+CONVERT(int,ANC2_Urine_Test_Done)+CONVERT(int,ANC3_Urine_Test_Done)+CONVERT(int,ANC4_Urine_Test_Done)>0 then 1 else 0 end))[ANC_Urine_Test_Done_Unique_PW]    
      ,SUM((Case when CONVERT(int,ANC1_Urine_Sugar_Present)+CONVERT(int,ANC2_Urine_Sugar_Present)+CONVERT(int,ANC3_Urine_Sugar_Present)+CONVERT(int,ANC4_Urine_Sugar_Present)>0 then 1 else 0 end))[ANC_Urine_Sugar_Unique_PW]    
      ,SUM((Case when CONVERT(int,ANC1_Urine_Albumin_Present)+CONVERT(int,ANC2_Urine_Albumin_Present)+CONVERT(int,ANC3_Urine_Albumin_Present)+CONVERT(int,ANC4_Urine_Albumin_Present)>0 then 1 else 0 end))[ANC_Urine_Albumin_Unique_PW]    
      ,SUM(CONVERT(int,ANC1_Urine_Test_Done))[ANC_Urine_Test_Done_ANC1]    
      ,SUM(CONVERT(int,ANC2_Urine_Test_Done))[ANC_Urine_Test_Done_ANC2]    
      ,SUM(CONVERT(int,ANC3_Urine_Test_Done))[ANC_Urine_Test_Done_ANC3]    
      ,SUM(CONVERT(int,ANC4_Urine_Test_Done))[ANC_Urine_Test_Done_ANC4]    
      ,SUM((Case when CONVERT(int,ANC1_BP_Distolic_Present)+CONVERT(int,ANC2_BP_Distolic_Present)+CONVERT(int,ANC3_BP_Distolic_Present)+CONVERT(int,ANC4_BP_Distolic_Present)    
      +CONVERT(int,ANC1_BP_Systolic_Present)+CONVERT(int,ANC2_BP_Systolic_Present)+CONVERT(int,ANC3_BP_Systolic_Present)+CONVERT(int,ANC4_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_BP_Unique_PW]    
      ,SUM((Case when CONVERT(int,ANC1_BP_Distolic_Present)+CONVERT(int,ANC1_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC1]    
      ,SUM((Case when CONVERT(int,ANC2_BP_Distolic_Present)+CONVERT(int,ANC2_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC2]    
      ,SUM((Case when CONVERT(int,ANC3_BP_Distolic_Present)+CONVERT(int,ANC3_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC3]    
      ,SUM((Case when CONVERT(int,ANC4_BP_Distolic_Present)+CONVERT(int,ANC4_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC4]    
      ,SUM((Case when CONVERT(int,ANC1_Weight_Present)+CONVERT(int,ANC2_Weight_Present)+CONVERT(int,ANC3_Weight_Present)+CONVERT(int,ANC4_Weight_Present)>0 then 1 else 0 end))[ANC_Weight_Unique_PW]    
      ,SUM(CONVERT(int,ANC1_Weight_Present))[ANC_PW_Weight_ANC1]    
      ,SUM(CONVERT(int,ANC2_Weight_Present))[ANC_PW_Weight_ANC2]    
      ,SUM(CONVERT(int,ANC3_Weight_Present))[ANC_PW_Weight_ANC3]    
      ,SUM(CONVERT(int,ANC4_Weight_Present))[ANC_PW_Weight_ANC4]    
      ,SUM((Case when CONVERT(int,ANC1_Hb_gm_Present)+CONVERT(int,ANC2_Hb_gm_Present)+CONVERT(int,ANC3_Hb_gm_Present)+CONVERT(int,ANC4_Hb_gm_Present)>0 then 1 else 0 end))[ANC_HB_Level_Unique_PW]    
      ,SUM(CONVERT(int,ANC1_Hb_gm_Present))[ANC_PW_HB_Level_ANC1]    
      ,SUM(CONVERT(int,ANC2_Hb_gm_Present))[ANC_PW_HB_Level_ANC2]    
      ,SUM(CONVERT(int,ANC3_Hb_gm_Present))[ANC_PW_HB_Level_ANC3]    
      ,SUM(CONVERT(int,ANC4_Hb_gm_Present))[ANC_PW_HB_Level_ANC4]    
      ,SUM(CONVERT(int,High_risk_Severe))[ANC_High_Risk_Pregnancy_Unique_PW]--HR    
      ,SUM((case when     
      (ANC1_Severe_Anemic=1 or ANC1_Convulsions=1 or ANC1_Diabetic=1 or ANC1_FoulSmellingDischarge=1 or ANC1_High_BP=1 or ANC1_SevereAnaemia=1 or ANC1_Twins=1 or ANC1_VaginalBleeding=1)    
       then 1 else 0 end))[ANC_PW_High_Risk_Pregnancy_ANC1]    
      ,SUM((case when (ANC2_Severe_Anemic=1 or ANC2_Convulsions=1 or ANC2_Diabetic=1 or ANC2_FoulSmellingDischarge=1 or ANC2_High_BP=1 or ANC2_SevereAnaemia=1 or ANC2_Twins=1 or ANC2_VaginalBleeding=1)    
       then 1 else 0 end))[ANC_PW_High_Risk_Pregnancy_ANC2]    
      ,SUM((case when (ANC3_Severe_Anemic=1 or ANC3_Convulsions=1 or ANC3_Diabetic=1 or ANC3_FoulSmellingDischarge=1 or ANC3_High_BP=1 or ANC3_SevereAnaemia=1 or ANC3_Twins=1 or ANC3_VaginalBleeding=1)    
       then 1 else 0 end))[ANC_PW_High_Risk_Pregnancy_ANC3]    
      ,SUM((case when ( ANC4_Severe_Anemic=1 or ANC4_Convulsions=1 or ANC4_Diabetic=1 or ANC4_FoulSmellingDischarge=1 or ANC4_High_BP=1 or ANC4_SevereAnaemia=1 or ANC4_Twins=1 or ANC4_VaginalBleeding=1)    
       then 1 else 0 end))[ANC_PW_High_Risk_Pregnancy_ANC4]    
      ,SUM((case when (ANC1_Severe_Anemic=1 or ANC2_Severe_Anemic=1 or ANC3_Severe_Anemic=1 or ANC4_Severe_Anemic=1) then 1 else 0 end))[ANC_Severe_Anaemic_Unique_PW]    
      ,SUM((case when (ANC1_Moderate_Anemic=1 or ANC2_Moderate_Anemic=1 or ANC3_Moderate_Anemic=1 or ANC4_Moderate_Anemic=1) then 1 else 0 end))[ANC_Moderate_Anaemic_Unique_PW]    
      ,SUM((case when (ANC1_Mild_Anemic=1 or ANC2_Mild_Anemic=1 or ANC3_Mild_Anemic=1 or ANC4_Mild_Anemic=1) then 1 else 0 end))[ANC_Mild_Anaemic_Unique_PW]    
      ,SUM(Convert(int,ANC1_Severe_Anemic))[ANC_Severe_Anaemic_ANC1]    
      ,SUM(Convert(int,ANC1_Moderate_Anemic))[ANC_Moderate_Anaemic_ANC1]    
      ,SUM(Convert(int,ANC1_Mild_Anemic))[ANC_Mild_Anaemic_ANC1]    
      ,SUM(Convert(int,ANC2_Severe_Anemic))[ANC_Severe_Anaemic_ANC2]    
      ,SUM(Convert(int,ANC2_Moderate_Anemic))[ANC_Moderate_Anaemic_ANC2]    
      ,SUM(Convert(int,ANC2_Mild_Anemic))[ANC_Mild_Anaemic_ANC2]    
      ,SUM(Convert(int,ANC3_Severe_Anemic))[ANC_Severe_Anaemic_ANC3]    
      ,SUM(Convert(int,ANC3_Moderate_Anemic))[ANC_Moderate_Anaemic_ANC3]    
      ,SUM(Convert(int,ANC3_Mild_Anemic))[ANC_Mild_Anaemic_ANC3]    
      ,SUM(Convert(int,ANC4_Severe_Anemic))[ANC_Severe_Anaemic_ANC4]    
      ,SUM(Convert(int,ANC4_Moderate_Anemic))[ANC_Moderate_Anaemic_ANC4]    
      ,SUM(Convert(int,ANC4_Mild_Anemic))[ANC_Mild_Anaemic_ANC4]    
      ,SUM(Convert(int,Maternal_Death_Present))[ANC_MD_Total]    
      ,SUM(Convert(int,ANCDeath_Reason_Eclampcia))[ANC_MD_Eclampsia]    
      ,SUM(Convert(int,ANCDeath_Reason_Haemorrahge))[ANC_MD_Haemorrhage]    
      ,SUM(Convert(int,ANCDeath_Reason_HighFever))[ANC_MD_High_Fever]    
      ,SUM(Convert(int,ANCDeath_Reason_Abortion))[ANC_MD_Abortion]    
      ,SUM(Convert(int,Abortion_Present))[ANC_Abortion_Total]    
      ,SUM(Convert(int,Abortion_Spontaneous))[ANC_Abortion_Spontaneous_Total]    
      ,SUM(Convert(int,Abortion_Induced))[ANC_Abortion_Induced_Total]    
      ,SUM(Convert(int,Abortion_Public))[ANC_Abortion_at_Public_Inst]    
      ,SUM(Convert(int,Abortion_Public_Inst_LT12Week))[ANC_Abortion_at_Public_Inst_Less_Than_12Week]    
      ,SUM(Convert(int,Abortion_Public_Inst_MT12Week))[ANC_Abortion_at_Public_Inst_More_Than_12Week]    
      ,SUM(Convert(int,Abortion_PVT))[ANC_Abortion_at_Private_Inst]    
      ,SUM(Convert(int,Abortion_Pvt_Inst_LT12Week))[ANC_Abortion_at_Private_Inst_Less_Than_12Week]    
      ,SUM(Convert(int,Abortion_Pvt_Inst_MT12Week))[ANC_Abortion_at_Private_Inst_More_Than_12Week]    
      ,SUM(Convert(int,Delivery_Date_Present))[Del_Rep_Total]    
      ,SUM(Convert(int,Delivery_Place_Home))[Del_Rep_at_Home]    
      ,SUM((case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) then 1 else 0 end)) [Del_Rep_at_Public]   
      ,SUM((case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) then 1 else 0 end))[Del_Rep_at_Private]    
      ,SUM(Convert(int,Delivery_Complication_Death))[Del_MD_Total]    
      ,SUM((Case when Delivery_Place_Home=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Total]    
      ,SUM((Case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1  or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Public_Intitution_Total]    
      ,SUM((Case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Private_Intitution_Total]    
      ,SUM((Case when (Delivery_Date_Present=0 AND Abortion_Present=0 and EDD_Date>Convert(date,GETDATE())) then 1 else 0 end ))  [Del_EDD]--Added for delivery due    
      ,SUM(Convert(int,Delivery_Place_APH))[Del_Rep_at_Pvt_AH]    
      ,SUM(Convert(int,Delivery_Place_Intransit))[Del_During_Transit]    
      ,SUM((Case when (Delivery_Conducted_By_ANM=1 or Delivery_Conducted_By_LHV=1 or Delivery_Conducted_By_Doctor=1 or Delivery_Conducted_By_StaffNurse=1 or Delivery_Conducted_By_SBA=1) and Delivery_Place_Home=1 then 1 else 0 end))[Del_at_Home_by_SBA]    
      ,SUM((Case when (Delivery_Conducted_By_Relative=1 or Delivery_Conducted_By_Other=1 or Delivery_Conducted_By_NONSBA=1) and Delivery_Place_Home=1 then 1 else 0 end))[Del_at_Home_by_NonSBA]    
      ,SUM(Convert(int,Delivery_Place_DH))[Del_Rep_at_DH]    
      ,0 [Del_Rep_at_FRU]    
      ,SUM(Convert(int,Delivery_Place_CHC))[Del_Rep_at_CHC]    
      ,SUM(Convert(int,Delivery_Place_PHC))[Del_Rep_at_PHC]    
      ,SUM(Convert(int,Delivery_Place_SC))[Del_Rep_at_Sub_Center]    
      ,SUM(Convert(int,Delivery_Place_OPF))[Del_Rep_at_Other_Public_Facility]    
	  ,SUM(Convert(int,Delivery_Place_RH))[Delivery_Place_RH]    
      ,SUM(Convert(int,Delivery_Place_ODH))[Delivery_Place_ODH]    
      ,SUM(Convert(int,Delivery_Place_OMCH))[Delivery_Place_OMCH]    
      ,SUM(Convert(int,Delivery_Place_Others))[Delivery_Place_Others]
      ,SUM(Convert(int,Delivery_Type_Normal))[Del_Normal_Delivery]    
      ,SUM(Convert(int,Delivery_Type_Assissted))[Del_Assisted_Delivery]    
      ,SUM(Convert(int,Delivery_Type_Cesarian))[Del_Caseriean_Delivery]    
      ,SUM((Case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Public]    
      ,SUM((Case when Delivery_Place_OPH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Private]    
      ,SUM((Case when Delivery_Place_APH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_PvtAF]    
      ,SUM((Case when Delivery_Place_DH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_DH]    
      ,0 [Del_Caseriean_at_FRU]    
      ,SUM((Case when Delivery_Place_CHC=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_CHC]    
      ,SUM((Case when Delivery_Place_PHC=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_PHC]    
      ,SUM((Case when Delivery_Place_OPH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Other_Public_Facility]    
      ,SUM(Convert(int,Delivery_date_PretermLT37Week))[Del_PreTerm_Less_Than_37weeks]    
      ,SUM(Convert(int,Delivery_Complication_PPH))[Del_PPH]    
      ,SUM(Convert(int,Delivery_Complication_RetainedPlacenta))[Del_Retained_Placenta]    
      ,SUM(Convert(int,Delivery_Complication_ObstructedDelivery))[Del_Obstructed_Labour]    
      ,SUM(Convert(int,Delivery_Complication_ProlapsedCord))[Del_Prolapsed_Cord]    
      ,SUM(Convert(int,Delivery_Complication_TwinsPregnancy))[Del_Twins_pregnancy]    
      ,SUM(Convert(int,Delivery_Complication_Convulsions))[Del_Convulsions]    
      ,SUM(Convert(int,Discharge_within48hr))[Del_Within_48_Hours]    
      ,SUM(Convert(int,Discharge_within2to5Day))[Del_Between_2_5_days]    
      ,SUM(Convert(int,Discharge_within_Aftr_5Day))[Del_After_5_days]    
      ,SUM(Convert(int,Delivery_Total_Birth))[Del_Total_Birth]    
      ,SUM(Convert(int,Delivery_Live_Birth))[Del_Live_Birth]    
      ,SUM(Convert(int,Delivery_Still_Birth))[Del_Still_Births]    
      ,0[Del_Institutional_Delivery_Total]--Remove    
      ,0[Del_Home_Delivery_Total]--Remove    
      ,SUM((Case when Delivery_Conducted_By_SBA=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Delivery_by_SBA]    
      ,SUM((Case when Delivery_Conducted_By_NONSBA=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Delivery_by_NonSBA]    
      ,SUM((Case when Delivery_Place_Intransit=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Transit_Total]    
      ,SUM(Convert(int,PNC_Death))[PNC_MD_Total]    
      ,SUM((Case when (PNC1_Type_Present=1 or PNC2_Type_Present=1 or PNC3_Type_Present=1 or PNC4_Type_Present=1 or PNC5_Type_Present=1 or PNC6_Type_Present=1 or PNC7_Type_Present=1 ) then 1 else 0 end))[PNC_PNC_Recevied_Total]    
      ,SUM((Case when (PNC1_Type_Present=0 and PNC2_Type_Present=0 and PNC3_Type_Present=0 and PNC4_Type_Present=0 and PNC5_Type_Present=0 and PNC6_Type_Present=0 and PNC7_Type_Present=0 and (Delivery_P=1 or Delivery_T=1)) then 1 else 0 end))[PNC_No_PNC_Recevied_Total]    
      ,SUM((Case when (PNC1_Type_Present=0 and PNC2_Type_Present=0 and PNC3_Type_Present=0 and PNC4_Type_Present=0 and PNC5_Type_Present=0 and PNC6_Type_Present=0 and PNC7_Type_Present=0 ) and Delivery_Place_Home=1 then 0 else 1 end))[PNC_M_delivered_at_Home_Received_No_PNC]    
      ,SUM((Case when (PNC1_Type_Present=1 and PNC2_Type_Present=1 and PNC3_Type_Present=1 and PNC4_Type_Present=1 and PNC5_Type_Present=1 and PNC6_Type_Present=1 and PNC7_Type_Present=1 ) and Delivery_Place_Home=1 then 1 else 0 end))[PNC_M_delivered_at_Home_Received_Full_PNC]    
      ,SUM(Convert(int,PNC1_Type_Present))[PNC_PNC1_Total]    
      ,SUM(Convert(int,PNC1_Type_Present))[PNC_PNC1_Within_24hr_After_del]--PNC1type will come if pnc is given on delivery+one day    
      ,SUM(Convert(int,PNC2_Type_Present))[PNC_PNC2_Total]    
      ,SUM(Convert(int,PNC2_Type_Present))[PNC_PNC2_3rd_Day_of_del]--PNC2type will come if pnc is given on delivery+3rd day    
      ,SUM(Convert(int,PNC3_Type_Present))[PNC_PNC3_Total]    
      ,SUM(Convert(int,[PNC_PNC3_7th_Day_of_del]))[PNC_PNC3_7th_Day_of_del]    
      ,SUM(Convert(int,PNC4_Type_Present))[PNC_PNC4_Total]    
      ,SUM(Convert(int,[PNC_PNC4_14th_Day_of_del]))[PNC_PNC4_14th_Day_of_del]    
      ,SUM(Convert(int,PNC5_Type_Present))[PNC_PNC5_Total]    
      ,SUM(Convert(int,[PNC_PNC5_21th_Day_of_del]))[PNC_PNC5_21th_Day_of_del]    
      ,SUM(Convert(int,PNC6_Type_Present))[PNC_PNC6_Total]    
      ,SUM(Convert(int,[PNC_PNC6_28th_Day_of_del]))[PNC_PNC6_28th_Day_of_del]    
      ,SUM(Convert(int,PNC7_Type_Present))[PNC_PNC7_Total]    
      ,SUM(Convert(int,[PNC_PNC7_42th_Day_of_del]))[PNC_PNC7_42th_Day_of_del]    
      ,SUM((Case when (PNC1_IFA_Tab_Present=1 or PNC2_IFA_Tab_Present=1 or PNC3_IFA_Tab_Present=1 or PNC4_IFA_Tab_Present=1 or PNC5_IFA_Tab_Present=1    
  or PNC6_IFA_Tab_Present=1 or PNC7_IFA_Tab_Present=1) then 1 else 0 end))[PNC_100IFA_Tab_Receive]    
      ,SUM((Case when (PNC1_DangerSign_Present=1 or PNC2_DangerSign_Present=1 or PNC3_DangerSign_Present=1 or PNC4_DangerSign_Present=1 or PNC5_DangerSign_Present=1    
  or PNC6_DangerSign_Present=1 or PNC7_DangerSign_Present=1) then 1 else 0 end))[PNC_M_Identify_With_Danger_Signs_Total]    
   ,SUM((case when Delivery_Date_Present=1     
   and (Convert(int,PNC1_Type_Present)+Convert(int,PNC2_Type_Present)+Convert(int,PNC3_Type_Present)+     
   Convert(int,PNC4_Type_Present)+Convert(int,PNC5_Type_Present)+Convert(int,PNC6_Type_Present)+Convert(int,PNC7_Type_Present))>=4 then 1 else 0 end    
   )) LM_Received4PNC    
   ,SUM((case when Delivery_Date_Present=1     
   and (Convert(int,PNC1_Type_Present)+Convert(int,PNC2_Type_Present)+Convert(int,PNC3_Type_Present)+     
   Convert(int,PNC4_Type_Present)+Convert(int,PNC5_Type_Present)+Convert(int,PNC6_Type_Present)+Convert(int,PNC7_Type_Present))>=4    
   and Delivery_42_Completed=1 then 1 else 0 end    
   )) LM_Completed42D_Del    
   ,Sum(CONVERT(int,Infant1_Breastfeed)+CONVERT(int,Infant2_Breastfeed)+CONVERT(int,Infant3_Breastfeed)+CONVERT(int,Infant4_Breastfeed)    
   +CONVERT(int,Infant5_Breastfeed)+CONVERT(int,Infant6_Breastfeed))Breastfeedwithin_1hr    
   ,Sum(CONVERT(int,Infant1_Death)+CONVERT(int,Infant2_Death)+CONVERT(int,Infant3_Death)+CONVERT(int,Infant4_Death)    
   +CONVERT(int,Infant5_Death)+CONVERT(int,Infant6_Death)) Infant_death_Reported    
   ,Sum(CONVERT(int,Infant1_Male)+CONVERT(int,Infant2_Male)+CONVERT(int,Infant3_Male)+CONVERT(int,Infant4_Male)    
   +CONVERT(int,Infant5_Male)+CONVERT(int,Infant6_Male))Live_Male    
   ,Sum(CONVERT(int,Infant1_FeMale)+CONVERT(int,Infant2_FeMale)+CONVERT(int,Infant3_FeMale)+CONVERT(int,Infant4_FeMale)    
   +CONVERT(int,Infant5_FeMale)+CONVERT(int,Infant6_FeMale))Live_Female    
   ,SUM(Convert(int,Address_Present))[PW_With_Address]    
   ,sum(Convert(int,[Mother_P]))[Mother_P]    
      ,sum(Convert(int,[Mother_T]))[Mother_T]    
      ,sum(Convert(int,[Mother_U]))[Mother_U]    
      ,sum(Convert(int,[ANC1_P])) [ANC1_P]    
      ,sum(Convert(int,[ANC1_T]))[ANC1_T]    
      ,sum(Convert(int,[ANC1_U]))[ANC1_U]    
      ,sum(Convert(int,[ANC2_P]))[ANC2_P]    
      ,sum(Convert(int,[ANC2_T]))[ANC2_T]    
      ,sum(Convert(int,[ANC2_U]))[ANC2_U]    
      ,sum(Convert(int,[ANC3_P]))[ANC3_P]    
      ,sum(Convert(int,[ANC3_T]))[ANC3_T]    
      ,sum(Convert(int,[ANC3_U]))[ANC3_U]    
      ,sum(Convert(int,[ANC4_P])) [ANC4_P]    
      ,sum(Convert(int,[ANC4_T]))[ANC4_T]    
      ,sum(Convert(int,[ANC4_U]))[ANC4_U]    
      ,sum(Convert(int,[TT1_Present])) [TT1_P]    
      ,sum(Convert(int,[TT1_T]))[TT1_T]    
      ,sum(Convert(int,[TT1_U]))[TT1_U]    
      ,sum(Convert(int,[TT2_Present])) [TT2_P]    
      ,sum(Convert(int,[TT2_T]))[TT2_T]    
      ,sum(Convert(int,[TT2_U]))[TT2_U]    
      ,sum(Convert(int,[TTB_Present])) [TTB_P]    
   ,sum(Convert(int,[TTB_T]))[TTB_T]    
   ,sum(Convert(int,[TTB_T]))[TTB_U]    
   ,sum(Convert(int,[PNC1_P]) )[PNC1_P]    
   ,sum(Convert(int,[PNC1_T]))[PNC1_T]    
   ,sum(Convert(int,[PNC1_U]))[PNC1_U]    
   ,sum(Convert(int,[PNC2_P]))[PNC2_P]    
   ,sum(Convert(int,[PNC2_T]))[PNC2_T]    
   ,sum(Convert(int,[PNC2_U]))[PNC2_U]    
   ,sum(Convert(int,[PNC3_P])) [PNC3_P]    
   ,sum(Convert(int,[PNC3_T]))[PNC3_T]    
   ,sum(Convert(int,[PNC3_U]))[PNC3_U]    
   ,sum(Convert(int,[PNC4_P]))[PNC4_P]    
   ,sum(Convert(int,[PNC4_T]))[PNC4_T]    
   ,sum(Convert(int,[PNC4_U]))[PNC4_U]    
   ,sum(Convert(int,[PNC5_P]) )[PNC5_P]    
   ,sum(Convert(int,[PNC5_T]))[PNC5_T]    
   ,sum(Convert(int,[PNC5_U]))[PNC5_U]    
   ,sum(Convert(int,[PNC6_P]))[PNC6_P]    
   ,sum(Convert(int,[PNC6_T]))[PNC6_T]    
   ,sum(Convert(int,[PNC6_U]))[PNC6_U]    
   ,sum(Convert(int,[PNC7_P])) [PNC7_P]    
   ,sum(Convert(int,[PNC7_T]))[PNC7_T]    
   ,sum(Convert(int,[PNC7_U]))[PNC7_U]    
   ,sum(Convert(int,[Delivery_P])) [Delivery_P]    
   ,sum(Convert(int,[Delivery_T]))[Delivery_T]    
   ,sum(Convert(int,[Delivery_U]))[Delivery_U]    
   ,sum(Convert(int,[LMP_P])) [LMP_P]    
   ,sum(Convert(int,[LMP_T]))[LMP_T]    
   ,sum(Convert(int,[LMP_U]))[LMP_U]    
  ,YEAR(a.PW_Death_date)[Year_ID]    
  ,Month(a.PW_Death_date)[Month_ID]    
  ,Day(a.PW_Death_date)[Day_ID]    
  --,DATEDIFF(DAY,cast((Case when Month(a.Mother_Registration_Date)> 3 then YEAR(a.Mother_Registration_Date) else YEAR(a.Mother_Registration_Date)-1 end) as varchar(4))+'-04-01',a.Mother_Registration_Date) as Days_Left    
  ,a.PW_Death_date as [AsOnDate]    
  ,1 as [IsActive],
   (Case when Month(PW_Death_date) <=3 then Year(PW_Death_date)-1 else Year(PW_Death_date) end) as FinYr        
   ,sum(Convert(int,Entry_Type_Death))Total_Death    
   ,SUM((Case when a.PW_Aadhar_No_Present=1 and a.Mobile_no_Present=1 then 1 else 0 end))    
    ,SUM((Case when Mobile_no_Present=1 and Validated_Callcentre=1 then 1 else 0 end)) Reg_Validate_Ph    
   ,SUM((Case when PW_UIDLinked_Present=1 then 1 else 0 end)) Reg_with_UIDlinked    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_Aadhar_No_Present=1 then 1 else 0 end)) JSY_With_UID    
   ,SUM((Case when JSY_Beneficiary_Y=1 and Mobile_no_Present=1 and Validated_Callcentre=1 then 1 else 0 end)) JSY_Validate_Ph    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_Bank_Name_Present=1 then 1 else 0 end)) JSY_With_Bank    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_UIDLinked_Present=1 then 1 else 0 end)) JSY_With_UID_Linked    
   ,SUM((Case when JSY_Beneficiary_Y=1 and (Whose_mobile_Wife=1 or Whose_mobile_Husband=1) then 1 else 0 end)) JSY_With_Self_Ph    
   ,SUM((case when (Delivery_Place_PHC=1 or Delivery_Place_APH=1  or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and High_risk_Severe=1 then 1 else 0 end)) as HR_Del_Pub  
-- added by brijesh  
, SUM(isnull(a.Is_Teen_Age,0)) as Teen_Age_Count   
  
  ------------------------covid  
    
,SUM((Case when isnull(ANC1_Is_ILI_Symptom,0)+isnull(ANC2_Is_ILI_Symptom,0)+isnull(ANC3_Is_ILI_Symptom,0)+isnull(ANC4_Is_ILI_Symptom,0)>0 then 1 else 0 end)) ANC_Is_ILI_Symptom_done  
,SUM((Case when isnull(ANC1_Is_contact_Covid,0)+isnull(ANC2_Is_contact_Covid,0)+isnull(ANC3_Is_contact_Covid,0)+isnull(ANC4_Is_contact_Covid,0)>0 then 1 else 0 end)) ANC_Is_contact_Covid_done  
,SUM((Case when isnull(ANC1_Covid_test_done,0)+isnull(ANC2_Covid_test_done,0)+isnull(ANC3_Covid_test_done,0)+isnull(ANC4_Covid_test_done,0)>0 then 1 else 0 end)) ANC_Covid_test_done  
,SUM((Case when isnull(ANC1_Covid_test_result,0)+isnull(ANC2_Covid_test_result,0)+isnull(ANC3_Covid_test_result,0)+isnull(ANC4_Covid_test_result,0)>0 then 1 else 0 end)) ANC_Covid_test_result_done  
,SUM(del_Is_ILI_Symptom) del_Is_ILI_Symptom_done,SUM(del_Is_contact_Covid) del_Is_contact_Covid_done  
,SUM(del_Covid_test_done) del_Covid_test_done,SUM(del_Covid_test_result) del_Covid_test_result_done  
,SUM((Case when isnull(PNC1_Is_ILI_Symptom,0)+isnull(PNC2_Is_ILI_Symptom,0)+isnull(PNC3_Is_ILI_Symptom,0)+isnull(PNC4_Is_ILI_Symptom,0)+isnull(PNC5_Is_ILI_Symptom,0)+isnull(PNC6_Is_ILI_Symptom,0)+isnull(PNC7_Is_ILI_Symptom,0)>0 then 1 else 0 end)) PNC_Is_ILI_Symptom_done  
,SUM((Case when isnull(PNC1_Is_contact_Covid,0)+isnull(PNC2_Is_contact_Covid,0)+isnull(PNC3_Is_contact_Covid,0)+isnull(PNC4_Is_contact_Covid,0)+isnull(PNC5_Is_contact_Covid,0)+isnull(PNC6_Is_contact_Covid,0)+isnull(PNC7_Is_contact_Covid,0)>0 then 1 else 0 end)) PNC_Is_contact_Covid_done  
,SUM((Case when isnull(PNC1_Covid_test_done,0)+isnull(PNC2_Covid_test_done,0)+isnull(PNC3_Covid_test_done,0)+isnull(PNC4_Covid_test_done,0)+isnull(PNC5_Covid_test_done,0)+isnull(PNC6_Covid_test_done,0)+isnull(PNC7_Covid_test_done,0)>0 then 1 else 0 end))PNC_Covid_test_done  
,SUM((Case when isnull(PNC1_Covid_test_result,0)+isnull(PNC2_Covid_test_result,0)+isnull(PNC3_Covid_test_result,0)+isnull(PNC4_Covid_test_result,0)+isnull(PNC5_Covid_test_result,0)+isnull(PNC6_Covid_test_result,0)+isnull(PNC7_Covid_test_result,0)>0 then 1 else 0 end)) PNC_Covid_test_result_done  
  
  
--  ,SUM((Case when isnull(ANC1_Is_ILI_Symptom,0)+isnull(ANC2_Is_ILI_Symptom,0)+isnull(ANC3_Is_ILI_Symptom,0)+isnull(ANC4_Is_ILI_Symptom,0)>0 then 0 else 1 end)) ANC_Is_ILI_Symptom_Notdone  
--,SUM((Case when isnull(ANC1_Is_contact_Covid,0)+isnull(ANC2_Is_contact_Covid,0)+isnull(ANC3_Is_contact_Covid,0)+isnull(ANC4_Is_contact_Covid,0)>0 then 0 else 1 end)) ANC_Is_contact_Covid_Notdone  
--,SUM((Case when isnull(ANC1_Covid_test_done,0)+isnull(ANC2_Covid_test_done,0)+isnull(ANC3_Covid_test_done,0)+isnull(ANC4_Covid_test_done,0)>0 then 0 else 1 end)) ANC_Covid_test_Notdone  
--,SUM((Case when isnull(ANC1_Covid_test_result,0)+isnull(ANC2_Covid_test_result,0)+isnull(ANC3_Covid_test_result,0)+isnull(ANC4_Covid_test_result,0)>0 then 0 else 1 end)) ANC_Covid_test_result_Notdone  
--,SUM(Case when del_Is_ILI_Symptom>0 then 0 else 1 end) del_Is_ILI_Symptom_Notdone,SUM(Case when del_Is_contact_Covid>0 then 0 else 1 end) del_Is_contact_Covid_Notdone  
--,SUM(Case when del_Covid_test_done>0 then 0 else 1 end) del_Covid_test_Notdone,SUM(Case when del_Covid_test_result>0 then 0 else 1 end) del_Covid_test_result_Notdone  
--,SUM((Case when isnull(PNC1_Is_ILI_Symptom,0)+isnull(PNC2_Is_ILI_Symptom,0)+isnull(PNC3_Is_ILI_Symptom,0)+isnull(PNC4_Is_ILI_Symptom,0)+isnull(PNC5_Is_ILI_Symptom,0)+isnull(PNC6_Is_ILI_Symptom,0)+isnull(PNC7_Is_ILI_Symptom,0)>0 then 0 else 1 end)) PNC_Is_ILI_Symptom_Notdone  
--,SUM((Case when isnull(PNC1_Is_contact_Covid,0)+isnull(PNC2_Is_contact_Covid,0)+isnull(PNC3_Is_contact_Covid,0)+isnull(PNC4_Is_contact_Covid,0)+isnull(PNC5_Is_contact_Covid,0)+isnull(PNC6_Is_contact_Covid,0)+isnull(PNC7_Is_contact_Covid,0)>0 then 0 else 1 end)) PNC_Is_contact_Covid_Notdone  
--,SUM((Case when isnull(PNC1_Covid_test_done,0)+isnull(PNC2_Covid_test_done,0)+isnull(PNC3_Covid_test_done,0)+isnull(PNC4_Covid_test_done,0)+isnull(PNC5_Covid_test_done,0)+isnull(PNC6_Covid_test_done,0)+isnull(PNC7_Covid_test_done,0)>0 then 0 else 1 end)) PNC_Covid_test_Notdone  
--,SUM((Case when isnull(PNC1_Covid_test_result,0)+isnull(PNC2_Covid_test_result,0)+isnull(PNC3_Covid_test_result,0)+isnull(PNC4_Covid_test_result,0)+isnull(PNC5_Covid_test_result,0)+isnull(PNC6_Covid_test_result,0)+isnull(PNC7_Covid_test_result,0)>0 then 0 else 1 end)) PNC_Covid_test_result_Notdone  
  
  
  
,SUM((Case when coalesce(nullif(ANC1_Is_ILI_Symptom,1),nullif(ANC2_Is_ILI_Symptom,1), nullif(ANC3_Is_ILI_Symptom,1), nullif(ANC4_Is_ILI_Symptom,1))=0 then 1 else 0 end)) ANC_Is_ILI_Symptom_Notdone  
,SUM((Case when coalesce(nullif(ANC1_Is_contact_Covid,1),nullif(ANC2_Is_contact_Covid,1),nullif(ANC3_Is_contact_Covid,1),nullif(ANC4_Is_contact_Covid,1))=0 then 1 else 0 end)) ANC_Is_contact_Covid_Notdone  
,SUM((Case when coalesce(nullif(ANC1_Covid_test_done,1),nullif(ANC2_Covid_test_done,1),nullif(ANC3_Covid_test_done,1),nullif(ANC4_Covid_test_done,1))=0 then 1 else 0 end)) ANC_Covid_test_Notdone  
,SUM((Case when coalesce(nullif(ANC1_Covid_test_result,1),nullif(ANC2_Covid_test_result,1),nullif(ANC3_Covid_test_result,1),nullif(ANC4_Covid_test_result,1))=0 then 1 else 0 end)) ANC_Covid_test_result_Notdone  
,SUM(Case when nullif(del_Is_ILI_Symptom,1)=0 then 1 else 0 end) del_Is_ILI_Symptom_Notdone,SUM(Case when nullif(del_Is_contact_Covid,1)=0 then 1 else 0 end) del_Is_contact_Covid_Notdone  
,SUM(Case when nullif(del_Covid_test_done,1)=0 then 1 else 0 end) del_Covid_test_Notdone,SUM(Case when nullif(del_Covid_test_result,1)=0 then 1 else 0 end) del_Covid_test_result_Notdone  
,SUM((Case when coalesce(nullif(PNC1_Is_ILI_Symptom,1),nullif(PNC2_Is_ILI_Symptom,1),nullif(PNC3_Is_ILI_Symptom,1),nullif(PNC4_Is_ILI_Symptom,1),nullif(PNC5_Is_ILI_Symptom,1),nullif(PNC6_Is_ILI_Symptom,1),nullif(PNC7_Is_ILI_Symptom,1))=0 then 1 else 0 end)) PNC_Is_ILI_Symptom_Notdone  
,SUM((Case when coalesce(nullif(PNC1_Is_contact_Covid,1),nullif(PNC2_Is_contact_Covid,1),nullif(PNC3_Is_contact_Covid,1),nullif(PNC4_Is_contact_Covid,1),nullif(PNC5_Is_contact_Covid,1),nullif(PNC6_Is_contact_Covid,1),nullif(PNC7_Is_contact_Covid,1))=0 then 1 else 0 end)) PNC_Is_contact_Covid_Notdone  
,SUM((Case when coalesce(nullif(PNC1_Covid_test_done,1),nullif(PNC2_Covid_test_done,1),nullif(PNC3_Covid_test_done,1),nullif(PNC4_Covid_test_done,1),nullif(PNC5_Covid_test_done,1),nullif(PNC6_Covid_test_done,1),nullif(PNC7_Covid_test_done,1))=0 then 1 else 0 end)) PNC_Covid_test_Notdone  
,SUM((Case when coalesce(nullif(PNC1_Covid_test_result,1),nullif(PNC2_Covid_test_result,1),nullif(PNC3_Covid_test_result,1),nullif(PNC4_Covid_test_result,1),nullif(PNC5_Covid_test_result,1),nullif(PNC6_Covid_test_result,1),nullif(PNC7_Covid_test_result,1))=0 then 1 else 0 end)) PNC_Covid_test_result_Notdone  
,SUM((case when High_risk_Severe=1 and Entry_Type_Death=1 then 1 else 0 end))[PW_High_risk_MD_Total]
,SUM((case when PNC1_Type_Present=1 and PNC2_Type_Present=1  and PNC3_Type_Present=1 and PNC4_Type_Present=1 and PNC5_Type_Present=1 and PNC6_Type_Present=1 and PNC7_Type_Present=1 then 1 else 0 end)) as ALLPNC    
,sum(isnull(is_verified,0)) as is_verified
,Sum(case when ((High_risk_Severe=1 ) and (IFA_Given=1 or Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1)) then 1 else 0 end) as HRP_Managed 
,sum(convert(int,(isnull(Mother_HealthIdNumber,0)))) as Mother_HealthIdNumber
,cast(getdate() as date)

------------------------------  
FROM t_mother_flat_Count a  (nolock)  
inner join t_temp_ReportMasterDate b  (nolock) on  a.StateID=b.State_Code and a.PHC_ID=b.PHC_Code and a.SubCentre_ID=b.SubCentre_Code and a.Village_ID=b.Village_Code    
where  a.PW_Death_date is not null    

group by YEAR(a.PW_Death_date),Month(a.PW_Death_date),Day(a.PW_Death_date),a.PW_Death_date    
,StateID,PHC_ID,SubCentre_ID,Village_ID    


exec Schedule_AC_PW_PHC_SubCenter_Village_Month_Death

exec Schedule_AC_PW_PHC_SubCenter_Month_Death

exec Schedule_AC_PW_Block_PHC_Month_Death

exec Schedule_AC_PW_District_Block_Month_Death

exec Schedule_AC_PW_State_District_Month_Death
end    
    
/*************************************************************************/
  
