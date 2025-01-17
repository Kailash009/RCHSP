USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[fill_SubCentre_DirectDataEntry]    Script Date: 09/26/2024 12:00:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
fill_SubCentre_DirectDataEntry 32155
*/
ALTER PROC [dbo].[fill_SubCentre_DirectDataEntry]
(
@Village_Code int
)
as
begin
	select  f.Name_E as District_Name,f.DCode as District_Code,
			d.Name_E as HealthBlock_Name,d.BID as HealthBlock_Code,
			e.Name_E as Taluka_Name,e.TCode as Taluka_Code,
			c.Name_E as Healthfacility_Name,c.PID as Healthfacility_Code,
			b.Name_E as HealthSubfacility_Name,a.[SID] as HealthSubfacility_Code
	 from Health_SC_Village a
	inner join Health_SubCentre b on a.SID=b.SID
	inner join Health_PHC c on b.PID=c.PID
	inner join Health_Block d on c.BID=d.BID
	inner join All_Taluka e on d.TCode=e.TCode and c.TCode=e.TCode and b.TCode=e.TCode
	inner join District f on b.DCode=f.DCode	
	where VCode=@Village_Code
end





