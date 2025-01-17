USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_AC_GF_District_Block]    Script Date: 09/26/2024 12:18:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Schedule_AC_GF_District_Block]  
as  
begin  
truncate table Scheduled_AC_GF_District_Block  
insert into Scheduled_AC_GF_District_Block(District_ID,HealthBlock_ID,[Total_GF],[Total_ANM],[Total_ANM2],[Total_LinkWorker],[Total_MPW],[Total_GNM],[Total_CHV]  
,[Total_AWW],[Total_ASHA],[Total_GF_With_UID],[Total_GF_With_Mob],[Total_GF_With_Bank],[Total_GF_IsValidated],[Total_GF_With_UID_Mob],[Total_ANM_With_UID_Mob]  
,[Total_ANM2_With_UID_Mob],[Total_LinkWorker_With_UID_Mob],[Total_MPW_With_UID_Mob],[Total_GNM_With_UID_Mob],[Total_CHV_With_UID_Mob],[Total_AWW_With_UID_Mob]  
,[Total_ASHA_With_UID_Mob],[Total_ANM_with_ValidatedPhone],[Total_ANM2_with_ValidatedPhone],[Total_LinkWorker_with_ValidatedPhone],[Total_MPW_with_ValidatedPhone]  
,[Total_GNM_with_ValidatedPhone],[Total_CHV_with_ValidatedPhone],[Total_AWW_with_ValidatedPhone],[Total_ASHA_with_ValidatedPhone],[Total_ANM_with_UID]  
,[Total_ANM2_with_UID],[Total_LinkWorker_with_UID],[Total_MPW_with_UID],[Total_GNM_with_UID],[Total_CHV_with_UID],[Total_AWW_with_UID],[Total_ASHA_with_UID]  
,[Total_ANM_with_ACC],[Total_ANM2_with_ACC],[Total_LinkWorker_with_ACC],[Total_MPW_with_ACC],[Total_GNM_with_ACC],[Total_CHV_with_ACC],[Total_AWW_with_ACC]  
,[Total_ASHA_with_ACC],[Total_ANM_with_UID_Linked],[Total_ANM2_with_UID_Linked],[Total_LinkWorker_with_UID_Linked],[Total_MPW_with_UID_Linked],[Total_GNM_with_UID_Linked]  
,[Total_CHV_with_UID_Linked],[Total_AWW_with_UID_Linked],[Total_ASHA_with_UID_Linked],[GF_Added_LW],[GF_Transfered_LW],[GF_Deactivated_LW]  
,[Total_Deactive],[Total_Deactive_WithUID],[Total_Deactive_WithBank],[Total_Deactive_WithUIDLink]  
,[DeactiveANM],[DeactiveANM_WithUID],[DeactiveANM_WithBank],[DeactiveANM_WithUIDLink],[DeactiveANM_WithValPhone]  
,[DeactiveANM2],[DeactiveANM2_WithUID],[DeactiveANM2_WithBank],[DeactiveANM2_WithUIDLink],[DeactiveANM2_WithValPhone]  
,[DeactiveLW],[DeactiveLW_WithUID],[DeactiveLW_WithBank],[DeactiveLW_WithUIDLink],[DeactiveLW_WithValPhone]  
,[DeactiveMPW],[DeactiveMPW_WithUID],[DeactiveMPW_WithBank],[DeactiveMPW_WithUIDLink],[DeactiveMPW_WithValPhone]  
,[DeactiveGNM],[DeactiveGNM_WithUID],[DeactiveGNM_WithBank],[DeactiveGNM_WithUIDLink],[DeactiveGNM_WithValPhone]  
,[DeactiveCHV],[DeactiveCHV_WithUID],[DeactiveCHV_WithBank],[DeactiveCHV_WithUIDLink],[DeactiveCHV_WithValPhone]  
,[DeactiveAWW],[DeactiveAWW_WithUID],[DeactiveAWW_WithBank],[DeactiveAWW_WithUIDLink],[DeactiveAWW_WithValPhone]  
,[DeactiveASHA],[DeactiveASHA_WithUID],[DeactiveASHA_WithBank],[DeactiveASHA_WithUIDLink],[DeactiveASHA_WithValPhone]  
,[Total_ANM_With_Mob],[Total_ANM2_With_Mob],[Total_LinkWorker_With_Mob],[Total_MPW_With_Mob],[Total_GNM_With_Mob],[Total_CHV_With_Mob]  
,[Total_AWW_WithD_Mob],[Total_ASHA_WithD_Mob]  
,[Total_ANM_GMWA_1],[Total_ANM2_GMWA_1],[Total_LinkWorker_GMWA_1],[Total_MPW_GMWA_1]  
,[Total_GNM_GMWA_1],[Total_CHV_GMWA_1],[Total_ASHA_GMWA_1],[Total_AWW_GMWA_1],[Total_ANM_GMWA_2],[Total_ANM2_GMWA_2],[Total_LinkWorker_GMWA_2]  
,[Total_MPW_GMWA_2],[Total_GNM_GMWA_2],[Total_CHV_GMWA_2],[Total_ASHA_GMWA_2],[Total_AWW_GMWA_2],[Total_ANM_GMWA_MT_2]  
,[Total_ANM2_GMWA_MT_2],[Total_LinkWorker_GMWA_MT_2],[Total_MPW_GMWA_MT_2],[Total_GNM_GMWA_MT_2],[Total_CHV_GMWA_MT_2]  
,[Total_ASHA_GMWA_MT_2],[Total_AWW_GMWA_MT_2]  
,[Total_ANM_PEWA_1] ,[Total_ANM2_PEWA_1],[Total_LinkWorker_PEWA_1],[Total_MPW_PEWA_1]  
,[Total_GNM_PEWA_1],[Total_CHV_PEWA_1],[Total_ASHA_PEWA_1],[Total_AWW_PEWA_1],[Total_ANM_PEWA_2],[Total_ANM2_PEWA_2],[Total_LinkWorker_PEWA_2]  
,[Total_MPW_PEWA_2],[Total_GNM_PEWA_2],[Total_CHV_PEWA_2],[Total_ASHA_PEWA_2],[Total_AWW_PEWA_2],[Total_ANM_PEWA_MT_2]  
,[Total_ANM2_PEWA_MT_2],[Total_LinkWorker_PEWA_MT_2],[Total_MPW_PEWA_MT_2],[Total_GNM_PEWA_MT_2],[Total_CHV_PEWA_MT_2]  
,[Total_ASHA_PEWA_PEMT_2],[Total_AWW_PEWA_MT_2],[Total_ANM_With_Unique_Mob],[Total_ANM2_With_Unique_Mob],[Total_LinkWorker_With_Unique_Mob],[Total_MPW_With_Unique_Mob],[Total_GNM_With_Unique_Mob],[Total_CHV_Unique_With_Mob]  
,[Total_AWW_With_Unique_Mob],[Total_ASHA_With_Unique_Mob]  
,[Total_ANM_With_Wrong_Mob],[Total_ANM2_With_Wrong_Mob],[Total_LinkWorker_With_Wrong_Mob],[Total_MPW_With_Wrong_Mob],[Total_GNM_With_Wrong_Mob],[Total_CHV_With_Wrong_Mob]  
,[Total_AWW_With_Wrong_Mob],[Total_ASHA_With_Wrong_Mob]
,[Total_ANM_with_VerifiedPhone],[Total_ANM2_with_VerifiedPhone],[Total_LinkWorker_with_VerifiedPhone] 
,[Total_MPW_with_VerifiedPhone],[Total_GNM_with_VerifiedPhone],[Total_CHV_with_VerifiedPhone],[Total_AWW_with_VerifiedPhone],[Total_ASHA_with_VerifiedPhone]) 
  
