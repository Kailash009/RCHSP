USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Factsheet_PIP_Mother_Count]    Script Date: 09/26/2024 11:59:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*          
Factsheet_PIP_Mother_Count 29,0,0,0,0,0,2023,4,0,'State','Monthly'         
*/            
ALTER procedure [dbo].[Factsheet_PIP_Mother_Count]                            
(                            
@State_Code int=0,                              
@District_Code int=0,                              
@HealthBlock_Code int=0,                              
@HealthFacility_Code int=0,                              
@HealthSubFacility_Code int=0,                            
@Village_Code int=0,                            
@FinancialYr int,                             
@Month_ID int=0 ,          
@Year_ID int=0,                                             
@Category varchar(20) ='',
@Type varchar(20)                             
)                            
as                            
begin 
Declare @start_date_y as int,@FinYrNew as int              
if(MONTH(GETDATE()-1)<=3)                
set @FinYrNew=Year(GETDATE()-1)-1                
else                
set @FinYrNew=Year(GETDATE()-1)                          
set @start_date_y= @FinancialYr-1                     
declare @state_dist_cd char(2)
SET NOCOUNT ON 
if (@Type = 'Yearly')
begin                           
 declare @daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int             
 set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)            
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)            
 set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)                                            
if(@Category='State')                              
begin                              
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,A.District_Name as ChildName,                                 
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,     
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion       
from                          
(          
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                             
from TBL_DISTRICT a                              
inner join TBL_STATE b on a.StateID=b.StateID                              
where b.StateID=@State_Code          
)A                              
left outer join          
(          
select CH.State_Code,CH.District_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as [Death_ANC]            
,SUM(Del_During_Transit) as Del_During_Transit     
,SUM(Abortion) as LMP_Abortion           
from dbo.[Scheduled_MH_Tracking_State_District_Month] as CH                
where Filter_Type=1 -- on the basis of LMP Reg           
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) 
and case when @FinYrNew<>@FinancialYr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@FinancialYr AS varchar)) as DATe))) else  cast(DATEADD(month, -13, GETDATE()) as DATe)end              
group by CH.State_Code,CH.District_Code          
)E on A.State_Code=E.State_Code and A.District_Code=E.District_Code          
         
             
END                                              
else if(@Category='District')                              
begin                              
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                               
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,            
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion         
from                          
(          
select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                              
from TBL_HEALTH_BLOCK a                              
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD                               
where a.DISTRICT_CD=@District_Code          
)A                               
left outer join          
(          
select  CH.District_Code,CH.HealthBlock_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit 
,SUM(Abortion) as LMP_Abortion             
from dbo.[Scheduled_MH_Tracking_District_Block_Month] as CH                
where Filter_Type=1                        
and District_Code=@District_Code 
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) 
and case when @FinYrNew<>@FinancialYr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@FinancialYr AS varchar)) as DATe))) else  cast(DATEADD(month, -13, GETDATE()) as DATe)end               
group by CH.District_Code,CH.HealthBlock_Code          
)E on  A.District_Code=E.District_Code and A.HealthBlock_Code=E.HealthBlock_Code 
           
                      
end                            
else if(@Category='Block')                              
begin                              
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,                                  
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,       
ISNULL(E.Total_LMP,0) as Total_LMP,              
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion        
from                          
(          
select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                              
from TBL_PHC a                              
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD                          
inner join TBL_DISTRICT C on a.DIST_CD=C.DIST_CD                               
where a.BID=@HealthBlock_Code          
)A                               
left outer join          
(          
select  CH.HealthBlock_Code,HealthFacility_Code             
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit
,SUM(Abortion) as LMP_Abortion              
from dbo.[Scheduled_MH_Tracking_Block_PHC_Month] as CH                
where Filter_Type=1                      
and HealthBlock_Code=@HealthBlock_Code
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) 
and case when @FinYrNew<>@FinancialYr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@FinancialYr AS varchar)) as DATe))) else  cast(DATEADD(month, -13, GETDATE()) as DATe)end               
group by CH.HealthBlock_Code,HealthFacility_Code          
)E on A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code                      
END                                            
else if(@Category='PHC')                              
begin                              
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName,       
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,               
ISNULL(E.LMP_Abortion,0) as LMP_Abortion         
from                          
(          
select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                          
from TBL_SUBPHC a                              
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                          
where a.PHC_CD= @HealthFacility_Code           
)A                              
left outer join          
(          
select HealthFacility_Code,HealthSubFacility_Code            
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit  
,SUM(Abortion) as LMP_Abortion            
from dbo.[Scheduled_MH_Tracking_PHC_SubCenter_Month] as CH                
where Filter_Type=1                       
and HealthFacility_Code=@HealthFacility_Code 
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) 
and case when @FinYrNew<>@FinancialYr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@FinancialYr AS varchar)) as DATe))) else  cast(DATEADD(month, -13, GETDATE()) as DATe)end             
group by HealthFacility_Code,HealthSubFacility_Code           
)E on A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code          
              
