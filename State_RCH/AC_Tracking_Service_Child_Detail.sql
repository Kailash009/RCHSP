USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Tracking_Service_Child_Detail]    Script Date: 09/26/2024 11:54:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   
    
/*    
AC_Tracking_Service_Child_Detail 32,8,0,0,0,0,2021,0,0,'','',33    
    
*/      
      
ALTER procedure [dbo].[AC_Tracking_Service_Child_Detail]        
      
(        
@State_Code int=0,            
     
@District_Code varchar(2)=0,          
      
@HealthBlock_Code varchar(15)=0,          
      
@HealthFacility_Code varchar(15)=0,          
      
@HealthSubFacility_Code varchar(15)=0,        
      
@Village_Code varchar(16)=0,          
      
@FinancialYr varchar(4),         
      
@Month_ID varchar(4)=0 ,        
      
@Year_ID varchar(4)=0 ,        
      
@FromDate date='',          
      
@ToDate date='' ,        
      
@Category varchar(20) =''      
      
)        
      
as        
      
begin         
Declare @Sql Varchar(Max)      
Declare @Sql1 nVarchar(Max)     
SET NOCOUNT ON               
      
set @Sql= ' select Row_number() over(order by a.registration_no) as Sno,      
isnull(i.DIST_NAME_ENG,''--'') as District,isnull(e.Block_Name_E,''--'') as [HealthBlock],isnull(f.PHC_NAME,''--'') as [HealthFacility],                        
isnull(g.SUBPHC_NAME_E,''--'') as [HealthSubFacility] ,isnull(h.VILLAGE_NAME,''--'') as [Village],      
Convert(varchar(12),a.Registration_no)as RCHID,                  
      
a.Name_Child as ChildName,a.Name_Father as FatherName,a.Name_Mother as MotherName,a.Mobile_no as MobileNo      
      
,Convert(Varchar(10),a.Birth_Date,103) as DOB                  
      
,a.[Address]      
      
--,dbo.Get_Masked_UID(a.Child_Aadhaar_No) as AadhaarNo      
      
,Convert(Varchar(10),a.Registration_Date,103) as RegistrationDate      
      
,a.[Weight],Convert(Varchar(10),a.BCG_Dt,103) as BCG,Convert(Varchar(10),a.OPV0_Dt,103) as OPV0,      
      
Convert(Varchar(10),A.OPV1_Dt,103) as OPV1, Convert(Varchar(10),a.OPV2_Dt,103) as OPV2,Convert(Varchar(10),a.OPV3_Dt,103) as OPV3,Convert(Varchar(10),a.OPVBooster_Dt,103) as [OPVB],Convert(Varchar(10),a.DPT1_Dt,103) as DPT1,                  
      
Convert(Varchar(10),a.DPT2_Dt,103) as DPT2,Convert(Varchar(10),a.DPT3_Dt,103) as DPT3,Convert(Varchar(10),a.DPTBooster1_Dt,103) as [DPTB1],Convert(Varchar(10),a.DPTBooster2_Dt,103) as [DPTB2],Convert(Varchar(10),a.HepatitisB0_Dt,103) as HEP0,Convert(Varchar(10),a.HepatitisB1_Dt,103) as HEP1,      
      
Convert(Varchar(10),a.HepatitisB2_Dt,103) as HEP2,Convert(Varchar(10),a.HepatitisB3_Dt,103) as HEP3,Convert(Varchar(10),a.Rota_Virus_Dt,103) as ROTA1,Convert(Varchar(10),a.Rota_Dose2_Dt,103) as ROTA2,Convert(Varchar(10),a.Rota_Dose3_Dt,103) as ROTA3,Convert(Varchar(10),a.Penta1_Dt,103) as PENTA1,Convert(Varchar(10),a.Penta2_Dt,103) as PENTA2,      
      
Convert(Varchar(10),a.Penta3_Dt ,103)as PENTA3,CONVERT(varchar(10),a.MR1_Dt,103) as MR1,CONVERT(varchar(10),a.MR_dt,103) as MR2,CONVERT(varchar(10),a.PCV_Dose1_Dt,103) as PCV1,CONVERT(varchar(10),a.PCV_Dose2_Dt,103) as PCV2,      
      
CONVERT(varchar(10),a.PCV_DoseB_Dt,103) as [PCVB],Convert(Varchar(10),a.Measles1_Dt ,103) as Measles,Convert(Varchar(10),a.Measles2_Dt,103) as Measles2,      
      
