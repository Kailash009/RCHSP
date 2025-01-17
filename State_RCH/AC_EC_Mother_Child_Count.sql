USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_EC_Mother_Child_Count]    Script Date: 09/26/2024 11:50:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*        
[AC_EC_Mother_Child_Count] 0,0,0,0,0,0,2016,0,0,'','','National'      
[AC_EC_Mother_Child_Count] 30,0,0,0,0,0,2019,5,0,'','','State'        
[AC_EC_Mother_Child_Count] 30,1,0,0,0,0,2019,5,0,'','','District'          
[AC_EC_Mother_Child_Count] 30,1,3,0,0,0,2018,3,0,'','','Block'          
[AC_EC_Mother_Child_Count] 30,1,3,12,0,0,2018,0,0,'','','PHC'          
[AC_EC_Mother_Child_Count] 30,1,3,12,48,0,2018,0,0,'','','SubCentre'          
[AC_EC_Mother_Child_Count] 28,22,270,443,0,2015,0,0,'','','PHC'                 
[AC_EC_Mother_Child_Count] 28,11,0,0,0,0,2015,0,0,'','','District'          
*/               
ALTER procedure [dbo].[AC_EC_Mother_Child_Count]        
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
 exec RCH_Reports.dbo.AC_EC_Mother_Child_Count @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,        
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category,@Type      
end        
      
if(@Category='State')          
begin          
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName        
,isnull(B.Infant_Registered,0) as Infant_Registered        
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
,isnull(e.Total_EC_Registered ,0) as Total_EC_Registered        
,isnull((case when @Month_ID=0 then e.Total_EC_Registered else C.EC_Registered_Distinct  end),0) as Total_EC_Registered_2       
,isnull(C.EC_Registered,0) as EC_Registered        
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull( C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No        
,isnull( C.EC_With_Address ,0) as  EC_With_Address        
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details        
,isnull( C.EC_With_PhoneNo ,0) as EC_With_PhoneNo        
,isnull( C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo        
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
--,ISNULL((case when @Month_ID=0 then e.Total_EC_With_No_Children else C.EC_With_No_Children end),0) as EC_With_No_Children        
--,ISNULL((case when @Month_ID=0 then e.Total_EC_With_One_Children else C.EC_With_One_Children end),0) as EC_With_One_Children        
--,ISNULL((case when @Month_ID=0 then e.Total_EC_With_Two_Children else C.EC_With_Two_Children end),0) as EC_With_Two_Children        
--,ISNULL((case when @Month_ID=0 then e.Total_EC_With_MoreThanTwo_Children else C.EC_With_MoreThanTwo_Children end),0) as EC_With_MoreThanTwo_Children        
,isnull(D.PW_Registered,0) as  PW_Registered        
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No        
,isnull(D.PW_With_Address,0) as PW_With_Address        
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details        
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo        
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo        
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester        
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk        
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic        
,(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_Mother        
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant        
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC         
      
,ISNULL(X.Prv_Estimated_EC,0) as Prv_Estimated_EC      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(C.EC_Registered_Distinct,0)) end ),0) as Prorata     
      
      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata      
      
,@daysPast as daysPast        
,@Daysinyear as DaysinYear      
,ISNULL(EC_With_FamilyID,0) as EC_With_FamilyID          
,@State_Code as State_Code 
,ISNULL(C.EC_HealthIdNumber,0) as EC_HealthIdNumber 
,ISNULL(E.Total_EC_HealthIdNumber,0) as Total_EC_HealthIdNumber    
from        
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name        
 ,c.Estimated_Mother as Estimated_Mother        
 ,c.Estimated_Infant  as Estimated_Infant        
 ,c.Estimated_EC  as Estimated_EC        
       
 from TBL_DISTRICT a        
 inner join TBL_STATE b on a.StateID=b.StateID        
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code        
 where c.Financial_Year=@FinancialYr         
 and b.StateID=@State_Code and (a.DIST_CD=@District_Code or @District_Code=0)        
)  A        
      
