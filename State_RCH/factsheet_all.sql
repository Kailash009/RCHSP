USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[factsheet_all]    Script Date: 09/26/2024 11:59:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
--factsheet_all @Category ='State',@State_Code=17,@finyr=2019,@Type='Yearly',@Quarter_ID=0,@Month_ID=0                          
--factsheet_all @Category ='District',@District_Code=2,@finyr=2017,@Type='Yearly' ,@Quarter_ID=0,@Month_ID=0   
--factsheet_all @Category ='State',@State_Code=30,@finyr=2017,@Type='Quarterly',@Quarter_ID=2,@Month_ID=0                          
--factsheet_all @Category ='District',@District_Code=2,@finyr=2017,@Type='Quarterly' ,@Quarter_ID=2,@Month_ID=0  
--factsheet_all @Category ='State',@State_Code=17,@finyr=2019,@Type='Monthly',@Quarter_ID=0,@Month_ID=7                         
--factsheet_all @Category ='District',@District_Code=1,@finyr=2019,@Type='Monthly' ,@Quarter_ID=0,@Month_ID=4                        
                         
ALTER procedure [dbo].[factsheet_all]                          
(                          
@Category varchar(20),                          
@Type as varchar(10)='',                          
@finyr int,                          
@State_Code int=0,                          
@District_Code int=0 ,   
@Quarter_ID int=0,   
@Month_ID int=0                          
)                          
as                           
begin                   
Declare @start_date_y as int,@FinYrNew as int              
if(MONTH(GETDATE()-1)<=3)                
set @FinYrNew=Year(GETDATE()-1)-1                
else                
set @FinYrNew=Year(GETDATE()-1)              
              
set @start_date_y= @finyr-1                     
declare @state_dist_cd char(2)                          
if(@Type ='Yearly')                          
Begin                          
if(@Category ='State')                          
Begin                      
declare @daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int -- up to current month                          
set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                      
set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                          
set @state_dist_cd=@State_Code                          
select @state_dist_cd state_code,@daysPast as daysPast                      
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 isnull(Estimated_EC,0) as Estimated_EC,
 isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant ,0) as Estimated_Infant,
 isnull(Prv_Estimated_Infant, 0 ) as    Prv_Estimated_Infant,                    
isnull( Prv_Estimated_EC,0) as Prv_Estimated_EC,
 isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,
 
 PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                          
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                          
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW      
    ,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child,
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Prv_Estimated_EC,0),isnull(Estimated_EC,0),isnull(EC_Registered,0),@finyr)  as EC_Prorata,
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Prv_Prv_Estimated_EC,0),isnull(Prv_Estimated_EC,0),isnull(Prv_EC_Registered,0),(@finyr-1))  as EC_Prorata_Prv                    
 from                           
(select @state_dist_cd state_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) )a                          
left outer join                            
(select @state_dist_cd state_code, SUM(Estimated_EC) Estimated_EC, SUM(Estimated_Mother) Estimated_Mother,SUM(Estimated_Infant) Estimated_Infant,SUM(Total_Mapped_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,                          
SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=@finyr and state_code=@state_dist_cd) b                          
 on a.state_code=b.state_code                          
                       
 left outer join                          
(select @state_dist_cd state_code, SUM(Estimated_Mother) Prv_Estimated_Mother,SUM(Estimated_Infant) Prv_Estimated_Infant, SUM(Estimated_EC) Prv_Estimated_EC                        
 from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=(@finyr-1) and state_code=@state_dist_cd) pb                          
 on a.state_code=pb.state_code    
   left outer join                           
(select @state_dist_cd state_code, SUM(Estimated_EC) as Prv_Prv_Estimated_EC  from rch_reports.dbo.Estimated_Data_All_State (nolock) 
where Financial_Year=(@finyr-2) and state_code=@state_dist_cd) ppb                          
 on a.state_code=ppb.state_code                   
left outer join                     
(select @state_dist_cd state_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                     
                       
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and Filter_Type=1 and state_code=@state_dist_cd) c                          
on c.state_code=b.state_code                   
   left outer join                           
(select @state_dist_cd state_code, SUM(total_distinct_ec) EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr<=@finyr and Filter_Type=1 and state_code=@state_dist_cd) ec                          
on ec.state_code=b.state_code             
 left outer join                           
(select @state_dist_cd state_code, SUM(total_distinct_ec ) Prv_EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr<=(@finyr-1) and Filter_Type=1 and state_code=@state_dist_cd) pec                          
on pec.state_code=b.state_code                      
left outer join                           
(select @state_dist_cd state_code, SUM(PW_Registered ) Prv_PW_Registered                        
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@finyr-1) and Filter_Type=1 and state_code=@state_dist_cd) pc                          
on pc.state_code=b.state_code                     
left outer join                    
(select @state_dist_cd state_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                    
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) )  as Del_Due_Not_Reported,SUM(nopnc) nopnc                   
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and state_code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between 
 cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) and             
case when @FinYrNew<>@finyr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@finyr AS varchar)) as DATe)))             
 else  cast(DATEADD(month, -13, GETDATE())  as DATe)  
 end        
                
                  
)   ps1                    
 on  ps1.state_code=b.state_code                    
left outer join                           
(select @state_dist_cd state_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                          
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                    
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and Filter_Type=1 and state_code=@state_dist_cd) d                          
on d.state_code=b.state_code                          
left outer join                           
(select @state_dist_cd state_code, SUM(Infant_Registered ) Prv_Infant_Registered                        
   from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=(@finyr-1) and Filter_Type=1 and state_code=@state_dist_cd) pd                          
