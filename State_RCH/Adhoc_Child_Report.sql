USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Adhoc_Child_Report]    Script Date: 09/26/2024 11:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--update t_NotAvailable_True_False set Is_ASHA_NotAvailable=1 where Type_ID=2
--  go
    
--/*          
--fill_ANM_ASHA_AWW_MPW 182,293,0,2          
--fill_ANM_ASHA_AWW_MPW 434,1802,0,1        
--fill_ANM_ASHA_AWW_MPW 434,1802,19551,1        
    
--fill_ANM_ASHA_AWW_MPW 126,744,0,1      
--fill_ANM_ASHA_AWW_MPW 17,38,10000654,1     
--fill_ANM_ASHA_AWW_MPW 201,618,22,1     
  
--fill_ANM_ASHA_AWW_MPW 1682,4580,9264,2  
     
      
--*/          
          
--alter proc [dbo].[fill_ANM_ASHA_AWW_MPW]          
--(          
--@PHC_ID int=0,          
--@SubCentre_ID int=0,         
--@Village_ID int=0,        
--@Type_ID int        
--)          
--as          
--begin          
--if(@SubCentre_ID=0 and @Village_ID=0)        
--begin        
-- if(@Type_ID=1 or @Type_ID=5 or @Type_ID=8)          
--  (    
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and Village_Code=0        
--  --and [TYPE_ID]=@Type_ID and Is_Active=1    
-- select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID    
-- where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=0 and a.Village_Code=0 and a.[TYPE_ID]=@Type_ID and a.Is_Active=1  and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16  
--  )     
--  union    
--  (select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1    
--  and [TYPE_ID]=@Type_ID)    
--  else          
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and Village_Code=0        
--  --and [TYPE_ID] not in (8,5,1) and Is_Active=1 order by Name      
--    select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID     
-- where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=0 and a.Village_Code=0 and a.[TYPE_ID] not in (8,5,1) and a.Is_Active=1  and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16 
-- union    
--  (select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1    
--  and [TYPE_ID]=@Type_ID)       
--end        
--else if(@SubCentre_ID>0 and @Village_ID=0)        
--begin        
--  if(@Type_ID=1 or @Type_ID=5 or @Type_ID=8)          
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and Village_Code=0        
--  --and [TYPE_ID]=@Type_ID and Is_Active=1     
--  select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=0 and a.Village_Code=0 and a.[TYPE_ID]=@Type_ID and a.Is_Active=1    and isnull(a.Is_Processed,1)<>0  and Isnull(a.Process_Value,0)<>16  
--  union        
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=@SubCentre_ID and Village_Code=0 and [TYPE_ID]=@Type_ID and Is_Active=1     
--  select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=@SubCentre_ID and a.Village_Code=0 and a.[TYPE_ID]=@Type_ID and a.Is_Active=1   and isnull(a.Is_Processed,1)<>0  and Isnull(a.Process_Value,0)<>16   
 
--  union    
--  select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1 and [TYPE_ID]=@Type_ID       
--  else          
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and Village_Code=0 and [TYPE_ID] not in (8,5,1) and Is_Active=1     
--    select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=0 and a.Village_Code=0 and a.[TYPE_ID] not in (8,5,1) and a.Is_Active=1     and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16  
--  union        
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=@SubCentre_ID and Village_Code=0 and [TYPE_ID] not in (8,5,1) and Is_Active=1        
--    select a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthFacilty_Code=@PHC_ID and a.HealthSubFacility_Code=@SubCentre_ID and a.Village_Code=0 and a.[TYPE_ID] not in (8,5,1) and a.Is_Active=1     and isnull(a.Is_Processed,1)<>0   and Isnull(a.Process_Value,
--0)<>16   
--union    
--  select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1 and [TYPE_ID]=@Type_ID       
--end        
-- else          
-- begin        
-- if(@Type_ID=8)          
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthSubFacility_Code=@SubCentre_ID and Village_Code=@Village_ID and [TYPE_ID]=@Type_ID and Is_Active=1 order by Name           
--  (select a.ID,Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthSubFacility_Code=@SubCentre_ID and a.Village_Code=@Village_ID   
-- and a.[TYPE_ID]=@Type_ID and a.Is_Active=1 and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16)     
-- union   
--  (select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1    
--  --and @Village_ID not in(select Village_Code from t_Ground_Staff where Type_ID=1 and Village_Code=@Village_ID)    
--  and [TYPE_ID]=@Type_ID)   
-- if(@Type_ID=1 or @Type_ID=5 )          
--  (    
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthSubFacility_Code=@SubCentre_ID and [TYPE_ID]=@Type_ID and Is_Active=1    
--    select distinct a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthSubFacility_Code=@SubCentre_ID and a.[TYPE_ID]=@Type_ID and a.Is_Active=1 and isnull(a.Is_Processed,1)<>0  and Isnull(a.Process_Value,0)<>16  
--  )    
--   union    
--  (select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1     
--  --and @Village_ID not in(select Village_Code from t_Ground_Staff where Type_ID=1 and Village_Code=@Village_ID)    
--  and [TYPE_ID]=@Type_ID)    
--  else          
--  --select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthSubFacility_Code=@SubCentre_ID and [TYPE_ID] not in (8,5,1) and Is_Active=1 order by Name          
--     select distinct a.ID, Name +'('+ convert(varchar(20),a.ID)+')' as Name,lower(Name) as vName from t_Ground_Staff_Mapping a    
-- inner join t_Ground_Staff b on a.ID=b.ID where a.HealthSubFacility_Code=@SubCentre_ID and a.[TYPE_ID] not in (8,5,1) and a.Is_Active=1 and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16
--  union    
--  (select 0 as ID, 'Not Available' as Name, lower('Not Available') as vName from t_NotAvailable_True_False where Is_ASHA_NotAvailable=1     
--  --and @Village_ID not in(select Village_Code from t_Ground_Staff where Type_ID=1 and Village_Code=@Village_ID)    
--  and [TYPE_ID]=@Type_ID)           
-- end          
--end          
--  GO     
  
         
  
  

