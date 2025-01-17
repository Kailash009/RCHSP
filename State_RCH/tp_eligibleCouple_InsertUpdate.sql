USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligibleCouple_InsertUpdate]    Script Date: 09/26/2024 12:24:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	            
/*                
   [tp_eligibleCouple_InsertUpdate] 23,5,'R',152,'0024',1,553,10880,3200,'2018-19',2018,0,'',114,'Sunita','Chand Khan','W','9818140740','2018-04-10',25,20,27,22,null,'xyz',null,null,null,null,null,null,null,null,null,'N',null,0,0,'10.25.215.127',20,'',1,n
  
    
      
        
          
ull,null,null,null,null,null,null,null,null,null,null,0,0,null,null,null,null,1,0,0,'0'            
               
  [tp_eligibleCouple_InsertUpdate] 23,5,'R',152,'0024',1            
,553,10880,3200,'2018-19',2018,,            
'',114,'Sunita','Chand Khan', 'W',            
'9818140740','19-04-2018',25,20,27,22,            
null,'xyz',null,null,            
null,null,null,null,            
null,null,null,'N'            
,null,            
0,0,'59.88.90.9',20,'',1,null,            
null,null,null,null,            
null,null,null,            
null,null,null,0,0,            
null,            
null,            
null,            
null            
,1            
,0            
,0            
,'0'            
            
            
            
[tp_eligibleCouple_InsertUpdate]             
            
            
*/                
ALTER  proc [dbo].[tp_eligibleCouple_InsertUpdate]                
(                
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,                
@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year smallint,@Registration_no bigint out,                
@ID_No varchar(18)=null,@Register_srno int,@Name_wife nvarchar(99),@Name_husband nvarchar(99),@Whose_mobile char(1),                
@Mobile_no nvarchar(10),@Date_regis Date,@Wife_current_age tinyint,@Wife_marry_age tinyint=null,@Hus_current_age tinyint=null,@Hus_marry_age tinyint=null,                
@Aadhar_No numeric(12)=null ,@Address nvarchar(150),@Religion_code int=null,@Caste tinyint=null,                
@Male_child_born tinyint=null,@Female_child_born tinyint=null,@Male_child_live tinyint=null,@Female_child_live tinyint=null,                
@Young_child_gender char(1)=null,@Young_child_age_month tinyint=null,  @Young_child_age_year tinyint=null,   @Infertility_status char(1)='N',                
@Infertility_refer nvarchar(100)=null,                
@ANM_ID int,@ASHA_ID int,@IP_address varchar(25),@Created_By int,@msg nvarchar(200) out,@BPL_APL tinyint=null,@Hus_Aadhar_No numeric(12)=null,                
@PW_BankID int=null,@PW_AccNo nvarchar(20)=null,@PW_IFSCCode nvarchar(15)=null,@PW_BranchName nvarchar(100)=null,                
@Husband_BankID int=null,@Husband_AccNo nvarchar(20)=null,@Husband_IFSCCode nvarchar(15)=null,                
@Husband_BranchName nvarchar(100)=null,@InfertilityOptions int=null,@InfertilityReferDH int=null,@Mobile_ID bigint=0,@Source_ID tinyint=0,                
@EID numeric(14)=null,                
@EIDT datetime=null,                
@Husband_EID numeric(14)=null,                
@Husband_EIDT datetime=null,                
@Case_no int,            
@PW_AadhaarLinked bit=0,            
@Husband_AadhaarLinked bit=0,            
@AWC varchar(14)='0',           
@DOB_w date='1990-01-01',  ---for KAFDI by jyoti        
@SR_User_Flag varchar(50) ='',      
@caste_pds_flag tinyint=0,                                 
@category_pds_flag tinyint=0,  
@TokenID nvarchar(200)=null      
,@InterState bit=0,     
@interstate_verification  int=1,    
@verification_rejected_remarks varchar(250)='',    
@verified_date DateTime=NULL,    
@verified_by int=NULL,    
@verifier_ip_address varchar(25)=NULL,
@Is_PVTG char(1)=null
)                
                
