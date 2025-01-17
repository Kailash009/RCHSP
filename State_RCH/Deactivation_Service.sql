USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Deactivation_Service]    Script Date: 09/26/2024 12:43:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Deactivation_Service](@ID int)  
RETURNS VARCHAR(100) AS  
  
BEGIN  
   DECLARE @Data as varchar(100) = null  
  
  select @Data=COALESCE( @Data+', ','')+  cast (ImmuCode as varchar)  
 from m_ImmunizationName   as s   
  where Flag=0  
   RETURN ISNULL(@Data,0)
     
  
END  
 
