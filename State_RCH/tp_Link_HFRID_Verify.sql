USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[tp_Link_HFRID_Verify]    Script Date: 09/26/2024 14:09:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
ALTER procedure [dbo].[tp_Link_HFRID_Verify]                      
  @type int=0,                      
 @State_Code int=0,                    
   @DCode int=0                  
                    
as begin                      
if(@type=1)                  
begin                  
select PID as Facility_PS,d.Name_E as district,t.Name_E as subDistrict,a.Name_E as Faciltiy_Name,d.mdds_code district_mdds,t.mdds_code taluka_mdds,        
district district_HFR,subDistrict subDistrict_HFR,b.Facilties_ID as Facility_ID,b.Faciltiy_Name as Facility_Name_HFR,district_LGD,Sub_disitrict_LGD,State_LGD,    
case when HFRID_verifyDt is null then 'Unverified' else 'Verified' end HFR_Status    
--,Is_Availabe,HFRID_verifyDt,HFRID_verify_by,HFRID_Update_by,HFRID_UpdateDt,Match_Score    
    
from All_Health_PHC  a (nolock)                   
inner join HFR_Govt_Facilties b (nolock) on b.Facilties_ID=a.hfrid         
inner join All_District d on a.DCode=d.DCode and d.StateID=a.State_Code         
inner join All_State_Taluka t on a.TCode=t.TCode  and t.State_Code =a.State_Code  where b.Linked_frm_backend is not null and (a.HFRID_verifyDt is null )                  
and a.State_Code=@State_Code and (a.DCode=@DCode or @Dcode=0)            
ORDER BY   district,subDistrict, a.Name_E            
                
                    
end                  
                  
else                  
begin                  
select SID as Facility_PS,d.Name_E as district,t.Name_E as subDistrict,a.Name_E as Faciltiy_Name,d.mdds_code district_mdds,t.mdds_code taluka_mdds,        
district district_HFR,subDistrict subDistrict_HFR,b.Facilties_ID as Facility_ID,b.Faciltiy_Name as Facility_Name_HFR,district_LGD,Sub_disitrict_LGD ,State_LGD       
,case when HFRID_verifyDt is null then 'Unverified' else 'Verified' end HFR_Status    
--,Is_Availabe,HFRID_verifyDt,HFRID_verify_by,HFRID_Update_by,HFRID_UpdateDt,Match_Score       
from All_Health_SubCentre  a (nolock)                  
inner join HFR_Govt_Facilties  b (nolock) on b.Facilties_ID=a.hfrid         
inner join All_District d on a.DCode=d.DCode and d.StateID=a.State_Code         
inner join All_State_Taluka t on a.TCode=t.TCode  and t.State_Code =a.State_Code  where b.Linked_frm_backend is not null and (a.HFRID_verifyDt is null )                  
and a.State_Code=@State_Code and (a.DCode=@DCode or @Dcode=0)                
ORDER BY  district,subDistrict, a.Name_E               
end                  
                  
end 