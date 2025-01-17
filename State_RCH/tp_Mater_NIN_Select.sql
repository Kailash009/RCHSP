USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Mater_NIN_Select]    Script Date: 09/26/2024 14:49:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

          
/*        
tp_Mater_NIN_Select 2,0,0,21        
*/        
ALTER procedure [dbo].[tp_Mater_NIN_Select]        
(        
@District_Code as int=0,                    
@HealthBlock_Code as int=0,                    
@HealthFacility_Code as int=0,                    
@Menu_Id as int                
)        
As        
Begin         
IF (@Menu_Id=22) ---HealthSubfacility   BY Manas 2119  
 BEGIN          
select HS.SUBPHC_NAME_E+'('+CAST(HS.SUBPHC_CD as varchar)+')' as SUBCenter,HP.PHC_NAME+'('+CAST(HP.PHC_CD as varchar)+')' as PHC          
,HB.Block_Name_E+'('+CAST(HB.BLOCK_CD as varchar)+')' as Block ,t.Name_E+'('+t.TAL_CD+')' as Taluka            
,d.DIST_NAME_ENG+'('+CAST(d.DIST_CD as varchar)+')' as District,s.Name_E+'('+CAST(s.StateID as varchar)+')' as State,(case  HS.HSF_NIN when 0 then '' else HS.HSF_NIN end) as NIN_Number,        
HS.SUBPHC_CD as ID ,      
(case when convert(date,HS.Modified_On)=CONVERT(Date,GETDATE() ) then 1 else 0 end) as  ColorFeild       
from TBL_SUBPHC as HS             
Left Outer Join TBL_PHC as HP on HS.PHC_CD=HP.PHC_CD             
left outer join TBL_HEALTH_BLOCK HB on HP.BID=HB.BLOCK_CD            
Left Outer Join TBL_TALUKA as t on t.TAL_CD=HB.TALUKA_CD            
Left Outer Join TBL_DISTRICT  as d on d.DIST_CD=t.DIST_CD            
left outer join State as s on s.StateID=d.StateID            
where(HS.DIST_CD=@District_Code)            
and (HP.BID=@HealthBlock_Code or @HealthBlock_Code=0)            
and(HS.PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)
and ISNULL(HS.HSF_NIN,0)=0            
        
 END          
         
 ELSE IF (@Menu_Id=21) -- Health PHC BY Manas 2119     
  BEGIN          
select HP.PHC_NAME+'('+CAST(HP.PHC_CD as varchar)+')' as PHC,HB.Block_Name_E+'('+CAST(HB.BLOCK_CD as varchar)+')' as Block ,t.Name_E+'('+t.TAL_CD+')' as Taluka            
,d.DIST_NAME_ENG+'('+CAST(d.DIST_CD as varchar)+')' as District,s.Name_E+'('+CAST(s.StateID as varchar)+')' as State,(case  HP.HF_NIN when 0 then '' else HP.HF_NIN end)as NIN_Number         
,'' as  SUBCenter,HP.PHC_CD as ID,      
(case when convert(date,HP.Modified_On)=CONVERT(Date,GETDATE() ) then 1 else 0 end) as  ColorFeild       
from TBL_PHC as HP             
left outer join TBL_HEALTH_BLOCK HB on HP.BID=HB.BLOCK_CD            
Left Outer Join TBL_TALUKA as t on t.TAL_CD=HB.TALUKA_CD            
Left Outer Join TBL_DISTRICT  as d on d.DIST_CD=t.DIST_CD            
left outer join State as s on s.StateID=d.StateID            
where (HP.DIST_CD=@District_Code)            
and (HP.BID=@HealthBlock_Code or @HealthBlock_Code=0)            
and  (HP.PHC_CD=@HealthFacility_Code or @HealthFacility_Code=0)    
and ISNULL(HP.HF_NIN,0)=0        
         
              
 END          
        
        
        
END    

