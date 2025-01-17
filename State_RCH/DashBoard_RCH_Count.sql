USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[DashBoard_RCH_Count]    Script Date: 09/26/2024 12:31:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  procedure [dbo].[DashBoard_RCH_Count]    
  
AS   
Begin    
  
Declare @Year as int = Year(GETDATE())   
  
    
    
SELECT SUM(isnull(B.EC,0)) AS Total_EC_count,  
sum(isnull(C.PW,0) +isnull(E.PW_9_28,0)+isnull(F.PW_MCTS,0) ) as Total_PW_Count  
 ,SUM(ISNULL( D.CHILD,0)+ISNULL(F.CH_MCTS,0)+ISNULL(E.CH_9_28,0))AS Total_Child_count  
,SUM(ISNULL(L.Total_GF,0) +ISNULL(M.Total_Anm,0) + ISNULL(M.TOTAL_Asha,0)) AS Total_GF_Count
 ,SUM(ISNULL(N.Total_EC_1Days,0))  AS Total_EC_1Days  
 ,SUM(ISNULL(N.Total_Mother_1Days,0) +ISNULL(F.PW_Added_LastDay,0)) AS Total_Mother_1Days  
 ,SUM(ISNULL(N.Total_Infant_1Days,0) +ISNULL(F.Child_Added_LastDay,0)) AS Total_Infant_1Days  
 ,SUM(ISNULL(Y1.Total_EC_CY,0)) AS Total_EC_CY  
 ,SUM(ISNULL(Y2.Total_Mother_CY,0)) AS Total_Mother_CY  
 ,SUM(ISNULL(Y3.Total_Infant_CY,0)) AS Total_Infant_CY  
 ,cast(round(sum(isnull(C.PW,0) +isnull(E.PW_9_28,0)+ isnull(F.PW_MCTS,0) +  
 (ISNULL( D.CHILD,0)+ISNULL(F.CH_MCTS,0)+ISNULL(E.CH_9_28,0)))/10000000.0,2) as numeric(36,2)) as TotalBeneficiaries  
,CONVERT(varchar(10), DATEADD(day, -1, GETDATE()),3) as Yesterday_Date  
,(CASE WHEN (MONTH(GETDATE())) <= 3 THEN convert(varchar(4), YEAR(GETDATE())-1) + '-' + convert(varchar(4), YEAR(GETDATE())%100)   
ELSE convert(varchar(4),YEAR(GETDATE()))+ '-' + convert(varchar(4),(YEAR(GETDATE())%100)+1)END) AS CurrentFinancialYear     
  
 FROM ((  
 Select State_ID,State_Name from State_Master  (NOLOCK)) A   
 left outer join   
 (select State_Code,ISNULL(SUM(EC_Registered),0) as EC  from  Scheduled_AC_EC_All_State_Month (NOLOCK) where Filter_Type=1 GROUP BY State_Code ) B  
 on A.State_ID=B.State_Code  
 LEFT OUTER JOIN    
 (SELECT State_Code,ISNULL(SUM(PW_Registered),0) as PW FROM Scheduled_AC_PW_All_State_Month  (NOLOCK) WHERE Filter_Type=1 and  State_Code NOT IN (9,28)   
 Group by State_Code ) C ON A.State_ID=C.State_Code  
 LEFT OUTER JOIN   
 (SELECT State_Code,isnull(SUM(Child_P+Child_T),0)  as CHILD FROM Scheduled_AC_Child_All_State_Month  (NOLOCK) WHERE Filter_Type=1 and State_Code NOT IN (9,28)  
  Group by State_Code ) D on a.State_ID=D.State_Code  -- total child from portal and templet of rch count  
  LEFT OUTER JOIN   
 (SELECT StateID,ISNULL(SUM(Mother_Total_Count),0) as PW_9_28,ISNULL( SUM(Child_Total_Count),0) as CH_9_28 FROM  Scheduled_DB_AllState__DashBoard_Count (NOLOCK) where   
  (StateID=9 and Created_Date>'2017-12-20') or (StateID=28 and Created_Date>'2015-12-07') Group by StateID) E ON A.State_ID=E.StateID  
left outer join   
(SELECT State_ID, ISNULL(SUM([PW_Total]),0) PW_MCTS,isnull(SUM([Child_Total]),0) AS CH_MCTS,ISNULL(SUM(PW_Added_LastDay),0) PW_Added_LastDay,isnull(SUM(Child_Added_LastDay),0) AS Child_Added_LastDay  
  FROM [RCH_Reports].[dbo].[Scheduled_MCTS_Count] (NOLOCK) where State_ID in (9,34,35,24,18,33,8,29,28) group by State_ID) F on A.State_ID=F.State_ID  
 lEFT OUTER JOIN  
(select state_Code,isnull(sum(total_GF ),0)   as Total_GF  from Scheduled_AC_GF_State_District (NOLOCK) where State_Code not in (9)   
group by State_Code) L on A.State_ID=L.State_Code  
lEFT OUTER JOIN  
(select State_ID,isnull(sum(HealthProvider_Total ),0) as  Total_Anm, SUM(ASHA_Total) AS TOTAL_Asha from SCHEDULED_MCTS_GF_Count (NOLOCK) where State_ID in   
(9,34,35,24,18,33,8,29) group by State_ID) M on A.State_ID=M.State_ID    -- MCTS Count of GF  
 Left outer join   
 (select StateID, ISNULL(SUM(cast(Mother_Total_Count as bigint)),0) as Total_Mother_1Days ,ISNULL(SUM(cast(Child_Total_Count as bigint)),0)  as Total_Infant_1Days     
,ISNULL(SUM(EC_Total_Count),0)  as Total_EC_1Days from Scheduled_DB_AllState__DashBoard_Count (NOLOCK) where Created_Date = CONVERT(date, GETDATE()-1) group by StateID) N ON A.State_ID=n.StateID  
 left outer join   
 (select State_Code, ISNULL(SUM(EC_Registered),0) as Total_EC_CY from  dbo.Scheduled_AC_EC_All_State_Month (NOLOCK) where Filter_Type=1 and Fin_Yr = @Year Group by State_Code) Y1 on A.State_ID=Y1.State_Code   
 lEFT OUTER JOIN     
(select State_Code,ISNULL(SUM(pw_registered),0) as Total_Mother_CY from  dbo.Scheduled_AC_PW_All_State_Month (NOLOCK) where Filter_Type=1 and Fin_Yr = @Year GROUP BY State_Code) Y2 on A.State_ID=Y2.State_Code  
left outer join  
(Select State_Code, ISNULL(SUM(Child_P+Child_T),0) as Total_Infant_CY from Scheduled_AC_Child_All_State_Month (NOLOCK)  where Filter_Type=1 and Fin_Yr = @Year Group by State_Code) Y3 on A.State_ID=Y3.State_Code   
)     
 END  
  
