USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetEligibleCouple]    Script Date: 09/26/2024 12:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* 
select top 1 * from RCH_99.dbo.t_eligibleCouples where Village_Code=12407       
         
  64 64  parameters    
 MS_SetEligibleCouple 95,11,'R',558,'0494',1,1916
 ,10058,12407,'2015-16',2015,23,'test ECMRMM','test husband','H','1234567891','9899978999','2015-04-01',11,11,'','','0','test address',2,99,'','',1
 ,1,1,1,'M',4,25,'N','',0,0,24318,113366,'',0,'00000',1,227651709627,'',0,1000000000,'SBIN0123456','test branch','',0,0,'','',01,'0','','0','',1,1,0
 
 [MS_SetEligibleCouple] 99,5,'R',13,'0015',4,96,248,0,
 '2015-16',2015,23,'test ECMRMM','test husband','H','1234567891','9899978999','2015-04-01',11,11,'','','0','test address',2,99,'','',1
 ,1,1,1,'M',4,25,'N','',0,0,24318,113366,'',0,'00000',1,227651709627,'',0,1000000000,'SBIN0123456','test branch','',0,0,'','',01,'0','','0','',1,1,0
*/					  	
ALTER procedure [dbo].[MS_SetEligibleCouple]          
(          
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,
@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year smallint,          
@Register_srno int,@Name_wife nvarchar(99),@Name_husband nvarchar(99),@Whose_mobile char(1),@Landline_no nvarchar(10),
@Mobile_no nvarchar(10),@Date_regis Datetime,@Wife_current_age tinyint,@Wife_marry_age tinyint,@Hus_current_age tinyint,
@Hus_marry_age tinyint,@Aadhar_No numeric(12)=null,@Address nvarchar(150),@Religion_code int,@Caste tinyint,@Identity_type tinyint,
@Identity_number varchar(20),@Male_child_born tinyint,@Female_child_born tinyint,@Male_child_live tinyint,@Female_child_live tinyint,
@Young_child_gender char(1),@Young_child_age_month tinyint,  @Young_child_age_year tinyint,@Infertility_status char(1),@Infertility_refer nvarchar(100)          
 -- 2 parameters deleted ,@Status_code char(1),@SubStatus_code char(1)-- 2 parameters added          
,@InfertilityOptions int=null,@InfertilityReferDH int=null,@ANM_ID int,@ASHA_ID int,@IP_address varchar(25)='',@Created_By int=-1,
@msg nvarchar(max)= '00000' out,@BPL_APL tinyint,@Hus_Aadhar_No numeric(12)=null,@PW_AadhaarLinked bit,@PW_BankID int,@PW_AccNo nvarchar(20),          
@PW_IFSCCode nvarchar(15),@PW_BranchName nvarchar(100),@Husband_AadhaarLinked bit,@Husband_BankID int,@Husband_AccNo nvarchar(20),
@Husband_IFSCCode nvarchar(15),@Husband_BranchName nvarchar(100),@Mobile_ID bigint=0,@EID numeric(14)=null,@EIDT datetime=''          
,@Husband_EID numeric(14)=null ,@Husband_EIDT datetime,@Case_no int,@Mode int,@Registration_no bigint          
)          
         
AS          
BEGIN          
declare @db varchar(50),@s varchar(max)        
          
if(@State_Code <=9)          
begin          
set @db='RCH_0'+cast(@State_Code as varchar)          
end          
else          
begin          
set @db='RCH_'+cast(@State_Code as varchar)          
end          
      
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin   
set @s='INSERT INTO '+cast(@db as varchar)+'.dbo.MS_eligibleCouples          
([State_Code] , [District_Code] , [Rural_Urban] , [HealthBlock_Code] , [Taluka_Code] , [HealthFacility_Type] , [HealthFacility_Code] ,          
 [HealthSubFacility_Code] , [Village_Code] , [Financial_Yr] , [Financial_Year]  
 , [ID_No] , [Register_srno] ,[Name_wife] , [Name_husband] , [Whose_mobile] , [Landline_no] , [Mobile_no] , [Date_regis] , [Wife_current_age] , 
 [Wife_marry_age] ,          
 [Hus_current_age] , [Hus_marry_age] , [Address] , [Religion_Code], [Caste], [Identity_type] , [Identity_number] , [Male_child_born] ,          
 [Female_child_born] , [Male_child_live], [Female_child_live] , [Young_child_gender] , [Young_child_age_month] , [Young_child_age_year] ,          
 [Infertility_status], [Infertility_refer] , [Pregnant] , [Pregnant_test] , InfertilityOptions , InfertilityReferDH , [ANM_ID] , [ASHA_ID] ,           
  [Flag] , [IP_address] , [Created_By] , [Created_On] , [Aadhar_No] , [BPL_APL] , [HusbandAadhaar_no] ,           
 [PW_AadhaarLinked] , [PW_BankID] ,          
 [PW_AccNo] , [PW_IFSCCode] , [PW_BranchName] , [Husband_AadhaarLinked] , [Husband_BankID] , [Husband_AccNo] , [Husband_IFSCCode] ,           
 [Husband_BranchName] ,
 [Mobile_ID],Exec_date,[EID],
 [EIDT],[Husband_EID],[Husband_EIDT],
 [Case_no], Mode,Registration_no
 )
