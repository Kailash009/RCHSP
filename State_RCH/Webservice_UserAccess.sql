USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[Webservice_UserAccess]    Script Date: 09/26/2024 15:49:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Webservice_UserAccess]
(@Access_Given int=0
)
as
begin

if(@Access_Given=1)
Update  UserMaster_Webservices set Status =1 where id  in ('mcts-AP')
else
Update  UserMaster_Webservices set Status =0 where id  in ('mcts-AP')

end
