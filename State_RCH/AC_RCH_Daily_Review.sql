USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_RCH_Daily_Review]    Script Date: 09/26/2024 11:53:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*   
[AC_RCH_Daily_Review] 0,0,0,0,0,0,2016,6,0,'','','National'   
[AC_RCH_Daily_Review] 23,0,0,0,0,0,2019,0,0,'','','State'  
[AC_RCH_Daily_Review] 23,1,0,0,0,0,2019,0,0,'','','District'  
[AC_RCH_Daily_Review] 23,1,1,0,0,0,2019,0,0,'','','Block'  
[AC_RCH_Daily_Review] 30,1,3,11,0,0,2019,0,0,'','','PHC'  
[AC_RCH_Daily_Review] 23,1,1,487,3234,0,2019,0,0,'','','Subcentre'  
  
*/  
ALTER proc [dbo].[AC_RCH_Daily_Review]  
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
   
if(@Category='National')    
begin    
 exec RCH_Reports.dbo.AC_RCH_Daily_Review @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,    
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category  
end  
  
if(@Category='State')    
begin    
select StateID as ParentID,StateName as ParentName,A.DIST_CD as ChildID,DIST_NAME_ENG as ChildName,F.Village_Population_Status  
,isnull(A.Village_Population,0) as Village_Population  
--,isnull(A.Estimated_EC,0) as Estimated_EC  
,isnull( (case when @Month_ID=0 then e.Total_EC_Registered else B.EC_Entry end),0) as EC_Entry,  
(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_PW    
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant    
,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC 
,isnull((case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),   
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(b.EC_Entry,0)) end ),0) as Prorata  
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0), 
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata
--,isnull(A.Estimated_MOther,0) as Estimated_PW  
 ,isnull(C.Mother_Entry,0) as Mother_Entry  
  
 ,isnull(D.Child_Entry,0) as Child_Entry  
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered  
 ,ISNULL(F.[Total_village]  ,0) as [Total_Village]  
 ,@daysPast as daysPast  
 ,@Daysinyear as DaysinYear  
 ,isnull(F.Village ,0) as Village  
 --,ISNULL(F.Total_village,1)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered  --Added on 06032018  
 ,isnull(F.Total_Profile_Not_Entered ,0) as Total_Profile_Not_Entered 
  from (  
 (select  a.StateID,a.DIST_CD,c.StateName ,a.DIST_NAME_ENG 
 --,[Total_Village]  
 --,[Total_Profile_Entered]  
-- ,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end)as  Village_Population_Status  
 ,b.V_Population as Village_Population  
 ,b.Estimated_EC as Estimated_EC  
 ,b.Estimated_Mother as Estimated_Mother  
 ,b.Estimated_Infant as Estimated_Infant  
 ,b.Total_ActiveVillage--Added on 06032018  
 from TBL_DISTRICT a  
 left outer join Estimated_Data_District_Wise b on a.Dist_Cd=b.District_Code  
 left outer join TBL_STATE c on a.StateID=c.StateID  --order by VILLAGE_CD  
 where  b.Financial_Year=@FinancialYr) A  
 left outer join  
(  
select  District_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_District_Wise   
where Financial_Year=@FinancialYr-1   
) X  
on X.District_Code=A.DIST_CD  
 left outer join  
 (select Sum(total_distinct_ec)as EC_Entry, State_Code , District_Code    
 from Scheduled_AC_EC_State_District_Month    
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by State_Code , District_Code) B on B.State_Code=A.StateID and B.District_Code=A.DIST_CD  
 left outer join  
 (select Sum(PW_Registered)as Mother_Entry,State_Code , District_Code   
 from Scheduled_AC_PW_State_District_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by State_Code , District_Code) C on C.State_Code=A.StateID and C.District_Code=A.DIST_CD  
 left outer join  
 (select Sum(Infant_Registered)as Child_Entry,State_Code , District_Code   
 from Scheduled_AC_CHILD_State_District_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by State_Code , District_Code) D on D.State_Code=A.StateID and D.District_Code=A.DIST_CD  
 left outer join  
(  
select  State_Code,District_Code   
,SUM(total_distinct_ec) as Total_EC_Registered    
from Scheduled_AC_EC_State_District_month (nolock)    
where State_Code =@State_Code  
and (District_Code=@District_Code or @District_Code=0)  
and (Month_ID<=@Month_ID or @Month_ID=0)  
and (Year_ID<=@Year_ID or @Year_ID=0)  
and (Filter_Type=1)  
and Fin_Yr<=@FinancialYr   
group by State_Code,District_Code  
) E on A.StateID=E.State_Code and A.DIST_CD=E.District_Code  
left outer join
(
select  State_Code, Sum(Estimated_EC) as Estimated_EC_Pro from RCH_Reports.dbo.Estimated_Data_All_State--Estimated_Data_District_Wise 
where Financial_Year=@FinancialYr group by State_Code
) XEC
on XEC.State_Code=A.StateID
left outer join
(
select  State_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from RCH_Reports.dbo.Estimated_Data_All_State--Estimated_Data_District_Wise 
where Financial_Year=@FinancialYr-1  group by State_Code
) XE
on XE.State_Code=A.StateID
 left outer join  
