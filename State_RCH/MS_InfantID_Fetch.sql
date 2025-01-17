USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_InfantID_Fetch]    Script Date: 09/26/2024 15:51:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*    
exec MS_InfantID_Fetch 30,130000001226,1,420    
exec MS_InfantID_Fetch 92,130000000078,1,1234      
*/    
    
    
ALTER procedure [dbo].[MS_InfantID_Fetch]    
(@State_Code int,    
@Registration_no bigint ,    
@Case_no int,    
@Mobile_ID bigint=0)    
as    
begin    
    
    
declare @s1 varchar(max),@db varchar(50)    
    
if(@State_Code <=9)    
begin    
set @db='RCH_0'+cast(@State_Code as varchar)    
end    
    
else    
begin    
set @db='RCH_'+cast(@State_Code as varchar)    
end    
   
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
set @s1='    
select cast(Infant_Id as varchar)+'' ( ''+cast(Infant_No as varchar)+'' )''+'' ( ''+ Infant_Name  +'' )''  from '+cast(@db as varchar)+'.dbo.t_mother_infant   
where Mobile_ID='+cast(@Mobile_ID  as varchar)+' and Case_no='+cast(@Case_no  as varchar)+' and Registration_no='+cast(@Registration_no as varchar(12))+'     
'    
--print(@s1)    
exec(@s1)

end
else
begin
select 'DB' as ID,'' as Contact_No
end     
end
