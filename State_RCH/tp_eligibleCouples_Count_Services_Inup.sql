USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligibleCouples_Count_Services_Inup]    Script Date: 09/26/2024 15:53:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--select COUNT(*) from t_eligibleCouples_Count_Services
--truncate table t_eligibleCouples_Count_Services
 --alter table t_eligibleCouples_Count_Services add PW_Aadhaar_no_IsNotFilled bit,
 -- alter table t_eligibleCouples_Count_Services add PW_AccNo_IsNotFilled bit,
 -- alter table t_eligibleCouples_Count_Services add Mobile_no_IsNotFilled bit,

ALTER PROCEDURE [dbo].[tp_eligibleCouples_Count_Services_Inup]
(@From_Date as date=null
,@To_Date as date=null)
as
begin

insert into t_eligibleCouples_Count_Services
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
      ,[Registration_no]
      ,[ID_No]
      ,[Register_srno]
      ,[Register_srno_Filled]
      ,[Date_regis]
      ,[Registration_Day]
      ,[Registration_Month]
      ,[Registration_Year]
      ,[Financial_Yr]
      ,[Financial_Year]
      ,[HealthProviderName]
      ,[HealthProviderCode]
      ,[HealthProvider_IsFilled]
      ,[AshaName]
      ,[AshaCode]
      ,[Asha_IsFilled]
      ,[Name_wife]
      ,[Name_wife_IsFilled]
      ,[Name_husband]
      ,[Name_husband_IsFilled]
      ,[Whose_mobile_Name]
      ,[Whose_mobile]
      ,[Whose_mobile_Wife]
      ,[Whose_mobile_Husband]
      ,[Whose_mobile_Neigbour]
      ,[Whose_mobile_Relative]
      ,[Whose_mobile_Other]
      ,[Mobile_no]
      ,[Mobile_no_IsFilled]
      ,[Mobile_no_IsNotFilled]
      ,[Landline_no]
      ,[Landline_no_IsFilled]
      ,[Address]
      ,[Address_IsFilled]
      ,[Wife_current_age]
      ,[Wife_Cureent_age_LessThen_19]
      ,[Wife_Cureent_age_20_To_24]
      ,[Wife_Cureent_age_25_To_29]
      ,[Wife_Cureent_age_30_To_34]
      ,[Wife_Cureent_age_35_To_39]
      ,[Wife_Cureent_age_40_To_44]
      ,[Wife_Cureent_age_45_To_49]
      ,[Wife_marry_age]
      ,[Wife_marry_age_IsFilled]
      ,[Hus_current_age]
      ,[Hus_marry_age]
      ,[Hus_marry_age_IsFilled]
      ,[PW_Enrollment_No]
      ,[PW_Enrollment_No_IsFilled]
      ,[PW_Enrollment_Date]
      ,[PW_Enrollment_Day]
      ,[PW_Enrollment_Month]
      ,[PW_Enrollment_Year]
      ,[PW_Aadhaar_no]
      ,[PW_Aadhaar_no_IsFilled]
      ,[PW_Aadhaar_no_IsNotFilled]
      ,[PW_AadhaarLinked_Code]
      ,[PW_AadhaarLinked_Yes]
      ,[PW_AadhaarLinked_No]
      ,[PW_AadhaarLinked_IsFilled]
      ,[PW_AadhaarLinked_NotFilled]
      ,[PW_Bank_Name]
      ,[PW_BankID]
      ,[PW_Bank_IsFilled]
      ,[PW_AccNo]
      ,[PW_AccNo_IsFilled]
      ,[PW_AccNo_IsNotFilled]
      ,[PW_BranchName]
      ,[PW_BranchName_IsFilled]
      ,[PW_IFSCCode]
      ,[PW_IFSCCode_IsFilled]
      ,[HusbandAadhaar_no]
      ,[HusbandAadhaar_IsFilled]
      ,[Husband_AadhaarLinked_Code]
      ,[Husband_AadhaarLinked_Yes]
      ,[Husband_AadhaarLinked_No]
      ,[Husband_AadhaarLinked_IsFilled]
      ,[Husband_AadhaarLinked_NotFilled]
      ,[Husband_Bank_Name]
      ,[Husband_BankID]
      ,[Husband_Bank_IsFilled]
      ,[Husband_AccNo]
      ,[Husband_AccNo_IsFilled]
      ,[Husband_BranchName]
      ,[Husband_BranchName_IsFilled]
      ,[Husband_IFSCCode]
      ,[Husband_IFSCCode_IsFilled]
      ,[Religion_Name]
      ,[Religion_Code]
      ,[Religion_IsFilled]
      ,[Religion_Buddism]
      ,[Religion_Christianity]
      ,[Religion_Hinduism]
      ,[Religion_Islam]
      ,[Religion_Jainism]
      ,[Religion_Sikhism]
      ,[Religion_Other]
      ,[Religion_NotFilled]
      ,[Cast_Name]
      ,[Cast_Code]
      ,[Caste_IsFilled]
      ,[Cast_SC]
      ,[Cast_ST]
      ,[Cast_Other]
      ,[Caste_NotFilled]
      ,[IdType_Name]
      ,[IdType_Code]
      ,[IdType_IsFilled]
      ,[IdType_DrivingLicence]
      ,[IdType_PanCard]
      ,[IdType_Passport]
      ,[IdType_RationCard]
      ,[IdType_VoterIdCard]
      ,[IdType_NotFilled]
      ,[Identity_number]
      ,[Identity_number_IsFilled]
      ,[BPL_APL]
      ,[Economic_status_BPL]
      ,[Economic_status_APL]
      ,[Economic_status_Not_Known]
      ,[Economic_status_IsFilled]
      ,[Economic_status_NotFilled]
      ,[Male_child_born]
      ,[Male_child_born_IsFilled]
      ,[Male_child_born_NotFilled]
      ,[Female_child_born]
      ,[Female_child_born_IsFilled]
      ,[Female_child_born_NotFilled]
      ,[Male_child_live]
      ,[Male_child_live_IsFilled]
      ,[Male_child_live_NotFilled]
      ,[Female_child_live]
      ,[Female_child_live_IsFilled]
      ,[Female_child_live_NotFilled]
      ,[Young_child_age_Month]
      ,[Young_child_age_Year]
      ,[Young_child_age_Month_IsFilled]
      ,[Young_child_age_Month_NotFilled]
      ,[Young_child_age_Year_IsFilled]
      ,[Young_child_age_Year_NotFilled]
      ,[Young_child_Sex]
      ,[Young_Child_Sex_Male]   --145
      ,[Young_Child_Sex_Female]
      ,[Young_Child_Sex_Transgender]
      ,[Young_Child_Sex_NotFilled]
      ,[Young_Child_Sex_IsFilled]
      ,[Infertility_status]
      ,[Infertility_status_Yes]
      ,[Infertility_status_NO]
      ,[Infertility_FRU_Code]
      ,[Infertility_DH_Code]
      ,[Infertility_OTHER_Code]
      ,[Infertility_Reffer]
      ,[Infertility_Reffer_DH_Code]
      ,[Infertility_Reffer_DH_Code_Isfilled]
      ,[Infertility_Reffer_DH_Code_Notfilled]
      ,[Infertility_Reffer_IsFilled]
      ,[Infertility_Reffer_NotFilled]
      ,[Case_no]--162
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
      ,a.Registration_no
      ,a.ID_No
      ,a.Register_srno
      --,(case isnull(a.Register_srno,0) when 0 then 0 else 1 end) as Register_srno_IsFilled
      ,(case when (LEN(a.Register_srno)>0 and a.Register_srno>0 and a.Register_srno IS NOT NULL)then 1 else 0 end) as Register_srno_IsFilled
      ,a.Date_regis 
      ,DAY(a.Date_regis) as Registration_Day
      ,MONTH(a.Date_regis) as Registration_Month
      ,YEAR(a.Date_regis) as Registration_Year
      ,a.Financial_Yr
      ,a.Financial_Year
      ,g.Name
      ,a.ANM_ID
      ,(case when(LEN(a.ANM_ID)>0 and a.ANM_ID>0 and a.ANM_ID is not null)then 1 else 0 end) as HealthProvider_IsFilled
      ,h.Name
      ,a.ASHA_ID
      ,(case when (LEN(a.ASHA_ID)>0 and a.ASHA_ID>0 and a.ASHA_ID is not null)then 1 else 0 end) as ASHA_IsFilled
      ,a.Name_wife
      ,(case when (LEN(a.Name_wife)>0 and a.Name_wife IS NOT NULL)then 1 else 0 end) as Name_wife_IsFilled
      ,a.Name_husband
      ,(case when (LEN(a.Name_husband)>0 and a.Name_husband is not null) then 1 else 0 end) as Name_husband_IsFilled
     ,(case when a.Whose_mobile = 'W' then 'Wife' 
		when a.Whose_mobile = 'H' then 'Husband'
		when a.Whose_mobile = 'N' then 'Neighbour'
		when a.Whose_mobile = 'R' then 'Relative'
		when a.Whose_mobile = 'O' then 'Others'
		end)AS Whose_mobile_Name
      ,a.Whose_mobile
      ,(case a.Whose_mobile when 'W' then 1 else 0 end) as Whose_mobile_Wife
      ,(case a.Whose_mobile when 'H' then 1 else 0 end) as Whose_mobile_Husband
      ,(case a.Whose_mobile when 'N' then 1 else 0 end) as Whose_mobile_Neigbour
      ,(case a.Whose_mobile when 'R' then 1 else 0 end) as Whose_mobile_Relative
      ,(case a.Whose_mobile when 'O' then 1 else 0 end) as Whose_mobile_Other
      ,a.Mobile_no
      ,(case when (LEN(a.Mobile_no)>0 and a.Mobile_no IS NOT NULL)then 1 else 0 end) as Mobile_no_IsFilled
      ,(case when (LEN(a.Mobile_no)=0 or a.Mobile_no IS NULL)then 1 else 0 end) as Mobile_no_IsNotFilled
      ,a.Landline_no
      ,(case when (LEN(a.Landline_no)>0 and a.Landline_no IS NOT NULL)then 1 else 0 end) as Landline_no_IsFilled
      ,a.Address
      ,(case when (LEN(a.Address)>0 and a.Address IS NOT NULL)then 1 else 0 end) as Address_IsFilled
	  ,a.Wife_current_age
	  ,(case when a.Wife_current_age < 19 then 1 else 0 end)as Wife_Cureent_age_LessThen_19
	  ,(case when a.Wife_current_age between 20 and 24 then 1 else 0 end)as Wife_Cureent_age_20_To_24
	  ,(case when a.Wife_current_age between 25 and 29 then 1 else 0 end)as Wife_Cureent_age_25_To_29
	  ,(case when a.Wife_current_age between 30 and 34 then 1 else 0 end)as Wife_Cureent_age_30_To_34
	  ,(case when a.Wife_current_age between 35 and 39 then 1 else 0 end)as Wife_Cureent_age_35_To_39
	  ,(case when a.Wife_current_age between 40 and 44 then 1 else 0 end)as Wife_Cureent_age_40_To_44
	  ,(case when a.Wife_current_age between 45 and 49 then 1 else 0 end)as Wife_Cureent_age_45_To_49
	  ,a.Wife_marry_age
	  ,(case when (LEN(a.Wife_marry_age)>0 and a.Wife_marry_age>0 and a.Wife_current_age IS NOT NULL)then 1 else 0 end) as Wife_marry_age_IsFilled
	  ,a.Hus_current_age
	  ,a.Hus_marry_age
	  ,(case when (LEN(a.Hus_marry_age)>0 and a.Hus_marry_age>0 and a.Hus_marry_age IS NOT NULL)then 1 else 0 end) as Hus_marry_age_IsFilled
	  ,a.EID
	  ,(case when (LEN(a.EID)>0 and a.EID>0 and a.EID is not null)then 1 else 0 end) as PW_Enrollment_No_IsFilled
	  ,a.EIDT
	  ,DAY(a.EIDT) as PW_Enrollment_Day
	  ,Month(a.EIDT) as PW_Enrollment_Month
	  ,Year(a.EIDT) as PW_Enrollment_Year
	  ,a.Aadhar_No
	  ,(case when (LEN(a.Aadhar_No)>0 and a.Aadhar_No>0 and a.Aadhar_No IS NOT NULL)then 1 else 0 end) as PW_Aadhaar_no_IsFilled
	  ,(case when (LEN(a.Aadhar_No)=0 or a.Aadhar_No=0 or a.Aadhar_No IS NULL)then 1 else 0 end) as PW_Aadhaar_no_IsNotFilled
	  --,a.PW_AadhaarLinked
	  ,(case when a.PW_AadhaarLinked=1 then 'Yes' when a.PW_AadhaarLinked=0 then 'No' end)as PW_AadhaarLinked
	  ,(case a.PW_AadhaarLinked when 1 then  1 end) as PW_AadhaarLinked_Yes
	  ,(case a.PW_AadhaarLinked when 0 then  1 end) as PW_AadhaarLinked_No
	  --,(case isnull(a.PW_AadhaarLinked,0) when 0 then  1 end) as PW_AadhaarLinked_NotFilled
	  ,(case when (LEN(a.PW_AadhaarLinked)>0 and a.PW_AadhaarLinked IS NOT NULL)then  1 else 0 end) as PW_AadhaarLinked_IsFilled
	  ,(case when (LEN(a.PW_AadhaarLinked)=0 or a.PW_AadhaarLinked IS NULL)then  1 else 0 end) as PW_AadhaarLinked_NotFilled
	  ,c.Bank_name as PW_Bank_Name
	  ,a.PW_BankID
	  ,(case when (LEN(a.PW_BankID)>0 and a.PW_BankID IS not null )then 1 else 0 end) as PW_Bank_IsFilled
	  ,a.PW_AccNo
	  ,(case when (LEN(a.PW_AccNo)>0 and a.PW_AccNo IS NOT NULL)then 1 else 0 end) as PW_AccNo_IsFilled
	  ,(case when (LEN(a.PW_AccNo)=0 or a.PW_AccNo IS NULL)then 1 else 0 end) as PW_AccNo_IsNotFilled
	  ,a.PW_BranchName
	  ,(case when( LEN(a.PW_BranchName)>0 and a.PW_BranchName IS NOT NULL)then 1 else 0 end) as PW_BranchName_IsFilled
	  ,a.PW_IFSCCode
	  ,(case when LEN(a.PW_IFSCCode)=11 then 1 else 0 end) as PW_IFSCCode_IsFilled
	  ,a.HusbandAadhaar_no
	  ,(case when (LEN(a.HusbandAadhaar_no)>0 and a.HusbandAadhaar_no>0 and a.HusbandAadhaar_no IS NOT NULL)then 1 else 0 end) as HusbandAadhaar_no_IsFilled
	  ,a.Husband_AadhaarLinked
	  ,(case a.Husband_AadhaarLinked when 1 then  1 end) as Husband_AadhaarLinked_Yes
	  ,(case a.Husband_AadhaarLinked when 0 then  1 end) as Husband_AadhaarLinked_No
	  --,(case isnull(a.Husband_AadhaarLinked,0) when 0 then  1 end) as Husband_AadhaarLinked_NotFilled
	  ,(case when (LEN(a.Husband_AadhaarLinked)>0 and a.Husband_AadhaarLinked IS NOT NULL)then  1  else 0 end) as Husband_AadhaarLinked_IsFilled
	  ,(case when (LEN(a.Husband_AadhaarLinked)=0 or a.Husband_AadhaarLinked IS NULL)then  1  else 0 end) as Husband_AadhaarLinked_NotFilled
	  ,f.Bank_name as Husband_Bank_Name
	  ,a.Husband_BankID
	  ,(case when (LEN(a.Husband_BankID)>0 and  a.Husband_BankID>0 and a.Husband_BankID IS not null )then 1 else 0 end) as Husband_Bank_IsFilled
	  ,a.Husband_AccNo
	  ,(case when (LEN(a.Husband_AccNo)>0 and a.Husband_BankID is not null)then 1 else 0 end) as Husband_AccNo_IsFilled
	  ,a.Husband_BranchName
	  ,(case when (LEN(a.Husband_BranchName)>0 and a.Husband_BranchName is not null)then 1 else 0 end) as Husband_BranchName_IsFilled
	  ,a.Husband_IFSCCode
	  ,(case when (LEN(a.Husband_IFSCCode)=11 and a.Husband_IFSCCode Is not null)then 1 else 0 end) as Husband_IFSCCode_IsFilled
	  ,d.Name
	  ,a.Religion_Code
	  ,(case when  LEN(a.Religion_Code)>0 and a.Religion_Code>0  and Religion_Code IS not null then 1 else 0 end) as Religion_IsFilled
	  ,(case when  a.Religion_Code=1 then 1 else 0 end) as Religion_Buddism
	  ,(case when  a.Religion_Code=2 then 1 else 0 end) as Religion_Christianity
	  ,(case when  a.Religion_Code=3 then 1 else 0 end) as Religion_Hinduism
	  ,(case when  a.Religion_Code=4 then 1 else 0 end) as Religion_Islam
	  ,(case when  a.Religion_Code=5 then 1 else 0 end) as Religion_Jainism
	  ,(case when  a.Religion_Code=6 then 1 else 0 end) as Religion_Sikhism
	  ,(case when  a.Religion_Code=99 then 1 else 0 end) as Religion_Other
	  ,(case when  (LEN(a.Religion_Code)=0 or a.Religion_Code=0 or a.Religion_Code IS null)then 1 else 0 end) as Religion_NotFilled
	  ,e.Caste_Name
	  ,a.Caste
	  ,(case when  (LEN(a.Caste)>0 and a.Caste>0 and a.Caste IS not null) then 1 else 0 end) as Caste_IsFilled
	  ,(case when  a.Caste=1 then 1 else 0 end) as Cast_SC
	  ,(case when  a.Caste=2 then 1 else 0 end) as Cast_ST
	  ,(case when  a.Caste=99 then 1 else 0 end) as Cast_Other
	  ,(case when (LEN(a.Caste)=0 or a.Caste=0 or a.Caste IS null) then 1 else 0 end) as Caste_NotFilled
	  ,i.Identity_Type_Name
	  ,a.Identity_type
	  ,(case when (LEN(a.Identity_type)>0 and a.Identity_type>0 and Identity_type IS not null) then 1 else 0 end) as IdType_IsFilled
	  ,(case when  a.Identity_type=2 then 1 else 0 end) as IdType_DrivingLicence
	  ,(case when  a.Identity_type=3 then 1 else 0 end) as IdType_PanCard
	  ,(case when  a.Identity_type=4 then 1 else 0 end) as IdType_Passport
	  ,(case when  a.Identity_type=5 then 1 else 0 end) as IdType_RationCard
	  ,(case when  a.Identity_type=6 then 1 else 0 end) as IdType_VoterIdCard
	  ,(case when (LEN(a.Identity_type)=0 or a.Identity_type=0 or Identity_type IS null)then 1 else 0 end) as IdType_NotFilled
	  ,a.Identity_number
	  ,(case when LEN(a.Identity_number)>0 and Identity_number IS not null then 1 else 0 end) as Identity_number_IsFilled
	  --,a.BPL_APL
	  ,(case when a.BPL_APL=1 then 'BPL' when a.BPL_APL=2 then 'APL' when a.BPL_APL=99 then 'Not_Known' end)as BPL_APL
	  ,(case when a.BPL_APL=1 then 1 else 0 end)  as Economic_status_BPL
	  ,(case when a.BPL_APL=2 then 1 else 0 end)  as Economic_status_APL
	  ,(case when a.BPL_APL=99 then 1 else 0 end)  as Economic_status_Not_Known
	  ,(case when (LEN(a.BPL_APL)>0 and a.BPL_APL>0 and a.BPL_APL IS NOT NULL )then 1 else 0 end)  as Economic_status_IsFilled
	  ,(case when (LEN(a.BPL_APL)=0 or a.BPL_APL=0 or a.BPL_APL IS NULL )then 1 else 0 end)  as Economic_status_Not_Filled
	  ,a.Male_child_born
	  ,(case when (LEN(a.Male_child_born)>0 and a.Male_child_born>0 and a.Male_child_born IS not null)then 1 else 0 end) as Male_child_born_IsFilled
	  ,(case when (LEN(a.Male_child_born)=0 or a.Male_child_born=0 or a.Male_child_born IS null) then 1 else 0 end) as Male_child_born_NotFilled
	  ,a.Female_child_born
	  ,(case when (LEN(a.Female_child_born)>0 and a.Female_child_born>0 and a.Female_child_born IS not null) then 1 else 0 end) as Female_child_born_IsFilled
	  ,(case when (LEN(a.Female_child_born)=0 or a.Female_child_born=0 or a.Female_child_born IS null) then 1 else 0 end) as Female_child_born_NotFilled
	  ,a.Male_child_live
	  ,(case when (LEN(a.Male_child_live)>0 and a.Male_child_live>0 and a.Male_child_live IS not null) then 1 else 0 end) as Male_child_live_IsFilled
	  ,(case when (LEN(a.Male_child_live)=0 or a.Male_child_live=0 or a.Male_child_live IS null) then 1 else 0 end) as Male_child_live_NotFilled
	  ,a.Female_child_live
	  ,(case when (LEN(a.Female_child_live)>0 and a.Female_child_live>0 and a.Female_child_live IS not null) then 1 else 0 end) as Female_child_live_IsFilled
	  ,(case when (LEN(a.Female_child_live)=0 or a.Female_child_live=0 or a.Female_child_live IS null) then 1 else 0 end) as Female_child_live_NotFilled
	  ,a.Young_child_age_month
	  ,a.Young_child_age_year
	  --,(case when isnull(a.Young_child_age_Month,0)>0 then 1 else 0 end) as Young_child_age_Month_IsFilled
	  --,(case when a.Young_child_age_Month IS null then 1 else 0 end) as Young_child_age_Month_NotFilled
	  --,(case when isnull(a.Young_child_age_year,0)>0 then 1 else 0 end) as Young_child_age_Year_IsFilled
	  --,(case when a.Young_child_age_year IS null then 1 else 0 end) as Young_child_age_Year_NotFilled
	  
	  ,(case when (LEN(a.Young_child_age_Month)>0 and a.Young_child_age_Month>0 and a.Young_child_age_Month is not null) then 1 else 0 end) as Young_child_age_Month_IsFilled
	  ,(case when (LEN(a.Young_child_age_Month)=0 or a.Young_child_age_Month=0 or a.Young_child_age_Month is null) then 1 else 0 end) as Young_child_age_Month_NotFilled
	  ,(case when (LEN(a.Young_child_age_year)>0 and a.Young_child_age_year>0 and a.Young_child_age_year is not null) then 1 else 0 end) as Young_child_age_Year_IsFilled
	  ,(case when(LEN(a.Young_child_age_year)=0 or a.Young_child_age_year=0 or a.Young_child_age_year is null) then 1 else 0 end) as Young_child_age_Year_NotFilled
	  ,(case when a.Young_child_gender='M' then 'Male' when a.Young_child_gender='F' then 'Female' when a.Young_child_gender='T' then 'Transgender' end) as Young_child_Sex
	  ,(case when a.Young_child_gender='M' then 1 else 0 end) as Young_Child_Sex_Male   --145
	  ,(case when a.Young_child_gender='F' then 1 else 0 end) as Young_Child_Sex_Female
	  ,(case when a.Young_child_gender='T' then 1 else 0 end) as Young_Child_Sex_Transgender
	  --,(case when a.Young_child_gender IS null then 1 else 0 end) as Young_child_Sex_NotFilled
	  --,(case when isnull(a.Young_child_gender,0)>0 then 1 else 0 end) as Young_child_Sex_IsFilled
	  ,(case when (LEN(a.Young_child_gender)=0 or a.Young_child_gender='0' or a.Young_child_gender IS null )then 1 else 0 end) as Young_child_Sex_NotFilled
	  ,(case when (LEN(a.Young_child_gender)>0 and a.Young_child_gender>'0' and a.Young_child_gender IS NOT NULL)then 1 else 0 end) as Young_child_Sex_IsFilled
	  ,(case when a.Infertility_status='Y'then 'YES' when a.Infertility_status='N' then 'NO' end)as Infertility_status
	  ,(case when a.Infertility_status='Y' then 1 else 0 end) as Infertility_status_Yes
	  ,(case when a.Infertility_status='N' then 1 else 0 end) as Infertility_status_No
	  ,(case when a.InfertilityOptions=1 then 1 else 0 end) as Infertility_FRU_Code
	  ,(case when a.InfertilityOptions=5 then 1 else 0 end) as Infertility_DH_Code
	  ,(case when a.InfertilityOptions=99 then 1 else 0 end) as Infertility_OTHER_Code
	  ,a.Infertility_refer
	  ,a.InfertilityReferDH
	  ,(case when (LEN(a.InfertilityReferDH)>0 and a.InfertilityReferDH>0 and a.InfertilityReferDH is not null) then 1 else 0 end) as Infertility_Reffer_DH_Code_Isfilled
	  ,(case when (LEN(InfertilityReferDH)=0 or a.InfertilityReferDH='' or a.InfertilityReferDH='0' or a.InfertilityReferDH IS null) then 1 else 0 end) as Infertility_Reffer_DH_Code_Notfilled
	  ,(case when (LEN(a.Infertility_refer)>0 and a.Infertility_refer>'0' and a.Infertility_refer is not null)then 1 else 0 end) as Infertility_Reffer_IsFilled
	  ,(case when (LEN(a.Infertility_refer)=0 or a.Infertility_refer='0' or a.Infertility_refer='' or a.Infertility_refer IS null) then 1 else 0 end) as Infertility_Reffer_IsNotFilled
	  ,a.Case_no

from t_eligibleCouples a
--inner join RCH_National_Level.dbo.m_Whose_MobileNo b on a.Whose_mobile=b.Whose_mobile_Code
left outer join RCH_National_Level.dbo.M_Bank c on a.PW_BankID=c.ID
left outer join RCH_National_Level.dbo.M_Bank f on a.Husband_BankID=f.ID
left outer join RCH_National_Level.dbo.m_Religion d on a.Religion_Code=d.Id
left outer join RCH_National_Level.dbo.m_Caste e on a.Caste=e.Caste_Code
left outer join t_Ground_Staff g on a.ANM_ID=g.ID
left outer join t_Ground_Staff h on a.ASHA_ID=h.ID
left outer join RCH_National_Level.dbo.m_Identity_Type i on a.Identity_type=i.Identity_Type_ID
end
                                                                                                                                                                                                                                        




