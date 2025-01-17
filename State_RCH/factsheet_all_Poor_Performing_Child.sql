USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[factsheet_all_Poor_Performing_Child]    Script Date: 09/26/2024 11:59:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[factsheet_all_Poor_Performing_Child] @Category ='State',@State_Code=17,@finyr=2019,@Type='Yearly'   
--[factsheet_all_Poor_Performing_Child] @Category ='State',@State_Code=17,@finyr=2019,@Type='Quarterly',@Quarter_ID=2       
--[factsheet_all_Poor_Performing_Child] @Category ='District',@State_Code=30,@District_Code=1,@finyr=2018,@Type='A'         
ALTER procedure [dbo].[factsheet_all_Poor_Performing_Child]            
(            
@Category varchar(20),            
@Type as varchar(20)='',            
@finyr int,            
@State_Code int=0,            
@District_Code int=0 ,  
@Month_ID int=0  ,  
@Quarter_ID int=0             
)            
as             
begin            
declare @state_dist_cd char(2) ,@FinYrNew as int,@daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int              
  if(MONTH(GETDATE()-1)<=3)                    
set @FinYrNew=Year(GETDATE()-1)-1                    
else                    
set @FinYrNew=Year(GETDATE()-1)          
 set @BeginDate = CAST(@FinYr as varchar)+'-04'+'-01'            
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)<=0 then 1 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)            
 set @Daysinyear=(case when @FinYr%4=0 then 366 else 365 end)           
if(@Type ='Yearly')                            
Begin         
if(@Category ='State')           
begin           
 set @state_dist_cd=@State_Code            
 select  top 3 a.District_Code Code,DIST_NAME_ENG Name,Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered ,(case when @finyr=@FinYrNew then   (round(((convert(float,isnull(Infant_Registered,0))*@Daysinyear*100)/(Estimated_Infant*@daysPast))
,2)) else (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2))end) as per_child               
            
  from             
  ((select District_Code,SUM(Estimated_Infant) Estimated_Infant from Estimated_Data_District_Wise(nolock) where Financial_Year=@finyr  group by District_Code) a             
  left outer join             
  (select District_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_State_District_Month(nolock) where Fin_Yr=@finyr and Filter_Type=1 group by District_Code) c on c.District_Code=a.District_Code             
  inner join          
  (select DIST_CD, DIST_NAME_ENG from TBL_DISTRICT(nolock)  where StateID=@state_dist_cd )d on d.DIST_CD=a.District_Code          
    )        
  where (case when @finyr=@FinYrNew then   (round(((convert(float,isnull(Infant_Registered,0))*@Daysinyear*100)/(Estimated_Infant*@daysPast)),2)) else (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2))end) < 75        
  order by per_child         
          
            
  end          
        
else if(@Category ='District')           
begin           
  set @state_dist_cd=@District_Code            
   select  top 3 a.HealthBlock_Code Code,Block_Name_E Name ,Estimated_Infant,Infant_Registered  ,    
       
   (case when @finyr=@FinYrNew then   (round(((convert(float,Infant_Registered)*@Daysinyear)/(Estimated_Infant*@daysPast))*100,2)) else (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))end) as per_child                      
  from             
  ((select HealthBlock_Code,SUM(Estimated_Infant) Estimated_Infant from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr  group by HealthBlock_Code) a             
  left outer join             
  (select HealthBlock_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_District_Block_Month (nolock) where Fin_Yr=@finyr and Filter_Type=1 group by HealthBlock_Code) c on c.HealthBlock_Code=a.HealthBlock_Code             
  inner join          
  (select BLOCK_CD, Block_Name_E from TBL_HEALTH_BLOCK (nolock) where DISTRICT_CD=@state_dist_cd )d on d.BLOCK_CD=a.HealthBlock_Code          
    )        
  where (case when @finyr=@FinYrNew then   (round(((convert(float,Infant_Registered)*@Daysinyear*100)/(Estimated_Infant*@daysPast)),2)) else (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))end)< 75        
  order by per_child         
          
            
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
begin           
  set @state_dist_cd=@State_Code            
   select  top 3 a.District_Code Code,DIST_NAME_ENG Name,Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered  ,    
   (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2)) as per_child               
            
  from             
  ((select District_Code,(SUM(Estimated_Infant)/4) Estimated_Infant from Estimated_Data_District_Wise(nolock) where Financial_Year=@finyr  group by District_Code) a             
  left outer join             
  (select District_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_State_District_Month(nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID) and Filter_Type=1 group by District_Code) c on c.District_Code=a.District_Code             
  inner join          
  (select DIST_CD, DIST_NAME_ENG from TBL_DISTRICT (nolock) where StateID=@state_dist_cd )d on d.DIST_CD=a.District_Code          
    )        
  where  (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2)) < 75        
  order by per_child         
          
            
  end          
        
  else if(@Category ='District')           
