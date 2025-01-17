USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[fill_ANM_ASHA]    Script Date: 09/26/2024 14:41:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
fill_ANM_ASHA_AWW_MPW
*/

ALTER proc [dbo].[fill_ANM_ASHA]
(
@SubCentre_ID int,
@PHC_ID int,
@Type_ID int
)
as
begin
	if(@SubCentre_ID >0)
	begin
		if(@Type_ID<>1)
		select ID,Name,lower(Name) as vName from t_Ground_Staff 
		where HealthSubFacility_Code=@SubCentre_ID and [TYPE_ID] not in (1,8,5) and Is_Active=1 order by Name
		else
		select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthSubFacility_Code=@SubCentre_ID and [TYPE_ID]=1 and Is_Active=1 order by Name
	end
	else
	begin
		if(@Type_ID<>1)
		select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and [TYPE_ID] not in (1,8,5) and Is_Active=1 order by Name
		else
		select ID,Name,lower(Name) as vName from t_Ground_Staff where HealthFacilty_Code=@PHC_ID and HealthSubFacility_Code=0 and [TYPE_ID]=1 and Is_Active=1 order by Name
	end
end





