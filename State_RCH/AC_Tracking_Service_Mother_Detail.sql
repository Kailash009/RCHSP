USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Tracking_Service_Mother_Detail]    Script Date: 09/26/2024 11:55:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  
[AC_Tracking_Service_Mother] 0,0,0,0,0,0,2015,0,0,'','','National'      
  
[AC_Tracking_Service_Mother] 4,0,0,0,0,0,2016,0,0,'','','State',3      
  
[AC_Tracking_Service_Mother_detail] 27,1,144,0,0,0,2021,0,0,'','','2',1       
  
[AC_Tracking_Service_Mother] 27,1,1,0,0,0,2016,0,2016,'','','Block',3      
  
[AC_Tracking_Service_Mother] 27,1,1,2,0,0,2016,0,2016,'','','PHC',3        
  
*/   
ALTER procedure [dbo].[AC_Tracking_Service_Mother_Detail]      
  
(      
  
@State_Code varchar(2)=0,        
  
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
  
@Category varchar(20) ='',    
  
@Type varchar(1)=0    
  
)      
  
as      
  
begin          

Declare @Sql Varchar(Max)    
Declare @Sql1 nVarchar(Max)   
SET NOCOUNT ON  
  
set @Sql= ' Select Row_number() over(order by a.registration_no) as Sno,  
isnull(i.DIST_NAME_ENG,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( i.DIST_CD,0) ) + '')'' as District,  
isnull(e.Block_Name_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( e.BLOCK_CD,0) ) + '')'' as [HealthBlock],  
isnull(f.PHC_NAME,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( f.PHC_CD,0) ) + '')''as [HealthFacility],                    
isnull(g.SUBPHC_NAME_E,''--'') + ''('' + CONVERT(VARCHAR(150),ISNULL( g.SUBPHC_CD,0) ) + '')'' as [HealthSubFacility] ,  
isnull(h.VILLAGE_NAME,''--'') as [Village],  
Convert(varchar(12),a.Registration_no)as RCHID,a.Case_no as CaseNo,a.Name_wife as MotherName,a.Name_husband as HusbandName                            
  
 ,a.Whose_mobile as [Mobileof],a.Mobile_no as MobileNo,a.Mother_Age as MotherAge    
 ,ISNULL( c.Name,'''') + ''('' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + '')'' as ANM_Name    
 ,ISNULL( d.Name,'''') + ''('' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + '')'' as ASHA_Name    
  
     
  
 ,a.PW_Bank_Name as BankName,a.[Address]                            
  
 ,Convert(varchar(10),a.Mother_Registration_Date,103) as RegistrationDate,Convert(varchar(10),a.Medical_LMP_Date,103) as LMP,Convert(varchar(10),a.Medical_EDD_Date,103) as EDD                            
  
 ,Convert(varchar(10),a.ANC1,103) ANC1,Convert(varchar(10),a.ANC2,103) as ANC2,Convert(varchar(10),a.ANC3,103) as ANC3,Convert(varchar(10),a.ANC4,103) as ANC4                            
  
 ,Convert(varchar(10),A.TT1,103) as TT1,Convert(varchar(10),a.TT2,103) as TT2,Convert(varchar(10),a.TTB,103) as TTB,  
   
    
(Case When(ISNULL(ANC1_IFA_Given,0)+ ISNULL(ANC2_IFA_Given,0)+ISNULL(ANC3_IFA_Given,0)+ISNULL(ANC4_IFA_Given,0)) >400 then 400 
else ISNULL(ANC1_IFA_Given,0)+ ISNULL(ANC2_IFA_Given,0)+ISNULL(ANC3_IFA_Given,0)+ISNULL(ANC4_IFA_Given,0) end) as ANC_IFA,  
  
(Case When(ISNULL(PNC1_IFA_Tab,0)+ISNULL(PNC2_IFA_Tab,0)+ISNULL(PNC3_IFA_Tab,0)+ISNULL(PNC4_IFA_Tab,0)+ISNULL(PNC5_IFA_Tab,0)+ISNULL(PNC6_IFA_Tab,0)+
ISNULL(PNC7_IFA_Tab,0)) >400 then 400 
else ISNULL(PNC1_IFA_Tab,0)+ISNULL(PNC2_IFA_Tab,0)+ISNULL(PNC3_IFA_Tab,0)+ISNULL(PNC4_IFA_Tab,0)+ISNULL(PNC5_IFA_Tab,0)+ISNULL(PNC6_IFA_Tab,0)+
ISNULL(PNC7_IFA_Tab,0) end) as PNC_IFA ,                        
  
(Case When(ISNULL(ANC1_IFA_Given,0)+ ISNULL(ANC2_IFA_Given,0)+ISNULL(ANC3_IFA_Given,0)+ISNULL(ANC4_IFA_Given,0)) > 400 then 400 
else ISNULL(ANC1_IFA_Given,0)+ ISNULL(ANC2_IFA_Given,0)+ISNULL(ANC3_IFA_Given,0)+ISNULL(ANC4_IFA_Given,0) end) + (Case When (ISNULL(PNC1_IFA_Tab,0)+
ISNULL(PNC2_IFA_Tab,0)+ISNULL(PNC3_IFA_Tab,0)+ ISNULL(PNC4_IFA_Tab,0)+ISNULL(PNC5_IFA_Tab,0)+ISNULL(PNC6_IFA_Tab,0)+ISNULL(PNC7_IFA_Tab,0)) >400 then 400
else ISNULL(PNC1_IFA_Tab,0)+
ISNULL(PNC2_IFA_Tab,0)+ISNULL(PNC3_IFA_Tab,0)+ ISNULL(PNC4_IFA_Tab,0)+ISNULL(PNC5_IFA_Tab,0)+ISNULL(PNC6_IFA_Tab,0)+ISNULL(PNC7_IFA_Tab,0)end)
as IFA  
  
 ,Convert(varchar(10),a.Delivery_date,103) as Delivery,Convert(varchar(10),a.PNC1_Date,103) as PNC1,Convert(varchar(10),a.PNC2_Date,103) as PNC2,Convert(varchar(10),a.PNC3_Date,103) as PNC3                            
  
 ,Convert(varchar(10),a.PNC4_Date,103) as PNC4,Convert(varchar(10),a.PNC5_Date,103) as PNC5,Convert(varchar(10),a.PNC6_Date,103) as PNC6,Convert(varchar(10),a.PNC7_Date,103)  as PNC7                            
  
 ,a.ANC1_Symptoms_High_Risk as HighRisk1stVisit,a.ANC2_Symptoms_High_Risk as HighRisk2ndVisit,a.ANC3_Symptoms_High_Risk as HighRisk3rdVisit                            
  
 ,a.ANC4_Symptoms_High_Risk as HighRisk4thVisit                            
  
 ,a.ANC1_Hb_gm as  HBLevel1stVisit,a.ANC2_Hb_gm as HBLevel2ndVisit,a.ANC3_Hb_gm as HBLevel3rdVisit,a.ANC4_Hb_gm as HBLevel4thVisit,(case when Entry_type_death=1 then ''Yes'' else ''No'' end) as MaternalDeath,Abortion_Present ,

(Case When b.Maternal_Death_Present=1 then Convert(varchar(10),a.Death_Date,103)  
When b.Delivery_Complication_Death=1 then Convert(varchar(10),a.Delivery_Date,103)  
When b.PNC_Death=1 then Convert(varchar(10),a.Mother_Death_Date,103) else '''' end )as [Death_Date],
(Case When b.Maternal_Death_Present=1 then MD.Name
When b.Delivery_Complication_Death=1 then A.Delivery_Death_Cause  
When b.PNC_Death=1 then A.Mother_Death_Reason else '''' end)as [Death_Reason]
   
  
  
 from t_mother_flat a WITH (NOLOCK)                           
  
 inner join t_mother_flat_Count b WITH (NOLOCK) on a. Registration_no=b.Registration_no and a.Case_no=b.Case_no        
  
 Left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ANM_ID=c.ID        
  
 Left outer join t_Ground_Staff d WITH (NOLOCK) on a.Mother_ASHA_ID=d.ID    
   
 Left outer join TBL_DISTRICT i With (NOLOCK) on b.District_ID=i.DIST_CD                    
  
 Left outer join TBL_HEALTH_BLOCK e With (NOLOCK) on b.HealthBlock_ID=e.BLOCK_CD                    
  
 Left outer join TBL_PHC f With (NOLOCK) on b.PHC_ID=f.PHC_CD                    
  
 Left outer join TBL_SUBPHC g With (NOLOCK) on b.SubCentre_ID=g.SUBPHC_CD                    
  
 Left outer join TBL_VILLAGE h With (NOLOCK) on b.Village_ID=h.VILLAGE_CD and b.SubCentre_ID=h.SUBPHC_CD      
 
 left outer join RCH_National_Level.dbo.m_DeathReason MD WITH(NOLOCK) on a.Death_Reason=MD.ID

 where (Case when LMP_month <=3 then LMP_Year-1 else LMP_Year end)='+@FinancialYr +'       
  
 and  (b.LMP_Year ='+@Year_ID+' or '+@Year_ID+'=0)         
  
 and (b.LMP_month ='+@Month_ID+' or '+@Month_ID+'=0)             
  
 and (b.StateID='+@State_Code+' or '+@State_Code+'=0)    
  
 and (b.District_ID='+@District_Code+' or '+@District_Code+'=0)    
  
 and (b.HealthBlock_ID='+@HealthBlock_Code+' or '+@HealthBlock_Code+'=0)    
  
 and (b.PHC_ID ='+@HealthFacility_Code+' or '+@HealthFacility_Code+'=0)         
  
 and (b.SubCentre_ID='+@HealthSubFacility_Code+' or '+@HealthSubFacility_Code+'=0)     
  
 and (b.Village_ID='+@Village_Code+' or '+@Village_Code+'=0)     '

 if(@Category=2)    
begin 
set @Sql = @Sql + ' and b.PW_Aadhar_No_Present=1'    
end  
 if(@Category=3)    
begin 
set @Sql = @Sql + ' and Address_Present=1'    
end 
 if(@Category=4)    
begin 
set @Sql = @Sql + ' and PW_Bank_Name_Present=1'    
end 
 if(@Category=5)    
begin 
set @Sql = @Sql + ' and Mobile_no_Present=1'    
end 
 if(@Category=6)    
begin 
set @Sql = @Sql + ' and Mobile_no_Present=1 and (b.Whose_mobile_Husband=1 or b.Whose_mobile_Wife=1)'    
end 
 if(@Category=8)    
begin 
set @Sql = @Sql + ' and High_risk_Severe=1'    
end 
 if(@Category=9)    
begin 
set @Sql = @Sql + ' and Severe_Anemic_Case=1'    
end 
 if(@Category=11)    
begin 
set @Sql = @Sql + ' and Delivery_Date_Present=1'    
end 
 if(@Category=12)    
begin 
set @Sql = @Sql + ' and High_risk_Severe=1'    
end 
if(@Category=13)    
begin 
set @Sql = @Sql + ' and High_risk_Severe=1'    
end 
 if(@Category=14)    
begin 
set @Sql = @Sql + ' and Severe_Anemic_Case=1'    
end 
 if(@Category=15)    
begin 
set @Sql = @Sql + ' and Severe_Anemic_Case=1'    
end 
 if(@Category=21)    
begin 
set @Sql = @Sql + ' and Entry_Type_Death=1'    
end
 if(@Category=22)    
begin 
set @Sql = @Sql + ' and Delivery_42_Completed=1'    
end
 if(@Category=23)    
begin 
set @Sql = @Sql + ' and ANC1_Present=1'    
end
 if(@Category=24)    
begin 
set @Sql = @Sql + ' and ANC2_Present=1'    
end
 if(@Category=25)    
begin 
set @Sql = @Sql + ' and ANC3_Present=1'    
end
 if(@Category=26)    
begin 
set @Sql = @Sql + ' and ANC4_Present=1'    
end
 if(@Category=31)    
begin 
set @Sql = @Sql + ' and TTB_Present=1'    
end
 if(@Category=32)    
begin 
set @Sql = @Sql + ' and TT1_Present=1'    
end
 if(@Category=33)    
begin 
set @Sql = @Sql + ' and TT2_Present=1'    
end
 if(@Category=36)    
begin 
set @Sql = @Sql + ' and PNC1_Type_Present=1'    
end
 if(@Category=37)    
begin 
set @Sql = @Sql + ' and PNC2_Type_Present=1'    
end
 if(@Category=38)    
begin 
set @Sql = @Sql + ' and PNC3_Type_Present=1'    
end
 if(@Category=39)    
begin 
set @Sql = @Sql + ' and PNC4_Type_Present=1'    
end
 if(@Category=40)    
begin 
set @Sql = @Sql + ' and PNC5_Type_Present=1'    
end
 if(@Category=41)    
begin 
set @Sql = @Sql + ' and PNC6_Type_Present=1'    
end
 if(@Category=42)    
begin 
set @Sql = @Sql + ' and PNC7_Type_Present=1'    
end  
 if(@Category=7)    
begin 
set @Sql = @Sql + ' and DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date)  between 1 and 3'    
end                
 if(@Category=13 or @Category=15 or @Category=17 or @Category=18 or @Category=19 or @Category=22)    
begin 
set @Sql = @Sql + ' and Delivery_Date_Present=1'    
end   
 if(@Category=16)    
begin 
set @Sql = @Sql + ' and Delivery_Date_Present=0'    
end 
 if(@Category=10)    
begin 
set @Sql = @Sql + ' and Abortion_Present=0'    
end 
 if(@Category=17)    
begin 
set @Sql = @Sql + ' and Delivery_42_Completed=0'    
end 
 if(@Category=35)    
begin 
set @Sql = @Sql + ' and LMP_Date is not null and a.StateID  is not null'    
end 
 if(@Category=27 OR @Category=29)    
begin 
set @Sql = @Sql + ' and convert(int,ANC1_Present)+convert(int,ANC2_Present)+convert(int,ANC3_Present)+convert(int,ANC4_Present)=4'    
end 
 if(@Category=28)    
begin 
set @Sql = @Sql + ' and convert(int,ANC1_Present)+convert(int,ANC2_Present)+convert(int,ANC3_Present)+convert(int,ANC4_Present)>=3'    
end 
 if(@Category=34)    
begin 
set @Sql = @Sql + ' and Maternal_Death=1'    
end 
 if(@Category=29)    
begin 
set @Sql = @Sql + ' and ((convert(int,TT1_Present)+convert(int,TT2_Present))=2 or (convert(int,TTB_Present)) =1)'    
end  
 if(@Category=29 OR @Category=30)    
begin 
set @Sql = @Sql + ' and convert(int,ISNULL(ANC1_IFA_Given,0))+convert(int,ISNULL(ANC2_IFA_Given,0))+convert(int,ISNULL(ANC3_IFA_Given,0))+convert(int,ISNULL(ANC4_IFA_Given,0))>=180'    
end  
 if(@Category=43)    
begin 
set @Sql = @Sql + ' and convert(int,PNC1_Type_Present)+convert(int,PNC2_Type_Present)+convert(int,PNC3_Type_Present)+convert(int,PNC4_Type_Present) +convert(int,PNC5_Type_Present)+convert(int,PNC6_Type_Present)+convert(int,PNC7_Type_Present)=7'    
end    
 if(@Category=44)    
begin 
set @Sql = @Sql + ' and convert(int,PNC1_Type_Present)+convert(int,PNC2_Type_Present)+convert(int,PNC3_Type_Present)+convert(int,PNC4_Type_Present) +convert(int,PNC5_Type_Present)+convert(int,PNC6_Type_Present)+convert(int,PNC7_Type_Present)>=4'    
end 
 if(@Category=45)    
begin 
set @Sql = @Sql + ' and convert(int,PNC1_Type_Present)+convert(int,PNC2_Type_Present)+convert(int,PNC3_Type_Present)+convert(int,PNC4_Type_Present) +convert(int,PNC5_Type_Present)+convert(int,PNC6_Type_Present)+convert(int,PNC7_Type_Present)=0 and (convert(int,Delivery_P) + convert(int,Delivery_T))=1'    
end 

 if(@Category=46)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Place_PHC)+convert(int,Delivery_Place_CHC)+convert(int,Delivery_Place_DH)+convert(int,Delivery_Place_OPF)+convert(int,Delivery_Place_SDH)+convert(int,Delivery_Place_MCH)+convert(int,Delivery_Place_SC)+convert(int,Delivery_Place_UHC)>=1'    
end 

 if(@Category=47)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Place_APH)+convert(int,Delivery_Place_OPH)>=1'    
