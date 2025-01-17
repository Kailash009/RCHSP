USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Mother_PNC_Count_Services_Inup]    Script Date: 09/26/2024 14:50:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--  select COUNT(*) from t_mother_PNC_Count_Service
--  truncate table t_mother_PNC_Count_Service
--  select * from t_mother_PNC_Count_Service
ALTER procedure [dbo].[tp_Mother_PNC_Count_Services_Inup]
(@From_Date as date=null
,@To_Date as date=null)
as
begin

insert into t_mother_PNC_Count_Service
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
      ,[PNC_Health_Provider_Name]
      ,[PNC_Health_Provider_Code]
      ,[PNC_Health_Provider_IsFilled]
      ,[PNC_ASHA_Name]
      ,[PNC_ASHA_ID]
      ,[PNC_ASHA_IsFilled]
      ,[PNC_No]
      ,[PNC_Period]
      ,[PNC_Period_Code]
      ,[PNC_Period_1stDay]
      ,[PNC_Period_3rdDay]
      ,[PNC_Period_7thDay]
      ,[PNC_Period_14thDay]
      ,[PNC_Period_21stDay]
      ,[PNC_Period_28thDay]
      ,[PNC_Period_42ndDay]
      ,[PNC_Period_IsFilled]
      ,[PNC_Date]
      ,[PNC_Day]
      ,[PNC_Month]
      ,[PNC_Year]
      ,[PNC_Date_IsFilled]
      ,[PNC_No_of_IFA_Tabs_given_to_mother]
      ,[PNC_No_of_IFA_Tabs_given_to_mother_IsFilled]
      ,[PNC_PPC_Method]
      ,[PNC_PPC_Method_Code]
      ,[PNC_PPC_Method_POST_PARTUM_IUCD]
      ,[PNC_PPC_Method_CONDOM]
      ,[PNC_PPC_Method_MALE_STERILIZATION]
      ,[PNC_PPC_Method_POST_PARTUM_STERILIZATION]
      ,[PNC_PPC_Method_NONE]
      ,[PNC_PPC_Method_OTHER_SPECIFY]
      ,[PNC_PPC_Method_IsFilled]
      ,[PNC_PPC_Method_OTHER_Name]
      ,[PNC_PPC_Method_OTHER_Name_IsFilled]
      ,[PNC_Mother_Danger_Sign]
      ,[PNC_Mother_Danger_Sign_Code]
      ,[PNC_Mother_Danger_Sign_PPH]
      ,[PNC_Mother_Danger_Sign_Fever]
      ,[PNC_Mother_Danger_Sign_Sepsis]
      ,[PNC_Mother_Danger_Sign_Severe_Abdominal_Pain]
      ,[PNC_Mother_Danger_Sign_Severe_Headache_Blurred_Vision]
      ,[PNC_Mother_Danger_Sign_Difficult_Breathing]
      ,[PNC_Mother_Danger_Sign_Fever_Chills]
      ,[PNC_Mother_Danger_Sign_Other_Specify]
      ,[PNC_Mother_Danger_Sign_Nill]
      ,[PNC_Mother_Danger_Sign_IsFilled]
      ,[PNC_Mother_Referral_Facility]
      ,[PNC_Mother_Referral_Facility_Code]
      ,[PNC_Mother_Referral_Facility_PHC]
      ,[PNC_Mother_Referral_Facility_CHC]
      ,[PNC_Mother_Referral_Facility_DH]
      ,[PNC_Mother_Referral_Facility_Private_Hospital]
      ,[PNC_Mother_Referral_Facility_Other]
      ,[PNC_Mother_Referral_Facility_IsFilled]
      ,[PNC_Mother_Referral_Place_Other_Name]
      ,[PNC_Mother_Referral_Place_Other_Name_IsFilled]
      ,[PNC_Mother_Referral_Place_Other_Name_IsNotFilled]
      ,[PNC_Mother_Referral_Place_Code]
      ,[PNC_Mother_Referral_Place_Code_IsFilled]
      ,[PNC_Mother_Referral_Place_Code_IsNotFilled]
      ,[PNC_Mother_Death]
      ,[PNC_MohterDeath_Yes]
      ,[PNC_MotherDeath_No]
      ,[PNC_Mother_Death_IsFilled]
      ,[PNC_MotherDeath_Date]
      ,[PNC_MotherDeath_Day]
      ,[PNC_MotherDeath_Month]
      ,[PNC_MotherDeath_year]
      ,[PNC_MotherDeath_Date_IsFilled]
      ,[PNC_MotherDeath_Reason]
      ,[PNC_MotherDeath_Reason_Code]
      ,[PNC_MotherDeath_Reason_Eclampcia]
      ,[PNC_MotherDeath_Reason_Haemorrahge_pph]
      ,[PNC_MotherDeath_Reason_Anaemia]
      ,[PNC_MotherDeath_Reason_High_Fever]
      ,[PNC_MotherDeath_Reason_Other_Specify]
      ,[PNC_MotherDeath_Reason_IsFilled]
      ,[PNC_MotherDeath_Reason_Other_Name]
      ,[PNC_MotherDeath_Reason_Other_Name_IsFilled]
      ,[PNC_MotherDeath_Place]
      ,[PNC_MotherDeath_Place_Code]
      ,[PNC_MotherDeath_Place_Home]
      ,[PNC_MotherDeath_Place_Hospital]
      ,[PNC_MotherDeath_Place_Transit]
      ,[PNC_MotherDeath_Place_IsFilled]
      ,[PNC_Mother_Remark]
      ,[PNC_Mother_Remark_IsFilled]
      ,[PNC_DONE]
      ,PNC_delivered_Place_Code
      ,PNC_DateDiff_Delivery_PNC
	 )	  
