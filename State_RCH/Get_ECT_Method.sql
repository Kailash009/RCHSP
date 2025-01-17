USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_ECT_Method]    Script Date: 09/26/2024 12:44:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [dbo].[Get_ECT_Method](@Registration_No bigint,@case_no tinyint)
RETURNS varchar(50)
AS
BEGIN
	declare @Name varchar(50)
  select @Name=COALESCE( @Name+'','')+Method
	from t_eligible_couple_tracking where Registration_no=@Registration_No and Case_no=@case_no
	
	
DECLARE @old_string VARCHAR(35)
DECLARE @count INT
DECLARE @new_string VARCHAR(35)
SET @count=1

SET @old_string = @Name

WHILE ( @count <= LEN(@Name) )
  BEGIN
      IF ( @new_string IS NULL )
        BEGIN
            SET @new_string=''
        END
      SET @new_string=@new_string + Substring(@old_string, 1, 1)
      SET @old_string=REPLACE(@old_string, Substring(@old_string, 1, 1), '')
      SET @count=@count + 1
  END
set @Name=@new_string
	
	RETURN @Name
END



