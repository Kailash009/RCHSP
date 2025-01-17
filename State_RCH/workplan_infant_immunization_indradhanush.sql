USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[workplan_infant_immunization_indradhanush]    Script Date: 09/26/2024 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
/****** Script for SelectTopNRows command from SSMS  ******/        
/*        
workplan_infant_immunization_indradhanush 30,1,0,0,0,0,0,0,1,2018,8,'State',0,0,0      
workplan_infant_immunization_indradhanush 30,1,0,0,0,0,0,0,1,2019,10,'District',0,0,0     
workplan_infant_immunization_indradhanush 30,1,2,0,0,0,0,0,1,2019,10,'Block',0,0,0     
workplan_infant_immunization_indradhanush 30,1,3,26,0,0,0,0,1,2018,8,'PHC',0,0,0       
    
workplan_infant_immunization_indradhanush 30,1,3,11,0,0,0,0,1,2018,8,'PHC',0,0,0      
workplan_infant_immunization_indradhanush 30,1,3,12,0,0,0,0,1,2018,8,'PHC',0,0,0      
        
*/        
ALTER proc [dbo].[workplan_infant_immunization_indradhanush]        
(        
@State_Code int=0,  --        
@District_Code int=0,  --        
@HealthBlock_Code int=0,  --        
@HealthFacility_Code int=0, --         
@HealthSubFacility_Code int=0, --        
@Village_Code int=0, --        
@Is_ANMASHA as int=0,        
@ANMASHA_ID int=0,            
@Period_ID int, --        
@Year_ID as int=0, --        
@Month_ID as int=0, --        
--@Quarter_ID as int=0,        
@Category varchar(10), --        
@Services int=0,        
@Is_Service int=0,        
@Workplan_For int=0         
)        
as        
begin  
  
SET NOCOUNT ON        
        
if(@Category = 'State')        
begin        
------------------------------------------------------------------------------------        
 -------------------------------due        
 SELECT A.[State_Code] as ParentID,A.[District_Code] as ChildID,A.State_Name as ParentName,A.District_Name as ChildName        
 ,isnull(Due_vaccination_1yr,0)[Due_vaccination_1yr]          
 ,isnull(Due_vaccination_2yr,0)[Due_vaccination_2yr]        
 ,isnull(No_vaccination_2yr,0)[No_vaccination_2yr]        
 ,isnull([BCG_D_Count],0)[BCG_D_Count]        
 ,isnull([OPV0_D_Count],0)[OPV0_D_Count]        
 ,isnull([HB1_D_Count],0)[HB1_D_Count]        
 ,isnull([DPT1_D_Count],0)[DPT1_D_Count]        
 ,isnull([Penta1_D_Count],0)[Penta1_D_Count]        
 ,isnull([OPV1_D_Count],0)[OPV1_D_Count]        
 ,isnull([HB2_D_Count],0)[HB2_D_Count]        
 ,isnull([DPT2_D_Count],0)[DPT2_D_Count]        
 ,isnull([Penta2_D_Count],0)[Penta2_D_Count]        
 ,isnull([OPV2_D_Count],0)[OPV2_D_Count]        
 ,isnull([HB3_D_Count],0)[HB3_D_Count]        
 ,isnull([DPT3_D_Count],0)[DPT3_D_Count]        
 ,isnull([Penta3_D_Count],0)[Penta3_D_Count]        
 ,isnull([OPV3_D_Count],0)[OPV3_D_Count]        
 ,isnull([HB4_D_Count],0)[HB4_D_Count]        
 ,isnull([Measles_D_Count],0)[Measles_D_Count]        
 ,isnull([Vita_A_1_D_Count],0)[Vita_A_1_D_Count]        
 ,isnull(IPV_1_D_Count,0)[IPV_1_D_Count]        
 ,isnull(IPV_2_D_Count,0)[IPV_2_D_Count]        
 ,isnull(Rota_virus_1_D_Count,0)Rota_virus_1_D_Count        
 ,isnull(Rota_virus_2_D_Count,0)Rota_virus_2_D_Count        
 ,isnull(Rota_virus_3_D_Count,0)Rota_virus_3_D_Count        
 ,ISNULL(MR1_D_Count,0)MR1_D_Count      
 ,ISNULL(MR2_D_Count,0)[MR2_D_Count]      
 ,ISNULL(PCV1_D_Count,0)PCV1_D_Count      
 ,ISNULL(PCV2_D_Count,0)PCV2_D_Count      
 ,ISNULL(PCVB_D_Count,0)PCVB_D_Count    
 ,ISNULL(JE_Vaccine_D_Count,0)JE_Vaccine_D_Count    --Add on 02-12-19     
 ------------------------------given        
 --,isnull(No_vaccination_2yr)[No_vaccination_2yr]        
 ,isnull([BCG_G_Count],0)[BCG_G_Count]        
 ,isnull([OPV0_G_Count],0)[OPV0_G_Count]        
 ,isnull([HB1_G_Count],0)[HB1_G_Count]        
 ,isnull([DPT1_G_Count],0)[DPT1_G_Count]        
 ,isnull([Penta1_G_Count],0)[Penta1_G_Count]        
 ,isnull([OPV1_G_Count],0)[OPV1_G_Count]        
 ,isnull([HB2_G_Count],0)[HB2_G_Count]        
 ,isnull([DPT2_G_Count],0)[DPT2_G_Count]        
 ,isnull([Penta2_G_Count],0)[Penta2_G_Count]        
 ,isnull([OPV2_G_Count],0)[OPV2_G_Count]        
 ,isnull([HB3_G_Count],0)[HB3_G_Count]        
 ,isnull([DPT3_G_Count],0)[DPT3_G_Count]        
 ,isnull([Penta3_G_Count],0)[Penta3_G_Count]        
 ,isnull([OPV3_G_Count],0)[OPV3_G_Count]        
 ,isnull([HB4_G_Count],0)[HB4_G_Count]        
 ,isnull([Measles_G_Count],0)[Measles_G_Count]        
 ,isnull([Vita_A_1_G_Count],0)[Vita_A_1_G_Count]        
 ,isnull(IPV_1_G_Count,0)[IPV_1_G_Count]        
 ,isnull(IPV_2_G_Count,0)[IPV_2_G_Count]        
 ,isnull(Rota_virus_1_G_Count,0)Rota_virus_1_G_Count        
 ,isnull(Rota_virus_2_G_Count,0)Rota_virus_2_G_Count        
 ,isnull(Rota_virus_3_G_Count,0)Rota_virus_3_G_Count      
 ,ISNULL(MR1_G_Count,0)MR1_G_Count      
 ,ISNULL(MR2_G_Count,0)MR2_G_Count      
 ,ISNULL(PCV1_G_Count,0)PCV1_G_Count      
 ,ISNULL(PCV2_G_Count,0)PCV2_G_Count      
 ,ISNULL(PCVB_G_Count,0)PCVB_G_Count  
  ,ISNULL(JE_Vaccine_G_Count,0)JE_Vaccine_G_Count  --Add on 02-12-19         
 ,dbo.Deactivation_Service(0) as ImmuCode           
 FROM         