left outer join        
(        
 select  CH.State_Code,CH.District_Code         
,SUM(Infant_Registered) as Infant_Registered          
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
           
from Scheduled_AC_Child_State_District_Month as CH          
where CH.State_Code =@State_Code        
and (CH.District_Code=@District_Code or @District_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by CH.State_Code,CH.District_Code        
 ) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code        
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
,SUM(EC_HealthIdNumber) as EC_HealthIdNumber                  
from Scheduled_AC_EC_State_District_Month as EC          
where EC.State_Code =@State_Code        
and (EC.District_Code=@District_Code or @District_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by EC.State_Code,EC.District_Code        
 ) C on A.State_Code=C.State_Code and A.District_Code=C.District_Code        
left outer join        
(        
 select  PW.State_Code,PW.District_Code        
,SUM(PW_Registered) as PW_Registered          
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo          
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo           
,SUM(PW_With_Address) as PW_With_Address        
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No        
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details         
,SUM(PW_First_Trimester) as PW_First_Trimester         
,SUM(PW_High_Risk) as PW_High_Risk           
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                
from Scheduled_AC_PW_State_District_Month as PW          
where PW.State_Code =@State_Code        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by PW.State_Code,PW.District_Code         
 ) D on A.State_Code=D.State_Code and A.District_Code=D.District_Code        
 left outer join      
(      
 select  State_Code,District_Code       
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(EC_HealthIdNumber) as Total_EC_HealthIdNumber                 
   from Scheduled_AC_EC_State_District_month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,District_Code      
 ) E on A.State_Code=E.State_Code and A.District_Code=E.District_Code       
left outer join      
(      
--Previous Year Estimation      
select  District_Code, Estimated_EC as Prv_Estimated_EC from Estimated_Data_District_Wise       
where Financial_Year=@FinancialYr-1       
) X      
on X.District_Code=A.District_Code      
left outer join      
(      
--State level estimation for total Prorata      
select  State_Code, Sum(Estimated_EC) as Estimated_EC_Pro from RCH_Reports.dbo.Estimated_Data_All_State--Estimated_Data_District_Wise       
where Financial_Year=@FinancialYr group by State_Code      
) XEC      
on XEC.State_Code=A.State_Code      
left outer join      
(      
--State level previous year estimation for total Prorata      
select  State_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from RCH_Reports.dbo.Estimated_Data_All_State--Estimated_Data_District_Wise       
where Financial_Year=@FinancialYr-1  group by State_Code      
) XE      
on XE.State_Code=A.State_Code      
 left outer join        
(        
--State level distinct registration count      
 select  EC.State_Code        
,SUM(total_distinct_ec) as EC_Registered_Pro          
from Scheduled_AC_EC_State_District_Month as EC          
where EC.State_Code =@State_Code        
and (EC.District_Code=@District_Code or @District_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by EC.State_Code      
 ) CE on A.State_Code=CE.State_Code      
   left outer join      
(      
-- State level registration upto selected financial year      
 select  State_Code       
,SUM(total_distinct_ec) as Total_EC_Registered_Pro       
from Scheduled_AC_EC_State_District_month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code      
 ) EP on A.State_Code=EP.State_Code      
      
        
end        
else if(@Category='District')          
begin          
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName        
,isnull(B.Infant_Registered,0) as Infant_Registered        
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
,isnull(e.Total_EC_Registered ,0) as Total_EC_Registered        
,isnull((case when @Month_ID=0 then e.Total_EC_Registered else C.EC_Registered_Distinct  end),0) as Total_EC_Registered_2       
,isnull(C.EC_Registered,0) as EC_Registered        
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull( C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No        
,isnull( C.EC_With_Address ,0) as  EC_With_Address        
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details        
,isnull( C.EC_With_PhoneNo ,0) as EC_With_PhoneNo        
,isnull( C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo        
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
 ,isnull(D.PW_Registered,0) as  PW_Registered        
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No        
,isnull(D.PW_With_Address,0) as PW_With_Address        
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details        
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo        
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo        
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester        
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk        
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic        
,(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_Mother        
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant        
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC         
      
,ISNULL(X.Prv_Estimated_EC,0) as Prv_Estimated_EC      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(C.EC_Registered_Distinct,0)) end ),0) as Prorata      
      
      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata      
      
,@daysPast as daysPast        
,@Daysinyear as DaysinYear     
,ISNULL(EC_With_FamilyID,0) as EC_With_FamilyID        
,@State_Code as State_Code
,ISNULL(C.EC_HealthIdNumber,0) as EC_HealthIdNumber 
,ISNULL(E.Total_EC_HealthIdNumber,0) as Total_EC_HealthIdNumber        
from        
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name         
 ,c.Estimated_Mother as Estimated_Mother        
 ,c.Estimated_Infant  as Estimated_Infant        
 ,c.Estimated_EC  as Estimated_EC        
 from TBL_HEALTH_BLOCK a        
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD        
 inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code        
 where c.Financial_Year=@FinancialYr         
 and a.DISTRICT_CD=@District_Code        
)  A        
left outer join      
(      
select   HealthBlock_Code, SUM(Estimated_EC) Prv_Estimated_EC from Estimated_Data_Block_Wise       
where Financial_Year=@FinancialYr-1 group by HealthBlock_Code      
) X      
on X.HealthBlock_Code=A.HealthBlock_Code      
left outer join        
(        
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code         
,SUM(Infant_Registered) as Infant_Registered          
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
from Scheduled_AC_Child_District_Block_Month as CH          
where CH.State_Code =@State_Code        
and CH.District_Code=@District_Code        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code        
 ) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code        
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
,SUM(EC_HealthIdNumber) as EC_HealthIdNumber                    
from Scheduled_AC_EC_District_Block_Month as EC          
where EC.State_Code =@State_Code        
and EC.District_Code=@District_Code        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by EC.State_Code,EC.District_Code,EC.HealthBlock_Code         
 ) C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code        
