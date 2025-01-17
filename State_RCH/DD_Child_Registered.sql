USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[DD_Child_Registered]    Script Date: 09/26/2024 11:58:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*                
[DD_Child_Registered] 15,0,0,0,0,0,2018,0,0,'State',1                
[DD_Child_Registered] 15,0,0,0,0,0,2016,0,0,'District',1                
[DD_Child_Registered] 30,1,6,0,0,0,2016,0,0,'Block',2                
[DD_Child_Registered] 30,1,6,6,0,0,2016,0,0,'PHC',2                
[DD_Child_Registered] 30,1,6,6,92,0,2016,0,0,'SubCentre',2               
*/                
                
ALTER procedure [dbo].[DD_Child_Registered]                
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
@Category varchar(20) ='State',                
@Type int=1                
                
)                
as                
begin             
SET NOCOUNT ON   
     
declare @daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int                
 set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)                
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                
  set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)               
  set @MonthDiff=(case when @FinancialYr%4=0 then 366 else 365 end)                
                 
if(@Category='State')                  
 begin                 
  select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,A.District_Name as ChildName                
   ,A.Estimated_Beneficiary                
   ,isnull(B.[Infant_Registered],0) as [Infant_Registered]       
   ,ISNULL(B.Infant_11_Registered,0) as Infant_11_Registered                    
   ,isnull(B.[Infant_LBW_Registered],0) as [Infant_LBW_Registered]                
   ,isnull(B.[Infant_11_FullImmu],0) as [Infant_11_FullImmu]                
   ,isnull(B.[Infant_LBW_11_FullImmu],0) as [Infant_LBW_11_FullImmu]                
   ,isnull(B.Infant_11_Not_FullImmu,0) as Infant_11_Not_FullImmu                
   ,isnull(B.Infant_LBW_11_Not_FullImmu,0) as Infant_LBW_11_Not_FullImmu                
   ,isnull(B.Child_Death_Total,0) as Child_Death_Total    
   ,isnull(B.Total_Male,0) as Total_Male    
   ,isnull(B.Total_Female,0) as Total_Female   
   ,isnull(X.Estimated_Infant,0) as Estimated_Infant_Total 
   ,ISNULL(B.Child_Without_Mother,0) as Child_Without_Mother     
from                
  (select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                
  ,Estimated_Infant as Estimated_Beneficiary                  
  ,Estimated_Infant as Estimated_current_FinYr                
  from TBL_DISTRICT a  (NOLOCK)              
  inner join TBL_STATE b (NOLOCK) on a.StateID=b.StateID                
  inner join Estimated_Data_District_Wise c (NOLOCK) on a.DIST_CD=c.District_Code                
  where c.Financial_Year=@FinancialYr                 
  and (b.StateID=@State_Code or @State_Code=0) and (a.DIST_CD=@District_Code or @District_Code=0)                
)  A                
 left outer join   
  (Select State_Code,Estimated_Infant from Rch_Reports.dbo.Estimated_Data_All_State a  
  where Financial_Year=@FinancialYr and State_Code=@State_Code)   
  X on A.State_Code=X.State_Code       
  left outer join                
   (select [State_Code]as [State_Code],[District_Code]as [District_Code]                
   ,sum(Infant_Registered)as [Infant_Registered]         
   ,sum(Infant_11)as [Infant_11_Registered]              
   ,sum([Infant_Low_birth_Weight])as [Infant_LBW_Registered]                
   ,sum([Infant_11_FullImmu])as [Infant_11_FullImmu]                
   ,sum([Infant_LBW_11_FullImmu])as [Infant_LBW_11_FullImmu]                
   ,sum(Infant_11_Not_FullImmu)as Infant_11_Not_FullImmu                
   ,sum(Infant_LBW_11_Not_FullImmu)as Infant_LBW_11_Not_FullImmu          
   ,sum(Child_Death_Total) as Child_Death_Total    
   ,[Fin_Yr],[Filter_Type]     
   ,SUM(Total_Male) as Total_Male    
   ,SUM(Total_Female) as Total_Female 
   ,SUM(Mother_RegistrationNo_Absent) as Child_Without_Mother               
     from Scheduled_AC_Child_State_District_Month (NOLOCK)                
     where [Fin_Yr]=@FinancialYr                 
     and (Month_ID=@Month_ID or @Month_ID=0)                
     and (Year_ID=@Year_ID or @Year_ID=0)                
     and Filter_Type=@Type                 
     group by [State_Code],[District_Code],[Fin_Yr],[Filter_Type]) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code                
     order by A.District_Name                
 end                
