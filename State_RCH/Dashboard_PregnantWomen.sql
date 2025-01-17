USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_PregnantWomen]    Script Date: 09/26/2024 11:58:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
Dashboard_PregnantWomen 30,1,3,11,35,44,2017,0,1,1,'Subcentre'
*/

ALTER PROCEDURE [dbo].[Dashboard_PregnantWomen]
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
@Filter_Type int=0,
@Category varchar(20) 
)	
AS
BEGIN
if(@Category='State')
begin

select A.State_Code as ParentID, A.State_Name as ParentName,A.District_Code as ChildID, A.District_Name as ChildName,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
ISNULL(PW_Delivery_Due,0) as PW_Due_Delivery,
isnull(PW_Registered_1st_Trimester,0)as PW_Registered_1st_Trimester,
isnull(Del_Public,0) as Delivery_Public,
isnull(Del_Private,0) as Delivery_Private,       
isnull(Del_Home,0) as Delivery_Home, 
isnull(PW_Atleast_4PNC,0) as PW_Atleast_4PNC, 
isnull(PW_Atleast_4PNC_Within42Days,0) as PW_Atleast_4PNC_Within42Days, 
isnull(PW_No_PNC,0) as PW_No_PNC, 
isnull(PW_HighRisk,0) as PW_HighRisk, 
isnull(PW_SevereAnemic,0) as PW_SevereAnemic, 
isnull(PW_Registered,0) as PW_Registered, 
isnull(PW_With_Any_3_ANC,0) as PW_AtLeast3ANC_Delivered, 
isnull(PW_IFA_Due,0) as PW_IFA_Due, 
isnull(PW_IFA_Delivered,0) as PW_IFA_Delivered, 
isnull(PW_FullANC_Due,0) as PW_FullANC_Due, 
isnull(PW_FullANC_Delivered,0) as PW_FullANC_Delivered, 
isnull(PW_ANC1_Due,0) as PW_ANC1_Due, 
isnull(PW_ANC1_Delivered,0) as PW_ANC1_Delivered, 
isnull(PW_ANC2_Due,0) as PW_ANC2_Due, 
isnull(PW_ANC2_Delivered,0) as PW_ANC2_Delivered, 
isnull(PW_ANC3_Due,0) as PW_ANC3_Due, 
isnull(PW_ANC3_Delivered,0) as PW_ANC3_Delivered, 
isnull(PW_ANC4_Due,0) as PW_ANC4_Due, 
isnull(PW_ANC4_Delivered,0) as PW_ANC4_Delivered,
isnull(PW_Total_MD,0) as PW_Total_MD, 
isnull(ANC_MD_Total,0) as MD_Total_ANC, 
isnull(Del_MD_Total,0) as MD_Total_Delivery, 
isnull(PNC_MD_Total,0) as MD_Total_PNC

from 
(
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name  
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant  as Estimated_Infant  
 ,c.Estimated_EC  as Estimated_EC  
 from TBL_DISTRICT a  
 inner join TBL_STATE b on a.StateID=b.StateID  
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code  
 where c.Financial_Year=@FinancialYr
 ) A
