USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Automated_SMS]    Script Date: 09/26/2024 12:18:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
Schedule_Automated_SMS 5,1  
*/  
ALTER procedure [dbo].[Schedule_Automated_SMS]  
(  
@Level_ID as int=0  
,@ServiceID as int=0  
)  
as  
Begin  
SET NOCOUNT ON  
  
  
if(@ServiceID=1)--Total Count Service  
begin  
--1007160498762305465
insert into SMS.dbo.SMS_Sender_Detail_Manual(Template_Id,Mobile_No,Send_SMS_Detail,State_Code,District_Code,HealthBlock_Code,PHC_Code,SubCentre_Code,Sms_Group,Sms_Active,AsOnDate,RegID,IsUnicode,IsViaMobNo,IsBulk,SMS_Code)  
select '',A.Contact_No,A.SMSDetail,A.State_Code,A.District_Code,A.HealthBlock_Code,A.HealthFacility_Code,A.HealthSubFacility_Code,B.Group_Name,1 as SMS_Active  
,GETDATE(),A.Contact_No,0,0,1,'TC_SCH' from  
(  
Select Contact_No,dbo.SMS_SDBPS_TC(@Level_ID-1,District_Code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code) as SMSDetail,State_Code,District_Code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code   
from t_SMS_Hierachy_Mapping where is_active=1 and TYPE_ID=@Level_ID  
) A  
inner join  
(select StateID,GroupName as Group_Name from State ) B on A.State_Code=B.StateID  
where A.SMSDetail is not null  
END  
  
end

