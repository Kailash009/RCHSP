USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Children_6m_3y_Poshan_IU]    Script Date: 09/26/2024 12:21:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROCEDURE [dbo].[tp_Children_6m_3y_Poshan_IU] 
@health_id VARCHAR(20) ,
@beneficiary_type varchar(50) =NULL,
@name varchar(100)= NULL,
@aadhar_number varchar(20)= NULL,
@dob date =NULL,
@gender char(1)= NULL,
@father_name varchar(100) =NULL,
@mother_name varchar(100) =NULL,
@mobile varchar(15) =NULL,
@decease varchar(50) =NULL,
@child_on_solid_food varchar(10)= NULL,
@folic_acid varchar(10)= NULL,
@iron varchar(10)= NULL,
@vitamins varchar(10)= NULL,
@calcium varchar(10) =NULL,
@calcium_level_mg varchar(10) =NULL,
@energy_intake_kcal varchar(10)= NULL,
@protien_intake_gm varchar(10)= NULL,
@fat_intake_gm varchar(10)= NULL,
@provided_thr varchar(10)= NULL,
@provided_thr_days INT= NULL,
@additional_food_supplement varchar(50)= NULL,
@hb INT =NULL,
@hb_test_date Date= NULL,
@health_service_allopath varchar(10) =NULL,
@health_service_homeopath varchar(10)= NULL,
@health_service_ayush varchar(10) =NULL,
@height FLOAT =NULL,
@weight  FLOAT =NULL,
@weight_capture_date Date= NULL,
@height_capture_date Date =NULL,
@health_status varchar(50) =NULL,
@stunted varchar(50) =NULL,
@underweight varchar(50)= NULL,
@status int = 0 OUT
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRAN
    BEGIN TRY
      IF NOT EXISTS (SELECT  1 FROM t_Children_6m_3y_Poshan  WHERE health_id = @health_id)
      BEGIN
        INSERT INTO t_Children_6m_3y_Poshan 
		(health_id, beneficiary_type, name, aadhar_number, dob, gender, father_name, mother_name, mobile, decease, 
		child_on_solid_food, folic_acid, iron, vitamins, calcium, calcium_level_mg, energy_intake_kcal, protien_intake_gm, 
		fat_intake_gm, provided_thr, provided_thr_days, additional_food_supplement, hb, hb_test_date, health_service_allopath, 
		health_service_homeopath, health_service_ayush, height, weight, weight_capture_date, height_capture_date, 
		health_status, stunted, underweight, created_on)
        VALUES 
	   (@health_id, @beneficiary_type, @name, @aadhar_number, @dob, @gender, @father_name, @mother_name, @mobile, @decease, 
	    @child_on_solid_food, @folic_acid, @iron, @vitamins, @calcium, @calcium_level_mg, @energy_intake_kcal, @protien_intake_gm, 
	    @fat_intake_gm, @provided_thr, @provided_thr_days, @additional_food_supplement, @hb, @hb_test_date, @health_service_allopath, 
	    @health_service_homeopath, @health_service_ayush, @height, @weight, @weight_capture_date, @height_capture_date, 
	    @health_status, @stunted, @underweight, getdate())

       SET @status = 1
      END
      ELSE
      BEGIN
        UPDATE t_Children_6m_3y_Poshan  SET 
		beneficiary_type=@beneficiary_type,
		name=@name, 
		aadhar_number=@aadhar_number, 
		dob=@dob,
		gender=@gender, 
		father_name=@father_name, 
		mother_name=@mother_name, 
		mobile=@mobile, 
		decease=@decease, 
	    child_on_solid_food=@child_on_solid_food, 
		folic_acid=@folic_acid, 
		iron=@iron, 
		vitamins=@vitamins, 
		calcium=@calcium, 
		calcium_level_mg=@calcium_level_mg, 
		energy_intake_kcal=@energy_intake_kcal, 
		protien_intake_gm=@protien_intake_gm, 
	    fat_intake_gm=@fat_intake_gm, 
		provided_thr=@provided_thr, 
		provided_thr_days=@provided_thr_days, 
		additional_food_supplement=@additional_food_supplement, 
		hb=@hb, 
		hb_test_date=@hb_test_date, 
		health_service_allopath=@health_service_allopath, 
	    health_service_homeopath=@health_service_homeopath, 
		health_service_ayush=@health_service_ayush, 
		height=@height, 
		weight=@weight, 
		weight_capture_date=@weight_capture_date, 
		height_capture_date=@height_capture_date, 
	    health_status=@health_status, 
		stunted=@stunted, 
		underweight=@underweight,
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
