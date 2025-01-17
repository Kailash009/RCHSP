USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[MS_AdvanceSearch_Child]    Script Date: 09/26/2024 14:42:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
MS_AdvanceSearch_Child  228000000582,'','','',0,'',0,0,28,123

MS_AdvanceSearch_Child  0,'','','',128005797235,'',0,0,28,123
*/
ALTER procedure [dbo].[MS_AdvanceSearch_Child]
(
@Registration_No as bigint=0,
@Name as nvarchar(99)='',
@FatherName as nvarchar(99)='',
@MotherName as nvarchar(99)='',
@MotherID as bigint=0,
@Mobile_No as varchar(10)='',
@Aadhaar_No as numeric(12)=0,
@YearID as int=0,
@State_Code as int=0,
@ANM_ID as int=0
)
as
begin
SET NOCOUNT ON 
declare @s varchar(max)      
IF EXISTS (SELECT * FROM UserMaster_Webservices where Status=1)  
begin   
       
SET @s='select a.Registration_no,a.Name_Child as Name,a.[Address] as Benificiary_Address,a.Mobile_no as MobileNo,a.Child_Aadhar_No as Benificiary_UID
,a.Mother_Reg_no as MotherID
 from dbo.t_children_registration a
where (a.Registration_no='+cast(@Registration_No as varchar(12))+' or '+cast(@Registration_No as varchar(12))+'=0)
and (a.Financial_Year='+cast(@YearID as varchar(4))+' or '+cast(@YearID as varchar(4))+'=0)
and (a.Mother_Reg_no='+cast(@MotherID as varchar(12))+' or '+cast(@MotherID as varchar(12))+'=0)
and (a.Name_Child='''+cast(@Name as nvarchar(99))+''' or '''+cast(@Name as nvarchar(99))+'''='''')
and (a.Name_Father='''+cast(@FatherName as nvarchar(99))+''' or '''+cast(@FatherName as nvarchar(99))+'''='''')
and (a.Mobile_No='''+cast(@Mobile_No as varchar(10))+''' or '''+cast(@Mobile_No as varchar(10))+'''='''')
and (a.Child_Aadhar_No='+cast(@Aadhaar_No as varchar(12))+' or '+cast(@Aadhaar_No as varchar(12))+'=0)
and (a.Name_Mother='''+cast(@MotherName as nvarchar(99))+''' or '''+cast(@MotherName as nvarchar(99))+'''='''')'

EXEC(@s)      
end      
  
else  
begin  
select 'DB' as ID,'' as Contact_No  
end    
      
END     



