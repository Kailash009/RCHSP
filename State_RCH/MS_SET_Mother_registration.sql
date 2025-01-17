USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SET_Mother_registration]    Script Date: 09/26/2024 12:53:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[MS_SET_Mother_registration]        
(@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,        
@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year smallint,        
@Registration_no bigint out,@Register_srno nvarchar(10),@Name_PW nvarchar(50),@Name_H nvarchar(50),        
@Address nvarchar(150),@Registration_Date date,@Mobile_No varchar(10),@Mobile_Relates_To char(1),        
@Religion_code int=0,@Caste tinyint,@BPL_APL tinyint,@Birth_Date Date,@Age tinyint,@Height float=0,        
@ANM_ID int,@ASHA_ID int,@Case_no int,@IP_address varchar(25)='',@Created_By int,@JSY_Beneficiary char(1)='na',        
        
@Delete_Mother int=0,        
@msg varchar(200)='00000' out        
-- 1 parameter removed        
--,@PregnancyWeeks int=0          
        
 --1 parameter added        
,@JSY_Payment_Received char(1)=null,        
        
@Mobile_ID bigint=0        
,@SourceID int        
)        
AS        
BEGIN        
declare @db varchar(50),@s varchar(max),@SNO AS VARCHAR(200)        
        
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
        
set @s='        
INSERT INTO '+cast(@db as varchar)+'.dbo.MS_mother_registration(        
[State_Code]      ,[District_Code]      ,[Rural_Urban]      ,[HealthBlock_Code]      ,[Taluka_Code]        
,[HealthFacility_Type]      ,[HealthFacility_Code]      ,[HealthSubFacility_Code]      ,[Village_Code]        
,[Financial_Yr]      ,[Financial_Year]      ,[Registration_no]             
,[Register_srno]      ,[Name_PW]      ,[Name_H]      ,[Address]      ,[Registration_Date]      ,[Mobile_No]      ,[Mobile_Relates_To]        
,[Religion_code]      ,[Caste]      ,[BPL_APL]      ,[Birth_Date]      ,[Age]      ,[Height]      ,[ANM_ID]      ,[ASHA_ID]        
,[Case_no]      ,[IP_address]           ,[Created_By]      ,[Created_On]      ,[Mobile_ID]      ,[JSY_Beneficiary]        
,[Delete_Mother]               ,JSY_Payment_Received,flag,SourceID        
)        
VALUES        

(        
'+cast(@State_Code as varchar)+'      ,'+cast(@District_Code as varchar)+'      ,'''+cast(@Rural_Urban  as varchar)+'''     ,'+cast(@HealthBlock_Code as varchar)+'      ,'''+cast(@Taluka_Code as varchar)+'''        
,'+cast(@HealthFacility_Type as varchar)+'      ,'+cast(@HealthFacility_Code as varchar)+'      ,'+cast(@HealthSubFacility_Code as varchar)+'      ,'+cast(@Village_Code as varchar)+'        
,'''+cast(@Financial_Yr as varchar)+'''      ,'+cast(@Financial_Year as varchar)+'      ,'+cast(@Registration_no as varchar)+'             
,'''+cast(@Register_srno as varchar)+'''      ,'''+cast(@Name_PW as varchar)+'''     ,'''+cast(@Name_H as varchar)+'''      ,'''+cast(@Address as varchar)+'''      ,'''+cast(@Registration_Date as varchar)+'''      ,'''      
+cast(@Mobile_No as varchar)+'''      ,'''+cast(@Mobile_Relates_To as varchar)+'''        
,'+cast(@Religion_code as varchar)+'      ,'+cast(@Caste as varchar)+'      ,'+cast(@BPL_APL as varchar)+'      ,'''+cast(@Birth_Date as varchar)+'''      ,'+cast(@Age as varchar)+'      ,'+cast(@Height as varchar)+'      ,'+cast(@ANM_ID as varchar)


+'      ,'+cast(@ASHA_ID as varchar)+'        
,'+cast(@Case_no as varchar)+'      ,'''+cast(@IP_address as varchar)+'''           ,'+cast(@Created_By as varchar)+'      ,GETDATE()      ,'+cast(@Mobile_ID as varchar)+'      ,'''+cast(@JSY_Beneficiary as varchar)+'''        
,'+cast(@Delete_Mother as varchar)+'                 ,'''+cast(@JSY_Payment_Received as varchar)+''',1,'+cast(@SourceID as varchar)+'  )  '         
--PRINT(@S)              
EXEC(@s)        
set @msg='        
'+CAST(@Mobile_ID AS VARCHAR)+'        
'        
        
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
