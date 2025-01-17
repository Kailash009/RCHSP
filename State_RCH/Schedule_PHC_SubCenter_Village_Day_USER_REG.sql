USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_USER_REG]    Script Date: 09/26/2024 14:45:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[Schedule_PHC_SubCenter_Village_Day_USER_REG] 
(
@ExecDate date
)
as
begin
--truncate table [Scheduled_DB_PHC_SubCenter_Count]
delete from Scheduled_PHC_SubCenter_Village_Day_USER_REG where Created_Date=@ExecDate
-------EC
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],EC_Total_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC 
from t_eligibleCouples a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on   a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.State_Code, a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_By
----------------------------Family ID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set RC_Total_Count=X.RC from 
(
select  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On) as Comparedate,a.Created_By as USERID,COUNT(a.Registration_no ) as RC 
from t_eligibleCouples a
inner join t_State_Family_Data l (nolock) on a.Registration_no=l.Registration_No 
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),a.Created_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.[UserID]=X.USERID



-------------ECT-------------------

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],ECT_Count)
select a.State_Code,a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_by as USERID,COUNT(a.Registration_no ) as EC 
from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate  and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-----------------------Mother Count-------------------------------
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MR_Total_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_registration a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null and a.Registration_Date<>'1990-01-01'
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by

-------------------------------Mother Medical-----------------------------------------------------------------

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MM_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_medical a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Mother ANC---------------------------------------------------

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MA_Count)
select a.State_Code,a.District_Code ,a.HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_anc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Mother Delivery---------------------------------------------------

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MD_Count)
select a.State_Code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],Inst_MD_Count_dlyDt)
select a.State_Code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Delivery_date),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Delivery_date)=Created_Date and a.Created_by=b.USerID
where Delivery_Place not in (22,23,25) and convert(date,a.Delivery_date)=@ExecDate and b.Created_date is null 
group by  a.state_code,a.District_Code ,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Delivery_date),SourceID,Created_by

-------------------------------------------------------Mother Infant---------------------------------------------------
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MI_Count)
select a.State_Code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_infant a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Mother PNC---------------------------------------------------
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MP_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_mother_pnc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by a.state_code,a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
print('GF')
-------------------------------------------------------GF---------------------------------------------------
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],GF_Count)
select a.State_Code,t.DCode  District_Code ,t.bid HealthBlock_Code,a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),0,a.Created_By,COUNT(ID ) as EC from t_ground_staff a
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacilty_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Created_On)=Created_Date and a.Created_by=b.USerID
inner join Health_PHC t on t.pid = a.HealthFacilty_Code 
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacilty_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null 
group by a.state_code,t.DCode ,t.bid , a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),a.Created_by


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],GF_Count_Updated)
select a.State_Code, t.DCode  District_Code ,t.bid HealthBlock_Code , a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,Updated_On) as Comparedate,0,Updated_By as USERID,COUNT(ID ) as Co 
from t_Ground_Staff a
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacilty_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Updated_On)=Created_Date and a.Updated_By=b.USerID
inner join Health_PHC t on t.pid = a.HealthFacilty_Code 
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacilty_Code 
where convert(date,Updated_On)=@ExecDate
and convert(date,Updated_On)<> convert(date,a.Created_On)   and b.Created_date is null
group by  a.state_code,t.DCode ,t.bid,a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,Updated_On),Updated_By
-------------------------------------------------------Child REG---------------------------------------------------
print('CR')

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CR_Count)
select a.State_Code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_children_registration a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.CreATED_bY=B.uSERid
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Child Tracking---------------------------------------------------
print('CT')
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CT_Count)
select  a.State_Code, a.District_Code ,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_children_tracking a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by a.state_code,a.District_Code ,a.HealthBlock_Code  , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Child PNC---------------------------------------------------
print('CP')

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CP_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(InfantRegistration ) as EC from t_child_pnc a
inner join t_Schedule_Date_Child_Previous c on a.InfantRegistration=c.Registration_No

left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null 
group by  a.state_code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Child Tracking Medical---------------------------------------------------
print('CTM')
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CTM_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code
,convert(date,a.Created_On),SourceID,Created_By,COUNT(a.Registration_no ) as EC from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No

left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID

