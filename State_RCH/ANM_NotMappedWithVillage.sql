USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[ANM_NotMappedWithVillage]    Script Date: 09/26/2024 12:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[ANM_NotMappedWithVillage](@id int)      
RETURNS int      
AS      
BEGIN      
            
       DECLARE @Result int      
       select   @Result = COUNT(distinct amap.Village_Code)  from t_ANM_ASHA_Mapping_Village amap    
       inner join dbo.t_ground_staff_mapping gm on amap.id = gm.id and amap.HealthFacility_Code= gm.HealthFacilty_Code and amap.HealthSubFacility_Code = gm.HealthSubFacility_Code    
 where amap.ID=@id and isnull(amap.Village_Code,0)<>0 and amap.Is_Mapped=1  and (gm.IsActual =1 or gm.IsLinked = 1)    
       RETURN @Result      
      
end