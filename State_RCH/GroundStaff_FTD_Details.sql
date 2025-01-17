USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[GroundStaff_FTD_Details]    Script Date: 09/26/2024 14:23:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		
/*                                          
GroundStaff_FTD_Details   1,35,3,0,0,0,0,2022,10                 
*/                                                                                          
ALTER procedure [dbo].[GroundStaff_FTD_Details]                                                  
(                              
@Category int=0,                                
@State_Code int=0,                                
@District_Code int=0,                               
@HealthBlock_Code int=0,                                
@HealthFacility_Code int=0,                                
@HealthSubFacility_Code int=0,                                
@Village_Code int=0 ,                                                         
@FinancialYr as int=0,  
@Month_ID int=0                             
)                                                  
as                                                  
begin                                                  
SET NOCOUNT ON                            
select Distinct isnull(b.Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( b.DCode,0) ) + ')' as District,    
isnull(c.Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( c.BID,0) ) + ')' as [Health_Block],    
isnull(e.Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( e.PID,0) ) + ')' as [Health_Facility],    
isnull(f.Name_E,'--')  + '(' + CONVERT(VARCHAR(150),ISNULL( f.SID,0) ) + ')' as [Health_SubFacility],                              
isnull(g.Name_E,'--') as [Village] ,a.ID as ID,isnull(a.Name,'--') as [Name],isnull(a.Contact_No,'--') as [Mobile_No],@Category as Cell_value,  
hitcount Attempt_count,  
x.apkversion,x.starttime,ISNULL(x.apistatuscode,0) as apistatuscode  
from t_Ground_Staff a WITH (NOLOCK)  
inner join t_healthproviderftd_login_status x WITH (NOLOCK) on x.healthproviderid=a.ID                            
inner join DISTRICT b WITH (NOLOCK) on b.DCode=x.districtcode                              
inner join HEALTH_BLOCK c WITH (NOLOCK) on c.BID=x.blockcode                               
inner join Health_PHC e WITH (NOLOCK) on e.PID=x.healthfacilitycode                              
left outer join Health_SubCentre f WITH (NOLOCK) on f.SID=x.healthsubfacilitycode  
left outer join VILLAGE g WITH (NOLOCK) on g.VCode=x.villagecode                              
where (x.districtcode=@District_Code)                              
and (CASE WHEN (MONTH (starttime)) <= 3 THEN YEAR(starttime)-1 ELSE YEAR(starttime) end)=@FinancialYr  
and (MONTH (starttime))=@Month_ID  
and (case when (@Category=2) then x.apistatuscode else 0 end) =0 
and (case when (@Category=3) then x.apistatuscode else 1 end) =1   
order by Name, starttime desc                                
END 