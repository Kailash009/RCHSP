USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[GM_NA_Mother_Child_Key_Indicator]    Script Date: 09/26/2024 12:06:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
GM_NA_Mother_Child_Key_Indicator 6,0,0,0,0,0,2017,0,0,'State',2

GM_NA_Mother_Child_Key_Indicator 6,21,0,0,0,0,2017,0,0,'District',2
*/
ALTER procedure [dbo].[GM_NA_Mother_Child_Key_Indicator]-- for niti aayog
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
@Category varchar(20) ='District'  ,
@Type int =2  --pass 2
)
as
begin

if(@Category='State')  
begin  
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName
,isnull(B.Infant_Registered,0) as Infant_Registered
,isnull(B.Children_Registered,0) as Children_Registered
,isnull(B.Child_With_FULLIMMU,0) as Child_With_FULLIMMU
,isnull(B.Child_With_RECEIVEDALL,0) as Child_With_RECEIVEDALL
,isnull(C.PW_Registered,0) as PW_Registered
,isnull(C.PW_First_Trimester,0) as PW_First_Trimester
,isnull(C.PW_HR_Del_Institutional,0) as PW_HR_Del_Institutional
,ISNULL(A.Estimated_Mother,0) as Estimated_Mother
,isnull(A.Estimated_Infant,0) as Estimated_Infant
from
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name
, isnull(c.Estimated_Infant,0)as Estimated_Infant, isnull(c.Estimated_Mother,0)as Estimated_Mother
from TBL_DISTRICT a
inner join TBL_STATE b on a.StateID=b.StateID
left outer join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code
where c.Financial_Year=@FinancialYr and a.Is_Backward=1
and b.StateID=@State_Code and (a.DIST_CD=@District_Code or @District_Code=0)
)  A
left outer join
(
 select  CH.State_Code,CH.District_Code 
,SUM(Infant_Registered) as Infant_Registered  
,SUM(Child_T)+SUM(Child_P) AS Children_Registered  
,SUM(Child_With_FULLIMMU) as Child_With_FULLIMMU   
,SUM(Child_With_RECEIVEDALL) as Child_With_RECEIVEDALL
from Scheduled_AC_Child_State_District_Month as CH  
 where CH.State_Code =@State_Code
 and (CH.District_Code=@District_Code or @District_Code=0)
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and (Filter_Type=@Type)
and Fin_Yr=@FinancialYr 
 group by CH.State_Code,CH.District_Code
 ) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code
left outer join
(
 select  PW.State_Code,PW.District_Code  
,SUM(PW_Registered) as PW_Registered    
,SUM(PW_High_Risk) as PW_High_Risk    
,SUM(PW_First_Trimester) as PW_First_Trimester   
,SUM(Del_HR_Pub) as PW_HR_Del_Institutional  
,SUM(ANC1_within_12Weeks) AS ANC1_within_12Weeks    
,SUM(ANC1_P)+SUM(ANC1_T) as Toatal_ANC1            
from Scheduled_AC_PW_State_District_Month as PW    
where PW.State_Code =@State_Code  
and (PW.District_Code=@District_Code or @District_Code=0)  
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and (Filter_Type=@Type)  
and Fin_Yr=@FinancialYr   
 group by PW.State_Code,PW.District_Code  
 ) C on A.State_Code=B.State_Code and A.District_Code=C.District_Code

end
else if(@Category='District')  
begin  
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName
,isnull(B.Infant_Registered,0) as Infant_Registered
,isnull(B.Children_Registered,0) as Children_Registered
,isnull(B.Child_With_FULLIMMU,0) as Child_With_FULLIMMU
,isnull(B.Child_With_RECEIVEDALL,0) as Child_With_RECEIVEDALL
,isnull(C.PW_Registered,0) as PW_Registered
,isnull(C.PW_First_Trimester,0) as PW_First_Trimester
,isnull(C.PW_HR_Del_Institutional,0) as PW_HR_Del_Institutional
,ISNULL(A.Estimated_Mother,0) as Estimated_Mother
,isnull(A.Estimated_Infant,0) as Estimated_Infant
from
(select a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name
,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name 
, isnull(c.Estimated_Infant,0)as Estimated_Infant, isnull(c.Estimated_Mother,0)as Estimated_Mother

from TBL_HEALTH_BLOCK a
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD
left outer join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code
where c.Financial_Year=@FinancialYr 
and a.DISTRICT_CD=@District_Code
)  A
left outer join
(
 select CH.District_Code,CH.HealthBlock_Code 
,SUM(Infant_Registered) as Infant_Registered  
,SUM(Child_T)+SUM(Child_P) AS Children_Registered  
,SUM(Child_With_FULLIMMU) as Child_With_FULLIMMU   
,SUM(Child_With_RECEIVEDALL) as Child_With_RECEIVEDALL
from Scheduled_AC_Child_District_Block_Month as CH  
where CH.State_Code =@State_Code
 and CH.District_Code=@District_Code
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and (Filter_Type=@Type)
and Fin_Yr=@FinancialYr 
 group by CH.District_Code,CH.HealthBlock_Code
 ) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code