end 
 if(@Category=48)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Conducted_By_ANM)+convert(int,Delivery_Conducted_By_LHV)+convert(int,Delivery_Conducted_By_Doctor)+convert(int,Delivery_Conducted_By_StaffNurse)+convert(int,Delivery_Conducted_By_SBA)+convert(int,Delivery_Place_Home)>=2'    
end 
 if(@Category=49)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Conducted_By_Relative)+convert(int,Delivery_Conducted_By_Other)+convert(int,Delivery_Conducted_By_NONSBA)+convert(int,Delivery_Place_Home)>=2'    
end 

 if(@Category=50)    
begin 
set @Sql = @Sql + ' and (convert(int,Delivery_Place_PHC)+convert(int,Delivery_Place_CHC)+convert(int,Delivery_Place_DH)+convert(int,Delivery_Place_OPF)+convert(int,Delivery_Place_SDH)+convert(int,Delivery_Place_MCH)+convert(int,Delivery_Place_SC)+convert(int,Delivery_Place_UHC))+ convert(int,Delivery_Type_Cesarian)>=2'    
end   
 if(@Category=51)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Place_OPH)+convert(int,Delivery_Type_Cesarian)=2'    
end 
 if(@Category=52)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Type_Cesarian)=1'    
end 

 if(@Category=53)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Date_Present)+convert(int,Abortion_Present)<=0'    
end 
 if(@Category=54)    
begin 
set @Sql = @Sql + ' and convert(int,Delivery_Place_Intransit)=1'    
end 
 
set @Sql = @Sql + '  and Abortion_Present=0  '       
  
if(@Type=1)  --All PW    
  
begin      

set @Sql = @Sql + '  '     
  
end          
  
else if(@Type=2)  --High Risk Severe    
  
begin      
  
   
  
set @Sql = @Sql + '  and High_risk_Severe=1    '
  
    
  
end      
  
      
  
else if(@Type=3)--Severe Anemic    
  
begin    
  
 set @Sql = @Sql + '  and Severe_Anemic_Case=1   ' 
  
end    
  EXEC(@Sql)
END    
