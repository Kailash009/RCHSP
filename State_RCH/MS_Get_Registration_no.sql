USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Registration_no]    Script Date: 09/26/2024 15:49:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*    
    
EXEC MS_Get_Registration_no 1,27,'EC'    
EXEC MS_Get_Registration_no 12281,27,'Child'    
EXEC MS_Get_Registration_no 4,30,'EC'    
*/    
ALTER procedure [dbo].[MS_Get_Registration_no]    
(@Mobile_ID bigint,@State_ID INT,@Type varchar(10))    
AS    
BEGIN     
    
DECLARE @DB VARCHAR(MAX),@S VARCHAR(MAX)    
IF(@State_ID<=9)    
BEGIN    
SET @DB='RCH_0'+CAST(@State_ID AS VARCHAR)    
END    
ELSE    
BEGIN    
SET @DB='RCH_'+CAST(@State_ID AS VARCHAR)    
END    
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
    
SET @S='    
if('''+CAST(@Type AS VARCHAR)+''' =''EC'')    
BEGIN    
SELECT distinct Registration_no,Mobile_ID FROM '+CAST(@DB AS VARCHAR)+'.dbo.MS_eligibleCouples    
WHERE Mobile_ID='+CAST(@Mobile_ID as varchar)+'    
END    
    
ELSE if('''+CAST(@Type AS VARCHAR)+''' =''Child'')    
begin    
SELECT distinct Registration_no,Mobile_ID FROM '+CAST(@DB AS VARCHAR)+'.dbo.MS_children_registration    
WHERE Mobile_ID='+CAST(@Mobile_ID as varchar)+'    
end    
'    
--PRINT(@S)    
EXEC(@S)  
END
else
begin
select 'DB' as ID,'' as Contact_No
end  
    
   
    
END 
