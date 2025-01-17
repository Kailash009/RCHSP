USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Adhoc_MH_Beneficiary_Card]    Script Date: 09/26/2024 11:56:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
      
      
-----------------------------------      
/*      
Adhoc_MH_Beneficiary_Card 0,0,0,0,0,0,0,0,0,0,0,109044250121,'0'       
*/      
        
ALTER procedure [dbo].[Adhoc_MH_Beneficiary_Card]        
(        
@State_Code int=0,        
@District_Code int=0,        
@HealthBlock_Code int=0,        
@HealthFacility_Code int=0,        
@HealthSubFacility_Code int=0,        
@Village_Code int=0,        
@FinancialYr int=0,        
@Month_ID int=0 ,        
@Year_ID int=0 ,        
@Type as int=0,--Registrerd        
@Filter_Type as int=0,        
@Registration_No bigint=0,        
@ID_No varchar(18)='0'        
)        
As        
begin        
SET NOCOUNT ON       
if(@State_Code<>0)      
begin        
select a.Registration_no,a.Case_no,a.ID_No,a.Name_wife,a.Name_husband,a.Whose_mobile,a.Mobile_no,      
convert(varchar,a.EC_Regisration_Date,103) as EC_Regisration_Date,a.Wife_current_age,a.Address      
,isnull(f.VILLAGE_NAME,'Direct Entry')as Village_Name,a.Religion,a.Caste,c.Name as ASHA_Name,c.Contact_No as ASHA_Contact_No,b.Name as ANM_NAME      
,b.Contact_No as ANM_Contact_No,c.IsLinked--,[dbo].[Get_Masked_UID](a.PW_Aadhar_No) as PW_Aadhar_No      
,a.PW_EID      
,a.Mother_Weight,(Case a.[JSY_Beneficiary] when 'N' then 'No' when 'Y' then 'Yes' end )as JSY_Beneficiary,          
(Case a.[JSY_Payment_Received] when 'N' then 'No' when 'Y' then 'Yes' end )as JSY_Payment_Received,          
(Case a.[Medical_Reg_12Weeks] when 'N' then 'No' when 'Y' then 'Yes' end )as Medical_Reg_12Weeks      
,a.Expected_delivery_place,a.Expected_delivery_placeName      
,convert(varchar, a.Mother_Registration_Date,103) as Mother_Registration_Date,CONVERT(varchar,a.Mother_BirthDate,103) as Mother_BirthDate      
,CONVERT(varchar,a.Medical_LMP_Date,103) as Medical_LMP_Date,CONVERT(varchar,a.Medical_EDD_Date,103) as Medical_EDD_Date,CONVERT(varchar,a.ANC1,103) as ANC1      
,CONVERT(varchar,a.ANC2,103) as ANC2,CONVERT(varchar,a.ANC3,103) as ANC3,CONVERT(varchar,a.ANC4,103) as ANC4,CONVERT(varchar,a.TT1,103) as TT1      
,CONVERT(varchar,a.TT2,103) as TT2,CONVERT(varchar,a.TTB,103) as TTB,CONVERT(varchar,a.IFA,103) as IFA,CONVERT(varchar,a.AbortionDate,103) as AbortionDate      
,CONVERT(varchar,a.Discharge_Date,103) as Discharge_Date,CONVERT(varchar,a.JSY_Paid_Date,103) as JSY_Paid_Date,CONVERT(varchar,a.Delivery_date,103) as Delivery_date      
,CONVERT(varchar,a.Death_Date,103) as Death_Date,a.Abortion_Type,a.Delivery_Place,a.Delivery_Place_Name,a.Delivery_Conducted_By,a.Delivery_Type      
,a.Delivery_Outcomes,a.Delivery_Complication,(case when coalesce(Death_Date,Mother_Death_Date) is not null then Convert(varchar,coalesce(Death_Date,Mother_Death_Date),103) else '' end) AS Maternal_Death,        
(Case a.[Infant1_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant1_Gender      
,a.Infant1_Weight      
,(case a.Infant1_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant1_Breast_Feeding      
,(Case a.[Infant2_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant2_Gender,a.Infant2_Weight      
,(case a.Infant2_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant2_Breast_Feeding      
,(Case a.[Infant3_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant3_Gender,a.Infant3_Weight      
,(case a.Infant3_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant3_Breast_Feeding      
,(Case a.[Infant4_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant4_Gender,a.Infant4_Weight      
,(case a.Infant4_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant4_Breast_Feeding       
,d.DIST_NAME_ENG as DistrictName,d.Block_Name_E as BlockName,d.PHC_NAME as PHCName,e.SUBPHC_NAME_E as SubCentreName,      
(Case when AbortionDate is not null then 1 else 0 end ) as abortion_present ,    
CONVERT(varchar,a.PNC1_Date,103) as PNC1_Date,CONVERT(varchar,a.PNC2_Date,103) as PNC2_Date,CONVERT(varchar,a.PNC3_Date,103) as PNC3_Date,    
CONVERT(varchar,a.PNC4_Date,103) as PNC4_Date,CONVERT(varchar,a.PNC5_Date,103) as PNC5_Date,CONVERT(varchar,a.PNC6_Date,103) as PNC6_Date,    
CONVERT(varchar,a.PNC7_Date,103) as PNC7_Date     
from t_mother_flat a WITH (NOLOCK)       
--inner join t_mother_flat_Count g WITH (NOLOCK) on a.Registration_no=g.Registration_no and a.Case_no=g.Case_no      
left outer join t_Ground_Staff b WITH (NOLOCK) on a.Mother_ANM_ID=b.ID          
left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ASHA_ID=c.ID       
inner join Name_HealthFacility d WITH (NOLOCK) on a.PHC_ID=d.PHC_CD      
left outer join TBL_SubPHC e WITH (NOLOCK) on a.Subcentre_ID=e.SubPHC_CD      
left outer join TBL_VILLAGE f WITH (NOLOCK) on a.Subcentre_ID=f.SubPHC_CD and a.Village_ID=f.VILLAGE_CD      
where (a.M_StateID=@State_Code)        
and(a.M_District_ID=@District_Code)        
and(a.M_HealthBlock_ID=@HealthBlock_Code)        
and(a.M_PHC_ID=@HealthFacility_Code)        
and(a.M_SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
and(a.M_Village_ID=@Village_Code or @Village_Code=0)          
and (a.Mother_Yr=@FinancialYr  or @FinancialYr=0)  -- add by shivam       
and (Year(a.Mother_Registration_Date) =@Year_ID or  @Year_ID=0)      
and (Month(a.Mother_Registration_Date) =@month_ID or  @month_ID=0)       
and isnull(delete_mother,0)=0         
end      
else if(@State_Code=0)      
Begin      
select a.Registration_no,a.Case_no,a.ID_No,a.Name_wife,a.Name_husband,a.Whose_mobile,a.Mobile_no,      
convert(varchar,a.EC_Regisration_Date,103) as EC_Regisration_Date,a.Wife_current_age,a.Address      
,isnull(f.VILLAGE_NAME,'Direct Entry')as Village_Name,a.Religion,a.Caste,c.Name as ASHA_Name,c.Contact_No as ASHA_Contact_No,b.Name as ANM_NAME      
,b.Contact_No as ANM_Contact_No,c.IsLinked--,[dbo].[Get_Masked_UID](a.PW_Aadhar_No) as PW_Aadhar_No      
,a.PW_EID      
,a.Mother_Weight,(Case a.[JSY_Beneficiary] when 'N' then 'No' when 'Y' then 'Yes' end )as JSY_Beneficiary,          
(Case a.[JSY_Payment_Received] when 'N' then 'No' when 'Y' then 'Yes' end )as JSY_Payment_Received,          
(Case a.[Medical_Reg_12Weeks] when 'N' then 'No' when 'Y' then 'Yes' end )as Medical_Reg_12Weeks      
,a.Expected_delivery_place,a.Expected_delivery_placeName      
,convert(varchar, a.Mother_Registration_Date,103) as Mother_Registration_Date,CONVERT(varchar,a.Mother_BirthDate,103) as Mother_BirthDate      
,CONVERT(varchar,a.Medical_LMP_Date,103) as Medical_LMP_Date,CONVERT(varchar,a.Medical_EDD_Date,103) as Medical_EDD_Date,      
CONVERT(varchar,a.ANC1,103)  + '[' + tg1.name + '-' +  CAST(tg1.ID AS VARCHAR) + '] [' +  tg5.name + '-' +  CAST(tg5.ID AS VARCHAR) +']' as ANC1        
,CONVERT(varchar,a.ANC2,103) + '[' + tg2.name + '-' +  CAST(tg2.ID AS VARCHAR) + '] [' +  tg6.name + '-' +  CAST(tg6.ID AS VARCHAR) +']' as ANC2,      
 CONVERT(varchar,a.ANC3,103) + '[' + tg3.name + '-' +  CAST(tg3.ID AS VARCHAR) + '] [' +  tg7.name + '-' +  CAST(tg7.ID AS VARCHAR) +']' as ANC3,      
 CONVERT(varchar,a.ANC4,103) + '[' + tg4.name + '-' +  CAST(tg4.ID AS VARCHAR) + '] [' +  tg8.name + '-' +  CAST(tg8.ID AS VARCHAR) +']' as ANC4,      
CONVERT(varchar,a.TT1,103) as TT1      
,CONVERT(varchar,a.TT2,103) as TT2,CONVERT(varchar,a.TTB,103) as TTB,CONVERT(varchar,a.IFA,103) as IFA,CONVERT(varchar,a.AbortionDate,103) as AbortionDate      
,CONVERT(varchar,a.Discharge_Date,103) as Discharge_Date,CONVERT(varchar,a.JSY_Paid_Date,103) as JSY_Paid_Date,CONVERT(varchar,a.Delivery_date,103) as Delivery_date      
,CONVERT(varchar,a.Death_Date,103) as Death_Date,a.Abortion_Type,a.Delivery_Place,a.Delivery_Place_Name,a.Delivery_Conducted_By,a.Delivery_Type      
,a.Delivery_Outcomes,a.Delivery_Complication,    
--(case when coalesce(Death_Date,Mother_Death_Date) is not null then Convert(varchar,coalesce(Death_Date,Mother_Death_Date),103) else '' end) AS Maternal_Death,      
(case when Entry_type='Death' then 'Yes' else 'No' end) as Maternal_Death,      
(Case a.[Infant1_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant1_Gender      
,a.Infant1_Weight      ,(case a.Infant1_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant1_Breast_Feeding      
,(Case a.[Infant2_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant2_Gender,a.Infant2_Weight      
,(case a.Infant2_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant2_Breast_Feeding      
,(Case a.[Infant3_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant3_Gender,a.Infant3_Weight      
,(case a.Infant3_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant3_Breast_Feeding      
,(Case a.[Infant4_Gender] when 'M' then 'Male' when 'F' then 'Female' end )as Infant4_Gender,a.Infant4_Weight      
,(case a.Infant4_Breast_Feeding when '1' then 'Yes' when '0' then 'No'  else '' end) Infant4_Breast_Feeding       
,d.DIST_NAME_ENG as DistrictName,d.Block_Name_E as BlockName,d.PHC_NAME as PHCName,e.SUBPHC_NAME_E as SubCentreName,      
(Case when AbortionDate is not null then 1 else 0 end ) as abortion_present,    
CONVERT(varchar,a.PNC1_Date,103) as PNC1_Date,CONVERT(varchar,a.PNC2_Date,103) as PNC2_Date,CONVERT(varchar,a.PNC3_Date,103) as PNC3_Date,    
CONVERT(varchar,a.PNC4_Date,103) as PNC4_Date,CONVERT(varchar,a.PNC5_Date,103) as PNC5_Date,CONVERT(varchar,a.PNC6_Date,103) as PNC6_Date,    
CONVERT(varchar,a.PNC7_Date,103) as PNC7_Date       
from t_mother_flat a WITH (NOLOCK)        
--inner join t_mother_flat_Count g WITH (NOLOCK) on a.Registration_no=g.Registration_no and a.Case_no=g.Case_no      
left outer join t_Ground_Staff b WITH (NOLOCK) on a.Mother_ANM_ID=b.ID          
left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ASHA_ID=c.ID       
left join  t_Ground_Staff tg1 WITH (NOLOCK) on a.ANC1_ANM_ID = tg1.id      
left join  t_Ground_Staff tg2 WITH (NOLOCK) on a.ANC2_ANM_ID = tg2.id       
left join  t_Ground_Staff tg3 WITH (NOLOCK) on a.ANC3_ANM_ID = tg3.id       
left join  t_Ground_Staff tg4 WITH (NOLOCK) on a.ANC4_ANM_ID = tg4.id       
left join  t_Ground_Staff tg5 WITH (NOLOCK) on a.ANC1_ASHA_ID = tg5.id      
left join  t_Ground_Staff tg6 WITH (NOLOCK) on a.ANC2_ASHA_ID = tg6.id       
left join  t_Ground_Staff tg7 WITH (NOLOCK) on a.ANC3_ASHA_ID = tg7.id       
left join  t_Ground_Staff tg8 WITH (NOLOCK) on a.ANC4_ASHA_ID = tg8.id       
inner join Name_HealthFacility d WITH (NOLOCK) on a.PHC_ID=d.PHC_CD      
left outer join TBL_SubPHC e WITH (NOLOCK) on a.Subcentre_ID=e.SubPHC_CD      
left outer join TBL_VILLAGE f WITH (NOLOCK) on a.Subcentre_ID=f.SubPHC_CD and a.Village_ID=f.VILLAGE_CD      
where (a.Registration_no=@Registration_No or a.ID_no=@ID_No)   
and isnull(delete_mother,0)=0         
end      
END        
