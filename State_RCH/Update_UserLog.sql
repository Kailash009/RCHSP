USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Update_UserLog]    Script Date: 09/26/2024 14:53:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER PROCEDURE [dbo].[Update_UserLog] 
	@ActionUserID int,
	@UserID int,
	@WebPage varchar(50),
	@ActionPerformed varchar(50),
	@Details varchar(max),
	@IP varchar(25),
	@datetime datetime
AS
BEGIN
	declare @S nvarchar(2500)
	declare @DName varchar(25)
	set @DName='User_Log_'+left(datename(month,getdate()),3)+'_'+cast(year(getdate()) as varchar)
	set @S='update '+@DName+' set Details='''+cast(@Details as varchar(max))+''' where 
	UserID='+cast(@UserID as varchar)+' 
	and Datetime='''+cast(@datetime as varchar)+''' 
	and IP='''+@IP+'''
    and details like ''%CM/OfficeSelection.aspx%''
    and datetime>DATEADD (MINUTE ,-5,GETDATE())'
	--print (@S)
	exec sp_executesql @S
END

--select * from User_Log_May_2012 where UserID=4 and CONVERT(varchar(10), datetime,103) =  CONVERT(varchar(10), GETDATE(),103) order by datetime desc

 --update User_Log_May_2012 set Details=http://10.1.15.148/CM/OfficeSe where UserID=4 and Datetime='May 24 2012  4:25PM'






