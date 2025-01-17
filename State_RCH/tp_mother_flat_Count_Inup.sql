USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_flat_Count_Inup]    Script Date: 09/26/2024 14:49:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Proc [dbo].[tp_mother_flat_Count_Inup]      
as      
begin      
--truncate table t_mother_flat_Count      
delete w from t_mother_flat_Count  w      
inner join t_mother_flat a on a.Registration_no=w.Registration_no and a.Case_no=w.Case_no      
where CONVERT(date, a.Exec_Date)=CONVERT(date, GETDATE())             
insert into t_mother_flat_Count      
([StateID],[District_ID],[Rural_Urban],[HealthBlock_ID],[Taluka_ID],[Facility_ID],[PHC_ID],[SubCentre_ID],[Village_ID],[Registration_no]      
,[Case_no],[EC_Register_srno_Present],[EC_Register_srno_Absent],[ID_No_Present],[ID_No_Absent],[Whose_mobile_Neighbour],[Whose_mobile_Husband]      
,[Whose_mobile_Others],[Whose_mobile_Wife],[Whose_mobile_Relative]--20      
,[Whose_mobile_Not_Present],[Landline_no_Present],[Landline_no_Absent],[Mobile_no_Present],[Mobile_no_Absent],EC_Registration_Date,[Wife_current_age]      
,[Wife_marry_age],[Hus_current_age],[Hus_marry_age]--30      
,[Address_Present] ,[Address_Absent],[Religion_Hindu],[Religion_Muslim],[Religion_Sikh],[Religion_Christian],[Religion_Other],[Religion_Absent],[Caste_SC]      
,[Caste_ST]--40      
,[Caste_Others],[Caste_Absent],[PW_Aadhar_No_Present],[PW_Aadhar_No_Absent],[PW_Bank_Name_Present],[PW_Bank_Name_Absent],[Economic_Status_BPL],[Economic_Status_APL]      
,[Economic_Status_Not_Known],[Economic_Status_Absent]--50      
,[Mother_Registration_Date],[Mother_Weight],[Mother_BirthDate],[Mother_Age],[JSY_Beneficiary_Y],[JSY_Payment_Received_Y],[JSY_Payment_Received_N]      
,[JSY_Payment_Received_Absent],[Delete_Mother],[DeletedOn]--60      
,[Entry_Type_Active],[Entry_Type_Death],[Entry_Type_Migrated_In],[Entry_Type_Migrated_Out],[Entry_Type_Deceased],[Entry_Type_Absent],[CPSMS_Flag_Yes]      
,[CPSMS_Flag_No],[LMP_Date],[Reg_12Weeks_Y]--70      
,[Reg_12Weeks_N],[EDD_Date],[Blood_Group_Present],[Blood_Group_Absent],[Blood_Test_Done],[Blood_Test_NotDone],[VDRL_TEST_Done],[VDRL_TEST_NotDone]      
,[VDRL_Result_Positive],[VDRL_Result_Negative]--80      
,[VDRL_Date],[HIV_TEST_Done],[HIV_TEST_NotDone],[HIV_Result_Positive],[HIV_Result_Negative],[HIV_Date],[Pastillness_TB],[Pastillness_Diabetes]      
,[Pastillness_Hypertension],[Pastillness_HeartDisease]--90      
,[Pastillness_Epileptic],[Pastillness_STI_RTI],[Pastillness_HIV_POS],[Pastillness_Hepatitis_B],[Pastillness_Asthma],[Pastillness_Other]      
,[Pastillness_None],[LastPregComp_APH],[LastPregComp_Convulsion],[LastPregComp_PHI]--100      
,[LastPregComp_Repeatedabortion],[LastPregComp_Stillbirth],[LastPregComp_CongenitalAnomaly],[LastPregComp_CSection],[LastPregComp_BloodTransfusion]      
,[LastPregComp_Twins],[LastPregComp_ObstructedLabour],[LastPregComp_PPH],[LastPregComp_Other],[LastPregComp_None]--110      
,[L2LPregComp_APH],[L2LPregComp_Convulsion],[L2LPregComp_PHI],[L2LPregComp_Repeatedabortion],[L2LPregComp_Stillbirth],[L2LPregComp_CongenitalAnomaly]      
,[L2LPregComp_CSection],[L2LPregComp_BloodTransfusion],[L2LPregComp_Twins],[L2LPregComp_ObstructedLabour]--120      
,[L2LPregComp_PPH],[L2LPregComp_Other],[L2LPregComp_None],[Maternal_Death_Present],[ANCDeath_Reason_Eclampcia],[ANCDeath_Reason_Haemorrahge]      
,[ANCDeath_Reason_Abortion],[ANCDeath_Reason_HighFever],ANCDeath_Reason_Other,[Abortion_Present]--130      
,[Abortion_Spontaneous],[Abortion_Induced],[Abortion_Public],[Abortion_PVT],[Abortion_Public_Inst_LT12Week],[Abortion_Public_Inst_MT12Week]      
,[Abortion_Pvt_Inst_LT12Week],[Abortion_Pvt_Inst_MT12Week],[ANC1],[ANC1_Present]--140      
,[ANC1_Within12_Week],[ANC1_High_BP],[ANC1_Convulsions],[ANC1_VaginalBleeding],[ANC1_FoulSmellingDischarge],[ANC1_SevereAnaemia],[ANC1_Diabetic]      
,[ANC1_Twins],[ANC1_Others],[ANC1_BP_Systolic_Present]--150      
,[ANC1_BP_Systolic_Absent],[ANC1_BP_Distolic_Present],[ANC1_BP_Distolic_Absent],[ANC1_Hb_gm_Present],[ANC1_Hb_gm_Absent],[ANC1_Urine_Test_Done]      
,[ANC1_Urine_Test_NotDone],[ANC1_Urine_Albumin_Present],[ANC1_Urine_Albumin_Absent],[ANC1_Urine_Sugar_Present]--160      
,[ANC1_Urine_Sugar_Absent],[ANC1_BloodSugar_Test_Done],[ANC1_BloodSugar_Test_NotDone],[ANC1_Blood_Sugar_Fasting_Present],[ANC1_Blood_Sugar_Fasting_Absent]      
,[ANC1_Blood_Sugar_Post_Prandial_Present],[ANC1_Blood_Sugar_Post_Prandial_Absent],[ANC1_FA_Given_Present],[ANC1_FA_Given_Absent],[ANC1_IFA_Given_Present]--170      
,[ANC1_IFA_Given_Absent],[ANC1_Weight_Present],[ANC1_Weight_Absent],[ANC1_Severe_Anemic],[ANC1_Mild_Anemic],[ANC1_Moderate_Anemic],[ANC2],[ANC2_Present]      
,ANC2_Within26_Week,[ANC2_High_BP]--180      
,[ANC2_Convulsions],[ANC2_VaginalBleeding],[ANC2_FoulSmellingDischarge],[ANC2_SevereAnaemia],[ANC2_Diabetic],[ANC2_Twins],[ANC2_Others]      
,[ANC2_BP_Systolic_Present],[ANC2_BP_Systolic_Absent],[ANC2_BP_Distolic_Present]--190      
,[ANC2_BP_Distolic_Absent],[ANC2_Hb_gm_Present],[ANC2_Hb_gm_Absent],[ANC2_Urine_Test_Done],[ANC2_Urine_Test_NotDone],[ANC2_Urine_Albumin_Present]      
,[ANC2_Urine_Albumin_Absent],[ANC2_Urine_Sugar_Present],[ANC2_Urine_Sugar_Absent],[ANC2_BloodSugar_Test_Done]--200      
,[ANC2_BloodSugar_Test_NotDone],[ANC2_Blood_Sugar_Fasting_Present],[ANC2_Blood_Sugar_Fasting_Absent],[ANC2_Blood_Sugar_Post_Prandial_Present]      
,[ANC2_Blood_Sugar_Post_Prandial_Absent],[ANC2_FA_Given_Present],[ANC2_FA_Given_Absent],[ANC2_IFA_Given_Present],[ANC2_IFA_Given_Absent],[ANC2_Weight_Present]--210      
,[ANC2_Weight_Absent],[ANC2_Severe_Anemic],[ANC2_Mild_Anemic],[ANC2_Moderate_Anemic],[ANC3],[ANC3_Present],ANC3_Within34_Week      
,[ANC3_High_BP],[ANC3_Convulsions],[ANC3_VaginalBleeding]--220      
,[ANC3_FoulSmellingDischarge],[ANC3_SevereAnaemia],[ANC3_Diabetic],[ANC3_Twins],[ANC3_Others],[ANC3_BP_Systolic_Present],[ANC3_BP_Systolic_Absent]      
,[ANC3_BP_Distolic_Present],[ANC3_BP_Distolic_Absent],[ANC3_Hb_gm_Present]--230      
,[ANC3_Hb_gm_Absent],[ANC3_Urine_Test_Done],[ANC3_Urine_Test_NotDone],[ANC3_Urine_Albumin_Present],[ANC3_Urine_Albumin_Absent],[ANC3_Urine_Sugar_Present]      
,[ANC3_Urine_Sugar_Absent],[ANC3_BloodSugar_Test_Done],[ANC3_BloodSugar_Test_NotDone],[ANC3_Blood_Sugar_Fasting_Present]--240      
,[ANC3_Blood_Sugar_Fasting_Absent],[ANC3_Blood_Sugar_Post_Prandial_Present],[ANC3_Blood_Sugar_Post_Prandial_Absent],[ANC3_FA_Given_Present]      
,[ANC3_FA_Given_Absent],[ANC3_IFA_Given_Present],[ANC3_IFA_Given_Absent],[ANC3_Weight_Present],[ANC3_Weight_Absent]--250      
,[ANC3_Severe_Anemic],[ANC3_Mild_Anemic],[ANC3_Moderate_Anemic],[ANC4],[ANC4_Present],ANC4_Pregnancy_Week ,[ANC4_High_BP]      
,[ANC4_Convulsions],[ANC4_VaginalBleeding],[ANC4_FoulSmellingDischarge]--260      
,[ANC4_SevereAnaemia],[ANC4_Diabetic],[ANC4_Twins],[ANC4_Others],[ANC4_BP_Systolic_Present],[ANC4_BP_Systolic_Absent],[ANC4_BP_Distolic_Present]      
,[ANC4_BP_Distolic_Absent],[ANC4_Hb_gm_Present],[ANC4_Hb_gm_Absent]--270      
,[ANC4_Urine_Test_Done],[ANC4_Urine_Test_NotDone],[ANC4_Urine_Albumin_Present],[ANC4_Urine_Albumin_Absent],[ANC4_Urine_Sugar_Present],[ANC4_Urine_Sugar_Absent]      
,[ANC4_BloodSugar_Test_Done],[ANC4_BloodSugar_Test_NotDone],[ANC4_Blood_Sugar_Fasting_Present],[ANC4_Blood_Sugar_Fasting_Absent]--280      
,[ANC4_Blood_Sugar_Post_Prandial_Present],[ANC4_Blood_Sugar_Post_Prandial_Absent],[ANC4_FA_Given_Present],[ANC4_FA_Given_Absent],[ANC4_IFA_Given_Present]      
,[ANC4_IFA_Given_Absent],[ANC4_Weight_Present],[ANC4_Weight_Absent],[ANC4_Severe_Anemic],[ANC4_Mild_Anemic]--290      
,[ANC4_Moderate_Anemic],[TT1_Present],[TT2_Present],[TTB_Present],[Delivery_date_Present],[Delivery_date_PretermLT37Week],[Delivery_Place_PHC]      
,[Delivery_Place_CHC],[Delivery_Place_DH],[Delivery_Place_OPF]--300      
,[Delivery_Place_APH],[Delivery_Place_OPH],[Delivery_Place_Home],[Delivery_Place_SDH],[Delivery_Place_MCH],[Delivery_Place_Intransit],[Delivery_Place_SC],Delivery_Place_UHC
,Delivery_Place_RH,Delivery_Place_ODH,Delivery_Place_OMCH,Delivery_Place_Others     
,[Delivery_Complication_PPH],[Delivery_Complication_RetainedPlacenta],[Delivery_Complication_ObstructedDelivery]--310      
,[Delivery_Complication_ProlapsedCord],[Delivery_Complication_TwinsPregnancy],[Delivery_Complication_Convulsions],[Delivery_Complication_Death],[Delivery_Complication_Other]      
,[Delivery_Complication_DontKnow],[Delivery_Complication_None],[DeliveryDeath_Reason_Eclampcia] ,[DeliveryDeath_Reason_Haemorrahge] ,[DeliveryDeath_Reason_ObstructedLabour] --320      
,[DeliveryDeath_Reason_ProlongedLabour],[DeliveryDeath_Reason_HighFever] ,[DeliveryDeath_Reason_Other] ,[Delivery_Type_Normal],[Delivery_Type_Cesarian]      
,[Delivery_Type_Assissted],[Delivery_Conducted_By_ANM],[Delivery_Conducted_By_LHV],[Delivery_Conducted_By_Doctor],[Delivery_Conducted_By_StaffNurse]--330      
,[Delivery_Conducted_By_Relative],[Delivery_Conducted_By_Other],[Delivery_Conducted_By_SBA],[Delivery_Conducted_By_NONSBA],[Delivery_Live_Birth]      
,[Delivery_Still_Birth],[Delivery_Total_Birth],[Discharge_within48hr],[Discharge_within2to5Day],[Discharge_within_Aftr_5Day]--340      
,[PNC_Death],[PNC1_Type_Present],[PNC1_Type_Absent],[PNC1_IFA_Tab_Present],[PNC1_DangerSign_Present],[PNC2_Type_Present],[PNC2_Type_Absent]      
,[PNC2_IFA_Tab_Present],[PNC2_DangerSign_Present],[PNC3_Type_Present]--350      
,[PNC3_Type_Absent],[PNC3_IFA_Tab_Present],[PNC3_DangerSign_Present],[PNC4_Type_Present],[PNC4_Type_Absent],[PNC4_IFA_Tab_Present],[PNC4_DangerSign_Present]      
,[PNC5_Type_Present],[PNC5_Type_Absent],[PNC5_IFA_Tab_Present]--360      
,[PNC5_DangerSign_Present],[PNC6_Type_Present],[PNC6_Type_Absent],[PNC6_IFA_Tab_Present],[PNC6_DangerSign_Present],[PNC7_Type_Present],[PNC7_Type_Absent]      
,[PNC7_IFA_Tab_Present],[PNC7_DangerSign_Present],[PNC_PNC3_7th_Day_of_del]--370      
,[PNC_PNC4_14th_Day_of_del],[PNC_PNC5_21th_Day_of_del],[PNC_PNC6_28th_Day_of_del],[PNC_PNC7_42th_Day_of_del]      
,LMP_month,LMP_Year,IFA_Given,[Mother_P],[Mother_T],[Mother_U]--380      
,[LMP_P],[LMP_T],[LMP_U],[ANC1_P],[ANC1_T],[ANC1_U],[ANC2_P],[ANC2_T],[ANC2_U],[ANC3_P]--390      
,[ANC3_T],[ANC3_U],[ANC4_P],[ANC4_T],[ANC4_U],[PNC1_P],[PNC1_T],[PNC1_U],[PNC2_P],[PNC2_T]--400      
,[PNC2_U],[PNC3_P],[PNC3_T],[PNC3_U],[PNC4_P],[PNC4_T],[PNC4_U],[PNC5_P],[PNC5_T],[PNC5_U]--410      
,[PNC6_P],[PNC6_T],[PNC6_U],[PNC7_P],[PNC7_T],[PNC7_U],[Infant1_Live],Infant2_Live ,Infant3_Live ,Infant4_Live --420    
,Infant5_Live ,Infant6_Live ,  Infant1_Breastfeed ,Infant2_Breastfeed ,Infant3_Breastfeed ,Infant4_Breastfeed ,Infant5_Breastfeed ,Infant6_Breastfeed ,    
Infant1_Death ,Infant2_Death ,Infant3_Death ,Infant4_Death ,Infant5_Death ,Infant6_Death ,    
Infant1_Male ,Infant2_Male ,Infant3_Male ,Infant4_Male ,Infant5_Male ,Infant6_Male ,--440    
Infant1_Female ,Infant2_Female ,Infant3_Female ,Infant4_Female ,Infant5_Female ,Infant6_Female,Delivery_42_Completed,PW_UIDLinked_Present,PW_UIDLinked_Absent,Hus_UIDLinked_Present--450    
,Hus_UIDLinked_Absent,PW_Acc_Present,PW_Acc_Absent,Hus_Acc_Present,Hus_Acc_Absent ,Mother_Reg_Fin_Yr,LMP_minanc1 ,LMP_maxanc1,LMP_minanc2,LMP_maxanc2--460    
,LMP_minanc3,LMP_maxanc3,LMP_minanc4,LMP_7m,LMP_84d ,EDD_month,EDD_Yr,EDD_FinYr,LMP_FinYr,Del_minpnc1--470    
,Del_minpnc2,Del_minpnc3,Del_minpnc4,Del_minpnc5,Del_minpnc6,Del_minpnc7,Del_45d,Del_month,Del_Yr,Del_FinYr--480    
,TT1_30d,Delivery_P,Delivery_T,Delivery_U,ANC1_visit_Present,ANC2_visit_Present,ANC3_visit_Present,ANC4_visit_Present,ANC5_visit_Present,ANC6_visit_Present--490    
,ANC7_visit_Present,ANC8_visit_Present,ANC9_visit_Present,ANC10_visit_Present,ANC11_visit_Present,ANC12_visit_Present,ANC13_visit_Present    
,ANC1_visit_Absent,ANC2_visit_Absent,ANC3_visit_Absent--500    
,ANC4_visit_Absent,ANC5_visit_Absent,ANC6_visit_Absent,ANC7_visit_Absent,ANC8_visit_Absent,ANC9_visit_Absent,ANC10_visit_Absent,ANC11_visit_Absent,ANC12_visit_Absent,ANC13_visit_Absent--510    
,Validated_Callcentre,Delivery_date,[Call_Ans_Yes],[Call_Ans_No],NoCall_Reason_1,NoCall_Reason_2,NoCall_Reason_3,NoCall_Reason_4,NoCall_Reason_5,NoCall_Reason_6--520    
,NoCall_Reason_7,IsPhoneNoCorrect,Phoneno_NotCorrect,NoPhone_Reason_1,NoPhone_Reason_2,NoPhone_Reason_3,NoPhone_Reason_4,NoPhone_Reason_5,NoPhone_Reason_11,NoPhone_Reason_12--530   
 ,NoPhone_Reason_13,Is_Confirmed--532,    
,Exec_date,distinct_ec,mcts_full_anc,mcts_ifa_given,Is_Teen_Age    
--------------------covid  
,ANC1_Is_ILI_Symptom ,ANC1_Is_contact_Covid ,ANC1_Covid_test_done ,ANC1_Covid_test_result ,  
ANC2_Is_ILI_Symptom ,ANC2_Is_contact_Covid ,ANC2_Covid_test_done ,ANC2_Covid_test_result ,  
ANC3_Is_ILI_Symptom ,ANC3_Is_contact_Covid ,ANC3_Covid_test_done ,ANC3_Covid_test_result ,  
ANC4_Is_ILI_Symptom ,ANC4_Is_contact_Covid ,ANC4_Covid_test_done ,ANC4_Covid_test_result ,  
ANC99_Is_ILI_Symptom ,ANC99_Is_contact_Covid ,ANC99_Covid_test_done ,ANC99_Covid_test_result ,  
del_Is_ILI_Symptom ,del_Is_contact_Covid ,del_Covid_test_done ,del_Covid_test_result ,  
PNC1_Is_ILI_Symptom ,PNC1_Is_contact_Covid ,PNC1_Covid_test_done ,PNC1_Covid_test_result ,  
PNC2_Is_ILI_Symptom ,PNC2_Is_contact_Covid ,PNC2_Covid_test_done ,PNC2_Covid_test_result ,  
PNC3_Is_ILI_Symptom ,PNC3_Is_contact_Covid ,PNC3_Covid_test_done ,PNC3_Covid_test_result ,  
PNC4_Is_ILI_Symptom ,PNC4_Is_contact_Covid ,PNC4_Covid_test_done ,PNC4_Covid_test_result ,  
PNC5_Is_ILI_Symptom ,PNC5_Is_contact_Covid ,PNC5_Covid_test_done ,PNC5_Covid_test_result ,  
PNC6_Is_ILI_Symptom ,PNC6_Is_contact_Covid ,PNC6_Covid_test_done ,PNC6_Covid_test_result ,  
PNC7_Is_ILI_Symptom ,PNC7_Is_contact_Covid ,PNC7_Covid_test_done ,PNC7_Covid_test_result,
is_verified,
------------------------  
Mother_HealthIdNumber,Mother_HealthId,cc_total,cc_sent,PW_Death_date,
HBSAG_Test,HBSAG_Date,HBSAG_Result,
Infant1_HBIG_Date,Infant2_HBIG_Date,Infant3_HBIG_Date,Infant4_HBIG_Date,Infant5_HBIG_Date,Infant6_HBIG_Date,
------
 PNC1_PPIUCD ,PNC2_PPIUCD ,PNC3_PPIUCD ,PNC4_PPIUCD ,PNC5_PPIUCD ,PNC6_PPIUCD ,PNC7_PPIUCD ,
 PNC1_PPS ,PNC2_PPS ,PNC3_PPS ,PNC4_PPS ,PNC5_PPS ,PNC6_PPS ,PNC7_PPS ,
 PNC1_Male_Str ,PNC2_Male_Str ,PNC3_Male_Str ,PNC4_Male_Str ,PNC5_Male_Str ,PNC6_Male_Str ,PNC7_Male_Str ,
 PNC1_Condom,PNC2_Condom,PNC3_Condom,PNC4_Condom,PNC5_Condom ,PNC6_Condom,PNC7_Condom ,
 PNC1_Other_PPC ,PNC2_Other_PPC ,PNC3_Other_PPC ,PNC4_Other_PPC ,PNC5_Other_PPC ,PNC6_Other_PPC ,PNC7_Other_PPC 
 --------
 ,IS_PVTG

)      
      
