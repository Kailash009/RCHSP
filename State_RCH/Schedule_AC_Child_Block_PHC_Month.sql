USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_AC_Child_Block_PHC_Month]    Script Date: 09/26/2024 14:43:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



    
ALTER procedure [dbo].[Schedule_AC_Child_Block_PHC_Month]  
as  
begin  
  
truncate table Scheduled_AC_Child_Block_PHC_Month  
  
  
insert into Scheduled_AC_Child_Block_PHC_Month([State_Code],[HealthBlock_Code],[HealthFacility_Code]  
,[Infant_Registered],[Infant_With_PhoneNo],[Infant_With_SelfPhoneNo],[Infant_With_Address],[Infant_With_Aadhaar_No],[Infant_With_EID]  
,[Child_0_1],[Child_1_2],[Child_2_3],[Child_3_4],[Child_4_5]  
,Child_P,Child_T,BCG_P,BCG_T,OPV0_P,OPV0_T,OPV1_P,OPV1_T,OPV2_P,OPV2_T  
,OPV3_P,OPV3_T,OPVB_P,OPVB_T,DPT1_P,DPT1_T,DPT2_P,DPT2_T,DPT3_P,DPT3_T  
,DPTB1_P,DPTB1_T,DPTB2_P,DPTB2_T,HEP0_P,HEP0_T,HEP1_P,HEP1_T,HEP2_P,HEP2_T  
,HEP3_P,HEP3_T,PENTA1_P,PENTA1_T,PENTA2_P,PENTA2_T,PENTA3_P,PENTA3_T,Measles1_P,Measles1_T,Measles2_P,Measles2_T  
,JE1_P,JE1_T,JE2_P,JE2_T,VITA1_P,VITA1_T,VITA2_P,VITA2_T,VITA3_P,VITA3_T,VITA4_P,VITA4_T,VITA5_P,VITA5_T,VITA6_P,VITA6_T  
,VITA7_P,VITA7_T,VITA8_P,VITA8_T,VITA9_P,VITA9_T,MMR_P,MMR_T,MR_P,MR_T,Typhoid_P,Typhoid_T,RotaVirus_P,RotaVirus_T,VitaK_P,VitaK_T  
,Infant_Reg_Within_30days,Infant_Low_birth_Weight  
,[Infant_LBW_11_Not_FullImmu],[Infant_11_Not_FullImmu],[Infant_LBW_11_FullImmu],[Infant_11_FullImmu],Child_Death_Total,Infant_Death_Total  
,CH_With_Brestfed_6_month,CH_with_UID_Mob,Total_Birthdose_Given,Birthdose_Exp_VitK,Started_Vaccination,Rota2_P,Rota2_T,Rota2_U  
,Rota3_P,Rota3_T,Rota3_U,IPV1_P,IPV1_T,IPV1_U,IPV2_P,IPV2_T,IPV2_U,Total_Service_P,Total_Service_T,Total_Service_U  
,Started_Vaccination_0_1,Started_Vaccination_1_2,Started_Vaccination_2_3,Started_Vaccination_3_4,Started_Vaccination_4_5  
,[Year_ID],[Month_ID],[Fin_Yr],[Filter_Type],Infant_11,Child_With_FULLIMMU,Child_With_RECEIVEDALL,BreastFed_on_Hour  
,[Total_Male],[Total_Female]  
-----------------------------covid  
,reg_Is_ILI_Symptom_done ,reg_Is_contact_Covid_done ,reg_Covid_test_done ,reg_Covid_test_result_done   
,Immu_Is_ILI_Symptom_done ,Immu_Is_contact_Covid_done ,Immu_Covid_test_done ,Immu_Covid_test_result_done  
,reg_Is_ILI_Symptom_notdone ,reg_Is_contact_Covid_notdone ,reg_Covid_test_notdone ,reg_Covid_test_result_notdone   
,Immu_Is_ILI_Symptom_notdone ,Immu_Is_contact_Covid_notdone ,Immu_Covid_test_notdone ,Immu_Covid_test_result_notdone,Mother_RegistrationNo_Absent
,is_verified ,CH_HEB_PW,CH_HBIG_LINKED_PW,TOTAL_HBIG  
--------------------------------  
)  
select State_Code,BID ,Healthfacility_Code   
,Sum([Infant_Registered])[Infant_Registered],Sum([Infant_With_PhoneNo])[Infant_With_PhoneNo],Sum([Infant_With_SelfPhoneNo])[Infant_With_SelfPhoneNo]  
,Sum([Infant_With_Address])[Infant_With_Address],Sum([Infant_With_Aadhaar_No])[Infant_With_Aadhaar_No],Sum([Infant_With_EID])[Infant_With_EID]  
,Sum([Child_0_1])[Child_0_1],Sum([Child_1_2])[Child_1_2],Sum([Child_2_3])[Child_2_3],Sum([Child_3_4])[Child_3_4],Sum([Child_4_5])[Child_4_5]  
,Sum(Child_P),Sum(Child_T),Sum(BCG_P),Sum(BCG_T),Sum(OPV0_P),Sum(OPV0_T),Sum(OPV1_P),Sum(OPV1_T),Sum(OPV2_P),Sum(OPV2_T)  
,Sum(OPV3_P),Sum(OPV3_T),Sum(OPVB_P),Sum(OPVB_T),Sum(DPT1_P),Sum(DPT1_T),Sum(DPT2_P),Sum(DPT2_T),Sum(DPT3_P),Sum(DPT3_T)  
,Sum(DPTB1_P),Sum(DPTB1_T),Sum(DPTB2_P),Sum(DPTB2_T),Sum(HEP0_P),Sum(HEP0_T),Sum(HEP1_P),Sum(HEP1_T),Sum(HEP2_P),Sum(HEP2_T)  
,Sum(HEP3_P),Sum(HEP3_T),Sum(PENTA1_P),Sum(PENTA1_T),Sum(PENTA2_P),Sum(PENTA2_T),Sum(PENTA3_P),Sum(PENTA3_T),Sum(Measles1_P)  
,Sum(Measles1_T),Sum(Measles2_P),Sum(Measles2_T),Sum(JE1_P),Sum(JE1_T),Sum(JE2_P),Sum(JE2_T),Sum(VITA1_P),Sum(VITA1_T),Sum(VITA2_P)  
,Sum(VITA2_T),Sum(VITA3_P),Sum(VITA3_T),Sum(VITA4_P),Sum(VITA4_T),Sum(VITA5_P),Sum(VITA5_T),Sum(VITA6_P),Sum(VITA6_T),Sum(VITA7_P)  
,Sum(VITA7_T),Sum(VITA8_P),Sum(VITA8_T),Sum(VITA9_P),Sum(VITA9_T),Sum(MMR_P),Sum(MMR_T),Sum(MR_P),Sum(MR_T),Sum(Typhoid_P)  
,Sum(Typhoid_T),Sum(RotaVirus_P),Sum(RotaVirus_T),Sum(VitaK_P),Sum(VitaK_T),SUM(Infant_Reg_Within_30days),Sum(Infant_Low_birth_Weight)  
,Sum([Infant_LBW_11_Not_FullImmu]),Sum([Infant_11_Not_FullImmu]),Sum([Infant_LBW_11_FullImmu]),Sum([Infant_11_FullImmu]),SUM(Child_Death_Total),sum(Infant_Death_Total)  
,SUM(CH_With_Brestfed_6_month),sum(CH_with_UID_Mob),SUM(Total_Birthdose_Given),SUM(Birthdose_Exp_VitK),SUM(Started_Vaccination),SUM(Rota2_P),SUM(Rota2_T),SUM(Rota2_U)  
,SUM(Rota3_P),SUM(Rota3_T),SUM(Rota3_U),SUM(IPV1_P),SUM(IPV1_T),SUM(IPV1_U),SUM(IPV2_P),SUM(IPV2_T),SUM(IPV2_U),SUM(Total_Service_P),SUM(Total_Service_T),SUM(Total_Service_U)  
,SUM(Started_Vaccination_0_1),SUM(Started_Vaccination_1_2),SUM(Started_Vaccination_2_3),SUM(Started_Vaccination_3_4),SUM(Started_Vaccination_4_5)  
,[Year_ID],[Month_ID],[Fin_Yr] ,[Filter_Type],SUM(Infant_11),SUM(Child_With_FULLIMMU),SUM(Child_With_RECEIVEDALL),SUM(BreastFed_on_Hour)  
,SUM(Total_Male),SUM(Total_Female)  
-----------------------------covid  
,sum(isnull(reg_Is_ILI_Symptom_done,0)) reg_Is_ILI_Symptom_done,sum(isnull(reg_Is_contact_Covid_done,0)) reg_Is_contact_Covid_done,sum(isnull(reg_Covid_test_done,0)) reg_Covid_test_done,sum(isnull(reg_Covid_test_result_done,0)) reg_Covid_test_result_done 
   
