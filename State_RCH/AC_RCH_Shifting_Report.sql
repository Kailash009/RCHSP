USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_RCH_Shifting_Report]    Script Date: 09/26/2024 11:53:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*       
  create index AC_PWindx on Scheduled_AC_PW_PHC_SubCenter_village_Month(fin_yr,filter_type) include (State_Code,HealthFacility_Code,HealthSubFacility_Code,Village_Code)     
  create index AC_chindx on Scheduled_AC_Child_PHC_SubCenter_Village_Month(fin_yr,filter_type) include (State_Code,HealthFacility_Code,HealthSubFacility_Code,Village_Code)    
    create index AC_ecindx on Scheduled_AC_EC_PHC_SubCenter_Village_Month(fin_yr,filter_type) include (State_Code,HealthFacility_Code,HealthSubFacility_Code,Village_Code)    
    
[AC_RCH_Shifting_Report] 29,0,0,0,4730,0,2019,0,0,'','','Subcentre'     
[AC_RCH_Shifting_Report] 29,0,0,3105,0,0,2019,0,0,'','','PHC'     
[AC_RCH_Shifting_Report_New_14122020] 30,1,1,0,0,0,2019,0,0,'','','Block'     
[AC_RCH_Shifting_Report_New_14122020] 30,2,0,0,0,0,2019,0,0,'','','District'     
[AC_RCH_Shifting_Report_New_14122020] 30,0,0,0,0,0,2019,0,0,'','','State'     
    
    
[AC_RCH_Shifting_Report] 23,8,7,8,63,0,2019,0,0,'','','Subcentre'     
[AC_RCH_Shifting_Report] 23,8,7,8,0,0,2019,0,0,'','','PHC'     
[AC_RCH_Shifting_Report] 23,8,7,0,0,0,2019,0,0,'','','Block'     
[AC_RCH_Shifting_Report] 23,8,0,0,0,0,2019,0,0,'','','District'     
[AC_RCH_Shifting_Report] 23,0,0,0,0,0,2019,0,0,'','','State'     
    
[AC_RCH_Shifting_Report] 29,18,0,0,0,0,2019,0,0,'','','District'     
[AC_RCH_Shifting_Report] 29,0,0,0,0,0,2019,0,0,'','','State'     
    
[AC_RCH_Shifting_Report] 29,0,0,0,9169,0,2020,0,0,'','','Subcentre'     
[AC_RCH_Shifting_Report] 29,0,0,2088,0,0,2020,0,0,'','','PHC'     
    
*/      
ALTER proc [dbo].[AC_RCH_Shifting_Report]      
(      
@State_Code int=0,        
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
@Category varchar(20) ='District'        
)      
as      
begin      
declare @daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int -- up to current month      
      
 set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)      
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)      
 set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)      
       
--if(@Category='National')        
--begin        
-- exec RCH_Reports.dbo.AC_RCH_Daily_Review @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,        
-- @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category      
--end      
      
     
if(@Category='State')        
begin        
select StateID as ParentID,StateName as ParentName,A.DIST_CD as ChildID,DIST_NAME_ENG as ChildName,F.Village_Population_Status      
,isnull(A.Village_Population,0) as Village_Population      
,isnull(  e.Total_EC_Registered ,0) as EC_Entry,      
 isnull(A.Estimated_Mother,0) as Estimated_PW        
, isnull(A.Estimated_Infant,0)  as Estimated_Infant        
, isnull(A.Estimated_EC,0)  as Estimated_EC     
,isnull( RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),       
@FinancialYr) ,0) as Prorata      
,isnull(RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),     
@FinancialYr),0) as TotalProrata    
 ,isnull(C.Mother_Entry,0) as Mother_Entry      
      
 ,isnull(D.Child_Entry,0) as Child_Entry      
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered      
 ,ISNULL(F.[Total_village]  ,0) as [Total_Village]      
 ,@daysPast as daysPast      
 ,@Daysinyear as DaysinYear      
 ,isnull(F.Village ,0) as Village      
 ,isnull(F.Total_Profile_Not_Entered ,0) as Total_Profile_Not_Entered     
  from (      
 (select  a.StateID,a.DIST_CD,c.StateName ,a.DIST_NAME_ENG     
 ,b.V_Population as Village_Population      
 ,b.Estimated_EC as Estimated_EC      
 ,b.Estimated_Mother as Estimated_Mother      
 ,b.Estimated_Infant as Estimated_Infant      
 ,b.Total_ActiveVillage--Added on 06032018      
 from TBL_DISTRICT a (nolock)     
 left outer join Estimated_Data_District_Wise b(nolock) on a.Dist_Cd=b.District_Code      
 left outer join TBL_STATE c(nolock) on a.StateID=c.StateID  --order by VILLAGE_CD      
 where  b.Financial_Year=@FinancialYr and isnull(b.Hierarchy_isDeactive,0)=0   
 ) A      
 left outer join      
(      
select  District_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_District_Wise (nolock)      
where Financial_Year=@FinancialYr-1 and isnull(Hierarchy_isDeactive,0)=0       
) X      
on X.District_Code=A.DIST_CD      
    
 left outer join      
 (select Sum(p1.Mother_Entry)as Mother_Entry,State_Code , p1.DCode from    
 (select Sum(PW_Registered)as Mother_Entry,State_Code , p.DCode        
 from Scheduled_AC_PW_phc_subcenter_village_month t (nolock)     
   left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID     
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code      
   left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )   =p.PID            
 where Fin_Yr=@FinancialYr        
 --and (village_code in (select vcode from Health_SC_Village C(nolock)     
 --WHERE C.SID  = t.HealthSubFacility_Code)  or t.Village_Code =0)    
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1       
 group by State_Code , p.DCode    
 --union    
 --select Sum(PW_Registered)as Mother_Entry,State_Code , p.DCode        
 --from Scheduled_AC_PW_phc_subcenter_village_month t (nolock)     
 -- -- inner join Health_SubCentre s on t.HealthSubFacility_Code =s.SID       
 --    inner join Health_phc p(nolock)  on t.HealthFacility_Code    =p.PID            
 --where Fin_Yr=@FinancialYr        
 ----and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 --and Filter_Type=1   and t.HealthSubFacility_Code =0 and t.Village_Code =0    
 --group by State_Code , p.DCode    
 ) P1 group by p1.State_Code, p1.DCode    
     
  ) C on C.State_Code=A.StateID and C.DCode =A.DIST_CD      
 left outer join      
 (select Sum(I1.Child_Entry)as Child_Entry,State_Code , I1.DCode  from     
 (select Sum(Infant_Registered)as Child_Entry,State_Code , p.DCode       
 from Scheduled_AC_CHILD_phc_subcenter_village_month t (nolock)     
 left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
 left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID    
 left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code           
 where Fin_Yr=@FinancialYr       
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1   
 group by State_Code , p.DCode       
 --union    
 --select Sum(Infant_Registered)as Child_Entry,State_Code , p.DCode       
 --from Scheduled_AC_CHILD_phc_subcenter_village_month t (nolock)     
 ----  inner join Health_SubCentre s on t.HealthSubFacility_Code =s.SID       
 --    inner join Health_phc p(nolock)  on t.HealthFacility_Code  =p.PID          
 --where Fin_Yr=@FinancialYr       
 ----and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 --and Filter_Type=1    and t.HealthSubFacility_Code =0 and t.Village_Code =0    
 --group by State_Code , p.DCode     
 )I1 group by I1.State_Code, I1.DCode    
 ) D on D.State_Code=A.StateID and D.DCode=A.DIST_CD      
 left outer join      
