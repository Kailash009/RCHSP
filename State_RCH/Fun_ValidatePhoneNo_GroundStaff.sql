USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_ValidatePhoneNo_GroundStaff]    Script Date: 09/26/2024 12:44:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
    select dbo.Fun_ValidatePhoneNo_GroundStaff(Mobile_No),Registration_no,Mobile_No from t_mother_registration
*/
ALTER FUNCTION [dbo].[Fun_ValidatePhoneNo_GroundStaff] 
(   
    @PhoneNo varchar(50) 
)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT
    DECLARE @I BIGINT
    DECLARE @PHONE_LENGTH INT
    DECLARE @PhoneNo_int varchar(50)
        
   SET @RESULT = 0
    -- remove leading zeros
   --SET @PhoneNo=REPLACE(@PhoneNo,' ', '')
   --SET @PhoneNo=REPLACE(LTRIM(REPLACE(RTRIM(@PhoneNo), '0', ' ')), ' ', '0') 

    SET  @PHONE_LENGTH=ISNULL(len(@PhoneNo),0)
    
    if(@PHONE_LENGTH = 11)
    begin
    set @PhoneNo=Substring(@PhoneNo,2,11)
     SET @PHONE_LENGTH=ISNULL(len(@PhoneNo),0)
    End
    
    
    if(@PHONE_LENGTH < 10 OR @PhoneNo=replicate(left(@PhoneNo,1),len(@PhoneNo)) or @PhoneNo like '[0-5]%' or @PHONE_LENGTH >10)
       RETURN 0
        
    SET  @PhoneNo_int= @PhoneNo
	SET @I = PATINDEX('%[^0-9]%', @PhoneNo_int)
	BEGIN
		WHILE @I > 0
		BEGIN
		SET @PhoneNo_int = STUFF(@PhoneNo_int, @I, 1, '' )
		SET @I = PATINDEX('%[^0-9]%', @PhoneNo_int )
		END
	END
	
	If(@PHONE_LENGTH=Len(@PhoneNo_int))
	BEGIN
	 RETURN 1
	END
	
	RETURN 0
	
	END
