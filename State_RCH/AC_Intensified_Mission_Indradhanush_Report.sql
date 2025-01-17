USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Intensified_Mission_Indradhanush_Report]    Script Date: 09/26/2024 11:52:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 


/*    
    [AC_Intensified_Mission_Indradhanush_Report] 30,0,0,0,0,0,2019,0,0,'State',1
    [AC_Intensified_Mission_Indradhanush_Report] 30,1,0,0,0,0,2019,0,0,'District',0   
    [AC_Intensified_Mission_Indradhanush_Report] 30,1,3,0,0,0,2019,0,0,'Block',0   
    [AC_Intensified_Mission_Indradhanush_Report] 30,1,3,11,0,0,2019,0,0,'PHC',0   
    [AC_Intensified_Mission_Indradhanush_Report] 30,1,3,11,36,0,2019,0,0,'SubCentre',0   
   
*/    
ALTER procedure [dbo].[AC_Intensified_Mission_Indradhanush_Report]    
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
@Category varchar(20) ='District'  ,    
@Type int =0 --All states,IMI States    
)    
    
as    
begin   
SET NOCOUNT ON; 
    
if(@Category='State')    
Begin    
     
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,
Isnull(A.[Estimated_Infant],0) as [Estimated_Infant] 
,ISNULL(A.[IMI_Target],0)as [IMI_Target] 
,Isnull(C.[Estimated_0_2_Infant],0)as [Estimated_0_2_Infant]   
,ISNULL(Total_Registered,0) as Total_Registered    
,ISNULL(Started_Vaccination,0)as Started_Vaccination    
,ISNULL(Birthdose_Exp_VitK,0) as Birthdose_Exp_VitK    
,ISNULL([Total_0_2_child],0) as [Total_0_2_child]    
,ISNULL([Total_0_2_Started_Vaccination],0)as [Total_0_2_Started_Vaccination]   
from        
 (select a.StateID as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name,c.Estimated_Infant as [Estimated_Infant],a.Is_IMI as [IMI_Target]      
 from  TBL_DISTRICT (NOLOCK) a       
 inner join TBL_STATE (NOLOCK) b on a.StateID=b.StateID      
 inner join Estimated_Data_District_Wise (NOLOCK) c on a.DIST_CD=c.District_Code    
where c.Financial_Year=@FinancialYr     
and ISNULL(a.Is_IMI,0)=@Type  
) A      
left outer join      
(select c.State_Code as State_Code,c.District_Code as District_Code,SUM(c.Estimated_Infant) as [Estimated_0_2_Infant]   
 from  Estimated_Data_District_Wise (NOLOCK) c     
where c.Financial_Year Between @FinancialYr -1 and @FinancialYr       
group by c.State_Code,c.District_Code    
) C  on A.State_Code =C.State_Code and A.District_Code=C.District_Code     
left outer join      
(      
select  State_Code,District_Code,    
sum(Child_0_1) as Total_Registered    
,sum([Child_0_1]+[Child_1_2]) as [Total_0_2_child]    
,SUM(Started_Vaccination_0_1+Started_Vaccination_1_2) as [Total_0_2_Started_Vaccination]   
,sum(Started_Vaccination_0_1)  as Started_Vaccination    
,sum(Birthdose_Exp_VitK) as Birthdose_Exp_VitK    
FROM dbo.Scheduled_AC_Child_State_District_Month (NOLOCK)   
where State_Code=@State_Code    
and Filter_Type=1    
and Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
group by State_Code,District_Code    
)       
 B on  A.State_Code =B.State_Code and A.District_Code=B.District_Code     
end    
    
else if(@Category='District')    
Begin    

