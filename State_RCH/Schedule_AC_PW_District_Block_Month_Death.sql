USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_AC_PW_District_Block_Month_Death]    Script Date: 09/26/2024 14:43:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
ALTER procedure [dbo].[Schedule_AC_PW_District_Block_Month_Death]      
as      
begin      
      
truncate table Scheduled_AC_PW_District_Block_Month_Death      
      
      
insert into Scheduled_AC_PW_District_Block_Month_Death([State_Code],[District_Code],[HealthBlock_Code]      
,[PW_Registered],[PW_With_PhoneNo],[PW_With_SelfPhoneNo],[PW_With_Address],[PW_With_Aadhaar_No],[PW_With_Bank_Details],[Mother_P]    
,[Mother_T],[ANC1_P],[ANC1_T],[ANC2_P],[ANC2_T],[ANC3_P],[ANC3_T],[ANC4_P],[ANC4_T],[TT1_P],[TT1_T],[TT2_P],[TT2_T],[TTB_P],[TTB_T]    
,[PNC1_P],[PNC1_T],[PNC2_P],[PNC2_T],[PNC3_P],[PNC3_T],[PNC4_P],[PNC4_T],[PNC5_P],[PNC5_T],[PNC6_P],[PNC6_T],[PNC7_P],[PNC7_T]    
,[Delivery_P],[Delivery_T],[LMP_P],[LMP_T],[PW_First_Trimester],[PW_Second_Trimester],[PW_Third_Trimester],[PW_High_Risk],[PW_Severe_Anaemic]    
,[PW_Mild_Anaemic],[PW_Moderate_Anaemic],[PW_withAge_Less_19],[PW_Delivery_Due],[PW_With_Other_PhoneNo],[PW_MD_Total],[PW_With_Any_3_ANC]    
,[PW_with_UID_Mob],[PW_with_Validated_Mob],[PW_with_UID_Linked],[PW_JSY_Total],[PW_JSY_with_Validated_Mob],[PW_JSY_PW_With_Aadhaar_No]    
,[PW_JSY_Bank_Details],[PW_JSY_with_UID_Linked],[PW_JSY_With_Self_Ph],[PW_JSY_Benifit_Received],[PW_With_No_ANC],[PW_With_All_PNC],[PW_With_Any_PNC],[PW_With_No_PNC]    
,[PW_With_4_PNC],[PW_4_PNC_Within42D],[Reg_Hindu_Total],[Reg_Muslim_Total],[Reg_Sikh_Total]    
,[Reg_Christian_Total],[Reg_Other_Relegion_Total],[Reg_SC],[Reg_ST],[Reg_Other_Caste_Total],[Reg_BPL_Total],[Reg_APL_Total]    
,[Reg_NotKnown_Total],[Med_RTI_STI],[Med_HIV_Postive],[Med_Repeated_Abortion],[Med_Sill_Birth],[Med_Antepartum_haemorrhage],[Med_VDRL_Test]    
,[Med_VDRL_Test_Positive],[Med_HIV_Test],[Med_HIV_Test_Positive],[Med_Blood_Test],[ANC1_within_12Weeks],[ANC2_within_26Weeks],[ANC3_within_34Weeks]    
,[ANC_FA_Total],[ANC_IFA_Total],[ANC_All4],[ANC_FullANC],[ANC_Abortion_at_Private_Inst],[ANC_Abortion_at_Public_Inst],[ANC_Abortion_at_Public_Inst_MT12Week]    
,[ANC_Abortion_at_Public_Inst_LT12Week],[ANC_Abortion_at_Private_Inst_MT12Week],[ANC_Abortion_at_Private_Inst_LT12Week],[ANC_Abortion_Total]    
,[ANC_Abortion_Induced],[ANC_Abortion_Spontaneous],[Del_Public],[Del_Institutional],[Del_Private],[Del_Rep_at_Home],[Del_Rep_at_Pvt_AH],[Del_Rep_at_DH]    
,[Del_Rep_at_FRU],[Del_Rep_at_CHC],[Del_Rep_at_PHC],[Del_Rep_at_SC],[Del_Rep_at_OPF],[Del_During_Transit],[Del_at_Home_by_SBA],[Del_at_Home_by_NonSBA]    
,[Del_Normal_Delivery],[Del_Assisted_Delivery],[Del_Caseriean_Delivery],[Del_Caseriean_at_Public],[Del_Caseriean_at_Private],[Del_Caseriean_at_PvtAF]    
,[Del_Caseriean_at_DH],[Del_Caseriean_at_FRU],[Del_Caseriean_at_CHC],[Del_Caseriean_at_PHC],[Del_Caseriean_at_OPF],[Del_PreTerm_Less_Than_37weeks]    
,[Del_Retained_Placenta],[Del_PPH],[Del_Obstructed_Labour],[Del_Prolapsed_Cord],[Del_Twins_pregnancy],[Del_Within_48_Hours],[Del_Between_2_5_days]    
,[Del_After_5_days],[Del_Total_Birth],[Del_Live_Birth],[Del_Still_Births],[ANC_MD_Total],[Del_MD_Total],[PNC_MD_Total],[ANC_MD_Abortion]    
,[ANC_MD_High_Fever],[ANC_MD_Haemorrhage],[ANC_MD_Eclampsia],[Del_MD_Transit_Total],[Del_MD_Public_Intitution_Total],[Del_MD_Private_Intitution_Total]    
,[Del_MD_Home_Total],[Del_MD_Home_SBA],[Del_MD_Home_NonSBA],[ANC_Mild_Anaemic_ANC4],[ANC_Mild_Anaemic_ANC3],[ANC_Mild_Anaemic_ANC2],[ANC_Mild_Anaemic_ANC1]    
,[ANC_Moderate_Anaemic_ANC4],[ANC_Moderate_Anaemic_ANC3],[ANC_Moderate_Anaemic_ANC2],[ANC_Moderate_Anaemic_ANC1],[ANC_Severe_Anaemic_ANC4]    
,[ANC_Severe_Anaemic_ANC3],[ANC_Severe_Anaemic_ANC2],[ANC_Severe_Anaemic_ANC1],[ANC_HB_Total_TESTED],[ANC_BP_Total_TESTED],[ANC_Weight_Measured]    
,[ANC_Sugar_Fasting_TESTED],[ANC_Urine_TESTED],[ANC_Urine_Sugar_TESTED],[ANC_Urine_Albumin_TESTED],[ANC_PW_HB_Level_ANC4],[ANC_PW_HB_Level_ANC3]    
,[ANC_PW_HB_Level_ANC2],[ANC_PW_HB_Level_ANC1],[ANC_PW_UT_Level_ANC4],[ANC_PW_UT_Level_ANC3],[ANC_PW_UT_Level_ANC2],[ANC_PW_UT_Level_ANC1]    
,[ANC_PW_BP_Level_ANC4],[ANC_PW_BP_Level_ANC3],[ANC_PW_BP_Level_ANC2],[ANC_PW_BP_Level_ANC1],[ANC_High_Risk_ANC4],[ANC_High_Risk_ANC3]    
,[ANC_High_Risk_ANC2],[ANC_High_Risk_ANC1],[ANC_Weight_Measured_ANC4],[ANC_Weight_Measured_ANC3],[ANC_Weight_Measured_ANC2],[ANC_Weight_Measured_ANC1]    
,[PNC_Mother_With_Danger_Sign],[PNC_IFA_Tab],[PNC7_42th_Day_of_del],[PNC6_28th_Day_of_del],[PNC5_21th_Day_of_del],[PNC4_14th_Day_of_del]    
,[PNC3_7th_Day_of_del],[PNC2_3rd_Day_of_del],[PNC1_Within_24hr_After_del],[Del_at_Home_Full_PNC],[Del_at_Home_No_PNC],Med_CSection,Del_HR_Pub    
,[Year_ID],[Month_ID],[Fin_Yr],[Filter_Type],[Teen_Age_Count]  
--------------------covid  
,ANC_Is_ILI_Symptom_done ,ANC_Is_contact_Covid_done ,ANC_Covid_test_done ,ANC_Covid_test_result_done   
,del_Is_ILI_Symptom_done ,del_Is_contact_Covid_done ,del_Covid_test_done ,del_Covid_test_result_done   
,PNC_Is_ILI_Symptom_done ,PNC_Is_contact_Covid_done ,PNC_Covid_test_done ,PNC_Covid_test_result_done   
,ANC_Is_ILI_Symptom_NotDone ,ANC_Is_contact_Covid_NotDone ,ANC_Covid_test_NotDone ,ANC_Covid_test_result_NotDone   
,del_Is_ILI_Symptom_NotDone ,del_Is_contact_Covid_NotDone ,del_Covid_test_NotDone ,del_Covid_test_result_NotDone   
,PNC_Is_ILI_Symptom_NotDone ,PNC_Is_contact_Covid_NotDone ,PNC_Covid_test_NotDone ,PNC_Covid_test_result_NotDone 
,Delivery_Place_RH,Delivery_Place_ODH,Delivery_Place_OMCH,Delivery_Place_Others,PW_High_risk_MD_Total,AllPNC
,is_verified,is_verified_JSY,HRP_Managed,Mother_HealthIdNumber
)      
      