(      
select  State_Code,E1.DCode        
,SUM(E1.Total_EC_Registered) as Total_EC_Registered  from (    
select  State_Code,p.DCode        
,SUM(total_distinct_ec) as Total_EC_Registered        
from Scheduled_AC_EC_phc_subcenter_village_month t (nolock)     
left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID     
left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code       
where State_Code =@State_Code      
--and (District_Code=@District_Code or @District_Code=0)      
--and (Month_ID<=@Month_ID or @Month_ID=0)      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and Fin_Yr<=@FinancialYr     
and (Filter_Type=1)      
       
group by State_Code,p.DCode     
--union    
--select  State_Code,p.DCode        
--,SUM(total_distinct_ec) as Total_EC_Registered        
--from Scheduled_AC_EC_phc_subcenter_village_month t (nolock)     
--  -- inner join Health_SubCentre s on t.HealthSubFacility_Code =s.SID       
--     inner join Health_phc p(nolock)  on t.HealthFacility_Code   =p.PID        
--where State_Code =@State_Code      
----and (District_Code=@District_Code or @District_Code=0)      
----and (Month_ID<=@Month_ID or @Month_ID=0)      
--and (Year_ID<=@Year_ID or @Year_ID=0)      
--and (Filter_Type=1)      
--and Fin_Yr<=@FinancialYr    and t.HealthSubFacility_Code =0 and t.Village_Code =0    
--group by State_Code,p.DCode     
)E1 group by E1.State_Code, E1.DCode     
) E on A.StateID=E.State_Code and A.DIST_CD=E.DCode      
left outer join    
(    
select  State_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_District_Wise(nolock)      
where Financial_Year=@FinancialYr and isnull(Hierarchy_isDeactive,0)=0  
group by State_Code    
) XEC    
on XEC.State_Code=A.StateID    
left outer join    
(    
select  State_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_District_Wise(nolock)      
where Financial_Year=@FinancialYr-1 and isnull(Hierarchy_isDeactive,0)=0  
 group by State_Code    
) XE    
on XE.State_Code=A.StateID    
 left outer join      
    
(    
 select  State_Code     
,SUM(total_distinct_ec) as Total_EC_Registered_Pro     
from Scheduled_AC_EC_State_District_month (nolock)      
 where State_Code =@State_Code    
 and (District_Code=@District_Code or @District_Code=0)    
and Fin_Yr<=@FinancialYr     
--and (Year_ID<=@Year_ID or @Year_ID=0)    
and (Filter_Type=1)    
    
 group by State_Code    
 ) EP on A.StateID=EP.State_Code     
left outer join       
    
(     
 select State_Code , T.DIST_CD,isnull(V.Total_Village,0) Village , isnull(A.mapped_village,0) Total_village,     
  isnull(B.profile_entered,0) Total_Profile_Entered ,    
  isnull(A.mapped_village,0) - isnull(B.profile_entered,0) Total_Profile_Not_Entered    
     ,(case when A.mapped_village<> b.profile_entered then 'Not Completed' when b.profile_entered =0 then 'Not Completed' else 'Completed' end) as Village_Population_Status      
    
  from (    
   select a.StateID  as State_Code, c.StateName , a.DIST_CD  ,a.DIST_NAME_ENG    
     from TBL_District  a(nolock)     
     left outer join TBL_STATE c(nolock)  on a.StateID=c.StateID    
        ) T     
     Left Outer Join       
  (select a.DCode, COUNT(Distinct vcode ) as Total_village from VILLAGE  a(nolock)     
    group by a.DCode  ) V  on v.dcode = T.DIST_CD     
    Left Outer join    
     ( select b.DIST_CD   ,  COUNT(a.VCode ) as mapped_village from Health_SC_Village  a(nolock)      
   inner join TBL_SUBPHC b(nolock)  on a.SID = b.SUBPHC_CD     
   inner join Village v(nolock)  on a.VCode = v.VCode     
   where a.IsActive =1    
   group by b.DIST_CD   ) A ON  T.DIST_CD = A.DIST_CD    
   Left Outer Join    
   (select  district_code , COUNT(village_code) as profile_entered from t_villagewise_registry a(nolock)     
   inner join Health_SC_Village b(nolock)  on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID    
   inner join Village v(nolock)  on a.Village_code = v.VCode      
    and Finanacial_Yr = @FinancialYr  and b.IsActive = 1     
       
    group by District_code  ) B on T.DIST_CD = B.District_code    
    ) F on A.StateID=F.state_code  and A.DIST_CD= F.DIST_CD    
  )--order by ParentID, ChildID    
end      
else if(@Category='District')        
begin        
 select A.state_code, A.DISTRICT_CD as ParentID,District_Name as ParentName,BLOCK_CD as ChildID,Block_Name_E as ChildName,F.Village_Population_Status      
 ,isnull(A.Village_Population,0) as Village_Population      
 ,isnull(  e.Total_EC_Registered ,0) as EC_Entry,      
  isnull(A.Estimated_Mother,0)  as Estimated_PW        
,isnull(A.Estimated_Infant,0)  as Estimated_Infant        
 , isnull(A.Estimated_EC,0)  as Estimated_EC         
