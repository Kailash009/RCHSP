USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Registered_Mother_ID]    Script Date: 09/26/2024 15:51:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*    
exec MS_Get_Registered_Mother_ID 27    
    
*/    
ALTER PROCEDURE [dbo].[MS_Get_Registered_Mother_ID]    
(@State_ID int)    
as    
begin    
    
declare @db varchar(50),@s varchar(max)    
if(@State_ID<=9)    
begin    
set @db ='RCH_0'+CAST(@State_ID AS VARCHAR)    
    
end    
ELSE    
begin    
set @db ='RCH_'+CAST(@State_ID AS VARCHAR)    
    
end   
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
 
SET @s=    
'    
select Mobile_ID,Registration_no  from '+CAST(@db AS VARCHAR)+'.dbo.t_eligible_couple_tracking     
where ((Pregnant = ''Y'' and Pregnant_test = ''P'')    
or (Pregnant = ''Y'' and Pregnant_test = ''D'')    
or (Pregnant = ''D'' and Pregnant_test = ''P''))    
and (Mobile_ID is not null and Mobile_ID<>0)    
'    
--PRINT(@s)    
exec(@s)    
   
   end
else
begin
select 'DB' as ID,'' as Contact_No
end    
    
end 
