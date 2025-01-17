USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Child_Count]    Script Date: 09/26/2024 11:45:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*    
[AC_Child_Count] 28,0,0,0,0,0,2015,0,0,'','','State','1'    
[AC_Child_Count] 28,22,0,0,0,0,2015,0,0,'','','District','2'      
[AC_Child_Count] 28,11,558,0,0,0,2015,0,0,'','','Block'      
[AC_Child_Count] 28,15,495,1405,0,0,2015,0,0,'','','PHC'      
[AC_Child_Count] 28,15,495,1405,6656,0,2015,0,0,'','','SubCentre','1 '     
[AC_Child_Count] 28,22,270,443,0,2015,0,0,'','','PHC'     
[AC_Child_Count] 28,11,0,0,0,0,2015,0,0,'','','District'      
*/    
    
ALTER procedure [dbo].[AC_Child_Count]    
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
@Category varchar(20) ='District'  ,    
@Type int =1      
)    
as    
begin    
   
SET NOCOUNT ON    
    
declare @daysPast as int,@BeginDate as date,@Daysinyear int    
    
set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)    
set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)    
set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)    
    
    
if(@Category='National')      
begin      
 exec RCH_Reports.dbo.AC_Child_Count @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,      
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category,@Type    
end    
if(@Category='State')      
begin      
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName    
,isnull(B.Infant_Registered,0) as Infant_Registered   
,isnull(B.Child_Registered,0) as Child_Registered --done by shital on 25-02-2019   
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address    
,isnull(B.Infant_With_Aadhaar_No,0) as Infant_With_Aadhaar_No    
,isnull(B.Infant_With_EID,0) as Infant_With_EID    
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5    
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
,isnull(A.Estimated_Infant,0) as Estimated_Infant    
,@daysPast as daysPast    
,@Daysinyear as DaysinYear    
,isnull(B.Child_Death_Total,0) as Child_Death_Total
,ISNULL(B.CH_HEB_PW,0) as CH_HEB_PW 
,ISNULL(B.CH_HBIG_LINKED_PW,0) as CH_HBIG_LINKED_PW 
,ISNULL(B.TOTAL_HBIG,0) as TOTAL_HBIG    
from    
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name    
     
 , c.Estimated_Infant  as Estimated_Infant    
     
 from TBL_DISTRICT a WITH (NOLOCK)   
 inner join TBL_STATE b WITH (NOLOCK) on a.StateID=b.StateID    
 inner join Estimated_Data_District_Wise c WITH (NOLOCK) on a.DIST_CD=c.District_Code    
 where c.Financial_Year=@FinancialYr     
 and b.StateID=@State_Code and (a.DIST_CD=@District_Code or @District_Code=0)    
)  A    
left outer join    
(    
 select  CH.State_Code,CH.District_Code     
,SUM(Infant_Registered) as Infant_Registered      
 ,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address    
,SUM(Infant_With_Aadhaar_No) as Infant_With_Aadhaar_No    
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5      
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight       
,sum(Child_Death_Total) as Child_Death_Total 
,SUM(CH_HEB_PW) as CH_HEB_PW
,SUM(CH_HBIG_LINKED_PW) as CH_HBIG_LINKED_PW
,SUM(TOTAL_HBIG) as TOTAL_HBIG   
   from Scheduled_AC_Child_State_District_Month as CH WITH (NOLOCK)     
 where CH.State_Code =@State_Code    
 and (CH.District_Code=@District_Code or @District_Code=0)    
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
 group by CH.State_Code,CH.District_Code    
 ) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code order by A.State_Name,a.District_Name    
    
    
end    
else if(@Category='District')      
begin      
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName    
,isnull(B.Infant_Registered,0) as Infant_Registered    
,isnull(B.Child_Registered,0) as Child_Registered --done by shital on 25-02-2019  
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address    
,isnull(B.Infant_With_Aadhaar_No,0) as Infant_With_Aadhaar_No    
,isnull(B.Infant_With_EID,0) as Infant_With_EID    
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5    
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
,isnull(A.Estimated_Infant,0) as Estimated_Infant    
,@daysPast as daysPast    
,@Daysinyear as DaysinYear    
,isnull(B.Child_Death_Total,0) as Child_Death_Total
,ISNULL(B.CH_HEB_PW,0) as CH_HEB_PW 
,ISNULL(B.CH_HBIG_LINKED_PW,0) as CH_HBIG_LINKED_PW 
,ISNULL(B.TOTAL_HBIG,0) as TOTAL_HBIG     
from    
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name     
     
 ,c.Estimated_Infant  as Estimated_Infant    
     
 from TBL_HEALTH_BLOCK a WITH (NOLOCK)   
 inner join TBL_DISTRICT b WITH (NOLOCK) on a.DISTRICT_CD=b.DIST_CD    
 inner join Estimated_Data_Block_Wise c WITH (NOLOCK) on a.BLOCK_CD=c.HealthBlock_Code    
 where c.Financial_Year=@FinancialYr     
 and a.DISTRICT_CD=@District_Code    
)  A    
left outer join    
(    
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code     
,SUM(Infant_Registered) as Infant_Registered      
,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address    
,SUM(Infant_With_Aadhaar_No) as Infant_With_Aadhaar_No    
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5      
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight       
,sum(Child_Death_Total) as Child_Death_Total
,SUM(CH_HEB_PW) as CH_HEB_PW
,SUM(CH_HBIG_LINKED_PW) as CH_HBIG_LINKED_PW
,SUM(TOTAL_HBIG) as TOTAL_HBIG    
   from Scheduled_AC_Child_District_Block_Month as CH WITH (NOLOCK)     
 where CH.State_Code =@State_Code    
 and CH.District_Code=@District_Code    
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
 group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code    
 ) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code order by A.District_Name,a.HealthBlock_Name    
    
    
    