left outer join
(
 select  PW.District_Code,PW.HealthBlock_Code  
,SUM(PW_Registered) as PW_Registered    
,SUM(PW_High_Risk) as PW_High_Risk    
,SUM(PW_First_Trimester) as PW_First_Trimester   
,SUM(Del_HR_Pub) as PW_HR_Del_Institutional  
,SUM(ANC1_within_12Weeks) AS ANC1_within_12Weeks    
,SUM(ANC1_P)+SUM(ANC1_T) as Toatal_ANC1            
from Scheduled_AC_PW_District_Block_Month as PW    
where PW.State_Code =@State_Code  
and PW.District_Code=@District_Code 
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and (Filter_Type=@Type)  
and Fin_Yr=@FinancialYr   
 group by PW.District_Code,PW.HealthBlock_Code   
 ) C on A.District_Code=C.District_Code and A.HealthBlock_Code=C.HealthBlock_Code

end
else if(@Category='Block')  
begin  
select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName
,isnull(B.Infant_Registered,0) as Infant_Registered
,isnull(B.Children_Registered,0) as Children_Registered
,isnull(B.Child_With_FULLIMMU,0) as Child_With_FULLIMMU
,isnull(B.Child_With_RECEIVEDALL,0) as Child_With_RECEIVEDALL
,isnull(C.PW_Registered,0) as PW_Registered
,isnull(C.PW_First_Trimester,0) as PW_First_Trimester
,isnull(C.PW_HR_Del_Institutional,0) as PW_HR_Del_Institutional
,ISNULL(A.Estimated_Mother,0) as Estimated_Mother
,isnull(A.Estimated_Infant,0) as Estimated_Infant
from  
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
, isnull(c.Estimated_Infant,0)as Estimated_Infant, isnull(c.Estimated_Mother,0)as Estimated_Mother

 from TBL_PHC  a
 inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
 left outer join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code
 where c.Financial_Year=@FinancialYr 
 and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)
)  A 
left outer join
(
 select HealthBlock_Code,HealthFacility_Code   
,SUM(Infant_Registered) as Infant_Registered  
,SUM(Child_T)+SUM(Child_P) AS Children_Registered  
,SUM(Child_With_FULLIMMU) as Child_With_FULLIMMU   
,SUM(Child_With_RECEIVEDALL) as Child_With_RECEIVEDALL              
from Scheduled_AC_Child_Block_PHC_Month
where HealthBlock_Code =@HealthBlock_Code   
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and (Filter_Type=@Type)
and Fin_Yr=@FinancialYr 
 group by HealthBlock_Code,HealthFacility_Code
 ) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code
left outer join
(
 select  PW.HealthBlock_Code,PW.HealthFacility_Code  
,SUM(PW_Registered) as PW_Registered    
,SUM(PW_High_Risk) as PW_High_Risk    
,SUM(PW_First_Trimester) as PW_First_Trimester   
,SUM(Del_HR_Pub) as  PW_HR_Del_Institutional  
,SUM(ANC1_within_12Weeks) AS ANC1_within_12Weeks    
,SUM(ANC1_P)+SUM(ANC1_T) as Toatal_ANC1            
from Scheduled_AC_PW_Block_PHC_Month as PW    
where HealthBlock_Code =@HealthBlock_Code   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and (Filter_Type=@Type)  
and Fin_Yr=@FinancialYr   
 group by  PW.HealthBlock_Code,PW.HealthFacility_Code 
 ) C on A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code
 end 
else if(@Category='PHC')  
begin  
select A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName
,isnull(B.Infant_Registered,0) as Infant_Registered
,isnull(B.Children_Registered,0) as Children_Registered
,isnull(B.Child_With_FULLIMMU,0) as Child_With_FULLIMMU
,isnull(B.Child_With_RECEIVEDALL,0) as Child_With_RECEIVEDALL
,isnull(C.PW_Registered,0) as PW_Registered
,isnull(C.PW_First_Trimester,0) as PW_First_Trimester
,isnull(C.PW_HR_Del_Institutional,0) as PW_HR_Del_Institutional
,ISNULL(A.Estimated_Mother,0) as Estimated_Mother
,isnull(A.Estimated_Infant,0) as Estimated_Infant
from 
(
select b.PHC_CD as HealthFacility_Code
,b.PHC_NAME as HealthFacility_Name 
,isnull(a.SUBPHC_CD,0) as HealthSubFacility_Code
,isnull(a.SUBPHC_NAME_E,'') as HealthSubFacility_Name
, isnull(c.Estimated_Infant,0)as Estimated_Infant, isnull(c.Estimated_Mother,0)as Estimated_Mother
from TBL_SUBPHC a
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
left outer join Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code 
where c.Financial_Year=@FinancialYr 
and (a.PHC_CD= @HealthFacility_Code)
)  A 
left outer join 
(  
 select HealthFacility_Code,HealthSubFacility_Code
,SUM(Infant_Registered) as Infant_Registered  
,SUM(Child_T)+SUM(Child_P) AS Children_Registered  
,SUM(Child_With_FULLIMMU) as Child_With_FULLIMMU   
,SUM(Child_With_RECEIVEDALL) as Child_With_RECEIVEDALL         
from Scheduled_AC_Child_PHC_SubCenter_Month
where State_Code =@State_Code
and HealthFacility_Code =@HealthFacility_Code   
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and (Filter_Type=@Type)
and Fin_Yr=@FinancialYr 
 group by HealthFacility_Code,HealthSubFacility_Code
 ) B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code