,isnull( RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),       
@FinancialYr) ,0) as Prorata      
,isnull( RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),     
@FinancialYr),0) as TotalProrata    
 ,isnull(C.Mother_Entry,0) as Mother_Entry      
 ,isnull(D.Child_Entry,0) as Child_Entry      
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered      
 ,ISNULL(F.[Total_Village],0) as [Total_Village]      
 ,@daysPast as daysPast      
 ,@Daysinyear as DaysinYear      
 ,'--' as Village      
 ,ISNULL(F.Total_Village,0)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered  --Added on 06032018      
  from (      
 (select c.State_Code , b.DISTRICT_CD,b.BLOCK_CD, a.DIST_NAME_ENG as District_Name,b.Block_Name_E,    
 c.V_Population as Village_Population      
 ,c.Estimated_EC as Estimated_EC      
 ,c.Estimated_Mother as Estimated_Mother      
 ,c.Estimated_Infant as Estimated_Infant      
 ,c.Total_ActiveVillage--Added on 06032018      
 from TBL_HEALTH_BLOCK b (nolock)      
 left outer join Estimated_Data_Block_Wise c(nolock)  on b.BLOCK_CD=c.HealthBlock_Code      
 inner join TBL_DISTRICT a(nolock)  on b.DISTRICT_CD=a.DIST_CD       
 where (b.DISTRICT_CD=@District_Code or @District_Code=0)   
 and c.Financial_Year=@FinancialYr  
 and isnull(c.Hierarchy_isDeactive,0)=0  
  
 ) A      
 left outer join      
(      
select  HealthBlock_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_Block_Wise(nolock)        
where Financial_Year=@FinancialYr-1 and isnull(Hierarchy_isDeactive,0)=0  
      
) X      
on X.HealthBlock_Code=A.BLOCK_CD      
    
 left outer join     
  (select Sum(P1.Mother_Entry)as Mother_Entry,P1.HealthBlock_Code as  HealthBlock_Code ,district_code from     
 (select Sum(PW_Registered)as Mother_Entry,p.BID  as  HealthBlock_Code,p.DCode as district_code       
 from Scheduled_AC_PW_PHC_SubCenter_village_Month t (nolock)     
   left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID      
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code     
    left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )   =p.PID        
 where Fin_Yr=@FinancialYr       
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1       
    
 group by p.DCode,p.BID     
     
--  union    
--  select   Sum(PW_Registered)as Mother_Entry,p.BID  as  HealthBlock_Code,p.DCode as district_code     
--    from Scheduled_AC_PW_PHC_SubCenter_village_Month t (nolock)    
----   Left Outer  join Health_SubCentre s (nolock) on t.HealthSubFacility_Code =s.SID      
--     inner join Health_phc p (nolock) on t.HealthFacility_Code  =p.PID     
-- where Fin_Yr=@FinancialYr      
-- --and (Month_ID =@Month_ID or @Month_ID=0)     
-- and (Year_ID =@Year_ID or @Year_ID=0)     
-- and Filter_Type=1   and    
-- HealthSubFacility_Code = 0 and Village_Code =0    
-- group by p.DCode, p.BID     
 )P1 group by P1.district_code, P1.HealthBlock_Code    
     
 ) C on C.HealthBlock_Code=A.BLOCK_CD  and C.district_code=A.DISTRICT_CD    
     
 left outer join (    
 select Sum(I1.Child_Entry)as Child_Entry, I1.HealthBlock_Code  as  HealthBlock_Code ,district_code from    
      
 (select Sum(Infant_Registered)as Child_Entry, p.BID  as  HealthBlock_Code, p.DCode as district_code       
 from Scheduled_AC_Child_PHC_SubCenter_village_Month t (nolock)     
   left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
   left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID     
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code       
 where Fin_Yr=@FinancialYr       
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1       
  group by p.DCode, p.BID     
 --union    
 -- select Sum(Infant_Registered)as Child_Entry, p.BID  as  HealthBlock_Code,p.DCode as district_code     
     
 --from Scheduled_AC_Child_PHC_SubCenter_village_Month t (nolock)    
 ----  Left Outer  join Health_SubCentre s (nolock) on t.HealthSubFacility_Code =s.SID      
 --    inner join Health_phc p (nolock) on t.HealthFacility_Code  =p.PID     
 --where Fin_Yr=@FinancialYr      
 ----and (Month_ID =@Month_ID or @Month_ID=0)     
 --and (Year_ID =@Year_ID or @Year_ID=0)     
 --and Filter_Type=1   and    
 --HealthSubFacility_Code = 0 and Village_Code =0    
 --group by p.DCode , p.BID    
     
  )I1 group by I1.district_code ,I1.HealthBlock_Code    
     
 ) D on  D.HealthBlock_Code=A.BLOCK_CD  and D.district_code=A.DISTRICT_CD    
    left outer join      
(      
 select  E1.State_code, E1.HealthBlock_Code   as  HealthBlock_Code,district_code  , Sum(E1.Total_EC_Registered)as Total_EC_Registered from    
(    
 select  State_Code,p.BID  as  HealthBlock_Code ,p.DCode as district_code     
,SUM(total_distinct_ec) as Total_EC_Registered        
                 
   from Scheduled_AC_EC_PHC_SubCenter_village_Month t (nolock)     
   left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
   left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )   =p.PID      
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code       
 where State_Code =@State_Code      
 --and (District_Code=@District_Code or @District_Code=0)      
    
and (Year_ID<=@Year_ID or @Year_ID=0)    
  and Fin_Yr<=@FinancialYr    
and (Filter_Type=1)       
     
  group by State_Code,p.DCode ,  p.BID        
      
--   union    
--  select  State_Code, p.BID  as  HealthBlock_Code,p.DCode as district_code  , Sum(total_distinct_ec)as Total_EC_Registered    
--    from Scheduled_AC_EC_PHC_SubCenter_village_Month t (nolock)    
----   Left Outer  join Health_SubCentre s (nolock) on t.HealthSubFacility_Code =s.SID      
--     inner join Health_phc p (nolock) on t.HealthFacility_Code  =p.PID     
-- where Fin_Yr=@FinancialYr      
-- --and (Month_ID =@Month_ID or @Month_ID=0)     
-- and (Year_ID =@Year_ID or @Year_ID=0)     
-- and Filter_Type=1   and    
-- HealthSubFacility_Code = 0 and Village_Code =0    
-- group by State_Code,p.DCode ,p.BID     
)E1 group by State_code,E1.district_code, E1.HealthBlock_Code    
 )E on    A.BLOCK_CD=E.HealthBlock_Code   and A.DISTRICT_CD=E.district_code     
 left outer join    
(    
select  District_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Block_Wise(nolock)      
where Financial_Year=@FinancialYr and isnull(Hierarchy_isDeactive,0)=0  
group by District_Code    
) XEC    
on XEC.District_Code=A.DISTRICT_CD    
left outer join    
(    
select  District_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Block_Wise (nolock)     
where Financial_Year=@FinancialYr-1 and isnull(Hierarchy_isDeactive,0)=0 group by District_Code    
) XE    
on XE.District_Code=A.DISTRICT_CD    
     
   left outer join    
(    
 select SUM(total_distinct_ec) as Total_EC_Registered_Pro   , a.State_Code     
from Scheduled_AC_EC_District_Block_Month a (nolock)       
inner join  Estimated_Data_Block_Wise b (nolock) on a.HealthBlock_Code  =b.HealthBlock_Code     
 where --HealthSubFacility_Code =287      
       
 --(Year_ID<=@Year_ID  or @Year_ID =0) and     
 (Filter_Type=1)      
and Fin_Yr<=@FinancialYr    and   ((a.HealthBlock_Code  = 0 and a.District_Code  =@District_Code )           
   OR (a.HealthBlock_Code != 0 ) )    
 and b.District_Code = @District_Code  and b.Financial_Year = @FinancialYr   
 and isnull(b.Hierarchy_isDeactive,0)=0     
 group by a.State_Code     
 ) EP   on A.State_Code  = EP.State_Code     
      
 left outer join       
 ( select State_Code, T.District_CD, T.HealthBlock_Code    
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered    
 ,ISNULL(A.Total_mapped_village ,0) as [Total_Village]    
 ,isnull(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered     
 ,isnull(V.Total_Village,0) as Village    
  ,(case when A.Total_mapped_village <> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end) as Village_Population_Status      
    
  from (    
    
   select StateID  as State_Code,a.DISTRICT_CD ,b.DIST_NAME_ENG, a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
  from TBL_Health_Block  a(nolock)     
     inner join TBL_District  b(nolock)  on a.DISTRICT_CD =b.DIST_CD    
  and  a.DISTRICT_CD=@District_Code  ) T     
  Left Outer Join     
(select a.DIST_CD, c.BLOCK_CD   , COUNT(distinct VILLAGE_CD ) as Total_village from TBL_VILLAGE a(nolock)     
  inner join TBL_PHC b(nolock)  on a.PHC_CD = b.PHC_CD     
  inner join TBL_HEALTH_BLOCK c(nolock)  on  b.BID =c.BLOCK_CD      
  group by a.DIST_CD , c.BLOCK_CD   ) V  on v.DIST_CD = T.DISTRICT_CD and  v.BLOCK_CD = T.HealthBlock_Code    
  Left Outer join    
   ( select c.DIST_CD   , c.bid as Health_block_code ,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a (nolock)     
 inner join TBL_SUBPHC b(nolock)  on a.SID = b.SUBPHC_CD     
 inner join TBL_PHC c(nolock)  on c.PHC_CD = b.PHC_CD      
 inner join Village v(nolock)  on a.VCode = v.VCode     
 where a.IsActive =1    
 group by c.DIST_CD , c.BID   ) A ON  T.HealthBlock_Code = A.Health_block_code      
 Left Outer Join    
 (select  district_code ,healthblock_code, COUNT(village_code) as Total_profile_entered from t_villagewise_registry a(nolock)     
 inner join Health_SC_Village b(nolock)  on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID    
  and Finanacial_Yr = @FinancialYr  and b.IsActive = 1     
  inner join TBL_HEALTH_BLOCK  c(nolock)  on c.BLOCK_CD  = a.HealthBlock_code     
  inner join Village v(nolock)  on a.Village_code = v.VCode      
  group by District_code , HealthBlock_code    ) B on T.HealthBlock_Code = B.HealthBlock_code     
) F on F.DISTRICT_CD= A.DISTRICT_CD and F.HealthBlock_Code= A.BLOCK_CD    
 )  --order by ParentID, ChildID     
