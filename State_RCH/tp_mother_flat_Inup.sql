USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_flat_Inup]    Script Date: 09/26/2024 14:50:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--tp_mother_flat_Inup '08/07/2024','08/07/2024'
 ALTER Proc [dbo].[tp_mother_flat_Inup]
(@FromDate as Date
,@ToDate as Date
)
as
begin

--delete w from t_mother_flat  w
--inner join t_eligibleCouples a on a.Registration_no=w.Registration_no and a.Case_no=w.Case_no
--where (CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) 

--select * from t_mother_flat

---jyoti
update t_mother_flat 
 set Max_EC_Flag =0 from  t_mother_flat a
inner join 
(
select a.[Registration_no]
FROM t_eligibleCouples a
   inner join t_Schedule_Date_Previous q on a.Registration_no=q.Registration_No and a.Case_no=q.Case_No
  left outer join t_mother_flat e on a.Registration_no=e.Registration_no and a.Case_no=e.Case_no
where  e.Registration_no is null --and q.case_no<>1 
) X on a.Registration_no=x.Registration_no
-------------------------------
insert into t_mother_flat([StateID],[District_ID],[Rural_Urban],[HealthBlock_ID],[Taluka_ID],[Facility_ID],[PHC_ID],[SubCentre_ID],[Village_ID]
,[Registration_no],[Case_no],[EC_Register_srno],[ID_No],[Name_wife],[Name_husband],[Whose_mobile],[Landline_no],[Mobile_no],[EC_Regisration_Date]
,[Wife_current_age],[Wife_marry_age],[Hus_current_age],[Hus_marry_age],[Address],[Religion],[Caste],[Male_child_born],[Female_child_born],[Male_child_live]
,[Female_child_live],[Young_child_gender],[Young_child_age_month],[Young_child_age_year],[Infertility_status],[InfertilityOptions],[Infertility_refer]
,[Pregnant_Status],[Pregnant_Test],[Eligibility_Status],[Present_Status],[EC_ANM_ID],[EC_ASHA_ID],[PW_Aadhar_No],[PW_EID],[PW_EIDT],[PW_AadhaarLinked]
,[PW_Bank_Name],[PW_Branch_Name],[PW_IFSC_Code],[PW_Account_No],[Hus_Aadhar_No],[Hus_EID],[Hus_EIDT],[Hus_AadhaarLinked],[Hus_Bank_Name],[Hus_Branch_Name]
,[Hus_IFSC_Code],[Hus_Account_No],[Economic_Status],[EC_Created_On],[EC_Updated_On],EC_Yr,EC_Child_Total,EC_With_MaleChild,EC_With_FemaleChild
,EC_With_MaleChild_Live,EC_With_FemaleChild_Live,SourceID,Exec_Date,EC_Registration_Yr
,distinct_ec
---jyoti
,Max_EC_Flag,Delete_Mother,Dup_Mother_Delete ,permanent_delete,DeletedOn,Deleted_By,DeletedBy_name,mother_HealthIdNumber,mother_HealthId,HID_linked_date
,Incentive_PW_ANM_ID,incentive_PW_ASHA_ID,IS_PVTG)

select a.State_Code,a.District_Code,a.[Rural_Urban],a.HealthBlock_Code,a.Taluka_Code,a.HealthFacility_Type,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,a. [Registration_no],a. [Case_no],a.Register_srno as [EC_Register_srno],a. [ID_No],a. [Name_wife],a. [Name_husband],p. Whose_mobile_Name,a. [Landline_no],a. [Mobile_no],a. Date_regis
,a. [Wife_current_age],a. [Wife_marry_age],a. [Hus_current_age],a. [Hus_marry_age],a. [Address],b.Name as [Religion],c.Caste_Name as [Caste],a.[Male_child_born],a.[Female_child_born],a.[Male_child_live]
,a.[Female_child_live],a.[Young_child_gender],a.[Young_child_age_month],a.[Young_child_age_year],a.[Infertility_status],d.Name as [InfertilityOptions],a.Infertility_Refer  as [Infertility_refer]--Update 
,a.Pregnant [Pregnant_Status],a.[Pregnant_Test],a.Eligible as [Eligibility_Status],a.Status as  [Present_Status],a.ANM_ID [EC_ANM_ID],a.ASHA_ID [EC_ASHA_ID],a.Aadhar_No as [PW_Aadhar_No],a.EID as [PW_EID],a.EIDT [PW_EIDT],a.[PW_AadhaarLinked]
,n.Bank_Name as [PW_Bank_Name],a.PW_BranchName as [PW_Branch_Name],a.PW_IFSCCode as [PW_IFSC_Code],a.PW_AccNo as [PW_Account_No],a.HusbandAadhaar_no as [Hus_Aadhar_No],a.Husband_EID [Hus_EID],a.Husband_EIDT [Hus_EIDT],a.Husband_AadhaarLinked [Hus_AadhaarLinked],o.Bank_Name [Hus_Bank_Name],a.Husband_BranchName [Hus_Branch_Name]
,a.Husband_IFSCCode [Hus_IFSC_Code],a.Husband_AccNo [Hus_Account_No],f.Name as [Economic_Status],Convert(date,a.Created_On),CONVERT(date,a.Updated_On),a.Financial_Year
,(isnull(a.Male_child_born,0)+isnull(a.Female_child_born,0)) EC_Child_Total,isnull(a.Male_child_born,0)  EC_With_MaleChild
,isnull(a.Female_child_born,0) EC_With_FemaleChild,isnull(a.Male_child_live,0)EC_With_MaleChild_Live,isnull(a.FeMale_child_live,0)EC_With_FemaleChild_Live,a.SourceID
,GETDATE(),a.Financial_Year
,case a.Case_no when 1 then 1 else 0 end distinct_ec
---jyoti
,1 as Max_EC_Flag,a.Delete_Mother,a.Dup_Mother_Delete ,a.permanent_delete,a.DeletedOn,a.Deleted_By,User_Name DeletedBy_name 
,HealthIdNumber,HealthId,isnull(isnull(z.HID_linked_date,z.updated_on),z.Created_On) HID_linked_date,Incentive_ANM_ID	,incentive_ASHA_ID,(case when z.Is_PVTG='Y' then 'Y' when z.Is_PVTG='N' then 'N' else '' end) Is_PVTG
FROM t_eligibleCouples a inner join t_mother_registration z on a.Registration_no=Z.Registration_no and a.Case_no=Z.Case_no
  left outer join RCH_National_Level.dbo.m_Religion b on a.Religion_Code=b.Id
  left outer join RCH_National_Level.dbo.m_Caste c on a.Caste=c.Caste_Code
  left outer join RCH_National_Level.dbo.m_Infertility_Option d on a.InfertilityOptions=d.Id
  left outer join [RCH_National_Level].[dbo].[m_EconomicStatus_options] f on a.BPL_APL=f.Id
  left outer join [RCH_National_Level].[dbo].[M_Bank] n on a.PW_BankID=n.Id
  left outer join [RCH_National_Level].[dbo].[M_Bank] o on a.Husband_BankID=o.Id
  left outer join [RCH_National_Level].[dbo].[m_Whose_MobileNo] p on a.Whose_mobile=p.Whose_mobile_Code
  inner join t_Schedule_Date_Previous q on a.Registration_no=q.Registration_No and a.Case_no=q.Case_No
  left outer join t_mother_flat e on a.Registration_no=e.Registration_no and a.Case_no=e.Case_no
  left outer join User_Master u on a.Deleted_By=userID
where  e.Registration_no is null

---------------------------------------- EC Update------------------------------------------------------------------------------------------


-------jyoti
Update t_mother_flat set Eligible_S=Eligible ,Status_S=Status,Reason_S=Reason,InEligibility_FinYear_S=InEligility_FinYear,Inactive_Date_S=Inactive_Date

from 
(
select a.Registration_no,a.MAX_Case_no case_no, a.Eligible,a.InEligility_FinYear,a.Inactive_Date,a.Reason,a.Status
FROM t_eligibleCouples_Status a
inner join t_mother_flat b on b.Registration_no=a.Registration_no and b.Case_no=a.MAX_Case_no
inner join t_Schedule_Date_Previous q on a.Registration_no=q.Registration_No and b.Case_no=q.Case_No
where b.Max_EC_Flag=1 and EC_Table=1
)X
where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

  

update [t_mother_flat] set Name_wife=X.Name_wife,Name_husband=X.Name_husband,[Address]=X.[Address],Whose_mobile=X.Whose_mobile_Name
,Mobile_no=X.Mobile_no,Caste=X.Caste,Wife_current_age=X.Wife_current_age,Economic_Status=X.Economic_Status
,[EC_Register_srno]=X.EC_Register_srno,Landline_no=X. [Landline_no],EC_Regisration_Date=X.Date_regis
,Wife_marry_age =X.[Wife_marry_age],Hus_current_age=X.[Hus_current_age],[Hus_marry_age]=X.[Hus_marry_age],[Religion]=X.[Religion],[Male_child_born]=X.[Male_child_born]
,[Female_child_born]=X.[Female_child_born],[Male_child_live]=X.[Male_child_live]
,[Female_child_live]=X.[Female_child_live],[Young_child_gender]=X.[Young_child_gender],[Young_child_age_month]=X.[Young_child_age_month]
,[Young_child_age_year]=X.[Young_child_age_year],[Infertility_status]=X.[Infertility_status],[InfertilityOptions]=X.[InfertilityOptions]
,[Infertility_refer]=X.[Infertility_refer]--Update 
,[Pregnant_Status]=X.[Pregnant_Status],[Pregnant_Test]=X.[Pregnant_Test],[Eligibility_Status]=X.[Eligibility_Status],[Present_Status]=X.[Present_Status]
,[EC_ANM_ID]=X.[EC_ANM_ID],[EC_ASHA_ID]=X.[EC_ASHA_ID],[PW_Aadhar_No]=X.[PW_Aadhar_No],[PW_EID]=X.[PW_EID],[PW_EIDT]=X.[PW_EIDT],[PW_AadhaarLinked]=X.[PW_AadhaarLinked]
,[PW_Bank_Name]=X.[PW_Bank_Name],[PW_Branch_Name]=X.[PW_Branch_Name],[PW_IFSC_Code]=X.[PW_IFSC_Code],[PW_Account_No]=X.[PW_Account_No]
,[Hus_Aadhar_No]=X.[Hus_Aadhar_No],[Hus_EID]=X.[Hus_EID],[Hus_EIDT]=X.[Hus_EIDT],[Hus_AadhaarLinked]=X.[Hus_AadhaarLinked]
,[Hus_Bank_Name]=X.[Hus_Bank_Name],[Hus_Branch_Name]=X.[Hus_Branch_Name]
,[Hus_IFSC_Code]=X.[Hus_IFSC_Code],[Hus_Account_No]=X.[Hus_Account_No],[EC_Updated_On]=X.Updated_On
,EC_Yr=X.Financial_Year
,EC_Child_Total=X.EC_Child_Total,EC_With_MaleChild=X.EC_With_MaleChild
,EC_With_FemaleChild=X.EC_With_FemaleChild,EC_With_MaleChild_Live=X.EC_With_MaleChild_Live
,EC_With_FemaleChild_Live=X.EC_With_FemaleChild_Live
,EC_Registration_Yr=X.Financial_Year
,Exec_Date=GETDATE()
,[Delete_Mother]=x.Delete_Mother,
	[DeletedOn]=(Case when x.Delete_Mother=1 then x.DeletedOn  else null end),
	Deleted_By=Case when x.Delete_Mother=1 then x.Deleted_By  else null end,
	DeletedBy_name=Case when x.Delete_Mother=1 then x.DeletedBy_name  else null end,
	Dup_Mother_Delete=x.Dup_Mother_Delete ,permanent_delete=x.permanent_delete -- tentative duplicate
	,Mother_HealthIdNumber=x.HealthIdNumber,
	Mother_HealthId=x.HealthId,
	HID_linked_date=x.HID_linked_date,
	Incentive_PW_ANM_ID	=Incentive_ANM_ID,incentive_PW_ASHA_ID=incentive_ASHA_ID
	,IS_PVTG=X.Is_PVTG
from

(
select a. [Registration_no],a. [Case_no],a.Register_srno as [EC_Register_srno],a. [ID_No],a. [Name_wife],a. [Name_husband],p. Whose_mobile_Name,a. [Landline_no],a. [Mobile_no],a. Date_regis
,a. [Wife_current_age],a. [Wife_marry_age],a. [Hus_current_age],a. [Hus_marry_age],a. [Address],b.Name as [Religion],c.Caste_Name as [Caste],a.[Male_child_born],a.[Female_child_born],a.[Male_child_live]
,a.[Female_child_live],a.[Young_child_gender],a.[Young_child_age_month],a.[Young_child_age_year],a.[Infertility_status],d.Name as [InfertilityOptions],a.Infertility_Refer  as [Infertility_refer]--Update 
,a.Pregnant [Pregnant_Status],a.[Pregnant_Test],a.Eligible as [Eligibility_Status],a.Status as  [Present_Status],a.ANM_ID [EC_ANM_ID],a.ASHA_ID [EC_ASHA_ID],a.Aadhar_No as [PW_Aadhar_No],a.EID as [PW_EID],a.EIDT [PW_EIDT],a.[PW_AadhaarLinked]
,n.Bank_Name as [PW_Bank_Name],a.PW_BranchName as [PW_Branch_Name],a.PW_IFSCCode as [PW_IFSC_Code],a.PW_AccNo as [PW_Account_No],a.HusbandAadhaar_no as [Hus_Aadhar_No],a.Husband_EID [Hus_EID],a.Husband_EIDT [Hus_EIDT],a.Husband_AadhaarLinked [Hus_AadhaarLinked],o.Bank_Name [Hus_Bank_Name],a.Husband_BranchName [Hus_Branch_Name]
,a.Husband_IFSCCode [Hus_IFSC_Code],a.Husband_AccNo [Hus_Account_No],f.Name as [Economic_Status],CONVERT(date,a.Updated_On) as Updated_On
,(isnull(a.Male_child_born,0)+isnull(a.Female_child_born,0)) EC_Child_Total,isnull(a.Male_child_born,0)  EC_With_MaleChild
,isnull(a.Female_child_born,0) EC_With_FemaleChild,isnull(a.Male_child_live,0)EC_With_MaleChild_Live,isnull(a.FeMale_child_live,0)EC_With_FemaleChild_Live,a.SourceID,a.Financial_Year
,a.Delete_Mother,a.Dup_Mother_Delete ,a.permanent_delete,a.DeletedOn,a.Deleted_By,User_Name DeletedBy_name,HealthIdNumber,HealthId,isnull(isnull(z.HID_linked_date,z.updated_on),z.Created_On) HID_linked_date
,Incentive_ANM_ID	,incentive_ASHA_ID,(case when Is_PVTG='Y' then 'Y' when Is_PVTG='N' then 'N' else '' end) Is_PVTG
FROM t_eligibleCouples a inner join t_mother_registration z on a.Registration_no=Z.Registration_no and a.Case_no=Z.Case_no
  left outer join RCH_National_Level.dbo.m_Religion b on a.Religion_Code=b.Id
  left outer join RCH_National_Level.dbo.m_Caste c on a.Caste=c.Caste_Code
  left outer join RCH_National_Level.dbo.m_Infertility_Option d on a.InfertilityOptions=d.Id
  left outer join [RCH_National_Level].[dbo].[m_EconomicStatus_options] f on a.BPL_APL=f.Id
  left outer join [RCH_National_Level].[dbo].[M_Bank] n on a.PW_BankID=n.Id
  left outer join [RCH_National_Level].[dbo].[M_Bank] o on a.Husband_BankID=o.Id
  left outer join [RCH_National_Level].[dbo].[m_Whose_MobileNo] p on a.Whose_mobile=p.Whose_mobile_Code
  inner join t_Schedule_Date_Previous q on a.Registration_no=q.Registration_No and a.Case_no=q.Case_No
  left outer join User_Master u on a.Deleted_By=userID
where q.EC_Table=1
--where ( CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)
)
X

where [t_mother_flat].Registration_no=X.Registration_no and [t_mother_flat].Case_no=X.Case_no

  
----------------------------------------------ECT Registration-------------------------------------------------------------
  
update [t_mother_flat] set ECT_With_Visit=X.ECT_With_Visit,ECT_With_Method_Val=X.ECT_With_Method_Val,EC_Preg_Status=X.EC_Preg_Status_Val
,ECT_mode_execution=getdate()
from (
select a.Registration_no,a.case_no,COUNT(Visit_no) as ECT_With_Visit,dbo.Get_ECT_Method(a.Registration_no,a.case_no) as ECT_With_Method_Val ,dbo.Get_ECT_Preg_Status(a.Registration_no,a.case_no) as EC_Preg_Status_Val
from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_no
where b.ECT_Table=1
group by a.Registration_no,a.case_no
) X 
where [t_mother_flat].Registration_no=X.Registration_no and [t_mother_flat].Case_no=X.Case_no
    
    
Update [t_mother_flat] set ECT_With_Method_Name=dbo.Get_ECT_Method_Name(ECT_With_Method_Val) where CONVERT(date,Exec_Date)=CONVERT(date,GETDATE())  and ECT_With_Method_Val is not null
  