end    
else if(@Category='Block')      
begin      
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName    
,isnull(B.Infant_Registered,0) as Infant_Registered    
,isnull(B.Child_Registered,0) as Child_Registered --done by shital on 25-02-2019  
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address    
,isnull(B.Infant_With_Aadhaar_No,0) as Infant_With_Aadhaar_No    
,isnull(B.Infant_With_EID,0) as Infant_With_EID    
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5    
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
,isnull(A.Estimated_Infant,0) as Estimated_Infant    
,@daysPast as daysPast    
,@Daysinyear as DaysinYear    
,isnull(B.Child_Death_Total,0) as Child_Death_Total 
,ISNULL(B.CH_HEB_PW,0) as CH_HEB_PW 
,ISNULL(B.CH_HBIG_LINKED_PW,0) as CH_HBIG_LINKED_PW 
,ISNULL(B.TOTAL_HBIG,0) as TOTAL_HBIG    
from      
(select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name    
,c.Estimated_Infant  as Estimated_Infant     
    
     from TBL_PHC  a WITH (NOLOCK)   
     inner join TBL_HEALTH_BLOCK b WITH (NOLOCK) on a.BID=b.BLOCK_CD    
     inner join Estimated_Data_PHC_Wise c WITH (NOLOCK) on a.PHC_CD=c.HealthFacility_Code    
  where c.Financial_Year=@FinancialYr     
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)    
)  A     
left outer join    
(    
 select State_Code,HealthBlock_Code,HealthFacility_Code       
 ,SUM(Infant_Registered) as Infant_Registered      
 ,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address    
,SUM(Infant_With_Aadhaar_No) as Infant_With_Aadhaar_No    
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5    
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight    
,sum(Child_Death_Total) as Child_Death_Total 
,SUM(CH_HEB_PW) as CH_HEB_PW
,SUM(CH_HBIG_LINKED_PW) as CH_HBIG_LINKED_PW
,SUM(TOTAL_HBIG) as TOTAL_HBIG                  
   from Scheduled_AC_Child_Block_PHC_Month  WITH (NOLOCK)  
 where State_Code =@State_Code    
 and HealthBlock_Code =@HealthBlock_Code       
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
 group by State_Code,HealthBlock_Code,HealthFacility_Code    
 ) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code order by A.HealthBlock_Name,A.HealthFacility_Name    
     
 end     
else if(@Category='PHC')      
begin      
select A.State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName    
,isnull(B.Infant_Registered,0) as Infant_Registered    
,isnull(B.Child_Registered,0) as Child_Registered --done by shital on 25-02-2019  
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address    
,isnull(B.Infant_With_Aadhaar_No,0) as Infant_With_Aadhaar_No    
,isnull(B.Infant_With_EID,0) as Infant_With_EID    
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5    
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
,isnull(A.Estimated_Infant,0) as Estimated_Infant    
,@daysPast as daysPast    
,@Daysinyear as DaysinYear    
,isnull(B.Child_Death_Total,0) as Child_Death_Total
,ISNULL(B.CH_HEB_PW,0) as CH_HEB_PW 
,ISNULL(B.CH_HBIG_LINKED_PW,0) as CH_HBIG_LINKED_PW 
,ISNULL(B.TOTAL_HBIG,0) as TOTAL_HBIG     
from     
(    
 select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name,isnull([Total_Village],0) as [Total_Village]  
 ,isnull([Total_Profile_Entered],1)as [Total_Profile_Entered]    
 ,a.Estimated_EC as Estimated_EC    
 ,a.Estimated_Mother as Estimated_Mother    
 ,a.Estimated_Infant as Estimated_Infant    
 from Estimated_Data_SubCenter_Wise a WITH (NOLOCK)   
 inner join TBL_PHC b WITH (NOLOCK)on a.HealthFacility_Code=b.PHC_CD    
 left outer join TBL_SUBPHC c WITH (NOLOCK) on a.HealthSubFacility_Code=c.SUBPHC_CD     
 where a.Financial_Year=@FinancialYr     
 and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)    
)  A     
left outer join     
(      
 select State_Code,HealthFacility_Code,HealthSubFacility_Code    
 ,SUM(Infant_Registered) as Infant_Registered    
,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address    
,SUM(Infant_With_Aadhaar_No) as Infant_With_Aadhaar_No    
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5     
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight      
,sum(Child_Death_Total) as Child_Death_Total
,SUM(CH_HEB_PW) as CH_HEB_PW
,SUM(CH_HBIG_LINKED_PW) as CH_HBIG_LINKED_PW
,SUM(TOTAL_HBIG) as TOTAL_HBIG                
   from Scheduled_AC_Child_PHC_SubCenter_Month WITH (NOLOCK)    
 where State_Code =@State_Code    
 and HealthFacility_Code =@HealthFacility_Code       
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code    
 ) B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code order by A.HealthFacility_Name,A.HealthSubFacility_Name    
    
     
 end      