(  
 select  EC.State_Code  
,SUM(total_distinct_ec) as EC_Registered_Pro    
from Scheduled_AC_EC_State_District_Month as EC    
where EC.State_Code =@State_Code  
and (EC.District_Code=@District_Code or @District_Code=0)  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and Filter_Type=1  
 group by EC.State_Code
 ) CE on A.StateID=CE.State_Code
   left outer join
(
 select  State_Code 
,SUM(total_distinct_ec) as Total_EC_Registered_Pro 
from Scheduled_AC_EC_State_District_month (nolock)  
 where State_Code =@State_Code
 and (District_Code=@District_Code or @District_Code=0)

and (Year_ID<=@Year_ID or @Year_ID=0)
and (Filter_Type=1)
and Fin_Yr<=@FinancialYr 
 group by State_Code
 ) EP on A.StateID=EP.State_Code 
left outer join   
--(select SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village,@State_Code as StateCode ,District_ID as DCode from [Scheduled_BR_CM_Consolidated] group by District_ID) F on A.StateID=F.StateCode and F.DCode=A.DIST_CD  
--) 
( 
 select State_Code , T.DIST_CD,isnull(V.Total_Village,0) Village , isnull(A.mapped_village,0) Total_village, 
		isnull(B.profile_entered,0) Total_Profile_Entered ,
		isnull(A.mapped_village,0) - isnull(B.profile_entered,0) Total_Profile_Not_Entered
 	   ,(case when A.mapped_village<> b.profile_entered then 'Not Completed' when b.profile_entered =0 then 'Not Completed' else 'Completed' end) as Village_Population_Status  

		from (
			select a.StateID  as State_Code, c.StateName , a.DIST_CD  ,a.DIST_NAME_ENG
				 from TBL_District  a
				 left outer join TBL_STATE c on a.StateID=c.StateID
   				 ) T 
				 Left Outer Join   
		(select a.DCode, COUNT(Distinct vcode ) as Total_village from VILLAGE  a
		  group by a.DCode  ) V  on v.dcode = T.DIST_CD 
		  Left Outer join
		   ( select b.DIST_CD   ,  COUNT(a.VCode ) as mapped_village from Health_SC_Village  a 
			inner join TBL_SUBPHC b on a.SID = b.SUBPHC_CD 
			inner join Village v on a.VCode = v.VCode 
			where a.IsActive =1
			group by b.DIST_CD   ) A ON  T.DIST_CD = A.DIST_CD
			Left Outer Join
			(select  district_code , COUNT(village_code) as profile_entered from t_villagewise_registry a
			inner join Health_SC_Village b on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID
			inner join Village v on a.Village_code = v.VCode  
			 and Finanacial_Yr = @FinancialYr  and b.IsActive = 1 
			
			 group by District_code  ) B on T.DIST_CD = B.District_code
		  ) F on A.StateID=F.state_code  and A.DIST_CD= F.DIST_CD
  )
end  
else if(@Category='District')    
begin    
 select A.DISTRICT_CD as ParentID,District_Name as ParentName,BLOCK_CD as ChildID,Block_Name_E as ChildName,F.Village_Population_Status  
 ,isnull(A.Village_Population,0) as Village_Population  
 --,isnull(A.Estimated_EC,0) as Estimated_EC  
 ,isnull( (case when @Month_ID=0 then e.Total_EC_Registered else B.EC_Entry end),0) as EC_Entry,  
 (case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_PW    
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant    
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC     
,isnull((case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),   
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(b.EC_Entry,0)) end ),0) as Prorata  
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0), 
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata
 ,isnull(C.Mother_Entry,0) as Mother_Entry  
 ,isnull(D.Child_Entry,0) as Child_Entry  
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered  
 ,ISNULL(F.[Total_Village],0) as [Total_Village]  
 ,@daysPast as daysPast  
 ,@Daysinyear as DaysinYear  
 ,'--' as Village  
 ,ISNULL(F.Total_Village,0)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered  --Added on 06032018  
  from (  
 (select  b.DISTRICT_CD,b.BLOCK_CD, a.DIST_NAME_ENG as District_Name,b.Block_Name_E,
 --[Total_Village]  
 --,([Total_Profile_Entered]+Total_Direct_profile)[Total_Profile_Entered]  
 --,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end) as Village_Population_Status  
 c.V_Population as Village_Population  
 ,c.Estimated_EC as Estimated_EC  
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant as Estimated_Infant  
 ,c.Total_ActiveVillage--Added on 06032018  
 from TBL_HEALTH_BLOCK b  
 left outer join Estimated_Data_Block_Wise c on b.BLOCK_CD=c.HealthBlock_Code  
 inner join TBL_DISTRICT a on b.DISTRICT_CD=a.DIST_CD --order by VILLAGE_CD  
 where (b.DISTRICT_CD=@District_Code or @District_Code=0) and c.Financial_Year=@FinancialYr) A  
 left outer join  