(        
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                           
from TBL_DISTRICT a WITH (NOLOCK)                            
inner join TBL_STATE b WITH (NOLOCK)  on a.StateID=b.StateID                            
where b.StateID=@State_Code)A          
left outer join         
(        
    SELECT         
    w.State_ID         
    ,w.District_ID         
 ,sum(Due_vaccination_1yr)[Due_vaccination_1yr]        
 ,SUM(Due_vaccination_2yr)[Due_vaccination_2yr]        
 ,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_D_Count])[BCG_D_Count]        
 ,sum([OPV0_D_Count])[OPV0_D_Count]        
 ,sum([HB1_D_Count])[HB1_D_Count]        
 ,sum([DPT1_D_Count])[DPT1_D_Count]        
 ,sum([Penta1_D_Count])[Penta1_D_Count]        
 ,sum([OPV1_D_Count])[OPV1_D_Count]        
 ,sum([HB2_D_Count])[HB2_D_Count]        
 ,sum([DPT2_D_Count])[DPT2_D_Count]        
 ,sum([Penta2_D_Count])[Penta2_D_Count]        
 ,sum([OPV2_D_Count])[OPV2_D_Count]        
 ,sum([HB3_D_Count])[HB3_D_Count]        
 ,sum([DPT3_D_Count])[DPT3_D_Count]        
 ,sum([Penta3_D_Count])[Penta3_D_Count]        
 ,sum([OPV3_D_Count])[OPV3_D_Count]        
 ,sum([HB4_D_Count])[HB4_D_Count]        
 ,sum([Measles_D_Count])[Measles_D_Count]        
 ,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]        
 ,SUM(IPV_1_D_Count)[IPV_1_D_Count]        
 ,SUM(IPV_2_D_Count)[IPV_2_D_Count]        
 ,SUM(Rota_virus_1_D_Count)Rota_virus_1_D_Count        
 ,SUM(Rota_virus_2_D_Count)Rota_virus_2_D_Count        
 ,SUM(Rota_virus_3_D_Count)Rota_virus_3_D_Count        
 ,SUM(MR1_D_Count)MR1_D_Count      
 ,SUM(MR2_D_Count)MR2_D_Count      
 ,SUM(PCV1_D_Count)PCV1_D_Count      
 ,SUM(PCV2_D_Count)PCV2_D_Count      
 ,SUM(PCVB_D_Count)PCVB_D_Count  
  ,SUM(JE_Vaccine_D_Count)JE_Vaccine_D_Count    --Add on 02-12-19       
 ------------------------------given        
 --,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_G_Count])[BCG_G_Count]        
 ,sum([OPV0_G_Count])[OPV0_G_Count]        
 ,sum([HB1_G_Count])[HB1_G_Count]        
 ,sum([DPT1_G_Count])[DPT1_G_Count]        
 ,sum([Penta1_G_Count])[Penta1_G_Count]        
 ,sum([OPV1_G_Count])[OPV1_G_Count]        
 ,sum([HB2_G_Count])[HB2_G_Count]        
 ,sum([DPT2_G_Count])[DPT2_G_Count]        
 ,sum([Penta2_G_Count])[Penta2_G_Count]        
 ,sum([OPV2_G_Count])[OPV2_G_Count]        
 ,sum([HB3_G_Count])[HB3_G_Count]        
 ,sum([DPT3_G_Count])[DPT3_G_Count]        
 ,sum([Penta3_G_Count])[Penta3_G_Count]        
 ,sum([OPV3_G_Count])[OPV3_G_Count]        
 ,sum([HB4_G_Count])[HB4_G_Count]        
 ,sum([Measles_G_Count])[Measles_G_Count]        
 ,sum([Vita_A_1_G_Count])[Vita_A_1_G_Count]        
 ,SUM(IPV_1_G_Count)[IPV_1_G_Count]        
 ,SUM(IPV_2_G_Count)[IPV_2_G_Count]        
 ,SUM(Rota_virus_1_G_Count)Rota_virus_1_G_Count        
 ,SUM(Rota_virus_2_G_Count)Rota_virus_2_G_Count        
 ,SUM(Rota_virus_3_G_Count)Rota_virus_3_G_Count       
 ,SUM(MR1_G_Count)MR1_G_Count       
 ,SUM(MR2_G_Count)MR2_G_Count      
 ,SUM(PCV1_G_Count)PCV1_G_Count      
 ,SUM(PCV2_G_Count)PCV2_G_Count      
 ,SUM(PCVB_G_Count)PCVB_G_Count  
  ,SUM(JE_Vaccine_G_Count)JE_Vaccine_G_Count  --Add on 02-12-19     
 FROM [Scheduled_Infant_Workplan_StateDist_FinYr] w WITH (NOLOCK)         
 where Month_ID=@Month_ID and YEar_ID=@Year_ID and w.State_ID=@State_Code        
 group by w.[State_ID],w.[District_ID])B on A.State_Code=B.State_ID AND A.District_Code=B.District_ID         
         