on pd.state_code=b.state_code                      
left outer join                    
(select @state_dist_cd state_code,       
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where state_code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between 
cast(('1/1/'+cast(@start_date_y AS varchar)) as DATe) and             
case when @FinYrNew<>@finyr then  DATEADD(Day,-1, (cast(('1/1/'+cast(@finyr AS varchar)) as DATe)))             
 else  cast(DATEADD(month, -15, GETDATE())  as DATe)  
 end             
                  
)  chs                    
 on chs.state_code=b.state_code                       
left outer join                           
( select @state_dist_cd state_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                          
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                          
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                          
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID             
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                          
 ,sum(Total_ASHA) Total_ASHA,                          
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                          
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                          
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                          
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                          
 from Scheduled_AC_GF_State_District where state_code=@state_dist_cd ) e                          
 on e.state_code=b.state_code                 
    left outer join                
    (Select @state_dist_cd state_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (                
select COUNT(*) Total_District from TBL_DISTRICT ) t1,                
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK ) t2,                
(select Count(*) Total_PHC from TBL_PHC) t3,                
(select Count(*) Total_SUBPHC from TBL_SUBPHC ) t4,                
(                
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,                
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,                
sum(Total_SC_not_Child) Total_SC_not_Child                
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate()))                
) t5 )  t6                
on t6.state_code=b.state_code                
inner join                          
( select @state_dist_cd state_code,stateName as State_District_Name from TBL_STATE where StateID=@state_dist_cd) ts on ts.state_code=b.state_code                          
 end                          
 else if(@Category ='District')                          
Begin                      
                      
   set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                      
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
 set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                          
  set @state_dist_cd=@District_Code                        
select @state_dist_cd district_code,@daysPast as daysPast                      
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 
isnull(Estimated_EC,0) as Estimated_EC,
 isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant ,0) as Estimated_Infant,
 isnull(Prv_Estimated_Infant, 0 ) as    Prv_Estimated_Infant,                    
isnull( Prv_Estimated_EC,0) as Prv_Estimated_EC,
 isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,
 
 PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                          
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                          
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,        
    Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child ,
isnull(RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Prv_Estimated_EC,0),isnull(Estimated_EC,0),isnull(EC_Registered,0),@finyr),0)  as EC_Prorata,
isnull(RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Prv_Prv_Estimated_EC,0),isnull(Prv_Estimated_EC,0),isnull(Prv_EC_Registered,0),(@finyr-1)),0)  as EC_Prorata_Prv                      
 from                           
(select @state_dist_cd district_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) where District_ID =@state_dist_cd )a                          
left outer join                           
(select @state_dist_cd district_code, SUM(Estimated_EC) Estimated_EC, SUM(Estimated_Mother) Estimated_Mother,SUM(Estimated_Infant) Estimated_Infant,SUM(Total_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,                       
  
   
SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr and District_Code=@state_dist_cd) b                          
 on a.district_code=b.district_code                          
                         
left outer join                          
(select @state_dist_cd district_code, SUM(Estimated_Mother) Prv_Estimated_Mother,SUM(Estimated_Infant) Prv_Estimated_Infant, SUM(Estimated_EC) Prv_Estimated_EC                        
 from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@finyr-1) and District_Code=@state_dist_cd) pb                          
 on a.district_code=pb.district_code    
left outer join                         
(select @state_dist_cd district_code, SUM(Estimated_EC) as Prv_Prv_Estimated_EC  from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@finyr-1) and District_Code=@state_dist_cd) ppb                          
 on a.district_code=ppb.district_code                       
left outer join                           
(select @state_dist_cd district_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                     
                       
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and Filter_Type=1 and District_Code=@state_dist_cd) c                          
on c.district_code=b.district_code                   
   left outer join                           
(select @state_dist_cd district_code, SUM(total_distinct_ec ) EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr<=@finyr and Filter_Type=1 and District_Code=@state_dist_cd) ec                          
on ec.district_code=b.district_code             
 left outer join                           
(select @state_dist_cd district_code, SUM(total_distinct_ec ) Prv_EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr<=(@finyr-1) and Filter_Type=1 and District_Code=@state_dist_cd) pec                          
on pec.district_code=b.district_code                      
left outer join                           
(select @state_dist_cd district_code, SUM(PW_Registered ) Prv_PW_Registered          
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@finyr-1) and Filter_Type=1 and District_Code=@state_dist_cd) pc                          
on pc.district_code=b.district_code                     
left outer join                    
(select @state_dist_cd district_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                    
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) ) as Del_Due_Not_Reported,SUM(nopnc) nopnc                   
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and District_Code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between  cast(('3/1/'+cast(@start_date_y AS varchar)) as DATe) and             
case when @FinYrNew<>@finyr then  DATEADD(Day,-1, (cast(('3/1/'+cast(@finyr AS varchar)) as DATe)))             
 else  cast(DATEADD(month, -13, GETDATE())  as DATe)  
 end               
                  
)   ps1                    
 on  ps1.district_code=b.district_code                    
left outer join                           
(select @state_dist_cd district_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                          
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                    
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and Filter_Type=1 and District_Code=@state_dist_cd) d                          
on d.district_code=b.district_code                          
left outer join                           
(select @state_dist_cd district_code, SUM(Infant_Registered ) Prv_Infant_Registered                        
   from Scheduled_AC_Child_District_Block_Month  (nolock) where Fin_Yr=(@finyr-1) and Filter_Type=1 and District_Code=@state_dist_cd) pd                          
