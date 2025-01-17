USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Daily_Reporting_Status_Detail]    Script Date: 09/26/2024 11:46:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 /*                          
[AC_Daily_Reporting_Status_Detail] 30,0,0,0,0,0,1   --EC           
[AC_Daily_Reporting_Status_Detail] 30,0,0,0,0,0,2   --PW
[AC_Daily_Reporting_Status_Detail] 30,0,0,0,0,0,3   --CH        
*/              
ALTER procedure [dbo].[AC_Daily_Reporting_Status_Detail]              
(
@State_Code int=0,                
@District_Code int=0,                
@HealthBlock_Code int=0,                
@HealthFacility_Code int=0,                
@HealthSubFacility_Code int=0,              
@Village_Code int=0,                                                       
@Category int =0
)              
as              
begin              
  
SET NOCOUNT ON   

if(@Category=1)--EC
begin
select ROW_NUMBER()over (order by a.Registration_no,a.case_no ) as  Sno,
isnull(i.DIST_NAME_ENG,'--') as District,isnull(e.Block_Name_E,'--') as [HealthBlock],isnull(f.PHC_NAME,'--') as [HealthFacility],                  
isnull(g.SUBPHC_NAME_E,'--') as [HealthSubFacility] ,isnull(h.VILLAGE_NAME,'--') as [Village],
Convert(varchar(12),a.Registration_no) as Registration_no,
a.case_no as CaseNo,'' as Child_Name,a.Name_Wife as Women_Name,a.Name_husband as HusBand_Name  ,a.Wife_current_age as  Women_Age  
,a.Whose_mobile as [Mobileof] ,a.Mobile_no as MobileNo ,a.[Address]  ,'' as [DOB],'' as [Weight],Convert(Varchar(10),a.EC_Regisration_Date,103)as Registration_Date
,'' as [LMP],'' as [EDD],'' as ANMASHAName 
,'' as Family_ID,'' as Religion,'' as Caste,'' as RC_Type
from t_mother_flat a WITH (NOLOCK)  
--inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no  
--inner join t_EC_Flat_Count c WITH (NOLOCK) on a. Registration_no=c.Registration_no and a.Case_no=c.Case_no 
Left outer join TBL_DISTRICT i With (NOLOCK) on a.District_ID=i.DIST_CD                  
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                  
Left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                  
Left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                  
Left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.M_SubCentre_ID=h.SUBPHC_CD     
where a.EC_Regisration_Date is not null  
and a.EC_Created_On between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())    
and (a.StateID=@State_Code or @State_Code=0)              
and (a.District_ID=@District_Code or @District_Code=0)                
and (a.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                
and (a.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                    
and (a.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) 
and (a.Village_ID=@Village_Code or @Village_Code=0)  

end

else if(@Category=2)--PW
Begin
select Row_number() over(order by a.registration_no) as Sno,
isnull(i.DIST_NAME_ENG,'--') as District,isnull(e.Block_Name_E,'--') as [HealthBlock],isnull(f.PHC_NAME,'--') as [HealthFacility],                  
isnull(g.SUBPHC_NAME_E,'--') as [HealthSubFacility] ,isnull(h.VILLAGE_NAME,'--') as [Village],
Convert(varchar(12),a.Registration_no)as Registration_no,
a.Case_no as CaseNo,'' as Child_Name,a.Name_wife as Women_Name,a.Name_husband as HusBand_Name ,a.Mother_Age as Women_Age                     
,a.Whose_mobile as [Mobileof],a.Mobile_no as MobileNo,a.[Address],'' as [DOB],'' as [Weight],
Convert(varchar(10),a.Mother_Registration_Date,103)as Registration_Date,Convert(varchar(10),a.Medical_LMP_Date,103) as LMP,
Convert(varchar(10),a.Medical_EDD_Date,103) as EDD,c.Name + '(' + CONVERT(VARCHAR(150),c.ID ) + ')/' + d.Name + '(' + CONVERT(VARCHAR(150),d.ID ) + ')' as ANMASHAName 
,'' as Family_ID,'' as Religion,'' as Caste,'' as RC_Type
from t_mother_flat a WITH (NOLOCK)                        
--inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no     
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ANM_ID=c.ID    
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.Mother_ASHA_ID=d.ID
Left outer join TBL_DISTRICT i With (NOLOCK) on a.m_District_ID=i.DIST_CD                  
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.M_HealthBlock_ID=e.BLOCK_CD                  
Left outer join TBL_PHC f With (NOLOCK) on a.M_PHC_ID=f.PHC_CD                  
Left outer join TBL_SUBPHC g With (NOLOCK) on a.M_SubCentre_ID=g.SUBPHC_CD                  
Left outer join TBL_VILLAGE h With (NOLOCK) on a.M_Village_ID=h.VILLAGE_CD and a.M_SubCentre_ID=h.SUBPHC_CD        
where a.Mother_Created_On between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())    
and (a.StateID=@State_Code or @State_Code=0)            
and (a.District_ID=@District_Code or @District_Code=0)              
and (a.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)              
and (a.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                  
and (a.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)  
and (a.Village_ID=@Village_Code or @Village_Code=0)
End

else if(@Category=3)--CH

Begin
select Row_number() over(order by a.registration_no) as Sno,
isnull(i.DIST_NAME_ENG,'--') as District,isnull(e.Block_Name_E,'--') as [HealthBlock],isnull(f.PHC_NAME,'--') as [HealthFacility],                  
isnull(g.SUBPHC_NAME_E,'--') as [HealthSubFacility] ,isnull(h.VILLAGE_NAME,'--') as [Village],
Convert(varchar(12),a.Registration_no)as Registration_no, 
'' as CaseNo ,a.Name_Child as ChildName,a.Name_Mother as Women_Name,a.Name_Father as HusBand_Name,'' as Women_Age ,
'' as [Mobileof],a.Mobile_no as MobileNo ,a.[Address],Convert(Varchar(10),a.Birth_Date,103) as DOB,
a.[Weight],Convert(Varchar(10),a.Registration_Date,103) as Registration_Date ,'' as [LMP],'' as [EDD],
c.Name + '(' + CONVERT(VARCHAR(150),c.ID ) + ')/' + d.Name + '(' + CONVERT(VARCHAR(150),d.ID ) + ')' as ANMASHAName 
,'' as Family_ID,'' as Religion,'' as Caste,'' as RC_Type
from t_child_flat a WITH (NOLOCK)             
--inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no 
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID    
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.ASHA_ID=d.ID
Left outer join TBL_DISTRICT i With (NOLOCK) on a.District_ID=i.DIST_CD                  
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                  
Left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                  
Left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                  
Left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD                   
where a.Created_On between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())   
and (a.StateID=@State_Code or @State_Code=0)              
and (a.District_ID=@District_Code or @District_Code=0)                
and (a.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                
and (a.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                    
and (a.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) 
and (a.Village_ID=@Village_Code or @Village_Code=0)
end

else if(@Category=4)--EC WITH FAMILY ID

begin
select ROW_NUMBER()over (order by a.Registration_no,a.case_no ) as  Sno,
isnull(i.DIST_NAME_ENG,'--') as District,isnull(e.Block_Name_E,'--') as [HealthBlock],isnull(f.PHC_NAME,'--') as [HealthFacility],                  
isnull(g.SUBPHC_NAME_E,'--') as [HealthSubFacility] ,isnull(h.VILLAGE_NAME,'--') as [Village],
Convert(varchar(12),a.Registration_no) as Registration_no,
a.case_no as CaseNo,'' as Child_Name,a.Name_Wife as Women_Name,a.Name_husband as HusBand_Name  ,a.Wife_current_age as  Women_Age  
,a.Whose_mobile as [Mobileof] ,a.Mobile_no as MobileNo ,a.[Address]  ,'' as [DOB],'' as [Weight],Convert(Varchar(10),a.EC_Regisration_Date,103)as Registration_Date
,'' as [LMP],'' as [EDD],'' as ANMASHAName 
,a.Woman_RC_NUMBER as Family_ID,a.Religion,a.Caste,a.Economic_Status as RC_Type
from t_mother_flat a WITH (NOLOCK)  
--inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no  
--inner join t_EC_Flat_Count c WITH (NOLOCK) on a. Registration_no=c.Registration_no and a.Case_no=c.Case_no 
Left outer join TBL_DISTRICT i With (NOLOCK) on a.District_ID=i.DIST_CD                  
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                  
Left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                  
Left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                  
Left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.M_SubCentre_ID=h.SUBPHC_CD     
where a.EC_Regisration_Date is not null  
and a.EC_Created_On between CONVERT(date, GETDATE()-1) and CONVERT(date,GETDATE())    
and (a.StateID=@State_Code or @State_Code=0)              
and (a.District_ID=@District_Code or @District_Code=0)                
and (a.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                
and (a.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                    
and (a.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) 
and (a.Village_ID=@Village_Code or @Village_Code=0)  
and isnull(a.Woman_RC_NUMBER,'0')<> '0'
end
End

