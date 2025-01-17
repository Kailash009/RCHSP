USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[LL_Child]    Script Date: 09/26/2024 12:09:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   /*29,2,14,2564,10933,*/      
   --LL_Child 29,1,6,0,0,0,2021,0,0,'','',1,1,'PHC',23   
   --LL_Child 29,1,6,0,0,0,2021,0,0,'','',1,1,'PHC',30  
   --LL_Child_new 29,1,6,0,0,0,2021,0,0,'','',7,1,'PHC',23  
   --LL_Child 29,1,6,0,0,0,2021,0,0,'','',0,1,'PHC',30    
  
ALTER procedure [dbo].[LL_Child]                                        
(                        
@State_Code Varchar(2)=0,                                          
@District_Code Varchar(4)=0,                                          
@HealthBlock_Code Varchar(15)=0,                                          
@HealthFacility_Code Varchar(15)=0,                                          
@HealthSubFacility_Code Varchar(15)=0,                                        
@Village_Code Varchar(16)=0,                                        
@FinancialYr varchar(4),                                         
@Month_ID varchar(4)=0 ,                                        
@Year_ID varchar(4)=0 ,                                        
@FromDate date='',                                          
@ToDate date='' ,                                        
@Category varchar(2) =0,                                        
@Type varchar(2)=1,                            
@Level as varchar(15)='',                               
@Report_Module as varchar(2)=30--Node ID of report                                                                
)                                        
as                                        
begin                                        
                         
