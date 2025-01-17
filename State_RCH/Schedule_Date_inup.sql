USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Date_inup]    Script Date: 09/26/2024 12:18:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/**
tp_mother_flat_Inup  '2022-06-16','2022-06-16'
Schedule_Date_inup '2022-09-27','2022-09-27'
Schedule_Date_inup '09/30/2019','12/30/2019'
*/
ALTER procedure  [dbo].[Schedule_Date_inup]
(@FromDate as Date
,@ToDate as Date
)
as
begin

truncate table t_Schedule_Date_Previous

-----------------------------EC----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[EC_Registration_date],[Created_On],[Updated_On],[EC_Table])
select a.[Registration_No],a.[Case_No],date_regis [EC_Registration_date],a.Created_On,a.Updated_On,1 from t_eligibleCouples a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
-------------------old case
/*
Insert into [t_eligibleCouples_Status]([Registration_no],[MAX_Case_no],[Eligible],[Status],[InEligility_FinYear],[IP_address]
,[Created_By],[Created_On])
Select a.Registration_no,a.Case_No,a.Eligible,a.Status,0,a.IP_address,a.Created_By,a.Created_On 
from t_eligibleCouples a
left outer join [t_eligibleCouples_Status] b on a.Registration_no=b.Registration_no --and a.Case_No=1
where CONVERT(date,a.Created_On) between @FromDate and @ToDate  and a.Case_no=1  
and  b.Registration_no is null


update [t_eligibleCouples_Status] set [MAX_Case_no]=X.CaseNo,[Eligible]=X.Eligible,[Status]=X.[Status],Updated_By=X.Updated_By,Updated_On=X.Updated_On
from
(
Select  A.Registration_no,CaseNo,B.Eligible,B.Status,B.Updated_By,Updated_On
from 
(Select Registration_no,Max(Case_No) as CaseNo from t_eligibleCouples  a
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by Registration_no
) A
inner join
t_eligibleCouples B on A.Registration_no=B.Registration_no and a.CaseNo=B.Case_no
)X
where [t_eligibleCouples_Status].Registration_no=X.Registration_no
*/
---------------new eligibleCouples_Status-------06/09/2019
Insert into [t_eligibleCouples_Status]([Registration_no],[MAX_Case_no],ID_no,[Eligible],[Status],[Reason],[InEligility_FinYear],[IP_address]
,[Created_By],[Created_On])
Select a.Registration_no,a.Case_No,a.ID_no,
case when a.Eligible='I' then 'P' else a.Eligible end as Eligible,
case when a.Eligible='E' then 'A' when a.Eligible='I' then 'A' when a.Eligible='J' then 'A' end as status,
case when a.Eligible='E' then 'E' else null end as reason,
0,a.IP_address,a.Created_By,a.Created_On
from t_eligibleCouples a
left outer join [t_eligibleCouples_Status] b on a.Registration_no=b.Registration_no and a.Case_No=1
where CONVERT(date,a.Created_On) between @FromDate and @ToDate  and a.Case_no=1  
and 
 b.Registration_no is null
 
 /*
---not required now as it has been written in data entry SP too-------------------------------------------------Update Query----------------------------------------------------------------------
update [t_eligibleCouples_Status] set [MAX_Case_no]=X.CaseNo,[Eligible]=X.Eligible,[Status]=X.status, Reason=x.reason, Updated_By=X.Updated_By,Updated_On=X.Updated_On
from
(
Select  A.Registration_no,CaseNo,
case when B.Eligible='I' then 'P' else B.Eligible end as Eligible,
case when B.Eligible='E' then 'A' when B.Eligible='I' then 'A' when B.Eligible='J' then 'A' end as status,
case when B.Eligible='E' then 'E' else null end as reason,
B.Updated_By,Updated_On
from 
(Select Registration_no,Max(Case_No) as CaseNo from t_eligibleCouples  a
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by Registration_no
) A
inner join
t_eligibleCouples B on A.Registration_no=B.Registration_no and a.CaseNo=B.Case_no
)X
where [t_eligibleCouples_Status].Registration_no=X.Registration_no
*/

