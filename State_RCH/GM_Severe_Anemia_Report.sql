USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[GM_Severe_Anemia_Report]    Script Date: 09/26/2024 14:23:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*  

*/  
ALTER procedure [dbo].[GM_Severe_Anemia_Report] 
(  
@State_Code int=0,  
@District_Code int=0,
@HealthBlock_Code int=0,
@HealthFacility_Code int=0,
@HealthSubFacility_Code int=0,
@Village_Code int=0,
@FinancialYr int=0,
@FromMonth int=0,  
@ToMonth int=0,
@Category varchar(20)='District'
,@PeriodID as int=0
,@FromYear as int=0
,@ToYear as int=0
,@Type_ID as int=0
  
)  
AS  
BEGIN  

if(@Category='State')
begin
select  A.State_Code as Parent_ID,A.District_Code as Child_ID,A.State_Name as Parent_Name,A.District_Name as Child_Name
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total ,isnull(C.Severe_Anemic_Total,0) as Severe_Anemic_Total 
 from
 (
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME as District_Name
from TBL_DISTRICT a
inner join TBL_STATE b on a.StateID=b.StateID
where b.StateID=@State_Code and Is_Backward=1
)  A
left outer join 
(
select MH.State_Code, MH.District_Code
,SUM(Total_LMP)as Registered_PW_Total  
from Scheduled_MH_Tracking_State_District_Month as MH
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID  
where MH.State_Code=@State_Code 
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=1
group by MH.State_Code, MH.District_Code
) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code
left outer join 
(
select MH.State_Code, MH.District_Code
,SUM(Total_LMP)as Severe_Anemic_Total  
from Scheduled_MH_Tracking_State_District_Month as MH
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID  
where MH.State_Code=@State_Code 
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=3
group by MH.State_Code, MH.District_Code
) C on A.State_Code=C.State_Code and A.District_Code=C.District_Code
end     
else if(@Category='District')  
   
begin  
select A.District_Code as Parent_ID,A.HealthBlock_Code as Child_ID,A.District_Name as Parent_Name,A.HealthBlock_Name as Child_Name
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total ,isnull(C.Severe_Anemic_Total,0) as Severe_Anemic_Total 
from   
(select a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name 
from TBL_HEALTH_BLOCK a
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD
where (a.DISTRICT_CD=@District_Code or @District_Code=0)
)  A
left outer join
(select MH.District_Code,MH.HealthBlock_Code
,SUM(Total_LMP)as Registered_PW_Total  
from Scheduled_MH_Tracking_District_Block_Month as MH
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.District_Code= @District_Code
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=1
group by MH.District_Code,MH.HealthBlock_Code) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code
left outer join
(select MH.District_Code,MH.HealthBlock_Code
,SUM(Total_LMP)as Severe_Anemic_Total  
from Scheduled_MH_Tracking_District_Block_Month as MH
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.District_Code= @District_Code
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=3
group by MH.District_Code,MH.HealthBlock_Code) C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code

end  
else if(@Category='Block')  
   
begin  
    ----------------------------------------------------------- Delevery  
       
  
Select A.HealthBlock_Code as Parent_ID,A.HealthFacility_Code as Child_ID,A.HealthBlock_Name as Parent_Name,A.HealthFacility_Name as Child_Name
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total ,isnull(C.Severe_Anemic_Total,0) as Severe_Anemic_Total 
from  
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
from TBL_PHC  a
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
where a.BID=@HealthBlock_Code
)  A 
left outer join
(select MH.HealthBlock_Code,MH.HealthFacility_Code
,SUM(Total_LMP)as Registered_PW_Total  
from Scheduled_MH_Tracking_Block_PHC_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthBlock_Code=@HealthBlock_Code
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=1
group by MH.HealthBlock_Code,MH.HealthFacility_Code) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code 
left outer join
(select MH.HealthBlock_Code,MH.HealthFacility_Code
,SUM(Total_LMP)as Severe_Anemic_Total  
from Scheduled_MH_Tracking_Block_PHC_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthBlock_Code=@HealthBlock_Code
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=3
group by MH.HealthBlock_Code,MH.HealthFacility_Code) C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code 
   
end  
else if(@Category='PHC')  
   
begin  
  
Select A.HealthFacility_Code as Parent_ID,A.HealthSubFacility_Code  as Child_ID,A.HealthFacility_Name as Parent_Name,A.HealthSubFacility_Name as Child_Name
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total ,isnull(C.Severe_Anemic_Total,0) as Severe_Anemic_Total 

from 
(select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
from TBL_SUBPHC a
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
where a.PHC_CD=@HealthFacility_Code
)  A 
left outer join  
(
select MH.HealthFacility_Code,MH.HealthSubFacility_Code
,SUM(Total_LMP)as Registered_PW_Total  
from Scheduled_MH_Tracking_PHC_SubCenter_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthFacility_Code=@HealthFacility_Code   
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=1
group by MH.HealthFacility_Code,MH.HealthSubFacility_Code) B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code 
left outer join  
(
select MH.HealthFacility_Code,MH.HealthSubFacility_Code
,SUM(Total_LMP)as Severe_Anemic_Total  
from Scheduled_MH_Tracking_PHC_SubCenter_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthFacility_Code=@HealthFacility_Code   
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=3
group by MH.HealthFacility_Code,MH.HealthSubFacility_Code) C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code 
end  
else if(@Category='SubCentre')  
   
begin  
  
Select A.HealthSubFacility_Code as Parent_ID,A.Village_Code  as Child_ID,A.HealthSubFacility_Name as Parent_Name,A.Village_Code as Child_Name
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total ,isnull(C.Severe_Anemic_Total,0) as Severe_Anemic_Total 

from 
(select a.HealthSubFacility_Code,b.SUBPHC_NAME as HealthSubFacility_Name ,a.Village_Code,a.VILLAGE_NAME as Village_Name
from Estimated_Data_Village_Wise a
inner join TBL_SUBPHC b on a.HealthSubFacility_Code=b.SUBPHC_CD
left outer join  Village c on a.Village_Code=c.VCode 
where a.Financial_Year=@FinancialYr 
and a.HealthSubFacility_Code= @HealthSubFacility_Code
)  A 
left outer join  
(
select MH.HealthSubFacility_Code,MH.Village_Code
,SUM(Total_LMP)as Registered_PW_Total  
from Scheduled_MH_Tracking_PHC_SubCenter_Village_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthSubFacility_Code=@HealthSubFacility_Code   
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=1
group by MH.HealthSubFacility_Code,MH.Village_Code) B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code 
left outer join  
(
select MH.HealthSubFacility_Code,MH.Village_Code
,SUM(Total_LMP)as Severe_Anemic_Total   
from Scheduled_MH_Tracking_PHC_SubCenter_Village_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthSubFacility_Code=@HealthSubFacility_Code   
--and MH.Fin_Yr=@FinancialYr
and Filter_Type=3
group by MH.HealthSubFacility_Code,MH.Village_Code) C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code 
end  
  
end  



