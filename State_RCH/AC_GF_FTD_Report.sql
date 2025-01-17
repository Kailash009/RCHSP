USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_GF_FTD_Report]    Script Date: 09/26/2024 11:51:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*         
[AC_GF_FTD_Report] 35,0,0,0,0,0,2022,10,0,'','','State',1          
[AC_GF_FTD_Report] 35,2,0,0,0,0,2022,10,0,'','','District',1                  
*/        
ALTER procedure [dbo].[AC_GF_FTD_Report]        
(        
@State_Code int=0,          
@District_Code int=0,          
@HealthBlock_Code int=0,          
@HealthFacility_Code int=0,          
@HealthSubFacility_Code int=0,        
@Village_Code int=0,        
@FinancialYr int,         
@Month_ID int=0 ,        
@Year_ID int=0 ,        
@FromDate date='',          
@ToDate date='' ,        
@Category varchar(20) ='District'  ,        
@Type int =1         
)            
as        
begin        
if(@Category='State')        
Begin        
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName         
,ISNULL(Total_ANM,0) as Total_ANM        
,ISNULL(Total_Active_ANM,0) as Total_Active_ANM   
,ISNULL(Distinct_HP_ID,0)as Distinct_HP_ID           
,ISNULL(Total_FTD,0)as Total_FTD        
,ISNULL(FTD_Success,0) as FTD_Success        
,ISNULL(FTD_Failure,0) as FTD_Failure        
from            
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name          
 from  TBL_DISTRICT a           
 inner join TBL_STATE b on a.StateID=b.StateID                
) A          
left outer join          
(          
select  State_Code,District_Code,        
  sum([Total_ANM]) as  Total_ANM,    
  sum(Active_ANM)as [Total_Active_ANM],  
  sum(Distinct_HP_ID) as Distinct_HP_ID,  
  sum(Total_FTD) as Total_FTD,    
  sum(Success_FTD) as [FTD_Success],    
  sum(Failed_FTD) as [FTD_Failure]       
FROM dbo.t_HP_ftd_state_district_month         
where State_Code=@State_Code  
and StartDT_FinYr=@FinancialYr  
and StartDT_month=@Month_ID        
group by State_Code,District_Code        
)           
B on  A.State_Code =B.State_Code and A.District_Code=B.District_Code         
end           
else if(@Category='District')        
Begin        
select A.District_Code as ParentID,A.District_Name as ParentName,'' as ChildID,'' as ChildName          
,ISNULL(Total_ANM,0) as Total_ANM        
,ISNULL(Total_Active_ANM,0) as Total_Active_ANM    
,ISNULL(Distinct_HP_ID,0)as Distinct_HP_ID     
,ISNULL(Total_FTD,0)as Total_FTD        
,ISNULL(FTD_Success,0) as FTD_Success        
,ISNULL(FTD_Failure,0) as FTD_Failure         
from            
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name          
 from TBL_DISTRICT a        
 where a.DIST_CD=@District_Code          
) A          
left outer join          
( select District_Code,        
  sum([Total_ANM]) as  Total_ANM,    
  sum(Active_ANM)as [Total_Active_ANM],  
    sum(Distinct_HP_ID) as Distinct_HP_ID,    
  sum(Total_FTD) as Total_FTD,    
  sum(Success_FTD) as [FTD_Success],    
  sum(Failed_FTD) as [FTD_Failure]    
  FROM dbo.t_HP_ftd_district_block_month         
  where (District_Code=@District_Code)  
  and StartDT_FinYr=@FinancialYr  
  and StartDT_month=@Month_ID             
  group by District_Code        
) B on A.District_Code=B.District_Code         
end        
--else if(@Category='Block')        
--Begin        
--select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName        
--,ISNULL(Total_ANM,0) as Total_ANM        
--,ISNULL(Total_Active_ANM,0) as Total_Active_ANM        
--,ISNULL(ANM_FTD,0)as ANM_FTD        
--,ISNULL(FTD_Success,0) as FTD_Success        
--,ISNULL(FTD_Failure,0) as FTD_Failure        
-- from          
-- (        
--  select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name        
--  from TBL_PHC  a      
--  inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD        
--  where  a.BID=@HealthBlock_Code         
--) A        
--left outer join        
--(        
--  select HealthBlock_Code,HealthFacility_Code ,      
--  sum([Total_ANM]) as  Total_ANM,    
--  sum(Active_ANM)as [Total_Active_ANM],    sum(Total_FTD) as [ANM_FTD],    
--  sum(Success_FTD) as [FTD_Success],    
--  sum(Failed_FTD) as [FTD_Failure]       
--  FROM dbo.t_HP_ftd_block_phc_month a        
--  where (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)        
--  and (HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0)        
--  group by HealthBlock_Code,HealthFacility_Code        
--)  B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code        
--end            
--else if(@Category='PHC' )        
--Begin        
--select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName        
--,ISNULL(Total_ANM,0) as Total_ANM        
--,ISNULL(Total_Active_ANM,0) as Total_Active_ANM        
--,ISNULL(ANM_FTD,0)as ANM_FTD        
--,ISNULL(FTD_Success,0) as FTD_Success        
--,ISNULL(FTD_Failure,0) as FTD_Failure           
--from         
-- (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name        
--  from TBL_SUBPHC a        
--  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD        
--  where (a.PHC_CD= @HealthFacility_Code)        
--  and (a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)        
--) A        
--left outer join        
--(        
-- select HealthFacility_Code,HealthSubFacility_Code,        
--  sum([Total_ANM]) as  Total_ANM,    
--  sum(Active_ANM)as [Total_Active_ANM],    
--  sum(Total_FTD) as [ANM_FTD],    
--  sum(Success_FTD) as [FTD_Success],    
--  sum(Failed_FTD) as [FTD_Failure]          
--  FROM dbo.t_HP_ftd_phc_sc_month         
--  where (HealthFacility_Code=@HealthFacility_Code)        
--  and (HealthFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
--  group by HealthFacility_Code,HealthSubFacility_Code            
--  )  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code        
--end            
--else if(@Category='SubCentre')        
--Begin        
--select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName        
--,ISNULL(Total_ANM,0) as Total_ANM        
--,ISNULL(Total_Active_ANM,0) as Total_Active_ANM        
--,ISNULL(ANM_FTD,0)as ANM_FTD        
--,ISNULL(FTD_Success,0) as FTD_Success        
--,ISNULL(FTD_Failure,0) as FTD_Failure          
--from         
-- (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name        
--  from TBL_SUBPHC a        
--  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD        
--  where (a.PHC_CD= @HealthFacility_Code)        
--  and (a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)        
--  union        
--  select a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name ,0 as HealthSubFacility_Code,'Direct Entry' as HealthSubFacility_Name        
--  from TBL_PHC a         
--  where (a.PHC_CD= @HealthFacility_Code)        
--) A        
--left outer join        
--(        
-- select HealthFacility_Code,HealthSubFacility_Code,    
--  sum([Total_ANM]) as  Total_ANM,    
--  sum(Active_ANM)as [Total_Active_ANM],    
--  sum(Total_FTD) as [ANM_FTD],    
--  sum(Success_FTD) as [FTD_Success],    
--  sum(Failed_FTD) as [FTD_Failure]        
--  FROM dbo.t_HP_ftd_sc_village_month         
--  where (HealthFacility_Code=@HealthFacility_Code)        
--  and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
--  group by HealthFacility_Code,HealthSubFacility_Code           
--  )  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code        
--end           
END        
        

