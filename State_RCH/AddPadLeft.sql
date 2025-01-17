USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[AddPadLeft]    Script Date: 09/26/2024 12:40:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[AddPadLeft] (@input INT, @pad tinyint)
RETURNS VARCHAR(250)
AS BEGIN
    DECLARE @NumStr VARCHAR(250)

    SET @NumStr = LTRIM(@input)

    IF(@pad > LEN(@NumStr))
        SET @NumStr = REPLICATE('0', @Pad - LEN(@NumStr)) + @NumStr;

    RETURN @NumStr;
END