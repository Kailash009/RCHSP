USE [RCH_MIGRATION]
GO
/****** Object:  StoredProcedure [dbo].[UpdateInsert_Workplan_Child]    Script Date: 09/26/2024 14:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[UpdateInsert_Workplan_Child]
as
begin

--truncate table MCR_24.dbo.t_workplan_child
delete w from MCR_24.dbo.t_workplan_child  w
inner join RCH_MIGRATION.dbo.NRHM_Format_Child a on a.ID_No=w.ID_No
--where a.District_ID=9

insert into MCR_24.dbo.t_workplan_child
SELECT t.ID_No, t.ServiceID
,t.ServiceMIN,t.ServiceMIN_Month,t.ServiceMIN_Year,t.ServiceMIN_FinYr
,t.ServiceMAX,t.ServiceMAX_Month,t.ServiceMAX_Year,t.ServiceMAX_FinYear
,t.Givendate,t.Givendate_month,t.Givendate_Year,t.Givendate_FinYr
,a.Delete_mother,(case when t.Givendate is null then 0 else 1 end) as IsGiven,GETDATE() as Createdon, Dateadd(day,-1,Birthdate_plus1day)
FROM MCR_24.dbo.NRHM_Format_Child_Total a  
inner join RCH_MIGRATION.dbo.NRHM_Format_Child b on a.ID_no=b.ID_no
CROSS APPLY 
(     VALUES          
(a.ID_No,Dateadd(day,-1,Birthdate_plus1day),Birthdate_Month,Birthdate_Year,a.yr,Birthdate_plus1yr,Birthdate_plus1yr_month,Birthdate_plus1yr_Year,Birthdate_plus1yr_FinYear,1,a.BCG_Dt,BCG_Dt_month,BCG_Dt_Year,BCG_Dt_FinYear)   
,(a.ID_No,Dateadd(day,-1,Birthdate_plus1day),Birthdate_Month,Birthdate_Year,a.yr,Birthdate_plus1day,Birthdate_plus1day_month,Birthdate_plus1day_Year,Birthdate_plus1day_FinYear,2,HepatitisB0_Dt,HepatitisB0_Dt_month,HepatitisB0_Dt_Year,HepatitisB0_Dt_FinYear)   
,(a.ID_No,Dateadd(day,-1,Birthdate_plus1day),Birthdate_Month,Birthdate_Year,a.yr,Birthdate_plus14day,Birthdate_plus14day_month,Birthdate_plus14day_Year,Birthdate_plus14day_FinYear,3,a.OPV0_Dt,OPV0_Dt_month,OPV0_Dt_Year,OPV0_Dt_FinYear)    
,(a.ID_No,Birthdate_plus14day,Birthdate_plus14day_month,Birthdate_plus14day_Year,Birthdate_plus14day_FinYear,Birthdate_plus1yr,Birthdate_plus1yr_month,Birthdate_plus1yr_Year,Birthdate_plus1yr_FinYear,(case when a.Penta1_Dt is null then 4 else 0 end),a.DPT1_Dt,DPT1_Dt_month,DPT1_Dt_Year,DPT1_Dt_FinYear) 
,(a.ID_No,Birthdate_plus14day,Birthdate_plus14day_month,Birthdate_plus14day_Year,Birthdate_plus14day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.Penta1_Dt is null then 5 else 0 end),a.OPV1_Dt,OPV1_Dt_Month,OPV1_Dt_Year,OPV1_Dt_FinYear) 
,(a.ID_No,Birthdate_plus14day,Birthdate_plus14day_month,Birthdate_plus14day_Year,Birthdate_plus14day_FinYear,Birthdate_plus11mon,Birthdate_plus11mon_month,Birthdate_plus11mon_Year,Birthdate_plus11mon_FinYear,(case when a.Penta1_Dt is null then 6 else 0 end),a.HepatitisB1_Dt,HepatitisB1_Dt_month,HepatitisB1_Dt_Year,HepatitisB1_Dt_FinYear)         
,(a.ID_No,OPV1_plus28day,OPV1_plus28day_month,OPV1_plus28day_Year,OPV1_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.OPV1_Dt is not null then 7 else 0 end),a.OPV2_Dt,OPV2_Dt_Month,OPV2_Dt_Year,OPV2_Dt_FinYear)         
,(a.ID_No,DPT1_plus28day,DPT1_plus28day_month,DPT1_plus28day_Year,DPT1_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.DPT1_Dt is not null then 8 else 0 end),a.DPT2_Dt,DPT2_Dt_month,DPT2_Dt_Year,DPT2_Dt_FinYear)         
,(a.ID_No,HepatitisB1_plus28day,HepatitisB1_plus28day_month,HepatitisB1_plus28day_Year,HepatitisB1_plus28day_FinYear,Birthdate_plus11mon,Birthdate_plus11mon_month,Birthdate_plus11mon_Year,Birthdate_plus11mon_FinYear,(case when a.HepatitisB1_Dt is not null then 9 else 0 end),a.HepatitisB2_Dt,HepatitisB2_Dt_month,HepatitisB2_Dt_Year,HepatitisB2_Dt_FinYear)  

,(a.ID_No,OPV2_plus28day,OPV2_plus28day_month,OPV2_plus28day_Year,OPV2_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.OPV2_Dt is not null then 10 else 0 end),a.OPV3_Dt,OPV3_Dt_Month,OPV3_Dt_Year,OPV3_Dt_FinYear)         
,(a.ID_No,DPT2_plus28day,DPT2_plus28day_month,DPT2_plus28day_Year,DPT2_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.DPT2_Dt is not null then 11 else 0 end),a.DPT3_Dt,DPT3_Dt_month,DPT3_Dt_Year,DPT3_Dt_FinYear)         
,(a.ID_No,HepatitisB2_plus28day,HepatitisB2_plus28day_month,HepatitisB2_plus28day_Year,HepatitisB2_plus28day_FinYear,Birthdate_plus11mon,Birthdate_plus11mon_month,Birthdate_plus11mon_Year,Birthdate_plus11mon_FinYear,(case when a.HepatitisB2_Dt is not null then 12 else 0 end),a.HepatitisB3_Dt,HepatitisB3_Dt_month,HepatitisB3_Dt_Year,HepatitisB3_Dt_FinYear)   

,(a.ID_No,Birthdate_plus270day,Birthdate_plus270day_month,Birthdate_plus270day_Year,Birthdate_plus270day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,13,Measles1_Dt,Measles1_month,Measles1_Year,Measles1_FinYear)   
,(a.ID_No,Birthdate_plus270day,Birthdate_plus270day_month,Birthdate_plus270day_Year,Birthdate_plus270day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,14,a.VitA_Dose1_Dt,VitA_Dose1_Dt_month,VitA_Dose1_Dt_Year,VitA_Dose1_Dt_FinYear)   

,(a.ID_No,DPT3_plus6mon,DPT3_plus6mon_month,DPT3_plus6mon_Year,DPT3_plus6mon_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.DPT3_Dt is not null then 15 else 0 end),a.DPTBooster_Dt,DPTBooster_Dt_month,DPTBooster_Dt_Year,DPTBooster_Dt_FinYear)         
,(a.ID_No,OPV3_plus6mon,OPV3_plus6mon_month,OPV3_plus6mon_Year,OPV3_plus6mon_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.OPV3_Dt is not null then 16 else 0 end),a.OPVBooster_Dt,OPVBooster_Dt_month,OPVBooster_Dt_Year,OPVBooster_Dt_FinYear)         

,(a.ID_No,Birthdate_plus16mon,Birthdate_plus16mon_month,Birthdate_plus16mon_Year,Birthdate_plus16mon_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when Measles1_Dt is not null then 17 else 0 end),a.MR_Dt,MR_Dt_month,MR_Dt_Year,MR_Dt_FinYear)         
 
,(a.ID_No,VitA_Dose1_plus6mon,VitA_Dose1_plus6mon_month,VitA_Dose1_plus6mon_Year,VitA_Dose1_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose1_Dt is not null then 18 else 0 end),a.VitA_Dose2_Dt,VitA_Dose2_Dt_month,VitA_Dose2_Dt_Year,VitA_Dose2_Dt_FinYear)         
,(a.ID_No,VitA_Dose2_plus6mon,VitA_Dose2_plus6mon_month,VitA_Dose2_plus6mon_Year,VitA_Dose2_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose2_Dt is not null then 19 else 0 end),a.VitA_Dose3_Dt,VitA_Dose3_Dt_month,VitA_Dose3_Dt_Year,VitA_Dose3_Dt_FinYear)     
,(a.ID_No,VitA_Dose3_plus6mon,VitA_Dose3_plus6mon_month,VitA_Dose3_plus6mon_Year,VitA_Dose3_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose3_Dt is not null then 20 else 0 end),a.VitA_Dose4_Dt,VitA_Dose4_Dt_month,VitA_Dose4_Dt_Year,VitA_Dose4_Dt_FinYear)     
,(a.ID_No,VitA_Dose4_plus6mon,VitA_Dose4_plus6mon_month,VitA_Dose4_plus6mon_Year,VitA_Dose4_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose4_Dt is not null then 21 else 0 end),a.VitA_Dose5_Dt,VitA_Dose5_Dt_month,VitA_Dose5_Dt_Year,VitA_Dose5_Dt_FinYear)     
,(a.ID_No,VitA_Dose5_plus6mon,VitA_Dose5_plus6mon_month,VitA_Dose5_plus6mon_Year,VitA_Dose5_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose5_Dt is not null then 22 else 0 end),a.VitA_Dose6_Dt,VitA_Dose6_Dt_month,VitA_Dose6_Dt_Year,VitA_Dose6_Dt_FinYear)     
,(a.ID_No,VitA_Dose6_plus6mon,VitA_Dose6_plus6mon_month,VitA_Dose6_plus6mon_Year,VitA_Dose6_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose6_Dt is not null then 23 else 0 end),a.VitA_Dose7_Dt,VitA_Dose7_Dt_month,VitA_Dose7_Dt_Year,VitA_Dose7_Dt_FinYear)     
,(a.ID_No,VitA_Dose7_plus6mon,VitA_Dose7_plus6mon_month,VitA_Dose7_plus6mon_Year,VitA_Dose7_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose7_Dt is not null then 24 else 0 end),a.VitA_Dose8_Dt,VitA_Dose8_Dt_month,VitA_Dose8_Dt_Year,VitA_Dose8_Dt_FinYear)     
,(a.ID_No,VitA_Dose8_plus6mon,VitA_Dose8_plus6mon_month,VitA_Dose8_plus6mon_Year,VitA_Dose8_plus6mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,(case when a.VitA_Dose8_Dt is not null then 25 else 0 end),a.VitA_Dose9_Dt,VitA_Dose9_Dt_month,VitA_Dose9_Dt_Year,VitA_Dose9_Dt_FinYear)     
 
,(a.ID_No,Birthdate_plus60mon,Birthdate_plus60mon_month,Birthdate_plus60mon_Year,Birthdate_plus60mon_FinYear,Birthdate_plus83mon,Birthdate_plus83mon_month,Birthdate_plus83mon_Year,Birthdate_plus83mon_FinYear,26,a.DT5_Dt,DT5_Dt_month,DT5_Dt_Year,DT5_Dt_FinYear)     
,(a.ID_No,Birthdate_plus120mon,Birthdate_plus120mon_month,Birthdate_plus120mon_Year,Birthdate_plus120mon_FinYear,Birthdate_plus191mon,Birthdate_plus191mon_month,Birthdate_plus191mon_Year,Birthdate_plus191mon_FinYear,27,a.TT10_Dt,TT10_Dt_month,TT10_Dt_Year,TT10_Dt_FinYear)     
,(a.ID_No,Birthdate_plus192mon,Birthdate_plus192mon_month,Birthdate_plus192mon_Year,Birthdate_plus192mon_FinYear,Birthdate_plus204mon,Birthdate_plus204mon_month,Birthdate_plus204mon_Year,Birthdate_plus204mon_FinYear,28,a.TT16_Dt,TT16_Dt_month,TT16_Dt_Year,TT16_Dt_FinYear)     
,(a.ID_No,Birthdate_plus270day,Birthdate_plus270day_month,Birthdate_plus270day_Year,Birthdate_plus270day_FinYear,Birthdate_plus179mon,Birthdate_plus179mon_month,Birthdate_plus179mon_Year,Birthdate_plus179mon_FinYear,29,a.JE_Dt,JE2_Dt_month,JE2_Dt_Year,JE2_Dt_FinYear)     
 
,(a.ID_No,Birthdate_plus16mon,Birthdate_plus16mon_month,Birthdate_plus16mon_Year,Birthdate_plus16mon_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.Measles1_Dt is not null then 30 else 0 end),a.Measles2_Dt,Measles2_Dt_month,Measles2_Dt_Year,Measles2_Dt_FinYear)         

,(a.ID_No,Penta1_plus28day,Penta1_plus28day_month,Penta1_plus28day_Year,Penta1_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.Penta1_Dt is not null then 32 else 0 end),a.Penta2_Dt,Penta2_Dt_month,Penta2_Dt_Year,Penta2_FinYear)         
,(a.ID_No,Penta2_plus28day,Penta2_plus28day_month,Penta2_plus28day_Year,Penta2_plus28day_FinYear,Birthdate_plus59mon,Birthdate_plus59mon_month,Birthdate_plus59mon_Year,Birthdate_plus59mon_FinYear,(case when a.Penta2_Dt is not null then 33 else 0 end),a.Penta3_Dt,Penta3_Dt_month,Penta3_Dt_Year,Penta3_FinYear)         

 ) 
t(ID_No, ServiceMIN,ServiceMIN_Month,ServiceMIN_Year,ServiceMIN_FinYr, ServiceMAX,ServiceMAX_Month,ServiceMAX_Year,ServiceMAX_FinYear,ServiceID,Givendate,Givendate_month,Givendate_Year,Givendate_FinYr)
WHERE --a.District_ID=9 and 
t.ServiceID>0
end
