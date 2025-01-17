USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[Log_Activity]    Script Date: 09/26/2024 14:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*
Log_Activity 1,0
*/

ALTER PROC [dbo].[Log_Activity]
(@UserID int=0,
@AppID int=0,
@User_Name varchar(50)=null)
as 
begin 

Declare @S as varchar(max)=null
if (@AppID=1)
Begin
set @S='select A.UserID,B.User_Name,(A.Datetime) as LastLoginDate,Right(A.Datetime,7) as LastLoginTime,
A.ActionPerformed,A.Details,A.IP,C.State_Name ,C.District_Name ,C.Taluka_Name as Taluka_Name,C.Block_Name ,C.PHC_Name ,C.SubCenter_Nmae from(
(SELECT UserID,ActionPerformed,Details,IP,Datetime 
FROM User_Log_'+CAST(SubString(DATENAME(month,getdate()),1,3)as varchar)+'_'+CAST(year(getdate()) as varchar)+') as A
left outer join
(select UserID,User_Name,LastLogin from [User_Master]) as B on B.UserID=A.UserID 
left outer join
(SELECT dbo.User_Master.UserID,dbo.Health_SubCentre.Name_E AS SubCenter_Nmae, dbo.All_Taluka.Name_E AS Taluka_Name, dbo.Health_PHC.Name_E AS PHC_Name, 
             dbo.Health_Block.Name_E AS Block_Name, dbo.State.Name_E AS State_Name, dbo.District.Name_E AS District_Name
FROM         dbo.User_Master left outer JOIN
             dbo.District ON dbo.User_Master.District_ID = dbo.District.DCode left outer JOIN
             dbo.State ON dbo.User_Master.StateID = dbo.State.StateID left outer JOIN
             dbo.Health_Block ON dbo.User_Master.Healthblock_ID = dbo.Health_Block.BID left outer JOIN
             dbo.Health_PHC ON dbo.User_Master.PHC_ID = dbo.Health_PHC.PID left outer JOIN
             dbo.All_Taluka ON dbo.User_Master.Taluka_ID = dbo.All_Taluka.TCode left outer JOIN
             dbo.Health_SubCentre ON dbo.User_Master.SubCentre_ID = dbo.Health_SubCentre.SID) C on A.UserID=C.UserID
) where A.UserID='+cast(@UserID as varchar)+' and a.Details like ''%CM%'' order by A.datetime desc'
end
else if(@AppID =2)
begin
set @S='select A.UserID,B.User_Name,(A.Datetime) as LastLoginDate,Right(A.Datetime,7) as LastLoginTime,
A.ActionPerformed,A.Details,A.IP,C.State_Name ,C.District_Name ,C.Taluka_Name as Taluka_Name,C.Block_Name ,C.PHC_Name ,C.SubCenter_Nmae from(
(SELECT UserID,ActionPerformed,Details,IP,datetime 
FROM User_Log_'+CAST(SubString(DATENAME(month,getdate()),1,3)as varchar)+'_'+CAST(year(getdate()) as varchar)+') as A
left outer join
(select UserID,User_Name,LastLogin from [User_Master]) as B on B.UserID=A.UserID 
left outer join
(SELECT dbo.User_Master.UserID,dbo.Health_SubCentre.Name_E AS SubCenter_Nmae, dbo.All_Taluka.Name_E AS Taluka_Name, dbo.Health_PHC.Name_E AS PHC_Name, 
             dbo.Health_Block.Name_E AS Block_Name, dbo.State.Name_E AS State_Name, dbo.District.Name_E AS District_Name
FROM         dbo.User_Master left outer JOIN
             dbo.District ON dbo.User_Master.District_ID = dbo.District.DCode left outer JOIN
             dbo.State ON dbo.User_Master.StateID = dbo.State.StateID left outer JOIN
             dbo.Health_Block ON dbo.User_Master.Healthblock_ID = dbo.Health_Block.BID left outer JOIN
             dbo.Health_PHC ON dbo.User_Master.PHC_ID = dbo.Health_PHC.PID left outer JOIN
             dbo.All_Taluka ON dbo.User_Master.Taluka_ID = dbo.All_Taluka.TCode left outer JOIN
             dbo.Health_SubCentre ON dbo.User_Master.SubCentre_ID = dbo.Health_SubCentre.SID) C on A.UserID=C.UserID
) where A.UserID='+cast(@UserID as varchar)+' and a.Details like ''%MCH%'' order by A.datetime desc'
end
else if(@AppID =0 and @User_Name<>'0')
begin
set @S='select A.UserID,B.User_Name,(A.Datetime) as LastLoginDate,Right(A.Datetime,7) as LastLoginTime,
A.ActionPerformed,A.Details,A.IP,C.State_Name ,C.District_Name ,C.Taluka_Name as Taluka_Name,C.Block_Name ,C.PHC_Name ,C.SubCenter_Nmae from(
(SELECT UserID,ActionPerformed,Details,IP,datetime 
FROM User_Log_'+CAST(SubString(DATENAME(month,getdate()),1,3)as varchar)+'_'+CAST(year(getdate()) as varchar)+') as A
left outer join
(select UserID,User_Name,LastLogin from [User_Master]) as B on B.UserID=A.UserID 
left outer join
(SELECT dbo.User_Master.UserID,dbo.Health_SubCentre.Name_E AS SubCenter_Nmae, dbo.All_Taluka.Name_E AS Taluka_Name, dbo.Health_PHC.Name_E AS PHC_Name, 
             dbo.Health_Block.Name_E AS Block_Name, dbo.State.Name_E AS State_Name, dbo.District.Name_E AS District_Name
FROM         dbo.User_Master left outer JOIN
             dbo.District ON dbo.User_Master.District_ID = dbo.District.DCode left outer JOIN
             dbo.State ON dbo.User_Master.StateID = dbo.State.StateID left outer JOIN
             dbo.Health_Block ON dbo.User_Master.Healthblock_ID = dbo.Health_Block.BID left outer JOIN
             dbo.Health_PHC ON dbo.User_Master.PHC_ID = dbo.Health_PHC.PID left outer JOIN
             dbo.All_Taluka ON dbo.User_Master.Taluka_ID = dbo.All_Taluka.TCode left outer JOIN
             dbo.Health_SubCentre ON dbo.User_Master.SubCentre_ID = dbo.Health_SubCentre.SID) C on A.UserID=C.UserID
) where B.User_Name='''+cast(@User_Name as varchar)+'''  order by A.datetime desc'
end
else if(@AppID =0 and @User_Name='0')
begin
set @S='select A.UserID,B.User_Name,(A.Datetime) as LastLoginDate,Right(A.Datetime,7) as LastLoginTime,
A.ActionPerformed,A.Details,A.IP,C.State_Name ,C.District_Name ,C.Taluka_Name as Taluka_Name,C.Block_Name ,C.PHC_Name ,C.SubCenter_Nmae from(
(SELECT UserID,ActionPerformed,Details,IP,datetime 
FROM User_Log_'+CAST(SubString(DATENAME(month,getdate()),1,3)as varchar)+'_'+CAST(year(getdate()) as varchar)+') as A
left outer join
(select UserID,User_Name,LastLogin from [User_Master]) as B on B.UserID=A.UserID 
left outer join
(SELECT dbo.User_Master.UserID,dbo.Health_SubCentre.Name_E AS SubCenter_Nmae, dbo.All_Taluka.Name_E AS Taluka_Name, dbo.Health_PHC.Name_E AS PHC_Name, 
             dbo.Health_Block.Name_E AS Block_Name, dbo.State.Name_E AS State_Name, dbo.District.Name_E AS District_Name
FROM         dbo.User_Master left outer JOIN
             dbo.District ON dbo.User_Master.District_ID = dbo.District.DCode left outer JOIN
             dbo.State ON dbo.User_Master.StateID = dbo.State.StateID left outer JOIN
             dbo.Health_Block ON dbo.User_Master.Healthblock_ID = dbo.Health_Block.BID left outer JOIN
             dbo.Health_PHC ON dbo.User_Master.PHC_ID = dbo.Health_PHC.PID left outer JOIN
             dbo.All_Taluka ON dbo.User_Master.Taluka_ID = dbo.All_Taluka.TCode left outer JOIN
             dbo.Health_SubCentre ON dbo.User_Master.SubCentre_ID = dbo.Health_SubCentre.SID) C on A.UserID=C.UserID
) where A.UserID='+cast(@UserID as varchar)+'  order by A.datetime desc'
end

exec(@S)
--print(@S)
end











