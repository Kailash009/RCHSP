USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_DaysLeft]    Script Date: 09/26/2024 12:44:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[Get_DaysLeft](@Registration_no bigint)
RETURNS int
AS
BEGIN
	declare @Days int=0
    select  @Days= (case when DATEDIFF(day,getdate(),DATEADD(DAY,60,Execution_Date)) <=0 then 0 else DATEDIFF(day,getdate(),DATEADD(DAY,60,Execution_Date)) end) from t_page_tracking a WITH(NOLOCK) 
	left outer join t_mother_flat c WITH(NOLOCK) on a.Registration_no = c.Registration_no and c.case_no<> a.case_no 
    where a.Registration_no=@Registration_no and Is_Previous_Current=1 and  a.Case_no<>1  
     and c.Delivery_date is null and c.AbortionDate is null and c.Death_Date is null

	RETURN @Days
END
