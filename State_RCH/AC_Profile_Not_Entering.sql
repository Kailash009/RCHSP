USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[AC_Profile_Not_Entering]    Script Date: 09/26/2024 14:39:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* 
[AC_Profile_Not_Entering] 0,0,0,0,0,0,2017,0,0,'','','National' 
[AC_Profile_Not_Entering_New] 23,0,0,0,0,0,2019,0,0,'','','State'
[AC_Profile_Not_Entering_New] 30,1,0,0,0,0,2019,0,0,'','','District'
[AC_Profile_Not_Entering_New] 30,56,191,0,0,0,2019,0,0,'','','Block'
[AC_Profile_Not_Entering_New] 30,1,1,1,0,0,2019,0,0,'','','PHC'
[AC_Profile_Not_Entering_New] 23,1,1,1,9,0,2019,0,0,'','','Subcentre'

*/
ALTER proc [dbo].[AC_Profile_Not_Entering]
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
	exec RCH_Reports.dbo.AC_Profile_Not_Entering @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,  
	@FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category
end

if(@Category='State')  
begin  
--	select StateID as ParentID,StateName as ParentName,DIST_CD as ChildID,DIST_NAME_ENG as ChildName
--	,ISNULL(C.Total_Profile_Entered,0) as Total_Profile_Entered
--	,ISNULL(C.[Total_Village_mapped],0) as [Total_Village]
--	,ISNULL(C.[Total_Village_mapped],1)-ISNULL(C.Total_Profile_Entered,0) as Total_Profile_Not_Entered -- changed by aruna on 13052019
--	,ISNULL(C.Total_Direct_Profile,0) as Total_Direct_Profile
--	,@daysPast as daysPast 
--	,@Daysinyear as DaysinYear
--	,isnull(B.Total_Village,0) as Village
--	 from (
--	(
--	select  a.StateID,a.DIST_CD,c.StateName ,a.DIST_NAME_ENG 
--	from TBL_DISTRICT a
--	left outer join TBL_STATE c on a.StateID=c.StateID) A
--	left outer join 
--	(select count(VCode)as Total_Village,@State_Code as StateCode ,DCode as DCode from Village 
--	group by DCode) B on A.StateID=B.StateCode and B.DCode=A.DIST_CD
--	)
--	left outer join 
--	(
--	 select District_Code as ChildID,State_Code as ParentID,Total_Village as Total_Village_mapped
--	 ,Total_Profile_Entered Total_Profile_Entered
--	 ,Total_Direct_Profile as Total_Direct_Profile
--	 ,Total_ActiveVillage--Added on 16022018
--	 from Estimated_Data_District_Wise  where Financial_Year=@FinancialYr 
--	) C on A.StateID=C.ParentID and A.DIST_CD=C.ChildID


select T.State_Code as ParentID , T.StateName as ParentName, T.DIST_CD as ChildID,T.DIST_NAME_ENG as ChildName , isnull(V.Total_Village,0) Village , isnull(A.mapped_village,0) Total_village, 
isnull(B.profile_entered,0) Total_Profile_Entered ,
isnull(A.mapped_village,0) - isnull(B.profile_entered,0) Total_Profile_Not_Entered 
	,@daysPast as daysPast
	,@Daysinyear as DaysinYear
from 

(  select a.StateID  as State_Code, c.StateName , a.DIST_CD  ,a.DIST_NAME_ENG
	 from TBL_District  a
	 left outer join TBL_STATE c on a.StateID=c.StateID
   	 ) T 
	 Left Outer Join 
(select a.dcode, COUNT(Distinct vcode ) as Total_village from VILLAGE a

  group by a.dcode  ) V  on v.dcode = T.DIST_CD 
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


end
else if(@Category='District')  
begin  
	select T.DISTRICT_CD as ParentID,T.DIST_NAME_ENG as ParentName,BLOCK_CD as ChildID,T.HealthBlock_Name  as ChildName
	,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,isnull(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	,isnull(V.Total_Village,0) as Village
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

	end
else if(@Category='Block')  
begin  
	select T.State_Code,T. HealthBlock_Code as ParentID,T.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID
	,T.HealthFacility_Name as ChildName
	,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,isnull(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	--,ISNULL(C.Total_Direct_Profile,0) as Total_Direct_Profile
	,@daysPast as daysPast
	,@Daysinyear as DaysinYear
	,isnull(V.Total_Village,0) as Village
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

end
else if(@Category='PHC')  
begin  
	select T.State_Code,T.PHC_CD as  ParentID,T.SUBPHC_CD  as ChildID,T.Healthphc_Name  as ParentName,T.SUBPHC_NAME_E  as ChildName
	,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	--,ISNULL(C.Total_Direct_Profile,0) as Total_Direct_Profile
	,@daysPast as daysPast
	,@Daysinyear as DaysinYear
	,isnull(V.Total_Village,0) as Village
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

	
end
else if(@Category='Subcentre')  
begin  
	select T.SUBPHC_CD  as ParentID,T.VILLAGE_CD  as ChildID,T.SUBPHC_NAME_E  as ParentName,T.VILLAGE_NAME  as ChildName
	,ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.Total_mapped_village ,0) as [Total_Village]
	,ISNULL(A.Total_mapped_village,0)-ISNULL(B.Total_Profile_Entered,0) as Total_Profile_Not_Entered 
	
	,@daysPast as daysPast
	,@Daysinyear as DaysinYear
	,isnull(V.Total_Village,0) as Village
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

	
end

end



