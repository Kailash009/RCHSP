USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_PW_CH_Tab_Portal]    Script Date: 09/26/2024 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*      
[AC_EC_PW_CH_Tab_Portal] 9,0,0,0,0,0,2022,0,0,'','','State'           
[AC_EC_PW_CH_Tab_Portal] 9,1,0,0,0,0,2022,0,0,'','','District'    
[AC_EC_PW_CH_Tab_Portal] 9,1,11,0,0,0,2022,0,0,'','','Block'     
[AC_EC_PW_CH_Tab_Portal] 9,1,11,48,0,0,2022,0,0,'','','PHC'            
[AC_EC_PW_CH_Tab_Portal] 9,1,11,48,86,0,2022,0,0,'','','SubCentre'         
*/      
ALTER procedure [dbo].[AC_EC_PW_CH_Tab_Portal]      
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
 @Category varchar(20)='PHC'           
)      
as       
begin        
if exists(select 1 from TBL_DISTRICT a where a.StateID=@State_Code and a.Dist_ANMOL_Live=1)    
begin          
if(@Category ='State')      
 begin      
 select A.Parent_ID,A.Parent_Name,A.Child_ID,A.Child_Name,     
  ISNULL(B.Total_PW_OnPortal,0) as Total_PW_OnPortal,
  ISNULL(B.Total_PW_OnTab,0) as Total_PW_OnTab,
  ISNULL(B.Total_PW_Service_OnPortal,0) as Total_PW_Service_OnPortal,
  ISNULL(B.Total_PW_Service_OnTab,0) as Total_PW_Service_OnTab,
  ISNULL(C.Total_Child_OnPortal,0) as Total_Child_OnPortal, 
  ISNULL(C.Total_Child_OnTab,0) as Total_Child_OnTab, 
  ISNULL(C.Total_Child_Service_OnPortal,0) as Total_Child_Service_OnPortal, 
  ISNULL(C.Total_Child_Service_OnTab,0) as Total_Child_Service_OnTab, 
  ISNULL(D.Total_EC_Registred_OnPortal,0) as Total_EC_Registred_OnPortal, 
  ISNULL(D.Total_EC_Registred_OnTab,0) as Total_EC_Registred_OnTab,
  ISNULL(D.Total_EC_Services_OnPortal,0) as Total_EC_Services_OnPortal, 
  ISNULL(D.Total_EC_Services_OnTab,0) as Total_EC_Services_OnTab
