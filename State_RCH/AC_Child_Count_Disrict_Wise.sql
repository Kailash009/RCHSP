USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Child_Count_Disrict_Wise]    Script Date: 09/26/2024 11:45:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*    
[AC_Child_Count_Disrict_Wise] 29,1,0,0,0,0,2019,0,0,'','','District','1'      
*/    
    
ALTER procedure [dbo].[AC_Child_Count_Disrict_Wise]    
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
   
SET NOCOUNT ON      

if(@Category='District')      
begin      
select 
isnull(A.DIST_NAME_ENG,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.Dcode,0) ) + ')' as District,      
isnull(A.Block_Name_E,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.BID,0) ) + ')' as [Health_Block],      
isnull(A.PHC_NAME,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.PID,0) ) + ')' as [Health_Facility],  
isnull(A.HealthSubFacility_Name,'--') + '(' + CONVERT(VARCHAR(150),ISNULL( A.HealthSubFacility_Code,0) ) + ')' as [Health_SubFacility] ,      
A.Village_Name   
,isnull(B.Infant_Registered,0) as Infant_Registered    
,isnull(B.Child_Registered,0) as Child_Registered  
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address       
,isnull(B.Infant_With_EID,0) as Infant_With_EID 
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5 
,isnull(A.Estimated_Infant,0) as Estimated_Infant 
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
   
from     
(    
 select c.State_Code,
  D.DCode,D.Name_E as DIST_NAME_ENG,HB.BID,HB.Name_E as Block_Name_E,PH.PID,PH.Name_E as PHC_Name,
  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code    
 ,isnull(sp.Name_E,'Direct Entry') as  HealthSubFacility_Name,isnull(vn.Name_E,'Direct Entry') as Village_Name        
 ,c.Estimated_Infant as Estimated_Infant    
 from Estimated_Data_Village_Wise  c WITH (NOLOCK)    
 left outer join VILLAGE vn WITH (NOLOCK) on vn.vcode=c.Village_Code     
 left outer join Health_SubCentre sp WITH (NOLOCK) on sp.SID=c.HealthSubFacility_Code    
 left outer join Health_PHC PH with(Nolock) on PH.PID=SP.PID
 left outer join HEALTH_BLOCK HB with(nolock) on HB.BID=PH.BID
 left outer join DISTRICT D with(Nolock) on D.DCode=Hb.DCode
 left outer join Health_SC_Village v WITH (NOLOCK) on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code      
 where (d.DCode=@District_Code) and c.Financial_Year=@FinancialYr    
    
)  A     
left outer join     
(      
select State_Code,HealthSubFacility_Code,Village_Code
,SUM(Infant_Registered) as Infant_Registered      
,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address      
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5    
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight                   
from Scheduled_AC_Child_PHC_SubCenter_Village_Month A WITH (NOLOCK) 
inner join Health_PHC B WITH (NOLOCK) on B.PID=A.HealthFacility_Code                     
where B.DCode=@District_Code          
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
group by State_Code,HealthSubFacility_Code,Village_Code
 ) B on  A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code 
 order by A.HealthSubFacility_Name,A.Village_Name    
end      
end    

