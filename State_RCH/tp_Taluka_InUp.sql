USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Taluka_InUp]    Script Date: 09/26/2024 14:52:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER Procedure [dbo].[tp_Taluka_InUp]
(
@Taluka_ID as nvarchar(6)='0'
,@District_ID as int=0
,@Taluka_NameEng as nvarchar(50)
,@Taluka_NameReg as nvarchar(50)
,@UserID as  int=0
,@msg as varchar(100) out
)

as
begin

if exists (select * from All_Taluka where TCode=@Taluka_ID)
begin

	update All_Taluka set Name_E=@Taluka_NameEng,Name_G=@Taluka_NameReg,Modified_on=GETDATE(),Modified_By=@UserID where TCode=@Taluka_ID
	set @msg='Updated Successfully'

end
else
Begin
	if exists( select * from All_Taluka where Soundex(Name_E)=Soundex(@Taluka_NameEng))
	begin
		set @msg='Taluka of this name already Exists'
	
	
	end
	else
	Begin
		insert into All_Taluka(TCode,DCode,Name_E,Name_G,Created_On,Created_By,IsNew,IsActive)
		values(@Taluka_ID,@District_ID,@Taluka_NameEng,@Taluka_NameReg,GETDATE(),@UserID,1,1)
		set @msg='Saved Successfully'
	
	end



End



End





