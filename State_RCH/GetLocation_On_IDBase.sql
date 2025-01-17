USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[GetLocation_On_IDBase]    Script Date: 09/26/2024 12:05:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





 
ALTER PROCEDURE [dbo].[GetLocation_On_IDBase]  
(@Type as int=0,  
@ID as nvarchar(10)='0'   
)  
as   
Begin  
declare @s as Varchar(8000)=null  
  
  
  
  
IF(@Type=1)--PHC  
Begin  
Select   
  
a.DCode as ID  
,a.TCode as ID1  
,a.BID as ID2  
,a.PID as ID3  
,0 as ID4  
,0 as ID5  
  
  
from Health_PHC a  
inner join Health_Block b on a.BID =b.BID  
inner join Taluka  c on a.Tcode=c.TCode   
inner join District d on a.DCode =d.DCode  where (a.PID=@ID or @ID=0)  
  
end  
IF(@Type=2)--SubCentre  
Begin  
Select   
  
 a.DCode as ID  
, a.TCode as ID1  
, b.BID as ID2  
, a.PID as ID3  
,a.SID as ID4  
,0 as ID5  
from Health_SubCentre a  
inner join Health_PHC b on a.PID =b.PID  
inner join Health_Block c on b.BID =c.BID  
inner join Taluka  d on a.Tcode=d.TCode    
inner join District e on a.DCode =e.DCode  where  (a.SID=@ID or @ID=0)  
exec(@s)  
end  
  
IF(@Type=3)--Village  
Begin  
  
select   
  a.DCode as ID  
 ,a.TCode as ID1  
 ,d.BID as ID2  
 ,c.PID as ID3  
 ,b.SID as ID4  
 ,a.VCode as ID5  
from village a  
left outer join Health_SC_Village b on a.VCode =b.VCode   
left outer join Health_SubCentre c on b.SID =c.SID   
left outer join Health_PHC d on c.PID =d.PID   
left outer join Health_Block e on d.BID =e.BID   
left outer join Taluka f on a.TCode =f.TCode   
left outer join District g on a.DCode =g.DCode where (a.VCode=@ID or @ID=0)  
end  
end




