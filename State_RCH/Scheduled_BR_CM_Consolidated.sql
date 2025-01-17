USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_BR_CM_Consolidated]    Script Date: 09/26/2024 14:43:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER procedure [dbo].[Schedule_BR_CM_Consolidated]    
as    
begin    
truncate table Scheduled_BR_CM_Consolidated    
insert into Scheduled_BR_CM_Consolidated    
Select a.ID as DistrictID    
,[Total_Taluka]    
,([Block_Type_0]+[Block_Type_1]+[Block_Type_2]+[Block_Type_3])Total_Block    
,([FacilityType_1]+[FacilityType_2]+[FacilityType_3]+[FacilityType_4]+[FacilityType_5]+[FacilityType_6]+[FacilityType_7]+[FacilityType_8]    
+[FacilityType_9]+[FacilityType_10]+[FacilityType_11]+[FacilityType_12]+[FacilityType_13]+[FacilityType_14]+[FacilityType_15]    
+[FacilityType_16]+[FacilityType_17]+[FacilityType_18]+[FacilityType_19]+[FacilityType_20]+[FacilityType_100]) as Total_PHC    
,([SubFacilityType_1]+[SubFacilityType_2]+[SubFacilityType_3]+[SubFacilityType_4]+[SubFacilityType_5]+[SubFacilityType_6]+[SubFacilityType_7]) as[Total_Subcentre]    
,([Village_Type_1]+[Village_Type_2]+[Village_Type_3]+[Village_Type_4])[Total_Village]    
,[Total_SubVillage]    
,[FacilityType_1],[FacilityType_2],[FacilityType_3],[FacilityType_4],[FacilityType_5],[FacilityType_6],[FacilityType_7],[FacilityType_8],[FacilityType_9]    
,[FacilityType_10],[FacilityType_11],[FacilityType_12],[FacilityType_13],[FacilityType_14],[FacilityType_15],[FacilityType_16],[FacilityType_17]    
,[FacilityType_18],[FacilityType_19],[FacilityType_20],[FacilityType_100],[FacilityType_Notional],[FacilityType_Tribal],[FacilityType_DEP]    
,[FacilityType_24_7],[Block_Type_0],[Block_Type_1],[Block_Type_2],[Block_Type_3],[SubFacilityType_1],[SubFacilityType_2],[SubFacilityType_3]    
,[SubFacilityType_4],[SubFacilityType_5],[SubFacilityType_6],[SubFacilityType_7],[SubFacility_Notional],[SubFacility_Tribal],[SubFacility_DEP]    
,[District_MDDS],[Taluka_MDDS],[Block_MDDS],[Village_MDDS],[SubVillage_MDDS],[District_MDDSVerified],[Taluka_MDDSVerified],[Block_MDDSVerified]    
,[Village_MDDSVerified],[SubVillage_MDDSVerified],[Village_Type_1],[Village_Type_2],[Village_Type_3],[Village_Type_4],[Subfacility_1_Village]    
,[Subfacility_2_Village],[Subfacility_3_Village],[Subfacility_4_Village],[Subfacility_5M_Village],[Total_Block_Mapped],[Total_PHC_Mapped]    
,[Total_SC_Mapped],[Total_Village_Mapped],[Total_SubVillage_Mapped],GETDATE(),Subfacility_2M_Village,Village_1_SC,Village_2M_SC     
,FacilityType_NIN,SubFacility_NIN    
from    
    
(Select DIST_CD as ID    
,(case when ISNULL(MDDS_Code,0)=0 then 0 else 1 end) as District_MDDS     
,(case when ISNULL(DVerified,0)=0 then 0 else 1 end) as District_MDDSVerified     
from TBL_DISTRICT) A    
left outer join     
(Select DIST_CD as ID,Count(Tal_Cd) as Total_Taluka    
,SUM((case when ISNULL(MDDS_Code,0)=0 then 0 else 1 end)) as Taluka_MDDS     
,SUM((case when ISNULL(IsVerified,0)=0 then 0 else 1 end)) as Taluka_MDDSVerified     
 from TBL_TALUKA group by DIST_CD) B on A.ID=B.ID    