as                
BEGIN                
SET NOCOUNT ON                
set @msg='';                
Declare @CompareReg bigint=0 ,@Check as tinyint=0,@getdatefun smalldatetime--,@WifeAadhaar bigint=0,@HusbandAadhaar bigint=0                
                
select @Check=count(Registration_no),@getdatefun=GETDATE() from t_eligibleCouples WITH (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no            
              
   if(@DOB_w=null or @DOB_w='' or @DOB_w='1990-01-01')        
   Begin        
  set @DOB_w=convert(date,DATEADD(YEAR,-@Wife_current_age,@Date_regis))        
  end        
        
if(@Check=0)                
begin                
  begin tran                
select @CompareReg=Registration_no from t_eligibleCouples (NOLOCK) where HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code               
and Village_Code=@Village_Code  and Name_wife=@Name_wife and Mobile_no=@Mobile_no and Name_husband=@Name_husband                   
                
  if (@CompareReg=0 or @CompareReg='' or @CompareReg is null)                
                
  BEGIN                
            
                 
   --SELECT @Registration_no = Id_M+1 from m_lastId_mother             
               
   --update m_lastId_mother set Id_M=@Registration_no             
      DECLARE @ID_Table table( New_ID  bigint);            
      Update m_lastId_mother set ID_m = ID_m + 1 OUTPUT    inserted.ID_m into @ID_Table            
   select  @Registration_no=New_ID from @ID_Table            
            
    insert into t_eligibleCouples                
    (State_Code,District_Code,Rural_Urban,HealthBlock_Code,Taluka_Code,HealthFacility_Type,HealthFacility_Code,HealthSubFacility_Code,Village_Code                
    ,Financial_Yr,Financial_Year,Registration_no,ID_No,Register_srno,Name_wife,Name_husband,Whose_mobile,Mobile_no,Date_regis,Wife_current_age                
    ,Wife_marry_age,Hus_current_age,Hus_marry_age,Aadhar_No,Address,Religion_code,Caste,Male_child_born,Female_child_born,Male_child_live                
    ,Female_child_live,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant                
    ,Pregnant_test,Eligible,Status,ANM_ID,ASHA_ID,Case_no,Flag,IP_address,Created_By,Created_On,BPL_APL,HusbandAadhaar_no,PW_BankID,PW_AccNo                
    ,PW_IFSCCode,PW_BranchName,Husband_BankID,Husband_AccNo,Husband_IFSCCode,Husband_BranchName,InfertilityOptions,InfertilityReferDH                
    ,Mobile_ID,SourceID,EID,EIDT,Husband_EID,Husband_EIDT,PW_AadhaarLinked,Husband_AadhaarLinked,SR_User_Flag,caste_pds_flag,category_pds_flag,TokenID,InterState,interstate_verification)                
    values                
  (@State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code                
  ,@Financial_Yr,@Financial_Year,@Registration_no,@ID_No,@Register_srno,@Name_wife,@Name_husband,@Whose_mobile,@Mobile_no,@Date_regis,@Wife_current_age                
  ,@Wife_marry_age,@Hus_current_age,@Hus_marry_age,@Aadhar_No,@Address,@Religion_code,@Caste,@Male_child_born,@Female_child_born,@Male_child_live                
  ,@Female_child_live,@Young_child_gender,@Young_child_age_month,@Young_child_age_year,@Infertility_status,@Infertility_refer,'N'                
  ,null,'E','A',@ANM_ID,@ASHA_ID,1,0,@IP_address,@Created_By,@getdatefun,@BPL_APL,@Hus_Aadhar_No,@PW_BankID,@PW_AccNo                
  ,@PW_IFSCCode,@PW_BranchName,@Husband_BankID,@Husband_AccNo,@Husband_IFSCCode,@Husband_BranchName,@InfertilityOptions,@InfertilityReferDH                
  ,@Mobile_ID,@Source_ID,@EID,@EIDT,@Husband_EID,@Husband_EIDT,@PW_AadhaarLinked,@Husband_AadhaarLinked,@SR_User_Flag,@caste_pds_flag,@category_pds_flag,@TokenID,@InterState,@interstate_verification)                
        
  -- added by brijesh for DCRCH Count on 16022021      
   if not exists(select 1 from SMS.dbo.Live_Count_EC(nolock) where Count_Date=convert(date,GETDATE()) and State_Code=@State_Code)      
    begin      
     insert into SMS.dbo.Live_Count_EC (State_Code,EC_Count_Total,EC_Count_Year,EC_Count_Month,EC_Count_Week,EC_Count_Today )      
     select  State_Code,EC_Count_Total,EC_Count_Year,EC_Count_Month,EC_Count_Week,1 as EC_Count_Today from SMS.dbo.Live_Count_EC(nolock)       
     where State_Code=@State_Code and Count_Date=convert(date,GETDATE()-1)      
    end      
   else      
    begin      
     update SMS.dbo.Live_Count_EC set EC_Count_Today += 1 where Count_Date=convert(date,GETDATE()) and State_Code=@State_Code      
    end      
                   
   insert into t_mother_registration(State_Code,District_Code,Rural_Urban,HealthBlock_Code,Taluka_Code,HealthFacility_Type,HealthFacility_Code                
    ,HealthSubFacility_Code,Village_code,Registration_no,Name_PW,Name_H,[Address],Mobile_No,Mobile_Relates_To,Religion_code,Caste,Age,BPL_APL,ANM_Id,ASHA_Id,Case_no            
    ,Flag,Registration_Date,Birth_Date,Created_By,Created_On,SourceID,IP_address,SR_User_Flag,caste_pds_flag,category_pds_flag,InterState,interstate_verification,verification_rejected_remarks,verified_by,verified_date,verifier_ip_address,Is_PVTG)                
    values(@State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,@HealthFacility_Code                
    ,@HealthSubFacility_Code,@Village_code,@Registration_no,@Name_wife,@Name_husband,@Address,@Mobile_No,@Whose_mobile,@Religion_code,@Caste,@Wife_current_age              
    ,@BPL_APL,@ANM_Id,@ASHA_Id,1,0,'1990-01-01',@DOB_w,@Created_By,@getdatefun,@Source_ID,@IP_address,@SR_User_Flag,@caste_pds_flag,@category_pds_flag,@InterState,@interstate_verification,@verification_rejected_remarks,@verified_by,@verified_date,@verifier_ip_address,@Is_PVTG)                
                       
   insert into t_page_tracking(Registration_no,Page_Code,Execution_Date,Case_no,Is_Previous_Current,InterState)values(@Registration_no,'EC',@getdatefun,1,1,@InterState)            
            
 --insert into t_Hierarchy_EC_Master(Registration_no,Case_no,State_Code,District_Code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code,Village_Code,Created_Date,Reg_Date)            
 --   values(@Registration_no,1,@State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,@getdatefun,@Date_regis)             
              
   insert into t_eligibleCouples_Status (Registration_no,ID_No,MAX_Case_no,Eligible,Status,Reason,InEligility_FinYear,IP_address,Created_By,Created_On)          
    values (@Registration_no,@ID_No,1,'E','A','E',0,@IP_address,@Created_By,@getdatefun)          
              
              
          
                    
              
                   
   set @msg = 'Record Save Successfully !!!'                
                    
  END                
  else                
  BEGIN                
                 
   --set @msg = 'Eligible Couple already exists with same Name,Husband Name,Mobile No.,Registration Date along with RCH ID No.'+cast(@CompareReg as varchar(12))+'.'                
   set @msg = 'Eligible Couple record already exists with the same Woman Name, Husband Name and Mobile No. for RCH ID No.'+cast(@CompareReg as varchar(12))+'.'                
   ----set @Registration_no=@CompareReg                
   --select Name_husband,Name_wife,Mobile_no,Date_regis from t_eligibleCouples where Registration_no=@Registration_no                
  END                
   Commit tran                      
END                
else                
 BEGIN                
        Select @HealthFacility_Code=HealthFacility_Code , @HealthSubFacility_Code=HealthSubFacility_Code,@Village_Code=Village_Code from t_eligibleCouples (nolock) where Registration_no=@Registration_no and Case_no=@Case_no    
          
  select @CompareReg=Registration_no from t_eligibleCouples (NOLOCK) where HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code               
and Village_Code=@Village_Code  and Name_wife=@Name_wife and Mobile_no=@Mobile_no and Name_husband=@Name_husband and Registration_no <> @Registration_no                  
                
  if (@CompareReg=0 or @CompareReg='' or @CompareReg is null)                
   begin             
             
-- Declare @Abortion_Date as date,@Maternal_Death as int,@Delivery_Date as date,@EDD as date,@Isvalid bit          
--select @Abortion_Date=Mother_Abortion_Date,@Maternal_Death=isnull(Mother_Death,0),@Delivery_date=Delivery_date,@EDD=Mother_EDD_Date           
--  from t_mother_infant_intermediate (NOLOCK) where Registration_no=@Registration_no AND Case_no=@Case_no          
            
--  IF(@Maternal_Death<>1)          
--  BEGIN          
--   IF(@Abortion_Date IS NOT NULL AND @Abortion_Date<>'' and @Abortion_Date<@Date_regis )          
--   BEGIN          
--    set @Isvalid=1          
              
--   END          
--   ELSE IF(@Delivery_date IS NOT NULL AND @Delivery_date<>'' and convert(date,DateAdd(day,42,@Delivery_date))<@Date_regis )          
--   BEGIN          
--    set @Isvalid=1          
              
--   END          
--   ELSE IF(@EDD IS NOT NULL AND @EDD<>'' and convert(date,DateAdd(day,42,@EDD))<@Date_regis )          
--   BEGIN          
--    set @Isvalid=1          
              
--   END          
            
--  END          
--  ELSE          
--  BEGIN          
--   set @Isvalid=0          
            
--  END          
          
--  if(@Isvalid=1)          
--  begin            
    INSERT INTO l_eligibleCouples([State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]            
      ,[HealthSubFacility_Code],[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[Register_srno],[Name_wife],[Name_husband]            
      ,[Whose_mobile],[Landline_no],[Mobile_no],[Date_regis],[Wife_current_age],[Wife_marry_age],[Hus_current_age],[Hus_marry_age],[Address]                
      ,[Religion_Code],[Caste],[Identity_type],[Identity_number],[Male_child_born],[Female_child_born],[Male_child_live],[Female_child_live]            
      ,[Young_child_gender],[Young_child_age_month],[Young_child_age_year],[Infertility_status],[Infertility_refer],[Pregnant],[Pregnant_test]            
      ,[Eligible],[Status],[ANM_ID],[ASHA_ID],[Case_no],[Flag],[IP_address],[Aadhar_No],[EID],[EIDT]            
      ,[BPL_APL],[HusbandAadhaar_no],[PW_AadhaarLinked],[PW_BankID],[PW_AccNo],[PW_IFSCCode],[PW_BranchName],[Husband_AadhaarLinked]            
      ,[Husband_BankID],[Husband_AccNo],[Husband_IFSCCode],[Husband_BranchName],[InactiveECReason],[InfertilityOptions],[InfertilityReferDH]            
     ,[Delete_Mother],[ReasonForDeletion],[DeletedOn],[CPSMS_Flag],[IsHusbandFather],[Mobile_ID]            
      ,[Created_By],[Created_On],Log_Created_By,Log_Created_On ,SourceID )            
   SELECT             
     [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code]            
      ,[HealthSubFacility_Code],[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[Register_srno],[Name_wife],[Name_husband]            
      ,[Whose_mobile],[Landline_no],[Mobile_no],[Date_regis],[Wife_current_age],[Wife_marry_age],[Hus_current_age],[Hus_marry_age],[Address]            
      ,[Religion_Code],[Caste],[Identity_type],[Identity_number],[Male_child_born],[Female_child_born],[Male_child_live],[Female_child_live]            
      ,[Young_child_gender],[Young_child_age_month],[Young_child_age_year],[Infertility_status],[Infertility_refer],[Pregnant],[Pregnant_test]            
      ,[Eligible],[Status],[ANM_ID],[ASHA_ID],[Case_no],[Flag],[IP_address],[Aadhar_No],[EID],[EIDT]            
      ,[BPL_APL],[HusbandAadhaar_no],[PW_AadhaarLinked],[PW_BankID],[PW_AccNo],[PW_IFSCCode],[PW_BranchName],[Husband_AadhaarLinked]            
      ,[Husband_BankID],[Husband_AccNo],[Husband_IFSCCode],[Husband_BranchName],[InactiveECReason],[InfertilityOptions],[InfertilityReferDH]            
      ,[Delete_Mother],[ReasonForDeletion],[DeletedOn],[CPSMS_Flag],[IsHusbandFather],[Mobile_ID]            
      ,[Created_By],[Created_On],[Created_By],@getdatefun,SourceID                   
       FROM t_eligibleCouples (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no        
    update t_eligibleCouples                 
      set                 
                        
      Financial_Yr=@Financial_Yr,                
      Financial_Year=@Financial_Year,                
      Register_srno=@Register_srno,                
      Name_wife=@Name_wife,            
      Name_husband=@Name_husband,                
      Whose_mobile=@Whose_mobile,                
                        
      Mobile_no=@Mobile_no,                
      Date_regis=@Date_regis,                
      Wife_current_age=@Wife_current_age,                
      Wife_marry_age=@Wife_marry_age,                
      Hus_current_age=@Hus_current_age,                
      Hus_marry_age=@Hus_marry_age,                
      --Aadhar_No=@Aadhar_No,      done by jyoti 23/01/2019          
      Address=@Address,                
      Religion_code=@Religion_code,                
      --Caste=@Caste,                
      Caste=(CASE WHEN ISNULL(caste_pds_flag,0)=1 THEN Caste ELSE @Caste END),                  
      Male_child_born=@Male_child_born,                
      Female_child_born=@Female_child_born,                
      Male_child_live=@Male_child_live,                
      Female_child_live=@Female_child_live,                
      Young_child_gender=@Young_child_gender,                
      Young_child_age_month=@Young_child_age_month,                
      Young_child_age_year=@Young_child_age_year,                
      Infertility_status=@Infertility_status,                
      Infertility_refer=@Infertility_refer,                
      --Pregnant='N',      changed by Aruna 5/20/2019               
      --Pregnant_test='D', changed by Aruna 5/20/2019                 
      ANM_ID=@ANM_ID,                
      ASHA_ID=@ASHA_ID,                
      Flag = 0,                
      IP_address=@IP_address,                
      --BPL_APL=@BPL_APL,      
      BPL_APL=(CASE WHEN ISNULL(category_pds_flag,0)=1 THEN BPL_APL ELSE @BPL_APL END),                  
      --HusbandAadhaar_no=@Hus_Aadhar_No,  done by jyoti 23/01/2019               
                        
      PW_BankID=@PW_BankID,                
      PW_AccNo=@PW_AccNo,                
      PW_IFSCCode=@PW_IFSCCode,                
      PW_BranchName=@PW_BranchName,                
                         
      Husband_BankID=@Husband_BankID,                
      Husband_AccNo=@Husband_AccNo,                
      Husband_IFSCCode=@Husband_IFSCCode,                
      Husband_BranchName=@Husband_BranchName,                
      InfertilityOptions=@InfertilityOptions,                
      InfertilityReferDH=@InfertilityReferDH,                
      Mobile_ID=@Mobile_ID,                
      Updated_On=@getdatefun,                
      Updated_By=@Created_By,                
      EID=@EID,                
      EIDT=@EIDT,                
      Husband_EID=@Husband_EID,                
      Husband_EIDT=@Husband_EIDT,              
      PW_AadhaarLinked=@PW_AadhaarLinked,--Added on 08092016            
      Husband_AadhaarLinked=@Husband_AadhaarLinked,--Added on 08092016       
      SR_User_Flag=@SR_User_Flag           
     WHERE Registration_no=@Registration_no                 
      and Case_no=@Case_no              
   -- update [t_Hierarchy_EC_Master] set Reg_Date=@Date_regis            
   --where [t_Hierarchy_EC_Master].Registration_no=@Registration_no             
   --and [t_Hierarchy_EC_Master].Case_no=@Case_no               
    update t_mother_registration set  Name_PW=@Name_wife            
      ,Name_H=@Name_husband            
      ,[Address]=@Address            
      ,Mobile_No=@Mobile_No            
      ,Mobile_Relates_To=@Whose_mobile            
      ,Religion_code=@Religion_code            
      --,Caste=@Caste      
       ,Caste=(CASE WHEN ISNULL(caste_pds_flag,0)=1 THEN Caste ELSE @Caste END)             
      ,Age=@Wife_current_age            
      --,BPL_APL=@BPL_APL        
      ,BPL_APL=(CASE WHEN ISNULL(category_pds_flag,0)=1 THEN BPL_APL ELSE @BPL_APL END)             
      --,Birth_Date=convert(date,DATEADD(YEAR,-@Wife_current_age,@Date_regis))            
      ,Birth_Date=  @DOB_w  ----for KAFDI by jyoti                
      ,Updated_On=@getdatefun               
      ,Updated_By=updated_by
	   ,Is_PVTG=@Is_PVTG               
      where Registration_no=@Registration_no                 
      and Case_no=@Case_no                
    set @msg = 'Record Save Successfully !!!'     
      
    /*added for change the verification flag if mob no Change on 01/09/2021*/     
if exists(select 1 from t_MotherEntry_Verification WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Mobile_no<>@Mobile_no)          
Begin          
Update t_MotherEntry_Verification set is_verified=0,Is_Confirm=0,Updated_On=getdate(),Updated_By=@Created_By where Registration_no=@Registration_no and Case_no=@Case_no       
End   
if exists(select 1 from t_MotherEntry_Verification WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Mobile_no=@Mobile_no)          
Begin       
Update t_MotherEntry_Verification set is_verified=1,Is_Confirm=1,Updated_On=getdate(),Updated_By=@Created_By where Registration_no=@Registration_no and Case_no=@Case_no  and Mobile_no=@Mobile_no     
End                
  --end          
  --else          
  --begin          
  -- set @msg = 'Duplicate Entry !!!'          
  --end          
    END                
  else                
  BEGIN                
                 
   --set @msg = 'Eligible Couple already exists with same Name,Husband Name,Mobile No.,Registration Date along with RCH ID No.'+cast(@CompareReg as varchar(12))+'.'                
   --set @msg = 'Eligible Couple already exist with same Woman Name, Husband Name, Mobile No. and Birth date for RCH ID No.'+cast(@CompareReg as varchar(12))+'.'                
   set @msg = 'Eligible Couple record already exists with the same Woman Name, Husband Name and Mobile No. for RCH ID No.'+cast(@CompareReg as varchar(12))+'.'                
   ----set @Registration_no=@CompareReg                
   --select Name_husband,Name_wife,Mobile_no,Date_regis from t_eligibleCouples where Registration_no=@Registration_no                
  END             
           
 END                
                
RETURN                
END                
                
IF (@@ERROR <> 0)                
BEGIN                
     RAISERROR ('TRANSACTION FAILED',16,-1)                
     ROLLBACK TRANSACTION                
END                
  

