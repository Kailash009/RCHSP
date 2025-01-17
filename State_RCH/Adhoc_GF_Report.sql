USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Adhoc_GF_Report]    Script Date: 09/26/2024 11:56:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
-------------------------------------------      
      
      
/*      
[Adhoc_GF_Report] 30,1,0,0,0,0,0,1,1,0111,0      
[Adhoc_GF_Report] 4,1,1,0,0,0,0,0,0,3,1,1,5      
[Adhoc_GF_Report] 4,1,1,160,0,0,0,0,0,4,1      
*/      
ALTER procedure [dbo].[Adhoc_GF_Report]      
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
@Category_ID as int=0,--hierrachy      
@Type as int=0,--Registrerd      
@Filter_Type as int=0,      
@Sub_Filter_Type as int=0      
)      
as      
begin      
      
Select  ROW_NUMBER() OVER(ORDER BY a.ID ASC) AS [Sno],d.Block_Name_E as [Health Block],e.PHC_Name as [Health Facility],isnull(f.SubPHC_Name_E,'Direct Entry')+CAST((case when f.SUBPHC_CD is null then '(0)' else '' end) as varchar) as [Health SubFacility],isnull(g.Name_E,'Direct Entry')+'(
'+cast(isnull(g.MDDS_Code,0) as varchar)+')' as Village      
,a.ID as ID,a.Name as Name,isnull(a.Husband_Name,'') as [Husband Name]      
,b.Type_Name as Designation,a.Contact_No as [Mobile No]      
,(case when a.Is_Active=1 then 'Yes' else 'No' end) as Status      
,(case when a.IsValidated=1 then 'Yes' else 'No' end) as IsValidated      
,a.Sex as Gender,a.Address      
,(case when a.Reg_Date is null then '' else CONVERT(varchar(10),a.Reg_Date,103) end) as JoiningDate      
,a.Telecom_Operator as [Telecom Operator]--,dbo.Get_Masked_UID(a.Aadhar_No) as AadhaarNo      
--,(case when a.AadhaarLinked=1 then 'Yes' else 'No' end) as [Linked with Aadhaar]      
,h.Bank_Name as Bank      
,a.BranchName,dbo.Get_Masked_Account(a.AccNo) as [Account No]      
,a.IFSCCode      
from t_ground_staff a      
inner join RCH_National_Level.dbo.m_HealthProvider_Type b on a.Type_ID=b.Type_ID      
inner join t_Ground_Staff_flat i on a.ID=i.ID  
inner join TBL_HEALTH_BLOCK d on a.HealthBlock_Code=d.BLOCK_CD      
inner join TBL_PHC e on a.HealthFacilty_Code=e.PHC_CD       
left outer join TBL_SubPHC f on a.HealthSubFacility_Code=f.SUBPHC_CD       
left outer join Village g on a.Village_Code=g.VCode      
left outer join RCH_National_Level.dbo.M_Bank h on a.BankID=h.ID       
where 
--a.Is_Active=1 and       
     (a.District_Code=@District_Code or @District_Code=0)     
and (CASE WHEN @Category_ID >=3 THEN a.HealthBlock_Code else 0 END)=@HealthBlock_Code      
and (CASE WHEN @Category_ID >=4 THEN a.HealthFacilty_Code else 0 END)=@HealthFacility_Code      
and (CASE WHEN @Category_ID >=5 THEN a.HealthSubFacility_Code else 0 END)=@HealthSubFacility_Code      
and (CASE WHEN @Category_ID >=6 THEN a.Village_Code else 0 END)=@Village_Code      
and  (case when @Filter_Type<>9 then   b.Type_ID else @Filter_Type end)=@Filter_Type     
and (case @Sub_Filter_Type       
when 1 then i.Aadhar_No_Absent      
when 2 then i.Contact_No_Absent      
when 3 then i.Aadhaar_Linked_Absent      
when 4 then i.Account_Number_Absent      
when 5 then i.IsValidated_No      
else 1       
end)=1      
and (case when @Sub_Filter_Type=6 then isnull(g.MDDS_Code,0) else 1 end)<>0      
and  b.Type_ID <> 8--Add New by Shivam 14/06/2019    
END      
  
  
  
  
  
    
  
  
  
  
  
  
  