END                                                
else if(@Category='SubCentre')                              
begin                              
select A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,        
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,           
ISNULL(E.Total_LMP,0) as Total_LMP,                
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion          
from                          
(          
 select v.SID as HealthSubFacility_Code,isnull(v.VCode,0) as Village_Code,sp.SUBPHC_NAME_E as HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name                            
 from Health_SC_Village v                             
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=v.VCode and vn.SUBPHC_CD=v.SID                            
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=v.SID                            
 where sp.SUBPHC_CD=@HealthSubFacility_Code          
)A                             
left outer join          
(          
select  CH.HealthSubFacility_Code,CH.Village_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit 
,SUM(Abortion) as LMP_Abortion             
from dbo.[Scheduled_MH_Tracking_PHC_SubCenter_Village_Month] as CH                
where Filter_Type=1                     
and HealthSubFacility_Code=@HealthSubFacility_Code 
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) 
and case when @FinYrNew<>@FinancialYr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@FinancialYr AS varchar)) as DATe))) else  cast(DATEADD(month, -13, GETDATE()) as DATe)end              
group by CH.HealthSubFacility_Code,CH.Village_Code          
)E on A.HealthSubFacility_Code=E.HealthSubFacility_Code and A.Village_Code=E.Village_Code                      
end 
end
else if(@Type ='Monthly')                          
Begin       
declare @PrevYearID int,@NewYear_ID int=0    
if(@Month_ID<4)    
set @NewYear_ID=@FinancialYr+1    
else    
set @NewYear_ID=@FinancialYr    
if(@Month_ID=4)  
set @PrevYearID=@FinancialYr-1  
else  
set @PrevYearID=@FinancialYr 
set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)                      
set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)
if(@Category='State')                              
begin                              
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,A.District_Name as ChildName,                                 
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,     
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion       
from                          
(          
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                             
from TBL_DISTRICT a                              
inner join TBL_STATE b on a.StateID=b.StateID                              
where b.StateID=@State_Code          
)A                              
left outer join          
(          
select CH.State_Code,CH.District_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as [Death_ANC]            
,SUM(Del_During_Transit) as Del_During_Transit     
,SUM(Abortion) as LMP_Abortion           
from dbo.[Scheduled_MH_Tracking_State_District_Month] as CH                
where Filter_Type=1 -- on the basis of LMP Reg           
and  cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))              
group by CH.State_Code,CH.District_Code          
)E on A.State_Code=E.State_Code and A.District_Code=E.District_Code          
         
             
END                                              
else if(@Category='District')                              
begin                              
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                               
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,            
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion         
from                          
(          
select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                              
from TBL_HEALTH_BLOCK a                              
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD                               
where a.DISTRICT_CD=@District_Code          
)A                               
left outer join          
(          
select  CH.District_Code,CH.HealthBlock_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit 
,SUM(Abortion) as LMP_Abortion             
from dbo.[Scheduled_MH_Tracking_District_Block_Month] as CH                
where Filter_Type=1                      
and District_Code=@District_Code
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))              
group by CH.District_Code,CH.HealthBlock_Code          
)E on  A.District_Code=E.District_Code and A.HealthBlock_Code=E.HealthBlock_Code 
           
                      
end                            
else if(@Category='Block')                              
begin                              
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,                                  
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,       
ISNULL(E.Total_LMP,0) as Total_LMP,              
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion        
from                          
(          
select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                              
from TBL_PHC a                              
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD                          
inner join TBL_DISTRICT C on a.DIST_CD=C.DIST_CD                               
where a.BID=@HealthBlock_Code          
)A                               
left outer join          
(          
select  CH.HealthBlock_Code,HealthFacility_Code             
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit
,SUM(Abortion) as LMP_Abortion              
from dbo.[Scheduled_MH_Tracking_Block_PHC_Month] as CH                
where Filter_Type=1                     
and HealthBlock_Code=@HealthBlock_Code
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))             
group by CH.HealthBlock_Code,HealthFacility_Code          
)E on A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code                      
END                                            
else if(@Category='PHC')                              
begin                              
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName,       
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,          
ISNULL(E.Total_LMP,0) as Total_LMP,               
ISNULL(E.LMP_Abortion,0) as LMP_Abortion         
from                          
(          
select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                          
from TBL_SUBPHC a                              
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                          
where a.PHC_CD= @HealthFacility_Code           
)A                              
left outer join          
(          
select HealthFacility_Code,HealthSubFacility_Code            
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit  
,SUM(Abortion) as LMP_Abortion            
from dbo.[Scheduled_MH_Tracking_PHC_SubCenter_Month] as CH                
where Filter_Type=1                      
and HealthFacility_Code=@HealthFacility_Code
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))            
group by HealthFacility_Code,HealthSubFacility_Code           
)E on A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code          
              
