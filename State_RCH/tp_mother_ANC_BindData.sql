USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_ANC_BindData]    Script Date: 09/26/2024 14:49:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
  
      
ALTER proc [dbo].[tp_mother_ANC_BindData]      
(      
@State_Code int        
--,@District_Code int        
--,@Rural_Urban char(1)        
--,@HealthBlock_Code int        
--,@Taluka_Code varchar(6)        
--,@HealthFacility_Type int        
--,@HealthFacility_Code int        
--,@HealthSubFacility_Code int        
--,@Village_Code int      
,@Registration_no bigint    
,@Case_no int    
)      
as      
begin      
SET NOCOUNT ON      
          
select A.Registration_no,A.ANC_No,A.ANC_Type,A.hfANC_Type,A.ANC_Date,A.Pregnancy_Month,A.[Abortion_IfAny],A.[Abortion_Type],A.Abortion_date,A.[Abortion_Preg_Weeks],A.[Weight],A.[BP_Systolic]      
,A.[BP_Distolic],A.Odema_Feet,A.Hb_gm,A.Urine_Albumin,A.Urine_Sugar,A.FA_Given,A.IFA_Given,A.Abdoman_FP,A.Abdoman_FHS,      
A.Abdoman_FP,A.Symptoms_High_Risk,A.Referral_facility,A.Referral_location,A.Maternal_Death,A.Death_Date,A.Death_Reason,A.TT_Date,A.TT_Code,ANM_Name,ASHA_Name        
,B.Max_ANC_Date,Substring(B.ANC_Type,6,7) as Max_ANC_Type,A.[Covid_test_result] from (      
select       
    [Registration_no]      
    ,Case_no    
      ,[ANC_No]      
      ,'ANC - '+ cast([ANC_Type] as varchar(10)) as ANC_Type    
      ,ANC_Type as hfANC_Type    
      , ANC_Date     
      ,(case Abortion_date when '' then null else Abortion_date end) as Abortion_date     
      ,[Pregnancy_Month]      
      ,(case [Abortion_IfAny] when 'True' then 'Yes' when 'False' then 'No' else '''' end) as Abortion_IfAny      
      ,(case [Abortion_Type] when '0' then '' when '5' then 'Induced' when '6' then 'Spontaneous' else '' end) as Abortion_Type      
      ,[Abortion_Preg_Weeks]      
      ,[Weight]      
      ,[BP_Systolic]      
      ,[BP_Distolic]      
      ,[Odema_Feet]      
      ,[Hb_gm]      
      ,[Urine_Albumin]      
      ,[Urine_Sugar]      
      ,FA_Given    
      ,IFA_Given     
      ,[Abdoman_FH]      
      ,[Abdoman_FHS]      
      ,[Abdoman_FP]      
      ,(case [Symptoms_High_Risk] when '0' then '' when 'A' then 'High BP (Systolic >= 140 and or Diastolic >= 90 mmHg)' when 'B' then 'Convulsions' when 'C' then 'Vaginal Bleeding'      
       when 'D' then 'Foul Smelling Discharge' when 'E' then 'Severe Anaemia (Hb level < 7 gms%)' when 'F' then 'Diabetic' when 'G' then 'Twins'  when 'Y' then 'None'      
       when 'Z' then 'Any Other Specify' else '' end) as [Symptoms_High_Risk]      
      ,[Referral_Date]      
      ,(case [Referral_facility] when '0' then '' when '1' then 'Phc' when '2' then 'Chc' when '3' then 'District Hospital' when '4' then 'Private Hospital'      
      when '99' then 'Other' else '' end) as [Referral_facility]      
      ,[Referral_location]      
      ,(case [Maternal_Death] when '0' then 'No' when '1' then 'Yes' else '' end) as Maternal_Death      
      ,[Death_Date]      
      ,(case [Death_Reason] when '0' then '' when 'A' then 'Eclampcia' when 'B' then 'Haemorrahge' when 'C' then 'High Fever' when 'D' then 'Abortion'        when 'Z' then 'Any Other Specify' else '' end) as [Death_Reason]      
      ,TT_Date as TT_Date      
      ,(Case TT_Code    
        when 13 then 'TT1'    
        when 14 then 'TT2'    
        when 17 then 'TTB' end ) as TT_Code  
       ,d.Name as ANM_Name  
       ,(case when e.[Name] is null then 'Not Available' else e.[Name] end) as ASHA_Name
       ,(case c.[Covid_test_result] when '1' then 'Positive' when '0' then 'Negative' else '--' end) as Covid_test_result     
       from t_mother_anc c   
       Left outer join t_Ground_Staff d WITH (NOLOCK) on c.ANM_ID=d.ID      
       Left outer join t_Ground_Staff e WITH (NOLOCK) on c.ASHA_ID=e.ID  
       where --c.State_Code=@State_Code and   
       Registration_no=@Registration_no and Case_no=@Case_no)A      
      left outer join      
     (select MAX([ANC_Date]) as Max_ANC_Date,max('ANC - '+ cast([ANC_Type] as varchar(1))) as ANC_Type,Registration_no,Case_no from t_mother_anc    
      where --State_Code=@State_Code and   
      Registration_no=@Registration_no and Case_no=@Case_no group by Registration_no,Case_no) B on A.Registration_no=B.Registration_no and A.Case_no=b.Case_no    
      
end    

