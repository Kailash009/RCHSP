USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Estimates_Insert_Update]    Script Date: 09/26/2024 12:34:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[Estimates_Insert_Update]
(@StateID as int=0
,@District_ID as int=0
,@HealthBlock_Code int=0
,@Taluka_Code varchar(6)=null
,@HealthFacility_Code int=0
,@HealthSubFacility_Code int=0
,@ID int=0
,@Name as nvarchar(150)
,@EPW as int=0
,@EI as int=0
,@YearID as varchar(10)=null
,@msg varchar(200) out
)

as
begin

if(@StateID=0)
	begin

		if exists (select * from Estimated_Data_All_State where State_Code = @ID and  Yr=@YearID)
			begin

				update Estimated_Data_All_State set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end
else if(@StateID<>0 and @District_ID=0)
	begin

		if exists (select * from Estimated_Data_District_Wise where State_Code=@StateID and District_Code=@ID and Yr=@YearID)
			begin

				update Estimated_Data_District_Wise set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@StateID and District_Code=@ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end
else if(@StateID<>0 and @District_ID<>0 and @HealthBlock_Code=0 )
	begin

		if exists (select * from Estimated_Data_Block_Wise where  State_Code=@StateID and District_Code=@District_ID and HealthBlock_Code=@ID and Yr=@YearID)
			begin

				update Estimated_Data_Block_Wise set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@StateID and District_Code=@District_ID and HealthBlock_Code=@ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end
else if(@StateID<>0 and @District_ID<>0 and @HealthBlock_Code<>0 and @Taluka_Code = 0 )
	begin

		if exists (select * from Estimated_Data_Block_Wise where  State_Code=@StateID and District_Code=@District_ID and HealthBlock_Code=@ID and Yr=@YearID)
			begin

				update Estimated_Data_Block_Wise set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@StateID and District_Code=@District_ID and HealthBlock_Code=@ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end
else if(@StateID<>0 and @District_ID<>0 and @HealthBlock_Code<>0 and @Taluka_Code<>0 and @HealthFacility_Code=0)
	begin

		if exists (select * from Estimated_Data_PHC_Wise where  State_Code=@StateID and HealthFacility_Code = @ID and Yr=@YearID)
			begin

				update Estimated_Data_PHC_Wise set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@StateID and HealthFacility_Code = @ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end
	else if(@StateID<>0 and @District_ID<>0 and @HealthBlock_Code<>0 and @Taluka_Code<>0 and @HealthFacility_Code<>0 and @HealthSubFacility_Code = 0)
	begin

		if exists (select * from Estimated_Data_SubCenter_Wise where  State_Code=@StateID and HealthSubFacility_Code = @ID and Yr=@YearID)
			begin

				update Estimated_Data_SubCenter_Wise set Estimated_Mother=@EPW,Estimated_Infant=@EI where State_Code=@StateID and HealthSubFacility_Code = @ID and Yr=@YearID
				set @msg='Record Updated Successfully'
			end

	end     
       
End

