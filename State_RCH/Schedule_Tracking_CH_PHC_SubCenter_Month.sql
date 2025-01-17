USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Tracking_CH_PHC_SubCenter_Month]    Script Date: 09/26/2024 14:46:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[Schedule_Tracking_CH_PHC_SubCenter_Month]

as
begin

SET NOCOUNT ON 

truncate table Scheduled_Tracking_CH_PHC_SubCenter_Month
insert into Scheduled_Tracking_CH_PHC_SubCenter_Month([State_Code],[HealthFacility_Code],[HealthSubFacility_Code]
,[Year_ID],[Month_ID],[Total_Birthdate],[BCG],[OPV0],[HEP0]
,[DPT1],[OPV1],[HEP1],[PENTA1]
,[DPT2],[OPV2],[HEP2],[PENTA2]
,[DPT3],[OPV3],[HEP3],[PENTA3]
,[Measles],[AllVac],[Dead_Child],[Delete_Child]
,[Date_As_On],[Fin_Yr]
,BCG_OPV0_HEP0,Received_All_Vac,BreastFed_6Months
-----------------------------------------Jyoti 13 March 2019--------------------------
,[MR1],[MR],[PCV1],[PCV2],[PCVB]

---------------------------------------Shital 11 June 2019----------------------------

,[Rota1]
,Rota2
,[Rota3]
,[DPTB1]
,[DPTB2]
,[OPVB]
,[MEASLES2]
,[JE1]
,[JE2]
,[VITK]
-------------------------Shital 18112019----------------------------
,[IPV1]
,[IPV2]
,[VIT1] 
,[VIT2] 
,[VIT3]
,[VIT4] 
,[VIT5] 
,[VIT6] 
,[VIT7] 
,[VIT8] 
,[VIT9] 
)

SELECT  State_Code,isnull(PID,HealthFacility_Code),isnull(SID,0),[Year_ID],[Month_ID]
,SUM([Total_Birthdate]),SUM([BCG]),SUM([OPV0]),SUM([HEP0])
,SUM([DPT1]),SUM([OPV1]),SUM([HEP1]),SUM([PENTA1])
,SUM([DPT2]),SUM([OPV2]),SUM([HEP2]),SUM([PENTA2])
,SUM([DPT3]),SUM([OPV3]),SUM([HEP3]),SUM([PENTA3])
,SUM([Measles]),SUM([AllVac]),SUM([Dead_Child]),SUM([Delete_Child])
,GETDATE() ,[Fin_Yr]
,SUM(BCG_OPV0_HEP0),SUM(Received_All_Vac),SUM(BreastFed_6Months)
-----------------------------------------Jyoti 13 March 2019--------------------------
,SUM([MR1])
,SUM([MR])
,SUM([PCV1])
,SUM([PCV2])
,SUM([PCVB]) 

--------------------------Shital 11 June 2019------------------------------------------------

,SUM([Rota1])
,SUM([Rota2])
,SUM([Rota3])
,SUM([DPTB1])
,SUM([DPTB2])
,SUM([OPVB])
,SUM([MEASLES2])
,SUM(JE1)
,Sum(JE2)
,Sum(VITK)
-------------------------------Shital 18112019----------------------------
,Sum(IPV1)
,SUM(IPV2)
,SUM(VIT1)
,SUM(VIT2)
,SUM(VIT3)
,SUM(VIT4)
,SUM(VIT5)
,SUM(VIT6)
,SUM(VIT7)
,SUM(VIT8)
,SUM(VIT9)



FROM Scheduled_Tracking_CH_PHC_SubCenter_Village_Month a WITH (NOLOCK)
left outer join Health_SubCentre b WITH (NOLOCK) on a. [HealthSubFacility_Code]=b.SID
group by Year_ID,MONTH_ID,Fin_Yr,State_Code,isnull(PID,HealthFacility_Code),isnull(SID,0)
  
  


end

