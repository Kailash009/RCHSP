USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[Insert_Update_Mother_Workplan]    Script Date: 09/26/2024 14:24:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[Insert_Update_Mother_Workplan]			
as
begin
----------------------------------------Mother-------------------------------------------------------------------------------------------
-------------------------------ANC1,ANC2,ANC3,ANC4,Delivery,TT1,TT2,TTB,IFA--(597661)----------------------------------------------------
--Step 1 (Due)
insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag],[Created_On])
select b.Registration_no
,(case ServiceID when 1 then 1 when 2 then 2 when 3 then 3 when 4 then 4 when 9 then 5 when 5 then 13 when 6 then 14 when 7 then 15 end)as ANC_Type
,Service_Min as [MinANCDate],Service_Max as [MaxANCDate],Given_Date as [ANC_Date],0 as flag,getdate() as Created_On from MCR_30.dbo.t_workplan_mother a
inner join t_mother_registration b on a.ID_NO=b.ID_No where a.ServiceID in(1,2,3,4,9,5,6,7)
--Step 2 (Given)
update t_workplanANCDue set flag=1 where ANC_Date is not null
--select COUNT(Registration_no) from t_workplanANCDue where ANC_Date is not null --(463098)
--Step 3 (Over Due)

-------------------------------PNC-------------------------------------------------------------------------------
	-------------------------------------Insert----------------------------------------------------		
	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag])  --PNC1
	--select Registration_no,6,Delivery_date,(DATEADD(DAY,1, Delivery_date)),null,0 from t_mother_delivery

	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag])  --PNC2
	--select Registration_no,7,(DATEADD(DAY,2, Delivery_date)),(DATEADD(DAY,3, Delivery_date)),null,0 from t_mother_delivery

	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag])  --PNC3
	--select Registration_no,8,(DATEADD(DAY,4, Delivery_date)),(DATEADD(DAY,10, Delivery_date)),null,0 from t_mother_delivery
	
	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag]) --PNC4
	--select Registration_no,9,(DATEADD(DAY,11, Delivery_date)),(DATEADD(DAY,17, Delivery_date)),null,0 from t_mother_delivery

	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag]) --PNC5
	--select Registration_no,10,(DATEADD(DAY,18, Delivery_date)),(DATEADD(DAY,24, Delivery_date)),null,0 from t_mother_delivery
	
	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag]) --PNC6
	--select Registration_no,11,(DATEADD(DAY,25, Delivery_date)),(DATEADD(DAY,31, Delivery_date)),null,0 from t_mother_delivery
	
	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag]) --PNC7
	--select Registration_no,12,(DATEADD(DAY,39, Delivery_date)),DATEADD(DAY,45, Delivery_date),null,0 from t_mother_delivery
			
	--insert into t_workplanANCDue([Registration_no],[ANC_Type],[MinANCDate],[MaxANCDate],[ANC_Date],[flag]) --IFA for PNC
	--select Registration_no,16,Delivery_date,DATEADD(DAY,45, Delivery_date),null,0 from t_mother_delivery
	
	-------------------------------------Update----------------------------------------------------
				
	select a.Registration_no,b.PNC_Date,b.PNC_Type from t_workplanANCDue a 
	inner join t_mother_pnc b on a.Registration_no=b.Registration_no where a.Registration_no=b.Registration_no and a.ANC_Type =6

	--update t_workplanANCDue set ANC_Date=a.PNC_Date,flag=1 from t_mother_pnc a where t_workplanANCDue.Registration_no=a.Registration_no and t_workplanANCDue.ANC_Type=6 --43077

	select a.Registration_no,a.MinANCDate,a.MaxANCDate,b.PNC_Date from t_workplanANCDue a
	inner join t_mother_pnc b on a.Registration_no=b.Registration_no where PNC_Type=7 and a.ANC_Type=12

	--update t_workplanANCDue set ANC_Date=a.PNC_Date,flag=1 from t_mother_pnc a where t_workplanANCDue.Registration_no=a.Registration_no and   t_workplanANCDue.ANC_Type=12 and a.PNC_Type=7 --43077
-------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------Child---------------------------------------------------------------------------
--truncate table t_workplanChild
--select * from t_workplanChild
--alter table t_workplanChild add Created_On datetime

--insert into t_workplanChild([Registration_no],[Immu_Code],[MinDate],[MaxDate],[Immu_Date],[flag],[Created_On]) --(888032)
select  b.Registration_no
,(case ServiceID when 1 then 1 when 2 then 12 when 3 then 2 when 5 then	3 when 4 then 7 when 6 then 13 when 31 then 16 when 7 then 4 when 8 then 8 when 9 then	14 when 32 then 17 when 10 then 5 when 11 then 9 when 12 then 15 when 33 then 18 when 13 then 19 when 14 then 23 when 29 then 21 when 15 then 10 when 16 then 6 when 30 then 20 when 18 then 24 when 19 then 25 when 20 then 26 when 21 then 27 when 22 then 28 when 23 then 29 when 24 then 30
when 25 then 31 end)as ANC_Type
,Service_Min as [MinANCDate],Service_Max as [MaxANCDate],Given_Date as [Immu_Date],0 as flag,getdate() as Created_On from MCR_30.dbo.t_workplan_Child a
inner join t_children_registration b on a.ID_NO=b.ID_No where a.ServiceID in(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,19,20,21,22,23,24,25,29,30,31,32,33)

end