on pd.district_code=b.district_code                      
left outer join                    
(select @state_dist_cd district_code,                   
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where District_Code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between cast(('1/1/'+cast(@start_date_y AS varchar)) as DATe) and             
case when @FinYrNew<>@finyr then  DATEADD(Day,-1, (cast(('1/1/'+cast(@finyr AS varchar)) as DATe)))             
 else  cast(DATEADD(month, -15, GETDATE())  as DATe)  
 end 
                  
)  chs                    
 on chs.district_code=b.district_code                       
left outer join                           
( select @state_dist_cd district_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                          
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                          
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                          
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID                          
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                          
 ,sum(Total_ASHA) Total_ASHA,                          
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                          
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                          
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                          
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                          
 from Scheduled_AC_GF_State_District where District_Code=@state_dist_cd ) e                          
 on e.district_code=b.district_code                 
    left outer join                
    (Select @state_dist_cd district_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (                
select COUNT(*) Total_District from TBL_DISTRICT where DIST_CD=@state_dist_cd ) t1,                
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK where DISTRICT_CD=@state_dist_cd ) t2,                
(select Count(*) Total_PHC from TBL_PHC where DIST_CD=@state_dist_cd) t3,                
(select Count(*) Total_SUBPHC from TBL_SUBPHC where DIST_CD=@state_dist_cd ) t4,                
(                
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,                
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,                
sum(Total_SC_not_Child) Total_SC_not_Child                
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate())) and District_ID=@District_Code               
) t5 )  t6                
on t6.district_code=b.district_code                
inner join                          
( select @state_dist_cd district_code,DIST_NAME_ENG as State_District_Name from TBL_DISTRICT where DIST_CD =@state_dist_cd) ts on ts.district_code=b.district_code                          
 end                     
end    
  
else if(@Type ='Quarterly')                        
Begin                        
declare  
@start_month_ID int=0,  
@endmonth_ID int=0,  
@NewYear_ID int=0,  
@pstart_month_ID int=0,  
@pendmonth_ID int=0,  
@PrvYear_ID int=0  
  
if(@Quarter_ID=1)  
begin  
set @start_month_ID=4  
set @endmonth_ID=6  
set @NewYear_ID=@finyr  
set @pstart_month_ID=1  
set @pendmonth_ID=3  
set @PrvYear_ID=@finyr-1  
end  
else if(@Quarter_ID=2)  
begin  
set @start_month_ID=7  
set @endmonth_ID=9  
set @NewYear_ID=@finyr  
set @pstart_month_ID=4  
set @pendmonth_ID=6  
set @PrvYear_ID=@finyr  
end  
else if(@Quarter_ID=3)  
begin  
set @start_month_ID=10  
set @endmonth_ID=12  
set @NewYear_ID=@finyr  
set @pstart_month_ID=7  
set @pendmonth_ID=9  
set @PrvYear_ID=@finyr  
end  
else if(@Quarter_ID=4)  
begin  
set @start_month_ID=1  
set @endmonth_ID=3  
set @NewYear_ID=@finyr+1  
set @pstart_month_ID=10  
set @pendmonth_ID=12  
set @PrvYear_ID=@finyr  
end   
  
if(@Category ='State')                        
Begin          
                        
   set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                    
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                    
 set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                        
set @state_dist_cd=@State_Code                        
select @state_dist_cd state_code,@daysPast as daysPast                    
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 isnull(((Estimated_EC-Prv_Estimated_EC)/4),0) as Estimated_EC,
 isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant,0) as Estimated_Infant ,
 isnull(Prv_Estimated_Infant,0) as Prv_Estimated_Infant,                        
isnull((case when @finyr >@PrvYear_ID then ((Prv_Estimated_EC-Prv_Prv_Estimated_EC)/4) else ((Estimated_EC-Prv_Estimated_EC)/4) end),0)  as Prv_Estimated_EC,
 isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,

PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                        
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                        
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW    
    ,Total_SC_not_PW,              
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child,
isnull(RCH_Reports.dbo.EC_Percentage_Quaterly(ISNULL(Prv_Estimated_EC,0),isnull(Estimated_EC,0), isnull(EC_Registered,0)),0) as EC_Prorata,  
isnull(RCH_Reports.dbo.EC_Percentage_Quaterly(case when @finyr>@PrvYear_ID then isnull(Prv_Prv_Estimated_EC,0)  else isnull(Prv_Estimated_EC,0) end ,case when @finyr>@PrvYear_ID then isnull(Prv_Estimated_EC,0) else isnull(Estimated_EC,0) end ,isnull(Prv_EC_Registered,0)),0) as EC_Prorata_Prv                
 from                         
(select @state_dist_cd state_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) )a                        
left outer join                         
(select @state_dist_cd state_code, (SUM(Estimated_EC)) Estimated_EC, (SUM(Estimated_Mother)/4) Estimated_Mother,(SUM(Estimated_Infant)/4) Estimated_Infant,SUM(Total_Mapped_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,      
SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=@finyr  and state_code=@state_dist_cd) b                        
 on a.state_code=b.state_code                        
                       
 left outer join                         
(select @state_dist_cd state_code, (SUM(Estimated_Mother)/4) Prv_Estimated_Mother,SUM(Estimated_Infant)/4 Prv_Estimated_Infant                      
 from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=(@PrvYear_ID) and state_code=@state_dist_cd) pb                        
 on a.state_code=pb.state_code  
left outer join                       
(select @state_dist_cd state_code,  SUM(Estimated_EC) Prv_Estimated_EC                      
 from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=(@finyr-1) and state_code=@state_dist_cd) pe                        
 on a.state_code=pe.state_code 
 left outer join                        
(select @state_dist_cd state_code,  SUM(Estimated_EC) Prv_Prv_Estimated_EC                      
 from Estimated_Data_District_Wise (nolock) where Financial_Year=(@finyr-2) and state_code=@state_dist_cd) ppe                        
 on a.state_code=ppe.state_code                      
left outer join                         
(select @state_dist_cd state_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                             
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                   
                     
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)  and Filter_Type=1 and state_code=@state_dist_cd) c                        
on c.state_code=b.state_code                 
   left outer join                         
