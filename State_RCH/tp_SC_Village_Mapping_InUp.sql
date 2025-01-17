USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_SC_Village_Mapping_InUp]    Script Date: 09/26/2024 14:51:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[tp_SC_Village_Mapping_InUp]
(
@SubCentreID as int=0,
@VillageID as int=0,
@UserID as int=0,
@Msg as varchar(200)=null out
)
as
Begin

if(@SubCentreID=0 or @VillageID=0)
begin

set @Msg='Cannot Map 0 subcentre with 0 village'
return
end
else if exists (Select * from Health_SC_Village where SID=@SubCentreID and VCode=@VillageID )
begin

update Health_SC_Village set Modified_By=@UserID,Modified_On=GETDATE() where SID=@SubCentreID and VCode=@VillageID
set @Msg='Mapping already Exists'
return
end
else
begin
insert into Health_SC_Village(SID,VCode ,Created_By ,Created_on,IsActive)
values (@SubCentreID,@VillageID,@UserID,GETDATE(),1)
set @Msg='Saved Successfully'
return
end


End