(  
select  HealthBlock_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_Block_Wise   
where Financial_Year=@FinancialYr-1   
) X  
on X.HealthBlock_Code=A.BLOCK_CD  
 left outer join  
 (select Sum(total_distinct_ec)as EC_Entry, District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code   
 from Scheduled_AC_EC_District_Block_Month  
  where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
   group by District_Code,HealthBlock_Code) B on B.District_Code=A.DISTRICT_CD and B.HealthBlock_Code=A.BLOCK_CD  
 left outer join  
 (select Sum(PW_Registered)as Mother_Entry,District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code   
 from Scheduled_AC_PW_District_Block_Month    
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by District_Code,HealthBlock_Code) C on C.District_Code=A.DISTRICT_CD and C.HealthBlock_Code=A.BLOCK_CD  
 left outer join  
 (select Sum(Infant_Registered)as Child_Entry,District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code   
 from Scheduled_AC_Child_District_Block_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by District_Code,HealthBlock_Code) D on D.District_Code=A.DISTRICT_CD and D.HealthBlock_Code=A.BLOCK_CD  
    left outer join  
(  
 select  State_Code,District_Code,HealthBlock_Code  
,SUM(total_distinct_ec) as Total_EC_Registered    
             
   from Scheduled_AC_EC_District_Block_Month (nolock)    
 where State_Code =@State_Code  
 and (District_Code=@District_Code or @District_Code=0)  

and (Year_ID<=@Year_ID or @Year_ID=0)  
and (Filter_Type=1)  
and Fin_Yr<=@FinancialYr   
  group by State_Code,District_Code,HealthBlock_Code   
 )E on   A.DISTRICT_CD=E.District_Code and A.BLOCK_CD=E.HealthBlock_Code  
 left outer join
(
select  District_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Block_Wise 
where Financial_Year=@FinancialYr group by District_Code
) XEC
on XEC.District_Code=A.DISTRICT_CD
left outer join
(
select  District_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Block_Wise 
where Financial_Year=@FinancialYr-1  group by District_Code
) XE
on XE.District_Code=A.DISTRICT_CD
 left outer join  
(  
 select  State_Code,District_Code  
,SUM(total_distinct_ec) as EC_Registered_Pro    
from Scheduled_AC_EC_District_Block_Month as EC    
where EC.State_Code =@State_Code  
and (EC.District_Code=@District_Code or @District_Code=0)  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and Filter_Type=1  
 group by State_Code,District_Code
 ) CE on   a.DISTRICT_CD=ce.District_Code 
   left outer join
(
 select  District_Code 
,SUM(total_distinct_ec) as Total_EC_Registered_Pro 
from Scheduled_AC_EC_District_Block_Month (nolock)  
 where State_Code =@State_Code
 and (District_Code=@District_Code or @District_Code=0)

and (Year_ID<=@Year_ID or @Year_ID=0)
and (Filter_Type=1)
and Fin_Yr<=@FinancialYr 
 group by District_Code
 ) EP on A.DISTRICT_CD=EP.District_Code  
  
 left outer join   
 ( select State_Code, T.District_CD, T.HealthBlock_Code
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,isnull(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	,isnull(V.Total_Village,0) as Village
	 ,(case when A.Total_mapped_village <> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end) as Village_Population_Status  

	 from (

   select StateID  as State_Code,a.DISTRICT_CD ,b.DIST_NAME_ENG, a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name 
	 from TBL_Health_Block  a
     inner join TBL_District  b on a.DISTRICT_CD =b.DIST_CD
	 and  a.DISTRICT_CD=@District_Code  ) T 
	 Left Outer Join 
(select a.DIST_CD, c.BLOCK_CD   , COUNT(distinct VILLAGE_CD ) as Total_village from TBL_VILLAGE a
  inner join TBL_PHC b on a.PHC_CD = b.PHC_CD 
  inner join TBL_HEALTH_BLOCK c on  b.BID =c.BLOCK_CD  
  group by a.DIST_CD , c.BLOCK_CD   ) V  on v.DIST_CD = T.DISTRICT_CD and  v.BLOCK_CD = T.HealthBlock_Code
  Left Outer join
   ( select c.DIST_CD   , c.bid as Health_block_code ,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a 
	inner join TBL_SUBPHC b on a.SID = b.SUBPHC_CD 
	inner join TBL_PHC c on c.PHC_CD = b.PHC_CD  
	inner join Village v on a.VCode = v.VCode 
	where a.IsActive =1
	group by c.DIST_CD , c.BID   ) A ON  T.HealthBlock_Code = A.Health_block_code  
	Left Outer Join
	(select  district_code ,healthblock_code, COUNT(village_code) as Total_profile_entered from t_villagewise_registry a
	inner join Health_SC_Village b on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID
	 and Finanacial_Yr = @FinancialYr  and b.IsActive = 1 
	 inner join TBL_HEALTH_BLOCK  c on c.BLOCK_CD  = a.HealthBlock_code 
	 inner join Village v on a.Village_code = v.VCode  
	 group by District_code , HealthBlock_code    ) B on T.HealthBlock_Code = B.HealthBlock_code 
) F on F.DISTRICT_CD= A.DISTRICT_CD and F.HealthBlock_Code= A.BLOCK_CD
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=A.DISTRICT_CD  
 )   