select State_Code,DCode ,HealthBlock_Code       
,SUM([PW_Registered]),SUM([PW_With_PhoneNo]),SUM([PW_With_SelfPhoneNo]),sum([PW_With_Address]),sum([PW_With_Aadhaar_No]),sum([PW_With_Bank_Details]),sum([Mother_P])    
,sum([Mother_T]),sum([ANC1_P]),sum([ANC1_T]),sum([ANC2_P]),sum([ANC2_T]),sum([ANC3_P]),sum([ANC3_T]),sum([ANC4_P]),sum([ANC4_T]),sum([TT1_P]),sum([TT1_T]),sum([TT2_P]),sum([TT2_T]),sum([TTB_P]),sum([TTB_T])    
,sum([PNC1_P]),sum([PNC1_T]),sum([PNC2_P]),sum([PNC2_T]),sum([PNC3_P]),sum([PNC3_T]),sum([PNC4_P]),sum([PNC4_T]),sum([PNC5_P]),sum([PNC5_T]),sum([PNC6_P]),sum([PNC6_T]),sum([PNC7_P]),sum([PNC7_T])    
,sum([Delivery_P]),sum([Delivery_T]),sum([LMP_P]),sum([LMP_T]),sum([PW_First_Trimester]),sum([PW_Second_Trimester]),sum([PW_Third_Trimester]),sum([PW_High_Risk]),sum([PW_Severe_Anaemic])    
,sum([PW_Mild_Anaemic]),sum([PW_Moderate_Anaemic]),sum([PW_withAge_Less_19]),sum([PW_Delivery_Due]),sum([PW_With_Other_PhoneNo]),sum([PW_MD_Total]),sum([PW_With_Any_3_ANC])    
,sum([PW_with_UID_Mob]),sum([PW_with_Validated_Mob]),sum([PW_with_UID_Linked]),sum([PW_JSY_Total]),sum([PW_JSY_with_Validated_Mob]),sum([PW_JSY_PW_With_Aadhaar_No])    
,sum([PW_JSY_Bank_Details]),sum([PW_JSY_with_UID_Linked]),sum([PW_JSY_With_Self_Ph]),sum([PW_JSY_Benifit_Received]),sum([PW_With_No_ANC]),sum([PW_With_All_PNC]),sum([PW_With_Any_PNC]),sum([PW_With_No_PNC])    
,sum([PW_With_4_PNC]),sum([PW_4_PNC_Within42D]),sum([Reg_Hindu_Total]),sum([Reg_Muslim_Total]),sum([Reg_Sikh_Total])    
,sum([Reg_Christian_Total]),sum([Reg_Other_Relegion_Total]),sum([Reg_SC]),sum([Reg_ST]),sum([Reg_Other_Caste_Total]),sum([Reg_BPL_Total]),sum([Reg_APL_Total])    
,sum([Reg_NotKnown_Total]),sum([Med_RTI_STI]),sum([Med_HIV_Postive]),sum([Med_Repeated_Abortion]),sum([Med_Sill_Birth]),sum([Med_Antepartum_haemorrhage]),sum([Med_VDRL_Test])    
,sum([Med_VDRL_Test_Positive]),sum([Med_HIV_Test]),sum([Med_HIV_Test_Positive]),sum([Med_Blood_Test]),sum([ANC1_within_12Weeks]),sum([ANC2_within_26Weeks]),sum([ANC3_within_34Weeks])    
,sum([ANC_FA_Total]),sum([ANC_IFA_Total]),sum([ANC_All4]),sum([ANC_FullANC]),sum([ANC_Abortion_at_Private_Inst]),sum([ANC_Abortion_at_Public_Inst]),sum([ANC_Abortion_at_Public_Inst_MT12Week])    
,sum([ANC_Abortion_at_Public_Inst_LT12Week]),sum([ANC_Abortion_at_Private_Inst_MT12Week]),sum([ANC_Abortion_at_Private_Inst_LT12Week]),sum([ANC_Abortion_Total])    
,sum([ANC_Abortion_Induced]),sum([ANC_Abortion_Spontaneous]),sum([Del_Public]),sum([Del_Institutional]),sum([Del_Private]),sum([Del_Rep_at_Home]),sum([Del_Rep_at_Pvt_AH]),sum([Del_Rep_at_DH])    
,sum([Del_Rep_at_FRU]),sum([Del_Rep_at_CHC]),sum([Del_Rep_at_PHC]),sum([Del_Rep_at_SC]),sum([Del_Rep_at_OPF]),sum([Del_During_Transit]),sum([Del_at_Home_by_SBA]),sum([Del_at_Home_by_NonSBA])    
,sum([Del_Normal_Delivery]),sum([Del_Assisted_Delivery]),sum([Del_Caseriean_Delivery]),sum([Del_Caseriean_at_Public]),sum([Del_Caseriean_at_Private]),sum([Del_Caseriean_at_PvtAF])    
,sum([Del_Caseriean_at_DH]),sum([Del_Caseriean_at_FRU]),sum([Del_Caseriean_at_CHC]),sum([Del_Caseriean_at_PHC]),sum([Del_Caseriean_at_OPF]),sum([Del_PreTerm_Less_Than_37weeks])    
,sum([Del_Retained_Placenta]),sum([Del_PPH]),sum([Del_Obstructed_Labour]),sum([Del_Prolapsed_Cord]),sum([Del_Twins_pregnancy]),sum([Del_Within_48_Hours]),sum([Del_Between_2_5_days])    
,sum([Del_After_5_days]),sum([Del_Total_Birth]),sum([Del_Live_Birth]),sum([Del_Still_Births]),sum([ANC_MD_Total]),sum([Del_MD_Total]),sum([PNC_MD_Total]),sum([ANC_MD_Abortion])    
,sum([ANC_MD_High_Fever]),sum([ANC_MD_Haemorrhage]),sum([ANC_MD_Eclampsia]),sum([Del_MD_Transit_Total]),sum([Del_MD_Public_Intitution_Total]),sum([Del_MD_Private_Intitution_Total])    
,sum([Del_MD_Home_Total]),sum([Del_MD_Home_SBA]),sum([Del_MD_Home_NonSBA]),sum([ANC_Mild_Anaemic_ANC4]),sum([ANC_Mild_Anaemic_ANC3]),sum([ANC_Mild_Anaemic_ANC2]),sum([ANC_Mild_Anaemic_ANC1])    
,sum([ANC_Moderate_Anaemic_ANC4]),sum([ANC_Moderate_Anaemic_ANC3]),sum([ANC_Moderate_Anaemic_ANC2]),sum([ANC_Moderate_Anaemic_ANC1]),sum([ANC_Severe_Anaemic_ANC4])    
,sum([ANC_Severe_Anaemic_ANC3]),sum([ANC_Severe_Anaemic_ANC2]),sum([ANC_Severe_Anaemic_ANC1]),sum([ANC_HB_Total_TESTED]),sum([ANC_BP_Total_TESTED]),sum([ANC_Weight_Measured])    
,sum([ANC_Sugar_Fasting_TESTED]),sum([ANC_Urine_TESTED]),sum([ANC_Urine_Sugar_TESTED]),sum([ANC_Urine_Albumin_TESTED]),sum([ANC_PW_HB_Level_ANC4]),sum([ANC_PW_HB_Level_ANC3])    
,sum([ANC_PW_HB_Level_ANC2]),sum([ANC_PW_HB_Level_ANC1]),sum([ANC_PW_UT_Level_ANC4]),sum([ANC_PW_UT_Level_ANC3]),sum([ANC_PW_UT_Level_ANC2]),sum([ANC_PW_UT_Level_ANC1])    
,sum([ANC_PW_BP_Level_ANC4]),sum([ANC_PW_BP_Level_ANC3]),sum([ANC_PW_BP_Level_ANC2]),sum([ANC_PW_BP_Level_ANC1]),sum([ANC_High_Risk_ANC4]),sum([ANC_High_Risk_ANC3])    
,sum([ANC_High_Risk_ANC2]),sum([ANC_High_Risk_ANC1]),sum([ANC_Weight_Measured_ANC4]),sum([ANC_Weight_Measured_ANC3]),sum([ANC_Weight_Measured_ANC2]),sum([ANC_Weight_Measured_ANC1])    
,sum([PNC_Mother_With_Danger_Sign]),sum([PNC_IFA_Tab]),sum([PNC7_42th_Day_of_del]),sum([PNC6_28th_Day_of_del]),sum([PNC5_21th_Day_of_del]),sum([PNC4_14th_Day_of_del])    
,sum([PNC3_7th_Day_of_del]),sum([PNC2_3rd_Day_of_del]),sum([PNC1_Within_24hr_After_del]),sum([Del_at_Home_Full_PNC]),sum([Del_at_Home_No_PNC]),SUM(Med_CSection),SUM(Del_HR_Pub)    
,[Year_ID],[Month_ID],[Fin_Yr],[Filter_Type],SUM(Teen_Age_Count)    
  
