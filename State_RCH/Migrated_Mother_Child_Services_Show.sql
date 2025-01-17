USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Migrated_Mother_Child_Services_Show]    Script Date: 09/26/2024 12:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









/*
Migrated_Mother_Child_Services_Show 2,'191625202321400079','191625202321400079','srcChild'
Migrated_Mother_Child_Services_Show 1,300100201311400029,300100201311400029,'srcMother'
Migrated_Mother_Child_Services_Show 1,130000076563,130000076563,'srcMother'
*/
ALTER proc [dbo].[Migrated_Mother_Child_Services_Show] 
(
	@IsRchMctsType int,
	@RCH_ID_No bigint=0,
	@MCTS_ID_No nvarchar(18)='',
	@ReportType varchar(32)
)
as
begin
-----------------------Records for RCH Id No for Mother ---------------------------------------------
if(@IsRchMctsType = 1)
begin
if(@ReportType = 'srcMother')
begin
--------------------table One For Registred Mother--------------------------
select a.Registration_no,
	(case when (LEN(cast(a.ID_No as varchar))>0 and cast(a.ID_No as varchar)!='0' and cast(a.ID_No as varchar) is not null)then cast(a.ID_No as varchar) else '--' end)as ID_No,
	d.StateName as State,
	e.DIST_NAME as District,
	f.Block_Name_E as Block,
	h.PHC_NAME as Phc,
	i.SUBPHC_NAME_E AS SubPHC,
	j.VILLAGE_NAME AS Village,
	a.Name_PW as Name,
	(case when (LEN(a.Name_H)>0 and a.Name_H is not null)then a.Name_H else '--' end)as Husband_Father_Name,
	(case when (LEN(a.Financial_Yr)>0 and a.Financial_Yr is not null)then a.Financial_Yr else '--' end)as Financial_Yr,
	(case when (LEN(CONVERT(VARCHAR(10),b.LMP_Date , 103))>1 and CONVERT(VARCHAR(10), b.LMP_Date , 103) is not null)then CONVERT(VARCHAR(10), b.LMP_Date , 103) else '--' end)as LMP_Date,
	(case when (LEN(a.Mobile_No)>0 and a.Mobile_No is not null)then dbo.get_Masked_Mobile(a.Mobile_No) else '--' end)as Mobile_No
	
	from t_mother_registration as a
	 left outer join TBL_STATE d on a.State_Code=StateID
	 left outer join TBL_DISTRICT e on e.DIST_CD=a.District_Code  
	 left outer join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code  
	 left outer join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code   
	 left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
	 left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code 
	 left outer join t_mother_medical b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
		where a.Registration_no=@RCH_ID_No 