SELECT b.dcode,a.HealthBlock_ID,SUM([Total_GF]),SUM([Total_ANM]),SUM([Total_ANM2]),SUM([Total_LinkWorker]),SUM([Total_MPW]),SUM([Total_GNM]),SUM([Total_CHV])  
,SUM([Total_AWW]),SUM([Total_ASHA]),SUM([Total_GF_With_UID]),SUM([Total_GF_With_Mob]),SUM([Total_GF_With_Bank]),SUM([Total_GF_IsValidated])  
,SUM([Total_GF_With_UID_Mob]),SUM([Total_ANM_With_UID_Mob]),SUM([Total_ANM2_With_UID_Mob]),SUM([Total_LinkWorker_With_UID_Mob]),SUM([Total_MPW_With_UID_Mob])  
,SUM([Total_GNM_With_UID_Mob]),SUM([Total_CHV_With_UID_Mob]),SUM([Total_AWW_With_UID_Mob]),SUM([Total_ASHA_With_UID_Mob]),SUM([Total_ANM_with_ValidatedPhone])  
,SUM([Total_ANM2_with_ValidatedPhone]),SUM([Total_LinkWorker_with_ValidatedPhone]),SUM([Total_MPW_with_ValidatedPhone]),SUM([Total_GNM_with_ValidatedPhone])  
,SUM([Total_CHV_with_ValidatedPhone]),SUM([Total_AWW_with_ValidatedPhone]),SUM([Total_ASHA_with_ValidatedPhone]),SUM([Total_ANM_with_UID])  
,SUM([Total_ANM2_with_UID]),SUM([Total_LinkWorker_with_UID]),SUM([Total_MPW_with_UID]),SUM([Total_GNM_with_UID]),SUM([Total_CHV_with_UID])  
,SUM([Total_AWW_with_UID]),SUM([Total_ASHA_with_UID]),SUM([Total_ANM_with_ACC]),SUM([Total_ANM2_with_ACC]),SUM([Total_LinkWorker_with_ACC])  
,SUM([Total_MPW_with_ACC]),SUM([Total_GNM_with_ACC]),SUM([Total_CHV_with_ACC]),SUM([Total_AWW_with_ACC]),SUM([Total_ASHA_with_ACC])  
,SUM([Total_ANM_with_UID_Linked]),SUM([Total_ANM2_with_UID_Linked]),SUM([Total_LinkWorker_with_UID_Linked]),SUM([Total_MPW_with_UID_Linked])  
,SUM([Total_GNM_with_UID_Linked]),SUM([Total_CHV_with_UID_Linked]),SUM([Total_AWW_with_UID_Linked]),SUM([Total_ASHA_with_UID_Linked])  
,SUM(GF_Added_LW),SUM(GF_Transfered_LW),SUM(GF_Deactivated_LW),SUM(Total_Deactive),SUM(Total_Deactive_WithUID),SUM(Total_Deactive_WithBank)  
,SUM(Total_Deactive_WithUIDLink)  
,SUM([DeactiveANM]),SUM([DeactiveANM_WithUID]),SUM([DeactiveANM_WithBank]),SUM([DeactiveANM_WithUIDLink]),SUM([DeactiveANM_WithValPhone])  
,SUM([DeactiveANM2]),SUM([DeactiveANM2_WithUID]),SUM([DeactiveANM2_WithBank]),SUM([DeactiveANM2_WithUIDLink]),SUM([DeactiveANM2_WithValPhone])  
,SUM([DeactiveLW]),SUM([DeactiveLW_WithUID]),SUM([DeactiveLW_WithBank]),SUM([DeactiveLW_WithUIDLink]),SUM([DeactiveLW_WithValPhone])  
,SUM([DeactiveMPW]),SUM([DeactiveMPW_WithUID]),SUM([DeactiveMPW_WithBank]),SUM([DeactiveMPW_WithUIDLink]),SUM([DeactiveMPW_WithValPhone])  
,SUM([DeactiveGNM]),SUM([DeactiveGNM_WithUID]),SUM([DeactiveGNM_WithBank]),SUM([DeactiveGNM_WithUIDLink]),SUM([DeactiveGNM_WithValPhone])  
,SUM([DeactiveCHV]),SUM([DeactiveCHV_WithUID]),SUM([DeactiveCHV_WithBank]),SUM([DeactiveCHV_WithUIDLink]),SUM([DeactiveCHV_WithValPhone])  
,SUM([DeactiveAWW]),SUM([DeactiveAWW_WithUID]),SUM([DeactiveAWW_WithBank]),SUM([DeactiveAWW_WithUIDLink]),SUM([DeactiveAWW_WithValPhone])  
,SUM([DeactiveASHA]),SUM([DeactiveASHA_WithUID]),SUM([DeactiveASHA_WithBank]),SUM([DeactiveASHA_WithUIDLink]),SUM([DeactiveASHA_WithValPhone])  
,SUM([Total_ANM_With_Mob]),SUM([Total_ANM2_With_Mob]),SUM([Total_LinkWorker_With_Mob]),SUM([Total_MPW_With_Mob]),SUM([Total_GNM_With_Mob]),SUM([Total_CHV_With_Mob])  
,SUM([Total_AWW_WithD_Mob]),SUM([Total_ASHA_WithD_Mob])  
,SUM([Total_ANM_GMWA_1]),SUM([Total_ANM2_GMWA_1]),SUM([Total_LinkWorker_GMWA_1]),SUM([Total_MPW_GMWA_1])  
,SUM([Total_GNM_GMWA_1]),SUM([Total_CHV_GMWA_1]),SUM([Total_ASHA_GMWA_1]),SUM([Total_AWW_GMWA_1]),SUM([Total_ANM_GMWA_2]),SUM([Total_ANM2_GMWA_2])  
,SUM([Total_LinkWorker_GMWA_2])  
,SUM([Total_MPW_GMWA_2]),SUM([Total_GNM_GMWA_2]),SUM([Total_CHV_GMWA_2]),SUM([Total_ASHA_GMWA_2]),SUM([Total_AWW_GMWA_2]),SUM([Total_ANM_GMWA_MT_2])  
,SUM([Total_ANM2_GMWA_MT_2]),SUM([Total_LinkWorker_GMWA_MT_2]),SUM([Total_MPW_GMWA_MT_2]),SUM([Total_GNM_GMWA_MT_2]),SUM([Total_CHV_GMWA_MT_2])  
,SUM([Total_ASHA_GMWA_MT_2]),SUM([Total_AWW_GMWA_MT_2])  
,SUM([Total_ANM_PEWA_1]) ,SUM([Total_ANM2_PEWA_1]),SUM([Total_LinkWorker_PEWA_1]),SUM([Total_MPW_PEWA_1])  
,SUM([Total_GNM_PEWA_1]),SUM([Total_CHV_PEWA_1]),SUM([Total_ASHA_PEWA_1]),SUM([Total_AWW_PEWA_1]),SUM([Total_ANM_PEWA_2]),SUM([Total_ANM2_PEWA_2])  
,SUM([Total_LinkWorker_PEWA_2])  
,SUM([Total_MPW_PEWA_2]),SUM([Total_GNM_PEWA_2]),SUM([Total_CHV_PEWA_2]),SUM([Total_ASHA_PEWA_2]),SUM([Total_AWW_PEWA_2]),SUM([Total_ANM_PEWA_MT_2])  
,SUM([Total_ANM2_PEWA_MT_2]),SUM([Total_LinkWorker_PEWA_MT_2]),SUM([Total_MPW_PEWA_MT_2]),SUM([Total_GNM_PEWA_MT_2]),SUM([Total_CHV_PEWA_MT_2])  
,SUM([Total_ASHA_PEWA_PEMT_2]),SUM([Total_AWW_PEWA_MT_2]),SUM([Total_ANM_With_Unique_Mob]),SUM([Total_ANM2_With_Unique_Mob]),SUM([Total_LinkWorker_With_Unique_Mob])  
,SUM([Total_MPW_With_Unique_Mob]),SUM([Total_GNM_With_Unique_Mob]),SUM([Total_CHV_Unique_With_Mob])  
,SUM([Total_AWW_With_Unique_Mob]),SUM([Total_ASHA_With_Unique_Mob]),SUM([Total_ANM_With_Wrong_Mob]),SUM([Total_ANM2_With_Wrong_Mob])  
,SUM([Total_LinkWorker_With_Wrong_Mob]),SUM([Total_MPW_With_Wrong_Mob]),SUM([Total_GNM_With_Wrong_Mob]),SUM([Total_CHV_With_Wrong_Mob])  
,SUM([Total_AWW_With_Wrong_Mob]),SUM([Total_ASHA_With_Wrong_Mob])  
,SUM([Total_ANM_with_VerifiedPhone]),SUM([Total_ANM2_with_VerifiedPhone]),SUM([Total_LinkWorker_with_VerifiedPhone]),SUM([Total_MPW_with_VerifiedPhone])  
,SUM([Total_GNM_with_VerifiedPhone]),SUM([Total_CHV_with_VerifiedPhone]),SUM([Total_AWW_with_VerifiedPhone]),SUM([Total_ASHA_with_VerifiedPhone]) 
FROM Scheduled_AC_GF_Block_PHC a  
inner join HEALTH_BLOCK b on a.HealthBlock_ID =b.bid  
group by b.dcode,a.HealthBlock_ID  
end  
  