end        
--------------------------------------------------------------------------------------        
else if(@Category = 'District')        
begin        
 -------------------------------due        
SELECT A.District_Code as ParentID,A.HealthBlock_Code as ChildID,A.District_Name as ParentName,A.HealthBlock_Name as ChildName        
    ,isnull(Due_vaccination_1yr,0)[Due_vaccination_1yr]        
    ,isnull(Due_vaccination_2yr,0)[Due_vaccination_2yr]        
 ,isnull(No_vaccination_2yr,0)[No_vaccination_2yr]        
 ,isnull([BCG_D_Count],0)[BCG_D_Count]        
 ,isnull([OPV0_D_Count],0)[OPV0_D_Count]        
 ,isnull([HB1_D_Count],0)[HB1_D_Count]        
 ,isnull([DPT1_D_Count],0)[DPT1_D_Count]        
 ,isnull([Penta1_D_Count],0)[Penta1_D_Count]        
 ,isnull([OPV1_D_Count],0)[OPV1_D_Count]        
 ,isnull([HB2_D_Count],0)[HB2_D_Count]        
 ,isnull([DPT2_D_Count],0)[DPT2_D_Count]        
 ,isnull([Penta2_D_Count],0)[Penta2_D_Count]        
 ,isnull([OPV2_D_Count],0)[OPV2_D_Count]        
 ,isnull([HB3_D_Count],0)[HB3_D_Count]        
 ,isnull([DPT3_D_Count],0)[DPT3_D_Count]        
 ,isnull([Penta3_D_Count],0)[Penta3_D_Count]        
 ,isnull([OPV3_D_Count],0)[OPV3_D_Count]        
 ,isnull([HB4_D_Count],0)[HB4_D_Count]        
 ,isnull([Measles_D_Count],0)[Measles_D_Count]        
 ,isnull([Vita_A_1_D_Count],0)[Vita_A_1_D_Count]        
 ,isnull(IPV_1_D_Count,0)[IPV_1_D_Count]        
 ,isnull(IPV_2_D_Count,0)[IPV_2_D_Count]        
 ,isnull(Rota_virus_1_D_Count,0)Rota_virus_1_D_Count        
 ,isnull(Rota_virus_2_D_Count,0)Rota_virus_2_D_Count        
 ,isnull(Rota_virus_3_D_Count,0)Rota_virus_3_D_Count        
 ,ISNULL(MR1_D_Count,0)MR1_D_Count      
 ,ISNULL(MR2_D_Count,0)MR2_D_Count      
 ,ISNULL(PCV1_D_Count,0)PCV1_D_Count      
 ,ISNULL(PCV2_D_Count,0)PCV2_D_Count      
 ,ISNULL(PCVB_D_Count,0)PCVB_D_Count   
  ,ISNULL(JE_Vaccine_D_Count,0)JE_Vaccine_D_Count    --Add on 02-12-19      
 ------------------------------given        
 --,isnull(No_vaccination_2yr)[No_vaccination_2yr]        
 ,isnull([BCG_G_Count],0)[BCG_G_Count]        
 ,isnull([OPV0_G_Count],0)[OPV0_G_Count]        
 ,isnull([HB1_G_Count],0)[HB1_G_Count]        
 ,isnull([DPT1_G_Count],0)[DPT1_G_Count]        
 ,isnull([Penta1_G_Count],0)[Penta1_G_Count]        
 ,isnull([OPV1_G_Count],0)[OPV1_G_Count]        
 ,isnull([HB2_G_Count],0)[HB2_G_Count]        
 ,isnull([DPT2_G_Count],0)[DPT2_G_Count]        
 ,isnull([Penta2_G_Count],0)[Penta2_G_Count]        
 ,isnull([OPV2_G_Count],0)[OPV2_G_Count]        
 ,isnull([HB3_G_Count],0)[HB3_G_Count]        
 ,isnull([DPT3_G_Count],0)[DPT3_G_Count]        
 ,isnull([Penta3_G_Count],0)[Penta3_G_Count]        
 ,isnull([OPV3_G_Count],0)[OPV3_G_Count]        
 ,isnull([HB4_G_Count],0)[HB4_G_Count]        
 ,isnull([Measles_G_Count],0)[Measles_G_Count]        
 ,isnull([Vita_A_1_G_Count],0)[Vita_A_1_G_Count]        
 ,isnull(IPV_1_G_Count,0)[IPV_1_G_Count]        
 ,isnull(IPV_2_G_Count,0)[IPV_2_G_Count]        
 ,isnull(Rota_virus_1_G_Count,0)Rota_virus_1_G_Count        
 ,isnull(Rota_virus_2_G_Count,0)Rota_virus_2_G_Count        
 ,isnull(Rota_virus_3_G_Count,0)Rota_virus_3_G_Count        
 ,ISNULL(MR1_G_Count,0)MR1_G_Count      
 ,ISNULL(MR2_G_Count,0)MR2_G_Count      
 ,ISNULL(PCV1_G_Count,0)PCV1_G_Count      
 ,ISNULL(PCV2_G_Count,0)PCV2_G_Count      
 ,ISNULL(PCVB_G_Count,0)PCVB_G_Count 
  ,ISNULL(JE_Vaccine_G_Count,0)JE_Vaccine_G_Count  --Add on 02-12-19          
 ,dbo.Deactivation_Service(0) as ImmuCode         
