USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Workplan_log_Report]    Script Date: 09/26/2024 14:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[Workplan_log_Report] 30,0,0,0,0,0,2018,4,0,'','','State',1
[Workplan_log_Report] 30,1,0,0,0,0,2018,0,0,'','','District',1  
[Workplan_log_Report] 30,1,3,0,0,0,2019,0,0,'','','Block',1  
[Workplan_log_Report] 30,1,3,11,0,0,2019,0,0,'','','PHC',1  
[Workplan_log_Report] 30,1,3,11,35,0,2018,0,0,'','','SubCentre',1  


*/

ALTER procedure [dbo].[Workplan_log_Report]
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
@Type int=1
)
as
begin
if(@Category='State')  
begin 
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,
isnull(Workplan_for_ANC,0) as Workplan_for_ANC,
isnull(Workplan_for_Delivery,0) as Workplan_for_Delivery,
isnull(Workplan_for_PNC,0) as Workplan_for_PNC,
isnull(Workplan_for_Child_Immunization,0) as Workplan_for_Child_Immunization,
isnull(Workplan_for_Infant_Immunization,0) as Workplan_for_Infant_Immunization,
isnull(Workplan_by_HealthProvider_ID,0) as Workplan_by_HealthProvider_ID,
isnull(Workplan_by_Beneficiary_ID,0) as Workplan_by_Beneficiary_ID,
isnull(Facility_Wise_Workplan_PW_All,0) as Facility_Wise_Workplan_PW_All,
isnull(Workplan_for_Special_Round_IMI,0) as Workplan_for_Special_Round_IMI
from
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG  as District_Name

	from TBL_DISTRICT (nolock) a
	inner join TBL_STATE (nolock)  b on a.StateID=b.StateID

	and b.StateID=@State_Code and (a.DIST_CD=0 or 0=0)
)  A
left outer join
(

select state_id ,District_code,

isnull(sum(case when TypeOfService=1 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_ANC,
ISNULL(SUM(case when typeofservice=2 and WorkPlan_Type=1  then workplan_hitcount end),0) as Workplan_for_Delivery,
isnull(sum(case when (TypeOfService=3 or TypeOfService=5) and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_PNC,
isnull(sum(case when  WorkPlan_Type=4 or WorkPlan_Type=3 then workPlan_hitCount end),0) as Workplan_for_Child_Immunization,
isnull(sum(case when  WorkPlan_Type=2 then workPlan_hitCount end),0) as Workplan_for_Infant_Immunization,
isnull(sum(case when TypeOfService=6 then workPlan_hitCount end),0) as Workplan_by_HealthProvider_ID,
isnull(sum(case when TypeOfService=7 then workPlan_hitCount end),0) as Workplan_by_Beneficiary_ID,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Facility_Wise_Workplan_PW_All,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=5 then workPlan_hitCount end),0) as Workplan_for_Special_Round_IMI
 from t_Workplan_log (nolock) where State_ID=@State_Code and WorkPlan_year=@FinancialYr 
and (WorkPlan_month=@Month_ID or @Month_ID=0)
group by State_ID,District_code
 )B on A.State_Code=B.State_ID and A.District_Code=B.District_Code
end

Else if(@Category='District')  
begin 
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID
,  a.HealthBlock_Name  as ChildName,
isnull(Workplan_for_ANC,0) as Workplan_for_ANC,
isnull(Workplan_for_Delivery,0) as Workplan_for_Delivery,
isnull(Workplan_for_PNC,0) as Workplan_for_PNC,
isnull(Workplan_for_Child_Immunization,0) as Workplan_for_Child_Immunization,
isnull(Workplan_for_Infant_Immunization,0) as Workplan_for_Infant_Immunization,
isnull(Workplan_by_HealthProvider_ID,0) as Workplan_by_HealthProvider_ID,
isnull(Workplan_by_Beneficiary_ID,0) as Workplan_by_Beneficiary_ID,
isnull(Facility_Wise_Workplan_PW_All,0) as Facility_Wise_Workplan_PW_All,
isnull(Workplan_for_Special_Round_IMI,0) as Workplan_for_Special_Round_IMI
from
(
select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name 
	
	from TBL_HEALTH_BLOCK a
	inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD
	and a.DISTRICT_CD=@District_Code
)  A
left outer join
(

select state_id ,District_code,HealthBlock_Code,

isnull(sum(case when TypeOfService=1 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_ANC,
ISNULL(SUM(case when typeofservice=2 and WorkPlan_Type=1  then workplan_hitcount end),0) as Workplan_for_Delivery,
isnull(sum(case when (TypeOfService=3 or TypeOfService=5) and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_PNC,
isnull(sum(case when  WorkPlan_Type=4 or WorkPlan_Type=3 then workPlan_hitCount end),0) as Workplan_for_Child_Immunization,
isnull(sum(case when  WorkPlan_Type=2 then workPlan_hitCount end),0) as Workplan_for_Infant_Immunization,
isnull(sum(case when TypeOfService=6 then workPlan_hitCount end),0) as Workplan_by_HealthProvider_ID,
isnull(sum(case when TypeOfService=7 then workPlan_hitCount end),0) as Workplan_by_Beneficiary_ID,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Facility_Wise_Workplan_PW_All,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=5 then workPlan_hitCount end),0) as Workplan_for_Special_Round_IMI
 from t_Workplan_log (nolock) where  State_ID=@State_Code and District_code=@District_Code and WorkPlan_year=@FinancialYr and (WorkPlan_month=@Month_ID or @Month_ID=0) group by State_ID,District_code,HealthBlock_Code
 )B on A.HealthBlock_Code=B.HealthBlock_Code and A.District_Code=B.District_Code
end


Else if(@Category='Block')  
begin 
select @State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID, A.HealthFacility_Name   as ChildName,
isnull(Workplan_for_ANC,0) as Workplan_for_ANC,
isnull(Workplan_for_Delivery,0) as Workplan_for_Delivery,
isnull(Workplan_for_PNC,0) as Workplan_for_PNC,
isnull(Workplan_for_Child_Immunization,0) as Workplan_for_Child_Immunization,
isnull(Workplan_for_Infant_Immunization,0) as Workplan_for_Infant_Immunization,
isnull(Workplan_by_HealthProvider_ID,0) as Workplan_by_HealthProvider_ID,
isnull(Workplan_by_Beneficiary_ID,0) as Workplan_by_Beneficiary_ID,
isnull(Facility_Wise_Workplan_PW_All,0) as Facility_Wise_Workplan_PW_All,
isnull(Workplan_for_Special_Round_IMI,0) as Workplan_for_Special_Round_IMI
from
(
select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name

     from TBL_PHC  a
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD

	 and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)
	 
	 union select  HealthBlock_code,Block_Name_E ,isnull( HealthFacility_Code,0)as PHC_CD,'Workplan Direct at Block' as HealthFacility_Name   from t_Workplan_log w  inner join TBL_HEALTH_BLOCK w1 on w.HealthBlock_code=w1.BLOCK_CD where HealthBlock_code=@HealthBlock_Code  and HealthFacility_Code=0
)  A
left outer join
(

select state_id ,District_code,HealthBlock_Code,HealthFacility_Code,

isnull(sum(case when TypeOfService=1 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_ANC,
ISNULL(SUM(case when typeofservice=2 and WorkPlan_Type=1  then workplan_hitcount end),0) as Workplan_for_Delivery,
isnull(sum(case when (TypeOfService=3 or TypeOfService=5) and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_PNC,
isnull(sum(case when  WorkPlan_Type=4 or WorkPlan_Type=3 then workPlan_hitCount end),0) as Workplan_for_Child_Immunization,
isnull(sum(case when  WorkPlan_Type=2 then workPlan_hitCount end),0) as Workplan_for_Infant_Immunization,
isnull(sum(case when TypeOfService=6 then workPlan_hitCount end),0) as Workplan_by_HealthProvider_ID,
isnull(sum(case when TypeOfService=7 then workPlan_hitCount end),0) as Workplan_by_Beneficiary_ID,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Facility_Wise_Workplan_PW_All,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=5 then workPlan_hitCount end),0) as Workplan_for_Special_Round_IMI
 from t_Workplan_log (nolock) where  State_ID=@State_Code and District_code=@District_Code and  HealthBlock_Code =@HealthBlock_Code   and WorkPlan_year=@FinancialYr and (WorkPlan_month=@Month_ID or @Month_ID=0) group by State_ID,District_code,HealthBlock_Code,HealthFacility_Code
 )B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code order by ChildID desc
end


Else if(@Category='PHC')  
begin 
select @State_Code,ISNULL(A.HealthFacility_Code,@HealthFacility_Code) as  ParentID,isnull(A.HealthSubFacility_Code,0) as ChildID,A.HealthFacility_Name as ParentName,  A.HealthSubFacility_Name as ChildName,
isnull(Workplan_for_ANC,0) as Workplan_for_ANC,
isnull(Workplan_for_Delivery,0) as Workplan_for_Delivery,
isnull(Workplan_for_PNC,0) as Workplan_for_PNC,
isnull(Workplan_for_Child_Immunization,0) as Workplan_for_Child_Immunization,
isnull(Workplan_for_Infant_Immunization,0) as Workplan_for_Infant_Immunization,
isnull(Workplan_by_HealthProvider_ID,0) as Workplan_by_HealthProvider_ID,
isnull(Workplan_by_Beneficiary_ID,0) as Workplan_by_Beneficiary_ID,
isnull(Facility_Wise_Workplan_PW_All,0) as Facility_Wise_Workplan_PW_All,
isnull(Workplan_for_Special_Round_IMI,0) as Workplan_for_Special_Round_IMI
from
(
select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name
	from Estimated_Data_SubCenter_Wise a
	inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD
	left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD 
	where a.Financial_Year=@FinancialYr 
	and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)
	
	union select State_ID, HealthFacility_Code,PHC_NAME ,isnull( HealthSubFacility_Code,0)as HealthSubFacility_Code,'Workplan Direct at Facility' as HealthSubFacility_Name   from t_Workplan_log w  inner join TBL_PHC w1 on w.HealthFacility_Code=w1.PHC_CD where HealthFacility_Code=@HealthFacility_Code  and HealthSubFacility_Code=0
)  A
left outer join
(

select state_id ,District_code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code,

isnull(sum(case when TypeOfService=1 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_ANC,
ISNULL(SUM(case when typeofservice=2 and WorkPlan_Type=1  then workplan_hitcount end),0) as Workplan_for_Delivery,
isnull(sum(case when (TypeOfService=3 or TypeOfService=5) and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_PNC,
isnull(sum(case when  WorkPlan_Type=4 or WorkPlan_Type=3 then workPlan_hitCount end),0) as Workplan_for_Child_Immunization,
isnull(sum(case when  WorkPlan_Type=2 then workPlan_hitCount end),0) as Workplan_for_Infant_Immunization,
isnull(sum(case when TypeOfService=6 then workPlan_hitCount end),0) as Workplan_by_HealthProvider_ID,
isnull(sum(case when TypeOfService=7 then workPlan_hitCount end),0) as Workplan_by_Beneficiary_ID,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Facility_Wise_Workplan_PW_All,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=5 then workPlan_hitCount end),0) as Workplan_for_Special_Round_IMI
 from t_Workplan_log (nolock) where  State_ID=@State_Code and District_code=@District_Code and  HealthBlock_Code =@HealthBlock_Code  and HealthFacility_Code=@HealthFacility_Code  and WorkPlan_year=@FinancialYr and (WorkPlan_month=@Month_ID or @Month_ID=0) group by State_ID,District_code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code
 )B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.HealthFacility_Code=B.HealthFacility_Code  order by ChildID desc
end

Else if(@Category='SubCentre')  
begin 
select isnull(A.HealthSubFacility_Code,b.HealthSubFacility_Code) as  ParentID,isnull(A.Health_Provider_ID,0) as ChildID, isnull(A.HealthSubFacility_Name,c.SUBPHC_NAME_E) as ParentName,isnull(A.Health_Provider_Name,'All') as ChildName,
isnull(Workplan_for_ANC,0) as Workplan_for_ANC,
isnull(Workplan_for_Delivery,0) as Workplan_for_Delivery,
isnull(Workplan_for_PNC,0) as Workplan_for_PNC,
isnull(Workplan_for_Child_Immunization,0) as Workplan_for_Child_Immunization,
isnull(Workplan_for_Infant_Immunization,0) as Workplan_for_Infant_Immunization,
isnull(Workplan_by_HealthProvider_ID,0) as Workplan_by_HealthProvider_ID,
isnull(Workplan_by_Beneficiary_ID,0) as Workplan_by_Beneficiary_ID,
isnull(Facility_Wise_Workplan_PW_All,0) as Facility_Wise_Workplan_PW_All,
isnull(Workplan_for_Special_Round_IMI,0) as Workplan_for_Special_Round_IMI
from
(
select vn.State_Code,  vn.HealthSubFacility_Code as HealthSubFacility_Code,isnull(vn.ID,0) as Health_Provider_ID
	,sp.SUBPHC_NAME_E as	HealthSubFacility_Name, case when TYPE_ID=1 then(vn.Name+'(ASHA)')
	 when type_id=2 then (vn.Name+'(ANM)') 
	 when type_id=3 then (vn.Name+'(ANM 2)')
	 when type_id=4 then (vn.Name+'(LINK WORKER)')
	 when type_id=5 then (vn.Name+'(MPW)')
	 when type_id=6 then (vn.Name+'(GNM)')
	 when type_id=7 then (vn.Name+'(CHV)')
	 when type_id=8 then (vn.Name+'(AWW)')
	 else (vn.Name+'(Other)')
	 end as Health_Provider_Name
	
	
	from t_Ground_Staff vn 
	left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=vn.HealthSubFacility_Code
	
	where (vn.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	
	
)  A
full outer join
(

select state_id ,District_code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code,ANM_Asha_ID,

isnull(sum(case when TypeOfService=1 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_ANC,
ISNULL(SUM(case when typeofservice=2 and WorkPlan_Type=1  then workplan_hitcount end),0) as Workplan_for_Delivery,
isnull(sum(case when (TypeOfService=3 or TypeOfService=5) and WorkPlan_Type=1 then workPlan_hitCount end),0) as Workplan_for_PNC,
isnull(sum(case when  WorkPlan_Type=4 or WorkPlan_Type=3 then workPlan_hitCount end),0) as Workplan_for_Child_Immunization,
isnull(sum(case when  WorkPlan_Type=2 then workPlan_hitCount end),0) as Workplan_for_Infant_Immunization,
isnull(sum(case when TypeOfService=6 then workPlan_hitCount end),0) as Workplan_by_HealthProvider_ID,
isnull(sum(case when TypeOfService=7 then workPlan_hitCount end),0) as Workplan_by_Beneficiary_ID,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=1 then workPlan_hitCount end),0) as Facility_Wise_Workplan_PW_All,
isnull(sum(case when TypeOfService=0 and WorkPlan_Type=5 then workPlan_hitCount end),0) as Workplan_for_Special_Round_IMI
 from t_Workplan_log (nolock) where HealthSubFacility_Code>0 and State_ID=@State_Code and District_code=@District_Code and  HealthBlock_Code =@HealthBlock_Code  and HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code  and WorkPlan_year=@FinancialYr and (WorkPlan_month=@Month_ID or @Month_ID=0) group by State_ID,District_code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code,ANM_Asha_ID
 
 )B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Health_Provider_ID=B.ANM_Asha_ID
 left outer join
 (
	select SUBPHC_NAME_E, SUBPHC_CD from TBL_SUBPHC  
 ) C on C.SUBPHC_CD=B.HealthSubFacility_Code

end

END


