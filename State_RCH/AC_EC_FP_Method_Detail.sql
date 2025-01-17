USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_FP_Method_Detail]    Script Date: 09/26/2024 11:47:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
AC_EC_FP_Method_Detail  29,26,140,0,0,0,5,2022,0  
*/  
ALTER procedure [dbo].[AC_EC_FP_Method_Detail]                
(  
@State_Code  varchar(2)=0,                  
@District_Code  varchar(2)=0,                 
@HealthBlock_Code  varchar(15)=0,                     
@HealthFacility_Code  varchar(15)=0,                     
@HealthSubFacility_Code  varchar(15)=0,                   
@Village_Code varchar(16)=0,                                                        
@Category varchar(20) ='' ,  
@FinancialYr varchar(4),                             
@Month_ID varchar(4)=0    
)                
as                
begin                
SET NOCOUNT ON   
Declare @Sql Varchar(Max)      
Set @Sql='Select Row_number() over(order by m.registration_no) as Sno,  
isnull(i.DIST_NAME_ENG,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL(i.DIST_CD,0) ) + '')'' as District,          
isnull(e.Block_Name_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL(e.BLOCK_CD,0) ) + '')'' as [Health_Block],          
isnull(f.PHC_NAME,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL(f.PHC_CD,0) ) + '')'' as [Health_Facility],                            
isnull(g.SUBPHC_NAME_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL(g.SUBPHC_CD,0) ) + '')'' as [Health_SubFacility],          
isnull(h.VILLAGE_NAME,''--'') as [Village],  
Convert(varchar(12),m.Registration_no)as RCHID,m.Case_no as CaseNo,m.Name_PW as EC_Name,m.Name_H as HusbandName,m.Mobile_no as MobileNo,  
(case   
when t.Method=''M'' then ''Injectable MPA''   
when t.Method=''D'' then ''IUCD 375''   
when t.Method=''C'' then ''IUCD 380A''   
when t.Method=''F'' then ''Male Sterilization''   
when t.Method=''E'' then ''Female Sterilization''
when t.Method=''B'' then ''OC Pills''
when t.Method=''I'' then ''Other ''
 end) as Method ,   
Convert(Varchar(10),t.VisitDate,103) as Visit_Date                                                
from t_eligible_couple_tracking t with(nolock)       
inner join t_mother_registration m with(nolock) on t.Registration_no=m.Registration_no and t.case_no=m.case_no         
inner join RCH_national_level..m_Methods_PPMC_PPC n on t.method=n.method   
Left outer join TBL_DISTRICT i With (NOLOCK) on t.District_Code=i.DIST_CD                            
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on t.HealthBlock_Code=e.BLOCK_CD                            
Left outer join TBL_PHC f With (NOLOCK) on t.HealthFacility_Code=f.PHC_CD                            
Left outer join TBL_SUBPHC g With (NOLOCK) on t.HealthSubFacility_Code=g.SUBPHC_CD                            
Left outer join TBL_VILLAGE h With (NOLOCK) on t.Village_Code=h.VILLAGE_CD and t.HealthSubFacility_Code=h.SUBPHC_CD       
where ISNULL(delete_mother,0)=0 and m.created_on<cast(getdate() as date)'  
if (@Category < 8)  
begin  
set @Sql = @Sql +' and (Case when month(visitdate)>3 then year(visitdate) else year(visitdate)-1 end)='+@FinancialYr+'  
and (month(visitdate)='+@Month_ID+' or '+@Month_ID+'=0) '  
end  
if (@Category > 7)  
begin  
set @Sql = @Sql +' and (Case when month(visitdate)>3 then year(visitdate) else year(visitdate)-1 end)<='+@FinancialYr+''  
end  
set @Sql = @Sql +'                                    
and (t.District_Code='+@District_Code+' or '+@District_Code+'=0)                   
and (t.HealthBlock_Code='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)                                      
and (t.HealthFacility_Code ='+@HealthFacility_Code+' or  '+@HealthFacility_Code+'=0)                                          
and (t.HealthSubFacility_Code='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)      
and (t.Village_Code='+@Village_Code+' or '+@Village_Code+'=0 )'    
if(@Category=1 or @Category=8)          
begin          
set @Sql = @Sql + ' and n.Method =''M'' '  -- Injectable_MPA             
end   
if(@Category=2 or @Category=9)          
begin          
set @Sql = @Sql + ' and n.Method =''D'' ' --IUCD_375       
end   
if(@Category=3 or @Category=10)          
begin          
set @Sql = @Sql + ' and n.Method =''C'' ' --IUCD_380A          
end   
if(@Category=4 or @Category=11)          
begin          
set @Sql = @Sql + ' and n.Method =''F'' '--Male_Sterilization          
end  
if(@Category=5 or @Category=12)          
begin          
set @Sql = @Sql + ' and n.Method =''E'' '--Female_Sterilization          
end  
if(@Category=6 or @Category=12)          
begin          
set @Sql = @Sql + ' and n.Method =''B'' '--OC Pills          
end  
if(@Category=7 or @Category=12)          
begin          
set @Sql = @Sql + ' and n.Method =''I'' '--Other         
end  
--Print(@Sql)       
EXEC(@Sql)     
END  