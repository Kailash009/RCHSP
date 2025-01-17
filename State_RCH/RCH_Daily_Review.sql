USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[RCH_Daily_Review]    Script Date: 09/26/2024 12:18:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* 
[RCH_Daily_Review] 28,11,0,0,0,0,2015,0,0,'','','District'  
[RCH_Daily_Review] 28,11,558,0,0,0,2015,0,0,'','','Block'  
[RCH_Daily_Review] 28,22,270,443,0,0,2015,0,0,'','','PHC'  
[RCH_Daily_Review] 28,22,270,443,1918,0,2015,0,0,'','','SubCentre'  
*/
ALTER proc [dbo].[RCH_Daily_Review]
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

if(@Category='District')  
begin  
	select DISTRICT_CD as ParentID,District_Name as ParentName,BLOCK_CD as ChildID,Block_Name_E as ChildName,Village_Population_Status
	,isnull(A.Village_Population,0) as Village_Population
	,isnull(A.Estimated_EC,0) as Estimated_EC
	,isnull(B.EC_Entry,0) as EC_Entry
	,isnull(A.Estimated_MOther,0) as Estimated_PW
	,isnull(C.Mother_Entry,0) as Mother_Entry
	,isnull(A.Estimated_Infant,0) as Estimated_Infant
	,isnull(D.Child_Entry,0) as Child_Entry
	,ISNULL(A.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.[Total_Village],0) as [Total_Village]
	 from (
	(select  b.DIST_CD ,b.BLOCK_CD,b.DIST_NAME_ENG as District_Name,b.Block_Name_E,[Total_Village],[Total_Profile_Entered]
	,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' else 'Completed' end)as Village_Population_Status
	,c.V_Population as Village_Population,Estimated_EC as Estimated_EC,Estimated_Mother,Estimated_Infant from Name_Block b
	left outer join Estimated_Data_Block_Wise c on b.BLOCK_CD=c.HealthBlock_Code --order by VILLAGE_CD
	where (b.DIST_CD=@District_Code or @District_Code=0) and c.Financial_Year=@FinancialYr) A
	left outer join
	(select Sum(EC_Count)as EC_Entry, District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code from Scheduled_BR_District_Block_Reg_Count  group by District_Code,HealthBlock_Code) B on B.District_Code=A.DIST_CD and B.HealthBlock_Code=A.BLOCK_CD
	left outer join
	(select Sum(Mother_Count)as Mother_Entry,District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code from Scheduled_BR_District_Block_Reg_Count  group by District_Code,HealthBlock_Code) C on C.District_Code=A.DIST_CD and C.HealthBlock_Code=A.BLOCK_CD
	left outer join
	(select Sum(Child_Count)as Child_Entry,District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code from Scheduled_BR_District_Block_Reg_Count group by District_Code,HealthBlock_Code) D on D.District_Code=A.DIST_CD and D.HealthBlock_Code=A.BLOCK_CD
	) 
end
if(@Category='Block')  
begin  
	select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName
	,Village_Population_Status
	,isnull(A.Village_Population,0) as Village_Population
	,isnull(A.Estimated_EC,0) as Estimated_EC
	,isnull(B.EC_Entry,0) as EC_Entry
	,isnull(A.Estimated_MOther,0) as Estimated_PW
	,isnull(C.Mother_Entry,0) as Mother_Entry
	,isnull(A.Estimated_Infant,0) as Estimated_Infant
	,isnull(D.Child_Entry,0) as Child_Entry
	,ISNULL(A.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.[Total_Village],0) as [Total_Village]
	 from (
	(select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name,[Total_Village],[Total_Profile_Entered]
     ,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' else 'Completed' end)as Village_Population_Status
	,c.V_Population as Village_Population,Estimated_EC as Estimated_EC,Estimated_Mother,Estimated_Infant
     from TBL_PHC  a
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code
	 where c.Financial_Year=@FinancialYr 
	 and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)
	)  A
	left outer join
	(select Sum(EC_Count)as EC_Entry, HealthBlock_Code, HealthFacility_Code from Scheduled_BR_Block_PHC_Reg_Count  group by HealthBlock_Code, HealthFacility_Code) B on B.HealthBlock_Code=A.HealthBlock_Code and B.HealthFacility_Code=A.HealthFacility_Code
	left outer join
	(select Sum(Mother_Count)as Mother_Entry, HealthBlock_Code, HealthFacility_Code from Scheduled_BR_Block_PHC_Reg_Count  group by HealthBlock_Code, HealthFacility_Code) C on C.HealthBlock_Code=A.HealthBlock_Code and C.HealthFacility_Code=A.HealthFacility_Code
	left outer join
	(select Sum(Child_Count)as Child_Entry, HealthBlock_Code, HealthFacility_Code from Scheduled_BR_Block_PHC_Reg_Count group by HealthBlock_Code, HealthFacility_Code) D on D.HealthBlock_Code=A.HealthBlock_Code and D.HealthFacility_Code=A.HealthFacility_Code
	) 