(select @state_dist_cd state_code, SUM(total_distinct_ec ) EC_Registered                
                     
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)   and Filter_Type=1 and state_code=@state_dist_cd) ec                        
on ec.state_code=b.state_code           
 left outer join                         
(select @state_dist_cd state_code, SUM(total_distinct_ec ) Prv_EC_Registered                
                     
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID) and Filter_Type=1 and state_code=@state_dist_cd) pec                        
on pec.state_code=b.state_code                    
left outer join                         
(select @state_dist_cd state_code, SUM(PW_Registered ) Prv_PW_Registered                      
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID)  and Filter_Type=1 and state_code=@state_dist_cd) pc                        
on pc.state_code=b.state_code                   
left outer join                  
(select @state_dist_cd state_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                  
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) ) as Del_Due_Not_Reported,SUM(nopnc) nopnc                 
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and state_code=@state_dist_cd and              
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@start_month_ID  as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and            
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@endmonth_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))              
                
)   ps1                  
 on  ps1.state_code=b.state_code                  
left outer join                         
(select @state_dist_cd state_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                        
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                  
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)  and Filter_Type=1 and state_code=@state_dist_cd) d                        
on d.state_code=b.state_code                        
left outer join                         
(select @state_dist_cd state_code, SUM(Infant_Registered ) Prv_Infant_Registered                      
   from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID) and Filter_Type=1 and state_code=@state_dist_cd) pd                        
on pd.state_code=b.state_code                    
left outer join                  
(select @state_dist_cd state_code,                 
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where state_code=@state_dist_cd and              
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -15, (cast((cast(@start_month_ID  as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and            
DATEADD(Day,-1, DATEADD(MONTH, -14, (cast((cast(@endmonth_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))            
                
)  chs                  
 on chs.state_code=b.state_code                     
left outer join                         
( select @state_dist_cd state_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                        
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                        
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                        
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID           
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                        
 ,sum(Total_ASHA) Total_ASHA,                        
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                        
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                        
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                        
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                        
 from Scheduled_AC_GF_State_District where state_code=@state_dist_cd ) e                        
 on e.state_code=b.state_code               
    left outer join              
    (Select @state_dist_cd state_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,              
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (              
select COUNT(*) Total_District from TBL_DISTRICT ) t1,              
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK ) t2,              
(select Count(*) Total_PHC from TBL_PHC) t3,              
(select Count(*) Total_SUBPHC from TBL_SUBPHC ) t4,              
(              
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,              
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,              
sum(Total_SC_not_Child) Total_SC_not_Child              
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate()))             
) t5 )  t6              
on t6.state_code=b.state_code              
inner join                        
( select @state_dist_cd state_code,stateName as State_District_Name from TBL_STATE where StateID=@state_dist_cd) ts on ts.state_code=b.state_code    
                      
 end    
                       
 else if(@Category ='District')                        
Begin                    
                    
   set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                    
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                    
 set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                        
  set @state_dist_cd=@District_Code                      
select @state_dist_cd district_code,@daysPast as daysPast                    
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 isnull(((Estimated_EC-Prv_Estimated_EC)/4),0) as Estimated_EC,
 isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant,0) as Estimated_Infant ,
 isnull(Prv_Estimated_Infant,0) as Prv_Estimated_Infant,                        
isnull((case when @finyr >@PrvYear_ID then ((Prv_Estimated_EC-Prv_Prv_Estimated_EC)/4) else ((Estimated_EC-Prv_Estimated_EC)/4) end),0)  as Prv_Estimated_EC,
 isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,
PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                        
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                        
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,      
    Total_SC_not_PW,              
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child,  
isnull(RCH_Reports.dbo.EC_Percentage_Quaterly( isnull(Prv_Estimated_EC,0),isnull(Estimated_EC,0), isnull(EC_Registered,0)),0) as EC_Prorata,  
isnull(RCH_Reports.dbo.EC_Percentage_Quaterly(case when @finyr>@PrvYear_ID then isnull(Prv_Prv_Estimated_EC,0)  else isnull(Prv_Estimated_EC,0) end ,case when @finyr>@PrvYear_ID then isnull(Prv_Estimated_EC,0) else isnull(Estimated_EC,0) end ,isnull(Prv_EC_Registered,0)),0) as EC_Prorata_Prv 
                 
 from                         
(select @state_dist_cd district_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) where District_ID =@state_dist_cd )a                        
inner join                         
(select @state_dist_cd district_code, SUM(Estimated_EC) Estimated_EC, SUM(Estimated_Mother)/4 Estimated_Mother,SUM(Estimated_Infant)/4 Estimated_Infant,SUM(Total_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,                 
       
SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr and District_Code=@state_dist_cd) b                        
 on a.district_code=b.district_code                        
                       
 left outer join                         
(select @state_dist_cd district_code, SUM(Estimated_Mother)/4 Prv_Estimated_Mother,SUM(Estimated_Infant)/4 Prv_Estimated_Infant                    
 from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@PrvYear_ID) and District_Code=@state_dist_cd) pb                        
 on a.district_code=pb.district_code   
left outer join                        
(select @state_dist_cd district_code,  SUM(Estimated_EC) Prv_Estimated_EC                      
 from Estimated_Data_District_Wise (nolock) where Financial_Year=(@finyr-1) and District_Code=@state_dist_cd) pe                        
 on a.district_code=pe.district_code 
left outer join                         
(select @state_dist_cd district_code,  SUM(Estimated_EC) Prv_Prv_Estimated_EC                      
 from Estimated_Data_District_Wise (nolock) where Financial_Year=(@finyr-2) and District_Code=@state_dist_cd) ppe                        
 on a.district_code=ppe.district_code 
                        
left outer join                         
(select @state_dist_cd district_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                             
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                   
                     
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)  and Filter_Type=1 and District_Code=@state_dist_cd) c                        
on c.district_code=b.district_code                 
   left outer join                         
(select @state_dist_cd district_code, SUM(total_distinct_ec ) EC_Registered                
                     
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)  and Filter_Type=1 and District_Code=@state_dist_cd) ec                        
on ec.district_code=b.district_code           
 left outer join                         
(select @state_dist_cd district_code, SUM(total_distinct_ec ) Prv_EC_Registered                
                     
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID) and Filter_Type=1 and District_Code=@state_dist_cd) pec                        
on pec.district_code=b.district_code                    
left outer join                         
(select @state_dist_cd district_code, SUM(PW_Registered ) Prv_PW_Registered                      
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID) and Filter_Type=1 and District_Code=@state_dist_cd) pc                        
on pc.district_code=b.district_code                   
left outer join                  
(select @state_dist_cd district_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                  
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) ) as Del_Due_Not_Reported,SUM(nopnc) nopnc                 
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and District_Code=@state_dist_cd and              
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@start_month_ID  as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and            
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@endmonth_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))              
                
)   ps1                  
 on  ps1.district_code=b.district_code                  
