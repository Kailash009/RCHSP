USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_ANM_Registration_EC_PW_CHILD]    Script Date: 09/26/2024 11:45:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  AC_ANM_Registration_EC_PW_CHILD_New 'District',30,1,0,0,0,0,3,2022  
--  AC_ANM_Registration_EC_PW_CHILD 'District',30,1,0,0,0,0,1,2017    
--  AC_ANM_Registration_EC_PW_CHILD 'Block',30,1,3,0,0,0,1,2017    
--  AC_ANM_Registration_EC_PW_CHILD 'PHC',30,1,3,11,0,0,0,2017    
--  AC_ANM_Registration_EC_PW_CHILD 'Subcentre',30,1,3,11,42,0,1,2018     
ALTER PROCEDURE [dbo].[AC_ANM_Registration_EC_PW_CHILD]    
(    
@Category varchar(20),    
@State_Code int=0,                    
@District_Code int=0,                    
@HealthBlock_Code int=0,                    
@HealthFacility_Code int=0,                    
@HealthSubFacility_Code int=0,                    
@Village_Code int=0,    
@Month_ID int ,    
@Year_ID int    
)    
AS    
begin    
if(@Category ='District')        
begin    
Select d.DIST_CD as ParentID,d.DIST_NAME_ENG as ParentName,c.BLOCK_CD as ChildID,c.Block_Name_E as ChildName,      
a.ANM_ID as ID,b.Name,b.Contact_No,  
isnull(a.EC_Reg,0) as EC_Register_ANM,isnull(a.PW_Reg,0) as PW_Register_ANM,isnull(a.Child_Reg,0) as Child_Register_ANM,  
isnull(a.PW_Service,0) as Total_ANM_Provide_Service_PW,isnull(a.Child_Service,0) as Total_ANM_Provide_Service_Child,
(case when Is_Active=1 then 'Active' else 'In Active' end) as Status_ANM,
isnull(d.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + ')' as District,      
isnull(c.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( c.BLOCK_CD,0) ) + ')' as [Health_Block],      
isnull(f.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + ')' as [Health_Facility],                        
isnull(g.SUBPHC_NAME_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + ')' as [Health_SubFacility] ,      
isnull(h.VILLAGE_NAME,'--') as [Village] 
from Scheduled_AC_ANM_EC_PW_Child_PHC_SubCenter_Monthwise_Count a   
inner join t_Ground_Staff b on a.ANM_ID=b.ID 
Left outer join TBL_DISTRICT d on d.DIST_CD=b.District_Code 
Left outer join TBL_HEALTH_BLOCK c on c.BLOCK_CD=b.HealthBlock_Code    
Left outer join TBL_PHC f With (NOLOCK) on f.PHC_CD=b.HealthFacilty_Code                       
Left outer join TBL_SUBPHC g With (NOLOCK) on g.SUBPHC_CD=b.HealthSubFacility_Code                     
Left outer join TBL_VILLAGE h With (NOLOCK) on h.VILLAGE_CD=b.Village_Code and h.SUBPHC_CD=b.HealthSubFacility_Code
where a.District_ID=@District_Code   
and (a.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)    
and a.Month_ID=@Month_ID  
and a.Year_ID=@Year_ID  
order by District,Health_Block,Health_Facility,Health_SubFacility,Village,Name
 end    
 else if(@Category ='Block')        
begin    
select c.BLOCK_CD as ParentID,c.Block_Name_E as ParentName,f.PHC_CD as ChildID,f.PHC_NAME as ChildName,      
a.ANM_ID as ID,b.Name,b.Contact_No,  
isnull(a.EC_Reg,0) as EC_Register_ANM,isnull(a.PW_Reg,0) as PW_Register_ANM,isnull(a.Child_Reg,0) as Child_Register_ANM,  
isnull(a.PW_Service,0) as Total_ANM_Provide_Service_PW,isnull(a.Child_Service,0) as Total_ANM_Provide_Service_Child,
(case when Is_Active=1 then 'Active' else 'In Active' end) as Status_ANM,
isnull(d.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + ')' as District,      
isnull(c.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( c.BLOCK_CD,0) ) + ')' as [Health_Block],      
isnull(f.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + ')' as [Health_Facility],                        
isnull(g.SUBPHC_NAME_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + ')' as [Health_SubFacility] ,      
isnull(h.VILLAGE_NAME,'--') as [Village]   
from Scheduled_AC_ANM_EC_PW_Child_PHC_SubCenter_Monthwise_Count a   
inner join t_Ground_Staff b on a.ANM_ID=b.ID  
Left outer join TBL_DISTRICT d on d.DIST_CD=b.District_Code 
Left outer join TBL_HEALTH_BLOCK c on c.BLOCK_CD=b.HealthBlock_Code    
Left outer join TBL_PHC f With (NOLOCK) on f.PHC_CD=b.HealthFacilty_Code                       
Left outer join TBL_SUBPHC g With (NOLOCK) on g.SUBPHC_CD=b.HealthSubFacility_Code                     
Left outer join TBL_VILLAGE h With (NOLOCK) on h.VILLAGE_CD=b.Village_Code and h.SUBPHC_CD=b.HealthSubFacility_Code 
where a.HealthBlock_ID =@HealthBlock_Code and   
(a.PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)    
and a.Month_ID=@Month_ID  
and a.Year_ID=@Year_ID   
order by District,Health_Block,Health_Facility,Health_SubFacility,Village,Name
end     
if(@Category ='PHC')        
begin    
select f.PHC_CD as ParentID,f.PHC_NAME as ParentName,g.SUBPHC_CD as ChildID,ISNULL(g.SUBPHC_NAME_E,'Direct Entry') as ChildName,      
 a.ANM_ID as ID,b.Name,b.Contact_No,  
isnull(a.EC_Reg,0) as EC_Register_ANM,isnull(a.PW_Reg,0) as PW_Register_ANM,isnull(a.Child_Reg,0) as Child_Register_ANM,  
isnull(a.PW_Service,0) as Total_ANM_Provide_Service_PW,isnull(a.Child_Service,0) as Total_ANM_Provide_Service_Child,(case when Is_Active=1 then 'Active' else 'In Active' end) as Status_ANM,
isnull(d.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + ')' as District,      
isnull(c.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( c.BLOCK_CD,0) ) + ')' as [Health_Block],      
isnull(f.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + ')' as [Health_Facility],                        
isnull(g.SUBPHC_NAME_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + ')' as [Health_SubFacility] ,      
isnull(h.VILLAGE_NAME,'--') as [Village]  
  from Scheduled_AC_ANM_EC_PW_Child_PHC_SubCenter_Monthwise_Count a   
inner join t_Ground_Staff b on a.ANM_ID=b.ID  
Left outer join TBL_DISTRICT d on d.DIST_CD=b.District_Code 
Left outer join TBL_HEALTH_BLOCK c on c.BLOCK_CD=b.HealthBlock_Code    
Left outer join TBL_PHC f With (NOLOCK) on f.PHC_CD=b.HealthFacilty_Code                       
Left outer join TBL_SUBPHC g With (NOLOCK) on g.SUBPHC_CD=b.HealthSubFacility_Code                     
Left outer join TBL_VILLAGE h With (NOLOCK) on h.VILLAGE_CD=b.Village_Code and h.SUBPHC_CD=b.HealthSubFacility_Code 
where a.PHC_ID =@HealthFacility_Code and   
(a.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and   
a.Month_ID=@Month_ID  and  
a.Year_ID=@Year_ID   
order by District,Health_Block,Health_Facility,Health_SubFacility,Village,Name
 end    
 else if(@Category ='Subcentre')        
begin     
select  g.SUBPHC_CD as ParentID,g.SUBPHC_NAME_E as ParentName,e.VCode as ChildID,isnull(e.Name_E,'Direct Entry') as ChildName,       
a.ANM_ID as ID,b.Name,b.Contact_No,  
isnull(a.EC_Reg,0) as EC_Register_ANM,isnull(a.PW_Reg,0) as PW_Register_ANM,isnull(a.Child_Reg,0) as Child_Register_ANM,isnull(a.PW_Service,0) as Total_ANM_Provide_Service_PW  
,isnull(a.Child_Service,0) as Total_ANM_Provide_Service_Child,(case when Is_Active=1 then 'Active' else 'In Active' end) as Status_ANM,
isnull(d.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + ')' as District,      
isnull(c.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( c.BLOCK_CD,0) ) + ')' as [Health_Block],      
isnull(f.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + ')' as [Health_Facility],                        
isnull(g.SUBPHC_NAME_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + ')' as [Health_SubFacility] ,      
isnull(e.Name_E,'--') as [Village]   
from Scheduled_AC_ANM_EC_PW_Child_PHC_SubCenter_Monthwise_Count a   
inner join t_Ground_Staff b on a.ANM_ID=b.ID  
Left outer join TBL_DISTRICT d on d.DIST_CD=b.District_Code 
Left outer join TBL_HEALTH_BLOCK c on c.BLOCK_CD=b.HealthBlock_Code    
Left outer join TBL_PHC f With (NOLOCK) on f.PHC_CD=b.HealthFacilty_Code                       
Left outer join TBL_SUBPHC g With (NOLOCK) on g.SUBPHC_CD=b.HealthSubFacility_Code                     
left outer join Village e on e.VCode=b.Village_Code  
where a.PHC_ID =@HealthFacility_Code and   
a.SubCentre_ID=@HealthSubFacility_Code and   
(a.Village_ID =@Village_Code or @Village_Code =0) and  
a.Month_ID=@Month_ID   
 and a.Year_ID=@Year_ID 
 order by District,Health_Block,Health_Facility,Health_SubFacility,Village,Name  
end    
end  

