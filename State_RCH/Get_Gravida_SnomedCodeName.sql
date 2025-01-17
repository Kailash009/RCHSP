USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Gravida_SnomedCodeName]    Script Date: 09/26/2024 12:45:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--at state db
ALTER FUNCTION [dbo].[Get_Gravida_SnomedCodeName](@GravidaCode as int)
RETURNS varchar(100) AS  
BEGIN 
	Declare @result varchar(100) = ''
	IF(@GravidaCode>10)
	 BEGIN
	  SET @GravidaCode=11
	 END
    SET @result = (Select RTRIM(LTRIM(Code_Value))+':'+RTRIM(LTRIM(SnomedCT_Display_Name)) As  SnomedCT_Display from [RCH_National_Level].[dbo].m_Gravida where Id = @GravidaCode)
      	
	Return @result

END

