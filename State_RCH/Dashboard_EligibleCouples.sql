USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Dashboard_EligibleCouples]    Script Date: 09/26/2024 11:58:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
[Dashboard_EligibleCouples] 30,1,3,11,35,0,2017,0,0,1,'Subcentre'
*/

  
ALTER Procedure [dbo].[Dashboard_EligibleCouples]  
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
as  
begin  
if(@Category='State')  
begin  
  
select A.State_Code as ParentID, A.State_Name as ParentName,A.District_Code as ChildID, A.District_Name as ChildName  
,A.Estimated_EC as Estimated_EC
,ISNULL(B.EC_Reg,0) as EC_Registered
,ISNULL(B.EC_Reg_2_Child,0) as EC_Reg_2_Child
,ISNULL(B.EC_Reg_No_Child,0) as EC_Reg_No_Child        
,ISNULL(B.EC_Reg_infertility,0) as EC_Reg_infertility 
,ISNULL(B.EC_Any_Methods,0) as EC_Any_Methods 
,ISNULL(B.EC_No_Methods,0) as EC_No_Methods 
,ISNULL(B.EC_Marked_Pregnancy,0) as EC_Marked_Pregnancy 
,ISNULL(B.EC_Total_Sterilized,0) as EC_Total_Sterilized 
,ISNULL(B.EC_Male_Sterilized,0) as EC_Male_Sterilized 
,ISNULL(B.EC_Female_Sterilized,0) as EC_Female_Sterilized 
,ISNULL(B.EC_WithPPC_IUCD,0) as EC_WithPPC_IUCD 
,ISNULL(B.EC_WithPPC_STERILIZATION,0) as EC_WithPPC_STERILIZATION 
,ISNULL(B.EC_WithPPC_CONDOM,0) as EC_WithPPC_CONDOM 
,ISNULL(B.EC_Other_Methods,0) as EC_Other_Methods 
from   
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name  
 ,c.Estimated_Mother as Estimated_Mother  
 ,c.Estimated_Infant  as Estimated_Infant  
 ,c.Estimated_EC  as Estimated_EC  
 from TBL_DISTRICT a  
 inner join TBL_STATE b on a.StateID=b.StateID  
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code  
 where c.Financial_Year=@FinancialYr   
) A  
  
left outer join   
(select State_Code, District_Code,  
SUM(EC_Registered) AS EC_Reg,  
SUM(EC_With_Two_Children) AS EC_Reg_2_Child,  
SUM(EC_With_No_Children) AS EC_Reg_No_Child,  
SUM(EC_With_Infertility) AS EC_Reg_infertility,  
0 AS EC_Any_Methods,  
SUM(ECT_With_NONE) AS EC_No_Methods,  
SUM(ECT_With_ANYS) AS EC_Other_Methods,  
SUM(EC_With_Preg_Yes) AS EC_Marked_Pregnancy,  
SUM(ECT_With_MaleStr)+SUM(ECT_With_FeMaleStr) AS EC_Total_Sterilized,  
SUM(ECT_With_MaleStr) AS EC_Male_Sterilized,  
SUM(ECT_With_FeMaleStr) AS EC_Female_Sterilized,  
SUM(EC_WithPPC_IUCD) AS EC_WithPPC_IUCD,  
SUM(EC_WithPPC_STERILIZATION) AS EC_WithPPC_STERILIZATION,  
SUM(EC_WithPPC_CONDOM) AS EC_WithPPC_CONDOM
FROM Scheduled_AC_EC_State_District_Month 
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=@Filter_Type   
GROUP BY State_Code,District_Code)B  on A.State_Code=b.State_Code and A.District_Code=B.District_Code  
end  
  