left outer join                         
(select @state_dist_cd district_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                        
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                  
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID)  and Filter_Type=1 and District_Code=@state_dist_cd) d                        
on d.district_code=b.district_code                        
left outer join                         
(select @state_dist_cd district_code, SUM(Infant_Registered ) Prv_Infant_Registered                      
   from Scheduled_AC_Child_District_Block_Month  (nolock) where Fin_Yr=(@PrvYear_ID) and (Month_ID between @pstart_month_ID and @pendmonth_ID) and Filter_Type=1 and District_Code=@state_dist_cd) pd                        
on pd.district_code=b.district_code                    
left outer join                  
(select @state_dist_cd district_code,                 
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where District_Code=@state_dist_cd and              
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -15, (cast((cast(@start_month_ID  as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and            
DATEADD(Day,-1, DATEADD(MONTH, -14, (cast((cast(@endmonth_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))        
                
)  chs                  
 on chs.district_code=b.district_code                     
left outer join                         
( select @state_dist_cd district_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                        
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                        
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                        
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID                        
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                        
 ,sum(Total_ASHA) Total_ASHA,                        
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                        
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                        
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                        
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                        
 from Scheduled_AC_GF_State_District where District_Code=@state_dist_cd ) e                        
 on e.district_code=b.district_code               
    left outer join              
    (Select @state_dist_cd district_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,              
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (              
select COUNT(*) Total_District from TBL_DISTRICT where DIST_CD=@state_dist_cd ) t1,              
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK where DISTRICT_CD=@state_dist_cd ) t2,              
(select Count(*) Total_PHC from TBL_PHC where DIST_CD=@state_dist_cd) t3,              
(select Count(*) Total_SUBPHC from TBL_SUBPHC where DIST_CD=@state_dist_cd ) t4,              
(              
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,              
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,              
sum(Total_SC_not_Child) Total_SC_not_Child              
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate())) and District_ID=@District_Code             
) t5 )  t6              
on t6.district_code=b.district_code              
inner join                        
( select @state_dist_cd district_code,DIST_NAME_ENG as State_District_Name from TBL_DISTRICT where DIST_CD =@state_dist_cd) ts on ts.district_code=b.district_code                        
 end                   
  
end       
  
else if(@Type ='Monthly')                          
Begin       
declare @PrevYearID int   
if(@Month_ID<4)    
set @NewYear_ID=@finyr+1    
else    
set @NewYear_ID=@finyr   
  
if(@Month_ID=4)  
set @PrevYearID=@finyr-1  
else  
set @PrevYearID=@finyr  
  
                      
if(@Category ='State')                          
Begin            
    
                       
   set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                      
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
 set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                      
set @state_dist_cd=@State_Code                          
select @state_dist_cd state_code,@daysPast as daysPast                      
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 
  isnull(((Estimated_EC-Prv_Estimated_EC)/12),0) as Estimated_EC, 
 isnull((case when @finyr >@PrevYearID then ((Prv_Estimated_EC-Prv_Prv_Estimated_EC)/12) else ((Estimated_EC-Prv_Estimated_EC)/12) end),0)  as Prv_Estimated_EC 
 ,
  isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant,0) as Estimated_Infant ,
 isnull(Prv_Estimated_Infant,0) as Prv_Estimated_Infant, 
                            
isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,


PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                          
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                          
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW      
    ,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child ,

isnull(RCH_Reports.dbo.EC_Percentage_Monthly(isnull(Prv_Estimated_EC,0),isnull(Estimated_EC,0), isnull(EC_Registered,0)),0) as EC_Prorata,  
isnull(RCH_Reports.dbo.EC_Percentage_Monthly(case when @finyr>@PrevYearID then isnull(Prv_Prv_Estimated_EC,0)  else isnull(Prv_Estimated_EC,0) end ,case when @finyr>@PrevYearID then isnull(Prv_Estimated_EC,0) else isnull(Estimated_EC,0) end,isnull(Prv_EC_Registered,0)),0) as EC_Prorata_Prv 

                      
 from                           
(select @state_dist_cd state_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) )a                          
left outer join                           
(select @state_dist_cd state_code, SUM(Estimated_EC) Estimated_EC, (SUM(Estimated_Mother)/12) Estimated_Mother,(SUM(Estimated_Infant)/12) Estimated_Infant,SUM(Total_Mapped_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,           
   
              
SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=@finyr  and state_code=@state_dist_cd) b                          
 on a.state_code=b.state_code                          
     
   left outer join                         
(select @state_dist_cd state_code, (SUM(Estimated_Mother)/12) Prv_Estimated_Mother,(SUM(Estimated_Infant)/12) Prv_Estimated_Infant                   
 from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=(@PrevYearID) and state_code=@state_dist_cd) pe                        
 on a.state_code=pe.state_code 
   left outer join                         
(select @state_dist_cd state_code,  SUM(Estimated_EC) Prv_Estimated_EC                      
 from rch_reports.dbo.Estimated_Data_All_State (nolock) where Financial_Year=(@finyr-1) and state_code=@state_dist_cd) pb 
 on a.state_code=pb.state_code 
left outer join                        
(select @state_dist_cd state_code,  SUM(Estimated_EC) Prv_Prv_Estimated_EC                      
 from Estimated_Data_District_Wise (nolock) where Financial_Year=(@finyr-2) and state_code=@state_dist_cd) ppe                        
 on a.state_code=ppe.state_code                        
left outer join                           
(select @state_dist_cd state_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                     
                       
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID  and Filter_Type=1 and state_code=@state_dist_cd) c                          
on c.state_code=b.state_code                   
   left outer join                           
(select @state_dist_cd state_code, SUM(total_distinct_ec ) EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID  and Filter_Type=1 and state_code=@state_dist_cd) ec                          
on ec.state_code=b.state_code             
 left outer join                           
(select @state_dist_cd state_code, SUM(total_distinct_ec ) Prv_EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and state_code=@state_dist_cd) pec                          
on pec.state_code=b.state_code                      
left outer join                           
(select @state_dist_cd state_code, SUM(PW_Registered ) Prv_PW_Registered                        
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and state_code=@state_dist_cd) pc                          
on pc.state_code=b.state_code                     
left outer join                    
(select @state_dist_cd state_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                    
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) ) as Del_Due_Not_Reported,SUM(nopnc) nopnc                   
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and state_code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))                
                  
)   ps1                    
 on  ps1.state_code=b.state_code                    
