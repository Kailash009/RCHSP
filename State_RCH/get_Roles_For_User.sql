USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[get_Roles_For_User]    Script Date: 09/26/2024 12:01:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*  
get_Roles_For_User '1,2'  
*/  
  
ALTER PROCEDURE [dbo].[get_Roles_For_User]  
(@Roles nvarchar(30))  
as  
Begin  
  
Declare @S as varchar(500)=null;  
set @S='  
select Distinct R.RName as Role_Name  from User_AppRole as a   
inner join National_Level.dbo.App_Roles as R on a.RoleID=R.RID where RID  in ('+@Roles+') '  
exec(@S)  
--print(@S)  
end





