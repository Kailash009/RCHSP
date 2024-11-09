USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[isAdminOrUser]    Script Date: 09/26/2024 14:25:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[isAdminOrUser] 
	@UserID nvarchar(20),
	@iflag bit out

AS
BEGIN

if exists
	(select * from [ComAdmin_27].[dbo].[UserDetails] where ParentOffice ='0'and LocationField ='StateID' and userid =@UserID)
	set @iflag =1

else
	
	set @iflag =0
END