left outer join        
(        
 select  PW.State_Code,PW.District_Code,PW.HealthBlock_Code         
,SUM(PW_Registered) as PW_Registered          
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo          
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo           
,SUM(PW_With_Address) as PW_With_Address        
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No        
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details         
,SUM(PW_First_Trimester) as PW_First_Trimester         
,SUM(PW_High_Risk) as PW_High_Risk           
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                
from Scheduled_AC_PW_District_Block_Month as PW          
where PW.State_Code =@State_Code        
and PW.District_Code=@District_Code        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by PW.State_Code,PW.District_Code,PW.HealthBlock_Code         
 ) D on A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code        
  left outer join      
(      
 select  State_Code,District_Code ,HealthBlock_Code      
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(EC_HealthIdNumber) as Total_EC_HealthIdNumber                 
   from Scheduled_AC_EC_District_Block_Month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,District_Code,HealthBlock_Code       
 ) E on A.State_Code=E.State_Code and A.District_Code=E.District_Code  and a.HealthBlock_Code=e.HealthBlock_Code      
left outer join      
(      
select  District_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Block_Wise       
where Financial_Year=@FinancialYr group by District_Code      
) XEC      
on XEC.District_Code=A.District_Code      
left outer join      
(      
select  District_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Block_Wise       
where Financial_Year=@FinancialYr-1  group by District_Code      
) XE      
on XE.District_Code=A.District_Code      
 left outer join        
(        
--District level distinct registration count      
 select  State_Code,District_Code        
,SUM(total_distinct_ec) as EC_Registered_Pro          
from Scheduled_AC_EC_District_Block_Month as EC          
where EC.State_Code =@State_Code        
and (EC.District_Code=@District_Code or @District_Code=0)        
and Fin_Yr=@FinancialYr     and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,District_Code      
 ) CE on A.State_Code=CE.State_Code and a.District_Code=ce.District_Code       
   left outer join      