--------------------table Two ANC--------------------------
	select a.Registration_no,
	--a.ID_No,
	(case when (LEN(cast(a.ID_No as varchar))>0 and cast(a.ID_No as varchar)!='0' and cast(a.ID_No as varchar) is not null)then cast(a.ID_No as varchar) else '--' end)as ID_No,
	d.StateName as State,
	e.DIST_NAME as District,
	f.Block_Name_E as Block,
	h.PHC_NAME as Phc,
	i.SUBPHC_NAME_E AS SubPHC,
	j.VILLAGE_NAME AS Village,
	b.Name_PW as Name,
	b.Name_H as Husband_Father_Name,
	a.Financial_Yr,
	CONVERT(VARCHAR(10), LMP_Date , 103)as LMP_Date,
	dbo.get_Masked_Mobile(b.Mobile_No)Mobile_No,
	(case when a.ANC_No = 1 then 'ANC-1' 
		when a.ANC_No = 2 then 'ANC-2'
		when a.ANC_No = 3 then 'ANC-3'
		when a.ANC_No = 4 then 'ANC-4'
		when a.ANC_No = 0 or a.ANC_No is null then '--'
		end)AS ANC_No,
	(case when (LEN(cast(a.ANC_Type as varchar))>0 and cast(a.ANC_Type as varchar)!=0 and cast(a.ANC_Type as varchar) is not null)then cast(a.ANC_Type as varchar) else '--' end)as ANC_Type,
	(case when (LEN(CONVERT(VARCHAR(10), a.ANC_Date , 103))>1 and CONVERT(VARCHAR(10), a.ANC_Date , 103) is not null)then (CONVERT(VARCHAR(10), a.ANC_Date , 103)) else '--' end)as ANC_Date,
	(case when (LEN(cast(a.Pregnancy_Month as varchar))>0 and cast(a.Pregnancy_Month as varchar)!=0 and cast(a.Pregnancy_Month as varchar) is not null)then cast(a.Pregnancy_Month as varchar) else '--' end)as Pregnancy_Month,
	(case when (LEN(CONVERT(VARCHAR(10), a.TT1_Date , 103))>1 and CONVERT(VARCHAR(10), a.TT1_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TT1_Date , 103) else '--' end)as TT1_Date,
	(case when (LEN(CONVERT(VARCHAR(10), a.TT2_Date , 103))>1 and CONVERT(VARCHAR(10), a.TT2_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TT2_Date , 103) else '--' end)as TT2_Date,
	(case when (LEN(CONVERT(VARCHAR(10), a.TTB_Date , 103))>1 and CONVERT(VARCHAR(10), a.TTB_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TTB_Date , 103) else '--' end)as TTB_Date,
	(case when (LEN(CAST(a.IFA_Given AS varchar))>1 and CAST(a.IFA_Given AS varchar) is not null)then CAST(a.IFA_Given AS varchar) else '--' end)as IFA_Given,
	(case when (CAST(a.Abortion_IfAny AS varchar)='1' and CAST(a.Abortion_IfAny AS varchar)!='0' and CAST(a.Abortion_IfAny AS varchar) is not null)then CAST(a.Abortion_IfAny AS varchar) else '--' end)as Abortion_IfAny,
	a.Abortion_Preg_Weeks,
	dbo.Get_Symptoms_High_Risk_Name([Symptoms_High_Risk],Other_Symptoms_High_Risk) as Symptoms_High_Risk,
	(case when (CAST(a.Maternal_Death AS varchar)='1' and CAST(a.Maternal_Death AS varchar)!='0' and CAST(a.Maternal_Death AS varchar) is not null)then CAST(a.Maternal_Death AS varchar) else '--' end)as Maternal_Death,
	(case when (LEN(CONVERT(VARCHAR(10), a.Death_Date , 103))>1 and CONVERT(VARCHAR(10), a.Death_Date , 103) is not null)then CONVERT(VARCHAR(10), a.Death_Date , 103) else '--' end)as Death_Date,
	(case when (LEN(a.Death_Reason)>0 and a.Death_Reason is not null)then a.Death_Reason else '--' end)as Death_Reason
	from t_mother_anc as a
	 inner join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
	 inner join t_mother_medical c on a.Registration_no=c.Registration_no  and a.Case_no=c.Case_no
	 left outer join TBL_STATE d on a.State_Code=StateID
	 inner join TBL_DISTRICT e on e.DIST_CD=a.District_Code  
	 inner join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code  
	 inner join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code   
	 left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
	 left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code 
		where a.Registration_no=@RCH_ID_No
	--------------------table Three for Delivery--------------------------
	select d.Registration_no,
			(case when (LEN(CONVERT(VARCHAR(10), d.Delivery_date , 103))>0 and CONVERT(VARCHAR(10), d.Delivery_date , 103) is not null)then CONVERT(VARCHAR(10), d.Delivery_date , 103) else '--' end)as Delivery_date,
			(case when (LEN(d.Delivery_Place)>0 and d.Delivery_Place>0 and d.Delivery_Place is not null)then md.Name else '--' end)as Delevery_Place_Name,
			d.Delivery_Place,
			(case when (LEN(d.Delivery_Type)>0 and d.Delivery_Type>0 and d.Delivery_Type is not null)then mt.Name else '--' end)as Delevery_Type_Name,
			d.Delivery_Type,
	       d.Delivery_Complication
	       ,(case when (LEN(d.Delivery_Complication)>0  and d.Delivery_Complication IS NOT NULL)then [dbo].[Get_DeliveryComplication_Name](d.Delivery_Complication) else '--' end) as Delivery_Complication_Name
	       ,(case when (LEN(d.Delivery_Outcomes)>0 and d.Delivery_Outcomes>0 and d.Delivery_Outcomes is not null)then d.Delivery_Outcomes else 0 end)as Delivery_Outcomes
		from t_mother_delivery as d
		left outer join [RCH_National_Level].[dbo].[m_DeliveryPlace] md on md.DeliveryReffID=d.Delivery_Place
		left outer join [RCH_National_Level].[dbo].[m_DeliveryType] mt on mt.Id=d.Delivery_Type
		where d.Registration_no=@RCH_ID_No
		
-----------------------------table Four for PNC--------------------------

  	select p.PNC_No,
  		(case when (LEN(p.PNC_Type)>0 and p.PNC_Type!=0 and p.PNC_Type is not null)then mp.PNC_Period else '--' end)as PNC_Period,
  		(case when (LEN(p.PNC_Type)>0 and p.PNC_Type!=0 and p.PNC_Type is not null)then p.PNC_Type else '--' end)as PNC_Type,
  		(case when (LEN(CONVERT(VARCHAR(10), p.PNC_Date , 103))>1 and CONVERT(VARCHAR(10), p.PNC_Date , 103) is not null)then CONVERT(VARCHAR(10), p.PNC_Date , 103) else '--' end)as PNC_Date,
  		(case when (LEN(p.DangerSign_Mother)>0 and p.DangerSign_Mother is not null)then p.DangerSign_Mother else '--' end)as DangerSign_Mother,
  		(case when (LEN(p.DangerSign_Mother)>0 and p.DangerSign_Mother is not null)then [dbo].[Get_Mother_Danger_Sign_Name](p.DangerSign_Mother) else '--' end)as DangerSign_Name_Mother,
  		(case when (LEN(p.DangerSign_Mother_Other)>0 and p.DangerSign_Mother_Other is not null)then p.DangerSign_Mother_Other else '--' end)as DangerSign_Mother_Other,
  		(case when (LEN(p.PPC)>0 and p.PPC is not null)then m.Name else '--' end)as Method_Name,
  		(case when (LEN(p.PPC)>0 and p.PPC is not null)then p.PPC else '--' end)as PPC,
        (case when (LEN(p.OtherPPC_Method)>0 and p.OtherPPC_Method is not null)then p.OtherPPC_Method else '--' end)as OtherPPC_Method,
        (case when (CAST(p.Mother_Death AS varchar)='1' and CAST(p.Mother_Death AS varchar)!='0' and CAST(p.Mother_Death AS varchar) is not null)then CAST('Yes' AS varchar) else '--' end)as Mother_Death,
        (case when (LEN(CONVERT(VARCHAR(10), p.Mother_Death_Date , 103))>1 and CONVERT(VARCHAR(10), p.Mother_Death_Date , 103) is not null)then CONVERT(VARCHAR(10), p.Mother_Death_Date , 103) else '--' end)as Mother_Death_Date,
        (case when (LEN(p.Mother_Death_Reason)>0 and p.Mother_Death_Reason!='0' and p.Mother_Death_Reason is not null)then p.Mother_Death_Reason else '--' end)as Mother_Death_Reason
   from t_mother_pnc as p
		left outer join [RCH_National_Level].[dbo].[m_Methods_PPMC_PPC]as m on m.PPC=p.PPC
		left outer join  [RCH_National_Level].[dbo].[m_DangerSignMother] as md on md.ID=p.DangerSign_Mother
		left outer join [RCH_National_Level].[dbo].[m_PNCPeriod] as mp on mp.PNC_No=p.PNC_Type
		where p.Registration_no=@RCH_ID_No
end
-----------------------Table for Child---------------------------------------------
 	if(@ReportType = 'srcChild')
		begin
		select a.Registration_no,
					a.ID_No,
					isnull(a.Mother_ID_No,'--')as Mother_ID_No,
					d.StateName as State,
					e.DIST_NAME as District,
					f.Block_Name_E as Block,
					h.PHC_NAME as Phc,
					i.SUBPHC_NAME_E AS SubPHC,
					j.VILLAGE_NAME AS Village,
					(case when (LEN(CONVERT(VARCHAR(10), a.Birth_Date , 103))>1 and CONVERT(VARCHAR(10),
					 a.Birth_Date , 103) is not null)then CONVERT(VARCHAR(10), a.Birth_Date , 103) else '--' end)as Birth_Date,
		CONVERT(VARCHAR(10), b.Immu_date , 103)as Immu_date,
			(case b.Immu_code when 1 then 'BCG' when 2 then 'OPV-0' when 3 then 'OPV-1' when 4 then 'OPV-2' when 5 then 'OPV-3' 
				when 6 then 'OPV-B' when 7 then 'DPT-1' when 8 then 'DPT-2' when 9 then 'DPT-3' when 10 then 'DPT-B1' 
				when 11 then 'DPT-B2' when 12 then 'HEP B-0' when 13 then 'HEP B-1' when 14 then 'HEP B-2' when 15 then 'HEP B-3' 
				when 16 then 'PENTAVALENT VACCINE-1' when 17 then 'PENTAVALENT VACCINE-2' when 18 then 'PENTAVALENT VACCINE-3' 
				when 19 then 'MEASLES-1' when 20 then 'MEASLES-2' when 21 then 'JE VACCINE-1' when 22 then 'JE VACCINE-2' 
				when 23 then 'VITAMIN A-1' when 24 then 'VITAMIN A-2' when 25 then 'VITAMIN A-3' when 26 then 'VITAMIN A-4' 
				when 27 then 'VITAMIN A-5' when 28 then 'VITAMIN A-6' when 29 then 'VITAMIN A-7' end)as Immunization,
			 a.Name_Child as Name,a.Name_Mother,
			 (case when (LEN(CAST(a.Name_Father AS varchar))>1 and CAST(a.Name_Father AS varchar) is not null)then CAST(a.Name_Father AS varchar) else '--' end)as Husband_Father_Name,
			 dbo.get_Masked_Mobile(a.Mobile_no)Mobile_no
			 ,Financial_Yr
			 from t_children_registration a
			 left outer join t_children_tracking b on a. Registration_no=b.Registration_no 
			 left outer join TBL_STATE d on a.State_Code=d.StateID
			 inner join TBL_DISTRICT e on e.DIST_CD=a.District_Code 
			 inner join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code
			 inner join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code
			 left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
			 left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code 
			where a.Registration_no=@RCH_ID_No 
		end 
end

-----------------------Records for MCTS Id No for Mother ---------------------------------------------
if(@IsRchMctsType = 2)
begin
if(@ReportType = 'srcMother')
begin

--------------------table One For Registred Mother--------------------------
select a.Registration_no,
	(case when (LEN(cast(a.ID_No as varchar))>0 and cast(a.ID_No as varchar)!='0' and cast(a.ID_No as varchar) is not null)then cast(a.ID_No as varchar) else '--' end)as ID_No,
	d.StateName as State,
	e.DIST_NAME as District,
	f.Block_Name_E as Block,
	h.PHC_NAME as Phc,
	i.SUBPHC_NAME_E AS SubPHC,
	j.VILLAGE_NAME AS Village,
	a.Name_PW as Name,
	(case when (LEN(a.Name_H)>0 and a.Name_H is not null)then a.Name_H else '--' end)as Husband_Father_Name,
	(case when (LEN(a.Financial_Yr)>0 and a.Financial_Yr is not null)then a.Financial_Yr else '--' end)as Financial_Yr,
	(case when (LEN(CONVERT(VARCHAR(10),b.LMP_Date , 103))>1 and CONVERT(VARCHAR(10), b.LMP_Date , 103) is not null)then CONVERT(VARCHAR(10), b.LMP_Date , 103) else '--' end)as LMP_Date,
	(case when (LEN(a.Mobile_No)>0 and a.Mobile_No is not null)then dbo.get_Masked_Mobile(a.Mobile_No) else '--' end)as Mobile_No
	
	from t_mother_registration as a
	 left outer join TBL_STATE d on a.State_Code=StateID
	 left outer join TBL_DISTRICT e on e.DIST_CD=a.District_Code  
	 left outer join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code  
	 left outer join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code   
	 left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
	 left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code 
	 left outer join t_mother_medical b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
		where a.ID_NO=@MCTS_ID_No
		 
--------------------table Two for ANC--------------------------

	select a.Registration_no,
	--a.ID_No,
	(case when (LEN(cast(a.ID_No as varchar))>0 and cast(a.ID_No as varchar)!='0' and cast(a.ID_No as varchar) is not null)then cast(a.ID_No as varchar) else '--' end)as ID_No,
	d.StateName as State,
	e.DIST_NAME as District,
	f.Block_Name_E as Block,
	h.PHC_NAME as Phc,
	i.SUBPHC_NAME_E AS SubPHC,
	j.VILLAGE_NAME AS Village,
	b.Name_PW as Name,
	b.Name_H as Husband_Father_Name,
	a.Financial_Yr,
	CONVERT(VARCHAR(10), LMP_Date , 103)as LMP_Date,
	dbo.get_Masked_Mobile(b.Mobile_No)Mobile_No,
	(case when a.ANC_No = 1 then 'ANC-1' 
		when a.ANC_No = 2 then 'ANC-2'
		when a.ANC_No = 3 then 'ANC-3'
		when a.ANC_No = 4 then 'ANC-4'
		when a.ANC_No = 0 or a.ANC_No is null then '--'
		end)AS ANC_No,
	(case when (LEN(cast(a.ANC_Type as varchar))>0 and cast(a.ANC_Type as varchar)!=0 and cast(a.ANC_Type as varchar) is not null)then cast(a.ANC_Type as varchar) else '--' end)as ANC_Type,
	(case when (LEN(CONVERT(VARCHAR(10), a.ANC_Date , 103))>1 and CONVERT(VARCHAR(10), a.ANC_Date , 103) is not null)then (CONVERT(VARCHAR(10), a.ANC_Date , 103)) else '--' end)as ANC_Date,
	(case when (LEN(cast(a.Pregnancy_Month as varchar))>0 and cast(a.Pregnancy_Month as varchar)!=0 and cast(a.Pregnancy_Month as varchar) is not null)then cast(a.Pregnancy_Month as varchar) else '--' end)as Pregnancy_Month,
	(case when (LEN(CONVERT(VARCHAR(10), a.TT1_Date , 103))>1 and CONVERT(VARCHAR(10), a.TT1_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TT1_Date , 103) else '--' end)as TT1_Date,
	(case when (LEN(CONVERT(VARCHAR(10), a.TT2_Date , 103))>1 and CONVERT(VARCHAR(10), a.TT2_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TT2_Date , 103) else '--' end)as TT2_Date,
	(case when (LEN(CONVERT(VARCHAR(10), a.TTB_Date , 103))>1 and CONVERT(VARCHAR(10), a.TTB_Date , 103) is not null)then CONVERT(VARCHAR(10), a.TTB_Date , 103) else '--' end)as TTB_Date,
	(case when (LEN(CAST(a.IFA_Given AS varchar))>1 and CAST(a.IFA_Given AS varchar) is not null)then CAST(a.IFA_Given AS varchar) else '--' end)as IFA_Given,
	(case when (CAST(a.Abortion_IfAny AS varchar)='1' and CAST(a.Abortion_IfAny AS varchar)!='0' and CAST(a.Abortion_IfAny AS varchar) is not null)then CAST(a.Abortion_IfAny AS varchar) else '--' end)as Abortion_IfAny,
	a.Abortion_Preg_Weeks,
	(case when (LEN(a.Symptoms_High_Risk)>0 and a.Symptoms_High_Risk is not null)then 'Yes' else '--' end)as Symptoms_High_Risk,
	(case when (CAST(a.Maternal_Death AS varchar)='1' and CAST(a.Maternal_Death AS varchar)!='0' and CAST(a.Maternal_Death AS varchar) is not null)then CAST(a.Maternal_Death AS varchar) else '--' end)as Maternal_Death,
	(case when (LEN(CONVERT(VARCHAR(10), a.Death_Date , 103))>1 and CONVERT(VARCHAR(10), a.Death_Date , 103) is not null)then CONVERT(VARCHAR(10), a.Death_Date , 103) else '--' end)as Death_Date,
	(case when (LEN(a.Death_Reason)>0 and a.Death_Reason is not null)then a.Death_Reason else '--' end)as Death_Reason
	from t_mother_anc as a
	 inner join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no
	 inner join t_mother_medical c on a.Registration_no=c.Registration_no and a.Case_no=c.Case_no
	 left outer join TBL_STATE d on a.State_Code=StateID
	 inner join TBL_DISTRICT e on e.DIST_CD=a.District_Code  
	 inner join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code  
	 inner join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code   
	 left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
	 left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code
		where a.ID_NO=@MCTS_ID_No
--------------------table Three for Delivery--------------------------
select 
d.Registration_no,
(case when (LEN(CONVERT(VARCHAR(10), d.Delivery_date , 103))>0 and CONVERT(VARCHAR(10), d.Delivery_date , 103) is not null)
then CONVERT(VARCHAR(10), d.Delivery_date , 103) else '--' end)as Delivery_date,
(case when (LEN(d.Delivery_Place)>0 and d.Delivery_Place>0 and d.Delivery_Place is not null)then md.Name else '--' end)as Delevery_Place_Name,
d.Delivery_Place,
(case when (LEN(d.Delivery_Type)>0 and d.Delivery_Type>0 and d.Delivery_Type is not null)then mt.Name else '--' end)as Delevery_Type_Name,
d.Delivery_Type,
d.Delivery_Complication
,(case when (LEN(d.Delivery_Complication)>0  and d.Delivery_Complication IS NOT NULL)
then [dbo].[Get_DeliveryComplication_Name](d.Delivery_Complication) else '--' end) as Delivery_Complication_Name
,(case when (LEN(d.Delivery_Outcomes)>0 and d.Delivery_Outcomes>0 and d.Delivery_Outcomes is not null)
then d.Delivery_Outcomes else 0 end)as Delivery_Outcomes
from t_mother_delivery as d
left outer join [RCH_National_Level].[dbo].[m_DeliveryPlace] md on md.DeliveryReffID=d.Delivery_Place
left outer join [RCH_National_Level].[dbo].[m_DeliveryType] mt on mt.Id=d.Delivery_Type
where d.ID_NO=@MCTS_ID_No
--------------------table Four PNC --------------------------
  	select p.PNC_No,
  		(case when (LEN(p.PNC_Type)>0 and p.PNC_Type!=0 and p.PNC_Type is not null)then mp.PNC_Period else '--' end)as PNC_Period,
  		(case when (LEN(p.PNC_Type)>0 and p.PNC_Type!=0 and p.PNC_Type is not null)then p.PNC_Type else '--' end)as PNC_Type,
  		(case when (LEN(CONVERT(VARCHAR(10), p.PNC_Date , 103))>1 and CONVERT(VARCHAR(10), p.PNC_Date , 103) is not null)then CONVERT(VARCHAR(10), p.PNC_Date , 103) else '--' end)as PNC_Date,
  		(case when (LEN(p.DangerSign_Mother)>0 and p.DangerSign_Mother is not null)then p.DangerSign_Mother else '--' end)as DangerSign_Mother,
  		(case when (LEN(p.DangerSign_Mother)>0 and p.DangerSign_Mother is not null)then [dbo].[Get_Mother_Danger_Sign_Name](p.DangerSign_Mother) else '--' end)as DangerSign_Name_Mother,
  		(case when (LEN(p.DangerSign_Mother_Other)>0 and p.DangerSign_Mother_Other is not null)then p.DangerSign_Mother_Other else '--' end)as DangerSign_Mother_Other,
  		(case when (LEN(p.PPC)>0 and p.PPC is not null)then m.Name else '--' end)as Method_Name,
  		(case when (LEN(p.PPC)>0 and p.PPC is not null)then p.PPC else '--' end)as PPC,
        (case when (LEN(p.OtherPPC_Method)>0 and p.OtherPPC_Method is not null)then p.OtherPPC_Method else '--' end)as OtherPPC_Method,
        (case when (CAST(p.Mother_Death AS varchar)='1' and CAST(p.Mother_Death AS varchar)!='0' and CAST(p.Mother_Death AS varchar) is not null)then CAST('Yes' AS varchar) else '--' end)as Mother_Death,
        (case when (LEN(CONVERT(VARCHAR(10), p.Mother_Death_Date , 103))>1 and CONVERT(VARCHAR(10), p.Mother_Death_Date , 103) is not null)then CONVERT(VARCHAR(10), p.Mother_Death_Date , 103) else '--' end)as Mother_Death_Date,
        (case when (LEN(p.Mother_Death_Reason)>0 and p.Mother_Death_Reason!='0' and p.Mother_Death_Reason is not null)then p.Mother_Death_Reason else '--' end)as Mother_Death_Reason
   from t_mother_pnc as p
		left outer join [RCH_National_Level].[dbo].[m_Methods_PPMC_PPC]as m on m.PPC=p.PPC
		left outer join  [RCH_National_Level].[dbo].[m_DangerSignMother] as md on md.ID=p.DangerSign_Mother
		left outer join [RCH_National_Level].[dbo].[m_PNCPeriod] as mp on mp.PNC_No=p.PNC_Type
		where p.ID_NO=@MCTS_ID_No
end
--------------------Facth Records for Child--------------------------
 	if(@ReportType = 'srcChild')
		begin
select a.Registration_no,
a.ID_No,
isnull(a.Mother_ID_No,'--')as Mother_ID_No,
d.StateName as State,
e.DIST_NAME as District,
f.Block_Name_E as Block,
h.PHC_NAME as Phc,
i.SUBPHC_NAME_E AS SubPHC,
j.VILLAGE_NAME AS Village,
(case when (LEN(CONVERT(VARCHAR(10), a.Birth_Date , 103))>1 and CONVERT(VARCHAR(10),a.Birth_Date , 103) is not null)
then CONVERT(VARCHAR(10), a.Birth_Date , 103) else '--' end)as Birth_Date,
CONVERT(VARCHAR(10), b.Immu_date , 103)as Immu_date,
(case b.Immu_code when 1 then 'BCG' when 2 then 'OPV-0' when 3 then 'OPV-1' when 4 then 'OPV-2' when 5 then 'OPV-3' 
when 6 then 'OPV-B' when 7 then 'DPT-1' when 8 then 'DPT-2' when 9 then 'DPT-3' when 10 then 'DPT-B1' 
when 11 then 'DPT-B2' when 12 then 'HEP B-0' when 13 then 'HEP B-1' when 14 then 'HEP B-2' when 15 then 'HEP B-3' 
when 16 then 'PENTAVALENT VACCINE-1' when 17 then 'PENTAVALENT VACCINE-2' when 18 then 'PENTAVALENT VACCINE-3' 
when 19 then 'MEASLES-1' when 20 then 'MEASLES-2' when 21 then 'JE VACCINE-1' when 22 then 'JE VACCINE-2' 
when 23 then 'VITAMIN A-1' when 24 then 'VITAMIN A-2' when 25 then 'VITAMIN A-3' when 26 then 'VITAMIN A-4' 
when 27 then 'VITAMIN A-5' when 28 then 'VITAMIN A-6' when 29 then 'VITAMIN A-7' end)as Immunization,
a.Name_Child as Name,a.Name_Mother,
(case when (LEN(CAST(a.Name_Father AS varchar))>1 and CAST(a.Name_Father AS varchar) is not null)then CAST(a.Name_Father AS varchar) else '--' end)as Husband_Father_Name,
dbo.get_Masked_Mobile(a.Mobile_no)Mobile_no
,Financial_Yr
from t_children_registration a
left outer join t_children_tracking b on a. Registration_no=b.Registration_no 
left outer join TBL_STATE d on a.State_Code=d.StateID
inner join TBL_DISTRICT e on e.DIST_CD=a.District_Code 
inner join TBL_HEALTH_BLOCK f on f.BLOCK_CD=a.HealthBlock_Code
inner join TBL_PHC h on h.PHC_CD=a.HealthFacility_Code
left outer join TBL_SUBPHC i on i.SUBPHC_CD=a.HealthSubFacility_Code
left outer join TBL_VILLAGE j on j.VILLAGE_CD = a.Village_Code and j.SUBPHC_CD = a.HealthSubFacility_Code 
where a.ID_NO=@MCTS_ID_No 
		end 
end
end