left outer join     
(    
SELECT DISTRICT_CD as ID, [0] AS Block_Type_0, [1] AS Block_Type_1, [2] AS Block_Type_2, [3] AS Block_Type_3    
FROM     
(SELECT BLOCK_CD, Block_Type, DISTRICT_CD    
FROM TBL_HEALTH_BLOCK) p    
PIVOT    
(    
COUNT (BLOCK_CD)    
FOR Block_Type IN    
( [0], [1], [2], [3] )    
) AS pvt    
     
) C on A.ID=C.ID     
left outer join    
(    
SELECT DIST_CD as ID, [1] as FacilityType_1, [2] as FacilityType_2, [3] as FacilityType_3, [4] as FacilityType_4, [5] as FacilityType_5    
, [6] as FacilityType_6, [7] as FacilityType_7, [8] as FacilityType_8, [9] as FacilityType_9, [10] as FacilityType_10, [11] as FacilityType_11    
, [12] as FacilityType_12, [13] as FacilityType_13, [14] as FacilityType_14, [15] as FacilityType_15, [16] as FacilityType_16, [17] as FacilityType_17    
, [18] as FacilityType_18, [19] as FacilityType_19, [20] as FacilityType_20, [100] as FacilityType_100    
FROM     
(SELECT PHC_CD, Facility_Type, DIST_CD    
FROM TBL_PHC) p    
PIVOT    
(    
COUNT (PHC_CD)    
FOR Facility_Type IN    
( [1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [100] )    
) AS pvt    
 ) D on A.ID=D.ID    
left outer join    
(    
SELECT DIST_CD as ID, [1] as SubFacilityType_1, [2] as SubFacilityType_2, [3] as SubFacilityType_3, [4] as SubFacilityType_4, [5] as SubFacilityType_5    
, [6] as SubFacilityType_6, [7] as SubFacilityType_7    
FROM     
(SELECT SUBPHC_CD, SubFacility_Type, DIST_CD    
FROM TBL_SUBPHC) p    
PIVOT    
(    
COUNT (SUBPHC_CD)    
FOR SubFacility_Type IN    
( [1], [2], [3], [4], [5], [6], [7])    
) AS pvt    
     
) E on A.ID=E.ID     
left outer join    
(    
SELECT DCode as ID, [1] as Village_Type_1, [2] as Village_Type_2, [3] as Village_Type_3, [4] as Village_Type_4    
FROM     
(SELECT VCode, Village_Type, DCode    
FROM Cen_Village ) p    ----- (Village where VCode<10000000) by Cen_Village change on 14-06-2019 
PIVOT    
(    
COUNT (VCode)    
FOR Village_Type IN    
( [1], [2], [3], [4])    
) AS pvt    
     
) F on A.ID=F.ID     
left outer join    
(    
Select DCode as ID    
--,SUM((case when VCode<10000000 and ISNULL(MDDS_Code,0)=0 then 0 else 1 end)) as Village_MDDS 
--,SUM((case when VCode<10000000 and ISNULL(IsVerified,0)=0 then 0 else 1 end)) as Village_MDDSVerified     
--,SUM((case when VCode>10000000 and ISNULL(MDDS_Code,0)=0 then 1 else 1 end)) as SubVillage_MDDS  
--,SUM((case when VCode>10000000 and ISNULL(IsVerified,0)=0 then 0 else 1 end)) as SubVillage_MDDSVerified  

,SUM((case when VCode<10000000 and ISNULL(MDDS_Code,0)<>0 then 1 else 0 end)) as Village_MDDS     
,SUM((case when VCode<10000000 and IsVerified=1 and ISNULL(MDDS_Code,0)!=0  then 1 else 0 end)) as Village_MDDSVerified  ----Village_MDDS 
,SUM((case when VCode>10000000 then 1 else 0 end)) as Total_SubVillage    
 ,SUM((case when VCode>10000000 and ISNULL(MDDS_Code,0)<>0 then 1 else 0 end)) as SubVillage_MDDS    
,SUM((case when VCode>10000000 and IsVerified=1 and ISNULL(MDDS_Code,0)!=0 then 1 else 0 end)) as SubVillage_MDDSVerified    
 from Village    
 Group by DCode    
) G on A.ID=G.ID      
left outer join    
(    
Select DIST_CD as ID    
,SUM((case when ISNULL(Is_Notional,0)=0 then 0 else 1 end)) as FacilityType_Notional    
,SUM((case when ISNULL(Is_Tribal,0)=0 then 0 else 1 end)) as FacilityType_Tribal     
,SUM((case when ISNULL(Is_DataEntryPoint,0)=0 then 0 else 1 end)) as FacilityType_DEP    
,SUM((case when ISNULL(Is_WorkingAlways,0)=0 then 0 else 1 end)) as FacilityType_24_7    
,SUM((case when ISNULL(HF_NIN,0)=0 then 0 else 1 end)) as FacilityType_NIN    
,COUNT(Distinct BID) as Total_Block_Mapped    
 from TBL_PHC    
 Group by DIST_CD    
) H on A.ID=H.ID      
left outer join    
(    
Select DIST_CD as ID    
,SUM((case when ISNULL(Is_Notional,0)=0 then 0 else 1 end)) as SubFacility_Notional    
,SUM((case when ISNULL(Is_Tribal,0)=0 then 0 else 1 end)) as SubFacility_Tribal     
,SUM((case when ISNULL(Is_DataEntryPoint,0)=0 then 0 else 1 end)) as SubFacility_DEP    
,SUM((case when ISNULL(HSF_NIN,0)=0 then 0 else 1 end)) as SubFacility_NIN    
,COUNT(Distinct PHC_CD) as Total_PHC_Mapped    
 from TBL_SUBPHC    
 Group by DIST_CD    
) I on A.ID=I.ID      
left outer join    
(    
 Select DIST_CD as ID    
 ,SUM((case when Total_villages_Mapped=1 then 1 else 0 end)) as Subfacility_1_Village     
 ,SUM((case when Total_villages_Mapped=2 then 1 else 0 end)) as Subfacility_2_Village     
 ,SUM((case when Total_villages_Mapped=3 then 1 else 0 end)) as Subfacility_3_Village     
 ,SUM((case when Total_villages_Mapped=4 then 1 else 0 end)) as Subfacility_4_Village     
 ,SUM((case when Total_villages_Mapped>4 then 1 else 0 end)) as Subfacility_5M_Village     
 ,SUM((case when Total_villages_Mapped>=2 then 1 else 0 end)) as Subfacility_2M_Village     
 ,count(SUBPHC_CD) as Total_SC_Mapped    
 from    
 (    
  Select DIST_CD, SUBPHC_CD,COUNT(Village_CD) as Total_villages_Mapped from TBL_VILLAGE    
  group by DIST_CD, SUBPHC_CD    
 ) X    
 group by DIST_CD    
) J on A.ID=J.ID    
left outer join    
(Select DISTRICT_CD as ID    
,SUM((case when ISNULL(MDDS_Code,0)=0 then 0 else 1 end)) as Block_MDDS     
,SUM((case when ISNULL(BVerified,0)=0 then 0 else 1 end)) as Block_MDDSVerified     
 from TBL_HEALTH_BLOCK    
 group by DISTRICT_CD    
 )K on A.ID=K.ID    
 left outer join    
(Select DIST_CD as ID    
,COUNT(distinct Village_CD) as Total_Village_Mapped    
 from TBL_VILLAGE where VILLAGE_CD<10000000    
 group by DIST_CD    
 )L on A.ID=L.ID    
 left outer join    
(Select DIST_CD as ID    
,COUNT(distinct Village_CD) as Total_SubVillage_Mapped    
 from TBL_VILLAGE where VILLAGE_CD>10000000    
 group by DIST_CD    
 )M on A.ID=M.ID    
 left outer join    
(    
 Select DIST_CD as ID    
 ,SUM((case when Total_SC_Mapped=1 then 1 else 0 end)) as Village_1_SC    
 ,SUM((case when Total_SC_Mapped>=2 then 1 else 0 end)) as Village_2M_SC     
 from    
 (    
  Select DIST_CD, Village_CD,COUNT(SUBPHC_CD) as Total_SC_Mapped from TBL_VILLAGE      
  group by DIST_CD, Village_CD    
 ) X    
 group by DIST_CD    
) N on A.ID=N.ID    
End    

