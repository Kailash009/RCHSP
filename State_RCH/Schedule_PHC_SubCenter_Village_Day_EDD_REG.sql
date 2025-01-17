USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_EDD_REG]    Script Date: 09/26/2024 14:44:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
[Schedule_PHC_SubCenter_Village_Day_EDD_REG] 9
*/    
    
  ALTER Proc [dbo].[Schedule_PHC_SubCenter_Village_Day_EDD_REG]    
(    
@State_Code int=0    
)    
as    
begin    
    
truncate table t_temp_ReportMasterDate    
insert into t_temp_ReportMasterDate(Created_On,State_Code,PHC_Code,SubCentre_Code,Village_Code)    
select GETDATE(),State_Code,PHC_Code,SubCentre_Code,Village_Code     
from t_Schedule_Date where Mother_EDD_date is not null and State_Code is not null     
group by State_Code,PHC_Code,SubCentre_Code,Village_Code     
    
delete a from  Scheduled_PHC_SubCenter_Village_Day_EDD_REG a    
inner join t_temp_ReportMasterDate b on a.State_Code=b.State_Code and a.HealthFacility_Code=b.PHC_Code and a.HealthSubFacility_Code=b.SubCentre_Code    
and a.Village_Code=b.Village_Code    
    
    
    
insert into Scheduled_PHC_SubCenter_Village_Day_EDD_REG([State_Code],[HealthFacility_Code],[HealthSubFacility_Code],[Village_Code]    
,[Registered_PW_Total],[Reg_Hindu_Total],[Reg_Muslim_Total],[Reg_Sikh_Total],[Reg_Christian_Total],[Reg_Other_Relegion_Total]--10    
,[Reg_SC],[Reg_ST],[Reg_Other_Caste_Total],[Reg_APL_Total],[Reg_BPL_Total],[Reg_APLBPL_NotKnown_Total],[Reg_PW_Register_Less_Than_19Yr_Age]    
,[Reg_With_Aadhaar_No],[Reg_Without_Aadhaar_No],[Reg_With_Bank_Details]--20    
,[Reg_Without_Bank_Details],[Reg_With_Self_Mob_No],[Reg_With_Other_Mob_No],[Reg_Without_Mob_No],[Reg_Entited_JSY_Benifit],[Reg_Received_JSY_Benifit]    
,[Reg_NotReceived_JSY_Benifit],[Reg_PW_HighRisk],[ANC_ANC1_Total],[ANC_ANC2_Total]--30    
,[ANC_ANC3_Total],[ANC_ANC4_Total],[ANC_Any3_ANC_Total],[ANC_All4_ANC_Total],[ANC_TT1_Total],[ANC_TT2_Total],[ANC_TTBooster_Total]    
,[ANC_FA_Total],[ANC_100IFA_Total],[ANC_FullANC_Total]--40    
,[ANC_Blood_Sugar_Fasting_Unique_PW],[ANC_Urine_Test_Done_Unique_PW],[ANC_Urine_Sugar_Unique_PW]    
,[ANC_Urine_Albumin_Unique_PW],[ANC_Urine_Test_Done_ANC1],[ANC_Urine_Test_Done_ANC2],[ANC_Urine_Test_Done_ANC3],[ANC_Urine_Test_Done_ANC4]    
,[ANC_BP_Unique_PW],[ANC_PW_BP_ANC1]--50    
,[ANC_PW_BP_ANC2],[ANC_PW_BP_ANC3],[ANC_PW_BP_ANC4],[ANC_Weight_Unique_PW],[ANC_PW_Weight_ANC1]    
,[ANC_PW_Weight_ANC2],[ANC_PW_Weight_ANC3],[ANC_PW_Weight_ANC4],[ANC_HB_Level_Unique_PW],[ANC_PW_HB_Level_ANC1]--60    
,[ANC_PW_HB_Level_ANC2],[ANC_PW_HB_Level_ANC3],[ANC_PW_HB_Level_ANC4],[ANC_Severe_Anaemic_Unique_PW],[ANC_Moderate_Anaemic_Unique_PW]    
,[ANC_Mild_Anaemic_Unique_PW],[ANC_MD_Total],[ANC_MD_Eclampsia],[ANC_MD_Haemorrhage],[ANC_MD_High_Fever]--70    
,[ANC_MD_Abortion],[ANC_Abortion_Total],[ANC_Abortion_Spontaneous_Total]    
,[ANC_Abortion_Induced_Total],[ANC_Abortion_at_Public_Inst],[ANC_Abortion_at_Public_Inst_Less_Than_12Week],[ANC_Abortion_at_Public_Inst_More_Than_12Week]    
,[ANC_Abortion_at_Private_Inst],[ANC_Abortion_at_Private_Inst_Less_Than_12Week],[ANC_Abortion_at_Private_Inst_More_Than_12Week]--80    
    
,[Del_Rep_Total],[Del_Rep_at_Home],[Del_Rep_at_Public],[Del_Rep_at_Private],[Del_MD_Total],[Del_MD_Home_Total],[Del_MD_Public_Intitution_Total],[Del_MD_Private_Intitution_Total]    
,[Del_EDD],[Del_Rep_at_Pvt_AH]--90    
,[Del_During_Transit],[Del_at_Home_by_SBA],[Del_at_Home_by_NonSBA],[Del_Rep_at_DH],[Del_Rep_at_CHC],[Del_Rep_at_PHC],[Del_Rep_at_Sub_Center]    
,[Del_Rep_at_Other_Public_Facility],[Del_Normal_Delivery],[Del_Assisted_Delivery]--100    
,[Del_Caseriean_Delivery],[Del_Caseriean_at_Public],[Del_Caseriean_at_Private],[Del_Caseriean_at_PvtAF],[Del_Caseriean_at_DH]    
,[Del_Caseriean_at_CHC],[Del_Caseriean_at_PHC],[Del_Caseriean_at_Other_Public_Facility]
,Delivery_Place_RH,Delivery_Place_ODH,Delivery_Place_OMCH,Delivery_Place_Others
,[Del_PreTerm_Less_Than_37weeks],[Del_PPH]--110    
,[Del_Retained_Placenta],[Del_Obstructed_Labour],[Del_Prolapsed_Cord],[Del_Twins_pregnancy],[Del_Convulsions],[Del_Within_48_Hours]    
,[Del_Between_2_5_days],[Del_After_5_days],[Del_Total_Birth],[Del_Live_Birth]--120    
,[Del_Still_Births],[Del_MD_Home_Delivery_by_SBA],[Del_MD_Home_Delivery_by_NonSBA],[Del_MD_Transit_Total]    
,[Del_Highrisk],[Del_Severe_Anaemic],[PNC_MD_Total],[PNC_PNC_Recevied_Total],[PNC_No_PNC_Recevied_Total],[PNC_M_delivered_at_Home_Received_No_PNC]--130    
,[PNC_M_delivered_at_Home_Received_Full_PNC],[PNC_PNC1_Total],[PNC_PNC2_Total],[PNC_PNC3_Total],[PNC_PNC4_Total],[PNC_PNC5_Total]    
,[PNC_PNC6_Total],[PNC_PNC7_Total],[Received4PNC],[Breastfeedwithin_1hr]--140    
,[Infant_death_Reported],[Live_Male],[Live_Female],[PW_With_Address],Reg_Validate_Ph,Reg_with_UIDlinked,JSY_With_UID,JSY_Validate_Ph    
,JSY_With_Bank,JSY_With_UID_Linked,JSY_With_Self_Ph,Del_HR_Pub_Instn,Del_HR_Pri_Instn--152,    
,[ANC_All4_HR_Total],[ANC_All4_Severe_Total],[Del_HR_Home],[Del_Severe_Home],[Del_Severe_Pub_Instn],[Del_Severe_Pri_Instn],[Del_at_Home_HR_by_SBA]    
,[Del_at_Home_HR_by_NonSBA],[Del_at_Home_Severe_by_SBA],[Del_at_Home_Severe_by_NonSBA]--162    
,[Year_ID],[Month_ID],[Day_ID],[AsOnDate],[Fin_Yr],[Teen_Age_Count],PW_High_risk_MD_Total,ALLPNC
,run_date,PNC_PPIUCD,PNC_PPS,PNC_Male_Str,PNC_Condom,PNC_Other_PPC 
,PVTG_P,PVTG_N)    
    
