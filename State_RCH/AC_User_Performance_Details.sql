USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_User_Performance_Details]    Script Date: 09/26/2024 11:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*              
AC_User_Performance_Details_new 0,2018,0,33,'Village_Profile',1   -- Done   
AC_User_Performance_Details_new 0,2018,0,6,'EC_Profile',2      -- Done   
AC_User_Performance_Details_new 0,2018,0,8,'EC_Tracking',1     -- Not Done but now Done   , type id=2 pre_year    
AC_User_Performance_Details_new 0,2018,0,33,'PW_Profile',1     -- Done  
AC_User_Performance_Details_new 0,2018,0,6,'PW_Services',2     -- Done         
AC_User_Performance_Details_new 0,2018,0,33,'CH_Profile',1                
AC_User_Performance_Details_new 0,2018,0,33,'CH_Service',1                
*/        
            
ALTER procedure [dbo].[AC_User_Performance_Details]             
(              
 @District_Code as int =0              
,@Financial_Year as int            
,@Month_ID int=0           
,@UserID as int               
,@Category as varchar(20)=''              
,@TypeID as int                  
)                     
as                  
SET NOCOUNT ON;              
begin   
declare @Pre_YR varchar(max);    
if(@TypeID=1)  
begin  
set @Pre_YR= ''+cast(@Financial_Year as int)+'';  
end  
else  
begin  
set @Pre_YR= ''+cast(@Financial_Year as int)+''-'1';  
end                    
if(@Category='Village_Profile')     -- Done              
begin                  
select b.DIST_NAME_ENG as District,c.Block_Name_E as Block,d.PHC_NAME as HealthFacility,isnull(e.SUBPHC_NAME_E,'Direct Entry') as Subcentre              
,isnull(f.Name_E,'Direct Entry') as Village,              
'' as ID,'' as case_no,'' as W_M_Name,'' as H_C_Name,'' as Address,'' as Mobile_no                
from t_villagewise_registry (nolock) a               
inner join TBL_DISTRICT (nolock) b on a.District_code=b.DIST_CD                
inner join TBL_HEALTH_BLOCK (nolock) c on a.HealthBlock_code=c.BLOCK_CD                
inner join TBL_PHC (nolock) d on a.HealthFacility_code=d.PHC_CD                  
left outer join TBL_SUBPHC (nolock) e on a.HealthSubCentre_code=e.SUBPHC_CD                  
left outer join Village (nolock) f on a.Village_code=f.VCode                  
where a.Created_By=@UserID              
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Financial_Year               
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)          
                
