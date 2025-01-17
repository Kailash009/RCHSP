USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetECResitration_Count]    Script Date: 09/26/2024 14:04:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[MS_GetECResitration_Count] 11953,28,16,'R',236,'0717',2382,13811,20452  
*/
ALTER proc [dbo].[MS_GetECResitration_Count]
(
@ANM_ID int,
@State_Code int,
@District_Code int,
@Rural_Urban char(1),
@HealthBlock_Code int,
@Taluka_Code varchar(6),
@HealthFacility_Code int,
@HealthSubFacility_Code int,
@Village_Code int,
@Financial_Year int=0
)
as
 begin
declare @s varchar(max),@db varchar(50)    
if(@State_Code <=9)    
begin    
set @db='RCH_0'+CAST(@State_Code AS VARCHAR)    
end    
else     
begin    
set @db='RCH_'+CAST(@State_Code AS VARCHAR)    
end    
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
     
SET @s='select COUNT(Registration_no) as Total_EC_Count from '+cast(@db as varchar)+'.dbo.t_eligibleCouples
 WHERE State_Code= '+CAST (@State_Code as varchar)+'
 and HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'
and Village_Code ='+CAST (@Village_Code as varchar)+''



EXEC(@s)    
end    

else
begin
select 'DB' as ID,'' as Contact_No
end  
    
end
