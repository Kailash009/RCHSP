USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_GF_Bifurcation]    Script Date: 09/26/2024 11:51:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*
[AC_GF_Bifurcation] 0,0,0,0,0,0,2015,0,0,'','','National'  
[AC_GF_Bifurcation] 30,0,0,0,0,0,2016,0,0,'','','State',2  
[AC_GF_Bifurcation] 30,1,0,0,0,0,2017,0,0,'','','District',2  
[AC_GF_Bifurcation] 30,1,3,0,0,0,2017,0,0,'','','Block',2  
[AC_GF_Bifurcation] 30,1,3,13,0,0,2017,0,0,'','','PHC',2  
[AC_GF_Bifurcation] 30,1,2,0,0,0,2016,0,0,'','','SubCentre',2  
*/
ALTER procedure [dbo].[AC_GF_Bifurcation]
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
,ISNULL(Total_ANM2,0) as Total_ANM2
,ISNULL(TotalCHV,0)as TotalCHV
,ISNULL(Total_GNM,0) as Total_GNM
,ISNULL(Total_LinkWorker,0) as Total_LinkWorker
,ISNULL(Total_MPW,0) as  Total_MPW
,ISNULL(Total_ASHA,0) as  Total_ASHA
,ISNULL(Total_AWW,0) as  Total_AWW

,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile
,ISNULL(Total_ASHA_With_Mob,0) as  Total_ASHA_With_Mob
,ISNULL(Total_AWW_With_Mob,0) as  Total_AWW_With_Mob

,ISNULL(Total_GF_Validated_Mob,0) as  Total_GF_Validated_Mob
,ISNULL(Total_ASHA_Validated_Mob,0) as  Total_ASHA_Validated_Mob
,ISNULL(Total_AWW_Validated_Mob,0) as  Total_AWW_Validated_Mob

,ISNULL(Total_GF_Unique_Mob,0) as  Total_GF_Unique_Mob
,ISNULL(Total_ASHA_Unique_Mob,0) as  Total_ASHA_Unique_Mob
,ISNULL(Total_AWW_Unique_Mob,0) as  Total_AWW_Unique_Mob

,ISNULL(Total_GF_Wrong_Mob,0) as  Total_GF_Wrong_Mob
,ISNULL(Total_ASHA_Wrong_Mob,0) as  Total_ASHA_Wrong_Mob
,ISNULL(Total_AWW_Wrong_Mob,0) as  Total_AWW_Wrong_Mob
from    
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name  
 from  TBL_DISTRICT a   
 inner join TBL_STATE b on a.StateID=b.StateID  
   
) A  
left outer join  
(  
select  State_Code,District_Code
,sum([Total_ANM]) Total_ANM,SUM(Total_ANM2)Total_ANM2,SUM(Total_CHV) TotalCHV,SUM(Total_GNM) Total_GNM,SUM(Total_LinkWorker)Total_LinkWorker,SUM(Total_MPW)Total_MPW,SUM(Total_ASHA)Total_ASHA,SUM(Total_AWW)Total_AWW
,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile
,SUM([Total_ASHA_WithD_Mob]) as Total_ASHA_With_Mob
,SUM([Total_AWW_WithD_Mob]) as Total_AWW_With_Mob
,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])+sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob
,SUM([Total_ASHA_with_ValidatedPhone]) as Total_ASHA_Validated_Mob
,SUM([Total_AWW_with_ValidatedPhone]) as Total_AWW_Validated_Mob
,sum([Total_ANM_With_Unique_Mob])+sum([Total_ANM2_With_Unique_Mob])+sum(Total_CHV_Unique_With_Mob)+sum([Total_GNM_With_Unique_Mob])+sum([Total_LinkWorker_With_Unique_Mob])+sum([Total_MPW_With_Unique_Mob]) as Total_GF_Unique_Mob
,SUM([Total_ASHA_With_Unique_Mob]) as Total_ASHA_Unique_Mob
,SUM([Total_AWW_With_Unique_Mob]) as Total_AWW_Unique_Mob
,sum([Total_ANM_With_Wrong_Mob])+sum([Total_ANM2_With_Wrong_Mob])+sum([Total_CHV_With_Wrong_Mob])+sum([Total_GNM_With_Wrong_Mob])+sum([Total_LinkWorker_With_Wrong_Mob])+sum([Total_MPW_With_Wrong_Mob]) as Total_GF_Wrong_Mob
,SUM([Total_ASHA_With_Wrong_Mob]) as Total_ASHA_Wrong_Mob
,SUM([Total_AWW_With_Wrong_Mob]) as Total_AWW_Wrong_Mob
FROM dbo.Scheduled_AC_GF_State_District 
where State_Code=@State_Code
group by State_Code,District_Code
)   
 B on  A.State_Code =B.State_Code and A.District_Code=B.District_Code 
  