--------------------------------------------
/*      
Adhoc_Child_Report 23,15,16,61,256,0,2017,0,0,5,9,0      
*/      
ALTER procedure [dbo].[Adhoc_Child_Report]      
(  
@State_Code as int=0,      
@District_Code as int=0,      
@HealthBlock_Code as int=0,      
@HealthFacility_Code as int=0,      
@HealthSubFacility_Code as int=0,      
@Village_Code as int=0,      
@FinancialYr as int=0,      
@Month_ID as int=0,      
@Year_ID as int=0,      
@Category_ID as int=0,      
@Type as int=0,--Reg/DOB      
@Filter_Type as int=0,      
@Sub_Filter_Type as int=0      
)      
as      
begin      
      
SET NOCOUNT ON       
    
if(@Type<>99)      
begin      
select Row_number() over(order by a.registration_no) as Sno,isnull(f.SubPHC_Name_E,'Direct Entry')+CAST((case when f.SUBPHC_CD is null then '(0)' else '' end) as varchar) as [Health SubFacility],   
Convert(varchar(12),a.Registration_no)as RCHID,                  
a.Name_Child as ChildName,a.Name_Father as FatherName,a.Name_Mother as MotherName,a.Mother_Reg_no as MotherID,a.Mobile_no as MobileNo      
,Convert(Varchar(10),a.Birth_Date,103) as DOB                  
,a.[Address]  ,a.Gender    
--,dbo.Get_Masked_UID(a.Child_Aadhaar_No) as AadhaarNo      
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate,
--Convert(varchar(14),a.Child_EID)as EnrollmentNo,a.Child_EIDTime as EnrollmentTime,
a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,      
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                  
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,      
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,      
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles,(case when Entry_type_death=1 then 'Yes' else 'No' end)  as  ChildDeath,
ISNULL( c.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + ')/' + ISNULL( d.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + ')' as Name                  
from t_child_flat a WITH (NOLOCK)                 
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no  
left outer join TBL_SubPHC f on f.SUBPHC_CD=a.SubCentre_ID 
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID      
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.ASHA_ID=d.ID 
where (CASE @Type WHEN  1 THEN b.ChildReg_Fin_Yr  when 2 then (Case when b.Child_Birthdate_Month> 3 then Child_Birthdate_Yr else Child_Birthdate_Yr-1 end) END)=@FinancialYr            
and (CASE WHEN @Type = 1 and @Year_ID<>0 THEN b.Child_Registration_Yr WHEN @Type = 2 and @Year_ID<>0 THEN b.Child_Birthdate_Yr  ELSE  0 END)=@Year_ID        
and (CASE WHEN @Type = 1 and @Month_ID<>0 THEN b.Child_Registration_Month WHEN @Type = 2 and @Month_ID<>0 THEN b.Child_Birthdate_Month  ELSE  0 END)=@Month_ID        
and b.PHC_ID =@HealthFacility_Code        
and (CASE WHEN @Category_ID >=5 THEN b.SubCentre_ID else 0 END)=@HealthSubFacility_Code      
and (CASE WHEN @Category_ID >=6 THEN b.Village_ID else 0 END)=@Village_Code      
and (CASE @Filter_Type when 1 then Child_0_1 when 3 then Child_With_LOWWEIGHT when 4 then Child_With_LOWWEIGHT else 1 end)=1      
and (CASE @Filter_Type when 2 then Child_0_1 when 4 then Child_0_1  else 0 end)=0      
and (CASE  @Sub_Filter_Type      
WHEN 2 THEN b.Child_Aadhar_No_Present      
when 3 THEN b.Address_Present         
when 6 then Child_EID_Present      
when 7 then Child_1_2      
when 8 then Child_2_3      
when 9 then Child_3_4      
when 10 then Child_4_5      
when 16 then Entry_Type_Death      
ELSE 1      
END)=1       
and (case when (@Sub_Filter_Type=1 or @Sub_Filter_Type=2 or @Sub_Filter_Type=3  or @Sub_Filter_Type=4 or @Sub_Filter_Type=5 or @Sub_Filter_Type=6 or @Sub_Filter_Type=13 or @Sub_Filter_Type=14 or @Sub_Filter_Type=15 or @Sub_Filter_Type=17 or @Sub_Filter_Type=18 or @Sub_Filter_Type=19) then Child_0_1 else 1 end)=1      
and (case when (@Filter_Type=4 or @Filter_Type=5) then Mobile_no_Present else 1 end)=1      
and ((Case when @Filter_Type=5 then b.Whose_mobile_Father else 1 end)=1 or (case when @Filter_Type=5 then b.Whose_mobile_Mother else 1 end)=1)      
and (case when @Filter_Type=11 then DATEDIFF(DAY,Child_Birthdate_Date,Child_Registration_Date) else 30 end)<=30         
and (case when (@Filter_Type=12 or @Filter_Type=13 or @Filter_Type=15 or @Filter_Type=17) then Child_With_LOWWEIGHT else 1 end)=1       
--and (case when (@Filter_Type=13 or  @Filter_Type=14) then Child_FullyImmunised_Y else 1 end)=1       
--and (case when (@Filter_Type=17 or  @Filter_Type=18) then Child_FullyImmunised_N else 1 end)=1       
and (case when (@Sub_Filter_Type=13 or  @Sub_Filter_Type=14) then Child_FullyImmunised_Y else 1 end)=1       
and (case when (@Sub_Filter_Type=17 or  @Sub_Filter_Type=18) then Child_FullyImmunised_N else 1 end)=1       
and (case when (@Filter_Type=17 or  @Filter_Type=18 or  @Filter_Type=19) then Convert(date,Birthdate_plus11mon) else Convert(date,GETDATE()-1) end)<=Convert(date,GETDATE()-1)        
      
and (Case when @Sub_Filter_Type=20 then b.Birthdate_plus270day else convert(date,GETDATE()+1) end) between convert(date,GETDATE()-1) and  convert(date,dateadd(MONTH,3,GETDATE()-1))      
and (Case when @Sub_Filter_Type=20 then b.Child_FullyImmunised_Y else 0 end)<>1      
      
      
and (Case when @Sub_Filter_Type=21 then b.Birthdate_plus24mon else convert(date,GETDATE()+1) end) between convert(date,GETDATE()-1) and  convert(date,dateadd(MONTH,3,GETDATE()-1))      
and (Case when @Sub_Filter_Type=21 then b.Child_Received_Y else 0 end)<>1      
      
END      
else      
begin      
      
      
select Row_number() over(order by a.registration_no) as Sno,isnull(f.SubPHC_Name_E,'Direct Entry')+CAST((case when f.SUBPHC_CD is null then '(0)' else '' end) as varchar) as [Health SubFacility],  
Convert(varchar(12),a.Registration_no)as RCHID,                  
a.Name_Child as ChildName,a.Name_Father as FatherName,a.Name_Mother as MotherName,a.Mother_Reg_no as MotherID,a.Mobile_no as MobileNo      
,Convert(Varchar(10),a.Birth_Date,103) as DOB                  
,a.[Address]   ,a.Gender    
--,dbo.Get_Masked_UID(a.Child_Aadhaar_No) as AadhaarNo      
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate,
--Convert(varchar(14),a.Child_EID)as EnrollmentNo,a.Child_EIDTime as EnrollmentTime,
a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,      
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                  
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,      
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,      
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles,(case when Entry_type_death=1 then 'Yes' else 'No' end)  as  ChildDeath,
ISNULL( c.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + ')/' + ISNULL( d.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + ')' as Name                                   
from t_child_flat a WITH (NOLOCK)                 
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no    
left outer join TBL_SubPHC f on f.SUBPHC_CD=a.SubCentre_ID
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID      
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.ASHA_ID=d.ID      
inner join (      
select SubCentre_ID,Village_ID,Name_Mother,Name_Father,Birth_Date from t_child_flat WITH (NOLOCK)       
where     
--PHC_ID=@HealthFacility_Code       
--and     
Birth_Date is not null       
group by SubCentre_ID,Village_ID,Name_Mother,Name_Father,Birth_Date       
having(COUNT(*)>1)      
)X on a.SubCentre_ID=X.SubCentre_ID and a.Village_ID=X.Village_ID and a.Name_Mother=X.Name_Mother and a.Name_Father=X.Name_Father and a.Birth_Date=X.Birth_Date    
      
where (CASE @Filter_Type when 1 then Child_0_1 else 1 end)=1      
and (CASE @Filter_Type when 2 then Child_0_1  else 0 end)=0      
      
order by a.SubCentre_ID,a.Village_ID,a.Name_Mother,a.Name_Father,a.Birth_Date      
end      
      
END 

