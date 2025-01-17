USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_select_data_with_CCID]    Script Date: 09/26/2024 14:51:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
-- tp_select_data_with_CCID 'ET-116000658195-1-271684'          
ALTER proc [dbo].[tp_select_data_with_CCID]            
(            
@care_context_id varchar(50),            
@health_id_no varchar(30)=0,          
@HIP_ID varchar(30)=0,          
@From_date date='', @To_date date=''              
)            
as            
begin          
      
-------------------EC      
if Substring(@care_context_id,1,2)='EC'      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,e.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, e.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
e.Registration_no 'RCH ID No.',isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'Not Applicable') 'ASHA Name',e.Name_wife 'Name of Woman',e.Name_husband 'Name of Husband',e.PW_AccNo 'Account No.',b.Bank_Name 'Bank Name',e.PW_BranchName 'Bank Branch',e.PW_IFSCCode 'IFSC Code'       
,w.Whose_mobile_Name 'Whose Mobile',e.Mobile_no 'Mobile Number', convert(varchar,e.Date_regis,105) 'Date of Registration (dd-mm-yyyy)',e.Wife_current_age 'Current Age (in yrs) - Woman',e.Wife_marry_age 'Age at Marriage (in yrs) - Woman',e.Hus_current_age 
  
'Current Age (in yrs) - Husband',e.Hus_marry_age 'Age at Marriage (in yrs) - Husband',e.Address,r.Name 'Religion' ,c1.Caste_Name 'Caste',      
case e.BPL_APL when 1 then 'BPL' when 2 then 'APL' else 'Not Known'  end 'BPL/APL',e.Male_child_born 'Total No. of Children Born - Male',e.Female_child_born 'Total No. of Children Born - Female',e.Male_child_live 'No. of Live Children - Male',e.Female_child_live 'No. of Live Children - Female', e.Young_child_age_year 'Youngest Child (Age-Year)',e.Young_child_age_month 'Youngest Child (Age-Month)',e.Young_child_gender 'Youngest Child (Sex)'      
,'' as blank1 ,'' as blank2 ,'' as blank3   
from t_eligibleCouples e (nolock)      
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=e.Care_Context_id       
left join t_Ground_Staff g  (nolock) on e.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on e.ASHA_ID=g1.id       
left join RCH_National_Level.dbo.M_Bank b  (nolock) on e.PW_BankID=b.id      
left join RCH_National_Level.dbo.m_caste c1  (nolock) on e.Caste=c1.id      
left join RCH_National_Level.dbo.m_Religion r  (nolock) on e.Religion_Code=r.id      
left join RCH_National_Level.dbo.m_Whose_MobileNo w  (nolock) on e.Whose_mobile=w.Whose_mobile_Code      
where e.Care_Context_id=@care_context_id       
      
---------ECT      
else if Substring(@care_context_id,1,2)='ET'      
      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,t.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, t.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
      
isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',m.Name Method,convert(varchar,t.VisitDate,105) 'Visit Date',(case when t.Pregnant='Y' then 'Yes'      
when t.Pregnant='N' then 'No' else 'Do Not Know' end)'Pregnancy (Yes/No/Don’t Know)'      
from t_eligibleCouples e (nolock) inner join t_eligible_couple_tracking t(nolock) on e.Registration_no=t.Registration_no and e.Case_no=t.Case_no      
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=t.Care_Context_id       
left join t_Ground_Staff g  (nolock) on t.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on t.ASHA_ID=g1.id       
left join RCH_National_Level.dbo.m_Methods_PPMC_PPC m  (nolock) on t.Method=m.Method       
      
where t.Care_Context_id=@care_context_id       
      
      
else if Substring(@care_context_id,1,2)='MR'      
      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,r.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, r.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