--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by a.state_code,a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),SourceID,Created_by
-------------------------------------------------------Profile count---------------------------------------------------
print('PC')
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],Profile_Count)
select a.State_Code, a.District_Code ,a.HealthBlock_Code , a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code
,convert(date,a.Created_On),0,Created_By,COUNT(HealthFacility_code ) as EC from t_villagewise_registry a
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubCentre_code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Created_On)=Created_Date and a.Created_by=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,a.Created_On)=@ExecDate and b.Created_date is null
group by a.state_code,a.District_Code ,a.HealthBlock_Code  , a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code,convert(date,a.Created_On),Created_by


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],Profile_Count_Updated)
select a.State_Code,a.District_Code ,a.HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code
,convert(date,Updated_On),0,Updated_By,COUNT(HealthFacility_Code ) as EC from t_villagewise_registry a
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubCentre_code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
where convert(date,Updated_On)=@ExecDate
and convert(date,Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,a.District_Code ,a.HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code,convert(date,Updated_On),Updated_By


-----------------------------------------------------------------Only update by user no insert---------------------------------------------------------------------------------
print('EC1')
insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],EC_Total_Count_Updated)
select a.State_Code,t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),9,Updated_By as USERID,COUNT(a.Registration_no ) as EC 
from t_eligibleCouples a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code 
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],ECT_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),9,isnull(Updated_By,0),COUNT(a.Registration_no ) as Co from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)   
and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),isnull(Updated_By,0)

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MR_Total_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,isnull(Updated_By,0) as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_registration a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
and a.Registration_Date<>'1990-01-01' and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),isnull(Updated_By,0)


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MM_Count_Updated)
select a.State_Code,t.dcode District_Code ,t.bid HealthBlock_Code   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_medical a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)   and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By

insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MA_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_anc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MD_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By



insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MI_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_infant a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)   and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],MP_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_mother_pnc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate  and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)   and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CR_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_children_registration a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date  and a.uPDATED_bY=B.uSERid
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate  and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) ,Updated_By


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CT_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_children_tracking a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate  and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) ,Updated_By


insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CP_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_child_pnc a
inner join t_Schedule_Date_Child_Previous c on a.InfantRegistration=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate  and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid   ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) ,Updated_By



insert into Scheduled_PHC_SubCenter_Village_Day_USER_REG([STATE_ID],[DISTRICT_ID], [BLOCK_ID],[PHC_ID],[SubCentre_ID],[Village_ID],Created_Date,Source_ID,[UserID],CTM_Count_Updated)
select a.State_Code, t.dcode District_Code ,t.bid HealthBlock_Code  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,9,Updated_By as USERID,COUNT(a.Registration_no ) as Co 
from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
left outer join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
--inner join TBL_PHC t on t.PHC_CD = a.HealthFacility_Code 
inner join health_phc t on t.pid = a.HealthFacility_Code
where convert(date,a.Updated_On)=@ExecDate  and Updated_By is not null
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  and b.Created_date is null
group by  a.state_code,t.dcode ,t.bid  ,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) ,Updated_By




--------------------------------------------------------------------------------------------------------------------------------------
-------EC update


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set EC_Total_Count=X.EC from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On) as Comparedate,Created_By as USERID,COUNT(a.Registration_no ) as EC 
from t_eligibleCouples a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.[UserID]=X.USERID


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set EC_Total_Count_Updated=X.EC from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as EC 
from t_eligibleCouples a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


print('EC')
-------------ECT-------------------




update Scheduled_PHC_SubCenter_Village_Day_USER_REG set ECT_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set ECT_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

print('ECT')
-----------------------Mother Count-------------------------------





update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MR_Total_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_registration a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate and a.Registration_Date<>'1990-01-01'
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MR_Total_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_registration a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate and a.Registration_Date<>'1990-01-01'
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

print('MT')

-------------------------------Mother Medical-----------------------------------------------------------------




update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MM_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_medical a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MM_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_medical a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

print('MM')

-------------------------------------------------------Mother ANC---------------------------------------------------

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MA_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_anc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MA_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_anc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

print('MD')
-------------------------------------------------------Mother Delivery---------------------------------------------------

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MD_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MD_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Inst_MD_Count_dlyDt=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Delivery_date)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_delivery a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Delivery_date)=Created_Date and a.Created_by=b.USerID
where Delivery_Place not in (22,23,25) and convert(date,a.Delivery_date)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Delivery_date),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID
-------------------------------------------------------Mother Infant---------------------------------------------------
print('MI')


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MI_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_infant a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MI_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_infant a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

print('MP')
-------------------------------------------------------Mother PNC---------------------------------------------------


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MP_Count_Updated=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_mother_pnc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On)  
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set MP_Count=X.co from 
(
select a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_mother_pnc a
inner join t_Schedule_Date_Previous c on a.Registration_no=c.Registration_No and a.Case_no=c.Case_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID
print('GF')
-------------------------------------------------------GF---------------------------------------------------

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set GF_Count_Updated=X.co from 
(
select a.HealthFacilty_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,Updated_On) as Comparedate,Updated_By as USERID,COUNT(ID ) as co 
from t_Ground_Staff a
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacilty_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,Updated_On)=@ExecDate
and convert(date,Updated_On)<> convert(date,Created_On) 
group by  a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set GF_Count=X.co from 
(
select a.HealthFacilty_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,Created_On)  as Comparedate,Created_by as USERID,COUNT(ID ) as co 
from t_Ground_Staff a
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacilty_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,Created_On)=@ExecDate 
group by  a.HealthFacilty_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