end  
else if(@Category='Block')    
begin    
 select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName  
 ,Village_Population_Status  
 ,isnull(A.Village_Population,0) as Village_Population  
 --,isnull(A.Estimated_EC,0) as Estimated_EC  
 ,isnull( (case when @Month_ID=0 then e.Total_EC_Registered else B.EC_Entry end),0) as EC_Entry,  
 (case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_PW    
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant    
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC     
,isnull((case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),   
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(b.EC_Entry,0)) end ),0) as Prorata  
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0), 
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata
 --,isnull(A.Estimated_MOther,0) as Estimated_PW  
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
 --,[Total_Village]  
 --,([Total_Profile_Entered]+Total_Direct_profile)[Total_Profile_Entered]  
 --    ,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' when [Total_Profile_Entered]=0 then 'Not Completed' else 'Completed' end) as Village_Population_Status  
 ,c.V_Population as Village_Population  
 ,c.Estimated_EC as Estimated_EC  
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant as Estimated_Infant  
 ,c.Total_ActiveVillage--Added on 06032018  
     from TBL_PHC  a  
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD  
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code  
  where c.Financial_Year=@FinancialYr   
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)  
 )  A  
 left outer join  
(  
select  HealthFacility_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_PHC_Wise   
where Financial_Year=@FinancialYr-1   
) X  
on X.HealthFacility_Code=A.HealthFacility_Code  
 left outer join  
 (select Sum(total_distinct_ec)as EC_Entry, HealthBlock_Code, HealthFacility_Code   
 from Scheduled_AC_EC_Block_PHC_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthBlock_Code, HealthFacility_Code) B on B.HealthBlock_Code=A.HealthBlock_Code and B.HealthFacility_Code=A.HealthFacility_Code  
 left outer join  
 (select Sum(PW_Registered)as Mother_Entry, HealthBlock_Code, HealthFacility_Code   
 from Scheduled_AC_PW_Block_PHC_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthBlock_Code, HealthFacility_Code) C on C.HealthBlock_Code=A.HealthBlock_Code and C.HealthFacility_Code=A.HealthFacility_Code  
 left outer join  
 (select Sum(Infant_Registered)as Child_Entry, HealthBlock_Code, HealthFacility_Code   
 from Scheduled_AC_Child_Block_PHC_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthBlock_Code, HealthFacility_Code) D on D.HealthBlock_Code=A.HealthBlock_Code and D.HealthFacility_Code=A.HealthFacility_Code  
  left outer join  
(  
 select  State_Code,HealthBlock_Code,HealthFacility_Code   
,SUM(total_distinct_ec) as Total_EC_Registered    
             
   from Scheduled_AC_EC_Block_PHC_Month (nolock)    
 where State_Code =@State_Code  
 and HealthBlock_Code =@HealthBlock_Code     
 
and (Year_ID<=@Year_ID or @Year_ID=0)  
and (Filter_Type=1)  
and Fin_Yr<=@FinancialYr   
 group by State_Code,HealthBlock_Code,HealthFacility_Code   
 ) E on   A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code 
 left outer join
(
select  HealthBlock_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_PHC_Wise 
where Financial_Year=@FinancialYr and ( HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) group by HealthBlock_Code
) XEC
on XEC.HealthBlock_Code=A.HealthBlock_Code
left outer join
(
select  HealthBlock_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_PHC_Wise 
where Financial_Year=@FinancialYr-1 and ( HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) group by HealthBlock_Code
) XE
on XE.HealthBlock_Code=A.HealthBlock_Code
 left outer join  