left outer join
(select State_Code as State_Code, District_Code as District_Code,
SUM(PW_Registered)as PW_Registered,
SUM(PW_First_Trimester)as PW_Registered_1st_Trimester,
SUM(PW_High_Risk) as PW_HighRisk,
SUM(PW_Severe_Anaemic) as PW_SevereAnemic,
SUM(PW_MD_Total) as PW_Total_MD,
SUM(ANC_MD_Total) as ANC_MD_Total,
SUM(Del_MD_Total) as Del_MD_Total,
SUM(PNC_MD_Total) as PNC_MD_Total,
SUM(PW_With_Any_3_ANC) AS PW_With_Any_3_ANC
FROM Scheduled_AC_PW_State_District_Month 
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=1 
GROUP BY State_Code,District_Code) B  on A.State_Code=b.State_Code and A.District_Code=B.District_Code
left outer join
(select State_Code as State_Code, District_Code as District_Code,
SUM(PW_Registered) AS PW_Delivery_Due,
SUM(Del_Public) AS Del_Public,
SUM(Del_Private) AS Del_Private,
SUM(Del_Rep_at_Home) AS Del_Home,
SUM(PW_With_4_PNC) AS PW_Atleast_4PNC,
SUM(PW_4_PNC_Within42D) AS PW_Atleast_4PNC_Within42Days,
SUM(PW_With_No_PNC) AS PW_No_PNC
FROM Scheduled_AC_PW_State_District_Month 
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=2
GROUP BY State_Code,District_Code) C  on A.State_Code=C.State_Code and A.District_Code=C.District_Code
left outer join
(select State_ID as  State_Code,District_ID as District_Code
,SUM(IFA_D_Count)as PW_IFA_Due
,SUM(IFA_G_Count) AS PW_IFA_Delivered
,SUM(ANC4_D_Count) AS PW_FullANC_Due
,0 AS PW_FullANC_Delivered
,0 AS PW_AtLeast3ANC_Due
,SUM(ANC1_D_Count) AS PW_ANC1_Due
,SUM(ANC1_G_Count) AS PW_ANC1_Delivered
,SUM(ANC2_D_Count) AS PW_ANC2_Due
,SUM(ANC2_G_Count) AS PW_ANC2_Delivered
,SUM(ANC3_D_Count) AS PW_ANC3_Due
,SUM(ANC3_G_Count) AS PW_ANC3_Delivered
,SUM(ANC4_D_Count) AS PW_ANC4_Due
,SUM(ANC4_G_Count) AS PW_ANC4_Delivered
FROM Scheduled_MW_State_District_Monthwise 
WHERE Fin_Yr=@FinancialYr 
GROUP BY State_ID,District_ID) D  on A.State_Code=D.State_Code and A.District_Code=D.District_Code
end	

if(@Category='District')
begin

select A.District_Code as ParentID, A.District_Name as ParentName,A.HealthBlock_Code as ChildID, A.HealthBlock_Name as ChildName,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
ISNULL(PW_Delivery_Due,0) as PW_Due_Delivery,
isnull(PW_Registered_1st_Trimester,0)as PW_Registered_1st_Trimester,
isnull(Del_Public,0) as Delivery_Public,
isnull(Del_Private,0) as Delivery_Private,       
isnull(Del_Home,0) as Delivery_Home, 
isnull(PW_Atleast_4PNC,0) as PW_Atleast_4PNC, 
isnull(PW_Atleast_4PNC_Within42Days,0) as PW_Atleast_4PNC_Within42Days, 
isnull(PW_No_PNC,0) as PW_No_PNC, 
isnull(PW_HighRisk,0) as PW_HighRisk, 
isnull(PW_SevereAnemic,0) as PW_SevereAnemic, 
isnull(PW_Registered,0) as PW_Registered, 
isnull(PW_With_Any_3_ANC,0) as PW_AtLeast3ANC_Delivered, 
isnull(PW_IFA_Due,0) as PW_IFA_Due, 
isnull(PW_IFA_Delivered,0) as PW_IFA_Delivered, 
isnull(PW_FullANC_Due,0) as PW_FullANC_Due, 
isnull(PW_FullANC_Delivered,0) as PW_FullANC_Delivered, 
isnull(PW_ANC1_Due,0) as PW_ANC1_Due, 
isnull(PW_ANC1_Delivered,0) as PW_ANC1_Delivered, 
isnull(PW_ANC2_Due,0) as PW_ANC2_Due, 
isnull(PW_ANC2_Delivered,0) as PW_ANC2_Delivered, 
isnull(PW_ANC3_Due,0) as PW_ANC3_Due, 
isnull(PW_ANC3_Delivered,0) as PW_ANC3_Delivered, 
isnull(PW_ANC4_Due,0) as PW_ANC4_Due, 
isnull(PW_ANC4_Delivered,0) as PW_ANC4_Delivered,
isnull(PW_Total_MD,0) as PW_Total_MD, 
isnull(ANC_MD_Total,0) as MD_Total_ANC, 
isnull(Del_MD_Total,0) as MD_Total_Delivery, 
isnull(PNC_MD_Total,0) as MD_Total_PNC
from 
(
select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name   
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant  as Estimated_Infant  
 ,c.Estimated_EC  as Estimated_EC  
 from TBL_HEALTH_BLOCK a  
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD  
 inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code  
 where c.Financial_Year=@FinancialYr   
 and a.DISTRICT_CD=@District_Code
 )A 