(      
 select  District_Code       
,SUM(total_distinct_ec) as Total_EC_Registered_Pro       
from Scheduled_AC_EC_District_Block_Month (nolock)        
 where State_Code =@State_Code      
 and (District_Code=@District_Code or @District_Code=0)      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by District_Code      
 ) EP on A.District_Code=EP.District_Code        
        
        
end        
else if(@Category='Block')          
begin          
select @State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName        
,isnull(B.Infant_Registered,0) as Infant_Registered        
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
,isnull(e.Total_EC_Registered ,0) as Total_EC_Registered        
,isnull((case when @Month_ID=0 then e.Total_EC_Registered else C.EC_Registered_Distinct  end),0) as Total_EC_Registered_2       
,isnull(C.EC_Registered,0) as EC_Registered        
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull( C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No        
,isnull( C.EC_With_Address ,0) as  EC_With_Address        
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details        
,isnull( C.EC_With_PhoneNo ,0) as EC_With_PhoneNo        
,isnull( C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo        
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children       
,isnull(D.PW_Registered,0) as  PW_Registered        
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No        
,isnull(D.PW_With_Address,0) as PW_With_Address        
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details        
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo        
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo        
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester        
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk        
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic        
,(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_Mother        
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant        
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC         
      
,ISNULL(X.Prv_Estimated_EC,0) as Prv_Estimated_EC      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(C.EC_Registered_Distinct,0)) end ),0) as Prorata      
      
      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata      
,@daysPast as daysPast        
,@Daysinyear as DaysinYear     
,ISNULL(EC_With_FamilyID,0) as EC_With_FamilyID        
,@State_Code as State_Code    
,ISNULL(C.EC_HealthIdNumber,0) as EC_HealthIdNumber
,ISNULL(E.Total_EC_HealthIdNumber,0) as Total_EC_HealthIdNumber     
from          
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name        
   ,c.Estimated_Mother as Estimated_Mother        
 ,c.Estimated_Infant  as Estimated_Infant        
 ,c.Estimated_EC  as Estimated_EC        
     from TBL_PHC  a        
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD        
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code        
  where c.Financial_Year=@FinancialYr         
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)        
)  A        
left outer join      
(      
select  HealthFacility_Code, SUM(Estimated_EC) Prv_Estimated_EC from Estimated_Data_PHC_Wise       
where Financial_Year=@FinancialYr-1  and  ( HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)   group by HealthFacility_Code      
) X      
on X.HealthFacility_Code=A.HealthFacility_Code       
left outer join        
(        
 select State_Code,HealthBlock_Code,HealthFacility_Code           
 ,SUM(Infant_Registered) as Infant_Registered          
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
from Scheduled_AC_Child_Block_PHC_Month        
where State_Code =@State_Code        
and HealthBlock_Code =@HealthBlock_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthBlock_Code,HealthFacility_Code        
 ) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code        
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
,SUM(EC_HealthIdNumber) as EC_HealthIdNumber                         
from Scheduled_AC_EC_Block_PHC_Month as EC          
where State_Code =@State_Code        
and HealthBlock_Code =@HealthBlock_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthBlock_Code,HealthFacility_Code           
 ) C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code        
left outer join        
(        
 select State_Code,HealthBlock_Code,HealthFacility_Code           
,SUM(PW_Registered) as PW_Registered          
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo          
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo           
,SUM(PW_With_Address) as PW_With_Address        
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No        
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details        
,SUM(PW_First_Trimester) as PW_First_Trimester         
,SUM(PW_High_Risk) as PW_High_Risk           
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                        
from Scheduled_AC_PW_Block_PHC_Month as PW          
where State_Code =@State_Code        
and HealthBlock_Code =@HealthBlock_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthBlock_Code,HealthFacility_Code           
 ) D on A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code      
       
  left outer join      