(  
 select  State_Code,HealthBlock_Code  
,SUM(total_distinct_ec) as EC_Registered_Pro    
from Scheduled_AC_EC_Block_PHC_Month as EC    
where EC.State_Code =@State_Code  
and (EC.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and Filter_Type=1  
 group by State_Code,HealthBlock_Code
 ) CE on A.HealthBlock_Code=CE.HealthBlock_Code 
   left outer join
(
 select  HealthBlock_Code 
,SUM(total_distinct_ec) as Total_EC_Registered_Pro 
from Scheduled_AC_EC_Block_PHC_Month (nolock)  
 where HealthBlock_Code =@HealthBlock_Code

and (Year_ID<=@Year_ID or @Year_ID=0)
and (Filter_Type=1)
and Fin_Yr<=@FinancialYr 
 group by HealthBlock_Code
 ) EP on A.HealthBlock_Code=EP.HealthBlock_Code  
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
     from TBL_PHC  a
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
     inner join TBL_DISTRICT d on a.DIST_CD = d.DIST_CD 
	 and  a.BID=@HealthBlock_Code 
	)  T left outer join 
	
	(select count(distinct VILLAGE_CD)as Total_Village,PHC_CD from TBL_VILLAGE a group by PHC_CD)V on T.HealthFacility_Code=V.PHC_CD
	left outer join 
	(
	select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a 
	inner join TBL_SUBPHC b on a.SID = b.SUBPHC_CD 
	inner join TBL_PHC c on c.PHC_CD = b.PHC_CD  
	inner join Village v on a.VCode = v.VCode 
	where a.IsActive =1
	group by c.DIST_CD , c.BID , c.PHC_CD  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.HealthFacility_Code 
	left Outer join
	(select  district_code ,healthblock_code,HealthFacility_code, COUNT(village_code) as Total_profile_entered from t_villagewise_registry a
	inner join Health_SC_Village b on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID
	 and Finanacial_Yr = @FinancialYr  and b.IsActive = 1 
	 inner join TBL_PHC c on c.PHC_CD = a.HealthFacility_code 
	 inner join Village v on a.Village_code = v.VCode  
	 group by District_code , HealthBlock_code,HealthFacility_code     ) B on T.HealthBlock_Code = B.HealthBlock_code and T.HealthFacility_Code = B.HealthFacility_code 
) F on    F.HealthBlock_Code= A.HealthBlock_Code and F.PHC_CD = A.HealthFacility_Code
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=@District_Code  
 )
end  
else if(@Category='PHC')    
begin    
 select A.State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName  
 ,F.Village_Population_Status  
 ,isnull(A.Village_Population,0) as Village_Population  
 --,isnull(A.Estimated_EC,0) as Estimated_EC  
 ,isnull( (case when @Month_ID=0 then e.Total_EC_Registered else B.EC_Entry end),0) as EC_Entry,  
 (case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_PW    
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant    
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC     
,isnull((case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),   
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(b.EC_Entry,0)) end ),0) as Prorata  
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0), 
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata
 --,isnull(A.Estimated_MOther,0) as Estimated_PW  
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
 --isnull([Total_Village],0) as [Total_Village]  
   --  ,([Total_Profile_Entered]+Total_Direct_profile)[Total_Profile_Entered]  
  --    ,(case  when [Total_Profile_Entered]=0 then 'Not Completed' when isnull([Total_Village],0)<> isnull([Total_Profile_Entered],1) then 'Not Completed' else 'Completed' end) as Village_Population_Status  
   a.V_Population as Village_Population  
   ,a.Estimated_EC as Estimated_EC  
   ,a.Estimated_Mother as Estimated_Mother  
   ,a.Estimated_Infant as Estimated_Infant  
   ,a.Total_ActiveVillage--Added on 06032018  
      from Estimated_Data_SubCenter_Wise a  
   inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD  
   left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD   
     where a.Financial_Year=@FinancialYr   
     and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)  
      
     )  A   
     left outer join  
(  
select  HealthSubFacility_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_SubCenter_Wise   
where Financial_Year=@FinancialYr-1   and ( HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)   
) X  
on X.HealthSubFacility_Code=A.HealthSubFacility_Code  
 left outer join  
 (select Sum(total_distinct_ec)as EC_Entry, HealthFacility_Code,HealthSubFacility_Code   
 from Scheduled_AC_EC_PHC_SubCenter_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthFacility_Code,HealthSubFacility_Code) B on B.HealthFacility_Code=A.HealthFacility_Code and B.HealthSubFacility_Code=A.HealthSubFacility_Code  
 left outer join  
 (select Sum(PW_Registered)as Mother_Entry, HealthFacility_Code,HealthSubFacility_Code   
 from Scheduled_AC_PW_PHC_SubCenter_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthFacility_Code,HealthSubFacility_Code) C on C.HealthFacility_Code=A.HealthFacility_Code and C.HealthSubFacility_Code=A.HealthSubFacility_Code  
 left outer join  
 (select Sum(Infant_Registered)as Child_Entry, HealthFacility_Code,HealthSubFacility_Code   
 from Scheduled_AC_child_PHC_SubCenter_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by HealthFacility_Code,HealthSubFacility_Code) D on D.HealthFacility_Code=A.HealthFacility_Code and D.HealthSubFacility_Code=A.HealthSubFacility_Code  
 left outer join  