left outer join                           
(select @state_dist_cd state_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                          
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                    
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID and Filter_Type=1 and state_code=@state_dist_cd) d                          
on d.state_code=b.state_code                          
left outer join                           
(select @state_dist_cd state_code, SUM(Infant_Registered ) Prv_Infant_Registered                        
   from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and state_code=@state_dist_cd) pd                          
on pd.state_code=b.state_code                      
left outer join                    
(select @state_dist_cd state_code,                   
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where state_code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -15, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -14, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))               
                  
)  chs                    
 on chs.state_code=b.state_code                       
left outer join                           
( select @state_dist_cd state_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                          
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                          
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                          
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID             
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                          
 ,sum(Total_ASHA) Total_ASHA,                          
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                          
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                          
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                          
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                          
 from Scheduled_AC_GF_State_District where state_code=@state_dist_cd ) e                          
 on e.state_code=b.state_code                 
    left outer join                
    (Select @state_dist_cd state_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (                
select COUNT(*) Total_District from TBL_DISTRICT ) t1,                
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK ) t2,                
(select Count(*) Total_PHC from TBL_PHC) t3,                
(select Count(*) Total_SUBPHC from TBL_SUBPHC ) t4,                
(                
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,                
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,                
sum(Total_SC_not_Child) Total_SC_not_Child                
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate()))                
) t5 )  t6                
on t6.state_code=b.state_code                
inner join                          
( select @state_dist_cd state_code,stateName as State_District_Name from TBL_STATE where StateID=@state_dist_cd) ts on ts.state_code=b.state_code                          
 end                          
 else if(@Category ='District')                          
Begin                      
                      
   set @BeginDate = cast((cast(@finyr as varchar(4))+'-04-01')as DATE)                      
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
 set @Daysinyear=(case when @finyr%4=0 then 366 else 365 end)                          
  set @state_dist_cd=@District_Code                        
select @state_dist_cd district_code,@daysPast as daysPast                      
 ,@Daysinyear as DaysinYear, State_District_Name ,Total_Village,village_mapped,Total_Profile_Entered,Total_Profile_Not_Entered,
 
  isnull(((Estimated_EC-Prv_Estimated_EC)/12),0) as Estimated_EC, 
 isnull((case when @finyr >@PrevYearID then ((Prv_Estimated_EC-Prv_Prv_Estimated_EC)/12) else ((Estimated_EC-Prv_Estimated_EC)/12) end),0)  as Prv_Estimated_EC 
 ,
  isnull(Estimated_Mother,0) as Estimated_Mother,
 isnull(Prv_Estimated_Mother,0) as Prv_Estimated_Mother,
 isnull(Estimated_Infant,0) as Estimated_Infant ,
 isnull(Prv_Estimated_Infant,0) as Prv_Estimated_Infant, 
                            
