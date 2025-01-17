USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligibleCouple_Select]    Script Date: 09/26/2024 15:56:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
      
      
ALTER proc [dbo].[tp_eligibleCouple_Select]              
(              
@State_Code int                
,@District_Code int                
,@Rural_Urban char(1)                
,@HealthBlock_Code int                
,@Taluka_Code varchar(6)                
,@HealthFacility_Type int                
,@HealthFacility_Code int                
,@HealthSubFacility_Code int                
,@Village_Code int              
,@Registration_no bigint              
,@Case_no int              
)              
as              
begin              
 SET NOCOUNT ON              
               
 declare @Days_left int=0              
set @Days_left = dbo.Get_DaysLeft(@Registration_no)              
              
select @Days_left as Days_left,          
e.SNo ,            
e.State_Code,             
e.District_Code,             
e.Rural_Urban ,            
e.HealthBlock_Code,             
e.Taluka_Code,             
e.HealthFacility_Type ,            
e.HealthFacility_Code,             
e.HealthSubFacility_Code,             
e.Village_Code ,            
e.Financial_Yr,             
e.Financial_Year,             
e.Registration_no,             
e.ID_No ,            
e.Register_srno,             
Name_wife ,            
Name_husband,             
Whose_mobile,             
Landline_no ,            
e.Mobile_no ,            
Date_regis ,            
Wife_current_age ,            
Wife_marry_age,             
Hus_current_age,             
Hus_marry_age,             
e.Address ,            
e.Religion_Code,             
e.Caste ,            
Identity_type,             
Identity_number ,            
Male_child_born ,            
Female_child_born,             
Male_child_live,             
Female_child_live,             
Young_child_gender,             
Young_child_age_month,             
Young_child_age_year,             
Infertility_status,             
Infertility_refer,             
Pregnant,             
Pregnant_test,             
Eligible,             
Status,             
e.ANM_ID,             
e.ASHA_ID,             
e.Case_no,             
e.Flag,               
Aadhar_No,             
EID ,            
EIDT,             
e.BPL_APL ,            
HusbandAadhaar_no,             
PW_AadhaarLinked,             
PW_BankID ,            
PW_AccNo,             
PW_IFSCCode ,            
PW_BranchName,             
Husband_AadhaarLinked,             
Husband_BankID,             
Husband_AccNo,             
Husband_IFSCCode,             
Husband_BranchName,             
InactiveECReason,             
InfertilityOptions,             
InfertilityReferDH,              
e.Delete_Mother,             
e.ReasonForDeletion,             
e.DeletedOn,             
e.CPSMS_Flag,             
IsHusbandFather,             
e.Mobile_ID ,            
e.SourceID,             
Husband_EID ,            
Husband_EIDT,             
e.Dup_Mother_Delete,             
e.Schedule_updated_On,             
e.permanent_delete,             
e.Deleted_By,          
e.caste_pds_flag,           
e.category_pds_flag,              
sf.Registration_No RationCard_Registration_No,             
Woman_StatePopulationId ,            
Husband_StatePopulationId,             
Woman_Name ,            
Husband_Name,             
Woman_CurrentAge,             
Husband_CurrentAge,             
Match_Score_Analyzed,             
Match_Score_Confirm ,             
Service_Pulled_On,             
Woman_ServiceData,             
Husband_ServiceData,             
State_Populationdata_WSURL_ID,             
Woman_RC_NUMBER,          
Woman_RC_FAMILY_ID,             
Woman_RC_MEMBER_ID ,            
Husband_RC_NUMBER,             
Husband_FAMILY_ID,             
Husband_RC_MEMBER_ID,             
WomenDOB,             
HusbandDOB,             
Woman_Gender,             
Husband_Gender,             
Mobile_Number,             
sf.Address as RationCard_Address,            
APL_BPL as Rationcard_APL_BPL,             
sf.Caste as RationCard_Caste,             
Religion,    
c.HealthIdNumber,  
c.Birth_Date,
c.Is_PVTG   
 from t_eligibleCouples  e            
left outer join t_State_Family_Data sf on e.Registration_no = sf.Registration_no     
inner join t_mother_registration c on e.Registration_no = c.Registration_no and e.Case_no = c.Case_no        
where e.Registration_no=@Registration_no              
and e.Case_no=@Case_no              
               
end       


