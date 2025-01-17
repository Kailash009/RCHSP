USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[proc_Ground_transfer]    Script Date: 09/26/2024 12:17:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[proc_Ground_transfer]                                                  
(
@id int=0)                                                        
as                                                                   
begin                                                           
                                        
                                                                                                                           
declare @smsText nvarchar(max), @is_unicode as bit=0  ,@Sms_Group as varchar(50),                                      
@Template_Id as varchar(50),@Attached_TemplateId bit;               
                          

begin         
select @smsText= replace(a.SMS_Template_Text,'{HP_Name}','{AHSA_Name}'),@Template_Id=Text_Template_Id,@Attached_TemplateId=Attached_TemplateId,@Sms_Group=SMS_Template_Code  from SMS.dbo.SMS_Template_Text_master a where a.[SMS_Template_Code]='HP5' and Attached_TemplateID=1               
end  

             
if(ISNULL(@smsText,'')<>'')                                             
                    
begin                                         
                                   
Insert into SMS.dbo.SMS_Sender_Detail_Manual(Mobile_No,Send_SMS_Detail,State_Code,District_Code,HealthBlock_Code,PHC_Code,                          
SubCentre_Code,Sms_Group,Sms_Active,AsOnDate,SMS_Code,RegID,IsUnicode,Template_Id,Is_Attached_TemplateId)     
select a.Contact_No,sms.dbo.Fn_SMS_Template_to_SMS_Text(@smsText,'','','',isnull(a.Name,'No Name'),'','')
,a.State_Code as StateID,isnull(a.District_Code,0),          
isnull(a.HealthBlock_Code,0),isnull(a.HealthFacilty_Code,0),isnull(a.HealthSubFacility_Code,0),@Sms_Group, 1 as SMS_Active, getdate() as AsOnDate,          
@Sms_Group as SMS_Code,a.ID as RegID,@is_unicode  as IsUnicode,@Template_Id,@Attached_TemplateId            
from t_Ground_Staff a (nolock)  
where  a.Is_Active=1 and a.OTP_Verifiy_Flag=1 and a.ID=@id   and a.Type_ID in (2,3,5,6)  and LEN(a.Contact_No) = 10
and (SUBSTRING(a.Contact_No,1,1)=9 or SUBSTRING(a.Contact_No,1,1)=8 or SUBSTRING(a.Contact_No,1,1)=7 or SUBSTRING(a.Contact_No,1,1)=6)                                                     
             
                                                    
end                                                           
                                  
                     
end                                          
                                   
IF (@@ERROR <> 0)                                                        
BEGIN                                                        
RAISERROR ('TRANSACTION FAILED',16,-1)                                                     
ROLLBACK TRANSACTION                                                        
END 

