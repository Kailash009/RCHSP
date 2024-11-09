USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[isAppManager]    Script Date: 09/26/2024 14:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








ALTER PROCEDURE [dbo].[isAppManager] 
	-- Add the parameters for the stored procedure here
	@UserID int,
	@AppID int,
	@flg bit out
AS
BEGIN	
	if exists (select * from User_Apps where appid=@AppID and UserID=@UserID)		
		set @flg=1
	else
		set @flg=0
END