from       
  (select b.StateID [Parent_ID],b.StateName [Parent_Name],a.DIST_CD [Child_ID],a.DIST_NAME_ENG [Child_Name],Dist_ANMOL_Live    
  from TBL_DISTRICT a with(nolock)     
  inner join TBL_STATE b with(nolock) on a.StateID=b.StateID      
  where a.StateID=@State_Code       
) A      
left outer join      
(      
  Select a.State_Code as [Parent_ID] ,a.District_Code as [Child_ID]      
  ,sum(MOther_P) as Total_PW_OnPortal      
  ,sum(MOther_T) as Total_PW_OnTab          
  ,(SUM(ANC1_P)+SUM(ANC2_P)+SUM(ANC3_P)+SUM(ANC4_P)+SUM([Delivery_P]) +SUM([PNC1_P])+SUM([PNC2_P])+SUM([PNC3_P])+SUM([PNC4_P])      
  +SUM([PNC5_P])+SUM([PNC6_P])+SUM([PNC7_P]))as Total_PW_Service_OnPortal      
  ,(SUM(ANC1_T)+SUM(ANC2_T)+SUM(ANC3_T)+SUM(ANC4_T)+SUM([Delivery_T]) +SUM([PNC1_T])+SUM([PNC2_T])+SUM([PNC3_T])+SUM([PNC4_T])      
  +SUM([PNC5_T])+SUM([PNC6_T])+SUM([PNC7_T]))as Total_PW_Service_OnTab      
  from Scheduled_AC_PW_State_District_Month a with(nolock)       
  where a.State_Code=@State_Code      
  and (a.District_Code=@District_Code or @District_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
group by a.State_Code,a.District_Code) B on A.Parent_ID=B.Parent_ID and A.Child_ID=B.Child_ID 
left outer join      
(      
  Select a.State_Code as [Parent_ID] ,a.District_Code as [Child_ID]      
  ,sum(Child_P) as Total_Child_OnPortal      
  ,sum(Child_T) as Total_Child_OnTab      
  -----------------------------      
  ,(SUM(BCG_P)+SUM(OPV0_P)+SUM(OPV1_P)+SUM(OPV2_P)+SUM(OPV3_P)+SUM(OPVB_P)+SUM(DPT1_P)+SUM(DPT2_P)+SUM(DPT3_P)+SUM(DPTB1_P)      
  +SUM(DPTB2_P)+SUM(HEP0_P)+SUM(HEP1_P)+SUM(HEP2_P)+SUM(HEP3_P)+SUM(PENTA1_P)+SUM(PENTA2_P)+SUM(PENTA3_P)+SUM(Measles1_P)      
  +SUM(Measles2_P)+SUM(JE1_P)+SUM(JE2_P)+SUM(VITA1_P)+SUM(VITA2_P)+SUM(VITA3_P)+SUM(VITA4_P)+SUM(VITA5_P)+SUM(VITA6_P)      
  +SUM(VITA7_P)+SUM(VITA8_P)+SUM(VITA9_P)+SUM(MMR_P)+SUM(MR_P)+SUM(Typhoid_P)+SUM(RotaVirus_P)+SUM(VitaK_P)) as Total_Child_Service_OnPortal      
  -----------------------------      
  ,(SUM(BCG_T)+SUM(OPV0_T)+SUM(OPV1_T)+SUM(OPV2_T)+SUM(OPV3_T)+SUM(OPVB_T)+SUM(DPT1_T)+SUM(DPT2_T)+SUM(DPT3_T)+SUM(DPTB1_T)      
  +SUM(DPTB2_T)+SUM(HEP0_T)+SUM(HEP1_T)+SUM(HEP2_T)+SUM(HEP3_T)+SUM(PENTA1_T)+SUM(PENTA2_T)+SUM(PENTA3_T)+SUM(Measles1_T)      
  +SUM(Measles2_T)+SUM(JE1_T)+SUM(JE2_T)+SUM(VITA1_T)+SUM(VITA2_T)+SUM(VITA3_T)+SUM(VITA4_T)+SUM(VITA5_T)+SUM(VITA6_T)      
  +SUM(VITA7_T)+SUM(VITA8_T)+SUM(VITA9_T)+SUM(MMR_T)+SUM(MR_T)+SUM(Typhoid_T)+SUM(RotaVirus_T)+SUM(VitaK_T))as Total_Child_Service_OnTab      
  from Scheduled_AC_Child_State_District_Month a with(nolock)     
  where a.State_Code=@State_Code      
  and (a.District_Code=@District_Code or @District_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.State_Code,a.District_Code) C on A.Parent_ID=C.Parent_ID and A.Child_ID=C.Child_ID 
  left outer join      
  (      
  Select a.State_Code as [Parent_ID] ,a.District_Code as [Child_ID]      
  ,Sum(EC_Registered_P) as Total_EC_Registred_OnPortal      
  ,Sum(EC_Registered_T) as Total_EC_Registred_OnTab
  ,(SUM(ECT_With_Condom_P)+SUM(ECT_With_MaleStr_P)+SUM(ECT_With_FeMaleStr_P)+SUM(ECT_With_IUCD_5yr_P)+SUM(ECT_With_IUCD_10yr_P)+SUM(ECT_With_OCP_P)+SUM(ECT_With_ECP_P)) as Total_EC_Services_OnPortal,
  (SUM(ECT_With_Condom_T)+SUM(ECT_With_MaleStr_T)+SUM(ECT_With_FeMaleStr_T)+SUM(ECT_With_IUCD_5yr_T)+SUM(ECT_With_IUCD_10yr_T)+SUM(ECT_With_OCP_T)+SUM(ECT_With_ECP_T)) as Total_EC_Services_OnTab     
  from Scheduled_AC_EC_State_District_Month a with(nolock)       
  where a.State_Code=@State_Code      
  and (a.District_Code=@District_Code or @District_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.State_Code,a.District_Code) D on A.Parent_ID=D.Parent_ID and A.Child_ID=D.Child_ID      
       
 end      
 else if(@Category ='District')      
 begin      
 select A.Parent_ID,A.Parent_Name,A.Child_ID,A.Child_Name,     
  ISNULL(B.Total_PW_OnPortal,0) as Total_PW_OnPortal,
  ISNULL(B.Total_PW_OnTab,0) as Total_PW_OnTab,
  ISNULL(B.Total_PW_Service_OnPortal,0) as Total_PW_Service_OnPortal,
  ISNULL(B.Total_PW_Service_OnTab,0) as Total_PW_Service_OnTab,
  ISNULL(C.Total_Child_OnPortal,0) as Total_Child_OnPortal, 
  ISNULL(C.Total_Child_OnTab,0) as Total_Child_OnTab, 
  ISNULL(C.Total_Child_Service_OnPortal,0) as Total_Child_Service_OnPortal, 
  ISNULL(C.Total_Child_Service_OnTab,0) as Total_Child_Service_OnTab, 
  ISNULL(D.Total_EC_Registred_OnPortal,0) as Total_EC_Registred_OnPortal, 
  ISNULL(D.Total_EC_Registred_OnTab,0) as Total_EC_Registred_OnTab,
  ISNULL(D.Total_EC_Services_OnPortal,0) as Total_EC_Services_OnPortal, 
  ISNULL(D.Total_EC_Services_OnTab,0) as Total_EC_Services_OnTab  
   from       
  (select a.BLOCK_CD [Child_ID],a.Block_Name_E [Child_Name],b.DIST_NAME_ENG [Parent_Name],b.DIST_CD [Parent_ID],Dist_ANMOL_Live from TBL_HEALTH_BLOCK a with(nolock)      
  inner join TBL_DISTRICT b with(nolock) on a.DISTRICT_CD=b.DIST_CD      
  where A.DISTRICT_CD=@District_Code      
      
  ) A      
  left outer join      
  (      
  Select a.District_Code as [Parent_ID] ,a.HealthBlock_Code as [Child_ID]      
  ,sum(MOther_P) as Total_PW_OnPortal      
  ,sum(MOther_T) as Total_PW_OnTab          
  ,(SUM(ANC1_P)+SUM(ANC2_P)+SUM(ANC3_P)+SUM(ANC4_P)+SUM([Delivery_P]) +SUM([PNC1_P])+SUM([PNC2_P])+SUM([PNC3_P])+SUM([PNC4_P])      
  +SUM([PNC5_P])+SUM([PNC6_P])+SUM([PNC7_P]))as Total_PW_Service_OnPortal      
  ,(SUM(ANC1_T)+SUM(ANC2_T)+SUM(ANC3_T)+SUM(ANC4_T)+SUM([Delivery_T]) +SUM([PNC1_T])+SUM([PNC2_T])+SUM([PNC3_T])+SUM([PNC4_T])      
  +SUM([PNC5_T])+SUM([PNC6_T])+SUM([PNC7_T]))as Total_PW_Service_OnTab       
  from Scheduled_AC_PW_District_Block_Month a with(nolock)      
  where (a.District_Code=@District_Code or @District_Code=0)      
  and (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)       
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.District_Code ,a.HealthBlock_Code) B on A.Parent_ID=B.Parent_ID and A.Child_ID=B.Child_ID 
  left outer join      
  (      
  Select a.District_Code as [Parent_ID] ,a.HealthBlock_Code as [Child_ID]      
  ,sum(Child_P) as Total_Child_OnPortal      
  ,sum(Child_T) as Total_Child_OnTab      
  ,(SUM(BCG_P)+SUM(OPV0_P)+SUM(OPV1_P)+SUM(OPV2_P)+SUM(OPV3_P)+SUM(OPVB_P)+SUM(DPT1_P)+SUM(DPT2_P)+SUM(DPT3_P)+SUM(DPTB1_P)      
  +SUM(DPTB2_P)+SUM(HEP0_P)+SUM(HEP1_P)+SUM(HEP2_P)+SUM(HEP3_P)+SUM(PENTA1_P)+SUM(PENTA2_P)+SUM(PENTA3_P)+SUM(Measles1_P)      
  +SUM(Measles2_P)+SUM(JE1_P)+SUM(JE2_P)+SUM(VITA1_P)+SUM(VITA2_P)+SUM(VITA3_P)+SUM(VITA4_P)+SUM(VITA5_P)+SUM(VITA6_P)      
  +SUM(VITA7_P)+SUM(VITA8_P)+SUM(VITA9_P)+SUM(MMR_P)+SUM(MR_P)+SUM(Typhoid_P)+SUM(RotaVirus_P)+SUM(VitaK_P)) as Total_Child_Service_OnPortal,      
  (SUM(BCG_T)+SUM(OPV0_T)+SUM(OPV1_T)+SUM(OPV2_T)+SUM(OPV3_T)+SUM(OPVB_T)+SUM(DPT1_T)+SUM(DPT2_T)+SUM(DPT3_T)+SUM(DPTB1_T)      
  +SUM(DPTB2_T)+SUM(HEP0_T)+SUM(HEP1_T)+SUM(HEP2_T)+SUM(HEP3_T)+SUM(PENTA1_T)+SUM(PENTA2_T)+SUM(PENTA3_T)+SUM(Measles1_T)      
  +SUM(Measles2_T)+SUM(JE1_T)+SUM(JE2_T)+SUM(VITA1_T)+SUM(VITA2_T)+SUM(VITA3_T)+SUM(VITA4_T)+SUM(VITA5_T)+SUM(VITA6_T)      
  +SUM(VITA7_T)+SUM(VITA8_T)+SUM(VITA9_T)+SUM(MMR_T)+SUM(MR_T)+SUM(Typhoid_T)+SUM(RotaVirus_T)+SUM(VitaK_T))as Total_Child_Service_OnTab      
  from Scheduled_AC_Child_District_Block_Month a with(nolock)     
 where (a.District_Code=@District_Code or @District_Code=0)      
  and (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)    
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.District_Code ,a.HealthBlock_Code) C on A.Parent_ID=C.Parent_ID and A.Child_ID=C.Child_ID 
  left outer join      
  (      
  Select  a.District_Code as [Parent_ID] ,a.HealthBlock_Code as [Child_ID]      
  ,Sum(EC_Registered_P) as Total_EC_Registred_OnPortal      
  ,Sum(EC_Registered_T) as Total_EC_Registred_OnTab
  ,(SUM(ECT_With_Condom_P)+SUM(ECT_With_MaleStr_P)+SUM(ECT_With_FeMaleStr_P)+SUM(ECT_With_IUCD_5yr_P)+SUM(ECT_With_IUCD_10yr_P)+SUM(ECT_With_OCP_P)+SUM(ECT_With_ECP_P)) as Total_EC_Services_OnPortal,
  (SUM(ECT_With_Condom_T)+SUM(ECT_With_MaleStr_T)+SUM(ECT_With_FeMaleStr_T)+SUM(ECT_With_IUCD_5yr_T)+SUM(ECT_With_IUCD_10yr_T)+SUM(ECT_With_OCP_T)+SUM(ECT_With_ECP_T)) as Total_EC_Services_OnTab     
  from Scheduled_AC_EC_District_Block_Month a with(nolock)       
  where (a.District_Code=@District_Code or @District_Code=0)      
  and (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.District_Code ,a.HealthBlock_Code) D on A.Parent_ID=D.Parent_ID and A.Child_ID=D.Child_ID     
       
 end           
 else if(@Category ='Block')      
 begin      
       
  Select A.Parent_ID,A.Parent_Name,A.Child_ID,A.Child_Name,     
  ISNULL(B.Total_PW_OnPortal,0) as Total_PW_OnPortal,
  ISNULL(B.Total_PW_OnTab,0) as Total_PW_OnTab,
  ISNULL(B.Total_PW_Service_OnPortal,0) as Total_PW_Service_OnPortal,
  ISNULL(B.Total_PW_Service_OnTab,0) as Total_PW_Service_OnTab,
  ISNULL(C.Total_Child_OnPortal,0) as Total_Child_OnPortal, 
  ISNULL(C.Total_Child_OnTab,0) as Total_Child_OnTab, 
  ISNULL(C.Total_Child_Service_OnPortal,0) as Total_Child_Service_OnPortal, 
  ISNULL(C.Total_Child_Service_OnTab,0) as Total_Child_Service_OnTab, 
  ISNULL(D.Total_EC_Registred_OnPortal,0) as Total_EC_Registred_OnPortal, 
  ISNULL(D.Total_EC_Registred_OnTab,0) as Total_EC_Registred_OnTab,
  ISNULL(D.Total_EC_Services_OnPortal,0) as Total_EC_Services_OnPortal, 
  ISNULL(D.Total_EC_Services_OnTab,0) as Total_EC_Services_OnTab 
  from       
  (select a.BID as Parent_ID,b.Block_Name_E as Parent_Name,a.PHC_CD as Child_ID,a.PHC_NAME as Child_Name,Dist_ANMOL_Live from TBL_PHC a with(nolock)      
  inner join TBL_HEALTH_BLOCK b with(nolock) on a.BID=b.BLOCK_CD      
  inner join TBL_DISTRICT c with(nolock) on b.DISTRICT_CD=c.DIST_CD     
  where a.BID=@HealthBlock_Code OR @HealthBlock_Code=0    
  ) A      
  left outer join      
  (      
  Select a.HealthBlock_Code as [Parent_ID], a.HealthFacility_Code as [Child_ID]      
  ,sum(MOther_P) as Total_PW_OnPortal      
  ,sum(MOther_T) as Total_PW_OnTab          
  ,(SUM(ANC1_P)+SUM(ANC2_P)+SUM(ANC3_P)+SUM(ANC4_P)+SUM([Delivery_P]) +SUM([PNC1_P])+SUM([PNC2_P])+SUM([PNC3_P])+SUM([PNC4_P])      
  +SUM([PNC5_P])+SUM([PNC6_P])+SUM([PNC7_P]))as Total_PW_Service_OnPortal      
  ,(SUM(ANC1_T)+SUM(ANC2_T)+SUM(ANC3_T)+SUM(ANC4_T)+SUM([Delivery_T]) +SUM([PNC1_T])+SUM([PNC2_T])+SUM([PNC3_T])+SUM([PNC4_T])      
  +SUM([PNC5_T])+SUM([PNC6_T])+SUM([PNC7_T]))as Total_PW_Service_OnTab       
  from Scheduled_AC_PW_Block_PHC_Month a with(nolock)      
  where (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)       
  and (a.HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthBlock_Code ,a.HealthFacility_Code) B on A.Parent_ID=B.Parent_ID and A.Child_ID=B.Child_ID 
  left outer join      
  (      
  Select a.HealthBlock_Code as [Parent_ID], a.HealthFacility_Code as [Child_ID]      
  ,sum(Child_P) as Total_Child_OnPortal      
  ,sum(Child_T) as Total_Child_OnTab      
  ,(SUM(BCG_P)+SUM(OPV0_P)+SUM(OPV1_P)+SUM(OPV2_P)+SUM(OPV3_P)+SUM(OPVB_P)+SUM(DPT1_P)+SUM(DPT2_P)+SUM(DPT3_P)+SUM(DPTB1_P)      
  +SUM(DPTB2_P)+SUM(HEP0_P)+SUM(HEP1_P)+SUM(HEP2_P)+SUM(HEP3_P)+SUM(PENTA1_P)+SUM(PENTA2_P)+SUM(PENTA3_P)+SUM(Measles1_P)      
  +SUM(Measles2_P)+SUM(JE1_P)+SUM(JE2_P)+SUM(VITA1_P)+SUM(VITA2_P)+SUM(VITA3_P)+SUM(VITA4_P)+SUM(VITA5_P)+SUM(VITA6_P)      
  +SUM(VITA7_P)+SUM(VITA8_P)+SUM(VITA9_P)+SUM(MMR_P)+SUM(MR_P)+SUM(Typhoid_P)+SUM(RotaVirus_P)+SUM(VitaK_P)) as Total_Child_Service_OnPortal,      
  (SUM(BCG_T)+SUM(OPV0_T)+SUM(OPV1_T)+SUM(OPV2_T)+SUM(OPV3_T)+SUM(OPVB_T)+SUM(DPT1_T)+SUM(DPT2_T)+SUM(DPT3_T)+SUM(DPTB1_T)      
  +SUM(DPTB2_T)+SUM(HEP0_T)+SUM(HEP1_T)+SUM(HEP2_T)+SUM(HEP3_T)+SUM(PENTA1_T)+SUM(PENTA2_T)+SUM(PENTA3_T)+SUM(Measles1_T)      
  +SUM(Measles2_T)+SUM(JE1_T)+SUM(JE2_T)+SUM(VITA1_T)+SUM(VITA2_T)+SUM(VITA3_T)+SUM(VITA4_T)+SUM(VITA5_T)+SUM(VITA6_T)      
  +SUM(VITA7_T)+SUM(VITA8_T)+SUM(VITA9_T)+SUM(MMR_T)+SUM(MR_T)+SUM(Typhoid_T)+SUM(RotaVirus_T)+SUM(VitaK_T))as Total_Child_Service_OnTab      
  from Scheduled_AC_Child_Block_PHC_Month a with(nolock)     
  where (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)       
  and (a.HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0)       
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthBlock_Code ,a.HealthFacility_Code) C on A.Parent_ID=C.Parent_ID and A.Child_ID=C.Child_ID 
  left outer join      
  (      
  Select a.HealthBlock_Code as [Parent_ID], a.HealthFacility_Code as [Child_ID]      
	,Sum(EC_Registered_P) as Total_EC_Registred_OnPortal      
	,Sum(EC_Registered_T) as Total_EC_Registred_OnTab
	,(SUM(ECT_With_Condom_P)+SUM(ECT_With_MaleStr_P)+SUM(ECT_With_FeMaleStr_P)+SUM(ECT_With_IUCD_5yr_P)+SUM(ECT_With_IUCD_10yr_P)+SUM(ECT_With_OCP_P)+SUM(ECT_With_ECP_P)) as Total_EC_Services_OnPortal,
	(SUM(ECT_With_Condom_T)+SUM(ECT_With_MaleStr_T)+SUM(ECT_With_FeMaleStr_T)+SUM(ECT_With_IUCD_5yr_T)+SUM(ECT_With_IUCD_10yr_T)+SUM(ECT_With_OCP_T)+SUM(ECT_With_ECP_T)) as Total_EC_Services_OnTab         
  from Scheduled_AC_EC_Block_PHC_Month a with(nolock)       
  where (a.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)       
  and (a.HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0) 
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthBlock_Code ,a.HealthFacility_Code) D on A.Parent_ID=D.Parent_ID and A.Child_ID=D.Child_ID       
end            
 else if(@Category ='PHC')      
 begin      
   Select A.Parent_ID,A.Parent_Name,A.Child_ID,A.Child_Name,     
  ISNULL(B.Total_PW_OnPortal,0) as Total_PW_OnPortal,
  ISNULL(B.Total_PW_OnTab,0) as Total_PW_OnTab,
  ISNULL(B.Total_PW_Service_OnPortal,0) as Total_PW_Service_OnPortal,
  ISNULL(B.Total_PW_Service_OnTab,0) as Total_PW_Service_OnTab,
  ISNULL(C.Total_Child_OnPortal,0) as Total_Child_OnPortal, 
  ISNULL(C.Total_Child_OnTab,0) as Total_Child_OnTab, 
  ISNULL(C.Total_Child_Service_OnPortal,0) as Total_Child_Service_OnPortal, 
  ISNULL(C.Total_Child_Service_OnTab,0) as Total_Child_Service_OnTab, 
  ISNULL(D.Total_EC_Registred_OnPortal,0) as Total_EC_Registred_OnPortal, 
  ISNULL(D.Total_EC_Registred_OnTab,0) as Total_EC_Registred_OnTab,
  ISNULL(D.Total_EC_Services_OnPortal,0) as Total_EC_Services_OnPortal, 
  ISNULL(D.Total_EC_Services_OnTab,0) as Total_EC_Services_OnTab
   from       
   (select a.PHC_CD as Parent_ID,b.PHC_NAME as Parent_Name,a.SUBPHC_CD as Child_ID,a.SUBPHC_NAME_E as Child_Name,Dist_ANMOL_Live from TBL_SUBPHC a with(nolock)     
   inner join TBL_PHC b with(nolock) on a.PHC_CD=b.PHC_CD      
   inner join TBL_District c with(nolock) on b.Dist_cd=c.Dist_cd    
   where (a.PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)      
   ) A      
  left outer join      
  (      
  Select a.HealthFacility_Code as [Parent_ID], a.HealthSubFacility_Code as [Child_ID]      
  ,sum(MOther_P) as Total_PW_OnPortal      
  ,sum(MOther_T) as Total_PW_OnTab          
  ,(SUM(ANC1_P)+SUM(ANC2_P)+SUM(ANC3_P)+SUM(ANC4_P)+SUM([Delivery_P]) +SUM([PNC1_P])+SUM([PNC2_P])+SUM([PNC3_P])+SUM([PNC4_P])      
  +SUM([PNC5_P])+SUM([PNC6_P])+SUM([PNC7_P]))as Total_PW_Service_OnPortal      
  ,(SUM(ANC1_T)+SUM(ANC2_T)+SUM(ANC3_T)+SUM(ANC4_T)+SUM([Delivery_T]) +SUM([PNC1_T])+SUM([PNC2_T])+SUM([PNC3_T])+SUM([PNC4_T])      
  +SUM([PNC5_T])+SUM([PNC6_T])+SUM([PNC7_T]))as Total_PW_Service_OnTab       
  from Scheduled_AC_PW_PHC_SubCenter_Month a with(nolock)      
  where (a.HealthFacility_Code=@HealthFacility_Code)       
  and (a.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthFacility_Code,a.HealthSubFacility_Code) B on A.Parent_ID=B.Parent_ID and A.Child_ID=B.Child_ID 
  left outer join      
  (      
  Select  a.HealthFacility_Code as [Parent_ID], a.HealthSubFacility_Code as [Child_ID]            
  ,sum(Child_P) as Total_Child_OnPortal      
  ,sum(Child_T) as Total_Child_OnTab      
  ,(SUM(BCG_P)+SUM(OPV0_P)+SUM(OPV1_P)+SUM(OPV2_P)+SUM(OPV3_P)+SUM(OPVB_P)+SUM(DPT1_P)+SUM(DPT2_P)+SUM(DPT3_P)+SUM(DPTB1_P)      
  +SUM(DPTB2_P)+SUM(HEP0_P)+SUM(HEP1_P)+SUM(HEP2_P)+SUM(HEP3_P)+SUM(PENTA1_P)+SUM(PENTA2_P)+SUM(PENTA3_P)+SUM(Measles1_P)      
  +SUM(Measles2_P)+SUM(JE1_P)+SUM(JE2_P)+SUM(VITA1_P)+SUM(VITA2_P)+SUM(VITA3_P)+SUM(VITA4_P)+SUM(VITA5_P)+SUM(VITA6_P)      
  +SUM(VITA7_P)+SUM(VITA8_P)+SUM(VITA9_P)+SUM(MMR_P)+SUM(MR_P)+SUM(Typhoid_P)+SUM(RotaVirus_P)+SUM(VitaK_P)) as Total_Child_Service_OnPortal,      
  (SUM(BCG_T)+SUM(OPV0_T)+SUM(OPV1_T)+SUM(OPV2_T)+SUM(OPV3_T)+SUM(OPVB_T)+SUM(DPT1_T)+SUM(DPT2_T)+SUM(DPT3_T)+SUM(DPTB1_T)      
  +SUM(DPTB2_T)+SUM(HEP0_T)+SUM(HEP1_T)+SUM(HEP2_T)+SUM(HEP3_T)+SUM(PENTA1_T)+SUM(PENTA2_T)+SUM(PENTA3_T)+SUM(Measles1_T)      
  +SUM(Measles2_T)+SUM(JE1_T)+SUM(JE2_T)+SUM(VITA1_T)+SUM(VITA2_T)+SUM(VITA3_T)+SUM(VITA4_T)+SUM(VITA5_T)+SUM(VITA6_T)      
  +SUM(VITA7_T)+SUM(VITA8_T)+SUM(VITA9_T)+SUM(MMR_T)+SUM(MR_T)+SUM(Typhoid_T)+SUM(RotaVirus_T)+SUM(VitaK_T))as Total_Child_Service_OnTab      
  from Scheduled_AC_Child_PHC_SubCenter_Month a with(nolock)     
  where (a.HealthFacility_Code=@HealthFacility_Code)       
  and (a.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthFacility_Code,a.HealthSubFacility_Code) C on A.Parent_ID=C.Parent_ID and A.Child_ID=C.Child_ID 
  left outer join      
  (      
  Select  a.HealthFacility_Code as [Parent_ID], a.HealthSubFacility_Code as [Child_ID]            
	,Sum(EC_Registered_P) as Total_EC_Registred_OnPortal      
	,Sum(EC_Registered_T) as Total_EC_Registred_OnTab
	,(SUM(ECT_With_Condom_P)+SUM(ECT_With_MaleStr_P)+SUM(ECT_With_FeMaleStr_P)+SUM(ECT_With_IUCD_5yr_P)+SUM(ECT_With_IUCD_10yr_P)+SUM(ECT_With_OCP_P)+SUM(ECT_With_ECP_P)) as Total_EC_Services_OnPortal,
	(SUM(ECT_With_Condom_T)+SUM(ECT_With_MaleStr_T)+SUM(ECT_With_FeMaleStr_T)+SUM(ECT_With_IUCD_5yr_T)+SUM(ECT_With_IUCD_10yr_T)+SUM(ECT_With_OCP_T)+SUM(ECT_With_ECP_T)) as Total_EC_Services_OnTab         
  from Scheduled_AC_EC_PHC_SubCenter_Month a with(nolock)       
  where (a.HealthFacility_Code=@HealthFacility_Code)       
  and (a.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthFacility_Code,a.HealthSubFacility_Code) D on A.Parent_ID=D.Parent_ID and A.Child_ID=D.Child_ID       
end     
else if(@Category ='SubCentre')      
 begin      
   Select A.Parent_ID,A.Parent_Name,A.Child_ID,A.Child_Name,     
  ISNULL(B.Total_PW_OnPortal,0) as Total_PW_OnPortal,
  ISNULL(B.Total_PW_OnTab,0) as Total_PW_OnTab,
  ISNULL(B.Total_PW_Service_OnPortal,0) as Total_PW_Service_OnPortal,
  ISNULL(B.Total_PW_Service_OnTab,0) as Total_PW_Service_OnTab,
  ISNULL(C.Total_Child_OnPortal,0) as Total_Child_OnPortal, 
  ISNULL(C.Total_Child_OnTab,0) as Total_Child_OnTab, 
  ISNULL(C.Total_Child_Service_OnPortal,0) as Total_Child_Service_OnPortal, 
  ISNULL(C.Total_Child_Service_OnTab,0) as Total_Child_Service_OnTab, 
  ISNULL(D.Total_EC_Registred_OnPortal,0) as Total_EC_Registred_OnPortal, 
  ISNULL(D.Total_EC_Registred_OnTab,0) as Total_EC_Registred_OnTab,
  ISNULL(D.Total_EC_Services_OnPortal,0) as Total_EC_Services_OnPortal, 
  ISNULL(D.Total_EC_Services_OnTab,0) as Total_EC_Services_OnTab
   from       
 (select v.SID as Parent_ID,isnull(v.VCode,0) as Child_ID,sp.SUBPHC_NAME_E as Parent_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Child_Name                  
 from Health_SC_Village v                   
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=v.VCode and vn.SUBPHC_CD=v.SID                  
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=v.SID                  
 where sp.SUBPHC_CD=@HealthSubFacility_Code     
   ) A      
  left outer join      
  (      
  Select a.HealthSubFacility_Code as [Parent_ID], a.Village_Code as [Child_ID]      
  ,sum(MOther_P) as Total_PW_OnPortal      
  ,sum(MOther_T) as Total_PW_OnTab          
  ,(SUM(ANC1_P)+SUM(ANC2_P)+SUM(ANC3_P)+SUM(ANC4_P)+SUM([Delivery_P]) +SUM([PNC1_P])+SUM([PNC2_P])+SUM([PNC3_P])+SUM([PNC4_P])      
  +SUM([PNC5_P])+SUM([PNC6_P])+SUM([PNC7_P]))as Total_PW_Service_OnPortal      
  ,(SUM(ANC1_T)+SUM(ANC2_T)+SUM(ANC3_T)+SUM(ANC4_T)+SUM([Delivery_T]) +SUM([PNC1_T])+SUM([PNC2_T])+SUM([PNC3_T])+SUM([PNC4_T])      
  +SUM([PNC5_T])+SUM([PNC6_T])+SUM([PNC7_T]))as Total_PW_Service_OnTab       
  from Scheduled_AC_PW_PHC_SubCenter_Village_Month a with(nolock)      
  where (a.HealthSubFacility_Code=@HealthSubFacility_Code)      
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthSubFacility_Code,a.Village_Code ) B on A.Parent_ID=B.Parent_ID and A.Child_ID=B.Child_ID 
  left outer join      
  (      
  Select a.HealthSubFacility_Code as [Parent_ID], a.Village_Code as [Child_ID]             
  ,sum(Child_P) as Total_Child_OnPortal      
  ,sum(Child_T) as Total_Child_OnTab      
  ,(SUM(BCG_P)+SUM(OPV0_P)+SUM(OPV1_P)+SUM(OPV2_P)+SUM(OPV3_P)+SUM(OPVB_P)+SUM(DPT1_P)+SUM(DPT2_P)+SUM(DPT3_P)+SUM(DPTB1_P)      
  +SUM(DPTB2_P)+SUM(HEP0_P)+SUM(HEP1_P)+SUM(HEP2_P)+SUM(HEP3_P)+SUM(PENTA1_P)+SUM(PENTA2_P)+SUM(PENTA3_P)+SUM(Measles1_P)      
  +SUM(Measles2_P)+SUM(JE1_P)+SUM(JE2_P)+SUM(VITA1_P)+SUM(VITA2_P)+SUM(VITA3_P)+SUM(VITA4_P)+SUM(VITA5_P)+SUM(VITA6_P)      
  +SUM(VITA7_P)+SUM(VITA8_P)+SUM(VITA9_P)+SUM(MMR_P)+SUM(MR_P)+SUM(Typhoid_P)+SUM(RotaVirus_P)+SUM(VitaK_P)) as Total_Child_Service_OnPortal,      
  (SUM(BCG_T)+SUM(OPV0_T)+SUM(OPV1_T)+SUM(OPV2_T)+SUM(OPV3_T)+SUM(OPVB_T)+SUM(DPT1_T)+SUM(DPT2_T)+SUM(DPT3_T)+SUM(DPTB1_T)      
  +SUM(DPTB2_T)+SUM(HEP0_T)+SUM(HEP1_T)+SUM(HEP2_T)+SUM(HEP3_T)+SUM(PENTA1_T)+SUM(PENTA2_T)+SUM(PENTA3_T)+SUM(Measles1_T)      
  +SUM(Measles2_T)+SUM(JE1_T)+SUM(JE2_T)+SUM(VITA1_T)+SUM(VITA2_T)+SUM(VITA3_T)+SUM(VITA4_T)+SUM(VITA5_T)+SUM(VITA6_T)      
  +SUM(VITA7_T)+SUM(VITA8_T)+SUM(VITA9_T)+SUM(MMR_T)+SUM(MR_T)+SUM(Typhoid_T)+SUM(RotaVirus_T)+SUM(VitaK_T))as Total_Child_Service_OnTab      
  from Scheduled_AC_Child_PHC_SubCenter_Village_Month a with(nolock)     
  where (a.HealthSubFacility_Code=@HealthSubFacility_Code)        
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthSubFacility_Code,a.Village_Code ) C on A.Parent_ID=C.Parent_ID and A.Child_ID=C.Child_ID 
  left outer join      
  (      
  Select a.HealthSubFacility_Code as [Parent_ID], a.Village_Code as [Child_ID]             
	,Sum(EC_Registered_P) as Total_EC_Registred_OnPortal      
	,Sum(EC_Registered_T) as Total_EC_Registred_OnTab
	,(SUM(ECT_With_Condom_P)+SUM(ECT_With_MaleStr_P)+SUM(ECT_With_FeMaleStr_P)+SUM(ECT_With_IUCD_5yr_P)+SUM(ECT_With_IUCD_10yr_P)+SUM(ECT_With_OCP_P)+SUM(ECT_With_ECP_P)) as Total_EC_Services_OnPortal,
	(SUM(ECT_With_Condom_T)+SUM(ECT_With_MaleStr_T)+SUM(ECT_With_FeMaleStr_T)+SUM(ECT_With_IUCD_5yr_T)+SUM(ECT_With_IUCD_10yr_T)+SUM(ECT_With_OCP_T)+SUM(ECT_With_ECP_T)) as Total_EC_Services_OnTab         
  from Scheduled_AC_EC_PHC_SubCenter_Village_Month a with(nolock)       
  where (a.HealthSubFacility_Code=@HealthSubFacility_Code)
  and (a.Fin_Yr=@FinancialYr or @FinancialYr=0)       
  and (a.Month_ID=@Month_ID or @Month_ID=0)      
  and Filter_Type=1      
  group by a.HealthSubFacility_Code,a.Village_Code ) D on A.Parent_ID=D.Parent_ID and A.Child_ID=D.Child_ID       
end     
end
END
     