left outer join 
(select District_Code as District_Code, HealthBlock_Code as HealthBlock_Code,  
SUM(PW_Registered)as PW_Registered,
SUM(PW_First_Trimester)as PW_Registered_1st_Trimester,
SUM(PW_High_Risk) as PW_HighRisk,
SUM(PW_Severe_Anaemic) as PW_SevereAnemic,
SUM(PW_MD_Total) as PW_Total_MD,
SUM(ANC_MD_Total) as ANC_MD_Total,
SUM(Del_MD_Total) as Del_MD_Total,
SUM(PNC_MD_Total) as PNC_MD_Total,
SUM(PW_With_Any_3_ANC) AS PW_With_Any_3_ANC
 from Scheduled_AC_PW_District_Block_Month   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=1  
and District_Code=@District_Code 
group by District_Code,HealthBlock_Code) B  on A.District_Code=B.District_Code and A.HealthBlock_Code= B.HealthBlock_Code
left outer join 
(select District_Code as District_Code, HealthBlock_Code as HealthBlock_Code,  
SUM(PW_Registered) AS PW_Delivery_Due,
SUM(Del_Public) AS Del_Public,
SUM(Del_Private) AS Del_Private,
SUM(Del_Rep_at_Home) AS Del_Home,
SUM(PW_With_4_PNC) AS PW_Atleast_4PNC,
SUM(PW_4_PNC_Within42D) AS PW_Atleast_4PNC_Within42Days,
SUM(PW_With_No_PNC) AS PW_No_PNC
 from Scheduled_AC_PW_District_Block_Month   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=2
and District_Code=@District_Code   
group by District_Code,HealthBlock_Code) C  on A.District_Code=C.District_Code and A.HealthBlock_Code= C.HealthBlock_Code
left outer join 
(select District_ID as District_Code, HealthBlock_ID as HealthBlock_Code 
,SUM(IFA_D_Count)as PW_IFA_Due
,SUM(IFA_G_Count) AS PW_IFA_Delivered
,SUM(ANC4_D_Count) AS PW_FullANC_Due
,0 AS PW_FullANC_Delivered
,0 AS PW_AtLeast3ANC_Due
,SUM(ANC1_D_Count) AS PW_ANC1_Due
,SUM(ANC1_G_Count) AS PW_ANC1_Delivered
,SUM(ANC2_D_Count) AS PW_ANC2_Due
,SUM(ANC2_G_Count) AS PW_ANC2_Delivered
,SUM(ANC3_D_Count) AS PW_ANC3_Due
,SUM(ANC3_G_Count) AS PW_ANC3_Delivered
,SUM(ANC4_D_Count) AS PW_ANC4_Due
,SUM(ANC4_G_Count) AS PW_ANC4_Delivered
FROM Scheduled_MW_District_Block_Monthwise   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and District_ID=@District_Code
group by District_ID,HealthBlock_ID) D  on A.District_Code=D.District_Code and A.HealthBlock_Code= D.HealthBlock_Code
end	
if(@Category='Block')
begin

