USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[WorkPlanMother_Public]    Script Date: 09/26/2024 14:53:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
[WorkPlanMother_Public] 130000000003  
*/  
ALTER Proc [dbo].[WorkPlanMother_Public]  
(  
 @Registration_no bigint  
)  
as  
begin  
 select (case when ANC_Type=1 then 'ANC 1' when ANC_Type=2 then 'ANC 2' when ANC_Type=3 then 'ANC 3' when ANC_Type=4 then 'ANC 4' when ANC_Type=13 then 'TT1'   
 when ANC_Type=14 then 'TT2' when ANC_Type=15 then 'IFA' when ANC_Type=17 then 'TTB' when ANC_Type=5 then 'Delivery' end)as ANC_Type  
 ,(case when flag=0 then 'Due' when flag=1 then 'Given' end)as Status  
 ,MinANCDate as MinANCDue  
 ,MaxANCDate as MaxANCDue  
 ,ANC_Date from t_workplanANCDue where ANC_Type in(1,2,3,4,5,13,14,17,15) and Registration_no=@Registration_no  
end