select 
	   del.State_Code
      ,del.District_Code
      ,del.Rural_Urban
      ,del.HealthBlock_Code
      ,del.Taluka_Code
      ,del.HealthFacility_Type
      ,del.HealthFacility_Code
      ,del.HealthSubFacility_Code
      ,del.Village_Code
      ,del.Financial_Yr			--10
      ,del.Financial_Year
      ,del.Registration_no
      ,del.ID_No
      ,del.Case_no
      ,c.Name as ANM_Name
      ,a.ANM_ID
      ,(case  when a.ANM_ID<>0 then 1 else 0 end) as HealthProvider_IsFilled
      ,d.Name as ASHA_Name
      ,a.ASHA_ID								
      ,(case when a.ASHA_ID<>0 then 1 else 0 end) as ASHA_IsFilled    ----20
      ,a.PNC_No
      ,(case when a.PNC_Type=1 then '1st Day' when a.PNC_Type=2 then '3rd Day' when a.PNC_Type=3 then '7th Day' 
			 when a.PNC_Type=4 then '14th Day' when a.PNC_Type=5 then '21st Day' when a.PNC_Type=6 then '28th Day'
			 when a.PNC_Type=7 then '42th Day' end)as PNC_Period_Type
      ,a.PNC_Type
      ,(case when a.PNC_Type=1 then 1 else 0 end)as PNC_Period_1stDay
      ,(case when a.PNC_Type=2 then 1 else 0 end)as PNC_Period_3rdDay
      ,(case when a.PNC_Type=3 then 1 else 0 end)as PNC_Period_7thDay
      ,(case when a.PNC_Type=4 then 1 else 0 end)as PNC_Period_14thDay
      ,(case when a.PNC_Type=5 then 1 else 0 end)as PNC_Period_21thDay
      ,(case when a.PNC_Type=6 then 1 else 0 end)as PNC_Period_28thDay
      ,(case when a.PNC_Type=7 then 1 else 0 end)as PNC_Period_42ndDay
      ,(case when (LEN(a.PNC_Type)>0 and a.PNC_Type>0 and a.PNC_Type is not null) then 1 else 0 end)as PNC_Period_IsFilled
      ,a.PNC_Date
      ,DAY(a.PNC_Date)as PNC_Day
      ,MONTH(a.PNC_Date)as PNC_Month
      ,YEAR(a.PNC_Date)as PNC_Year
      ,(case when (LEN(a.PNC_Date)>0 and a.PNC_Date is not null)then 1 else 0 end)as PNC_Date_IsFilled
      ,a.No_of_IFA_Tabs_given_to_mother
      ,(case when (LEN(a.No_of_IFA_Tabs_given_to_mother)>0 and a.No_of_IFA_Tabs_given_to_mother>0 and a.No_of_IFA_Tabs_given_to_mother is not null)then 1 else 0 end)as NoOf_IFA_Tabs
      ,(case when a.PPC='A' then 'POST- PARTUM IUCD (PPIUCD-WITHIN 48 HR OF DELIVERY)' when a.PPC='B' then 'CONDOM' 
			 when a.PPC='C' then 'MALE  STERILIZATION' when a.PPC='D' then 'POST PARTUM STERILIZATION (PPS-WITHIN 7 DAYS OF DELIVERY)'
			 when a.PPC='E' then 'NONE' when a.PPC='F' then 'ANY OTHER SPECIFY' end)as PPC_Method_Name
      ,a.PPC as PPC_Method_Code
      ,(case when a.PPC='A' then 1 else 0 end)as POST_PARTUM_IUCD
      ,(case when a.PPC='B' then 1 else 0 end)as POST_PARTUM_Condom
      ,(case when a.PPC='C' then 1 else 0 end)as POST_PARTUM_MALE_STERILIZATION
      ,(case when a.PPC='D' then 1 else 0 end)as POST_PARTUM_POST_PARTUM_STERILIZATION
      ,(case when a.PPC='E' then 1 else 0 end)as POST_PARTUM_None
      ,(case when a.PPC='F' then 1 else 0 end)as POST_PARTUM_OTHER_SPECIFY
      ,(case when LEN(a.PPC)>0 and a.PPC>'0' and a.PPC Is Not Null then 1 else 0 end)as PPC_IsFilled
      ,a.OtherPPC_Method
      ,(case when (LEN(a.OtherPPC_Method)>0 and a.OtherPPC_Method is not null)then 1 else 0 end)as OtherPPC_Method_IsFilled
      ,[dbo].[Get_Mother_Danger_Sign_Name](a.DangerSign_Mother) as Mother_Danger_Sign_Name
      ,a.DangerSign_Mother
      ,(case when a.DangerSign_Mother like '%A%' then 1 else 0 end)AS Danger_Sign_PPH
      ,(case when a.DangerSign_Mother like '%B%' then 1 else 0 end)AS Danger_Sign_Fever
      ,(case when a.DangerSign_Mother like '%C%' then 1 else 0 end)AS Danger_Sign_Sepsis
      ,(case when a.DangerSign_Mother like '%D%' then 1 else 0 end)AS Danger_Sign_Severe_Abdominal_Pain
      ,(case when a.DangerSign_Mother like '%E%' then 1 else 0 end)AS Danger_Sign_Severe_Headache_Blurred_Vision
      ,(case when a.DangerSign_Mother like '%F%' then 1 else 0 end)AS Danger_Sign_Difficult_Breathing
      ,(case when a.DangerSign_Mother like '%G%' then 1 else 0 end)AS Danger_Sign_Fever_Chills
      ,(case when a.DangerSign_Mother like '%H%' then 1 else 0 end)AS Danger_Sign_Other_Specify
      ,(case when a.DangerSign_Mother like '%I%' then 1 else 0 end)AS Danger_Sign_Any_Nil
      ,(case when (LEN(a.DangerSign_Mother)>0 and a.DangerSign_Mother>'0' and a.DangerSign_Mother is not null)then 1 else 0 end)as Danger_Sign_IsFilled
      ,(case when a.ReferralFacility_Mother=1 then 'PHC' when a.ReferralFacility_Mother=2 then 'CHC'
			 when a.ReferralFacility_Mother=5 then 'District Hospital' when a.ReferralFacility_Mother=21 then 'Other Private Hospital'
			 when a.ReferralFacilityID_Mother=99 then 'Other' end)as Mother_ReferralFacility
	  ,a.ReferralFacility_Mother
	  ,(case when a.ReferralFacility_Mother=1 then 1 else 0 end)as ReferralFacility_PPC
      ,(case when a.ReferralFacility_Mother=2 then 1 else 0 end)as ReferralFacility_CHC
      ,(case when a.ReferralFacility_Mother=5 then 1 else 0 end)as ReferralFacility_District_Hospital
      ,(case when a.ReferralFacility_Mother=21 then 1 else 0 end)as ReferralFacility_Private_Hospital
      ,(case when a.ReferralFacility_Mother=99 then 1 else 0 end)as ReferralFacility_Other
      ,(case when (LEN(a.ReferralFacility_Mother)>0 and a.ReferralFacility_Mother>0 and a.ReferralFacility_Mother IS NOT NULL) then 1 else 0 end)as ReferralFacility_IsFilled
      ,a.ReferralLoationOther_Mother
      ,(case when (LEN(a.ReferralLoationOther_Mother)>0 and a.ReferralLoationOther_Mother IS NOT NULL)then 1 else 0 end)as Mother_Referral_Place_Other_Name_IsFilled
      ,(case when a.Registration_no IS null then null when (LEN(a.ReferralLoationOther_Mother)=0 or a.ReferralLoationOther_Mother IS NULL)then 1 else 0 end)as Mother_Referral_Place_Other_Name_IsNotFilled
      ,a.ReferralFacilityID_Mother
      ,(case when (LEN(a.ReferralFacilityID_Mother)>0 and a.ReferralFacilityID_Mother>0 and a.ReferralFacilityID_Mother IS NOT NULL)then 1 else 0 end)as ReferralFacilityID_Mother_IsFilled
      ,(case when a.Registration_no IS null then null when (LEN(a.ReferralFacilityID_Mother)=0 or a.ReferralFacilityID_Mother=0 or a.ReferralFacilityID_Mother IS NULL)then 1 else 0 end)as ReferralFacilityID_Mother_IsNotFilled
      ,(case when a.Mother_Death=1 then 'Yes' when a.Mother_Death=0 then 'No' end)as Mother_Death
      ,(case when a.Mother_Death=1 then 1 else 0 end)as Mother_Death_Yes
      ,(case when a.Mother_Death=0 then 1 else 0 end)as Mother_Death_No
      ,(case when (LEN(a.Mother_Death)>0 and a.Mother_Death is not null )then 1 else 0 end)as Mother_Death_IsFilled
      ,a.Mother_Death_Date
      ,DAY(a.Mother_Death_Date)as Mother_Death_Day
      ,MONTH(a.Mother_Death_Date)as Mother_Death_Month
      ,YEAR(a.Mother_Death_Date)as Mother_Death_Year
      ,(case when (LEN(a.Mother_Death_Date)>0 and a.Mother_Death_Date IS NOT NULL)then 1 else 0 end)as Mother_Death_Date_IsFilled
      
      
      
      ,[dbo].[Get_MotherDeathReason_Name](a.DangerSign_Mother) as Mother_Death_Reason_Name
      ,a.Mother_Death_Reason
      ,(case when a.Mother_Death_Reason like '%A%' then 1 else 0 end)as Death_Reason_Eclampcia
      ,(case when a.Mother_Death_Reason like '%B%' then 1 else 0 end)as Death_Reason_Haemorrahge_pph
      ,(case when a.Mother_Death_Reason like '%C%' then 1 else 0 end)as Death_Reason_Anaemia
      ,(case when a.Mother_Death_Reason like '%D%' then 1 else 0 end)as Death_Reason_High_Fever
      ,(case when a.Mother_Death_Reason like '%E%' then 1 else 0 end)as Death_Reason_Other_Specify
      ,(case when (LEN(a.Mother_Death_Reason)>0 and a.Mother_Death_Reason>'0' and a.Mother_Death_Reason IS NOT NULL)then 1 else 0 end)as Death_Reason_IsFilled
      ,a.Mother_Death_Reason_Other
      ,(case when (LEN(a.Mother_Death_Reason_Other)>0 and a.Mother_Death_Reason_Other IS NOT NULL)then 1 else 0 end)as Death_Reason_Other_Name_IsFilled
      ,(case when a.Place_of_death=1 then 'Home' when a.Place_of_death=2 then 'Hospital' when a.Place_of_death=3 then 'Transit' end)as Mother_Place_Death
      ,a.Place_of_death as Mother_Place_Death_Code
      ,(case when a.Place_of_death=1 then 1 else 0 end)as Mother_Place_Death_Home
      ,(case when a.Place_of_death=2 then 1 else 0 end)as Mother_Place_Death_Hospital
      ,(case when a.Place_of_death=3 then 1 else 0 end)as Mother_Place_Death_transit
      ,(case when (LEN(a.Place_of_death)>0 and a.Place_of_death>0 and a.Place_of_death IS NOT NULL)then 1 else 0 end)as Mother_Place_Death_IsFilled
      ,a.Remarks
      ,(case when (LEN(a.Remarks)>0 and a.Remarks IS NOT NULL)then 1 else 0 end) Mother_Remarks_IsFilled
      ,(case when a.Registration_no IS not null then 1 else 0 end) as PNC_DONE
      ,del.Delivery_Place as PNC_delivered_Place_Code
      ,(case when a.Registration_no IS null then null else datediff(day,del.Delivery_date,a.PNC_Date) end) as PNC_DateDiff_Delivery_PNC
  from t_mother_delivery del
  left outer join t_mother_pnc a on del.Registration_no=a.Registration_no
left outer join t_Ground_Staff c on a.ANM_ID=c.ID
left outer join t_Ground_Staff d on a.ASHA_ID=d.ID

end


--select Delivery_Place from t_mother_delivery 
--alter table t_mother_PNC_Count_Service add PNC_DateDiff_Delivery_PNC smallint
-- select * from t_mother_PNC_Count_Service where PNC_DONE is not null

--select * from t_mother_delivery where Registration_no  in (select Registration_no from t_mother_pnc where Registration_no=127000000038)
                                                                                                                              

                                                                