----------------------------------------covid  
--,sum(ANC_Is_ILI_Symptom_done)  ANC_Is_ILI_Symptom_done,Sum(ANC_Is_contact_Covid_done) ANC_Is_contact_Covid_done ,Sum(ANC_Covid_test_done) ANC_Covid_test_done ,Sum(ANC_Covid_test_result_done ) ANC_Covid_test_result_done  
--,Sum(del_Is_ILI_Symptom_done) del_Is_ILI_Symptom_done ,Sum(del_Is_contact_Covid_done) del_Is_contact_Covid_done  ,Sum(del_Covid_test_done) del_Covid_test_done  ,Sum(del_Covid_test_result_done)  del_Covid_test_result_done  
--,Sum(PNC_Is_ILI_Symptom_done) PNC_Is_ILI_Symptom_done ,Sum(PNC_Is_contact_Covid_done) PNC_Is_contact_Covid_done ,Sum(PNC_Covid_test_done) PNC_Covid_test_done ,Sum(PNC_Covid_test_result_done ) PNC_Covid_test_result_done  
--,Sum(ANC_Is_ILI_Symptom_NotDone)  ANC_Is_ILI_Symptom_NotDone,Sum(ANC_Is_contact_Covid_NotDone) ANC_Is_contact_Covid_NotDone ,Sum(ANC_Covid_test_NotDone) ANC_Covid_test_NotDone ,Sum(ANC_Covid_test_result_NotDone ) ANC_Covid_test_result_NotDone  
--,Sum(del_Is_ILI_Symptom_NotDone)  del_Is_ILI_Symptom_NotDone,Sum(del_Is_contact_Covid_NotDone) del_Is_contact_Covid_NotDone ,Sum(del_Covid_test_NotDone) del_Covid_test_NotDone ,Sum(del_Covid_test_result_NotDone ) del_Covid_test_result_NotDone  
--,Sum(PNC_Is_ILI_Symptom_NotDone) PNC_Is_ILI_Symptom_NotDone ,Sum(PNC_Is_contact_Covid_NotDone) PNC_Is_contact_Covid_NotDone ,Sum(PNC_Covid_test_NotDone) PNC_Covid_test_NotDone ,Sum(PNC_Covid_test_result_NotDone ) PNC_Covid_test_result_NotDone   
  
