USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Tracking_Service_Mother]    Script Date: 09/26/2024 11:54:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[AC_Tracking_Service_Mother]    
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
@Category varchar(20) ='',  
@Type int=0  
)    
as    
begin    
    
--if(@Category='National')      
--begin      
-- exec RCH_Reports.dbo.AC_Tracking_Service @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,      
-- @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category    
--end    
    
if(@Category='State')    
begin    
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,    
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,    
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,    
ISNULL (All_ANC,0) as All_ANC,ISNULL(RCH_fullANC,0) as RCH_fullANC, ISNULL(MCTS_fullANC,0) as MCTS_fullANC,  
ISNULL (Any_three_ANC,0) as Any_three_ANC  
,ISNULL([Death_ANC],0) as  [Death_ANC],ISNULL([Del_Pub],0) as [Del_Pub],ISNULL([Del_Pri],0) as [Del_Pri],ISNULL([Del_Home],0) as [Del_Home]  
,ISNULL([Del_HomeSBA],0) as [Del_HomeSBA],ISNULL([Del_HomeNonSBA],0) as [Del_HomeNonSBA],ISNULL([Del_CSec],0) as [Del_CSec],ISNULL([Del_CSec_Pub],0) as [Del_CSec_Pub]  
,ISNULL([Del_CSec_Pri],0) as [Del_CSec_Pri],ISNULL([Del_Death],0) as [Del_Death],ISNULL([Del_Due_Not_Reported],0) as [Del_Due_Not_Reported]  
,ISNULL([PNC1],0) as [PNC1],ISNULL([PNC2],0) as [PNC2],ISNULL([PNC3],0) as [PNC3],ISNULL([PNC4],0) as [PNC4],ISNULL([PNC5],0) as [PNC5]  
,ISNULL([PNC6],0) as [PNC6],ISNULL([PNC7],0) as [PNC7],ISNULL([NoPNC],0) as [NoPNC],ISNULL([AllPNC],0) as [AllPNC],ISNULL([Any4PNC],0) as [Any4PNC]  
,ISNULL([PNC_Death],0) as [PNC_Death],ISNULL(C.Total_PW_LMP ,0)  as Total_LMP_PW,ISNULL(Abortion,0)as Abortion  
,ISNULL([Del_During_Transit],0) as [Del_During_Transit]
,ISNULL([Del_Pub]+[Del_Pri],0) as [Del_Pub_Pri]  
 from      
 (select c.State_Code as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name    
 from  TBL_DISTRICT a     
 inner join TBL_STATE b on a.StateID=b.StateID    
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code    
 where c.Financial_Year=@FinancialYr     
     
) A    
left outer join    
(    
 select  CH.State_Code,CH.District_Code    
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2       
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC  
,SUM(Any_three_ANC) as Any_three_ANC      
,SUM([Death_ANC]) as  [Death_ANC],SUM([Del_Pub]) as [Del_Pub],SUM([Del_Pri]) as [Del_Pri],SUM([Del_Home]) as [Del_Home],SUM([Del_HomeSBA]) as [Del_HomeSBA]  
,SUM([Del_HomeNonSBA]) as [Del_HomeNonSBA],SUM([Del_CSec]) as [Del_CSec],SUM([Del_CSec_Pub]) as [Del_CSec_Pub]  
,SUM([Del_CSec_Pri]) as [Del_CSec_Pri],SUM([Del_Death]) as [Del_Death],SUM([Del_Due_Not_Reported]) as [Del_Due_Not_Reported]  
,SUM([PNC1]) as [PNC1],SUM([PNC2]) as [PNC2],SUM([PNC3]) as [PNC3],SUM([PNC4]) as [PNC4],SUM([PNC5]) as [PNC5]  
,SUM([PNC6]) as [PNC6],SUM([PNC7]) as [PNC7],SUM([NoPNC]) as [NoPNC],SUM([AllPNC]) as [AllPNC],SUM([Any4PNC]) as [Any4PNC],SUM([PNC_Death]) as [PNC_Death],SUM([Abortion])as Abortion  
,SUM(Del_During_Transit) as Del_During_Transit  
    
from dbo.[Scheduled_MH_Tracking_State_District_Month] as CH      
where Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)   
and Filter_Type=@Type   
 group by CH.State_Code,CH.District_Code    
 )     
 B on A.District_Code=B.District_Code  
 left outer join    