(select max(VisitDate) visitdate from t_eligible_couple_tracking t (nolock) where t.Registration_no=r.Registration_no and t.Case_no=r.Case_no) 'Last Visit Date'    
,r.Registration_no 'RCH ID',isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',convert(varchar,Registration_Date,105) 'Pregnancy Registration Date  (As per ReRister) dd-mm-yyyy',      
r.Name_PW 'Name of PW',r.Name_h 'Name of Husband',r.Address,      
case when JSY_Beneficiary='Y' then 'YES' when JSY_Beneficiary='N' then 'NO' else 'NA' end 'JSY Beneficiary',      
case when JSY_Payment_Received='Y' then 'YES' when JSY_Payment_Received='N' then 'NO'  else 'NA' end  'Payment Received',      
Age 'Age (in years)',convert(varchar,Birth_Date,105) 'Date of Birth (dd-mm-yyyy)',isnull(r.Height,'') 'Weight of PW (Kg)',case r.BPL_APL when 1 then 'BPL' when 2 then 'APL' else 'Not Known'  end 'BPL/APL'      
,'' as blank1      
from t_mother_registration r (nolock)       
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=r.Care_Context_id       
left join t_Ground_Staff g  (nolock) on r.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on r.ASHA_ID=g1.id        
where r.Care_Context_id=@care_context_id and ( Registration_Date<>'1990-01-01' and Registration_Date is not null)      
      
else if Substring(@care_context_id,1,2)='MM'      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,t.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
'NA' Doc_name, t.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
 convert(varchar,LMP_Date,105) 'LMP (dd-mm-yyyy)',      
 convert(varchar,EDD_Date,105) 'EDD Date (dd-mm-yyyy)',      
case when isnull(Reg_12Weeks,0)=0 then 'NO' else 'YES' end 'Registered within 12 Weeks of Pregnancy',      
isnull(b.Name, '') 'Blood group of Mother',      
coalesce(dbo.GetPastIllNess_Name(Past_Illness),OtherPast_Illness) 'Past illness',      
No_Of_Pregnancy 'No Of Pregnancy',      
dbo.Get_FacilityPlace_Service_Done(Expected_delivery_place) 'Expected Delivery Place',      
dbo.Get_FacilityPlace_Service_Done_Name(Expected_delivery_place,DeliveryLocationID,Place_name) 'Delivery Place location',      
      
Case VDRL_Test when 1 then 'Done' when 0 then 'Not Done' end 'VDRL Test',      
Case VDRL_Result when 'P' then 'Positive' when 'N' then 'Negative' end 'VDRL Result',VDRL_Date 'VDRL Date',      
      
Case HIV_Test when 1 then 'Done' when 0 then 'Not Done' end 'HIV Test',      
Case HIV_Result when 'P' then 'Positive' when 'N' then 'Negative' end 'HIV Result',HIV_Date 'HIV Date'      
,'' as blank1      
from t_mother_registration r (nolock) inner join t_mother_medical t  (nolock) on r.Registration_no=t.Registration_no and r.Case_no=t.Case_no      
 inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=t.Care_Context_id      
left join RCH_National_Level..m_bloodgroup b on b.ID = t.Blood_Group      
where t.Care_Context_id=@care_context_id       
      
else if Substring(@care_context_id,1,2)='MA'          
select         
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,t.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,      
convert(varchar,isnull([DoB],'--'),121)as [DoB],      
mobile Mobile_no, isnull(g.Name,'NA') Doc_name, t.ANM_ID Doc_ID,'HP' Doc_Qualification,      
--health_id_no,        
--t.Care_Context_id,      
r.Registration_no 'Registration no',        
--cast(Registration_Date as date)as Registration_Date,      
convert(varchar,isnull(Registration_Date,'--'),121) 'Registration Date',       
isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',          
dbo.Get_FacilityPlace_Service_Done_Name(FacilityPlaceANCDone,FacilityLocationIDANCDone,FacilityLocationANCDone) 'Facility/Place/Site of ANC done',      
Abortion_IfAny 'Abortion If Any',ANC_Type 'ANC Type',        
Convert(varchar,[ANC_Date],105)as 'ANC Date',       
Pregnancy_Month  'Weeks of pregnancy',Weight 'Weight of PW (Kg)',  
BP_Systolic 'BP Systolic (mm Hg)' ,BP_Distolic 'BP Diastolic  (mm Hg)', Hb_gm 'HB (gm %)', case isnull(Urine_Test,0) when 1 then 'Done' when 2 then 'Not Done' when 0 then 'Dont Know' end 'Urine Test (Done/ not done)',          
case isnull(BloodSugar_Test,0) when 1 then 'Done' when 2 then 'Not Done' when 0 then 'Dont Know' end 'Blood Sugar Test (Done/ not done)',          
Convert(varchar,TTname,105) 'TT Dose (Date)',      
Convert(varchar,[TT_Date],105)as 'TT Date (dd-mm-yyyy)',       
--case when Pregnancy_Month<=12 then FA_Given else 0 end 'No. of IFA tabs given (before 12 weeks)',      
case when Pregnancy_Month>12 then iFA_Given else 0 end 'No. of IFA tabs given (after 12 weeks)',          
Abdoman_FH 'Fundal Height / Size of the Uterus'        
,Abdoman_FHS 'Foetal Heart Rate (per Min)',          
case Abdoman_FP when 1 then 'Vertical/Head' when 2 then 'Tranceverse/Longitudinal' else 'NA'  end 'Foetal Presentation / Position',          
isnull(f.Name,'NA') 'Foetal Movements (Normal/ Increased/Decreased/Absent)',          
dbo.[Get_Symptoms_High_Risk_Name](Symptoms_High_Risk,Other_Symptoms_High_Risk) 'Any Symptoms of High Risk please indicate',      
--'' as blank1, '' as blank2      
dbo.Get_FacilityPlace_Service_Done(Referral_facility) 'Referral facility',      
Convert(varchar,Referral_date,103) 'Referral Date (dd/mm/yyyy)'      
from t_mother_registration r (nolock) inner join t_mother_anc t  (nolock) on r.Registration_no=t.Registration_no and r.Case_no=t.Case_no          
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=t.Care_Context_id        
left join t_Ground_Staff g  (nolock) on t.Anm_ID=g.id           
left join t_Ground_Staff g1  (nolock) on t.ASHA_ID=g1.id           
left join RCH_National_Level..m_Foetal_Movements f on f.ID = Foetal_Movements          
left join  RCH_National_Level..m_TT tt on tt.ttcode=tt_code          
where t.Care_Context_id=@care_context_id         
      
