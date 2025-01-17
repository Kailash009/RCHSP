USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Hierarchy]    Script Date: 09/26/2024 15:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[MS_Get_Hierarchy] 23,0,0,2
[MS_Get_Hierarchy] 23,1,0,3
[MS_Get_Hierarchy] 23,1,0,4


*/
ALTER Procedure [dbo].[MS_Get_Hierarchy]
(@State_Code as int=0
,@District_Code as int=0
,@SubDistrict_Code as int=0
,@Mode_ID as int=0
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

IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @db ))  
begin      
if(@Mode_ID=1)--National
begin
set @s='select distinct State_ID as StateCode,State_Name as StateName
from [RCH_National_Level].[dbo].[State_Master] where State_ID < 37 order by State_ID'
end
else if(@Mode_ID=2)--District
begin
set @s='select StateID as StateCode,DCode as DistrictCode,Name_G as DistrictName
from '+cast(@db as varchar)+'.dbo.District 
where StateId='+CAST (@State_Code as varchar)+''
end
else if(@Mode_ID=3)--Taluka
begin
set @s='select (c.StateID)as StateCode,
(a.DCode) as DistrictCode,
(a.TCode) as TalukaCode,
(a.Name_E) as TalukaName
from '+cast(@db as varchar)+'.dbo.All_Taluka a 
inner join '+cast(@db as varchar)+'.dbo.District b on a.DCode=b.DCode
inner join '+cast(@db as varchar)+'.dbo.State c on b.StateID=c.StateID
where (a.DCode='+CAST (@District_Code as varchar)+' or '+CAST(@District_Code as varchar)+'=0)
and c.StateID='+CAST (@State_Code as varchar)+''
end
else if(@Mode_ID=4)--Vilage
begin
set @s='select b.StateID as StateCode,
a.DCode as DistrictCode,
a.TCode as SubDistrict_Code, 
a.VCode as villegeCode,
a.Name_E as VillegeName
from '+cast(@db as varchar)+'.dbo.Cen_Village a 
inner join '+cast(@db as varchar)+'.dbo.District b on a.DCode=b.DCode
where a.TCode=('''+CAST (@SubDistrict_Code as varchar)+''' or '''+CAST(@SubDistrict_Code as VARCHAR)+'''=''0'')
and  a.DCode='+CAST (@District_Code as varchar)+'
and  b.StateID='+CAST (@State_Code as varchar)+''
end
exec(@s)
end
else
begin
set @s='select 0 as statecode'


end          
end
