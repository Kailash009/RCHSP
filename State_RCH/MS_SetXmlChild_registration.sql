USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlChild_registration]    Script Date: 09/26/2024 15:52:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*        
exec MS_SetXmlChild_registration    95,    16,    'R',    245,    '0705',    1,    2405,    13969,    10014195,    '2014-15',    2014,    99,   295003827796,        
    '2016-03-03',    'KUSHU',    'M',    '2014-11-28',    '21',    195003663433,    'MALLIKA',    '',  '9891097424',        
   'pune',   1,    99,    0,     '',    20914,   115756,    '0',   20914           
   ,'Kumar',   'W',    '5.0', '',   129411,0,'',0,'',0,'abcd'     ,4,1   
        
*/        
ALTER procedure [dbo].[MS_SetXmlChild_registration]        
(        
@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),@HealthFacility_Type int,@HealthFacility_Code int,        
@HealthSubFacility_Code int,@Village_Code int,@Financial_Yr varchar(7),@Financial_Year int,@Register_srno int,@Registration_no bigint out,@Registration_Date date,        
@Name_Child nvarchar(99),@Gender char(1),@Birth_Date date,@Birth_place nvarchar(99),@Mother_Reg_no bigint,@Name_Mother nvarchar(99),        
@Landline_no nvarchar(10),@Mobile_no nvarchar(10),@Address nvarchar(150),@Religion_code int,@Caste tinyint,@Identity_type tinyint,        
@Identity_number nvarchar(20),@ANM_ID int,@ASHA_ID int,@IP_address varchar(25),@Created_By int,        
@Name_Father nvarchar(99),@Mobile_Relates_To nvarchar(10),@Weight float,@msg nvarchar(200)= '00000' out,@Mobile_ID bigint        
,@DeliveryLocationID int,@Delivery_Location nvarchar(50)-- 2 parameters added        
/* 6 parameter added */        
,@Child_EID varchar(14)=null,        
@Child_EIDT datetime=null,        
@Child_Aadhar_No varchar(12)=null,        
@Birth_Certificate_No nvarchar(50),        
@Status int,        
@Case_no int=0        
)        
        
AS         
BEGIN        
DECLARE @DB AS VARCHAR(30),@S VARCHAR(MAX)        
        
IF(@State_Code <=9)        
BEGIN        
SET @DB='RCH_0'+CAST(@State_Code AS VARCHAR)        
END        
        
ELSE        
BEGIN        
SET @DB='RCH_'+CAST(@State_Code AS VARCHAR(2))        
END        
        
declare @Child_EID_numeric numeric(14),@Child_Aadhar_No_numeric numeric(12)        
set @Child_EID_numeric=cast(@Child_EID as numeric(14))        
set @Child_Aadhar_No_numeric=cast(@Child_Aadhar_No as numeric(12))        
        
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin       
SET @S='        
INSERT INTO '+CAST(@DB AS VARCHAR(6))+'.DBO.MS_children_registration        
(        
 State_Code ,District_Code ,Rural_Urban ,HealthBlock_Code ,Taluka_Code ,HealthFacility_Type ,HealthFacility_Code ,        
HealthSubFacility_Code ,Village_Code ,Financial_Yr ,Financial_Year ,Register_srno ,Registration_no ,Registration_Date ,        
Name_Child ,Gender ,Birth_Date ,Birth_place ,Mother_Reg_no ,Name_Mother ,Landline_no ,        
Mobile_no ,Address ,Religion_code ,Caste ,Identity_type ,Identity_number ,ANM_ID ,ASHA_ID ,        
IP_address ,Created_By,Created_On ,Name_Father ,Mobile_Relates_To ,Weight ,Mobile_ID, DeliveryLocationID,        
Delivery_Location        
   ,Child_EID ,        
 Child_EIDT ,        
 Child_Aadhar_No ,        
 Birth_Certificate_No ,        
 Status ,        
 Case_no         
        
)        
VALUES        
        
(        
'+cast(@State_Code  as varchar)+','+cast(@District_Code  as varchar)+' ,'''+cast(@Rural_Urban  as varchar)+''' ,'+cast(@HealthBlock_Code  as varchar)+','''+cast(@Taluka_Code  as varchar(6))+''' ,'+cast(@HealthFacility_Type  as varchar)+','+      
cast(@HealthFacility_Code  as varchar)+','+cast(@HealthSubFacility_Code  as varchar)+' ,'+cast(@Village_Code  as varchar)+'        
 ,'''+CAST(@Financial_Yr as varchar)+''' ,'+CAST(@Financial_Year AS VARCHAR)+' ,'+CAST(@Register_srno AS VARCHAR(9))+' ,'+CAST(@Registration_no AS VARCHAR(12))+',        
'''+CAST(@Registration_Date AS VARCHAR)+''' ,'''+CAST(@Name_Child AS VARCHAR(99))+''' ,'''+CAST(@Gender  AS VARCHAR(1))+''' ,'''+cast(@Birth_Date as varchar)+''' ,'''+cast(@Birth_place AS varchar)+''' ,'+cast(@Mother_Reg_no AS  varchar)+' ,'''+      
cast(@Name_Mother AS VARCHAR )+''' ,'''+CAST(@Landline_no AS VARCHAR)+''' ,        
'''+CAST(@Mobile_no AS VARCHAR)+''' ,'''+CAST(@Address AS VARCHAR)+''' ,'+CAST(@Religion_code AS VARCHAR)+' ,'+CAST(@Caste AS VARCHAR)+' ,'+CAST(@Identity_type AS VARCHAR)+' ,'''+CAST(@Identity_number AS VARCHAR)+'''        
 ,'+CAST(@ANM_ID AS VARCHAR(6))+','+CAST(@ASHA_ID AS VARCHAR(6))+' ,'''+CAST(@IP_address AS VARCHAR(50))+''' ,'+CAST(@ANM_ID AS VARCHAR(6))+' ,getdate(),        
'''+CAST(@Name_Father AS VARCHAR)+''' ,'''+CAST(@Mobile_Relates_To  AS VARCHAR)+''' ,'+cast(@Weight  as varchar)+'  ,'+cast(@Mobile_ID  as varchar)+'        
,'+CAST(@DeliveryLocationID as varchar)+','''+CAST(@Delivery_Location as varchar)+'''        
,'+CAST(@Child_EID_numeric as varchar)+',        
        
'''+CAST(@Child_EIDT AS VARCHAR)+''',        
'+CAST(@Child_Aadhar_No_numeric as varchar)+',        
        
'''+CAST(@Birth_Certificate_No AS VARCHAR)+''',        
'+CAST(@Status as varchar)+',        
'+CAST(@Case_no as varchar)+'        
        
)        
'        
--PRINT(@S)
set @msg=''+cast(@Mobile_ID as varchar)+''             
EXEC(@S)        
   
END  
else  
begin  
--set @msg='State Not Exist in Database'   
set @msg='ERROR'  
end 

--PRINT(@msg)   
end  
IF (@@ERROR <> 0)
BEGIN
	set @msg='0'
     RAISERROR ('ERROR',16,-1)
     ROLLBACK TRANSACTION
END

