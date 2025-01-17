USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_ABHA_ASHA_Detail_report]    Script Date: 09/26/2024 11:44:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*  
AC_ABHA_ASHA_Detail_report 1,29,2,12,3,0,0,2022,0,0 
*/  
  
ALTER proc [dbo].[AC_ABHA_ASHA_Detail_report]  
(  
@Category varchar(20) ='',  
@State_Code varchar(2)=0,              
@District_Code varchar(2)=0,             
@HealthBlock_Code varchar(15)=0,              
@HealthFacility_Code varchar(15)=0,             
@HealthSubFacility_Code varchar(15)=0,             
@Village_Code varchar(16)=0,            
@FinancialYr varchar(4),             
@Month_ID varchar(4),   
@ASHA_ID varchar(16)                              
)  
as Begin 
SET NOCOUNT ON    
Declare @Sql Varchar(Max)   
set @Sql='Select Row_number() over(order by registration_no) as Sno,  
isnull(i.DIST_NAME_ENG,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( i.DIST_CD,0) ) + '')'' as District,          
isnull(e.Block_Name_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( e.BLOCK_CD,0) ) + '')'' as [Health_Block],          
isnull(f.PHC_NAME,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + '')'' as [Health_Facility],                            
(case When isnull(g.SUBPHC_NAME_E,''--'') = ''--'' then ''--'' else g.SUBPHC_NAME_E + ''('' + CONVERT(VARCHAR(150),g.SUBPHC_CD) + '')'' end) as [Health_SubFacility],   
(case When isnull(GS.Name,''--'') = ''--'' then ''--'' else GS.Name + ''('' + CONVERT(VARCHAR(150),GS.ID) + '')'' end) as [ASHA],     
Name_wife as PW_Name,Registration_no,Mother_HealthIdNumber,HID_linked_date   
from t_mother_flat MF (nolock)  
left outer join t_Ground_Staff GS (nolock) on GS.ID=isnull(incentive_PW_ASHA_ID,0)  
Left outer join TBL_DISTRICT i With (NOLOCK) on i.DIST_CD = isnull(GS.District_Code,ISNULL(mf.M_District_ID,mf.district_id))                            
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on e.BLOCK_CD = isnull(GS.HealthBlock_Code,ISNULL(mf.M_HealthBlock_ID,mf.HealthBlock_ID))                           
Left outer join TBL_PHC f With (NOLOCK) on f.PHC_CD = isnull(GS.HealthFacilty_Code,ISNULL(mf.M_PHC_ID,mf.PHC_ID))                            
Left outer join TBL_SUBPHC g With (NOLOCK) on g.SUBPHC_CD = isnull(GS.HealthSubFacility_Code,ISNULL(mf.M_SubCentre_ID,mf.SubCentre_ID))   
where (Mother_HealthIdNumber <>''0'' and Mother_HealthIdNumber IS NOT NULL)   
and isnull(Delete_Mother,0)=0 and isnull(entry_type,''0'')<>''Death'' and distinct_ec=1
and (isnull(GS.District_Code,ISNULL(mf.M_District_ID,mf.district_id))='+@District_Code+')  
and (isnull(GS.HealthBlock_Code,ISNULL(mf.M_HealthBlock_ID,mf.HealthBlock_ID))='+@HealthBlock_Code+')' 
if(@HealthFacility_Code<>0)
begin
set @Sql = @Sql + ' and (isnull(GS.HealthFacilty_Code,ISNULL(mf.M_PHC_ID,mf.PHC_ID))='+@HealthFacility_Code+')'
end
if(@HealthSubFacility_Code<>0)
begin
set @Sql = @Sql + '    
and (isnull(GS.HealthSubFacility_Code,ISNULL(mf.M_SubCentre_ID,mf.SubCentre_ID))='+@HealthSubFacility_Code+')'
end  
set @Sql = @Sql + ' and (case when month(HID_linked_date)>3 then year(HID_linked_date) else year(HID_linked_date)-1 end)='+@FinancialYr+'  
and (Month(HID_linked_date)='+@Month_ID+' or '+@Month_ID+'=0)  
and isnull(incentive_PW_ASHA_ID,0)='+@ASHA_ID+'
' 
EXEC(@Sql) 
--Print(@Sql)  
END  



