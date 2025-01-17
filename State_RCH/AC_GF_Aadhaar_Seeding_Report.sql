USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_GF_Aadhaar_Seeding_Report]    Script Date: 09/26/2024 11:51:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
/*  
[AC_GF_Aadhaar_Seeding_Report] 0,0,0,0,0,0,2015,0,0,'','','National'    
[AC_GF_Aadhaar_Seeding_Report] 30,0,0,0,0,0,2016,0,0,'','','State',2    
[AC_GF_Aadhaar_Seeding_Report] 30,1,0,0,0,0,2017,0,0,'','','District',2    
[AC_GF_Aadhaar_Seeding_Report] 30,1,3,0,0,0,2017,0,0,'','','Block',2    
[AC_GF_Aadhaar_Seeding_Report] 30,1,3,13,0,0,2017,0,0,'','','PHC',2    
[AC_GF_Aadhaar_Seeding_Report] 30,1,2,0,0,0,2016,0,0,'','','SubCentre',2    
*/  
ALTER procedure [dbo].[AC_GF_Aadhaar_Seeding_Report]  
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
  
if(@Type=2)--ANM  
begin  
   
 select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName   
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified
from      
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name    
 from  TBL_DISTRICT a     
 inner join TBL_STATE b on a.StateID=b.StateID    
     
) A    
left outer join    
(    
select  State_Code,District_Code,  
  sum([Total_ANM])+SUM(Total_ANM2)+SUM(Total_CHV)+SUM(Total_GNM)+SUM(Total_LinkWorker)+SUM(Total_MPW) as Total_Registered  
  ,sum([Total_ANM_with_ACC])+SUM([Total_ANM2_with_ACC])+SUM([Total_CHV_with_ACC])+SUM([Total_GNM_with_ACC])+SUM([Total_LinkWorker_with_ACC])+SUM(Total_MPW_with_ACC) as Total_With_Bank  
  ,sum([Total_ANM_with_UID])+sum([Total_ANM2_with_UID])+sum([Total_CHV_with_UID])+sum([Total_GNM_with_UID])+sum([Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_UID  
  ,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])+sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob  
  ,SUM([Total_ANM_with_UID_Linked])+SUM([Total_ANM2_with_UID_Linked])+SUM([Total_CHV_with_UID_Linked])+SUM([Total_GNM_with_UID_Linked]) +SUM([Total_LinkWorker_with_UID_Linked])+SUM([Total_MPW_with_UID_Linked]) as Total_With_Bank_UID  
  ,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile  
  --//////////////////  
  ,SUM([DeactiveANM])+SUM([DeactiveANM2])+SUM([DeactiveCHV])+SUM([DeactiveGNM])+SUM([DeactiveLW])+SUM([DeactiveMPW])as Total_Deactive_Registered  
  ,SUM([DeactiveANM_WithBank])+SUM([DeactiveANM2_WithBank])+SUM([DeactiveCHV_WithBank])+SUM([DeactiveGNM_WithBank])+SUM([DeactiveLW_WithBank])+SUM([DeactiveMPW_WithBank])as Total_Deactive_With_Bank  
  ,SUM([DeactiveANM_WithUID])+SUM([DeactiveANM2_WithUID])+SUM([DeactiveCHV_WithUID])+SUM([DeactiveGNM_WithUID])+SUM([DeactiveLW_WithUID])+SUM([DeactiveMPW_WithUID])as Total_Deactive_UID  
  ,SUM([DeactiveANM_WithValPhone])+SUM([DeactiveANM2_WithValPhone])+SUM([DeactiveCHV_WithValPhone])+SUM([DeactiveGNM_WithValPhone])+SUM([DeactiveLW_WithValPhone])+SUM([DeactiveMPW_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
  ,SUM([DeactiveANM_WithUIDLink])+SUM([DeactiveANM2_WithUIDLink])+SUM([DeactiveCHV_WithUIDLink])+SUM([DeactiveGNM_WithUIDLink])+SUM([DeactiveLW_WithUIDLink])+SUM([DeactiveMPW_WithUIDLink])as Total_Deactive_With_Bank_UID  
  ,SUM([Total_ANM_with_VerifiedPhone]) +SUM([Total_ANM2_with_VerifiedPhone]) +SUM([Total_LinkWorker_with_VerifiedPhone])+SUM([Total_MPW_with_VerifiedPhone])+SUM([Total_GNM_with_VerifiedPhone])+SUM([Total_CHV_with_VerifiedPhone])as IsVerified 
FROM dbo.Scheduled_AC_GF_State_District   
where State_Code=@State_Code  
group by State_Code,District_Code  
)     
 B on  A.State_Code =B.State_Code and A.District_Code=B.District_Code   
    
end  
else   
begin  
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName   
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified
  from      
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name    
 from  TBL_DISTRICT a     
 inner join TBL_STATE b on a.StateID=b.StateID    
     
) A    
left outer join    
(    
    select  State_Code,District_Code  
    ,sum([Total_ASHA]) as Total_Registered  
    ,sum([Total_ASHA_with_ACC]) as Total_With_Bank  
    ,sum([Total_ASHA_with_UID]) as Total_UID  
    ,sum([Total_ASHA_with_ValidatedPhone]) as Total_GF_Validated_Mob  
    ,SUM([Total_ASHA_with_UID_Linked]) as Total_With_Bank_UID  
    ,SUM([DeactiveASHA])as Total_Deactive_Registered  
    ,SUM([DeactiveASHA_WithBank])as Total_Deactive_With_Bank  
    ,SUM([DeactiveASHA_WithUID])as Total_Deactive_UID  
    ,SUM([DeactiveASHA_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
    ,SUM([DeactiveASHA_WithUIDLink]) as Total_Deactive_With_Bank_UID  
    ,SUM([Total_ASHA_withD_Mob]) as Total_GF_With_Mobile 
    ,SUM(Total_ASHA_with_VerifiedPhone)as IsVerified  
    FROM dbo.Scheduled_AC_GF_State_District a  
   inner join RCH_National_Level.dbo. [State_dis_Detail]  b on a.State_Code=b.StateID and a.District_Code=b.District_ID   
  where StateID=@State_Code  
  group by State_Code,District_Code  
  --order by b.District_Name  
  )     
 B on A.State_Code =B.State_Code and A.District_Code=B.District_Code   
end  
  
  
  
end  
  
else if(@Category='District')  
Begin  
  
if(@Type=2)--ANM  
begin  
   
  select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName  
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified 
  from      
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
 from TBL_HEALTH_BLOCK a    
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD    
 where a.DISTRICT_CD=@District_Code    
) A    
left outer join    
(  select  District_ID,HealthBlock_ID   
 ,sum([Total_ANM])+SUM(Total_ANM2)+SUM(Total_CHV)+SUM(Total_GNM)+SUM(Total_LinkWorker)+SUM(Total_MPW) as Total_Registered  
  ,sum([Total_ANM_with_ACC])+SUM([Total_ANM2_with_ACC])+SUM([Total_CHV_with_ACC])+SUM([Total_GNM_with_ACC])  
  +SUM([Total_LinkWorker_with_ACC])+SUM(Total_MPW_with_ACC) as Total_With_Bank  
  ,sum([Total_ANM_with_UID])+sum([Total_ANM2_with_UID])+sum([Total_CHV_with_UID])+sum([Total_GNM_with_UID])+sum([Total_LinkWorker_with_UID])  
  +sum([Total_MPW_with_UID])  as Total_UID  
  ,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])  
  +sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob  
  ,SUM([Total_ANM_with_UID_Linked])+SUM([Total_ANM2_with_UID_Linked])+SUM([Total_CHV_with_UID_Linked])+SUM([Total_GNM_with_UID_Linked])  
  +SUM([Total_LinkWorker_with_UID_Linked])+SUM([Total_MPW_with_UID_Linked]) as Total_With_Bank_UID  
  ,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile  
   --//////////////////  
  ,SUM([DeactiveANM])+SUM([DeactiveANM2])+SUM([DeactiveCHV])+SUM([DeactiveGNM])+SUM([DeactiveLW])+SUM([DeactiveMPW])as Total_Deactive_Registered  
  ,SUM([DeactiveANM_WithBank])+SUM([DeactiveANM2_WithBank])+SUM([DeactiveCHV_WithBank])+SUM([DeactiveGNM_WithBank])+SUM([DeactiveLW_WithBank])+SUM([DeactiveMPW_WithBank])as Total_Deactive_With_Bank  
  ,SUM([DeactiveANM_WithUID])+SUM([DeactiveANM2_WithUID])+SUM([DeactiveCHV_WithUID])+SUM([DeactiveGNM_WithUID])+SUM([DeactiveLW_WithUID])+SUM([DeactiveMPW_WithUID])as Total_Deactive_UID  
  ,SUM([DeactiveANM_WithValPhone])+SUM([DeactiveANM2_WithValPhone])+SUM([DeactiveCHV_WithValPhone])+SUM([DeactiveGNM_WithValPhone])+SUM([DeactiveLW_WithValPhone])+SUM([DeactiveMPW_WithValPhone])  as Total_Deactive_GF_Validated_Mob  
  ,SUM([DeactiveANM_WithUIDLink])+SUM([DeactiveANM2_WithUIDLink])+SUM([DeactiveCHV_WithUIDLink])+SUM([DeactiveGNM_WithUIDLink])+SUM([DeactiveLW_WithUIDLink])+SUM([DeactiveMPW_WithUIDLink])as Total_Deactive_With_Bank_UID  
  ,SUM([Total_ANM_with_VerifiedPhone]) +SUM([Total_ANM2_with_VerifiedPhone]) +SUM([Total_LinkWorker_with_VerifiedPhone])+SUM([Total_MPW_with_VerifiedPhone])+SUM([Total_GNM_with_VerifiedPhone])+SUM([Total_CHV_with_VerifiedPhone])as IsVerified 
  FROM dbo.Scheduled_AC_GF_District_Block   
  where (District_ID=@District_Code)  
  and (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)  
  group by District_ID,HealthBlock_ID   
   ) B on A.District_Code=B.District_ID and A.HealthBlock_Code=B.HealthBlock_ID   
