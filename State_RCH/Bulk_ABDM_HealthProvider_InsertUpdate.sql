USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[Bulk_ABDM_HealthProvider_InsertUpdate]    Script Date: 09/26/2024 14:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[Bulk_ABDM_HealthProvider_InsertUpdate]                  
(                  
@Identifier as int=0,
@HPR_Id as varchar(17),
@HPR_category as varchar(20)='',
@Registered_HPR_category as varchar(99)='',
@HPR_name as varchar(99),
@Mobile_Number as varchar(10)='',
@Gender as varchar(10)='',
@Active as bit=null,
@Email as varchar(99)='',
@AddressLine1 as varchar(200)='',
@AddressLine2 as varchar(200)='',
@State_Name as varchar(99)='',
@State_code as int=0,
@District_name as varchar(99)='',
@District_code as int=0,
@City_name as varchar(99)='',
@City_code as int=0,
@application_status as varchar(20)='',
@is_council_verified as varchar(20)='',
@is_work_verified as varchar(20)='',
@CouncilName as varchar(200)='',
@RegisteredAt as varchar(99)='',
@RegistrationNumber as varchar(20)='',
@RegistrationDate as date=null,
@Created_by as int,
@msg nvarchar(200) out                      
)                  
AS                  
BEGIN                  
SET NOCOUNT ON  

 SET @msg='';                  

IF NOT EXISTS(SELECT HPR_Id FROM HPR_ABDM_tbl WHERE  HPR_Id=@HPR_Id)                  
BEGIN                  
 begin transaction        
  INSERT INTO HPR_ABDM_tbl                   
   (                  
      Identifier,HPR_Id,HPR_category,Registered_HPR_category,HPR_name,Mobile_Number,Gender,Active,Email,AddressLine1,AddressLine2
	,State_Name,State_code,District_name,District_code,City_name,City_code,application_status,is_council_verified,is_work_verified
	,CouncilName,RegisteredAt,RegistrationNumber,RegistrationDate,Created_on,Created_by) 
                 
 values(@Identifier,@HPR_Id,@HPR_category,@Registered_HPR_category,@HPR_name,@Mobile_Number,@Gender,@Active,@Email,@AddressLine1,@AddressLine2
	,@State_Name,@State_code,@District_name,@District_code,@City_name,@City_code,@application_status,@is_council_verified,@is_work_verified
	,@CouncilName,@RegisteredAt,@RegistrationNumber,@RegistrationDate,GETDATE(),@Created_by)                                       
     SET @msg='Record Saved Successfuly !!!'                  
	commit transaction                     
END
ELSE                 
 BEGIN          
  UPDATE HPR_ABDM_tbl SET                  
    Identifier=@Identifier,
    HPR_category=@HPR_category,
    Registered_HPR_category=@Registered_HPR_category,
    HPR_name=@HPR_name,
    Mobile_Number=@Mobile_Number,
    Gender=@Gender,
    Active=@Active,
    Email=@Email,
    AddressLine1=@AddressLine1,
    AddressLine2=@AddressLine2,
	State_Name=@State_Name,
	State_code=@State_code,
	District_name=@District_name,
	District_code=@District_code,
	City_name=@City_name,
	City_code=@City_code,
	application_status=@application_status,
	is_council_verified=@is_council_verified,
	is_work_verified=@is_work_verified,
	CouncilName=@CouncilName,
	RegisteredAt=@RegisteredAt,
	RegistrationNumber=@RegistrationNumber,
	RegistrationDate=@RegistrationDate,
	Updated_on=GETDATE(),
	Updated_by=@Created_by
    WHERE  HPR_Id=@HPR_Id
	  
    SET @msg = 'Record Update Successfully !!!'                  
 END   
END                      
                  
IF (@@ERROR <> 0)                  
BEGIN                  
     RAISERROR ('TRANSACTION FAILED',16,-1)                  
     ROLLBACK TRANSACTION                  
END    
