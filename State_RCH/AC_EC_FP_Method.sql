USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_FP_Method]    Script Date: 09/26/2024 11:46:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*     
AC_EC_FP_Method 1,0,0,0,0,0,2022,0,0,'','','State'    
AC_EC_FP_Method 29,2,0,0,0,0,2021,0,0,'','','District'    
AC_EC_FP_Method 29,2,14,0,0,0,2021,0,0,'','','Block'    
AC_EC_FP_Method 29,2,14,214,0,0,2021,0,0,'','','PHC'    
AC_EC_FP_Method 29,2,14,214,79,0,2021,0,0,'','','SubCentre'    
*/    
ALTER procedure [dbo].[AC_EC_FP_Method]                          
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
@Category varchar(20) =''                          
)                          
as                          
begin                                       
if(@Category='State')                            
begin                            
select  A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,                      
ISNULL(C.EC_since_inception,0) as EC_since_inception,    
ISNULL(D.Total_EC_Registered_New,0) as EC_New,    
(ISNULL(D.EC_Registered_New_Re_Reg,0) - ISNULL(D.Total_EC_Registered_New,0)) as EC_ReRegistration,    
ISNULL(B.Injectable_MPA,0) as Injectable_MPA,    
ISNULL(B.IUCD_375,0) as IUCD_375,    
ISNULL(B.IUCD_380A,0) as IUCD_380A,    
ISNULL(B.Male_Sterilization,0) as Male_Sterilization,    
ISNULL(B.Female_Sterilization,0) as Female_Sterilization,    
ISNULL(E.I_MPA_Since_Inception,0) as I_MPA_Since_Inception,    
ISNULL(E.IUCD_375_Since_Inception,0) as IUCD_375_Since_Inception,    
ISNULL(E.IUCD_380A_Since_Inception,0) as IUCD_380A_Since_Inception,    
ISNULL(E.Male_Str_Since_Inception,0) as Male_Str_Since_Inception,    
ISNULL(E.Female_Str_Since_Inception,0) as Female_Str_Since_Inception,   
ISNULL(C.EC_15_49,0) as EC_15_49,
ISNULL(B.OC_Pill,0) as OC_Pill ,
ISNULL(B.Other,0) as Other,
ISNULL(E.OC_Pill_Since_Inception,0) as OC_Pill_Since_Inception ,
ISNULL(E.Other_Since_Inception,0) as Other_Since_Inception 
              
from                      
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name                         
from TBL_DISTRICT a                          
inner join TBL_STATE b on a.StateID=b.StateID                          
where b.StateID=@State_Code               
)A                      
left outer join                      
(select c.State_Code,c.District_Code,                         
SUM(c.Injectable_MPA) as Injectable_MPA,    
SUM(c.IUCD_375) as IUCD_375,     
SUM(c.IUCD_380A) as IUCD_380A,    
SUM(Male_Sterilization) as Male_Sterilization,    
SUM(Female_Sterilization) as Female_Sterilization,
SUM(OC_Pill) as OC_Pill,
SUM(Other) as Other     
from  Schedule_EC_service_count_State_District c (nolock)                      
where c.Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)                          
 group by c.State_Code,c.District_Code                      
)B on A.State_Code=B.State_Code and A.District_Code=B.District_Code    
left outer join            
(            
Select State_Code,District_Code,            
SUM(total_distinct_ec) as EC_since_inception,  
SUM(EC_Wife_Cureent_age_15_To_49) as EC_15_49                              
from Scheduled_AC_EC_State_District_month (nolock)              
where Fin_Yr<=@FinancialYr             
group by State_Code,District_Code            
) C on A.State_Code=C.State_Code and A.District_Code=C.District_Code    
left outer join    
(    
Select State_Code,District_Code,             
SUM(total_distinct_ec) as Total_EC_Registered_New,    
SUM(EC_Registered) as EC_Registered_New_Re_Reg                              
from Scheduled_AC_EC_State_District_month (nolock)              
where Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)             
group by State_Code,District_Code    
) D on A.State_Code=D.State_Code and A.District_Code=D.District_Code    
left outer join               
(select State_Code,District_Code,                         
SUM(Injectable_MPA) as I_MPA_Since_Inception,    
SUM(IUCD_375) as IUCD_375_Since_Inception,     
SUM(IUCD_380A) as IUCD_380A_Since_Inception,    
SUM(Male_Sterilization) as Male_Str_Since_Inception,    
SUM(Female_Sterilization) as Female_Str_Since_Inception,
SUM(OC_Pill) as OC_Pill_Since_Inception,
SUM(Other) as Other_Since_Inception     
from Schedule_EC_service_count_State_District (nolock)                       
where Fin_Yr<=@FinancialYr                     
 group by State_Code,District_Code                      
)E on A.State_Code=E.State_Code and A.District_Code=E.District_Code                                              
end        
                      
