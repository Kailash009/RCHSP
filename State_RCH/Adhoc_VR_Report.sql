USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Adhoc_VR_Report]    Script Date: 09/26/2024 11:56:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Adhoc_VR_Report]
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
@Type as int=0,--Registrerd
@Filter_Type as int=0,
@Sub_Filter_Type as int=0
)
as
begin

if(@Filter_Type=2)--Not Enetered
begin
select f.DIST_NAME_ENG as District,e.Block_Name_E as Block,d.PHC_NAME as HealthFacility,c.SUBPHC_NAME_E as Subcentre
, a.VILLAGE_NAME as Village, '' as [Population of the Village],'' as  [Total No. of EC], '' as [Total No. of PW], '' as [Total No. of Infant]
,'' as [Health Institution Name], '' as [Health Institution Landline], '' as [Health Institution Mobile],'' as [Health Institution Address]
, '' as [FRUName],'' as [FRU Landline],'' as [FRU Mobile],'' as [FRU Address] 
,'' as [Transport Landline],'' as [Transport Mobile]
from Estimated_Data_Village_Wise  a
inner join TBL_VILLAGE b on a.HealthSubFacility_Code=b.SUBPHC_CD and a.Village_Code=b.VILLAGE_CD
inner join TBL_SUBPHC c on b.SUBPHC_CD=c.SUBPHC_CD
inner join TBL_PHC d on c.PHC_CD=d.PHC_CD
inner join TBL_HEALTH_BLOCK e on d.BID=e.BLOCK_CD
inner join TBL_DISTRICT f on e.DISTRICT_CD=f.DIST_CD
inner join Village g on b.VILLAGE_CD=g.VCode
where Financial_Year=@FinancialYr 
and ISNULL(a.Village_population,0)=0
and (b.DIST_CD=@District_Code  or @District_Code=0)
and (d.BID=@HealthBlock_Code or @HealthBlock_Code=0)
and (c.PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)
and (a.HealthSubFacility_Code=@HealthSubfacility_Code or @HealthSubfacility_Code=0)
and g.Village_Type=1
end

else if(@Filter_Type=1)--Entered
begin
select f.DIST_NAME_ENG as District,e.Block_Name_E as Block,d.PHC_NAME as HealthFacility,c.SUBPHC_NAME_E as Subcentre
, b.VILLAGE_NAME as Village, h.Village_population as [Population of the Village],h.Eligible_Couples as  [Total No. of EC], h.Estimated_PW as [Total No. of PW]
, h.Estimated_Infant as [Total No. of Infant]
,h.PHC_Name as [Health Institution Name], h.PHC_LL as [Health Institution Landline], h.PHC_Mob as [Health Institution Mobile],h.PHC_Address as [Health Institution Address]
,h.FRU_Name as [FRUName],h.FRU_LL as [FRU Landline],h.FRU_Mob as [FRU Mobile],h.FRU_Address as [FRU Address] 
,Trsprt_LL as [Transport Landline],Trsprt_Mob as [Transport Mobile]
from t_villagewise_registry  h
left outer join TBL_VILLAGE b on h.HealthSubCentre_code=b.SUBPHC_CD and h.Village_Code=b.VILLAGE_CD
inner join TBL_SUBPHC c on b.SUBPHC_CD=c.SUBPHC_CD
inner join TBL_PHC d on c.PHC_CD=d.PHC_CD
inner join TBL_HEALTH_BLOCK e on d.BID=e.BLOCK_CD
inner join TBL_DISTRICT f on e.DISTRICT_CD=f.DIST_CD
inner join Village g on b.VILLAGE_CD=g.VCode
where h.Finanacial_Yr=@FinancialYr 
and (b.DIST_CD=@District_Code  or @District_Code=0)
and (d.BID=@HealthBlock_Code or @HealthBlock_Code=0)
and (c.PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)
and (h.HealthSubCentre_code=@HealthSubfacility_Code or @HealthSubfacility_Code=0)
end
END





