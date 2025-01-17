USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Last_Mobile_ID]    Script Date: 09/26/2024 15:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*    
EXEC MS_Get_Last_Mobile_ID 1228,27,'EC'    
EXEC MS_Get_Last_Mobile_ID 1228,27,'Child'    
EXEC MS_Get_Last_Mobile_ID 16,27    
    
*/    
    
ALTER procedure [dbo].[MS_Get_Last_Mobile_ID]    
(@ANM_ID int  ,@State_Code int ,@type varchar(10) )    
AS    
BEGIN    
    
declare @s varchar(max),@db varchar(30)    
    
IF(@State_Code<=9)    
BEGIN    
set @db='RCH_0'+CAST(@State_Code AS VARCHAR)    
END    
ELSE    
BEGIN    
set @db='RCH_'+CAST(@State_Code AS VARCHAR)    
END    
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
    
SET @s='    
if('''+CAST(@type AS VARCHAR)+'''=''EC'')    
BEGIN    
select ISNULL(MAX(Mobile_ID),0) as Last_Mobile_ID  from '+CAST(@db AS VARCHAR)+'.dbo.MS_eligibleCouples     
where ANM_ID='+CAST(@ANM_ID AS VARCHAR)+'    
END    
ELSE IF('''+CAST(@type AS VARCHAR)+'''=''Child'')    
BEGIN    
select ISNULL(MAX(Mobile_ID),0) as Last_Mobile_ID  from '+CAST(@db AS VARCHAR)+'.dbo.MS_children_registration     
where ANM_ID='+CAST(@ANM_ID AS VARCHAR)+'    END    '    
--PRINT(@S)    
EXEC (@S)    
END 

else
begin
select 'DB' as ID,'' as Contact_No
end  
    
END 
   
    
--SELECT * FROM RCH_27.dbo.MS_eligible_couple_tracking      
    
--select * from RCH_27.dbo.MS_eligibleCouples 
