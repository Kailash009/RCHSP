USE [RCH_28]
GO

/****** Object:  View [dbo].[Hierarchy]    Script Date: 09/26/2024 15:47:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
[Districtwise_rpt] 9
*/
ALTER View [dbo].[Hierarchy]
as 
Select a.DIST_CD,a.DIST_NAME_ENG,b.TAL_CD,b.TAL_NAME,c.BLOCK_CD,c.Block_Name_E,d.TALUKA_CD,e.Name_E as HBT_Taluka,f.PHC_CD,f.PHC_NAME
,g.SUBPHC_CD,g.SUBPHC_NAME_E,h.VILLAGE_CD,h.VILLAGE_NAME from TBL_DISTRICT a
left outer join TBL_TALUKA b on a.DIST_CD=b.DIST_CD
left outer join TBL_HEALTH_BLOCK c on b.TAL_CD=c.TALUKA_CD
left outer join TBL_HEALTH_BLOCK_Taluka d on c.BLOCK_CD=d.BLOCK_CD
left outer join TBL_TALUKA e on d.TALUKA_CD=e.TAL_CD
left outer join TBL_PHC f on d.BLOCK_CD=f.BID and d.TALUKA_CD=f.TAL_CD
left outer join TBL_SUBPHC g on f.PHC_CD=g.PHC_CD
left outer join TBL_VILLAGE h on g.SUBPHC_CD=h.SUBPHC_CD 
union
select c.DIST_CD,c.DIST_NAME_ENG,d.TAL_CD,d.TAL_NAME,0,null,'0',null,0,null,0,null,a.VCode,a.Name_E as VILLAGE_NAME from Village a
left outer join TBL_VILLAGE b on a.VCode=b.VILLAGE_CD
left outer join TBL_DISTRICT c on a.DCode=c.DIST_CD
left outer join TBL_TALUKA d on a.TCode=d.TAL_CD
where b.VILLAGE_CD is null

GO