select A.District_Code as ParentID,A.District_Name as ParentName,
A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName,  
Isnull(A.[Estimated_Infant],0) as [Estimated_Infant]
,ISNULL(A.[IMI_Target],0) as [IMI_Target], 
Isnull(C.[Estimated_0_2_Infant],0) as [Estimated_0_2_Infant]   
,ISNULL(Total_Registered,0) as Total_Registered    
,ISNULL(Started_Vaccination,0)as Started_Vaccination    
,ISNULL(Birthdose_Exp_VitK,0) as Birthdose_Exp_VitK    
,ISNULL([Total_0_2_child],0) as [Total_0_2_child]    
,ISNULL([Total_0_2_Started_Vaccination],0)as [Total_0_2_Started_Vaccination]   
from        
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name,c.Estimated_Infant as [Estimated_Infant],b.Is_IMI as [IMI_Target]        
from TBL_HEALTH_BLOCK (NOLOCK) a      
inner join TBL_DISTRICT (NOLOCK) b on a.DISTRICT_CD=b.DIST_CD      
inner join Estimated_Data_Block_Wise (NOLOCK) c on a.BLOCK_CD=c.HealthBlock_Code    
where c.Financial_Year=@FinancialYr     
and a.DISTRICT_CD=@District_Code    
and ISNULL(b.Is_IMI,0)=@Type   
) A      
left outer join      
(select a.DISTRICT_CD as District_Code,c.HealthBlock_Code as HealthBlock_Code,SUM(c.Estimated_Infant) as [Estimated_0_2_Infant]   
 from  Estimated_Data_Block_Wise (NOLOCK) c     
 inner join TBL_Health_Block (NOLOCK) a on a.Block_CD=c.HealthBlock_Code    
where c.Financial_Year Between @FinancialYr -1 and @FinancialYr       
group by a.DISTRICT_CD,c.HealthBlock_Code    
) C on A.District_Code =C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code     
left outer join     
(select  District_Code,HealthBlock_Code     
,sum(Child_0_1) as Total_Registered    
,sum([Child_0_1]+[Child_1_2]) as [Total_0_2_child]    
,SUM(Started_Vaccination_0_1+Started_Vaccination_1_2) as [Total_0_2_Started_Vaccination]   
,sum(Started_Vaccination_0_1)  as Started_Vaccination    
,sum(Birthdose_Exp_VitK) as Birthdose_Exp_VitK    
FROM dbo.Scheduled_AC_Child_District_Block_Month (NOLOCK)    
where (District_Code=@District_Code)    
and Filter_Type=1    
and Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
group by District_Code,HealthBlock_Code     
) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code    

end    
    
else if(@Category='Block')    
Begin    

 select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,
 A.HealthFacility_Code as ChildID,
 A.HealthFacility_Name as ChildName,  
 Isnull(A.[Estimated_Infant],0) as [Estimated_Infant], 
 Isnull(C.[Estimated_0_2_Infant],0) as [Estimated_0_2_Infant]   
,ISNULL(Total_Registered,0) as Total_Registered    
,ISNULL(Started_Vaccination,0) as Started_Vaccination    
,ISNULL(Birthdose_Exp_VitK,0) as Birthdose_Exp_VitK    
,ISNULL([Total_0_2_child],0) as [Total_0_2_child]    
,ISNULL([Total_0_2_Started_Vaccination],0)as [Total_0_2_Started_Vaccination]   
 from      
 (    
select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name    
,c.Estimated_Infant as [Estimated_Infant]    
from TBL_PHC (NOLOCK) a    
inner join TBL_HEALTH_BLOCK (NOLOCK) b on a.BID=b.BLOCK_CD    
inner join Estimated_Data_PHC_Wise (NOLOCK) c on a.PHC_CD=c.HealthFacility_Code    
inner join TBL_DISTRICT (NOLOCK) d on a.DIST_CD=d.DIST_CD     
where c.Financial_Year=@FinancialYr     
and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)      
and ISNULL(d.Is_IMI,0)=@Type
) A    
left outer join    
(select a.BID as HealthBlock_Code,c.HealthFacility_Code as HealthFacility_Code,SUM(c.Estimated_Infant) as [Estimated_0_2_Infant]   
 from  Estimated_Data_PHC_Wise (NOLOCK) c     
 inner join TBL_PHC (NOLOCK) a on c.HealthFacility_Code=a.PHC_CD    
where c.Financial_Year Between @FinancialYr -1 and @FinancialYr         
group by a.BID,c.HealthFacility_Code    
) C on A.HealthBlock_Code =C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code     
left outer join    
(    
select HealthBlock_Code,HealthFacility_Code    
,sum(Child_0_1) as Total_Registered    
,sum([Child_0_1]+[Child_1_2]) as [Total_0_2_child]    
,SUM(Started_Vaccination_0_1+Started_Vaccination_1_2) as [Total_0_2_Started_Vaccination]   
,sum(Started_Vaccination_0_1)  as Started_Vaccination    
,sum(Birthdose_Exp_VitK) as Birthdose_Exp_VitK    
FROM dbo.Scheduled_AC_Child_Block_PHC_Month (NOLOCK) a    
where (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)    
and Filter_Type=1    
and Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
group by HealthBlock_Code,HealthFacility_Code    
)B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code    
    