(    
 select  CH.State_Code,CH.District_Code    
,SUM(Total_LMP) as Total_PW_LMP  
from dbo.[Scheduled_MH_Tracking_State_District_Month] as CH      
where Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)   
and Filter_Type=1   
 group by CH.State_Code,CH.District_Code    
 )     
 C on A.District_Code=C.District_Code  order by A.State_Name,a.District_Name  
end    
    
else if(@Category='District')    
begin    
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName,    
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,    
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,    
ISNULL (All_ANC,0) as All_ANC,ISNULL(RCH_fullANC,0) as RCH_fullANC, ISNULL(MCTS_fullANC,0) as MCTS_fullANC  
,ISNULL (Any_three_ANC,0) as Any_three_ANC  
,ISNULL([Death_ANC],0) as  [Death_ANC],ISNULL([Del_Pub],0) as [Del_Pub],ISNULL([Del_Pri],0) as [Del_Pri],ISNULL([Del_Home],0) as [Del_Home]  
,ISNULL([Del_HomeSBA],0) as [Del_HomeSBA],ISNULL([Del_HomeNonSBA],0) as [Del_HomeNonSBA],ISNULL([Del_CSec],0) as [Del_CSec],ISNULL([Del_CSec_Pub],0) as [Del_CSec_Pub]  
,ISNULL([Del_CSec_Pri],0) as [Del_CSec_Pri],ISNULL([Del_Death],0) as [Del_Death],ISNULL([Del_Due_Not_Reported],0) as [Del_Due_Not_Reported]  
,ISNULL([PNC1],0) as [PNC1],ISNULL([PNC2],0) as [PNC2],ISNULL([PNC3],0) as [PNC3],ISNULL([PNC4],0) as [PNC4],ISNULL([PNC5],0) as [PNC5]  
,ISNULL([PNC6],0) as [PNC6],ISNULL([PNC7],0) as [PNC7],ISNULL([NoPNC],0) as [NoPNC],ISNULL([AllPNC],0) as [AllPNC],ISNULL([Any4PNC],0) as [Any4PNC]  
,ISNULL([PNC_Death],0) as [PNC_Death],ISNULL(C.Total_PW_LMP ,0)  as Total_LMP_PW,ISNULL(Abortion,0)as Abortion  
,ISNULL([Del_During_Transit],0) as [Del_During_Transit]  
,ISNULL([Del_Pub]+[Del_Pri],0) as [Del_Pub_Pri] 
 from      
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
 from TBL_HEALTH_BLOCK a    
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD    
 inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code    
 where c.Financial_Year=@FinancialYr     
 and a.DISTRICT_CD=@District_Code    
) A    
left outer join    
(    
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code     
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2       
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC ,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC  
 ,SUM(Any_three_ANC) as Any_three_ANC      
,SUM([Death_ANC]) as  [Death_ANC],SUM([Del_Pub]) as [Del_Pub],SUM([Del_Pri]) as [Del_Pri],SUM([Del_Home]) as [Del_Home],SUM([Del_HomeSBA]) as [Del_HomeSBA]  
,SUM([Del_HomeNonSBA]) as [Del_HomeNonSBA],SUM([Del_CSec]) as [Del_CSec],SUM([Del_CSec_Pub]) as [Del_CSec_Pub]  
,SUM([Del_CSec_Pri]) as [Del_CSec_Pri],SUM([Del_Death]) as [Del_Death],SUM([Del_Due_Not_Reported]) as [Del_Due_Not_Reported]  
,SUM([PNC1]) as [PNC1],SUM([PNC2]) as [PNC2],SUM([PNC3]) as [PNC3],SUM([PNC4]) as [PNC4],SUM([PNC5]) as [PNC5]  
,SUM([PNC6]) as [PNC6],SUM([PNC7]) as [PNC7],SUM([NoPNC]) as [NoPNC],SUM([AllPNC]) as [AllPNC],SUM([Any4PNC]) as [Any4PNC],SUM([PNC_Death]) as [PNC_Death],SUM([Abortion])as Abortion    
,SUM(Del_During_Transit) as Del_During_Transit  
              
 from dbo.Scheduled_MH_Tracking_District_Block_Month as CH      
 where CH.State_Code =@State_Code    
 and CH.District_Code=@District_Code    
 and Fin_Yr=@FinancialYr     
  and (Month_ID=@Month_ID or @Month_ID=0)    
 and (Year_ID=@Year_ID or @Year_ID=0)    
 and Filter_Type=@Type   
  
 group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code    
 ) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code   
 left outer join    
