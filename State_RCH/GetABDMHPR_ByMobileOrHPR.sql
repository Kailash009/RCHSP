USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[GetABDMHPR_ByMobileOrHPR]    Script Date: 09/26/2024 14:08:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
GetABDMHPR_ByMobile '20-8742-6262-6538',''
GetABDMHPR_ByMobileOrHPR '','9766891346'
*/

--SELECT * FROM HPR_ABDM_tbl WHERE HPR_Id='20-8742-6262-6538'

ALTER PROCEDURE [dbo].[GetABDMHPR_ByMobileOrHPR] --GetABDMHPR_ByMobile     
 @HPR_ID varchar(17),
 @mobileNo varchar(10)=null
AS    
BEGIN  
 
	IF(@mobileNo is not null AND @mobileNo <>'')
	BEGIN
	SELECT b.HPRID,b.Match_Score,b.Is_HPRvalidated,Identifier,HPR_Id,HPR_category,Registered_HPR_category,HPR_name as Name,Mobile_Number as mobileNumber,Gender,Active,Email,AddressLine1,AddressLine2
	,State_Name as state,a.State_code,District_name as district,a.District_code,City_name,City_code,application_status,is_council_verified,is_work_verified
	,CouncilName,RegisteredAt,RegistrationNumber,RegistrationDate
	FROM HPR_ABDM_tbl a
	left outer join All_Ground_Staff b on a.HPR_Id=b.HPRID
	WHERE a.Mobile_Number=@mobileNo
	--and application_status='Verified' --and HPR_category='nurse'
	
	END
	ELSE IF(@HPR_ID is not null AND @HPR_ID<>'')
	BEGIN
	SELECT b.HPRID,b.Match_Score,b.Is_HPRvalidated,Identifier,HPR_Id,HPR_category,Registered_HPR_category,HPR_name as Name,Mobile_Number as mobileNumber,Gender,Active,Email,AddressLine1,AddressLine2
	,State_Name as state,a.State_code,District_name as district,a.District_code,City_name,City_code,application_status,is_council_verified,is_work_verified
	,CouncilName,RegisteredAt,RegistrationNumber,RegistrationDate
	FROM HPR_ABDM_tbl a
	left outer join All_Ground_Staff b on a.HPR_Id=b.HPRID
	WHERE a.HPR_Id=@HPR_ID
	--and application_status='Verified' --and HPR_category='nurse'
	END
END