USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[get_Mother_Count]    Script Date: 09/26/2024 12:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER FUNCTION [dbo].[get_Mother_Count](@ID int,@Year as int,@type as varchar(15))
RETURNS @retTCInformation TABLE 
(
    HP_ID int,
    yr1 int,
    yr2 int,
    yr3 int    
)
AS 

BEGIN

if(@type='')
set @type=(select [TYPE_ID] from t_Ground_Staff where ID=@ID)

if(@type<>'1')
begin
   
INSERT @retTCInformation

select ANM_ID,[2012],[2011],[2010]
from
(select Financial_Year ,ANM_ID from t_mother_registration where ANM_ID=@ID)u
pivot
(count(Financial_Year) for Financial_Year in ([2012],[2011],[2010]))pvt
end
else
begin
INSERT @retTCInformation

select  ASHA_ID,[2012],[2011],[2010]
from
(select Financial_Year ,ASHA_ID from t_mother_registration where ASHA_ID=@ID)u
pivot
(count(Financial_Year) for Financial_Year in ([2012],[2011],[2010]))pvt

end
    RETURN;
END;








