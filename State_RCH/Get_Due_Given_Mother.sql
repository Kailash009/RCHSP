USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Due_Given_Mother]    Script Date: 09/26/2024 12:37:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Get_Due_Given_Mother](@Month tinyint,@Year as smallint,@Flag as tinyint,@LDate date,@FDate as Date)
RETURNS @retbenDueGivenInformation TABLE 
(Registration_no bigint,
Case_No tinyint
)
AS 

BEGIN

if(@Flag=1)
begin
INSERT @retbenDueGivenInformation

SELECT  a.Registration_no,a.Case_no
FROM [t_workplanANCDue] a 
inner join t_mother_flat_Count b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
where a.flag=0
and b.Entry_Type_Active=1
and b.LMP_Date is not null
and b.Delete_Mother<>1
and (b.Whose_mobile_Husband=1 or b.Whose_mobile_Wife=1)
and  @FDate between b.LMP_Date and b.EDD_Date
and @LDate between MinANCDate and MaxANCDate
and @FDate between MinANCDate and MaxANCDate
group by  a.Registration_no,a.Case_no
End
else
begin
INSERT @retbenDueGivenInformation
SELECT a.Registration_no,a.Case_no
FROM [t_workplanANCDue] a 
inner join t_mother_flat_Count b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
where a.flag=1
and b.Entry_Type_Active=1
and b.LMP_Date is not null
and b.Delete_Mother<>1
and (b.Whose_mobile_Husband=1 or b.Whose_mobile_Wife=1)
and ANC_Date between  @FDate and @LDate
group by  a.Registration_no,a.Case_no

end
RETURN;
END;