---------------------------------------------------------
/*  
------------Manual EC and next levels
insert into t_Schedule_Date_Previous(Registration_No,Case_no,EC_Registration_date,Created_On,Updated_On,EC_Table,ECT_Table,MR_Table,MM_Table,MANC_Table,MD_Table,MINFANT_Table,MPNC_Table,CPNC_Table,MV_Table )
select r.Registration_No,r.Case_no,date_regis,r.Created_On,r.Updated_On,1,1,1,1,1,1,1,1,1,1 from t_eligibleCouples r  
left outer join t_Schedule_Date_Previous b on r.Registration_no=b.Registration_no and r.Case_no=b.Case_no 
where  (CONVERT(date,r.Schedule_updated_On) between @FromDate and @ToDate) and b.[Registration_No] is null
*/
-----------------registration update--GJ
insert into t_Schedule_Date_Previous(Registration_No,Case_no,Mother_Registration_date,Created_On,Updated_On,MR_Table,MM_Table,MANC_Table,MD_Table,MINFANT_Table,MPNC_Table,CPNC_Table,MV_Table )
select r.Registration_No,r.Case_no,r.Registration_Date,r.Created_On,r.Updated_On,1,1,1,1,1,1,1,1 from t_mother_registration r  
left outer join t_Schedule_Date_Previous b on r.Registration_no=b.Registration_no and r.Case_no=b.Case_no 
where  (CONVERT(date,r.Schedule_updated_On) between @FromDate and @ToDate) and b.[Registration_No] is null
/*
------------Manual delivery and next levels
insert into t_Schedule_Date_Previous(Registration_No,Case_no,Created_On,Updated_On,EC_Table,ECT_Table,MR_Table,MM_Table,MANC_Table,MD_Table,MINFANT_Table,MPNC_Table,CPNC_Table,MV_Table )
select r.Registration_No,r.Case_no,r.Created_On,r.Updated_On,1,1,1,1,1,1,1,1,1,1 from t_mother_delivery r 
left outer join t_Schedule_Date_Previous b on r.Registration_no=b.Registration_no and r.Case_no=b.Case_no  
 where  (CONVERT(date,r.Schedule_updated_On) between @FromDate and @ToDate) 
and b.[Registration_No] is null
 


*/

-----------------------------ECT----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],ECT_Table)
select a.[Registration_No],a.[Case_No],GETDATE(),1 from t_eligible_couple_tracking a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No],a.[Case_No]


update  t_Schedule_Date_Previous set ECT_Table=1,[Updated_On]=X.Updated_On from 
(
select a.[Registration_No],a.[Case_No],a.Updated_On from t_eligible_couple_tracking a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
) X

where  t_Schedule_Date_Previous.[Registration_No]=X.Registration_no 
and t_Schedule_Date_Previous.Case_no=X.Case_no


-----------------------------MotherReg through EC----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Mother_Registration_date],[Created_On],[Updated_On],Ec_Table)
select a.[Registration_No],a.[Case_No],a.Registration_Date,a.Created_On,a.Updated_On,1 from t_mother_registration a (NOLOCK)
left outer join t_Schedule_Date_Previous b (NOLOCK) on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Updated_On) between @FromDate and @ToDate)) and b.[Registration_No] is null and a.Registration_Date='1990-01-01'


update t_Schedule_Date_Previous set [Mother_Registration_date]=X.Registration_Date,ec_Table=1 from
(
select a.[Registration_No],a.[Case_No],a.Registration_Date from t_mother_registration a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Updated_On) between @FromDate and @ToDate)) and a.Registration_Date='1990-01-01'
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no


-----------------------------MotherReg----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Mother_Registration_date],[Created_On],[Updated_On],MR_Table)
select a.[Registration_No],a.[Case_No],a.Registration_Date,a.Created_On,a.Updated_On,1 from t_mother_registration a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null and a.Registration_Date<>'1990-01-01'


update t_Schedule_Date_Previous set [Mother_Registration_date]=X.Registration_Date,MR_Table=1 from
(
select a.[Registration_No],a.[Case_No],a.Registration_Date from t_mother_registration a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and a.Registration_Date<>'1990-01-01'
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no


-----------------------------Mothermedical----------------------------------------------------------------

insert into t_Schedule_Date_Previous([Registration_No],[Case_No],Mother_LMP_date,Mother_EDD_date,[Created_On],[Updated_On],MM_Table)
select a.[Registration_No],a.[Case_No],a.LMP_Date,a.EDD_Date,a.Created_On,a.Updated_On,1 from t_mother_medical a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null

update t_Schedule_Date_Previous set Mother_LMP_date=X.LMP_Date,Mother_EDD_date=X.EDD_Date,MM_Table=1 from
(
select a.[Registration_No],a.[Case_No],a.LMP_Date,a.EDD_Date,a.Created_On,a.Updated_On from t_mother_medical a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no





-----------------------------MotherANC----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],MANC_Table)
select a.[Registration_No],a.[Case_No],GETDATE() as D,1 from t_mother_anc a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No],a.[Case_No]

