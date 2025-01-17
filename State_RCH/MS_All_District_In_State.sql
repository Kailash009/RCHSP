USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_All_District_In_State]    Script Date: 09/26/2024 12:13:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/**
exec [MS_All_District_In_State] 2,''
**/

ALTER Procedure [dbo].[MS_All_District_In_State]
(
 @State_Code int
 ,@TimeStamp DateTime = Null
 )
 as
begin


SET NOCOUNT ON 
declare @s varchar(max)      
IF EXISTS (SELECT * FROM UserMaster_Webservices where Status=1)  
begin  
set @s='select StateID as StateCode,DIST_CD as DistrictCode,DIST_NAME_ENG as DistrictName,MDDS_Code as MDDS_Code 
from dbo.TBL_District where StateId='+CAST (@State_Code as varchar)+''

if(@TimeStamp<>'' and @TimeStamp is not null)
begin
set @s=@s+' And (Created_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''' Or Modified_On  >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''')'
end
       


--print(@s) 
exec(@s) 
end  
end