End              
else if(@Category='EC_Profile')    -- Done         
Begin              
Select b.DIST_NAME_ENG as District,c.Block_Name_E as Block,d.PHC_NAME as HealthFacility,isnull(e.SUBPHC_NAME_E,'Direct Entry') as Subcentre               
,isnull(f.Name_E,'Direct Entry') as Village ,               
a.Registration_No as ID,a.case_no as case_no,a.Name_Wife as W_M_Name,a.Name_husband as H_C_Name,a.Address,a.Mobile_no as Mobile_no              
from t_eligibleCouples (nolock) a              
inner join TBL_DISTRICT (nolock) b on a.District_code=b.DIST_CD                
inner join TBL_HEALTH_BLOCK (nolock) c on a.HealthBlock_code=c.BLOCK_CD                
inner join TBL_PHC (nolock) d on a.HealthFacility_code=d.PHC_CD                  
left outer join TBL_SUBPHC (nolock) e on a.HealthSubFacility_Code=e.SUBPHC_CD                  
left outer join Village (nolock) f on a.Village_code=f.VCode              
where  a.Created_By=@UserID     
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR         
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)       
end              
else if(@Category='EC_Tracking')     -- Service      -- Services in Previous FY checking type id=2     Done    
Begin              
Select b.DIST_NAME_ENG as District,c.Block_Name_E as Block,d.PHC_NAME as HealthFacility,isnull(e.SUBPHC_NAME_E,'Direct Entry') as Subcentre               
,isnull(f.Name_E,'Direct Entry') as Village               
,x.Registration_No as ID,x.case_no as case_no,a.Name_Wife as W_M_Name,a.Name_husband as H_C_Name,a.Address,a.Mobile_no as Mobile_no              
from t_eligible_couple_tracking (nolock) x               
inner join t_eligibleCouples (nolock) a On x.Registration_no=a.Registration_no and x.Case_no=a.Case_no              
inner join TBL_DISTRICT (nolock) b on x.District_code=b.DIST_CD                
inner join TBL_HEALTH_BLOCK (nolock) c on x.HealthBlock_code=c.BLOCK_CD                
inner join TBL_PHC (nolock) d on x.HealthFacility_code=d.PHC_CD                  
left outer join TBL_SUBPHC (nolock) e on x.HealthSubFacility_Code=e.SUBPHC_CD                  
left outer join Village (nolock) f on x.Village_code=f.VCode              
where  x.Created_By=@UserID
and (case when Month(x.Created_On)>3 then YEAR(x.Created_On) else YEAR(x.Created_On)-1 end) = @Pre_YR              
and (Month(x.Created_On)=@Month_ID or @Month_ID=0)         
end              
else if(@Category='PW_Profile')     -- PW Reg typeID=1 , TypeID=2 For previous Year    Done     
begin              
select b.DIST_NAME_ENG as District,c.Block_Name_E as Block,d.PHC_NAME as HealthFacility,isnull(e.SUBPHC_NAME_E,'Direct Entry') as Subcentre               
,isnull(f.Name_E,'Direct Entry') as Village                
,a.Registration_no as ID,a.Case_no as case_no,a.Name_PW as W_M_Name,a.Name_H as H_C_Name,a.Address,a.Mobile_no as Mobile_no              
from t_mother_registration (nolock) a                
inner join TBL_DISTRICT (nolock) b on a.District_code=b.DIST_CD                
inner join TBL_HEALTH_BLOCK (nolock) c on a.HealthBlock_code=c.BLOCK_CD                
inner join TBL_PHC (nolock) d on a.HealthFacility_code=d.PHC_CD                  
left outer join TBL_SUBPHC (nolock) e on a.HealthSubFacility_Code=e.SUBPHC_CD                  
left outer join Village (nolock) f on a.Village_code=f.VCode              
where  a.Created_By=@UserID 
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)              
and  a.Registration_Date<>'1990-01-01'           
end               
else if(@Category='PW_Services')        --PW Service      Done  
begin                 
select b.Name_E as District,c.Name_E as Block,d.Name_E as HealthFacility,isnull(e.Name_E,'Direct Entry') as Subcentre              
,isnull(f.Name_E,'Direct Entry') as Village               
,r.ID,r.case_no,a.Name_PW as W_M_Name,a.Name_H as H_C_Name,a.Address,a.Mobile_no as Mobile_nofrom from               
(select a.Registration_no as ID,a.Case_no as case_no,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On               
from t_mother_medical (nolock) a              
where                 
a.Created_By=@UserID 
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                    
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)     
UNION ALL              
select a.Registration_no as ID,a.Case_no as case_no,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On            
from t_mother_anc (nolock) a                
where a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                   
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)      
UNION ALL              
select a.Registration_no as ID,a.Case_no as case_no,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On            
from t_mother_delivery (nolock) a               
where a.Created_By=@UserID 
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                    
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)     
UNION ALL              
select a.Registration_no as ID,a.Case_no as case_no,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On           
from t_mother_infant (nolock) a                 
where  a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                     
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)     
UNION ALL              
select a.Registration_no as ID,a.Case_no as case_no,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On             
from t_mother_pnc (nolock) a                 
where a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)        
)r              
inner join t_mother_registration (nolock) a on a.Registration_no=r.ID and a.Case_no=r.case_no              
inner join District (nolock) b on b.DCode=r.District_Code                
inner join Health_Block (nolock) c on c.BID=r.HealthBlock_Code                
inner join Health_PHC (nolock) d on d.PID=r.HealthFacility_Code                  
left outer join Health_SubCentre (nolock) e on e.SID=r.HealthSubFacility_Code                  
left outer join Village (nolock) f on f.VCode=r.Village_Code              
where  r.Created_By=@UserID            
and (Month(r.Created_On)=@Month_ID or @Month_ID=0)               
end                
else if(@Category='CH_Profile')     --child Reg. with Pre_yr Reg in type id=2       Done         
begin              
select b.DIST_NAME_ENG as District,c.Block_Name_E as Block,d.PHC_NAME as HealthFacility,isnull(e.SUBPHC_NAME_E,'Direct Entry') as Subcentre               
,isnull(f.Name_E,'Direct Entry') as Village                
,a.Registration_no as ID,'' as case_no,a.Name_Mother as W_M_Name,a.Name_Child as H_C_Name,Address,a.Mobile_no as Mobile_no                               
from t_children_registration (nolock) a                             
inner join TBL_DISTRICT (nolock) b on a.District_code=b.DIST_CD                
inner join TBL_HEALTH_BLOCK (nolock) c on a.HealthBlock_code=c.BLOCK_CD                
inner join TBL_PHC (nolock) d on a.HealthFacility_code=d.PHC_CD                  
left outer join TBL_SUBPHC (nolock) e on a.HealthSubFacility_Code=e.SUBPHC_CD                  
left outer join Village (nolock) f on a.Village_code=f.VCode              
where  a.Created_By=@UserID             
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                       
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)                
end              
else if(@Category='CH_Service')         --Child Service      Done      
begin     
select b.Name_E as District,c.Name_E as Block,d.Name_E as HealthFacility,isnull(e.Name_E,'Direct Entry') as Subcentre               
,isnull(f.Name_E,'Direct Entry') as Village               
,r.ID,'' as case_no,a.Name_Mother as W_M_Name,a.Name_Child as H_C_Name,Address,a.Mobile_no as Mobile_no              
from               
(select a.Registration_no as ID,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On                          
from t_children_tracking (nolock) a        
where a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                      
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)    
UNION All              
select a.Registration_no as ID ,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On                            
from t_child_pnc (nolock) a                 
where  a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                          
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)                
UNION All              
select a.Registration_no as ID,a.District_Code,a.HealthBlock_Code,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,Created_By,Created_On                          
from t_children_tracking_medical (nolock) a               
where a.Created_By=@UserID
and (case when Month(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end) = @Pre_YR                                        
and (Month(a.Created_On)=@Month_ID or @Month_ID=0)   
)r              
inner join t_children_registration (nolock) a on a.Registration_no=r.ID              
inner join District (nolock) b on b.DCode=r.District_Code                
inner join Health_Block (nolock) c on c.BID=r.HealthBlock_Code                
inner join Health_PHC (nolock) d on d.PID=r.HealthFacility_Code                  
left outer join Health_SubCentre (nolock) e on e.SID=r.HealthSubFacility_Code                  
left outer join Village (nolock) f on f.VCode=r.Village_Code              
where r.Created_By=@UserID            
and (Month(r.Created_On)=@Month_ID or @Month_ID=0)               
end              
END

