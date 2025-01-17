USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Daily_Reporting_Status]    Script Date: 09/26/2024 11:46:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
ALTER procedure [dbo].[AC_Daily_Reporting_Status]                    
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
@Category varchar(20) =''                    
)                    
as                    
begin                    
if(@Category='National')                    
begin                    
 exec RCH_Reports.dbo.AC_Daily_Reporting_Status @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,                    
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category                  
end                    
                  
if(@Category='State')                      
begin                      
select  A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,                
isNull(B.Total_EC_Reg,0) as Total_EC_Registered,                
isNull(C.Total_EC_1Days,0) as Total_EC_Registered_Today,                
isNuLL(D.Total_EC_30Days,0) as Total_EC_Registered_Last_30days,                
isNuLL(C.Total_EC_Service_1Day,0) as Total_EC_Service_Today,                
isNuLL(D.Total_EC_Service_30Day,0)as Total_EC_Service_Last_30days,                
                
isNuLL(B.Total_Mother_Reg,0) as Total_PW_Registered,                
isNuLL(C.Total_Mother_1Days,0) as Total_PW_Registered_Today,                
isNuLL(D.Total_Mother_30Days,0) as Total_PW_Registered_Last_30days,                
isNuLL(C.Total_Mother_Service_1Day,0) as Total_PW_Service_Today,                
isNuLL(D.Total_Mother_Service_30Day,0) as Total_PW_Service_Last_30days,                
                
isNuLL(B.Total_Infant_Reg,0) as Total_Infant_Registered,                
isNuLL(C.Total_Infant_1Days,0) as Total_Infant_Registered_Today,                
isNuLL(D.Total_Infant_30Days,0) as Total_Infant_Registered_Last_30days,                
isNuLL(C.Total_Child_Service_1Day,0) as Total_Infant_Service_Today,                
isNuLL(D.Total_Child_Service_30Day,0) as Total_Infant_Service_Last_30days,
isNuLL(C.Total_RC_Count_1Day,0) as Total_RC_Count_1Day,                
isNuLL(D.Total_RC_Count_30Day,0) as Total_RC_Count_30Day   
            
