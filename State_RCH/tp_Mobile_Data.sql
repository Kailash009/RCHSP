USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Mobile_Data]    Script Date: 09/26/2024 14:49:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[tp_Mobile_Data]
(
@State_Code int=27,
@District_Code int=21,
@Rural_Urban char(1)='R',
@HealthBlock_Code int=162,
@Taluka_Code varchar(6)='0221',
@HealthFacility_Type int=99,
@HealthFacility_Code int=897,
@HealthSubFacility_Code int=5552,
@Village_Code int=27911,
@Financial_Yr varchar(7)='2013-14',
@Financial_Year smallint=2013,
@Registration_no bigint out,
@ID_No varchar(18)=null,
@Register_srno int=0,
@Name_wife nvarchar(99),
@Name_husband nvarchar(99),
@Whose_mobile char(1)='W',
@Landline_no nvarchar(10)=NULL,
@Mobile_no nvarchar(10),
@Date_regis Date,
@Wife_current_age tinyint=0,
@Wife_marry_age tinyint=0,
@Hus_current_age tinyint=0,
@Hus_marry_age tinyint=0,
@Aadhar_No numeric(12)=null,
@EID numeric(14)=null,
@EIDT datetime=null,
@Address nvarchar(150),
@Religion_code int,
@Caste tinyint,               
@Identity_type tinyint,
@Identity_number varchar(20),
@Male_child_born tinyint,
@Female_child_born tinyint,
@Male_child_live tinyint,
@Female_child_live tinyint,
@Young_child_gender char(1),
@Young_child_age_month tinyint,  
@Young_child_age_year tinyint,   
@Infertility_status char(1),
@Infertility_refer nvarchar(100),
--@Status_code char(1)='I',
--@SubStatus_code char(1)='A',
@ANM_ID int,
@ASHA_ID int=0,
@IP_address varchar(25),
@Created_By int=0,
@BPL_APL tinyint,
@Hus_Aadhar_No numeric(12)=null
)

as
BEGIN
SET NOCOUNT ON
if not exists(select Registration_no from t_eligibleCouples where State_Code=@State_Code
			and District_Code=@District_Code
			and Rural_Urban=@Rural_Urban
			and	HealthBlock_Code=@HealthBlock_Code
			and Taluka_Code=@Taluka_Code
			and HealthFacility_Type=@HealthFacility_Type
			and HealthFacility_Code=@HealthFacility_Code
			and HealthSubFacility_Code=@HealthSubFacility_Code
			and Village_Code=@Village_Code
			and Registration_no=@Registration_no)
		BEGIN
		
			
			declare @id int, @R_No varchar(12)
			SELECT @id = isnull(Id_M,0) + 1 from m_lastId
			SELECT @R_No =   left(replicate('0',2),2-len(@State_Code))+cast(@State_Code as varchar(2)) + left(replicate('0',9),9-len(@id))+cast(@id as varchar(9))
			set @Registration_no = CAST(@R_No as bigint)
			
			   insert into t_eligibleCouples
				(State_Code
				,District_Code
				,Rural_Urban
				,HealthBlock_Code
				,Taluka_Code
				,HealthFacility_Type
				,HealthFacility_Code
				,HealthSubFacility_Code
				,Village_Code
				,Financial_Yr
				,Financial_Year
				,Registration_no
				,ID_No
				,Register_srno
				,Name_wife
				,Name_husband
				,Whose_mobile
				,Landline_no
				,Mobile_no
				,Date_regis
				,Wife_current_age
				,Wife_marry_age
				,Hus_current_age
				,Hus_marry_age
				,Aadhar_No
				,EID
				,EIDT
				,Address
				,Religion_code
				,Caste
				,Identity_type
				,Identity_number
				,Male_child_born
				,Female_child_born
				,Male_child_live
				,Female_child_live
				,Young_child_gender
				,Young_child_age_month
				,Young_child_age_year
				,Infertility_status
				,Infertility_refer
				,Pregnant
				,Pregnant_test
				,ANM_ID
				,ASHA_ID
				,Case_no
				,Flag
				,IP_address
				,Created_By
				,Created_On
				,BPL_APL
				,HusbandAadhaar_no)
				values
				(@State_Code
				,@District_Code
				,@Rural_Urban
				,@HealthBlock_Code
				,@Taluka_Code
				,@HealthFacility_Type
				,@HealthFacility_Code
				,@HealthSubFacility_Code
				,@Village_Code
				,@Financial_Yr
				,@Financial_Year
				,@Registration_no
				,@ID_No
				,@Register_srno
				,@Name_wife
				,@Name_husband
				,@Whose_mobile
				,@Landline_no
				,@Mobile_no
				,CONVERT(DATE,GETDATE())
				,@Wife_current_age
				,@Wife_marry_age
				,@Hus_current_age
				,@Hus_marry_age
				,@Aadhar_No
				,@EID
				,@EIDT
				,@Address
				,@Religion_code
				,@Caste
				,@Identity_type
				,@Identity_number
				,@Male_child_born
				,@Female_child_born
				,@Male_child_live
				,@Female_child_live
				,@Young_child_gender
				,@Young_child_age_month
				,@Young_child_age_year
				,@Infertility_status
				,@Infertility_refer
				,'N'
				,'D'
				,@ANM_ID
				,@ASHA_ID
				,1
				,0
				,@IP_address
				,@Created_By
				,GETDATE()
				,@BPL_APL
				,@Hus_Aadhar_No)
					
		
	  END