end      
else if(@Category='Block')        
begin        
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName      
 ,Village_Population_Status      
 ,isnull(A.Village_Population,0) as Village_Population      
 ,isnull(  e.Total_EC_Registered ,0) as EC_Entry,      
  isnull(A.Estimated_Mother,0)  as Estimated_PW        
,isnull(A.Estimated_Infant,0)  as Estimated_Infant        
 ,isnull(A.Estimated_EC,0)  as Estimated_EC         
,isnull( RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),       
@FinancialYr) ,0) as Prorata      
,isnull(  RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),     
@FinancialYr) ,0) as TotalProrata    
 ,isnull(C.Mother_Entry,0) as Mother_Entry      
 ,isnull(D.Child_Entry,0) as Child_Entry      
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered      
 ,ISNULL(F.[Total_Village],0) as [Total_Village]      
 ,@daysPast as daysPast      
 ,@Daysinyear as DaysinYear      
 ,'--' as Village      
 ,ISNULL(F.Total_Village,0)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered  --Added on 06032018      
  from (      
 (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name    
 ,c.V_Population as Village_Population      
 ,c.Estimated_EC as Estimated_EC      
 ,c.Estimated_Mother as Estimated_Mother      
 ,c.Estimated_Infant as Estimated_Infant      
 ,c.Total_ActiveVillage--Added on 06032018      
     from TBL_PHC  a(nolock)       
     inner join TBL_HEALTH_BLOCK b(nolock)  on a.BID=b.BLOCK_CD      
     inner join Estimated_Data_PHC_Wise c(nolock)  on a.PHC_CD=c.HealthFacility_Code      
  where c.Financial_Year=@FinancialYr       
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)   
  and isnull(c.Hierarchy_isDeactive,0)=0     
    
 )  A      
 left outer join      
(      
select  HealthFacility_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_PHC_Wise (nolock)       
where Financial_Year=@FinancialYr-1 and isnull(Hierarchy_isDeactive,0)=0     
) X      
on X.HealthFacility_Code=A.HealthFacility_Code      
 left outer join      
 ( select m1.PID  , SUM(m1.Mother_Entry ) as Mother_Entry,BID from     
    
 (select  isnull(s.pid,HealthFacility_Code ) PID    ,Sum(PW_Registered)as Mother_Entry,p.BID    
 from Scheduled_AC_PW_PHC_SubCenter_Village_Month t (nolock)     
     left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
  left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code    
     left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID      
 where Fin_Yr=@FinancialYr       
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1       
 group by p.BID,isnull(s.pid,HealthFacility_Code )    
-- union    
-- select  t.HealthFacility_Code  as PID,p.BID,    
--SUM(PW_Registered) as Mother_Entry        
                 
--   from Scheduled_AC_PW_PHC_SubCenter_Village_Month t (nolock)    
--   left outer join Health_PHC p(nolock)  on p.PID=t.HealthFacility_Code    
    
--   where t.HealthSubFacility_Code =0 and Fin_Yr=@FinancialYr     
--    and (Year_ID =@Year_ID or @Year_ID=0)      
-- and Filter_Type=1     
--   group by State_Code,p.BID,t.HealthFacility_Code    
   )m1 group by m1.BID,m1.PID    
 ) C on  C.pid=A.HealthFacility_Code and C.BID=a.HealthBlock_Code     
 left outer join      
     
 (     
select  e1.PID  , SUM(e1.Child_Entry ) as Child_Entry,BID from     
    
 (select  isnull(s.pid,HealthFacility_Code ) PID    ,Sum(Infant_Registered)as Child_Entry,p.BID    
 from   Scheduled_AC_Child_PHC_SubCenter_Village_Month t (nolock)     
     left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID       
     left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID    
     left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code          
 where Fin_Yr=@FinancialYr       
 --and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1      
 group by  p.BID,isnull(s.pid,HealthFacility_Code )    
     
--  union     
     
-- select  t.HealthFacility_Code  as PID,p.BID    
--,SUM(Infant_Registered) as Child_Entry        
                 
--   from Scheduled_AC_Child_PHC_SubCenter_Village_Month t (nolock)    
--   left outer join Health_PHC p(nolock)  on p.PID=t.HealthFacility_Code    
--   where t.HealthSubFacility_Code =0 and Fin_Yr=@FinancialYr     
--    and (Year_ID =@Year_ID or @Year_ID=0)      
-- and Filter_Type=1     
--   group by State_Code,p.BID,t.HealthFacility_Code    
   )e1 group by e1.BID,e1.PID    
 ) D on  D.PID =A.HealthFacility_Code  and D.BID=A.HealthBlock_Code    
     
     
  left outer join      
(      
 select a1.State_Code, a1.PID,a1.BID  , SUM(a1.Total_EC_Registered) as Total_EC_Registered from     
 (select  State_Code,isnull(s.pid,HealthFacility_Code ) PID ,p.BID       
,SUM(total_distinct_ec) as Total_EC_Registered        
                 
   from Scheduled_AC_EC_PHC_SubCenter_village_Month t (nolock)     
     left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID      
     left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code     
     left join Health_phc p(nolock)  on isnull(s.pid,HealthFacility_Code )  =p.PID         
 where State_Code =@State_Code      
 --and HealthBlock_Code =@HealthBlock_Code         
     
and (Year_ID<=@Year_ID or @Year_ID=0)      
 and Fin_Yr<=@FinancialYr     
and (Filter_Type=1)      
--and ((t.HealthFacility_Code   = 0 and   p.BID  =@HealthBlock_Code  )           
--   OR (HealthFacility_Code != 0 ) )    
     
 group by State_Code,p.BID,isnull(s.pid,HealthFacility_Code )      
-- union     
     
-- select  State_Code,t.HealthFacility_Code  as PID,p.BID    
--,SUM(total_distinct_ec) as Total_EC_Registered        
                 
--   from Scheduled_AC_EC_PHC_SubCenter_village_Month t (nolock)    
--   left outer join Health_PHC p(nolock)  on p.PID=t.HealthFacility_Code    
--   where t.HealthSubFacility_Code =0 and Fin_Yr<=@FinancialYr     
--    and (Year_ID <=@Year_ID or @Year_ID=0)      
--    and Filter_Type=1     
--   group by State_Code,p.BID,t.HealthFacility_Code    
   )a1 group by State_Code,BID ,PID     
 ) E on    A.HealthFacility_Code=E.PID  and A.HealthBlock_Code=E.BID    
 left outer join    
