USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_WebServices_MasterData_Mother_CPSMS_In]    Script Date: 09/26/2024 14:47:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--exec RCH_Web_Services.dbo.Schedule_Bifurcate_CPSMS_Table
--exec RCH_Web_Services.dbo.Update_CPSMS_Flag
ALTER procedure [dbo].[Schedule_WebServices_MasterData_Mother_CPSMS_In]
as
begin

truncate table d_CPSMS
insert into d_CPSMS
select Registration_no,Case_no from T_mother_flat where CPSMS_Flag=0 
and JSY_Beneficiary='Y' 
and Medical_EDD_Date>'2012-11-01' 
and Medical_LMP_Date is not null and ISNULL(Delete_Mother,0)<>1 
and (isnull(Entry_Type,'Active')<>'Death' )  --and CONVERT(date,Exec_Date)='2016-08-12'

delete w from RCH_Web_Services.dbo. Masterdata_Mother w
inner join t_mother_flat b on w.Registration_no=b.Registration_no and w.Case_no=b.Case_no
inner join d_CPSMS c on w.Registration_no=c.Registration_no  and w.Case_no=c.Case_no



delete w from RCH_Web_Services.dbo. Master_Mother_Data w
inner join t_mother_flat b on w.Registration_no=b.Registration_no
inner join d_CPSMS c on w.Registration_no=c.Registration_no  and w.Case_no=c.Case_no