SET NOCOUNT ON                             
Declare @Sql Varchar(Max)                   
if(@Report_Module=23)                            
begin                  
set @Sql= 'select Row_number() over(order by a.registration_no) as Sno,                        
isnull(d.DIST_NAME_ENG,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + '')''  as District,              
isnull(e.Block_Name_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( e.BLOCK_CD,0) ) + '')'' as [Health_Block],              
isnull(f.PHC_NAME,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + '')'' as [Health_Facility],                          
isnull(g.SUBPHC_NAME_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + '')'' as [Health_SubFacility] ,              
isnull(h.VILLAGE_NAME,''--'') as [Village],                        
Convert(varchar(12),a.Registration_no)as RCHID,                                        
a.Name_Child as ChildName,a.Name_Father as FatherName,a.Name_Mother as MotherName,a.Mobile_no as MobileNo                            
,Convert(Varchar(10),a.Birth_Date,103) as DOB                                        
,a.[Address]                            
--,dbo.Get_Masked_UID(a.Child_Aadhaar_No) as AadhaarNo                 
,ISNULL(c.Name,'''')+''(ID-''+CONVERT(VARCHAR(150),ISNULL(c.ID,0)) + '')'' + ''(MobNo.-'' + ISNULL(c.Contact_No,0)+ '')'' as ANM_Name                
,ISNULL(c1.Name,'''')+''(ID-''+CONVERT(VARCHAR(150),ISNULL(c1.ID,0)) + '')'' + ''(MobNo.-'' + ISNULL(c1.Contact_No,0)+ '')'' as ASHA_Name                         
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate                    
--,Convert(varchar(14),a.Child_EID)as EnrollmentNo,a.Child_EIDTime as EnrollmentTime,                          
,a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,                            
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                                        
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,                            
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,                            
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles,Convert(Varchar(10),a.Rota_Virus_Dt,103) as Rota1,Convert(Varchar(10),a.Rota_Dose2_Dt ,103) as Rota2,                  
Convert(Varchar(10),a.Rota_Dose3_Dt ,103) as Rota3,Convert(Varchar(10),a.IPV_Dose1_Dt ,103) as IPV1,Convert(Varchar(10),a.IPV_Dose2_Dt ,103) as IPV2,Convert(Varchar(10),a.PCV_Dose1_Dt ,103) as PCV1,                  
Convert(Varchar(10),a.PCV_Dose2_Dt ,103) as PCV2,Convert(Varchar(10),a.PCV_DoseB_Dt ,103) as PCVB,Convert(Varchar(10),a.JE1_Dt ,103) as JE1,Convert(Varchar(10),a.MR1_Dt ,103) as MR1,          
Convert(Varchar(10),a.OPVBooster_Dt ,103) as OPVB,          
Convert(Varchar(10),a.DPTBooster1_Dt ,103) as DPTB1,          
Convert(Varchar(10),a.DPTBooster2_Dt ,103) as DPTB2,          
Convert(Varchar(10),a.Measles2_Dt ,103) as Measles2,          
--Convert(Varchar(10),a.MR1_Dt ,103) as MR1,          
Convert(Varchar(10),a.JE2_Dt ,103) as JE2,          
Convert(Varchar(10),a.MR_Dt ,103) as MR2,      
Convert(Varchar(10),a.VitK_Dt ,103) as VitK           
                  
,(case when Entry_type_death=1 then ''Yes'' else ''No'' end)  as  ChildDeath                   
,dbo.Deactivation_Service(0) as ImmuCode                  
                                      
from t_child_flat a WITH (NOLOCK)                                   
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no                  
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID                            
Left outer join t_Ground_Staff c1 WITH (NOLOCK) on a.ASHA_ID=c1.ID                       
left outer join TBL_DISTRICT d With (NOLOCK) on a.District_ID=d.DIST_CD                          
left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                          
left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                        
left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                          
left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD   
where (CASE '+@Type+' WHEN  1 THEN b.ChildReg_Fin_Yr  when 2 then (Case when b.Child_Birthdate_Month> 3 then Child_Birthdate_Yr else Child_Birthdate_Yr-1 end) END)='+@FinancialYr +'                                   
and (CASE WHEN '+@Type+' = 1 and '+@Year_ID+'<>0 THEN b.Child_Registration_Yr WHEN '+@Type+' = 2 and '+@Year_ID+'<>0 THEN b.Child_Birthdate_Yr  ELSE  0 END)='+@Year_ID+'                              
and (CASE WHEN '+@Type+' = 1 and '+@Month_ID+'<>0 THEN b.Child_Registration_Month WHEN '+@Type+' = 2 and '+@Month_ID+'<>0 THEN b.Child_Birthdate_Month  ELSE  0 END)='+@Month_ID+'   
and (b.StateID='+@State_Code+')  
and (b.District_ID='+@District_Code+')      
and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)      
and (b.PHC_ID ='+@HealthFacility_Code+' or '+@HealthFacility_Code+'=0)           
and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)   
and (CASE WHEN '''+cast(@Level as varchar(15))+''' = ''Subcentre'' THEN b.Village_ID else 0 END)='+@Village_Code+''  
if(@Category=2)      
begin      
set @Sql = @Sql + ' and b.Child_Aadhar_No_Present=1'      
end  
if(@Category=3)      
begin      
set @Sql = @Sql + ' and b.Address_Present=1'      
end  
if(@Category=6)      
begin      
set @Sql = @Sql + ' and b.Child_EID_Present=1'      
end  
if(@Category=7)      
begin      
set @Sql = @Sql + ' and b.Child_1_2=1'      
end  
if(@Category=9)      
begin      
set @Sql = @Sql + ' and b.Child_2_3=1'      
end  
if(@Category=10)      
begin      
set @Sql = @Sql + ' and b.Child_3_4=1'      
end  
if(@Category=11)      
begin      
set @Sql = @Sql + ' and b.Child_4_5=1'      
end  
if(@Category=16)      
begin      
set @Sql = @Sql + ' and b.Entry_Type_Death=1'      
end  
if(@Category=45)      
begin      
set @Sql = @Sql + ' and b.Mother_RegistrationNo_Absent=1'      
end  
if(@Category=1 or @Category=2 or @Category=3  or @Category=4 or @Category=5 or @Category=6 or @Category=13 or @Category=14 or @Category=15 or @Category=17 or @Category=18 or @Category=19)      
begin      
set @Sql = @Sql + ' and Child_0_1=1'      
end   
if(@Category=4 or @Category=5 )      
begin      
set @Sql = @Sql + ' and Mobile_no_Present=1'      
end  
if(@Category=5 )      
begin      
set @Sql = @Sql + ' and ((b.Whose_mobile_Father)=1 or (b.Whose_mobile_Mother)=1)'      
end  
if(@Category=12)      
begin      
set @Sql = @Sql + ' and DATEDIFF(DAY,Child_Birthdate_Date,Child_Registration_Date)<=30'      
end     
if(@Category=13 or @Category=15 or @Category=17)      
begin      
set @Sql = @Sql + ' and Child_With_LOWWEIGHT=1'      
end   
if(@Category=13 or @Category=14)      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_Y=1'      
end  
if(@Category=17 or @Category=18)      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_N=1'      
end      
if(@Category=17 or  @Category=18 or  @Category=19)      
begin      
set @Sql = @Sql + ' and Convert(date,Birthdate_plus11mon) <= Convert(date,GETDATE()-1) '      
end                              
end                            
else if(@Report_Module=30) --Dashboard                            
begin                     
IF(@Category =1)    -- add by pankaj on 02-12-19                  
begin                  
set @Sql= 'select Row_number() over(order by a.registration_no) as Sno,              
Convert(varchar(12),a.Registration_no)as RCHID,                                        
a.Name_Child as ChildName,a.Name_Father as FatherName,              
a.Name_Mother + (case when(a.Mother_Reg_no = '''' OR a.Mother_Reg_no IS NULL) then''(''+''Not Available''+'')'' else ''(''+Convert(varchar,a.Mother_Reg_no)+'')''end )as MotherName,                
a.Mobile_no as MobileNo                            
,Convert(Varchar(10),a.Birth_Date,103) as DOB                                        
,a.[Address]                                                   
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate                                            
,a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,                            
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                                        
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,                            
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,                            
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles                                  
,Convert(Varchar(10),a.IPV_Dose1_Dt ,103) as IPV1                    
,Convert(Varchar(10),a.IPV_Dose2_Dt ,103) as IPV2                  
,Convert(Varchar(10),a.PCV_Dose1_Dt ,103) as PCV1                  
,Convert(Varchar(10),a.PCV_Dose2_Dt ,103) as PCV2                  
,Convert(Varchar(10),a.PCV_DoseB_Dt ,103) as PCVB                  
,Convert(Varchar(10),a.MR1_Dt,103) as MR1                  
,Convert(Varchar(10),a.Rota_Virus_Dt,103) as Rota1                  
,Convert(Varchar(10),a.Rota_Dose2_Dt,103) as Rota2                  
,Convert(Varchar(10),a.Rota_Dose3_Dt,103) as Rota3                  
,Convert(Varchar(10),a.JE1_Dt,103) as JE1                   
,(case when Entry_type_death=1 then ''Yes'' else ''No'' end)  as  ChildDeath                                      
from t_child_flat a WITH (NOLOCK)                                       
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no                                        
where (CASE '+@Type+' WHEN  1 THEN b.ChildReg_Fin_Yr  when 2 then (Case when b.Child_Birthdate_Month> 3 then Child_Birthdate_Yr else Child_Birthdate_Yr-1 end) END)='+@FinancialYr+'                                  
and (CASE WHEN '+@Type+' = 1 and '+@Year_ID+'<>0 THEN b.Child_Registration_Yr WHEN '+@Type+' = 2 and '+@Year_ID+'<>0 THEN b.Child_Birthdate_Yr  ELSE  0 END)='+@Year_ID+'                              
and (CASE WHEN '+@Type+' = 1 and '+@Month_ID+'<>0 THEN b.Child_Registration_Month WHEN '+@Type+' = 2 and '+@Month_ID+'<>0 THEN b.Child_Birthdate_Month  ELSE  0 END)='+@Month_ID+'                                                                   
and (b.StateID='+@State_Code+')  
and (b.District_ID='+@District_Code+')                                          
and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)                                          
and (b.PHC_ID ='+@HealthFacility_Code+' or  '+@HealthFacility_Code+'=0)                                              
and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)                    
and (CASE WHEN '''+@Level+''' = ''Subcentre'' THEN b.Village_ID else 0 END)='+@Village_Code+''  
if(@Category=2)      
begin      
set @Sql = @Sql + ' and b.Child_Aadhar_No_Present=1'      
end  
if(@Category=3)      
begin      
set @Sql = @Sql + ' and b.Address_Present=1'      
end  
if(@Category=6)      
begin      
set @Sql = @Sql + ' and Child_EID_Present=1'      
end  
if(@Category=7)      
begin      
set @Sql = @Sql + ' and Child_1_2=1'      
end  
if(@Category=9)      
begin      
set @Sql = @Sql + ' and Child_2_3=1'      
end  
if(@Category=10)      
begin      
set @Sql = @Sql + ' and Child_3_4=1'      
end  
if(@Category=11)      
begin      
set @Sql = @Sql + ' and Child_4_5=1'      
end  
if(@Category=20)      
begin      
set @Sql = @Sql + ' and BCG_Dt_Present=1'      
end  
if(@Category=21)      
begin      
set @Sql = @Sql + ' and OPV0_Dt_Present=1'      
end  
if(@Category=22)      
begin      
set @Sql = @Sql + ' and HepatitisB0_Dt_Present=1'    
end  
if(@Category=23)      
begin      
set @Sql = @Sql + ' and OPV1_Dt_Present=1'      
end  
if(@Category=24)      
begin      
set @Sql = @Sql + ' and HepatitisB1_Dt_Present=1'      
end  
if(@Category=25)      
begin      
set @Sql = @Sql + ' and DPT1_Dt_Present=1'      
end  
if(@Category=26)      
begin      
set @Sql = @Sql + ' and Penta1_Dt_Present=1'      
end  
if(@Category=27)      
begin      
set @Sql = @Sql + ' and OPV2_Dt_Present=1'    
end  
  
if(@Category=28)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=29)      
begin      
set @Sql = @Sql + ' and DPT2_Dt_Present=1'      
end  
if(@Category=30)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'      
end  
if(@Category=31)      
begin      
set @Sql = @Sql + ' and OPV3_Dt_Present=1'      
end  
if(@Category=32)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'    
end  
if(@Category=33)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=34)      
begin      
set @Sql = @Sql + ' and DPT3_Dt_Present=1'      
end  
if(@Category=35)      
begin      
set @Sql = @Sql + ' and Penta3_Dt_Present=1'      
end  
if(@Category=36)      
begin      
set @Sql = @Sql + ' and Measles1_Present=1'    
end  
if(@Category=37)      
begin      
set @Sql = @Sql + ' and Measles2_Present=1'    
end  
if(@Category=38)      
begin      
set @Sql = @Sql + ' and JE1_Dt_Present=1'      
end  
if(@Category=39)      
begin      
set @Sql = @Sql + ' and JE2_Dt_Present=1'      
end  
if(@Category=40)      
begin      
set @Sql = @Sql + ' and VitA_Dose1_Dt_Present=1'      
end  
if(@Category=41)      
begin      
set @Sql = @Sql + ' and Child_Received_Y=1'    
end  
if(@Category=1 or @Category=2 or @Category=3  or @Category=4 or @Category=5 or @Category=6 or @Category=13 or @Category=14 or @Category=15 or @Category=17 or @Category=18 or @Category=19 or @Category=43)      
begin      
set @Sql = @Sql + ' and Child_0_1=1'    
end  
if(@Category=4 or @Category=5)      
begin      
set @Sql = @Sql + ' and Mobile_no_Present=1'    
end  
if(@Category=5)      
begin      
set @Sql = @Sql + ' and ((b.Whose_mobile_Father)=1 or (b.Whose_mobile_Mother)=1)'     
end  
if(@Category=12)      
begin      
set @Sql = @Sql + ' and DATEDIFF(DAY,Child_Birthdate_Date,Child_Registration_Date)<=30'      
end     
if(@Category=13 or @Category=15 or @Category=17)      
begin      
set @Sql = @Sql + ' and Child_With_LOWWEIGHT=1'      
end    
if(@Category=14)      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_Y=1'      
end     
if(@Category=17 or @Category=18 )      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_N=1'      
end     
if(@Category=17 or  @Category=18 or  @Category=19)      
begin      
set @Sql = @Sql + ' and Convert(date,Birthdate_plus11mon) <= Convert(date,GETDATE()-1) '      
end     
if(@Category=42)      
begin      
set @Sql = @Sql + ' and ((Child_BreastFeed_19_Y)=1 or (Child_BreastFeed_10_Y)=1)'   
end  
if(@Category=16 OR @Category=43)    
begin      
set @Sql = @Sql + ' and Entry_Type_Death=1'      
end    
if(@Category=44)    
begin      
set @Sql = @Sql + ' and cast(Child_0_1 as int)+cast(Child_1_2 as int)+cast(Child_2_3 as int)+cast(Child_3_4 as int)+cast(Child_4_5 as int)=1'      
end                  
end                  
else if(@Category =7)   -- add by pankaj on 02-12-19                  
begin                  
set @Sql= 'select Row_number() over(order by a.registration_no) as Sno,Convert(varchar(12),a.Registration_no)as RCHID,                                        
a.Name_Child as ChildName,a.Name_Father as FatherName,                
a.Name_Mother + (case when(a.Mother_Reg_no = '''' OR a.Mother_Reg_no IS NULL) then''(''+''Not Available''+'')'' else ''(''+Convert(varchar,a.Mother_Reg_no)+'')''end )as MotherName,                
a.Mobile_no as MobileNo                            
,Convert(Varchar(10),a.Birth_Date,103) as DOB                                        
,a.[Address]                                                    
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate                                            
,a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,                            
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                                        
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,                            
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,                            
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles                                 
,Convert(Varchar(10),a.Measles2_Dt,103) as Measles2  -- ADD 5 immu.                   
,Convert(Varchar(10),a.MR_Dt,103) as MR2                  
,Convert(Varchar(10),a.DPTBooster1_Dt,103) as DPTB                   
,Convert(Varchar(10),a.JE2_Dt,103) as JE2                   
,Convert(Varchar(10),a.OPVBooster_Dt,103) as OPVB                   
,(case when Entry_type_death=1 then ''Yes'' else ''No'' end)  as  ChildDeath                                        
from t_child_flat a WITH (NOLOCK)                                       
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no                                        
where (CASE '+@Type+' WHEN  1 THEN b.ChildReg_Fin_Yr  when 2 then (Case when b.Child_Birthdate_Month> 3 then Child_Birthdate_Yr else Child_Birthdate_Yr-1 end) END)='+@FinancialYr+'                                  
and (CASE WHEN '+@Type+' = 1 and '+@Year_ID+'<>0 THEN b.Child_Registration_Yr WHEN '+@Type+' = 2 and '+@Year_ID+'<>0 THEN b.Child_Birthdate_Yr  ELSE  0 END)='+@Year_ID+'                              
and (CASE WHEN '+@Type+' = 1 and '+@Month_ID+'<>0 THEN b.Child_Registration_Month WHEN '+@Type+' = 2 and '+@Month_ID+'<>0 THEN b.Child_Birthdate_Month  ELSE  0 END)='+@Month_ID+'                                                                   
and (b.StateID='+@State_Code+')  
and (b.District_ID='+@District_Code+')                                          
and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)                                          
and (b.PHC_ID ='+@HealthFacility_Code+' or  '+@HealthFacility_Code+'=0)                                              
and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)                    
and (CASE WHEN '''+@Level+''' = ''Subcentre'' THEN b.Village_ID else 0 END)='+@Village_Code+''  
if(@Category=2)      
begin      
set @Sql = @Sql + ' and b.Child_Aadhar_No_Present=1'      
end  
if(@Category=3)      
begin      
set @Sql = @Sql + ' and b.Address_Present=1'      
end  
if(@Category=6)      
begin      
set @Sql = @Sql + ' and Child_EID_Present=1'      
end  
if(@Category=7)      
begin      
set @Sql = @Sql + ' and Child_1_2=1'      
end  
if(@Category=9)      
begin      
set @Sql = @Sql + ' and Child_2_3=1'      
end  
if(@Category=10)      
begin      
set @Sql = @Sql + ' and Child_3_4=1'      
end  
if(@Category=11)      
begin      
set @Sql = @Sql + ' and Child_4_5=1'      
end  
if(@Category=20)      
begin      
set @Sql = @Sql + ' and BCG_Dt_Present=1'      
end  
if(@Category=21)      
begin      
set @Sql = @Sql + ' and OPV0_Dt_Present=1'      
end  
if(@Category=22)      
begin      
set @Sql = @Sql + ' and HepatitisB0_Dt_Present=1'    
end  
if(@Category=23)      
begin      
set @Sql = @Sql + ' and OPV1_Dt_Present=1'      
end  
if(@Category=24)      
begin      
set @Sql = @Sql + ' and HepatitisB1_Dt_Present=1'      
end  
if(@Category=25)      
begin      
set @Sql = @Sql + ' and DPT1_Dt_Present=1'      
end  
if(@Category=26)      
begin      
set @Sql = @Sql + ' and Penta1_Dt_Present=1'      
end  
if(@Category=27)      
begin      
set @Sql = @Sql + ' and OPV2_Dt_Present=1'    
end  
  
