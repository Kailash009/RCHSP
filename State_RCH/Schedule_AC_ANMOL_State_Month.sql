USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_AC_ANMOL_State_Month]    Script Date: 09/26/2024 14:42:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  ALTER procedure [dbo].[Schedule_AC_ANMOL_State_Month]    
as    
begin    
    
truncate table Scheduled_AC_ANMOL_State_Month    
    
insert into Scheduled_AC_ANMOL_State_Month    
( state_id , [Filter_Type]    
,[Total_User],[EC_Registered],[ECT_Count],[MR_Count],[MM_Count],[MA_Count],[MD_Count],[MI_Count],[MP_Count],[CR_Count],[CT_Count],[CP_Count],[CTM_Count]    
,[EC_Count_Updated],[ECT_Count_Updated],[MR_Count_Updated],[MM_Count_Updated],[MA_Count_Updated],[MD_Count_Updated],[MI_Count_Updated],[MP_Count_Updated]    
,[CR_Count_Updated],[CT_Count_Updated],[CP_Count_Updated],[CTM_Count_Updated],Existing_Users    
,[Month_ID],[Year_ID],[Fin_Yr])    
select state_id,  
Source_ID  
,count(distinct [UserID]) [Total_User]  
,Sum(isnull([EC_Total_Count],0)) [EC_Registered]  
,Sum(isnull([ECT_Count],0)) [ECT_Count]  
,Sum(isnull([MR_Total_Count],0)) [MR_Count]  
,Sum(isnull([MM_Count],0)) [MM_Count]  
,Sum(isnull([MA_Count],0)) [MA_Count]  
,Sum(isnull([MD_Count],0)) [MD_Count]  
,Sum(isnull([MI_Count],0))[MI_Count]  
,Sum(isnull([MP_Count],0)) [MP_Count]  
,Sum(isnull([CR_Count],0)) [CR_Count]  
,Sum(isnull([CT_Count],0)) [CT_Count]  
,Sum(isnull([CP_Count],0)) [CP_Count]  
,Sum(isnull([CTM_Count],0)) [CTM_Count]  
,Sum(isnull([EC_Total_Count_Updated],0)) [EC_Count_Updated]  
,Sum(isnull([ECT_Count_Updated],0)) [ECT_Count_Updated]  
,Sum(isnull([MR_Total_Count_Updated],0)) [MR_Count_Updated]  
,Sum(isnull([MM_Count_Updated],0)) [MM_Count_Updated]  
,Sum(isnull([MA_Count_Updated],0)) [MA_Count_Updated]  
,Sum(isnull([MD_Count_Updated],0)) [MD_Count_Updated]  
,Sum(isnull([MI_Count_Updated],0)) [MI_Count_Updated]  
,Sum(isnull([MP_Count_Updated],0)) [MP_Count_Updated]  
,Sum(isnull([CR_Count_Updated],0)) [CR_Count_Updated]  
,Sum(isnull([CT_Count_Updated],0)) [CT_Count_Updated]  
,Sum(isnull([CP_Count_Updated],0)) [CP_Count_Updated]  
,Sum(isnull([CTM_Count_Updated],0)) [CTM_Count_Updated],0  
,month(Created_Date) as Month_ID,Year(Created_Date) as Year_ID,Financial_Year  
  FROM [Scheduled_PHC_SubCenter_Village_Day_USER_REG] a   
   
     where a.STATE_ID is not null 
  group by  State_ID, [Source_ID],Financial_Year,MONTH(Created_Date),YEAR(Created_Date)  
    
update Scheduled_AC_ANMOL_State_Month set user_ins_count=X.user_ins_count from  
(  
Select a.STATE_ID  ,Source_ID ,MONTH(Created_Date) as MOnth_ID,YEar(Created_Date) as Year_ID, COUNT(distinct a.UserID ) as user_ins_count   
from [Scheduled_PHC_SubCenter_Village_Day_USER_REG] a  
where   
   
(a.EC_Total_Count > 0 or a.[ECT_Count] > 0 or   
a.[MR_Total_Count] > 0 or  
a.[MM_Count] > 0 or  
a.[MA_Count]> 0 or  
a.[MD_Count]> 0 or  
a.[MI_Count]> 0 or  
a.[MP_Count]> 0 or  
a.[CR_Count]> 0 or  
a.[CT_Count]> 0 or  
a.[CP_Count]> 0 or  
a.[CTM_Count]> 0 )  
group by a.state_id , a.Source_ID , month(a.Created_Date), Year(a.Created_Date) ,a.Financial_Year  
  
)X where   
X.State_ID   = Scheduled_AC_ANMOL_State_Month.STATE_ID  and  
X.Source_ID = Scheduled_AC_ANMOL_State_Month.filter_type and  
X.MOnth_ID=Scheduled_AC_ANMOL_State_Month.Month_ID and  
X.Year_ID=Scheduled_AC_ANMOL_State_Month.Year_ID  

update Scheduled_AC_ANMOL_State_Month set HP_ins_count=Y.HP_ins_count from      
(  
Select State_ID,a.Source_ID,month(a.Created_Date) mm,Year(a.Created_Date) yy , COUNT(distinct a.UserID ) as HP_ins_count     
from [Scheduled_PHC_SubCenter_Village_Day_USER_REG] a   
inner join t_Ground_Staff   g on g.ID=a.UserID  
where g.Type_ID in (2,3,5,6) and Is_Active=1 and  
(a.EC_Total_Count > 0 or a.[ECT_Count] > 0 or     
a.[MR_Total_Count] > 0 or    
a.[MM_Count] > 0 or    
a.[MA_Count]> 0 or    
a.[MD_Count]> 0 or    
a.[MI_Count]> 0 or    
a.[MP_Count]> 0 or    
a.[CR_Count]> 0 or    
a.[CT_Count]> 0 or    
a.[CP_Count]> 0 or    
a.[CTM_Count]> 0 )    
group by a.state_id , month(a.Created_Date),Year(a.Created_Date), a.Source_ID ,a.Financial_Year
)Y where
Y.State_ID =  Scheduled_AC_ANMOL_State_Month.STATE_ID  and 
Y.Source_ID = Scheduled_AC_ANMOL_State_Month.filter_type  and    
Y.mm = Scheduled_AC_ANMOL_State_Month.Month_ID and    
Y.yy = Scheduled_AC_ANMOL_State_Month.Year_ID 
  


End  
  