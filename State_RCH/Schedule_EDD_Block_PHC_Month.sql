USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_EDD_Block_PHC_Month]    Script Date: 09/26/2024 14:44:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[Schedule_EDD_Block_PHC_Month]
as
begin
truncate table [Scheduled_EDD_Block_PHC_Month]
insert into [Scheduled_EDD_Block_PHC_Month]([State_Code],[HealthBlock_Code],[HealthFacility_Code]
,[Total_Due],[Delivered],[Total_HighRisk],[Delivered_Highrisk],[Total_SevereAnaemic],[Delivered_SevereAnaemic]
,[Total_Abortion],[Not_Delivery],Total_4PNC_Received,Delivery_Institutional
,[Month_ID],[Year_ID],[Fin_Yr])
SELECT [State_Code],BID,[HealthFacility_Code]
,SUM([Total_Due]),SUM([Delivered]),SUM([Total_HighRisk]),SUM([Delivered_Highrisk]),SUM([Total_SevereAnaemic]),SUM([Delivered_SevereAnaemic])
,SUM([Total_Abortion]),SUM([Not_Delivery]),SUM(Total_4PNC_Received),SUM(Delivery_Institutional)
,[Month_ID]      ,[Year_ID],Fin_Yr
FROM [Scheduled_EDD_PHC_SubCenter_Village_Month] a
inner join Health_PHC  b on a.[HealthFacility_Code]=b.pid
group by [State_Code],BID,[HealthFacility_Code],[Year_ID],[Month_ID],Fin_Yr
end


