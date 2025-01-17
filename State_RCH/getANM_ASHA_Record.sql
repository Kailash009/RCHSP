USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[getANM_ASHA_Record]    Script Date: 09/26/2024 12:38:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER FUNCTION [dbo].[getANM_ASHA_Record](@District_ID int,@HealthBlock_ID int,@PHC_ID as int,@SubCentre_ID as int,@Village_code as int,@type as varchar(10))
RETURNS @retContactInformation TABLE 
(
    
    ID int  NULL, 
    Name nvarchar(200) NULL,
    Number varchar(15) NULL,
    IsValidated bit

)
AS 
-- Returns the first name, last name, job title, and contact type for the specified contact.
BEGIN
 
   
	IF (@type='ASHA')
		BEGIN
        INSERT @retContactInformation
        SELECT ID, Name,Contact_no,IsValidated  FROM t_Ground_Staff WHERE District_Code =@District_ID and Type_ID=1 
        and (Healthblock_Code=@HealthBlock_ID or @HealthBlock_ID=0)
        and (HealthFacilty_Code=@PHC_ID or @PHC_ID=0)
        and (HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0)
        and (Village_Code=@Village_code or @Village_code=0)
        
        and isnull(is_Active,1)=1
		END
    
    
    ELSE IF(@type='ANM')
    BEGIN
     INSERT @retContactInformation
      SELECT ID, Name,Contact_no,IsValidated  FROM t_Ground_Staff WHERE District_Code = @District_ID and Type_ID<>1
      and (Healthblock_Code=@HealthBlock_ID or @HealthBlock_ID=0)
        and (HealthFacilty_Code=@PHC_ID or @PHC_ID=0)
        and (HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0)
        and (Village_Code=@Village_code or @Village_code=0)
        and isnull(is_Active,1)=1
    END
    
    RETURN;
END;

/*
[dbo].[getANM_ASHA_Record](18,'589',3004,'ANM')
*/




