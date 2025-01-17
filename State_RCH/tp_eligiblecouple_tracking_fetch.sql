USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligiblecouple_tracking_fetch]    Script Date: 09/26/2024 15:56:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
        
ALTER proc [dbo].[tp_eligiblecouple_tracking_fetch]         
(      
@State_Code int        
,@District_Code int =0       
,@Rural_Urban char(1)        
,@HealthBlock_Code int=0        
,@Taluka_Code varchar(6) =''       
,@HealthFacility_Type int        
,@HealthFacility_Code int =0       
,@HealthSubFacility_Code int =0       
,@Village_Code int=0      
,@Registration_no bigint      
,@Case_no int      
)        
as        
begin      
SET NOCOUNT ON      
      
--declare @Case_no as varchar(200)      
--set @Case_no = '(select Case_no from t_page_tracking where       
--    Case_no in(select max(Case_no) from t_page_tracking where Registration_no='+cast(@Registration_no as varchar(12)) + ') and Registration_no= '+cast(@Registration_no as varchar(12)) +')'      
      
select  Visit_No       
      ,[Registration_no]        
      ,[VisitDate]        
      ,(case [Method]         
      when 'A' then 'CONDOM'        
      when 'F' then 'MALE  STERILIZATION'        
      when 'E' then 'FEMALE  STERILIZATION'        
      when 'D' then 'IUCD CU 375(5 YRS)'        
      when 'C' then 'IUCD CU 380A(10 YRS)'        
      when 'B' then 'OC PILLS'        
      when 'G' then 'EC PILLS'      
      when 'H' then 'NONE'        
      when 'I' then 'ANY OTHER SPECIFY' 
       when 'M' then 'INJECTABLE MPA'       
      else '' end) as Method        
      ,[Other]         
      ,a.[Created_By]        
      ,a.[Created_On]        
      ,(case Pregnant  when 'Y' then 'Yes' when 'N' then 'No' when 'D' then 'Don''t Know' else '' end) as Pregnant        
      ,(case when [Pregnant]='N' and [Pregnant_test]='D' then '--'       
    when [Pregnant]='Y' and [Pregnant_test]='N' then 'Negative'       
    when [Pregnant]='Y' and [Pregnant_test]='P' then 'Positive'      
    when [Pregnant]='Y' and [Pregnant_test]='D' then 'Not Done'      
    when [Pregnant]='D' and [Pregnant_test]='P' then 'Positive'      
    when [Pregnant]='D' and [Pregnant_test]='N' then 'Negative'       
    when [Pregnant]='D' and Pregnant_test='D'  then 'Not Done'      
    else '--' end)as Pregnant_test    
    ,b.Name as ANM_Name    
    ,(case when c.[Name] is null then 'Not Available' else c.[Name] end) as ASHA_Name,a.Method_recd_date     
       from t_eligible_couple_tracking a  WITH (NOLOCK)     
       Left outer join t_Ground_Staff b WITH (NOLOCK) on a.ANM_ID=b.ID        
       Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ASHA_ID=c.ID    
       where  --a.State_Code=@State_Code and      
  --(District_Code=@District_Code or @District_Code =0) and        
  --(Rural_Urban=@Rural_Urban or @Rural_Urban ='') and       
  --(HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code =0) and       
  --(Taluka_Code=@Taluka_Code  or @Taluka_Code='0')and         
  --(HealthFacility_Type=@HealthFacility_Type or @HealthFacility_Type = 0) and       
  --(HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code =0) and         
  --(HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code =0) and         
  --(Village_Code=@Village_Code or @Village_Code =0) and      
  Registration_no=@Registration_no      
  and Case_no=@Case_no      
       order by [VisitDate] asc        
end      
      