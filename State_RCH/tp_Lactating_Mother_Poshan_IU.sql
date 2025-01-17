USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Lactating_Mother_Poshan_IU]    Script Date: 09/26/2024 14:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[tp_Lactating_Mother_Poshan_IU] 
@health_id varchar(20),
@beneficiary_type varchar(50) =NULL,
@name varchar(100) =NULL,
@husband_name varchar(100) =NULL,
@dob date =NULL,
@aadhar_number varchar(20) =NULL,
@mobile varchar(15)= NULL,
@delivery_date Date =null,
@infant_gender char(1)= null,
@decease varchar(50)=NULL,
@infant_birth_height FLOAT =NULL,
@infant_birth_weight FLOAT =NULL,
@delivery_time_breast_fed varchar(10)= NULL,
@exclusively_breast_fed varchar(10)= NULL,
@height FLOAT =NULL,
@weight  FLOAT= NULL,
@weight_capture_date Date =NULL,
@height_capture_date Date =NULL,
@hb INT= NULL,
@hb_test_date Date =NULL,
@menstrual_cycle varchar(10)= NULL,
@folic_acid varchar(10)= NULL,
@iron varchar(10)= NULL,
@vitamins varchar(10)= NULL,
@calcium varchar(10)= NULL,
@provided_thr varchar(10) =NULL,
@provided_thr_days INT =NULL,
@health_service_allopath varchar(10) =NULL,
@health_service_homeopath varchar(10)= NULL,
@health_service_ayush varchar(10) =NULL,
@health_status varchar(50) =NULL,
@stunted varchar(50)= NULL,
@underweight varchar(50)= NULL,
@status int = 0 OUT
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRAN
    BEGIN TRY
      IF NOT EXISTS (SELECT  1 FROM t_Lactating_Mother_Poshan  WHERE health_id = @health_id)
      BEGIN
        INSERT INTO t_Lactating_Mother_Poshan 
		(health_id, beneficiary_type, name, husband_name, dob, aadhar_number, mobile, delivery_date, infant_gender, decease, infant_birth_height, 
		infant_birth_weight, delivery_time_breast_fed, exclusively_breast_fed, height, weight, weight_capture_date, height_capture_date, hb, hb_test_date, 
		menstrual_cycle, folic_acid, iron, vitamins, calcium, provided_thr, provided_thr_days, health_service_allopath, health_service_homeopath, 
		health_service_ayush, health_status, stunted, underweight, created_on)
        VALUES 
	   (@health_id, @beneficiary_type, @name, @husband_name, @dob, @aadhar_number, @mobile, @delivery_date, @infant_gender, @decease, @infant_birth_height, 
	   @infant_birth_weight, @delivery_time_breast_fed, @exclusively_breast_fed, @height, @weight, @weight_capture_date, @height_capture_date, @hb, @hb_test_date, 
	   @menstrual_cycle, @folic_acid, @iron, @vitamins, @calcium, @provided_thr, @provided_thr_days, @health_service_allopath, @health_service_homeopath, 
	   @health_service_ayush, @health_status, @stunted, @underweight, GETDATE())

       SET @status = 1
      END
      ELSE
      BEGIN
        UPDATE t_Lactating_Mother_Poshan
        SET beneficiary_type=@beneficiary_type, 
		name=@name, 
		husband_name=@husband_name, 
		dob=@dob, 
		aadhar_number=@aadhar_number, 
		mobile=@mobile, 
		delivery_date=@delivery_date, 
		infant_gender=@infant_gender, 
		decease=@decease, 
		infant_birth_height=@infant_birth_height, 
		infant_birth_weight=@infant_birth_weight, 
		delivery_time_breast_fed=@delivery_time_breast_fed, 
		exclusively_breast_fed=@exclusively_breast_fed, 
		height=@height, 
		weight=@weight, 
		weight_capture_date=@weight_capture_date, 
		height_capture_date=@height_capture_date, 
		hb=@hb,
		hb_test_date=@hb_test_date, 
		menstrual_cycle = @menstrual_cycle,
        folic_acid = @folic_acid,
        iron = @iron,
        vitamins = @vitamins,
        calcium = @calcium,
        provided_thr = @provided_thr,
        provided_thr_days = @provided_thr_days,
        health_service_allopath = @health_service_allopath,
        health_service_homeopath = @health_service_homeopath,
        health_service_ayush = @health_service_ayush,
        health_status = @health_status,
        stunted = @stunted,
        underweight = @underweight,
        updated_on = GETDATE()
        WHERE health_id = @health_id

        SET @status = 1
      END
    COMMIT TRAN
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
      ROLLBACK TRAN
    END
  END CATCH
END