if(@Category=28)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=29)      
begin      
set @Sql = @Sql + ' and DPT2_Dt_Present=1'      
end  
if(@Category=30)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'      
end  
if(@Category=31)      
begin      
set @Sql = @Sql + ' and OPV3_Dt_Present=1'      
end  
if(@Category=32)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'    
end  
if(@Category=33)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=34)      
begin      
set @Sql = @Sql + ' and DPT3_Dt_Present=1'      
end  
if(@Category=35)      
begin      
set @Sql = @Sql + ' and Penta3_Dt_Present=1'      
end  
if(@Category=36)      
begin      
set @Sql = @Sql + ' and Measles1_Present=1'    
end  
if(@Category=37)      
begin      
set @Sql = @Sql + ' and Measles2_Present=1'    
end  
if(@Category=38)      
begin      
set @Sql = @Sql + ' and JE1_Dt_Present=1'      
end  
if(@Category=39)      
begin      
set @Sql = @Sql + ' and JE2_Dt_Present=1'      
end  
if(@Category=40)      
begin      
set @Sql = @Sql + ' and VitA_Dose1_Dt_Present=1'      
end  
if(@Category=41)      
begin      
set @Sql = @Sql + ' and Child_Received_Y=1'    
end  
if(@Category=1 or @Category=2 or @Category=3  or @Category=4 or @Category=5 or @Category=6 or @Category=13 or @Category=14 or @Category=15 or @Category=17 or @Category=18 or @Category=19 or @Category=43)      
begin      
set @Sql = @Sql + ' and Child_0_1=1'    
end  
if(@Category=4 or @Category=5)      
begin      
set @Sql = @Sql + ' and Mobile_no_Present=1'    
end  
if(@Category=5)      
begin      
set @Sql = @Sql + ' and ((b.Whose_mobile_Father)=1 or (b.Whose_mobile_Mother)=1)'     
end  
if(@Category=12)      
begin      
set @Sql = @Sql + ' and DATEDIFF(DAY,Child_Birthdate_Date,Child_Registration_Date)<=30'      
end     
if(@Category=13 or @Category=15 or @Category=17)      
begin      
set @Sql = @Sql + ' and Child_With_LOWWEIGHT=1'      
end    
if(@Category=14)      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_Y=1'      
end     
if(@Category=17 or @Category=18 )      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_N=1'      
end     
if(@Category=17 or  @Category=18 or  @Category=19)      
begin      
set @Sql = @Sql + ' and Convert(date,Birthdate_plus11mon) <= Convert(date,GETDATE()-1) '      
end     
if(@Category=42)      
begin      
set @Sql = @Sql + ' and ((Child_BreastFeed_19_Y)=1 or (Child_BreastFeed_10_Y)=1)'   
end  
if(@Category=16 OR @Category=43)    
begin      
set @Sql = @Sql + ' and Entry_Type_Death=1'      
end    
if(@Category=44)    
begin      
set @Sql = @Sql + ' and cast(Child_0_1 as int)+cast(Child_1_2 as int)+cast(Child_2_3 as int)+cast(Child_3_4 as int)+cast(Child_4_5 as int)=1'      
end                              
end                  
else                  
begin                  
 set @Sql= 'select Row_number() over(order by a.registration_no) as Sno,              
