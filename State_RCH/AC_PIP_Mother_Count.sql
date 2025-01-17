USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[AC_PIP_Mother_Count]    Script Date: 09/26/2024 14:39:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /*          
AC_PIP_Mother_Count 30,0,0,0,0,0,2022,0,0,'State'         
*/            
ALTER procedure [dbo].[AC_PIP_Mother_Count]                            
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
@Category varchar(20) =''                            
)                            
as                            
begin                            
 declare @daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int             
 set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)            
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)            
 set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)                                            
if(@Category='State')                              
begin                              
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,A.District_Name as ChildName,                         
ISNULL(B.PW_Registered,0) as PW_Registered ,    
ISNULL(B.PW_High_Risk,0) as PW_High_Risk,    
ISNULL(HRP_Managed,0) as HRP_Managed,    
ISNULL(B.ANC_Abortion_Induced,0) as ANC_Abortion_Induced,    
ISNULL(B.ANC_Abortion_Spontaneous,0) as ANC_Abortion_Spontaneous,          
ISNULL(C.Estimated_Infant,0) as Estimated_Infant,    
ISNULL(C.Estimated_Mother,0) as Estimated_Mother,    
ISNULL(D.Child_Entry,0) as Child_Entry ,        
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
ISNULL(B.Abortion,0) as Abortion,        
ISNULL(E.Total_LMP,0) as Total_LMP,         
ISNULL(Z.Est_Infant,0) as Est_Infant,    
ISNULL(Z.Est_PW,0)as Est_PW,    
@daysPast as daysPast,    
@Daysinyear as DaysinYear,    
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
select State_Code,District_Code,          
Sum(PW_Registered)as PW_Registered,Sum([PW_High_Risk])as [PW_High_Risk],Sum(ANC_Abortion_Induced) as [ANC_Abortion_Induced],        
Sum(ANC_Abortion_Spontaneous) as [ANC_Abortion_Spontaneous],Sum(HRP_Managed) as HRP_Managed,       
(Sum(ANC_Abortion_Induced) + Sum(ANC_Abortion_Spontaneous)) as Abortion         
from Scheduled_AC_PW_State_District_Month --on the basis of MH Reg         
where Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)        
and Filter_Type=1                         
group by State_Code,District_Code          
)B on A.State_Code=B.State_Code and A.District_Code=B.District_Code          
left outer join          
(          
select a.StateID,a.DIST_CD          
,b.Estimated_Mother as Estimated_Mother            
,b.Estimated_Infant as Estimated_Infant            
from TBL_DISTRICT a            
left outer join Estimated_Data_District_Wise b on a.Dist_Cd=b.District_Code            
left outer join TBL_STATE c on a.StateID=c.StateID          
where  b.Financial_Year=@FinancialYr           
)C on A.State_Code=C.StateID and A.District_Code=C.DIST_CD          
left outer join                 
(          
Select Sum(Infant_Registered)as Child_Entry,State_Code , District_Code               
from Scheduled_AC_CHILD_State_District_Month                  
where Filter_Type=1--on the basis of CH Reg          
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)                 
group by State_Code , District_Code          
)D on A.State_Code=D.State_Code and A.District_Code=D.District_Code          
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
and  Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)              
group by CH.State_Code,CH.District_Code          
)E on A.State_Code=E.State_Code and A.District_Code=E.District_Code          
left outer join                  
(          
select b.State_Code ,b.Estimated_Mother as Est_PW,b.Estimated_Infant as Est_Infant              
from RCH_Reports.dbo.Estimated_Data_All_State (nolock) b               
where b.State_Code=@State_Code           
and b.Financial_Year=@FinancialYr                                
) Z on A.State_Code=Z.State_Code            
             