update t_Schedule_Date_Previous set MANC_Table=1 from
(
select a.[Registration_No],a.[Case_No],GETDATE() as D from t_mother_anc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.[Registration_No],a.[Case_No]
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no





-----------------------------MotherDelivery----------------------------------------------------------------




insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],[Updated_On],Mother_DEL_date,MD_Table)
select a.[Registration_No],a.[Case_No],a.Created_On,a.Updated_On,a.Delivery_date,1 from t_mother_delivery a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null

update t_Schedule_Date_Previous set Mother_DEL_date=X.Delivery_date,MD_Table=1 from
(
select a.[Registration_No],a.[Case_No],a.Delivery_date from t_mother_delivery a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no



-----------------------------MotherPNC----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],MPNC_Table)
select a.[Registration_No],a.[Case_No],GETDATE(),1 from t_mother_pnc a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No],a.[Case_No]


update t_Schedule_Date_Previous set MPNC_Table=1 from
(
select a.[Registration_No],a.[Case_No] from t_mother_pnc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.[Registration_No],a.[Case_No]
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no




-----------------------------MotherInfant----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],MINFANT_Table)
select a.[Registration_No],a.[Case_No],GETDATE(),1 from t_mother_infant a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No],a.[Case_No]


update t_Schedule_Date_Previous set MINFANT_Table=1 from
(
select a.[Registration_No],a.[Case_No] from t_mother_infant a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.[Registration_No],a.[Case_No]
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no

-----------------------------ChildPNC----------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],CPNC_Table)
select a.[Registration_No],a.[Case_No],GETDATE(),1 from t_child_pnc a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No],a.[Case_No]

update t_Schedule_Date_Previous set CPNC_Table=1 from
(
select a.[Registration_No],a.[Case_No] from t_child_pnc a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.[Registration_No],a.[Case_No]
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no
and t_Schedule_Date_Previous.Case_No=X.Case_no





-----------------------------ChildRegistration----------------------------------------------------------------


truncate table t_Schedule_Date_Child_Previous
insert into t_Schedule_Date_Child_Previous(Registration_No,Registration_date,Birthdate_date,Created_On,Updated_On,CR_Table)
select Registration_No,Registration_date,Birth_Date,Created_On,Updated_On,1 from t_children_registration a
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))

------------Manual Child and next levels

insert into t_Schedule_Date_Child_Previous(Registration_No,Registration_date,Birthdate_date,Created_On,Updated_On,CR_Table,CT_Table,CTM_Table,CPNC_Table,CI_Table,CV_Table )
select r.Registration_No,r.Registration_date,r.Birth_Date,r.Created_On,r.Updated_On,1,1,1,1,1,1 from t_children_registration r (nolock) 
left outer join t_Schedule_Date_Child_Previous b on r.Registration_no=b.Registration_no  where
(CONVERT(date,r.Schedule_updated_On) between @FromDate and @ToDate) and b.Registration_No is null

/**/


-----------------------------ChildPNC----------------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CPNC_Table)
select a.InfantRegistration,GETDATE(),1 from t_child_pnc a
left outer join t_Schedule_Date_Child_Previous b on a.InfantRegistration=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.InfantRegistration

update t_Schedule_Date_Child_Previous set CPNC_Table=1 from
(
select a.InfantRegistration as Registration_no from t_child_pnc a
inner join t_Schedule_Date_Child_Previous b on a.InfantRegistration=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.InfantRegistration
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Registration_no




-----------------------------ChildTracking----------------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CT_Table)
select a.[Registration_No],GETDATE(),1 from t_children_tracking a
left outer join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No]

update t_Schedule_Date_Child_Previous set CT_Table=1 from
(
select a.[Registration_No] from t_children_tracking a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.[Registration_No]
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Registration_no
------------------------------301019
-----------------------------ChildTracking log----------------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CT_Table)
select a.[Registration_No],GETDATE(),1 from t_children_tracking_log a
left outer join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Del_Update_date) between @FromDate and @ToDate) )
and b.[Registration_No] is null
group by a.[Registration_No]

update t_Schedule_Date_Child_Previous set CT_Table=1 from
(
select a.[Registration_No] from t_children_tracking_log a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Del_Update_date) between @FromDate and @ToDate) )
group by a.[Registration_No]
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Registration_no
----------------------------------Childtrackingmedical------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CTM_Table)
select a.[Registration_No],GETDATE(),1 from t_children_tracking_medical a
left outer join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.[Registration_No] is null
group by a.[Registration_No]