end

else if(@Category='District')
Begin

	
  select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName
,ISNULL(Total_ANM,0) as Total_ANM
,ISNULL(Total_ANM2,0) as Total_ANM2
,ISNULL(TotalCHV,0)as TotalCHV
,ISNULL(Total_GNM,0) as Total_GNM
,ISNULL(Total_LinkWorker,0) as Total_LinkWorker
,ISNULL(Total_MPW,0) as  Total_MPW
,ISNULL(Total_ASHA,0) as  Total_ASHA
,ISNULL(Total_AWW,0) as  Total_AWW

,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile
,ISNULL(Total_ASHA_With_Mob,0) as  Total_ASHA_With_Mob
,ISNULL(Total_AWW_With_Mob,0) as  Total_AWW_With_Mob

,ISNULL(Total_GF_Validated_Mob,0) as  Total_GF_Validated_Mob
,ISNULL(Total_ASHA_Validated_Mob,0) as  Total_ASHA_Validated_Mob
,ISNULL(Total_AWW_Validated_Mob,0) as  Total_AWW_Validated_Mob

,ISNULL(Total_GF_Unique_Mob,0) as  Total_GF_Unique_Mob
,ISNULL(Total_ASHA_Unique_Mob,0) as  Total_ASHA_Unique_Mob
,ISNULL(Total_AWW_Unique_Mob,0) as  Total_AWW_Unique_Mob

,ISNULL(Total_GF_Wrong_Mob,0) as  Total_GF_Wrong_Mob
,ISNULL(Total_ASHA_Wrong_Mob,0) as  Total_ASHA_Wrong_Mob
,ISNULL(Total_AWW_Wrong_Mob,0) as  Total_AWW_Wrong_Mob

  from    
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name   
 from TBL_HEALTH_BLOCK a  
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD  
 where a.DISTRICT_CD=@District_Code  
) A  
left outer join  
(  select  District_ID,HealthBlock_ID 
,sum([Total_ANM]) Total_ANM,SUM(Total_ANM2)Total_ANM2,SUM(Total_CHV) TotalCHV,SUM(Total_GNM) Total_GNM,SUM(Total_LinkWorker)Total_LinkWorker,SUM(Total_MPW)Total_MPW,SUM(Total_ASHA)Total_ASHA,SUM(Total_AWW)Total_AWW
,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile
,SUM([Total_ASHA_WithD_Mob]) as Total_ASHA_With_Mob
,SUM([Total_AWW_WithD_Mob]) as Total_AWW_With_Mob
,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])+sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob
,SUM([Total_ASHA_with_ValidatedPhone]) as Total_ASHA_Validated_Mob
,SUM([Total_AWW_with_ValidatedPhone]) as Total_AWW_Validated_Mob
,sum([Total_ANM_With_Unique_Mob])+sum([Total_ANM2_With_Unique_Mob])+sum(Total_CHV_Unique_With_Mob)+sum([Total_GNM_With_Unique_Mob])+sum([Total_LinkWorker_With_Unique_Mob])+sum([Total_MPW_With_Unique_Mob]) as Total_GF_Unique_Mob
,SUM([Total_ASHA_With_Unique_Mob]) as Total_ASHA_Unique_Mob
,SUM([Total_AWW_With_Unique_Mob]) as Total_AWW_Unique_Mob
,sum([Total_ANM_With_Wrong_Mob])+sum([Total_ANM2_With_Wrong_Mob])+sum([Total_CHV_With_Wrong_Mob])+sum([Total_GNM_With_Wrong_Mob])+sum([Total_LinkWorker_With_Wrong_Mob])+sum([Total_MPW_With_Wrong_Mob]) as Total_GF_Wrong_Mob
,SUM([Total_ASHA_With_Wrong_Mob]) as Total_ASHA_Wrong_Mob
,SUM([Total_AWW_With_Wrong_Mob]) as Total_AWW_Wrong_Mob
  FROM dbo.Scheduled_AC_GF_District_Block 
  where (District_ID=@District_Code)
  and (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)
  group by District_ID,HealthBlock_ID 
   ) B on A.District_Code=B.District_ID and A.HealthBlock_Code=B.HealthBlock_ID 