if(@Category='District')  
begin  
select A.District_Code as ParentID,A.District_Name as ParentName, A.HealthBlock_Code as ChildID, A.HealthBlock_Name as ChildName  
,A.Estimated_EC as Estimated_EC
,ISNULL(B.EC_Reg,0) as EC_Registered
,ISNULL(B.EC_Reg_2_Child,0) as EC_Reg_2_Child
,ISNULL(B.EC_Reg_No_Child,0) as EC_Reg_No_Child        
,ISNULL(B.EC_Reg_infertility,0) as EC_Reg_infertility 
,ISNULL(B.EC_Any_Methods,0) as EC_Any_Methods 
,ISNULL(B.EC_No_Methods,0) as EC_No_Methods 
,ISNULL(B.EC_Marked_Pregnancy,0) as EC_Marked_Pregnancy 
,ISNULL(B.EC_Total_Sterilized,0) as EC_Total_Sterilized 
,ISNULL(B.EC_Male_Sterilized,0) as EC_Male_Sterilized 
,ISNULL(B.EC_Female_Sterilized,0) as EC_Female_Sterilized 
,ISNULL(B.EC_WithPPC_IUCD,0) as EC_WithPPC_IUCD 
,ISNULL(B.EC_WithPPC_STERILIZATION,0) as EC_WithPPC_STERILIZATION 
,ISNULL(B.EC_WithPPC_CONDOM,0) as EC_WithPPC_CONDOM 
,ISNULL(B.EC_Other_Methods,0) as EC_Other_Methods 
  
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
Left outer Join  
(select District_Code as District_Code, HealthBlock_Code as HealthBlock_Code,  
SUM(EC_Registered) AS EC_Reg,  
SUM(EC_With_Two_Children) AS EC_Reg_2_Child,  
SUM(EC_With_No_Children) AS EC_Reg_No_Child,  
SUM(EC_With_Infertility) AS EC_Reg_infertility,  
0 AS EC_Any_Methods,  
SUM(ECT_With_NONE) AS EC_No_Methods,  
SUM(ECT_With_ANYS) AS EC_Other_Methods,  
SUM(EC_With_Preg_Yes) AS EC_Marked_Pregnancy,  
SUM(ECT_With_MaleStr)+SUM(ECT_With_FeMaleStr) AS EC_Total_Sterilized,  
SUM(ECT_With_MaleStr) AS EC_Male_Sterilized,  
SUM(ECT_With_FeMaleStr) AS EC_Female_Sterilized,  
SUM(EC_WithPPC_IUCD) AS EC_WithPPC_IUCD,  
SUM(EC_WithPPC_STERILIZATION) AS EC_WithPPC_STERILIZATION,  
SUM(EC_WithPPC_CONDOM) AS EC_WithPPC_CONDOM
 from Scheduled_AC_EC_District_Block_Month   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=@Filter_Type 
and District_Code=@District_Code  
group by District_Code,HealthBlock_Code
) B ON A.District_Code=B.District_Code and A.HealthBlock_Code= B.HealthBlock_Code  
end  
  
  
if(@Category='Block')  
begin  
select A.HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName 
,A.Estimated_EC as Estimated_EC 
,ISNULL(B.EC_Reg,0) as EC_Registered
,ISNULL(B.EC_Reg_2_Child,0) as EC_Reg_2_Child
,ISNULL(B.EC_Reg_No_Child,0) as EC_Reg_No_Child        
,ISNULL(B.EC_Reg_infertility,0) as EC_Reg_infertility 
,ISNULL(B.EC_Any_Methods,0) as EC_Any_Methods 
,ISNULL(B.EC_No_Methods,0) as EC_No_Methods 
,ISNULL(B.EC_Marked_Pregnancy,0) as EC_Marked_Pregnancy 
,ISNULL(B.EC_Total_Sterilized,0) as EC_Total_Sterilized 
,ISNULL(B.EC_Male_Sterilized,0) as EC_Male_Sterilized 
,ISNULL(B.EC_Female_Sterilized,0) as EC_Female_Sterilized 
,ISNULL(B.EC_WithPPC_IUCD,0) as EC_WithPPC_IUCD 
,ISNULL(B.EC_WithPPC_STERILIZATION,0) as EC_WithPPC_STERILIZATION 
,ISNULL(B.EC_WithPPC_CONDOM,0) as EC_WithPPC_CONDOM 
,ISNULL(B.EC_Other_Methods,0) as EC_Other_Methods 
  
 from 
 (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name  
,c.Estimated_Mother as Estimated_Mother  
,c.Estimated_Infant  as Estimated_Infant  
,c.Estimated_EC  as Estimated_EC  
from TBL_PHC  a  
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD  
inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code  
where c.Financial_Year=@FinancialYr   
and  a.BID=@HealthBlock_Code  
)A   
   
