USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_ReRegistration_RegDate_Update]    Script Date: 09/26/2024 14:51:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*

*/
ALTER proc [dbo].[tp_ReRegistration_RegDate_Update]
(
@Registration_no bigint,
@Date_regis Date,
@IP_address varchar(25),
@Created_By int,
@msg nvarchar(200) out
)

as
BEGIN
SET NOCOUNT ON
set @msg='';
if exists(select Registration_no from t_temp where Registration_no=@Registration_no )
	BEGIN
		update t_eligibleCouples set 
						Date_regis=@Date_regis,
						IP_address=@IP_address,
						Updated_By=@Created_By,
						Updated_On=(case when (Created_On=Convert(date,GETDATE())) then null else CONVERT(date,GETDATE()) end)
		WHERE Registration_no=@Registration_no 
		set @msg = 'Registration date updated Successfully !!!'
		RETURN
	END
else
	BEGIN
		set @msg = 'Registration date not updated !!!'
		RETURN
	END

RETURN
END

IF (@@ERROR <> 0)
BEGIN
     RAISERROR ('TRANSACTION FAILED',16,-1)
     ROLLBACK TRANSACTION
END




