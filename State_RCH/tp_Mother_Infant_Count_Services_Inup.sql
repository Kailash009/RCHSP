USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Mother_Infant_Count_Services_Inup]    Script Date: 09/26/2024 14:50:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--select COUNT(*) from t_mother_Infant_Count_Service
--truncate table t_mother_Infant_Count_Service

ALTER procedure [dbo].[tp_Mother_Infant_Count_Services_Inup]
(@From_Date as date=null
,@To_Date as date=null)
as
begin

insert into t_mother_Infant_Count_Service
(
	   [State_Code]
      ,[District_Code]
      ,[Rural_Urban]
      ,[HealthBlock_Code]
      ,[Taluka_Code]
      ,[HealthFacility_Type]
      ,[HealthFacility_Code]
      ,[HealthSubFacility_Code]
      ,[Village_Code]
      ,[Financial_Yr]
      ,[Financial_Year]
      ,[Registration_no]
      ,[ID_No]
      ,[Case_No]
      ,[Inf_Health_Provider_Name]
      ,[Inf_Health_Provider_Code]
      ,[Inf_Health_Provider_IsFilled]
      ,[Inf_ASHA_Name]
      ,[Inf_ASHA_ID]
      ,[Inf_ASHA_IsFilled]
      ,[Inf_Term]
      ,[Inf_Term_Code]
      ,[Inf_Term_Full]
      ,[Inf_Term_Premature]
      ,[Inf_Term_IsFilled]
      ,[Inf_Sex]
      ,[Inf_Sex_Code]
      ,[Inf_Male]
      ,[Inf_Female]
      ,[Inf_Transgender]
      ,[Inf_Sex_IsFilled]
      ,[Inf_Baby_Cried_Immediately_At_Birth]
      ,[Inf_Baby_Cried_Immediately_At_Birth_code]
      ,[Inf_Baby_Cried_Immediately_At_Birth_Yes]
      ,[Inf_Baby_Cried_Immediately_At_Birth_No]
      ,[Inf_Baby_Cried_Immediately_At_Birth_IsFiled]
      ,[Inf_Resucitation_Done]
      ,[Inf_Resucitation_Done_Code]
      ,[Inf_Resucitation_Done_Yes]
      ,[Inf_Resucitation_Done_No]
      ,[Inf_Resucitation_Done_IsFilled]
      ,[Inf_Refer_to_higher_facility]
      ,[Inf_Refer_to_higher_facility_Code]
      ,[Inf_Refer_to_higher_facility_Yes]
      ,[Inf_Refer_to_higher_facility_No]
      ,[Inf_Refer_to_higher_facility_NotAvailable]
      ,[Inf_Refer_to_higher_facility_IsFilled]
      ,[Inf_Defect_Seen_At_Birth]
      ,[Inf_Defect_Seen_At_Birth_Code]
      ,[Inf_Defect_Seen_At_Birth_CleftLip_Cleftpalate]
      ,[Inf_Defect_Seen_At_Birth_Club_foot]
      ,[Inf_Defect_Seen_At_Birth_Downs_Syndrome]
      ,[Inf_Defect_Seen_At_Birth_Hydrocephalus]
      ,[Inf_Defect_Seen_At_Birth_Imperforate_anus]
      ,[Inf_Defect_Seen_At_Birth_Neural_tube_defect]
      ,[Inf_Defect_Seen_At_Birth_Nill]
      ,[Inf_Defect_Seen_At_Birth_Other]
      ,[Inf_Defect_Seen_At_Birth_NotAvailable]
      ,[Inf_Defect_Seen_At_Birth_IsFilled]
      ,[Inf_Weight_At_Birth]
      ,[Inf_Weight_At_Birth_IsFilled]
      ,[Inf_Breast_Feeding]
      ,[Inf_Breast_Feeding_Code]
      ,[Inf_Breast_Feeding_Yes]
      ,[Inf_Breast_Feeding_No]
      ,[Inf_Breast_Feeding_IsFilled]
      ,[Inf_OPV0_Dose_Date]
      ,[Inf_OPV0_Dose_Day]
      ,[Inf_OPV0_Dose_Month]
      ,[Inf_OPV0_Dose_Year]
      ,[Inf_OPV0_Dose_Date_IsFilled]
      ,[Inf_BCG_Dose_Date]
      ,[Inf_BCG_Dose_Day]
      ,[Inf_BCG_Dose_Month]
      ,[Inf_BCG_Dose_Year]
      ,[Inf_BCG_Dose_Date_IsFilled]
      ,[Inf_HEP0_Dose_Date]
      ,[Inf_HEP0_Dose_Day]
      ,[Inf_HEP0_Dose_Month]
      ,[Inf_HEP0_Dose_Year]
      ,[Inf_HEP0_Dose_Date_IsFilled]
      ,[Inf_VITK_Dose_Date]
      ,[Inf_VITK_Dose_Day]
      ,[Inf_VITK_Dose_Month]
      ,[Inf_VITK_Dose_Year]
      ,[Inf_VITK_Dose_Date_IsFilled]   --86
)
select
	   a.State_Code
      ,a.District_Code
      ,a.Rural_Urban
      ,a.HealthBlock_Code
      ,a.Taluka_Code
      ,a.HealthFacility_Type
      ,a.HealthFacility_Code
      ,a.HealthSubFacility_Code
      ,a.Village_Code
      ,a.Financial_Yr			--10
      ,a.Financial_Year
      ,a.Registration_no
      ,a.ID_No
      ,a.Case_no
      ,c.Name as ANM_Name
      ,a.ANM_ID
      ,(case a.ANM_ID when 0 then 0 else 1 end) as HealthProvider_IsFilled
      ,d.Name as ASHA_Name
      ,a.ASHA_ID								
      ,(case a.ASHA_ID when 0 then 0 else 1 end) as ASHA_IsFilled    ----20
      ,(case when a.Infant_Term='F' then 'Full Term' when a.Infant_Term='P' then 'Premature' end)as Infant_Term
      ,a.Infant_Term as Infant_Term_Code
      ,(case when a.Infant_Term='F' then 1 else 0 end)as Infant_Term_Full
      ,(case when a.Infant_Term='P' then 1 else 0 end)as Infant_Term_Premature
      ,(case when LEN(a.Infant_Term)>0 and a.Infant_Term is not null then 1 else 0 end)as Infant_Term_IsFilled
      ,(case when a.Gender_Infant='M' then 'Male' when a.Gender_Infant= 'F' then 'Female' when a.Gender_Infant= 'T' then 'Transgender' end) as Infant_Gender
      ,a.Gender_Infant
      ,(case when a.Gender_Infant='M' then 1 else 0 end)as Infant_Gender_Male
      ,(case when a.Gender_Infant='F' then 1 else 0 end)as Infant_Gender_Female
      ,(case when a.Gender_Infant='T' then 1 else 0 end)as Infant_Gender_Transgender
      ,(case when LEN(a.Gender_Infant)>0 and a.Gender_Infant>'0' and a.Gender_Infant is not null then 1 else 0 end)as Infant_Gender_IsFilled
      ,(case when a.Baby_Cried_Immediately_At_Birth='Y' then 'Yes' when a.Baby_Cried_Immediately_At_Birth='N' then 'Not' end)as Baby_Cried_Immediately_At_Birth
      ,a.Baby_Cried_Immediately_At_Birth as Baby_Cried_Immediately_At_Birth_Code
      ,(case when a.Baby_Cried_Immediately_At_Birth='Y' then 1 else 0 end)Baby_Cried_Immediately_At_Birth_Yes
      ,(case when a.Baby_Cried_Immediately_At_Birth='N' then 1 else 0 end)Baby_Cried_Immediately_At_Birth_NO
      ,(case when (LEN(a.Baby_Cried_Immediately_At_Birth)>0) and a.Baby_Cried_Immediately_At_Birth>'0' and a.Baby_Cried_Immediately_At_Birth is not null then 1 else 0 end)Baby_Cried_Immediately_At_Birth_IsFilled
      ,(case when a.Resucitation_Done='Y' then 'Yes' when a.Resucitation_Done ='N' then 'No' end)as Resucitation_Done
      ,a.Resucitation_Done as Resucitation_Done_Code
      ,(case when a.Resucitation_Done='Y' then 1 else 0 end)as Resucitation_Done_Yes
      ,(case when a.Resucitation_Done='N' then 1 else 0 end)as Resucitation_Done_No
      ,(case when (LEN(a.Resucitation_Done)>0) and a.Resucitation_Done>'0' and a.Resucitation_Done is not null then 1 else 0 end)Resucitation_Done_IsFilled
      ,(case when a.Higher_Facility='Y' then 'Yes' when a.Higher_Facility='N' then 'No' end)as Higher_Facility
      ,a.Higher_Facility as Higher_Facility_Code
      ,(case when a.Higher_Facility='Y' then 1 else 0 end)as Higher_Facility_Yes
      ,(case when a.Higher_Facility='N' then 1 else 0 end)as Higher_Facility_No
      ,(case when a.Higher_Facility='Na' then 1 else 0 end)as Higher_Facility_NotAvailable
      ,(case when (LEN(a.Higher_Facility)>0) and a.Higher_Facility>'0' and a.Higher_Facility is not null then 1 else 0 end)as Higher_Facility_IsFilled
      ,(case when a.Any_Defect_Seen_At_Birth=1 then 'CleftLip Cleftpalate' when a.Any_Defect_Seen_At_Birth=2 then 'Club foot'
			when a.Any_Defect_Seen_At_Birth=3 then 'Downs Syndrome' when a.Any_Defect_Seen_At_Birth=4 then 'Hydrocephalus'
			when a.Any_Defect_Seen_At_Birth=5 then 'Imperforate anus' when a.Any_Defect_Seen_At_Birth=6 then 'Neural tube defect'
			when a.Any_Defect_Seen_At_Birth=7 then 'Nill' when a.Any_Defect_Seen_At_Birth=99 then 'Other'
			when a.Any_Defect_Seen_At_Birth=100 then 'Not Available' end)Any_Defect_Seen_At_Birth
      ,a.Any_Defect_Seen_At_Birth as Any_Defect_Seen_At_Birth_Code
      ,(case when a.Any_Defect_Seen_At_Birth=1 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_Cleftpalate
      ,(case when a.Any_Defect_Seen_At_Birth=2 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_ClubFoot
      ,(case when a.Any_Defect_Seen_At_Birth=3 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_DownsSyndrome
      ,(case when a.Any_Defect_Seen_At_Birth=4 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_Hydrocephalus
      ,(case when a.Any_Defect_Seen_At_Birth=5 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_ImperforateAnus
      ,(case when a.Any_Defect_Seen_At_Birth=6 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_NeuralTubeDefect
      ,(case when a.Any_Defect_Seen_At_Birth=7 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_Nill
      ,(case when a.Any_Defect_Seen_At_Birth=99 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_Other
      ,(case when a.Any_Defect_Seen_At_Birth=100 then 1 else 0 end)as Any_Defect_Seen_At_Birth_CleftLip_NotAvailable
      ,(case when (LEN(a.Any_Defect_Seen_At_Birth)>0) and a.Any_Defect_Seen_At_Birth>0 and a.Any_Defect_Seen_At_Birth IS NOT NULL then 1 else 0 end)as Any_Defect_Seen_At_Birth_IsFilled
      ,a.Weight
      ,(case when (LEN(a.Weight)>0) and a.Weight>0 and a.Weight IS NOT NULL then 1 else 0 end)as Weight_IsFilled
      ,(case when a.Breast_Feeding=1 then 'Yes' when a.Breast_Feeding=0 then 'No' end) as Breast_Feeding
      ,a.Breast_Feeding as Breast_Feeding_Code
      ,(case when a.Breast_Feeding=1 then 1 else 0 end)as Breast_Feeding_Yes
      ,(case when a.Breast_Feeding=0 then 1 else 0 end)as Breast_Feeding_No
      ,(case when (LEN(a.Breast_Feeding)>0) and a.Breast_Feeding IS NOT NULL then 1 else 0 end)as Breast_Feeding_IsFilled
      ,a.OPV_Date
      ,DAY(a.OPV_Date)as OPV_Day
      ,MONTH(a.OPV_Date)as OPV_Month
      ,YEAR(a.OPV_Date)as OPV_Year
      ,(case when (LEN(a.OPV_Date)>0 and a.OPV_Date is not null)then 1 else 0 end)as OPV_Date_IsFilled
      ,a.BCG_Date
      ,DAY(a.BCG_Date)as BCG_Day
      ,MONTH(a.BCG_Date)as BCG_Month
      ,YEAR(a.BCG_Date)as BCG_Year
      ,(case when (LEN(a.BCG_Date)>0 and a.BCG_Date is not null)then 1 else 0 end)as BCG_Date_IsFilled
      ,a.HEP_B_Date
      ,DAY(a.HEP_B_Date)as HEP0_Day
      ,MONTH(a.HEP_B_Date)as HEP0_Month
      ,YEAR(a.HEP_B_Date)as HEP0_Year
      ,(case when (LEN(a.HEP_B_Date)>0 and a.HEP_B_Date is not null)then 1 else 0 end)as HEP0_Date_IsFilled
      ,a.Vit_K_Date
      ,DAY(a.Vit_K_Date)as VITK_Day
      ,MONTH(a.Vit_K_Date)as VITK_Month
      ,YEAR(a.Vit_K_Date)as VITK_Year
      ,(case when (LEN(a.Vit_K_Date)>0 and a.Vit_K_Date is not null)then 1 else 0 end)as VITK_Date_IsFilled
      
	from t_mother_infant a
	left outer join t_Ground_Staff c on a.ANM_ID=c.ID
	left outer join t_Ground_Staff d on a.ASHA_ID=d.ID
	end
	                                                                                                                               

                                                                                                         