end  
else   
begin  
    select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName  
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID
,ISNULL(IsVerified,0)as IsVerified  
  from      
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
 from TBL_HEALTH_BLOCK a    
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD    
 where a.DISTRICT_CD=@District_Code    
) A    
left outer join    
(  select  District_ID,HealthBlock_ID   
 ,sum([Total_ASHA]) as Total_Registered  
    ,sum([Total_ASHA_with_ACC]) as Total_With_Bank  
    ,sum([Total_ASHA_with_UID]) as Total_UID  
    ,sum([Total_ASHA_with_ValidatedPhone]) as Total_GF_Validated_Mob  
    ,SUM([Total_ASHA_with_UID_Linked]) as Total_With_Bank_UID  
    ,SUM([DeactiveASHA])as Total_Deactive_Registered  
    ,SUM([DeactiveASHA_WithBank])as Total_Deactive_With_Bank  
    ,SUM([DeactiveASHA_WithUID])as Total_Deactive_UID  
    ,SUM([DeactiveASHA_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
    ,SUM([DeactiveASHA_WithUIDLink]) as Total_Deactive_With_Bank_UID  
    ,SUM([Total_ASHA_withD_Mob]) as Total_GF_With_Mobile
    ,SUM(Total_ASHA_with_VerifiedPhone)as IsVerified  
  FROM dbo.Scheduled_AC_GF_District_Block a  
  where (District_ID=@District_Code or @District_Code=0)   
  and (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)  
  group by District_ID,HealthBlock_ID  
   ) B on A.District_Code=B.District_ID and A.HealthBlock_Code=B.HealthBlock_ID   
end  
  
  
  
end  
  
  
else if(@Category='Block')  
Begin  
  
if(@Type=2)--ANM  
begin  
   
 select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName  
 ,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified  
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
  ,sum([Total_ANM])+SUM(Total_ANM2)+SUM(Total_CHV)+SUM(Total_GNM)+SUM(Total_LinkWorker)+SUM(Total_MPW) as Total_Registered  
  ,sum([Total_ANM_with_ACC])+SUM([Total_ANM2_with_ACC])+SUM([Total_CHV_with_ACC])+SUM([Total_GNM_with_ACC])  
  +SUM([Total_LinkWorker_with_ACC])+SUM(Total_MPW_with_ACC) as Total_With_Bank  
  ,sum([Total_ANM_with_UID])+sum([Total_ANM2_with_UID])+sum([Total_CHV_with_UID])+sum([Total_GNM_with_UID])+sum([Total_LinkWorker_with_UID])  
  +sum([Total_MPW_with_UID])  as Total_UID  
  ,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])  
  +sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob  
  ,SUM([Total_ANM_with_UID_Linked])+SUM([Total_ANM2_with_UID_Linked])+SUM([Total_CHV_with_UID_Linked])+SUM([Total_GNM_with_UID_Linked])  
  +SUM([Total_LinkWorker_with_UID_Linked])+SUM([Total_MPW_with_UID_Linked]) as Total_With_Bank_UID  
  ,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile  
  
   --//////////////////  
  ,SUM([DeactiveANM])+SUM([DeactiveANM2])+SUM([DeactiveCHV])+SUM([DeactiveGNM])+SUM([DeactiveLW])+SUM([DeactiveMPW])as Total_Deactive_Registered  
  ,SUM([DeactiveANM_WithBank])+SUM([DeactiveANM2_WithBank])+SUM([DeactiveCHV_WithBank])+SUM([DeactiveGNM_WithBank])+SUM([DeactiveLW_WithBank])+SUM([DeactiveMPW_WithBank])as Total_Deactive_With_Bank  
  ,SUM([DeactiveANM_WithUID])+SUM([DeactiveANM2_WithUID])+SUM([DeactiveCHV_WithUID])+SUM([DeactiveGNM_WithUID])+SUM([DeactiveLW_WithUID])+SUM([DeactiveMPW_WithUID])as Total_Deactive_UID  
  ,SUM([DeactiveANM_WithValPhone])+SUM([DeactiveANM2_WithValPhone])+SUM([DeactiveCHV_WithValPhone])+SUM([DeactiveGNM_WithValPhone])+SUM([DeactiveLW_WithValPhone])+SUM([DeactiveMPW_WithValPhone])  as Total_Deactive_GF_Validated_Mob  
  ,SUM([DeactiveANM_WithUIDLink])+SUM([DeactiveANM2_WithUIDLink])+SUM([DeactiveCHV_WithUIDLink])+SUM([DeactiveGNM_WithUIDLink])+SUM([DeactiveLW_WithUIDLink])+SUM([DeactiveMPW_WithUIDLink])as Total_Deactive_With_Bank_UID  
  ,SUM([Total_ANM_with_VerifiedPhone]) +SUM([Total_ANM2_with_VerifiedPhone]) +SUM([Total_LinkWorker_with_VerifiedPhone])+SUM([Total_MPW_with_VerifiedPhone])+SUM([Total_GNM_with_VerifiedPhone])+SUM([Total_CHV_with_VerifiedPhone])as IsVerified 