else if(@Category='District')                            
begin                            
select  A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName ,                      
ISNULL(C.EC_since_inception,0) as EC_since_inception,    
ISNULL(D.Total_EC_Registered_New,0) as EC_New,    
(ISNULL(D.EC_Registered_New_Re_Reg,0) - ISNULL(D.Total_EC_Registered_New,0)) as EC_ReRegistration,    
ISNULL(B.Injectable_MPA,0) as Injectable_MPA,    
ISNULL(B.IUCD_375,0) as IUCD_375,    
ISNULL(B.IUCD_380A,0) as IUCD_380A,    
ISNULL(B.Male_Sterilization,0) as Male_Sterilization,    
ISNULL(B.Female_Sterilization,0) as Female_Sterilization,    
ISNULL(E.I_MPA_Since_Inception,0) as I_MPA_Since_Inception,    
ISNULL(E.IUCD_375_Since_Inception,0) as IUCD_375_Since_Inception,    
ISNULL(E.IUCD_380A_Since_Inception,0) as IUCD_380A_Since_Inception,    
ISNULL(E.Male_Str_Since_Inception,0) as Male_Str_Since_Inception,    
ISNULL(E.Female_Str_Since_Inception,0) as Female_Str_Since_Inception,   
ISNULL(C.EC_15_49,0) as EC_15_49,
ISNULL(B.OC_Pill,0) as OC_Pill ,
ISNULL(B.Other,0) as Other,
ISNULL(E.OC_Pill_Since_Inception,0) as OC_Pill_Since_Inception ,
ISNULL(E.Other_Since_Inception,0) as Other_Since_Inception                     
                          
