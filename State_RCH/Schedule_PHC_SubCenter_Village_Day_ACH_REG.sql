USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_ACH_REG]    Script Date: 09/26/2024 14:44:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[Schedule_PHC_SubCenter_Village_Day_ACH_REG]
(@State_Code as int=0)
as
begin

truncate table Scheduled_PHC_SubCenter_Village_Day_ACH_REG

insert into Scheduled_PHC_SubCenter_Village_Day_ACH_REG([State_Code],[HealthFacility_Code],[HealthSubFacility_Code],[Village_Code]
,[Child_Total],[Infant_Registered],[Infant_With_PhoneNo],[Infant_With_SelfPhoneNo],[Infant_With_Address],[Infant_With_Aadhaar_No]
,[Infant_With_EID],[Infant_Reg_Within_30days],[Infant_Low_birth_Weight],[Child_0_1],[Child_1_5],[Child_1_2],[Child_2_3]
,[Child_3_4],[Child_4_5],[Child_With_BCG],[Child_With_OPV0],[Child_With_OPV1],[Child_With_OPV2],[Child_With_OPV3],[Child_With_OPVB]
,[Child_With_DPT1],[Child_With_DPT2],[Child_With_DPT3],[Child_With_DPTB1],[Child_With_DPTB2],[Child_With_HEP0],[Child_With_HEP1]
,[Child_With_HEP2],[Child_With_HEP3],[Child_With_PENTA1],[Child_With_PENTA2],[Child_With_PENTA3],[Child_With_MEASLES1]
,[Child_With_MEASLES2],[Child_With_JE1],[Child_With_JE2],[Child_With_VITAMIN1],[Child_With_VITAMIN2],[Child_With_VITAMIN3]
,[Child_With_VITAMIN4],[Child_With_VITAMIN5],[Child_With_VITAMIN6],[Child_With_VITAMIN7],[Child_With_VITAMIN8],[Child_With_VITAMIN9]
,[Child_With_VITAMINK],[Child_With_FULLIMMU],[Child_With_RECEIVEDALL],[Child_With_LOWWEIGHT],[Child_With_PNEUMONIA],[Child_With_BREASTFEED6MONTH]
,[Child_With_FULL_HEP],[Child_With_FULL_DPT],[Child_With_FULL_OPV],[Child_With_FULL_PENTA]
,[Child_P],[Child_T],[BCG_P],[BCG_T],[BCG_U],[OPV0_P],[OPV0_T],[OPV0_U],[OPV1_P],[OPV1_T],[OPV1_U],[OPV2_P],[OPV2_T],[OPV2_U],[OPV3_P]
,[OPV3_T],[OPV3_U],[OPVB_P],[OPVB_T],[OPVB_U],[DPT1_P],[DPT1_T],[DPT1_U],[DPT2_P],[DPT2_T],[DPT2_U],[DPT3_P],[DPT3_T],[DPT3_U],[DPTB1_P]
,[DPTB1_T],[DPTB1_U],[DPTB2_P],[DPTB2_T],[DPTB2_U],[HEP0_P],[HEP0_T],[HEP0_U],[HEP1_P],[HEP1_T],[HEP1_U],[HEP2_P],[HEP2_T],[HEP2_U]
,[HEP3_P],[HEP3_T],[HEP3_U],[PENTA1_P],[PENTA1_T],[PENTA1_U],[PENTA2_P],[PENTA2_T],[PENTA2_U],[PENTA3_P],[PENTA3_T],[PENTA3_U]
,[Measles1_P],[Measles1_T],[Measles1_U],[Measles2_P],[Measles2_T],[Measles2_U],[JE1_P],[JE1_T],[JE1_U],[JE2_P],[JE2_T],[JE2_U]
,[VITA1_P],[VITA1_T],[VITA1_U],[VITA2_P],[VITA2_T],[VITA2_U],[VITA3_P],[VITA3_T],[VITA3_U],[VITA4_P],[VITA4_T],[VITA4_U]
,[VITA5_P],[VITA5_T],[VITA5_U],[VITA6_P],[VITA6_T],[VITA6_U],[VITA7_P],[VITA7_T],[VITA7_U],[VITA8_P],[VITA8_T],[VITA8_U]
,[VITA9_P],[VITA9_T],[VITA9_U],[MMR_P],[MMR_T],[MMR_U],[MR_P],[MR_T],[MR_U],[Typhoid_P],[Typhoid_T],[Typhoid_U]
,[RotaVirus_P],[RotaVirus_T],[RotaVirus_U],[VitaK_P],[VitaK_T],[VitaK_U],[Year_ID],[Month_ID],[Day_ID],[AsOnDate],[Fin_Yr]
,[Child_Death],Infant_Death,[Infant_LBW_11_FullyImmunized],[Infant_11_FullyImmunized],[Infant_LBW_11],[Infant_11])

