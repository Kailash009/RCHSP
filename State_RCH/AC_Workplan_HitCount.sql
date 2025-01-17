USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Workplan_HitCount]    Script Date: 09/26/2024 11:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[AC_Workplan_HitCount]
(@State_Code int=0,  
@District_Code int=0,  
@HealthBlock_Code int=0,  
@HealthFacility_Code int=0,  
@HealthSubFacility_Code int=0,
@Village_Code int=0,
@FinancialYr int, 
@Month_ID int=0 ,
@Year_ID int=0 ,
@FromDate date='',  
@ToDate date='' ,
@Category varchar(20) ='District'  ,
@Type int =1
)
as
begin

if(@Category='State')
begin
Select A.FPath as Fpath,A.Fname,B.Name,B.ID,isnull(X.HitCount,0)HitCount 
from
(Select Fname,FPath,1 as N  from dbo.Get_Fpath_Name() )A
left outer join
(Select DIST_NAME_ENG as Name,DIST_CD as ID,1 as N from TBL_DISTRICT) B on A.N=B.N
left outer join
(
select sum(HitCount) as HitCount,Fpath,District_Code as ID FROM t_LogUser a
where Ftype='workplan'
and (MonthID=@Month_ID or @Month_ID=0)
and (YearID=@Year_ID or @Year_ID=0)
group by Fpath,District_Code
) X on A.FPath=X.Fpath and B.ID=X.ID 




End
else if(@Category='District')
begin

Select A.FPath as Fpath,A.Fname,B.Name,B.ID,isnull(X.HitCount,0)HitCount  from
(Select Fname,FPath,1 as N  from dbo.Get_Fpath_Name()  )A
left outer join
(Select Block_Name_E as Name,BLOCK_CD as ID,1 as N from TBL_HEALTH_BLOCK 
where DISTRICT_CD=@District_Code
) B on A.N=B.N
left outer join
(
select sum(HitCount) as HitCount,Fpath,HealthBlock_Code as ID FROM t_LogUser a
where Ftype='workplan'
and (MonthID=@Month_ID or @Month_ID=0)
and (YearID=@Year_ID or @Year_ID=0)
and District_Code=@District_Code
group by Fpath,HealthBlock_Code
) X on A.FPath=X.Fpath and B.ID=X.ID 

End

else if(@Category='Block')
begin

Select A.FPath as Fpath,A.Fname,B.Name,B.ID,isnull(X.HitCount,0)HitCount  from
(Select Fname,FPath,1 as N  from dbo.Get_Fpath_Name()  )A
left outer join
(Select PHC_NAME as Name,PHC_CD as ID,1 as N from TBL_PHC
where BID=@HealthBlock_Code 
) B on A.N=B.N
left outer join
(
select sum(HitCount) as HitCount,Fpath,HealthFacility_Code as ID FROM t_LogUser a
where Ftype='workplan'
and (MonthID=@Month_ID or @Month_ID=0)
and (YearID=@Year_ID or @Year_ID=0)
and HealthBlock_Code=@HealthBlock_Code
group by Fpath,HealthFacility_Code
) X on A.Fpath=X.Fpath and B.ID=X.ID 


End
else if(@Category='PHC')
begin
Select A.FPath as Fpath,A.Fname,B.Name,B.ID,isnull(X.HitCount,0)HitCount  from
(Select Fname,FPath,1 as N  from dbo.Get_Fpath_Name() )A
left outer join
(Select SUBPHC_NAME_E as Name,SUBPHC_CD as ID,1 as N from TBL_SUBPHC where (PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)
 ) B on A.N=B.N
left outer join
(
select sum(HitCount) as HitCount,Fpath,HealthSubFacility_Code as ID FROM t_LogUser a
where Ftype='workplan'
and (MonthID=@Month_ID or @Month_ID=0)
and (YearID=@Year_ID or @Year_ID=0)
and HealthFacility_Code=@HealthFacility_Code
group by Fpath,HealthSubFacility_Code
) X on A.Fpath=X.Fpath and B.ID=X.ID 

End
END