begin           
  set @state_dist_cd=@District_Code            
   select  top 3 a.HealthBlock_Code Code,Block_Name_E Name ,Estimated_Infant,Infant_Registered  ,    
       
   (case when @finyr=@FinYrNew then   (round(((convert(float,Infant_Registered)*@Daysinyear)/(Estimated_Infant*@daysPast))*100,2)) else (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))end) as per_child                      
  from             
  ((select HealthBlock_Code,(SUM(Estimated_Infant)/12) Estimated_Infant from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr  group by HealthBlock_Code) a             
  left outer join             
  (select HealthBlock_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_District_Block_Month (nolock) where Fin_Yr=@finyr and (Month_ID between @start_month_ID and @endmonth_ID) and Filter_Type=1 group by HealthBlock_Code) c on c.HealthBlock_Code=a.HealthBlock_Code             
  inner join          
  (select BLOCK_CD, Block_Name_E from TBL_HEALTH_BLOCK (nolock)  where DISTRICT_CD=@state_dist_cd )d on d.BLOCK_CD=a.HealthBlock_Code          
    )        
  where  (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))< 75        
  order by per_child         
          
            
  end       
    
  end   
  else if(@Type ='Monthly')                            
Begin    
if(@Category ='State')           
begin           
  set @state_dist_cd=@State_Code            
   select  top 3 a.District_Code Code,DIST_NAME_ENG Name,Estimated_Infant,isnull(Infant_Registered,0) as Infant_Registered  ,    
   (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2)) as per_child               
            
  from             
  ((select District_Code,(SUM(Estimated_Infant)/12) Estimated_Infant from Estimated_Data_District_Wise(nolock) where Financial_Year=@finyr  group by District_Code) a             
  left outer join             
  (select District_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_State_District_Month(nolock) where Fin_Yr=@finyr and (Month_ID =@Month_ID) and Filter_Type=1 group by District_Code) c on c.District_Code=a.District_Code            
 
  inner join          
  (select DIST_CD, DIST_NAME_ENG from TBL_DISTRICT (nolock) where StateID=@state_dist_cd )d on d.DIST_CD=a.District_Code          
    )        
  where  (round((convert(float,isnull(Infant_Registered,0))/Estimated_Infant)*100,2)) < 75        
  order by per_child         
          
            
  end          
        
  else if(@Category ='District')           
begin           
  set @state_dist_cd=@District_Code            
   select  top 3 a.HealthBlock_Code Code,Block_Name_E Name ,Estimated_Infant,Infant_Registered  ,    
       
   (case when @finyr=@FinYrNew then   (round(((convert(float,Infant_Registered)*@Daysinyear)/(Estimated_Infant*@daysPast))*100,2)) else (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))end) as per_child                      
  from             
  ((select HealthBlock_Code,(SUM(Estimated_Infant)/12) Estimated_Infant from Estimated_Data_Block_Wise (nolock) where Financial_Year=@finyr  group by HealthBlock_Code) a             
  left outer join             
  (select HealthBlock_Code,SUM(Infant_Registered ) Infant_Registered from Scheduled_AC_Child_District_Block_Month (nolock) where Fin_Yr=@finyr and (Month_ID =@Month_ID) and Filter_Type=1 group by HealthBlock_Code) c on c.HealthBlock_Code=a.HealthBlock_Code             
  inner join          
  (select BLOCK_CD, Block_Name_E from TBL_HEALTH_BLOCK (nolock)  where DISTRICT_CD=@state_dist_cd )d on d.BLOCK_CD=a.HealthBlock_Code          
    )        
  where  (round((convert(float,Infant_Registered)/Estimated_Infant)*100,2))< 75        
  order by per_child         
          
            
  end     
end  
  end  