from                
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                   
from TBL_DISTRICT a                    
inner join TBL_STATE b on a.StateID=b.StateID                    
where b.StateID=@State_Code         
)A                
left outer join                
(select c.StateID,c.District_ID,                   
 SUM(c.Mother_Total_Count) as Total_Mother_Reg                    
,SUM(c.Child_Total_Count)  as Total_Infant_Reg                   
,SUM(c.EC_Total_Count)  as Total_EC_Reg                   
from  Scheduled_DB_State_District_Count c                 
where c.Financial_Year=@FinancialYr                
and c.StateID=@State_Code   
 group by c.StateID,c.District_ID                
)B on A.State_Code=B.StateID and A.District_Code=B.District_ID                
left outer join                
(                
select c.StateID as State_Code,c.District_ID as District_Code                
,c.Mother_Total_Count as Total_Mother_1Days      
,c.Child_Total_Count  as Total_Infant_1Days                   
,c.EC_Total_Count  as Total_EC_1Days                 
,c.ECT_Count as Total_EC_Service_1Day                 
,(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_1Day                 
,(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_1Day
,(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_1Day                  
from Scheduled_DB_State_District_Count c                
where c.Financial_Year=@FinancialYr                   
and c.StateID=@State_Code       
and Created_Date between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())                
)C on A.State_Code=C.State_Code and A.District_Code=C.District_Code                  
left outer join                
(                
select c.StateID as State_Code,c.District_ID as District_Code                
,SUM(c.Mother_Total_Count) as Total_Mother_30Days                    
,SUM(c.Child_Total_Count)  as Total_Infant_30Days                   
,SUM(c.EC_Total_Count)  as Total_EC_30Days                
,SUM(c.ECT_Count) as Total_EC_Service_30Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_30Day                 
,SUM(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_30Day 
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_30Day                    
from Scheduled_DB_State_District_Count c                
where c.Financial_Year=@FinancialYr                   
and c.StateID=@State_Code      
and Created_Date between CONVERT(date, GETDATE()-30) and CONVERT(date,GETDATE())                
group by c.StateID,c.District_ID                
)D on A.State_Code=D.State_Code and A.District_Code=D.District_Code                    
                    
end                    
else if(@Category='District')                      
begin                      
select  A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                
isNull(B.Total_EC_Reg,0) as Total_EC_Registered,                
isNull(C.Total_EC_1Days,0) as Total_EC_Registered_Today,                
isNuLL(D.Total_EC_30Days,0) as Total_EC_Registered_Last_30days,                
isNuLL(C.Total_EC_Service_1Day,0) as Total_EC_Service_Today,                
isNuLL(D.Total_EC_Service_30Day,0)as Total_EC_Service_Last_30days,                
                
isNuLL(B.Total_Mother_Reg,0) as Total_PW_Registered,                
isNuLL(C.Total_Mother_1Days,0) as Total_PW_Registered_Today,                
isNuLL(D.Total_Mother_30Days,0) as Total_PW_Registered_Last_30days,                
isNuLL(C.Total_Mother_Service_1Day,0) as Total_PW_Service_Today,                
isNuLL(D.Total_Mother_Service_30Day,0) as Total_PW_Service_Last_30days,                
                
isNuLL(B.Total_Infant_Reg,0) as Total_Infant_Registered,                
isNuLL(C.Total_Infant_1Days,0) as Total_Infant_Registered_Today,                
isNuLL(D.Total_Infant_30Days,0) as Total_Infant_Registered_Last_30days,                
isNuLL(C.Total_Child_Service_1Day,0) as Total_Infant_Service_Today,                
isNuLL(D.Total_Child_Service_30Day,0) as Total_Infant_Service_Last_30days,
isNuLL(C.Total_RC_Count_1Day,0) as Total_RC_Count_1Day,                
isNuLL(D.Total_RC_Count_30Day,0) as Total_RC_Count_30Day                  
from                
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                    
from TBL_HEALTH_BLOCK a                    
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD                     
where a.DISTRICT_CD=@District_Code                
)A                
left outer join                
(select c.District_ID,c.HealthBlock_ID,                   
 SUM(c.Mother_Total_Count) as Total_Mother_Reg                    
,SUM(c.Child_Total_Count)  as Total_Infant_Reg                   
,SUM(c.EC_Total_Count)  as Total_EC_Reg                   
from  Scheduled_DB_District_Block_Count c                   
where c.Financial_Year=@FinancialYr                     
and c.District_ID=@District_Code           
group by c.District_ID,c.HealthBlock_ID                
)B on A.District_Code=B.District_ID and A.HealthBlock_Code=B.HealthBlock_ID                
left outer join                
(                
select c.District_ID as District_Code,c.HealthBlock_ID                  
,c.Mother_Total_Count as Total_Mother_1Days          
,c.Child_Total_Count  as Total_Infant_1Days                   
,c.EC_Total_Count  as Total_EC_1Days                 
,c.ECT_Count as Total_EC_Service_1Day                 
,(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_1Day                 
,(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_1Day
,(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_1Day                   
 from Scheduled_DB_District_Block_Count c                
where c.Financial_Year=@FinancialYr                   
and c.District_ID=@District_Code               
and Created_Date between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())                
)C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_ID                
left outer join                
(                
select c.District_ID as District_Code,c.HealthBlock_ID as HealthBlock_Code                
,SUM( c.Mother_Total_Count) as Total_Mother_30Days                    
,SUM( c.Child_Total_Count)  as Total_Infant_30Days                   
,SUM( c.EC_Total_Count)  as Total_EC_30Days                
,SUM(c.ECT_Count) as Total_EC_Service_30Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_30Day                 
,SUM(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_30Day  
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_30Day                 
from Scheduled_DB_District_Block_Count c                
where c.Financial_Year=@FinancialYr                    
and c.District_ID=@District_Code            
and Created_Date between CONVERT(date, GETDATE()-30) and CONVERT(date,GETDATE())                
group by c.District_ID,HealthBlock_ID                
)D on A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code                     
end                    
else if(@Category='Block')                      
begin                      
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName ,                   
isNull(B.Total_EC_Reg,0) as Total_EC_Registered,                
isNull(C.Total_EC_1Days,0) as Total_EC_Registered_Today,                
isNuLL(D.Total_EC_30Days,0) as Total_EC_Registered_Last_30days,                
isNuLL(C.Total_EC_Service_1Day,0) as Total_EC_Service_Today,                
isNuLL(D.Total_EC_Service_30Day,0)as Total_EC_Service_Last_30days,                
                
isNuLL(B.Total_Mother_Reg,0) as Total_PW_Registered,                
isNuLL(C.Total_Mother_1Days,0) as Total_PW_Registered_Today,                
isNuLL(D.Total_Mother_30Days,0) as Total_PW_Registered_Last_30days,                
isNuLL(C.Total_Mother_Service_1Day,0) as Total_PW_Service_Today,                
isNuLL(D.Total_Mother_Service_30Day,0) as Total_PW_Service_Last_30days,                
                
isNuLL(B.Total_Infant_Reg,0) as Total_Infant_Registered,                
isNuLL(C.Total_Infant_1Days,0) as Total_Infant_Registered_Today,                
isNuLL(D.Total_Infant_30Days,0) as Total_Infant_Registered_Last_30days,                
isNuLL(C.Total_Child_Service_1Day,0) as Total_Infant_Service_Today,                
isNuLL(D.Total_Child_Service_30Day,0) as Total_Infant_Service_Last_30days,
isNuLL(C.Total_RC_Count_1Day,0) as Total_RC_Count_1Day,                
isNuLL(D.Total_RC_Count_30Day,0) as Total_RC_Count_30Day                   
from                
(select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                    
from TBL_PHC a                    
  inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD                
  inner join TBL_DISTRICT C on a.DIST_CD=C.DIST_CD                     
where a.BID=@HealthBlock_Code                 
)A                
left outer join                
(select c.HealthBlock_ID,c.PHC_ID,                   
 SUM(c.Mother_Total_Count) as Total_Mother_Reg                    
,SUM(c.Child_Total_Count)  as Total_Infant_Reg                   
,SUM(c.EC_Total_Count)  as Total_EC_Reg                   
from  Scheduled_DB_Block_PHC_Count c                 
where c.Financial_Year=@FinancialYr                     
and c.HealthBlock_ID=@HealthBlock_Code   
group by c.HealthBlock_ID,c.PHC_ID                
)B on A.HealthBlock_Code=B.HealthBlock_ID and A.HealthFacility_Code=B.PHC_ID                
left outer join                
(                
select c.HealthBlock_ID,c.PHC_ID                
,c.Mother_Total_Count as Total_Mother_1Days                    
,c.Child_Total_Count  as Total_Infant_1Days                   
,c.EC_Total_Count  as Total_EC_1Days                 
,c.ECT_Count as Total_EC_Service_1Day                 
,(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_1Day                 
,(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_1Day 
,(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_1Day                 
from Scheduled_DB_Block_PHC_Count c                
where c.Financial_Year=@FinancialYr                    
and c.HealthBlock_ID=@HealthBlock_Code    
and Created_Date between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())                
)C on A.HealthBlock_Code=C.HealthBlock_ID and A.HealthFacility_Code=C.PHC_ID                 
left outer join                
(                
select c.HealthBlock_ID,c.PHC_ID                
,SUM( c.Mother_Total_Count) as Total_Mother_30Days                    
,SUM( c.Child_Total_Count)  as Total_Infant_30Days                   
,SUM( c.EC_Total_Count) as Total_EC_30Days                
,SUM(c.ECT_Count) as Total_EC_Service_30Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_30Day                 
,SUM(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_30Day 
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_30Day                    
from Scheduled_DB_Block_PHC_Count c                
where c.Financial_Year=@FinancialYr                   
and c.HealthBlock_ID=@HealthBlock_Code              
and Created_Date between CONVERT(date, GETDATE()-30) and CONVERT(date,GETDATE())                
group by c.HealthBlock_ID,c.PHC_ID                
)D on A.HealthBlock_Code=D.HealthBlock_ID and A.HealthFacility_Code=D.PHC_ID                       
 end                     
else if(@Category='PHC')                      
begin                      
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName ,                
isNull(B.Total_EC_Reg,0) as Total_EC_Registered,                
isNull(C.Total_EC_1Days,0) as Total_EC_Registered_Today,                
isNuLL(D.Total_EC_30Days,0) as Total_EC_Registered_Last_30days,                
isNuLL(C.Total_EC_Service_1Day,0) as Total_EC_Service_Today,                
isNuLL(D.Total_EC_Service_30Day,0)as Total_EC_Service_Last_30days,                
                
isNuLL(B.Total_Mother_Reg,0) as Total_PW_Registered,                
isNuLL(C.Total_Mother_1Days,0) as Total_PW_Registered_Today,                
isNuLL(D.Total_Mother_30Days,0) as Total_PW_Registered_Last_30days,                
isNuLL(C.Total_Mother_Service_1Day,0) as Total_PW_Service_Today,                
isNuLL(D.Total_Mother_Service_30Day,0) as Total_PW_Service_Last_30days,                
                
isNuLL(B.Total_Infant_Reg,0) as Total_Infant_Registered,                
isNuLL(C.Total_Infant_1Days,0) as Total_Infant_Registered_Today,                
isNuLL(D.Total_Infant_30Days,0) as Total_Infant_Registered_Last_30days,                
isNuLL(C.Total_Child_Service_1Day,0) as Total_Infant_Service_Today,                
isNuLL(D.Total_Child_Service_30Day,0) as Total_Infant_Service_Last_30days,
isNuLL(C.Total_RC_Count_1Day,0) as Total_RC_Count_1Day,                
isNuLL(D.Total_RC_Count_30Day,0) as Total_RC_Count_30Day                   
from                
(select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                
from TBL_SUBPHC a                    
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                
where a.PHC_CD= @HealthFacility_Code                 
)A                
left outer join                
(select c.PHC_ID,c.SubCentre_ID                  
,SUM(c.Mother_Total_Count) as Total_Mother_Reg                    
,SUM(c.Child_Total_Count)  as Total_Infant_Reg            
,SUM(c.EC_Total_Count)  as Total_EC_Reg            
from  Scheduled_DB_PHC_SC_Village_Count c                 
where c.Financial_Year=@FinancialYr                     
and c.PHC_ID=@HealthFacility_Code    
group by c.PHC_ID,c.SubCentre_ID               
)B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.SubCentre_ID                 
left outer join              
(                
select c.PHC_ID,c.SubCentre_ID    
,SUM(c.Mother_Total_Count) as Total_Mother_1Days                    
,SUM(c.Child_Total_Count)  as Total_Infant_1Days                   
,SUM(c.EC_Total_Count)  as Total_EC_1Days                 
,SUM(c.ECT_Count) as Total_EC_Service_1Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_1Day                 
,SUM(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_1Day
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_1Day                  
from Scheduled_DB_PHC_SC_Village_Count c                
where c.Financial_Year=@FinancialYr                    
and c.PHC_ID=@HealthFacility_Code   
and Created_Date between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())       
group by c.PHC_ID,c.SubCentre_ID             
)C on A.HealthFacility_Code=C.PHC_ID and A.HealthSubFacility_Code=C.SubCentre_ID                   
left outer join                
(                
select c.PHC_ID,c.SubCentre_ID             
,SUM( c.Mother_Total_Count) as Total_Mother_30Days                    
,SUM( c.Child_Total_Count)  as Total_Infant_30Days                   
,SUM( c.EC_Total_Count)  as Total_EC_30Days                
,SUM(c.ECT_Count) as Total_EC_Service_30Day                   
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_30Day                       
,sum(ISNULL(c.CHT_Count,0) + ISNULL(c.CPNC_Count,0) + ISNULL(c.CTM_Count,0)) as Total_Child_Service_30Day                  
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_30Day                  
from Scheduled_DB_PHC_SC_Village_Count c                
where c.Financial_Year=@FinancialYr                
and c.PHC_ID=@HealthFacility_Code        
and Created_Date between CONVERT(date, GETDATE()-30) and CONVERT(date,GETDATE())                
group by c.PHC_ID,c.SubCentre_ID                
)D on A.HealthFacility_Code=D.PHC_ID and A.HealthSubFacility_Code=D.SubCentre_ID                    
                     
end                      
else if(@Category='SubCentre')                      
begin                      
select A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,                  
isNull(B.Total_EC_Reg,0) as Total_EC_Registered,                
isNull(C.Total_EC_1Days,0) as Total_EC_Registered_Today,                
isNuLL(D.Total_EC_30Days,0) as Total_EC_Registered_Last_30days,                
isNuLL(C.Total_EC_Service_1Day,0) as Total_EC_Service_Today,                
isNuLL(D.Total_EC_Service_30Day,0)as Total_EC_Service_Last_30days,                
                
isNuLL(B.Total_Mother_Reg,0) as Total_PW_Registered,                
isNuLL(C.Total_Mother_1Days,0) as Total_PW_Registered_Today,                
isNuLL(D.Total_Mother_30Days,0) as Total_PW_Registered_Last_30days,                
isNuLL(C.Total_Mother_Service_1Day,0) as Total_PW_Service_Today,                
isNuLL(D.Total_Mother_Service_30Day,0) as Total_PW_Service_Last_30days,                
                
isNuLL(B.Total_Infant_Reg,0) as Total_Infant_Registered,                
isNuLL(C.Total_Infant_1Days,0) as Total_Infant_Registered_Today,                
isNuLL(D.Total_Infant_30Days,0) as Total_Infant_Registered_Last_30days,                
isNuLL(C.Total_Child_Service_1Day,0) as Total_Infant_Service_Today,                
isNuLL(D.Total_Child_Service_30Day,0) as Total_Infant_Service_Last_30days,
isNuLL(C.Total_RC_Count_1Day,0) as Total_RC_Count_1Day,                
isNuLL(D.Total_RC_Count_30Day,0) as Total_RC_Count_30Day                  
from                
(                
 select v.SID as HealthSubFacility_Code,isnull(v.VCode,0) as Village_Code,sp.SUBPHC_NAME_E as HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name                  
 from Health_SC_Village v                   
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=v.VCode and vn.SUBPHC_CD=v.SID                  
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=v.SID                  
 where sp.SUBPHC_CD=@HealthSubFacility_Code                               
 )  A                 
left outer join                
(select c.Village_ID,c.SubCentre_ID,                   
 SUM(c.Mother_Total_Count) as Total_Mother_Reg                    
,SUM(c.Child_Total_Count)  as Total_Infant_Reg                   
,SUM(c.EC_Total_Count)  as Total_EC_Reg                   
from  Scheduled_DB_PHC_SC_Village_Count c                 
where c.Financial_Year=@FinancialYr                   
and c.SubCentre_ID=@HealthSubFacility_Code          
group by c.SubCentre_ID,c.Village_ID               
)B on  A.HealthSubFacility_Code=B.SubCentre_ID and A.Village_Code=B.Village_ID                    
left outer join                
(                
select c.Village_ID,c.SubCentre_ID                
,SUM(c.Mother_Total_Count) as Total_Mother_1Days                    
,SUM(c.Child_Total_Count)  as Total_Infant_1Days                   
,SUM(c.EC_Total_Count)  as Total_EC_1Days                 
,SUM(c.ECT_Count) as Total_EC_Service_1Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_1Day                 
,SUM(isnull(c.CHT_Count,0)+isnull(c.CPNC_Count,0)+isnull(c.CTM_Count,0))as Total_Child_Service_1Day
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_1Day                  
from Scheduled_DB_PHC_SC_Village_Count c                
where c.Financial_Year=@FinancialYr                   
and c.SubCentre_ID=@HealthSubFacility_Code          
and Created_Date between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())      
group by c.SubCentre_ID,c.Village_ID                  
)                
C on  A.HealthSubFacility_Code=C.SubCentre_ID and A.Village_Code=C.Village_ID                  
left outer join                
(                
 select c.Village_ID,c.SubCentre_ID                
,SUM( c.Mother_Total_Count) as Total_Mother_30Days                    
,SUM( c.Child_Total_Count)  as Total_Infant_30Days                   
,SUM( c.EC_Total_Count)  as Total_EC_30Days                
,SUM(c.ECT_Count) as Total_EC_Service_30Day                 
,SUM(isnull(c.MA_Count,0)+isnull(c.MD_Count,0)+isnull(c.MPNC_Count,0)) as Total_Mother_Service_30Day                       
,sum(ISNULL(c.CHT_Count,0) + ISNULL(c.CPNC_Count,0) + ISNULL(c.CTM_Count,0)) as Total_Child_Service_30Day 
,SUM(ISNULL(c.RC_Total_Count,0)) as Total_RC_Count_30Day                
from Scheduled_DB_PHC_SC_Village_Count c                
where c.Financial_Year=@FinancialYr                   
and c.SubCentre_ID=@HealthSubFacility_Code         
and Created_Date between CONVERT(date, GETDATE()-30) and CONVERT(date,GETDATE())                
group by  c.SubCentre_ID,c.Village_ID                 
)D on  A.HealthSubFacility_Code=D.SubCentre_ID and A.Village_Code=D.Village_ID                
end                      
end  
  
