USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_ABHA_ASHA_Report]    Script Date: 09/26/2024 11:44:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*  
AC_ABHA_ASHA_Report 29,2,0,0,0,0,2022,0,0,'','','District',1  
AC_ABHA_ASHA_Report 29,2,12,0,0,0,2022,0,0,'','','Block',1  
AC_ABHA_ASHA_Report 29,2,12,3,0,0,2022,0,0,'','','PHC',1  
  
  
AC_ABHA_ASHA_Report 28,14,0,0,0,0,2022,0,0,'','','District',1   
*/    
ALTER procedure [dbo].[AC_ABHA_ASHA_Report]                        
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
@Category varchar(20) ='District',              
@Type int =1                        
)                        
as                                          
begin     
SET NOCOUNT ON    
if(@Category='District')      
begin   
Select A.District_Code as ParentID,Rtrim(A.District_Name) as ParentName,A.HealthBlock_Code as ChildID,rTRIM(a.HealthBlock_Name) as ChildName,    
ISNULL(B.ASHA_ID,0) as ASHA_ID,ISNULL(B.Total_ABHA_Registered,0) as Total_ABHA_Registered   
from    
(  
Select a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
from TBL_HEALTH_BLOCK a WITH (NOLOCK)   
inner join TBL_DISTRICT b WITH (NOLOCK) on a.DISTRICT_CD=b.DIST_CD     
where a.DISTRICT_CD=@District_Code    
)A   
left outer join    
(   
select A.District_Code,A.HealthBlock_Code                      
,(Case when d.Name IS NOT NULL then ISNULL(d.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(d.ID,0)) + ')' else '0'  end) as ASHA_ID  
,SUM(Total_ABHA_Registered)Total_ABHA_Registered               
from Scheduled_AC_ASHA_ABHA_Monthwise_Count A (nolock)   
Left outer join t_Ground_Staff d WITH (NOLOCK) on A.ASHA_ID=d.ID                   
where (A.District_Code=@District_Code)  
and (HID_FinYr=@FinancialYr)    
and (Month_ID=@Month_ID or @Month_ID=0)  
group by A.District_Code,A.HealthBlock_Code,d.Name,d.ID     
)B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code   
order by A.District_Name,a.HealthBlock_Name   
end  
else if(@Category='Block')      
begin   
Select A.HealthBlock_Code as ParentID,Rtrim(A.HealthBlock_Name) as ParentName,A.HealthFacility_Code as ChildID,Rtrim(A.HealthFacility_Name) as ChildName,    
ISNULL(B.ASHA_ID,0) as ASHA_ID,ISNULL(B.Total_ABHA_Registered,0) as Total_ABHA_Registered   
from    
(  
select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name      
from TBL_PHC  a WITH (NOLOCK)   
inner join TBL_HEALTH_BLOCK b WITH (NOLOCK) on a.BID=b.BLOCK_CD    
where (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)    
)A   
left outer join    
(   
select A.HealthBlock_Code,A.HealthFacility_Code                      
,(Case when d.Name IS NOT NULL then ISNULL(d.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(d.ID,0)) + ')' else '0'  end) as ASHA_ID
,SUM(Total_ABHA_Registered) Total_ABHA_Registered               
from Scheduled_AC_ASHA_ABHA_Monthwise_Count A (nolock)  
Left outer join t_Ground_Staff d WITH (NOLOCK) on A.ASHA_ID=d.ID                     
where (A.HealthBlock_Code = @HealthBlock_Code)  
and (HID_FinYr=@FinancialYr)    
and (Month_ID=@Month_ID or @Month_ID=0)   
group by A.HealthBlock_Code,A.HealthFacility_Code,d.Name,d.ID   
)B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code   
order by A.HealthBlock_Code,A.HealthFacility_Code  
end   
else if(@Category='PHC')      
begin   
Select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,Rtrim(A.HealthFacility_Name) as ParentName,Rtrim(A.HealthSubFacility_Name) as ChildName,    
ISNULL(B.ASHA_ID,0) as ASHA_ID,ISNULL(B.Total_ABHA_Registered,0) as Total_ABHA_Registered   
from    
(  
select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                  
from TBL_SUBPHC a                      
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                  
where a.PHC_CD= @HealthFacility_Code     
)A   
left outer join    
(   
select a.HealthFacility_Code,a.HealthSubFacility_Code   
,(Case when d.Name IS NOT NULL then ISNULL(d.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(d.ID,0)) + ')' else '0'  end) as ASHA_ID
,SUM(Total_ABHA_Registered) Total_ABHA_Registered             
from Scheduled_AC_ASHA_ABHA_Monthwise_Count A (nolock)  
Left outer join t_Ground_Staff d WITH (NOLOCK) on A.ASHA_ID=d.ID                     
where a.HealthFacility_Code=@HealthFacility_Code      
and (HID_FinYr=@FinancialYr)    
and (Month_ID=@Month_ID or @Month_ID=0)   
group by a.HealthFacility_Code,a.HealthSubFacility_Code,d.Name,d.ID  
)B on  A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code  
order by a.HealthFacility_Code,a.HealthSubFacility_Code  
end       
END    