end


else if(@Category='Block')
Begin


 select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName
,ISNULL(Total_ANM,0) as Total_ANM
,ISNULL(Total_ANM2,0) as Total_ANM2
,ISNULL(TotalCHV,0)as TotalCHV
,ISNULL(Total_GNM,0) as Total_GNM
,ISNULL(Total_LinkWorker,0) as Total_LinkWorker
,ISNULL(Total_MPW,0) as  Total_MPW
,ISNULL(Total_ASHA,0) as  Total_ASHA
,ISNULL(Total_AWW,0) as  Total_AWW

,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile
,ISNULL(Total_ASHA_With_Mob,0) as  Total_ASHA_With_Mob
,ISNULL(Total_AWW_With_Mob,0) as  Total_AWW_With_Mob

,ISNULL(Total_GF_Validated_Mob,0) as  Total_GF_Validated_Mob
,ISNULL(Total_ASHA_Validated_Mob,0) as  Total_ASHA_Validated_Mob
,ISNULL(Total_AWW_Validated_Mob,0) as  Total_AWW_Validated_Mob

,ISNULL(Total_GF_Unique_Mob,0) as  Total_GF_Unique_Mob
,ISNULL(Total_ASHA_Unique_Mob,0) as  Total_ASHA_Unique_Mob
,ISNULL(Total_AWW_Unique_Mob,0) as  Total_AWW_Unique_Mob

,ISNULL(Total_GF_Wrong_Mob,0) as  Total_GF_Wrong_Mob
,ISNULL(Total_ASHA_Wrong_Mob,0) as  Total_ASHA_Wrong_Mob
,ISNULL(Total_AWW_Wrong_Mob,0) as  Total_AWW_Wrong_Mob

 from  
 (
  select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
  from TBL_PHC  a
  inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
  where  a.BID=@HealthBlock_Code 
) A
left outer join
(
  select HealthBlock_ID,PHC_ID
,sum([Total_ANM]) Total_ANM,SUM(Total_ANM2)Total_ANM2,SUM(Total_CHV) TotalCHV,SUM(Total_GNM) Total_GNM,SUM(Total_LinkWorker)Total_LinkWorker,SUM(Total_MPW)Total_MPW,SUM(Total_ASHA)Total_ASHA,SUM(Total_AWW)Total_AWW
,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile
,SUM([Total_ASHA_WithD_Mob]) as Total_ASHA_With_Mob
,SUM([Total_AWW_WithD_Mob]) as Total_AWW_With_Mob
,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])+sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob
,SUM([Total_ASHA_with_ValidatedPhone]) as Total_ASHA_Validated_Mob
,SUM([Total_AWW_with_ValidatedPhone]) as Total_AWW_Validated_Mob
,sum([Total_ANM_With_Unique_Mob])+sum([Total_ANM2_With_Unique_Mob])+sum(Total_CHV_Unique_With_Mob)+sum([Total_GNM_With_Unique_Mob])+sum([Total_LinkWorker_With_Unique_Mob])+sum([Total_MPW_With_Unique_Mob]) as Total_GF_Unique_Mob
,SUM([Total_ASHA_With_Unique_Mob]) as Total_ASHA_Unique_Mob
,SUM([Total_AWW_With_Unique_Mob]) as Total_AWW_Unique_Mob
,sum([Total_ANM_With_Wrong_Mob])+sum([Total_ANM2_With_Wrong_Mob])+sum([Total_CHV_With_Wrong_Mob])+sum([Total_GNM_With_Wrong_Mob])+sum([Total_LinkWorker_With_Wrong_Mob])+sum([Total_MPW_With_Wrong_Mob]) as Total_GF_Wrong_Mob
,SUM([Total_ASHA_With_Wrong_Mob]) as Total_ASHA_Wrong_Mob
,SUM([Total_AWW_With_Wrong_Mob]) as Total_AWW_Wrong_Mob
  FROM dbo.Scheduled_AC_GF_Block_PHC a
  where (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)
  and (PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)
  group by HealthBlock_ID,PHC_ID
  --order by b.District_Name
  )  B on A.HealthBlock_Code=B.HealthBlock_ID and A.HealthFacility_Code=B.PHC_ID