(      
 select  State_Code,HealthBlock_Code,HealthFacility_Code       
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(EC_HealthIdNumber) as Total_EC_HealthIdNumber               
   from Scheduled_AC_EC_Block_PHC_Month (nolock)        
 where State_Code =@State_Code      
 and HealthBlock_Code =@HealthBlock_Code         
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,HealthBlock_Code,HealthFacility_Code       
 ) E on   A.HealthBlock_Code=E.HealthBlock_Code and A.HealthFacility_Code=E.HealthFacility_Code       
       
 left outer join      
(      
select  HealthBlock_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_PHC_Wise       
where Financial_Year=@FinancialYr and ( HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) group by HealthBlock_Code      
) XEC      
on XEC.HealthBlock_Code=A.HealthBlock_Code      
left outer join      
(      
select  HealthBlock_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_PHC_Wise       
where Financial_Year=@FinancialYr-1 and ( HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) group by HealthBlock_Code      
) XE    
on XE.HealthBlock_Code=A.HealthBlock_Code      
 left outer join        
(        
--Block level distinct registration count      
 select  State_Code,HealthBlock_Code        
,SUM(total_distinct_ec) as EC_Registered_Pro          
from Scheduled_AC_EC_Block_PHC_Month as EC          
where EC.State_Code =@State_Code        
and (EC.HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthBlock_Code      
 ) CE on A.HealthBlock_Code=CE.HealthBlock_Code       
   left outer join      
(      
 select  HealthBlock_Code       
,SUM(total_distinct_ec) as Total_EC_Registered_Pro       
from Scheduled_AC_EC_Block_PHC_Month (nolock)        
 where HealthBlock_Code =@HealthBlock_Code      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by HealthBlock_Code      
 ) EP on A.HealthBlock_Code=EP.HealthBlock_Code         
 end         
else if(@Category='PHC')          
begin          
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName        
,isnull(B.Infant_Registered,0) as Infant_Registered        
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
,isnull(e.Total_EC_Registered ,0) as Total_EC_Registered        
,isnull((case when @Month_ID=0 then e.Total_EC_Registered else C.EC_Registered_Distinct  end),0) as Total_EC_Registered_2       
,isnull(C.EC_Registered,0) as EC_Registered        
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull( C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No        
,isnull( C.EC_With_Address ,0) as  EC_With_Address        
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details        
,isnull( C.EC_With_PhoneNo ,0) as EC_With_PhoneNo        
,isnull( C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo        
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children      
,isnull(D.PW_Registered,0) as  PW_Registered        
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No        
,isnull(D.PW_With_Address,0) as PW_With_Address        
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details        
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo        
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo        
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester        
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk        
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic        
,(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_Mother        
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant        
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC         
      
,ISNULL(X.Prv_Estimated_EC,0) as Prv_Estimated_EC      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(C.EC_Registered_Distinct,0)) end ),0) as Prorata      
      
      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata      
,@daysPast as daysPast        
,@Daysinyear as DaysinYear        
,ISNULL(EC_With_FamilyID,0) as EC_With_FamilyID        
,@State_Code as State_Code  
,ISNULL(C.EC_HealthIdNumber,0) as EC_HealthIdNumber 
,ISNULL(E.Total_EC_HealthIdNumber,0) as Total_EC_HealthIdNumber   
from       
(      
 select b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name      
 ,isnull([Total_Village],0) as [Total_Village]      
 ,a.Estimated_EC as Estimated_EC      
 ,a.Estimated_Mother as Estimated_Mother      
 ,a.Estimated_Infant as Estimated_Infant      
 --from Estimated_Data_SubCenter_Wise a      
 --inner join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD       
 --inner join TBL_PHC b on c.PHC_CD=b.PHC_CD      
  from Estimated_Data_SubCenter_Wise a        
   inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD        
   left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD       
 where a.Financial_Year=@FinancialYr and( b.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)      
)A       
left outer join      
(      
select  HealthSubFacility_Code, SUM(Estimated_EC) Prv_Estimated_EC from Estimated_Data_SubCenter_Wise       
where Financial_Year=@FinancialYr-1 and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) group by HealthSubFacility_Code      
) X      
on X.HealthSubFacility_Code=A.HealthSubFacility_Code       
left outer join         
(          
 select State_Code,HealthFacility_Code,HealthSubFacility_Code        
 ,SUM(Infant_Registered) as Infant_Registered          
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
from Scheduled_AC_Child_PHC_SubCenter_Month        
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code        
 ) B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code        
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
,SUM(EC_HealthIdNumber) as EC_HealthIdNumber                         
from Scheduled_AC_EC_PHC_SubCenter_Month as EC          
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code         
 ) C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code        
