USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_Children]    Script Date: 09/26/2024 11:57:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Dashboard_Children]
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
@Filter_Type tinyint,
@Category varchar(20)
)
as 
begin

if (@Category='State')
begin

select A.State_Code as ParentID, A.State_Name as ParentName, A.District_Code as ChildID, A.District_Name as ChildName, 
A.Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered,isnull(Live_births,0) as Live_births,isnull(LBW_infants,0) as LBW_infants,
isnull(Infant_deaths,0) as Infant_deaths,isnull(Breast_fed_1Hour,0) as Breast_fed_1Hour,isnull(Breast_fed_6Months,0) as Breast_fed_6Months, 
isnull(BCG,0) as BCG,isnull(OPV0,0) as OPV0,isnull(HEP0,0) as HEP0,isnull(OPV1,0) as OPV1,isnull(HEP1,0) as HEP1,isnull(DTP1,0) as DTP1, 
isnull(Penta1,0) as Penta1,isnull(OPV2,0) as OPV2,isnull(HEP2,0) as HEP2,isnull(DTP2,0) as DTP2,isnull(Penta2,0) as Penta2,isnull(OPV3,0) as OPV3,
isnull(HEP3,0) as HEP3,isnull(DTP3,0) as DTP3,isnull(Penta3,0) as Penta3,isnull(Measles1,0) as Measles1,isnull(Measles2,0) as Measles2,  
isnull(JE1,0) as JE1,isnull(JE2,0) as JE2,isnull(Vitamin1,0) as Vitamin1,isnull(Full_Immu_One_Yr,0) as Full_Immu_One_Yr,
isnull(Full_Immu_Two_Yr,0) as Full_Immu_Two_Yr
from 
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME as District_Name
,c.Estimated_Infant as Estimated_Infant
from TBL_DISTRICT a
inner join TBL_STATE b on a.StateID=b.StateID
inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code
where c.Financial_Year=@FinancialYr 
and b.StateID=@State_Code)  A