(    
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code     
,SUM(Total_LMP) as Total_PW_LMP  
from dbo.Scheduled_MH_Tracking_District_Block_Month as CH      
 where CH.State_Code =@State_Code    
 and CH.District_Code=@District_Code    
 and Fin_Yr=@FinancialYr     
  and (Month_ID=@Month_ID or @Month_ID=0)    
 and (Year_ID=@Year_ID or @Year_ID=0)    
 and Filter_Type=1   
  
 group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code    
 )C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code order by A.District_Name,A.HealthBlock_Name   
end    
    
else if(@Category='Block')  
begin  
select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,  
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,    
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,    
ISNULL (All_ANC,0) as All_ANC,ISNULL(RCH_fullANC,0) as RCH_fullANC, ISNULL(MCTS_fullANC,0) as MCTS_fullANC  
,ISNULL (Any_three_ANC,0) as Any_three_ANC  
,ISNULL([Death_ANC],0) as  [Death_ANC],ISNULL([Del_Pub],0) as [Del_Pub],ISNULL([Del_Pri],0) as [Del_Pri],ISNULL([Del_Home],0) as [Del_Home]  
,ISNULL([Del_HomeSBA],0) as [Del_HomeSBA],ISNULL([Del_HomeNonSBA],0) as [Del_HomeNonSBA],ISNULL([Del_CSec],0) as [Del_CSec],ISNULL([Del_CSec_Pub],0) as [Del_CSec_Pub]  
,ISNULL([Del_CSec_Pri],0) as [Del_CSec_Pri],ISNULL([Del_Death],0) as [Del_Death],ISNULL([Del_Due_Not_Reported],0) as [Del_Due_Not_Reported]  
,ISNULL([PNC1],0) as [PNC1],ISNULL([PNC2],0) as [PNC2],ISNULL([PNC3],0) as [PNC3],ISNULL([PNC4],0) as [PNC4],ISNULL([PNC5],0) as [PNC5]  
,ISNULL([PNC6],0) as [PNC6],ISNULL([PNC7],0) as [PNC7],ISNULL([NoPNC],0) as [NoPNC],ISNULL([AllPNC],0) as [AllPNC],ISNULL([Any4PNC],0) as [Any4PNC]  
,ISNULL([PNC_Death],0) as [PNC_Death],ISNULL(C.Total_PW_LMP ,0)  as Total_LMP_PW,ISNULL(Abortion,0)as Abortion  
,ISNULL([Del_During_Transit],0) as [Del_During_Transit]  
,ISNULL([Del_Pub]+[Del_Pri],0) as [Del_Pub_Pri] 
 from    
 (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name  
     from TBL_PHC  a  
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD  
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code  
  where c.Financial_Year=@FinancialYr   
  and  a.BID=@HealthBlock_Code   
) A  
left outer join  
(  
select State_Code,HealthBlock_Code,HealthFacility_Code    
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2       
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC ,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC   
 ,SUM(Any_three_ANC) as Any_three_ANC      
,SUM([Death_ANC]) as  [Death_ANC],SUM([Del_Pub]) as [Del_Pub],SUM([Del_Pri]) as [Del_Pri],SUM([Del_Home]) as [Del_Home],SUM([Del_HomeSBA]) as [Del_HomeSBA]  
,SUM([Del_HomeNonSBA]) as [Del_HomeNonSBA],SUM([Del_CSec]) as [Del_CSec],SUM([Del_CSec_Pub]) as [Del_CSec_Pub]  
,SUM([Del_CSec_Pri]) as [Del_CSec_Pri],SUM([Del_Death]) as [Del_Death],SUM([Del_Due_Not_Reported]) as [Del_Due_Not_Reported]  
,SUM([PNC1]) as [PNC1],SUM([PNC2]) as [PNC2],SUM([PNC3]) as [PNC3],SUM([PNC4]) as [PNC4],SUM([PNC5]) as [PNC5]  
,SUM([PNC6]) as [PNC6],SUM([PNC7]) as [PNC7],SUM([NoPNC]) as [NoPNC],SUM([AllPNC]) as [AllPNC],SUM([Any4PNC]) as [Any4PNC],SUM([PNC_Death]) as [PNC_Death],SUM([Abortion])as Abortion  
,SUM(Del_During_Transit) as Del_During_Transit           
   from dbo.Scheduled_MH_Tracking_Block_PHC_Month as CH    
 where State_Code =@State_Code  
 and HealthBlock_Code =@HealthBlock_Code     
 and Fin_Yr=@FinancialYr  
 and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 and Filter_Type=@Type   
  
 group by State_Code,HealthBlock_Code,HealthFacility_Code  
  
 )  B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code  
 left outer join  