left outer join        
(        
 select State_Code,HealthFacility_Code,HealthSubFacility_Code        
,SUM(PW_Registered) as PW_Registered          
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo          
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo           
,SUM(PW_With_Address) as PW_With_Address        
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No        
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details         
,SUM(PW_First_Trimester) as PW_First_Trimester         
,SUM(PW_High_Risk) as PW_High_Risk           
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                       
from Scheduled_AC_PW_PHC_SubCenter_Month as PW          
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code           
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code        
 ) D on A.HealthFacility_Code=D.HealthFacility_Code and A.HealthSubFacility_Code=D.HealthSubFacility_Code       
  left outer join      
(      
 select  State_Code,HealthFacility_Code,HealthSubFacility_Code      
,SUM(total_distinct_ec) as Total_EC_Registered        
,SUM(EC_HealthIdNumber) as Total_EC_HealthIdNumber               
   from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code            
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code       
 ) E on   A.HealthFacility_Code=E.HealthFacility_Code and A.HealthSubFacility_Code=E.HealthSubFacility_Code       
  left outer join      
(      
select  HealthFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_SubCenter_Wise       
where Financial_Year=@FinancialYr and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) group by HealthFacility_Code      
) XEC      
on XEC.HealthFacility_Code=A.HealthFacility_Code      
left outer join      
(      
select  HealthFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_SubCenter_Wise       
where Financial_Year=@FinancialYr-1  and (HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0) group by HealthFacility_Code      
) XE      
on XE.HealthFacility_Code=A.HealthFacility_Code      
 left outer join        