left outer join
(select [State_Code]as [State_Code],[District_Code]as [District_Code]
,sum(Infant_Registered)as [Infant_Registered],0 as  [Live_births],sum(Infant_Low_birth_Weight)as [LBW_Infants],sum(Infant_Death_Total)as [Infant_Deaths]
,0 as Breast_fed_1Hour,sum(CH_With_Brestfed_6_month)as Breast_fed_6Months,SUM(BCG_P+BCG_T) as BCG
,SUM(OPV0_P+OPV0_T) as OPV0,SUM(HEP0_P+HEP0_T) as HEP0,SUM(OPV1_P+OPV1_T) as OPV1
,SUM(HEP1_P+HEP1_T) as HEP1,SUM(DPT1_P+DPT1_T) as DTP1,SUM(PENTA1_P+PENTA1_T) as Penta1
,SUM(OPV2_P+OPV2_T) as OPV2,SUM(HEP2_P+HEP2_T) as HEP2,SUM(DPT2_P+DPT2_T) as DTP2
,SUM(PENTA2_P+PENTA2_T) as Penta2,SUM(OPV3_P+OPV3_T) as OPV3
,SUM(HEP3_P+HEP3_T) as HEP3,SUM(DPT3_P+DPT3_T) as DTP3,SUM(PENTA3_P+PENTA3_T) as Penta3
,SUM(Measles1_P+Measles1_T) as Measles1,SUM(Measles2_P+Measles2_T) as Measles2,SUM(JE1_P+JE1_T) as JE1,SUM(JE2_P+JE2_T) as JE2
,SUM(VITA1_P+VITA1_T) as Vitamin1
,SUM(Infant_11_FullImmu) as Full_Immu_One_Yr,SUM(Infant_11_FullImmu) as Full_Immu_Two_Yr
from Scheduled_AC_Child_State_District_Month 
where [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and Filter_Type=@Filter_Type 
group by [State_Code],[District_Code]) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code


end
if (@Category='District')
begin
Select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,A.HealthBlock_Name as ChildName,
A.Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered,isnull(Live_births,0) as Live_births,isnull(LBW_infants,0) as LBW_infants,
isnull(Infant_deaths,0) as Infant_deaths,isnull(Breast_fed_1Hour,0) as Breast_fed_1Hour,isnull(Breast_fed_6Months,0) as Breast_fed_6Months, 
isnull(BCG,0) as BCG,isnull(OPV0,0) as OPV0,isnull(HEP0,0) as HEP0,isnull(OPV1,0) as OPV1,isnull(HEP1,0) as HEP1,isnull(DTP1,0) as DTP1, 
isnull(Penta1,0) as Penta1,isnull(OPV2,0) as OPV2,isnull(HEP2,0) as HEP2,isnull(DTP2,0) as DTP2,isnull(Penta2,0) as Penta2,isnull(OPV3,0) as OPV3,
isnull(HEP3,0) as HEP3,isnull(DTP3,0) as DTP3,isnull(Penta3,0) as Penta3,isnull(Measles1,0) as Measles1,isnull(Measles2,0) as Measles2,  
isnull(JE1,0) as JE1,isnull(JE2,0) as JE2,isnull(Vitamin1,0) as Vitamin1,isnull(Full_Immu_One_Yr,0) as Full_Immu_One_Yr,
isnull(Full_Immu_Two_Yr,0) as Full_Immu_Two_Yr
from 
(Select b.StateID as StateCode,a.DISTRICT_CD as District_Code, b.DIST_NAME_ENG as District_Name, 
a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name,c.Estimated_Infant as Estimated_Infant
from TBL_HEALTH_BLOCK a
inner join TBL_DISTRICT b on a.DISTRICT_CD = b.DIST_CD
inner join Estimated_Data_Block_Wise c on a.BLOCK_CD = c.HealthBlock_Code
where c.Financial_Year = @FinancialYr
and a.DISTRICT_CD =@District_Code) A
left outer join 
(Select District_Code as District_Code , HealthBlock_Code as HealthBlock_Code
,sum(Infant_Registered)as [Infant_Registered],0 as  [Live_births],sum(Infant_Low_birth_Weight)as [LBW_Infants],sum(Infant_Death_Total)as [Infant_Deaths]
,0 as Breast_fed_1Hour,sum(CH_With_Brestfed_6_month)as Breast_fed_6Months,SUM(BCG_P+BCG_T) as BCG
,SUM(OPV0_P+OPV0_T) as OPV0,SUM(HEP0_P+HEP0_T) as HEP0,SUM(OPV1_P+OPV1_T) as OPV1
,SUM(HEP1_P+HEP1_T) as HEP1,SUM(DPT1_P+DPT1_T) as DTP1,SUM(PENTA1_P+PENTA1_T) as Penta1
,SUM(OPV2_P+OPV2_T) as OPV2,SUM(HEP2_P+HEP2_T) as HEP2,SUM(DPT2_P+DPT2_T) as DTP2
,SUM(PENTA2_P+PENTA2_T) as Penta2,SUM(OPV3_P+OPV3_T) as OPV3
,SUM(HEP3_P+HEP3_T) as HEP3,SUM(DPT3_P+DPT3_T) as DTP3,SUM(PENTA3_P+PENTA3_T) as Penta3
,SUM(Measles1_P+Measles1_T) as Measles1,SUM(Measles2_P+Measles2_T) as Measles2,SUM(JE1_P+JE1_T) as JE1,SUM(JE2_P+JE2_T) as JE2
,SUM(VITA1_P+VITA1_T) as Vitamin1
,SUM(Infant_11_FullImmu) as Full_Immu_One_Yr,SUM(Infant_11_FullImmu) as Full_Immu_Two_Yr
from Scheduled_AC_Child_District_Block_Month 
where [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and Filter_Type=@Filter_Type 
group by [District_Code],HealthBlock_Code) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code
end
if (@Category='Block')
begin
select A.HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,
A.Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered,isnull(Live_births,0) as Live_births,isnull(LBW_infants,0) as LBW_infants,
isnull(Infant_deaths,0) as Infant_deaths,isnull(Breast_fed_1Hour,0) as Breast_fed_1Hour,isnull(Breast_fed_6Months,0) as Breast_fed_6Months, 
isnull(BCG,0) as BCG,isnull(OPV0,0) as OPV0,isnull(HEP0,0) as HEP0,isnull(OPV1,0) as OPV1,isnull(HEP1,0) as HEP1,isnull(DTP1,0) as DTP1, 
isnull(Penta1,0) as Penta1,isnull(OPV2,0) as OPV2,isnull(HEP2,0) as HEP2,isnull(DTP2,0) as DTP2,isnull(Penta2,0) as Penta2,isnull(OPV3,0) as OPV3,
isnull(HEP3,0) as HEP3,isnull(DTP3,0) as DTP3,isnull(Penta3,0) as Penta3,isnull(Measles1,0) as Measles1,isnull(Measles2,0) as Measles2,  
isnull(JE1,0) as JE1,isnull(JE2,0) as JE2,isnull(Vitamin1,0) as Vitamin1,isnull(Full_Immu_One_Yr,0) as Full_Immu_One_Yr,
isnull(Full_Immu_Two_Yr,0) as Full_Immu_Two_Yr
from
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name 
,Estimated_Infant
from TBL_PHC  a
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code
where c.Financial_Year=@FinancialYr 
and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)
)  A 