(    
select  HealthBlock_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_PHC_Wise(nolock)      
where Financial_Year=@FinancialYr   
and (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)   
and isnull(Hierarchy_isDeactive,0)=0  
group by HealthBlock_Code    
) XEC    
on XEC.HealthBlock_Code=A.HealthBlock_Code    
left outer join    
(    
select  HealthBlock_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_PHC_Wise(nolock)      
where Financial_Year=@FinancialYr-1 and (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)  
and isnull(Hierarchy_isDeactive,0)=0  
group by HealthBlock_Code    
) XE    
on XE.HealthBlock_Code=A.HealthBlock_Code    
   left outer join    
(    
select SUM(total_distinct_ec) as Total_EC_Registered_Pro   , a.State_Code     
from Scheduled_AC_EC_Block_PHC_Month a (nolock)       
inner join Estimated_Data_PHC_Wise b(nolock) on a.HealthFacility_Code  =b.HealthFacility_Code      
 where --HealthSubFacility_Code =287      
       
 --(Year_ID<=@Year_ID  or @Year_ID =0) and     
 (Filter_Type=1)      
 and Fin_Yr<=@FinancialYr    and  ((a.HealthFacility_Code = 0 and a.HealthFacility_Code =@HealthFacility_Code )           
 OR (a.HealthFacility_Code != 0 ) )    
 and b.HealthFacility_Code = @HealthFacility_Code  and b.Financial_Year = @FinancialYr  
 and isnull(Hierarchy_isDeactive,0)=0      
 group by a.State_Code     
 ) EP   on A.State_Code  = EP.State_Code      
    
left outer join       
( Select T.State_Code,a.DIST_CD,T.HealthBlock_Code ,PHC_CD ,    
ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered    
 ,ISNULL(A.Total_mapped_village ,0) as [Total_Village]    
 ,isnull(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered     
 --,ISNULL(C.Total_Direct_Profile,0) as Total_Direct_Profile    
 ,@daysPast as daysPast    
 ,@Daysinyear as DaysinYear    
 ,isnull(V.Total_Village,0) as Village    
  ,(case when A.Total_mapped_village <> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end) as Village_Population_Status      
    
  from     
    
 (select StateID as State_Code,a.DIST_CD , a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name     
 ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name    
     from TBL_PHC  a(nolock)     
     inner join TBL_HEALTH_BLOCK b(nolock)  on a.BID=b.BLOCK_CD    
     inner join TBL_DISTRICT d(nolock)  on a.DIST_CD = d.DIST_CD     
  and  a.BID=@HealthBlock_Code     
 )  T left outer join     
     
 (select count(distinct VILLAGE_CD)as Total_Village,PHC_CD from TBL_VILLAGE a(nolock)  group by PHC_CD)V on T.HealthFacility_Code=V.PHC_CD    
 left outer join     
 (    
 select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a(nolock)      
 inner join TBL_SUBPHC b(nolock)  on a.SID = b.SUBPHC_CD     
 inner join TBL_PHC c(nolock)  on c.PHC_CD = b.PHC_CD      
 inner join Village v(nolock)  on a.VCode = v.VCode     
 where a.IsActive =1    
 group by c.DIST_CD , c.BID , c.PHC_CD  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.HealthFacility_Code     
 left Outer join    
 (select  district_code ,healthblock_code,HealthFacility_code, COUNT(village_code) as Total_profile_entered from t_villagewise_registry a(nolock)     
 inner join Health_SC_Village b(nolock)  on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID    
  and Finanacial_Yr = @FinancialYr  and b.IsActive = 1     
  inner join TBL_PHC c(nolock)  on c.PHC_CD = a.HealthFacility_code     
  inner join Village v(nolock)  on a.Village_code = v.VCode      
  group by District_code , HealthBlock_code,HealthFacility_code     ) B on T.HealthBlock_Code = B.HealthBlock_code and T.HealthFacility_Code = B.HealthFacility_code     
) F on    F.HealthBlock_Code= A.HealthBlock_Code and F.PHC_CD = A.HealthFacility_Code    
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=@District_Code      
 )--order by ParentID, ChildID    
end      
else if(@Category='PHC')        
begin        
 select distinct A.State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName      
 ,F.Village_Population_Status      
 ,isnull(A.Village_Population,0) as Village_Population      
 ,isnull(  e.Total_EC_Registered ,0) as EC_Entry,      
  isnull(A.Estimated_Mother,0)  as Estimated_PW        
, isnull(A.Estimated_Infant,0)  as Estimated_Infant        
 , isnull(A.Estimated_EC,0)  as Estimated_EC         
,isnull( RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),       
@FinancialYr) ,0) as Prorata      
,isnull(  RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),     
@FinancialYr) ,0) as TotalProrata     
 ,isnull(C.Mother_Entry,0) as Mother_Entry      
 ,isnull(D.Child_Entry,0) as Child_Entry      
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered      
 ,ISNULL(F.[Total_Village],0) as [Total_Village]      
 ,@daysPast as daysPast      
 ,@Daysinyear as DaysinYear      
 ,'--' as Village      
 ,ISNULL(F.Total_Village,0)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered  --Added on 06032018      
  from (      
 (        
       
 select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name,    
   a.V_Population as Village_Population      
   ,a.Estimated_EC as Estimated_EC      
   ,a.Estimated_Mother as Estimated_Mother      
   ,a.Estimated_Infant as Estimated_Infant      
   ,a.Total_ActiveVillage--Added on 06032018      
      from Estimated_Data_SubCenter_Wise a(nolock)       
   inner join TBL_PHC b(nolock)  on a.HealthFacility_Code=b.PHC_CD      
   left outer join TBL_SUBPHC c(nolock)  on a.HealthSubFacility_Code=c.SUBPHC_CD       
     where a.Financial_Year=@FinancialYr       
     and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)    
     and isnull(Hierarchy_isDeactive,0)=0   
 --    union    
 --select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,0 as HealthSubFacility_Code,'Direct Entry' as HealthSubFacility_Name,    
 --  a.V_Population as Village_Population       
 --,a.Estimated_EC as Estimated_EC        
 --,a.Estimated_Mother as Estimated_Mother        
 --,a.Estimated_Infant as Estimated_Infant     
 -- ,a.Total_ActiveVillage       
 --from Estimated_Data_PHC_Wise  a (nolock)     
 --    inner join TBL_PHC b (nolock) on a.HealthFacility_Code=b.PHC_CD         
 --where-- a.HealthBlock_Code = @HealthBlock_Code  and  a.HealthFacility_Code=@HealthFacility_Code     
 --(HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)    
 --and a.Financial_Year=@FinancialYr      
          
     )  A       
     left outer join      
