USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlChildren_pnc]    Script Date: 09/26/2024 15:52:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[MS_SetXmlChildren_pnc]      
(@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,      
@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year smallint,      
@Registration_no bigint out,@ID_No varchar(18)=null,@InfantRegistration bigint,@PNC_No int,@PNC_Period int,      
@PNC_Date date,@Infant_Weight float,@DangerSign_Infant nvarchar(50),@DangerSign_Infant_Other nvarchar(50)=null,@DangerSign_Infant_length int,      
@ReferralFacility_Infant int,@ReferralFacilityID_Infant int,@ReferralLoationOther_Infant nvarchar(50)=null,@Infant_Death bit,      
@Infant_Death_Place As tinyint,@Infant_Death_Date date =null,@Infant_Death_Reason nvarchar(50),@Infant_Death_Reason_Other nvarchar(50)=null,      
@Infant_Death_Reason_length int,@ANM_ID int,@ASHA_ID int,@Case_no int,@IP_address varchar(25),@Created_By int,@Delivery_date date=null,      
@Mobile_ID bigint=0,@msg varchar(200)='00000' out      
      
)      
as      
begin      
declare @s varchar(max),@db as varchar(30)      
      
if(@State_Code <=9)      
begin      
set @db='RCH_0'+CAST(@State_Code as varchar)      
end      
      
else      
begin      
set @db='RCH_'+CAST(@State_Code AS VARCHAR)      
end      
    
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin      
      
SET @s=      
'      
insert into '+CAST(@db as varchar)+'.dbo.MS_child_pnc      
([State_Code]      ,[District_Code]      ,[Rural_Urban]      ,[HealthBlock_Code]      ,[Taluka_Code]      ,[HealthFacility_Type]      
      ,[HealthFacility_Code]      ,[HealthSubFacility_Code]      ,[Village_Code]      ,[Financial_Yr]      ,[Financial_Year]      
      ,[Registration_no]      ,[ID_No]      ,[InfantRegistration]      ,[PNC_No]      ,[PNC_Type]      ,[PNC_Date]      
      ,[Infant_Weight]      ,[DangerSign_Infant]      ,[DangerSign_Infant_Other]      ,[DangerSign_Infant_length]      ,[ReferralFacility_Infant]      
      ,[ReferralFacilityID_Infant]      ,[ReferralLoationOther_Infant]      ,[Infant_Death]      ,[Place_of_death]      ,[Infant_Death_Date]      
      ,[Infant_Death_Reason]      ,[Infant_Death_Reason_Other]      ,[Infant_Death_Reason_length]          ,[ANM_ID]      
      ,[ASHA_ID]      ,[Case_no]      ,[IP_address]      ,[Created_By]      ,[Created_On]      ,[Mobile_ID])      
            
      
      
values      
('+cast(@State_Code  as varchar)+','+cast(@District_Code  as varchar)+' ,'''+cast(@Rural_Urban  as varchar)+''' ,'+cast(@HealthBlock_Code  as varchar)+','''+cast(@Taluka_Code  as varchar)+''' ,'+cast(@HealthFacility_Type  as varchar)+    
','+cast(@HealthFacility_Code  as varchar)+','+cast(@HealthSubFacility_Code  as varchar)+' ,'+cast(@Village_Code  as varchar)+'      
      ,'''+cast(@Financial_Yr as varchar)+'''      ,'+cast(@Financial_Year as varchar)+'      
      ,'+cast(@Registration_no as varchar)+'      ,''''     ,'+cast(@InfantRegistration as varchar)+'      ,'+cast(@PNC_No as varchar)+'     ,'+cast(@PNC_Period  as varchar)+'           
       ,'''+cast(@PNC_Date as varchar)+'''      
      ,'+cast(@Infant_Weight as varchar)+'      ,'''+cast(@DangerSign_Infant as varchar)+'''     ,'''+cast(@DangerSign_Infant_Other as varchar)+'''     ,'+cast(@DangerSign_Infant_length as varchar)+'          
        ,'+cast(@ReferralFacility_Infant as varchar)+'      
      ,'+cast(@ReferralFacilityID_Infant as varchar)+'      ,'''+cast(@ReferralLoationOther_Infant as varchar)+'''      ,'+cast(@Infant_Death as varchar)+'      
           ,'+cast(@Infant_Death_Place as varchar)+'      ,'''+cast(@Infant_Death_Date as varchar)+'''      
      ,'''+cast(@Infant_Death_Reason as varchar)+'''      ,'''+cast(@Infant_Death_Reason_Other as varchar)+'''      ,'+cast(@Infant_Death_Reason_length as varchar)+'      
                 ,'+cast(@ANM_ID as varchar)+'      
      ,'+cast(@ASHA_ID  as varchar)+'     ,'+cast(@Case_no as varchar)+'      ,'''+cast(@IP_address as varchar)+'''     ,'+cast(@Created_By as varchar)+'      ,GETDATE()      ,'+cast(@Mobile_ID as varchar)+'      
      
)      
      
'      
--print(@s)      
exec(@s)      
      
set @msg='      
'+CAST(@Mobile_ID as varchar)+'      
      
'      
     
     
   end  
else  
begin  
--set @msg='State Not Exist in Database'   
set @msg='ERROR'  
end    
      
      
end 
