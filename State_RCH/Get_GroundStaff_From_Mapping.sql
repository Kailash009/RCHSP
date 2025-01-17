USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Get_GroundStaff_From_Mapping]    Script Date: 09/26/2024 12:00:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER Procedure [dbo].[Get_GroundStaff_From_Mapping]
(@District_Code int=0,
@HealthBlock_Code int=0,
@HealthFacility_Code as int=0,
@HealthSubFacility_Code as int=0,
@Village_Code as int=0,
@TypeID as int,
@Migration_Type as int=0,
@ID as int=0,
@msg nvarchar(100))
as

begin
if(@TypeID=1) -- ANM
begin

if(@Migration_Type=11 or @Migration_Type=12 or @Migration_Type=22)--Transfer case(F)
begin
	select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
	inner join t_Ground_Staff g on v.ID=g.ID
	where (v.District_Code=@District_Code )
	and (v.HealthBlock_Code=@HealthBlock_Code )
	and (v.HealthFacilty_Code=@HealthFacility_Code )
	and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
	and (v.Village_Code=@Village_Code or @Village_Code=0)
	and v.[TYPE_ID]<>1 and v.Isactual=1 and v.Is_Active=1 and v.Islinked=0 and v.Is_Mapped=1
End
else if (@Migration_Type=13 or @Migration_Type=14 or @Migration_Type=15 or @Migration_Type=16 or @Migration_Type=17 or @Migration_Type=199 or @Migration_Type=110)--Deactivation From
Begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]<>1 and v.Isactual=1 and v.Is_Active=1 and v.Islinked=0 and v.Is_USSD_Flagged=0  and v.Is_Mapped=1
End
else if(@Migration_Type=18)--Link(From)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]<>1 and v.Isactual=1 and v.Is_Active=1  and v.Is_Mapped=1

end
else If(@Migration_Type=10)--delink(From)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]<>1 and v.Isactual=0 and v.Is_Active=1 and v.Islinked=1 and v.Is_Mapped=1

end
else If(@Migration_Type=210)--Merge(To)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]<>1 and v.Isactual=1 and v.Is_Active=1 and v.Is_Mapped=1

end
else
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]<>1 and v.ID<>@ID and v.Is_Active=1  and v.Is_Mapped=1
end
end

else
begin
if(@Migration_Type=11 or @Migration_Type=12or @Migration_Type=22)--Transfer case(F)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.Isactual=1 and v.Is_Active=1 and v.Islinked=0 and v.Is_Mapped=1
End
else if (@Migration_Type=13 or @Migration_Type=14 or @Migration_Type=15 or @Migration_Type=16 or @Migration_Type=17 or @Migration_Type=199 or @Migration_Type=110)--Deactivation From
Begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.Isactual=1 and v.Is_Active=1 and v.Islinked=0 and v.Is_USSD_Flagged=0 and v.Is_Mapped=1

End
else if(@Migration_Type=18)--Link(From)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.Isactual=1 and v.Is_Active=1 and v.Is_Mapped=1

end
else If(@Migration_Type=10)--delink(From)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.Isactual=0 and v.Is_Active=1 and v.Islinked=1 and v.Is_Mapped=1

end
else If(@Migration_Type=210)--Merge(To)
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.Isactual=1 and v.Is_Active=1 and v.Is_Mapped=1

end
else
begin
select v.ID,Name+'-('+CAST(v.ID as varchar(10))+')' as Name from t_Ground_Staff_Mapping v
inner join t_Ground_Staff g on v.ID=g.ID
where (v.District_Code=@District_Code )
and (v.HealthBlock_Code=@HealthBlock_Code )
and (v.HealthFacilty_Code=@HealthFacility_Code )
and (v.HealthSubFacility_Code=@HealthSubFacility_Code)
and (v.Village_Code=@Village_Code or @Village_Code=0)
and v.[TYPE_ID]=1 and v.ID<>@ID and v.Is_Active=1 and v.Is_Mapped=1

end
end

end