-------------------------------------------------------Child REG---------------------------------------------------
print('CR')



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CR_Count_Updated=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_children_registration a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CR_Count=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_children_registration a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID
-------------------------------------------------------Child Tracking---------------------------------------------------
print('CT')




update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CT_Count_Updated=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_children_tracking a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate 
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CT_Count=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_children_tracking a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID
-------------------------------------------------------Child PNC---------------------------------------------------
print('CP')



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CP_Count_Updated=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_child_pnc a
inner join t_Schedule_Date_Child_Previous c on a.InfantRegistration=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CP_Count=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_child_pnc a
inner join t_Schedule_Date_Child_Previous c on a.InfantRegistration=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID
-------------------------------------------------------Child Tracking Medical---------------------------------------------------
print('CTM')


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CTM_Count_Updated=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On) as Comparedate,Updated_By as USERID,COUNT(a.Registration_no ) as co 
from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,a.Updated_On)=@ExecDate
and convert(date,a.Updated_On)<> convert(date,a.Created_On) 
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set CTM_Count=X.co from 
(
select a.HealthFacility_Code as HealthFacility_Code ,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On)  as Comparedate,Created_by as USERID,COUNT(a.Registration_no ) as co 
from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous c on a.Registration_no=c.Registration_No

inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubFacility_Code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,a.Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,a.Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,convert(date,a.Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

-------------------------------------------------------Profile count---------------------------------------------------
print('PC')


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Profile_Count_Updated=X.EC from 
(
select a.HealthFacility_Code,a.HealthSubCentre_code HealthSubFacility_Code,a.Village_Code,convert(date,Updated_On) as Comparedate,Updated_By as USERID,COUNT(HealthFacility_Code ) as EC 
from t_villagewise_registry a
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubCentre_code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Updated_On)=Created_Date and a.Updated_By=b.USerID
where convert(date,Updated_On)=@ExecDate
and convert(date,Updated_On)<> convert(date,Created_On) 
group by  a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code,convert(date,Updated_On),Updated_By
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Profile_Count=X.EC from 
(
select a.HealthFacility_Code,a.HealthSubCentre_code HealthSubFacility_Code,a.Village_Code,convert(date,Created_On)  as Comparedate,Created_by as USERID,COUNT(HealthFacility_Code ) as EC 
from t_villagewise_registry a
inner join Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.[PHC_ID] and a.HealthSubCentre_code=b.[SubCentre_ID] and a.Village_Code=b.[Village_ID] and convert(date,Created_On)=Created_Date and a.Created_by=b.USerID
where convert(date,Created_On)=@ExecDate
group by  a.HealthFacility_Code,a.HealthSubCentre_code,a.Village_Code,convert(date,Created_On),Created_by
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.HealthFacility_Code 
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.HealthSubFacility_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_Code
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Comparedate
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.USERID



-----------------------------------------------Updated source ID by checking the last updated user-------------------------------------------------
update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID=3 where Created_Date=@ExecDate and  UserID>(select MAX(userID) from User_Master) and Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date from t_eligible_couple_tracking a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date and b.Created_Date=@ExecDate
where Source_ID=9 and ECT_Count_Updated is not null
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_eligibleCouples a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and EC_Total_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_registration a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MR_Total_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9




update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_medical a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MM_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9



update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_anc a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MA_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_delivery a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MD_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_infant a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MI_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_mother_pnc a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and MP_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_children_registration a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and CR_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_children_tracking a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and CT_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_children_tracking_medical a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and CTM_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9

update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Source_ID= X.S from
(
select (Case when IP_address='' then 3 else 0 end) as S,b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date 
from t_child_pnc a
inner join  Scheduled_PHC_SubCenter_Village_Day_USER_REG b on a.HealthFacility_Code=b.PHC_ID and a.HealthSubFacility_Code=b.SubCentre_ID and a.Village_Code=b.Village_ID and a.Updated_By=b.UserID and CONVERT(date,a.Updated_On)=b.Created_Date  and b.Created_Date=@ExecDate
where Source_ID=9 and CP_Count_Updated is not null
group by (Case when IP_address='' then 3 else 0 end),b.PHC_ID,b.SubCentre_ID,b.Village_ID,b.USerID,b.Created_Date
)X
where Scheduled_PHC_SubCenter_Village_Day_USER_REG.PHC_ID=X.PHC_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.SubCentre_ID=X.SubCentre_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Village_ID=X.Village_ID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.UserID=X.UserID
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Created_Date=X.Created_Date
and Scheduled_PHC_SubCenter_Village_Day_USER_REG.Source_ID=9


update Scheduled_PHC_SubCenter_Village_Day_USER_REG set Financial_Year=(case when month(Created_Date)<=3 then YEAR(Created_Date)-1 else YEAR(Created_Date) end)
where  Created_Date=@ExecDate and Financial_Year is null


End