end    
    
    
else if(@Category='PHC' or @Category='SubCentre')    
Begin       
select A.HealthFacility_Code as ParentID
,A.HealthFacility_Name as ParentName 
,A.HealthSubFacility_Code as ChildID
,A.HealthSubFacility_Name as ChildName
,Isnull(A.[Estimated_Infant],0)as [Estimated_Infant]
, Isnull(C.[Estimated_0_2_Infant],0)as [Estimated_0_2_Infant]   
,ISNULL(Total_Registered,0) as Total_Registered    
,ISNULL(Started_Vaccination,0)as Started_Vaccination    
,ISNULL(Birthdose_Exp_VitK,0) as Birthdose_Exp_VitK    
,ISNULL([Total_0_2_child],0) as [Total_0_2_child]    
,ISNULL([Total_0_2_Started_Vaccination],0)as [Total_0_2_Started_Vaccination]   
from     
 (select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name,c.Estimated_Infant as [Estimated_Infant]    
from TBL_SUBPHC (NOLOCK) a    
inner join TBL_PHC (NOLOCK) b on a.PHC_CD=b.PHC_CD    
inner join  Estimated_Data_SubCenter_Wise (NOLOCK) c on a.SUBPHC_CD=c.HealthSubFacility_Code    
inner join TBL_DISTRICT (NOLOCK) d on a.DIST_CD=d.DIST_CD    
where c.Financial_Year=@FinancialYr     
and ( a.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)    
and (a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)    
and ISNULL(d.Is_IMI,0)=@Type
) A    
left outer join    
(select c.HealthFacility_Code as HealthFacility_Code,c.HealthSubFacility_Code as HealthSubFacility_Code,SUM(c.Estimated_Infant) as [Estimated_0_2_Infant]   
 from  Estimated_Data_SubCenter_Wise (NOLOCK) c     
where c.Financial_Year Between @FinancialYr -1 and @FinancialYr       
group by c.HealthFacility_Code,c.HealthSubFacility_Code    
) C     
 on A.HealthFacility_Code =C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code     
    
left outer join    
(    
 select HealthSubFacility_Code,HealthFacility_Code    
,sum(Child_0_1) as Total_Registered    
,sum([Child_0_1]+[Child_1_2]) as [Total_0_2_child]    
,SUM(Started_Vaccination_0_1+Started_Vaccination_1_2) as [Total_0_2_Started_Vaccination]   
,sum(Infant_Low_birth_Weight) as Infant_Low_birth_Weight    
,sum(Started_Vaccination_0_1)  as Started_Vaccination    
,sum(Birthdose_Exp_VitK) as Birthdose_Exp_VitK    
FROM dbo.Scheduled_AC_Child_PHC_SubCenter_Month (NOLOCK)    
where (HealthFacility_Code=@HealthFacility_Code)    
and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)    
group by HealthSubFacility_Code,HealthFacility_Code    
)  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code    
end    
    
END    
    
    
    
      