insert into RCH_Web_Services.dbo. Master_Mother_Data
([StateID],[State_Name],[District_ID],[District_Name],[Taluka_ID],[Taluka_Name],[HealthBlock_ID],[HealthBlock_Name],[PHC_ID],[PHC_Name],[SubCentre_ID]
,[SubCentre_Name],[Village_ID],[Village_Name],[Registration_no],[Case_no],[EC_Register_srno],[ID_No],[Name_wife],[Name_husband],[Whose_mobile],[Landline_no]
,[Mobile_no],[EC_Regisration_Date],[Wife_current_age],[Wife_marry_age],[Hus_current_age],[Hus_marry_age],[Address],[Religion],[Caste],[Male_child_born]
,[Female_child_born],[Male_child_live],[Female_child_live],[Young_child_gender],[Young_child_age_month],[Young_child_age_year],[Infertility_status]
,[InfertilityOptions],[Infertility_refer],[Pregnant_Status],[Pregnant_Test],[Eligibility_Status],[Present_Status],[EC_ANM_ID],[EC_ASHA_ID]
,[EC_ANM_Name],[EC_ASHA_Name],[EC_ANMPhone_No],[EC_ASHAPhone_No],[EC_Yr],[PW_Aadhar_No],[PW_EID],[PW_EIDT],[PW_AadhaarLinked],[PW_Bank_Name]
,[PW_Branch_Name],[PW_IFSC_Code],[PW_Account_No],[Hus_Aadhar_No],[Hus_EID],[Hus_EIDT],[Hus_AadhaarLinked],[Hus_Bank_Name],[Hus_Branch_Name]
,[Hus_IFSC_Code],[Hus_Account_No],[Economic_Status],[EC_Created_On],[EC_Updated_On],[Mother_Register_srno],[Mother_Registration_Date],[Mother_Weight]
,[Mother_BirthDate],[Mother_Age],[Mother_ANM_ID],[Mother_ASHA_ID],[Mother_Created_On],[Mother_Updated_On],[JSY_Beneficiary],[JSY_Payment_Received]
,[Delete_Mother],[DeletedOn],[Entry_Type],[CPSMS_Flag],[Mother_Yr],[Mother_SourceID],[Medical_LMP_Date],[Medical_Reg_12Weeks],[Medical_EDD_Date]
,[Medical_Blood_Group],[Medical_VDRL_TEST],[Medical_VDRL_Date],[Med_VDRL_Result],[Medical_HIV_TEST],[Medical_HIV_Date],[Med_HIV_Result],[Medical_Yr]
,[Med_PastIllness_Val],[Med_PastIllness],[Med_Last_Preg_Complication_Val],[Med_Last_Preg_Complication],[Med_Last_PregOutcome],[Med_SecondLast_Preg_Complication_Val]
,[Med_SecondLast_Preg_Complication],[Med_SecondLast_PregOutcome],[Expected_delivery_place],[Expected_delivery_placeName],[Med_Source_ID],[ANC1]
,[ANC1_Pregnancy_Week],[ANC1_Weight],[ANC1_BP_Systolic],[ANC1_BP_Distolic],[ANC1_Hb_gm],[ANC1_Urine_Test],[ANC1_Urine_Albumin],[ANC1_Urine_Sugar]
,[ANC1_BloodSugar_Test],[ANC1_Blood_Sugar_Fasting],[ANC1_Blood_Sugar_Post_Prandial],[ANC1_FA_Given],[ANC1_IFA_Given],[ANC1_Abdoman_FH],[ANC1_Abdoman_FHS]
,[ANC1_Abdoman_FP],[ANC1_Foetal_Movements],[ANC1_Symptoms_High_Risk_VAL],[ANC1_Symptoms_High_Risk],[ANC1_Referal_Facility],[ANC1_Referal_FacilityName]
,[ANC1_Referal_Date],[ANC1_ANM_ID],[ANC1_ASHA_ID],[ANC1_SourceID],[ANC2],[ANC2_Pregnancy_Week],[ANC2_Weight],[ANC2_BP_Systolic],[ANC2_BP_Distolic]
,[ANC2_Hb_gm],[ANC2_Urine_Test],[ANC2_Urine_Albumin],[ANC2_Urine_Sugar],[ANC2_BloodSugar_Test],[ANC2_Blood_Sugar_Fasting],[ANC2_Blood_Sugar_Post_Prandial]
,[ANC2_FA_Given],[ANC2_IFA_Given],[ANC2_Abdoman_FH],[ANC2_Abdoman_FHS],[ANC2_Abdoman_FP],[ANC2_Foetal_Movements],[ANC2_Symptoms_High_Risk_VAL]
,[ANC2_Symptoms_High_Risk],[ANC2_Referal_Facility],[ANC2_Referal_FacilityName],[ANC2_Referal_Date],[ANC2_ANM_ID],[ANC2_ASHA_ID],[ANC2_SourceID]
,[ANC3],[ANC3_Pregnancy_Week],[ANC3_Weight],[ANC3_BP_Systolic],[ANC3_BP_Distolic],[ANC3_Hb_gm],[ANC3_Urine_Test],[ANC3_Urine_Albumin],[ANC3_Urine_Sugar]
,[ANC3_BloodSugar_Test],[ANC3_Blood_Sugar_Fasting],[ANC3_Blood_Sugar_Post_Prandial],[ANC3_FA_Given],[ANC3_IFA_Given],[ANC3_Abdoman_FH],[ANC3_Abdoman_FHS]
,[ANC3_Abdoman_FP],[ANC3_Foetal_Movements],[ANC3_Symptoms_High_Risk_VAL],[ANC3_Symptoms_High_Risk],[ANC3_Referal_Facility],[ANC3_Referal_FacilityName]
,[ANC3_Referal_Date],[ANC3_ANM_ID],[ANC3_ASHA_ID],[ANC3_SourceID],[ANC4],[ANC4_Pregnancy_Week],[ANC4_Weight],[ANC4_BP_Systolic],[ANC4_BP_Distolic]
,[ANC4_Hb_gm],[ANC4_Urine_Test],[ANC4_Urine_Albumin],[ANC4_Urine_Sugar],[ANC4_BloodSugar_Test],[ANC4_Blood_Sugar_Fasting],[ANC4_Blood_Sugar_Post_Prandial]
,[ANC4_FA_Given],[ANC4_IFA_Given],[ANC4_Abdoman_FH],[ANC4_Abdoman_FHS],[ANC4_Abdoman_FP],[ANC4_Foetal_Movements],[ANC4_Symptoms_High_Risk_VAL]
,[ANC4_Symptoms_High_Risk],[ANC4_Referal_Facility],[ANC4_Referal_FacilityName],[ANC4_Referal_Date],[ANC4_ANM_ID],[ANC4_ASHA_ID],[ANC4_SourceID]
,[TT1],[TT2],[TTB],[IFA],[AbortionDate],[Abortion_Type],[Abortion_Preg_Weeks],[Induced_Indicate_Facility],[Maternal_Death],[Death_Date],[Death_Reason]
,[PPMC],[Delivery_date],[Delivery_Place],[Delivery_Place_Name],[Delivery_Conducted_By],[Delivery_Type],[Delivery_Death_Cause],[Delivery_Outcomes]
,[Live_Birth],[Still_Birth],[Discharge_Date],[JSY_Paid_Date],[Delivery_ANM_ID],[Delivery_ASHA_ID],[Delivery_Time],[Discharge_Time],[Delivery_Complication]
,[Delivery_SourceID],[PNC1_No],[PNC1_Type],[PNC1_Date],[PNC1_IFA_Tab],[PNC1_DangerSign_Mother_VAL],[PNC1_DangerSign_Mother],[PNC1_ReferralFacility_Mother_VAL]
,[PNC1_ReferralFacility_Mother],[PNC1_PPC_VAL],[PNC1_PPC],[PNC1_ANM_ID],[PNC1_ASHA_ID],[PNC1_Created_by],[PNC1_Mobile_ID],[PNC1_Source_ID],[PNC2_No]
,[PNC2_Type],[PNC2_Date],[PNC2_IFA_Tab],[PNC2_DangerSign_Mother_VAL],[PNC2_DangerSign_Mother],[PNC2_ReferralFacility_Mother_VAL],[PNC2_ReferralFacility_Mother]
,[PNC2_PPC_VAL],[PNC2_PPC],[PNC2_ANM_ID],[PNC2_ASHA_ID],[PNC2_Created_by],[PNC2_Mobile_ID],[PNC2_Source_ID],[PNC3_No],[PNC3_Type],[PNC3_Date],[PNC3_IFA_Tab]
,[PNC3_DangerSign_Mother_VAL],[PNC3_DangerSign_Mother],[PNC3_ReferralFacility_Mother_VAL],[PNC3_ReferralFacility_Mother],[PNC3_PPC_VAL],[PNC3_PPC]
,[PNC3_ANM_ID],[PNC3_ASHA_ID],[PNC3_Created_by],[PNC3_Mobile_ID],[PNC3_Source_ID],[PNC4_No],[PNC4_Type],[PNC4_Date],[PNC4_IFA_Tab],[PNC4_DangerSign_Mother_VAL]
,[PNC4_DangerSign_Mother],[PNC4_ReferralFacility_Mother_VAL],[PNC4_ReferralFacility_Mother],[PNC4_PPC_VAL],[PNC4_PPC],[PNC4_ANM_ID],[PNC4_ASHA_ID]
,[PNC4_Created_by],[PNC4_Mobile_ID],[PNC4_Source_ID],[PNC5_No],[PNC5_Type],[PNC5_Date],[PNC5_IFA_Tab],[PNC5_DangerSign_Mother_VAL],[PNC5_DangerSign_Mother]
,[PNC5_ReferralFacility_Mother_VAL],[PNC5_ReferralFacility_Mother],[PNC5_PPC_VAL],[PNC5_PPC],[PNC5_ANM_ID],[PNC5_ASHA_ID],[PNC5_Created_by],[PNC5_Mobile_ID]
,[PNC5_Source_ID],[PNC6_No] ,[PNC6_Type],[PNC6_Date],[PNC6_IFA_Tab],[PNC6_DangerSign_Mother_VAL],[PNC6_DangerSign_Mother],[PNC6_ReferralFacility_Mother_VAL]
,[PNC6_ReferralFacility_Mother],[PNC6_PPC_VAL],[PNC6_PPC],[PNC6_ANM_ID],[PNC6_ASHA_ID],[PNC6_Created_by],[PNC6_Mobile_ID],[PNC6_Source_ID]
,[PNC7_No],[PNC7_Type],[PNC7_Date],[PNC7_IFA_Tab],[PNC7_DangerSign_Mother_VAL],[PNC7_DangerSign_Mother],[PNC7_ReferralFacility_Mother_VAL],[PNC7_ReferralFacility_Mother]
,[PNC7_PPC_VAL],[PNC7_PPC],[PNC7_ANM_ID],[PNC7_ASHA_ID],[PNC7_Created_by],[PNC7_Mobile_ID],[PNC7_Source_ID]
,[Mother_Death_Place],[Mother_Death_Date],[Mother_Death_Reason_VAL],[Mother_Death_Reason],[Infant1_No],[Infant1_Id],[Infant1_Name],[Infant1_Term_VAL]
,[Infant1_Term],[Infant1_Baby_Cried],[Infant1_Resucitation_Done],[Infant1_BirthDefect],[Infant1_Gender],[Infant1_Weight],[Infant1_Breast_Feeding]
,[Infant1_Reffered_HigherFacility],[Infant1_MobileID],[Infant1_ANM_ID],[Infant1_ASHA_ID],[Infant1_Source_ID],[Infant1_Created_By],[Infant2_No]
,[Infant2_Id],[Infant2_Name],[Infant2_Term_VAL],[Infant2_Term],[Infant2_Baby_Cried],[Infant2_Resucitation_Done],[Infant2_BirthDefect],[Infant2_Gender]
,[Infant2_Weight],[Infant2_Breast_Feeding],[Infant2_Reffered_HigherFacility],[Infant2_MobileID],[Infant2_ANM_ID],[Infant2_ASHA_ID],[Infant2_Source_ID]
,[Infant2_Created_By],[Infant3_No],[Infant3_Id],[Infant3_Name],[Infant3_Term_VAL],[Infant3_Term],[Infant3_Baby_Cried],[Infant3_Resucitation_Done]
,[Infant3_BirthDefect],[Infant3_Gender],[Infant3_Weight],[Infant3_Breast_Feeding],[Infant3_Reffered_HigherFacility],[Infant3_MobileID],[Infant3_ANM_ID]
,[Infant3_ASHA_ID],[Infant3_Source_ID],[Infant3_Created_By],[Infant4_No],[Infant4_Id],[Infant4_Name],[Infant4_Term_VAL],[Infant4_Term],[Infant4_Baby_Cried]
,[Infant4_Resucitation_Done],[Infant4_BirthDefect],[Infant4_Gender],[Infant4_Weight],[Infant4_Breast_Feeding],[Infant4_Reffered_HigherFacility]
,[Infant4_MobileID],[Infant4_ANM_ID],[Infant4_ASHA_ID],[Infant4_Source_ID],[Infant4_Created_By],[Infant5_No],[Infant5_Id],[Infant5_Name],[Infant5_Term_VAL]
,[Infant5_Term],[Infant5_Baby_Cried],[Infant5_Resucitation_Done],[Infant5_BirthDefect],[Infant5_Gender],[Infant5_Weight],[Infant5_Breast_Feeding]
,[Infant5_Reffered_HigherFacility],[Infant5_MobileID],[Infant5_ANM_ID],[Infant5_ASHA_ID],[Infant5_Source_ID],[Infant5_Created_By],[Infant6_No]
,[Infant6_Id],[Infant6_Name],[Infant6_Term_VAL],[Infant6_Term],[Infant6_Baby_Cried],[Infant6_Resucitation_Done],[Infant6_BirthDefect],[Infant6_Gender]
,[Infant6_Weight],[Infant6_Breast_Feeding],[Infant6_Reffered_HigherFacility],[Infant6_MobileID],[Infant6_ANM_ID],[Infant6_ASHA_ID],[Infant6_Source_ID]
,[Infant6_Created_By],[Infant_Death_Place],[Infant_Death_Date],[Infant_Death_Reason_VAL],[Infant_Death_Reason]
,[BloodGroup_Test],[Delivery_Place_VAl],[Delivery_Complication_VAl],[Delivery_DeathCause_VAL],[Delivery_Type_VAL],[Delivery_Conducted_By_VAL]
,[Med_Pregnancy_No],[Infant1_Death_Place],[Infant1_Death_Date],[Infant1_Death_Reason_VAL],[Infant1_Death_Reason],[Infant2_Death_Place],[Infant2_Death_Date]
,[Infant2_Death_Reason_VAL],[Infant2_Death_Reason],[Infant3_Death_Place],[Infant3_Death_Date],[Infant3_Death_Reason_VAL],[Infant3_Death_Reason],[Infant4_Death_Place]
,[Infant4_Death_Date],[Infant4_Death_Reason_VAL],[Infant4_Death_Reason],[Infant5_Death_Place],[Infant5_Death_Date],[Infant5_Death_Reason_VAL],[Infant5_Death_Reason]
,[Infant6_Death_Place],[Infant6_Death_Date],[Infant6_Death_Reason_VAL],[Infant6_Death_Reason],[Infant1_Death],[Infant2_Death],[Infant3_Death],[Infant4_Death]
,[Infant5_Death],[Infant6_Death],[Exec_Date]
)
select a.[StateID],b.StateName as [State_Name],a.[District_ID],c.DIST_NAME_ENG as [District_Name],a.[Taluka_ID],d.TAL_NAME [Taluka_Name],[HealthBlock_ID],e. Block_Name_E [HealthBlock_Name],[PHC_ID],[PHC_Name]
,[SubCentre_ID],g.SUBPHC_NAME_E as [SubCentre_Name],[Village_ID],[Village_Name],a.[Registration_no],a.[Case_no],[EC_Register_srno],[ID_No],[Name_wife],[Name_husband],[Whose_mobile],[Landline_no]
,[Mobile_no],[EC_Regisration_Date],[Wife_current_age],[Wife_marry_age],[Hus_current_age],[Hus_marry_age],a.[Address],[Religion],[Caste],[Male_child_born]
,[Female_child_born],[Male_child_live],[Female_child_live],[Young_child_gender],[Young_child_age_month],[Young_child_age_year],[Infertility_status]
,[InfertilityOptions],[Infertility_refer],[Pregnant_Status],[Pregnant_Test],[Eligibility_Status],[Present_Status],[EC_ANM_ID],[EC_ASHA_ID]
,i.Name as [EC_ANM_Name],j.Name as [EC_ASHA_Name],i.Contact_No as [EC_ANMPhone_No],j.Contact_No as [EC_ASHAPhone_No],[EC_Yr],[PW_Aadhar_No],[PW_EID],[PW_EIDT],[PW_AadhaarLinked],[PW_Bank_Name]
,[PW_Branch_Name],[PW_IFSC_Code],[PW_Account_No],[Hus_Aadhar_No],[Hus_EID],[Hus_EIDT],[Hus_AadhaarLinked],[Hus_Bank_Name],[Hus_Branch_Name]
,[Hus_IFSC_Code],[Hus_Account_No],[Economic_Status],[EC_Created_On],[EC_Updated_On],[Mother_Register_srno],[Mother_Registration_Date],[Mother_Weight]
,[Mother_BirthDate],[Mother_Age],[Mother_ANM_ID],[Mother_ASHA_ID],[Mother_Created_On],[Mother_Updated_On],[JSY_Beneficiary],[JSY_Payment_Received]
,[Delete_Mother],[DeletedOn],[Entry_Type],a.[CPSMS_Flag],[Mother_Yr],[Mother_SourceID],[Medical_LMP_Date],[Medical_Reg_12Weeks],[Medical_EDD_Date]
,[Medical_Blood_Group],[Medical_VDRL_TEST],[Medical_VDRL_Date],[Med_VDRL_Result],[Medical_HIV_TEST],[Medical_HIV_Date],[Med_HIV_Result],[Medical_Yr]
,[Med_PastIllness_Val],[Med_PastIllness],[Med_Last_Preg_Complication_Val],[Med_Last_Preg_Complication],[Med_Last_PregOutcome],[Med_SecondLast_Preg_Complication_Val]
,[Med_SecondLast_Preg_Complication],[Med_SecondLast_PregOutcome],[Expected_delivery_place],[Expected_delivery_placeName],[Med_Source_ID],[ANC1]
,[ANC1_Pregnancy_Week],[ANC1_Weight],[ANC1_BP_Systolic],[ANC1_BP_Distolic],[ANC1_Hb_gm],[ANC1_Urine_Test],[ANC1_Urine_Albumin],[ANC1_Urine_Sugar]
,[ANC1_BloodSugar_Test],[ANC1_Blood_Sugar_Fasting],[ANC1_Blood_Sugar_Post_Prandial],[ANC1_FA_Given],[ANC1_IFA_Given],[ANC1_Abdoman_FH],[ANC1_Abdoman_FHS]
,[ANC1_Abdoman_FP],[ANC1_Foetal_Movements],[ANC1_Symptoms_High_Risk_VAL],[ANC1_Symptoms_High_Risk],[ANC1_Referal_Facility],[ANC1_Referal_FacilityName]
,[ANC1_Referal_Date],[ANC1_ANM_ID],[ANC1_ASHA_ID],[ANC1_SourceID],[ANC2],[ANC2_Pregnancy_Week],[ANC2_Weight],[ANC2_BP_Systolic],[ANC2_BP_Distolic]
,[ANC2_Hb_gm],[ANC2_Urine_Test],[ANC2_Urine_Albumin],[ANC2_Urine_Sugar],[ANC2_BloodSugar_Test],[ANC2_Blood_Sugar_Fasting],[ANC2_Blood_Sugar_Post_Prandial]
,[ANC2_FA_Given],[ANC2_IFA_Given],[ANC2_Abdoman_FH],[ANC2_Abdoman_FHS],[ANC2_Abdoman_FP],[ANC2_Foetal_Movements],[ANC2_Symptoms_High_Risk_VAL]
,[ANC2_Symptoms_High_Risk],[ANC2_Referal_Facility],[ANC2_Referal_FacilityName],[ANC2_Referal_Date],[ANC2_ANM_ID],[ANC2_ASHA_ID],[ANC2_SourceID]
,[ANC3],[ANC3_Pregnancy_Week],[ANC3_Weight],[ANC3_BP_Systolic],[ANC3_BP_Distolic],[ANC3_Hb_gm],[ANC3_Urine_Test],[ANC3_Urine_Albumin],[ANC3_Urine_Sugar]
,[ANC3_BloodSugar_Test],[ANC3_Blood_Sugar_Fasting],[ANC3_Blood_Sugar_Post_Prandial],[ANC3_FA_Given],[ANC3_IFA_Given],[ANC3_Abdoman_FH],[ANC3_Abdoman_FHS]
,[ANC3_Abdoman_FP],[ANC3_Foetal_Movements],[ANC3_Symptoms_High_Risk_VAL],[ANC3_Symptoms_High_Risk],[ANC3_Referal_Facility],[ANC3_Referal_FacilityName]
,[ANC3_Referal_Date],[ANC3_ANM_ID],[ANC3_ASHA_ID],[ANC3_SourceID],[ANC4],[ANC4_Pregnancy_Week],[ANC4_Weight],[ANC4_BP_Systolic],[ANC4_BP_Distolic]
,[ANC4_Hb_gm],[ANC4_Urine_Test],[ANC4_Urine_Albumin],[ANC4_Urine_Sugar],[ANC4_BloodSugar_Test],[ANC4_Blood_Sugar_Fasting],[ANC4_Blood_Sugar_Post_Prandial]
,[ANC4_FA_Given],[ANC4_IFA_Given],[ANC4_Abdoman_FH],[ANC4_Abdoman_FHS],[ANC4_Abdoman_FP],[ANC4_Foetal_Movements],[ANC4_Symptoms_High_Risk_VAL]
,[ANC4_Symptoms_High_Risk],[ANC4_Referal_Facility],[ANC4_Referal_FacilityName],[ANC4_Referal_Date],[ANC4_ANM_ID],[ANC4_ASHA_ID],[ANC4_SourceID]
,[TT1],[TT2],[TTB],[IFA],[AbortionDate],[Abortion_Type],[Abortion_Preg_Weeks],[Induced_Indicate_Facility],[Maternal_Death],[Death_Date],[Death_Reason]
,[PPMC],[Delivery_date],[Delivery_Place],[Delivery_Place_Name],[Delivery_Conducted_By],[Delivery_Type],[Delivery_Death_Cause],[Delivery_Outcomes]
,[Live_Birth],[Still_Birth],[Discharge_Date],[JSY_Paid_Date],[Delivery_ANM_ID],[Delivery_ASHA_ID],[Delivery_Time],[Discharge_Time],[Delivery_Complication]
,[Delivery_SourceID],[PNC1_No],[PNC1_Type],[PNC1_Date],[PNC1_IFA_Tab],[PNC1_DangerSign_Mother_VAL],[PNC1_DangerSign_Mother],[PNC1_ReferralFacility_Mother_VAL]
,[PNC1_ReferralFacility_Mother],[PNC1_PPC_VAL],[PNC1_PPC],[PNC1_ANM_ID],[PNC1_ASHA_ID],[PNC1_Created_by],[PNC1_Mobile_ID],[PNC1_Source_ID],[PNC2_No]
,[PNC2_Type],[PNC2_Date],[PNC2_IFA_Tab],[PNC2_DangerSign_Mother_VAL],[PNC2_DangerSign_Mother],[PNC2_ReferralFacility_Mother_VAL],[PNC2_ReferralFacility_Mother]
,[PNC2_PPC_VAL],[PNC2_PPC],[PNC2_ANM_ID],[PNC2_ASHA_ID],[PNC2_Created_by],[PNC2_Mobile_ID],[PNC2_Source_ID],[PNC3_No],[PNC3_Type],[PNC3_Date],[PNC3_IFA_Tab]
,[PNC3_DangerSign_Mother_VAL],[PNC3_DangerSign_Mother],[PNC3_ReferralFacility_Mother_VAL],[PNC3_ReferralFacility_Mother],[PNC3_PPC_VAL],[PNC3_PPC]
,[PNC3_ANM_ID],[PNC3_ASHA_ID],[PNC3_Created_by],[PNC3_Mobile_ID],[PNC3_Source_ID],[PNC4_No],[PNC4_Type],[PNC4_Date],[PNC4_IFA_Tab],[PNC4_DangerSign_Mother_VAL]
,[PNC4_DangerSign_Mother],[PNC4_ReferralFacility_Mother_VAL],[PNC4_ReferralFacility_Mother],[PNC4_PPC_VAL],[PNC4_PPC],[PNC4_ANM_ID],[PNC4_ASHA_ID]
,[PNC4_Created_by],[PNC4_Mobile_ID],[PNC4_Source_ID],[PNC5_No],[PNC5_Type],[PNC5_Date],[PNC5_IFA_Tab],[PNC5_DangerSign_Mother_VAL],[PNC5_DangerSign_Mother]
,[PNC5_ReferralFacility_Mother_VAL],[PNC5_ReferralFacility_Mother],[PNC5_PPC_VAL],[PNC5_PPC],[PNC5_ANM_ID],[PNC5_ASHA_ID],[PNC5_Created_by],[PNC5_Mobile_ID]
,[PNC5_Source_ID],[PNC6_No] ,[PNC6_Type],[PNC6_Date],[PNC6_IFA_Tab],[PNC6_DangerSign_Mother_VAL],[PNC6_DangerSign_Mother],[PNC6_ReferralFacility_Mother_VAL]
,[PNC6_ReferralFacility_Mother],[PNC6_PPC_VAL],[PNC6_PPC],[PNC6_ANM_ID],[PNC6_ASHA_ID],[PNC6_Created_by],[PNC6_Mobile_ID],[PNC6_Source_ID]
,[PNC7_No],[PNC7_Type],[PNC7_Date],[PNC7_IFA_Tab],[PNC7_DangerSign_Mother_VAL],[PNC7_DangerSign_Mother],[PNC7_ReferralFacility_Mother_VAL],[PNC7_ReferralFacility_Mother]
,[PNC7_PPC_VAL],[PNC7_PPC],[PNC7_ANM_ID],[PNC7_ASHA_ID],[PNC7_Created_by],[PNC7_Mobile_ID],[PNC7_Source_ID]
,[Mother_Death_Place],[Mother_Death_Date],[Mother_Death_Reason_VAL],[Mother_Death_Reason],[Infant1_No],[Infant1_Id],[Infant1_Name],[Infant1_Term_VAL]
,[Infant1_Term],[Infant1_Baby_Cried],[Infant1_Resucitation_Done],[Infant1_BirthDefect],[Infant1_Gender],[Infant1_Weight],[Infant1_Breast_Feeding]
,[Infant1_Reffered_HigherFacility],[Infant1_MobileID],[Infant1_ANM_ID],[Infant1_ASHA_ID],[Infant1_Source_ID],[Infant1_Created_By],[Infant2_No]
,[Infant2_Id],[Infant2_Name],[Infant2_Term_VAL],[Infant2_Term],[Infant2_Baby_Cried],[Infant2_Resucitation_Done],[Infant2_BirthDefect],[Infant2_Gender]
,[Infant2_Weight],[Infant2_Breast_Feeding],[Infant2_Reffered_HigherFacility],[Infant2_MobileID],[Infant2_ANM_ID],[Infant2_ASHA_ID],[Infant2_Source_ID]
,[Infant2_Created_By],[Infant3_No],[Infant3_Id],[Infant3_Name],[Infant3_Term_VAL],[Infant3_Term],[Infant3_Baby_Cried],[Infant3_Resucitation_Done]
,[Infant3_BirthDefect],[Infant3_Gender],[Infant3_Weight],[Infant3_Breast_Feeding],[Infant3_Reffered_HigherFacility],[Infant3_MobileID],[Infant3_ANM_ID]
,[Infant3_ASHA_ID],[Infant3_Source_ID],[Infant3_Created_By],[Infant4_No],[Infant4_Id],[Infant4_Name],[Infant4_Term_VAL],[Infant4_Term],[Infant4_Baby_Cried]
,[Infant4_Resucitation_Done],[Infant4_BirthDefect],[Infant4_Gender],[Infant4_Weight],[Infant4_Breast_Feeding],[Infant4_Reffered_HigherFacility]
,[Infant4_MobileID],[Infant4_ANM_ID],[Infant4_ASHA_ID],[Infant4_Source_ID],[Infant4_Created_By],[Infant5_No],[Infant5_Id],[Infant5_Name],[Infant5_Term_VAL]
,[Infant5_Term],[Infant5_Baby_Cried],[Infant5_Resucitation_Done],[Infant5_BirthDefect],[Infant5_Gender],[Infant5_Weight],[Infant5_Breast_Feeding]
,[Infant5_Reffered_HigherFacility],[Infant5_MobileID],[Infant5_ANM_ID],[Infant5_ASHA_ID],[Infant5_Source_ID],[Infant5_Created_By],[Infant6_No]
,[Infant6_Id],[Infant6_Name],[Infant6_Term_VAL],[Infant6_Term],[Infant6_Baby_Cried],[Infant6_Resucitation_Done],[Infant6_BirthDefect],[Infant6_Gender]
,[Infant6_Weight],[Infant6_Breast_Feeding],[Infant6_Reffered_HigherFacility],[Infant6_MobileID],[Infant6_ANM_ID],[Infant6_ASHA_ID],[Infant6_Source_ID]
,[Infant6_Created_By],[Infant_Death_Place],[Infant_Death_Date],[Infant_Death_Reason_VAL],[Infant_Death_Reason]
,[BloodGroup_Test],[Delivery_Place_VAl],[Delivery_Complication_VAl],[Delivery_DeathCause_VAL],[Delivery_Type_VAL],[Delivery_Conducted_By_VAL]
,[Med_Pregnancy_No],[Infant1_Death_Place],[Infant1_Death_Date],[Infant1_Death_Reason_VAL],[Infant1_Death_Reason],[Infant2_Death_Place],[Infant2_Death_Date]
,[Infant2_Death_Reason_VAL],[Infant2_Death_Reason],[Infant3_Death_Place],[Infant3_Death_Date],[Infant3_Death_Reason_VAL],[Infant3_Death_Reason],[Infant4_Death_Place]
,[Infant4_Death_Date],[Infant4_Death_Reason_VAL],[Infant4_Death_Reason],[Infant5_Death_Place],[Infant5_Death_Date],[Infant5_Death_Reason_VAL],[Infant5_Death_Reason]
,[Infant6_Death_Place],[Infant6_Death_Date],[Infant6_Death_Reason_VAL],[Infant6_Death_Reason],[Infant1_Death],[Infant2_Death],[Infant3_Death],[Infant4_Death]
,[Infant5_Death],[Infant6_Death],[Exec_Date] from 
[t_mother_flat] a
inner join TBL_STATE b on a.StateID=b.StateID
inner join TBL_DISTRICT c on a.District_ID=c.DIST_CD
inner join TBL_TALUKA d on a.Taluka_ID=d.TAL_CD and a.District_Id=d.DIST_CD
inner join TBL_HEALTH_BLOCK e on a.HealthBlock_ID=e.BLOCK_CD
inner join TBL_PHC f on a.PHC_ID=f.PHC_CD
left outer join TBL_SUBPHC g on a.SubCentre_ID=g.SUBPHC_CD
left outer join TBL_VILLAGE h on a.SubCentre_ID=h.SUBPHC_CD and a.Village_ID=h.VILLAGE_CD
left outer join t_Ground_Staff i on a.EC_ANM_ID=i.ID
left outer join t_Ground_Staff j on a.EC_ASHA_ID=j.ID
left outer join t_MotherEntry_Verification k on a.Registration_no=k.Registration_no
inner join d_CPSMS l on a.Registration_no=l.Registration_no  and a.Case_no=l.Case_no





