left outer join 
(select HealthBlock_Code as HealthBlock_Code,HealthFacility_Code as HealthFacility_Code
,sum(Infant_Registered)as [Infant_Registered],0 as  [Live_births],sum(Infant_Low_birth_Weight)as [LBW_Infants],sum(Infant_Death_Total)as [Infant_Deaths]
,0 as Breast_fed_1Hour,sum(CH_With_Brestfed_6_month)as Breast_fed_6Months,SUM(BCG_P+BCG_T) as BCG
,SUM(OPV0_P+OPV0_T) as OPV0,SUM(HEP0_P+HEP0_T) as HEP0,SUM(OPV1_P+OPV1_T) as OPV1
,SUM(HEP1_P+HEP1_T) as HEP1,SUM(DPT1_P+DPT1_T) as DTP1,SUM(PENTA1_P+PENTA1_T) as Penta1
,SUM(OPV2_P+OPV2_T) as OPV2,SUM(HEP2_P+HEP2_T) as HEP2,SUM(DPT2_P+DPT2_T) as DTP2
,SUM(PENTA2_P+PENTA2_T) as Penta2,SUM(OPV3_P+OPV3_T) as OPV3
,SUM(HEP3_P+HEP3_T) as HEP3,SUM(DPT3_P+DPT3_T) as DTP3,SUM(PENTA3_P+PENTA3_T) as Penta3
,SUM(Measles1_P+Measles1_T) as Measles1,SUM(Measles2_P+Measles2_T) as Measles2,SUM(JE1_P+JE1_T) as JE1,SUM(JE2_P+JE2_T) as JE2
,SUM(VITA1_P+VITA1_T) as Vitamin1
,SUM(Infant_11_FullImmu) as Full_Immu_One_Yr,SUM(Infant_11_FullImmu) as Full_Immu_Two_Yr
from Scheduled_AC_Child_Block_PHC_Month 
where [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and Filter_Type=@Filter_Type 
group by HealthBlock_Code,HealthFacility_Code) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code 
end
          
if (@Category='PHC')
begin
select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName,
A.Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered,isnull(Live_births,0) as Live_births,isnull(LBW_infants,0) as LBW_infants,
isnull(Infant_deaths,0) as Infant_deaths,isnull(Breast_fed_1Hour,0) as Breast_fed_1Hour,isnull(Breast_fed_6Months,0) as Breast_fed_6Months, 
isnull(BCG,0) as BCG,isnull(OPV0,0) as OPV0,isnull(HEP0,0) as HEP0,isnull(OPV1,0) as OPV1,isnull(HEP1,0) as HEP1,isnull(DTP1,0) as DTP1, 
isnull(Penta1,0) as Penta1,isnull(OPV2,0) as OPV2,isnull(HEP2,0) as HEP2,isnull(DTP2,0) as DTP2,isnull(Penta2,0) as Penta2,isnull(OPV3,0) as OPV3,
isnull(HEP3,0) as HEP3,isnull(DTP3,0) as DTP3,isnull(Penta3,0) as Penta3,isnull(Measles1,0) as Measles1,isnull(Measles2,0) as Measles2,  
isnull(JE1,0) as JE1,isnull(JE2,0) as JE2,isnull(Vitamin1,0) as Vitamin1,isnull(Full_Immu_One_Yr,0) as Full_Immu_One_Yr,
isnull(Full_Immu_Two_Yr,0) as Full_Immu_Two_Yr
from 
(select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
,Estimated_Infant
from TBL_SUBPHC a
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code
where c.Financial_Year=@FinancialYr 
and a.PHC_CD= @HealthFacility_Code)  A
left outer join
(select HealthFacility_Code as HealthFacility_Code,HealthSubFacility_Code as HealthSubFacility_Code
,sum(Infant_Registered)as [Infant_Registered],0 as  [Live_births],sum(Infant_Low_birth_Weight)as [LBW_Infants],sum(Infant_Death_Total)as [Infant_Deaths]
,0 as Breast_fed_1Hour,sum(CH_With_Brestfed_6_month)as Breast_fed_6Months,SUM(BCG_P+BCG_T) as BCG
,SUM(OPV0_P+OPV0_T) as OPV0,SUM(HEP0_P+HEP0_T) as HEP0,SUM(OPV1_P+OPV1_T) as OPV1
,SUM(HEP1_P+HEP1_T) as HEP1,SUM(DPT1_P+DPT1_T) as DTP1,SUM(PENTA1_P+PENTA1_T) as Penta1
,SUM(OPV2_P+OPV2_T) as OPV2,SUM(HEP2_P+HEP2_T) as HEP2,SUM(DPT2_P+DPT2_T) as DTP2
,SUM(PENTA2_P+PENTA2_T) as Penta2,SUM(OPV3_P+OPV3_T) as OPV3
,SUM(HEP3_P+HEP3_T) as HEP3,SUM(DPT3_P+DPT3_T) as DTP3,SUM(PENTA3_P+PENTA3_T) as Penta3
,SUM(Measles1_P+Measles1_T) as Measles1,SUM(Measles2_P+Measles2_T) as Measles2,SUM(JE1_P+JE1_T) as JE1,SUM(JE2_P+JE2_T) as JE2
,SUM(VITA1_P+VITA1_T) as Vitamin1
,SUM(Infant_11_FullImmu) as Full_Immu_One_Yr,SUM(Infant_11_FullImmu) as Full_Immu_Two_Yr
from Scheduled_AC_Child_PHC_SubCenter_Month 
where [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and Filter_Type=@Filter_Type 
group by HealthFacility_Code,HealthSubFacility_Code) B on A.HealthFacility_Code=B.HealthFacility_Code  and A.HealthSubFacility_Code=B.HealthSubFacility_Code
end

if (@Category='SubCentre')
begin
select A.HealthSubFacility_Code as ParentID,A.HealthSubFacility_Name as ParentName,A.Village_Code as ChildID,A.Village_Name as ChildName,
A.Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered,isnull(Live_births,0) as Live_births,isnull(LBW_infants,0) as LBW_infants,
isnull(Infant_deaths,0) as Infant_deaths,isnull(Breast_fed_1Hour,0) as Breast_fed_1Hour,isnull(Breast_fed_6Months,0) as Breast_fed_6Months, 
isnull(BCG,0) as BCG,isnull(OPV0,0) as OPV0,isnull(HEP0,0) as HEP0,isnull(OPV1,0) as OPV1,isnull(HEP1,0) as HEP1,isnull(DTP1,0) as DTP1, 
isnull(Penta1,0) as Penta1,isnull(OPV2,0) as OPV2,isnull(HEP2,0) as HEP2,isnull(DTP2,0) as DTP2,isnull(Penta2,0) as Penta2,isnull(OPV3,0) as OPV3,
isnull(HEP3,0) as HEP3,isnull(DTP3,0) as DTP3,isnull(Penta3,0) as Penta3,isnull(Measles1,0) as Measles1,isnull(Measles2,0) as Measles2,  
isnull(JE1,0) as JE1,isnull(JE2,0) as JE2,isnull(Vitamin1,0) as Vitamin1,isnull(Full_Immu_One_Yr,0) as Full_Immu_One_Yr,
isnull(Full_Immu_Two_Yr,0) as Full_Immu_Two_Yr
from
(select b.StateID as State_Code , 0 as Village_Code ,SUBPHC_NAME_E as HealthSubFacility_Name,SUBPHC_CD as HealthSubFacility_Code,'Direct Entry' as Village_Name  
,(Case when @Month_ID = 0 then Estimated_Infant else Estimated_Infant/12 end) as Estimated_Infant
from TBL_SUBPHC a
inner join TBL_DISTRICT b on a.DIST_CD=b.DIST_CD
inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code
where c.Financial_Year=@FinancialYr 
and ( a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0))  A
left outer join
(select HealthSubFacility_Code as HealthSubFacility_Code,Village_Code as Village_Code
,sum(Infant_Registered)as [Infant_Registered],0 as  [Live_births],sum(Infant_Low_birth_Weight)as [LBW_Infants],sum(Infant_Death_Total)as [Infant_Deaths]
,0 as Breast_fed_1Hour,sum(CH_With_Brestfed_6_month)as Breast_fed_6Months,SUM(BCG_P+BCG_T) as BCG
,SUM(OPV0_P+OPV0_T) as OPV0,SUM(HEP0_P+HEP0_T) as HEP0,SUM(OPV1_P+OPV1_T) as OPV1
,SUM(HEP1_P+HEP1_T) as HEP1,SUM(DPT1_P+DPT1_T) as DTP1,SUM(PENTA1_P+PENTA1_T) as Penta1
,SUM(OPV2_P+OPV2_T) as OPV2,SUM(HEP2_P+HEP2_T) as HEP2,SUM(DPT2_P+DPT2_T) as DTP2
,SUM(PENTA2_P+PENTA2_T) as Penta2,SUM(OPV3_P+OPV3_T) as OPV3
,SUM(HEP3_P+HEP3_T) as HEP3,SUM(DPT3_P+DPT3_T) as DTP3,SUM(PENTA3_P+PENTA3_T) as Penta3
,SUM(Measles1_P+Measles1_T) as Measles1,SUM(Measles2_P+Measles2_T) as Measles2,SUM(JE1_P+JE1_T) as JE1,SUM(JE2_P+JE2_T) as JE2
,SUM(VITA1_P+VITA1_T) as Vitamin1
,SUM(Infant_11_FullImmu) as Full_Immu_One_Yr,SUM(Infant_11_FullImmu) as Full_Immu_Two_Yr
from Scheduled_AC_Child_PHC_SubCenter_Village_Month
where [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and Filter_Type=@Filter_Type 
group by HealthSubFacility_Code,Village_Code,[Fin_Yr]) B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code
end

end