--,SUM([DeactiveAWW]),SUM([DeactiveAWW_WithUID]),SUM([DeactiveAWW_WithBank]),SUM([DeactiveAWW_WithUIDLink])  
      
  FROM dbo.Scheduled_AC_GF_Block_PHC a  
  where (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)  
  and (PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)  
  group by HealthBlock_ID,PHC_ID  
  --order by b.District_Name  
  )  B on A.HealthBlock_Code=B.HealthBlock_ID and A.HealthFacility_Code=B.PHC_ID  
end  
else   
begin  
    select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName  
 ,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID
,ISNULL(IsVerified,0)as IsVerified  
  from    
 (select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name  
     from TBL_PHC  a  
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD  
  where (a.BID=@HealthBlock_Code)  
) A  
left outer join  
(  
  select HealthBlock_ID,PHC_ID  
   ,sum([Total_ASHA]) as Total_Registered  
    ,sum([Total_ASHA_with_ACC]) as Total_With_Bank  
    ,sum([Total_ASHA_with_UID]) as Total_UID  
    ,sum([Total_ASHA_with_ValidatedPhone]) as Total_GF_Validated_Mob  
    ,SUM([Total_ASHA_with_UID_Linked]) as Total_With_Bank_UID  
    ,SUM([DeactiveASHA])as Total_Deactive_Registered  
    ,SUM([DeactiveASHA_WithBank])as Total_Deactive_With_Bank  
    ,SUM([DeactiveASHA_WithUID])as Total_Deactive_UID  
    ,SUM([DeactiveASHA_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
    ,SUM([DeactiveASHA_WithUIDLink]) as Total_Deactive_With_Bank_UID  
    ,SUM([Total_ASHA_withD_Mob]) as Total_GF_With_Mobile 
    ,SUM(Total_ASHA_with_VerifiedPhone)as IsVerified  
  FROM dbo.Scheduled_AC_GF_Block_PHC a  
  where (HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)  
  and (PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)  
  group by HealthBlock_ID,PHC_ID  
  )  B on A.HealthBlock_Code=B.HealthBlock_ID and A.HealthFacility_Code=B.PHC_ID  
end  
  
  
  
end  
  
  
else if(@Category='PHC' )  
Begin  
  
if(@Type=2)--ANM  
begin  
   
  select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName  
 ,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified  
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
 ,sum([Total_ANM])+SUM(Total_ANM2)+SUM(Total_CHV)+SUM(Total_GNM)+SUM(Total_LinkWorker)+SUM(Total_MPW) as Total_Registered  
  ,sum([Total_ANM_with_ACC])+SUM([Total_ANM2_with_ACC])+SUM([Total_CHV_with_ACC])+SUM([Total_GNM_with_ACC])  
  +SUM([Total_LinkWorker_with_ACC])+SUM(Total_MPW_with_ACC) as Total_With_Bank  
  ,sum([Total_ANM_with_UID])+sum([Total_ANM2_with_UID])+sum([Total_CHV_with_UID])+sum([Total_GNM_with_UID])+sum([Total_LinkWorker_with_UID])  
  +sum([Total_MPW_with_UID])  as Total_UID  
  ,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])  
  +sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob  
  ,SUM([Total_ANM_with_UID_Linked])+SUM([Total_ANM2_with_UID_Linked])+SUM([Total_CHV_with_UID_Linked])+SUM([Total_GNM_with_UID_Linked])  
  +SUM([Total_LinkWorker_with_UID_Linked])+SUM([Total_MPW_with_UID_Linked]) as Total_With_Bank_UID  
  ,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile  
  
   --//////////////////  
  ,SUM([DeactiveANM])+SUM([DeactiveANM2])+SUM([DeactiveCHV])+SUM([DeactiveGNM])+SUM([DeactiveLW])+SUM([DeactiveMPW])as Total_Deactive_Registered  
  ,SUM([DeactiveANM_WithBank])+SUM([DeactiveANM2_WithBank])+SUM([DeactiveCHV_WithBank])+SUM([DeactiveGNM_WithBank])+SUM([DeactiveLW_WithBank])+SUM([DeactiveMPW_WithBank])as Total_Deactive_With_Bank  
  ,SUM([DeactiveANM_WithUID])+SUM([DeactiveANM2_WithUID])+SUM([DeactiveCHV_WithUID])+SUM([DeactiveGNM_WithUID])+SUM([DeactiveLW_WithUID])+SUM([DeactiveMPW_WithUID])as Total_Deactive_UID  
  ,SUM([DeactiveANM_WithValPhone])+SUM([DeactiveANM2_WithValPhone])+SUM([DeactiveCHV_WithValPhone])+SUM([DeactiveGNM_WithValPhone])+SUM([DeactiveLW_WithValPhone])+SUM([DeactiveMPW_WithValPhone])  as Total_Deactive_GF_Validated_Mob  
  ,SUM([DeactiveANM_WithUIDLink])+SUM([DeactiveANM2_WithUIDLink])+SUM([DeactiveCHV_WithUIDLink])+SUM([DeactiveGNM_WithUIDLink])+SUM([DeactiveLW_WithUIDLink])+SUM([DeactiveMPW_WithUIDLink])as Total_Deactive_With_Bank_UID  
  ,SUM([Total_ANM_with_VerifiedPhone]) +SUM([Total_ANM2_with_VerifiedPhone]) +SUM([Total_LinkWorker_with_VerifiedPhone])+SUM([Total_MPW_with_VerifiedPhone])+SUM([Total_GNM_with_VerifiedPhone])+SUM([Total_CHV_with_VerifiedPhone])as IsVerified 
      
  FROM dbo.Scheduled_AC_GF_PHC_Subcenter   
  where (PHC_ID=@HealthFacility_Code)  
  and (Subcenter_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  group by PHC_ID,Subcenter_ID  
  --order by PHC_ID,Subcenter_ID  
  )  B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.Subcenter_ID  
