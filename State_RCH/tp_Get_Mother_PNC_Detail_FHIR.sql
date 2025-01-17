USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Get_Mother_PNC_Detail_FHIR]    Script Date: 09/26/2024 12:24:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--------------------------
ALTER PROC [dbo].[tp_Get_Mother_PNC_Detail_FHIR] 
AS        
BEGIN        
SET NOCOUNT ON   
SELECT r.registration_no,r.Case_No, 
r.HealthIdNumber,r.Name_PW, r.Mobile_No,convert(varchar, r.Birth_Date, 23) AS Birth_Date, 'female' AS Gender,r.Age,
s.StateName AS State_Name, d.DIST_NAME AS District_Name, r.Address,
ISNULL(Cast(g.ID as varchar), '99999') AS ANM_ID,  ISNULL(g.Name, 'NA') AS ANM_Name, ISNULL(g.Contact_No,'NA') AS ANM_Contact_No,      
g.Address AS Anm_Address, CASE WHEN g.Sex='M' THEN 'male' ELSE 'female' END AS ANM_Gender, 
a.Care_Context_id, a.PNC_No,a.PNC_Type, convert(varchar, a.PNC_Date, 23) AS PNC_Date, 
cast(cast(a.PNC_Date as varchar(20)) + ' ' + '12:00:01.451' as datetime) PNC_Date_Time,
Case When a.PPC='F' THEN ISNULL(a.OtherPPC_Method, 'NA') ELSE ISNULL(dbo.Get_PPC_Name(a.PPC), 'NA') END AS PPC_Method_Name,
m.Code_Value AS SnomedCT_Code, m.SnomedCT_Display_Name,
ISNULL(coalesce(dbo.Get_Mother_Danger_Sign_Name(a.DangerSign_Mother),a.DangerSign_Mother_Other), 'NA') AS DangerSign_Name,
ISNULL(dbo.Get_Mother_Danger_Sign_Name(a.DangerSign_Mother+'999'), 'NA') AS DangerSign_SnomedCT_Code_Name,
a.No_of_IFA_Tabs_given_to_mother AS IFA_Tabs,  
ISNULL(a.Updated_On,a.Created_On)  AS LastUpdatedDate
,CASE WHEN  a.Is_ILI_Symptom = '0' THEN  'No' WHEN a.Is_ILI_Symptom = '1' THEN 'Yes' ELSE 'NA' END AS Is_ILI_Symptom
,CASE WHEN  a.Covid_test_result = '0' THEN  'Negative' WHEN a.Covid_test_result = '1' THEN 'Positive' ELSE 'NA' END AS Covid_test_result
FROM  t_Schedule_Date_Previous sd WITH(NOLOCK) INNER JOIN  
t_mother_pnc a  WITH(NOLOCK) on sd.Registration_no=a.Registration_no and sd.Case_no=a.Case_no
INNER JOIN t_mother_registration r WITH(NOLOCK) on a.Registration_no=r.Registration_no and a.Case_no=r.Case_no
LEFT JOIN dbo.t_Ground_Staff AS g WITH(NOLOCK)  on a.ANM_ID=g.ID   
INNER JOIN TBL_STATE AS s WITH(NOLOCK) ON r.State_Code=s.StateID           
LEFT JOIN TBL_DISTRICT AS  d WITH(NOLOCK) ON r.District_Code=d.DIST_CD  
LEFT JOIN RCH_National_Level.dbo.m_Methods_PPMC_PPC m WITH(NOLOCK) ON a.ppc=m.ppc 
WHERE  cast((ISNULL(sd.Updated_On,sd.Created_On)) as date) =  cast(getdate()-1 as date) 
 and (sd.MPNC_Table =1 or sd.MR_Table=1) and r.HealthIdNumber is not null and r.Approved_ABHA_Logic=1
END  
