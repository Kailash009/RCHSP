USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_Count]    Script Date: 09/26/2024 11:46:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
      
      
      
      
/*      
[AC_EC_Count] 30,0,0,0,0,0,2019,6,0,'','','State',1      
[AC_EC_Count] 27,2,0,0,0,0,2016,0,0,'','','District',1        
[AC_EC_Count] 27,2,138,0,0,0,2016,0,0,'','','Block',1        
[AC_EC_Count] 27,2,138,896,0,0,2016,0,0,'','','PHC',1        
[AC_EC_Count] 27,2,138,896,4012,0,2016,0,0,'','','SubCentre',1        
      
[AC_EC_Count] 28,0,0,0,0,0,2015,0,0,'','','State',3      
[AC_EC_Count] 28,22,0,0,0,0,2015,0,0,'','','District',3        
[AC_EC_Count] 28,11,558,0,0,0,2015,0,0,'','','Block',3        
[AC_EC_Count] 30,1,1,1,0,0,2019,0,0,'','','PHC',1       
[AC_EC_Count] 30,1,1,1,9,0,2019,0,0,'','','SubCentre',1        
      
*/      
      
ALTER procedure [dbo].[AC_EC_Count]      
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
@Type int=1      
)      
as      
begin      
declare @daysPast as int,@BeginDate as date,@Daysinyear int      
      
 set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)      
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)      
 set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)      
      
      
      
if(@Category='National')        
begin        
 exec RCH_Reports.dbo.AC_EC_Count @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,        
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category,@Type      
end      
      
if(@Category='State')        
begin        
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName      
      