end




else if(@Category='PHC' )
Begin

  select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName
,ISNULL(Total_ANM,0) as Total_ANM
,ISNULL(Total_ANM2,0) as Total_ANM2
,ISNULL(TotalCHV,0)as TotalCHV
,ISNULL(Total_GNM,0) as Total_GNM
,ISNULL(Total_LinkWorker,0) as Total_LinkWorker
,ISNULL(Total_MPW,0) as  Total_MPW
,ISNULL(Total_ASHA,0) as  Total_ASHA
,ISNULL(Total_AWW,0) as  Total_AWW

,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile
,ISNULL(Total_ASHA_With_Mob,0) as  Total_ASHA_With_Mob
,ISNULL(Total_AWW_With_Mob,0) as  Total_AWW_With_Mob

,ISNULL(Total_GF_Validated_Mob,0) as  Total_GF_Validated_Mob
,ISNULL(Total_ASHA_Validated_Mob,0) as  Total_ASHA_Validated_Mob
,ISNULL(Total_AWW_Validated_Mob,0) as  Total_AWW_Validated_Mob

,ISNULL(Total_GF_Unique_Mob,0) as  Total_GF_Unique_Mob
,ISNULL(Total_ASHA_Unique_Mob,0) as  Total_ASHA_Unique_Mob
,ISNULL(Total_AWW_Unique_Mob,0) as  Total_AWW_Unique_Mob

,ISNULL(Total_GF_Wrong_Mob,0) as  Total_GF_Wrong_Mob
,ISNULL(Total_ASHA_Wrong_Mob,0) as  Total_ASHA_Wrong_Mob
,ISNULL(Total_AWW_Wrong_Mob,0) as  Total_AWW_Wrong_Mob

from 
 (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
  from TBL_SUBPHC a
  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
  where (a.PHC_CD= @HealthFacility_Code)
  and (a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)
) A
left outer join
(
 select Subcenter_ID,PHC_ID
,sum([Total_ANM]) Total_ANM,SUM(Total_ANM2)Total_ANM2,SUM(Total_CHV) TotalCHV,SUM(Total_GNM) Total_GNM,SUM(Total_LinkWorker)Total_LinkWorker,SUM(Total_MPW)Total_MPW,SUM(Total_ASHA)Total_ASHA,SUM(Total_AWW)Total_AWW
,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile
,SUM([Total_ASHA_WithD_Mob]) as Total_ASHA_With_Mob
,SUM([Total_AWW_WithD_Mob]) as Total_AWW_With_Mob
,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])+sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob
,SUM([Total_ASHA_with_ValidatedPhone]) as Total_ASHA_Validated_Mob
,SUM([Total_AWW_with_ValidatedPhone]) as Total_AWW_Validated_Mob
,sum([Total_ANM_With_Unique_Mob])+sum([Total_ANM2_With_Unique_Mob])+sum(Total_CHV_Unique_With_Mob)+sum([Total_GNM_With_Unique_Mob])+sum([Total_LinkWorker_With_Unique_Mob])+sum([Total_MPW_With_Unique_Mob]) as Total_GF_Unique_Mob
,SUM([Total_ASHA_With_Unique_Mob]) as Total_ASHA_Unique_Mob
,SUM([Total_AWW_With_Unique_Mob]) as Total_AWW_Unique_Mob
,sum([Total_ANM_With_Wrong_Mob])+sum([Total_ANM2_With_Wrong_Mob])+sum([Total_CHV_With_Wrong_Mob])+sum([Total_GNM_With_Wrong_Mob])+sum([Total_LinkWorker_With_Wrong_Mob])+sum([Total_MPW_With_Wrong_Mob]) as Total_GF_Wrong_Mob
,SUM([Total_ASHA_With_Wrong_Mob]) as Total_ASHA_Wrong_Mob
,SUM([Total_AWW_With_Wrong_Mob]) as Total_AWW_Wrong_Mob
  FROM dbo.Scheduled_AC_GF_PHC_Subcenter 
  where (PHC_ID=@HealthFacility_Code)
  and (Subcenter_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
  group by PHC_ID,Subcenter_ID
  --order by PHC_ID,Subcenter_ID
  )  B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.Subcenter_ID
end

END