FROM         
(        
select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                            
from TBL_HEALTH_BLOCK a WITH (NOLOCK)                             
inner join TBL_DISTRICT b WITH (NOLOCK)  on a.DISTRICT_CD=b.DIST_CD                             
where a.DISTRICT_CD=@District_Code )A          
left outer join         
(        
SELECT         
     w.District_ID,w.HealthBlock_ID        
    ,sum(Due_vaccination_1yr)[Due_vaccination_1yr]        
    ,SUM(Due_vaccination_2yr)[Due_vaccination_2yr]        
 ,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_D_Count])[BCG_D_Count]        
 ,sum([OPV0_D_Count])[OPV0_D_Count]        
 ,sum([HB1_D_Count])[HB1_D_Count]        
 ,sum([DPT1_D_Count])[DPT1_D_Count]        
 ,sum([Penta1_D_Count])[Penta1_D_Count]        
 ,sum([OPV1_D_Count])[OPV1_D_Count]        
 ,sum([HB2_D_Count])[HB2_D_Count]        
 ,sum([DPT2_D_Count])[DPT2_D_Count]        
 ,sum([Penta2_D_Count])[Penta2_D_Count]        
 ,sum([OPV2_D_Count])[OPV2_D_Count]        
 ,sum([HB3_D_Count])[HB3_D_Count]        
 ,sum([DPT3_D_Count])[DPT3_D_Count]        
 ,sum([Penta3_D_Count])[Penta3_D_Count]        
 ,sum([OPV3_D_Count])[OPV3_D_Count]        
 ,sum([HB4_D_Count])[HB4_D_Count]        
 ,sum([Measles_D_Count])[Measles_D_Count]        
 ,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]        
 ,SUM(IPV_1_D_Count)[IPV_1_D_Count]        
 ,SUM(IPV_2_D_Count)[IPV_2_D_Count]        
 ,SUM(Rota_virus_1_D_Count)Rota_virus_1_D_Count        
 ,SUM(Rota_virus_2_D_Count)Rota_virus_2_D_Count        
 ,SUM(Rota_virus_3_D_Count)Rota_virus_3_D_Count       
 ,SUM(MR1_D_Count)MR1_D_Count      
 ,SUM(MR2_D_Count)MR2_D_Count      
 ,SUM(PCV1_D_Count)PCV1_D_Count      
 ,SUM(PCV2_D_Count)PCV2_D_Count      
 ,SUM(PCVB_D_Count)PCVB_D_Count  
  ,SUM(JE_Vaccine_D_Count)JE_Vaccine_D_Count    --Add on 02-12-19        
 ------------------------------given        
 --,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_G_Count])[BCG_G_Count]        
 ,sum([OPV0_G_Count])[OPV0_G_Count]        
 ,sum([HB1_G_Count])[HB1_G_Count]        
 ,sum([DPT1_G_Count])[DPT1_G_Count]        
 ,sum([Penta1_G_Count])[Penta1_G_Count]        
 ,sum([OPV1_G_Count])[OPV1_G_Count]        
 ,sum([HB2_G_Count])[HB2_G_Count]        
 ,sum([DPT2_G_Count])[DPT2_G_Count]        
 ,sum([Penta2_G_Count])[Penta2_G_Count]        
 ,sum([OPV2_G_Count])[OPV2_G_Count]        
 ,sum([HB3_G_Count])[HB3_G_Count]        
 ,sum([DPT3_G_Count])[DPT3_G_Count]        
 ,sum([Penta3_G_Count])[Penta3_G_Count]        
 ,sum([OPV3_G_Count])[OPV3_G_Count]        
 ,sum([HB4_G_Count])[HB4_G_Count]        
 ,sum([Measles_G_Count])[Measles_G_Count]        
 ,sum([Vita_A_1_G_Count])[Vita_A_1_G_Count]        
 ,SUM(IPV_1_G_Count)[IPV_1_G_Count]        
 ,SUM(IPV_2_G_Count)[IPV_2_G_Count]        
 ,SUM(Rota_virus_1_G_Count)Rota_virus_1_G_Count        
 ,SUM(Rota_virus_2_G_Count)Rota_virus_2_G_Count        
 ,SUM(Rota_virus_3_G_Count)Rota_virus_3_G_Count       
 ,SUM(MR1_G_Count)MR1_G_Count       
 ,SUM(MR2_G_Count)MR2_G_Count      
 ,SUM(PCV1_G_Count)PCV1_G_Count      
 ,SUM(PCV2_G_Count)PCV2_G_Count      
 ,SUM(PCVB_G_Count)PCVB_G_Count       
  ,SUM(JE_Vaccine_G_Count)JE_Vaccine_G_Count  --Add on 02-12-19 
 FROM Scheduled_Infant_Workplan_DistBlk_FinYr w WITH (NOLOCK)        
 where Month_ID=@Month_ID and YEar_ID=@Year_ID        
 and w.District_ID=@District_Code        
 group by [District_ID],HealthBlock_ID)B on A.District_Code=B.District_ID AND A.HealthBlock_Code=B.HealthBlock_ID        
         