else if Substring(@care_context_id,1,2)='MD'      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,d.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, d.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
isnull(g.Name,'NA') 'Health Provider Name :',isnull(g1.Name,'NA') 'ASHA Name :',convert(varchar,d.Delivery_date,105) 'Date of Delivery',Delivery_Time 'Delivery Time :',      
dbo.Get_FacilityPlace_Service_Done(Delivery_Place) 'Place of Delivery',      
dbo.Get_FacilityPlace_Service_Done_Name(Delivery_Place,DeliveryLocationID,delivery_location) 'Location of Delivery',      
b.Name 'Who Conducted Delivery',t.Name 'Type of Delivery',dbo.[Get_DeliveryComplication_Name](Delivery_Complication) 'Delivery Complication',    
isnull(d.Delivery_Outcomes,0)'Outcomes Of Delivery',isnull(d.LiveBirth,0)'No. of Live Birth',d.StillBirth 'No. of Still Birth'     
,convert(varchar,d.Discharge_Date,105) 'Date of Discharge','' as blank1, '' as blank2      
from t_mother_registration r (nolock)       
inner join t_mother_delivery d (nolock) on r.Registration_no=d.Registration_no and r.Case_no=d.Case_no       
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=d.Care_Context_id       
left join t_Ground_Staff g  (nolock) on d.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on d.ASHA_ID=g1.id       
left join RCH_National_Level.dbo.m_DeliveryType t (nolock) on d.Delivery_Type=t.id      
left join RCH_National_Level.dbo.m_DeliveryConductedBy b  (nolock) on d.Delivery_Conducted_By=b.id      
where d.Care_Context_id=@care_context_id       
      
else if Substring(@care_context_id,1,2)='MI'      
      
select        
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,t.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, t.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
t.Registration_no 'RCH ID No. :',Infant_id 'Infant No', convert(varchar,Delivery_date,105) 'Delivery Date',      
isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',      
case when Infant_Term='1' or Infant_Term='F' then 'Full Term' when Infant_Term='2' or Infant_Term='P' then 'Premature' end 'Infant Term',      
r.Name_PW 'Mother Name' ,      
Gender_Infant 'Sex of Infant',      
case when Baby_Cried_Immediately_At_Birth='0' or Baby_Cried_Immediately_At_Birth='N' then 'NO' when Baby_Cried_Immediately_At_Birth='1' or Baby_Cried_Immediately_At_Birth='Y' then 'YES' end 'Baby Cried Immediately At Birth',      
case when t.Higher_Facility='Y' then 'YES' when t.Higher_Facility='N' then 'NO' else 'NA' end 'Referred to higher facility for further management',      
DBO.[Get_Infant_defect_Seen]  (Any_Defect_Seen_At_Birth) 'Any defect seen at Birth',      
Weight 'Weight at Birth (kg)',      
case when isnull(Breast_Feeding,0)=0 then 'NO' else 'YES' end 'Breast Feeding Started within one hour Delivery',convert(varchar,OPV_Date,105) 'OPV-0 Dose : (dd-mm-yyyy)',      
convert(varchar,BCG_Date,105) 'BCG Dose : (dd-mm-yyyy)',convert(varchar,HEP_B_Date,105) 'HEP B-0 Dose : (dd-mm-yyyy)',convert(varchar,Vit_K_Date,105) 'VITK Dose : (dd-mm-yyyy)'     
,'' as blank1, '' as blank2,'' as blank3       
from t_mother_registration r (nolock) inner join t_mother_infant t  (nolock) on r.Registration_no=t.Registration_no and r.Case_no=t.Case_no      
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=t.Care_Context_id       
inner join t_mother_delivery d  (nolock) on d.Registration_no=t.Registration_no and d.Case_no=t.Case_no      
left join t_Ground_Staff g  (nolock) on t.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on t.ASHA_ID=g1.id       
where t.Care_Context_id=@care_context_id       
      