else
	BEGIN
		
				update t_eligibleCouples 
					set State_Code=@State_Code,
					District_Code=@District_Code,
					Rural_Urban=@Rural_Urban,
					HealthBlock_Code=@HealthBlock_Code,
					Taluka_Code=@Taluka_Code,
					HealthFacility_Type=@HealthFacility_Type,
					HealthFacility_Code=@HealthFacility_Code,
					HealthSubFacility_Code=@HealthSubFacility_Code,
					Village_Code=@Village_Code,
					Financial_Yr=@Financial_Yr,
					Financial_Year=@Financial_Year,
					Register_srno=@Register_srno,
					Name_wife=@Name_wife,
					Name_husband=@Name_husband,
					Whose_mobile=@Whose_mobile,
					Landline_no=@Landline_no,
					Mobile_no=@Mobile_no,
					Date_regis=CONVERT(DATE,GETDATE()),
					Wife_current_age=@Wife_current_age,
					Wife_marry_age=@Wife_marry_age,
					Hus_current_age=@Hus_current_age,
					Hus_marry_age=@Hus_marry_age,
					Aadhar_No=@Aadhar_No,
					EID=@EID,
					EIDT=@EIDT,
					Address=@Address,
					Religion_code=@Religion_code,
					Caste=@Caste,
					Identity_type=@Identity_type,
					Identity_number=@Identity_number,
					Male_child_born=@Male_child_born,
					Female_child_born=@Female_child_born,
					Male_child_live=@Male_child_live,
					Female_child_live=@Female_child_live,
					Young_child_gender=@Young_child_gender,
					Young_child_age_month=@Young_child_age_month,
					Young_child_age_year=@Young_child_age_year,
					Infertility_status=@Infertility_status,
					Infertility_refer=@Infertility_refer,
					Pregnant='N',
			        Pregnant_test='D',
					ANM_ID=@ANM_ID,
					ASHA_ID=@ASHA_ID,
					Flag = 0,
					IP_address=@IP_address,
					Created_By=@Created_By,
					Created_On=GETDATE(),
					BPL_APL=@BPL_APL,
					HusbandAadhaar_no=@Hus_Aadhar_No
				WHERE State_Code=@State_Code
					and District_Code=@District_Code
					and Rural_Urban=@Rural_Urban
					and	HealthBlock_Code=@HealthBlock_Code
					and Taluka_Code=@Taluka_Code
					and HealthFacility_Type=@HealthFacility_Type
					and HealthFacility_Code=@HealthFacility_Code
					and HealthSubFacility_Code=@HealthSubFacility_Code
					and Village_Code=@Village_Code
					and Registration_no=@Registration_no 
			end
		
END
