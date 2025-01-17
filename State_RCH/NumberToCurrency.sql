USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[NumberToCurrency]    Script Date: 09/26/2024 12:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[NumberToCurrency]
(    
  @InNumericValue NUMERIC(38,2)

)
RETURNS VARCHAR(60)
AS
BEGIN
DECLARE     @RetVal     VARCHAR(60)
            ,@StrRight  VARCHAR(5) 
            ,@StrFinal  VARCHAR(60)
            ,@StrLength INT
                 
SET @RetVal = ''
SET @RetVal= @InNumericValue 
SET @RetVal= SUBSTRING(@RetVal,1,CASE WHEN CHARINDEX('.', @RetVal)=0 THEN LEN(@RetVal)ELSE CHARINDEX('.',@RetVal)-1 END)
SET @StrLength = LEN(@RetVal)
IF(@StrLength > 3)
BEGIN
      SET @StrFinal = RIGHT(@RetVal,3)         
      SET @RetVal = SUBSTRING(@RetVal,-2,@StrLength)
      SET @StrLength = LEN(@RetVal)
      IF (LEN(@RetVal) > 0 AND LEN(@RetVal) < 3)
            BEGIN
            SET @StrFinal = @RetVal + ',' + @StrFinal
            END
      WHILE LEN(@RetVal) > 2
            BEGIN
            SET @StrRight=RIGHT(@RetVal,2)               
            SET @StrFinal = @StrRight + ',' + @StrFinal
            SET @RetVal = SUBSTRING(@RetVal,-1,@StrLength)
            SET @StrLength = LEN(@RetVal)
            IF(LEN(@RetVal) > 2)
            CONTINUE
            ELSE
            SET @StrFinal = @RetVal + ',' + @StrFinal
            BREAK
            END
            
END
else
SET @StrFinal=@RetVal

            
SELECT @StrFinal = ISNULL(@StrFinal,00)
RETURN @StrFinal
END