END                                              
else if(@Category='District')                              
begin                              
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                        
ISNULL(B.PW_Registered,0) as PW_Registered ,    
ISNULL(B.PW_High_Risk,0) as PW_High_Risk,    
ISNULL(HRP_Managed,0) as HRP_Managed,    
ISNULL(B.ANC_Abortion_Induced,0) as ANC_Abortion_Induced,    
ISNULL(B.ANC_Abortion_Spontaneous,0) as ANC_Abortion_Spontaneous,          
ISNULL(C.Estimated_Infant,0) as Estimated_Infant,    
ISNULL(C.Estimated_Mother,0) as Estimated_Mother,    
ISNULL(D.Child_Entry,0) as Child_Entry ,        
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
ISNULL(B.Abortion,0) as Abortion,        
ISNULL(E.Total_LMP,0) as Total_LMP,         
ISNULL(Z.Est_Infant,0) as Est_Infant,    
ISNULL(Z.Est_PW,0)as Est_PW,    
@daysPast as daysPast,    
@Daysinyear as DaysinYear,    
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
select District_Code,HealthBlock_Code,          
Sum(PW_Registered)as PW_Registered,Sum([PW_High_Risk])as [PW_High_Risk],Sum(ANC_Abortion_Induced) as [ANC_Abortion_Induced],          
Sum(ANC_Abortion_Spontaneous) as [ANC_Abortion_Spontaneous],Sum(HRP_Managed) as HRP_Managed ,
(Sum(ANC_Abortion_Induced) + Sum(ANC_Abortion_Spontaneous)) as Abortion 
           
from Scheduled_AC_PW_District_Block_Month          
 where [Fin_Yr]=@FinancialYr 
 and (Month_ID=@Month_ID or @Month_ID=0)        
 and Filter_Type=1            
 and District_Code=@District_Code          
group by District_Code,HealthBlock_Code          
)B on  A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code           
left outer join          
(          
select a.DIST_CD,BLOCK_CD          
,c.Estimated_Mother as Estimated_Mother            
,c.Estimated_Infant as Estimated_Infant            
from TBL_HEALTH_BLOCK b            
 left outer join Estimated_Data_Block_Wise c on b.BLOCK_CD=c.HealthBlock_Code            
 inner join TBL_DISTRICT a on b.DISTRICT_CD=a.DIST_CD          
 where c.Financial_Year=@FinancialYr          
 and c.District_Code=@District_Code          
)C on  A.District_Code=C.DIST_CD and A.HealthBlock_Code=C.BLOCK_CD          
left outer join                 
(          
Select Sum(Infant_Registered)as Child_Entry,District_Code,HealthBlock_Code               
from Scheduled_AC_Child_District_Block_Month                  
where Filter_Type=1          
and [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)             
and District_Code=@District_Code               
group by  District_Code,HealthBlock_Code          
)D on  A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code          
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
and [Fin_Yr]=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)              
and District_Code=@District_Code              
group by CH.District_Code,CH.HealthBlock_Code          
)E on  A.District_Code=E.District_Code and A.HealthBlock_Code=E.HealthBlock_Code 
left outer join                  
(          
select b.District_Code,b.HealthBlock_Code
,b.Estimated_Mother as Est_PW,b.Estimated_Infant as Est_Infant              
from Estimated_Data_Block_Wise (nolock) b               
where (b.District_Code=@District_Code or @District_Code=0)           
and b.Financial_Year=@FinancialYr                                
) Z on  A.District_Code=Z.District_Code and A.HealthBlock_Code=Z.HealthBlock_Code             
                      
