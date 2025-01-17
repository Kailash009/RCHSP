USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_AdvanceSearch]    Script Date: 09/26/2024 12:13:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*
MS_AdvanceSearch 128000055603,'','','',0,'',0,28,0
MS_AdvanceSearch 0,'Ravuri Madhuvani','China Swamy','9989109070',0,'',0,28,123
*/
ALTER procedure [dbo].[MS_AdvanceSearch]
(@Registration_No as bigint=0,
@Name as nvarchar(99)='',
@HusbandName as nvarchar(99)='',
@Mobile_No as varchar(10)='',
@Aadhaar_No as numeric(12)=0,
@Account_No as varchar(20)='',
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
SET @s='select top 1 a.Registration_no,a.Name_wife as Name,a.[Address] as Benificiary_Address,a.Mobile_no as MobileNo,a.Aadhar_No as Benificiary_UID
 from t_eligibleCouples a
inner join t_page_tracking b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
where (a.Registration_no='+cast(@Registration_No as varchar(12))+' or '+cast(@Registration_No as varchar(12))+'=0)
and (a.Financial_Year='+cast(@YearID as varchar(4))+' or '+cast(@YearID as varchar(4))+'=0)
and (a.Name_wife='''+cast(@Name as nvarchar(99))+''' or '''+cast(@Name as nvarchar(99))+'''='''')
and (a.Name_husband='''+cast(@HusbandName as nvarchar(99))+''' or '''+cast(@HusbandName as nvarchar(99))+'''='''')
and (a.Mobile_No='''+cast(@Mobile_No as varchar(10))+''' or '''+cast(@Mobile_No as varchar(10))+'''='''')
and (a.Aadhar_No='+cast(@Aadhaar_No as varchar(12))+' or '+cast(@Aadhaar_No as varchar(12))+'=0)
and (a.PW_AccNo='''+cast(@Account_No as varchar(20))+''' or '''+cast(@Account_No as varchar(20))+'''='''')

order by a.case_no desc'

EXEC(@s)
--print(@S)      
end      
  
else  
begin  
select 'DB' as ID,'' as Contact_No  
end    
      
END     