(  
select State_Code,HealthBlock_Code,HealthFacility_Code    
,SUM(Total_LMP) as Total_PW_LMP  
from dbo.Scheduled_MH_Tracking_Block_PHC_Month as CH    
 where State_Code =@State_Code  
 and HealthBlock_Code =@HealthBlock_Code     
 and Fin_Yr=@FinancialYr  
 and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
  
 group by State_Code,HealthBlock_Code,HealthFacility_Code  
  
 )  C on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code order by A.HealthBlock_Name,A.HealthFacility_Name 
end  
else if(@Category='PHC' )  
begin  
select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName,  
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,    
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,    
ISNULL (All_ANC,0) as All_ANC,ISNULL(RCH_fullANC,0) as RCH_fullANC, ISNULL(MCTS_fullANC,0) as MCTS_fullANC,  
ISNULL (Any_three_ANC,0) as Any_three_ANC  
,ISNULL([Death_ANC],0) as  [Death_ANC],ISNULL([Del_Pub],0) as [Del_Pub],ISNULL([Del_Pri],0) as [Del_Pri],ISNULL([Del_Home],0) as [Del_Home]  
,ISNULL([Del_HomeSBA],0) as [Del_HomeSBA],ISNULL([Del_HomeNonSBA],0) as [Del_HomeNonSBA],ISNULL([Del_CSec],0) as [Del_CSec],ISNULL([Del_CSec_Pub],0) as [Del_CSec_Pub]  
,ISNULL([Del_CSec_Pri],0) as [Del_CSec_Pri],ISNULL([Del_Death],0) as [Del_Death],ISNULL([Del_Due_Not_Reported],0) as [Del_Due_Not_Reported]  
,ISNULL([PNC1],0) as [PNC1],ISNULL([PNC2],0) as [PNC2],ISNULL([PNC3],0) as [PNC3],ISNULL([PNC4],0) as [PNC4],ISNULL([PNC5],0) as [PNC5]  
,ISNULL([PNC6],0) as [PNC6],ISNULL([PNC7],0) as [PNC7],ISNULL([NoPNC],0) as [NoPNC],ISNULL([AllPNC],0) as [AllPNC],ISNULL([Any4PNC],0) as [Any4PNC]  
,ISNULL([PNC_Death],0) as [PNC_Death] ,ISNULL(C.Total_PW_LMP ,0)  as Total_LMP_PW,ISNULL(Abortion,0)as Abortion  
,ISNULL([Del_During_Transit],0) as [Del_During_Transit]  
,ISNULL([Del_Pub]+[Del_Pri],0) as [Del_Pub_Pri] 
from   
 (select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name  
      from TBL_SUBPHC a  
   inner join TBL_PHC b on a.PHC_CD=b.PHC_CD  
      inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code and a.PHC_CD=c.HealthFacility_Code 
     where c.Financial_Year=@FinancialYr   
     and ( a.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)  
      and ( a.SUBPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)  
) A  
left outer join  
(  
 select State_Code,HealthFacility_Code,HealthSubFacility_Code  
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2       
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC ,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC  
,SUM(Any_three_ANC) as Any_three_ANC      
,SUM([Death_ANC]) as  [Death_ANC],SUM([Del_Pub]) as [Del_Pub],SUM([Del_Pri]) as [Del_Pri],SUM([Del_Home]) as [Del_Home],SUM([Del_HomeSBA]) as [Del_HomeSBA]  
,SUM([Del_HomeNonSBA]) as [Del_HomeNonSBA],SUM([Del_CSec]) as [Del_CSec],SUM([Del_CSec_Pub]) as [Del_CSec_Pub]  
,SUM([Del_CSec_Pri]) as [Del_CSec_Pri],SUM([Del_Death]) as [Del_Death],SUM([Del_Due_Not_Reported]) as [Del_Due_Not_Reported]  
,SUM([PNC1]) as [PNC1],SUM([PNC2]) as [PNC2],SUM([PNC3]) as [PNC3],SUM([PNC4]) as [PNC4],SUM([PNC5]) as [PNC5]  
,SUM([PNC6]) as [PNC6],SUM([PNC7]) as [PNC7],SUM([NoPNC]) as [NoPNC],SUM([AllPNC]) as [AllPNC],SUM([Any4PNC]) as [Any4PNC],SUM([PNC_Death]) as [PNC_Death],SUM([Abortion])as Abortion  
,SUM(Del_During_Transit) as Del_During_Transit            
from dbo.Scheduled_MH_Tracking_PHC_SubCenter_Month as CH    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code     
 and Fin_Yr=@FinancialYr   
  and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 and Filter_Type=@Type   
  
 group by CH.State_Code,CH.HealthFacility_Code,CH.HealthSubFacility_Code  
 )  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code  
 left outer join  
