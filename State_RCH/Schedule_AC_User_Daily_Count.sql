USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_AC_User_Daily_Count]    Script Date: 09/26/2024 14:43:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[Schedule_AC_User_Daily_Count] '2015-02-01'
[Schedule_AC_User_Daily_Count] '2015-02-02'
[Schedule_AC_User_Daily_Count] '2015-02-03'

*/

ALTER proc [dbo].[Schedule_AC_User_Daily_Count]
(@RunningDate as Date='')
as
begin

if not exists(select * from t_userwise_insert_update_count where AsOnDate=@RunningDate)
begin
insert into t_userwise_insert_update_count(UserID,AsOnDate,[EC_insered_on],[EC_updated_on],[ECT_insered_on],[ECT_updated_on],[MR_inserted_on]
,[MR_updated_on],[MM_inserted_on],[MM_updated_on],[MA_inserted_on],[MA_updated_on],[MD_inserted_on],[MD_updated_on],[MI_inserted_on],[MI_updated_on]
,[MP_inserted_on],[MP_updated_on],[CR_inserted_on],[CR_updated_on],[CT_inserted_on],[CT_updated_on],[CM_inserted_on],[CM_updated_on])
select a.UserID,@RunningDate,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 from User_Master a
inner join User_AppRole b on a.UserID=b.UserID where a.Status=1

------------------------------------------Total EC Created
update t_userwise_insert_update_count set EC_insered_on=a.EC_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as EC_insered_on 
--,(case when (Created_By=ANM_ID and SourceID=3) then 23 when (Created_By=ANM_ID and SourceID=1) then 21 
--when (Created_By=ASHA_ID and SourceID=3) then 13 when (Created_By=ASHA_ID and SourceID=1) then 11 else 0 end) Is_User_ANM_ASHA
from t_eligibleCouples group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total EC Updated
update t_userwise_insert_update_count set EC_updated_on=a.EC_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as EC_updated_on from t_eligibleCouples group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total ECT Created
update t_userwise_insert_update_count set ECT_insered_on=a.ECT_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as ECT_insered_on from t_eligible_couple_tracking group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total ECT Updated
update t_userwise_insert_update_count set ECT_updated_on=a.ECT_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as ECT_updated_on from t_eligible_couple_tracking group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
-------------------------------------------Mother
------------------------------------------Total MR Created
update t_userwise_insert_update_count set MR_inserted_on=a.MR_inserted_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MR_inserted_on from t_mother_registration where CONVERT(date,Registration_Date)<>'1990-01-01'
 group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MR Updated
update t_userwise_insert_update_count set MR_updated_on=a.MR_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MR_updated_on from t_mother_registration where CONVERT(date,Registration_Date)<>'1990-01-01'
 group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MM Created
update t_userwise_insert_update_count set MM_inserted_on=a.MM_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MM_insered_on from t_mother_medical group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MM Updated
update t_userwise_insert_update_count set MM_updated_on=a.MM_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MM_updated_on from t_mother_medical group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MA Created
update t_userwise_insert_update_count set MA_inserted_on=a.MA_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MA_insered_on from t_mother_anc group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MA Updated
update t_userwise_insert_update_count set MA_updated_on=a.MA_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MA_updated_on from t_mother_anc group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MD Created
update t_userwise_insert_update_count set MD_inserted_on=a.MD_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MD_insered_on from t_mother_delivery group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MD Updated
update t_userwise_insert_update_count set MD_updated_on=a.MD_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MD_updated_on from t_mother_delivery group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MI Created
update t_userwise_insert_update_count set MI_inserted_on=a.MI_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MI_insered_on from t_mother_infant group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MI Updated
update t_userwise_insert_update_count set MI_updated_on=a.MI_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MI_updated_on from t_mother_infant group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MP Created
update t_userwise_insert_update_count set MP_inserted_on=a.MP_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as MP_insered_on from t_mother_pnc group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total MP Updated
update t_userwise_insert_update_count set MP_updated_on=a.MP_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as MP_updated_on from t_mother_pnc group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Child
------------------------------------------Total CR Created
update t_userwise_insert_update_count set CR_inserted_on=a.CR_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as CR_insered_on from t_children_registration where CONVERT(date,Registration_Date)<>'1990-01-01' group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total CR Updated
update t_userwise_insert_update_count set CR_updated_on=a.CR_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as CR_updated_on from t_children_registration where CONVERT(date,Registration_Date)<>'1990-01-01' group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total CT Created
update t_userwise_insert_update_count set CT_inserted_on=a.CT_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as CT_insered_on from t_children_tracking group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total CT Updated
update t_userwise_insert_update_count set CT_updated_on=a.CT_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as CT_updated_on from t_children_tracking group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total CT Created
update t_userwise_insert_update_count set CM_inserted_on=a.CM_insered_on from 
(select Created_By,CONVERT(date,Created_On)as Created_On,COUNT(Registration_no) as CM_insered_on from t_children_tracking_medical group by Created_By,CONVERT(date,Created_On)) a
where t_userwise_insert_update_count.UserID = a.Created_By and t_userwise_insert_update_count.AsOnDate=a.Created_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate
------------------------------------------Total CM Updated
update t_userwise_insert_update_count set CM_updated_on=a.CM_updated_on from 
(select Updated_By,CONVERT(date,Updated_On)as Updated_On,COUNT(Registration_no) as CM_updated_on from t_children_tracking_medical group by Updated_By,CONVERT(date,Updated_On))a
where t_userwise_insert_update_count.UserID = a.Updated_By and t_userwise_insert_update_count.AsOnDate=a.Updated_On
and t_userwise_insert_update_count.AsOnDate=@RunningDate

delete from t_userwise_insert_update_count where UserID in(
select UserID from t_userwise_insert_update_count group by UserID having (sum([EC_insered_on])
+ sum([EC_updated_on])
+sum([ECT_insered_on])
+sum([ECT_updated_on])
+sum([MR_inserted_on])
+sum([MR_updated_on])
+sum([MM_inserted_on])
+sum([MM_updated_on])
+sum([MA_inserted_on])
+sum([MA_updated_on])
+sum([MD_inserted_on])
+sum([MD_updated_on]
)+sum([MI_inserted_on])
+sum([MI_updated_on]
)+sum([MP_inserted_on])
+sum([MP_updated_on])
+sum([CR_inserted_on])
+sum([CR_updated_on])
+sum([CT_inserted_on])
+sum([CT_updated_on])
+sum([CM_inserted_on])
+sum([CM_updated_on]))=0 )

end
end
