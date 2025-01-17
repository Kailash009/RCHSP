USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Mother_Count_Disrict_Wise]    Script Date: 09/26/2024 11:52:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*          
[AC_Mother_Count_Disrict_Wise] 29,12,0,0,0,0,2020,0,0,'','','District',1            
*/          
          
ALTER procedure [dbo].[AC_Mother_Count_Disrict_Wise]          
(          
@State_Code int=0,            
@District_Code int=0,            
@HealthBlock_Code int=0,            
@HealthFacility_Code int=0,            
@HealthSubFacility_Code int=0,          
@Village_Code int=0,          
@FinancialYr int,           
@Month_ID int=0 ,          
@Year_ID int=0 ,          
@FromDate date='',            
@ToDate date='' ,          
@Category varchar(20) ='District',          
@Type int =1          
)          
as          
begin                       
if(@Category='District')          
begin                  
select 
isnull(A.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.Dcode,0) ) + ')' as District,      
isnull(A.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.BID,0) ) + ')' as [Health_Block],      
isnull(A.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.PID,0) ) + ')' as [Health_Facility],  
isnull(A.HealthSubFacility_Name,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.HealthSubFacility_Code,0) ) + ')' as [Health_SubFacility] ,      
A.Village_Name   
,isnull(D.PW_Registered,0) as  PW_Registered                  
,isnull(D.PW_With_Address,0) as PW_With_Address          
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details          
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo          
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo 
,isnull(A.Estimated_Mother,0) as Estimated_Mother 
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester          
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk          
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic                 
from          
(
select  c.State_Code,
  D.DCode,D.Name_E as DIST_NAME_ENG,HB.BID,HB.Name_E as Block_Name_E,PH.PID,PH.Name_E as PHC_Name,
  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code    
 ,isnull(sp.Name_E,'Direct Entry') as  HealthSubFacility_Name,isnull(vn.Name_E,'Direct Entry') as Village_Name        
 ,c.Estimated_Mother as Estimated_Mother                
 from Estimated_Data_Village_Wise  c WITH (NOLOCK)        
left outer join VILLAGE vn WITH (NOLOCK) on vn.vcode=c.Village_Code     
 left outer join Health_SubCentre sp WITH (NOLOCK) on sp.SID=c.HealthSubFacility_Code    
 left outer join Health_PHC PH with(Nolock) on PH.PID=SP.PID
 left outer join HEALTH_BLOCK HB with(nolock) on HB.BID=PH.BID
 left outer join DISTRICT D with(Nolock) on D.DCode=Hb.DCode     
 left outer join Health_SC_Village v WITH (NOLOCK) on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code         
 where (d.Dcode=@District_Code)        
 and c.Financial_Year=@FinancialYr           
)  A          
          
left outer join          
(          
 select State_Code,HealthSubFacility_Code,Village_Code           
,SUM(PW_Registered) as PW_Registered            
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo            
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo             
,SUM(PW_With_Address) as PW_With_Address                 
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details           
,SUM(PW_First_Trimester) as PW_First_Trimester           
,SUM(PW_High_Risk) as PW_High_Risk             
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                         
from Scheduled_AC_PW_PHC_SubCenter_Village_Month as PW WITH (NOLOCK) 
inner join Health_PHC B WITH (NOLOCK) on B.PID=PW.HealthFacility_Code                       
where B.DCode=@District_Code          
and (Month_ID=@Month_ID or @Month_ID=0)          
and (Year_ID=@Year_ID or @Year_ID=0)          
and (Filter_Type=@Type)          
and Fin_Yr=@FinancialYr           
group by State_Code,HealthSubFacility_Code,Village_Code 
 ) D on  A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code order by A.HealthSubFacility_Name,A.Village_Name        
end         
END     
    