end
if(@Category='PHC')  
begin  
	select A.State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName,[Total_Village],[Total_Profile_Entered]
	,Village_Population_Status
	,isnull(A.Village_Population,0) as Village_Population
	,isnull(A.Estimated_EC,0) as Estimated_EC
	,isnull(B.EC_Entry,0) as EC_Entry
	,isnull(A.Estimated_MOther,0) as Estimated_PW
	,isnull(C.Mother_Entry,0) as Mother_Entry
	,isnull(A.Estimated_Infant,0) as Estimated_Infant
	,isnull(D.Child_Entry,0) as Child_Entry
	,ISNULL(A.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.[Total_Village],0) as [Total_Village]
	 from (
	(select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name,[Total_Village],[Total_Profile_Entered]
      ,(case when [Total_Village]<> [Total_Profile_Entered] then 'Not Completed' else 'Completed' end)as Village_Population_Status
	  ,c.V_Population as Village_Population,Estimated_EC as Estimated_EC,Estimated_Mother,Estimated_Infant
      from TBL_SUBPHC a
	  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
      inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code
     where c.Financial_Year=@FinancialYr 
     and ( a.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)
     )  A 
	left outer join
	(select Sum(EC_Count)as EC_Entry, HealthFacility_Code,HealthSubFacility_Code from Scheduled_BR_PHC_SubCenter_Reg_Count  group by HealthFacility_Code,HealthSubFacility_Code) B on B.HealthFacility_Code=A.HealthFacility_Code and B.HealthSubFacility_Code=A.HealthSubFacility_Code
	left outer join
	(select Sum(Mother_Count)as Mother_Entry, HealthFacility_Code,HealthSubFacility_Code from Scheduled_BR_PHC_SubCenter_Reg_Count  group by HealthFacility_Code,HealthSubFacility_Code) C on C.HealthFacility_Code=A.HealthFacility_Code and C.HealthSubFacility_Code=A.HealthSubFacility_Code
	left outer join
	(select Sum(Child_Count)as Child_Entry, HealthFacility_Code,HealthSubFacility_Code from Scheduled_BR_PHC_SubCenter_Reg_Count group by HealthFacility_Code,HealthSubFacility_Code) D on D.HealthFacility_Code=A.HealthFacility_Code and D.HealthSubFacility_Code=A.HealthSubFacility_Code
	) 
end
if(@Category='Subcentre')  
begin  
	select SID as ParentID,VCode as ChildID,SUBPHC_NAME as ParentName,Vilage_Name as ChildName,Village_Population_Status
	,isnull(A.Village_Population,0) as Village_Population
	,isnull(A.Estimated_EC,0) as Estimated_EC
	,isnull(B.EC_Entry,0) as EC_Entry
	,isnull(A.Estimated_MOther,0) as Estimated_PW
	,isnull(C.Mother_Entry,0) as Mother_Entry
	,isnull(A.Estimated_Infant,0) as Estimated_Infant
	,isnull(D.Child_Entry,0) as Child_Entry
	,ISNULL(A.Total_Profile_Entered,0) as Total_Profile_Entered
	,ISNULL(A.[Total_Village],0) as [Total_Village]
	 from (
	(select  v.SID,v.VCode,sp.SUBPHC_NAME,vn.VILLAGE_NAME as Vilage_Name
	,(case when Village_Population=0 then 'Not Completed' else 'Completed' end)as Village_Population_Status,1 as [Total_Village],(case when Village_Population<>0 then 1 else 0 end)[Total_Profile_Entered]
	,Village_Population,Estimated_EC,Estimated_Mother,Estimated_Infant	from Health_SC_Village v
	left outer join Estimated_Data_Village_Wise c on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code --order by VILLAGE_CD
	left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=v.VCode
	left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=v.SID
	where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr) A
	left outer join
	(select Sum(EC_Count)as EC_Entry, Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code from Scheduled_BR_PHC_SC_Village_Reg_Count  group by Village_Code,HealthSubFacility_Code) B on B.Village_Code=A.VCode and B.HealthSubFacility_Code=A.SID
	left outer join
	(select Sum(Mother_Count)as Mother_Entry,Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code from Scheduled_BR_PHC_SC_Village_Reg_Count  group by Village_Code,HealthSubFacility_Code) C on C.Village_Code=A.VCode and C.HealthSubFacility_Code=A.SID
	left outer join
	(select Sum(Child_Count)as Child_Entry,Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code from Scheduled_BR_PHC_SC_Village_Reg_Count group by Village_Code,HealthSubFacility_Code) D on D.Village_Code=A.VCode and D.HealthSubFacility_Code=A.SID
	) 
end


end