isnull(Prv_EC_Registered,0) as Prv_EC_Registered,
 isnull(EC_Registered,0) as EC_Registered,
isnull( PW_Registered,0) as PW_Registered,
 isnull( Prv_PW_Registered,0) as Prv_PW_Registered,

PW_First_Trimester,PW_High_Risk,PW_Severe_Anaemic,Infant_Registered,Prv_Infant_Registered,Infant_Reg_Within_30days,Infant_Low_birth_Weight,                          
 total_ANM,Total_ANM_self_Mob,Total_ANM_UID,Total_ANM_With_Bank,Total_ANM_With_Bank_UID,Total_ASHA,Total_asha_self_Mob,Total_asha_UID,Total_asha_With_Bank,Total_asha_With_Bank_UID                          
    ,Total_LMP,ALL_ANC,Any_three_ANC,Delivery,del_instt,Del_Home,Del_CSec,Del_Due_Not_Reported,nopnc,Total_Birthdate,BCG,Measles,AllVac,Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,        
    Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child ,

isnull(RCH_Reports.dbo.EC_Percentage_Monthly(isnull(Prv_Estimated_EC,0),isnull(Estimated_EC,0), isnull(EC_Registered,0)),0) as EC_Prorata,  
isnull(RCH_Reports.dbo.EC_Percentage_Monthly(case when @finyr>@PrevYearID then isnull(Prv_Prv_Estimated_EC,0)  else isnull(Prv_Estimated_EC,0) end ,case when @finyr>@PrevYearID then isnull(Prv_Estimated_EC,0) else isnull(Estimated_EC,0) end,isnull(Prv_EC_Registered,0)),0) as EC_Prorata_Prv  
                
 from                           
(select @state_dist_cd district_code,SUM(isnull(Total_Village,0))+SUM(isnull(Total_SubVillage,0)) as Total_Village from [Scheduled_BR_CM_Consolidated] (nolock) where District_ID =@state_dist_cd )a                          
left outer join                           
(select @state_dist_cd district_code, SUM(Estimated_EC) Estimated_EC, SUM(Estimated_Mother)/12 Estimated_Mother,SUM(Estimated_Infant)/12 Estimated_Infant,SUM(Total_Village) village_mapped,SUM(Total_Profile_Entered) Total_Profile_Entered,SUM(ISNULL(Total_ActiveVillage,1)-ISNULL(Total_Profile_Entered,0)) Total_Profile_Not_Entered from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr and District_Code=@state_dist_cd) b                          
 on a.district_code=b.district_code                          
     left outer join                          
(select @state_dist_cd district_code, (SUM(Estimated_Mother)/12) Prv_Estimated_Mother,(SUM(Estimated_Infant)/12) Prv_Estimated_Infant                   
 from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@PrevYearID) and District_Code=@state_dist_cd) pe                        
 on a.district_code=pe.district_code 
    left outer join                         
(select @state_dist_cd district_code,  SUM(Estimated_EC) Prv_Estimated_EC                      
 from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@finyr-1) and District_Code=@state_dist_cd) pb 
 on a.district_code=pb.district_code   
  
 left outer join                         
(select @state_dist_cd district_code,  SUM(Estimated_EC) Prv_Prv_Estimated_EC                      
 from Estimated_Data_Block_Wise (nolock) where Financial_Year=(@finyr-2) and District_Code=@state_dist_cd) ppe                        
 on a.district_code=ppe.district_code 
                         
                        
left outer join                           
(select @state_dist_cd district_code, SUM(PW_Registered ) PW_Registered,SUM(PW_First_Trimester) PW_First_Trimester ,SUM(PW_High_Risk) as PW_High_Risk                               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                     
                       
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID and Filter_Type=1 and District_Code=@state_dist_cd) c                          
on c.district_code=b.district_code                   
   left outer join                           
(select @state_dist_cd district_code, SUM(total_distinct_ec ) EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID and Filter_Type=1 and District_Code=@state_dist_cd) ec                          
on ec.district_code=b.district_code             
 left outer join                           
(select @state_dist_cd district_code, SUM(total_distinct_ec ) Prv_EC_Registered                  
                       
 from Scheduled_AC_EC_State_District_Month (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and District_Code=@state_dist_cd) pec                          
on pec.district_code=b.district_code                      
left outer join                           
(select @state_dist_cd district_code, SUM(PW_Registered ) Prv_PW_Registered                        
 from Scheduled_AC_PW_State_District_Month (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and District_Code=@state_dist_cd) pc                          
on pc.district_code=b.district_code                     
left outer join                    
(select @state_dist_cd district_code,  SUM(Total_LMP) Total_LMP,SUM(All_ANC) All_ANC,SUM(Any_three_ANC) Any_three_ANC,SUM(Delivery)Delivery,                    
SUM(Del_Pub+Del_Pri) del_instt,SUM(Del_Home)Del_Home,SUM(Del_CSec)Del_CSec,SUM(isnull(Total_LMP,0)-isnull(Delivery,0)-isnull(Abortion,0)-isnull(Death_ANC,0) ) as Del_Due_Not_Reported,SUM(nopnc) nopnc                   
FROM Scheduled_MH_Tracking_State_District_Month  where Filter_Type=1 and District_Code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -13, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -12, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))                
                   
                  
)   ps1                    
 on  ps1.district_code=b.district_code                    