else if Substring(@care_context_id,1,2)='MP'      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,p.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, p.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
/*      
isnull(g.Name,'NA') 'Health_Provider_Name',isnull(g1.Name,'NA') 'ASHA_Name',p.PNC_Type,      
p.PNC_Date,p.No_of_IFA_Tabs_given_to_mother,      
dbo.Get_PPC_Name(PPC) PPC_Method,      
coalesce(dbo.Get_Mother_Danger_Sign_Name(DangerSign_Mother),DangerSign_Mother_Other) Mother_Danger_Sign      
*/      
isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',p.PNC_Type 'PNC Period',      
Convert(varchar,p.PNC_Date,105) 'PNC Date :(dd-mm-yyyy)',p.No_of_IFA_Tabs_given_to_mother 'IFA Tablets Given to Mother',      
dbo.Get_PPC_Name(PPC)  'PPC Method',      
coalesce(dbo.Get_Mother_Danger_Sign_Name(DangerSign_Mother),DangerSign_Mother_Other) 'Mother Danger Sign'      
      
,'' as blank1, '' as blank2,'' as blank3       
from t_mother_registration r (nolock)       
inner join t_mother_pnc p (nolock) on r.Registration_no=p.Registration_no and r.Case_no=p.Case_no      
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=p.Care_Context_id       
left join t_Ground_Staff g  (nolock) on p.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on p.ASHA_ID=g1.id       
where p.Care_Context_id=@care_context_id       
      
else if Substring(@care_context_id,1,2)='CP'      
      
select       
--Name_PW,'F' Gender,birth_date DoB,Mobile_no,isnull(g.Name,'NA') Doc_name,p.ANM_ID Doc_ID,'HP' Doc_Qualification,health_id_no,        
p_name Name_PW, c.Gender,convert(varchar,isnull([DoB],'--'),121)as [DoB],mobile Mobile_no,       
isnull(g.Name,'NA') Doc_name, p.ANM_ID Doc_ID,'HP' Doc_Qualification,--health_id_no,        
--t.Care_Context_id,      
p.InfantRegistration 'RCH ID No. :',isnull(g.Name,'NA') 'Health Provider Name',isnull(g1.Name,'NA') 'ASHA Name',      
p.PNC_type 'PNC Period',Convert(varchar,p.PNC_Date,105) 'PNC Date :(dd-mm-yyyy)' ,p.Infant_Weight 'Weight of Infant : (kg)',      
coalesce(dbo.Get_Child_Danger_Sign_Name(DangerSign_Infant),DangerSign_Infant_Other) 'Infant Danger Sign',      
 case when Infant_Death_Date is not null then 'Y' else 'N' end 'Infant Death'    
 ,'' as blank1,'' as blank2      
from t_child_pnc p (nolock)      
inner join  RCH_Web_Services..care_context_link_request c (nolock) on c.Care_Context_id=p.Care_Context_id       
left join t_Ground_Staff g  (nolock) on p.Anm_ID=g.id       
left join t_Ground_Staff g1  (nolock) on p.ASHA_ID=g1.id       
left join RCH_National_Level.dbo.m_DangerSignInfant d(nolock) on p.DangerSign_Infant=d.ID      
where p.Care_Context_id=@care_context_id       
end      
      
--select * from RCH_Web_Services..care_context_link_request where Care_Context_id = 'MA-135000099189-1-139965' 