SELECT  [M_StateID]      
      ,[M_District_ID]      
      ,[Rural_Urban]      
      ,[M_HealthBlock_ID]      
      ,[M_Taluka_ID]      
      ,[M_Facility_ID]      
      ,[M_PHC_ID]      
      ,[M_SubCentre_ID]      
      ,[M_Village_ID]      
      ,[Registration_no]      
      ,[Case_no]--11      
      ,(Case when ISNULL(EC_Register_srno,0)=0 then 0 when EC_Register_srno='' then 0 else 1 end )[EC_Register_srno_Present]      
      ,(Case when ISNULL(EC_Register_srno,0)=0 then 1 when EC_Register_srno='' then 1 else 0 end )[EC_Register_srno_Absent]      
      ,(Case when ISNULL(ID_No,'0')='0' then 0 when ID_No='' then 0 else 1 end )[ID_No_Present]      
      ,(Case when ISNULL(ID_No,'0')='0' then 1 when ID_No='' then 1 else 0 end )[ID_No_Absent]      
      ,(Case when Whose_mobile='Neighbour' then 1 else 0 end )[Whose_mobile_Neighbour]      
      ,(Case when Whose_mobile='Husband' then 1 else 0 end )[Whose_mobile_Husband]      
      ,(Case when Whose_mobile='Others' then 1 else 0 end )[Whose_mobile_Others]      
      ,(Case when Whose_mobile='Wife' then 1 else 0 end )[Whose_mobile_Wife]      
      ,(Case when Whose_mobile='Relative' then 1 else 0 end )[Whose_mobile_Relative]--20      
      ,(Case when ISNULL(Whose_mobile,'')='' then 1 else 0 end )[Whose_mobile_Not_Present]      
      ,(Case when ISNULL(Landline_no,'')='' then 0 else 1 end )[Landline_no_Present]      
      ,(Case when ISNULL(Landline_no,'')='' then 1 else 0 end )[Landline_no_Absent]      
      ,(Case when ISNULL(Mobile_no,'')='' then 0 else 1 end )[Mobile_no_Present]      
      ,(Case when ISNULL(Mobile_no,'')='' then 1 else 0 end )[Mobile_no_Absent]      
      ,[EC_Regisration_Date]      
      ,[Wife_current_age]      
      ,[Wife_marry_age]      
      ,[Hus_current_age]      
      ,[Hus_marry_age]--30      
      ,(Case when ISNULL(Address,'0')='0' then 0 when Address='' then 0 else 1 end )[Address_Present]      
      ,(Case when ISNULL(Address,'0')='0' then 1 when Address='' then 1 else 0 end )[Address_Absent]      
      ,(Case when Religion='Hindu' then 1 else 0 end )[Religion_Hindu]      
      ,(Case when Religion='Muslim' then 1 else 0 end )[Religion_Muslim]      
      ,(Case when Religion='Sikh' then 1 else 0 end )[Religion_Sikh]      
      ,(Case when Religion='Christian' then 1 else 0 end )[Religion_Christian]      
      ,(Case when Religion='Other' then 1 else 0 end )[Religion_Other]      
      ,(Case when ISNULL(Religion,'0')='0' then 1 when Religion='' then 1 else 0 end )[Religion_Absent]      
      ,(Case when Caste='SC' then 1 else 0 end )[Caste_SC]      
      ,(Case when Caste='ST' then 1 else 0 end )[Caste_ST]--40      
      ,(Case when Caste='Others' then 1 else 0 end )[Caste_Others]      
      ,(Case when ISNULL(Caste,'0')='0' then 1 when Caste='' then 1 else 0 end )[Caste_Absent]      
      ,(Case when ISNULL(PW_Aadhar_No,0)=0 then 0 else 1 end )[PW_Aadhar_No_Present]      
      ,(Case when ISNULL(PW_Aadhar_No,0)=0 then 1 else 0 end )[PW_Aadhar_No_Absent]      
      ,(Case when ISNULL(PW_Bank_Name,'0')='0' then 0 when PW_Bank_Name='' then 0 else 1 end )[PW_Bank_Name_Present]      
      ,(Case when ISNULL(PW_Bank_Name,'0')='0' then 1 when PW_Bank_Name='' then 1 else 0 end )[PW_Bank_Name_Absent]      
      ,(Case when Economic_Status='BPL' then 1 else 0 end )[Economic_Status_BPL]      
      ,(Case when Economic_Status='APL' then 1 else 0 end )[Economic_Status_APL]      
      ,(Case when Economic_Status='Not Known' then 1 else 0 end )[Economic_Status_NotKnown]      
      ,(Case when ISNULL(Economic_Status,'S')='S' then 1 when Economic_Status='' then 1 else 0 end )[Economic_Status_Absent]--50      
      ,[Mother_Registration_Date]      
      ,[Mother_Weight]      
      ,[Mother_BirthDate]      
      ,[Mother_Age]      
      ,(Case when JSY_Beneficiary='Y' then 1 else 0 end )[JSY_Beneficiary_Y]      
      ,(Case when JSY_Payment_Received='Y' then 1 else 0 end )[JSY_Payment_Received_Y]      
      ,(Case when JSY_Payment_Received='N' then 1 else 0 end )[JSY_Payment_Received_N]      
      ,(Case when ISNULL(JSY_Payment_Received,'0')='0' then 1 when JSY_Payment_Received='' then 1 else 0 end )[JSY_Payment_Received_Absent]      
      ,[Delete_Mother]      
      ,[DeletedOn]--60      
      ,(Case when Entry_Type='Active' then 1 else 0 end )[Entry_Type_Active]      
      ,(Case when Entry_Type='Death' then 1 else 0 end )[Entry_Type_Death]      
      ,(Case when Entry_Type='Migrated_In' then 1 else 0 end )[Entry_Type_Migrated_In]      
      ,(Case when Entry_Type='Migrated_Out' then 1 else 0 end )[Entry_Type_Migrated_Out]      
      ,(Case when Entry_Type='Deceased' then 1 else 0 end )[Entry_Type_Deceased]      
      ,(Case when ISNULL(Entry_Type,'0')='0' then 1 when Entry_Type='' then 1 else 0 end )[Entry_Type_Absent]      
      ,(Case when CPSMS_Flag='Yes' then 1 else 0 end )[CPSMS_Flag_Yes]      
      ,(Case when CPSMS_Flag='No' then 1 else 0 end )[CPSMS_Flag_No]      
      ,[Medical_LMP_Date] [LMP_Date]      
      ,(Case when Medical_Reg_12Weeks='Y' then 1 else 0 end )[Reg_12Weeks_Y]--70      
      ,(Case when Medical_Reg_12Weeks='N' then 1 else 0 end )[Reg_12Weeks_N]      
      ,[Medical_EDD_Date] [EDD_Date]      
      ,(Case when ISNULL(Medical_Blood_Group,'0')='0' then 0 when Medical_Blood_Group='' then 0 else 1 end  )[Blood_Group_Present]      
      ,(Case when ISNULL(Medical_Blood_Group,'0')='0' then 1 when Medical_Blood_Group='' then 1 else 0 end  )[Blood_Group_Absent]      
      ,(Case when BloodGroup_Test='Done' then 1 else 0 end )[Blood_Test_Done]      
      ,(Case when BloodGroup_Test='Not Done' then 1 else 0 end )[Blood_Test_NotDone]      
      ,(Case when Medical_VDRL_TEST='Done' then 1 else 0 end )[VDRL_TEST_Done]      
      ,(Case when Medical_VDRL_TEST='Not Done' then 1 else 0 end )[VDRL_TEST_NotDone]      
      ,(Case when Med_VDRL_Result='Positive' then 1 else 0 end )[VDRL_Result_Positive]      
      ,(Case when Med_VDRL_Result='Negative' then 1 else 0 end )[VDRL_Result_Negative]--80      
      ,Medical_VDRL_Date [VDRL_Date]      
      ,(Case when Medical_HIV_TEST='Done' then 1 else 0 end )[HIV_TEST_Done]      
      ,(Case when Medical_HIV_TEST='Not Done' then 1 else 0 end )[HIV_TEST_NotDone]      
      ,(Case when Med_HIV_Result='Positive' then 1 else 0 end )[HIV_Result_Positive]      
      ,(Case when Med_HIV_Result='Negative' then 1 else 0 end )[HIV_Result_Negative]      
      ,Medical_HIV_Date [HIV_Date]      
      ,(Case when Patindex('%A%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_TB]      
      ,(Case when Patindex('%B%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_Diabetes]      
      ,(Case when Patindex('%C%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_Hypertension]      
      ,(Case when Patindex('%D%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_HeartDisease]--90      
      ,(Case when Patindex('%E%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_Epileptic]      
      ,(Case when Patindex('%F%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_STI_RTI]      
      ,(Case when Patindex('%G%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_HIV_POS]      
      ,(Case when Patindex('%H%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_Hepatitis_B]      
      ,(Case when Patindex('%I%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_Asthma]      
      ,(Case when Patindex('%Z%',Med_PastIllness_Val)<>1 then 1 else 0 end )[Pastillness_Other]      
      ,(Case when Patindex('%J%',Med_PastIllness_Val)<>0 then 1 else 0 end )[Pastillness_None]      
      ,(Case when Patindex('%B%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_APH]      
      ,(Case when Patindex('%A%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_Convulsion]      
      ,(Case when Patindex('%C%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_PHI]--100      
      ,(Case when Patindex('%D%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_Repeatedabortion]      
      ,(Case when Patindex('%E%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_Stillbirth]      
      ,(Case when Patindex('%F%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_CongenitalAnomaly]      
      ,(Case when Patindex('%G%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_CSection]      
      ,(Case when Patindex('%H%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_BloodTransfusion]      
      ,(Case when Patindex('%I%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_Twins]      
      ,(Case when Patindex('%J%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_ObstructedLabour]      
      ,(Case when Patindex('%K%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_PPH]      
      ,(Case when Patindex('%Z%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_Other]      
      ,(Case when Patindex('%L%',Med_Last_Preg_Complication_Val)<>0 then 1 else 0 end )[LastPregComp_None]--110      
            
      ,(Case when Patindex('%B%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_APH]      
      ,(Case when Patindex('%A%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_Convulsion]      
      ,(Case when Patindex('%C%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_PHI]      
      ,(Case when Patindex('%D%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_Repeatedabortion]      
      ,(Case when Patindex('%E%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_Stillbirth]      
      ,(Case when Patindex('%F%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_CongenitalAnomaly]      
      ,(Case when Patindex('%G%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_CSection]      
      ,(Case when Patindex('%H%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_BloodTransfusion]      
      ,(Case when Patindex('%I%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_Twins]      
      ,(Case when Patindex('%J%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_ObstructedLabour]--120      
      ,(Case when Patindex('%K%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_PPH]      
      ,(Case when Patindex('%Z%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_Other]      
      ,(Case when Patindex('%L%',Med_SecondLast_Preg_Complication_Val)<>0 then 1 else 0 end )[L2LPregComp_None]      
      ,(Case when isnull(Maternal_Death,0)=0 then 0 else 1 end)[Maternal_Death_Present]      
      ,(Case when Patindex('%A%',Death_Reason)<>0 then 1 else 0 end )[ANCDeath_Reason_Eclampcia]      
      ,(Case when Patindex('%B%',Death_Reason)<>0 then 1 else 0 end )[ANCDeath_Reason_Haemorrahge]      
      ,(Case when Patindex('%D%',Death_Reason)<>0 then 1 else 0 end )[ANCDeath_Reason_Abortion]      
      ,(Case when Patindex('%C%',Death_Reason)<>0 then 1 else 0 end )[ANCDeath_Reason_HighFever]      
      ,(Case when Patindex('%Z%',Death_Reason)<>0 then 1 else 0 end )[Death_Reason_Other]      
      ,(Case when AbortionDate is not null then 1 else 0 end )[Abortion_Present]--130      
      ,(Case when Abortion_Type='Spontaneous' then 1 else 0 end )[Abortion_Spontaneous]      
      ,(Case when Abortion_Type='Induced' then 1 else 0 end )[Abortion_Induced]      
      ,(Case when Induced_Indicate_Facility='Govt. Hospital' then 1 else 0 end )[Abortion_Public]      
      ,(Case when Induced_Indicate_Facility='Pvt. Hospital' then 1 else 0 end )[Abortion_PVT]      
      ,(Case when Induced_Indicate_Facility='Govt. Hospital' and Abortion_Preg_Weeks<=12 then 1 else 0 end )[Abortion_Public_Inst_LT12Week]      
      ,(Case when Induced_Indicate_Facility='Govt. Hospital' and Abortion_Preg_Weeks>12 then 1 else 0 end )[Abortion_Public_Inst_MT12Week]      
      ,(Case when Induced_Indicate_Facility='Pvt. Hospital' and Abortion_Preg_Weeks<=12 then 1 else 0 end )[Abortion_Pvt_Inst_LT12Week]      
      ,(Case when Induced_Indicate_Facility='Pvt. Hospital' and Abortion_Preg_Weeks>12 then 1 else 0 end )[Abortion_Pvt_Inst_MT12Week]      
      ,[ANC1]      
      ,(Case when ANC1 is not null then 1 else 0 end )[ANC1_Present]--140      
      ,(Case when ANC1_Pregnancy_Week<12 then 1 else 0 end )[ANC1_Within12_Week]      
      ,(Case when Patindex('%A%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_High_BP]      
      ,(Case when Patindex('%B%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_Convulsions]      
      ,(Case when Patindex('%C%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_VaginalBleeding]      
      ,(Case when Patindex('%D%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_FoulSmellingDischarge]      
      ,(Case when Patindex('%E%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_SevereAnaemia]      
      ,(Case when Patindex('%F%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_Diabetic]      
      ,(Case when Patindex('%G%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_Twins]      
      ,(Case when Patindex('%Z%',ANC1_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC1_Others]      
      ,(Case when isnull(ANC1_BP_Systolic,0)>0 then 1 else 0 end )[ANC1_BP_Systolic_Present]--150      
      ,(Case when isnull(ANC1_BP_Systolic,0)>0 then 0 else 1 end )[ANC1_BP_Systolic_Absent]      
      ,(Case when isnull(ANC1_BP_Distolic,0)>0 then 1 else 0 end )[ANC1_BP_Distolic_Present]      
      ,(Case when isnull(ANC1_BP_Distolic,0)>0 then 0 else 1 end )[ANC1_BP_Distolic_Absent]      
      ,(Case when isnull(ANC1_Hb_gm,0)>0 then 1 else 0 end )[ANC1_Hb_gm_Present]      
      ,(Case when isnull(ANC1_Hb_gm,0)>0 then 0 else 1 end )[ANC1_Hb_gm_Absent]      
      ,(Case when ANC1_Urine_Test='Done' then 1 else 0 end )[ANC1_Urine_Test_Done]      
      ,(Case when ANC1_Urine_Test='Not Done' then 1 else 0 end )[ANC1_Urine_Test_NotDone]      
      ,(Case when ANC1_Urine_Albumin='Present' then 1 else 0 end )[ANC1_Urine_Albumin_Present]      
      ,(Case when ANC1_Urine_Albumin='Absent' then 1 else 0 end )[ANC1_Urine_Albumin_Absent]      
      ,(Case when ANC1_Urine_Sugar='Present' then 1 else 0 end )[ANC1_Urine_Sugar_Present]--160      
      ,(Case when ANC1_Urine_Sugar='Absent' then 1 else 0 end )[ANC1_Urine_Sugar_Absent]      
      ,(Case when ANC1_BloodSugar_Test='Done' then 1 else 0 end )[ANC1_BloodSugar_Test_Done]      
      ,(Case when ANC1_BloodSugar_Test='Not Done' then 1 else 0 end )[ANC1_BloodSugar_Test_NotDone]      
      ,(Case when isnull(ANC1_Blood_Sugar_Fasting,0)>0 then 1 else 0 end )[ANC1_Blood_Sugar_Fasting_Present]      
      ,(Case when isnull(ANC1_Blood_Sugar_Fasting,0)>0 then 0 else 1 end )[ANC1_Blood_Sugar_Fasting_Absent]      
      ,(Case when isnull(ANC1_Blood_Sugar_Post_Prandial,0)>0 then 1 else 0 end )[ANC1_Blood_Sugar_Post_Prandial_Present]      
      ,(Case when isnull(ANC1_Blood_Sugar_Post_Prandial,0)>0 then 0 else 1 end )[ANC1_Blood_Sugar_Post_Prandial_Absent]      
      ,(Case when isnull(ANC1_FA_Given,0)>0 then 1 else 0 end )[ANC1_FA_Given_Present]      
      ,(Case when isnull(ANC1_FA_Given,0)>0 then 0 else 1 end )[ANC1_FA_Given_Absent]      
      ,(Case when isnull(ANC1_IFA_Given,0)>0 then 1 else 0 end )[ANC1_IFA_Given_Present]--170      
      ,(Case when isnull(ANC1_IFA_Given,0)>0 then 0 else 1 end )[ANC1_IFA_Given_Absent]      
      ,(Case when isnull(ANC1_Weight,0)>0 then 1 else 0 end )[ANC1_Weight_Present]      
      ,(Case when isnull(ANC1_Weight,0)>0 then 0 else 1 end )[ANC1_Weight_Absent]      
      ,(Case when isnull(ANC1_Hb_gm,0) between 1 and 6.9 then 1 else 0 end )[ANC1_Severe_Anemic]      
      ,(Case when isnull(ANC1_Hb_gm,0) between 9.1 and 11 then 1 else 0 end )[ANC1_Mild_Anemic]      
      ,(Case when isnull(ANC1_Hb_gm,0) between 7 and 9 then 1 else 0 end )[ANC1_Moderate_Anemic]      
      ,[ANC2]      
      ,(Case when ANC2 is not null then 1 else 0 end )[ANC2_Present]      
      ,(Case when ANC2_Pregnancy_Week between 13 and 26 then 1 else 0 end )[ANC2_Within26_Week]      
      ,(Case when Patindex('%A%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_High_BP]--180      
      ,(Case when Patindex('%B%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_Convulsions]      
      ,(Case when Patindex('%C%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_VaginalBleeding]      
      ,(Case when Patindex('%D%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_FoulSmellingDischarge]      
      ,(Case when Patindex('%E%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_SevereAnaemia]      
      ,(Case when Patindex('%F%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_Diabetic]      
      ,(Case when Patindex('%G%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_Twins]      
      ,(Case when Patindex('%Z%',ANC2_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC2_Others]      
      ,(Case when isnull(ANC2_BP_Systolic,0)>0 then 1 else 0 end )[ANC2_BP_Systolic_Present]      
      ,(Case when isnull(ANC2_BP_Systolic,0)>0 then 0 else 1 end )[ANC2_BP_Systolic_Absent]      
      ,(Case when isnull(ANC2_BP_Distolic,0)>0 then 1 else 0 end )[ANC2_BP_Distolic_Present]--190      
      ,(Case when isnull(ANC2_BP_Distolic,0)>0 then 0 else 1 end )[ANC2_BP_Distolic_Absent]      
      ,(Case when isnull(ANC2_Hb_gm,0)>0 then 1 else 0 end )[ANC2_Hb_gm_Present]      
      ,(Case when isnull(ANC2_Hb_gm,0)>0 then 0 else 1 end )[ANC2_Hb_gm_Absent]      
      ,(Case when ANC2_Urine_Test='Done' then 1 else 0 end )[ANC2_Urine_Test_Done]      
      ,(Case when ANC2_Urine_Test='Not Done' then 1 else 0 end )[ANC2_Urine_Test_NotDone]      
      ,(Case when ANC2_Urine_Albumin='Present' then 1 else 0 end )[ANC2_Urine_Albumin_Present]      
      ,(Case when ANC2_Urine_Albumin='Absent' then 1 else 0 end )[ANC2_Urine_Albumin_Absent]      
      ,(Case when ANC2_Urine_Sugar='Present' then 1 else 0 end )[ANC2_Urine_Sugar_Present]      
      ,(Case when ANC2_Urine_Sugar='Absent' then 1 else 0 end )[ANC2_Urine_Sugar_Absent]      
      ,(Case when ANC2_BloodSugar_Test='Done' then 1 else 0 end )[ANC2_BloodSugar_Test_Done]--200      
      ,(Case when ANC2_BloodSugar_Test='Not Done' then 1 else 0 end )[ANC2_BloodSugar_Test_NotDone]      
      ,(Case when isnull(ANC2_Blood_Sugar_Fasting,0)>0 then 1 else 0 end )[ANC2_Blood_Sugar_Fasting_Present]      
      ,(Case when isnull(ANC2_Blood_Sugar_Fasting,0)>0 then 0 else 1 end )[ANC2_Blood_Sugar_Fasting_Absent]      
      ,(Case when isnull(ANC2_Blood_Sugar_Post_Prandial,0)>0 then 1 else 0 end )[ANC2_Blood_Sugar_Post_Prandial_Present]      
      ,(Case when isnull(ANC2_Blood_Sugar_Post_Prandial,0)>0 then 0 else 1 end )[ANC2_Blood_Sugar_Post_Prandial_Absent]      
      ,(Case when isnull(ANC2_FA_Given,0)>0 then 1 else 0 end )[ANC2_FA_Given_Present]      
      ,(Case when isnull(ANC2_FA_Given,0)>0 then 0 else 1 end )[ANC2_FA_Given_Absent]      
      ,(Case when isnull(ANC2_IFA_Given,0)>0 then 1 else 0 end )[ANC2_IFA_Given_Present]      
      ,(Case when isnull(ANC2_IFA_Given,0)>0 then 0 else 1 end )[ANC2_IFA_Given_Absent]      
      ,(Case when isnull(ANC2_Weight,0)>0 then 1 else 0 end )[ANC2_Weight_Present]--210      
      ,(Case when isnull(ANC2_Weight,0)>0 then 0 else 1 end )[ANC2_Weight_Absent]      
      ,(Case when isnull(ANC2_Hb_gm,0) between 1 and 6.9 then 1 else 0 end )[ANC2_Severe_Anemic]      
      ,(Case when isnull(ANC2_Hb_gm,0) between 9.1 and 11 then 1 else 0 end )[ANC2_Mild_Anemic]      
      ,(Case when isnull(ANC2_Hb_gm,0) between 7 and 9 then 1 else 0 end )[ANC2_Moderate_Anemic]      
      ,[ANC3]      
      ,(Case when ANC3 is not null then 1 else 0 end )[ANC3_Present]      
      ,(Case when ANC3_Pregnancy_Week between 34 and 37 then 1 else 0 end )[ANC3_Within34_Week]      
      ,(Case when Patindex('%A%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_High_BP]      
      ,(Case when Patindex('%B%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_Convulsions]      
      ,(Case when Patindex('%C%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_VaginalBleeding]--220      
      ,(Case when Patindex('%D%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_FoulSmellingDischarge]      
      ,(Case when Patindex('%E%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_SevereAnaemia]      
      ,(Case when Patindex('%F%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_Diabetic]      
      ,(Case when Patindex('%G%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_Twins]      
      ,(Case when Patindex('%Z%',ANC3_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC3_Others]      
      ,(Case when isnull(ANC3_BP_Systolic,0)>0 then 1 else 0 end )[ANC3_BP_Systolic_Present]      
      ,(Case when isnull(ANC3_BP_Systolic,0)>0 then 0 else 1 end )[ANC3_BP_Systolic_Absent]      
      ,(Case when isnull(ANC3_BP_Distolic,0)>0 then 1 else 0 end )[ANC3_BP_Distolic_Present]      
      ,(Case when isnull(ANC3_BP_Distolic,0)>0 then 0 else 1 end )[ANC3_BP_Distolic_Absent]      
      ,(Case when isnull(ANC3_Hb_gm,0)>0 then 1 else 0 end )[ANC3_Hb_gm_Present]--230      
      ,(Case when isnull(ANC3_Hb_gm,0)>0 then 0 else 1 end )[ANC3_Hb_gm_Absent]      
      ,(Case when ANC3_Urine_Test='Done' then 1 else 0 end )[ANC3_Urine_Test_Done]      
      ,(Case when ANC3_Urine_Test='Not Done' then 1 else 0 end )[ANC3_Urine_Test_NotDone]      
      ,(Case when ANC3_Urine_Albumin='Present' then 1 else 0 end )[ANC3_Urine_Albumin_Present]      
      ,(Case when ANC3_Urine_Albumin='Absent' then 1 else 0 end )[ANC3_Urine_Albumin_Absent]      
      ,(Case when ANC3_Urine_Sugar='Present' then 1 else 0 end )[ANC3_Urine_Sugar_Present]      
      ,(Case when ANC3_Urine_Sugar='Absent' then 1 else 0 end )[ANC3_Urine_Sugar_Absent]      
      ,(Case when ANC3_BloodSugar_Test='Done' then 1 else 0 end )[ANC3_BloodSugar_Test_Done]      
      ,(Case when ANC3_BloodSugar_Test='Not Done' then 1 else 0 end )[ANC3_BloodSugar_Test_NotDone]      
      ,(Case when isnull(ANC3_Blood_Sugar_Fasting,0)>0 then 1 else 0 end )[ANC3_Blood_Sugar_Fasting_Present]--240      
      ,(Case when isnull(ANC3_Blood_Sugar_Fasting,0)>0 then 0 else 1 end )[ANC3_Blood_Sugar_Fasting_Absent]      
      ,(Case when isnull(ANC3_Blood_Sugar_Post_Prandial,0)>0 then 1 else 0 end )[ANC3_Blood_Sugar_Post_Prandial_Present]      
      ,(Case when isnull(ANC3_Blood_Sugar_Post_Prandial,0)>0 then 0 else 1 end )[ANC3_Blood_Sugar_Post_Prandial_Absent]      
      ,(Case when isnull(ANC3_FA_Given,0)>0 then 1 else 0 end )[ANC3_FA_Given_Present]      
      ,(Case when isnull(ANC3_FA_Given,0)>0 then 0 else 1 end )[ANC3_FA_Given_Absent]      
      ,(Case when isnull(ANC3_IFA_Given,0)>0 then 1 else 0 end )[ANC3_IFA_Given_Present]      
      ,(Case when isnull(ANC3_IFA_Given,0)>0 then 0 else 1 end )[ANC3_IFA_Given_Absent]      
      ,(Case when isnull(ANC3_Weight,0)>0 then 1 else 0 end )[ANC3_Weight_Present]      
      ,(Case when isnull(ANC3_Weight,0)>0 then 0 else 1 end )[ANC3_Weight_Absent]--250      
      ,(Case when isnull(ANC3_Hb_gm,0) between 1 and 6.9 then 1 else 0 end )[ANC3_Severe_Anemic]      
      ,(Case when isnull(ANC3_Hb_gm,0) between 9.1 and 11 then 1 else 0 end )[ANC3_Mild_Anemic]      
      ,(Case when isnull(ANC3_Hb_gm,0) between 7 and 9 then 1 else 0 end )[ANC3_Moderate_Anemic]      
      ,[ANC4]      
      ,(Case when ANC4 is not null then 1 else 0 end )[ANC4_Present]      
      ,ANC4_Pregnancy_Week       
      ,(Case when Patindex('%A%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_High_BP]      
      ,(Case when Patindex('%B%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_Convulsions]      
      ,(Case when Patindex('%C%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_VaginalBleeding]      
      ,(Case when Patindex('%D%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_FoulSmellingDischarge]--260      
      ,(Case when Patindex('%E%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_SevereAnaemia]      
      ,(Case when Patindex('%F%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_Diabetic]      
      ,(Case when Patindex('%G%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_Twins]      
      ,(Case when Patindex('%Z%',ANC4_Symptoms_High_Risk_VAL)<>0 then 1 else 0 end )[ANC4_Others]      
      ,(Case when isnull(ANC4_BP_Systolic,0)>0 then 1 else 0 end )[ANC4_BP_Systolic_Present]      
      ,(Case when isnull(ANC4_BP_Systolic,0)>0 then 0 else 1 end )[ANC4_BP_Systolic_Absent]      
      ,(Case when isnull(ANC4_BP_Distolic,0)>0 then 1 else 0 end )[ANC4_BP_Distolic_Present]      
      ,(Case when isnull(ANC4_BP_Distolic,0)>0 then 0 else 1 end )[ANC4_BP_Distolic_Absent]      
      ,(Case when isnull(ANC4_Hb_gm,0)>0 then 1 else 0 end )[ANC4_Hb_gm_Present]      
      ,(Case when isnull(ANC4_Hb_gm,0)>0 then 0 else 1 end )[ANC4_Hb_gm_Absent]--270      
      ,(Case when ANC4_Urine_Test='Done' then 1 else 0 end )[ANC4_Urine_Test_Done]      
      ,(Case when ANC4_Urine_Test='Not Done' then 1 else 0 end )[ANC4_Urine_Test_NotDone]      
      ,(Case when ANC4_Urine_Albumin='Present' then 1 else 0 end )[ANC4_Urine_Albumin_Present]      
      ,(Case when ANC4_Urine_Albumin='Absent' then 1 else 0 end )[ANC4_Urine_Albumin_Absent]      
      ,(Case when ANC4_Urine_Sugar='Present' then 1 else 0 end )[ANC4_Urine_Sugar_Present]      
      ,(Case when ANC4_Urine_Sugar='Absent' then 1 else 0 end )[ANC4_Urine_Sugar_Absent]      
      ,(Case when ANC4_BloodSugar_Test='Done' then 1 else 0 end )[ANC4_BloodSugar_Test_Done]      
      ,(Case when ANC4_BloodSugar_Test='Not Done' then 1 else 0 end )[ANC4_BloodSugar_Test_NotDone]      
      ,(Case when isnull(ANC4_Blood_Sugar_Fasting,0)>0 then 1 else 0 end )[ANC4_Blood_Sugar_Fasting_Present]      
      ,(Case when isnull(ANC4_Blood_Sugar_Fasting,0)>0 then 0 else 1 end )[ANC4_Blood_Sugar_Fasting_Absent]--280      
      ,(Case when isnull(ANC4_Blood_Sugar_Post_Prandial,0)>0 then 1 else 0 end )[ANC4_Blood_Sugar_Post_Prandial_Present]      
      ,(Case when isnull(ANC4_Blood_Sugar_Post_Prandial,0)>0 then 0 else 1 end )[ANC4_Blood_Sugar_Post_Prandial_Absent]      
      ,(Case when isnull(ANC4_FA_Given,0)>0 then 1 else 0 end )[ANC4_FA_Given_Present]      
      ,(Case when isnull(ANC4_FA_Given,0)>0 then 0 else 1 end )[ANC4_FA_Given_Absent]      
      ,(Case when isnull(ANC4_IFA_Given,0)>0 then 1 else 0 end )[ANC4_IFA_Given_Present]      
      ,(Case when isnull(ANC4_IFA_Given,0)>0 then 0 else 1 end )[ANC4_IFA_Given_Absent]      
      ,(Case when isnull(ANC4_Weight,0)>0 then 1 else 0 end )[ANC4_Weight_Present]      
      ,(Case when isnull(ANC4_Weight,0)>0 then 0 else 1 end )[ANC4_Weight_Absent]      
      ,(Case when isnull(ANC4_Hb_gm,0) between 1 and 6.9 then 1 else 0 end )[ANC4_Severe_Anemic]      
      ,(Case when isnull(ANC4_Hb_gm,0) between 9.1 and 11 then 1 else 0 end )[ANC4_Mild_Anemic]--290      
      ,(Case when isnull(ANC4_Hb_gm,0) between 7 and 9 then 1 else 0 end )[ANC4_Moderate_Anemic]      
      ,(Case when TT1 is not null then 1 else 0 end )[TT1_Present]      
      ,(Case when TT2 is not null then 1 else 0 end )[TT2_Present]      
      ,(Case when TTB is not null then 1 else 0 end )[TTB_Present]      
      ,(Case when Delivery_date is not null then 1 else 0 end )[Delivery_date_Present]      
      ,(Case when Datediff(week,Medical_LMP_Date,Delivery_date)<37 then 1 else 0 end )[Delivery_date_PretermLT37Week]      
      ,(Case when Delivery_Place_Val=1 then 1 else 0 end )[Delivery_Place_PHC]      
      ,(Case when Delivery_Place_Val=2 then 1 else 0 end )[Delivery_Place_CHC]      
      ,(Case when Delivery_Place_Val=5 then 1 else 0 end )[Delivery_Place_DH]      
      ,(Case when Delivery_Place_Val=19 or Delivery_Place_Val=26 then 1 else 0 end )[Delivery_Place_OPF]--300      
      ,(Case when Delivery_Place_Val=20 or Delivery_Place_Val=27 then 1 else 0 end )[Delivery_Place_APH]      
      ,(Case when Delivery_Place_Val=21 then 1 else 0 end )[Delivery_Place_OPH]      
      ,(Case when Delivery_Place_Val=22 then 1 else 0 end )[Delivery_Place_Home]      
      ,(Case when Delivery_Place_Val=4 then 1 else 0 end )[Delivery_Place_SDH]      
      ,(Case when Delivery_Place_Val=17 then 1 else 0 end )[Delivery_Place_MCH]      
      ,(Case when Delivery_Place_Val=23 then 1 else 0 end )[Delivery_Place_Intransit]      
      ,(Case when Delivery_Place_Val=24 then 1 else 0 end )[Delivery_Place_SC]      
      ,(Case when Delivery_Place_Val=3 then 1 else 0 end )[Delivery_Place_UHC] 
      ,(Case when Delivery_Place_Val=7 then 1 else 0 end )[Delivery_Place_RH] 
      ,(Case when Delivery_Place_Val=28 then 1 else 0 end )[Delivery_Place_ODH] 
      ,(Case when Delivery_Place_Val=29 then 1 else 0 end )[Delivery_Place_OMCH]
	  ,(Case when Delivery_Place_Val=99 then 1 else 0 end )[Delivery_Place_Others] 
      ,(Case when Patindex('%A%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_PPH]      
      ,(Case when Patindex('%B%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_RetainedPlacenta]      
      ,(Case when Patindex('%C%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_ObstructedDelivery]--310      
      ,(Case when Patindex('%D%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_ProlapsedCord]      
      ,(Case when Patindex('%E%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_TwinsPregnancy]      
      ,(Case when Patindex('%F%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_Convulsions]      
      ,(Case when Patindex('%G%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_Death]      
      ,(Case when Patindex('%H%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_Other]      
      ,(Case when Patindex('%I%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_DontKnow]      
      ,(Case when Patindex('%J%',Delivery_Complication_VAl)<>0 then 1 else 0 end )[Delivery_Complication_None]      
      ,(Case when Delivery_DeathCause_VAL=1 then 1 else 0 end )[DeliveryDeath_Reason_Eclampcia]       
      ,(Case when Delivery_DeathCause_VAL=2 then 1 else 0 end )[DeliveryDeath_Reason_Haemorrahge]       
      ,(Case when Delivery_DeathCause_VAL=3 then 1 else 0 end )[DeliveryDeath_Reason_ObstructedLabour] --320      
      ,(Case when Delivery_DeathCause_VAL=4 then 1 else 0 end )[DeliveryDeath_Reason_ProlongedLabour]      
      ,(Case when Delivery_DeathCause_VAL=5 then 1 else 0 end )[DeliveryDeath_Reason_HighFever]       
      ,(Case when Delivery_DeathCause_VAL=99 then 1 else 0 end )[DeliveryDeath_Reason_Other]       
      ,(Case when Delivery_Type='Normal' then 1 else 0 end )[Delivery_Type_Normal]      
      ,(Case when Delivery_Type='Cesarian' then 1 else 0 end )[Delivery_Type_Cesarian]      
      ,(Case when Delivery_Type='Assissted' then 1 else 0 end )[Delivery_Type_Assissted]      
      ,(Case when Delivery_Conducted_By='ANM' then 1 else 0 end )[Delivery_Conducted_By_ANM]      
      ,(Case when Delivery_Conducted_By='LHV' then 1 else 0 end )[Delivery_Conducted_By_LHV]      
      ,(Case when Delivery_Conducted_By='Doctor' then 1 else 0 end )[Delivery_Conducted_By_Doctor]      
      ,(Case when Delivery_Conducted_By='Staff Nurse' then 1 else 0 end )[Delivery_Conducted_By_StaffNurse]--330      
      ,(Case when Delivery_Conducted_By='Relative' then 1 else 0 end )[Delivery_Conducted_By_Relative]      
      ,(Case when Delivery_Conducted_By='Other' then 1 else 0 end )[Delivery_Conducted_By_Other]      
      ,(Case when Delivery_Conducted_By='SBA' then 1 else 0 end )[Delivery_Conducted_By_SBA]      
      ,(Case when Delivery_Conducted_By='NON SBA' then 1 else 0 end )[Delivery_Conducted_By_NONSBA]      
      ,isnull(Live_birth,0) as [Delivery_Live_Birth]      
      ,isnull(Still_birth,0) as [Delivery_Still_Birth]      
      ,isnull(Delivery_Outcomes,0) [Delivery_Total_Birth]      
      ,(Case when Datediff(Day,Delivery_date,Discharge_Date)<=2 then 1 else 0 end )[Discharge_within48hr]      
      ,(Case when Datediff(Day,Delivery_date,Discharge_Date)between 3 and 5 then 1 else 0 end )[Discharge_within2to5Day]      
      ,(Case when Datediff(Day,Delivery_date,Discharge_Date)>5 then 1 else 0 end )[Discharge_within_Aftr_5Day]--340      
      ,(Case when Mother_Death_Date is not null then 1 else 0 end)[PNC_Death]      
      ,(Case When PNC1_Date is not null then 1 else 0 end)[PNC1_Type_Present]      
      ,(Case When PNC1_Date is not null then 0 else 1 end)[PNC1_Type_Absent]      
      ,(Case When isnull(PNC1_IFA_Tab,0)>0  then 1 else 0 end)[PNC1_IFA_Tab_Present]      
      ,(Case when PNC1_DangerSign_Mother_VAL is not null and Patindex('Y',PNC1_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC1_DangerSign_Present]      
      ,(Case When PNC2_Date is not null then 1 else 0 end)[PNC2_Type_Present]      
      ,(Case When PNC2_Date is not null then 0 else 1 end)[PNC2_Type_Absent]      
      ,(Case When isnull(PNC2_IFA_Tab,0)>0  then 1 else 0 end)[PNC2_IFA_Tab_Present]      
      ,(Case when PNC2_DangerSign_Mother_VAL is not null and Patindex('Y',PNC2_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC2_DangerSign_Present]      
      ,(Case When PNC3_Date is not null then 1 else 0 end)[PNC3_Type_Present]--350      
      ,(Case When PNC3_Date is not null then 0 else 1 end)[PNC3_Type_Absent]      
      ,(Case When isnull(PNC3_IFA_Tab,0)>0  then 1 else 0 end)[PNC3_IFA_Tab_Present]      
      ,(Case when PNC3_DangerSign_Mother_VAL is not null and Patindex('Y',PNC3_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC3_DangerSign_Present]      
      ,(Case When PNC4_Date is not null then 1 else 0 end)[PNC4_Type_Present]      
      ,(Case When PNC4_Date is not null then 0 else 1 end)[PNC4_Type_Absent]      
      ,(Case When isnull(PNC4_IFA_Tab,0)>0  then 1 else 0 end)[PNC4_IFA_Tab_Present]      
      ,(Case when PNC4_DangerSign_Mother_VAL is not null and Patindex('Y',PNC4_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC4_DangerSign_Present]      
      ,(Case When PNC5_Date is not null then 1 else 0 end)[PNC5_Type_Present]      
      ,(Case When PNC5_Date is not null then 0 else 1 end)[PNC5_Type_Absent]      
      ,(Case When isnull(PNC5_IFA_Tab,0)>0  then 1 else 0 end)[PNC5_IFA_Tab_Present]--360      
      ,(Case when PNC5_DangerSign_Mother_VAL is not null and Patindex('Y',PNC5_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC5_DangerSign_Present]      
      ,(Case When PNC6_Date is not null then 1 else 0 end)[PNC6_Type_Present]      
      ,(Case When PNC6_Date is not null then 0 else 1 end)[PNC6_Type_Absent]      
      ,(Case When isnull(PNC6_IFA_Tab,0)>0  then 1 else 0 end)[PNC6_IFA_Tab_Present]      
      ,(Case when PNC6_DangerSign_Mother_VAL is not null and Patindex('Y',PNC6_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC6_DangerSign_Present]      
      ,(Case When PNC7_Date is not null then 1 else 0 end)[PNC7_Type_Present]      
      ,(Case When PNC7_Date is not null then 0 else 1 end)[PNC7_Type_Absent]      
      ,(Case When isnull(PNC7_IFA_Tab,0)>0  then 1 else 0 end)[PNC7_IFA_Tab_Present]      
      ,(Case when PNC7_DangerSign_Mother_VAL is not null and Patindex('Y',PNC7_DangerSign_Mother_VAL)=0  then 1 else 0 end )[PNC7_DangerSign_Present]      
      ,(Case when Datediff(day,Delivery_date,PNC3_Date)=7 then 1 else 0 end )[PNC_PNC3_7th_Day_of_del]--370      
      ,(Case when Datediff(day,Delivery_date,PNC4_Date)=14 then 1 else 0 end )[PNC_PNC4_14th_Day_of_del]      
      ,(Case when Datediff(day,Delivery_date,PNC5_Date)=21 then 1 else 0 end )[PNC_PNC5_21th_Day_of_del]      
      ,(Case when Datediff(day,Delivery_date,PNC6_Date)=28 then 1 else 0 end )[PNC_PNC6_28th_Day_of_del]      
      ,(Case when Datediff(day,Delivery_date,PNC7_Date)=42 then 1 else 0 end )[PNC_PNC7_42th_Day_of_del]      
      ,MONTH([Medical_LMP_Date]) as LMP_Month      
      ,Year([Medical_LMP_Date]) as LMP_Year      
      ,(Case when (isnull(ANC1_IFA_Given,0)+isnull(ANC2_IFA_Given,0)+isnull(ANC3_IFA_Given,0)+isnull(ANC4_IFA_Given,0))>=180 then 1 else 0 end) as IFA_Given      
            
      ,(case when Mother_SourceID=0 then 1 else 0 end ) [Mother_P]      
   ,(case when Mother_SourceID=3 then 1 else 0 end ) [Mother_T]      
      ,(case when Mother_SourceID=1 then 1 else 0 end ) [Mother_U]      
            
      ,(case when Med_Source_ID=0 then 1 else 0 end ) [LMP_P]      
      ,(case when Med_Source_ID=3 then 1 else 0 end ) [LMP_T]      
      ,(case when Med_Source_ID=1 then 1 else 0 end ) [LMP_U]      
        
   ,(case when ANC1_SourceID=0 then 1 else 0 end ) [ANC1_P]      
   ,(case when ANC1_SourceID=3 then 1 else 0 end ) [ANC1_T]      
   ,(case when ANC1_SourceID=1 then 1 else 0 end ) [ANC1_U]      
         
   ,(case when ANC2_SourceID=0 then 1 else 0 end ) [ANC2_P]      
   ,(case when ANC2_SourceID=3 then 1 else 0 end ) [ANC2_T]      
   ,(case when ANC2_SourceID=1 then 1 else 0 end ) [ANC2_U]      
         
   ,(case when ANC3_SourceID=0 then 1 else 0 end ) [ANC3_P]      
  ,(case when ANC3_SourceID=3 then 1 else 0 end ) [ANC3_T]      
   ,(case when ANC3_SourceID=1 then 1 else 0 end )[ANC3_U]       
         
   ,(case when ANC4_SourceID=0 then 1 else 0 end ) [ANC4_P]      
   ,(case when ANC4_SourceID=3 then 1 else 0 end ) [ANC4_T]      
   ,(case when ANC4_SourceID=1 then 1 else 0 end ) [ANC4_U]      
         
   ,(case when PNC1_Source_ID=0 then 1 else 0 end )[PNC1_P]      
   ,(case when PNC1_Source_ID=3 then 1 else 0 end ) [PNC1_T]      
   ,(case when PNC1_Source_ID=1 then 1 else 0 end ) [PNC1_U]      
         
         
   ,(case when PNC2_Source_ID=0 then 1 else 0 end ) [PNC2_P]      
   ,(case when PNC2_Source_ID=3 then 1 else 0 end ) [PNC2_T]      
   ,(case when PNC2_Source_ID=1 then 1 else 0 end ) [PNC2_U]      
         
   ,(case when PNC3_Source_ID=0 then 1 else 0 end ) [PNC3_P]      
   ,(case when PNC3_Source_ID=3 then 1 else 0 end ) [PNC3_T]      
   ,(case when PNC3_Source_ID=1 then 1 else 0 end ) [PNC3_U]      
         
   ,(case when PNC4_Source_ID=0 then 1 else 0 end ) [PNC4_P]      
   ,(case when PNC4_Source_ID=3 then 1 else 0 end ) [PNC4_T]      
   ,(case when PNC4_Source_ID=1 then 1 else 0 end ) [PNC4_U]      
         
   ,(case when PNC5_Source_ID=0 then 1 else 0 end ) [PNC5_P]      
   ,(case when PNC5_Source_ID=3 then 1 else 0 end ) [PNC5_T]      
   ,(case when PNC5_Source_ID=1 then 1 else 0 end ) [PNC5_U]      
         
   ,(case when PNC6_Source_ID=0 then 1 else 0 end ) [PNC6_P]      
   ,(case when PNC6_Source_ID=3 then 1 else 0 end ) [PNC6_T]      
   ,(case when PNC6_Source_ID=1 then 1 else 0 end ) [PNC6_U]      
         
   ,(case when PNC7_Source_ID=0 then 1 else 0 end ) [PNC7_P]      
   ,(case when PNC7_Source_ID=3 then 1 else 0 end ) [PNC7_T]      
,(case when PNC7_Source_ID=1 then 1 else 0 end ) [PNC7_U]      
   ,(case when Live_Birth>=1 then 1 else 0 end) Infant1_Live    
   ,(case when Live_Birth>=2 then 1 else 0 end) Infant2_Live    
   ,(case when Live_Birth>=3 then 1 else 0 end) Infant3_Live    
   ,(case when Live_Birth>=4 then 1 else 0 end) Infant4_Live    
   ,(case when Live_Birth>=5 then 1 else 0 end) Infant5_Live    
   ,(case when Live_Birth>=6 then 1 else 0 end) Infant6_Live    
   ,(case when Infant1_Breast_Feeding=1 then 1 else 0 end) Infant1_Breastfeed    
   ,(case when Infant2_Breast_Feeding=1 then 1 else 0 end) Infant2_Breastfeed    
   ,(case when Infant3_Breast_Feeding=1 then 1 else 0 end) Infant3_Breastfeed    
   ,(case when Infant4_Breast_Feeding=1 then 1 else 0 end) Infant4_Breastfeed    
   ,(case when Infant5_Breast_Feeding=1 then 1 else 0 end) Infant5_Breastfeed    
   ,(case when Infant6_Breast_Feeding=1 then 1 else 0 end) Infant6_Breastfeed    
   ,(case when Infant1_Death_val=1 then 1 else 0 end) Infant1_Death    
   ,(case when Infant2_Death_val=1 then 1 else 0 end) Infant2_Death    
   ,(case when Infant3_Death_val=1 then 1 else 0 end) Infant3_Death    
   ,(case when Infant4_Death_val=1 then 1 else 0 end) Infant4_Death    
   ,(case when Infant5_Death_val=1 then 1 else 0 end) Infant5_Death    
   ,(case when Infant6_Death_val=1 then 1 else 0 end) Infant6_Death    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant1_Male    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant2_Male    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant3_Male    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant4_Male    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant5_Male    
   ,(case when Infant1_Gender='M' then 1 else 0 end) Infant6_Male    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant1_FeMale    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant2_FeMale    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant3_FeMale    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant4_FeMale    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant5_FeMale    
   ,(case when Infant1_Gender='F' then 1 else 0 end) Infant6_FeMale    
   ,(Case when Delivery_date Is not null and DATEADD(day,42,Delivery_date)<getdate() then 1 else 0 end)     
       
 ,(Case when ISNULL(PW_AadhaarLinked,'0')='0' then 0  else 1 end )      
    ,(Case when ISNULL(PW_AadhaarLinked,'0')='0' then 1  else 0 end )      
    ,(Case when ISNULL(Hus_AadhaarLinked,'0')='0' then 0  else 1 end )      
    ,(Case when ISNULL(Hus_AadhaarLinked,'0')='0' then 1  else 0 end )      
    ,(Case when ISNULL(PW_Account_No,'0')='0' then 0 when PW_Account_No='' then 0 else 1  end )      
    ,(Case when ISNULL(PW_Account_No,'0')='0' then 1 when PW_Account_No='' then 1 else 0  end )     
    ,(Case when ISNULL(Hus_Account_No,'0')='0' then 0 when Hus_Account_No='' then 0 else 1  end )      
    ,(Case when ISNULL(Hus_Account_No,'0')='0' then 1 when Hus_Account_No='' then 1 else 0  end )     
        
    ,Mother_Yr    
    ,dateadd(day,30,Medical_LMP_Date)  as LMP_minanc1    
    ,dateadd(day,90,Medical_LMP_Date) as LMP_maxanc1    
      ,dateadd(day,91,Medical_LMP_Date)  as LMP_minanc2    
      ,dateadd(day,188,Medical_LMP_Date)  as LMP_maxanc2    
      , dateadd(day,189,Medical_LMP_Date)  asLMP_minanc3    
      ,dateadd(day,244,Medical_LMP_Date)  as LMP_maxanc3     
      ,dateadd(day,245,Medical_LMP_Date) as LMP_minanc4     
      ,dateadd(month,7,Medical_LMP_Date)  as LMP_7m    
      ,dateadd(day,84,Medical_LMP_Date)  as  LMP_84d     
      ,month(Medical_EDD_Date) as EDD_month    
      ,Year(Medical_EDD_Date) as EDD_Yr    
      ,(case when month(Medical_EDD_Date)>3 then year(Medical_EDD_Date) else year(Medical_EDD_Date)-1 end) as EDD_FinYr    
      ,Medical_Yr as LMP_FinYr    
      ,dateadd(day,1,Delivery_date)  as Del_minpnc1    
      ,dateadd(day,3,Delivery_date)  as Del_minpnc2     
      ,dateadd(day,7,Delivery_date)  as Del_minpnc3    
      ,dateadd(day,14,Delivery_date)  as Del_minpnc4    
      ,dateadd(day,21,Delivery_date)  as Del_minpnc5    
      ,dateadd(day,28,Delivery_date)  as Del_minpnc6    
      ,dateadd(day,42,Delivery_date) asDel_minpnc7    
      ,dateadd(day,45,Delivery_date) as Del_45d     
      ,month(Delivery_date) as Del_month    
      ,year(Delivery_date) as Del_Yr    
      ,(case when month(Delivery_date)>3 then year(Delivery_date) else year(Delivery_date)-1 end) as Del_FinYr    
      ,dateadd(month,1,TT1) as TT1_30d    
      ,(case when Delivery_SourceID=0 then 1 else 0 end ) [Delivery_P]      
   ,(case when Delivery_SourceID=3 then 1 else 0 end ) [Delivery_T]      
      ,(case when Delivery_SourceID=1 then 1 else 0 end ) [Delivery_U]      
         
      ,(Case when ANC1_visit is null then 0 else 1 end)    
   ,(Case when ANC2_visit is null then 0 else 1 end)    
   ,(Case when ANC3_visit is null then 0 else 1 end)    
   ,(Case when ANC4_visit is null then 0 else 1 end)    
   ,(Case when ANC5_visit is null then 0 else 1 end)    
   ,(Case when ANC6_visit is null then 0 else 1 end)    
   ,(Case when ANC7_visit is null then 0 else 1 end)    
   ,(Case when ANC8_visit is null then 0 else 1 end)    
   ,(Case when ANC9_visit is null then 0 else 1 end)    
   ,(Case when ANC10_visit is null then 0 else 1 end)    
   ,(Case when ANC11_visit is null then 0 else 1 end)    
   ,(Case when ANC12_visit is null then 0 else 1 end)    
   ,(Case when ANC13_visit is null then 0 else 1 end)    
  ,(Case when ANC1_visit is null then 1 else 0 end)    
  ,(Case when ANC2_visit is null then 1 else 0 end)    
  ,(Case when ANC3_visit is null then 1 else 0 end)    
  ,(Case when ANC4_visit is null then 1 else 0 end)    
  ,(Case when ANC5_visit is null then 1 else 0 end)    
  ,(Case when ANC6_visit is null then 1 else 0 end)    
  ,(Case when ANC7_visit is null then 1 else 0 end)    
  ,(Case when ANC8_visit is null then 1 else 0 end)    
  ,(Case when ANC9_visit is null then 1 else 0 end)    
  ,(Case when ANC10_visit is null then 1 else 0 end)    
  ,(Case when ANC11_visit is null then 1 else 0 end)    
  ,(Case when ANC12_visit is null then 1 else 0 end)    
  ,(Case when ANC13_visit is null then 1 else 0 end)--510    
  ,(case Validated_Callcentre when 1 then 1 else 0 end)    
  ,Delivery_date    
  ,(case when Call_Ans=1 then 1 else 0 end)    
  ,(case when Call_Ans=0 then 1 else 0 end)    
  ,(case when No_call_reaon_val=1 then 1 else 0 end)    
  ,(case when No_call_reaon_val=2 then 1 else 0 end)    
  ,(case when No_call_reaon_val=3 then 1 else 0 end)    
  ,(case when No_call_reaon_val=4 then 1 else 0 end)    
  ,(case when No_call_reaon_val=5 then 1 else 0 end)    
  ,(case when No_call_reaon_val=6 then 1 else 0 end)--520    
  ,(case when No_call_reaon_val=7 then 1 else 0 end)    
  ,(case when Is_Phone_Correct=1 then 1 else 0 end)    
  ,(case when Is_Phone_Correct=0 then 1 else 0 end)    
  ,(case when No_phone_reason_Val=1 then 1 else 0 end)    
  ,(case when No_phone_reason_Val=2 then 1 else 0 end)    
        ,(case when No_phone_reason_Val=3 then 1 else 0 end)    
        ,(case when No_phone_reason_Val=4 then 1 else 0 end)    
        ,(case when No_phone_reason_Val=5 then 1 else 0 end)    
        ,(case when No_phone_reason_Val=11 then 1 else 0 end)    
        ,(case when No_phone_reason_Val=12 then 1 else 0 end)--530    
        ,(case when No_phone_reason_Val=13 then 1 else 0 end)    
        ,Is_Confirmed    
        ,getdate() [Exec_Date],distinct_ec,mcts_full_anc,mcts_ifa      
        ,(Case when datediff(d,dateadd(year,19,Mother_BirthDate),Medical_LMP_Date)<=0 then 1 else 0 end)Is_Teen_Age   
        --------------------covid  
,ANC1_Is_ILI_Symptom ,ANC1_Is_contact_Covid ,ANC1_Covid_test_done ,ANC1_Covid_test_result ,  
ANC2_Is_ILI_Symptom ,ANC2_Is_contact_Covid ,ANC2_Covid_test_done ,ANC2_Covid_test_result ,  
ANC3_Is_ILI_Symptom ,ANC3_Is_contact_Covid ,ANC3_Covid_test_done ,ANC3_Covid_test_result ,  
ANC4_Is_ILI_Symptom ,ANC4_Is_contact_Covid ,ANC4_Covid_test_done ,ANC4_Covid_test_result ,  
ANC99_Is_ILI_Symptom ,ANC99_Is_contact_Covid ,ANC99_Covid_test_done ,ANC99_Covid_test_result ,  
 del_Is_ILI_Symptom ,del_Is_contact_Covid ,del_Covid_test_done ,del_Covid_test_result ,  
 PNC1_Is_ILI_Symptom ,PNC1_Is_contact_Covid ,PNC1_Covid_test_done ,PNC1_Covid_test_result ,  
PNC2_Is_ILI_Symptom ,PNC2_Is_contact_Covid ,PNC2_Covid_test_done ,PNC2_Covid_test_result ,  
PNC3_Is_ILI_Symptom ,PNC3_Is_contact_Covid ,PNC3_Covid_test_done ,PNC3_Covid_test_result ,  
PNC4_Is_ILI_Symptom ,PNC4_Is_contact_Covid ,PNC4_Covid_test_done ,PNC4_Covid_test_result ,  
PNC5_Is_ILI_Symptom ,PNC5_Is_contact_Covid ,PNC5_Covid_test_done ,PNC5_Covid_test_result ,  
PNC6_Is_ILI_Symptom ,PNC6_Is_contact_Covid ,PNC6_Covid_test_done ,PNC6_Covid_test_result ,  
PNC7_Is_ILI_Symptom ,PNC7_Is_contact_Covid ,PNC7_Covid_test_done ,PNC7_Covid_test_result
,isnull(is_verified,0) as is_verified,
------------------------  
Case When isnull(Mother_HealthIdNumber,0)='0'  then 0 when Mother_HealthIdNumber='' then 0 else 1 end,
Case When isnull(Mother_HealthId,0)='0' then 0  when Mother_HealthId='' then 0 else 1 end,isnull(cc_total,0)cc_total,isnull(cc_sent,0)cc_sent
,PW_Death_date
,HBSAG_Test
,(case when HBSAG_Date is not null then 1 else 0 end) HBSAG_Date
,HBSAG_Result
,(case when Infant1_HBIG_Date is not null then 1 else 0 end) Infant1_HBIG_Date
,(case when Infant2_HBIG_Date is not null then 1 else 0 end) Infant2_HBIG_Date
,(case when Infant3_HBIG_Date is not null then 1 else 0 end) Infant3_HBIG_Date
,(case when Infant4_HBIG_Date is not null then 1 else 0 end) Infant4_HBIG_Date
,(case when Infant5_HBIG_Date is not null then 1 else 0 end) Infant5_HBIG_Date
,(case when Infant6_HBIG_Date is not null then 1 else 0 end) Infant6_HBIG_Date
----------------
,(Case When PNC1_PPC_VAL='A' then 1  else 0 end)PNC1_PPIUCD
,(Case When PNC2_PPC_VAL='A' then 1  else 0 end)PNC2_PPIUCD
,(Case When PNC3_PPC_VAL='A' then 1  else 0 end)PNC3_PPIUCD
,(Case When PNC4_PPC_VAL='A' then 1  else 0 end)PNC4_PPIUCD
,(Case When PNC5_PPC_VAL='A' then 1  else 0 end)PNC5_PPIUCD
,(Case When PNC6_PPC_VAL='A' then 1  else 0 end)PNC6_PPIUCD
,(Case When PNC7_PPC_VAL='A' then 1  else 0 end)PNC7_PPIUCD
,(Case When PNC1_PPC_VAL='D' then 1  else 0 end)PNC1_PPS
,(Case When PNC2_PPC_VAL='D' then 1  else 0 end)PNC2_PPS
,(Case When PNC3_PPC_VAL='D' then 1  else 0 end)PNC3_PPS
,(Case When PNC4_PPC_VAL='D' then 1  else 0 end)PNC4_PPS
,(Case When PNC5_PPC_VAL='D' then 1  else 0 end)PNC5_PPS
,(Case When PNC6_PPC_VAL='D' then 1  else 0 end)PNC6_PPS
,(Case When PNC7_PPC_VAL='D' then 1  else 0 end)PNC7_PPS 
,(Case When PNC1_PPC_VAL='C' then 1  else 0 end)PNC1_Male_Str
,(Case When PNC2_PPC_VAL='C' then 1  else 0 end)PNC2_Male_Str
,(Case When PNC3_PPC_VAL='C' then 1  else 0 end)PNC3_Male_Str
,(Case When PNC4_PPC_VAL='C' then 1  else 0 end)PNC4_Male_Str
,(Case When PNC5_PPC_VAL='C' then 1  else 0 end)PNC5_Male_Str
,(Case When PNC6_PPC_VAL='C' then 1  else 0 end)PNC6_Male_Str
,(Case When PNC7_PPC_VAL='C' then 1  else 0 end)PNC7_Male_Str 
,(Case When PNC1_PPC_VAL='B' then 1  else 0 end)PNC1_Condom
,(Case When PNC2_PPC_VAL='B' then 1  else 0 end)PNC2_Condom
,(Case When PNC3_PPC_VAL='B' then 1  else 0 end)PNC3_Condom
,(Case When PNC4_PPC_VAL='B' then 1  else 0 end)PNC4_Condom
,(Case When PNC5_PPC_VAL='B' then 1  else 0 end)PNC5_Condom
,(Case When PNC6_PPC_VAL='B' then 1  else 0 end)PNC6_Condom
,(Case When PNC7_PPC_VAL='B' then 1  else 0 end)PNC7_Condom 
,(Case When PNC1_PPC_VAL='F' then 1  else 0 end)PNC1_Other_PPC 
,(Case When PNC2_PPC_VAL='F' then 1  else 0 end)PNC2_Other_PPC   
,(Case When PNC3_PPC_VAL='F' then 1  else 0 end)PNC3_Other_PPC 
,(Case When PNC4_PPC_VAL='F' then 1  else 0 end)PNC4_Other_PPC   
,(Case When PNC5_PPC_VAL='F' then 1  else 0 end)PNC5_Other_PPC   
,(Case When PNC6_PPC_VAL='F' then 1  else 0 end)PNC6_Other_PPC 
,(Case When PNC7_PPC_VAL='F' then 1  else 0 end)PNC7_Other_PPC 
,IS_PVTG 
 FROM [t_mother_flat]       
  where Convert(date,Exec_Date)=CONVERT(date,getDate())      and isnull(delete_mother,0)=0 ---delete will not go up    
        
---------------removal of delete record from count and above reports  
;with tc as(  
select registration_no,case_no,exec_date,delete_mother,t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID,  
row_number() OVER ( partition by t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID order by t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID) aa from (  
select t.m_StateID StateID, t.m_PHC_ID PHC_ID, t.m_SubCentre_ID SubCentre_ID, t.m_Village_ID Village_ID,COUNT(1) cnt from t_mother_flat t(nolock) where   
delete_mother=1 and Convert(date,Exec_Date)=CONVERT(date,getDate())  group by m_StateID,m_PHC_ID,m_SubCentre_ID,m_Village_ID ) a   
inner join   
(select StateID,PHC_ID,SubCentre_ID,Village_ID from t_mother_flat_count (nolock) where isnull(delete_mother,0)=0 group by StateID,PHC_ID,SubCentre_ID,Village_ID ) b   
on a.StateID=b.StateID and a.PHC_ID=b.PHC_ID and a.SubCentre_ID=b.SubCentre_ID and a.Village_ID=b.Village_ID  
inner join t_mother_flat_count  (nolock) t on t.StateID=b.StateID and t.PHC_ID=b.PHC_ID and t.SubCentre_ID=b.SubCentre_ID and t.Village_ID=b.Village_ID  
where  isnull(delete_mother,0)=0  
)  
--select StateID,PHC_ID,SubCentre_ID,Village_ID into #t from t_mother_flat_count (nolock) where isnull(delete_mother,0)=0 group by StateID,PHC_ID,SubCentre_ID,Village_ID
--;with tc as(  
--select registration_no,case_no,exec_date,delete_mother,t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID,  
--row_number() OVER ( partition by t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID order by t.StateID, t.PHC_ID, t.SubCentre_ID, t.Village_ID) aa from (  
--select t.m_StateID StateID, t.m_PHC_ID PHC_ID, t.m_SubCentre_ID SubCentre_ID, t.m_Village_ID Village_ID,COUNT(1) cnt from t_mother_flat t(nolock) where   
--delete_mother=1 and Convert(date,Exec_Date)=CONVERT(date,getDate())  group by m_StateID,m_PHC_ID,m_SubCentre_ID,m_Village_ID ) a   
--inner join   
--(select StateID,PHC_ID,SubCentre_ID,Village_ID from #t) b   
--on a.StateID=b.StateID and a.PHC_ID=b.PHC_ID and a.SubCentre_ID=b.SubCentre_ID and a.Village_ID=b.Village_ID  
--inner join t_mother_flat_count  (nolock) t on t.StateID=b.StateID and t.PHC_ID=b.PHC_ID and t.SubCentre_ID=b.SubCentre_ID and t.Village_ID=b.Village_ID  
--where  isnull(delete_mother,0)=0  
--) 

--select * from tc where aa=1 order by PHC_ID,SubCentre_ID,Village_ID  
update t set exec_date=getdate()  from t_mother_flat_count t (nolock) inner join tc on t.Registration_no=tc.Registration_no and   
t.Case_no=tc.Case_no  where aa=1   
  
--drop table #t 
  
delete c from  t_mother_flat f(nolock)  inner join  t_mother_flat_count c(nolock) on f.Registration_no=c.Registration_no and   
f.Case_no=c.Case_no  where f.delete_mother=1 and Convert(date,f.Exec_Date)=CONVERT(date,getDate())  
  
----------------------------------------------------------------------  
        
    update [t_mother_flat_Count] set High_risk_Severe=(case when (ANC1_Severe_Anemic=1 or ANC1_Convulsions=1 or ANC1_Diabetic=1 or ANC1_FoulSmellingDischarge=1 or ANC1_High_BP=1 or ANC1_SevereAnaemia=1 or ANC1_Twins=1 or ANC1_VaginalBleeding=1 or ANC1_Others=1    
                or ANC2_Severe_Anemic=1 or ANC2_Convulsions=1 or ANC2_Diabetic=1 or ANC2_FoulSmellingDischarge=1 or ANC2_High_BP=1 or ANC2_SevereAnaemia=1 or ANC2_Twins=1 or ANC2_VaginalBleeding=1 or ANC2_Others=1    
    or ANC3_Severe_Anemic=1 or ANC3_Convulsions=1 or ANC3_Diabetic=1 or ANC3_FoulSmellingDischarge=1 or ANC3_High_BP=1 or ANC3_SevereAnaemia=1 or ANC3_Twins=1 or ANC3_VaginalBleeding=1 or ANC3_Others=1    
    or ANC4_Severe_Anemic=1 or ANC4_Convulsions=1 or ANC4_Diabetic=1 or ANC4_FoulSmellingDischarge=1 or ANC4_High_BP=1 or ANC4_SevereAnaemia=1 or ANC4_Twins=1 or ANC4_VaginalBleeding=1 or ANC4_Others=1)    
          
       then 1 else 0 end)     
       ,Severe_Anemic_Case=(Case when ANC1_Severe_Anemic=1 or ANC2_Severe_Anemic=1 or ANC3_Severe_Anemic=1 or ANC4_Severe_Anemic=1 then 1 else 0 end)    
           
       where Convert(date,Exec_Date)=CONVERT(date,getDate())    
        
  End
