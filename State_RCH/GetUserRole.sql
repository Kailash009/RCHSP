USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[GetUserRole]    Script Date: 09/26/2024 12:46:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER FUNCTION [dbo].[GetUserRole](@UserId int)
RETURNS VARCHAR(100) AS

BEGIN
   DECLARE @Role as varchar(100) = null

  select @Role=COALESCE( @Role+', ','')+  cast (RoleId as varchar)
	from User_AppRole   as s 
		where UserID = @UserId 
   RETURN @Role
END
