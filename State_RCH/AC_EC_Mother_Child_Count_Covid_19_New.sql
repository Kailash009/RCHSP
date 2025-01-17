USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_Mother_Child_Count_Covid_19_New]    Script Date: 09/26/2024 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
AC_EC_Mother_Child_Count_Covid_19_New 29,0,0,0,0,0,2019,5,0,'','','State',''  
AC_EC_Mother_Child_Count_Covid_19_New 29,1,0,0,0,0,2019,5,0,'','','District',''  
AC_EC_Mother_Child_Count_Covid_19_New 29,1,7,0,0,0,2019,5,0,'','','Block',''  
AC_EC_Mother_Child_Count_Covid_19_New 29,1,7,118,0,0,2019,5,0,'','','PHC',''  
*/  
ALTER procedure [dbo].[AC_EC_Mother_Child_Count_Covid_19_New]                   
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
@Category varchar(20) ='',  
@Type varchar(20) =''                  
)                 
as                     
begin                          
if(@Category='State')                      
begin                      
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,                
isNull(B.PW_ANC,0) as PW_ANC,                
isNull(B.PNC,0) as PW_PNC,                           
isNuLL(B.Delivery,0) as PW_Deliveries,                                 
isNuLL(C.CH_Immu,0) as Child_Immunisation,
ISNULL(B.ANC_Covid_Positive,0) as ANC_Covid_Positive,
ISNULL(B.Delivery_Covid_Positive,0) as Delivery_Covid_Positive,
ISNULL(B.PNC_Covid_Positive,0) as PNC_Covid_Positive,
ISNULL(C.CH_Covid_Positive,0) as CH_Covid_Positive                                
from  
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                   
from TBL_DISTRICT a                    
inner join TBL_STATE b on a.StateID=b.StateID                    
where b.StateID=@State_Code         
)A                
left outer join                
(select S.StateID,D.DCode,                   
sum(PW.ANC1_G_Count + PW.ANC2_G_Count + PW.ANC3_G_Count + PW.ANC4_G_Count) as [PW_ANC],  
sum(PW.Delivery_G_Count) as [Delivery],  
sum(PW.PNC1_G_Count + PW.PNC2_G_Count + PW.PNC3_G_Count + PW.PNC4_G_Count + PW.PNC5_G_Count + PW.PNC6_G_Count + PW.PNC7_G_Count) as [PNC],
sum(PW.ANC1_covid + PW.ANC2_covid + PW.ANC3_covid + PW.ANC4_covid) as [ANC_Covid_Positive],  
sum(PW.Delivery_covid) as [Delivery_Covid_Positive],  
sum(PW.PNC1_covid + PW.PNC2_covid + PW.PNC3_covid + PW.PNC4_covid + PW.PNC5_covid + PW.PNC6_covid + PW.PNC7_covid) as [PNC_Covid_Positive] 
from Scheduled_AC_PW_Service_PHC_SubCenter_Month PW  
Left outer join Health_SubCentre SC on SC.SID=PW.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=PW.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID                  
where PW.Given_Yr=@FinancialYr  and PW.Given_Month=@Month_ID              
and S.StateID=@State_Code   
 group by S.StateID,D.DCode               
)B on A.State_Code=B.StateID and A.District_Code=B.DCode                 
left outer join                
(                
select S.StateID,D.DCode,                   
 Sum(BCG_G_Count + OPV0_G_Count + HEP0_G_Count + DPT1_G_Count + OPV1_G_Count + HEP1_G_Count + Pentavalent1_G_Count +   
DPT2_G_Count + OPV2_G_Count + HEP2_G_Count + Pentavalent2_G_Count + DPT3_G_Count + OPV3_G_Count + HEP3_G_Count + Pentavalent3_G_Count +   
Measles1_G_Count + VitADose1_G_Count + JEVaccine_G_Count + Rota_virus_1_G_Count + Rota_virus_2_G_Count + Rota_virus_3_G_Count +   
IPV_1_G_Count + IPV_2_G_Count + Dpt1_Booster_G_Count + OPV1_Booster_G_COunt +   
Measles2_G_Count + Vita_A_2_G_Count + Vita_A_3_G_Count + JE_2_Vaccine_G_Count + MR1_G_Count + MR2_G_Count + PCV1_G_Count + PCV2_G_Count +   
PCVB_G_Count + DPT_B2_G_Count + VITAMIN_A4_G_Count + VITAMIN_A5_G_Count + VITAMIN_A6_G_Count + VITAMIN_A7_G_Count + VITAMIN_A8_G_Count +   
VITAMIN_A9_G_Count + MMR_G_Count + Typhoid_G_Count + VITAMIN_K_G_Count) as [CH_Immu],
Sum(BCG_covid + OPV0_covid + HEP0_covid + DPT1_covid + OPV1_covid + HEP1_covid + Pentavalent1_covid + DPT2_covid + OPV2_covid +
HEP2_covid + Pentavalent2_covid + DPT3_covid + OPV3_covid + HEP3_covid +
Pentavalent3_covid + Measles1_covid + VitADose1_covid + JEVaccine_covid + Rota_virus_1_covid + Rota_virus_2_covid +
Rota_virus_3_covid + IPV_1_covid + IPV_2_covid + Dpt1_Booster_covid + OPV1_Booster_covid + Measles2_covid + Vita_A_2_covid +
Vita_A_3_covid + JE_2_Vaccine_covid + MR1_covid + MR2_covid + PCV1_covid + PCV2_covid + PCVB_covid + DPT_B2_covid + VITAMIN_A4_covid +
VITAMIN_A5_covid + VITAMIN_A6_covid + VITAMIN_A7_covid + VITAMIN_A8_covid + VITAMIN_A9_covid + MMR_covid + Typhoid_covid + VITAMIN_K_covid ) as CH_Covid_Positive  
 From Scheduled_AC_CH_Service_PHC_SubCenter_Month CH  
Left outer join Health_SubCentre SC on SC.SID=CH.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=CH.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID     
where CH.Given_Yr=@FinancialYr  and CH.Given_Month=@Month_ID              
and S.StateID=@State_Code   
group by S.StateID,D.DCode              
)C on A.State_Code=C.StateID and A.District_Code=C.DCode                  
end                    
else if(@Category='District')                      
begin                      
select  A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                
isNull(B.ANC,0) as PW_ANC,                
isNull(B.PNC,0) as PW_PNC,                           
isNuLL(B.Delivery,0) as PW_Deliveries,                                 
isNuLL(C.CH_Immu,0) as  Child_Immunisation,
ISNULL(B.ANC_Covid_Positive,0) as ANC_Covid_Positive,
ISNULL(B.Delivery_Covid_Positive,0) as Delivery_Covid_Positive,
ISNULL(B.PNC_Covid_Positive,0) as PNC_Covid_Positive,
ISNULL(C.CH_Covid_Positive,0) as CH_Covid_Positive 
from                
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                    
from TBL_HEALTH_BLOCK a                    
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD                     
where a.DISTRICT_CD=@District_Code                
)A                
left outer join                
(select D.DCode,HB.BID,                   
sum(PW.ANC1_G_Count + PW.ANC2_G_Count + PW.ANC3_G_Count + PW.ANC4_G_Count) as [ANC],  
sum(PW.Delivery_G_Count) as [Delivery],  
sum(PW.PNC1_G_Count + PW.PNC2_G_Count + PW.PNC3_G_Count + PW.PNC4_G_Count + PW.PNC5_G_Count + PW.PNC6_G_Count + PW.PNC7_G_Count) as [PNC],
sum(PW.ANC1_covid + PW.ANC2_covid + PW.ANC3_covid + PW.ANC4_covid) as [ANC_Covid_Positive],  
sum(PW.Delivery_covid) as [Delivery_Covid_Positive],  
sum(PW.PNC1_covid + PW.PNC2_covid + PW.PNC3_covid + PW.PNC4_covid + PW.PNC5_covid + PW.PNC6_covid + PW.PNC7_covid) as [PNC_Covid_Positive]         
from Scheduled_AC_PW_Service_PHC_SubCenter_Month PW  
Left outer join Health_SubCentre SC on SC.SID=PW.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=PW.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID                  
where PW.Given_Yr=@FinancialYr  and PW.Given_Month=@Month_ID                       
and D.DCode=@District_Code           
group by D.DCode,HB.BID                
)B on A.District_Code=B.DCode and A.HealthBlock_Code=B.BID                
left outer join                
(  
select D.DCode as District_Code,HB.BID,                                  
 Sum(BCG_G_Count + OPV0_G_Count + HEP0_G_Count + DPT1_G_Count + OPV1_G_Count + HEP1_G_Count + Pentavalent1_G_Count +   
DPT2_G_Count + OPV2_G_Count + HEP2_G_Count + Pentavalent2_G_Count + DPT3_G_Count + OPV3_G_Count + HEP3_G_Count + Pentavalent3_G_Count +   
Measles1_G_Count + VitADose1_G_Count + JEVaccine_G_Count + Rota_virus_1_G_Count + Rota_virus_2_G_Count + Rota_virus_3_G_Count +   
IPV_1_G_Count + IPV_2_G_Count + Dpt1_Booster_G_Count + OPV1_Booster_G_COunt +   
Measles2_G_Count + Vita_A_2_G_Count + Vita_A_3_G_Count + JE_2_Vaccine_G_Count + MR1_G_Count + MR2_G_Count + PCV1_G_Count + PCV2_G_Count +   
PCVB_G_Count + DPT_B2_G_Count + VITAMIN_A4_G_Count + VITAMIN_A5_G_Count + VITAMIN_A6_G_Count + VITAMIN_A7_G_Count + VITAMIN_A8_G_Count +   
VITAMIN_A9_G_Count + MMR_G_Count + Typhoid_G_Count + VITAMIN_K_G_Count) as [CH_Immu],
Sum(BCG_covid + OPV0_covid + HEP0_covid + DPT1_covid + OPV1_covid + HEP1_covid + Pentavalent1_covid + DPT2_covid + OPV2_covid +
HEP2_covid + Pentavalent2_covid + DPT3_covid + OPV3_covid + HEP3_covid +
Pentavalent3_covid + Measles1_covid + VitADose1_covid + JEVaccine_covid + Rota_virus_1_covid + Rota_virus_2_covid +
Rota_virus_3_covid + IPV_1_covid + IPV_2_covid + Dpt1_Booster_covid + OPV1_Booster_covid + Measles2_covid + Vita_A_2_covid +
Vita_A_3_covid + JE_2_Vaccine_covid + MR1_covid + MR2_covid + PCV1_covid + PCV2_covid + PCVB_covid + DPT_B2_covid + VITAMIN_A4_covid +
VITAMIN_A5_covid + VITAMIN_A6_covid + VITAMIN_A7_covid + VITAMIN_A8_covid + VITAMIN_A9_covid + MMR_covid + Typhoid_covid + VITAMIN_K_covid ) as CH_Covid_Positive  
 From Scheduled_AC_CH_Service_PHC_SubCenter_Month CH  
Left outer join Health_SubCentre SC on SC.SID=CH.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=CH.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID     
where CH.Given_Yr=@FinancialYr  and CH.Given_Month=@Month_ID                 
and D.DCode=@District_Code               
group by D.DCode,HB.BID                 
)C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.BID                
end   
else if(@Category='Block')                      
begin                      
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName ,                   
isNull(B.ANC,0) as PW_ANC,                
isNull(B.PNC,0) as PW_PNC,                           
isNuLL(B.Delivery,0) as PW_Deliveries,                                 
isNuLL(C.CH_Immu,0) as  Child_Immunisation,
ISNULL(B.ANC_Covid_Positive,0) as ANC_Covid_Positive,
ISNULL(B.Delivery_Covid_Positive,0) as Delivery_Covid_Positive,
ISNULL(B.PNC_Covid_Positive,0) as PNC_Covid_Positive,
ISNULL(C.CH_Covid_Positive,0) as CH_Covid_Positive    
from                
(select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                    
from TBL_PHC a                    
  inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD                
  inner join TBL_DISTRICT C on a.DIST_CD=C.DIST_CD                     
where a.BID=@HealthBlock_Code                 
)A               
left outer join                
(select HB.BID,PH.PID,                   
sum(PW.ANC1_G_Count + PW.ANC2_G_Count + PW.ANC3_G_Count + PW.ANC4_G_Count) as [ANC],  
sum(PW.Delivery_G_Count) as [Delivery],  
sum(PW.PNC1_G_Count + PW.PNC2_G_Count + PW.PNC3_G_Count + PW.PNC4_G_Count + PW.PNC5_G_Count + PW.PNC6_G_Count + PW.PNC7_G_Count) as [PNC],
sum(PW.ANC1_covid + PW.ANC2_covid + PW.ANC3_covid + PW.ANC4_covid) as [ANC_Covid_Positive],  
sum(PW.Delivery_covid) as [Delivery_Covid_Positive],  
sum(PW.PNC1_covid + PW.PNC2_covid + PW.PNC3_covid + PW.PNC4_covid + PW.PNC5_covid + PW.PNC6_covid + PW.PNC7_covid) as [PNC_Covid_Positive]                  
from Scheduled_AC_PW_Service_PHC_SubCenter_Month PW  
Left outer join Health_SubCentre SC on SC.SID=PW.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=PW.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID                  
where PW.Given_Yr=@FinancialYr  and PW.Given_Month=@Month_ID                  
and HB.BID=@HealthBlock_Code   
group by HB.BID,PH.PID                
)B on A.HealthBlock_Code=B.BID and A.HealthFacility_Code=B.PID                
left outer join                
(                
select HB.BID,PH.PID                
,Sum(BCG_G_Count + OPV0_G_Count + HEP0_G_Count + DPT1_G_Count + OPV1_G_Count + HEP1_G_Count + Pentavalent1_G_Count +   
DPT2_G_Count + OPV2_G_Count + HEP2_G_Count + Pentavalent2_G_Count + DPT3_G_Count + OPV3_G_Count + HEP3_G_Count + Pentavalent3_G_Count +   
Measles1_G_Count + VitADose1_G_Count + JEVaccine_G_Count + Rota_virus_1_G_Count + Rota_virus_2_G_Count + Rota_virus_3_G_Count +   
IPV_1_G_Count + IPV_2_G_Count + Dpt1_Booster_G_Count + OPV1_Booster_G_COunt +   
Measles2_G_Count + Vita_A_2_G_Count + Vita_A_3_G_Count + JE_2_Vaccine_G_Count + MR1_G_Count + MR2_G_Count + PCV1_G_Count + PCV2_G_Count +   
PCVB_G_Count + DPT_B2_G_Count + VITAMIN_A4_G_Count + VITAMIN_A5_G_Count + VITAMIN_A6_G_Count + VITAMIN_A7_G_Count + VITAMIN_A8_G_Count +   
VITAMIN_A9_G_Count + MMR_G_Count + Typhoid_G_Count + VITAMIN_K_G_Count) as [CH_Immu],
Sum(BCG_covid + OPV0_covid + HEP0_covid + DPT1_covid + OPV1_covid + HEP1_covid + Pentavalent1_covid + DPT2_covid + OPV2_covid +
HEP2_covid + Pentavalent2_covid + DPT3_covid + OPV3_covid + HEP3_covid +
Pentavalent3_covid + Measles1_covid + VitADose1_covid + JEVaccine_covid + Rota_virus_1_covid + Rota_virus_2_covid +
Rota_virus_3_covid + IPV_1_covid + IPV_2_covid + Dpt1_Booster_covid + OPV1_Booster_covid + Measles2_covid + Vita_A_2_covid +
Vita_A_3_covid + JE_2_Vaccine_covid + MR1_covid + MR2_covid + PCV1_covid + PCV2_covid + PCVB_covid + DPT_B2_covid + VITAMIN_A4_covid +
VITAMIN_A5_covid + VITAMIN_A6_covid + VITAMIN_A7_covid + VITAMIN_A8_covid + VITAMIN_A9_covid + MMR_covid + Typhoid_covid + VITAMIN_K_covid ) as CH_Covid_Positive 
 From Scheduled_AC_CH_Service_PHC_SubCenter_Month CH  
Left outer join Health_SubCentre SC on SC.SID=CH.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=CH.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID     
where CH.Given_Yr=@FinancialYr  and CH.Given_Month=@Month_ID                  
and HB.BID=@HealthBlock_Code    
group by HB.BID,PH.PID              
)C on A.HealthBlock_Code=C.BID and A.HealthFacility_Code=C.PID                 
end   
 else if(@Category='PHC')                      