from                      
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code ,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name                          
from TBL_HEALTH_BLOCK a (nolock)                         
inner join TBL_DISTRICT b (nolock) on a.DISTRICT_CD=b.DIST_CD                           
where a.DISTRICT_CD=@District_Code                      
)A                      
left outer join                      
(select c.District_Code,c.HealthBlock_Code,                         
SUM(c.Injectable_MPA) as Injectable_MPA,    
SUM(c.IUCD_375) as IUCD_375,     
SUM(c.IUCD_380A) as IUCD_380A,    
SUM(Male_Sterilization) as Male_Sterilization,    
SUM(Female_Sterilization) as Female_Sterilization,
SUM(OC_Pill) as OC_Pill,
SUM(Other) as Other                      
from  Schedule_EC_service_count_District_Block c (nolock)                        
where c.Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)                           
and c.District_Code=@District_Code                 
group by c.District_Code,c.HealthBlock_Code                      
)B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code     
left outer join            
(            
Select District_Code,HealthBlock_Code,             
SUM(total_distinct_ec) as EC_since_inception,  
SUM(EC_Wife_Cureent_age_15_To_49) as EC_15_49                               
from Scheduled_AC_EC_District_Block_Month (nolock)              
where(District_Code=@District_Code)            
and Fin_Yr<=@FinancialYr             
group by State_Code,District_Code,HealthBlock_Code            
) C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code    
left outer join    
(    
Select District_Code,HealthBlock_Code,            
SUM(total_distinct_ec) as Total_EC_Registered_New,     
SUM(EC_Registered) as EC_Registered_New_Re_Reg                              
from Scheduled_AC_EC_District_Block_Month (nolock)              
where (District_Code=@District_Code)            
and Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)              
group by State_Code,District_Code,HealthBlock_Code    
) D on A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code     
left outer join       
(    
Select District_Code,HealthBlock_Code,                         
SUM(Injectable_MPA) as I_MPA_Since_Inception,    
SUM(IUCD_375) as IUCD_375_Since_Inception,     
SUM(IUCD_380A) as IUCD_380A_Since_Inception,    
SUM(Male_Sterilization) as Male_Str_Since_Inception,    
SUM(Female_Sterilization) as Female_Str_Since_Inception,
SUM(OC_Pill) as OC_Pill_Since_Inception,
SUM(Other) as Other_Since_Inception     
from Schedule_EC_service_count_District_Block (nolock)                       
where Fin_Yr<=@FinancialYr                           
 group by District_Code,HealthBlock_Code                      
)E on A.District_Code=E.District_Code and A.HealthBlock_Code=E.HealthBlock_Code                                             
end                                                               
else if(@Category='Block')                            
begin                            
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName ,                         
ISNULL(C.EC_since_inception,0) as EC_since_inception,    
ISNULL(D.Total_EC_Registered_New,0) as EC_New,    
(ISNULL(D.EC_Registered_New_Re_Reg,0) - ISNULL(D.Total_EC_Registered_New,0)) as EC_ReRegistration,    
ISNULL(B.Injectable_MPA,0) as Injectable_MPA,    
ISNULL(B.IUCD_375,0) as IUCD_375,    
ISNULL(B.IUCD_380A,0) as IUCD_380A,    
ISNULL(B.Male_Sterilization,0) as Male_Sterilization,    
ISNULL(B.Female_Sterilization,0) as Female_Sterilization,    
ISNULL(E.I_MPA_Since_Inception,0) as I_MPA_Since_Inception,    
ISNULL(E.IUCD_375_Since_Inception,0) as IUCD_375_Since_Inception,    
ISNULL(E.IUCD_380A_Since_Inception,0) as IUCD_380A_Since_Inception,    
ISNULL(E.Male_Str_Since_Inception,0) as Male_Str_Since_Inception,    
ISNULL(E.Female_Str_Since_Inception,0) as Female_Str_Since_Inception,   
ISNULL(C.EC_15_49,0) as EC_15_49,
ISNULL(B.OC_Pill,0) as OC_Pill ,
ISNULL(B.Other,0) as Other,
ISNULL(E.OC_Pill_Since_Inception,0) as OC_Pill_Since_Inception ,
ISNULL(E.Other_Since_Inception,0) as Other_Since_Inception                                       
from                      
(select C.StateID as State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name                          
from TBL_PHC a (nolock)                         
  inner join TBL_HEALTH_BLOCK b (nolock) on a.BID=b.BLOCK_CD                      
  inner join TBL_DISTRICT C (nolock) on a.DIST_CD=C.DIST_CD                           
where a.BID=@HealthBlock_Code                       
)A                      
left outer join                      
(select c.HealthBlock_Code,c.HealthFacility_Code,                         
SUM(c.Injectable_MPA) as Injectable_MPA,    
SUM(c.IUCD_375) as IUCD_375,     
SUM(c.IUCD_380A) as IUCD_380A,    
SUM(Male_Sterilization) as Male_Sterilization,    
SUM(Female_Sterilization) as Female_Sterilization,
SUM(OC_Pill) as OC_Pill,
SUM(Other) as Other                       
from  Schedule_EC_service_count_Block_PHC c (nolock)                      
where c.Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)                           
and c.HealthBlock_Code=@HealthBlock_Code         
group by c.HealthBlock_Code,c.HealthFacility_Code                      
)B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code    
left outer join            
(            
Select HealthBlock_Code,HealthFacility_Code,             
SUM(total_distinct_ec) as EC_since_inception,  
SUM(EC_Wife_Cureent_age_15_To_49) as EC_15_49                               
from Scheduled_AC_EC_Block_PHC_Month (nolock)              
where HealthBlock_Code =@HealthBlock_Code          
and Fin_Yr<=@FinancialYr             
group by State_Code,HealthBlock_Code,HealthFacility_Code             
) C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code    
left outer join    
(    
Select HealthBlock_Code,HealthFacility_Code,            
SUM(total_distinct_ec) as Total_EC_Registered_New,    
SUM(EC_Registered) as EC_Registered_New_Re_Reg                                
from Scheduled_AC_EC_Block_PHC_Month (nolock)              
where HealthBlock_Code =@HealthBlock_Code            
and Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)             
group by State_Code,HealthBlock_Code,HealthFacility_Code    
) D on A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code    
left outer join    
(    
Select HealthBlock_Code,HealthFacility_Code,                         
SUM(Injectable_MPA) as I_MPA_Since_Inception,    
SUM(IUCD_375) as IUCD_375_Since_Inception,     
SUM(IUCD_380A) as IUCD_380A_Since_Inception,    
SUM(Male_Sterilization) as Male_Str_Since_Inception,    
SUM(Female_Sterilization) as Female_Str_Since_Inception,
SUM(OC_Pill) as OC_Pill_Since_Inception,
SUM(Other) as Other_Since_Inception     
from Schedule_EC_service_count_Block_PHC (nolock)                        
where Fin_Yr<=@FinancialYr                        
 group by HealthBlock_Code,HealthFacility_Code                      
)E on A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code    
end                          
else if(@Category='PHC')                            
begin                            
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName ,                      
ISNULL(C.EC_since_inception,0) as EC_since_inception,    
ISNULL(D.Total_EC_Registered_New,0) as EC_New,    
(ISNULL(D.EC_Registered_New_Re_Reg,0) - ISNULL(D.Total_EC_Registered_New,0)) as EC_ReRegistration,    
ISNULL(B.Injectable_MPA,0) as Injectable_MPA,    
ISNULL(B.IUCD_375,0) as IUCD_375,    
ISNULL(B.IUCD_380A,0) as IUCD_380A,    
ISNULL(B.Male_Sterilization,0) as Male_Sterilization,    
ISNULL(B.Female_Sterilization,0) as Female_Sterilization,    
ISNULL(E.I_MPA_Since_Inception,0) as I_MPA_Since_Inception,    
ISNULL(E.IUCD_375_Since_Inception,0) as IUCD_375_Since_Inception,    
ISNULL(E.IUCD_380A_Since_Inception,0) as IUCD_380A_Since_Inception,    
ISNULL(E.Male_Str_Since_Inception,0) as Male_Str_Since_Inception,    
ISNULL(E.Female_Str_Since_Inception,0) as Female_Str_Since_Inception,   
ISNULL(C.EC_15_49,0) as EC_15_49,
ISNULL(B.OC_Pill,0) as OC_Pill ,
ISNULL(B.Other,0) as Other,
ISNULL(E.OC_Pill_Since_Inception,0) as OC_Pill_Since_Inception ,
ISNULL(E.Other_Since_Inception,0) as Other_Since_Inception                                     
from                      
(select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(a.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name                      
from TBL_SUBPHC a (nolock)                        
inner join TBL_PHC b (nolock) on a.PHC_CD=b.PHC_CD                      
where a.PHC_CD= @HealthFacility_Code                       
)A                      
left outer join                      
(select c.HealthFacility_Code,c.HealthSubFacility_Code,                       
SUM(c.Injectable_MPA) as Injectable_MPA,    
SUM(c.IUCD_375) as IUCD_375,     
SUM(c.IUCD_380A) as IUCD_380A,    
SUM(Male_Sterilization) as Male_Sterilization,    
SUM(Female_Sterilization) as Female_Sterilization,
SUM(OC_Pill) as OC_Pill,
SUM(Other) as Other                
from Schedule_EC_service_count_PHC_SubCenter c (nolock)                      
where c.Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)                           
and c.HealthFacility_Code=@HealthFacility_Code          
group by c.HealthFacility_Code,c.HealthSubFacility_Code                     
)B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code    
left outer join            
(            
Select State_Code,HealthFacility_Code,HealthSubFacility_Code,             
SUM(total_distinct_ec) as EC_since_inception,  
SUM(EC_Wife_Cureent_age_15_To_49) as EC_15_49                               
from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)              
where HealthFacility_Code =@HealthFacility_Code        
and Fin_Yr<=@FinancialYr             
group by State_Code,HealthFacility_Code,HealthSubFacility_Code                
) C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code    
left outer join    
(    
Select State_Code,HealthFacility_Code,HealthSubFacility_Code,            
SUM(total_distinct_ec) as Total_EC_Registered_New,    
SUM(EC_Registered) as EC_Registered_New_Re_Reg                                
from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)              
where HealthFacility_Code =@HealthFacility_Code           
and Fin_Yr=@FinancialYr             
group by State_Code,HealthFacility_Code,HealthSubFacility_Code     
) D on A.HealthFacility_Code=D.HealthFacility_Code and A.HealthSubFacility_Code=D.HealthSubFacility_Code    
left outer join    
(    
Select HealthFacility_Code,HealthSubFacility_Code,                         
SUM(Injectable_MPA) as I_MPA_Since_Inception,    
SUM(IUCD_375) as IUCD_375_Since_Inception,     
SUM(IUCD_380A) as IUCD_380A_Since_Inception,    
SUM(Male_Sterilization) as Male_Str_Since_Inception,    
SUM(Female_Sterilization) as Female_Str_Since_Inception,
SUM(OC_Pill) as OC_Pill_Since_Inception,
SUM(Other) as Other_Since_Inception     
from Schedule_EC_service_count_PHC_SubCenter (nolock)                       
where Fin_Yr<=@FinancialYr                           
 group by HealthFacility_Code,HealthSubFacility_Code                      
)E on A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code    
end                         
else if(@Category='SubCentre')                            
begin       
select A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,                        
ISNULL(C.EC_since_inception,0) as EC_since_inception,    
ISNULL(D.Total_EC_Registered_New,0) as EC_New,    
(ISNULL(D.EC_Registered_New_Re_Reg,0) - ISNULL(D.Total_EC_Registered_New,0)) as EC_ReRegistration,     
ISNULL(B.Injectable_MPA,0) as Injectable_MPA,    
ISNULL(B.IUCD_375,0) as IUCD_375,    
ISNULL(B.IUCD_380A,0) as IUCD_380A,    
ISNULL(B.Male_Sterilization,0) as Male_Sterilization,    
ISNULL(B.Female_Sterilization,0) as Female_Sterilization,    
ISNULL(E.I_MPA_Since_Inception,0) as I_MPA_Since_Inception,    
ISNULL(E.IUCD_375_Since_Inception,0) as IUCD_375_Since_Inception,    
ISNULL(E.IUCD_380A_Since_Inception,0) as IUCD_380A_Since_Inception,    
ISNULL(E.Male_Str_Since_Inception,0) as Male_Str_Since_Inception,    
ISNULL(E.Female_Str_Since_Inception,0) as Female_Str_Since_Inception,   
ISNULL(C.EC_15_49,0) as EC_15_49,
ISNULL(B.OC_Pill,0) as OC_Pill ,
ISNULL(B.Other,0) as Other,
ISNULL(E.OC_Pill_Since_Inception,0) as OC_Pill_Since_Inception ,
ISNULL(E.Other_Since_Inception,0) as Other_Since_Inception                                    
from                      
(                      
 select v.SID as HealthSubFacility_Code,isnull(v.VCode,0) as Village_Code,sp.SUBPHC_NAME_E as HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name                        
 from Health_SC_Village v (nolock)                        
 left outer join TBL_VILLAGE vn (nolock) on vn.VILLAGE_CD=v.VCode and vn.SUBPHC_CD=v.SID                        
 left outer join TBL_SUBPHC sp (nolock) on sp.SUBPHC_CD=v.SID                        
 where sp.SUBPHC_CD=@HealthSubFacility_Code                                     
 )  A                       