left outer join
(
 select HealthFacility_Code,HealthSubFacility_Code 
,SUM(PW_Registered) as PW_Registered    
,SUM(PW_High_Risk) as PW_High_Risk    
,SUM(PW_First_Trimester) as PW_First_Trimester   
,SUM(Del_HR_Pub) as  PW_HR_Del_Institutional  
,SUM(ANC1_within_12Weeks) AS ANC1_within_12Weeks    
,SUM(ANC1_P)+SUM(ANC1_T) as Toatal_ANC1            
from Scheduled_AC_PW_PHC_SubCenter_Month as PW    
where HealthFacility_Code =@HealthFacility_Code 
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and (Filter_Type=@Type)  
and Fin_Yr=@FinancialYr   
 group by HealthFacility_Code,HealthSubFacility_Code
 ) C on A.HealthFacility_Code=C.HealthFacility_Code and A.HealthSubFacility_Code=C.HealthSubFacility_Code
 
 end  
else if(@Category='SubCentre')  
begin  
select A.State_Code,A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName
,isnull(B.Infant_Registered,0) as Infant_Registered
,isnull(B.Children_Registered,0) as Children_Registered
,isnull(B.Child_With_FULLIMMU,0) as Child_With_FULLIMMU
,isnull(B.Child_With_RECEIVEDALL,0) as Child_With_RECEIVEDALL
,isnull(C.PW_Registered,0) as PW_Registered
,isnull(C.PW_First_Trimester,0) as PW_First_Trimester
,isnull(C.PW_HR_Del_Institutional,0) as PW_HR_Del_Institutional
,ISNULL(A.Estimated_Mother,0) as Estimated_Mother
,isnull(A.Estimated_Infant,0) as Estimated_Infant
from 
(
select c.State_Code,  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code
,sp.SUBPHC_NAME_E as		HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name
, isnull(c.Estimated_Infant,0)as Estimated_Infant, isnull(c.Estimated_Mother,0)as Estimated_Mother
from Estimated_Data_Village_Wise  c
left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code
left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code
left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code 
where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr

)  A 
left outer join 
(  
 select HealthSubFacility_Code,Village_Code
,SUM(Infant_Registered) as Infant_Registered  
,SUM(Child_T)+SUM(Child_P) AS Children_Registered  
,SUM(Child_With_FULLIMMU) as Child_With_FULLIMMU   
,SUM(Child_With_RECEIVEDALL) as Child_With_RECEIVEDALL      
from Scheduled_AC_Child_PHC_SubCenter_Village_Month
where HealthFacility_Code =@HealthFacility_Code 
and HealthSubFacility_Code =@HealthSubFacility_Code     
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
and (Filter_Type=@Type)
and Fin_Yr=@FinancialYr 
 group by HealthSubFacility_Code,Village_Code
 ) B on  A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code
left outer join
(
 select  HealthSubFacility_Code,Village_Code
,SUM(PW_Registered) as PW_Registered    
,SUM(PW_High_Risk) as PW_High_Risk    
,SUM(PW_First_Trimester) as PW_First_Trimester   
,SUM(Del_HR_Pub) as  PW_HR_Del_Institutional  
,SUM(ANC1_within_12Weeks) AS ANC1_within_12Weeks    
,SUM(ANC1_P)+SUM(ANC1_T) as Toatal_ANC1            
from Scheduled_AC_PW_PHC_SubCenter_Village_Month as PW    
where HealthFacility_Code =@HealthFacility_Code 
and HealthSubFacility_Code =@HealthSubFacility_Code  
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
and (Filter_Type=@Type)  
and Fin_Yr=@FinancialYr   
 group by HealthSubFacility_Code,Village_Code
 ) C on A.HealthSubFacility_Code=C.HealthSubFacility_Code and A.Village_Code=C.Village_Code
 
 end 



end