-----------------------------------------------Mother Registration-------------------------------------------------------- 
	 
	update t_mother_flat set 
	[M_StateID]=State_Code,
	[M_District_ID]=District_Code,
	[M_HealthBlock_ID]=HealthBlock_Code,
	[M_Taluka_ID] =Taluka_Code,
	[M_Facility_ID]=HealthFacility_Type ,
	[M_PHC_ID]=HealthFacility_Code,
	[M_SubCentre_ID]=HealthSubFacility_Code ,
	[M_Village_ID]=Village_Code,
	[Mother_Register_srno]=Z.Register_srno,
	[Mother_Registration_Date]=(case when Z.Registration_Date<='1990-01-01' then null  else Z.Registration_Date end),
	[Mother_Weight]=Z.Height ,
	[Mother_BirthDate]=Z.Birth_Date,
	[Mother_Age]=Z.Age,
	[Mother_ANM_ID]=(case when Z.Registration_Date<='1990-01-01' then null  else Z.ANM_ID end),
	[Mother_ASHA_ID]=(case when Z.Registration_Date<='1990-01-01' then null else  Z.ASHA_ID  end),
	[Mother_Created_On]=(Case when [Mother_Created_On] is null  then(Case when Z.Registration_Date<='1990-01-01' then null  else Updated_On end) else [Mother_Created_On] end),
	[Mother_Updated_On]=Updated_On,
	[JSY_Beneficiary]=Z.JSY_Beneficiary,
	[JSY_Payment_Received]=Z.JSY_Payment_Received,
	[Delete_Mother]=Z.Delete_Mother,
	[DeletedOn]=(Case when Z.Delete_Mother=1 then Z.DeletedOn  else null end),
	Deleted_By=Case when Z.Delete_Mother=1 then z.Deleted_By  else null end,
	DeletedBy_name=Case when Z.Delete_Mother=1 then z.DeletedBy_name  else null end,
	Dup_Mother_Delete=z.Dup_Mother_Delete ,permanent_delete=z.permanent_delete, -- tentative duplicate
	[Entry_Type]=Z.EntrytypeName,
	[CPSMS_Flag]=Z.CPSMS_Flag,
	[Mother_Yr]=Z.Financial_Year,
	[Mother_SourceID]=Z.SourceID,
	[Exec_Date]=getdate(),
	Mother_HealthIdNumber=Z.HealthIdNumber,
	Mother_HealthId=Z.HealthId,
	HID_linked_date=Z.HID_linked_date,
	Incentive_PW_ANM_ID	=Incentive_ANM_ID,incentive_PW_ASHA_ID=incentive_ASHA_ID
	from
	(
	select a.State_Code,a.District_Code,a.HealthBlock_Code,a.Taluka_Code,a.HealthFacility_Type,a.HealthFacility_Code,a.HealthSubFacility_Code,Village_Code,a.Registration_no,a.Case_no, Register_srno,Registration_Date, Height,Birth_Date,Age,ANM_ID,ASHA_ID,SourceID,a.Created_On,a.Updated_On
	,JSY_Beneficiary,JSY_Payment_Received,Delete_Mother,Dup_Mother_Delete ,permanent_delete,DeletedOn,Entry_Type,CPSMS_Flag,Financial_Year,h.Name as EntrytypeName,Deleted_By,User_Name DeletedBy_name,HealthIdNumber,HealthId,isnull(isnull(a.HID_linked_date,a.updated_on),a.Created_On) HID_linked_date
	,Incentive_ANM_ID	,incentive_ASHA_ID from
	 t_mother_registration a
	left outer join RCH_National_Level.dbo.m_MotherEntry_Type h on a.Entry_Type=h.Id
	inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
	left outer join User_Master u on Deleted_By=userID
	where b.MR_Table=1
	)Z
	
	where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  --------------------------------------------------Mother medical--------------------------------------------------------------------------
  update t_mother_flat set 	[Medical_LMP_Date]=Z.LMP_Date,
	[Medical_Reg_12Weeks]=(case Z.Reg_12Weeks when 0 then 'N'  when 1 then 'Y' end),
	[Medical_EDD_Date]=Z.EDD_Date ,
	[Medical_Blood_Group]=Z.Bloodgroupname,
	[Medical_VDRL_TEST]=(Case VDRL_Test when 1 then 'Done' when 0 then 'Not Done' end),
	[Medical_VDRL_Date]=VDRL_Date,
	[Med_VDRL_Result]=(Case VDRL_Result when 'P' then 'Positive' when 'N' then 'Negative' end),
	[Medical_HIV_TEST]=(Case HIV_Test when 1 then 'Done' when 0 then 'Not Done' end),
	[Medical_HIV_Date]=HIV_Date,
	[Med_HIV_Result]=(Case HIV_Result when 'P' then 'Positive' when 'N' then 'Negative' end),
	[Medical_Yr]=Financial_Year,
	[Med_PastIllness_Val]=Past_Illness,
	[Med_PastIllness]=coalesce(dbo.GetPastIllNess_Name(Z.Past_Illness),Z.OtherPast_Illness),
	[Med_Last_Preg_Complication_Val]=Z.Last_Preg_Complication,
	[Med_Last_Preg_Complication]=coalesce(dbo.Get_LastComplication_Name(Z.Last_Preg_Complication),Z.Other_Last_Complication),
	[Med_Last_PregOutcome]=Z.Outcome_Last_Preg,
	[Med_SecondLast_Preg_Complication_Val]=Z.L2L_Preg_Complication,
	[Med_SecondLast_Preg_Complication]=coalesce(dbo.Get_LastComplication_Name(Z.L2L_Preg_Complication),Z.Other_L2L_Complication),
	[Med_SecondLast_PregOutcome]=Z.Outcome_L2L_Preg,
	[Expected_delivery_place]=Z.Expected_delivery_place ,
	[Expected_delivery_placeName]=Z.Expected_delivery_placeName,
	[Med_Source_ID]=Z.SourceID,
	[Med_Pregnancy_No]=Z.No_Of_Pregnancy,
	[BloodGroup_Test]=(Case Z.BloodGroup_Test when 1 then 'Done' when 2 then 'Not Done' end),
	HBSAG_Test=z.HBSAG_Test,
	HBSAG_Date=z.HBSAG_Date,
	HBSAG_Result=z.HBSAG_Result,	
	[Exec_Date]=getdate() 
	from
	(
	select a.Registration_no,a.Case_no, LMP_Date,Reg_12Weeks, EDD_Date,Blood_Group,VDRL_TEST,VDRL_Date,VDRL_Result,HIV_Date,HIV_Result,HIV_Test,Financial_Year,Past_Illness
	,OtherPast_Illness,Last_Preg_Complication,Other_Last_Complication,Outcome_Last_Preg,No_Of_Pregnancy
	,L2L_Preg_Complication,Other_L2L_Complication,Outcome_L2L_Preg,s.Name as Expected_delivery_place,a.Place_name Expected_delivery_placeName
	,CONVERT(varchar(5),r.Name) as Bloodgroupname,SourceID,BloodGroup_Test, 
	HBSAG_Test,	HBSAG_Date,	HBSAG_Result from t_mother_medical a with(nolock)
	left outer join  [RCH_National_Level].[dbo].[m_BloodGroup] r on a.Blood_Group=r.Id
	left outer join  [RCH_National_Level].[dbo].[m_DeliveryPlace] s on a.Expected_delivery_place=s.Id
	inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
	where b.MM_Table=1
	)Z
	
	where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
	