insert into RCH_Web_Services.dbo. Masterdata_Mother
([StateID],[State_Name],[District_ID],[District_Name],[Taluka_ID],[Taluka_Name],[HealthBlock_ID],[HealthBlock_Name],[PHC_ID],[PHC_Name]
,[SubCentre_ID],[SubCentre_Name],[Village_ID],[Village_Name],[Yr],[GP_Village],[Address],[ID_No],[Name],[Husband_Name],[PhoneNo_Of_Whom]
,[Whom_PhoneNo],[Birthdate],[JSY_Beneficiary],[Caste],[ANM_Name],[ANM_Phone],[ASHA_Name],[ASHA_Phone],[Delivery_Lnk_Facility],[Facility_Name]
,[LMP_Date],[ANC1_Date],[ANC2_Date],[ANC3_Date],[ANC4_Date],[TT1_Date],[TT2_Date],[TTBooster_Date],[IFA100_Given_Date],[Anemia],[ANC_Complication]
,[RTI_STI],[Dly_Date],[Dly_Place_Home_Type],[Dly_Place_Public],[Dly_Place_Private],[Dly_Type],[Dly_Complication],[Discharge_Date],[JSY_Paid_Date]
,[Abortion],[PNC_Home_Visit],[PNC_Complication],[PPC_Method],[PNC_Checkup],[Outcome_Nos],[Child1_Name],[Child1_Sex],[Child1_Wt],[Child1_Brestfeeding]
,[Child2_Name],[Child2_Sex],[Child2_Wt],[Child2_Brestfeeding],[Child3_Name],[Child3_Sex],[Child3_Wt],[Child3_Brestfeeding],[Child4_Name]
,[Child4_Sex],[Child4_Wt],[Child4_Brestfeeding],[Age],[MTHR_REG_DATE],[LastUpdateDate],[Remarks],[ANM_ID],[ASHA_ID]
,[Created_By],[Updated_By],[Aadhar_No],[BPL_APL],[EID],[EIDTime],[Bank_ID],[Bank_Name],[Branch_Name],[Acc_No],[IFSC_Code],[Is_Aadhar_linked]
,[Exec_Date],[Verify_Date],[Verifier_Name],[VerifierID],[Call_Ans],[IsPhoneNoCorrect],[NoCall_Reason],[NoPhone_Reason],[Verifier_Remarks],[EDD_Date]
,[GENDER],[Email],[CPSMS_Flag],[Registration_no],[Case_no],[Delete_mother],[Entry_type]
)