Convert(Varchar(10),a.JE1_Dt,103) as JE1,Convert(Varchar(10),a.JE2_Dt,103) as JE2,Convert(Varchar(10),a.VitK_Dt,103) as VitK,Convert(Varchar(10),a.IPV_Dose1_Dt,103) as IPV1,Convert(Varchar(10),a.IPV_Dose2_Dt,103) as IPV2,      
      
(case when Entry_type_death=1 then ''Yes'' else ''No'' end)  as  ChildDeath      
      
,dbo.Deactivation_Service(0) as ImmuCode      
 ,ISNULL( c.Name,'''') + ''('' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + '')'' as ANM_Name        
 ,ISNULL( d.Name,'''') + ''('' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + '')'' as ASHA_Name    
 ,(Case when DeathDate is not null then Convert(Varchar(10),DeathDate,103) else '''' end)as Death_Date    
 ,(Case when Death_Reason is not null then CD.Name else '''' end)as Death_Reason        
                  
      
from t_child_flat a WITH (NOLOCK)                 
      
inner join t_child_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no        
Left outer join TBL_DISTRICT i With (NOLOCK) on a.District_ID=i.DIST_CD                        
Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on a.HealthBlock_ID=e.BLOCK_CD                        
Left outer join TBL_PHC f With (NOLOCK) on a.PHC_ID=f.PHC_CD                        
Left outer join TBL_SUBPHC g With (NOLOCK) on a.SubCentre_ID=g.SUBPHC_CD                        
Left outer join TBL_VILLAGE h With (NOLOCK) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD       
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ANM_ID=c.ID          
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.ASHA_ID=d.ID         
left outer join rch_national_level.dbo.m_ClosureDeath CD on CD.ID=a.Death_Reason    
      
where (Case when b.Child_Birthdate_Month> 3 then b.Child_Birthdate_Yr else b.Child_Birthdate_Yr-1 end)='+@FinancialYr +'     
      
and (b.Child_Birthdate_Month='+@Month_ID+' or '+@Month_ID+'=0)          
      
and (b.Child_Birthdate_Yr='+@Year_ID+' or '+@Year_ID+'=0)         
      
    
      
and (b.District_ID='+@District_Code+' or '+@District_Code+'=0)      
      
and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)      
      
and (b.PHC_ID ='+@HealthFacility_Code+' or '+@HealthFacility_Code+'=0)           
      
and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)       
      
and (b.Village_ID='+@Village_Code+' or '+@Village_Code+'=0)'    
    
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
set @Sql = @Sql + ' and HepatitisB3_Dt_Present=1'      
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
if(@Category=45)      
begin      
set @Sql = @Sql + ' and OPVBooster_Dt_Present=1'      
end     
if(@Category=46)      
begin      
set @Sql = @Sql + ' and DPTBooster1_Dt_Present=1'      
end     
if(@Category=47)    
begin      
set @Sql = @Sql + ' and DPTBooster2_Dt_Present=1'      
end     
if(@Category=48)    
begin      
set @Sql = @Sql + ' and MR_Dt_Present=1'      
end     
if(@Category=49)      
begin      
set @Sql = @Sql + ' and MR1_Present=1'      
end     
if(@Category=50)      
begin      
set @Sql = @Sql + ' and PCV_D1_Dt_Present=1'      
end     
if(@Category=51)      
begin      
set @Sql = @Sql + ' and PCV_D2_Dt_Present=1'      
end     
if(@Category=52)      
begin      
set @Sql = @Sql + ' and PCV_DB_Dt_Present=1'      
end     
if(@Category=53)      
begin      
set @Sql = @Sql + ' and Rota_D1_Dt_Present=1'      
end     
if(@Category=54)      
begin      
set @Sql = @Sql + ' and Rota_D2_Dt_Present=1'      
end     
if(@Category=55)      
begin      
set @Sql = @Sql + ' and Rota_D3_Dt_Present=1'      
end     
if(@Category=56)      
begin      
set @Sql = @Sql + ' and VitA_K_Dt_Present=1'      
end     
if(@Category=57)      
begin      
set @Sql = @Sql + ' and IPV_D1_Dt_Present=1'      
end     
if(@Category=58)      
begin      
set @Sql = @Sql + ' and IPV_D2_Dt_Present=1'      
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
if(@Category=44)    
begin      
set @Sql = @Sql + ' and Child_Birthdate_Date is not null '      
end    
  Exec(@Sql)     
      
--Select @SQL1 = CAST(@SQL as NVarchar(Max))          
--EXECUTE sp_executesql @SQL1            
End      
      