---------------------------------------------Mother Delivery-------------------------------------------------------	
	
	
	update t_mother_flat set 	[Delivery_date]=Z.[Delivery_date],
	[Delivery_Place_VAl]=Z.Delivery_Place_Val,
	[Delivery_Place]=Z.Delivery_Place,
	[Delivery_Place_Name]=Z.Delivery_Place_Name ,
	[Delivery_Conducted_By]=Z.Delivery_Conducted_By,
	[Delivery_Type]=Z.Delivery_Type,
	[Delivery_Death_Cause]=Z.Delivery_Death_Cause,
	[Delivery_Outcomes]=Z.Delivery_Outcomes,
	[Live_Birth]=Z.Live_Birth,
	[Still_Birth]=Z.Still_Birth,
	[Discharge_Date]=Z.Discharge_Date,
	[JSY_Paid_Date]=Z.JSY_Paid_Date,
	[Delivery_ANM_ID]=Z.Delivery_ANM_ID,
	[Delivery_ASHA_ID]=Z.Delivery_ASHA_ID,
	[Delivery_Time]=Z.Delivery_Time,
	[Discharge_Time]=Z.Discharge_Time,
	[Delivery_Complication]=dbo.[Get_DeliveryComplication_Name](Z.[Delivery_Complication]),
	[Delivery_SourceID]=Z.SourceID,
	[Delivery_Complication_VAl]=Z.[Delivery_Complication],
	Delivery_DeathCause_VAL=Z.[Delivery_Death_Cause_VAL],
	Delivery_Type_VAL=Z.Delivery_Type_VAL,
	Delivery_Conducted_By_VAL=Z.Delivery_Conducted_By_VAl,
	del_Is_ILI_Symptom=Z.Is_ILI_Symptom,
	del_Is_contact_Covid=Z.Is_contact_Covid,
	del_Covid_test_done=Z.Covid_test_done,
	del_Covid_test_result=Z.Covid_test_result,
	[Exec_Date]=getdate()
	,MD_mode_execution=getdate()
	,DeliveryLocationID=z.DeliveryLocationID
	from
	(
	select a.Registration_no,a.Case_no, [Delivery_date],Delivery_Place as Delivery_Place_Val,j.Name as [Delivery_Place],DeliveryLocationID,a.Delivery_Location as Delivery_Place_Name,Coalesce(k.Name,a.Delivery_Conducted_Other) as [Delivery_Conducted_By]
	,l.Name as [Delivery_Type],m.Name as [Delivery_Death_Cause],a.Death_Cause as [Delivery_Death_Cause_VAL],A.[Delivery_Outcomes],A.LiveBirth as [Live_Birth],A.StillBirth as [Still_Birth]
	,a.[Discharge_Date],a.[JSY_Paid_Date],a.ANM_ID as [Delivery_ANM_ID],a.ASHA_ID as [Delivery_ASHA_ID],a.[Delivery_Time],a.[Discharge_Time]
	,a.[Delivery_Complication],SourceID,a.Delivery_Type as Delivery_Type_VAL,a.Delivery_Conducted_By as Delivery_Conducted_By_VAl 
	--,isnull(Is_ILI_Symptom,0) Is_ILI_Symptom,isnull(Is_contact_Covid,0) Is_contact_Covid,
 --   isnull(Covid_test_done,0) Covid_test_done,isnull(Covid_test_result,0) Covid_test_result--covid
 , Is_ILI_Symptom, Is_contact_Covid,
     Covid_test_done, Covid_test_result--covid
	from
	 t_mother_delivery a
	  left outer join [RCH_National_Level].[dbo].[m_DeliveryPlace] j on a.Delivery_Place=j.ID
	  left outer join [RCH_National_Level].[dbo].[m_DeliveryConductedBy] k on a.Delivery_Conducted_By=k.Id
	  left outer join [RCH_National_Level].[dbo].m_DeliveryType l on a.Delivery_Type=l.Id
      left outer join [RCH_National_Level].[dbo].[m_DeathCause] m on a.Death_Cause=m.Id
      inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
      where MD_Table=1
	)Z
	
	where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  
  update t_mother_flat set [Infertility_refer]=Z.PHC_NAME from  
  
  (select b.PHC_NAME,a.Registration_no,Case_no from t_eligibleCouples a
  inner join TBL_PHC b on a.InfertilityReferDH=b.PHC_CD 
  where a.InfertilityOptions=5 
  and  Registration_no in (select Registration_no from  t_mother_flat  where  CONVERT(date,Exec_Date)=CONVERT(date,GETDATE()))

  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  update t_mother_flat set Delivery_Place_Name=Z.SUBPHC_Name_E from  
  
  (select b.SUBPHC_Name_E,a.Registration_no,Case_no from t_mother_delivery a
  inner join TBL_SUBPHC b on a.DeliveryLocationID=b.SubPHC_CD 
  where a.Delivery_Place=24 
  and Registration_no in (select Registration_no from  t_mother_delivery  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
   update t_mother_flat set Delivery_Place_Name=Z.Village_Name from  
  
  (select b.Name_E as Village_Name,a.Registration_no,Case_no from t_mother_delivery a
  inner join Village b on a.DeliveryLocationID=b.VCode 
  where a.Delivery_Place=25 
  and Registration_no in (select Registration_no from  t_mother_delivery  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  update t_mother_flat set Delivery_Place_Name=Z.PHC_NAME from  
  
  (select b.PHC_NAME as PHC_NAME,a.Registration_no,Case_no from t_mother_delivery a
  inner join TBL_PHC b on a.DeliveryLocationID=b.PHC_CD 
  where a.Delivery_Place not in (24,25) 
  and Registration_no in (select Registration_no from  t_mother_delivery  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
   update t_mother_flat set Expected_delivery_placeName=Z.SUBPHC_Name_E from  
  
  (select b.SUBPHC_Name_E,a.Registration_no,Case_no,Expected_delivery_place from t_mother_medical a
  inner join TBL_SUBPHC b on a.Expected_delivery_place=b.SubPHC_CD 
  where a.Expected_delivery_place=24 
  and Registration_no in (select Registration_no from  t_mother_medical  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
   update t_mother_flat set Expected_delivery_placeName=Z.Village_Name from  
  
  (select b.Name_E as Village_Name,a.Registration_no,Case_no from t_mother_medical a
  inner join Village b on a.Expected_delivery_place=b.VCode 
  where a.Expected_delivery_place=25 
  and Registration_no in (select Registration_no from  t_mother_medical  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  update t_mother_flat set Expected_delivery_placeName=Z.PHC_NAME from  
  
  (select b.PHC_NAME as PHC_NAME,a.Registration_no,Case_no from t_mother_medical a
  inner join TBL_PHC b on a.Expected_delivery_place=b.PHC_CD 
  where a.Expected_delivery_place not in (24,25) 
  and Registration_no in (select Registration_no from  t_mother_medical  where  ((CONVERT(date, a.Created_On) BETWEEN @FromDate AND @ToDate) or (CONVERT(date, a.Updated_On) BETWEEN @FromDate AND @ToDate)))
  ) Z
  where t_mother_flat.Registration_no=Z.Registration_no and t_mother_flat.Case_no=Z.Case_no
  
  
  ------------------------------------------Mother ANC----------------------------------------------------------------------------
update t_mother_flat set [ANC1]=X.ANC1_Date
,[ANC1_Pregnancy_Week]=X.[ANC1_Pregnancy_Week]
,[ANC1_Weight]=X.[ANC1_Weight]
,[ANC1_BP_Systolic]=X.[ANC1_BP_Systolic]
,[ANC1_BP_Distolic]=X.[ANC1_BP_Distolic]
,[ANC1_Hb_gm]=X.[ANC1_Hb_gm]
,[ANC1_Urine_Test]=X.[ANC1_Urine_Test]
,[ANC1_Urine_Albumin]=X.[ANC1_Urine_Albumin]
,[ANC1_Urine_Sugar]=X.[ANC1_Urine_Sugar]
,[ANC1_BloodSugar_Test]=X.[ANC1_BloodSugar_Test]
,[ANC1_Blood_Sugar_Fasting]=X.[ANC1_Blood_Sugar_Fasting]
,[ANC1_Blood_Sugar_Post_Prandial]=X.[ANC1_Blood_Sugar_Post_Prandial]
,[ANC1_FA_Given]=X.[ANC1_FA_Given]
,[ANC1_IFA_Given]=X.[ANC1_IFA_Given]
,[ANC1_Abdoman_FH]=X.[ANC1_Abdoman_FH]
,[ANC1_Abdoman_FHS]=X.[ANC1_Abdoman_FHS]
,[ANC1_Abdoman_FP]=X.[ANC1_Abdoman_FP]
,[ANC1_Foetal_Movment_VAL]=X.[ANC1_Foetal_Movements]
,[ANC1_Foetal_Movements]=dbo.[Get_Foetal_movement_Name](X.[ANC1_Foetal_Movements])
,[ANC1_Symptoms_High_Risk_VAL]=X.[ANC1_Symptoms_High_Risk]
,[ANC1_Symptoms_High_Risk]=dbo.[Get_Symptoms_High_Risk_Name](X.[ANC1_Symptoms_High_Risk],X.[ANC1_Other_Symptoms_High_Risk])
,[ANC1_Referal_Facility]=X.[ANC1_Referal_Facility]
,[ANC1_Referal_FacilityName]=X.[ANC1_Referal_FacilityName]
,[ANC1_Referal_Date]=X.[ANC1_Referal_Date]
,[ANC1_ANM_ID]=X.[ANC1_ANM_ID]
,[ANC1_ASHA_ID]=X.[ANC1_ASHA_ID]
,[ANC1_SourceID]=X.ANC1_SourceID
,[ANC1_ANC_Facility_Done]=dbo.Get_FacilityPlace_Service_Done(X.ANC1_FacilityPlaceANCDone)
,[ANC1_ANC_Facility_DoneName]=dbo.Get_FacilityPlace_Service_Done_Name(X.ANC1_FacilityPlaceANCDone,X.ANC1_FacilityLocationIDANCDone,X.ANC1_FacilityLocationANCDone)
,[ANC2]=X.ANC2_Date
,[ANC2_Pregnancy_Week]=X.[ANC2_Pregnancy_Week]
,[ANC2_Weight]=X.[ANC2_Weight]
,[ANC2_BP_Systolic]=X.[ANC2_BP_Systolic]
,[ANC2_BP_Distolic]=X.[ANC2_BP_Distolic]
,[ANC2_Hb_gm]=X.[ANC2_Hb_gm]
,[ANC2_Urine_Test]=X.[ANC2_Urine_Test]
,[ANC2_Urine_Albumin]=X.[ANC2_Urine_Albumin]
,[ANC2_Urine_Sugar]=X.[ANC2_Urine_Sugar]
,[ANC2_BloodSugar_Test]=X.[ANC2_BloodSugar_Test]
,[ANC2_Blood_Sugar_Fasting]=X.[ANC2_Blood_Sugar_Fasting]
,[ANC2_Blood_Sugar_Post_Prandial]=X.[ANC2_Blood_Sugar_Post_Prandial]
,[ANC2_FA_Given]=X.[ANC2_FA_Given]
,[ANC2_IFA_Given]=X.[ANC2_IFA_Given]
,[ANC2_Abdoman_FH]=X.[ANC2_Abdoman_FH]
,[ANC2_Abdoman_FHS]=X.[ANC2_Abdoman_FHS]
,[ANC2_Abdoman_FP]=X.[ANC2_Abdoman_FP]
,[ANC2_Foetal_Movment_VAL]=X.[ANC2_Foetal_Movements]
,[ANC2_Foetal_Movements]=dbo.[Get_Foetal_movement_Name](X.[ANC2_Foetal_Movements])
,[ANC2_Symptoms_High_Risk_VAL]=X.[ANC2_Symptoms_High_Risk]
,[ANC2_Symptoms_High_Risk]=dbo.[Get_Symptoms_High_Risk_Name](X.[ANC2_Symptoms_High_Risk],X.[ANC2_Other_Symptoms_High_Risk])
,[ANC2_Referal_Facility]=X.[ANC2_Referal_Facility]
,[ANC2_Referal_FacilityName]=X.[ANC2_Referal_FacilityName]
,[ANC2_Referal_Date]=X.[ANC2_Referal_Date]
,[ANC2_ANM_ID]=X.[ANC2_ANM_ID]
,[ANC2_ASHA_ID]=X.[ANC2_ASHA_ID]
,[ANC2_SourceID]=X.ANC2_SourceID
,[ANC2_ANC_Facility_Done]=dbo.Get_FacilityPlace_Service_Done(X.ANC2_FacilityPlaceANCDone)
,[ANC2_ANC_Facility_DoneName]=dbo.Get_FacilityPlace_Service_Done_Name(X.ANC2_FacilityPlaceANCDone,X.ANC2_FacilityLocationIDANCDone,X.ANC2_FacilityLocationANCDone)
,[ANC3]=X.ANC3_Date
,[ANC3_Pregnancy_Week]=X.[ANC3_Pregnancy_Week]
,[ANC3_Weight]=X.[ANC3_Weight]
,[ANC3_BP_Systolic]=X.[ANC3_BP_Systolic]
,[ANC3_BP_Distolic]=X.[ANC3_BP_Distolic]
,[ANC3_Hb_gm]=X.[ANC3_Hb_gm]
,[ANC3_Urine_Test]=X.[ANC3_Urine_Test]
,[ANC3_Urine_Albumin]=X.[ANC3_Urine_Albumin]
,[ANC3_Urine_Sugar]=X.[ANC3_Urine_Sugar]
,[ANC3_BloodSugar_Test]=X.[ANC3_BloodSugar_Test]
,[ANC3_Blood_Sugar_Fasting]=X.[ANC3_Blood_Sugar_Fasting]
,[ANC3_Blood_Sugar_Post_Prandial]=X.[ANC3_Blood_Sugar_Post_Prandial]
,[ANC3_FA_Given]=X.[ANC3_FA_Given]
,[ANC3_IFA_Given]=X.[ANC3_IFA_Given]
,[ANC3_Abdoman_FH]=X.[ANC3_Abdoman_FH]
,[ANC3_Abdoman_FHS]=X.[ANC3_Abdoman_FHS]
,[ANC3_Abdoman_FP]=X.[ANC3_Abdoman_FP]
,[ANC3_Foetal_Movment_VAL]=X.[ANC3_Foetal_Movements]
,[ANC3_Foetal_Movements]=dbo.[Get_Foetal_movement_Name](X.[ANC3_Foetal_Movements])
,[ANC3_Symptoms_High_Risk_VAL]=X.[ANC3_Symptoms_High_Risk]
,[ANC3_Symptoms_High_Risk]=dbo.[Get_Symptoms_High_Risk_Name](X.[ANC3_Symptoms_High_Risk],X.[ANC3_Other_Symptoms_High_Risk])
,[ANC3_Referal_Facility]=X.[ANC3_Referal_Facility]
,[ANC3_Referal_FacilityName]=X.[ANC3_Referal_FacilityName]
,[ANC3_Referal_Date]=X.[ANC3_Referal_Date]
,[ANC3_ANM_ID]=X.[ANC3_ANM_ID]
,[ANC3_ASHA_ID]=X.[ANC3_ASHA_ID]
,[ANC3_SourceID]=X.ANC3_SourceID
,ANC3_ANC_Facility_Done=dbo.Get_FacilityPlace_Service_Done(X.ANC3_FacilityPlaceANCDone)
,ANC3_ANC_Facility_DoneName=dbo.Get_FacilityPlace_Service_Done_Name(X.ANC3_FacilityPlaceANCDone,X.ANC3_FacilityLocationIDANCDone,X.ANC3_FacilityLocationANCDone)
,[ANC4]=X.ANC4_Date
,[ANC4_Pregnancy_Week]=X.[ANC4_Pregnancy_Week]
,[ANC4_Weight]=X.[ANC4_Weight]
,[ANC4_BP_Systolic]=X.[ANC4_BP_Systolic]
,[ANC4_BP_Distolic]=X.[ANC4_BP_Distolic]
,[ANC4_Hb_gm]=X.[ANC4_Hb_gm]
,[ANC4_Urine_Test]=X.[ANC4_Urine_Test]
,[ANC4_Urine_Albumin]=X.[ANC4_Urine_Albumin]
,[ANC4_Urine_Sugar]=X.[ANC4_Urine_Sugar]
,[ANC4_BloodSugar_Test]=X.[ANC4_BloodSugar_Test]
,[ANC4_Blood_Sugar_Fasting]=X.[ANC4_Blood_Sugar_Fasting]
,[ANC4_Blood_Sugar_Post_Prandial]=X.[ANC4_Blood_Sugar_Post_Prandial]
,[ANC4_FA_Given]=X.[ANC4_FA_Given]
,[ANC4_IFA_Given]=X.[ANC4_IFA_Given]
,[ANC4_Abdoman_FH]=X.[ANC4_Abdoman_FH]
,[ANC4_Abdoman_FHS]=X.[ANC4_Abdoman_FHS]
,[ANC4_Abdoman_FP]=X.[ANC4_Abdoman_FP]
,[ANC4_Foetal_Movment_VAL]=X.[ANC4_Foetal_Movements]
,[ANC4_Foetal_Movements]=dbo.[Get_Foetal_movement_Name](X.[ANC4_Foetal_Movements])
,[ANC4_Symptoms_High_Risk_VAL]=X.[ANC4_Symptoms_High_Risk]
,[ANC4_Symptoms_High_Risk]=dbo.[Get_Symptoms_High_Risk_Name](X.[ANC4_Symptoms_High_Risk],X.[ANC4_Other_Symptoms_High_Risk])
,[ANC4_Referal_Facility]=X.[ANC4_Referal_Facility]
,[ANC4_Referal_FacilityName]=X.[ANC4_Referal_FacilityName]
,[ANC4_Referal_Date]=X.[ANC4_Referal_Date]
,[ANC4_ANM_ID]=X.[ANC4_ANM_ID]
,[ANC4_ASHA_ID]=X.[ANC4_ASHA_ID]
,[ANC4_SourceID]=X.ANC4_SourceID
,ANC4_ANC_Facility_Done=dbo.Get_FacilityPlace_Service_Done(X.ANC4_FacilityPlaceANCDone)
,ANC4_ANC_Facility_DoneName=dbo.Get_FacilityPlace_Service_Done_Name(X.ANC4_FacilityPlaceANCDone,X.ANC4_FacilityLocationIDANCDone,X.ANC4_FacilityLocationANCDone)
-------------------------------------covid
,[ANC1_Is_ILI_Symptom]=X.[ANC1_Is_ILI_Symptom]
,[ANC1_Is_contact_Covid]=X.[ANC1_Is_contact_Covid]
,[ANC1_Covid_test_done]=X.[ANC1_Covid_test_done]
,[ANC1_Covid_test_result]=X.[ANC1_Covid_test_result]

,[ANC2_Is_ILI_Symptom]=X.[ANC2_Is_ILI_Symptom]
,[ANC2_Is_contact_Covid]=X.[ANC2_Is_contact_Covid]
,[ANC2_Covid_test_done]=X.[ANC2_Covid_test_done]
,[ANC2_Covid_test_result]=X.[ANC2_Covid_test_result]

,[ANC3_Is_ILI_Symptom]=X.[ANC3_Is_ILI_Symptom]
,[ANC3_Is_contact_Covid]=X.[ANC3_Is_contact_Covid]
,[ANC3_Covid_test_done]=X.[ANC3_Covid_test_done]
,[ANC3_Covid_test_result]=X.[ANC3_Covid_test_result]

,[ANC4_Is_ILI_Symptom]=X.[ANC4_Is_ILI_Symptom]
,[ANC4_Is_contact_Covid]=X.[ANC4_Is_contact_Covid]
,[ANC4_Covid_test_done]=X.[ANC4_Covid_test_done]
,[ANC4_Covid_test_result]=X.[ANC4_Covid_test_result]

,[ANC99_Is_ILI_Symptom]=X.[ANC99_Is_ILI_Symptom]
,[ANC99_Is_contact_Covid]=X.[ANC99_Is_contact_Covid]
,[ANC99_Covid_test_done]=X.[ANC99_Covid_test_done]
,[ANC99_Covid_test_result]=X.[ANC99_Covid_test_result]
------------------------------------------
,[AbortionDate]=X.[ANC99_Abortion_date]
,[Abortion_Preg_Weeks]=X.[ANC99_Pregnancy_Week]
,[Abortion_Type]=dbo.[Get_Mother_Abortion_Name](X.[ANC99_Abortion_Type])
,[Induced_Indicate_Facility]=dbo.Get_Mother_Induced_Indicate_Facility(X.[ANC99_Induced_Indicate_Facility])
,[Maternal_Death]=coalesce(nullif(X.[ANC1_Maternal_Death],0),nullif(X.[ANC2_Maternal_Death],0),nullif(X.[ANC3_Maternal_Death],0),nullif(X.[ANC4_Maternal_Death],0),nullif(X.[ANC99_Maternal_Death],0))
,[Death_Date]=coalesce(X.[ANC1_Death_Date],X.[ANC2_Death_Date],X.[ANC3_Death_Date],X.[ANC4_Death_Date],X.[ANC99_Death_Date])--Updated by Shital 22-11-2018 

,[Death_Reason]=coalesce(nullif(X.[ANC1_Death_Reason],'0'),nullif(X.[ANC2_Death_Reason],'0'),nullif(X.[ANC3_Death_Reason],'0'),nullif(X.[ANC4_Death_Reason],'0'),nullif(X.[ANC99_Death_Reason],'0'))
,[PPMC]=coalesce(nullif(X.[ANC1_PPMC],'0'),nullif(X.[ANC2_PPMC],'0'),nullif(X.[ANC3_PPMC],'0'),nullif(X.[ANC4_PPMC],'0'),nullif(X.ANC99_PPMC,'0'))
,[Exec_Date]=getdate()
,ANC_mode_execution=getdate()
,ANC1_done_FacilityID=X.ANC1_FacilityLocationIDANCDone
,ANC2_done_FacilityID=X.ANC2_FacilityLocationIDANCDone
,ANC3_done_FacilityID=X.ANC3_FacilityLocationIDANCDone
,ANC4_done_FacilityID=X.ANC4_FacilityLocationIDANCDone
from
(
  
  
  
select Registration_no,Case_no,[ANC1_Date],[ANC1_Pregnancy_Week],[ANC1_Weight],[ANC1_BP_Systolic],[ANC1_BP_Distolic],[ANC1_Hb_gm],[ANC1_Urine_Test],[ANC1_Urine_Albumin]
,[ANC1_Urine_Sugar],[ANC1_BloodSugar_Test],[ANC1_Blood_Sugar_Fasting],[ANC1_Blood_Sugar_Post_Prandial],[ANC1_FA_Given],[ANC1_IFA_Given],[ANC1_Abdoman_FH]
,[ANC1_Abdoman_FHS],[ANC1_Abdoman_FP],[ANC1_Foetal_Movements],[ANC1_Symptoms_High_Risk],[ANC1_Referal_Facility],[ANC1_Referal_FacilityName],[ANC1_Referal_Date]
,[ANC1_ANM_ID],[ANC1_ASHA_ID],[ANC1_Abortion_date],[ANC1_Abortion_Preg_Weeks],[ANC1_Abortion_Type],[ANC1_Induced_Indicate_Facility]
,[ANC1_Maternal_Death],[ANC1_Death_Date],[ANC1_Death_Reason],[ANC1_PPMC],[ANC1_Other_Symptoms_High_Risk],[ANC1_SourceID]
,[ANC1_FacilityPlaceANCDone],[ANC1_FacilityLocationIDANCDone],[ANC1_FacilityLocationANCDone]

,[ANC1_Is_ILI_Symptom],[ANC1_Is_contact_Covid],[ANC1_Covid_test_done],[ANC1_Covid_test_result]  --covid
,[ANC2_Date] ,[ANC2_Pregnancy_Week],[ANC2_Weight],[ANC2_BP_Systolic],[ANC2_BP_Distolic],[ANC2_Hb_gm],[ANC2_Urine_Test]
,[ANC2_Urine_Albumin],[ANC2_Urine_Sugar],[ANC2_BloodSugar_Test],[ANC2_Blood_Sugar_Fasting],[ANC2_Blood_Sugar_Post_Prandial],[ANC2_FA_Given],[ANC2_IFA_Given]
,[ANC2_Abdoman_FH],[ANC2_Abdoman_FHS],[ANC2_Abdoman_FP],[ANC2_Foetal_Movements],[ANC2_Symptoms_High_Risk],[ANC2_Referal_Facility],[ANC2_Referal_FacilityName]
,[ANC2_Referal_Date],[ANC2_ANM_ID],[ANC2_ASHA_ID],[ANC2_Abortion_date],[ANC2_Abortion_Preg_Weeks],[ANC2_Abortion_Type],[ANC2_Induced_Indicate_Facility]
,[ANC2_Maternal_Death],[ANC2_Death_Date],[ANC2_Death_Reason],[ANC2_PPMC],[ANC2_Other_Symptoms_High_Risk],[ANC2_SourceID]
,[ANC2_FacilityPlaceANCDone],[ANC2_FacilityLocationIDANCDone],[ANC2_FacilityLocationANCDone]

,[ANC2_Is_ILI_Symptom],[ANC2_Is_contact_Covid],[ANC2_Covid_test_done],[ANC2_Covid_test_result]  --covid
,[ANC3_Date],[ANC3_Pregnancy_Week],[ANC3_Weight],[ANC3_BP_Systolic],[ANC3_BP_Distolic],[ANC3_Hb_gm]
,[ANC3_Urine_Test],[ANC3_Urine_Albumin],[ANC3_Urine_Sugar],[ANC3_BloodSugar_Test],[ANC3_Blood_Sugar_Fasting],[ANC3_Blood_Sugar_Post_Prandial],[ANC3_FA_Given]
,[ANC3_IFA_Given],[ANC3_Abdoman_FH],[ANC3_Abdoman_FHS],[ANC3_Abdoman_FP],[ANC3_Foetal_Movements],[ANC3_Symptoms_High_Risk],[ANC3_Referal_Facility],[ANC3_Referal_FacilityName]
,[ANC3_Referal_Date],[ANC3_ANM_ID],[ANC3_ASHA_ID],[ANC3_Abortion_date],[ANC3_Abortion_Preg_Weeks],[ANC3_Abortion_Type],[ANC3_Induced_Indicate_Facility]
,[ANC3_Maternal_Death],[ANC3_Death_Date],[ANC3_Death_Reason],[ANC3_PPMC],[ANC3_Other_Symptoms_High_Risk],[ANC3_SourceID]
,[ANC3_FacilityPlaceANCDone],[ANC3_FacilityLocationIDANCDone],[ANC3_FacilityLocationANCDone]

,[ANC3_Is_ILI_Symptom],[ANC3_Is_contact_Covid],[ANC3_Covid_test_done],[ANC3_Covid_test_result]  --covid
,[ANC4_Date],[ANC4_Pregnancy_Week],[ANC4_Weight],[ANC4_BP_Systolic],[ANC4_BP_Distolic],[ANC4_Hb_gm],[ANC4_Urine_Test]
,[ANC4_Urine_Albumin],[ANC4_Urine_Sugar],[ANC4_BloodSugar_Test],[ANC4_Blood_Sugar_Fasting],[ANC4_Blood_Sugar_Post_Prandial],[ANC4_FA_Given],[ANC4_IFA_Given]
,[ANC4_Abdoman_FH],[ANC4_Abdoman_FHS],[ANC4_Abdoman_FP],[ANC4_Foetal_Movements],[ANC4_Symptoms_High_Risk],[ANC4_Referal_Facility],[ANC4_Referal_FacilityName]
,[ANC4_Referal_Date],[ANC4_ANM_ID],[ANC4_ASHA_ID],[ANC4_Abortion_date],[ANC4_Abortion_Preg_Weeks],[ANC4_Abortion_Type],[ANC4_Induced_Indicate_Facility] 
,[ANC4_Maternal_Death],[ANC4_Death_Date],[ANC4_Death_Reason],[ANC4_PPMC],[ANC4_Other_Symptoms_High_Risk],[ANC4_SourceID]
,[ANC4_FacilityPlaceANCDone],[ANC4_FacilityLocationIDANCDone],[ANC4_FacilityLocationANCDone]

,[ANC4_Is_ILI_Symptom],[ANC4_Is_contact_Covid],[ANC4_Covid_test_done],[ANC4_Covid_test_result]  --covid
,[ANC99_Date],[ANC99_Pregnancy_Week],[ANC99_Weight],[ANC99_BP_Systolic],[ANC99_BP_Distolic],[ANC99_Hb_gm],[ANC99_Urine_Test]
,[ANC99_Urine_Albumin],[ANC99_Urine_Sugar],[ANC99_BloodSugar_Test],[ANC99_Blood_Sugar_Fasting],[ANC99_Blood_Sugar_Post_Prandial],[ANC99_FA_Given],[ANC99_IFA_Given]
,[ANC99_Abdoman_FH],[ANC99_Abdoman_FHS],[ANC99_Abdoman_FP],[ANC99_Foetal_Movements],[ANC99_Symptoms_High_Risk],[ANC99_Referal_Facility],[ANC99_Referal_FacilityName]
,[ANC99_Referal_Date],[ANC99_ANM_ID],[ANC99_ASHA_ID],[ANC99_Abortion_date],[ANC99_Abortion_Preg_Weeks],[ANC99_Abortion_Type],[ANC99_Induced_Indicate_Facility] 
,[ANC99_Maternal_Death],[ANC99_Death_Date],[ANC99_Death_Reason],[ANC99_PPMC],[ANC99_Other_Symptoms_High_Risk],[ANC99_SourceID]

,[ANC99_Is_ILI_Symptom],[ANC99_Is_contact_Covid],[ANC99_Covid_test_done],[ANC99_Covid_test_result]  --covid
from 
(
select Registration_no,'ANC'+cast(ANC_Type as varchar(4))+'_'+col new_col,value,Case_no from
(select a.Registration_no,a.Case_no,ANC_Date,ANC_Type,Pregnancy_Month,[Weight],[BP_Systolic],[BP_Distolic],[Hb_gm],[Urine_Test],[Urine_Albumin],[Urine_Sugar]
,[BloodSugar_Test],[Blood_Sugar_Fasting],[Blood_Sugar_Post_Prandial],[FA_Given],[IFA_Given],[Abdoman_FH],[Abdoman_FHS],[Abdoman_FP],[Foetal_Movements]
,[Symptoms_High_Risk],[Referral_facility],[Referral_location],[Referral_Date],[ANM_ID],[ASHA_ID],TT_Date,Abortion_date,Abortion_Preg_Weeks,Abortion_Type
,Induced_Indicate_Facility,Maternal_Death,Death_Date,Death_Reason,PPMC,Other_Symptoms_High_Risk,SourceID,FacilityPlaceANCDone,FacilityLocationIDANCDone,FacilityLocationANCDone
--,isnull(Is_ILI_Symptom,0) Is_ILI_Symptom,isnull(Is_contact_Covid,0) Is_contact_Covid,isnull(Covid_test_done,0) Covid_test_done,isnull(Covid_test_result,0) Covid_test_result--covid
, Is_ILI_Symptom, Is_contact_Covid, Covid_test_done, Covid_test_result--covid
from t_mother_ANC  a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where MANC_Table=1
 ) t_mother_ANC
cross apply
  (
    VALUES
		  
            (cast(ANC_Type as nvarchar), 'Type'),
            (cast(ANC_Date as nvarchar), 'Date'),
			(cast(Pregnancy_Month as nvarchar), 'Pregnancy_Week'),
			(cast([Weight] as nvarchar), 'Weight'),
			(cast(BP_Systolic as nvarchar), 'BP_Systolic'),
			(cast(BP_Distolic as nvarchar), 'BP_Distolic'),
			(cast(Hb_gm as nvarchar), 'Hb_gm'),
			(cast((case Urine_Test when '1' then 'Done' when '2' then 'Not Done' else null end) as nvarchar), 'Urine_Test'),
			(cast((case Urine_Albumin when 'N' then 'Absent' when 'P' then 'Present' else null end) as nvarchar), 'Urine_Albumin'),
			(cast((case Urine_Sugar when 'N' then 'Absent' when 'P' then 'Present' else null end) as nvarchar), 'Urine_Sugar'),
			(cast((case BloodSugar_Test  when '1' then 'Done' when '2' then 'Not Done' else null end) as nvarchar), 'BloodSugar_Test'),
			(cast(Blood_Sugar_Fasting as nvarchar), 'Blood_Sugar_Fasting'),
			(cast(Blood_Sugar_Post_Prandial as nvarchar), 'Blood_Sugar_Post_Prandial'),
			(cast(FA_Given as nvarchar), 'FA_Given'),
			(cast(IFA_Given as nvarchar), 'IFA_Given'),
			(cast(Abdoman_FH as nvarchar), 'Abdoman_FH'),
			(cast(Abdoman_FHS as nvarchar), 'Abdoman_FHS'),
			(cast(Abdoman_FP as nvarchar), 'Abdoman_FP'),
			(cast(Foetal_Movements as nvarchar), 'Foetal_Movements'),
			(cast(Referral_facility as nvarchar), 'Referral_facility'),
			(cast(Symptoms_High_Risk as nvarchar), 'Symptoms_High_Risk'),
			(cast(Other_Symptoms_High_Risk as nvarchar), 'Other_Symptoms_High_Risk'),
			(cast(Referral_location as nvarchar) , 'Referral_location'),
			(cast(FacilityPlaceANCDone as nvarchar), 'FacilityPlaceANCDone'),
			(cast(FacilityLocationIDANCDone as nvarchar) , 'FacilityLocationIDANCDone'),
			(cast(FacilityLocationANCDone as nvarchar) , 'FacilityLocationANCDone'),
			(cast(Referral_Date as nvarchar), 'Referral_Date'),
			(cast(ANM_ID as nvarchar), 'ANM_ID'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID'),
			(cast(Abortion_date as nvarchar), 'Abortion_date'),
			(cast(Abortion_Preg_Weeks as nvarchar), 'Abortion_Preg_Weeks'),
			(cast(Abortion_Type as nvarchar), 'Abortion_Type'),
			(cast(Induced_Indicate_Facility as nvarchar), 'Induced_Indicate_Facility'),
			(cast(Maternal_Death as nvarchar), 'Maternal_Death'),
			(cast(Death_Date as nvarchar), 'Death_Date'),
			(cast(Death_Reason as nvarchar), 'Death_Reason'),
			(cast(SourceID as nvarchar), 'SourceID'),
			(cast(PPMC as nvarchar), 'PPMC'),
			(cast(Is_ILI_Symptom as nvarchar), 'Is_ILI_Symptom'),
			(cast(Is_contact_Covid as nvarchar), 'Is_contact_Covid'),
			(cast(Covid_test_done as nvarchar), 'Covid_test_done'),
			(cast(Covid_test_result as nvarchar), 'Covid_test_result')
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [ANC1_Date],[ANC1_Pregnancy_Week],[ANC1_Weight],[ANC1_BP_Systolic],[ANC1_BP_Distolic],[ANC1_Hb_gm],[ANC1_Urine_Test],[ANC1_Urine_Albumin],[ANC1_Urine_Sugar]
,[ANC1_BloodSugar_Test],[ANC1_Blood_Sugar_Fasting],[ANC1_Blood_Sugar_Post_Prandial],[ANC1_FA_Given],[ANC1_IFA_Given],[ANC1_Abdoman_FH],[ANC1_Abdoman_FHS]
,[ANC1_Abdoman_FP],[ANC1_Foetal_Movements],[ANC1_Symptoms_High_Risk],[ANC1_Referal_Facility],[ANC1_Referal_FacilityName],[ANC1_Referal_Date],[ANC1_ANM_ID]
,[ANC1_ASHA_ID],[ANC1_Abortion_date],[ANC1_Abortion_Preg_Weeks],[ANC1_Abortion_Type],[ANC1_Induced_Indicate_Facility],[ANC1_Maternal_Death],[ANC1_Death_Date]
,[ANC1_Death_Reason],[ANC1_PPMC],[ANC1_Other_Symptoms_High_Risk],[ANC1_SourceID]
,[ANC1_FacilityPlaceANCDone],[ANC1_FacilityLocationIDANCDone],[ANC1_FacilityLocationANCDone]
,[ANC1_Is_ILI_Symptom],[ANC1_Is_contact_Covid],[ANC1_Covid_test_done],[ANC1_Covid_test_result]  --covid
,[ANC2_Date],[ANC2_Pregnancy_Week],[ANC2_Weight],[ANC2_BP_Systolic],[ANC2_BP_Distolic],[ANC2_Hb_gm],[ANC2_Urine_Test],[ANC2_Urine_Albumin],[ANC2_Urine_Sugar]
,[ANC2_BloodSugar_Test],[ANC2_Blood_Sugar_Fasting],[ANC2_Blood_Sugar_Post_Prandial],[ANC2_FA_Given],[ANC2_IFA_Given],[ANC2_Abdoman_FH],[ANC2_Abdoman_FHS]
,[ANC2_Abdoman_FP],[ANC2_Foetal_Movements],[ANC2_Symptoms_High_Risk],[ANC2_Referal_Facility],[ANC2_Referal_FacilityName],[ANC2_Referal_Date],[ANC2_ANM_ID]
,[ANC2_ASHA_ID],[ANC2_Abortion_date],[ANC2_Abortion_Preg_Weeks],[ANC2_Abortion_Type],[ANC2_Induced_Indicate_Facility],[ANC2_Maternal_Death],[ANC2_Death_Date]
,[ANC2_Death_Reason],[ANC2_PPMC],[ANC2_Other_Symptoms_High_Risk],[ANC2_SourceID]
,[ANC2_FacilityPlaceANCDone],[ANC2_FacilityLocationIDANCDone],[ANC2_FacilityLocationANCDone]
,[ANC2_Is_ILI_Symptom],[ANC2_Is_contact_Covid],[ANC2_Covid_test_done],[ANC2_Covid_test_result]  --covid
,[ANC3_Date],[ANC3_Pregnancy_Week],[ANC3_Weight],[ANC3_BP_Systolic],[ANC3_BP_Distolic],[ANC3_Hb_gm],[ANC3_Urine_Test],[ANC3_Urine_Albumin],[ANC3_Urine_Sugar]
,[ANC3_BloodSugar_Test],[ANC3_Blood_Sugar_Fasting],[ANC3_Blood_Sugar_Post_Prandial],[ANC3_FA_Given],[ANC3_IFA_Given],[ANC3_Abdoman_FH],[ANC3_Abdoman_FHS]
,[ANC3_Abdoman_FP],[ANC3_Foetal_Movements],[ANC3_Symptoms_High_Risk],[ANC3_Referal_Facility],[ANC3_Referal_FacilityName],[ANC3_Referal_Date],[ANC3_ANM_ID]
,[ANC3_ASHA_ID],[ANC3_Abortion_date],[ANC3_Abortion_Preg_Weeks],[ANC3_Abortion_Type],[ANC3_Induced_Indicate_Facility],[ANC3_Maternal_Death],[ANC3_Death_Date]
,[ANC3_Death_Reason],[ANC3_PPMC],[ANC3_Other_Symptoms_High_Risk],[ANC3_SourceID]
,[ANC3_FacilityPlaceANCDone],[ANC3_FacilityLocationIDANCDone],[ANC3_FacilityLocationANCDone]
,[ANC3_Is_ILI_Symptom],[ANC3_Is_contact_Covid],[ANC3_Covid_test_done],[ANC3_Covid_test_result]  --covid
,[ANC4_Date],[ANC4_Pregnancy_Week],[ANC4_Weight],[ANC4_BP_Systolic],[ANC4_BP_Distolic],[ANC4_Hb_gm],[ANC4_Urine_Test],[ANC4_Urine_Albumin],[ANC4_Urine_Sugar]
,[ANC4_BloodSugar_Test],[ANC4_Blood_Sugar_Fasting],[ANC4_Blood_Sugar_Post_Prandial],[ANC4_FA_Given],[ANC4_IFA_Given],[ANC4_Abdoman_FH],[ANC4_Abdoman_FHS]
,[ANC4_Abdoman_FP],[ANC4_Foetal_Movements],[ANC4_Symptoms_High_Risk],[ANC4_Referal_Facility],[ANC4_Referal_FacilityName],[ANC4_Referal_Date],[ANC4_ANM_ID]
,[ANC4_ASHA_ID],[ANC4_Abortion_date],[ANC4_Abortion_Preg_Weeks],[ANC4_Abortion_Type],[ANC4_Induced_Indicate_Facility],[ANC4_Maternal_Death],[ANC4_Death_Date]
,[ANC4_Death_Reason],[ANC4_PPMC],[ANC4_Other_Symptoms_High_Risk],[ANC4_SourceID]
,[ANC4_FacilityPlaceANCDone],[ANC4_FacilityLocationIDANCDone],[ANC4_FacilityLocationANCDone]
,[ANC4_Is_ILI_Symptom],[ANC4_Is_contact_Covid],[ANC4_Covid_test_done],[ANC4_Covid_test_result]  --covid
,[ANC99_Date],[ANC99_Pregnancy_Week],[ANC99_Weight],[ANC99_BP_Systolic],[ANC99_BP_Distolic],[ANC99_Hb_gm],[ANC99_Urine_Test]
,[ANC99_Urine_Albumin],[ANC99_Urine_Sugar],[ANC99_BloodSugar_Test],[ANC99_Blood_Sugar_Fasting],[ANC99_Blood_Sugar_Post_Prandial],[ANC99_FA_Given],[ANC99_IFA_Given]
,[ANC99_Abdoman_FH],[ANC99_Abdoman_FHS],[ANC99_Abdoman_FP],[ANC99_Foetal_Movements],[ANC99_Symptoms_High_Risk],[ANC99_Referal_Facility],[ANC99_Referal_FacilityName]
,[ANC99_Referal_Date],[ANC99_ANM_ID],[ANC99_ASHA_ID],[ANC99_Abortion_date],[ANC99_Abortion_Preg_Weeks],[ANC99_Abortion_Type],[ANC99_Induced_Indicate_Facility] 
,[ANC99_Maternal_Death],[ANC99_Death_Date],[ANC99_Death_Reason],[ANC99_PPMC],[ANC99_Other_Symptoms_High_Risk],[ANC99_SourceID]
,[ANC99_Is_ILI_Symptom],[ANC99_Is_contact_Covid],[ANC99_Covid_test_done],[ANC99_Covid_test_result]  --covid
)
) piv
  
  )X
  
  where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no
  
  
 update t_mother_flat set TT1=X.TT1,TT2=X.TT2,TTB=X.TTB,[Exec_Date]=getdate() from(
select Registration_no,Case_no,TT13_Date as [TT1],TT14_Date as TT2,TT17_Date as TTB from
(
select Registration_no,'TT'+cast(TT_Code as varchar(4))+'_'+col new_col,value,Case_no from
(select a.Registration_no,a.Case_no,TT_Code,TT_Date
from t_mother_ANC a   
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where MANC_Table=1
) t_mother_ANC
cross apply
  (
    VALUES
		  
            (cast(TT_Code as nvarchar), 'Code'),
            (cast(TT_Date as nvarchar), 'Date')
			
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [TT13_Code],[TT13_Date],[TT14_Code],[TT14_Date],[TT17_Code],[TT17_Date])
) piv
 
  )X where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no
  
  --Added on 08022017
  update t_mother_flat set ANC1_visit=X.ANC1_Visit,ANC2_visit=X.ANC2_Visit,ANC3_visit=X.ANC3_Visit
,ANC4_visit=X.ANC4_Visit,ANC5_visit=X.ANC5_Visit,ANC6_visit=X.ANC6_Visit,ANC7_visit=X.ANC7_Visit,ANC8_visit=X.ANC8_Visit,ANC9_visit=X.ANC9_Visit,ANC10_visit=X.ANC10_Visit
,ANC11_visit=X.ANC11_Visit,ANC12_visit=X.ANC12_Visit,ANC13_visit=X.ANC13_Visit,[Exec_Date]=getdate() from 
(
select Registration_no,Case_no,[1] as ANC1_Visit,[2] as ANC2_Visit,[3] as ANC3_Visit,[4] as ANC4_Visit,[5] as ANC5_Visit,[6] as ANC6_Visit
,[7] as ANC7_Visit,[8] as ANC8_Visit,[9] as ANC9_Visit,[10] as ANC10_Visit,[11] as ANC11_Visit,[12] as ANC12_Visit,[13] as ANC13_Visit
from 
(
 select a.Registration_no,a.Case_no,ANC_No,ANC_Type
from t_mother_anc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where MANC_Table=1

) src
pivot
(
  max(ANC_Type)
  for ANC_No in ([1], [2], [3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
) piv

)X
where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

----added on 07022023
Update t_mother_flat set ANC1_IFA_Given=x.ANC1_IFA_Given,ANC2_IFA_Given=x.ANC2_IFA_Given,ANC3_IFA_Given=x.ANC3_IFA_Given,ANC4_IFA_Given=x.ANC4_IFA_Given
,ANC1_FA_Given=x.ANC1_FA_Given,ANC2_FA_Given=x.ANC2_FA_Given,ANC3_FA_Given=x.ANC3_FA_Given,ANC4_FA_Given=x.ANC4_FA_Given,Exec_Date=getdate()
from(select b.Registration_no,b.case_no,sum(isnull(case when b.ANC_Type=1 then b.IFA_Given end,0))ANC1_IFA_Given,sum(isnull(case when b.ANC_Type=2 then b.IFA_Given end,0))ANC2_IFA_Given ,
sum(isnull(case when b.ANC_Type=3 then b.IFA_Given end,0))ANC3_IFA_Given,sum(isnull(case when b.ANC_Type=4 then b.IFA_Given end,0))ANC4_IFA_Given,
sum(isnull(case when b.ANC_Type=1 then b.FA_Given end,0))ANC1_FA_Given,sum(isnull(case when b.ANC_Type=2 then b.FA_Given end,0))ANC2_FA_Given ,
sum(isnull(case when b.ANC_Type=3 then b.FA_Given end,0))ANC3_FA_Given,sum(isnull(case when b.ANC_Type=4 then b.FA_Given end,0))ANC4_FA_Given  from
(select a.Registration_no,a.Case_no,ANC_Type,Sum(isnull(FA_Given,0))FA_Given,Sum(isnull(IFA_Given,0))IFA_Given from t_mother_anc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
group by a.Registration_no, a.Case_no,ANC_Type)b
group by b.Registration_no,b.Case_no)X
where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no
  ---------------------------------------------------mother PNC----------------------------------------------------------------------------------
  update t_mother_flat set  [PNC1_No]=X.PNC1_No
	 ,[PNC1_Type]=X.[PNC1_Type]
      ,[PNC1_Date]=X.[PNC1_Date]
      ,[PNC1_IFA_Tab]=X.[PNC1_IFA_Tab]
      ,[PNC1_DangerSign_Mother_VAL]=X.[PNC1_DangerSign_Mother_VAL]
      ,[PNC1_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC1_DangerSign_Mother_VAL]),x.PNC1_DangerSign_Mother_Other) 
      ,[PNC1_ReferralFacility_Mother_VAL]=X.[PNC1_ReferralFacility_Mother_VAL]
      ,[PNC1_ReferralFacility_Mother]=X.PNC1_ReferralFacility_Mother 
      ,[PNC1_PPC_VAL]=X.[PNC1_PPC_VAL]
      ,[PNC1_PPC]=dbo.Get_PPC_Name(X.[PNC1_PPC_VAL])
      ,[PNC1_ANM_ID]=X.[PNC1_ANM_ID]
      ,[PNC1_ASHA_ID]=X.[PNC1_ASHA_ID]
      ,[PNC1_Created_by]=X.[PNC1_Created_by]
      ,[PNC1_Mobile_ID]=X.[PNC1_Mobile_ID]
      ,[PNC1_Source_ID]=X.[PNC1_Source_ID]
      ,[PNC2_No]=X.PNC2_No
	  ,[PNC2_Type]=X.[PNC2_Type]
      ,[PNC2_Date]=X.[PNC2_Date]
      ,[PNC2_IFA_Tab]=X.[PNC2_IFA_Tab]
      ,[PNC2_DangerSign_Mother_VAL]=X.[PNC2_DangerSign_Mother_VAL]
      ,[PNC2_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC2_DangerSign_Mother_VAL]),x.PNC2_DangerSign_Mother_Other) 
      ,[PNC2_ReferralFacility_Mother_VAL]=X.[PNC2_ReferralFacility_Mother_VAL]
      ,[PNC2_ReferralFacility_Mother]=X.[PNC2_ReferralFacility_Mother]
      ,[PNC2_PPC_VAL]=X.[PNC2_PPC_VAL]
      ,[PNC2_PPC]=dbo.Get_PPC_Name(X.[PNC2_PPC_VAL])
      ,[PNC2_ANM_ID]=X.[PNC2_ANM_ID]
      ,[PNC2_ASHA_ID]=X.[PNC2_ASHA_ID]
      ,[PNC2_Created_by]=X.[PNC2_Created_by]
      ,[PNC2_Mobile_ID]=X.[PNC2_Mobile_ID]
      ,[PNC2_Source_ID]=X.[PNC2_Source_ID]
      ,[PNC3_No]=X.PNC3_No
	  ,[PNC3_Type]=X.[PNC3_Type]
      ,[PNC3_Date]=X.[PNC3_Date]
      ,[PNC3_IFA_Tab]=X.[PNC3_IFA_Tab]
      ,[PNC3_DangerSign_Mother_VAL]=X.[PNC3_DangerSign_Mother_VAL]
      ,[PNC3_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC3_DangerSign_Mother_VAL]),x.PNC3_DangerSign_Mother_Other) 
      ,[PNC3_ReferralFacility_Mother_VAL]=X.[PNC3_ReferralFacility_Mother_VAL]
      ,[PNC3_ReferralFacility_Mother]=X.[PNC3_ReferralFacility_Mother]
      ,[PNC3_PPC_VAL]=X.[PNC3_PPC_VAL]
      ,[PNC3_PPC]=dbo.Get_PPC_Name(X.[PNC3_PPC_VAL])
      ,[PNC3_ANM_ID]=X.[PNC3_ANM_ID]
      ,[PNC3_ASHA_ID]=X.[PNC3_ASHA_ID]
      ,[PNC3_Created_by]=X.[PNC3_Created_by]
      ,[PNC3_Mobile_ID]=X.[PNC3_Mobile_ID]
      ,[PNC3_Source_ID]=X.[PNC3_Source_ID]
      ,[PNC4_No]=X.PNC4_No
	  ,[PNC4_Type]=X.[PNC4_Type]
      ,[PNC4_Date]=X.[PNC4_Date]
      ,[PNC4_IFA_Tab]=X.[PNC4_IFA_Tab]
      ,[PNC4_DangerSign_Mother_VAL]=X.[PNC4_DangerSign_Mother_VAL]
      ,[PNC4_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC4_DangerSign_Mother_VAL]),x.PNC4_DangerSign_Mother_Other) 
      ,[PNC4_ReferralFacility_Mother_VAL]=X.[PNC4_ReferralFacility_Mother_VAL]
      ,[PNC4_ReferralFacility_Mother]=X.[PNC4_ReferralFacility_Mother]
      ,[PNC4_PPC_VAL]=X.[PNC4_PPC_VAL]
      ,[PNC4_PPC]=dbo.Get_PPC_Name(X.[PNC4_PPC_VAL])
      ,[PNC4_ANM_ID]=X.[PNC4_ANM_ID]
      ,[PNC4_ASHA_ID]=X.[PNC4_ASHA_ID]
      ,[PNC4_Created_by]=X.[PNC4_Created_by]
      ,[PNC4_Mobile_ID]=X.[PNC4_Mobile_ID]
      ,[PNC4_Source_ID]=X.[PNC4_Source_ID]
      ,[PNC5_No]=X.PNC5_No
	  ,[PNC5_Type]=X.[PNC5_Type]
      ,[PNC5_Date]=X.[PNC5_Date]
      ,[PNC5_IFA_Tab]=X.[PNC5_IFA_Tab]
      ,[PNC5_DangerSign_Mother_VAL]=X.[PNC5_DangerSign_Mother_VAL]
      ,[PNC5_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC5_DangerSign_Mother_VAL]),x.PNC5_DangerSign_Mother_Other) 
      ,[PNC5_ReferralFacility_Mother_VAL]=X.[PNC5_ReferralFacility_Mother_VAL]
      ,[PNC5_ReferralFacility_Mother]=X.[PNC5_ReferralFacility_Mother]
      ,[PNC5_PPC_VAL]=X.[PNC5_PPC_VAL]
      ,[PNC5_PPC]=dbo.Get_PPC_Name(X.[PNC5_PPC_VAL])
      ,[PNC5_ANM_ID]=X.[PNC5_ANM_ID]
      ,[PNC5_ASHA_ID]=X.[PNC5_ASHA_ID]
      ,[PNC5_Created_by]=X.[PNC5_Created_by]
      ,[PNC5_Mobile_ID]=X.[PNC5_Mobile_ID]
      ,[PNC5_Source_ID]=X.[PNC5_Source_ID]
      ,[PNC6_No]=X.PNC6_No
	  ,[PNC6_Type]=X.[PNC6_Type]
      ,[PNC6_Date]=X.[PNC6_Date]
      ,[PNC6_IFA_Tab]=X.[PNC6_IFA_Tab]
      ,[PNC6_DangerSign_Mother_VAL]=X.[PNC6_DangerSign_Mother_VAL]
      ,[PNC6_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC6_DangerSign_Mother_VAL]),X.PNC6_DangerSign_Mother_Other) 
      ,[PNC6_ReferralFacility_Mother_VAL]=X.[PNC6_ReferralFacility_Mother_VAL]
      ,[PNC6_ReferralFacility_Mother]=X.[PNC6_ReferralFacility_Mother]
      ,[PNC6_PPC_VAL]=X.[PNC6_PPC_VAL]
      ,[PNC6_PPC]=dbo.Get_PPC_Name(X.[PNC6_PPC_VAL])
      ,[PNC6_ANM_ID]=X.[PNC6_ANM_ID]
      ,[PNC6_ASHA_ID]=X.[PNC6_ASHA_ID]
      ,[PNC6_Created_by]=X.[PNC6_Created_by]
      ,[PNC6_Mobile_ID]=X.[PNC6_Mobile_ID]
      ,[PNC6_Source_ID]=X.[PNC6_Source_ID]
      ,[PNC7_No]=X.PNC7_No
	  ,[PNC7_Type]=X.[PNC7_Type]
      ,[PNC7_Date]=X.[PNC7_Date]
      ,[PNC7_IFA_Tab]=X.[PNC7_IFA_Tab]
      ,[PNC7_DangerSign_Mother_VAL]=X.[PNC7_DangerSign_Mother_VAL]
      ,[PNC7_DangerSign_Mother]=coalesce(dbo.Get_Mother_Danger_Sign_Name(X.[PNC7_DangerSign_Mother_VAL]),X.PNC7_DangerSign_Mother_Other) 
      ,[PNC7_ReferralFacility_Mother_VAL]=X.[PNC7_ReferralFacility_Mother_VAL]
      ,[PNC7_ReferralFacility_Mother]=X.[PNC7_ReferralFacility_Mother]
      ,[PNC7_PPC_VAL]=X.[PNC7_PPC_VAL]
      ,[PNC7_PPC]=dbo.Get_PPC_Name(X.[PNC7_PPC_VAL])
      ,[PNC7_ANM_ID]=X.[PNC7_ANM_ID]
      ,[PNC7_ASHA_ID]=X.[PNC7_ASHA_ID]
      ,[PNC7_Created_by]=X.[PNC7_Created_by]
      ,[PNC7_Mobile_ID]=X.[PNC7_Mobile_ID]
      ,[PNC7_Source_ID]=X.[PNC7_Source_ID]
      -------------------------------------covid
,[PNC1_Is_ILI_Symptom]=X.[PNC1_Is_ILI_Symptom]
,[PNC1_Is_contact_Covid]=X.[PNC1_Is_contact_Covid]
,[PNC1_Covid_test_done]=X.[PNC1_Covid_test_done]
,[PNC1_Covid_test_result]=X.[PNC1_Covid_test_result]

,[PNC2_Is_ILI_Symptom]=X.[PNC2_Is_ILI_Symptom]
,[PNC2_Is_contact_Covid]=X.[PNC2_Is_contact_Covid]
,[PNC2_Covid_test_done]=X.[PNC2_Covid_test_done]
,[PNC2_Covid_test_result]=X.[PNC2_Covid_test_result]

,[PNC3_Is_ILI_Symptom]=X.[PNC3_Is_ILI_Symptom]
,[PNC3_Is_contact_Covid]=X.[PNC3_Is_contact_Covid]
,[PNC3_Covid_test_done]=X.[PNC3_Covid_test_done]
,[PNC3_Covid_test_result]=X.[PNC3_Covid_test_result]

,[PNC4_Is_ILI_Symptom]=X.[PNC4_Is_ILI_Symptom]
,[PNC4_Is_contact_Covid]=X.[PNC4_Is_contact_Covid]
,[PNC4_Covid_test_done]=X.[PNC4_Covid_test_done]
,[PNC4_Covid_test_result]=X.[PNC4_Covid_test_result]

,[PNC5_Is_ILI_Symptom]=X.[PNC5_Is_ILI_Symptom]
,[PNC5_Is_contact_Covid]=X.[PNC5_Is_contact_Covid]
,[PNC5_Covid_test_done]=X.[PNC5_Covid_test_done]
,[PNC5_Covid_test_result]=X.[PNC5_Covid_test_result]

,[PNC6_Is_ILI_Symptom]=X.[PNC6_Is_ILI_Symptom]
,[PNC6_Is_contact_Covid]=X.[PNC6_Is_contact_Covid]
,[PNC6_Covid_test_done]=X.[PNC6_Covid_test_done]
,[PNC6_Covid_test_result]=X.[PNC6_Covid_test_result]

,[PNC7_Is_ILI_Symptom]=X.[PNC7_Is_ILI_Symptom]
,[PNC7_Is_contact_Covid]=X.[PNC7_Is_contact_Covid]
,[PNC7_Covid_test_done]=X.[PNC7_Covid_test_done]
,[PNC7_Covid_test_result]=X.[PNC7_Covid_test_result]

-------------------------------------------------------
      ,[Exec_Date]=getdate()
	  ,MPNC_mode_execution=getdate()
      from
      (
  
  select Registration_no,Case_no, [PNC1_No],PNC1_Type,[PNC1_Date],[PNC1_IFA_Tab],[PNC1_DangerSign_Mother_VAL]
  ,PNC1_DangerSign_Mother,[PNC1_ReferralFacility_Mother_VAL]
 ,PNC1_ReferralFacility_Mother,[PNC1_PPC_VAL],[PNC1_ANM_ID],[PNC1_ASHA_ID],[PNC1_Created_by],[PNC1_Mobile_ID],[PNC1_Source_ID]
 ,[PNC1_Mother_Death_Place],[PNC1_Mother_Death_Date],[PNC1_Mother_Death_Reason_VAL],[PNC1_Mother_Death_Reason_Other],PNC1_DangerSign_Mother_Other
 ,[PNC1_Is_ILI_Symptom],[PNC1_Is_contact_Covid],[PNC1_Covid_test_done],[PNC1_Covid_test_result]  --covid
 ,[PNC2_No],PNC2_Type,[PNC2_Date],[PNC2_IFA_Tab],[PNC2_DangerSign_Mother_VAL],PNC2_DangerSign_Mother,[PNC2_ReferralFacility_Mother_VAL]
 ,PNC2_ReferralFacility_Mother,[PNC2_PPC_VAL],[PNC2_ANM_ID],[PNC2_ASHA_ID],[PNC2_Created_by],[PNC2_Mobile_ID],[PNC2_Source_ID]
 ,[PNC2_Mother_Death_Place],[PNC2_Mother_Death_Date],[PNC2_Mother_Death_Reason_VAL],[PNC2_Mother_Death_Reason_Other],PNC2_DangerSign_Mother_Other
 ,[PNC2_Is_ILI_Symptom],[PNC2_Is_contact_Covid],[PNC2_Covid_test_done],[PNC2_Covid_test_result]  --covid
 ,[PNC3_No],PNC3_Type,[PNC3_Date],[PNC3_IFA_Tab],[PNC3_DangerSign_Mother_VAL],PNC3_DangerSign_Mother,[PNC3_ReferralFacility_Mother_VAL]
 ,PNC3_ReferralFacility_Mother,[PNC3_PPC_VAL],[PNC3_ANM_ID],[PNC3_ASHA_ID],[PNC3_Created_by],[PNC3_Mobile_ID],[PNC3_Source_ID]
 ,[PNC3_Mother_Death_Place],[PNC3_Mother_Death_Date],[PNC3_Mother_Death_Reason_VAL],[PNC3_Mother_Death_Reason_Other],PNC3_DangerSign_Mother_Other
 ,[PNC3_Is_ILI_Symptom],[PNC3_Is_contact_Covid],[PNC3_Covid_test_done],[PNC3_Covid_test_result]  --covid
 ,[PNC4_No],PNC4_Type,[PNC4_Date],[PNC4_IFA_Tab],[PNC4_DangerSign_Mother_VAL],PNC4_DangerSign_Mother,[PNC4_ReferralFacility_Mother_VAL]
 ,PNC4_ReferralFacility_Mother,[PNC4_PPC_VAL],[PNC4_ANM_ID],[PNC4_ASHA_ID],[PNC4_Created_by],[PNC4_Mobile_ID],[PNC4_Source_ID]
 ,[PNC4_Mother_Death_Place],[PNC4_Mother_Death_Date],[PNC4_Mother_Death_Reason_VAL],[PNC4_Mother_Death_Reason_Other],PNC4_DangerSign_Mother_Other
  ,[PNC4_Is_ILI_Symptom],[PNC4_Is_contact_Covid],[PNC4_Covid_test_done],[PNC4_Covid_test_result]  --covid
 ,[PNC5_No],PNC5_Type,[PNC5_Date],[PNC5_IFA_Tab],[PNC5_DangerSign_Mother_VAL],PNC5_DangerSign_Mother,[PNC5_ReferralFacility_Mother_VAL]
 ,PNC5_ReferralFacility_Mother,[PNC5_PPC_VAL],[PNC5_ANM_ID],[PNC5_ASHA_ID],[PNC5_Created_by],[PNC5_Mobile_ID],[PNC5_Source_ID]
 ,[PNC5_Mother_Death_Place],[PNC5_Mother_Death_Date],[PNC5_Mother_Death_Reason_VAL],[PNC5_Mother_Death_Reason_Other],PNC5_DangerSign_Mother_Other
 ,[PNC5_Is_ILI_Symptom],[PNC5_Is_contact_Covid],[PNC5_Covid_test_done],[PNC5_Covid_test_result]  --covid
 ,[PNC6_No],PNC6_Type,[PNC6_Date],[PNC6_IFA_Tab],[PNC6_DangerSign_Mother_VAL],PNC6_DangerSign_Mother,[PNC6_ReferralFacility_Mother_VAL]
 ,PNC6_ReferralFacility_Mother,[PNC6_PPC_VAL],[PNC6_ANM_ID],[PNC6_ASHA_ID],[PNC6_Created_by],[PNC6_Mobile_ID],[PNC6_Source_ID]
 ,[PNC6_Mother_Death_Place],[PNC6_Mother_Death_Date],[PNC6_Mother_Death_Reason_VAL],[PNC6_Mother_Death_Reason_Other],PNC6_DangerSign_Mother_Other
 ,[PNC6_Is_ILI_Symptom],[PNC6_Is_contact_Covid],[PNC6_Covid_test_done],[PNC6_Covid_test_result]  --covid
 ,[PNC7_No],PNC7_Type,[PNC7_Date],[PNC7_IFA_Tab],[PNC7_DangerSign_Mother_VAL],PNC7_DangerSign_Mother,[PNC7_ReferralFacility_Mother_VAL]
 ,PNC7_ReferralFacility_Mother,[PNC7_PPC_VAL],[PNC7_ANM_ID],[PNC7_ASHA_ID],[PNC7_Created_by],[PNC7_Mobile_ID],[PNC7_Source_ID]
 ,[PNC7_Mother_Death_Place],[PNC7_Mother_Death_Date],[PNC7_Mother_Death_Reason_VAL],[PNC7_Mother_Death_Reason_Other],PNC7_DangerSign_Mother_Other
  ,[PNC7_Is_ILI_Symptom],[PNC7_Is_contact_Covid],[PNC7_Covid_test_done],[PNC7_Covid_test_result]  --covid
from 
(
select Registration_no,'PNC'+cast(PNC_type as varchar(4))+'_'+col new_col,value,Case_no from
(select a.Registration_no,a.Case_no,PNC_No,PNC_Type,PNC_Date,No_of_IFA_Tabs_given_to_mother,DangerSign_Mother,DangerSign_Mother_Other
,ReferralFacility_Mother,ReferralFacilityID_Mother,ReferralLoationOther_Mother,PPC,
ANM_ID,ASHA_ID,Place_of_death ,Mother_Death_Date ,Mother_Death_Reason,Mother_Death_Reason_Other,Created_By,Mobile_ID,SourceID
--,isnull(Is_ILI_Symptom,0) Is_ILI_Symptom,isnull(Is_contact_Covid,0) Is_contact_Covid,isnull(Covid_test_done,0) Covid_test_done,isnull(Covid_test_result,0) Covid_test_result--covid
, Is_ILI_Symptom, Is_contact_Covid, Covid_test_done, Covid_test_result--covid
from t_mother_pnc  a   
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where MPNC_Table=1
) t_mother_pnc
cross apply
  (
    VALUES
		  
            (cast(PNC_No as nvarchar), 'No'),
            (cast(PNC_Type as nvarchar), 'Type'),
			(cast(PNC_Date as nvarchar), 'Date'),
			(cast(No_of_IFA_Tabs_given_to_mother as nvarchar), 'IFA_Tab'),
			(cast(DangerSign_Mother as nvarchar), 'DangerSign_Mother_VAL'),
			(cast(DangerSign_Mother_Other as nvarchar), 'DangerSign_Mother_Other'),
			(cast(ReferralFacility_Mother as nvarchar), 'ReferralFacility_Mother_VAL'),
			(cast(ReferralFacilityID_Mother as nvarchar), 'ReferralFacilityID_Mother'),
			(cast(ReferralLoationOther_Mother as nvarchar), 'ReferralLoationOther_Mother'),
			(cast(PPC as nvarchar), 'PPC_VAL'),
			(cast(ANM_ID as nvarchar), 'ANM_ID'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID'),
			(cast(Place_of_death as nvarchar), 'Mother_Death_Place'),
			(cast(Mother_Death_Date as nvarchar), 'Mother_Death_Date'),
			(cast(Mother_Death_Reason as nvarchar), 'Mother_Death_Reason_VAL'),
			(cast(Mother_Death_Reason_Other as nvarchar), 'Mother_Death_Reason_Other'),
			(cast(Created_By as nvarchar), 'Created_By'),
			(cast(Mobile_ID as nvarchar), 'Mobile_ID'),
			(cast(SourceID as nvarchar), 'Source_ID'),
			(cast(Is_ILI_Symptom as nvarchar), 'Is_ILI_Symptom'),
			(cast(Is_contact_Covid as nvarchar), 'Is_contact_Covid'),
			(cast(Covid_test_done as nvarchar), 'Covid_test_done'),
			(cast(Covid_test_result as nvarchar), 'Covid_test_result')
		
			
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [PNC1_No],PNC1_Type,[PNC1_Date],[PNC1_IFA_Tab],[PNC1_DangerSign_Mother_VAL],PNC1_DangerSign_Mother,[PNC1_ReferralFacility_Mother_VAL]
 ,PNC1_ReferralFacility_Mother,[PNC1_PPC_VAL],[PNC1_ANM_ID],[PNC1_ASHA_ID],[PNC1_Created_by],[PNC1_Mobile_ID],[PNC1_Source_ID]
 ,[PNC1_Mother_Death_Place],[PNC1_Mother_Death_Date],[PNC1_Mother_Death_Reason_VAL],[PNC1_Mother_Death_Reason_Other],PNC1_DangerSign_Mother_Other
 ,[PNC1_Is_ILI_Symptom],[PNC1_Is_contact_Covid],[PNC1_Covid_test_done],[PNC1_Covid_test_result]  --covid
 ,[PNC2_No],PNC2_Type,[PNC2_Date],[PNC2_IFA_Tab],[PNC2_DangerSign_Mother_VAL],PNC2_DangerSign_Mother,[PNC2_ReferralFacility_Mother_VAL]
 ,PNC2_ReferralFacility_Mother,[PNC2_PPC_VAL],[PNC2_ANM_ID],[PNC2_ASHA_ID],[PNC2_Created_by],[PNC2_Mobile_ID],[PNC2_Source_ID]
 ,[PNC2_Mother_Death_Place],[PNC2_Mother_Death_Date],[PNC2_Mother_Death_Reason_VAL],[PNC2_Mother_Death_Reason_Other],PNC2_DangerSign_Mother_Other
 ,[PNC2_Is_ILI_Symptom],[PNC2_Is_contact_Covid],[PNC2_Covid_test_done],[PNC2_Covid_test_result]  --covid
 ,[PNC3_No],PNC3_Type,[PNC3_Date],[PNC3_IFA_Tab],[PNC3_DangerSign_Mother_VAL],PNC3_DangerSign_Mother,[PNC3_ReferralFacility_Mother_VAL]
 ,PNC3_ReferralFacility_Mother,[PNC3_PPC_VAL],[PNC3_ANM_ID],[PNC3_ASHA_ID],[PNC3_Created_by],[PNC3_Mobile_ID],[PNC3_Source_ID]
 ,[PNC3_Mother_Death_Place],[PNC3_Mother_Death_Date],[PNC3_Mother_Death_Reason_VAL],[PNC3_Mother_Death_Reason_Other],PNC3_DangerSign_Mother_Other
 ,[PNC3_Is_ILI_Symptom],[PNC3_Is_contact_Covid],[PNC3_Covid_test_done],[PNC3_Covid_test_result]  --covid
 ,[PNC4_No],PNC4_Type,[PNC4_Date],[PNC4_IFA_Tab],[PNC4_DangerSign_Mother_VAL],PNC4_DangerSign_Mother,[PNC4_ReferralFacility_Mother_VAL]
 ,PNC4_ReferralFacility_Mother,[PNC4_PPC_VAL],[PNC4_ANM_ID],[PNC4_ASHA_ID],[PNC4_Created_by],[PNC4_Mobile_ID],[PNC4_Source_ID]
 ,[PNC4_Mother_Death_Place],[PNC4_Mother_Death_Date],[PNC4_Mother_Death_Reason_VAL],[PNC4_Mother_Death_Reason_Other],PNC4_DangerSign_Mother_Other
 ,[PNC4_Is_ILI_Symptom],[PNC4_Is_contact_Covid],[PNC4_Covid_test_done],[PNC4_Covid_test_result]  --covid
 ,[PNC5_No],PNC5_Type,[PNC5_Date],[PNC5_IFA_Tab],[PNC5_DangerSign_Mother_VAL],PNC5_DangerSign_Mother,[PNC5_ReferralFacility_Mother_VAL]
 ,PNC5_ReferralFacility_Mother,[PNC5_PPC_VAL],[PNC5_ANM_ID],[PNC5_ASHA_ID],[PNC5_Created_by],[PNC5_Mobile_ID],[PNC5_Source_ID]
 ,[PNC5_Mother_Death_Place],[PNC5_Mother_Death_Date],[PNC5_Mother_Death_Reason_VAL],[PNC5_Mother_Death_Reason_Other],PNC5_DangerSign_Mother_Other
 ,[PNC5_Is_ILI_Symptom],[PNC5_Is_contact_Covid],[PNC5_Covid_test_done],[PNC5_Covid_test_result]  --covid
 ,[PNC6_No],PNC6_Type,[PNC6_Date],[PNC6_IFA_Tab],[PNC6_DangerSign_Mother_VAL],PNC6_DangerSign_Mother,[PNC6_ReferralFacility_Mother_VAL]
 ,PNC6_ReferralFacility_Mother,[PNC6_PPC_VAL],[PNC6_ANM_ID],[PNC6_ASHA_ID],[PNC6_Created_by],[PNC6_Mobile_ID],[PNC6_Source_ID]
 ,[PNC6_Mother_Death_Place],[PNC6_Mother_Death_Date],[PNC6_Mother_Death_Reason_VAL],[PNC6_Mother_Death_Reason_Other],PNC6_DangerSign_Mother_Other
 ,[PNC6_Is_ILI_Symptom],[PNC6_Is_contact_Covid],[PNC6_Covid_test_done],[PNC6_Covid_test_result]  --covid
 ,[PNC7_No],PNC7_Type,[PNC7_Date],[PNC7_IFA_Tab],[PNC7_DangerSign_Mother_VAL],PNC7_DangerSign_Mother,[PNC7_ReferralFacility_Mother_VAL]
 ,PNC7_ReferralFacility_Mother,[PNC7_PPC_VAL],[PNC7_ANM_ID],[PNC7_ASHA_ID],[PNC7_Created_by],[PNC7_Mobile_ID],[PNC7_Source_ID],PNC7_DangerSign_Mother_Other
 ,[PNC7_Mother_Death_Place],[PNC7_Mother_Death_Date],[PNC7_Mother_Death_Reason_VAL],[PNC7_Mother_Death_Reason_Other]
 ,[PNC7_Is_ILI_Symptom],[PNC7_Is_contact_Covid],[PNC7_Covid_test_done],[PNC7_Covid_test_result]  --covid
)
) piv
  
  
  ) X
  
  where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no
  
  --------------------------------------------Mother_PNC Death Added on 03072018-------------------------------------------------------------------
update t_mother_flat set  
[Mother_Death_Place]=Place_of_death
,[Mother_Death_Date]=X.Mother_Death_Date
,[Mother_Death_Reason_VAL]=X.Mother_Death_Reason
,[Mother_Death_Reason] =(case when X.Mother_Death_Reason='Z' then Mother_Death_Reason_Other else dbo.[Get_MotherDeathReason_Name](X.Mother_Death_Reason) end)
,[Exec_Date]=getdate()
from
(
  select a.Registration_no,a.Case_no,PNC_No,PNC_Type,PNC_Date,No_of_IFA_Tabs_given_to_mother,DangerSign_Mother,DangerSign_Mother_Other
,ReferralFacility_Mother,ReferralFacilityID_Mother,ReferralLoationOther_Mother,PPC,
ANM_ID,ASHA_ID,Place_of_death ,Mother_Death_Date ,Mother_Death_Reason,Mother_Death_Reason_Other,Created_By,Mobile_ID,SourceID
from t_mother_pnc  a   
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where MPNC_Table=1 and a.PNC_Type=0
) X
where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

----added on 16022023
Update t_mother_flat set PNC1_IFA_Tab=x.PNC1_IFA_Tab,PNC2_IFA_Tab=x.PNC2_IFA_Tab,PNC3_IFA_Tab=x.PNC3_IFA_Tab,PNC4_IFA_Tab=x.PNC4_IFA_Tab
,PNC5_IFA_Tab=x.PNC5_IFA_Tab,PNC6_IFA_Tab=x.PNC6_IFA_Tab,PNC7_IFA_Tab=x.PNC7_IFA_Tab,Exec_Date=getdate()
from(select b.Registration_no,b.case_no,
sum(isnull(case when b.PNC_Type=1 then b.IFA_Given end,0))PNC1_IFA_Tab,
sum(isnull(case when b.PNC_Type=2 then b.IFA_Given end,0))PNC2_IFA_Tab,
sum(isnull(case when b.PNC_Type=3 then b.IFA_Given end,0))PNC3_IFA_Tab,
sum(isnull(case when b.PNC_Type=4 then b.IFA_Given end,0))PNC4_IFA_Tab,
sum(isnull(case when b.PNC_Type=5 then b.IFA_Given end,0))PNC5_IFA_Tab,
sum(isnull(case when b.PNC_Type=6 then b.IFA_Given end,0))PNC6_IFA_Tab,
sum(isnull(case when b.PNC_Type=7 then b.IFA_Given end,0))PNC7_IFA_Tab
from
(select a.Registration_no,a.Case_no,PNC_Type,Sum(isnull(No_of_IFA_Tabs_given_to_mother,0)) IFA_Given from t_mother_pnc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
group by a.Registration_no, a.Case_no,PNC_Type) b
group by b.Registration_no,b.Case_no)X
where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

  ------------------------------------------------------Child PNC----------------------------------------------------------------------------
  update t_mother_flat set  
	 [Infant1_Death_Place]=X.Infant1_Infant_Death_Place
      ,[Infant1_Death_Date]=X.Infant1_Infant_Death_Date
      ,[Infant1_Death_Reason_VAL]=X.Infant1_Infant_Death_Reason_VAL
      ,[Infant1_Death_Reason]=(case when X.Infant1_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant1_Infant_Death_Reason_VAL) else X.Infant1_Infant_Death_Reason_other end)
      ,Infant1_Death=(case when X.[Infant1_Death]=1 then 'Yes' else null end)
      ,Infant1_Death_Val=X.[Infant1_Death]
      
      ,[Infant2_Death_Place]=X.Infant2_Infant_Death_Place
      ,[Infant2_Death_Date]=X.Infant2_Infant_Death_Date
      ,[Infant2_Death_Reason_VAL]=X.Infant2_Infant_Death_Reason_VAL
      ,[Infant2_Death_Reason]=(case when X.Infant2_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant2_Infant_Death_Reason_VAL) else X.Infant2_Infant_Death_Reason_other end)
      ,[Infant2_Death]=(case when X.[Infant2_Death]=1 then 'Yes' else null end)
      ,Infant2_Death_Val=X.[Infant2_Death]
      
      ,[Infant3_Death_Place]=X.Infant3_Infant_Death_Place
      ,[Infant3_Death_Date]=X.Infant3_Infant_Death_Date
      ,[Infant3_Death_Reason_VAL]=X.Infant3_Infant_Death_Reason_VAL
      ,[Infant3_Death_Reason]=(case when X.Infant3_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant3_Infant_Death_Reason_VAL) else X.Infant3_Infant_Death_Reason_other end)
      ,[Infant3_Death]=(case when X.[Infant3_Death]=1 then 'Yes' else null end)
      ,Infant3_Death_Val=X.[Infant3_Death]
      
      ,[Infant4_Death_Place]=X.Infant4_Infant_Death_Place
      ,[Infant4_Death_Date]=X.Infant4_Infant_Death_Date
      ,[Infant4_Death_Reason_VAL]=X.Infant4_Infant_Death_Reason_VAL
      ,[Infant4_Death_Reason]=(case when X.Infant4_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant4_Infant_Death_Reason_VAL) else X.Infant4_Infant_Death_Reason_other end)
      ,[Infant4_Death]=(case when X.[Infant4_Death]=1 then 'Yes' else null end)
      ,Infant4_Death_Val=X.[Infant4_Death]
      
      ,[Infant5_Death_Place]=X.Infant5_Infant_Death_Place
      ,[Infant5_Death_Date]=X.Infant5_Infant_Death_Date
      ,[Infant5_Death_Reason_VAL]=X.Infant5_Infant_Death_Reason_VAL
      ,[Infant5_Death_Reason]=(case when X.Infant5_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant5_Infant_Death_Reason_VAL) else X.Infant5_Infant_Death_Reason_other end)
      ,[Infant5_Death]=(case when X.[Infant5_Death]=1 then 'Yes' else null end)
      ,Infant5_Death_Val=X.[Infant5_Death]
      
      ,[Infant6_Death_Place]=X.Infant6_Infant_Death_Place
      ,[Infant6_Death_Date]=X.Infant6_Infant_Death_Date
      ,[Infant6_Death_Reason_VAL]=X.Infant6_Infant_Death_Reason_VAL
      ,[Infant6_Death_Reason]=(case when X.Infant6_Infant_Death_Reason_VAL<>'Z' then  dbo.Get_ChildDeathReason_Name(X.Infant6_Infant_Death_Reason_VAL) else X.Infant6_Infant_Death_Reason_other end)
      ,[Infant6_Death]=(case when X.[Infant6_Death]=1 then 'Yes' else null end)
      ,Infant6_Death_Val=X.[Infant6_Death]
      
      ,[Exec_Date]=getdate()
	  ,CPNC_mode_execution=getdate()
      from
      (
  
  select Registration_no,Case_no,  [Infant1_Death],[Infant1_ANM_ID_Infant],[Infant1_ASHA_ID_Infant],[Infant1_Infant_Death_Place],[Infant1_Infant_Death_Date]
,[Infant1_Infant_Death_Reason_VAL],[Infant1_Infant_Death_Reason_other],[Infant1_Created_by_Infant],[Infant1_Mobile_ID_Infant],[Infant1_Source_ID_Infant]

 ,[Infant2_Death],[Infant2_ANM_ID_Infant],[Infant2_ASHA_ID_Infant],[Infant2_Infant_Death_Place],[Infant2_Infant_Death_Date]
,[Infant2_Infant_Death_Reason_VAL],[Infant2_Infant_Death_Reason_other],[Infant2_Created_by_Infant],[Infant2_Mobile_ID_Infant],[Infant2_Source_ID_Infant]

 ,[Infant3_Death],[Infant3_ANM_ID_Infant],[Infant3_ASHA_ID_Infant],[Infant3_Infant_Death_Place],[Infant3_Infant_Death_Date]
,[Infant3_Infant_Death_Reason_VAL],[Infant3_Infant_Death_Reason_other],[Infant3_Created_by_Infant],[Infant3_Mobile_ID_Infant],[Infant3_Source_ID_Infant]
 
 ,[Infant4_Death],[Infant4_ANM_ID_Infant],[Infant4_ASHA_ID_Infant],[Infant4_Infant_Death_Place],[Infant4_Infant_Death_Date]
,[Infant4_Infant_Death_Reason_VAL],[Infant4_Infant_Death_Reason_other],[Infant4_Created_by_Infant],[Infant4_Mobile_ID_Infant],[Infant4_Source_ID_Infant]

 ,[Infant5_Death],[Infant5_ANM_ID_Infant],[Infant5_ASHA_ID_Infant],[Infant5_Infant_Death_Place],[Infant5_Infant_Death_Date]
,[Infant5_Infant_Death_Reason_VAL],[Infant5_Infant_Death_Reason_other],[Infant5_Created_by_Infant],[Infant5_Mobile_ID_Infant],[Infant5_Source_ID_Infant]
 
,[Infant6_Death],[Infant6_ANM_ID_Infant],[Infant6_ASHA_ID_Infant],[Infant6_Infant_Death_Place],[Infant6_Infant_Death_Date]
,[Infant6_Infant_Death_Reason_VAL],[Infant6_Infant_Death_Reason_other],[Infant6_Created_by_Infant],[Infant6_Mobile_ID_Infant],[Infant6_Source_ID_Infant]
 ,[Infant7_Death],[Infant7_ANM_ID_Infant],[Infant7_ASHA_ID_Infant],[Infant7_Infant_Death_Place],[Infant7_Infant_Death_Date]
,[Infant7_Infant_Death_Reason_VAL],[Infant7_Infant_Death_Reason_other],[Infant7_Created_by_Infant],[Infant7_Mobile_ID_Infant],[Infant7_Source_ID_Infant]
from 
(
select Registration_no,'Infant'+cast(Infant_No as varchar(4))+'_'+col new_col,value,Case_no from
(select a.Registration_no,a.Case_no,b.Infant_No,a.Infant_Death,
a.ANM_ID,a.ASHA_ID,Place_of_death ,a.Infant_Death_Date ,a.Infant_Death_Reason,a.Infant_Death_Reason_Other,a.Created_By,a.Mobile_ID,a.SourceID
from t_child_pnc  a  (nolock)
inner join t_mother_infant b  (nolock) on a.InfantRegistration=b.Infant_Id 
inner join t_Schedule_Date_Child_Previous c  (nolock) on a.InfantRegistration=c.Registration_No 
where c.CPNC_Table=1
) t_child_pnc
cross apply
  (
    VALUES
		  
         
            (cast(Infant_Death as nvarchar), 'Death'),
			(cast(ANM_ID as nvarchar), 'ANM_ID_Infant'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID_Infant'),
			(cast(Place_of_death as nvarchar), 'Infant_Death_Place'),
			(cast(Infant_Death_Date as nvarchar), 'Infant_Death_Date'),
			(cast(Infant_Death_Reason as nvarchar), 'Infant_Death_Reason_VAL'),
			(cast(Infant_Death_Reason_Other as nvarchar), 'Infant_Death_Reason_other'),
			(cast(Created_By as nvarchar), 'Created_by_Infant'),
			(cast(Mobile_ID as nvarchar), 'Mobile_ID_Infant'),
			(cast(SourceID as nvarchar), 'Source_ID_Infant')
		
			
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [Infant1_Death],[Infant1_ANM_ID_Infant],[Infant1_ASHA_ID_Infant],[Infant1_Infant_Death_Place],[Infant1_Infant_Death_Date]
,[Infant1_Infant_Death_Reason_VAL],[Infant1_Infant_Death_Reason_other],[Infant1_Created_by_Infant],[Infant1_Mobile_ID_Infant],[Infant1_Source_ID_Infant]

 ,[Infant2_Death],[Infant2_ANM_ID_Infant],[Infant2_ASHA_ID_Infant],[Infant2_Infant_Death_Place],[Infant2_Infant_Death_Date]
,[Infant2_Infant_Death_Reason_VAL],[Infant2_Infant_Death_Reason_other],[Infant2_Created_by_Infant],[Infant2_Mobile_ID_Infant],[Infant2_Source_ID_Infant]

 ,[Infant3_Death],[Infant3_ANM_ID_Infant],[Infant3_ASHA_ID_Infant],[Infant3_Infant_Death_Place],[Infant3_Infant_Death_Date]
,[Infant3_Infant_Death_Reason_VAL],[Infant3_Infant_Death_Reason_other],[Infant3_Created_by_Infant],[Infant3_Mobile_ID_Infant],[Infant3_Source_ID_Infant]
 
 ,[Infant4_Death],[Infant4_ANM_ID_Infant],[Infant4_ASHA_ID_Infant],[Infant4_Infant_Death_Place],[Infant4_Infant_Death_Date]
,[Infant4_Infant_Death_Reason_VAL],[Infant4_Infant_Death_Reason_other],[Infant4_Created_by_Infant],[Infant4_Mobile_ID_Infant],[Infant4_Source_ID_Infant]

 ,[Infant5_Death],[Infant5_ANM_ID_Infant],[Infant5_ASHA_ID_Infant],[Infant5_Infant_Death_Place],[Infant5_Infant_Death_Date]
,[Infant5_Infant_Death_Reason_VAL],[Infant5_Infant_Death_Reason_other],[Infant5_Created_by_Infant],[Infant5_Mobile_ID_Infant],[Infant5_Source_ID_Infant]
 
,[Infant6_Death],[Infant6_ANM_ID_Infant],[Infant6_ASHA_ID_Infant],[Infant6_Infant_Death_Place],[Infant6_Infant_Death_Date]
,[Infant6_Infant_Death_Reason_VAL],[Infant6_Infant_Death_Reason_other],[Infant6_Created_by_Infant],[Infant6_Mobile_ID_Infant],[Infant6_Source_ID_Infant]
 ,[Infant7_Death],[Infant7_ANM_ID_Infant],[Infant7_ASHA_ID_Infant],[Infant7_Infant_Death_Place],[Infant7_Infant_Death_Date]
,[Infant7_Infant_Death_Reason_VAL],[Infant7_Infant_Death_Reason_other],[Infant7_Created_by_Infant],[Infant7_Mobile_ID_Infant],[Infant7_Source_ID_Infant]
)
) piv
  
  
  ) X
  
  where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no
 
  
  
  ------------------------------------------------------Mother Infant-----------------------------------------------------------------------------
  
  update t_mother_flat set  [Infant1_No]=X.[Infant1_No]
	 ,[Infant1_Id]=X.[Infant1_Id]
      ,[Infant1_Name]=X.[Infant1_Name]
    
      ,[Infant1_Term_VAL]=X.[Infant1_Term_VAL]
      ,[Infant1_Term]=dbo.[Get_InfantTerm_Name](X.[Infant1_Term_VAL])
      ,[Infant1_Baby_Cried]=X.Infant1_Baby_Cried
      ,[Infant1_Resucitation_Done]=X.Infant1_Resucitation_Done
      ,[Infant1_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant1_BirthDefect)
      ,[Infant1_Gender]=X.Infant1_Gender
      ,[Infant1_Weight]=X.Infant1_Weight
      ,[Infant1_Breast_Feeding]=X.Infant1_Breast_Feeding
      ,[Infant1_Reffered_HigherFacility]=X.Infant1_Reffered_HigherFacility
      ,[Infant1_MobileID]=X.Infant1_MobileID
	  ,[Infant1_ANM_ID]=X.Infant1_ANM_ID
      ,[Infant1_ASHA_ID]=X.Infant1_ASHA_ID
	  ,[Infant1_Source_ID]=X.Infant1_Source_ID
      ,[Infant1_Created_By]=X.Infant1_Created_By
      ,[Infant1_BCG_Date]=X.[Infant1_BCG_Date]
      ,[Infant1_Hep_B_Date]=X.[Infant1_Hep_B_Date]
      ,[Infant1_OPV_Date]=X.[Infant1_OPV_Date]
      ,[Infant1_Vit_K_Date]=X.[Infant1_Vit_K_Date]
      
      
      ,[Infant2_No]=X.[Infant2_No]
	  ,[Infant2_Id]=X.[Infant2_Id]
      ,[Infant2_Name]=X.[Infant2_Name]
      ,[Infant2_Term_VAL]=X.[Infant2_Term_VAL]
      ,[Infant2_Term]=dbo.[Get_InfantTerm_Name](X.[Infant2_Term_VAL])
      ,[Infant2_Baby_Cried]=X.Infant2_Baby_Cried
      ,[Infant2_Resucitation_Done]=X.Infant2_Resucitation_Done
      ,[Infant2_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant2_BirthDefect)
      ,[Infant2_Gender]=X.Infant2_Gender
      ,[Infant2_Weight]=X.Infant2_Weight
      ,[Infant2_Breast_Feeding]=X.Infant2_Breast_Feeding
      ,[Infant2_Reffered_HigherFacility]=X.Infant2_Reffered_HigherFacility
      ,[Infant2_MobileID]=X.Infant2_MobileID
	  ,[Infant2_ANM_ID]=X.Infant2_ANM_ID
      ,[Infant2_ASHA_ID]=X.Infant2_ASHA_ID
	  ,[Infant2_Source_ID]=X.Infant2_Source_ID
      ,[Infant2_Created_By]=X.Infant2_Created_By
      ,[Infant2_BCG_Date]=X.[Infant2_BCG_Date]
      ,[Infant2_Hep_B_Date]=X.[Infant2_Hep_B_Date]
      ,[Infant2_OPV_Date]=X.[Infant2_OPV_Date]
      ,[Infant2_Vit_K_Date]=X.[Infant2_Vit_K_Date]
      
      ,[Infant3_No]=X.[Infant3_No]
	  ,[Infant3_Id]=X.[Infant3_Id]
      ,[Infant3_Name]=X.[Infant3_Name]
      ,[Infant3_Term_VAL]=X.[Infant3_Term_VAL]
      ,[Infant3_Term]=dbo.[Get_InfantTerm_Name](X.[Infant3_Term_VAL])
      ,[Infant3_Baby_Cried]=X.Infant3_Baby_Cried
      ,[Infant3_Resucitation_Done]=X.Infant3_Resucitation_Done
      ,[Infant3_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant3_BirthDefect)
      ,[Infant3_Gender]=X.Infant3_Gender
      ,[Infant3_Weight]=X.Infant3_Weight
      ,[Infant3_Breast_Feeding]=X.Infant3_Breast_Feeding
      ,[Infant3_Reffered_HigherFacility]=X.Infant3_Reffered_HigherFacility
      ,[Infant3_MobileID]=X.Infant3_MobileID
	  ,[Infant3_ANM_ID]=X.Infant3_ANM_ID
      ,[Infant3_ASHA_ID]=X.Infant3_ASHA_ID
	  ,[Infant3_Source_ID]=X.Infant3_Source_ID
      ,[Infant3_Created_By]=X.Infant3_Created_By
      ,[Infant3_BCG_Date]=X.[Infant3_BCG_Date]
      ,[Infant3_Hep_B_Date]=X.[Infant3_Hep_B_Date]
      ,[Infant3_OPV_Date]=X.[Infant3_OPV_Date]
      ,[Infant3_Vit_K_Date]=X.[Infant3_Vit_K_Date]
     
      ,[Infant4_No]=X.[Infant4_No]
	  ,[Infant4_Id]=X.[Infant4_Id]
      ,[Infant4_Name]=X.[Infant4_Name]
      ,[Infant4_Term_VAL]=X.[Infant4_Term_VAL]
      ,[Infant4_Term]=dbo.[Get_InfantTerm_Name](X.[Infant4_Term_VAL])
      ,[Infant4_Baby_Cried]=X.Infant4_Baby_Cried
      ,[Infant4_Resucitation_Done]=X.Infant4_Resucitation_Done
      ,[Infant4_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant4_BirthDefect)
      ,[Infant4_Gender]=X.Infant4_Gender
      ,[Infant4_Weight]=X.Infant4_Weight
      ,[Infant4_Breast_Feeding]=X.Infant4_Breast_Feeding
      ,[Infant4_Reffered_HigherFacility]=X.Infant4_Reffered_HigherFacility
      ,[Infant4_MobileID]=X.Infant4_MobileID
	  ,[Infant4_ANM_ID]=X.Infant4_ANM_ID
      ,[Infant4_ASHA_ID]=X.Infant4_ASHA_ID
	  ,[Infant4_Source_ID]=X.Infant4_Source_ID
      ,[Infant4_Created_By]=X.Infant4_Created_By
      ,[Infant4_BCG_Date]=X.[Infant4_BCG_Date]
      ,[Infant4_Hep_B_Date]=X.[Infant4_Hep_B_Date]
      ,[Infant4_OPV_Date]=X.[Infant4_OPV_Date]
      ,[Infant4_Vit_K_Date]=X.[Infant4_Vit_K_Date]
      
      ,[Infant5_No]=X.[Infant5_No]
	  ,[Infant5_Id]=X.[Infant5_Id]
      ,[Infant5_Name]=X.[Infant5_Name]
      ,[Infant5_Term_VAL]=X.[Infant5_Term_VAL]
      ,[Infant5_Term]=dbo.[Get_InfantTerm_Name](X.[Infant5_Term_VAL])
      ,[Infant5_Baby_Cried]=X.Infant5_Baby_Cried
      ,[Infant5_Resucitation_Done]=X.Infant5_Resucitation_Done
      ,[Infant5_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant5_BirthDefect)
      ,[Infant5_Gender]=X.Infant5_Gender
      ,[Infant5_Weight]=X.Infant5_Weight
      ,[Infant5_Breast_Feeding]=X.Infant5_Breast_Feeding
      ,[Infant5_Reffered_HigherFacility]=X.Infant5_Reffered_HigherFacility
      ,[Infant5_MobileID]=X.Infant5_MobileID
	  ,[Infant5_ANM_ID]=X.Infant5_ANM_ID
      ,[Infant5_ASHA_ID]=X.Infant5_ASHA_ID
	  ,[Infant5_Source_ID]=X.Infant5_Source_ID
      ,[Infant5_Created_By]=X.Infant5_Created_By
      ,[Infant5_BCG_Date]=X.[Infant5_BCG_Date]
      ,[Infant5_Hep_B_Date]=X.[Infant5_Hep_B_Date]
      ,[Infant5_OPV_Date]=X.[Infant5_OPV_Date]
      ,[Infant5_Vit_K_Date]=X.[Infant5_Vit_K_Date]
      
      ,[Infant6_No]=X.[Infant6_No]
	  ,[Infant6_Id]=X.[Infant6_Id]
      ,[Infant6_Name]=X.[Infant6_Name]
      ,[Infant6_Term_VAL]=X.[Infant6_Term_VAL]
      ,[Infant6_Term]=dbo.[Get_InfantTerm_Name](X.[Infant6_Term_VAL])
      ,[Infant6_Baby_Cried]=X.Infant6_Baby_Cried
      ,[Infant6_Resucitation_Done]=X.Infant6_Resucitation_Done
      ,[Infant6_BirthDefect]=DBO.[Get_Infant_defect_Seen]  (X.Infant6_BirthDefect)
      ,[Infant6_Gender]=X.Infant6_Gender
      ,[Infant6_Weight]=X.Infant6_Weight
      ,[Infant6_Breast_Feeding]=X.Infant6_Breast_Feeding
      ,[Infant6_Reffered_HigherFacility]=X.Infant6_Reffered_HigherFacility
      ,[Infant6_MobileID]=X.Infant6_MobileID
	  ,[Infant6_ANM_ID]=X.Infant6_ANM_ID
      ,[Infant6_ASHA_ID]=X.Infant6_ASHA_ID
	  ,[Infant6_Source_ID]=X.Infant6_Source_ID
      ,[Infant6_Created_By]=X.Infant6_Created_By
      ,[Infant6_BCG_Date]=X.[Infant6_BCG_Date]
      ,[Infant6_Hep_B_Date]=X.[Infant6_Hep_B_Date]
      ,[Infant6_OPV_Date]=X.[Infant6_OPV_Date]
      ,[Infant6_Vit_K_Date]=X.[Infant6_Vit_K_Date]
      ,[Exec_Date]=getdate()
	  ,[MI_mode_execution]=getdate()
      from
      (
  
  select Registration_no,Case_no, [Infant1_No],[Infant1_Id],[Infant1_Name],[Infant1_Term_VAL],[Infant1_Term],[Infant1_Baby_Cried],[Infant1_Resucitation_Done],[Infant1_BirthDefect]
,[Infant1_Gender],[Infant1_Weight],[Infant1_Breast_Feeding],[Infant1_Reffered_HigherFacility],[Infant1_MobileID],[Infant1_ANM_ID],[Infant1_ASHA_ID]
,[Infant1_Source_ID],[Infant1_Created_By],[Infant1_BCG_Date],[Infant1_Hep_B_Date],[Infant1_OPV_Date],[Infant1_Vit_K_Date]
,[Infant2_No],[Infant2_Id],[Infant2_Name],[Infant2_Term_VAL],[Infant2_Term],[Infant2_Baby_Cried],[Infant2_Resucitation_Done],[Infant2_BirthDefect]
,[Infant2_Gender],[Infant2_Weight],[Infant2_Breast_Feeding],[Infant2_Reffered_HigherFacility],[Infant2_MobileID],[Infant2_ANM_ID],[Infant2_ASHA_ID]
,[Infant2_Source_ID],[Infant2_Created_By],[Infant2_BCG_Date],[Infant2_Hep_B_Date],[Infant2_OPV_Date],[Infant2_Vit_K_Date]
,[Infant3_No],[Infant3_Id],[Infant3_Name],[Infant3_Term_VAL],[Infant3_Term],[Infant3_Baby_Cried],[Infant3_Resucitation_Done],[Infant3_BirthDefect]
,[Infant3_Gender],[Infant3_Weight],[Infant3_Breast_Feeding],[Infant3_Reffered_HigherFacility],[Infant3_MobileID],[Infant3_ANM_ID],[Infant3_ASHA_ID]
,[Infant3_Source_ID],[Infant3_Created_By],[Infant3_BCG_Date],[Infant3_Hep_B_Date],[Infant3_OPV_Date],[Infant3_Vit_K_Date]
,[Infant4_No],[Infant4_Id],[Infant4_Name],[Infant4_Term_VAL],[Infant4_Term],[Infant4_Baby_Cried],[Infant4_Resucitation_Done],[Infant4_BirthDefect]
,[Infant4_Gender],[Infant4_Weight],[Infant4_Breast_Feeding],[Infant4_Reffered_HigherFacility],[Infant4_MobileID],[Infant4_ANM_ID],[Infant4_ASHA_ID]
,[Infant4_Source_ID],[Infant4_Created_By],[Infant4_BCG_Date],[Infant4_Hep_B_Date],[Infant4_OPV_Date],[Infant4_Vit_K_Date]
,[Infant5_No],[Infant5_Id],[Infant5_Name],[Infant5_Term_VAL],[Infant5_Term],[Infant5_Baby_Cried],[Infant5_Resucitation_Done],[Infant5_BirthDefect]
,[Infant5_Gender],[Infant5_Weight],[Infant5_Breast_Feeding],[Infant5_Reffered_HigherFacility],[Infant5_MobileID],[Infant5_ANM_ID],[Infant5_ASHA_ID]
,[Infant5_Source_ID],[Infant5_Created_By],[Infant5_BCG_Date],[Infant5_Hep_B_Date],[Infant5_OPV_Date],[Infant5_Vit_K_Date]
,[Infant6_No],[Infant6_Id],[Infant6_Name],[Infant6_Term_VAL],[Infant6_Term],[Infant6_Baby_Cried],[Infant6_Resucitation_Done],[Infant6_BirthDefect]
,[Infant6_Gender],[Infant6_Weight],[Infant6_Breast_Feeding],[Infant6_Reffered_HigherFacility],[Infant6_MobileID],[Infant6_ANM_ID],[Infant6_ASHA_ID]
,[Infant6_Source_ID],[Infant6_Created_By],[Infant6_BCG_Date],[Infant6_Hep_B_Date],[Infant6_OPV_Date],[Infant6_Vit_K_Date]
from 
(
select Registration_no,'Infant'+cast(Infant_no as varchar(4))+'_'+col new_col,value,Case_no from
(select a.Registration_no,a.Case_no,Infant_No,Infant_Id,Infant_Name,Infant_Term,Baby_Cried_Immediately_At_Birth
,Resucitation_Done,Any_Defect_Seen_At_Birth,Gender_Infant,[Weight],Breast_Feeding,Higher_Facility,
ANM_ID,ASHA_ID,Created_By,Mobile_ID,SourceID,BCG_Date,Hep_B_Date,OPV_Date,Vit_K_Date
from t_mother_infant a  (nolock)  
inner join t_Schedule_Date_Previous b  (nolock) on a.Registration_no=b.Registration_No and a.Case_no=b.Case_No
where b.MINFANT_Table=1
) t_mother_infant
cross apply
  (
    VALUES
		  
            (cast(Infant_no as nvarchar), 'No'),
            (cast(Infant_Id as nvarchar), 'Id'),
			(cast(Infant_Name as nvarchar), 'Name'),
			(cast(Infant_Term as nvarchar), 'Term'),
			(cast(Baby_Cried_Immediately_At_Birth as nvarchar), 'Baby_Cried'),
			(cast(Resucitation_Done as nvarchar), 'Resucitation_Done'),
			(cast(Any_Defect_Seen_At_Birth as nvarchar), 'BirthDefect'),
			(cast(Gender_Infant as nvarchar), 'Gender'),
			(cast([Weight] as nvarchar), 'Weight'),
			(cast(Breast_Feeding as nvarchar), 'Breast_Feeding'),
			(cast(Higher_Facility as nvarchar), 'Reffered_HigherFacility'),
			(cast(ANM_ID as nvarchar), 'ANM_ID'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID'),
			(cast(Created_By as nvarchar), 'Created_by'),
			(cast(Mobile_ID as nvarchar), 'MobileID'),
			(cast(SourceID as nvarchar), 'Source_ID'),
			(cast(BCG_Date as nvarchar), 'BCG_Date'),
			(cast(Hep_B_Date as nvarchar), 'Hep_B_Date'),
			(cast(OPV_Date as nvarchar), 'OPV_Date'),
			(cast(Vit_K_Date as nvarchar), 'Vit_K_Date')
		
			
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [Infant1_No],[Infant1_Id],[Infant1_Name],[Infant1_Term_VAL],[Infant1_Term],[Infant1_Baby_Cried],[Infant1_Resucitation_Done],[Infant1_BirthDefect]
,[Infant1_Gender],[Infant1_Weight],[Infant1_Breast_Feeding],[Infant1_Reffered_HigherFacility],[Infant1_MobileID],[Infant1_ANM_ID],[Infant1_ASHA_ID]
,[Infant1_Source_ID],[Infant1_Created_By],[Infant1_BCG_Date],[Infant1_Hep_B_Date],[Infant1_OPV_Date],[Infant1_Vit_K_Date]
,[Infant2_No],[Infant2_Id],[Infant2_Name],[Infant2_Term_VAL],[Infant2_Term],[Infant2_Baby_Cried],[Infant2_Resucitation_Done],[Infant2_BirthDefect]
,[Infant2_Gender],[Infant2_Weight],[Infant2_Breast_Feeding],[Infant2_Reffered_HigherFacility],[Infant2_MobileID],[Infant2_ANM_ID],[Infant2_ASHA_ID]
,[Infant2_Source_ID],[Infant2_Created_By],[Infant2_BCG_Date],[Infant2_Hep_B_Date],[Infant2_OPV_Date],[Infant2_Vit_K_Date]
,[Infant3_No],[Infant3_Id],[Infant3_Name],[Infant3_Term_VAL],[Infant3_Term],[Infant3_Baby_Cried],[Infant3_Resucitation_Done],[Infant3_BirthDefect]
,[Infant3_Gender],[Infant3_Weight],[Infant3_Breast_Feeding],[Infant3_Reffered_HigherFacility],[Infant3_MobileID],[Infant3_ANM_ID],[Infant3_ASHA_ID]
,[Infant3_Source_ID],[Infant3_Created_By],[Infant3_BCG_Date],[Infant3_Hep_B_Date],[Infant3_OPV_Date],[Infant3_Vit_K_Date]
,[Infant4_No],[Infant4_Id],[Infant4_Name],[Infant4_Term_VAL],[Infant4_Term],[Infant4_Baby_Cried],[Infant4_Resucitation_Done],[Infant4_BirthDefect]
,[Infant4_Gender],[Infant4_Weight],[Infant4_Breast_Feeding],[Infant4_Reffered_HigherFacility],[Infant4_MobileID],[Infant4_ANM_ID],[Infant4_ASHA_ID]
,[Infant4_Source_ID],[Infant4_Created_By],[Infant4_BCG_Date],[Infant4_Hep_B_Date],[Infant4_OPV_Date],[Infant4_Vit_K_Date]
,[Infant5_No],[Infant5_Id],[Infant5_Name],[Infant5_Term_VAL],[Infant5_Term],[Infant5_Baby_Cried],[Infant5_Resucitation_Done],[Infant5_BirthDefect]
,[Infant5_Gender],[Infant5_Weight],[Infant5_Breast_Feeding],[Infant5_Reffered_HigherFacility],[Infant5_MobileID],[Infant5_ANM_ID],[Infant5_ASHA_ID]
,[Infant5_Source_ID],[Infant5_Created_By],[Infant5_BCG_Date],[Infant5_Hep_B_Date],[Infant5_OPV_Date],[Infant5_Vit_K_Date]
,[Infant6_No],[Infant6_Id],[Infant6_Name],[Infant6_Term_VAL],[Infant6_Term],[Infant6_Baby_Cried],[Infant6_Resucitation_Done],[Infant6_BirthDefect]
,[Infant6_Gender],[Infant6_Weight],[Infant6_Breast_Feeding],[Infant6_Reffered_HigherFacility],[Infant6_MobileID],[Infant6_ANM_ID],[Infant6_ASHA_ID]
,[Infant6_Source_ID],[Infant6_Created_By],[Infant6_BCG_Date],[Infant6_Hep_B_Date],[Infant6_OPV_Date],[Infant6_Vit_K_Date]
)
) piv
  ) X

where t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

-----------------------------------------------------------------------------------------------------------
update t_mother_flat set  [Infant1_HBIG_Date]=X.Infant1_HBIG_Date
,[Infant2_HBIG_Date]=X.Infant2_HBIG_Date
,[Infant3_HBIG_Date]=X.Infant3_HBIG_Date
,[Infant4_HBIG_Date]=X.Infant4_HBIG_Date
,[Infant5_HBIG_Date]=X.Infant5_HBIG_Date
,[Infant6_HBIG_Date]=X.Infant6_HBIG_Date
,[Exec_Date]=getdate()
from
(
select Registration_no,Case_no,  [Infant1_HBIG_Date] ,[Infant2_HBIG_Date] ,[Infant3_HBIG_Date]  ,[Infant4_HBIG_Date] ,[Infant5_HBIG_Date] ,[Infant6_HBIG_Date]
from 
(select Registration_no,'Infant'+cast(Infant_No as varchar(4))+'_'+col new_col,value,Case_no from 
(select b.Registration_no,b.Case_no,b.Infant_No,a.HBIG_Date 
from t_children_registration   a (nolock)
inner join t_mother_infant b  (nolock) on a.Registration_no=b.Infant_Id 
inner join t_Schedule_Date_Child_Previous c  (nolock) on a.Registration_no=c.Registration_No 
where c.CR_Table=1
) t_child_hbig
cross apply
(
VALUES
(cast(HBIG_Date as nvarchar), 'HBIG_Date')
) x (value, col)
) src
pivot
(
 max(value)
  for new_col in (
 [Infant1_HBIG_Date]
 ,[Infant2_HBIG_Date]
 ,[Infant3_HBIG_Date]
 ,[Infant4_HBIG_Date]
 ,[Infant5_HBIG_Date]
,[Infant6_HBIG_Date]
)
) piv
  ) X   where 
  t_mother_flat.Registration_no=X.Registration_no and t_mother_flat.Case_no=X.Case_no

  
  ----------------------------------Mother_verification--------------------------------------------------------------
  --update t_mother_flat set Validated_Callcentre=1 from 
  --(
  --select Registration_no,Case_no from t_MotherEntry_Verification 
  --where Call_Ans=1 and IsPhoneNoCorrect=1 and Convert(date,VerifyDt)=CONVERT(date,getdate()-1)
  --)X
  --where t_mother_flat.Registration_no=X.Registration_no
  --and t_mother_flat.case_no=X.Case_no
  
  
update t_mother_flat set  Call_Ans=X.Call_Ans,Is_Phone_Correct=X.IsPhoneNoCorrect,No_Call_Reason=(case when X.Call_Ans=0 then X.StatusNAme else null end)
,No_Phone_Reason=(case when X.Call_Ans=1 then X.StatusNAme else null end)
,No_call_reaon_val=NoCall_Reason,No_phone_reason_Val=X.NoPhone_Reason
,Is_Confirmed=X.Is_Confirm,Validated_Callcentre=(case when X.Call_Ans=1 and X.IsPhoneNoCorrect=1 and X.Is_Confirm=1 then 1 else 0 end)
,is_verified=x.is_verified
 from(
select a.Call_Ans,a.IsPhoneNoCorrect,b.Status as StatusNAme,a.NoCall_Reason,a.NoPhone_Reason,a.Registration_no,a.Case_no,a.Is_Confirm,isnull(a.is_verified,0) is_verified
from t_MotherEntry_Verification a
inner join t_call_status b on a.Call_Ans=b.CallAns and isnull(a.IsPhoneNoCorrect,0)=b.IsPhoneNo_Correct 
and (Case when CallAns=0 then a.NoCall_Reason else a.NoPhone_Reason end)=b.Phone_Reason
inner join t_Schedule_Date_Previous c on a.Registration_no=C.Registration_no and a.Case_no=c.Case_no
where MV_Table=1

)X
where t_mother_flat.Registration_no=X.Registration_no
and t_mother_flat.Case_no=X.Case_no

update t_mother_flat set Woman_RC_NUMBER=B.Woman_RC_NUMBER,RC_created_dt= B.RC_created_dt,RC_With_ExistRecord= B.RC_With_ExistRecord
,Woman_RC_Family_ID=b.Woman_RC_Family_ID,Woman_RC_MEMBER_ID=b.Woman_RC_MEMBER_ID,Husband_RC_NUMBER=b.Husband_RC_NUMBER
,Husband_RC_family_ID=b.Husband_RC_family_ID,Husband_RC_MEMBER_ID=b.Husband_RC_MEMBER_ID
from (
select a.Registration_no,Woman_RC_NUMBER,l.created_on RC_created_dt,a.RC_With_ExistRecord 
,l.Woman_RC_Family_ID,l.Woman_RC_MEMBER_ID ,l.Husband_RC_NUMBER,l.Husband_family_ID Husband_RC_family_ID,l.Husband_RC_MEMBER_ID
from t_eligibleCouples a (nolock)
left outer join t_State_Family_Data l (nolock) on a.Registration_no=l.Registration_No 
inner join t_Schedule_Date_Previous c on a.Registration_no=C.Registration_no
where isnull(Woman_ServiceData,'')<>''  and isnull(Woman_RC_NUMBER,'')<>''
) B where t_mother_flat.Registration_no=B.Registration_no

---------------update care context----------------------------------------------------------------------------------

declare @state_code tinyint,
@db as char(6) 
select @db= DB_NAME()
select @state_code= Substring(@db,5,2)

update a set a.cc_total=c.cc_total,a.cc_sent=c.cc_sent from  
t_mother_flat(nolock) a inner join  (
select State_code,uhid ,health_id_no,(count(care_context_id))cc_total,count(case when isnull(status,0)=1 then 1 end) cc_sent from 
RCH_Web_Services..care_context_link_request(nolock) where State_code=@state_code
group by State_code,uhid ,health_id_no
) c 
on a.Registration_no=c.uhid and a.Mother_HealthIdNumber=c.health_id_no 
inner join t_Schedule_Date_Previous(nolock) p on a.Registration_no= p.Registration_No where ccid_table=1

end