end        
else if(@Category = 'Block')        
begin        
 -------------------------------due        
SELECT A.HealthBlock_Code as ParentID, A.HealthFacility_Code as ChildID,A.HealthBlock_Name as ParentName,A.HealthFacility_Name as ChildName        
    ,isnull(Due_vaccination_1yr,0)[Due_vaccination_1yr]        
    ,isnull(Due_vaccination_2yr,0)[Due_vaccination_2yr]        
 ,isnull(No_vaccination_2yr,0)[No_vaccination_2yr]        
 ,isnull([BCG_D_Count],0)[BCG_D_Count]        
 ,isnull([OPV0_D_Count],0)[OPV0_D_Count]        
 ,isnull([HB1_D_Count],0)[HB1_D_Count]        
 ,isnull([DPT1_D_Count],0)[DPT1_D_Count]        
 ,isnull([Penta1_D_Count],0)[Penta1_D_Count]        
 ,isnull([OPV1_D_Count],0)[OPV1_D_Count]        
 ,isnull([HB2_D_Count],0)[HB2_D_Count]        
 ,isnull([DPT2_D_Count],0)[DPT2_D_Count]        
 ,isnull([Penta2_D_Count],0)[Penta2_D_Count]        
 ,isnull([OPV2_D_Count],0)[OPV2_D_Count]        
 ,isnull([HB3_D_Count],0)[HB3_D_Count]        
 ,isnull([DPT3_D_Count],0)[DPT3_D_Count]        
 ,isnull([Penta3_D_Count],0)[Penta3_D_Count]        
 ,isnull([OPV3_D_Count],0)[OPV3_D_Count]        
 ,isnull([HB4_D_Count],0)[HB4_D_Count]        
 ,isnull([Measles_D_Count],0)[Measles_D_Count]        
 ,isnull([Vita_A_1_D_Count],0)[Vita_A_1_D_Count]        
 ,isnull(IPV_1_D_Count,0)[IPV_1_D_Count]        
 ,isnull(IPV_2_D_Count,0)[IPV_2_D_Count]        
 ,isnull(Rota_virus_1_D_Count,0)Rota_virus_1_D_Count        
 ,isnull(Rota_virus_2_D_Count,0)Rota_virus_2_D_Count        
 ,isnull(Rota_virus_3_D_Count,0)Rota_virus_3_D_Count       
 ,ISNULL(MR1_D_Count,0)MR1_D_Count      
 ,ISNULL(MR2_D_Count,0)MR2_D_Count      
 ,ISNULL(PCV1_D_Count,0)PCV1_D_Count      
 ,ISNULL(PCV2_D_Count,0)PCV2_D_Count      
 ,ISNULL(PCVB_D_Count,0)PCVB_D_Count   
  ,ISNULL(JE_Vaccine_D_Count,0)JE_Vaccine_D_Count    --Add on 02-12-19      
 ------------------------------given        
 --,isnull(No_vaccination_2yr)[No_vaccination_2yr]        
 ,isnull([BCG_G_Count],0)[BCG_G_Count]        
 ,isnull([OPV0_G_Count],0)[OPV0_G_Count]        
 ,isnull([HB1_G_Count],0)[HB1_G_Count]        
 ,isnull([DPT1_G_Count],0)[DPT1_G_Count]        
 ,isnull([Penta1_G_Count],0)[Penta1_G_Count]        
 ,isnull([OPV1_G_Count],0)[OPV1_G_Count]        
 ,isnull([HB2_G_Count],0)[HB2_G_Count]        
 ,isnull([DPT2_G_Count],0)[DPT2_G_Count]        
 ,isnull([Penta2_G_Count],0)[Penta2_G_Count]        
 ,isnull([OPV2_G_Count],0)[OPV2_G_Count]        
 ,isnull([HB3_G_Count],0)[HB3_G_Count]        
 ,isnull([DPT3_G_Count],0)[DPT3_G_Count]        
 ,isnull([Penta3_G_Count],0)[Penta3_G_Count]        
 ,isnull([OPV3_G_Count],0)[OPV3_G_Count]        
 ,isnull([HB4_G_Count],0)[HB4_G_Count]        
 ,isnull([Measles_G_Count],0)[Measles_G_Count]        
 ,isnull([Vita_A_1_G_Count],0)[Vita_A_1_G_Count]        
 ,isnull(IPV_1_G_Count,0)[IPV_1_G_Count]        
 ,isnull(IPV_2_G_Count,0)[IPV_2_G_Count]        
 ,isnull(Rota_virus_1_G_Count,0)Rota_virus_1_G_Count        
 ,isnull(Rota_virus_2_G_Count,0)Rota_virus_2_G_Count        
 ,isnull(Rota_virus_3_G_Count,0)Rota_virus_3_G_Count      
 ,ISNULL(MR1_G_Count,0)MR1_G_Count      
 ,ISNULL(MR2_G_Count,0)MR2_G_Count      
 ,ISNULL(PCV1_G_Count,0)PCV1_G_Count      
 ,ISNULL(PCV2_G_Count,0)PCV2_G_Count      
 ,ISNULL(PCVB_G_Count,0)PCVB_G_Count
  ,ISNULL(JE_Vaccine_G_Count,0)JE_Vaccine_G_Count  --Add on 02-12-19             