(      
select  HealthSubFacility_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_SubCenter_Wise(nolock)        
where Financial_Year=@FinancialYr-1   and ( HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)   
and isnull(Hierarchy_isDeactive,0)=0      
) X      
on X.HealthSubFacility_Code=A.HealthSubFacility_Code      
 left outer join  (    
 select Sum(p1.Mother_Entry)as Mother_Entry,HealthFacility_Code, p1.SID  from     
     
 (select Sum(PW_Registered)as Mother_Entry, isnull(vn.PHC_CD,pid) HealthFacility_Code,    
  --HealthSubFacility_Code as SID,      
 case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE(nolock)  where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end as SID     
   ,Village_Code      
    
 from Scheduled_AC_PW_PHC_SubCenter_village_Month   t(nolock)  
 left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID   
 left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code    
  --inner join   Health_SC_Village  s on t.Village_Code  =  s.VCode     
 where Fin_Yr=@FinancialYr       
-- and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1       
 group by State_Code,isnull(vn.PHC_CD,pid),HealthSubFacility_Code,Village_Code,vn.SUBPHC_CD    
    
--   union     
--   select Sum(PW_Registered)as Mother_Entry, HealthSubFacility_Code as sid , Village_Code,HealthFacility_Code     
-- from Scheduled_AC_PW_PHC_SubCenter_village_Month   t(nolock)     
-- where Fin_Yr=@FinancialYr       
---- and (Month_ID =@Month_ID or @Month_ID=0)      
-- and (Year_ID =@Year_ID or @Year_ID=0)      
-- and Filter_Type=1   and ((HealthSubFacility_Code = 0 and HealthFacility_Code =@HealthFacility_Code )           
--   OR (HealthSubFacility_Code != 0 ) )    
--   and (village_code = 0 )    
--   group by HealthFacility_Code, HealthSubFacility_Code, Village_Code      
   ) p1 group by HealthFacility_Code,sid    
  ) C on  C.SID =A.HealthSubFacility_Code  and C.HealthFacility_Code=A.HealthFacility_Code    
 left outer join  (    
     
     
 select sum(c1.Child_Entry) as child_entry,HealthFacility_Code ,c1.SID     
 from     
 (select Sum(Infant_Registered)as Child_Entry, isnull(vn.PHC_CD,pid)HealthFacility_Code    
--, HealthSubFacility_Code  as SID      
,case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE(nolock)  where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end as SID     
,  Village_Code     
 from Scheduled_AC_Child_PHC_SubCenter_Village_Month  t(nolock)
 left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID      
 left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD=t.HealthSubFacility_Code    
 --inner join   Health_SC_Village  s on t.Village_Code  =  s.VCode     
 where Fin_Yr=@FinancialYr       
-- and (Month_ID =@Month_ID or @Month_ID=0)      
 --and (Year_ID =@Year_ID or @Year_ID=0)      
 and Filter_Type=1      
 group by State_Code,isnull(vn.PHC_CD,pid),HealthSubFacility_Code, Village_Code ,vn.SUBPHC_CD     
    
-- union    
-- select Sum(Infant_Registered)as Child_Entry,HealthFacility_Code, HealthSubFacility_Code  as sid  , Village_Code     
-- from Scheduled_AC_Child_PHC_SubCenter_Village_Month  t (nolock)     
-- where Fin_Yr=@FinancialYr       
---- and (Month_ID =@Month_ID or @Month_ID=0)      
-- and (Year_ID =@Year_ID or @Year_ID=0)      
-- and Filter_Type=1  and ((HealthSubFacility_Code = 0 and HealthFacility_Code =@HealthFacility_Code ) OR (HealthSubFacility_Code != 0 ) )     
     
--  and (village_code = 0 )    
-- group by HealthFacility_Code,HealthSubFacility_Code, Village_Code      
)c1 group by HealthFacility_Code, sid    
     
 ) D on  D.sid=A.HealthSubFacility_Code and D.HealthFacility_Code=A.HealthFacility_Code     
     
     
     
     
 left outer join      
(      
select  e1.State_Code,e1.SID ,HealthFacility_Code     
,SUM(e1.Total_EC_Registered) as Total_EC_Registered  from (    
 select  State_Code, isnull(vn.PHC_CD,pid)  HealthFacility_Code    
, case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end  as SID    
,Village_Code        
,SUM(total_distinct_ec) as Total_EC_Registered          
                   
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month t(nolock)    
   left join Health_SubCentre s(nolock)  on t.HealthSubFacility_Code =s.SID 
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD= t.HealthSubFacility_Code         
 where State_Code =@State_Code         
    
and (Year_ID<=@Year_ID  or @Year_ID =0)    
 and Fin_Yr<=@FinancialYr        
and (Filter_Type=1)        
      
 group by State_Code,isnull(vn.PHC_CD,pid),HealthSubFacility_Code,Village_Code,vn.SUBPHC_CD     
    
    
-- union    
-- select  State_Code,HealthFacility_Code,HealthSubFacility_Code , Village_Code     
--,SUM(total_distinct_ec) as Total_EC_Registered        
                 
--   from Scheduled_AC_EC_PHC_SubCenter_village_Month t (nolock)      
-- where State_Code =@State_Code      
-- --and HealthFacility_Code =@HealthFacility_Code            
--and ((HealthSubFacility_Code = 0 and HealthFacility_Code =@HealthFacility_Code )           
--   OR (HealthSubFacility_Code != 0 ) )     
--and (Year_ID<=@Year_ID or @Year_ID=0)      
--and (Filter_Type=1)      
--and Fin_Yr<=@FinancialYr      
    
--and village_code = 0    
-- group by State_Code,HealthFacility_Code,HealthSubFacility_Code, Village_Code      
)e1 group by State_Code,HealthFacility_Code , SID     
 ) E on   A.HealthSubFacility_Code=E.SID and A.HealthFacility_Code=E.HealthFacility_Code    
 left outer join    