,sum(isnull(ANC_Is_ILI_Symptom_done,0))  ANC_Is_ILI_Symptom_done,sum(isnull(ANC_Is_contact_Covid_done,0)) ANC_Is_contact_Covid_done ,sum(isnull(ANC_Covid_test_done,0)) ANC_Covid_test_done ,sum(isnull(ANC_Covid_test_result_done ,0)) ANC_Covid_test_result_done  
,sum(isnull(del_Is_ILI_Symptom_done,0)) del_Is_ILI_Symptom_done ,sum(isnull(del_Is_contact_Covid_done,0)) del_Is_contact_Covid_done  ,sum(isnull(del_Covid_test_done,0)) del_Covid_test_done  ,sum(isnull(del_Covid_test_result_done,0))  del_Covid_test_result_done  
,sum(isnull(PNC_Is_ILI_Symptom_done,0)) PNC_Is_ILI_Symptom_done ,sum(isnull(PNC_Is_contact_Covid_done,0)) PNC_Is_contact_Covid_done ,sum(isnull(PNC_Covid_test_done,0)) PNC_Covid_test_done ,sum(isnull(PNC_Covid_test_result_done ,0)) PNC_Covid_test_result_done  
,sum(isnull(ANC_Is_ILI_Symptom_NotDone,0))  ANC_Is_ILI_Symptom_NotDone,sum(isnull(ANC_Is_contact_Covid_NotDone,0)) ANC_Is_contact_Covid_NotDone ,sum(isnull(ANC_Covid_test_NotDone,0)) ANC_Covid_test_NotDone ,sum(isnull(ANC_Covid_test_result_NotDone ,0)) ANC_Covid_test_result_NotDone  
,sum(isnull(del_Is_ILI_Symptom_NotDone,0))  del_Is_ILI_Symptom_NotDone,sum(isnull(del_Is_contact_Covid_NotDone,0)) del_Is_contact_Covid_NotDone ,sum(isnull(del_Covid_test_NotDone,0)) del_Covid_test_NotDone ,sum(isnull(del_Covid_test_result_NotDone ,0)) del_Covid_test_result_NotDone  
,sum(isnull(PNC_Is_ILI_Symptom_NotDone,0)) PNC_Is_ILI_Symptom_NotDone ,sum(isnull(PNC_Is_contact_Covid_NotDone,0)) PNC_Is_contact_Covid_NotDone ,sum(isnull(PNC_Covid_test_NotDone,0)) PNC_Covid_test_NotDone ,sum(isnull(PNC_Covid_test_result_NotDone ,0)) PNC_Covid_test_result_NotDone   
,sum(isnull(Delivery_Place_RH,0)),sum(isnull(Delivery_Place_ODH,0)),sum(isnull(Delivery_Place_OMCH,0)),sum(isnull(Delivery_Place_Others,0))  
,SUM(isnull(PW_High_risk_MD_Total,0)),SUM(isnull(AllPNC,0)),SUM(isnull(is_verified,0)) is_verified,SUM(isnull(is_verified_JSY,0)) is_verified_JSY
,SUM(isnull(HRP_Managed,0)) HRP_Managed,SUM(isnull(Mother_HealthIdNumber,0)) Mother_HealthIdNumber

 -------------------   
   
 -------------------   
   
from  Scheduled_AC_PW_Block_PHC_Month_Death a       
  inner join HEALTH_BLOCK b on a.HealthBlock_Code =b.BID      
group by  State_Code,DCode ,HealthBlock_Code       
,[Year_ID],[Month_ID],[Fin_Yr],[Filter_Type]      
      
      
end      
  
  
 /***************************************************/
   
  
  