select A.HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
ISNULL(PW_Delivery_Due,0) as PW_Due_Delivery,
isnull(PW_Registered_1st_Trimester,0)as PW_Registered_1st_Trimester,
isnull(Del_Public,0) as Delivery_Public,
isnull(Del_Private,0) as Delivery_Private,       
isnull(Del_Home,0) as Delivery_Home, 
isnull(PW_Atleast_4PNC,0) as PW_Atleast_4PNC, 
isnull(PW_Atleast_4PNC_Within42Days,0) as PW_Atleast_4PNC_Within42Days, 
isnull(PW_No_PNC,0) as PW_No_PNC, 
isnull(PW_HighRisk,0) as PW_HighRisk, 
isnull(PW_SevereAnemic,0) as PW_SevereAnemic, 
isnull(PW_Registered,0) as PW_Registered, 
isnull(PW_With_Any_3_ANC,0) as PW_AtLeast3ANC_Delivered, 
isnull(PW_IFA_Due,0) as PW_IFA_Due, 
isnull(PW_IFA_Delivered,0) as PW_IFA_Delivered, 
isnull(PW_FullANC_Due,0) as PW_FullANC_Due, 
isnull(PW_FullANC_Delivered,0) as PW_FullANC_Delivered, 
isnull(PW_ANC1_Due,0) as PW_ANC1_Due, 
isnull(PW_ANC1_Delivered,0) as PW_ANC1_Delivered, 
isnull(PW_ANC2_Due,0) as PW_ANC2_Due, 
isnull(PW_ANC2_Delivered,0) as PW_ANC2_Delivered, 
isnull(PW_ANC3_Due,0) as PW_ANC3_Due, 
isnull(PW_ANC3_Delivered,0) as PW_ANC3_Delivered, 
isnull(PW_ANC4_Due,0) as PW_ANC4_Due, 
isnull(PW_ANC4_Delivered,0) as PW_ANC4_Delivered,
isnull(PW_Total_MD,0) as PW_Total_MD, 
isnull(ANC_MD_Total,0) as MD_Total_ANC, 
isnull(Del_MD_Total,0) as MD_Total_Delivery, 
isnull(PNC_MD_Total,0) as MD_Total_PNC
from 
(
select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name  
,c.Estimated_Mother as Estimated_Mother  
,c.Estimated_Infant  as Estimated_Infant  
,c.Estimated_EC  as Estimated_EC  
from TBL_PHC  a  
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD  
inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code  
where c.Financial_Year=@FinancialYr   
and  a.BID=@HealthBlock_Code 
)A 
left outer join 
(select HealthBlock_Code as HealthBlock_Code,HealthFacility_Code as HealthFacility_Code,  
SUM(PW_Registered)as PW_Registered,
SUM(PW_First_Trimester)as PW_Registered_1st_Trimester,
SUM(PW_High_Risk) as PW_HighRisk,
SUM(PW_Severe_Anaemic) as PW_SevereAnemic,
SUM(PW_MD_Total) as PW_Total_MD,
SUM(ANC_MD_Total) as ANC_MD_Total,
SUM(Del_MD_Total) as Del_MD_Total,
SUM(PNC_MD_Total) as PNC_MD_Total,
SUM(PW_With_Any_3_ANC) AS PW_With_Any_3_ANC
from Scheduled_AC_PW_Block_PHC_Month
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=1
and  HealthBlock_Code=@HealthBlock_Code
group by HealthBlock_Code,HealthFacility_Code) B  on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code
left outer join 
(select HealthBlock_Code as HealthBlock_Code,HealthFacility_Code as HealthFacility_Code,  
SUM(PW_Registered) AS PW_Delivery_Due,
SUM(Del_Public) AS Del_Public,
SUM(Del_Private) AS Del_Private,
SUM(Del_Rep_at_Home) AS Del_Home,
SUM(PW_With_4_PNC) AS PW_Atleast_4PNC,
SUM(PW_4_PNC_Within42D) AS PW_Atleast_4PNC_Within42Days,
SUM(PW_With_No_PNC) AS PW_No_PNC
from Scheduled_AC_PW_Block_PHC_Month
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=2
and  HealthBlock_Code=@HealthBlock_Code
group by HealthBlock_Code,HealthFacility_Code) C  on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code
left outer join 
(select HealthBlock_ID as HealthBlock_Code,PHC_ID as HealthFacility_Code  
,SUM(IFA_D_Count)as PW_IFA_Due
,SUM(IFA_G_Count) AS PW_IFA_Delivered
,SUM(ANC4_D_Count) AS PW_FullANC_Due
,0 AS PW_FullANC_Delivered
,0 AS PW_AtLeast3ANC_Due
,SUM(ANC1_D_Count) AS PW_ANC1_Due
,SUM(ANC1_G_Count) AS PW_ANC1_Delivered
,SUM(ANC2_D_Count) AS PW_ANC2_Due
,SUM(ANC2_G_Count) AS PW_ANC2_Delivered
,SUM(ANC3_D_Count) AS PW_ANC3_Due
,SUM(ANC3_G_Count) AS PW_ANC3_Delivered
,SUM(ANC4_D_Count) AS PW_ANC4_Due
,SUM(ANC4_G_Count) AS PW_ANC4_Delivered
FROM Scheduled_MW_Block_PHC_Monthwise   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and HealthBlock_ID=@HealthBlock_Code
group by HealthBlock_ID,PHC_ID) D  on A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code
end
if(@Category='PHC')
begin