,dbo.Deactivation_Service(0) as ImmuCode         
        
FROM         
(        
select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME         
as HealthFacility_Name        
from TBL_PHC a WITH (NOLOCK)                            
  inner join TBL_HEALTH_BLOCK b WITH (NOLOCK)  on a.BID=b.BLOCK_CD                        
  inner join TBL_DISTRICT C WITH (NOLOCK)  on a.DIST_CD=C.DIST_CD                             
where a.BID=@HealthBlock_Code                        
)A          
left outer join         
(        
SELECT HealthBlock_ID ,PHC_ID        
    ,sum(Due_vaccination_1yr)[Due_vaccination_1yr]        
    ,SUM(Due_vaccination_2yr)[Due_vaccination_2yr]        
 ,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_D_Count])[BCG_D_Count]        
 ,sum([OPV0_D_Count])[OPV0_D_Count]        
 ,sum([HB1_D_Count])[HB1_D_Count]        
 ,sum([DPT1_D_Count])[DPT1_D_Count]        
 ,sum([Penta1_D_Count])[Penta1_D_Count]        
 ,sum([OPV1_D_Count])[OPV1_D_Count]        
 ,sum([HB2_D_Count])[HB2_D_Count]        
 ,sum([DPT2_D_Count])[DPT2_D_Count]        
 ,sum([Penta2_D_Count])[Penta2_D_Count]        
 ,sum([OPV2_D_Count])[OPV2_D_Count]        
 ,sum([HB3_D_Count])[HB3_D_Count]        
 ,sum([DPT3_D_Count])[DPT3_D_Count]        
 ,sum([Penta3_D_Count])[Penta3_D_Count]        
 ,sum([OPV3_D_Count])[OPV3_D_Count]        
 ,sum([HB4_D_Count])[HB4_D_Count]        
 ,sum([Measles_D_Count])[Measles_D_Count]        
 ,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]        
 ,SUM(IPV_1_D_Count)[IPV_1_D_Count]        
 ,SUM(IPV_2_D_Count)[IPV_2_D_Count]        
 ,SUM(Rota_virus_1_D_Count)Rota_virus_1_D_Count        
 ,SUM(Rota_virus_2_D_Count)Rota_virus_2_D_Count        
 ,SUM(Rota_virus_3_D_Count)Rota_virus_3_D_Count        
 ,SUM(MR1_D_Count)MR1_D_Count      
 ,SUM(MR2_D_Count)MR2_D_Count      
 ,SUM(PCV1_D_Count)PCV1_D_Count      
 ,SUM(PCV2_D_Count)PCV2_D_Count      
 ,SUM(PCVB_D_Count)PCVB_D_Count 
  ,SUM(JE_Vaccine_D_Count)JE_Vaccine_D_Count    --Add on 02-12-19        
 ------------------------------given        
 --,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_G_Count])[BCG_G_Count],sum([OPV0_G_Count])[OPV0_G_Count],sum([HB1_G_Count])[HB1_G_Count]        
 ,sum([DPT1_G_Count])[DPT1_G_Count],sum([Penta1_G_Count])[Penta1_G_Count],sum([OPV1_G_Count])[OPV1_G_Count]        
 ,sum([HB2_G_Count])[HB2_G_Count],sum([DPT2_G_Count])[DPT2_G_Count],sum([Penta2_G_Count])[Penta2_G_Count]        
 ,sum([OPV2_G_Count])[OPV2_G_Count],sum([HB3_G_Count])[HB3_G_Count],sum([DPT3_G_Count])[DPT3_G_Count]        
 ,sum([Penta3_G_Count])[Penta3_G_Count],sum([OPV3_G_Count])[OPV3_G_Count],sum([HB4_G_Count])[HB4_G_Count]        
 ,sum([Measles_G_Count])[Measles_G_Count]        
 ,sum([Vita_A_1_G_Count])[Vita_A_1_G_Count]        
 ,SUM(IPV_1_G_Count)[IPV_1_G_Count]        
 ,SUM(IPV_2_G_Count)[IPV_2_G_Count]        
 ,SUM(Rota_virus_1_G_Count)Rota_virus_1_G_Count        
 ,SUM(Rota_virus_2_G_Count)Rota_virus_2_G_Count        
 ,SUM(Rota_virus_3_G_Count)Rota_virus_3_G_Count        
 ,SUM(MR1_G_Count)MR1_G_Count       
 ,SUM(MR2_G_Count)MR2_G_Count      
 ,SUM(PCV1_G_Count)PCV1_G_Count      
 ,SUM(PCV2_G_Count)PCV2_G_Count      
 ,SUM(PCVB_G_Count)PCVB_G_Count        
  ,SUM(JE_Vaccine_G_Count)JE_Vaccine_G_Count  --Add on 02-12-19 
 FROM Scheduled_Infant_Workplan_BlkPHC_FinYr w WITH (NOLOCK)          
 where Month_ID=@Month_ID and YEAR_ID=@Year_ID        
 and w.HealthBlock_ID=@HealthBlock_Code        
 group by HealthBlock_ID,PHC_ID)B on A.HealthBlock_Code=B.HealthBlock_ID AND A.HealthFacility_Code=B.PHC_ID        
