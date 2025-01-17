USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlChildren_tracking_Medical]    Script Date: 09/26/2024 15:52:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[MS_SetXmlChildren_tracking_Medical]      
(      
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),      
@HealthFacility_Type int,@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,      
@Registration_no bigint out,@Immu_code int,@Breastfeeding int,@Complentary_Feeding int,@Month_Complentary_Feeding int,      
@Visit_Date date,@Child_Weight float,@Diarrhoea int,@ORS_Given int,@Pneumonia int,@Antibiotics_Given int,      
@Remarks nvarchar(255),@ANM_ID int,@ASHA_ID int,@IP_address varchar(25),@Created_by int,@Mobile_ID bigint,@msg nvarchar(max)= '00000' out      
)      
AS      
BEGIN      
declare @s varchar(max),@db varchar(30)      
      
if(@State_Code <=9)      
begin      
set @db='RCH_0'+CAST(@State_Code AS VARCHAR)      
end      
      
else      
begin      
SET @db='RCH_'+CAST(@State_Code as varchar)      
end      
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin     
      
set @s='      
insert into '+CAST(@db as varchar)+'.dbo.MS_children_tracking_medical      
(State_Code ,District_Code ,Rural_Urban ,HealthBlock_Code ,Taluka_Code ,      
HealthFacility_Type ,HealthFacility_Code ,HealthSubFacility_Code ,Village_Code ,      
Registration_no ,Immu_code ,Breastfeeding ,Complentary_Feeding ,Month_Complentary_Feeding ,      
Visit_Date ,Child_Weight ,Diarrhoea ,ORS_Given ,Pneumonia ,Antibiotics_Given ,      
Remarks ,ANM_ID ,ASHA_ID ,IP_address ,Created_by ,Mobile_ID,created_on)      
values      
('+cast(@State_Code  as varchar)+','+cast(@District_Code  as varchar)+' ,'''+cast(@Rural_Urban  as varchar)+''' ,'+cast(@HealthBlock_Code  as varchar)  
+','''+cast(@Taluka_Code  as varchar)+''' ,'+cast(@HealthFacility_Type  as varchar)+','+cast(@HealthFacility_Code  as varchar)+','+cast(@HealthSubFacility_Code  as varchar)+' ,'+cast(@Village_Code  as varchar)+'      
 ,'+cast(@Registration_no as varchar)+' ,'+cast(@Immu_code as varchar)+' ,'+cast(@Breastfeeding as varchar)+' ,'+cast(@Complentary_Feeding as varchar)+'      
  ,'+cast(@Month_Complentary_Feeding as varchar)+' ,      
'''+cast(@Visit_Date as varchar)+''' ,'+cast(@Child_Weight as varchar)+' ,'+cast(@Diarrhoea as varchar)+' ,'+cast(@ORS_Given as varchar)+' ,'+cast(@Pneumonia as varchar)+' ,'+cast(@Antibiotics_Given as varchar)+' ,       
'''+cast(@Remarks as varchar)+''' ,'+cast(@ANM_ID as varchar)+' ,'+cast(@ASHA_ID as varchar)+' ,'''+cast(@IP_address as varchar)+''' ,'+cast(@Created_by as varchar)+' ,'+cast(@Mobile_ID as varchar)+',getdate())      
'      
--print(@s)      
exec(@s)      
      
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