(        
--PHC level distinct registration count      
 select  State_Code,HealthFacility_Code        
,SUM(total_distinct_ec) as EC_Registered_Pro          
from Scheduled_AC_EC_PHC_SubCenter_Month as EC          
where EC.State_Code =@State_Code        
and (EC.HealthFacility_Code=@HealthFacility_Code or @HealthFacility_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthFacility_Code      
 ) CE on A.HealthFacility_Code=CE.HealthFacility_Code       
   left outer join      
(      
 select  HealthFacility_Code       
,SUM(total_distinct_ec) as Total_EC_Registered_Pro       
from Scheduled_AC_EC_PHC_SubCenter_Month (nolock)        
 where HealthFacility_Code =@HealthFacility_Code      
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by HealthFacility_Code      
 ) EP on A.HealthFacility_Code=EP.HealthFacility_Code        
         
 end          
else if(@Category='SubCentre')          
begin          
select @State_Code,A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName        
,isnull(B.Infant_Registered,0) as Infant_Registered        
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
,isnull(e.Total_EC_Registered ,0) as Total_EC_Registered        
,isnull((case when @Month_ID=0 then e.Total_EC_Registered else C.EC_Registered_Distinct  end),0) as Total_EC_Registered_2       
,isnull(C.EC_Registered,0) as EC_Registered        
,ISNULL(C.EC_Registered_Distinct,0) as EC_Registered_Distinct      
,isnull( C.EC_With_Aadhaar_No,0) as EC_With_Aadhaar_No        
,isnull( C.EC_With_Address ,0) as  EC_With_Address        
,isnull(C.EC_With_Bank_Details,0) as EC_With_Bank_Details        
,isnull( C.EC_With_PhoneNo ,0) as EC_With_PhoneNo        
,isnull( C.EC_With_SelfPhoneNo,0) as EC_With_SelfPhoneNo        
,ISNULL(C.EC_With_No_Children,0) as EC_With_No_Children      
,ISNULL(C.EC_With_One_Children,0) as EC_With_One_Children      
,ISNULL(C.EC_With_Two_Children,0) as EC_With_Two_Children      
,ISNULL(C.EC_With_MoreThanTwo_Children,0) as EC_With_MoreThanTwo_Children       
,isnull(D.PW_Registered,0) as  PW_Registered        
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No        
,isnull(D.PW_With_Address,0) as PW_With_Address        
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details        
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo        
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo        
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester        
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk        
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic        
,(case when @Month_ID=0 then isnull(A.Estimated_Mother,0) else  isnull(A.Estimated_Mother,0)/ NULLIF(12 ,0)  end ) as Estimated_Mother        
,(case when @Month_ID=0 then isnull(A.Estimated_Infant,0) else  isnull(A.Estimated_Infant,0)/ NULLIF(12 ,0)  end ) as Estimated_Infant        
 ,(case when @Month_ID=0 then isnull(A.Estimated_EC,0) else (isnull(A.Estimated_EC,0)-ISNULL(x.Prv_Estimated_EC,0))/ NULLIF(12 ,0)   end ) as Estimated_EC         
      
,ISNULL(X.Prv_Estimated_EC,0) as Prv_Estimated_EC      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(e.Total_EC_Registered,0),@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(x.Prv_Estimated_EC,0),isnull(a.Estimated_EC,0),isnull(C.EC_Registered_Distinct,0)) end ),0) as Prorata      
      
      
,isnull( (case when @Month_ID=0 then RCH_Reports.dbo.EC_Prorata_Yearly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(ep.Total_EC_Registered_Pro,0),       
@FinancialYr) else RCH_Reports.dbo.EC_Percentage_Monthly(isnull(xe.Prv_Estimated_EC_Pro,0),isnull(xec.Estimated_EC_Pro,0),isnull(Ce.EC_Registered_Pro,0)) end ),0) as TotalProrata      
,@daysPast as daysPast        
,@Daysinyear as DaysinYear    
,ISNULL(EC_With_FamilyID,0) as EC_With_FamilyID      
,@State_Code as State_Code
,ISNULL(C.EC_HealthIdNumber,0) as EC_HealthIdNumber 
,ISNULL(E.Total_EC_HealthIdNumber,0) as Total_EC_HealthIdNumber        
from       
(      
 select   vn.SUBPHC_CD as HealthSubFacility_Code,isnull(vn.VILLAGE_CD,0) as Village_Code      
 ,sp.SUBPHC_NAME_E as  HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name      
 ,c.Estimated_EC as Estimated_EC      
 ,c.Estimated_Mother as Estimated_Mother      
 ,c.Estimated_Infant as Estimated_Infant      
 from Estimated_Data_Village_Wise  c      
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code      
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code      
 left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code       
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)      
 and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr      
       
      
)  A      
left outer join      
(      
select  Village_Code, SUM(Estimated_EC) Prv_Estimated_EC from Estimated_Data_Village_Wise       
where Financial_Year=@FinancialYr-1 group by Village_Code      
) X      
on X.Village_Code=A.Village_Code       
left outer join      
(      
 select State_Code,HealthSubFacility_Code,Village_Code        
 ,SUM(Infant_Registered) as Infant_Registered          
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
from Scheduled_AC_Child_PHC_SubCenter_Village_Month        
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code         
and HealthSubFacility_Code =@HealthSubFacility_Code             
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthSubFacility_Code,Village_Code        
 ) B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code        
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
,SUM(EC_HealthIdNumber) as EC_HealthIdNumber                         
from Scheduled_AC_EC_PHC_SubCenter_Village_Month as EC          
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code         
and HealthSubFacility_Code =@HealthSubFacility_Code             
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthSubFacility_Code,Village_Code        
 ) C on  A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code        