select StateID as State_Code
      ,PHC_ID as Healthfacility_Code
      ,SubCentre_ID as HealthSubfacility_Code
      ,Village_ID
      ,count(Registration_no)[Child_Total]
      ,Sum(Case when [Child_0_1]=1 then 1 else 0 end )[Infant_Registered]
      ,SUM(Case when [Child_0_1]=1 and Mobile_no_Present=1 then 1 else 0 end)[Infant_With_PhoneNo]
      ,SUM((case when (Whose_mobile_Father=1 or Whose_mobile_Mother=1) and [Child_0_1]=1 then 1 else 0 end))[Infant_With_SelfPhoneNo]
      ,SUM(Case when [Child_0_1]=1 and Address_Present=1 then 1 else 0 end)[Infant_With_Address]
      ,SUM(Case when [Child_0_1]=1 and Child_Aadhar_No_Present=1 then 1 else 0 end)[Infant_With_Aadhaar_No]
      ,SUM(Case when [Child_0_1]=1 and Child_EID_Present=1 then 1 else 0 end)[Infant_With_EID]
       ,SUM(Case when DATEDIFF(day,Child_Birthdate_Date,Child_Registration_Date)<=30 then 1 else 0 end) Infant_Reg_Within_30days
	  ,SUM(Case when [Child_0_1]=1 and Child_With_LOWWEIGHT=1 then 1 else 0 end) Infant_Low_birth_Weight
      ,SUM(Convert(int,[Child_0_1])) [Child_0_1]
      ,SUM((case when Child_Age<=1 then 0 else 1 end))[Child_1_5]
      ,SUM(Convert(int,[Child_1_2])) [Child_1_2]
	  ,SUM(Convert(int,[Child_2_3])) [Child_2_3]
	  ,SUM(Convert(int,[Child_3_4])) [Child_3_4]
	  ,SUM(Convert(int,[Child_4_5])) [Child_4_5]
      ,SUM(Convert(int,BCG_Dt_Present))[Child_With_BCG]
      ,SUM(Convert(int,OPV0_Dt_Present))[Child_With_OPV0]
      ,SUM(Convert(int,OPV1_Dt_Present))[Child_With_OPV1]
      ,SUM(Convert(int,OPV2_Dt_Present))[Child_With_OPV2]
      ,SUM(Convert(int,OPV3_Dt_Present))[Child_With_OPV3]
      ,SUM(Convert(int,OPVBooster_Dt_Present))[Child_With_OPVB]
      ,SUM(Convert(int,DPT1_Dt_Present))[Child_With_DPT1]
      ,SUM(Convert(int,DPT2_Dt_Present))[Child_With_DPT2]
      ,SUM(Convert(int,DPT3_Dt_Present))[Child_With_DPT3]
      ,SUM(Convert(int,DPTBooster1_Dt_Present)) [Child_With_DPTB1]
      ,SUM(Convert(int,DPTBooster2_Dt_Present))[Child_With_DPTB2]
      ,SUM(Convert(int,HepatitisB0_Dt_Present))[Child_With_HEP0]
      ,SUM(Convert(int,HepatitisB1_Dt_Present))[Child_With_HEP1]
      ,SUM(Convert(int,HepatitisB2_Dt_Present))[Child_With_HEP2]
      ,SUM(Convert(int,HepatitisB3_Dt_Present))[Child_With_HEP3]
      ,SUM(Convert(int,Penta1_Dt_Present))[Child_With_PENTA1]
      ,SUM(Convert(int,Penta2_Dt_Present))[Child_With_PENTA2]
      ,SUM(Convert(int,Penta3_Dt_Present))[Child_With_PENTA3]
      ,SUM(Convert(int,Measles1_Present))[Child_With_MEASLES1]
      ,SUM(Convert(int,Measles2_Present))[Child_With_MEASLES1]
      
      ,SUM(Convert(int,JE1_Dt_Present))[Child_With_JE1]
      ,SUM(Convert(int,JE2_Dt_Present))[Child_With_JE2]
      ,SUM(Convert(int,VitA_Dose1_Dt_Present))[Child_With_VITAMIN1]
      ,SUM(Convert(int,VitA_Dose2_Dt_Present))[Child_With_VITAMIN2]
      ,SUM(Convert(int,VitA_Dose3_Dt_Present))[Child_With_VITAMIN3]
      ,SUM(Convert(int,VitA_Dose4_Dt_Present))[Child_With_VITAMIN4]
      ,SUM(Convert(int,VitA_Dose5_Dt_Present))[Child_With_VITAMIN5]
      ,SUM(Convert(int,VitA_Dose6_Dt_Present))[Child_With_VITAMIN6]
      ,SUM(Convert(int,VitA_Dose7_Dt_Present))[Child_With_VITAMIN7]
      ,SUM(Convert(int,VitA_Dose8_Dt_Present))[Child_With_VITAMIN8]
      ,SUM(Convert(int,VitA_Dose9_Dt_Present))[Child_With_VITAMIN9]
      ,SUM(Convert(int,VitA_K_Dt_Present))[Child_With_VITAMINK]
      ,SUM(Convert(int,Child_FullyImmunised_Y))[Child_With_FULLIMMU]
      ,SUM(Convert(int,Child_Received_Y))[Child_With_RECEIVEDALL]
      ,SUM(Convert(int,Child_With_LOWWEIGHT))[Child_With_LOWWEIGHT]
      ,SUM((case when (Child_Pneumonia_19_Y=1 or Child_Pneumonia_10_Y=1) then 1 else 0 end))[Child_With_PNEUMONIA]
      ,SUM((case when (Child_BreastFeed_19_Y=1 or Child_BreastFeed_10_Y=1) then 1 else 0 end))[Child_With_BREASTFEED6MONTH]
      ,SUM(case when HepatitisB1_Dt_Present=1 and HepatitisB2_Dt_Present=1 and HepatitisB3_Dt_Present=1 then 1 else 0 end)[Child_With_FULL_HEP]
      ,SUM(case when DPT1_Dt_Present=1 and DPT2_Dt_Present=1 and DPT3_Dt_Present=1 then 1 else 0 end)[Child_With_FULL_DPT]
      ,SUM(case when OPV1_Dt_Present=1 and OPV2_Dt_Present=1 and OPV3_Dt_Present=1 then 1 else 0 end)[Child_With_FULL_OPV]
      ,SUM(case when Penta1_Dt_Present=1 and Penta2_Dt_Present=1 and Penta3_Dt_Present=1 then 1 else 0 end)[Child_With_FULL_PENTA]
      ,Sum(Convert(int,[Child_P_Source_ID]))Child_P
	  ,Sum(Convert(int,[Child_T_Source_ID]))Child_T
	  ,Sum(Convert(int,[BCG_P_Source_ID]))BCG_P
	  ,Sum(Convert(int,[BCG_T_Source_ID]))BCG_T
	  ,Sum(Convert(int,[BCG_U_Source_ID]))BCG_U
	  ,Sum(Convert(int,[OPV0_P_Source_ID]))OPV0_P
	  ,Sum(Convert(int,[OPV0_T_Source_ID]))OPV0_T
	  ,Sum(Convert(int,[OPV0_U_Source_ID]))OPV0_U
	  ,Sum(Convert(int,[OPV1_P_Source_ID]))OPV1_P
	  ,Sum(Convert(int,[OPV1_T_Source_ID]))OPV1_T
	  ,Sum(Convert(int,[OPV1_U_Source_ID]))OPV1_U
	  ,Sum(Convert(int,[OPV2_P_Source_ID]))OPV2_P
	  ,Sum(Convert(int,[OPV2_T_Source_ID]))OPV2_T
	  ,Sum(Convert(int,[OPV2_U_Source_ID]))OPV2_U
	  ,Sum(Convert(int,[OPV3_P_Source_ID]))OPV3_P
	  ,Sum(Convert(int,[OPV3_T_Source_ID]))OPV3_T
	  ,Sum(Convert(int,[OPV3_U_Source_ID]))OPV3_U
	  ,Sum(Convert(int,[OPVB_P_Source_ID]))OPVB_P
	  ,Sum(Convert(int,[OPVB_T_Source_ID]))OPVB_T
	  ,Sum(Convert(int,[OPVB_U_Source_ID]))OPVB_U
	  ,Sum(Convert(int,[DPT1_P_Source_ID]))DPT1_P
	  ,Sum(Convert(int,[DPT1_T_Source_ID]))DPT1_T
	  ,Sum(Convert(int,[DPT1_U_Source_ID]))DPT1_U
	  ,Sum(Convert(int,[DPT2_P_Source_ID]))DPT2_P
	  ,Sum(Convert(int,[DPT2_T_Source_ID]))DPT2_T
	  ,Sum(Convert(int,[DPT2_U_Source_ID]))DPT2_U
	  ,Sum(Convert(int,[DPT3_P_Source_ID]))DPT3_P
	  ,Sum(Convert(int,[DPT3_T_Source_ID]))DPT3_T
	  ,Sum(Convert(int,[DPT3_U_Source_ID]))DPT3_U
	  ,Sum(Convert(int,[DPTB1_P_Source_ID]))DPTB1_P
	  ,Sum(Convert(int,[DPTB1_T_Source_ID]))DPTB1_T
	  ,Sum(Convert(int,[DPTB1_U_Source_ID]))DPTB1_U
	  ,Sum(Convert(int,[DPTB2_P_Source_ID]))DPTB2_P
	  ,Sum(Convert(int,[DPTB2_T_Source_ID]))DPTB2_T
	  ,Sum(Convert(int,[DPTB2_U_Source_ID]))DPTB2_U
	  ,Sum(Convert(int,[HEP0_P_Source_ID]))HEP0_P
	  ,Sum(Convert(int,[HEP0_T_Source_ID]))HEP0_T
	  ,Sum(Convert(int,[HEP0_U_Source_ID]))HEP0_U
	  ,Sum(Convert(int,[HEP1_P_Source_ID]))HEP1_P
	  ,Sum(Convert(int,[HEP1_T_Source_ID]))HEP1_T
	  ,Sum(Convert(int,[HEP1_U_Source_ID]))HEP1_U
	  ,Sum(Convert(int,[HEP2_P_Source_ID]))HEP2_P
	  ,Sum(Convert(int,[HEP2_T_Source_ID]))HEP2_T
	  ,Sum(Convert(int,[HEP2_U_Source_ID]))HEP2_U
	  ,Sum(Convert(int,[HEP3_P_Source_ID]))HEP3_P
	  ,Sum(Convert(int,[HEP3_T_Source_ID]))HEP3_T
	  ,Sum(Convert(int,[HEP3_U_Source_ID]))HEP3_U
	  ,Sum(Convert(int,[PENTA1_P_Source_ID]))PENTA1_P
	  ,Sum(Convert(int,[PENTA1_T_Source_ID]))PENTA1_T
	  ,Sum(Convert(int,[PENTA1_U_Source_ID]))PENTA1_U
	  ,Sum(Convert(int,[PENTA2_P_Source_ID]))PENTA2_P
	  ,Sum(Convert(int,[PENTA2_T_Source_ID]))PENTA2_T
	  ,Sum(Convert(int,[PENTA2_U_Source_ID]))PENTA2_U
	  ,Sum(Convert(int,[PENTA3_P_Source_ID]))PENTA3_P
	  ,Sum(Convert(int,[PENTA3_T_Source_ID]))PENTA3_T
	  ,Sum(Convert(int,[PENTA3_U_Source_ID]))PENTA3_U
	  ,Sum(Convert(int,[Measles1_P_Source_ID]))Measles1_P
	  ,Sum(Convert(int,[Measles1_T_Source_ID]))Measles1_T
	  ,Sum(Convert(int,[Measles1_U_Source_ID]))Measles1_U
	  ,Sum(Convert(int,[Measles2_P_Source_ID]))Measles2_P
	  ,Sum(Convert(int,[Measles2_T_Source_ID]))Measles2_T
	  ,Sum(Convert(int,[Measles2_U_Source_ID]))Measles2_U
	  ,Sum(Convert(int,[JE1_P_Source_ID]))JE1_P
	  ,Sum(Convert(int,[JE1_T_Source_ID]))JE1_T
	  ,Sum(Convert(int,[JE1_U_Source_ID]))JE1_U
	  ,Sum(Convert(int,[JE2_P_Source_ID]))JE2_P
	  ,Sum(Convert(int,[JE2_T_Source_ID]))JE2_T
	  ,Sum(Convert(int,[JE2_U_Source_ID]))JE2_U
	  ,Sum(Convert(int,[VITA1_P_Source_ID]))VITA1_P
	  ,Sum(Convert(int,[VITA1_T_Source_ID]))VITA1_T
	  ,Sum(Convert(int,[VITA1_U_Source_ID]))VITA1_U
	  ,Sum(Convert(int,[VITA2_P_Source_ID]))VITA2_P
	  ,Sum(Convert(int,[VITA2_T_Source_ID]))VITA2_T
	  ,Sum(Convert(int,[VITA2_U_Source_ID]))VITA2_U
	  ,Sum(Convert(int,[VITA3_P_Source_ID]))VITA3_P
	  ,Sum(Convert(int,[VITA3_T_Source_ID]))VITA3_T
	  ,Sum(Convert(int,[VITA3_U_Source_ID]))VITA3_U
	  ,Sum(Convert(int,[VITA4_P_Source_ID]))VITA4_P
	  ,Sum(Convert(int,[VITA4_T_Source_ID]))VITA4_T
	  ,Sum(Convert(int,[VITA4_U_Source_ID]))VITA4_U
	  ,Sum(Convert(int,[VITA5_P_Source_ID]))VITA5_P
	  ,Sum(Convert(int,[VITA5_T_Source_ID]))VITA5_T
	  ,Sum(Convert(int,[VITA5_U_Source_ID]))VITA5_U
	  ,Sum(Convert(int,[VITA6_P_Source_ID]))VITA6_P
	  ,Sum(Convert(int,[VITA6_T_Source_ID]))VITA6_T
	  ,Sum(Convert(int,[VITA6_U_Source_ID]))VITA6_U
	  ,Sum(Convert(int,[VITA7_P_Source_ID]))VITA7_P
	  ,Sum(Convert(int,[VITA7_T_Source_ID]))VITA7_T
	  ,Sum(Convert(int,[VITA7_U_Source_ID]))VITA7_U
	  ,Sum(Convert(int,[VITA8_P_Source_ID]))VITA8_P
	  ,Sum(Convert(int,[VITA8_T_Source_ID]))VITA8_T
	  ,Sum(Convert(int,[VITA8_U_Source_ID]))VITA8_U
	  ,Sum(Convert(int,[VITA9_P_Source_ID]))VITA9_P
	  ,Sum(Convert(int,[VITA9_T_Source_ID]))VITA9_T
	  ,Sum(Convert(int,[VITA9_U_Source_ID]))VITA9_U
	  ,Sum(Convert(int,[MMR_P_Source_ID]))MMR_P
	  ,Sum(Convert(int,[MMR_T_Source_ID]))MMR_T
	  ,Sum(Convert(int,[MMR_U_Source_ID]))MMR_U
	  ,Sum(Convert(int,[MR_P_Source_ID]))MR_P
	  ,Sum(Convert(int,[MR_T_Source_ID]))MR_T
	  ,Sum(Convert(int,[MR_U_Source_ID]))MR_U
	  ,Sum(Convert(int,[Typhoid_P_Source_ID]))Typhoid_P
	  ,Sum(Convert(int,[Typhoid_T_Source_ID]))Typhoid_T
	  ,Sum(Convert(int,[Typhoid_U_Source_ID]))Typhoid_U
	  ,Sum(Convert(int,[Rota_P_Source_ID]))Rota_P
	  ,Sum(Convert(int,[Rota_T_Source_ID]))Rota_T
	  ,Sum(Convert(int,[Rota_U_Source_ID]))Rota_U
	  ,Sum(Convert(int,[VITAK_P_Source_ID]))VITAK_P
	  ,Sum(Convert(int,[VITAK_T_Source_ID]))VITAK_T
	  ,Sum(Convert(int,[VITAK_U_Source_ID]))VITAK_U
      ,YEAR(Child_Registration_Date)[Year_ID]
      ,Month(Child_Registration_Date)[Month_ID]
      ,Day(Child_Registration_Date)[Day_ID]
      ,Child_Registration_Date as [AsOnDate]
      ,ChildReg_Fin_Yr as FinYr
      ,SUM(Convert(int,Entry_Type_Death))
      ,SUM((case when  [Child_0_1]=1 and Entry_Type_Death=1 then 1 else 0 end)) Infant_Death
      ,SUM(Case when [Child_0_1]=1 and Child_With_LOWWEIGHT=1 and Child_FullyImmunised_Y=1 then 1 else 0 end) as Infant_LBW_11_FullyImmunized
      ,SUM(Case when [Child_0_1]=1  and Child_FullyImmunised_Y=1 then 1 else 0 end) as Infant_LBW_11_FullyImmunized
      ,SUM(Case when [Child_0_1]=1  and Child_With_LOWWEIGHT=1 and Convert(date,Birthdate_plus11mon)<=Convert(date,GETDATE()) then 1 else 0 end) as Infant_LBW_11
      ,SUM(Case when [Child_0_1]=1  and Convert(date,Birthdate_plus11mon)<=Convert(date,GETDATE()) then 1 else 0 end) as Infant_11
  FROM t_child_flat_Count 
  where YEAR(Child_Registration_Date)>2000 
  and Entry_Type_Death<>1 
  and DATEDIFF(YEAR,Child_Birthdate_Date,GETDATE()-1)<=5
  group by ChildReg_Fin_Yr,YEAR(Child_Registration_Date),Month(Child_Registration_Date),Day(Child_Registration_Date),Child_Registration_Date
  ,StateID,PHC_ID,SubCentre_ID,Village_ID


end