update t_Schedule_Date_Child_Previous set CTM_Table=1 from
(
select a.[Registration_No] from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Registration_no

-------------------------------------------------Infant_mother-------------------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CI_Table,CT_Table)
select a.Infant_Id,GETDATE(),1,1 from t_mother_infant a
left outer join t_Schedule_Date_Child_Previous b on a.Infant_Id=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.Registration_No is null

update t_Schedule_Date_Child_Previous set CI_Table=1,CT_Table=1 from
(
select a.Infant_Id from t_mother_infant a
inner join t_Schedule_Date_Child_Previous b on a.Infant_Id=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.Infant_Id
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Infant_Id

-------------------------------------------------Child Verification-------------------------------------------------------------------
insert into t_Schedule_Date_Child_Previous([Registration_No],[Created_On],CV_Table)
select a.Registration_no,GETDATE(),1 from t_ChildEntry_Verification a
left outer join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.Registration_no is null

update t_Schedule_Date_Child_Previous set CV_Table=1 from
(
select a.Registration_no from t_ChildEntry_Verification a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_no 
where ((CONVERT(date,a.Created_On) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
group by a.Registration_no
)X
where t_Schedule_Date_Child_Previous.[Registration_No]=X.Registration_no


-------------------------------------------------Mother Verification-------------------------------------------------------------------
insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],MV_Table)
select a.Registration_no,a.Case_no,GETDATE(),1 from t_MotherEntry_Verification a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no  and a.Case_no=b.case_no
where ((CONVERT(date,a.VerifyDt) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
and b.Registration_no is null

update t_Schedule_Date_Previous set MV_Table=1 from
(
select a.Registration_no,a.Case_no from t_MotherEntry_Verification a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_No
where ((CONVERT(date,a.VerifyDt) between @FromDate and @ToDate) or  (CONVERT(date,a.Updated_On) between @FromDate and @ToDate))
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no and t_Schedule_Date_Previous.Case_No=X.Case_no

-------------------CCID
declare @state_code tinyint,
@db as char(6) 
select @db= DB_NAME()
select @state_code= Substring(@db,5,2)

insert into t_Schedule_Date_Previous([Registration_No],[Case_No],[Created_On],ccID_table)
select a.[Registration_No],0 [Case_No],GETDATE(),1 from (
select distinct uhid as Registration_no,cast(exec_date as date) Created_On,cast(updated_on as date) Updated_On from 
RCH_Web_Services..care_context_link_request where State_code=@state_code and 
((cast(exec_date as date) between @FromDate and @ToDate) or  (cast(updated_on as date) between @FromDate and @ToDate))
) a
left outer join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no   
where  b.[Registration_No] is null group by a.[Registration_No]


update t_Schedule_Date_Previous set ccID_table=1 from
(
select a.[Registration_No] from (
select distinct uhid as Registration_no,cast(exec_date as date) Created_On,cast(updated_on as date) Updated_On from 
RCH_Web_Services..care_context_link_request where State_code=@state_code and 
((cast(exec_date as date) between @FromDate and @ToDate) or  (cast(updated_on as date) between @FromDate and @ToDate))
) a
inner join t_Schedule_Date_Previous b on a.Registration_no=b.Registration_no   

group by a.[Registration_No]
)X
where t_Schedule_Date_Previous.[Registration_No]=X.Registration_no




if(day(getdate())=1)
begin
Declare @Ldate as date,@Fdate as Date
--set @Fdate=cast(year(getdate()) as varchar)+'-'+cast(month(dateadd(month,1,getdate())) as varchar)+'-01'
set @Fdate=cast(year(DATEADD(MONTH, 1, getdate())) as varchar)+'-'+cast(month(dateadd(month,1,getdate())) as varchar)+'-01'
set @Ldate=convert(Date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@Fdate)+1,0)))
if not exists(select * from m_Month_YearMaster where Datecheck=@Ldate)
begin
insert into  m_Month_YearMaster(Month_ID,YEar_ID,DateCheck,Fin_Yr,IsRun,CombinedDate)
select MONTH(@Fdate),Year(@Fdate),@Ldate,(case when MONTH(@Fdate)>3 then Year(@Fdate) else Year(@Fdate)-1 end),1,convert(bigint,cast(Year(@Fdate) as varchar)+(case when month(@Fdate)<10 then '0'+cast(month(@Fdate) as varchar) else cast(month(@Fdate) as varchar) end)+cast(day(@Ldate) as varchar))
end
end
end
-------------------------------