left outer join        
(        
 select State_Code,HealthSubFacility_Code,Village_Code        
,SUM(PW_Registered) as PW_Registered          
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo          
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo           
,SUM(PW_With_Address) as PW_With_Address        
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No        
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details        
,SUM(PW_First_Trimester) as PW_First_Trimester         
,SUM(PW_High_Risk) as PW_High_Risk           
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic                        
from Scheduled_AC_PW_PHC_SubCenter_Village_Month as PW          
where State_Code =@State_Code        
and HealthFacility_Code =@HealthFacility_Code         
and HealthSubFacility_Code =@HealthSubFacility_Code              
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthSubFacility_Code,Village_Code        
 ) D on  A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code        
  left outer join      
(      
 select  State_Code,HealthSubFacility_Code,Village_Code      
,SUM(total_distinct_ec) as Total_EC_Registered  
,SUM(EC_HealthIdNumber) as Total_EC_HealthIdNumber         
   from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)        
 where State_Code =@State_Code      
 and HealthFacility_Code =@HealthFacility_Code       
 and HealthSubFacility_Code =@HealthSubFacility_Code         
      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
group by State_Code,HealthSubFacility_Code,Village_Code       
 ) E on     A.HealthSubFacility_Code=E.HealthSubFacility_Code and A.Village_Code=E.Village_Code      
      
  left outer join      
(      
select  HealthSubFacility_Code, Sum(Estimated_EC) as Estimated_EC_Pro from Estimated_Data_Village_Wise       
where Financial_Year=@FinancialYr and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) group by HealthSubFacility_Code      
) XEC      
on XEC.HealthSubFacility_Code=A.HealthSubFacility_Code      
left outer join      
(      
select  HealthSubFacility_Code, Sum(Estimated_EC) as Prv_Estimated_EC_Pro from Estimated_Data_Village_Wise       
where Financial_Year=@FinancialYr-1  and (HealthSubFacility_Code= @HealthSubFacility_Code or @HealthSubFacility_Code=0) group by HealthSubFacility_Code      
) XE      
on XE.HealthSubFacility_Code=A.HealthSubFacility_Code      
 left outer join        
(        
--Subcenter level distinct registration count      
 select  State_Code,HealthSubFacility_Code        
,SUM(total_distinct_ec) as EC_Registered_Pro          
from Scheduled_AC_EC_PHC_SubCenter_Village_Month as EC          
where EC.State_Code =@State_Code        
and (EC.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)        
and Fin_Yr=@FinancialYr         
and (Month_ID=@Month_ID or @Month_ID=0)        
and (Year_ID=@Year_ID or @Year_ID=0)        
and Filter_Type=@Type        
 group by State_Code,HealthSubFacility_Code      
 ) CE on A.HealthSubFacility_Code=CE.HealthSubFacility_Code       
   left outer join      
(      
 select  HealthSubFacility_Code       
,SUM(total_distinct_ec) as Total_EC_Registered_Pro       
from Scheduled_AC_EC_PHC_SubCenter_Village_Month (nolock)        
 where HealthSubFacility_Code =@HealthSubFacility_Code      
and Village_Code !=0      
and (Year_ID<=@Year_ID or @Year_ID=0)      
and (Filter_Type=@Type)      
and Fin_Yr<=@FinancialYr       
 group by HealthSubFacility_Code      
 ) EP on A.HealthSubFacility_Code=EP.HealthSubFacility_Code         
 end          
        
end        
        
