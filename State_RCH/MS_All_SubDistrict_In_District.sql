USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_All_SubDistrict_In_District]    Script Date: 09/26/2024 15:50:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
exec [MS_All_SubDistrict_In_District] 31,1
exec [MS_All_SubDistrict_In_District] 21,1
**/
ALTER procedure [dbo].[MS_All_SubDistrict_In_District]
@State_Id int,
@District_Id int


as
begin
SET NOCOUNT ON 
declare @s varchar(max),@db varchar(50)      
if(@State_Id <=9)      
begin      
set @db='RCH_0'+CAST(@State_Id AS VARCHAR)      
end      
else       
begin      
set @db='RCH_'+CAST(@State_Id AS VARCHAR)      
end  

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @db ))  
begin
		set @s='select (c.StateID)as StateCode,
					   (a.DCode) as DistrictCode,
					   (a.TCode) as TalukaCode,
					   (a.Name_G) as TalukaName,
					   (a.MDDS_Code)as MDDS_Code 
					   from 
					   '+cast(@db as varchar)+'.dbo.All_Taluka a 
					   inner join   
					   '+cast(@db as varchar)+'.dbo.District b
					   on a.DCode=b.DCode
					   inner join
					    '+cast(@db as varchar)+'.dbo.State c
					   on b.StateID=c.StateID
					   where a.DCode='+CAST (@District_Id as varchar)+' or '+CAST(@District_Id as varchar)+'=0
					   and 
					   c.StateID='+CAST (@State_Id as varchar)+''
       
         
       
end

else	
begin
set @s='select 0 as StateCode' 
					    
end

--print(@s) 
exec(@s)   

end
