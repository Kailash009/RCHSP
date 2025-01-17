USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[getSMS_Child_Count]    Script Date: 09/26/2024 12:39:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER FUNCTION [dbo].[getSMS_Child_Count](@PID int,@SID as int,@VID as int,@Month_ID int,@Year_ID int,@Ldate as Date,@Service_ID int)
RETURNS @retTCCInformation TABLE 
(
    Registration_No Bigint
       
)
AS 

BEGIN
INSERT @retTCCInformation
SELECT  a.Registration_no
FROM [t_workplanChild] a 
inner join t_child_flat_Count b on a.Registration_No=b.Registration_No
inner join m_Month_YearMaster c on a.MinDate <= c.DateCheck
where c.Month_ID=@Month_ID and c.Year_ID=@Year_ID
and datediff(month,Child_Birthdate_Date,@Ldate)<=12
and a.MinDate<=@Ldate 
and a.Immu_Date is null
and b.Entry_Type_Active=1
and b.PHC_ID=@PID 
and (b.SubCentre_ID=@SID or @SID=0)
and (b.Village_ID=@VID or @VID=0)
and (a.Immu_Code=@Service_ID or @Service_ID=0)
group by a.Registration_no

    RETURN;
END;

/*
[dbo].[getANM_ASHA_Record](18,'589',3004,'ANM')
*/










