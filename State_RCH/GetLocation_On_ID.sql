USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[GetLocation_On_ID]    Script Date: 09/26/2024 12:05:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





  
ALTER PROCEDURE [dbo].[GetLocation_On_ID]  
(@Type as nvarchar(30),  
@SearchText as nvarchar(30)  
)  
as   
Begin  
  
set nocount on;  
declare @s as Varchar(8000)=null  
  
If(SUBSTRING(@Type,1,1)=1)--PHC  
Begin  
set @s='Select  top 20 PID as ID,Name_E as Name  
from Health_PHC   
where  
Name_E like '''+cast(@SearchText as nvarchar(30))+'%'''  
  
If(SUBSTRING(@Type,3,1)=1)--District  
set @s=@s + ' AND Dcode='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=2)--HB  
set @s=@s + ' AND BID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
end  
  
  
  
If(SUBSTRING(@Type,1,1)=2)--SubCentre  
Begin  
set @s='Select  top 20 SID as ID,a.Name_E as Name  
from Health_SubCentre a inner join  
Health_PHC b on a.PID=b.PID  
where   
a.Name_E like '''+cast(@SearchText as nvarchar(30))+'%'''  
If(SUBSTRING(@Type,3,1)=1)  
set @s=@s + ' AND a.Dcode='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=2)  
set @s=@s + ' AND b.BID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=3)  
set @s=@s + ' AND a.PID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
end  
  
  
  
  
If(SUBSTRING(@Type,1,1)=3)--Village  
Begin  
set @s='Select  top 20 a.VCode as ID ,a.Name_E as Name  
from village a  
left outer join Health_SC_Village b on a.VCode=b.VCode  
left outer join Health_SubCentre c on b.SID=c.SID  
left outer join Health_PHC d on c.PID=d.PID  
where a.Name_E like '''+cast(@SearchText as nvarchar(30))+'%'''  
If(SUBSTRING(@Type,3,1)=1)  
set @s=@s + ' AND a.Dcode='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=2)  
set @s=@s + ' AND d.BID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=3)  
set @s=@s + ' AND c.PID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
  
If (SUBSTRING(@Type,3,1)=4)  
set @s=@s + ' AND b.SID='+CAST(SUBSTRING(@Type,5,LEN(@Type)) as varchar)+''  
end  
  
exec(@s)  
print(@s)  
end