left outer join                           
(select @state_dist_cd district_code, SUM(Infant_Registered ) Infant_Registered,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days                          
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                    
  from Scheduled_AC_Child_State_District_Month (nolock) where Fin_Yr=@finyr and Month_ID=@Month_ID and Filter_Type=1 and District_Code=@state_dist_cd) d                          
on d.district_code=b.district_code                          
left outer join                           
(select @state_dist_cd district_code, SUM(Infant_Registered ) Prv_Infant_Registered                        
   from Scheduled_AC_Child_District_Block_Month  (nolock) where Fin_Yr=(@PrevYearID) and Month_ID=(case when (@Month_ID=1) then 12 else (@Month_ID-1) end) and Filter_Type=1 and District_Code=@state_dist_cd) pd                          
on pd.district_code=b.district_code                      
left outer join                    
(select @state_dist_cd district_code,                   
sum(Total_Birthdate) Total_Birthdate,SUM(bcg) BCG,sum(isnull(measles,0)+isnull(MR1,0)) Measles,SUM(AllVac) AllVac  from Scheduled_Tracking_CH_State_District_Month  where District_Code=@state_dist_cd and                
cast((cast(Month_ID as varchar)+'/1/'+cast(Year_ID as varchar)) as DATe) between DATEADD(MONTH, -15, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))) and              
DATEADD(Day,-1, DATEADD(MONTH, -14, (cast((cast(@Month_ID as varchar)+'/1/'+cast(@NewYear_ID AS varchar)) as DATe))))               
                
                  
)  chs                    
 on chs.district_code=b.district_code                       
left outer join                           
( select @state_dist_cd district_code,sum(Total_ANM+Total_ANM2+Total_LinkWorker+Total_MPW+Total_GNM+Total_CHV) total_ANM,                          
 sum([Total_ANM_with_ValidatedPhone]+[Total_ANM2_with_ValidatedPhone]+[Total_CHV_with_ValidatedPhone]+[Total_GNM_with_ValidatedPhone]+[Total_LinkWorker_with_ValidatedPhone]+[Total_MPW_with_ValidatedPhone]) as Total_ANM_self_Mob,                          
 sum([Total_ANM_with_ACC]+[Total_ANM2_with_ACC]+[Total_CHV_with_ACC]+[Total_GNM_with_ACC]+[Total_LinkWorker_with_ACC]+Total_MPW_with_ACC) as Total_ANM_With_Bank                          
  ,sum([Total_ANM_with_UID]+[Total_ANM2_with_UID]+[Total_CHV_with_UID]+[Total_GNM_with_UID]+[Total_LinkWorker_with_UID])+sum([Total_MPW_with_UID])  as Total_ANM_UID                          
 ,SUM([Total_ANM_with_UID_Linked]+[Total_ANM2_with_UID_Linked]+[Total_CHV_with_UID_Linked]+[Total_GNM_with_UID_Linked] +[Total_LinkWorker_with_UID_Linked]+[Total_MPW_with_UID_Linked]) as Total_ANM_With_Bank_UID                          
 ,sum(Total_ASHA) Total_ASHA,                          
 sum(Total_ASHA_with_ValidatedPhone) as Total_asha_self_Mob,                          
 sum(Total_ASHA_with_ACC) as Total_asha_With_Bank                          
  ,sum(Total_ASHA_with_UID)  as Total_asha_UID                          
 ,SUM(Total_ASHA_with_UID_Linked) as Total_asha_With_Bank_UID                          
 from Scheduled_AC_GF_State_District where District_Code=@state_dist_cd ) e                          
 on e.district_code=b.district_code                 
    left outer join                
    (Select @state_dist_cd district_code, Total_District,Total_Blocks,Total_PHC,Total_SUBPHC,Total_District_not_PW, Total_Block_not_PW,Total_PHC_not_PW,Total_SC_not_PW,                
Total_District_not_Child, Total_Block_not_Child,Total_PHC_not_Child,Total_SC_not_Child from (                
select COUNT(*) Total_District from TBL_DISTRICT where DIST_CD=@state_dist_cd ) t1,                
(select Count(*) Total_Blocks from TBL_HEALTH_BLOCK where DISTRICT_CD=@state_dist_cd ) t2,                
(select Count(*) Total_PHC from TBL_PHC where DIST_CD=@state_dist_cd) t3,                
(select Count(*) Total_SUBPHC from TBL_SUBPHC where DIST_CD=@state_dist_cd ) t4,                
(                
select  sum(Total_District_not_PW) Total_District_not_PW, sum(Total_Block_not_PW) Total_Block_not_PW,sum(Total_PHC_not_PW) Total_PHC_not_PW, sum(Total_SC_not_PW) Total_SC_not_PW,                
sum(Total_District_not_Child) Total_District_not_Child, sum(Total_Block_not_Child)Total_Block_not_Child,sum(Total_PHC_not_Child) Total_PHC_not_Child,                
sum(Total_SC_not_Child) Total_SC_not_Child                
from dbo.Scheduled_BR_Facilities_Not_Entering_Data where Month_ID = MONTH(DATEADD(MONTH, -1, getdate())) and Year_ID = year(DATEADD(MONTH, -1, getdate())) and District_ID=@District_Code               
) t5 )  t6                
on t6.district_code=b.district_code                
inner join   
( select @state_dist_cd district_code,DIST_NAME_ENG as State_District_Name from TBL_DISTRICT where DIST_CD =@state_dist_cd) ts on ts.district_code=b.district_code                          
 end                     
end               
end