(  
 select State_Code,HealthFacility_Code,HealthSubFacility_Code  
,SUM(Total_LMP) as Total_PW_LMP  
            
   from dbo.Scheduled_MH_Tracking_PHC_SubCenter_Month as CH    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code     
 and Fin_Yr=@FinancialYr   
  and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
  
 group by CH.State_Code,CH.HealthFacility_Code,CH.HealthSubFacility_Code  
 )  C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code  order by A.HealthFacility_Name,A.HealthSubFacility_Name
end  
else if(@Category='Subcentre')--Added by sneha on 16042018  
begin  
select A.State_Code,A.HealthSubFacility_Code as ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,  
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,    
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,    
ISNULL (All_ANC,0) as All_ANC,ISNULL(RCH_fullANC,0) as RCH_fullANC, ISNULL(MCTS_fullANC,0) as MCTS_fullANC,  
ISNULL (Any_three_ANC,0) as Any_three_ANC  
,ISNULL([Death_ANC],0) as  [Death_ANC],ISNULL([Del_Pub],0) as [Del_Pub],ISNULL([Del_Pri],0) as [Del_Pri],ISNULL([Del_Home],0) as [Del_Home]  
,ISNULL([Del_HomeSBA],0) as [Del_HomeSBA],ISNULL([Del_HomeNonSBA],0) as [Del_HomeNonSBA],ISNULL([Del_CSec],0) as [Del_CSec],ISNULL([Del_CSec_Pub],0) as [Del_CSec_Pub]  
,ISNULL([Del_CSec_Pri],0) as [Del_CSec_Pri],ISNULL([Del_Death],0) as [Del_Death],ISNULL([Del_Due_Not_Reported],0) as [Del_Due_Not_Reported]  
,ISNULL([PNC1],0) as [PNC1],ISNULL([PNC2],0) as [PNC2],ISNULL([PNC3],0) as [PNC3],ISNULL([PNC4],0) as [PNC4],ISNULL([PNC5],0) as [PNC5]  
,ISNULL([PNC6],0) as [PNC6],ISNULL([PNC7],0) as [PNC7],ISNULL([NoPNC],0) as [NoPNC],ISNULL([AllPNC],0) as [AllPNC],ISNULL([Any4PNC],0) as [Any4PNC]  
,ISNULL([PNC_Death],0) as [PNC_Death] ,ISNULL(C.Total_PW_LMP ,0)  as Total_LMP_PW,ISNULL(Abortion,0)as Abortion  
,ISNULL([Del_During_Transit],0) as [Del_During_Transit]  
,ISNULL([Del_Pub]+[Del_Pri],0) as [Del_Pub_Pri] 
from    
(  
select a.State_Code,a.HealthSubFacility_Code as HealthSubFacility_Code,b.SUBPHC_NAME as HealthSubFacility_Name ,a.Village_Code   as Village_Code,a.VILLAGE_NAME as Village_Name  
from Estimated_Data_Village_Wise a  
inner join TBL_SUBPHC b on a.HealthSubFacility_Code=b.SUBPHC_CD  
left outer join  Village c on a.Village_Code=c.VCode   
where a.Financial_Year=@FinancialYr   
and a.HealthSubFacility_Code= @HealthSubFacility_Code  
  
) A  
left outer join  
(  
 select State_Code,HealthSubFacility_Code,Village_Code  
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2       
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC ,SUM(RCH_fullANC)as RCH_fullANC ,SUM(MCTS_fullANC)as MCTS_fullANC  
,SUM(Any_three_ANC) as Any_three_ANC      
,SUM([Death_ANC]) as  [Death_ANC],SUM([Del_Pub]) as [Del_Pub],SUM([Del_Pri]) as [Del_Pri],SUM([Del_Home]) as [Del_Home],SUM([Del_HomeSBA]) as [Del_HomeSBA]  
,SUM([Del_HomeNonSBA]) as [Del_HomeNonSBA],SUM([Del_CSec]) as [Del_CSec],SUM([Del_CSec_Pub]) as [Del_CSec_Pub]  
,SUM([Del_CSec_Pri]) as [Del_CSec_Pri],SUM([Del_Death]) as [Del_Death],SUM([Del_Due_Not_Reported]) as [Del_Due_Not_Reported]  
,SUM([PNC1]) as [PNC1],SUM([PNC2]) as [PNC2],SUM([PNC3]) as [PNC3],SUM([PNC4]) as [PNC4],SUM([PNC5]) as [PNC5]  
,SUM([PNC6]) as [PNC6],SUM([PNC7]) as [PNC7],SUM([NoPNC]) as [NoPNC],SUM([AllPNC]) as [AllPNC],SUM([Any4PNC]) as [Any4PNC],SUM([PNC_Death]) as [PNC_Death],SUM([Abortion])as Abortion  
,SUM(Del_During_Transit) as Del_During_Transit      
from dbo.Scheduled_MH_Tracking_PHC_SubCenter_Village_Month as CH    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code     
 and Fin_Yr=@FinancialYr   
  and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)
  and Filter_Type=@Type   
 group by CH.State_Code,CH.HealthSubFacility_Code,CH.Village_Code  
 )  B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code  
 left outer join  
(  
 select State_Code,HealthSubFacility_Code,Village_Code  
,SUM(Total_LMP) as Total_PW_LMP  
            
   from dbo.Scheduled_MH_Tracking_PHC_SubCenter_Village_Month as CH    
 where State_Code =@State_Code  
 and HealthFacility_Code =@HealthFacility_Code     
 and Fin_Yr=@FinancialYr   
  and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 and Filter_Type=1   
  
 group by CH.State_Code,CH.HealthSubFacility_Code,CH.Village_Code  
 )  C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code   order by A.HealthSubFacility_Name,A.Village_Name
   
end  
END    