(    
select  HealthFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_SubCenter_Wise (nolock)     
where Financial_Year=@FinancialYr and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) and isnull(Hierarchy_isDeactive,0)=0  
group by HealthFacility_Code    
) XEC    
on XEC.HealthFacility_Code=A.HealthFacility_Code    
left outer join    
(    
select  HealthFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_SubCenter_Wise (nolock)     
where Financial_Year=@FinancialYr-1  and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) and isnull(Hierarchy_isDeactive,0)=0  
group by HealthFacility_Code    
) XE    
on XE.HealthFacility_Code=A.HealthFacility_Code    
    
   left outer join    
 (select SUM(total_distinct_ec) as Total_EC_Registered_Pro   , a.State_Code     
from Scheduled_AC_EC_PHC_SubCenter_Month a (nolock)       
inner join  Estimated_Data_SubCenter_Wise b(nolock)  on a.HealthSubFacility_Code  =b.HealthSubFacility_Code      
 where     
       
 --(Year_ID<=@Year_ID   or @Year_ID =0)  and    
 (Filter_Type=1)      
and Fin_Yr<=@FinancialYr    and  ((a.HealthSubFacility_Code  = 0 and a.HealthFacility_Code =@HealthFacility_Code )           
   OR (a.HealthSubFacility_Code  != 0 ) )    
 and b.HealthFacility_Code = @HealthFacility_Code  and b.Financial_Year = @FinancialYr      
 group by a.State_Code     
 ) EP   on A.State_Code  = EP.State_Code      
 left outer join       
 ( Select State_Code,T.DIST_CD,  T.HealthBlock_Code , T.PHC_CD ,T.SUBPHC_CD    
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered    
 ,ISNULL(A.Total_mapped_village ,0) as [Total_Village]    
 ,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered     
 ,isnull(V.Total_Village,0) as Village,    
 (case  when [Total_Profile_Entered]=0 then 'Not Completed' when isnull(A.Total_mapped_village,0)<> isnull([Total_Profile_Entered],1) then 'Not Completed' else 'Completed' end) as Village_Population_Status      
  from     
     
 (select  stateid as State_Code,a.DIST_CD,  c.BLOCK_CD as HealthBlock_Code,a.PHC_CD ,b.PHC_NAME  as Healthphc_Name ,a.SUBPHC_CD ,a.SUBPHC_NAME_E     
  from TBL_SUBPHC   a(nolock)     
     inner join TBL_phc b(nolock)  on a.PHC_CD =b.PHC_CD  and a.DIST_CD = b.DIST_CD     
      inner join TBL_HEALTH_BLOCK  c (nolock) on b.BID =c.BLOCK_CD  and a.DIST_CD = c.DISTRICT_CD     
      inner join TBL_DISTRICT d(nolock)  on a.DIST_CD = d.DIST_CD     
  and  a.DIST_CD =@District_Code  and  c.BLOCK_CD = @HealthBlock_Code  and a.PHC_CD = @HealthFacility_Code) T    
  Left Outer Join     
      
 (select count(distinct VILLAGE_CD)as Total_Village,SUBPHC_CD  from TBL_VILLAGE a group by SUBPHC_CD )V on T.SUBPHC_CD =V.SUBPHC_CD     
 Left Outer join       
 ( select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,a.SID ,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a(nolock)      
 inner join TBL_SUBPHC b(nolock)  on a.SID = b.SUBPHC_CD     
 inner join TBL_PHC c(nolock)  on c.PHC_CD = b.PHC_CD      
 inner join Village v(nolock)  on a.VCode = v.VCode     
 where a.IsActive =1    
 group by c.DIST_CD , c.BID , c.PHC_CD , a.SID  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.PHC_CD and A.SID = T.SUBPHC_CD    
 Left Outer join    
 (select  district_code ,healthblock_code,HealthFacility_code,healthsubcentre_code,  COUNT(village_code) as Total_profile_entered from t_villagewise_registry a(nolock)     
  inner join Health_SC_Village b(nolock)  on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID    
  and Finanacial_Yr = @FinancialYr  and b.IsActive = 1     
  inner join TBL_PHC c(nolock)  on c.PHC_CD = a.HealthFacility_code     
  inner join Village v(nolock)  on a.Village_code = v.VCode      
  group by District_code , HealthBlock_code,HealthFacility_code , HealthSubCentre_code) B on T.HealthBlock_Code = B.HealthBlock_code and T.PHC_CD = B.HealthFacility_code  and T.SUBPHC_CD = b.HealthSubCentre_code    
    
     
 )F on A.State_Code = F.State_code and A.HealthFacility_Code=F.PHC_CD and A.HealthSubFacility_Code=F.SUBPHC_CD    
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=@District_Code      
 )       
 --order by ParentID, ChildID    
end      
else if(@Category='Subcentre')        
Begin    
 select distinct A.State_Code , A.SID as ParentID,VCode as ChildID,SUBPHC_NAME_E as ParentName,Vilage_Name as ChildName,F.Village_Population_Status        
 ,isnull(A.Village_Population,0) as Village_Population        
 ,isnull(e.Total_EC_Registered,0)  as EC_Entry,        
  isnull(A.Estimated_Mother,0)  as Estimated_PW          
, isnull(A.Estimated_Infant,0)  as Estimated_Infant          
 , isnull(A.Estimated_EC,0)  as Estimated_EC           