Left Outer Join   
(select HealthBlock_Code as HealthBlock_Code,HealthFacility_Code as HealthFacility_Code,  
SUM(EC_Registered) AS EC_Reg,  
SUM(EC_With_Two_Children) AS EC_Reg_2_Child,  
SUM(EC_With_No_Children) AS EC_Reg_No_Child,  
SUM(EC_With_Infertility) AS EC_Reg_infertility,  
0 AS EC_Any_Methods,  
SUM(ECT_With_NONE) AS EC_No_Methods,  
SUM(ECT_With_ANYS) AS EC_Other_Methods,  
SUM(EC_With_Preg_Yes) AS EC_Marked_Pregnancy,  
SUM(ECT_With_MaleStr)+SUM(ECT_With_FeMaleStr) AS EC_Total_Sterilized,  
SUM(ECT_With_MaleStr) AS EC_Male_Sterilized,  
SUM(ECT_With_FeMaleStr) AS EC_Female_Sterilized,  
SUM(EC_WithPPC_IUCD) AS EC_WithPPC_IUCD,  
SUM(EC_WithPPC_STERILIZATION) AS EC_WithPPC_STERILIZATION,  
SUM(EC_WithPPC_CONDOM) AS EC_WithPPC_CONDOM
from Scheduled_AC_EC_Block_PHC_Month
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=@Filter_Type 
and HealthBlock_Code=@HealthBlock_Code 
group by HealthBlock_Code,HealthFacility_Code)B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code  
  
end  
  
  
if(@Category='PHC')  
begin  
select A.HealthFacility_Code as ParentID, A.HealthFacility_Name as ParentName,A.HealthSubFacility_Code AS ChildID,A.HealthSubFacility_Name AS ChildName  
,A.Estimated_EC as Estimated_EC
,ISNULL(B.EC_Reg,0) as EC_Registered
,ISNULL(B.EC_Reg_2_Child,0) as EC_Reg_2_Child
,ISNULL(B.EC_Reg_No_Child,0) as EC_Reg_No_Child        
,ISNULL(B.EC_Reg_infertility,0) as EC_Reg_infertility 
,ISNULL(B.EC_Any_Methods,0) as EC_Any_Methods 
,ISNULL(B.EC_No_Methods,0) as EC_No_Methods 
,ISNULL(B.EC_Marked_Pregnancy,0) as EC_Marked_Pregnancy 
,ISNULL(B.EC_Total_Sterilized,0) as EC_Total_Sterilized 
,ISNULL(B.EC_Male_Sterilized,0) as EC_Male_Sterilized 
,ISNULL(B.EC_Female_Sterilized,0) as EC_Female_Sterilized 
,ISNULL(B.EC_WithPPC_IUCD,0) as EC_WithPPC_IUCD 
,ISNULL(B.EC_WithPPC_STERILIZATION,0) as EC_WithPPC_STERILIZATION 
,ISNULL(B.EC_WithPPC_CONDOM,0) as EC_WithPPC_CONDOM 
,ISNULL(B.EC_Other_Methods,0) as EC_Other_Methods      
  
  
 from   
(select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name,isnull([Total_Village],0) as [Total_Village],isnull([Total_Profile_Entered],1)as [Total_Profile_Entered]
,a.Estimated_EC as Estimated_EC
,a.Estimated_Mother as Estimated_Mother
,a.Estimated_Infant as Estimated_Infant
from Estimated_Data_SubCenter_Wise a
inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD
left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD 
where a.Financial_Year=@FinancialYr 
and a.HealthFacility_Code= @HealthFacility_Code
)A  
Left Outer Join  
(  
select HealthFacility_Code,HealthSubFacility_Code,  
SUM(EC_Registered) AS EC_Reg,  
SUM(EC_With_Two_Children) AS EC_Reg_2_Child,  
SUM(EC_With_No_Children) AS EC_Reg_No_Child,  
SUM(EC_With_Infertility) AS EC_Reg_infertility,  
0 AS EC_Any_Methods,  
SUM(ECT_With_NONE) AS EC_No_Methods,  
SUM(ECT_With_ANYS) AS EC_Other_Methods,  
SUM(EC_With_Preg_Yes) AS EC_Marked_Pregnancy,  
SUM(ECT_With_MaleStr)+SUM(ECT_With_FeMaleStr) AS EC_Total_Sterilized,  
SUM(ECT_With_MaleStr) AS EC_Male_Sterilized,  
SUM(ECT_With_FeMaleStr) AS EC_Female_Sterilized,  
SUM(EC_WithPPC_IUCD) AS EC_WithPPC_IUCD,  
SUM(EC_WithPPC_STERILIZATION) AS EC_WithPPC_STERILIZATION,  
SUM(EC_WithPPC_CONDOM) AS EC_WithPPC_CONDOM
 from Scheduled_AC_EC_PHC_SubCenter_Month      
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=@Filter_Type 
and HealthFacility_Code=@HealthFacility_Code
group by HealthFacility_Code,HealthSubFacility_Code)B on A.HealthSubFacility_Code=B.HealthSubFacility_Code  
end  
  
