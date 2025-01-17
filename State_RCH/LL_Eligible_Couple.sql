USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[LL_Eligible_Couple]    Script Date: 09/26/2024 14:42:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
/*                        
--Registration                  
[LL_Eligible_Couple] 30,1,3,11,37,0,0,0,0,'','',1,1,30                         
*/                  
ALTER procedure [dbo].[LL_Eligible_Couple]                  
(              
@State_Code int=0,                    
@District_Code int=0,                    
@HealthBlock_Code int=0,                    
@HealthFacility_Code int=0,                    
@HealthSubFacility_Code int=0,                  
@Village_Code int=0,                  
@FinancialYr int=0,                   
@Month_ID int=0 ,                  
@Year_ID int=0 ,                  
@FromDate date='',                    
@ToDate date='' ,                  
@Category int =0,  --Cellvalue                                    
@Type int=1 ,--As per registration                  
@Level as varchar(15)='PHC',--Category PHC,Subcentre                  
@Report_Module as  int=30--Node ID of report                     
)                  
as                  
begin                  
SET NOCOUNT ON                  
                  
if(@Report_Module=23)-- Linelisting                  
begin                  
                  
select ROW_NUMBER()over (order by a.Registration_no,a.case_no ) as  Sno,                
isnull(d.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + ')' as District,            
isnull(e.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( e.BLOCK_CD,0) ) + ')' as [Health Block],            
isnull(f.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + ')'as [Health Facility],                    
isnull(g.SUBPHC_NAME_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + ')' as [Health SubFacility] ,            
isnull(h.VILLAGE_NAME,'--') as [Village],                 
Convert(varchar(12),a.Registration_no) as Registration_no,a.case_no as CaseNo,a.Name_Wife as Women_Name,a.Name_husband as HusBand_Name                  
,a.Wife_current_age as  Women_Age                  
,a.Whose_mobile                  
,a.Mobile_no                  
,a.[Address]                  
,Convert(Varchar(10),a.EC_Regisration_Date,103) as EC_Regisration_Date                  
,a.Infertility_status                  
,a.EC_Child_Total                  
--,(case isnull(a.PW_AadhaarLinked,0) when 1 then 'Y' else 'N' end) as PW_AadhaarLinked                  
,ISNULL(i.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(i.ID,0)) + ')' + '(MobNo.-' + ISNULL(i.Contact_No,0)+ ')' as ANM_Name              
,ISNULL(j.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(j.ID,0)) + ')' + '(MobNo.-' + ISNULL(j.Contact_No,0)+ ')' as ASHA_Name              
from t_mother_flat a WITH (NOLOCK)                  
inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no                  
inner join t_EC_Flat_Count c WITH (NOLOCK) on a. Registration_no=c.Registration_no and a.Case_no=c.Case_no             
Left outer join t_Ground_Staff i WITH (NOLOCK) on a.Mother_ANM_ID=i.ID                              
Left outer join t_Ground_Staff j WITH (NOLOCK) on a.Mother_ASHA_ID=j.ID                  
left outer join TBL_DISTRICT d With (NOLOCK) on a.District_ID=d.DIST_CD                    
left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                    
left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                    
left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                    
left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD                 
where b.EC_Registration_Date is not null                   
--and  (Case when Month(b.EC_Registration_Date)> 3 then YEAR(b.EC_Registration_Date) else YEAR(b.EC_Registration_Date)-1 end)=@FinancialYr                        
and ((Case when @Category =11 and Month(b.EC_Registration_Date)> 3 then YEAR(b.EC_Registration_Date) when @Category=11 and Month(b.EC_Registration_Date)<= 3 then  YEAR(b.EC_Registration_Date)-1 end)<=@FinancialYr       
OR  (Case when @Category !=11 and Month(b.EC_Registration_Date)> 3 then YEAR(b.EC_Registration_Date) when @Category!=11 and Month(b.EC_Registration_Date)<= 3 then  YEAR(b.EC_Registration_Date)-1 end)=@FinancialYr)           
and (CASE WHEN @Year_ID<>0 THEN YEAR(b.EC_Registration_Date) ELSE  0 END)=@Year_ID                    
and (CASE WHEN @Month_ID<>0 THEN MONTH(b.EC_Registration_Date) ELSE  0 END)=@Month_ID                    
and (c.StateID=@State_Code or @State_Code=0)                              
and (c.District_ID=@District_Code or @District_Code=0)                                
and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                                
and (c.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                                    
and (c.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)                      
and (CASE WHEN @Level = 'Subcentre' THEN c.Village_ID else 0 END)=@Village_Code                  
and (CASE @Category                   
WHEN 2 THEN b.PW_Aadhar_No_Present                  
when 3 THEN b.Address_Present                   
when 4 then b.PW_Bank_Name_Present                  
when 5 then b.Mobile_no_Present                  
when 6 then b.Mobile_no_Present                 
ELSE 1                  
END)=1                   
and ((Case when @Category=6 then b.Whose_mobile_Husband else 1 end)=1 or (case when @Category=6 then b.Whose_mobile_Wife else 1 end)=1)                  
and (case  @Category when 7 then c.EC_Child_Born  else 0 end)=0                  
and (case  @Category when 8 then c.EC_Child_Born  else 1 end)=1                  
and (case  @Category when 9 then c.EC_Child_Born  else 2 end)=2                  
and (case  @Category when 10 then c.EC_Child_Born  else 3 end)>2                
end                  
else if(@Report_Module=30 and @State_Code<>29)-- dashboard                  
begin                  
select ROW_NUMBER()over (order by a.Registration_no,a.case_no ) as  Sno,Convert(varchar(12),a.Registration_no) as [RCH ID],a.case_no as CaseNo,a.Name_Wife as [Women Name],a.Name_husband as [HusBand Name],a.Wife_current_age as [Women Age]                 
 
,(case Whose_mobile when 'Wife' then a.Mobile_no+'('+a.Whose_mobile+')' when 'Husband' then a.Mobile_no +'('+a.Whose_mobile+')'  else 'Others' end)as [Mobile No(Whose Mobile No)]                 
,a.[Address],Convert(Varchar(10),a.EC_Regisration_Date,103) As [Registration Date],isnull(dbo.Get_Masked_Account(a.PW_Account_No),'') as [Account No]                  
--,(case isnull(a.PW_AadhaarLinked,0) when 1 then 'Y' else 'N' end) as [PW Aadhaar Linked]                  
,a.Infertility_status [Infertility Status],a.EC_Child_Total [Total Children]        
,ISNULL(Male_child_born,0)as Male_child_born ,ISNULL(Female_child_born,0)as Female_child_born              
,ISNULL(i.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(i.ID,0)) + ')' + '(MobNo.-' + ISNULL(i.Contact_No,0)+ ')' as ANM_Name              
,ISNULL(j.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(j.ID,0)) + ')' + '(MobNo.-' + ISNULL(j.Contact_No,0)+ ')' as ASHA_Name    
from t_mother_flat a WITH (NOLOCK)                  
inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no                  
inner join t_EC_Flat_Count c WITH (NOLOCK) on a. Registration_no=c.Registration_no and a.Case_no=c.Case_no             
Left outer join t_Ground_Staff i WITH (NOLOCK) on a.Mother_ANM_ID=i.ID                              
Left outer join t_Ground_Staff j WITH (NOLOCK) on a.Mother_ASHA_ID=j.ID                   
where b.EC_Registration_Date is not null                   
and  ((Case when Month(b.EC_Registration_Date)> 3 then YEAR(b.EC_Registration_Date) else YEAR(b.EC_Registration_Date)-1 end)=@FinancialYr or @FinancialYr=0)                   
and (CASE WHEN @Year_ID<>0 THEN YEAR(b.EC_Registration_Date) ELSE  0 END)=@Year_ID                    
and (CASE WHEN @Month_ID<>0 THEN MONTH(b.EC_Registration_Date) ELSE  0 END)=@Month_ID                    
--and (c.StateID=@State_Code or @State_Code=0)                              
and (c.District_ID=@District_Code or @District_Code=0)                                
and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                                
and (c.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                                    
and (c.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)                    
and (CASE WHEN @Level = 'Subcentre' THEN c.Village_ID else 0 END)=@Village_Code                  
and (CASE @Category                   
--WHEN 2 THEN b.PW_Aadhar_No_Present        
WHEN 2 THEN c.Woman_RC_NUMBER                
when 3 THEN b.Address_Present                   
when 4 then b.PW_Bank_Name_Present                  
when 5 then b.Mobile_no_Present                  
when 6 then b.Mobile_no_Present                 
ELSE 1                  
END)=1                   
and ((Case when @Category=6 then b.Whose_mobile_Husband else 1 end)=1 or (case when @Category=6 then b.Whose_mobile_Wife else 1 end)=1)                  
and (case  @Category when 7 then c.EC_Child_Born  else 0 end)=0                  
and (case  @Category when 8 then c.EC_Child_Born  else 1 end)=1                  
and (case  @Category when 9 then c.EC_Child_Born  else 2 end)=2                  
and (case  @Category when 10 then c.EC_Child_Born  else 3 end)>2                 
and (case  @Category when 11 then c.distinct_ec  else 1 end)=1                 
and (case  @Category when 12 then c.distinct_ec  else 1 end)=1                                  
end                  
else if(@Report_Module=30 and @State_Code=29)-- dashboard                  
begin                  
select ROW_NUMBER()over (order by a.Registration_no,a.case_no ) as  Sno,Convert(varchar(12),a.Registration_no) as [RCH ID],a.case_no as CaseNo,a.Name_Wife as [Women Name],a.Name_husband as [HusBand Name],a.Wife_current_age as [Women Age]                  
,(case Whose_mobile when 'Wife' then a.Mobile_no+'('+a.Whose_mobile+')' when 'Husband' then a.Mobile_no +'('+a.Whose_mobile+')'  else 'Others' end)as [Mobile No(Whose Mobile No)]    
,Nullif(a.Hus_current_age,0) as [Husband Age],a.Woman_RC_NUMBER as [Family ID],a.Religion,a.Caste,a.Economic_Status as [RC Type]   
,a.[Address],Convert(Varchar(10),a.EC_Regisration_Date,103) As [Registration Date],isnull(dbo.Get_Masked_Account(a.PW_Account_No),'') as [Account No]                  
--,(case isnull(a.PW_AadhaarLinked,0) when 1 then 'Y' else 'N' end) as [PW Aadhaar Linked]                  
,a.Infertility_status [Infertility Status],a.EC_Child_Total [Total Children]        
,ISNULL(Male_child_born,0)as Male_child_born ,ISNULL(Female_child_born,0)as Female_child_born              
,ISNULL(i.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(i.ID,0)) + ')' + '(MobNo.-' + ISNULL(i.Contact_No,0)+ ')' as ANM_Name              
,ISNULL(j.Name,'')+'(ID-'+CONVERT(VARCHAR(150),ISNULL(j.ID,0)) + ')' + '(MobNo.-' + ISNULL(j.Contact_No,0)+ ')' as ASHA_Name    
from t_mother_flat a WITH (NOLOCK)                  
inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no                  
inner join t_EC_Flat_Count c WITH (NOLOCK) on a. Registration_no=c.Registration_no and a.Case_no=c.Case_no             
Left outer join t_Ground_Staff i WITH (NOLOCK) on a.Mother_ANM_ID=i.ID                              
Left outer join t_Ground_Staff j WITH (NOLOCK) on a.Mother_ASHA_ID=j.ID                   
where b.EC_Registration_Date is not null                   
and  ((Case when Month(b.EC_Registration_Date)> 3 then YEAR(b.EC_Registration_Date) else YEAR(b.EC_Registration_Date)-1 end)=@FinancialYr or @FinancialYr=0)                   
and (CASE WHEN @Year_ID<>0 THEN YEAR(b.EC_Registration_Date) ELSE  0 END)=@Year_ID                    
and (CASE WHEN @Month_ID<>0 THEN MONTH(b.EC_Registration_Date) ELSE  0 END)=@Month_ID                    
--and (c.StateID=@State_Code or @State_Code=0)                          
and (c.District_ID=@District_Code or @District_Code=0)                                
and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0)                                
and (c.PHC_ID =@HealthFacility_Code or  @HealthFacility_Code=0)                                    
and (c.SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0)                    
and (CASE WHEN @Level = 'Subcentre' THEN c.Village_ID else 0 END)=@Village_Code                  
and (CASE @Category                   
--WHEN 2 THEN b.PW_Aadhar_No_Present        
WHEN 2 THEN c.Woman_RC_NUMBER                
when 3 THEN b.Address_Present                   
when 4 then b.PW_Bank_Name_Present                  
when 5 then b.Mobile_no_Present                  
when 6 then b.Mobile_no_Present               
ELSE 1                  
END)=1                   
and ((Case when @Category=6 then b.Whose_mobile_Husband else 1 end)=1 or (case when @Category=6 then b.Whose_mobile_Wife else 1 end)=1)                  
and (case  @Category when 7 then c.EC_Child_Born  else 0 end)=0                  
and (case  @Category when 8 then c.EC_Child_Born  else 1 end)=1                  
and (case  @Category when 9 then c.EC_Child_Born  else 2 end)=2                  
and (case  @Category when 10 then c.EC_Child_Born  else 3 end)>2                 
and (case  @Category when 11 then c.distinct_ec  else 1 end)=1                 
and (case  @Category when 12 then c.distinct_ec  else 1 end)=1   
and (case  @Category when 13 then c.distinct_ec + c.Woman_RC_NUMBER else 2 end)=2               
                  
end                  
                  
end 