if(@Category='District')                
 begin                 
  select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,A.HealthBlock_Name as ChildName                
    ,A.Estimated_Beneficiary                
   ,isnull(B.[Infant_Registered],0) as [Infant_Registered]       
   ,ISNULL(B.Infant_11_Registered,0) as Infant_11_Registered                    
   ,isnull(B.[Infant_LBW_Registered],0) as [Infant_LBW_Registered]                
   ,isnull(B.[Infant_11_FullImmu],0) as [Infant_11_FullImmu]                
   ,isnull(B.[Infant_LBW_11_FullImmu],0) as [Infant_LBW_11_FullImmu]                
   ,isnull(B.Infant_11_Not_FullImmu,0) as Infant_11_Not_FullImmu                
   ,isnull(B.Infant_LBW_11_Not_FullImmu,0) as Infant_LBW_11_Not_FullImmu                
   ,isnull(B.Child_Death_Total,0) as Child_Death_Total    
    ,isnull(B.Total_Male,0) as Total_Male    
    ,isnull(B.Total_Female,0) as Total_Female    
 ,'' as Estimated_Infant_Total  
 ,ISNULL(B.Child_Without_Mother,0) as Child_Without_Mother                 
  from                
  (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name                
  ,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                 
  ,Estimated_Infant as Estimated_Beneficiary                  
  ,Estimated_Infant as Estimated_current_FinYr                    
  from TBL_HEALTH_BLOCK a  (NOLOCK)              
  inner join TBL_DISTRICT b (NOLOCK) on a.DISTRICT_CD=b.DIST_CD                
  inner join Estimated_Data_Block_Wise c (NOLOCK) on a.BLOCK_CD=c.HealthBlock_Code                
  where c.Financial_Year=@FinancialYr                 
  and a.DISTRICT_CD=@District_Code )  A                
  left outer join                
