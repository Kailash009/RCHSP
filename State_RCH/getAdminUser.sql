USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[getAdminUser]    Script Date: 09/26/2024 12:01:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[getAdminUser] 
	@UserID nvarchar(27),
	@UserAdmin nvarchar(2700) OUTPUT
	
AS
BEGIN
--declare @uid as int
declare @ofid as int
declare @prid as int
declare @PHCNAME1 as varchar(270)='' 
declare @PHCNAME as varchar(50)
declare @intflag as int
declare @LinkField as varchar(50)
Declare @Combined as varchar(270)
declare @odid1 as int
declare @odidlen as int
declare @phclen as int

--set @uid= (select userid from [User_Master]where User_Name ='dnic')
set @ofid =( select officeid from [ComAdmin_27].[dbo].[User_Map] where UserID= @UserID )
set @prid =(select parentid from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid )
print @ofid
while (@prid!=0)
begin 
set @prid =(select parentid from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid )

--set @PHCNAME =( select name_e from [ComAdmin_27].[dbo].[Office]  where OfficeID =@ofid)
set @odid1 = (select ODID  from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid )
set @odidlen=( select LEN(name_e)from [ComAdmin_27].[dbo].[Office_Definitions] where ODID =@odid1)
set @phclen =(select Len(name_e) from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid)
set @PHCNAME =( select substring(name_e, @odidlen+1,@phclen ) from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid)
set @LinkField =(select locationfield from [ComAdmin_27].[dbo].[Office] where OfficeID =@ofid)


Set @Combined =@LinkField+'-'+@PHCNAME
set @PHCNAME1 =@Combined +'/'+ @PHCNAME1

set @ofid=@prid

--print @PHCNAME 
set @UserAdmin= @PHCNAME1
end


--set @UserAdmin= @PHCNAME1

END




