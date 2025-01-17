USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_PW_DirectData_Entry]    Script Date: 09/26/2024 12:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
MS_PW_DirectData_Entry 99,5,'R',13,'0015',4,96,248,0,'2015-16',2015,233,
--EC
'test EM','test hus EM','H','1234567891','9871235888','2015-04-09',11,11,'','','0','test address',2,99,'','',1,1,1,1,'F',1,15,'N','',0,0
 ,24318,113366,'',0,'00000',2,227651709627,'',0,2000000000,'SBIN0876543','test branch','',0,0,'','',000000
 ,'0','','0','',1,1,0,
 -- MR
 'test EM','test hus EM','2015-04-01','W','',11,35,'NA',0,'',3,
  --MM
 '2014-12-11',0,'2015-09-17',1,'J','',0,'J',0,'',0,'J',0,'',0,0,'','','','','','',0,'',0,0
 */
ALTER procedure [dbo].[MS_PW_DirectData_Entry]  
(  
--Common  
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,@HealthFacility_Code int,      
@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year smallint,      
@Register_srno int  
--Ec  
,@Name_wife nvarchar(99),@Name_husband nvarchar(99),@Whose_mobile char(1),@Landline_no nvarchar(10),@Mobile_no nvarchar(10),@Date_regis Datetime,      
@Wife_current_age tinyint,@Wife_marry_age tinyint,@Hus_current_age tinyint,@Hus_marry_age tinyint,@Aadhar_No numeric(12)=null,@Address nvarchar(150),@Religion_code int,@Caste tinyint,@Identity_type tinyint,@Identity_number varchar(20)    
,@Male_child_born tinyint,@Female_child_born tinyint,@Male_child_live tinyint,@Female_child_live tinyint,@Young_child_gender char(1),@Young_child_age_month tinyint,  @Young_child_age_year tinyint,         
@Infertility_status char(1),@Infertility_refer nvarchar(100),@InfertilityOptions int=null,@InfertilityReferDH int=null         
   
,@ANM_ID int,@ASHA_ID int,@IP_address varchar(25)='',@Created_By int=-1,@msg nvarchar(max)= '00000' out,@BPL_APL tinyint,@Hus_Aadhar_No numeric(12)=null  
,@PW_AadhaarLinked bit,@PW_BankID int,@PW_AccNo nvarchar(20), @PW_IFSCCode nvarchar(15),@PW_BranchName nvarchar(100),@Husband_AadhaarLinked bit  
,@Husband_BankID int,@Husband_AccNo nvarchar(20),@Husband_IFSCCode nvarchar(15),@Husband_BranchName nvarchar(100),@Mobile_ID bigint=0   
,@EID numeric(14)=null ,@EIDT datetime='',@Husband_EID bit,@Husband_EIDT datetime ,@Case_no int,@Mode int,@Registration_no bigint   
  
 ----Mother Registration    
,@Name_PW nvarchar(50),@Name_H nvarchar(50),@Registration_Date date,@Mobile_Relates_To char(1),@Birth_Date Date,@Age tinyint,@Height float=0,      
@JSY_Beneficiary char(1)='na',@Delete_Mother int=0,@JSY_Payment_Received char(1)=null,@SourceID int    
  
  
 
----Mother Medical  
,@LMP_Date date,@Reg_12Weeks bit=0,@EDD_Date date=null,@Blood_Group int=1      
,@Past_Illness nvarchar(50)=null,@OtherPast_Illness nvarchar(20)=null,@No_Of_Pregnancy int=0,      
@Last_Preg_Complication nvarchar(50)=null,@Last_Preg_Complication_Length int=0,@Other_Last_Complication nvarchar(20)=null,@Outcome_Last_Preg int=0      
,@L2L_Preg_Complication nvarchar(50)=null,@L2L_Preg_Complication_Length int=0 ,@Other_L2L_Complication nvarchar(20)=null,@Outcome_L2L_Preg int=0      
,@Expected_delivery_place int=0,@Place_name nvarchar(60)=null,@VDRL_Test bit,@VDRL_Date date=null      
,@VDRL_Result char(1)=null,@HIV_Test bit,@HIV_Date date=null     
,@Past_Illness_Length INT=0,@HIV_Result char(1)=null,@DeliveryLocation int=null    
,@BloodGroup_Test tinyint     
  
)  
  
as   
begin  
  
