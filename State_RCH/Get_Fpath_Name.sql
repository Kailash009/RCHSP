USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Fpath_Name]    Script Date: 09/26/2024 12:37:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Get_Fpath_Name]()
RETURNS @retFpath TABLE 
(
    Fpath int,
    Fname Varchar(50)
)
AS 

BEGIN

   
INSERT @retFpath
Select 1,'Workplan for Mother ANC'
union
Select 2,'Workplan Delivery'
union
Select 3,'Workplan PNC Mother Delivery Done'
union
Select 4,'Workplan PNC Mother NotDelivered butDue'
union
Select 5,'Workplan Facilitywise'
union
Select 6,'Workplan By Beneficiary ID'
union
Select 7,'Workplan By HealthProvider ID'
union
Select 8,'Workplan Child Immunization'
union
Select 9,'Workplan Infant Immunization'

    RETURN;
END;