SELECT StateID as State_Code    
      ,PHC_ID as Healthfacility_Code    
      ,SubCentre_ID as HealthSubfacility_Code    
      ,Village_ID as Village_Code    
      ,count(a.Registration_no)[Registered_PW_Total]    
      ,SUM(Convert(int,Religion_Hindu))[Reg_Hindu_Total]    
      ,SUM(Convert(int,Religion_Muslim))[Reg_Muslim_Total]    
      ,SUM(Convert(int,Religion_Sikh))[Reg_Sikh_Total]    
      ,SUM(Convert(int,Religion_Christian))[Reg_Christian_Total]    
      ,SUM(Convert(int,Religion_Other))[Reg_Other_Relegion_Total]--10    
      ,SUM(Convert(int,Caste_SC))[Reg_SC]    
      ,SUM(Convert(int,Caste_ST))[Reg_ST]    
      ,SUM(Convert(int,Caste_Others))[Reg_Other_Caste_Total]    
      ,SUM(Convert(int,Economic_Status_APL))[Reg_APL_Total]    
      ,SUM(Convert(int,Economic_Status_BPL))[Reg_BPL_Total]    
      ,SUM(Convert(int,Economic_Status_Not_Known))[Reg_APLBPL_NotKnown_Total]    
      ,SUM((case when Mother_Age<19 then 1 else 0 end)) [Reg_PW_Register_Less_Than_19Yr_Age]--17    
      ,SUM(Convert(int,PW_Aadhar_No_Present))[Reg_With_Aadhaar_No]    
      ,SUM(Convert(int,PW_Aadhar_No_Absent))[Reg_Without_Aadhaar_No]    
      ,SUM(Convert(int,PW_Bank_Name_Present))[Reg_With_Bank_Details]--20    
      ,SUM(Convert(int,PW_Bank_Name_Absent))[Reg_Without_Bank_Details]    
      ,SUM((case when (Whose_mobile_Wife=1 or Whose_mobile_Husband=1) then 1 else 0 end))[Reg_With_Self_Mob_No]    
      ,SUM(Convert(int,Whose_mobile_Others))[Reg_With_Other_Mob_No]    
      ,SUM(Convert(int,Whose_mobile_Not_Present))[Reg_Without_Mob_No]    
      ,SUM(Convert(int,JSY_Beneficiary_Y))[Reg_Entited_JSY_Benifit]    
      ,SUM(Convert(int,JSY_Payment_Received_Y))[Reg_Received_JSY_Benifit]    
      ,SUM(Convert(int,JSY_Payment_Received_N))[Reg_NotReceived_JSY_Benifit]    
      ,SUM(CONVERT(int,High_risk_Severe))[Reg_PW_HighRisk]--highrisk    
      ,SUM(Convert(int,ANC1_Present))[ANC_ANC1_Total]    
      ,SUM(Convert(int,ANC2_Present))[ANC_ANC2_Total]--30    
      ,SUM(Convert(int,ANC3_Present))[ANC_ANC3_Total]    
      ,SUM(Convert(int,ANC4_Present))[ANC_ANC4_Total]    
      ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)>=3 then 1 else 0 end))[ANC_Any3_ANC_Total]    
      ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)=4 then 1 else 0 end))[ANC_All4_ANC_Total]    
      ,SUM(Convert(int,TT1_Present))[ANC_TT1_Total]    
      ,SUM(Convert(int,TT2_Present))[ANC_TT2_Total]    
      ,SUM(Convert(int,TTB_Present))[ANC_TTBooster_Total]    
      ,SUM((Case when CONVERT(int,ANC1_FA_Given_Present)+CONVERT(int,ANC2_FA_Given_Present)+CONVERT(int,ANC3_FA_Given_Present)+CONVERT(int,ANC4_FA_Given_Present)>0 then 1 else 0 end))[ANC_FA_Total]    
      ,SUM((Case when CONVERT(int,ANC1_IFA_Given_Present)+CONVERT(int,ANC2_IFA_Given_Present)+CONVERT(int,ANC3_IFA_Given_Present)+CONVERT(int,ANC4_IFA_Given_Present)>0 then 1 else 0 end))[ANC_100IFA_Total]    
      ,SUM((Case when ANC1_Present=1 and ANC2_Present=1 and ANC3_Present=1 and ANC4_Present=1and ((TT1_Present=1 and TT2_Present=1)OR TTB_Present=1)    
      and CONVERT(int,ANC1_IFA_Given_Present)+CONVERT(int,ANC2_IFA_Given_Present)+CONVERT(int,ANC3_IFA_Given_Present)+CONVERT(int,ANC4_IFA_Given_Present)>0 then 1 else 0 end))[ANC_FullANC_Total]--40    
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
      ,SUM((Case when CONVERT(int,ANC1_BP_Distolic_Present)+CONVERT(int,ANC1_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC1]--50    
      ,SUM((Case when CONVERT(int,ANC2_BP_Distolic_Present)+CONVERT(int,ANC2_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC2]    
      ,SUM((Case when CONVERT(int,ANC3_BP_Distolic_Present)+CONVERT(int,ANC3_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC3]    
      ,SUM((Case when CONVERT(int,ANC4_BP_Distolic_Present)+CONVERT(int,ANC4_BP_Systolic_Present)>0 then 1 else 0 end))[ANC_PW_BP_ANC4]    
      ,SUM((Case when CONVERT(int,ANC1_Weight_Present)+CONVERT(int,ANC2_Weight_Present)+CONVERT(int,ANC3_Weight_Present)+CONVERT(int,ANC4_Weight_Present)>0 then 1 else 0 end))[ANC_Weight_Unique_PW]    
      ,SUM(CONVERT(int,ANC1_Weight_Present))[ANC_PW_Weight_ANC1]    
      ,SUM(CONVERT(int,ANC2_Weight_Present))[ANC_PW_Weight_ANC2]    
      ,SUM(CONVERT(int,ANC3_Weight_Present))[ANC_PW_Weight_ANC3]    
      ,SUM(CONVERT(int,ANC4_Weight_Present))[ANC_PW_Weight_ANC4]    
      ,SUM((Case when CONVERT(int,ANC1_Hb_gm_Present)+CONVERT(int,ANC2_Hb_gm_Present)+CONVERT(int,ANC3_Hb_gm_Present)+CONVERT(int,ANC4_Hb_gm_Present)>0 then 1 else 0 end))[ANC_HB_Level_Unique_PW]    
      ,SUM(CONVERT(int,ANC1_Hb_gm_Present))[ANC_PW_HB_Level_ANC1]--60    
      ,SUM(CONVERT(int,ANC2_Hb_gm_Present))[ANC_PW_HB_Level_ANC2]    
      ,SUM(CONVERT(int,ANC3_Hb_gm_Present))[ANC_PW_HB_Level_ANC3]    
      ,SUM(CONVERT(int,ANC4_Hb_gm_Present))[ANC_PW_HB_Level_ANC4]      
      ,SUM((case when (ANC1_Severe_Anemic=1 or ANC2_Severe_Anemic=1 or ANC3_Severe_Anemic=1 or ANC4_Severe_Anemic=1) then 1 else 0 end))[ANC_Severe_Anaemic_Unique_PW]    
      ,SUM((case when (ANC1_Moderate_Anemic=1 or ANC2_Moderate_Anemic=1 or ANC3_Moderate_Anemic=1 or ANC4_Moderate_Anemic=1) then 1 else 0 end))[ANC_Moderate_Anaemic_Unique_PW]    
      ,SUM((case when (ANC1_Mild_Anemic=1 or ANC2_Mild_Anemic=1 or ANC3_Mild_Anemic=1 or ANC4_Mild_Anemic=1) then 1 else 0 end))[ANC_Mild_Anaemic_Unique_PW]    
      ,SUM(Convert(int,Maternal_Death_Present))[ANC_MD_Total]    
      ,SUM(Convert(int,ANCDeath_Reason_Eclampcia))[ANC_MD_Eclampsia]    
	  ,SUM(Convert(int,ANCDeath_Reason_Haemorrahge))[ANC_MD_Haemorrhage]    
      ,SUM(Convert(int,ANCDeath_Reason_HighFever))[ANC_MD_High_Fever]--70    
      ,SUM(Convert(int,ANCDeath_Reason_Abortion))[ANC_MD_Abortion]    
      ,SUM(Convert(int,Abortion_Present))[ANC_Abortion_Total]    
      ,SUM(Convert(int,Abortion_Spontaneous))[ANC_Abortion_Spontaneous_Total]    
      ,SUM(Convert(int,Abortion_Induced))[ANC_Abortion_Induced_Total]    
      ,SUM(Convert(int,Abortion_Public))[ANC_Abortion_at_Public_Inst]    
      ,SUM(Convert(int,Abortion_Public_Inst_LT12Week))[ANC_Abortion_at_Public_Inst_Less_Than_12Week]    
      ,SUM(Convert(int,Abortion_Public_Inst_MT12Week))[ANC_Abortion_at_Public_Inst_More_Than_12Week]    
      ,SUM(Convert(int,Abortion_PVT))[ANC_Abortion_at_Private_Inst]    
      ,SUM(Convert(int,Abortion_Pvt_Inst_LT12Week))[ANC_Abortion_at_Private_Inst_Less_Than_12Week]    
      ,SUM(Convert(int,Abortion_Pvt_Inst_MT12Week))[ANC_Abortion_at_Private_Inst_More_Than_12Week]--80    
      ,SUM(Convert(int,Delivery_Date_Present))[Del_Rep_Total]    
      ,SUM(Convert(int,Delivery_Place_Home))[Del_Rep_at_Home]    
      ,SUM((case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) then 1 else 0 end)) [Del_Rep_at_Public]    
      ,SUM((case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) then 1 else 0 end))[Del_Rep_at_Private]    
      ,SUM(Convert(int,Delivery_Complication_Death))[Del_MD_Total]    
      ,SUM((Case when Delivery_Place_Home=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Total]    
      ,SUM((Case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Public_Intitution_Total]    
      ,SUM((Case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Private_Intitution_Total]    
      ,SUM((Case when (Delivery_Date_Present=0 AND Abortion_Present=0 and EDD_Date>Convert(date,GETDATE())) then 1 else 0 end ))  [Del_EDD]--Added for delivery due    
      ,SUM(Convert(int,Delivery_Place_APH))[Del_Rep_at_Pvt_AH]--90    
      ,SUM(Convert(int,Delivery_Place_Intransit))[Del_During_Transit]    
      ,SUM((Case when (Delivery_Conducted_By_ANM=1 or Delivery_Conducted_By_LHV=1 or Delivery_Conducted_By_Doctor=1 or Delivery_Conducted_By_StaffNurse=1 or Delivery_Conducted_By_SBA=1) and Delivery_Place_Home=1 then 1 else 0 end))[Del_at_Home_by_SBA]    
      ,SUM((Case when (Delivery_Conducted_By_Relative=1 or Delivery_Conducted_By_Other=1 or Delivery_Conducted_By_NONSBA=1) and Delivery_Place_Home=1 then 1 else 0 end))[Del_at_Home_by_NonSBA]   
      ,SUM(Convert(int,Delivery_Place_DH))[Del_Rep_at_DH]    
      ,SUM(Convert(int,Delivery_Place_CHC))[Del_Rep_at_CHC]    
      ,SUM(Convert(int,Delivery_Place_PHC))[Del_Rep_at_PHC]    
      ,SUM(Convert(int,Delivery_Place_SC))[Del_Rep_at_Sub_Center]    
      ,SUM(Convert(int,Delivery_Place_OPF))[Del_Rep_at_Other_Public_Facility]    
      ,SUM(Convert(int,Delivery_Type_Normal))[Del_Normal_Delivery]    
      ,SUM(Convert(int,Delivery_Type_Assissted))[Del_Assisted_Delivery]--100    
      ,SUM(Convert(int,Delivery_Type_Cesarian))[Del_Caseriean_Delivery]    
      ,SUM((Case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Public]    
      ,SUM((Case when Delivery_Place_OPH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Private]    
      ,SUM((Case when Delivery_Place_APH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_PvtAF]    
      ,SUM((Case when Delivery_Place_DH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_DH]    
      ,SUM((Case when Delivery_Place_CHC=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_CHC]    
      ,SUM((Case when Delivery_Place_PHC=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_PHC]    
      ,SUM((Case when Delivery_Place_OPH=1 and Delivery_Type_Cesarian=1 then 1 else 0 end))[Del_Caseriean_at_Other_Public_Facility]    
	  ,SUM(Convert(int,Delivery_Place_RH))[Delivery_Place_RH]    
      ,SUM(Convert(int,Delivery_Place_ODH))[Delivery_Place_ODH]    
      ,SUM(Convert(int,Delivery_Place_OMCH))[Delivery_Place_OMCH]
      ,SUM(Convert(int,Delivery_Place_Others))[Delivery_Place_Others] 
      ,SUM(Convert(int,Delivery_date_PretermLT37Week))[Del_PreTerm_Less_Than_37weeks]    
      ,SUM(Convert(int,Delivery_Complication_PPH))[Del_PPH]--110    
      ,SUM(Convert(int,Delivery_Complication_RetainedPlacenta))[Del_Retained_Placenta]    
      ,SUM(Convert(int,Delivery_Complication_ObstructedDelivery))[Del_Obstructed_Labour]    
      ,SUM(Convert(int,Delivery_Complication_ProlapsedCord))[Del_Prolapsed_Cord]    
      ,SUM(Convert(int,Delivery_Complication_TwinsPregnancy))[Del_Twins_pregnancy]    
      ,SUM(Convert(int,Delivery_Complication_Convulsions))[Del_Convulsions]    
      ,SUM(Convert(int,Discharge_within48hr))[Del_Within_48_Hours]    
      ,SUM(Convert(int,Discharge_within2to5Day))[Del_Between_2_5_days]    
      ,SUM(Convert(int,Discharge_within_Aftr_5Day))[Del_After_5_days]    
      ,SUM(Convert(int,Delivery_Total_Birth))[Del_Total_Birth]    
      ,SUM(Convert(int,Delivery_Live_Birth))[Del_Live_Birth]--120    
      ,SUM(Convert(int,Delivery_Still_Birth))[Del_Still_Births]    
      ,SUM((Case when Delivery_Conducted_By_SBA=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Delivery_by_SBA]    
      ,SUM((Case when Delivery_Conducted_By_NONSBA=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Home_Delivery_by_NonSBA]    
      ,SUM((Case when Delivery_Place_Intransit=1 and Delivery_Complication_Death=1 then 1 else 0 end))[Del_MD_Transit_Total]    
      ,SUM((Case when Delivery_Date_Present=1 and High_risk_Severe=1 then 1 else 0 end)) [Del_Highrisk]    
      ,SUM((Case when Delivery_Date_Present=1 and (ANC1_Severe_Anemic=1 or ANC2_Severe_Anemic=1 or ANC3_Severe_Anemic=1 or ANC4_Severe_Anemic=1) then 1 else 0 end)) [Del_Severe]    
    
      ,SUM(Convert(int,PNC_Death))[PNC_MD_Total]    
      ,SUM((Case when (PNC1_Type_Present=1 or PNC2_Type_Present=1 or PNC3_Type_Present=1 or PNC4_Type_Present=1 or PNC5_Type_Present=1 or PNC6_Type_Present=1 or PNC7_Type_Present=1 ) then 1 else 0 end))[PNC_PNC_Recevied_Total]    
      ,SUM((Case when (PNC1_Type_Present=0 and PNC2_Type_Present=0 and PNC3_Type_Present=0 and PNC4_Type_Present=0 and PNC5_Type_Present=0 and PNC6_Type_Present=0 and PNC7_Type_Present=0 and (Delivery_P=1 or Delivery_T=1)) then 1 else 0 end))[PNC_No_PNC_Recevied_Total]    
      ,SUM((Case when (PNC1_Type_Present=0 and PNC2_Type_Present=0 and PNC3_Type_Present=0 and PNC4_Type_Present=0 and PNC5_Type_Present=0 and PNC6_Type_Present=0 and PNC7_Type_Present=0 ) and Delivery_Place_Home=1 then 0 else 1 end))[PNC_M_delivered_at_Home_Received_No_PNC]    
      ,SUM((Case when (PNC1_Type_Present=1 and PNC2_Type_Present=1 and PNC3_Type_Present=1 and PNC4_Type_Present=1 and PNC5_Type_Present=1 and PNC6_Type_Present=1 and PNC7_Type_Present=1 ) and Delivery_Place_Home=1 then 1 else 0 end))[PNC_M_delivered_at_Home_Received_Full_PNC]    
      ,SUM(Convert(int,PNC1_Type_Present))[PNC_PNC1_Total]    
      ,SUM(Convert(int,PNC2_Type_Present))[PNC_PNC2_Total]    
      ,SUM(Convert(int,PNC3_Type_Present))[PNC_PNC3_Total]    
      ,SUM(Convert(int,PNC4_Type_Present))[PNC_PNC4_Total]    
      ,SUM(Convert(int,PNC5_Type_Present))[PNC_PNC5_Total]    
      ,SUM(Convert(int,PNC6_Type_Present))[PNC_PNC6_Total]    
      ,SUM(Convert(int,PNC7_Type_Present))[PNC_PNC7_Total]    
   ,SUM((case when Delivery_Date_Present=1     
   and (Convert(int,PNC1_Type_Present)+Convert(int,PNC2_Type_Present)+Convert(int,PNC3_Type_Present)+     
   Convert(int,PNC4_Type_Present)+Convert(int,PNC5_Type_Present)+Convert(int,PNC6_Type_Present)+Convert(int,PNC7_Type_Present))>=4 then 1 else 0 end    
   )) Received4PNC    
   ,Sum(CONVERT(int,Infant1_Breastfeed)+CONVERT(int,Infant2_Breastfeed)+CONVERT(int,Infant3_Breastfeed)+CONVERT(int,Infant4_Breastfeed)    
   +CONVERT(int,Infant5_Breastfeed)+CONVERT(int,Infant6_Breastfeed))Breastfeedwithin_1hr--140    
   ,Sum(CONVERT(int,Infant1_Death)+CONVERT(int,Infant2_Death)+CONVERT(int,Infant3_Death)+CONVERT(int,Infant4_Death)    
   +CONVERT(int,Infant5_Death)+CONVERT(int,Infant6_Death)) Infant_death_Reported    
   ,Sum(CONVERT(int,Infant1_Male)+CONVERT(int,Infant2_Male)+CONVERT(int,Infant3_Male)+CONVERT(int,Infant4_Male)    
   +CONVERT(int,Infant5_Male)+CONVERT(int,Infant6_Male))Live_Male    
   ,Sum(CONVERT(int,Infant1_FeMale)+CONVERT(int,Infant2_FeMale)+CONVERT(int,Infant3_FeMale)+CONVERT(int,Infant4_FeMale)    
   +CONVERT(int,Infant5_FeMale)+CONVERT(int,Infant6_FeMale))Live_Female    
   ,SUM(Convert(int,Address_Present))[PW_With_Address]--144    
   ,SUM((Case when Mobile_no_Present=1 and Validated_Callcentre=1 then 1 else 0 end)) Reg_Validate_Ph    
   ,SUM((Case when PW_UIDLinked_Present=1 then 1 else 0 end)) Reg_with_UIDlinked    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_Aadhar_No_Present=1 then 1 else 0 end)) JSY_With_UID    
   ,SUM((Case when JSY_Beneficiary_Y=1 and Mobile_no_Present=1 and Validated_Callcentre=1 then 1 else 0 end)) JSY_Validate_Ph    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_Bank_Name_Present=1 then 1 else 0 end)) JSY_With_Bank    
   ,SUM((Case when JSY_Beneficiary_Y=1 and PW_UIDLinked_Present=1 then 1 else 0 end)) JSY_With_UID_Linked    
   ,SUM((Case when JSY_Beneficiary_Y=1 and (Whose_mobile_Wife=1 or Whose_mobile_Husband=1) then 1 else 0 end)) JSY_With_Self_Ph    
   ,SUM((case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and High_risk_Severe=1 then 1 else 0 end)) [Del_HR_Rep_at_Public]    
      ,SUM((case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) and High_risk_Severe=1 then 1 else 0 end))[Del_HR_Rep_at_Private]    
      ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)=4 and High_risk_Severe=1 then 1 else 0 end)) [ANC_All4_HR_Total]    
   ,SUM((Case when CONVERT(int,ANC1_Present)+CONVERT(int,ANC2_Present)+CONVERT(int,ANC3_Present)+CONVERT(int,ANC4_Present)=4 and Severe_Anemic_Case=1 then 1 else 0 end)) [ANC_All4_Severe_Total]    
   ,SUM((Case when CONVERT(int,Delivery_Place_Home)=1 and High_risk_Severe=1 then 1 else 0 end)) [Del_HR_Home]    
   ,SUM((Case when CONVERT(int,Delivery_Place_Home)=1 and Severe_Anemic_Case=1 then 1 else 0 end)) [Del_Severe_Home]    
   ,SUM((case when (Delivery_Place_PHC=1 or Delivery_Place_CHC=1 or  Delivery_Place_DH=1 or Delivery_Place_OPF=1 or Delivery_Place_SDH=1 or Delivery_Place_MCH=1 or Delivery_Place_SC=1 or Delivery_Place_UHC=1 or Delivery_Place_RH=1 or Delivery_Place_ODH=1 or Delivery_Place_OMCH=1) and Severe_Anemic_Case=1 then 1 else 0 end)) [Del_Severe_Pub_Instn]    
   ,SUM((case when (Delivery_Place_APH=1 or Delivery_Place_OPH=1 ) and Severe_Anemic_Case=1 then 1 else 0 end))[Del_Severe_Pri_Instn]    
   ,SUM((Case when Delivery_Conducted_By_SBA=1 and High_risk_Severe=1 then 1 else 0 end))[Del_at_Home_HR_by_SBA]    
   ,SUM((Case when Delivery_Conducted_By_NONSBA=1 and High_risk_Severe=1 then 1 else 0 end))[Del_at_Home_HR_by_NonSBA]    
   ,SUM((Case when Delivery_Conducted_By_SBA=1 and Severe_Anemic_Case=1 then 1 else 0 end))[Del_at_Home_Severe_by_SBA]    
   ,SUM((Case when Delivery_Conducted_By_NONSBA=1 and Severe_Anemic_Case=1 then 1 else 0 end))[Del_at_Home_Severe_by_NonSBA]    
      ,Year(EDD_Date) [Year_ID]    
      ,month(EDD_Date) [Month_ID]    
      ,Day(EDD_Date)[Day_ID]    
         
      ,EDD_Date as [AsOnDate]    
   , (Case when month(EDD_Date) <=3 then Year(EDD_Date)-1 else Year(EDD_Date) end) as FinYr    
  -- added by brijesh  
,SUM(isnull(a.Is_Teen_Age,0)) as Teen_Age_Count
,SUM((case when High_risk_Severe=1 and Entry_Type_Death=1 then 1 else 0 end))[PW_High_risk_MD_Total]
,SUM((case when PNC1_Type_Present=1 and PNC2_Type_Present=1  and PNC3_Type_Present=1 and PNC4_Type_Present=1 and PNC5_Type_Present=1 and PNC6_Type_Present=1 and PNC7_Type_Present=1 then 1 else 0 end)) as ALLPNC       
,cast(getdate() as date)
,SUM((Case when (PNC1_PPIUCD=1 or PNC2_PPIUCD=1 or PNC3_PPIUCD=1 or PNC4_PPIUCD=1 or PNC5_PPIUCD=1 or PNC6_PPIUCD=1 or PNC7_PPIUCD=1 ) then 1 else 0 end))PNC_PPIUCD  
,SUM((Case when (PNC1_PPS=1 or PNC2_PPS=1 or PNC3_PPS=1 or PNC4_PPS=1 or PNC5_PPS=1 or PNC6_PPS=1 or PNC7_PPS=1 ) then 1 else 0 end))PNC_PPS
,SUM((Case when (PNC1_Male_Str=1 or PNC2_Male_Str=1 or PNC3_Male_Str=1 or PNC4_Male_Str=1 or PNC5_Male_Str=1 or PNC6_Male_Str=1 or PNC7_Male_Str=1 ) then 1 else 0 end))PNC_Male_Str
,SUM((Case when (PNC1_Condom=1 or PNC2_Condom=1 or PNC3_Condom=1 or PNC4_Condom=1 or PNC5_Condom=1 or PNC6_Condom=1 or PNC7_Condom=1 ) then 1 else 0 end))PNC_Condom
,SUM((Case when (PNC1_Other_PPC=1 or PNC2_Other_PPC=1 or PNC3_Other_PPC=1 or PNC4_Other_PPC=1 or PNC5_Other_PPC=1 or PNC6_Other_PPC=1 or PNC7_Other_PPC=1 ) then 1 else 0 end))PNC_Other_PPC
,SUM(case when IS_PVTG='Y' then 1 else 0 end)PVTG_P
,SUM(case when IS_PVTG='N' then 1 else 0 end)PVTG_N
    
    
  FROM t_mother_flat_Count   a    
  inner join t_temp_ReportMasterDate b on a.StateID=b.State_Code and a.PHC_ID=b.PHC_Code and a.SubCentre_ID=b.SubCentre_Code and a.Village_ID=b.Village_Code    
   where StateID is not null and EDD_Date is not null and YEAR(EDD_Date)>2000     
      
  group by Year(EDD_Date),month(EDD_Date),Day(EDD_Date),EDD_Date    
  ,StateID,PHC_ID,SubCentre_ID,Village_ID    
      
    
    
end    

/*********************************************************************/
