USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetPassword]    Script Date: 09/26/2024 12:52:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
EXEC MS_GetPassword 'UNICEF-MCTS','UNICEF-MCTS@123','5698553435641244'  
EXEC MS_GetPassword 'UNICEF-MS','UNICEF-MCTS@123','569855343564'  
EXEC MS_GetPassword 'UNICEF-MS','UNICEF-MCTS@123','569855343564'  
  
*/  
  
  
ALTER procedure [dbo].[MS_GetPassword]  
(@username varchar(30),@password varchar(30),@EMICODE varchar(30))  
as  
begin  
  
IF EXISTS(SELECT * FROM MS_UserMaster_Table WHERE username=@username AND password=@password)  
BEGIN  
if not exists(SELECT * FROM MS_GetPassword_Table WHERE username=@username AND password=@password and EMICODE=@EMICODE)  
begin  
insert into  MS_GetPassword_Table([username]  
      ,[password]  
      ,[Token_ID]  
      ,[Created_Date]  
      ,[EMICODE])  
values(@username,@password, CONVERT(numeric,  
 (SELECT REPLACE (  
 CONVERT(VARCHAR(8), GETDATE(),112) + '' + CONVERT(VARCHAR(8), GETDATE(), 108)  
 ,':',''))  
)  
 ,GETDATE(),@EMICODE)  
  
  
  
--UPDATE MS_GetPassword_Max_Table  
--SET MAX_Tid=Tid , EXEC_DATE=getdate()  
--,EMICODE=@EMICODE  
--where EMICODE=@EMICODE    
  
select  Tid      ,[Token_ID]   from MS_GetPassword_Table  
where username=@username AND password=@password and EMICODE=@EMICODE  
  
select '00000' as  msg   
  
  
end  
  
else  
begin  

select 'EMI Already Registered' as msg  
end  
  
END  
  
else  
begin  
select 'NotRegistered' as msg  
 
end  
  
  
end