end  
else   
begin  
select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName  
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID 
,ISNULL(IsVerified,0)as IsVerified 
  from   
 (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name  
      from TBL_SUBPHC a  
   inner join TBL_PHC b on a.PHC_CD=b.PHC_CD  
     where ( a.PHC_CD= @HealthFacility_Code )  
      and ( a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)  
) A  
left outer join  
(  
  select Subcenter_ID,PHC_ID  
   ,sum([Total_ASHA]) as Total_Registered  
    ,sum([Total_ASHA_with_ACC]) as Total_With_Bank  
    ,sum([Total_ASHA_with_UID]) as Total_UID  
    ,sum([Total_ASHA_with_ValidatedPhone]) as Total_GF_Validated_Mob  
    ,SUM([Total_ASHA_with_UID_Linked]) as Total_With_Bank_UID  
    ,SUM([DeactiveASHA])as Total_Deactive_Registered  
    ,SUM([DeactiveASHA_WithBank])as Total_Deactive_With_Bank  
    ,SUM([DeactiveASHA_WithUID])as Total_Deactive_UID  
    ,SUM([DeactiveASHA_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
    ,SUM([DeactiveASHA_WithUIDLink]) as Total_Deactive_With_Bank_UID  
    ,SUM([Total_ASHA_withD_Mob]) as Total_GF_With_Mobile  
    ,SUM(Total_ASHA_with_VerifiedPhone)as IsVerified  
  FROM dbo.Scheduled_AC_GF_PHC_Subcenter a  
  where (PHC_ID=@HealthFacility_Code)  
  and (Subcenter_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  group by PHC_ID,Subcenter_ID  
  --order by PHC_ID,Subcenter_ID  
  )  B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.Subcenter_ID  
end  
  
  
  
end  
else if(@Category='SubCentre')  
Begin  
  
if(@Type=2)--ANM  
begin  
   
  select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName  
 ,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified  
from   
 (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name  
  from TBL_SUBPHC a  
  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD  
  where (a.PHC_CD= @HealthFacility_Code)  
  and (a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  union  
  select a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name ,0 as HealthSubFacility_Code,'Direct Entry' as HealthSubFacility_Name  
  from TBL_PHC a   
  where (a.PHC_CD= @HealthFacility_Code)  
    
) A  
left outer join  
(  
 select Subcenter_ID,PHC_ID  
 ,sum([Total_ANM])+SUM(Total_ANM2)+SUM(Total_CHV)+SUM(Total_GNM)+SUM(Total_LinkWorker)+SUM(Total_MPW) as Total_Registered  
  ,sum([Total_ANM_with_ACC])+SUM([Total_ANM2_with_ACC])+SUM([Total_CHV_with_ACC])+SUM([Total_GNM_with_ACC])  
  +SUM([Total_LinkWorker_with_ACC])+SUM(Total_MPW_with_ACC) as Total_With_Bank  
  ,sum([Total_ANM_with_UID])+sum([Total_ANM2_with_UID])+sum([Total_CHV_with_UID])+sum([Total_GNM_with_UID])+sum([Total_LinkWorker_with_UID])  
  +sum([Total_MPW_with_UID])  as Total_UID  
  ,sum([Total_ANM_with_ValidatedPhone])+sum([Total_ANM2_with_ValidatedPhone])+sum([Total_CHV_with_ValidatedPhone])  
  +sum([Total_GNM_with_ValidatedPhone])+sum([Total_LinkWorker_with_ValidatedPhone])+sum([Total_MPW_with_ValidatedPhone]) as Total_GF_Validated_Mob  
  ,SUM([Total_ANM_with_UID_Linked])+SUM([Total_ANM2_with_UID_Linked])+SUM([Total_CHV_with_UID_Linked])+SUM([Total_GNM_with_UID_Linked])  
  +SUM([Total_LinkWorker_with_UID_Linked])+SUM([Total_MPW_with_UID_Linked]) as Total_With_Bank_UID  
  ,SUM([Total_ANM_with_Mob])+SUM([Total_ANM2_with_Mob])+SUM([Total_CHV_with_Mob])+SUM([Total_GNM_with_Mob]) +SUM([Total_LinkWorker_with_Mob])+SUM([Total_MPW_with_Mob]) as Total_GF_With_Mobile  
  
   --//////////////////  
  ,SUM([DeactiveANM])+SUM([DeactiveANM2])+SUM([DeactiveCHV])+SUM([DeactiveGNM])+SUM([DeactiveLW])+SUM([DeactiveMPW])as Total_Deactive_Registered  
  ,SUM([DeactiveANM_WithBank])+SUM([DeactiveANM2_WithBank])+SUM([DeactiveCHV_WithBank])+SUM([DeactiveGNM_WithBank])+SUM([DeactiveLW_WithBank])+SUM([DeactiveMPW_WithBank])as Total_Deactive_With_Bank  
  ,SUM([DeactiveANM_WithUID])+SUM([DeactiveANM2_WithUID])+SUM([DeactiveCHV_WithUID])+SUM([DeactiveGNM_WithUID])+SUM([DeactiveLW_WithUID])+SUM([DeactiveMPW_WithUID])as Total_Deactive_UID  
  ,SUM([DeactiveANM_WithValPhone])+SUM([DeactiveANM2_WithValPhone])+SUM([DeactiveCHV_WithValPhone])+SUM([DeactiveGNM_WithValPhone])+SUM([DeactiveLW_WithValPhone])+SUM([DeactiveMPW_WithValPhone])  as Total_Deactive_GF_Validated_Mob  
  ,SUM([DeactiveANM_WithUIDLink])+SUM([DeactiveANM2_WithUIDLink])+SUM([DeactiveCHV_WithUIDLink])+SUM([DeactiveGNM_WithUIDLink])+SUM([DeactiveLW_WithUIDLink])+SUM([DeactiveMPW_WithUIDLink])as Total_Deactive_With_Bank_UID  
  ,SUM([Total_ANM_with_VerifiedPhone]) +SUM([Total_ANM2_with_VerifiedPhone]) +SUM([Total_LinkWorker_with_VerifiedPhone])+SUM([Total_MPW_with_VerifiedPhone])+SUM([Total_GNM_with_VerifiedPhone])+SUM([Total_CHV_with_VerifiedPhone])as IsVerified 
      
  FROM dbo.Scheduled_AC_GF_PHC_Subcenter   
  where (PHC_ID=@HealthFacility_Code)  
  and (Subcenter_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  group by PHC_ID,Subcenter_ID  
  --order by PHC_ID,Subcenter_ID  
  )  B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.Subcenter_ID  
end  
else   
begin  
select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName  
,ISNULL(Total_Registered,0) as Total_Registered  
,ISNULL(Total_With_Bank,0) as Total_With_Bank  
,ISNULL(Total_UID,0)as Total_UID  
,ISNULL(Total_GF_Validated_Mob,0) as Total_GF_Validated_Mob  
,ISNULL(Total_With_Bank_UID,0) as Total_With_Bank_UID  
,ISNULL(Total_GF_With_Mobile,0) as  Total_GF_With_Mobile  
,ISNULL(Total_Deactive_Registered,0)as Total_Deactive_Registered  
,Isnull(Total_Deactive_With_Bank,0)as Total_Deactive_With_Bank  
,Isnull(Total_Deactive_UID,0)as Total_Deactive_UID  
,Isnull(Total_Deactive_GF_Validated_Mob,0)as  Total_Deactive_GF_Validated_Mob  
,Isnull(Total_Deactive_With_Bank_UID,0)as Total_Deactive_With_Bank_UID  
,ISNULL(IsVerified,0)as IsVerified
  from   
 (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name  
      from TBL_SUBPHC a  
   inner join TBL_PHC b on a.PHC_CD=b.PHC_CD  
     where ( a.PHC_CD= @HealthFacility_Code )  
      and ( a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)  
) A  
left outer join  
(  
  select Subcenter_ID,PHC_ID  
   ,sum([Total_ASHA]) as Total_Registered  
    ,sum([Total_ASHA_with_ACC]) as Total_With_Bank  
    ,sum([Total_ASHA_with_UID]) as Total_UID  
    ,sum([Total_ASHA_with_ValidatedPhone]) as Total_GF_Validated_Mob  
    ,SUM([Total_ASHA_with_UID_Linked]) as Total_With_Bank_UID  
    ,SUM([DeactiveASHA])as Total_Deactive_Registered  
    ,SUM([DeactiveASHA_WithBank])as Total_Deactive_With_Bank  
    ,SUM([DeactiveASHA_WithUID])as Total_Deactive_UID  
    ,SUM([DeactiveASHA_WithValPhone]) as Total_Deactive_GF_Validated_Mob  
    ,SUM([DeactiveASHA_WithUIDLink]) as Total_Deactive_With_Bank_UID  
    ,SUM([Total_ASHA_withD_Mob]) as Total_GF_With_Mobile  
    ,SUM(Total_ASHA_with_VerifiedPhone)as IsVerified  
  FROM dbo.Scheduled_AC_GF_PHC_Subcenter a  
  where (PHC_ID=@HealthFacility_Code)  
  and (Subcenter_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  group by PHC_ID,Subcenter_ID  
  --order by PHC_ID,Subcenter_ID  
  )  B on A.HealthFacility_Code=B.PHC_ID and A.HealthSubFacility_Code=B.Subcenter_ID  
end  
  
  
  
end  
END  
  
  
  
  