(  
 select  State_Code,HealthFacility_Code,HealthSubFacility_Code  
,SUM(total_distinct_ec) as Total_EC_Registered    
             
   from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code        

and (Year_ID<=@Year_ID or @Year_ID=0)  
and (Filter_Type=1)  
and Fin_Yr<=@FinancialYr   
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code   
 ) E on   A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code 
 left outer join
(
select  HealthFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_SubCenter_Wise 
where Financial_Year=@FinancialYr and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) group by HealthFacility_Code
) XEC
on XEC.HealthFacility_Code=A.HealthFacility_Code
left outer join
(
select  HealthFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_SubCenter_Wise 
where Financial_Year=@FinancialYr-1  and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) group by HealthFacility_Code
) XE
on XE.HealthFacility_Code=A.HealthFacility_Code
 left outer join  
(  
--Monthly registration count on PHC level
 select  State_Code,HealthFacility_Code  
,SUM(total_distinct_ec) as EC_Registered_Pro    
from Scheduled_AC_EC_PHC_SubCenter_Month as EC    
where EC.State_Code =@State_Code  
and (EC.HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0)  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and Filter_Type=1  
 group by State_Code,HealthFacility_Code
 ) CE on A.HealthFacility_Code=CE.HealthFacility_Code 
   left outer join
(
 select  HealthFacility_Code 
,SUM(total_distinct_ec) as Total_EC_Registered_Pro 
from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)  
 where HealthFacility_Code =@HealthFacility_Code

and (Year_ID<=@Year_ID or @Year_ID=0)
and (Filter_Type=1)
and Fin_Yr<=@FinancialYr 
 group by HealthFacility_Code
 ) EP on A.HealthFacility_Code=EP.HealthFacility_Code    
 left outer join   
 ( Select State_Code,T.DIST_CD,  T.HealthBlock_Code , T.PHC_CD ,T.SUBPHC_CD
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	,isnull(V.Total_Village,0) as Village,
	(case  when [Total_Profile_Entered]=0 then 'Not Completed' when isnull(A.Total_mapped_village,0)<> isnull([Total_Profile_Entered],1) then 'Not Completed' else 'Completed' end) as Village_Population_Status  
	 from 
	
	(select  stateid as State_Code,a.DIST_CD,  c.BLOCK_CD as HealthBlock_Code,a.PHC_CD ,b.PHC_NAME  as Healthphc_Name ,a.SUBPHC_CD ,a.SUBPHC_NAME_E 
	 from TBL_SUBPHC   a
     inner join TBL_phc b on a.PHC_CD =b.PHC_CD  and a.DIST_CD = b.DIST_CD 
      inner join TBL_HEALTH_BLOCK  c on b.BID =c.BLOCK_CD  and a.DIST_CD = c.DISTRICT_CD 
      inner join TBL_DISTRICT d on a.DIST_CD = d.DIST_CD 
	 and  a.DIST_CD =@District_Code  and  c.BLOCK_CD = @HealthBlock_Code  and a.PHC_CD = @HealthFacility_Code) T
	 Left Outer Join 
	 
	(select count(distinct VILLAGE_CD)as Total_Village,SUBPHC_CD  from TBL_VILLAGE a group by SUBPHC_CD )V on T.SUBPHC_CD =V.SUBPHC_CD 
	Left Outer join   
	( select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,a.SID ,  COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a 
	inner join TBL_SUBPHC b on a.SID = b.SUBPHC_CD 
	inner join TBL_PHC c on c.PHC_CD = b.PHC_CD  
	inner join Village v on a.VCode = v.VCode 
	where a.IsActive =1
	group by c.DIST_CD , c.BID , c.PHC_CD , a.SID  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.PHC_CD and A.SID = T.SUBPHC_CD
	Left Outer join
	(select  district_code ,healthblock_code,HealthFacility_code,healthsubcentre_code,  COUNT(village_code) as Total_profile_entered from t_villagewise_registry a
	 inner join Health_SC_Village b on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID
	 and Finanacial_Yr = @FinancialYr  and b.IsActive = 1 
	 inner join TBL_PHC c on c.PHC_CD = a.HealthFacility_code 
	 inner join Village v on a.Village_code = v.VCode  
	 group by District_code , HealthBlock_code,HealthFacility_code , HealthSubCentre_code) B on T.HealthBlock_Code = B.HealthBlock_code and T.PHC_CD = B.HealthFacility_code  and T.SUBPHC_CD = b.HealthSubCentre_code

 
 )F on A.State_Code = F.State_code and A.HealthFacility_Code=F.PHC_CD and A.HealthSubFacility_Code=F.SUBPHC_CD
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=@District_Code  
 )   
