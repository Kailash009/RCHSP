USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Fun_ValidatePhoneNo]    Script Date: 09/26/2024 12:44:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER FUNCTION [dbo].[Fun_ValidatePhoneNo] 
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
   SET @PhoneNo=REPLACE(@PhoneNo,' ', '')
   SET @PhoneNo=REPLACE(LTRIM(REPLACE(RTRIM(@PhoneNo), '0', ' ')), ' ', '0') 
   
    SET  @PHONE_LENGTH=ISNULL(len(@PhoneNo),0)
    if(@PHONE_LENGTH < 6 OR @PHONE_LENGTH >10)
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




