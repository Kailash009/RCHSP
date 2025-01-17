USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[workplan_infant_immunization_new]    Script Date: 09/26/2024 14:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
/*
workplan_infant_immunization 0,0
*/
ALTER proc [dbo].[workplan_infant_immunization_new]
(
@State_Code int=0,  
@District_Code int=0,  
@HealthBlock_Code int=0,  
@HealthFacility_Code int=0,  
@HealthSubFacility_Code int=0,
@Village_Code int=0,
@Year_ID as int=0,
@Month_ID as int=0,
@Quarter_ID as int=0,
@Period_ID int,
@Category varchar(10)
)
as
begin


if(@Period_ID=2)--Quarterly
begin
 if(@Quarter_ID=1)
 begin
	set @Month_ID=4
	set @Quarter_ID=@Month_ID+2
 end
 else if(@Quarter_ID=2)
 begin
	set @Month_ID=7
	set @Quarter_ID=@Month_ID+2
 end
 else if(@Quarter_ID=3)
 begin
	set @Month_ID=10
	set @Quarter_ID=@Month_ID+2
 end
 else
 begin
	set @Month_ID=1
	set @Quarter_ID=@Month_ID+2
 end
end


if(@Category = 'State')
begin
------------------------------------------------------------------------------------
if(@Period_ID=1) -- year
begin

--select * from (

--select * from TBL_STATE a 
-- inner join TBL_DISTRICT b on a.StateID=b.StateID and a.District_ID=b.DIST_CD

SELECT [State_ID] as ParentID,[District_ID] as ChildID--,b.StateName as ParentName,c.DIST_NAME as ChildName
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM [Scheduled_Infant_Workplan_StateDist_FinYr] a
  where Fin_Yr=@Year_ID
 group by a.State_ID,a.District_ID
end
else if(@Period_ID=2) -- Quarter
begin
SELECT [State_ID],[District_ID]
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM [Scheduled_Infant_Workplan_StateDist_FinYr] where 
 Fin_Yr=@Year_ID
 and Month_ID between @Month_ID and @Quarter_ID
 group by State_ID,District_ID
end
else if(@Period_ID=3) -- Month
begin
SELECT [State_ID],[District_ID]
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM [Scheduled_Infant_Workplan_StateDist_FinYr] where 
 Fin_Yr=@Year_ID
 and Month_ID=@Month_ID
 group by State_ID,District_ID
end
--------------------------------------------------------------------------------------
end
if(@Category = 'District')
begin
SELECT [District_ID],HealthBlock_ID
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM Scheduled_Infant_Workplan_DistBlk_FinYr --where Fin_Yr=@FinancialYr
 group by [District_ID],HealthBlock_ID
end
if(@Category = 'Block')
begin
SELECT HealthBlock_ID,PHC_ID
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM Scheduled_Infant_Workplan_BlkPHC_FinYr where Fin_Yr=@Year_ID
 group by HealthBlock_ID,PHC_ID
end
if(@Category = 'PHC')
begin
SELECT PHC_ID,SubCentre_ID
,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]
,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]
,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]
,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]
,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]
,sum([Measles_D_Count])[Measles_D_Count]
,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]
 FROM Scheduled_Infant_Workplan_PHCSubCen_FinYr where Fin_Yr=@Year_ID
 group by PHC_ID,SubCentre_ID
end
 
 end