end  
else if(@Category='Subcentre')    
begin    
 select SID as ParentID,VCode as ChildID,SUBPHC_NAME_E as ParentName,Vilage_Name as ChildName,F.Village_Population_Status  
 ,isnull(A.Village_Population,0) as Village_Population  
 --,isnull(A.Estimated_EC,0) as Estimated_EC  
 ,isnull( (case when @Month_ID=0 then e.Total_EC_Registered else B.EC_Entry end),0) as EC_Entry,  
 (case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_PW    
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant    
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC     
,isnull((case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),   
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(b.EC_Entry,0)) end ),0) as Prorata  
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0), 
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata
 --,isnull(A.Estimated_MOther,0) as Estimated_PW  
 ,isnull(C.Mother_Entry,0) as Mother_Entry  
 ,isnull(D.Child_Entry,0) as Child_Entry  
 ,ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Entered  
 ,ISNULL(F.[Total_Village],0) as [Total_Village]  
 ,@daysPast as daysPast  
 ,@Daysinyear as DaysinYear  
 ,'--' as Village  
 --,ISNULL(F.[Total_Village],0)-ISNULL(F.Total_Profile_Entered,0) as Total_Profile_Not_Entered --Added on 06032018  
 ,F.Total_Profile_Not_Entered
  from (  
 (select  c.HealthSubFacility_Code as SID,isnull(c.Village_Code,0) as VCode,sp.SUBPHC_NAME_E,isnull(vn.VILLAGE_NAME,'Direct Entry') as Vilage_Name  
 --,(case when Village_Population=0 then 'Not Completed' else 'Completed' end)as Village_Population_Status,1 as [Total_Village]  
 --,(case when Village_Population<>0 then 1 else 0 end)[Total_Profile_Entered]  
 ,Village_Population  
 ,c.Estimated_EC as Estimated_EC  
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant as Estimated_Infant  
-- ,(case when c.Village_Status=1 then 1 else 0 end) as [Total_Village_mapped]--Added on 06032018  
 from Estimated_Data_Village_Wise  c  
 --left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code --order by VILLAGE_CD  
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code  
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code  
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
 and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr) A  
 left outer join  
(  
select  Village_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_Village_Wise   
where Financial_Year=@FinancialYr-1  and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
) X  
on X.Village_Code=A.VCode  
 left outer join  
 (select Sum(total_distinct_ec)as EC_Entry, Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code   
 from Scheduled_AC_EC_PHC_SubCenter_Village_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by Village_Code,HealthSubFacility_Code) B on B.Village_Code=A.VCode and B.HealthSubFacility_Code=A.SID  
 left outer join  
 (select Sum(PW_Registered)as Mother_Entry,Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code   
 from Scheduled_AC_PW_PHC_SubCenter_Village_Month    
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by Village_Code,HealthSubFacility_Code) C on C.Village_Code=A.VCode and C.HealthSubFacility_Code=A.SID  
 left outer join  
 (select Sum(Infant_Registered)as Child_Entry,Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code   
 from Scheduled_AC_Child_PHC_SubCenter_Village_Month   
 where Fin_Yr=@FinancialYr   
 and (Month_ID =@Month_ID or @Month_ID=0)  
 and (Year_ID =@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
 group by Village_Code,HealthSubFacility_Code) D on D.Village_Code=A.VCode and D.HealthSubFacility_Code=A.SID  
  left outer join  
(  
 select  State_Code,HealthSubFacility_Code,Village_Code  
,SUM(total_distinct_ec) as Total_EC_Registered    
             
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code   
 and HealthSubFacility_Code =@HealthSubFacility_Code     

and (Year_ID<=@Year_ID or @Year_ID=0)  
and (Filter_Type=1)  
and Fin_Yr<=@FinancialYr   
group by State_Code,HealthSubFacility_Code,Village_Code   
 ) E on     A.SID=E.HealthSubFacility_Code and A.VCode=E.Village_Code  
  left outer join
(
select  HealthSubFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Village_Wise 
where Financial_Year=@FinancialYr and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) group by HealthSubFacility_Code
) XEC
on XEC.HealthSubFacility_Code=A.SID
left outer join
(
select  HealthSubFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Village_Wise 
where Financial_Year=@FinancialYr-1  and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) group by HealthSubFacility_Code
) XE
on XE.HealthSubFacility_Code=A.SID
 left outer join  