END                                                
else if(@Category='SubCentre')                              
begin                              
select A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,        
ISNULL(E.ANC1,0) as ANC1,    
ISNULL(E.ANC2,0) as ANC2,    
ISNULL(E.ANC3,0) as ANC3,    
ISNULL(E.ANC4,0) as ANC4,    
ISNULL(E.TT1,0) as TT1,    
ISNULL(E.TT2,0) as TT2,    
ISNULL(E.TTBooster,0) as TTBooster,    
ISNULL(E.IFA,0) as IFA,    
ISNULL(E.Delivery,0) as Delivery,    
ISNULL(E.RCH_fullANC,0) as RCH_fullANC,    
ISNULL(E.All_ANC,0) as All_ANC,    
ISNULL(E.Any_three_ANC,0) as Any_three_ANC,    
ISNULL(E.Death_ANC,0) as Death_ANC,           
ISNULL(E.Total_LMP,0) as Total_LMP,                
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion          
from                          
(          
 select v.SID as HealthSubFacility_Code,isnull(v.VCode,0) as Village_Code,sp.SUBPHC_NAME_E as HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name                            
 from Health_SC_Village v                             
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=v.VCode and vn.SUBPHC_CD=v.SID                            
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=v.SID                            
 where sp.SUBPHC_CD=@HealthSubFacility_Code          
)A                             
left outer join          
(          
select  CH.HealthSubFacility_Code,CH.Village_Code              
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4 ,SUM(TT1) as TT1,SUM(TT2) as TT2                 
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC            
,SUM(Any_three_ANC) as Any_three_ANC            
,SUM([Death_ANC]) as  [Death_ANC],SUM([Abortion])as Abortion            
,SUM(Del_During_Transit) as Del_During_Transit 
,SUM(Abortion) as LMP_Abortion             
from dbo.[Scheduled_MH_Tracking_PHC_SubCenter_Village_Month] as CH                
where Filter_Type=1                    
and HealthSubFacility_Code=@HealthSubFacility_Code
and cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))             
group by CH.HealthSubFacility_Code,CH.Village_Code          
)E on A.HealthSubFacility_Code=E.HealthSubFacility_Code and A.Village_Code=E.Village_Code                      
end 
end                            
END   
  