begin                      
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName ,                
isNull(B.ANC,0) as PW_ANC,                
isNull(B.PNC,0) as PW_PNC,                           
isNuLL(B.Delivery,0) as PW_Deliveries,                                 
isNuLL(C.CH_Immu,0) as  Child_Immunisation,
ISNULL(B.ANC_Covid_Positive,0) as ANC_Covid_Positive,
ISNULL(B.Delivery_Covid_Positive,0) as Delivery_Covid_Positive,
ISNULL(B.PNC_Covid_Positive,0) as PNC_Covid_Positive,
ISNULL(C.CH_Covid_Positive,0) as CH_Covid_Positive    
from                
(select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                
from TBL_SUBPHC a                    
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                
where a.PHC_CD= @HealthFacility_Code                 
)A                
left outer join                
(select PH.PID,SC.SID,                  
 sum(PW.ANC1_G_Count + PW.ANC2_G_Count + PW.ANC3_G_Count + PW.ANC4_G_Count) as [ANC],  
sum(PW.Delivery_G_Count) as [Delivery],  
sum(PW.PNC1_G_Count + PW.PNC2_G_Count + PW.PNC3_G_Count + PW.PNC4_G_Count + PW.PNC5_G_Count + PW.PNC6_G_Count + PW.PNC7_G_Count) as [PNC],
sum(PW.ANC1_covid + PW.ANC2_covid + PW.ANC3_covid + PW.ANC4_covid) as [ANC_Covid_Positive],  
sum(PW.Delivery_covid) as [Delivery_Covid_Positive],  
sum(PW.PNC1_covid + PW.PNC2_covid + PW.PNC3_covid + PW.PNC4_covid + PW.PNC5_covid + PW.PNC6_covid + PW.PNC7_covid) as [PNC_Covid_Positive]                  
from Scheduled_AC_PW_Service_PHC_SubCenter_Month PW  
Left outer join Health_SubCentre SC on SC.SID=PW.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=PW.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID                  
where PW.Given_Yr=@FinancialYr  and PW.Given_Month=@Month_ID                    
and PH.PID=@HealthFacility_Code    
group by PH.PID,SC.SID               
)B on A.HealthFacility_Code=B.PID and A.HealthSubFacility_Code=B.SID                 
left outer join              
(                
select PH.PID,SC.SID  
,Sum(BCG_G_Count + OPV0_G_Count + HEP0_G_Count + DPT1_G_Count + OPV1_G_Count + HEP1_G_Count + Pentavalent1_G_Count +   
DPT2_G_Count + OPV2_G_Count + HEP2_G_Count + Pentavalent2_G_Count + DPT3_G_Count + OPV3_G_Count + HEP3_G_Count + Pentavalent3_G_Count +   
Measles1_G_Count + VitADose1_G_Count + JEVaccine_G_Count + Rota_virus_1_G_Count + Rota_virus_2_G_Count + Rota_virus_3_G_Count +   
IPV_1_G_Count + IPV_2_G_Count + Dpt1_Booster_G_Count + OPV1_Booster_G_COunt +   
Measles2_G_Count + Vita_A_2_G_Count + Vita_A_3_G_Count + JE_2_Vaccine_G_Count + MR1_G_Count + MR2_G_Count + PCV1_G_Count + PCV2_G_Count +   
PCVB_G_Count + DPT_B2_G_Count + VITAMIN_A4_G_Count + VITAMIN_A5_G_Count + VITAMIN_A6_G_Count + VITAMIN_A7_G_Count + VITAMIN_A8_G_Count +   
VITAMIN_A9_G_Count + MMR_G_Count + Typhoid_G_Count + VITAMIN_K_G_Count) as [CH_Immu],
Sum(BCG_covid + OPV0_covid + HEP0_covid + DPT1_covid + OPV1_covid + HEP1_covid + Pentavalent1_covid + DPT2_covid + OPV2_covid +
HEP2_covid + Pentavalent2_covid + DPT3_covid + OPV3_covid + HEP3_covid +
Pentavalent3_covid + Measles1_covid + VitADose1_covid + JEVaccine_covid + Rota_virus_1_covid + Rota_virus_2_covid +
Rota_virus_3_covid + IPV_1_covid + IPV_2_covid + Dpt1_Booster_covid + OPV1_Booster_covid + Measles2_covid + Vita_A_2_covid +
Vita_A_3_covid + JE_2_Vaccine_covid + MR1_covid + MR2_covid + PCV1_covid + PCV2_covid + PCVB_covid + DPT_B2_covid + VITAMIN_A4_covid +
VITAMIN_A5_covid + VITAMIN_A6_covid + VITAMIN_A7_covid + VITAMIN_A8_covid + VITAMIN_A9_covid + MMR_covid + Typhoid_covid + VITAMIN_K_covid ) as CH_Covid_Positive  
From Scheduled_AC_CH_Service_PHC_SubCenter_Month CH  
Left outer join Health_SubCentre SC on SC.SID=CH.SubCentre_ID  
Left outer join Health_PHC PH on PH.PID=CH.PHC_ID  
Left outer join Health_Block HB on HB.BID=PH.BID  
Left outer join District D on D.DCode=HB.DCode  
Left outer join State S on S.StateID=D.StateID     
where CH.Given_Yr=@FinancialYr  and CH.Given_Month=@Month_ID         
and PH.PID=@HealthFacility_Code   
group by PH.PID,SC.SID             
)C on A.HealthFacility_Code=C.PID and A.HealthSubFacility_Code=C.SID                        
end  
end

