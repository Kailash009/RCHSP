USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_All_Village_In_SubDistrict]    Script Date: 09/26/2024 15:49:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
exec MS_All_Village_In_SubDistrict 31,1,0002
exec MS_All_Village_In_SubDistrict 31,1,0001
exec MS_All_Village_In_SubDistrict 21,1,0001

**/


ALTER Procedure [dbo].[MS_All_Village_In_SubDistrict]
@State_id int,
@district_Code int,
@SubDistrict_id varchar(6)
as 
begin

SET NOCOUNT ON 
declare @s varchar(max),@db varchar(50)     
if(@State_id <=9)      
begin      
set @db='RCH_0'+CAST(@State_id AS VARCHAR)      
end      
else       
begin      
set @db='RCH_'+CAST(@State_id AS VARCHAR)      
end   

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @db ))  
begin
set @s='select b.StateID as StateCode,
       a.DCode as DistrictCode,
       a.TCode as SubDistrict_Code, 
       a.VCode as villegeCode,
       a.Name_E as VillegeName,
       a.MDDS_Code as MDDS_Code
       from '+cast(@db as varchar)+'.dbo.Cen_Village a 
       inner join 
      '+cast(@db as varchar)+'.dbo.District b
       on a.DCode=b.DCode
       where a.TCode='+CAST (@SubDistrict_id as varchar)+' or '+CAST(@SubDistrict_id as VARCHAR)+'=0
       and  
       a.DCode='+CAST (@district_Code as varchar)+' or '+CAST(@district_Code as VARCHAR)+'=0
       and   
       b.StateID='+CAST (@State_id as varchar)+''
     
end
 
else
begin



set @s='select 0 as statecode'

end


--print(@s) 
exec(@s)    

			  

end