values ('+cast(@State_Code  as varchar(5))+'
,'+cast(@District_Code  as varchar)+' ,'''+cast(@Rural_Urban  as varchar)+''' ,'+cast(@HealthBlock_Code  as varchar)+'
,'''+cast(@Taluka_Code  as varchar)+''' ,'+cast(@HealthFacility_Type  as varchar)+','+cast(@HealthFacility_Code  as varchar)+'
,'+cast(@HealthSubFacility_Code  as varchar)+' ,'+cast(@Village_Code  as varchar)+','''+cast(@Financial_Yr  as varchar)+''','+cast(@Financial_Year  as varchar)+'
,'''','+cast(@Register_srno  as varchar)+','''+cast(@Name_wife  as varchar)+''','''+cast(@Name_husband  as varchar)+''','''+cast(@Whose_mobile  as varchar)+'''
,'''+cast(@Landline_no  as varchar)+''','''+cast(@Mobile_no  as varchar)+''','''+cast(@Date_regis  as varchar)+''','+cast(@Wife_current_age  as varchar)+'
,'+cast(@Wife_marry_age  as varchar)+','+cast(@Hus_current_age  as varchar)+','+cast(@Hus_marry_age  as varchar)+','''+cast(@Address  as varchar)+'''
,'+cast(@Religion_code  as varchar)+','+cast(@Caste  as varchar)+' ,'+cast(@Identity_type  as varchar)+' ,'''+cast(@Identity_number  as varchar)+''' 
,'+cast(@Male_child_born  as varchar)+','+cast(@Female_child_born  as varchar)+','+cast(@Male_child_live  as varchar)+','+cast(@Female_child_live  as varchar)+'
,'''+cast(@Young_child_gender  as varchar)+''','+cast(@Young_child_age_month  as varchar)+', '+cast( @Young_child_age_year  as varchar)+'
,'''+cast( @Infertility_status  as varchar)+''','''+cast(@Infertility_refer  as varchar)+''',''N'',''D'','''+cast(@InfertilityOptions  as varchar)+'''
,'''+cast(@InfertilityReferDH  as varchar)+''','+cast(@ANM_ID  as varchar)+','+cast(@ASHA_ID  as varchar)+',0,'''','+cast(@Created_By  as varchar)+'
,'''+cast(GETDATE() as varchar)+''','+cast(@Aadhar_No  as varchar)+','+cast(@BPL_APL  as varchar)+','+cast(@Hus_Aadhar_No  as varchar)+','+cast(@PW_AadhaarLinked  as varchar)+'
,'+cast(@PW_BankID  as varchar)+','''+cast(@PW_AccNo  as varchar)+''','''+cast(@PW_IFSCCode  as varchar)+''','''+cast(@PW_BranchName  as varchar)+'''
,'+cast(@Husband_AadhaarLinked  as varchar)+','+cast(@Husband_BankID  as varchar)+','''+cast(@Husband_AccNo  as varchar)+'''
,'''+cast(@Husband_IFSCCode  as varchar)+''','''+cast(@Husband_BranchName  as varchar)+''','+cast(@Mobile_ID  as varchar)+'
,'''+cast(GETDATE() as varchar)+''','+cast(@EID  as varchar)+' ,'''+cast(@EIDT  as varchar)+''','+cast(@Husband_EID  as varchar)+' ,'''+cast(@Husband_EIDT as varchar)+'''
,'+cast(@Case_no  as varchar)+', '+cast(@Mode  as varchar)+', '+cast(@Registration_no  as varchar)+'
)
 
 '  
--print(@s)          
exec(@s)          
set @msg=''+CAST(@Mobile_ID AS VARCHAR)+''          
end      
else      
begin      
--set @msg='State Not Exist in Database'   
set @msg='ERROR'    
end        
           
END          
IF (@@ERROR <> 0)  
BEGIN  
 set @msg='0'  
     RAISERROR ('ERROR',16,-1)  
     ROLLBACK TRANSACTION  
END
