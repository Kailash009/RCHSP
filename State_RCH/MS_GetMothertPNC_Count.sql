USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetMothertPNC_Count]    Script Date: 09/26/2024 15:51:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
[MS_GetMothertPNC_Count] 11953,28,16,'R',236,'0717',2382,13811,20452  
*/
ALTER proc [dbo].[MS_GetMothertPNC_Count]
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
Declare @s varchar(max),@db varchar(50)    
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
     
SET @s='select COUNT(Registration_no) as Total_MOTHERPNC_Count from '+cast(@db as varchar)+'.dbo.t_mother_pnc
WHERE State_Code= '+CAST (@State_Code as varchar)+'    
and District_Code= '+CAST (@District_Code as varchar)+'    
and Rural_Urban ='''+CAST (@Rural_Urban as varchar)+'''    
and HealthBlock_Code ='+CAST (@HealthBlock_Code as varchar)+'    
and Taluka_Code='''+CAST (@Taluka_Code as varchar)+'''    

and HealthFacility_Code= '+CAST (@HealthFacility_Code as varchar)+'    
and HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'    
--and (Village_Code ='+CAST (@Village_Code as varchar)+'or ' +CAST (@Village_Code as varchar)+ '=0)
'
EXEC(@s)    
end    

else
begin
select 'DB' as ID,'' as Contact_No
end  
    
end