end        
else if(@Category = 'PHC')        
begin        
 -------------------------------due        
SELECT A.HealthFacility_Code as ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName        
    ,isnull(Due_vaccination_1yr,0)[Due_vaccination_1yr]        
    ,isnull(Due_vaccination_2yr,0)[Due_vaccination_2yr]        
 ,isnull(No_vaccination_2yr,0)[No_vaccination_2yr]        
 ,isnull([BCG_D_Count],0)[BCG_D_Count]        
 ,isnull([OPV0_D_Count],0)[OPV0_D_Count]        
 ,isnull([HB1_D_Count],0)[HB1_D_Count]        
 ,isnull([DPT1_D_Count],0)[DPT1_D_Count]        
 ,isnull([Penta1_D_Count],0)[Penta1_D_Count]        
 ,isnull([OPV1_D_Count],0)[OPV1_D_Count]        
 ,isnull([HB2_D_Count],0)[HB2_D_Count]        
 ,isnull([DPT2_D_Count],0)[DPT2_D_Count]        
 ,isnull([Penta2_D_Count],0)[Penta2_D_Count]        
 ,isnull([OPV2_D_Count],0)[OPV2_D_Count]        
 ,isnull([HB3_D_Count],0)[HB3_D_Count]        
 ,isnull([DPT3_D_Count],0)[DPT3_D_Count]        
 ,isnull([Penta3_D_Count],0)[Penta3_D_Count]        
 ,isnull([OPV3_D_Count],0)[OPV3_D_Count]        
 ,isnull([HB4_D_Count],0)[HB4_D_Count]        
 ,isnull([Measles_D_Count],0)[Measles_D_Count]        
 ,isnull([Vita_A_1_D_Count],0)[Vita_A_1_D_Count]        
 ,isnull(IPV_1_D_Count,0)[IPV_1_D_Count]        
 ,isnull(IPV_2_D_Count,0)[IPV_2_D_Count]        
 ,isnull(Rota_virus_1_D_Count,0)Rota_virus_1_D_Count        
 ,isnull(Rota_virus_2_D_Count,0)Rota_virus_2_D_Count        
 ,isnull(Rota_virus_3_D_Count,0)Rota_virus_3_D_Count       
 ,ISNULL(MR1_D_Count,0)MR1_D_Count      
 ,ISNULL(MR2_D_Count,0)MR2_D_Count      
 ,ISNULL(PCV1_D_Count,0)PCV1_D_Count      
 ,ISNULL(PCV2_D_Count,0)PCV2_D_Count      
 ,ISNULL(PCVB_D_Count,0)PCVB_D_Count   
  ,ISNULL(JE_Vaccine_D_Count,0)JE_Vaccine_D_Count    --Add on 02-12-19       
 ------------------------------given        
 --,isnull(No_vaccination_2yr)[No_vaccination_2yr]        
 ,isnull([BCG_G_Count],0)[BCG_G_Count]        
 ,isnull([OPV0_G_Count],0)[OPV0_G_Count]        
 ,isnull([HB1_G_Count],0)[HB1_G_Count]        
 ,isnull([DPT1_G_Count],0)[DPT1_G_Count]        
 ,isnull([Penta1_G_Count],0)[Penta1_G_Count]        
 ,isnull([OPV1_G_Count],0)[OPV1_G_Count]        
 ,isnull([HB2_G_Count],0)[HB2_G_Count]        
 ,isnull([DPT2_G_Count],0)[DPT2_G_Count]        
 ,isnull([Penta2_G_Count],0)[Penta2_G_Count]        
 ,isnull([OPV2_G_Count],0)[OPV2_G_Count]        
 ,isnull([HB3_G_Count],0)[HB3_G_Count]        
 ,isnull([DPT3_G_Count],0)[DPT3_G_Count]        
 ,isnull([Penta3_G_Count],0)[Penta3_G_Count]        
 ,isnull([OPV3_G_Count],0)[OPV3_G_Count]        
 ,isnull([HB4_G_Count],0)[HB4_G_Count]        
 ,isnull([Measles_G_Count],0)[Measles_G_Count]        
 ,isnull([Vita_A_1_G_Count],0)[Vita_A_1_G_Count]        
 ,isnull(IPV_1_G_Count,0)[IPV_1_G_Count]        
 ,isnull(IPV_2_G_Count,0)[IPV_2_G_Count]        
 ,isnull(Rota_virus_1_G_Count,0)Rota_virus_1_G_Count        
 ,isnull(Rota_virus_2_G_Count,0)Rota_virus_2_G_Count        
 ,isnull(Rota_virus_3_G_Count,0)Rota_virus_3_G_Count        
 ,ISNULL(MR1_G_Count,0)MR1_G_Count      
 ,ISNULL(MR2_G_Count,0)MR2_G_Count      
 ,ISNULL(PCV1_G_Count,0)PCV1_G_Count      
 ,ISNULL(PCV2_G_Count,0)PCV2_G_Count      
 ,ISNULL(PCVB_G_Count,0)PCVB_G_Count  
  ,ISNULL(JE_Vaccine_G_Count,0)JE_Vaccine_G_Count  --Add on 02-12-19         