if(@Category='Subcentre')  
begin  
select A.HealthSubFacility_Code as ParentID,A.HealthSubFacility_Name as ParentName,A.Village_Code as ChildID,A.Village_Name as ChildName  
,A.Estimated_EC as Estimated_EC
,ISNULL(B.EC_Reg,0) as EC_Registered
,ISNULL(B.EC_Reg_2_Child,0) as EC_Reg_2_Child
,ISNULL(B.EC_Reg_No_Child,0) as EC_Reg_No_Child        
,ISNULL(B.EC_Reg_infertility,0) as EC_Reg_infertility 
,ISNULL(B.EC_Any_Methods,0) as EC_Any_Methods 
,ISNULL(B.EC_No_Methods,0) as EC_No_Methods 
,ISNULL(B.EC_Marked_Pregnancy,0) as EC_Marked_Pregnancy 
,ISNULL(B.EC_Total_Sterilized,0) as EC_Total_Sterilized 
,ISNULL(B.EC_Male_Sterilized,0) as EC_Male_Sterilized 
,ISNULL(B.EC_Female_Sterilized,0) as EC_Female_Sterilized 
,ISNULL(B.EC_WithPPC_IUCD,0) as EC_WithPPC_IUCD 
,ISNULL(B.EC_WithPPC_STERILIZATION,0) as EC_WithPPC_STERILIZATION 
,ISNULL(B.EC_WithPPC_CONDOM,0) as EC_WithPPC_CONDOM 
,ISNULL(B.EC_Other_Methods,0) as EC_Other_Methods 
from   
(select c.State_Code,  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code
,sp.SUBPHC_NAME_E as HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name
,c.Estimated_EC as Estimated_EC
,c.Estimated_Mother as Estimated_Mother
,c.Estimated_Infant as Estimated_Infant
from Estimated_Data_Village_Wise  c
left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code
left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code
left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code 
where sp.SUBPHC_CD=@HealthSubFacility_Code
and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) 
and c.Financial_Year=@FinancialYr
)  A  
 Left Outer Join  
 (select HealthSubFacility_Code,Village_Code,  
SUM(EC_Registered) AS EC_Reg,  
SUM(EC_With_Two_Children) AS EC_Reg_2_Child,  
SUM(EC_With_No_Children) AS EC_Reg_No_Child,  
SUM(EC_With_Infertility) AS EC_Reg_infertility,  
0 AS EC_Any_Methods,  
SUM(ECT_With_NONE) AS EC_No_Methods,  
SUM(ECT_With_ANYS) AS EC_Other_Methods,  
SUM(EC_With_Preg_Yes) AS EC_Marked_Pregnancy,  
SUM(ECT_With_MaleStr)+SUM(ECT_With_FeMaleStr) AS EC_Total_Sterilized,  
SUM(ECT_With_MaleStr) AS EC_Male_Sterilized,  
SUM(ECT_With_FeMaleStr) AS EC_Female_Sterilized,  
SUM(EC_WithPPC_IUCD) AS EC_WithPPC_IUCD,  
SUM(EC_WithPPC_STERILIZATION) AS EC_WithPPC_STERILIZATION,  
SUM(EC_WithPPC_CONDOM) AS EC_WithPPC_CONDOM
 from Scheduled_AC_EC_PHC_SubCenter_Village_Month   
WHERE Fin_Yr=@FinancialYr 
and (Year_ID=@Year_ID or @Year_ID=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and Filter_Type=@Filter_Type 
and HealthSubFacility_Code=@HealthSubFacility_Code
group by HealthSubFacility_Code,Village_Code)B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code  
  
end  
end