select a.[StateID],b.StateName as [State_Name],a.[District_ID],c.DIST_NAME_ENG as [District_Name],a.[Taluka_ID],d.TAL_NAME [Taluka_Name],[HealthBlock_ID],e. Block_Name_E [HealthBlock_Name],[PHC_ID],[PHC_Name]
,[SubCentre_ID],g.SUBPHC_NAME_E as [SubCentre_Name],[Village_ID],[Village_Name],a.EC_Yr,'' as [GP_Village],a.[Address],a.ID_No  ,a.Name_wife,a.Name_husband
,a.Whose_mobile,a.Mobile_no,a.Mother_BirthDate,[JSY_Beneficiary],[Caste],i.Name as [ANM_Name],i.Contact_No [ANM_Phone],j.Name as [ASHA_Name],j.Contact_No as[ASHA_Phone],a.Expected_delivery_place [Delivery_Lnk_Facility],a.Expected_delivery_placeName [Facility_Name]
,a.Medical_LMP_Date [LMP_Date],a.ANC1 [ANC1_Date],a.ANC2 [ANC2_Date],a.ANC3 [ANC3_Date],a.ANC4 [ANC4_Date],a.TT1 [TT1_Date],a.TT2 [TT2_Date],a.TTB [TTBooster_Date],null [IFA100_Given_Date]-- we dont capture IFA date in ANC
,coalesce(a.ANC1_Hb_gm,a.ANC2_Hb_gm,a.ANC3_Hb_gm,a.ANC4_Hb_gm),null [ANC1_Complication]--No feild as such
,null [RTI_STI]--Check
,a.Delivery_date [Dly_Date]
,(Case when a.Delivery_Place='Home' then a.Delivery_Conducted_By else null end ) [Dly_Place_Home_Type]
      ,(Case when a.Delivery_Place<>'Home' and a.Delivery_Place<>'Other Private Hospital' then a.Delivery_Place else null end ) [Dly_Place_Public]
      ,(Case when a.Delivery_Place='Other Private Hospital' then a.Delivery_Place_Name else null end )[Dly_Place_Private]
      ,a.Delivery_Type as [Dly_Type]
      ,a.Delivery_Complication [Dly_Complication]
      ,a.Discharge_Date [Discharge_Date]
      ,a.JSY_Paid_Date [JSY_Paid_Date]