else if(@Category='SubCentre')      
begin      
select A.State_Code,A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName    
,isnull(B.Infant_Registered,0) as Infant_Registered    
,isnull(B.Child_Registered,0) as Child_Registered --done by shital on 25-02-2019  
,isnull(B.Infant_With_PhoneNo,0) as Infant_With_PhoneNo    
,isnull(B.Infant_With_SelfPhoneNo,0) as Infant_With_SelfPhoneNo    
,isnull(B.Infant_With_Address,0) as Infant_With_Address    
,isnull(B.Infant_With_Aadhaar_No,0) as Infant_With_Aadhaar_No    
,isnull(B.Infant_With_EID,0) as Infant_With_EID    
,isnull(B.Child_0_1,0) as Child_0_1    
,isnull(B.Child_1_2,0) as Child_1_2    
,isnull(B.Child_2_3,0) as Child_2_3    
,isnull(B.Child_3_4,0) as Child_3_4    
,isnull(B.Child_4_5,0) as Child_4_5    
,ISNULL(B.Infant_Reg_Within_30days,0) as Infant_Reg_Within_30days    
,ISNULL(B.Infant_Low_birth_Weight,0) as Infant_Low_birth_Weight    
,isnull(A.Estimated_Infant,0) as Estimated_Infant    
,@daysPast as daysPast    
,@Daysinyear as DaysinYear    
,isnull(B.Child_Death_Total,0) as Child_Death_Total
,ISNULL(B.CH_HEB_PW,0) as CH_HEB_PW 
,ISNULL(B.CH_HBIG_LINKED_PW,0) as CH_HBIG_LINKED_PW 
,ISNULL(B.TOTAL_HBIG,0) as TOTAL_HBIG     
from     
(    
 select c.State_Code,  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code    
 ,sp.SUBPHC_NAME_E as  HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name    
 ,c.Estimated_EC as Estimated_EC    
 ,c.Estimated_Mother as Estimated_Mother    
 ,c.Estimated_Infant as Estimated_Infant    
 from Estimated_Data_Village_Wise  c WITH (NOLOCK)    
 left outer join TBL_VILLAGE vn WITH (NOLOCK) on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code    
 left outer join TBL_SUBPHC sp WITH (NOLOCK) on sp.SUBPHC_CD=c.HealthSubFacility_Code    
 left outer join Health_SC_Village v WITH (NOLOCK) on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code     
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)    
 and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr    
    
)  A     
left outer join     
(      
 select State_Code,HealthSubFacility_Code,Village_Code    
 ,SUM(Infant_Registered) as Infant_Registered      
  ,SUM(Infant_Registered+Child_1_2+Child_2_3+Child_3_4+Child_4_5)as Child_Registered --done by shital on 25-02-2019  
,SUM(Infant_With_PhoneNo) AS Infant_With_PhoneNo      
,SUM(Infant_With_SelfPhoneNo) as Infant_With_SelfPhoneNo       
,SUM(Infant_With_Address) as Infant_With_Address    
,SUM(Infant_With_Aadhaar_No) as Infant_With_Aadhaar_No    
,SUM(Infant_With_EID) as Infant_With_EID      
,SUM(Child_0_1) as Child_0_1    
,SUM(Child_1_2) as Child_1_2       
,SUM(Child_2_3) as Child_2_3       
,SUM(Child_3_4) as Child_3_4       
,SUM(Child_4_5) as Child_4_5    
,SUM(Infant_Reg_Within_30days) as Infant_Reg_Within_30days    
,SUM(Infant_Low_birth_Weight) as Infant_Low_birth_Weight        
,sum(Child_Death_Total) as Child_Death_Total
,SUM(CH_HEB_PW) as CH_HEB_PW
,SUM(CH_HBIG_LINKED_PW) as CH_HBIG_LINKED_PW
,SUM(TOTAL_HBIG) as TOTAL_HBIG
               
   from Scheduled_AC_Child_PHC_SubCenter_Village_Month WITH (NOLOCK)   
 where State_Code =@State_Code    
 and HealthFacility_Code =@HealthFacility_Code     
 and HealthSubFacility_Code =@HealthSubFacility_Code         
and (Month_ID=@Month_ID or @Month_ID=0)    
and (Year_ID=@Year_ID or @Year_ID=0)    
and (Filter_Type=@Type)    
and Fin_Yr=@FinancialYr     
 group by State_Code,HealthSubFacility_Code,Village_Code    
 ) B on  A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code order by A.HealthSubFacility_Name,A.Village_Name    
    
     
 end      
    
end    
  