end                            
else if(@Category='Block')                              
begin                              
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName                          
,ISNULL(B.PW_Registered,0) as PW_Registered ,    
ISNULL(B.PW_High_Risk,0) as PW_High_Risk,    
ISNULL(HRP_Managed,0) as HRP_Managed,    
ISNULL(B.ANC_Abortion_Induced,0) as ANC_Abortion_Induced,    
ISNULL(B.ANC_Abortion_Spontaneous,0) as ANC_Abortion_Spontaneous,          
ISNULL(C.Estimated_Infant,0) as Estimated_Infant,    
ISNULL(C.Estimated_Mother,0) as Estimated_Mother,    
ISNULL(D.Child_Entry,0) as Child_Entry ,        
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
ISNULL(B.Abortion,0) as Abortion,        
ISNULL(E.Total_LMP,0) as Total_LMP,         
ISNULL(Z.Est_Infant,0) as Est_Infant,    
ISNULL(Z.Est_PW,0)as Est_PW,    
@daysPast as daysPast,    
@Daysinyear as DaysinYear,    
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
select HealthBlock_Code,HealthFacility_Code,          
Sum(PW_Registered)as PW_Registered,Sum([PW_High_Risk])as [PW_High_Risk],Sum(ANC_Abortion_Induced) as [ANC_Abortion_Induced],Sum(ANC_Abortion_Spontaneous) as [ANC_Abortion_Spontaneous]  ,Sum(HRP_Managed) as HRP_Managed          
,(Sum(ANC_Abortion_Induced) + Sum(ANC_Abortion_Spontaneous)) as Abortion 
from Scheduled_AC_PW_Block_PHC_Month          
where Fin_Yr=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)         
and Filter_Type=1         
and HealthBlock_Code=@HealthBlock_Code          
group by HealthBlock_Code,HealthFacility_Code          
)B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code          
left outer join          
(          
select c.HealthBlock_Code,c.HealthFacility_Code          
,c.Estimated_Mother as Estimated_Mother            
,c.Estimated_Infant as Estimated_Infant            
from TBL_PHC  a            
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD            
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code          
     where Financial_Year=@FinancialYr           
     and HealthBlock_Code=@HealthBlock_Code          
)C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code          
left outer join                 
(          
Select Sum(Infant_Registered)as Child_Entry,HealthBlock_Code,HealthFacility_Code             
from Scheduled_AC_Child_Block_PHC_Month                  
where Filter_Type=1           
and Fin_Yr=@FinancialYr 
 and (Month_ID=@Month_ID or @Month_ID=0)            
and HealthBlock_Code=@HealthBlock_Code              
group by HealthBlock_Code,HealthFacility_Code          
)D on A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code          
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
and Fin_Yr=@FinancialYr
and (Month_ID=@Month_ID or @Month_ID=0)             
and HealthBlock_Code=@HealthBlock_Code             
group by CH.HealthBlock_Code,HealthFacility_Code          
)E on A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code          
left outer join          
(          
select HealthBlock_Code,HealthFacility_Code                  
,sum([Total_Due])as [Total_Due]                   
,sum([Delivered])as [Total_Delivered]                  
from Scheduled_EDD_Block_PHC_Month           
where Fin_Yr=@FinancialYr          
and HealthBlock_Code=@HealthBlock_Code                  
group by HealthBlock_Code,HealthFacility_Code,[Fin_Yr]                 
)F           
on A.HealthBlock_Code=f.HealthBlock_Code and A.HealthFacility_Code=f.HealthFacility_Code 
left outer join                  
(          
select HealthBlock_Code,HealthFacility_Code
,b.Estimated_Mother as Est_PW,b.Estimated_Infant as Est_Infant              
from Estimated_Data_PHC_Wise (nolock) b               
where (b.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)           
and b.Financial_Year=@FinancialYr                                
) Z on  A.HealthBlock_Code=Z.HealthBlock_Code and A.HealthFacility_Code=Z.HealthFacility_Code            
END                                            
else if(@Category='PHC')                              
begin                              
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName                         ,
ISNULL(B.PW_Registered,0) as PW_Registered ,    
ISNULL(B.PW_High_Risk,0) as PW_High_Risk,    
ISNULL(HRP_Managed,0) as HRP_Managed,    
ISNULL(B.ANC_Abortion_Induced,0) as ANC_Abortion_Induced,    
ISNULL(B.ANC_Abortion_Spontaneous,0) as ANC_Abortion_Spontaneous,          
ISNULL(C.Estimated_Infant,0) as Estimated_Infant,    
ISNULL(C.Estimated_Mother,0) as Estimated_Mother,    
ISNULL(D.Child_Entry,0) as Child_Entry ,        
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
ISNULL(B.Abortion,0) as Abortion,        
ISNULL(E.Total_LMP,0) as Total_LMP,         
ISNULL(Z.Est_Infant,0) as Est_Infant,    
ISNULL(Z.Est_PW,0)as Est_PW,    
@daysPast as daysPast,    
@Daysinyear as DaysinYear,    
ISNULL(E.LMP_Abortion,0) as  LMP_Abortion         
from                          
(          
select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                          
from TBL_SUBPHC a                              
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD                          
where a.PHC_CD= @HealthFacility_Code           
)A            
left outer join            
(          
select HealthFacility_Code,HealthSubFacility_Code,          
Sum(PW_Registered)as PW_Registered,Sum([PW_High_Risk])as [PW_High_Risk],Sum(ANC_Abortion_Induced) as [ANC_Abortion_Induced],Sum(ANC_Abortion_Spontaneous) as [ANC_Abortion_Spontaneous]  ,Sum(HRP_Managed) as HRP_Managed          
,(Sum(ANC_Abortion_Induced) + Sum(ANC_Abortion_Spontaneous)) as Abortion 
from Scheduled_AC_PW_PHC_SubCenter_Month          
where Fin_Yr=@FinancialYr
and (Month_ID=@Month_ID or @Month_ID=0)          
and Filter_Type=1         
and HealthFacility_Code=@HealthFacility_Code          
group by HealthFacility_Code,HealthSubFacility_Code          
)B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code          
left outer join          
(          
select HealthFacility_Code,HealthSubFacility_Code          
,a.Estimated_Mother as Estimated_Mother            
,a.Estimated_Infant as Estimated_Infant            
from Estimated_Data_SubCenter_Wise a            
   inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD            
   left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD          
   where a.Financial_Year=@FinancialYr          
   and a.HealthFacility_Code=@HealthFacility_Code          
)C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code          
left outer join                 
(          
Select Sum(Infant_Registered)as Child_Entry,HealthFacility_Code,HealthSubFacility_Code               
from Scheduled_AC_Child_PHC_SubCenter_Month                  
where Filter_Type=1          
and Fin_Yr=@FinancialYr 
 and (Month_ID=@Month_ID or @Month_ID=0)            
and HealthFacility_Code=@HealthFacility_Code               
group by HealthFacility_Code,HealthSubFacility_Code           
)D on A.HealthFacility_Code=D.HealthFacility_Code and A.HealthSubFacility_Code=D.HealthSubFacility_Code          
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
and Fin_Yr=@FinancialYr
and (Month_ID=@Month_ID or @Month_ID=0)             
and HealthFacility_Code=@HealthFacility_Code            
group by HealthFacility_Code,HealthSubFacility_Code           
)E on A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code          
left outer join          
(          
select  HealthFacility_Code,HealthSubFacility_Code                   
,sum([Total_Due])as [Total_Due]                   
,sum([Delivered])as [Total_Delivered]                  
from Scheduled_EDD_PHC_SubCenter_Month          
where Fin_Yr=@FinancialYr          
and HealthFacility_Code=@HealthFacility_Code                   
group by HealthFacility_Code,HealthSubFacility_Code ,[Fin_Yr]                 
)F           
on A.HealthFacility_Code=F.HealthFacility_Code and A.HealthSubFacility_Code=F.HealthSubFacility_Code
left outer join                  
(          
select HealthFacility_Code,HealthSubFacility_Code
,b.Estimated_Mother as Est_PW,b.Estimated_Infant as Est_Infant              
from Estimated_Data_SubCenter_Wise (nolock) b               
where(HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)           
and b.Financial_Year=@FinancialYr                                
) Z on A.HealthFacility_Code=Z.HealthFacility_Code and A.HealthSubFacility_Code=Z.HealthSubFacility_Code
              