,isnull(C.EC_Registered,0) as EC_Registered      
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull(C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No      
,isnull(C.EC_With_Address,0) as  EC_With_Address      
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details      
,isnull(C.EC_With_PhoneNo,0) as EC_With_PhoneNo      
,isnull(C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo      
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,isnull(A.Estimated_EC,0) as Estimated_EC      
,ISNULL(D.Total_EC_Registered,0) as Total_EC_Registered      
,@daysPast as daysPast      
,@Daysinyear as DaysinYear     
,ISNULL(C.EC_With_FamilyID,0) as EC_With_FamilyID
,ISNULL(D.All_FamilyID,0) as All_FamilyID       
from      
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG  as District_Name      
 --,c.Estimated_Mother as Estimated_Mother      
 --,c.Estimated_Infant as Estimated_Infant      
 --,c.Estimated_EC  as Estimated_EC      
 from TBL_DISTRICT (nolock) a      
 inner join TBL_STATE (nolock)  b on a.StateID=b.StateID      
 --inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code      
 --where c.Financial_Year=@FinancialYr       
 and b.StateID=@State_Code and (a.DIST_CD=@District_Code or @District_Code=0)      
)  A      
      
left outer join      
(      
 select  EC.State_Code,EC.District_Code       
,SUM(EC_Registered) as EC_Registered        
,SUM(total_distinct_ec) as EC_Registered_Distinct        
,SUM(EC_With_PhoneNo) AS EC_With_PhoneNo        
,SUM(EC_With_SelfPhoneNo) as EC_With_SelfPhoneNo         
,SUM(EC_With_Address) as EC_With_Address      
,SUM(EC_With_Aadhaar_No) as EC_With_Aadhaar_No      
,SUM(EC_With_Bank_Details) as EC_With_Bank_Details       
,SUM(EC_With_No_Children) as EC_With_No_Children      
,SUM(EC_With_One_Children) as EC_With_One_Children         
,SUM(EC_With_Two_Children) as EC_With_Two_Children         
,SUM(EC_With_MoreThanTwo_Children) as EC_With_MoreThanTwo_Children      
,SUM(Woman_RC_NUMBER) as EC_With_FamilyID                
   from Scheduled_AC_EC_State_District_month as EC  (nolock)        
 where EC.State_Code =@State_Code      
 and (EC.District_Code=@District_Code or @District_Code=0)      
and (Month_ID=@Month_ID or @Month_ID=0)      
and (Year_ID=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr=@FinancialYr       
 group by EC.State_Code,EC.District_Code      
 ) C on A.State_Code=C.State_Code and A.District_Code=C.District_Code       
left outer join      
(      
 select  State_Code,District_Code       
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(Woman_RC_NUMBER) as All_FamilyID                                
                 
   from Scheduled_AC_EC_State_District_month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,District_Code      
 ) D on A.State_Code=D.State_Code and A.District_Code=D.District_Code order by A.State_Name,a.District_Name      
      
end      
else if(@Category='District')        
begin        
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName      
      
,isnull(C.EC_Registered,0) as EC_Registered      
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull(C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No      
,isnull(C.EC_With_Address,0) as  EC_With_Address      
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details      
,isnull(C.EC_With_PhoneNo,0) as EC_With_PhoneNo      
,isnull(C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo      
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,isnull(A.Estimated_EC,0) as Estimated_EC      
,ISNULL(D.Total_EC_Registered,0) as Total_EC_Registered      
,@daysPast as daysPast      
,@Daysinyear as DaysinYear     
,ISNULL(C.EC_With_FamilyID,0) as EC_With_FamilyID
,ISNULL(D.All_FamilyID,0) as All_FamilyID        
from      
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name       
 --,c.Estimated_Mother as Estimated_Mother      
 --,c.Estimated_Infant as Estimated_Infant      
 --,c.Estimated_EC  as Estimated_EC      
 from TBL_HEALTH_BLOCK a      
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD      
 --inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code      
 --where c.Financial_Year=@FinancialYr       
 and a.DISTRICT_CD=@District_Code      
)  A      
      
left outer join      
(      
 select  EC.State_Code,EC.District_Code,EC.HealthBlock_Code       
,SUM(EC_Registered) as EC_Registered        
,SUM(total_distinct_ec) as EC_Registered_Distinct        
,SUM(EC_With_PhoneNo) AS EC_With_PhoneNo        
,SUM(EC_With_SelfPhoneNo) as EC_With_SelfPhoneNo         
,SUM(EC_With_Address) as EC_With_Address      
,SUM(EC_With_Aadhaar_No) as EC_With_Aadhaar_No      
,SUM(EC_With_Bank_Details) as EC_With_Bank_Details       
,SUM(EC_With_No_Children) as EC_With_No_Children      
,SUM(EC_With_One_Children) as EC_With_One_Children         
,SUM(EC_With_Two_Children) as EC_With_Two_Children         
,SUM(EC_With_MoreThanTwo_Children) as EC_With_MoreThanTwo_Children      
,SUM(Woman_RC_NUMBER) as EC_With_FamilyID                
   from Scheduled_AC_EC_District_Block_Month as EC        
 where EC.State_Code =@State_Code      
 and EC.District_Code=@District_Code      
and (Month_ID=@Month_ID or @Month_ID=0)      
and (Year_ID=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr=@FinancialYr       
 group by EC.State_Code,EC.District_Code,EC.HealthBlock_Code       
 ) C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code       
left outer join      
(      
 select  State_Code,District_Code,HealthBlock_Code      
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(Woman_RC_NUMBER) as All_FamilyID                                                 
   from Scheduled_AC_EC_District_Block_Month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
  group by State_Code,District_Code,HealthBlock_Code       
 ) D on   A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code  order by A.District_Name      
      
      
      
      
end      
else if(@Category='Block')        
begin        
select @State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName      
      
,isnull(C.EC_Registered,0) as EC_Registered      
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull(C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No      
,isnull(C.EC_With_Address,0) as  EC_With_Address      
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details      
,isnull(C.EC_With_PhoneNo,0) as EC_With_PhoneNo      
,isnull(C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo      
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,isnull(A.Estimated_EC,0) as Estimated_EC      
,ISNULL(D.Total_EC_Registered,0) as Total_EC_Registered      
,@daysPast as daysPast      
,@Daysinyear as DaysinYear      
,ISNULL(C.EC_With_FamilyID,0) as EC_With_FamilyID
,ISNULL(D.All_FamilyID,0) as All_FamilyID       
from        
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name      
 --  ,c.Estimated_Mother as Estimated_Mother      
 --,c.Estimated_Infant as Estimated_Infant      
 --,c.Estimated_EC  as Estimated_EC      
     from TBL_PHC  a      
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD      
  --   inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code      
  --where c.Financial_Year=@FinancialYr       
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)      
)  A       
      
 left outer join      
(      
 select  State_Code,HealthBlock_Code,HealthFacility_Code         
,SUM(EC_Registered) as EC_Registered        
,SUM(total_distinct_ec) as EC_Registered_Distinct        
,SUM(EC_With_PhoneNo) AS EC_With_PhoneNo        
,SUM(EC_With_SelfPhoneNo) as EC_With_SelfPhoneNo         
,SUM(EC_With_Address) as EC_With_Address      
,SUM(EC_With_Aadhaar_No) as EC_With_Aadhaar_No      
,SUM(EC_With_Bank_Details) as EC_With_Bank_Details       
,SUM(EC_With_No_Children) as EC_With_No_Children      
,SUM(EC_With_One_Children) as EC_With_One_Children         
,SUM(EC_With_Two_Children) as EC_With_Two_Children         
,SUM(EC_With_MoreThanTwo_Children) as EC_With_MoreThanTwo_Children     
,SUM(Woman_RC_NUMBER) as EC_With_FamilyID                      
   from Scheduled_AC_EC_Block_PHC_Month as EC        
 where State_Code =@State_Code      
 and HealthBlock_Code =@HealthBlock_Code         
and (Month_ID=@Month_ID or @Month_ID=0)      
and (Year_ID=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr=@FinancialYr       
 group by State_Code,HealthBlock_Code,HealthFacility_Code         
 ) C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code      
 left outer join      
(      
 select  State_Code,HealthBlock_Code,HealthFacility_Code       
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(Woman_RC_NUMBER) as All_FamilyID                                
                 
   from Scheduled_AC_EC_Block_PHC_Month (nolock)        
 where State_Code =@State_Code      
 and HealthBlock_Code =@HealthBlock_Code       
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,HealthBlock_Code,HealthFacility_Code       
 ) D on   A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code      
  order by A.HealthBlock_Name,A.HealthFacility_Name      
      
 end       
else if(@Category='PHC')        
begin        
select @State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName      
      
,isnull(C.EC_Registered,0) as EC_Registered      
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull(C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No      
,isnull(C.EC_With_Address,0) as  EC_With_Address      
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details      
,isnull(C.EC_With_PhoneNo,0) as EC_With_PhoneNo      
,isnull(C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo      
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,isnull(A.Estimated_EC,0) as Estimated_EC      
,ISNULL(D.Total_EC_Registered,0) as Total_EC_Registered      
,@daysPast as daysPast      
,@Daysinyear as DaysinYear      
,ISNULL(C.EC_With_FamilyID,0) as EC_With_FamilyID
,ISNULL(D.All_FamilyID,0) as All_FamilyID       
from       
(      
select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name,isnull([Total_Village],0) as [Total_Village],isnull([Total_Profile_Entered],1)as [Total_Profile_Entered]      
 ,a.Estimated_EC as Estimated_EC      
 ,a.Estimated_Mother as Estimated_Mother      
 ,a.Estimated_Infant as Estimated_Infant      
 from Estimated_Data_SubCenter_Wise a      
 inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD      
 left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD       
 where a.Financial_Year=@FinancialYr       
 and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)      
)A       
      
left outer join      
(      
 select  State_Code,HealthFacility_Code,HealthSubFacility_Code      
,SUM(EC_Registered) as EC_Registered        
,SUM(total_distinct_ec) as EC_Registered_Distinct        
,SUM(EC_With_PhoneNo) AS EC_With_PhoneNo        
,SUM(EC_With_SelfPhoneNo) as EC_With_SelfPhoneNo         
,SUM(EC_With_Address) as EC_With_Address      
,SUM(EC_With_Aadhaar_No) as EC_With_Aadhaar_No      
,SUM(EC_With_Bank_Details) as EC_With_Bank_Details      
,SUM(EC_With_No_Children) as EC_With_No_Children      
,SUM(EC_With_One_Children) as EC_With_One_Children         
,SUM(EC_With_Two_Children) as EC_With_Two_Children         
,SUM(EC_With_MoreThanTwo_Children) as EC_With_MoreThanTwo_Children      
,SUM(Woman_RC_NUMBER) as EC_With_FamilyID                      
   from Scheduled_AC_EC_PHC_SubCenter_Month as EC        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code         
and (Month_ID=@Month_ID or @Month_ID=0)      
and (Year_ID=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr=@FinancialYr       
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code       
 ) C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code      
       
  left outer join      
(      
 select  State_Code,HealthFacility_Code,HealthSubFacility_Code      
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(Woman_RC_NUMBER) as All_FamilyID                                
                 
from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code            
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code       
 ) D on   A.HealthFacility_Code=D.HealthFacility_Code and A.HealthSubFacility_Code=D.HealthSubFacility_Code order by A.HealthFacility_Name,A.HealthSubFacility_Name      
      
 end        
else if(@Category='SubCentre')        
begin        
select @State_Code,A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName      
      
,isnull(C.EC_Registered,0) as EC_Registered      
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull(C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No      
,isnull(C.EC_With_Address,0) as  EC_With_Address      
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details      
,isnull(C.EC_With_PhoneNo,0) as EC_With_PhoneNo      
,isnull(C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo      
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,isnull(A.Estimated_EC,0) as Estimated_EC      
,ISNULL(D.Total_EC_Registered,0) as Total_EC_Registered      
,@daysPast as daysPast      
,@Daysinyear as DaysinYear      
,ISNULL(C.EC_With_FamilyID,0) as EC_With_FamilyID
,ISNULL(D.All_FamilyID,0) as All_FamilyID       
  from       
(      
 select c.State_Code,  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code      
 ,sp.SUBPHC_NAME_E as  HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name      
 ,c.Estimated_EC as Estimated_EC      
 ,c.Estimated_Mother as Estimated_Mother      
 ,c.Estimated_Infant as Estimated_Infant      
 from Estimated_Data_Village_Wise  c      
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code      
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code      
 left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code       
 where (c.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)      
 and (c.Village_Code=@Village_Code or @Village_Code=0)       
 and c.Financial_Year=@FinancialYr      
      
)  A       
      
  left outer join      
(      
 select  State_Code,HealthSubFacility_Code,Village_Code      
,SUM(EC_Registered) as EC_Registered        
,SUM(total_distinct_ec) as EC_Registered_Distinct        
,SUM(EC_With_PhoneNo) AS EC_With_PhoneNo        
,SUM(EC_With_SelfPhoneNo) as EC_With_SelfPhoneNo         
,SUM(EC_With_Address) as EC_With_Address      
,SUM(EC_With_Aadhaar_No) as EC_With_Aadhaar_No      
,SUM(EC_With_Bank_Details) as EC_With_Bank_Details       
,SUM(EC_With_No_Children) as EC_With_No_Children      
,SUM(EC_With_One_Children) as EC_With_One_Children         
,SUM(EC_With_Two_Children) as EC_With_Two_Children         
,SUM(EC_With_MoreThanTwo_Children) as EC_With_MoreThanTwo_Children      
,SUM(Woman_RC_NUMBER) as EC_With_FamilyID                     
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month as EC        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code       
 and HealthSubFacility_Code =@HealthSubFacility_Code           
and (Month_ID=@Month_ID or @Month_ID=0)      
and (Year_ID=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr=@FinancialYr       
 group by State_Code,HealthSubFacility_Code,Village_Code      
 ) C on  A.HealthSubFacility_Code=C.HealthSubFacility_Code       
and A.Village_Code=C.Village_Code      
 left outer join      
(      
 select  State_Code,HealthSubFacility_Code,Village_Code      
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(Woman_RC_NUMBER) as All_FamilyID                                
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code       
 and HealthSubFacility_Code =@HealthSubFacility_Code         
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
group by State_Code,HealthSubFacility_Code,Village_Code       
 ) D on     A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code      
  order by A.HealthSubFacility_Name,A.Village_Name      
      
       
       
 end        
      
end      
