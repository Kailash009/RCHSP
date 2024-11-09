USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[insrtLog]    Script Date: 09/26/2024 14:25:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Shailesh Khanesha>
-- Create date: <02/04/2009>
-- Description:	<Store user activity log>
-- =============================================
ALTER PROCEDURE [dbo].[insrtLog] 
	@UserID int,
	@WebPage varchar(50),
	@ActionPerformed varchar(50),
	@Details varchar(250),
	@IP varchar(25),
	@datetime datetime
AS
BEGIN
	Insert into Adm_Log(UserID,WebPage,ActionPerformed,Details,IP,datetime)
	values(@UserID,@WebPage,@ActionPerformed,@Details,@IP,@datetime)
END