,isnull(RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),         
@FinancialYr ),0) as Prorata        
,isnull(RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr ) ,0) as TotalProrata      
     
 ,isnull(C.Mother_Entry,0) as Mother_Entry        
 ,isnull(D.Child_Entry,0) as Child_Entry        
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered        
 ,ISNULL(F.[Total_Village],0) as [Total_Village]        
 ,@daysPast as daysPast        
 ,@Daysinyear as DaysinYear        
 ,'--' as Village        
 ,F.Total_Profile_Not_Entered      
  from (        
 (select c.State_Code , c.HealthSubFacility_Code as SID,isnull(c.Village_Code,0) as VCode,sp.SUBPHC_NAME_E,isnull(vn.VILLAGE_NAME,'Direct Entry') as Vilage_Name        
 ,Village_Population        
 ,c.Estimated_EC as Estimated_EC        
 ,c.Estimated_Mother as Estimated_Mother        
 ,c.Estimated_Infant as Estimated_Infant        
 from Estimated_Data_Village_Wise  c (nolock)        
 left join Health_SC_Village s(nolock)  on c.HealthSubFacility_Code =s.SID and c.Village_Code =s.VCode     
 left outer join TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code        
 left outer join TBL_SUBPHC sp(nolock)  on sp.SUBPHC_CD=c.HealthSubFacility_Code        
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
 and (vn.VILLAGE_CD=0 or 0=0) and c.Financial_Year=@FinancialYr     
 union    
 select c.State_Code , c.HealthSubFacility_Code as SID,0 as VCode,sp.SUBPHC_NAME_E,'Direct Entry' as Vilage_Name        
 ,c.V_Population      
 ,c.Estimated_EC as Estimated_EC        
 ,c.Estimated_Mother as Estimated_Mother        
 ,c.Estimated_Infant as Estimated_Infant        
 from Estimated_Data_subcenter_Wise  c (nolock)     
  left join TBL_SUBPHC sp(nolock)  on sp.SUBPHC_CD=c.HealthSubFacility_Code        
 where c.HealthFacility_Code = @HealthFacility_Code and  c.HealthSubFacility_Code=@HealthSubFacility_Code and c.Financial_Year=@FinancialYr     
 ) A        
 left outer join        
(        
select  Village_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_Village_Wise(nolock)          
where Financial_Year=@FinancialYr -1  and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
and isnull(Hierarchy_isDeactive,0)=0        
) X        
on X.Village_Code=A.VCode        
 left outer join       
     
    
      
 (select Village_Code,Sum(Mother_Entry)as Mother_Entry,isnull(HealthSubFacility_Code,0)HealthSubFacility_Code from(    
 select Village_Code as  Village_Code    
, case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE(nolock)  where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end  HealthSubFacility_Code    
,Sum(PW_Registered)as Mother_Entry  from Scheduled_AC_PW_PHC_SubCenter_Village_Month c(nolock)      
 left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code    
  where Fin_Yr=@FinancialYr       
 --and (Year_ID =@Year_ID or @Year_ID=0)     
 and Filter_Type=1    and vn.SUBPHC_CD=@HealthSubFacility_Code    
 group by Village_Code,HealthSubFacility_Code,vn.SUBPHC_CD    
 ) a group by Village_Code,HealthSubFacility_Code) C on C.Village_Code=A.VCode   and C.HealthSubFacility_Code=A.SID     
 left outer join       
     
      
 (select Village_Code,Sum(Child_Entry)as Child_Entry,isnull(HealthSubFacility_Code,0)HealthSubFacility_Code from(    
select Sum(Infant_Registered)as Child_Entry,Village_Code as  Village_Code    
, case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end  HealthSubFacility_Code    
 from Scheduled_AC_Child_PHC_SubCenter_Village_Month t(nolock)     
 left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD= t.HealthSubFacility_Code        
 where Fin_Yr=@FinancialYr          
 --and (Month_ID =0 or 0=0)        
 --and (Year_ID =@Year_ID  or @Year_ID =0)        
 and Filter_Type=1   and vn.SUBPHC_CD=@HealthSubFacility_Code       
 group by State_Code,Village_Code,HealthSubFacility_Code,vn.SUBPHC_CD     
 ) a group by HealthSubFacility_Code, Village_Code) D on D.Village_Code=A.VCode and D.HealthSubFacility_Code=A.SID    
     
        
  left outer join        
(        
 select Village_Code,Sum(Total_EC_Registered)as Total_EC_Registered,isnull(HealthSubFacility_Code,0)HealthSubFacility_Code from(    
select  State_Code    
, case when Village_Code=0 then HealthSubFacility_Code else case when vn.SUBPHC_CD IS null then    
(select top 1 SUBPHC_CD from TBL_VILLAGE(nolock)  where VILLAGE_CD=Village_Code)  else   vn.SUBPHC_CD end  end  HealthSubFacility_Code,Village_Code        
,SUM(total_distinct_ec) as Total_EC_Registered          
                   
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month t(nolock)     
   left join   TBL_VILLAGE vn(nolock)  on vn.VILLAGE_CD=t.Village_Code and vn.SUBPHC_CD= t.HealthSubFacility_Code         
 where State_Code =@State_Code         
    
and (Year_ID<=@Year_ID  or @Year_ID =0)        
and Fin_Yr<=@FinancialYr     
and (Filter_Type=1)   and vn.SUBPHC_CD=@HealthSubFacility_Code      
      
 group by State_Code,Village_Code,HealthSubFacility_Code,vn.SUBPHC_CD       
 ) a group by HealthSubFacility_Code,Village_Code       
 ) E on     A.VCode=E.Village_Code   and A.SID=E.HealthSubFacility_Code    
  left outer join      
(      
select  HealthSubFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Village_Wise (nolock)       
where Financial_Year=@FinancialYr  and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) and isnull(Hierarchy_isDeactive,0)=0 group by HealthSubFacility_Code      
) XEC      
on XEC.HealthSubFacility_Code=A.SID      
left outer join      
(      
select  HealthSubFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Village_Wise (nolock)       
where Financial_Year=@FinancialYr -1  and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) and isnull(Hierarchy_isDeactive,0)=0 group by HealthSubFacility_Code      
) XE      
on XE.HealthSubFacility_Code=A.SID      
    
   left outer join      
    
 (select SUM(total_distinct_ec) as Total_EC_Registered_Pro   , a.State_Code     
from Scheduled_AC_EC_PHC_SubCenter_Village_Month a (nolock)       
inner join  Estimated_Data_Village_Wise b (nolock) on a.Village_Code =b.Village_Code     
 where      
       
 (Year_ID<=@Year_ID  or @Year_ID =0)  and    
 (Filter_Type=1)      
and Fin_Yr<=@FinancialYr    and  ((a.village_code = 0 and a.HealthSubFacility_Code =@HealthSubFacility_Code)           
   OR (a.village_code != 0 ) )    
 and b.HealthSubFacility_Code = @HealthSubFacility_Code and b.Financial_Year = @FinancialYr      
 group by a.State_Code     
 ) EP   on A.State_Code  = EP.State_Code     
    
 left outer join         
 ( Select T.State_Code, T.DIST_CD ,T.HealthBlock_Code ,T.PHC_CD ,T.SUBPHC_CD ,T.VILLAGE_CD       
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered      
 ,ISNULL(A.Total_mapped_village ,0) as [Total_Village]      
 ,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered       
 ,isnull(V.Total_Village,0) as Village      
 ,(case  when [Total_Profile_Entered]=0 then 'Not Completed' when isnull(A.Total_mapped_village,0)<> isnull([Total_Profile_Entered],0) then 'Not Completed' else 'Completed' end) as Village_Population_Status        
  from (      
       
 select stateid as State_Code,a.DIST_CD,  c.BLOCK_CD as HealthBlock_Code,a.PHC_CD ,a.SUBPHC_CD ,d.SUBPHC_NAME_E ,a.VILLAGE_CD,a.VILLAGE_NAME      
  from TBL_VILLAGE    a (nolock)      
  inner join TBL_SUBPHC d(nolock)  on a.SUBPHC_CD = d.SUBPHC_CD      
     inner join TBL_phc b(nolock)  on a.PHC_CD =b.PHC_CD  and a.DIST_CD = b.DIST_CD       
      inner join TBL_HEALTH_BLOCK  c(nolock)  on b.BID =c.BLOCK_CD  and a.DIST_CD = c.DISTRICT_CD       
      inner join TBL_DISTRICT e(nolock)  on a.DIST_CD = e.DIST_CD      
  and  a.DIST_CD =@District_Code   and  c.BLOCK_CD = @HealthBlock_Code  and a.PHC_CD = @HealthFacility_Code  and a.SUBPHC_CD=@HealthSubFacility_Code  ) T      
        
  Left Outer Join       
        
 (select count(distinct VILLAGE_CD)as Total_Village,VILLAGE_CD   from TBL_VILLAGE a group by VILLAGE_CD  )V on T.VILLAGE_CD =V.VILLAGE_CD       
 Left Outer join         
 ( select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,a.SID , a.VCode , COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a(nolock)        
 inner join TBL_SUBPHC b(nolock)  on a.SID = b.SUBPHC_CD       
 inner join TBL_PHC c(nolock)  on c.PHC_CD = b.PHC_CD        
 inner join Village v(nolock)  on a.VCode = v.VCode       
 where a.IsActive =1      
 group by c.DIST_CD , c.BID , c.PHC_CD , a.SID ,a.VCode  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.PHC_CD and A.SID = T.SUBPHC_CD and a.VCode = t.VILLAGE_CD      
 Left Outer join      
 (select  district_code ,healthblock_code,HealthFacility_code,healthsubcentre_code,village_code , COUNT(village_code) as Total_profile_entered from t_villagewise_registry a(nolock)       
  inner join Health_SC_Village b(nolock)  on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID      
  and Finanacial_Yr = @FinancialYr   and b.IsActive = 1       
  inner join TBL_PHC c(nolock)  on c.PHC_CD = a.HealthFacility_code       
  inner join Village v(nolock)  on a.Village_code = v.VCode        
  group by District_code , HealthBlock_code,HealthFacility_code , HealthSubCentre_code, Village_code ) B on T.HealthBlock_Code = B.HealthBlock_code and T.PHC_CD = B.HealthFacility_code  and T.SUBPHC_CD = b.HealthSubCentre_code and t.VILLAGE_CD = b.Village_code       
      
 ) F on A.SID = F.SUBPHC_CD  and A.VCode = F.VILLAGE_CD       
 )  --order by ParentID, ChildID     
End    
      
end      
      
    
    
    