(  
--Monthly registration count on Subcenter level
 select  State_Code,HealthSubFacility_Code  
,SUM(total_distinct_ec) as EC_Registered_Pro    
from Scheduled_AC_EC_PHC_SubCenter_Village_Month as EC    
where EC.State_Code =@State_Code  
and (EC.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and Filter_Type=1  
 group by State_Code,HealthSubFacility_Code
 ) CE on A.SID=CE.HealthSubFacility_Code 
   left outer join
(
 select  HealthSubFacility_Code 
,SUM(total_distinct_ec) as Total_EC_Registered_Pro 
from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)  
 where HealthSubFacility_Code =@HealthSubFacility_Code
and Village_Code !=0
and (Year_ID<=@Year_ID or @Year_ID=0)
and (Filter_Type=1)
and Fin_Yr<=@FinancialYr 
 group by HealthSubFacility_Code
 ) EP on A.SID=EP.HealthSubFacility_Code 
 left outer join   
 ( Select T.State_Code, T.DIST_CD ,T.HealthBlock_Code ,T.PHC_CD ,T.SUBPHC_CD ,T.VILLAGE_CD 
 ,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	,isnull(V.Total_Village,0) as Village
	,(case  when [Total_Profile_Entered]=0 then 'Not Completed' when isnull(A.Total_mapped_village,0)<> isnull([Total_Profile_Entered],0) then 'Not Completed' else 'Completed' end) as Village_Population_Status  
	 from (
	
	select stateid as State_Code,a.DIST_CD,  c.BLOCK_CD as HealthBlock_Code,a.PHC_CD ,a.SUBPHC_CD ,d.SUBPHC_NAME_E ,a.VILLAGE_CD,a.VILLAGE_NAME
	 from TBL_VILLAGE    a
	 inner join TBL_SUBPHC d on a.SUBPHC_CD = d.SUBPHC_CD
     inner join TBL_phc b on a.PHC_CD =b.PHC_CD  and a.DIST_CD = b.DIST_CD 
      inner join TBL_HEALTH_BLOCK  c on b.BID =c.BLOCK_CD  and a.DIST_CD = c.DISTRICT_CD 
      inner join TBL_DISTRICT e on a.DIST_CD = e.DIST_CD
	 and  a.DIST_CD =@District_Code  and  c.BLOCK_CD = @HealthBlock_Code and a.PHC_CD = @HealthFacility_Code and a.SUBPHC_CD=@HealthSubFacility_Code  ) T
	 
	 Left Outer Join 
	 
	(select count(distinct VILLAGE_CD)as Total_Village,VILLAGE_CD   from TBL_VILLAGE a group by VILLAGE_CD  )V on T.VILLAGE_CD =V.VILLAGE_CD 
	Left Outer join   
	( select c.DIST_CD   , c.bid as Health_block_code ,c.PHC_CD HealthFacility_code,a.SID , a.VCode , COUNT(a.VCode ) as Total_mapped_village from Health_SC_Village  a 
	inner join TBL_SUBPHC b on a.SID = b.SUBPHC_CD 
	inner join TBL_PHC c on c.PHC_CD = b.PHC_CD  
	inner join Village v on a.VCode = v.VCode 
	where a.IsActive =1
	group by c.DIST_CD , c.BID , c.PHC_CD , a.SID ,a.VCode  ) A ON  T.HealthBlock_Code = A.Health_block_code  and A.HealthFacility_code = T.PHC_CD and A.SID = T.SUBPHC_CD and a.VCode = t.VILLAGE_CD
	Left Outer join
	(select  district_code ,healthblock_code,HealthFacility_code,healthsubcentre_code,village_code , COUNT(village_code) as Total_profile_entered from t_villagewise_registry a
	 inner join Health_SC_Village b on a.Village_code = b.VCode and a.HealthSubCentre_code = b.SID
	 and Finanacial_Yr = @FinancialYr  and b.IsActive = 1 
	 inner join TBL_PHC c on c.PHC_CD = a.HealthFacility_code 
	 inner join Village v on a.Village_code = v.VCode  
	 group by District_code , HealthBlock_code,HealthFacility_code , HealthSubCentre_code, Village_code ) B on T.HealthBlock_Code = B.HealthBlock_code and T.PHC_CD = B.HealthFacility_code  and T.SUBPHC_CD = b.HealthSubCentre_code and t.VILLAGE_CD = b.Village_code 

 ) F on A.SID = F.SUBPHC_CD  and A.VCode = F.VILLAGE_CD 
 --(select count(VCode)as Total_Village ,DCode from Village where IsActive=1 group by DCode) E on E.DCode=@District_Code  
 ) 
   
end  
  
end  
  