(select [District_Code]as [District_Code],HealthBlock_Code as HealthBlock_Code                
   ,sum(Infant_Registered)as [Infant_Registered]      
   ,sum(Infant_11)as [Infant_11_Registered]                 
   ,sum([Infant_Low_birth_Weight])as [Infant_LBW_Registered]                
  ,sum([Infant_11_FullImmu])as [Infant_11_FullImmu]                
   ,sum([Infant_LBW_11_FullImmu])as [Infant_LBW_11_FullImmu]                
   ,sum(Infant_11_Not_FullImmu)as Infant_11_Not_FullImmu                
   ,sum(Infant_LBW_11_Not_FullImmu)as Infant_LBW_11_Not_FullImmu                
   ,sum(Child_Death_Total) as Child_Death_Total    
   ,[Fin_Yr],[Filter_Type]    
   ,SUM(Total_Male) as Total_Male    
   ,SUM(Total_Female) as Total_Female
   ,SUM(Mother_RegistrationNo_Absent) as Child_Without_Mother                
    from Scheduled_AC_Child_District_Block_Month (NOLOCK)                
     where [Fin_Yr]=@FinancialYr                 
     and (Month_ID=@Month_ID or @Month_ID=0)                
     and (Year_ID=@Year_ID or @Year_ID=0)                
     and Filter_Type=@Type                 
     group by [District_Code],HealthBlock_Code,[Fin_Yr],[Filter_Type]) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code                
   order by A.HealthBlock_Name                
 end                
 if(@Category='Block')                  
 begin                 
  select A.HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName                
   ,A.Estimated_Beneficiary                
   ,A.Estimated_Beneficiary                
   ,isnull(B.[Infant_Registered],0) as [Infant_Registered]       
    ,ISNULL(B.Infant_11_Registered,0) as Infant_11_Registered                    
   ,isnull(B.[Infant_LBW_Registered],0) as [Infant_LBW_Registered]                
   ,isnull(B.[Infant_11_FullImmu],0) as [Infant_11_FullImmu]                
   ,isnull(B.[Infant_LBW_11_FullImmu],0) as [Infant_LBW_11_FullImmu]                
   ,isnull(B.Infant_11_Not_FullImmu,0) as Infant_11_Not_FullImmu                
   ,isnull(B.Infant_LBW_11_Not_FullImmu,0) as Infant_LBW_11_Not_FullImmu                
   ,isnull(B.Child_Death_Total,0) as Child_Death_Total     
   ,isnull(B.Total_Male,0) as Total_Male    
   ,isnull(B.Total_Female,0) as Total_Female   
   ,'' as Estimated_Infant_Total  
   ,ISNULL(B.Child_Without_Mother,0) as Child_Without_Mother          
  from                
  (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                
   ,Estimated_Infant as Estimated_Beneficiary                  
  ,Estimated_Infant as Estimated_current_FinYr                   
    from TBL_PHC  a (NOLOCK)               
    inner join TBL_HEALTH_BLOCK b (NOLOCK) on a.BID=b.BLOCK_CD                
    inner join Estimated_Data_PHC_Wise c (NOLOCK) on a.PHC_CD=c.HealthFacility_Code                
    where c.Financial_Year=@FinancialYr       
    and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)                 
    )  A                 
  left outer join                
   (select HealthBlock_Code as HealthBlock_Code,HealthFacility_Code as HealthFacility_Code                
   ,sum(Infant_Registered)as [Infant_Registered]      
    ,sum(Infant_11)as [Infant_11_Registered]                   
   ,sum([Infant_Low_birth_Weight])as [Infant_LBW_Registered]                
   ,sum([Infant_11_FullImmu])as [Infant_11_FullImmu]                
   ,sum([Infant_LBW_11_FullImmu])as [Infant_LBW_11_FullImmu]                
   ,sum(Infant_11_Not_FullImmu)as Infant_11_Not_FullImmu                
   ,sum(Infant_LBW_11_Not_FullImmu)as Infant_LBW_11_Not_FullImmu                
   ,sum(Child_Death_Total) as Child_Death_Total                
   ,[Fin_Yr],[Filter_Type]      
   ,SUM(Total_Male) as Total_Male    
   ,SUM(Total_Female) as Total_Female               
   ,SUM(Mother_RegistrationNo_Absent) as Child_Without_Mother                
     from Scheduled_AC_Child_Block_PHC_Month (NOLOCK)                
     where [Fin_Yr]=@FinancialYr                 
     and (Month_ID=@Month_ID or @Month_ID=0)                
     and (Year_ID=@Year_ID or @Year_ID=0)                
     and Filter_Type=@Type                 
     group by HealthBlock_Code,HealthFacility_Code,[Fin_Yr],[Filter_Type]) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code                 
   order by A.HealthFacility_Name                
 end                
 if(@Category='PHC')                  
 begin                 
  select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName                
   ,A.Estimated_Beneficiary                
   ,isnull(B.[Infant_Registered],0) as [Infant_Registered]       
    ,ISNULL(B.Infant_11_Registered,0) as Infant_11_Registered                    
   ,isnull(B.[Infant_LBW_Registered],0) as [Infant_LBW_Registered]                
   ,isnull(B.[Infant_11_FullImmu],0) as [Infant_11_FullImmu]                
   ,isnull(B.[Infant_LBW_11_FullImmu],0) as [Infant_LBW_11_FullImmu]                
   ,isnull(B.Infant_11_Not_FullImmu,0) as Infant_11_Not_FullImmu                
   ,isnull(B.Infant_LBW_11_Not_FullImmu,0) as Infant_LBW_11_Not_FullImmu                
   ,isnull(B.Child_Death_Total,0) as Child_Death_Total     
   ,isnull(B.Total_Male,0) as Total_Male    
   ,isnull(B.Total_Female,0) as Total_Female   
   ,'' as Estimated_Infant_Total 
   ,ISNULL(B.Child_Without_Mother,0) as Child_Without_Mother              
  from                
  (        
  select a.HealthFacility_Code as HealthFacility_Code,c.PHC_NAME as HealthFacility_Name ,a.HealthSubFacility_Code as HealthSubFacility_Code,isnull(b.SUBPHC_NAME_E ,'Direct Entry')as HealthSubFacility_Name          
 ,Estimated_Infant as Estimated_Beneficiary                       
 from Estimated_Data_SubCenter_Wise a (NOLOCK)       
 left outer join TBL_SUBPHC b (NOLOCK) on a.HealthSubFacility_Code=b.SUBPHC_CD         
 inner join TBL_PHC c (NOLOCK) on a.HealthFacility_Code=c.PHC_CD            
 where a.Financial_Year=@FinancialYr            
 and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)       
    )  A                
  left outer join                
   (select HealthFacility_Code as HealthFacility_Code,HealthSubFacility_Code as HealthSubFacility_Code                
   ,sum(Infant_Registered)as [Infant_Registered]       
    ,sum(Infant_11)as [Infant_11_Registered]                  
   ,sum([Infant_Low_birth_Weight])as [Infant_LBW_Registered]                
   ,sum([Infant_11_FullImmu])as [Infant_11_FullImmu]                
   ,sum([Infant_LBW_11_FullImmu])as [Infant_LBW_11_FullImmu]                
   ,sum(Infant_11_Not_FullImmu)as Infant_11_Not_FullImmu                
   ,sum(Infant_LBW_11_Not_FullImmu)as Infant_LBW_11_Not_FullImmu                
   ,sum(Child_Death_Total) as Child_Death_Total                
   ,[Fin_Yr],[Filter_Type]    
   ,SUM(Total_Male) as Total_Male    
   ,SUM(Total_Female) as Total_Female 
   ,SUM(Mother_RegistrationNo_Absent) as Child_Without_Mother                                
     from Scheduled_AC_Child_PHC_SubCenter_Month (NOLOCK)                
     where [Fin_Yr]=@FinancialYr                 
     and (Month_ID=@Month_ID or @Month_ID=0)                
     and (Year_ID=@Year_ID or @Year_ID=0)                
     and Filter_Type=@Type                  
     group by HealthFacility_Code,HealthSubFacility_Code,[Fin_Yr],[Filter_Type]) B on A.HealthFacility_Code=B.HealthFacility_Code  and A.HealthSubFacility_Code=B.HealthSubFacility_Code                
   order by A.HealthSubFacility_Name                
 end                
 if(@Category='SubCentre')             
 begin                 
  select A.HealthSubFacility_Code as ParentID,A.HealthSubFacility_Name as ParentName,A.Village_Code as ChildID,A.Village_Name as ChildName                
   ,A.Estimated_Beneficiary                
   ,isnull(B.[Infant_Registered],0) as [Infant_Registered]       
   ,ISNULL(B.Infant_11_Registered,0) as Infant_11_Registered                    
   ,isnull(B.[Infant_LBW_Registered],0) as [Infant_LBW_Registered]                
   ,isnull(B.[Infant_11_FullImmu],0) as [Infant_11_FullImmu]                
   ,isnull(B.[Infant_LBW_11_FullImmu],0) as [Infant_LBW_11_FullImmu]                
   ,isnull(B.Infant_11_Not_FullImmu,0) as Infant_11_Not_FullImmu                
   ,isnull(B.Infant_LBW_11_Not_FullImmu,0) as Infant_LBW_11_Not_FullImmu                      
   ,isnull(B.Child_Death_Total,0) as Child_Death_Total     
   ,isnull(B.Total_Male,0) as Total_Male    
   ,isnull(B.Total_Female,0) as Total_Female   
   ,'' as Estimated_Infant_Total
   ,ISNULL(B.Child_Without_Mother,0) as Child_Without_Mother               
  from                
  (             
 select a.Village_Code as Village_Code ,b.SUBPHC_NAME_E as HealthSubFacility_Name,a.HealthSubFacility_Code as HealthSubFacility_Code,a.VILLAGE_NAME as Village_Name           
,Estimated_Infant as Estimated_Beneficiary                
from Estimated_Data_Village_Wise a (NOLOCK)                 
inner join TBL_SUBPHC b (NOLOCK) on a.HealthSubFacility_Code=b.SUBPHC_CD          
left outer join  TBL_ViLLAGE c (NOLOCK) on a.Village_Code=c.Village_CD and a.HealthSubFacility_Code=c.SUBPHC_CD        
where a.Financial_Year=@FinancialYr         
and ( a.HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0)           
        
    )  A                
  left outer join                
   (select HealthSubFacility_Code as HealthSubFacility_Code,Village_Code as Village_Code                
   ,sum(Infant_Registered)as [Infant_Registered]       
   ,sum(Infant_11)as [Infant_11_Registered]                  
   ,sum([Infant_Low_birth_Weight])as [Infant_LBW_Registered]                
   ,sum([Infant_11_FullImmu])as [Infant_11_FullImmu]                
   ,sum([Infant_LBW_11_FullImmu])as [Infant_LBW_11_FullImmu]                
   ,sum(Infant_11_Not_FullImmu)as Infant_11_Not_FullImmu                
   ,sum(Infant_LBW_11_Not_FullImmu)as Infant_LBW_11_Not_FullImmu                
   ,sum(Child_Death_Total) as Child_Death_Total                
   ,[Fin_Yr],[Filter_Type]     
   ,SUM(Total_Male) as Total_Male    
   ,SUM(Total_Female) as Total_Female
   ,SUM(Mother_RegistrationNo_Absent) as Child_Without_Mother                
     from Scheduled_AC_Child_PHC_SubCenter_Village_Month (NOLOCK)                
     where [Fin_Yr]=@FinancialYr                 
     and (Month_ID=@Month_ID or @Month_ID=0)                
     and (Year_ID=@Year_ID or @Year_ID=0)                
     and Filter_Type=@Type                 
     group by HealthSubFacility_Code,Village_Code,[Fin_Yr],[Filter_Type]) B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code                
   order by A.Village_Name                
 end                
end      
      
      