isnull(d.DIST_NAME_ENG,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( d.DIST_CD,0) ) + '')'' as District,              
isnull(e.Block_Name_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( e.BLOCK_CD,0) ) + '')'' as [Health Block],              
isnull(f.PHC_NAME,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + '')'' as [Health Facility],                                
isnull(g.SUBPHC_NAME_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + '')'' as [Health SubFacility] ,              
isnull(h.VILLAGE_NAME,''--'') as [Village],              
Convert(varchar(12),a.Registration_no)as RCHID,                                        
a.Name_Child as ChildName,a.Name_Father as FatherName,              
a.Name_Mother + (case when(a.Mother_Reg_no = '''' OR a.Mother_Reg_no IS NULL) then''(''+''Not Available''+'')'' else ''(''+Convert(varchar,a.Mother_Reg_no)+'')''end )as MotherName,                
a.Mobile_no as MobileNo                            
,Convert(Varchar(10),a.Birth_Date,103) as DOB                                        
,a.[Address]                                        
,ISNULL(c.Name,'''')+''(ID-''+CONVERT(VARCHAR(150),ISNULL(c.ID,0)) + '')'' + ''(MobNo.-'' + ISNULL(c.Contact_No,0)+ '')'' as ANM_Name                
,ISNULL(c1.Name,'''')+''(ID-''+CONVERT(VARCHAR(150),ISNULL(c1.ID,0)) + '')'' + ''(MobNo.-'' + ISNULL(c1.Contact_No,0)+ '')'' as ASHA_Name                          
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate                                          
,a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,                            
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                                        
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,                            
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,                            
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,Convert(Varchar(10),a.Measles1_Dt ,103) as Measles,                             
Convert(Varchar(10),a.IPV_Dose1_Dt ,103) as IPV1                    
,Convert(Varchar(10),a.IPV_Dose2_Dt ,103) as IPV2                  
,Convert(Varchar(10),a.PCV_Dose1_Dt ,103) as PCV1                  
,Convert(Varchar(10),a.PCV_Dose2_Dt ,103) as PCV2                  
,Convert(Varchar(10),a.PCV_DoseB_Dt ,103) as PCVB                  
,Convert(Varchar(10),a.MR1_Dt,103) as MR1                  
,Convert(Varchar(10),a.Rota_Virus_Dt,103) as Rota1                  
,Convert(Varchar(10),a.Rota_Dose2_Dt,103) as Rota2                  
,Convert(Varchar(10),a.Rota_Dose3_Dt,103) as Rota3                  
,Convert(Varchar(10),a.JE1_Dt,103) as JE1                                  
,Convert(Varchar(10),a.Measles2_Dt,103) as Measles2                    
,Convert(Varchar(10),a.MR_Dt,103) as MR2                  
,Convert(Varchar(10),a.DPTBooster1_Dt,103) as DPTB                   
,Convert(Varchar(10),a.JE2_Dt,103) as JE2                   
,Convert(Varchar(10),a.OPVBooster_Dt,103) as OPVB                   
                  
,(case when Entry_type_death=1 then ''Yes'' else ''No'' end)  as  ChildDeath ,        
(Case when DeathDate is not null then Convert(Varchar(10),DeathDate,103) else '''' end)as Death_Date,        
(Case when Death_Reason is not null then CD.Name else '''' end)as Death_Reason              
              
from t_child_flat a WITH (NOLOCK)                                       
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no  
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID                            
Left outer join t_Ground_Staff c1 WITH (NOLOCK) on a.ASHA_ID=c1.ID                       
left outer join TBL_DISTRICT d With (NOLOCK) on a.District_ID=d.DIST_CD                          
left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                          
left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                        
left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                          
left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD        
left outer join rch_national_level.dbo.m_ClosureDeath CD on CD.ID=a.Death_Reason                                            
where (CASE '+@Type+' WHEN  1 THEN b.ChildReg_Fin_Yr  when 2 then (Case when b.Child_Birthdate_Month> 3 then Child_Birthdate_Yr else Child_Birthdate_Yr-1 end) END)='+@FinancialYr+'                                  
and (CASE WHEN '+@Type+' = 1 and '+@Year_ID+'<>0 THEN b.Child_Registration_Yr WHEN '+@Type+' = 2 and '+@Year_ID+'<>0 THEN b.Child_Birthdate_Yr  ELSE  0 END)='+@Year_ID+'                              
and (CASE WHEN '+@Type+' = 1 and '+@Month_ID+'<>0 THEN b.Child_Registration_Month WHEN '+@Type+' = 2 and '+@Month_ID+'<>0 THEN b.Child_Birthdate_Month  ELSE  0 END)='+@Month_ID+'                                                                   
and (b.StateID='+@State_Code+')  
and (b.District_ID='+@District_Code+')                                          
and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)                                          
and (b.PHC_ID ='+@HealthFacility_Code+' or  '+@HealthFacility_Code+'=0)                                              
and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)                    
and (CASE WHEN '''+@Level+''' = ''Subcentre'' THEN b.Village_ID else 0 END)='+@Village_Code+''  
if(@Category=2)      
begin      
set @Sql = @Sql + ' and b.Child_Aadhar_No_Present=1'      
end  
if(@Category=3)      
begin      
set @Sql = @Sql + ' and b.Address_Present=1'      
end  
if(@Category=6)      
begin      
set @Sql = @Sql + ' and Child_EID_Present=1'      
end  
if(@Category=7)      
begin      
set @Sql = @Sql + ' and Child_1_2=1'      
end  
if(@Category=9)      
begin      
set @Sql = @Sql + ' and Child_2_3=1'      
end  
if(@Category=10)      
begin      
set @Sql = @Sql + ' and Child_3_4=1'      
end  
if(@Category=11)      
begin      
set @Sql = @Sql + ' and Child_4_5=1'      
end  
if(@Category=20)      
begin      
set @Sql = @Sql + ' and BCG_Dt_Present=1'      
end  
if(@Category=21)      
begin      
set @Sql = @Sql + ' and OPV0_Dt_Present=1'      
end  
if(@Category=22)      
begin      
set @Sql = @Sql + ' and HepatitisB0_Dt_Present=1'    
end  
if(@Category=23)      
begin      
set @Sql = @Sql + ' and OPV1_Dt_Present=1'      
end  
if(@Category=24)      
begin      
set @Sql = @Sql + ' and HepatitisB1_Dt_Present=1'      
end  
if(@Category=25)      
begin      
set @Sql = @Sql + ' and DPT1_Dt_Present=1'      
end  
if(@Category=26)      
begin      
set @Sql = @Sql + ' and Penta1_Dt_Present=1'      
end  
if(@Category=27)      
begin      
set @Sql = @Sql + ' and OPV2_Dt_Present=1'    
end  
  
if(@Category=28)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=29)      
begin      
set @Sql = @Sql + ' and DPT2_Dt_Present=1'      
end  
if(@Category=30)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'      
end  
if(@Category=31)      
begin      
set @Sql = @Sql + ' and OPV3_Dt_Present=1'      
end  
if(@Category=32)      
begin      
set @Sql = @Sql + ' and Penta2_Dt_Present=1'    
end  
if(@Category=33)      
begin      
set @Sql = @Sql + ' and HepatitisB2_Dt_Present=1'      
end  
if(@Category=34)      
begin      
set @Sql = @Sql + ' and DPT3_Dt_Present=1'      
end  
if(@Category=35)      
begin      
set @Sql = @Sql + ' and Penta3_Dt_Present=1'      
end  
if(@Category=36)      
begin      
set @Sql = @Sql + ' and Measles1_Present=1'    
end  
if(@Category=37)      
begin      
set @Sql = @Sql + ' and Measles2_Present=1'    
end  
if(@Category=38)      
begin      
set @Sql = @Sql + ' and JE1_Dt_Present=1'      
end  
if(@Category=39)      
begin      
set @Sql = @Sql + ' and JE2_Dt_Present=1'      
end  
if(@Category=40)      
begin      
set @Sql = @Sql + ' and VitA_Dose1_Dt_Present=1'      
end  
if(@Category=41)      
begin      
set @Sql = @Sql + ' and Child_Received_Y=1'    
end  
if(@Category=1 or @Category=2 or @Category=3  or @Category=4 or @Category=5 or @Category=6 or @Category=13 or @Category=14 or @Category=15 or @Category=17 or @Category=18 or @Category=19 or @Category=43)      
begin      
set @Sql = @Sql + ' and Child_0_1=1'    
end  
if(@Category=4 or @Category=5)      
begin      
set @Sql = @Sql + ' and Mobile_no_Present=1'    
end  
if(@Category=5)      
begin      
set @Sql = @Sql + ' and ((b.Whose_mobile_Father)=1 or (b.Whose_mobile_Mother)=1)'     
end  
if(@Category=12)      
begin      
set @Sql = @Sql + ' and DATEDIFF(DAY,Child_Birthdate_Date,Child_Registration_Date)<=30'      
end     
if(@Category=13 or @Category=15 or @Category=17)      
begin      
set @Sql = @Sql + ' and Child_With_LOWWEIGHT=1'      
end    
if(@Category=14)      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_Y=1'      
end     
if(@Category=17 or @Category=18 )      
begin      
set @Sql = @Sql + ' and Child_FullyImmunised_N=1'      
end     
if(@Category=17 or  @Category=18 or  @Category=19)      
begin      
set @Sql = @Sql + ' and Convert(date,Birthdate_plus11mon) <= Convert(date,GETDATE()-1) '      
end     
if(@Category=42)      
begin      
set @Sql = @Sql + ' and ((Child_BreastFeed_19_Y)=1 or (Child_BreastFeed_10_Y)=1)'   
end  
if(@Category=16 OR @Category=43)    
begin      
set @Sql = @Sql + ' and Entry_Type_Death=1'      
end    
if(@Category=44)    
begin      
set @Sql = @Sql + ' and cast(Child_0_1 as int)+cast(Child_1_2 as int)+cast(Child_2_3 as int)+cast(Child_3_4 as int)+cast(Child_4_5 as int)=1'      
end                            
end                            
End                            
EXEC(@Sql)                         
end                   
    