,dbo.Deactivation_Service(0) as ImmuCode         
FROM         
(        
select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name           
from Estimated_Data_SubCenter_Wise a WITH (NOLOCK)         
left outer join TBL_SUBPHC c WITH (NOLOCK)  on a.HealthSubFacility_Code=c.SUBPHC_CD        
left outer join TBL_PHC b WITH (NOLOCK)  on c.PHC_CD=b.PHC_CD        
where a.Financial_Year=(case when @Month_ID<=3 then @Year_ID-1 else @Year_ID end)        
and  isnull(c.PHC_CD, a.HealthFacility_Code)= @HealthFacility_Code        
)A          
left outer join         
(        
        
SELECT isnull(c.PHC_CD,PHC_ID)PHC_ID,SubCentre_ID        
    ,sum(Due_vaccination_1yr)[Due_vaccination_1yr],SUM(Due_vaccination_2yr)[Due_vaccination_2yr]        
 ,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_D_Count])[BCG_D_Count],sum([OPV0_D_Count])[OPV0_D_Count],sum([HB1_D_Count])[HB1_D_Count]        
 ,sum([DPT1_D_Count])[DPT1_D_Count],sum([Penta1_D_Count])[Penta1_D_Count],sum([OPV1_D_Count])[OPV1_D_Count]        
 ,sum([HB2_D_Count])[HB2_D_Count],sum([DPT2_D_Count])[DPT2_D_Count],sum([Penta2_D_Count])[Penta2_D_Count]        
 ,sum([OPV2_D_Count])[OPV2_D_Count],sum([HB3_D_Count])[HB3_D_Count],sum([DPT3_D_Count])[DPT3_D_Count]        
 ,sum([Penta3_D_Count])[Penta3_D_Count],sum([OPV3_D_Count])[OPV3_D_Count],sum([HB4_D_Count])[HB4_D_Count]        
 ,sum([Measles_D_Count])[Measles_D_Count]        
 ,sum([Vita_A_1_D_Count])[Vita_A_1_D_Count]        
 ,SUM(IPV_1_D_Count)[IPV_1_D_Count]        
 ,SUM(IPV_2_D_Count)[IPV_2_D_Count]        
 ,SUM(Rota_virus_1_D_Count)Rota_virus_1_D_Count        
 ,SUM(Rota_virus_2_D_Count)Rota_virus_2_D_Count        
 ,SUM(Rota_virus_3_D_Count)Rota_virus_3_D_Count       
  
 ,SUM(MR1_D_Count)MR1_D_Count      
 ,SUM(MR2_D_Count)MR2_D_Count      
 ,SUM(PCV1_D_Count)PCV1_D_Count      
 ,SUM(PCV2_D_Count)PCV2_D_Count      
 ,SUM(PCVB_D_Count)PCVB_D_Count 
  ,SUM(JE_Vaccine_D_Count)JE_Vaccine_D_Count    --Add on 02-12-19         
 ------------------------------given        
 --,SUM(No_vaccination_2yr)[No_vaccination_2yr]        
 ,sum([BCG_G_Count])[BCG_G_Count],sum([OPV0_G_Count])[OPV0_G_Count],sum([HB1_G_Count])[HB1_G_Count]        
 ,sum([DPT1_G_Count])[DPT1_G_Count],sum([Penta1_G_Count])[Penta1_G_Count],sum([OPV1_G_Count])[OPV1_G_Count]        
 ,sum([HB2_G_Count])[HB2_G_Count],sum([DPT2_G_Count])[DPT2_G_Count],sum([Penta2_G_Count])[Penta2_G_Count]        
 ,sum([OPV2_G_Count])[OPV2_G_Count],sum([HB3_G_Count])[HB3_G_Count],sum([DPT3_G_Count])[DPT3_G_Count]        
 ,sum([Penta3_G_Count])[Penta3_G_Count],sum([OPV3_G_Count])[OPV3_G_Count],sum([HB4_G_Count])[HB4_G_Count]        
 ,sum([Measles_G_Count])[Measles_G_Count]        
 ,sum([Vita_A_1_G_Count])[Vita_A_1_G_Count]        
 ,SUM(IPV_1_G_Count)[IPV_1_G_Count]        
 ,SUM(IPV_2_G_Count)[IPV_2_G_Count]        
 ,SUM(Rota_virus_1_G_Count)Rota_virus_1_G_Count        
 ,SUM(Rota_virus_2_G_Count)Rota_virus_2_G_Count        
 ,SUM(Rota_virus_3_G_Count)Rota_virus_3_G_Count        
 ,SUM(MR1_G_Count)MR1_G_Count       
 ,SUM(MR2_G_Count)MR2_G_Count      
 ,SUM(PCV1_G_Count)PCV1_G_Count      
 ,SUM(PCV2_G_Count)PCV2_G_Count      
 ,SUM(PCVB_G_Count)PCVB_G_Count  
 ,SUM(JE_Vaccine_G_Count)JE_Vaccine_G_Count  --Add on 02-12-19     
 FROM Scheduled_Infant_Workplan_PHCSubCen_FinYr w WITH (NOLOCK)         
 left outer join TBL_SUBPHC c WITH (NOLOCK) on w.SubCentre_ID=c.SUBPHC_CD         
where Month_ID=@Month_ID and YEAR_ID=@Year_ID        
 and isnull(c.PHC_CD,PHC_ID)=@HealthFacility_Code        
 group by isnull(c.PHC_CD,PHC_ID),SubCentre_ID)B on A.HealthFacility_Code=B.PHC_ID AND A.HealthSubFacility_Code=B.SubCentre_ID        
         
        
end        
         
 end        
  