,a.Abortion_Type [Abortion]
      ,null [PNC_Home_Visit]--No feild as such
      ,null [PNC_Complication] --No feild as such
      ,coalesce(a.PNC1_PPC,a.PNC2_PPC,a.PNC3_PPC,a.PNC4_PPC,a.PNC5_PPC,a.PNC6_PPC,a.PNC7_PPC) [PPC_Method]
      ,null [PNC_Checkup] --No feild as such
      ,a.Delivery_Outcomes [Outcome_Nos]
      ,a.Infant1_Name [Child1_Name]
      ,a.[Infant1_Gender] [Child1_Sex]
      ,a.[Infant1_Weight] [Child1_Wt]
      ,a.[Infant1_Breast_Feeding] [Child1_Brestfeeding]
      
      ,a.Infant2_Name [Child2_Name]
      ,a.[Infant2_Gender][Child2_Sex]
      ,a.[Infant2_Weight] [Child2_Wt]
      ,a.[Infant2_Breast_Feeding][Child2_Brestfeeding]
      ,a.Infant3_Name[Child3_Name]
      ,a.[Infant3_Gender][Child3_Sex]
      ,a.[Infant3_Weight][Child3_Wt]
      ,a.[Infant3_Breast_Feeding][Child3_Brestfeeding]
      ,a.Infant4_Name [Child4_Name]
      
      ,a.[Infant4_Gender][Child4_Sex]
      ,a.[Infant4_Weight][Child4_Wt]
      ,a.[Infant4_Breast_Feeding][Child4_Brestfeeding]
      ,a.Mother_Age [Age]
      ,a.Mother_Created_On [MTHR_REG_DATE]
      ,a.Mother_Updated_On [LastUpdateDate]
      ,null[Remarks]
      ,a.EC_ANM_ID [ANM_ID]
      ,a.EC_ASHA_ID[ASHA_ID]
      
      ,null[Created_By]
      ,null[Updated_By]
      ,a.PW_Aadhar_No [Aadhar_No]
      ,a.Economic_Status [BPL_APL]
      ,a.PW_EID [EID]
      ,a.PW_EIDT [EIDTime]
      ,null[Bank_ID]
      ,a.PW_Bank_Name [Bank_Name]
      ,a.PW_Branch_Name [Branch_Name]
      ,a.PW_Account_No [Acc_No]
      ,a.PW_IFSC_Code [IFSC_Code]
      ,a.PW_AadhaarLinked [Is_Aadhar_linked]
      
      ,getdate() [Exec_Date]
      ,k.VerifyDt as [Verify_Date]
      ,k.VerifierName as [Verifier_Name]
      ,k.VerifierID as [VerifierID]
      ,k.Call_Ans as [Call_Ans]
      ,k.IsPhoneNoCorrect as [IsPhoneNoCorrect]
      ,k.NoCall_Reason as [NoCall_Reason]
      ,k.NoPhone_Reason as [NoPhone_Reason]
      ,k.Remark [Verifier_Remarks]
      ,a.Medical_EDD_Date [EDD_Date]
      
      ,'F'[GENDER]
      ,null [Email]
      ,a.[CPSMS_Flag]
      ,a.[Registration_no]
      ,a.[Case_no] 
      ,a.Delete_Mother
      ,isnull(l.Id,4)
      from [t_mother_flat] a
      inner join TBL_STATE b on a.StateID=b.StateID
      inner join TBL_DISTRICT c on a.District_ID=c.DIST_CD
      inner join TBL_TALUKA d on a.Taluka_ID=d.TAL_CD
      inner join TBL_HEALTH_BLOCK e on a.HealthBlock_ID=e.BLOCK_CD
      inner join TBL_PHC f on a.PHC_ID=f.PHC_CD
      left outer join TBL_SUBPHC g on a.SubCentre_ID=g.SUBPHC_CD
      left outer join TBL_VILLAGE h on a.SubCentre_ID=h.SUBPHC_CD and a.Village_ID=h.VILLAGE_CD
      left outer join t_Ground_Staff i on a.EC_ANM_ID=i.ID
      left outer join t_Ground_Staff j on a.EC_ASHA_ID=j.ID
      left outer join t_MotherEntry_Verification k on a.Registration_no=k.Registration_no
      left outer join RCH_National_Level.dbo.m_MotherEntry_Type l on a.Entry_Type=l.Name
      inner join d_CPSMS m on a.Registration_no=m.Registration_no  and a.Case_no=m.Case_no
     



exec tp_mother_flat_count_InUp

exec tp_EC_flat_count_InUp
      
end



