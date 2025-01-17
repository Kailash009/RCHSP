USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[tp_CBR_registration_Insert]    Script Date: 09/26/2024 14:08:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[tp_CBR_registration_Insert]
           @State_Name  varchar(50)  = '' ,
            @State_Code  int  = 0 ,
            @District_Name  varchar(50)  = '' ,
            @District_Code  int  = 0 ,
            @Subdistrict_Name  varchar(50)  = '' ,
            @Subdistrict_Code  varchar(6)  = '' ,
            @Healthblock_Name  varchar(50)  = '' ,
            @Healthblock_Code  int  = 0,
            @Ulb_Name  varchar(50)  = '' ,
            @Ulb_Code  int  = 0 ,
            @Uwin_Facility_Id  int  = 0 ,
            @Facility_Name  varchar(50)  = '' ,
            @Facilityhfr_Id  varchar(12)  = '' ,
            @sub_center_id  int  = 0 ,
            @Sub_Facility_Hfr_Id  varchar(12)  = '' ,
            @Sub_Facility_Hfr_Name  varchar(50)  = '' ,
            @Village_Name  varchar(50)  = '' ,
            @Village_Code  int  = 0 ,
            @hpr_id  varchar(17)  = '' ,
            @Ben_Name  nvarchar(99)  = '' ,
            @Ben_Mobile_Number  varchar(10)  = '' ,
            @Reference_Id  bigint  = 0 OUT,
            @Request_ID  varchar(100)  = '' ,
            @Ben_DoB  date  = '1900-01-01' ,
            @Ben_YoB  int  = 0 ,
            @Beneficiary_Gender  varchar(10)  = '' ,
            @Ben_type  varchar(10)  = '' ,
            @DoR  datetime  = '1900-01-01' ,
            @ABHA_Number  varchar(20)  = '' ,
            @ABHA_Address  varchar(75)  = '' ,
            @Is_Pregnant_Woman  bit  = 0 ,
            @lmp_Date  date  = NULL ,
            @Relation_with_guardian  varchar(30)  = '' ,
            @Guardian_Name  nvarchar(99)  = '' ,
            @Guradian_Reference_Id  bigint  = 0 ,
            @Guradian_ABHA_Number  varchar(20)  = '' ,
            @Guradian_ABHA_Address  varchar(75)  = '' ,
            @Ben_Weight  int  = 0 ,
            @Blood_Group  varchar(7)  = '' ,
            @Ben_Secret_Key  nvarchar(100)  = '' ,
            @Registration_no  bigint  = 0 ,
            @Photo_Id_Type  varchar(30)  = '' ,
            @Photo_Id_Number  varchar(30)  = '' ,
            @Created_on  datetime  = '1900-01-01' ,
            @Created_by  int  = 0, 
            @msg nvarchar(200) ='' out
AS
BEGIN

  IF NOT EXISTS(SELECT 1 FROM CBR_registration where Reference_Id=@reference_id)
    BEGIN
	  INSERT INTO [CBR_registration]
           ([State_Name]
           ,[State_Code]
           ,[District_Name]
           ,[District_Code]
           ,[Subdistrict_Name]
           ,[Subdistrict_Code]
           ,[Healthblock_Name]
           ,[Healthblock_Code]
           ,[Ulb_Name]
           ,[Ulb_Code]
           ,[Uwin_Facility_Id]
           ,[Facility_Name]
           ,[Facilityhfr_Id]
           ,[sub_center_id]
           ,[Sub_Facility_Hfr_Id]
           ,[Sub_Facility_Hfr_Name]
           ,[Village_Name]
           ,[Village_Code]
           ,[hpr_id]
           ,[Ben_Name]
           ,[Ben_Mobile_Number]
           ,[Reference_Id]
           ,[Request_ID]
           ,[Ben_DoB]
           ,[Ben_YoB]
           ,[Beneficiary_Gender]
           ,[Ben_type]
           ,[DoR]
           ,[ABHA_Number]
           ,[ABHA_Address]
           ,[Is_Pregnant_Woman]
           ,[lmp_Date]
           ,[Relation_with_guardian]
           ,[Guardian_Name]
           ,[Guradian_Reference_Id]
           ,[Guradian_ABHA_Number]
           ,[Guradian_ABHA_Address]
           ,[Ben_Weight]
           ,[Blood_Group]
           ,[Ben_Secret_Key]
           ,[Registration_no]
           ,[Photo_Id_Type]
           ,[Photo_Id_Number]
           ,[Created_on]
           ,[Created_by]
          )
	   VALUES
	   (
	        @State_Name  ,
            @State_Code  ,
            @District_Name  ,
            @District_Code   ,
            @Subdistrict_Name  ,
            @Subdistrict_Code ,
            @Healthblock_Name ,
            @Healthblock_Code   ,
            @Ulb_Name  ,
            @Ulb_Code  ,
            @Uwin_Facility_Id   ,
            @Facility_Name ,
            @Facilityhfr_Id  ,
            @sub_center_id   ,
            @Sub_Facility_Hfr_Id  ,
            @Sub_Facility_Hfr_Name   ,
            @Village_Name   ,
            @Village_Code ,
            @hpr_id  ,
            @Ben_Name  ,
            @Ben_Mobile_Number ,
            @Reference_Id ,
            @Request_ID   ,
            @Ben_DoB  ,
            @Ben_YoB ,
            @Beneficiary_Gender   ,
            @Ben_type  ,
            @DoR ,
            @ABHA_Number  ,
            @ABHA_Address  ,
            @Is_Pregnant_Woman   ,
            @lmp_Date  ,
            @Relation_with_guardian  ,
            @Guardian_Name ,
            @Guradian_Reference_Id  ,
            @Guradian_ABHA_Number   ,
            @Guradian_ABHA_Address  ,
            @Ben_Weight  ,
            @Blood_Group  ,
            @Ben_Secret_Key   ,
            @Registration_no  ,
            @Photo_Id_Type   ,
            @Photo_Id_Number  ,
            @Created_on   ,
            @Created_by 
	   )
	   SET @msg='1'
	      RETURN;         
	END
  ELSE
    BEGIN
	  SET @msg='2'
	     RETURN ;
	END
END
 
