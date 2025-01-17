USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlChildren_tracking]    Script Date: 09/26/2024 15:52:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*      
MS_SetXmlChildren_tracking 27,    26,    'R',    84,  '0252',    1,    274,    1622,    32155,    227000695830,   '19',    '2013-11-01',      
    '0',    '3',    0,   '',   '',  '1900-01-01',   '',   93360,    40392,    'fe80::91da:f736:fa88:4821',    1915,    '',    0,    0,      
    '',    0,    '',    1,    2,'',    251135      
      
*/      
ALTER procedure [dbo].[MS_SetXmlChildren_tracking]      
(      
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,@HealthFacility_Code int,      
@HealthSubFacility_Code int,@Village_Code int,@Registration_no bigint out,@Immu_code nvarchar(10)=null,@Immu_date date,@Immu_Source char(1),      
@AEFI_Serious char(1),@Serious_Reason int,@Vac_Name nvarchar(50),@Vac_batch nvarchar(20),@Vac_expiry date =null,@Vac_manuf nvarchar(50),      
@ANM_ID int,@ASHA_ID int,@IP_address varchar(25),@Created_By int,@Remarks nvarchar(250),@Reason_closure int,@Death_reason int,@Other_Death_reason nvarchar(100),      
@Death_Date date =null,@Death_Place int=0 ,   -- 2 parametrs added      
@Closure_Remarks int,@NonSerious_Reason nvarchar(100),@Fully_Immunized tinyint,@Received_AllVaccines tinyint,@msg nvarchar(max)= '00000' out      
,@Mobile_ID bigint,@SourceID int      
,@Case_closure bit,      
@Reason_closure_Other nvarchar(50)      
)      
as      
begin      
declare @db varchar(30),@s varchar(max)      
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
      
SET @s ='      
insert into '+CAST(@db as varchar)+'.dbo.MS_children_tracking      
(      
State_Code ,District_Code ,Rural_Urban ,HealthBlock_Code ,Taluka_Code ,HealthFacility_Type ,HealthFacility_Code ,      
HealthSubFacility_Code ,Village_Code ,Registration_no ,Immu_code ,Immu_date ,Immu_Source ,AEFI_Serious ,      
Serious_Reason ,Vac_Name ,Vac_batch ,Vac_exp_date ,Vac_manuf ,ANM_ID ,ASHA_ID ,      
IP_address ,Created_By ,Remarks ,Reason_closure ,Death_reason ,Other_Death_reason ,Closure_Remarks ,      
NonSerious_Reason ,Fully_Immunized ,Received_AllVaccines ,Mobile_ID,Created_On ,DeathPlace,DeathDate      
,SourceID       
,Case_closure      
,Reason_closure_Other      
)      
      
      
values      
(      
'+cast(@State_Code  as varchar)+','+cast(@District_Code  as varchar)+' ,'''+cast(@Rural_Urban  as varchar)+''' ,'+cast(@HealthBlock_Code  as varchar)+','''+cast(@Taluka_Code  as varchar)+''' ,'+cast(@HealthFacility_Type  as varchar)+','    
+cast(@HealthFacility_Code  as varchar)+','+cast(@HealthSubFacility_Code  as varchar)+' ,'+cast(@Village_Code  as varchar)+'      
 ,'+cast(@Registration_no as varchar)+' ,'''+cast(@Immu_code as varchar)+''' ,'''+cast(@Immu_date as varchar)+''' ,'''+cast(@Immu_Source as varchar)+'''      
  ,'''+cast(@AEFI_Serious as varchar)+''' ,      
'+cast(@Serious_Reason as varchar)+' ,'''+cast(@Vac_Name as varchar)+''' ,'''+cast(@Vac_batch as varchar)+''' ,'''+cast(@Vac_expiry as varchar)+''' ,'''+cast(@Vac_manuf as varchar)+''' ,'+cast(@ANM_ID as varchar)+' , '+cast(@ASHA_ID as varchar)+' ,      
'''+cast(@IP_address as varchar)+''' ,'+cast(@Created_By as varchar)+' ,'''+cast(@Remarks as varchar)+''','+cast(@Reason_closure as varchar)+' ,'    
+cast(@Death_reason as varchar)+' ,'''+cast(@Other_Death_reason as varchar)+''' ,'+cast(@Closure_Remarks as varchar)+' ,      
'''+cast(@NonSerious_Reason as varchar)+''' ,'+cast(@Fully_Immunized as varchar)+' ,'+cast(@Received_AllVaccines as varchar)+' ,'+cast(@Mobile_ID as varchar)+',getdate()      
,'+cast(@Death_Place as varchar)+','''+cast(@Death_Date as varchar)+''','+cast(@SourceID as varchar)+'      
,'+cast(@Case_closure as varchar)+','''+cast(@Reason_closure_Other as varchar)+'''      
)      
'      
--print(@s)      
exec(@s)      
set @msg=''+cast(@Mobile_ID as varchar)+''      
    
 end  
else  
begin  
--set @msg='State Not Exist in Database'   
set @msg='ERROR'   
end    
     
      
end 
IF (@@ERROR <> 0)
BEGIN
	set @msg='0'
     RAISERROR ('ERROR',16,-1)
     ROLLBACK TRANSACTION
END

