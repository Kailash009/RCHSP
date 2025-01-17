USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[shedule_ap_deathRecord_child]    Script Date: 09/26/2024 14:47:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER PROC [dbo].[shedule_ap_deathRecord_child]
as
begin

insert into [a_children_registration]([State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]
      ,[Village_Code],[Registration_no],[Register_srno],[Financial_Yr],[Financial_Year],[Registration_Date],[Name_Child],[Gender],[Birth_Date],[Birth_place]
      ,[Mother_Reg_no],[Mother_ID_No],[ID_No],[Name_Mother],[Landline_no],[Mobile_no],[Address],[Religion_code],[Caste],[Identity_type],[Identity_number]
      ,[ANM_ID],[ASHA_ID],[IP_address],[Created_By],[Created_On],[Delete_mother],[ReasonForDeletion],[DeletedOn],[Name_Father],[Mobile_Relates_To]
      ,[Weight],[Delivery_Location],[DeliveryLocationID],[Updated_On],[Updated_By],[Mobile_ID],[SourceID],[Child_EID],[Child_EIDT],[Child_Aadhar_No]
      ,[Birth_Certificate_Received],[Entry_Type],[Fully_Immunized],[Received_AllVaccines])
	SELECT [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]
      ,[Village_Code],[Registration_no],[Register_srno],[Financial_Yr],[Financial_Year],[Registration_Date],[Name_Child],[Gender],[Birth_Date],[Birth_place]
      ,[Mother_Reg_no],[Mother_ID_No],[ID_No],[Name_Mother],[Landline_no],[Mobile_no],[Address],[Religion_code],[Caste],[Identity_type],[Identity_number]
      ,[ANM_ID],[ASHA_ID],[IP_address],[Created_By],[Created_On],[Delete_mother],[ReasonForDeletion],[DeletedOn],[Name_Father],[Mobile_Relates_To]
      ,[Weight],[Delivery_Location],[DeliveryLocationID],[Updated_On],[Updated_By],[Mobile_ID],[SourceID],[Child_EID],[Child_EIDT],[Child_Aadhar_No]
      ,[Birth_Certificate_Received],[Entry_Type],[Fully_Immunized],[Received_AllVaccines]
	FROM [t_children_registration] where Registration_no in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))
	delete from [t_children_registration] where Registration_no in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))

	insert into a_children_tracking([State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]
      ,[HealthSubFacility_Code],[Village_Code],[Registration_no],[Immu_code],[Immu_date],[Immu_Source],[AEFI_Serious]
      ,[Serious_Reason],[Vac_Name],[Vac_batch],[Vac_exp_date],[Vac_manuf],[ANM_ID],[ASHA_ID],[IP_address],[Created_by]
      ,[Created_On],[Remarks],[Reason_closure],[Death_reason],[Other_Death_reason],[Closure_Remarks],[NonSerious_Reason]
      ,[Fully_Immunized],[Received_AllVaccines],[DeathPlace],[DeathDate],[Mobile_ID],[Updated_By],[Updated_On]
      ,[ID_No],[SourceID])
	SELECT [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]
      ,[HealthSubFacility_Code],[Village_Code],[Registration_no],[Immu_code],[Immu_date],[Immu_Source],[AEFI_Serious]
      ,[Serious_Reason],[Vac_Name],[Vac_batch],[Vac_exp_date],[Vac_manuf],[ANM_ID],[ASHA_ID],[IP_address],[Created_by]
      ,[Created_On],[Remarks],[Reason_closure],[Death_reason],[Other_Death_reason],[Closure_Remarks],[NonSerious_Reason]
      ,[Fully_Immunized],[Received_AllVaccines],[DeathPlace],[DeathDate],[Mobile_ID],[Updated_By],[Updated_On]
      ,[ID_No],[SourceID]
	FROM [t_children_tracking]where Registration_no in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))
	delete from t_children_tracking where Registration_no in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))
		
	insert into a_child_pnc([State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]
      ,[HealthSubFacility_Code],[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[InfantRegistration]
      ,[PNC_No],[PNC_Type],[PNC_Date],[Infant_Weight],[DangerSign_Infant],[DangerSign_Infant_Other],[DangerSign_Infant_length]
      ,[ReferralFacility_Infant],[ReferralFacilityID_Infant],[ReferralLoationOther_Infant],[Infant_Death],[Place_of_death]
      ,[Infant_Death_Date],[Infant_Death_Reason],[Infant_Death_Reason_Other],[Infant_Death_Reason_length],[Remarks]
      ,[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],[Mobile_ID],[Updated_By],[Updated_On],[SourceID])
	select [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]
      ,[HealthSubFacility_Code],[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[InfantRegistration]
      ,[PNC_No],[PNC_Type],[PNC_Date],[Infant_Weight],[DangerSign_Infant],[DangerSign_Infant_Other],[DangerSign_Infant_length]
      ,[ReferralFacility_Infant],[ReferralFacilityID_Infant],[ReferralLoationOther_Infant],[Infant_Death],[Place_of_death]
      ,[Infant_Death_Date],[Infant_Death_Reason],[Infant_Death_Reason_Other],[Infant_Death_Reason_length],[Remarks]
      ,[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],[Mobile_ID],[Updated_By],[Updated_On],[SourceID]
   from t_child_pnc where InfantRegistration in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))
	delete from t_child_pnc where InfantRegistration in(select Registration_no from t_death_records where Convert(date,CreatedOn) < CONVERT(date,GETDATE()))
	
	delete t_death_records where IsMotherChild=2 and Convert(date,CreatedOn) < CONVERT(date,GETDATE())

end




