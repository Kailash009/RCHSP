USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_WebServices_MasterData_Child_In]    Script Date: 09/26/2024 14:46:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec Schedule_WebServices_MasterData_Child_In

*/


ALTER procedure [dbo].[Schedule_WebServices_MasterData_Child_In]


as
begin


delete w from RCH_Web_Services.dbo.Master_Child_Data w
inner join t_child_flat b on w.Registration_no=b.Registration_no
where Convert(date,b.Exec_Date)=CONVERT(date,getdate())


insert into RCH_Web_Services.dbo.Master_Child_Data([StateID],[State_Name],[District_ID],[District_Name],[Taluka_ID],[Taluka_Name],[HealthBlock_ID]
,[HealthBlock_Name],[PHC_ID],[PHC_Name],[SubCentre_ID],[SubCentre_Name] ,[Village_ID],[Village_Name],[Registration_no],[Register_srno],[Financial_Year]
,[Registration_Date],[Name_Child],[Gender],[Birth_Date],[Birth_place],[Mother_Reg_no],[Mother_Case_no],[Mother_ID_No],[ID_No],[Name_Mother]
,[Landline_no],[Mobile_no],[Address],[Religion],[Caste],[ANM_Name],[ASHA_Name],[ANM_Phone_No],[ASHA_Phone_No],[IP_Address],[Created_On]
,[Updated_On],[Created_By],[Updated_By],[Delete_mother],[Name_Father],[Mobile_Relates_To],[Weight],[Mobile_ID],[SourceID],[Child_Aadhaar_No]
,[Child_EID],[Child_EIDTime],[Birth_Certificate_Number],[Entry_Type],[Fully_Immunized],[Received_AllVaccines],[AEFI_Serious],[AEFI_Serious_Vaccination]
,[Serious_Reason],[Reason_closure],[Death_reason],[DeathPlace],[DeathDate],[Case_closure],[BCG_Dt],[BCG_ANM_ID],[BCG_ASHA_ID],[BCG_Source_ID],[OPV0_Dt]
,[OPV0_ANM_ID],[OPV0_ASHA_ID],[OPV0_Source_ID],[OPV1_Dt],[OPV1_ANM_ID],[OPV1_ASHA_ID],[OPV1_Source_ID],[OPV2_Dt],[OPV2_ANM_ID],[OPV2_ASHA_ID]
,[OPV2_Source_ID],[OPV3_Dt],[OPV3_ANM_ID],[OPV3_ASHA_ID],[OPV3_Source_ID],[OPVBooster_Dt] ,[OPVBooster_ANM_ID],[OPVBooster_ASHA_ID],[OPVBooster_Source_ID]
,[DPT1_Dt],[DPT1_ANM_ID],[DPT1_ASHA_ID],[DPT1_Source_ID],[DPT2_Dt],[DPT2_ANM_ID],[DPT2_ASHA_ID],[DPT2_Source_ID],[DPT3_Dt],[DPT3_ANM_ID],[DPT3_ASHA_ID]
,[DPT3_Source_ID],[DPTBooster1_Dt],[DPTBooster1_ANM_ID],[DPTBooster1_ASHA_ID],[DPTBooster1_Source_ID],[DPTBooster1_Breastfeeding],[DPTBooster1_Complentary_Feeding]
,[DPTBooster1_Complentary_Feeding_Month],[DPTBooster1_Visit_Date],[DPTBooster1_Child_Weight],[DPTBooster1_Diarrhoea],[DPTBooster1_ORS_Given]
,[DPTBooster1_Pneumonia],[DPTBooster1_Antibiotics_Given],[DPTBooster2_Dt],[DPTBooster2_ANM_ID],[DPTBooster2_ASHA_ID],[DPTBooster2_Source_ID]
,[HepatitisB0_Dt],[HepatitisB0_ANM_ID],[HepatitisB0_ASHA_ID] ,[HepatitisB0_Source_ID],[HepatitisB1_Dt],[HepatitisB1_ANM_ID],[HepatitisB1_ASHA_ID]
,[HepatitisB1_Source_ID],[HepatitisB2_Dt],[HepatitisB2_ANM_ID],[HepatitisB2_ASHA_ID],[HepatitisB2_Source_ID],[HepatitisB3_Dt],[HepatitisB3_ANM_ID]
,[HepatitisB3_ASHA_ID],[HepatitisB3_Source_ID],[Penta1_Dt],[Penta1_ANM_ID],[Penta1_ASHA_ID],[Penta1_Source_ID],[Penta2_Dt],[Penta2_ANM_ID]
,[Penta2_ASHA_ID],[Penta2_Source_ID],[Penta3_Dt],[Penta3_ANM_ID],[Penta3_ASHA_ID],[Penta3_Source_ID],[Measles1_Dt],[Measles1_ANM_ID],[Measles1_ASHA_ID]
,[Measles1_Source_ID],[Measles1_Breastfeeding],[Measles1_Complentary_Feeding],[Measles1_Complentary_Feeding_Month],[Measles1_Visit_Date]
,[Measles1_Child_Weight],[Measles1_Diarrhoea],[Measles1_ORS_Given],[Measles1_Pneumonia],[Measles1_Antibiotics_Given],[Measles2_Dt],[Measles2_ANM_ID]
,[Measles2_ASHA_ID],[Measles2_Source_ID],[JE1_Dt],[JE1_ANM_ID],[JE1_ASHA_ID],[JE1_Source_ID],[JE2_Dt],[JE2_ANM_ID],[JE2_ASHA_ID],[JE2_Source_ID]
,[VitA_Dose1_Dt],[VitA_Dose1_ANM_ID],[VitA_Dose1_ASHA_ID],[VitA_Dose1_Source_ID],[VitA_Dose2_Dt],[VitA_Dose2_ANM_ID],[VitA_Dose2_ASHA_ID]
,[VitA_Dose2_Source_ID],[VitA_Dose3_Dt],[VitA_Dose3_ANM_ID],[VitA_Dose3_ASHA_ID],[VitA_Dose3_Source_ID],[VitA_Dose4_Dt],[VitA_Dose4_ANM_ID]
,[VitA_Dose4_ASHA_ID],[VitA_Dose4_Source_ID],[VitA_Dose5_Dt],[VitA_Dose5_ANM_ID],[VitA_Dose5_ASHA_ID],[VitA_Dose5_Source_ID],[VitA_Dose6_Dt]
,[VitA_Dose6_ANM_ID],[VitA_Dose6_ASHA_ID],[VitA_Dose6_Source_ID],[VitA_Dose7_Dt],[VitA_Dose7_ANM_ID],[VitA_Dose7_ASHA_ID],[VitA_Dose7_Source_ID]
,[VitA_Dose8_Dt],[VitA_Dose8_ANM_ID],[VitA_Dose8_ASHA_ID],[VitA_Dose8_Source_ID],[VitA_Dose9_Dt],[VitA_Dose9_ANM_ID],[VitA_Dose9_ASHA_ID]
,[VitA_Dose9_Source_ID],[MMR_Dt],[MMR_ANM_ID],[MMR_ASHA_ID],[MMR_Source_ID],[MR_Dt],[MR_ANM_ID],[MR_ASHA_ID],[MR_Source_ID],[Typhoid_Dt]
,[Typhoid_ANM_ID],[Typhoid_ASHA_ID],[Typhoid_Source_ID],[Rota_Virus_Dt],[Rota_Virus_ANM_ID],[Rota_Virus_ASHA_ID],[Rota_Virus_Source_ID]
,[VitK_Dt],[VitK_ANM_ID],[VitK_ASHA_ID],[VitK_Source_ID],[Exec_Date]
,[PNC1_No],[PNC1_Type_Infant],[PNC1_Date_Infant],[PNC1_DangerSign_Infant],[PNC1_ReferralFacility_Infant],[PNC1_ANM_ID_Infant],[PNC1_ASHA_ID_Infant]
,[PNC1_Created_by_Infant],[PNC1_Source_ID_Infant],[PNC1_Infant_Weight]
,[PNC2_No_Infant],[PNC2_Type_Infant],[PNC2_Date_Infant],[PNC2_DangerSign_Infant],[PNC2_ReferralFacility_Infant],[PNC2_ANM_ID_Infant],[PNC2_ASHA_ID_Infant]
,[PNC2_Created_by_Infant],[PNC2_Source_ID_Infant],[PNC2_Infant_Weight]
,[PNC3_No_Infant],[PNC3_Type_Infant],[PNC3_Date_Infant],[PNC3_DangerSign_Infant],[PNC3_ReferralFacility_Infant],[PNC3_ANM_ID_Infant],[PNC3_ASHA_ID_Infant]
,[PNC3_Created_by_Infant],[PNC3_Source_ID_Infant],[PNC3_Infant_Weight]
,[PNC4_No_Infant],[PNC4_Type_Infant],[PNC4_Date_Infant],[PNC4_DangerSign_Infant],[PNC4_ReferralFacility_Infant],[PNC4_ANM_ID_Infant],[PNC4_ASHA_ID_Infant]
,[PNC4_Created_by_Infant],[PNC4_Source_ID_Infant],[PNC4_Infant_Weight]
,[PNC5_No_Infant],[PNC5_Type_Infant],[PNC5_Date_Infant],[PNC5_DangerSign_Infant],[PNC5_ReferralFacility_Infant],[PNC5_ANM_ID_Infant],[PNC5_ASHA_ID_Infant]
,[PNC5_Created_by_Infant],[PNC5_Source_ID_Infant],[PNC5_Infant_Weight]
,[PNC6_No_Infant],[PNC6_Type_Infant],[PNC6_Date_Infant],[PNC6_DangerSign_Infant],[PNC6_ReferralFacility_Infant],[PNC6_ANM_ID_Infant],[PNC6_ASHA_ID_Infant]
,[PNC6_Created_by_Infant],[PNC6_Source_ID_Infant],[PNC6_Infant_Weight]
,[PNC7_No_Infant],[PNC7_Type_Infant],[PNC7_Date_Infant],[PNC7_DangerSign_Infant],[PNC7_ReferralFacility_Infant],[PNC7_ANM_ID_Infant],[PNC7_ASHA_ID_Infant]
,[PNC7_Created_by_Infant],[PNC7_Source_ID_Infant],[PNC7_Infant_Weight]
-----------------------New addition 291119
,Rota_Dose2_Dt ,Rota_Dose2_ANM_ID ,Rota_Dose2_ASHA_ID ,Rota_Dose2_Source_ID ,
Rota_Dose3_Dt ,Rota_Dose3_ANM_ID ,Rota_Dose3_ASHA_ID ,Rota_Dose3_Source_ID ,
IPV_Dose1_Dt ,IPV_Dose1_ANM_ID ,IPV_Dose1_ASHA_ID ,IPV_Dose1_Source_ID ,
IPV_Dose2_Dt ,IPV_Dose2_ANM_ID ,IPV_Dose2_ASHA_ID ,IPV_Dose2_Source_ID ,
IPV_Dose3_Dt ,IPV_Dose3_ANM_ID ,IPV_Dose3_ASHA_ID ,IPV_Dose3_Source_ID ,
PCV_Dose1_Dt ,PCV_Dose1_ANM_ID ,PCV_Dose1_ASHA_ID ,PCV_Dose1_Source_ID ,
PCV_Dose2_Dt ,PCV_Dose2_ANM_ID ,PCV_Dose2_ASHA_ID ,PCV_Dose2_Source_ID ,
PCV_DoseB_Dt ,PCV_DoseB_ANM_ID ,PCV_DoseB_ASHA_ID ,PCV_DoseB_Source_ID ,
MR1_Dt ,MR1_ANM_ID ,MR1_ASHA_ID ,MR1_Source_ID ,
MR1_Breastfeeding ,MR1_Complentary_Feeding ,MR1_Complentary_Feeding_Month ,MR1_Visit_Date ,
MR1_Child_Weight ,MR1_Diarrhoea ,MR1_ORS_Given ,MR1_Pneumonia ,MR1_Antibiotics_Given ,
Call_Ans ,Is_Phone_Correct , Is_Confirmed ,Validated_Callcentre
--------Mother_infant_detail
,Preterm_FullTerm,Baby_Cried,Resucitation_Done
,Defect_Seen_At_Birth,Breast_Feeding,Inj_Corticosteriods_Given
,Reffered_Higher_Facility,Defect_SeenAtBirth 
-------------------------------------------------
,MDDS_State_ID,MDDS_District_ID,MDDS_Taluka_ID,MDDS_Village_ID,MDDS_Block_ID,ANM_ID,ASHA_ID
)
select a.[StateID],b.StateName as [State_Name],a.[District_ID],c.DIST_NAME_ENG as [District_Name],a.[Taluka_ID],d.TAL_NAME [Taluka_Name],[HealthBlock_ID],e. Block_Name_E [HealthBlock_Name],[PHC_ID],[PHC_Name]
,[SubCentre_ID],g.SUBPHC_NAME_E as [SubCentre_Name],[Village_ID],[Village_Name],[Registration_no],[Register_srno],a.[Financial_Year]
,[Registration_Date],[Name_Child],[Gender],[Birth_Date],[Birth_place],[Mother_Reg_no],[Mother_Case_no],[Mother_ID_No],[ID_No],[Name_Mother]
,[Landline_no],[Mobile_no],a.[Address],[Religion],[Caste],i.Name  as [ANM_Name],j.Name as [ASHA_Name],i.Contact_No as [ANM_Phone_No],j.Contact_No[ASHA_Phone_No],a.[IP_Address],a.[Created_On]
,a.[Updated_On],a.[Created_By],a.[Updated_By],[Delete_mother],[Name_Father],[Mobile_Relates_To],[Weight],[Mobile_ID],[SourceID],[Child_Aadhaar_No]
,[Child_EID],[Child_EIDTime],[Birth_Certificate_Number],[Entry_Type],[Fully_Immunized],[Received_AllVaccines],[AEFI_Serious],[AEFI_Serious_Vaccination]
,[Serious_Reason],[Reason_closure],[Death_reason],[DeathPlace],[DeathDate],[Case_closure],[BCG_Dt],[BCG_ANM_ID],[BCG_ASHA_ID],[BCG_Source_ID],[OPV0_Dt]
,[OPV0_ANM_ID],[OPV0_ASHA_ID],[OPV0_Source_ID],[OPV1_Dt],[OPV1_ANM_ID],[OPV1_ASHA_ID],[OPV1_Source_ID],[OPV2_Dt],[OPV2_ANM_ID],[OPV2_ASHA_ID]
,[OPV2_Source_ID],[OPV3_Dt],[OPV3_ANM_ID],[OPV3_ASHA_ID],[OPV3_Source_ID],[OPVBooster_Dt] ,[OPVBooster_ANM_ID],[OPVBooster_ASHA_ID],[OPVBooster_Source_ID]
,[DPT1_Dt],[DPT1_ANM_ID],[DPT1_ASHA_ID],[DPT1_Source_ID],[DPT2_Dt],[DPT2_ANM_ID],[DPT2_ASHA_ID],[DPT2_Source_ID],[DPT3_Dt],[DPT3_ANM_ID],[DPT3_ASHA_ID]
,[DPT3_Source_ID],[DPTBooster1_Dt],[DPTBooster1_ANM_ID],[DPTBooster1_ASHA_ID],[DPTBooster1_Source_ID],[DPTBooster1_Breastfeeding],[DPTBooster1_Complentary_Feeding]
,[DPTBooster1_Complentary_Feeding_Month],[DPTBooster1_Visit_Date],[DPTBooster1_Child_Weight],[DPTBooster1_Diarrhoea],[DPTBooster1_ORS_Given]
,[DPTBooster1_Pneumonia],[DPTBooster1_Antibiotics_Given],[DPTBooster2_Dt],[DPTBooster2_ANM_ID],[DPTBooster2_ASHA_ID],[DPTBooster2_Source_ID]
,[HepatitisB0_Dt],[HepatitisB0_ANM_ID],[HepatitisB0_ASHA_ID] ,[HepatitisB0_Source_ID],[HepatitisB1_Dt],[HepatitisB1_ANM_ID],[HepatitisB1_ASHA_ID]
,[HepatitisB1_Source_ID],[HepatitisB2_Dt],[HepatitisB2_ANM_ID],[HepatitisB2_ASHA_ID],[HepatitisB2_Source_ID],[HepatitisB3_Dt],[HepatitisB3_ANM_ID]
,[HepatitisB3_ASHA_ID],[HepatitisB3_Source_ID],[Penta1_Dt],[Penta1_ANM_ID],[Penta1_ASHA_ID],[Penta1_Source_ID],[Penta2_Dt],[Penta2_ANM_ID]
,[Penta2_ASHA_ID],[Penta2_Source_ID],[Penta3_Dt],[Penta3_ANM_ID],[Penta3_ASHA_ID],[Penta3_Source_ID],[Measles1_Dt],[Measles1_ANM_ID],[Measles1_ASHA_ID]
,[Measles1_Source_ID],[Measles1_Breastfeeding],[Measles1_Complentary_Feeding],[Measles1_Complentary_Feeding_Month],[Measles1_Visit_Date]
,[Measles1_Child_Weight],[Measles1_Diarrhoea],[Measles1_ORS_Given],[Measles1_Pneumonia],[Measles1_Antibiotics_Given],[Measles2_Dt],[Measles2_ANM_ID]
,[Measles2_ASHA_ID],[Measles2_Source_ID],[JE1_Dt],[JE1_ANM_ID],[JE1_ASHA_ID],[JE1_Source_ID],[JE2_Dt],[JE2_ANM_ID],[JE2_ASHA_ID],[JE2_Source_ID]
,[VitA_Dose1_Dt],[VitA_Dose1_ANM_ID],[VitA_Dose1_ASHA_ID],[VitA_Dose1_Source_ID],[VitA_Dose2_Dt],[VitA_Dose2_ANM_ID],[VitA_Dose2_ASHA_ID]
,[VitA_Dose2_Source_ID],[VitA_Dose3_Dt],[VitA_Dose3_ANM_ID],[VitA_Dose3_ASHA_ID],[VitA_Dose3_Source_ID],[VitA_Dose4_Dt],[VitA_Dose4_ANM_ID]
,[VitA_Dose4_ASHA_ID],[VitA_Dose4_Source_ID],[VitA_Dose5_Dt],[VitA_Dose5_ANM_ID],[VitA_Dose5_ASHA_ID],[VitA_Dose5_Source_ID],[VitA_Dose6_Dt]
,[VitA_Dose6_ANM_ID],[VitA_Dose6_ASHA_ID],[VitA_Dose6_Source_ID],[VitA_Dose7_Dt],[VitA_Dose7_ANM_ID],[VitA_Dose7_ASHA_ID],[VitA_Dose7_Source_ID]
,[VitA_Dose8_Dt],[VitA_Dose8_ANM_ID],[VitA_Dose8_ASHA_ID],[VitA_Dose8_Source_ID],[VitA_Dose9_Dt],[VitA_Dose9_ANM_ID],[VitA_Dose9_ASHA_ID]
,[VitA_Dose9_Source_ID],[MMR_Dt],[MMR_ANM_ID],[MMR_ASHA_ID],[MMR_Source_ID],[MR_Dt],[MR_ANM_ID],[MR_ASHA_ID],[MR_Source_ID],[Typhoid_Dt]
,[Typhoid_ANM_ID],[Typhoid_ASHA_ID],[Typhoid_Source_ID],[Rota_Virus_Dt],[Rota_Virus_ANM_ID],[Rota_Virus_ASHA_ID],[Rota_Virus_Source_ID]
,[VitK_Dt],[VitK_ANM_ID],[VitK_ASHA_ID],[VitK_Source_ID],GETDATE() 
,[PNC1_No],[PNC1_Type_Infant],[PNC1_Date_Infant],[PNC1_DangerSign_Infant],[PNC1_ReferralFacility_Infant],[PNC1_ANM_ID_Infant],[PNC1_ASHA_ID_Infant]
,[PNC1_Created_by_Infant],[PNC1_Source_ID_Infant],[PNC1_Infant_Weight]
,[PNC2_No_Infant],[PNC2_Type_Infant],[PNC2_Date_Infant],[PNC2_DangerSign_Infant],[PNC2_ReferralFacility_Infant],[PNC2_ANM_ID_Infant],[PNC2_ASHA_ID_Infant]
,[PNC2_Created_by_Infant],[PNC2_Source_ID_Infant],[PNC2_Infant_Weight]
,[PNC3_No_Infant],[PNC3_Type_Infant],[PNC3_Date_Infant],[PNC3_DangerSign_Infant],[PNC3_ReferralFacility_Infant],[PNC3_ANM_ID_Infant],[PNC3_ASHA_ID_Infant]
,[PNC3_Created_by_Infant],[PNC3_Source_ID_Infant],[PNC3_Infant_Weight]
,[PNC4_No_Infant],[PNC4_Type_Infant],[PNC4_Date_Infant],[PNC4_DangerSign_Infant],[PNC4_ReferralFacility_Infant],[PNC4_ANM_ID_Infant],[PNC4_ASHA_ID_Infant]
,[PNC4_Created_by_Infant],[PNC4_Source_ID_Infant],[PNC4_Infant_Weight]
,[PNC5_No_Infant],[PNC5_Type_Infant],[PNC5_Date_Infant],[PNC5_DangerSign_Infant],[PNC5_ReferralFacility_Infant],[PNC5_ANM_ID_Infant],[PNC5_ASHA_ID_Infant]
,[PNC5_Created_by_Infant],[PNC5_Source_ID_Infant],[PNC5_Infant_Weight]
,[PNC6_No_Infant],[PNC6_Type_Infant],[PNC6_Date_Infant],[PNC6_DangerSign_Infant],[PNC6_ReferralFacility_Infant],[PNC6_ANM_ID_Infant],[PNC6_ASHA_ID_Infant]
,[PNC6_Created_by_Infant],[PNC6_Source_ID_Infant],[PNC6_Infant_Weight]
,[PNC7_No_Infant],[PNC7_Type_Infant],[PNC7_Date_Infant],[PNC7_DangerSign_Infant],[PNC7_ReferralFacility_Infant],[PNC7_ANM_ID_Infant],[PNC7_ASHA_ID_Infant]
,[PNC7_Created_by_Infant],[PNC7_Source_ID_Infant],[PNC7_Infant_Weight]
-----------------------New addition 291119
,Rota_Dose2_Dt ,Rota_Dose2_ANM_ID ,Rota_Dose2_ASHA_ID ,Rota_Dose2_Source_ID ,
Rota_Dose3_Dt ,Rota_Dose3_ANM_ID ,Rota_Dose3_ASHA_ID ,Rota_Dose3_Source_ID ,
IPV_Dose1_Dt ,IPV_Dose1_ANM_ID ,IPV_Dose1_ASHA_ID ,IPV_Dose1_Source_ID ,
IPV_Dose2_Dt ,IPV_Dose2_ANM_ID ,IPV_Dose2_ASHA_ID ,IPV_Dose2_Source_ID ,
IPV_Dose3_Dt ,IPV_Dose3_ANM_ID ,IPV_Dose3_ASHA_ID ,IPV_Dose3_Source_ID ,
PCV_Dose1_Dt ,PCV_Dose1_ANM_ID ,PCV_Dose1_ASHA_ID ,PCV_Dose1_Source_ID ,
PCV_Dose2_Dt ,PCV_Dose2_ANM_ID ,PCV_Dose2_ASHA_ID ,PCV_Dose2_Source_ID ,
PCV_DoseB_Dt ,PCV_DoseB_ANM_ID ,PCV_DoseB_ASHA_ID ,PCV_DoseB_Source_ID ,
MR1_Dt ,MR1_ANM_ID ,MR1_ASHA_ID ,MR1_Source_ID ,
MR1_Breastfeeding ,MR1_Complentary_Feeding ,MR1_Complentary_Feeding_Month ,MR1_Visit_Date ,
MR1_Child_Weight ,MR1_Diarrhoea ,MR1_ORS_Given ,MR1_Pneumonia ,MR1_Antibiotics_Given ,
Call_Ans ,Is_Phone_Correct , Is_Confirmed ,Validated_Callcentre
--------Mother_infant_detail
,Preterm_FullTerm,Baby_Cried,Resucitation_Done
,Defect_Seen_At_Birth,Breast_Feeding,Inj_Corticosteriods_Given
,Reffered_Higher_Facility,Defect_SeenAtBirth
---------------------------------------
,b.StateID,c.MDDS_Code,d.MDDS_Code,h.MDDS_Code,e.MDDS_Code,ANM_ID,ASHA_ID
from [t_child_flat] a
      inner join TBL_STATE b on a.StateID=b.StateID
      inner join TBL_DISTRICT c on a.District_ID=c.DIST_CD
      inner join TBL_TALUKA d on a.Taluka_ID=d.TAL_CD  and a.District_ID=d.DIST_CD
      inner join TBL_HEALTH_BLOCK e on a.HealthBlock_ID=e.BLOCK_CD
      inner join TBL_PHC f on a.PHC_ID=f.PHC_CD
      left outer join TBL_SUBPHC g on a.SubCentre_ID=g.SUBPHC_CD
      left outer join TBL_VILLAGE h on a.SubCentre_ID=h.SUBPHC_CD and a.Village_ID=h.VILLAGE_CD
      left outer join t_Ground_Staff i on a.ANM_ID=i.ID
      left outer join t_Ground_Staff j on a.ASHA_ID=j.ID
      
       where Convert(date,a.Exec_Date)=CONVERT(date,getdate())

end