select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
ISNULL(PW_Delivery_Due,0) as PW_Due_Delivery,
isnull(PW_Registered_1st_Trimester,0)as PW_Registered_1st_Trimester,
isnull(Del_Public,0) as Delivery_Public,
isnull(Del_Private,0) as Delivery_Private,       
isnull(Del_Home,0) as Delivery_Home, 
isnull(PW_Atleast_4PNC,0) as PW_Atleast_4PNC, 
isnull(PW_Atleast_4PNC_Within42Days,0) as PW_Atleast_4PNC_Within42Days, 
isnull(PW_No_PNC,0) as PW_No_PNC, 
isnull(PW_HighRisk,0) as PW_HighRisk, 
isnull(PW_SevereAnemic,0) as PW_SevereAnemic, 
isnull(PW_Registered,0) as PW_Registered, 
isnull(PW_With_Any_3_ANC,0) as PW_AtLeast3ANC_Delivered, 
isnull(PW_IFA_Due,0) as PW_IFA_Due, 
isnull(PW_IFA_Delivered,0) as PW_IFA_Delivered, 
isnull(PW_FullANC_Due,0) as PW_FullANC_Due, 
isnull(PW_FullANC_Delivered,0) as PW_FullANC_Delivered, 
isnull(PW_ANC1_Due,0) as PW_ANC1_Due, 
isnull(PW_ANC1_Delivered,0) as PW_ANC1_Delivered, 
isnull(PW_ANC2_Due,0) as PW_ANC2_Due, 
isnull(PW_ANC2_Delivered,0) as PW_ANC2_Delivered, 
isnull(PW_ANC3_Due,0) as PW_ANC3_Due, 
isnull(PW_ANC3_Delivered,0) as PW_ANC3_Delivered, 
isnull(PW_ANC4_Due,0) as PW_ANC4_Due, 
isnull(PW_ANC4_Delivered,0) as PW_ANC4_Delivered,
isnull(PW_Total_MD,0) as PW_Total_MD, 
isnull(ANC_MD_Total,0) as MD_Total_ANC, 
isnull(Del_MD_Total,0) as MD_Total_Delivery, 
isnull(PNC_MD_Total,0) as MD_Total_PNC
from 
(
select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name
,isnull([Total_Village],0) as [Total_Village],isnull([Total_Profile_Entered],1)as [Total_Profile_Entered]
,a.Estimated_EC as Estimated_EC
,a.Estimated_Mother as Estimated_Mother
,a.Estimated_Infant as Estimated_Infant
from Estimated_Data_SubCenter_Wise a
inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD
left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD 
where a.Financial_Year=@FinancialYr 
and a.HealthFacility_Code= @HealthFacility_Code)A 
left outer join 
(select HealthFacility_Code as HealthFacility_Code,HealthSubFacility_Code as HealthSubFacility_Code,
SUM(PW_Registered)as PW_Registered,
SUM(PW_First_Trimester)as PW_Registered_1st_Trimester,
SUM(PW_High_Risk) as PW_HighRisk,
SUM(PW_Severe_Anaemic) as PW_SevereAnemic,
SUM(PW_MD_Total) as PW_Total_MD,
SUM(ANC_MD_Total) as ANC_MD_Total,
SUM(Del_MD_Total) as Del_MD_Total,
SUM(PNC_MD_Total) as PNC_MD_Total,
SUM(PW_With_Any_3_ANC) AS PW_With_Any_3_ANC
 from Scheduled_AC_PW_PHC_SubCenter_Month      
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=1
and  HealthFacility_Code=@HealthFacility_Code
group by HealthFacility_Code,HealthSubFacility_Code) B on A.HealthFacility_Code=B.HealthFacility_Code  and A.HealthSubFacility_Code=B.HealthSubFacility_Code
left outer join 
(select HealthFacility_Code as HealthFacility_Code,HealthSubFacility_Code as HealthSubFacility_Code,
SUM(PW_Registered) AS PW_Delivery_Due,
SUM(Del_Public) AS Del_Public,
SUM(Del_Private) AS Del_Private,
SUM(Del_Rep_at_Home) AS Del_Home,
SUM(PW_With_4_PNC) AS PW_Atleast_4PNC,
SUM(PW_4_PNC_Within42D) AS PW_Atleast_4PNC_Within42Days,
SUM(PW_With_No_PNC) AS PW_No_PNC
 from Scheduled_AC_PW_PHC_SubCenter_Month      
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=2 
group by HealthFacility_Code,HealthSubFacility_Code) C on A.HealthFacility_Code=C.HealthFacility_Code  and A.HealthSubFacility_Code=C.HealthSubFacility_Code
left outer join 
(select PHC_ID as HealthFacility_Code,SubCentre_ID as HealthSubFacility_Code
,SUM(IFA_D_Count)as PW_IFA_Due
,SUM(IFA_G_Count) AS PW_IFA_Delivered
,SUM(ANC4_D_Count) AS PW_FullANC_Due
,0 AS PW_FullANC_Delivered
,0 AS PW_AtLeast3ANC_Due
,SUM(ANC1_D_Count) AS PW_ANC1_Due
,SUM(ANC1_G_Count) AS PW_ANC1_Delivered
,SUM(ANC2_D_Count) AS PW_ANC2_Due
,SUM(ANC2_G_Count) AS PW_ANC2_Delivered
,SUM(ANC3_D_Count) AS PW_ANC3_Due
,SUM(ANC3_G_Count) AS PW_ANC3_Delivered
,SUM(ANC4_D_Count) AS PW_ANC4_Due
,SUM(ANC4_G_Count) AS PW_ANC4_Delivered
FROM Scheduled_MW_PHC_SubCentre_Monthwise        
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
group by PHC_ID,SubCentre_ID) D on A.HealthFacility_Code=D.HealthFacility_Code  and A.HealthSubFacility_Code=D.HealthSubFacility_Code
end		
if(@Category='Subcentre')
begin