left outer join                      
(select c.HealthSubFacility_Code,c.Village_Code,                         
SUM(c.Injectable_MPA) as Injectable_MPA,    
SUM(c.IUCD_375) as IUCD_375,     
SUM(c.IUCD_380A) as IUCD_380A,    
SUM(Male_Sterilization) as Male_Sterilization,    
SUM(Female_Sterilization) as Female_Sterilization,
SUM(OC_Pill) as OC_Pill,
SUM(Other) as Other                        
from  Schedule_EC_service_count_PHC_SubCenter_Village c (nolock)                      
where c.Fin_Yr=@FinancialYr     
and (Month_ID=@Month_ID or @Month_ID=0)                         
and c.HealthSubFacility_Code=@HealthSubFacility_Code                
group by c.HealthSubFacility_Code,c.Village_Code                     
)B on  A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code    
left outer join            
(            
Select State_Code,HealthSubFacility_Code,Village_Code,            
SUM(total_distinct_ec) as EC_since_inception,  
SUM(EC_Wife_Cureent_age_15_To_49) as EC_15_49                               
from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)               
where HealthSubFacility_Code =@HealthSubFacility_Code       
and Fin_Yr<=@FinancialYr             
group by State_Code,HealthSubFacility_Code,Village_Code                
) C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code    
left outer join    
(    
Select State_Code,HealthSubFacility_Code,Village_Code,            
SUM(total_distinct_ec) as Total_EC_Registered_New,    
SUM(EC_Registered) as EC_Registered_New_Re_Reg                               
from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)              
where HealthSubFacility_Code =@HealthSubFacility_Code          
and Fin_Yr=@FinancialYr    
and (Month_ID=@Month_ID or @Month_ID=0)              
group by State_Code,HealthSubFacility_Code,Village_Code     
) D on A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code    
left outer join    
(    
Select HealthSubFacility_Code,Village_Code,                         
SUM(Injectable_MPA) as I_MPA_Since_Inception,    
SUM(IUCD_375) as IUCD_375_Since_Inception,     
SUM(IUCD_380A) as IUCD_380A_Since_Inception,    
SUM(Male_Sterilization) as Male_Str_Since_Inception,    
SUM(Female_Sterilization) as Female_Str_Since_Inception, 
SUM(OC_Pill) as OC_Pill_Since_Inception,
SUM(Other) as Other_Since_Inception  
from Schedule_EC_service_count_PHC_SubCenter_Village (nolock)                        
where Fin_Yr<=@FinancialYr                           
 group by HealthSubFacility_Code,Village_Code      
)E on A.HealthSubFacility_Code=E.HealthSubFacility_Code and A.Village_Code=E.Village_Code    
end                         
end        

