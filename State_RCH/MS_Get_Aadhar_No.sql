USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Aadhar_No]    Script Date: 09/26/2024 15:50:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
    
    
    
/*    
    
MS_Get_Aadhar_No 245,99    
    
*/    
ALTER procedure [dbo].[MS_Get_Aadhar_No]  
( @ANM_ID int,  @State_Code int  )    
    
as    
    
begin    
declare @s varchar(max),@db varchar(30)    
    
if(@State_Code<=9)    
begin    
set @db ='RCH_0'+CAST(@State_Code AS VARCHAR)    
end    
else    
begin    
set @db ='RCH_'+CAST(@State_Code AS VARCHAR)    
end   

IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
    
SET @s='    
    
select isnull(Aadhar_No,0) as Aadhar_No from '+@db+'.dbo.t_Ground_Staff     
where ID='+CAST(@ANM_ID as varchar)+'    
'    
exec(@s)    
   end  
    
  else
begin
select 'DB' as ID,'' as Contact_No
end  
    
END      
    
    
    
    
    
  
