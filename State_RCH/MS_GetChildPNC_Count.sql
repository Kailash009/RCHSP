USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetChildPNC_Count]    Script Date: 09/26/2024 15:49:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
[MS_GetChildPNC_Count] 11953,28,16,'R',236,'0717',2382,13811,20452  
*/
ALTER proc [dbo].[MS_GetChildPNC_Count]
(
@ANM_ID int=0,
@State_Code int=0,
@District_Code int=0,
@Rural_Urban char(1)='R',
@HealthBlock_Code int=0,
@Taluka_Code varchar(6)='0',
@HealthFacility_Code int=0,
@HealthSubFacility_Code int=0,
@Village_Code int=0,
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
     
SET @s=' 
select COUNT(Registration_no) as Total_PNC_Count from '+cast(@db as varchar)+'.dbo.t_child_pnc
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
--print(@s) 
end    

else
begin
select 'DB' as ID,'' as Contact_No
end  
    
END  