,sum(isnull(Immu_Is_ILI_Symptom_done,0)) Immu_Is_ILI_Symptom_done,sum(isnull(Immu_Is_contact_Covid_done,0)) Immu_Is_contact_Covid_done,sum(isnull(Immu_Covid_test_done,0)) Immu_Covid_test_done,sum(isnull(Immu_Covid_test_result_done,0)) Immu_Covid_test_result_done  
,sum(isnull(reg_Is_ILI_Symptom_notdone,0)) reg_Is_ILI_Symptom_notdone,sum(isnull(reg_Is_contact_Covid_notdone,0)) reg_Is_contact_Covid_notdone,sum(isnull(reg_Covid_test_notdone,0)) reg_Covid_test_notdone,sum(isnull(reg_Covid_test_result_notdone,0)) reg_Covid_test_result_notdone  
,sum(isnull(Immu_Is_ILI_Symptom_notdone,0)) Immu_Is_ILI_Symptom_notdone,sum(isnull(Immu_Is_contact_Covid_notdone,0)) Immu_Is_contact_Covid_notdone,sum(isnull(Immu_Covid_test_notdone,0)) Immu_Covid_test_notdone,sum(isnull(Immu_Covid_test_result_notdone,0))
 Immu_Covid_test_result_notdone,SUM(ISNULL(Mother_RegistrationNo_Absent,0)) Mother_RegistrationNo_Absent,SUM(ISNULL(is_verified,0)) is_verified
--------------------------------------------------------  
 ,sum(isnull(CH_HEB_PW,0))CH_HEB_PW,sum(isnull(CH_HBIG_LINKED_PW,0))CH_HBIG_LINKED_PW,sum(isnull(TOTAL_HBIG,0))TOTAL_HBIG  
  
from  Scheduled_AC_Child_PHC_SubCenter_Month a   
inner join Health_PHC b on a.Healthfacility_Code =b.PID  
group by  State_Code,BID ,Healthfacility_Code   
,[Year_ID],[Month_ID],[Fin_Yr] ,[Filter_Type]  
end  

