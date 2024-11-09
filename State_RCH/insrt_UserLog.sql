USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[insrt_UserLog]    Script Date: 09/26/2024 14:25:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
/*    
    insrt_UserLog 1915,1915,'/RCHRPT/LogOut.aspx','Logout','Application:http://10.24.103.59/','10.24.103.59','09/01/2014 12:32:36'     
*/    
    
ALTER PROCEDURE [dbo].[insrt_UserLog]     
 @ActionUserID int,    
 @UserID int,    
 @WebPage varchar(50),    
 @ActionPerformed varchar(50),    
 @Details varchar(250),    
 @IP varchar(25),    
 @datetime datetime   
AS    
BEGIN    
 declare @S nvarchar(2500)    
 declare @DName varchar(25)    
 set @DName='User_Log_'+left(datename(month,getdate()),3)+'_'+cast(year(getdate()) as varchar)    
 set @S='Insert into '+@DName+' values('+cast(@ActionUserID as varchar)+','+cast(@UserID as varchar)+','''+@WebPage+''','''    
 --set @S=@S+@ActionPerformed+''','''+@Details+''','''+@IP+''','''+GETDATE()+''','''+GETDATE()+''','+cast(@UserID as varchar)+')'    
 set @S=@S+@ActionPerformed+''','''+@Details+''','''+@IP+''','''+cast(@datetime as varchar)+''','''+cast(@datetime as varchar)+''','+cast(@UserID as varchar)+')'  
 --print (@S)    
 exec sp_executesql @S    
   
   
  --set @S=@S+@ActionPerformed+''','''+@Details+''','''+@IP+''','''+cast(@datetime as varchar)+''','''+cast(@datetime as varchar)+''','+cast(@UserID as varchar)+')'  
  --set @S=@S+@ActionPerformed+''','''+@Details+''','''+@IP+''','''+cast(@datetime as varchar)+''')'  
   
END    
    
  --select * from User_log_Jan_2019