select A.HealthSubFacility_Code as ParentID,A.HealthSubFacility_Name as ParentName,A.Village_Code as ChildID,A.Village_Name as ChildName,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
A.Estimated_EC as Estimated_EC,
A.Estimated_Mother as Estimated_Mother,
ISNULL(PW_Delivery_Due,0) as PW_Due_Delivery,
isnull(PW_Registered_1st_Trimester,0)as PW_Registered_1st_Trimester,
isnull(Del_Public,0) as Delivery_Public,
isnull(Del_Private,0) as Delivery_Private,       
isnull(Del_Home,0) as Delivery_Home, 
isnull(PW_Atleast_4PNC,0) as PW_Atleast_4PNC, 
isnull(PW_Atleast_4PNC_Within42Days,0) as PW_Atleast_4PNC_Within42Days, 
isnull(PW_No_PNC,0) as PW_No_PNC, 
isnull(PW_HighRisk,0) as PW_HighRisk, 
isnull(PW_SevereAnemic,0) as PW_SevereAnemic, 
isnull(PW_Registered,0) as PW_Registered, 
isnull(PW_With_Any_3_ANC,0) as PW_AtLeast3ANC_Delivered, 
0 as PW_IFA_Due, 
0 as PW_IFA_Delivered, 
0 as PW_FullANC_Due, 
0 as PW_FullANC_Delivered, 
0 as PW_ANC1_Due, 
0 as PW_ANC1_Delivered, 
0 as PW_ANC2_Due, 
0 as PW_ANC2_Delivered, 
0 as PW_ANC3_Due, 
0 as PW_ANC3_Delivered, 
0 as PW_ANC4_Due, 
0 as PW_ANC4_Delivered,
isnull(PW_Total_MD,0) as PW_Total_MD, 
isnull(ANC_MD_Total,0) as MD_Total_ANC, 
isnull(Del_MD_Total,0) as MD_Total_Delivery, 
isnull(PNC_MD_Total,0) as MD_Total_PNC
from 
(
select a.State_Code,a.HealthSubFacility_Code as HealthSubFacility_Code,sp.SUBPHC_NAME_E as HealthSubFacility_Name
,isnull(a.Village_Code,0) as Village_Code,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name
,0 as [Total_Village],0 as [Total_Profile_Entered]
,a.Estimated_EC as Estimated_EC
,a.Estimated_Mother as Estimated_Mother
,a.Estimated_Infant as Estimated_Infant
from Estimated_Data_Village_Wise a
left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=a.Village_Code and vn.SUBPHC_CD=a.HealthSubFacility_Code
left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=a.HealthSubFacility_Code 
where a.Financial_Year=@FinancialYr 
and a.HealthSubFacility_Code= @HealthSubFacility_Code)A 
left outer join 
(select HealthSubFacility_Code as HealthSubFacility_Code,Village_Code as Village_Code,
SUM(PW_Registered)as PW_Registered,
SUM(PW_First_Trimester)as PW_Registered_1st_Trimester,
SUM(PW_High_Risk) as PW_HighRisk,
SUM(PW_Severe_Anaemic) as PW_SevereAnemic,
SUM(PW_MD_Total) as PW_Total_MD,
SUM(ANC_MD_Total) as ANC_MD_Total,
SUM(Del_MD_Total) as Del_MD_Total,
SUM(PNC_MD_Total) as PNC_MD_Total,
SUM(PW_With_Any_3_ANC) AS PW_With_Any_3_ANC
 from Scheduled_AC_PW_PHC_SubCenter_Village_Month      
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=1
and  HealthSubFacility_Code=@HealthSubFacility_Code
group by HealthSubFacility_Code,Village_Code) B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code
left outer join 
(select HealthSubFacility_Code as HealthSubFacility_Code,Village_Code as Village_Code,
SUM(PW_Registered) AS PW_Delivery_Due,
SUM(Del_Public) AS Del_Public,
SUM(Del_Private) AS Del_Private,
SUM(Del_Rep_at_Home) AS Del_Home,
SUM(PW_With_4_PNC) AS PW_Atleast_4PNC,
SUM(PW_4_PNC_Within42D) AS PW_Atleast_4PNC_Within42Days,
SUM(PW_With_No_PNC) AS PW_No_PNC
 from Scheduled_AC_PW_PHC_SubCenter_Village_Month      
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=2 
group by HealthSubFacility_Code,Village_Code) C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code
--left outer join 
--(select HealthSubFacility_Code as HealthSubFacility_Code,Village_Code as Village_Code
--,SUM(IFA_D_Count)as PW_IFA_Due
--,SUM(IFA_G_Count) AS PW_IFA_Delivered
--,SUM(ANC4_D_Count) AS PW_FullANC_Due
--,0 AS PW_FullANC_Delivered
--,0 AS PW_AtLeast3ANC_Due
--,SUM(ANC1_D_Count) AS PW_ANC1_Due
--,SUM(ANC1_G_Count) AS PW_ANC1_Delivered
--,SUM(ANC2_D_Count) AS PW_ANC2_Due
--,SUM(ANC2_G_Count) AS PW_ANC2_Delivered
--,SUM(ANC3_D_Count) AS PW_ANC3_Due
--,SUM(ANC3_G_Count) AS PW_ANC3_Delivered
--,SUM(ANC4_D_Count) AS PW_ANC4_Due
--,SUM(ANC4_G_Count) AS PW_ANC4_Delivered
--FROM Scheduled_MW_PHC_SubCentre_Monthwise        
--WHERE Fin_Yr=@FinancialYr 
--and (Year_ID=@Year_ID or @Year_ID=0)
--and (Month_ID=@Month_ID or @Month_ID=0)
--group by PHC_ID,SubCentre_ID) D on A.HealthFacility_Code=D.HealthFacility_Code  and A.HealthSubFacility_Code=D.HealthSubFacility_Code
end	
END