declare @regno bigint=0  
--or @Wife_marry_age ='' or @Hus_current_age='' or @Hus_marry_age=''
if(@Date_regis = '' or @Wife_current_age=''  or @Address='' or @Registration_Date='' or @Birth_Date='' or @LMP_Date='' or @Mobile_no='' or @Whose_mobile='')
begin
	set @msg='00000'  
end
else
begin 
	exec MS_SetEligibleCouple    @State_Code ,@District_Code ,@Rural_Urban ,@HealthBlock_Code ,@Taluka_Code ,@HealthFacility_Type ,@HealthFacility_Code ,      
	@HealthSubFacility_Code ,@Village_Code ,@Financial_Yr ,@Financial_Year ,@Register_srno ,@Name_wife   
	,@Name_husband ,@Whose_mobile ,@Landline_no ,@Mobile_no ,@Date_regis ,@Wife_current_age   
	,@Wife_marry_age ,@Hus_current_age ,@Hus_marry_age ,@Aadhar_No ,@Address ,@Religion_code ,@Caste ,@Identity_type ,@Identity_number     
	,@Male_child_born ,@Female_child_born ,@Male_child_live ,@Female_child_live ,@Young_child_gender ,@Young_child_age_month ,  @Young_child_age_year ,         
	@Infertility_status ,@Infertility_refer ,@InfertilityOptions ,@InfertilityReferDH ,@ANM_ID ,@ASHA_ID ,@IP_address ,       
	@Created_By,@msg ,@BPL_APL ,@Hus_Aadhar_No ,@PW_AadhaarLinked ,@PW_BankID ,@PW_AccNo,      
	@PW_IFSCCode ,@PW_BranchName ,@Husband_AadhaarLinked ,@Husband_BankID ,@Husband_AccNo,@Husband_IFSCCode ,      
	@Husband_BranchName ,@Mobile_ID ,@EID ,@EIDT ,@Husband_EID ,@Husband_EIDT ,@Case_no  ,@Mode  ,@Registration_no    
	  
	  
	exec MS_RegistrationNo_Return @State_Code,@Mobile_ID,@Registration_no=@regno output
	if(@regno<>0)
	  begin
		exec  MS_SET_Mother_registration  @State_Code ,@District_Code ,@Rural_Urban ,@HealthBlock_Code ,@Taluka_Code ,@HealthFacility_Type ,      
		@HealthFacility_Code ,@HealthSubFacility_Code ,@Village_Code ,@Financial_Yr ,@Financial_Year , @regno ,@Register_srno ,@Name_PW ,@Name_H   
		, @Address ,@Registration_Date ,@Mobile_No ,@Mobile_Relates_To ,@Religion_code ,@Caste ,@BPL_APL ,@Birth_Date ,@Age ,@Height , @ANM_ID ,@ASHA_ID  
		 ,@Case_no ,@IP_address ,@Created_By ,@JSY_Beneficiary , @Delete_Mother,@msg,@JSY_Payment_Received , @Mobile_ID  ,@SourceID  
		  
		exec MS_SetXmlMother_medical   @State_Code ,@District_Code ,@Rural_Urban ,@HealthBlock_Code ,@Taluka_Code ,@HealthFacility_Type ,@HealthFacility_Code ,@HealthSubFacility_Code   
		,@Village_Code,@Financial_Yr ,@Financial_Year ,@regno ,@LMP_Date,@Reg_12Weeks ,@EDD_Date ,@Blood_Group       
		,@Past_Illness ,@OtherPast_Illness ,@No_Of_Pregnancy ,@Last_Preg_Complication,@Last_Preg_Complication_Length ,@Other_Last_Complication ,@Outcome_Last_Preg       
		,@L2L_Preg_Complication ,@L2L_Preg_Complication_Length ,@Other_L2L_Complication ,@Outcome_L2L_Preg,@Expected_delivery_place ,@Place_name ,@VDRL_Test  
		,@VDRL_Date,@VDRL_Result ,@HIV_Test ,@HIV_Date ,@ANM_ID ,@ASHA_ID ,@Case_no ,@IP_address ,@Created_By ,@Mobile_ID ,@msg ,@Past_Illness_Length ,@HIV_Result   
		,@DeliveryLocation ,@BloodGroup_Test,@SourceID  
	  end
	set @msg=''+CAST(@Mobile_ID AS VARCHAR)+''   
 end 
end
