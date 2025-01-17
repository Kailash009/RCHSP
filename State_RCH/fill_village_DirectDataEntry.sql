USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[fill_village_DirectDataEntry]    Script Date: 09/26/2024 14:41:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
fill_village_DirectDataEntry 69
*/
ALTER proc [dbo].[fill_village_DirectDataEntry]
(
@District_Code int
)
as
begin
	select a.VILLAGE_CD as ID,VILLAGE_NAME as Name from TBL_VILLAGE a
	inner join Village b on a.VILLAGE_CD=b.Vcode
	where DIST_CD=@District_Code and b.Village_Type=1
	order by a.VILLAGE_NAME
end