END                                                
else if(@Category='SubCentre')                              
begin                              
select A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,
ISNULL(B.PW_Registered,0) as PW_Registered ,    
ISNULL(B.PW_High_Risk,0) as PW_High_Risk,    
ISNULL(HRP_Managed,0) as HRP_Managed,    
ISNULL(B.ANC_Abortion_Induced,0) as ANC_Abortion_Induced,    
ISNULL(B.ANC_Abortion_Spontaneous,0) as ANC_Abortion_Spontaneous,          
ISNULL(C.Estimated_Infant,0) as Estimated_Infant,    
ISNULL(C.Estimated_Mother,0) as Estimated_Mother,    
ISNULL(D.Child_Entry,0) as Child_Entry ,        
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
ISNULL(B.Abortion,0) as Abortion,        
ISNULL(E.Total_LMP,0) as Total_LMP,         
ISNULL(Z.Est_Infant,0) as Est_Infant,    
ISNULL(Z.Est_PW,0)as Est_PW,    
@daysPast as daysPast,    
@Daysinyear as DaysinYear,    
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
select HealthSubFacility_Code,Village_Code,          
Sum(PW_Registered)as PW_Registered,Sum([PW_High_Risk])as [PW_High_Risk],Sum(ANC_Abortion_Induced) as [ANC_Abortion_Induced],Sum(ANC_Abortion_Spontaneous) as [ANC_Abortion_Spontaneous]  ,Sum(HRP_Managed) as HRP_Managed          
,(Sum(ANC_Abortion_Induced) + Sum(ANC_Abortion_Spontaneous)) as Abortion 
from Scheduled_AC_PW_PHC_SubCenter_Village_Month          
where Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)     
and Filter_Type=1         
and HealthSubFacility_Code=@HealthSubFacility_Code           
group by HealthSubFacility_Code,Village_Code          
)B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code          
left outer join          
(          
select c.HealthSubFacility_Code,c.Village_Code          
,c.Estimated_Mother as Estimated_Mother            
,c.Estimated_Infant as Estimated_Infant            
from  Estimated_Data_Village_Wise  c            
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code            
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code            
 where c.Financial_Year=@FinancialYr          
 and HealthSubFacility_Code=@HealthSubFacility_Code          
)C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code          
left outer join                 
(          
Select Sum(Infant_Registered)as Child_Entry,HealthSubFacility_Code,Village_Code              
from Scheduled_AC_Child_PHC_SubCenter_Village_Month                  
where Filter_Type=1           
and Fin_Yr=@FinancialYr  
and (Month_ID=@Month_ID or @Month_ID=0)           
and HealthSubFacility_Code=@HealthSubFacility_Code              
group by HealthSubFacility_Code,Village_Code          
)D on A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code          
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
and Fin_Yr=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)            
and HealthSubFacility_Code=@HealthSubFacility_Code             
group by CH.HealthSubFacility_Code,CH.Village_Code          
)E on A.HealthSubFacility_Code=E.HealthSubFacility_Code and A.Village_Code=E.Village_Code          
left outer join          
(          
select HealthSubFacility_Code,Village_Code               
,sum([Total_Due])as [Total_Due]                   
,sum([Delivered])as [Total_Delivered]                  
from Scheduled_EDD_PHC_SubCenter_Village_Month          
where Fin_Yr=@FinancialYr          
and HealthSubFacility_Code=@HealthSubFacility_Code                   
group by HealthSubFacility_Code,Village_Code,[Fin_Yr]           
)F           
on A.HealthSubFacility_Code=f.HealthSubFacility_Code and A.Village_Code=f.Village_Code 
left outer join                  
(          
select HealthSubFacility_Code,Village_Code
,b.Estimated_Mother as Est_PW,b.Estimated_Infant as Est_Infant              
from Estimated_Data_Village_Wise (nolock) b               
where(HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)           
and b.Financial_Year=@FinancialYr                                
) Z on A.HealthSubFacility_Code=Z.HealthSubFacility_Code and A.Village_Code=Z.Village_Code            
end                             
END   
  