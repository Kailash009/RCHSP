USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Tracking_Service]    Script Date: 09/26/2024 11:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  
  
[AC_Tracking_Service] 0,0,0,0,0,0,2015,0,0,'','','National'  
[AC_Tracking_Service] 28,0,0,0,0,0,2015,0,0,'','','State'  
[AC_Tracking_Service] 28,16,0,0,0,0,2015,3,2016,'','','District'  
[AC_Tracking_Service] 28,16,671,0,0,0,2015,1,2015,'','','Block'  
[AC_Tracking_Service] 28,16,232,329,0,2015,12,2015,'','','PHC'  
  
*/  
ALTER proc [dbo].[AC_Tracking_Service]  
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
@Category varchar(20)   
)  
as  
begin  
  
if(@Category='National')    
begin    
 exec RCH_Reports.dbo.AC_Tracking_Service @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,    
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category  
end  
  
if(@Category='State')  
begin  
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,  
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,  
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,  
ISNULL (All_ANC,0) as All_ANC,ISNULL (Any_three_ANC,0) as Any_three_ANC,ISNULL (SC_Total_LMP,0) as SC_Total_LMP,ISNULL (SC_ANC1,0) as SC_ANC1,  
ISNULL (SC_ANC2,0)as SC_ANC2,ISNULL (SC_ANC3,0) as  SC_ANC3,ISNULL (SC_ANC4,0) as SC_ANC4,ISNULL (SC_TT1,0) as SC_TT1,ISNULL (SC_TT2,0)as SC_TT2,  
ISNULL (SC_TTBooster,0) as SC_TTBooster,isnull (SC_IFA,0) as SC_IFA,ISNULL (SC_Delivery,0) as SC_Delivery,ISNULL (SC_All_ANC,0) as SC_All_ANC,  
ISNULL (SC_Any_three_ANC,0) as SC_Any_three_ANC,ISNULL (ST_Total_LMP,0) as ST_Total_LMP,ISNULL (ST_ANC1,0)as  ST_ANC1,  
ISNULL (ST_ANC2,0)as ST_ANC2,ISNULL (ST_ANC3,0)as ST_ANC3,ISNULL (ST_ANC4,0)as ST_ANC4,isnull (ST_TT1,0) as ST_TT1,ISNULL(ST_TT2,0) as ST_TT2,  
ISNULL(ST_TTBooster,0) as ST_TTBooster,ISNULL(ST_IFA,0) as ST_IFA,ISNULL(ST_Delivery,0) as ST_Delivery,ISNULL(ST_All_ANC,0) as ST_All_ANC,  
ISNULL(ST_Any_three_ANC,0) as ST_Any_three_ANC,ISNULL(OTHERC_Total_LMP,0) as OTHERC_Total_LMP,ISNULL(OTHERC_ANC1,0) as OTHERC_ANC1,  
ISNULL(OTHERC_ANC2,0) as OTHERC_ANC2,ISNULL(OTHERC_ANC3,0) as OTHERC_ANC3,ISNULL(OTHERC_ANC4,0) as OTHERC_ANC4,ISNULL(OTHERC_TT1,0) as OTHERC_TT1,  
ISNULL(OTHERC_TT2,0) as OTHERC_TT2,ISNULL(OTHERC_TTBooster,0) as OTHERC_TTBooster,ISNULL(OTHERC_IFA,0) as OTHERC_IFA,ISNULL(OTHERC_Delivery,0) as OTHERC_Delivery,  
ISNULL(OTHERC_All_ANC,0) as OTHERC_All_ANC,ISNULL(OTHERC_Any_three_ANC,0) as OTHERC_Any_three_ANC,ISNULL (APL_Total_LMP,0) as APL_Total_LMP,  
ISNULL (APL_ANC1,0) as APL_ANC1,ISNULL (APL_ANC2,0) as APL_ANC2,ISNULL (APL_ANC3,0) as APL_ANC3,ISNULL (APL_ANC4,0) as APL_ANC4,ISNULL (APL_TT1,0) as APL_TT1,  
ISNULL (APL_TT2,0) as APL_TT2,ISNULL (APL_TTBooster,0) as APL_TTBooster,ISNULL (APL_IFA,0) as APL_IFA,ISNULL (APL_Delivery,0) as APL_Delivery,  
ISNULL (APL_All_ANC,0) as APL_All_ANC,ISNULL (APL_Any_three_ANC,0) as APL_Any_three_ANC,ISNULL (BPL_Total_LMP,0) as BPL_Total_LMP,  
ISNULL (BPL_ANC1,0) as BPL_ANC1,ISNULL (BPL_ANC2,0) asBPL_ANC2,ISNULL (BPL_ANC3,0) as BPL_ANC3,ISNULL (BPL_ANC4,0) as BPL_ANC4,  
ISNULL (BPL_TT1,0) as BPL_TT1,ISNULL (BPL_TT2,0) as BPL_TT2,ISNULL (BPL_TTBooster,0) as BPL_TTBooster,ISNULL (BPL_IFA,0) as BPL_IFA,  
ISNULL (BPL_Delivery,0) as BPL_Delivery,ISNULL (BPL_All_ANC,0) as BPL_All_ANC,ISNULL (BPL_Any_three_ANC,0) as BPL_Any_three_ANC,  
ISNULL (NotKnown_Total_LMP,0) as  NotKnown_Total_LMP,ISNULL (NotKnown_ANC1,0) as NotKnown_ANC1,ISNULL (NotKnown_ANC2,0) as NotKnown_ANC2,  
ISNULL (NotKnown_ANC3,0) as NotKnown_ANC3,ISNULL (NotKnown_ANC4,0) as NotKnown_ANC4,ISNULL (NotKnown_TT1,0) as NotKnown_TT1,  
ISNULL (NotKnown_TT2,0) as NotKnown_TT2,ISNULL (NotKnown_TTBooster,0) as NotKnown_TTBooster,ISNULL (NotKnown_IFA,0) as NotKnown_IFA,  
ISNULL (NotKnown_Delivery,0) as NotKnown_Delivery,ISNULL (NotKnown_All_ANC,0) as NotKnown_All_ANC,ISNULL (NotKnown_Any_three_ANC,0) as NotKnown_Any_three_ANC,  
ISNULL (Christian_Total_LMP,0) as Christian_Total_LMP,ISNULL (Christian_ANC1,0) as Christian_ANC1,ISNULL (Christian_ANC2,0) as Christian_ANC2,  
ISNULL (Christian_ANC3,0) as Christian_ANC3,ISNULL (Christian_ANC4,0) as Christian_ANC4,ISNULL (Christian_TT1,0) as Christian_TT1,  
ISNULL (Christian_TT2,0) as Christian_TT2,ISNULL (Christian_TTBooster,0) as Christian_TTBooster,ISNULL (Christian_IFA,0) as Christian_IFA,  
ISNULL (Christian_Delivery,0) as Christian_Delivery,ISNULL (Christian_All_ANC,0) as Christian_All_ANC,ISNULL (Christian_Any_three_ANC,0) as Christian_Any_three_ANC,  
ISNULL (Hindu_Total_LMP,0) as Hindu_Total_LMP,ISNULL (Hindu_ANC1,0) as Hindu_ANC1,ISNULL (Hindu_ANC2,0) as Hindu_ANC2,ISNULL (Hindu_ANC3,0) as Hindu_ANC3,  
ISNULL (Hindu_ANC4,0) as Hindu_ANC4,ISNULL (Hindu_TT1,0) as Hindu_TT1,ISNULL (Hindu_TT2,0) as Hindu_TT2,ISNULL (Hindu_TTBooster,0) as Hindu_TTBooster,  
ISNULL (Hindu_IFA,0) as Hindu_IFA,ISNULL (Hindun_Delivery,0) as Hindun_Delivery,ISNULL (Hindu_All_ANC,0) as  Hindu_All_ANC,ISNULL (Hindu_Any_three_ANC,0) as Hindu_Any_three_ANC,  
ISNULL (Muslim_Total_LMP,0) as Muslim_Total_LMP,ISNULL (Muslim_ANC1,0) as Muslim_ANC1,ISNULL (Muslim_ANC2,0) as Muslim_ANC2,ISNULL (Muslim_ANC3,0) as Muslim_ANC3,  
ISNULL (Muslim_ANC4,0) as Muslim_ANC4,ISNULL (Muslim_TT1,0) as Muslim_TT1,ISNULL (Muslim_TT2,0) as Muslim_TT2,ISNULL (Muslim_TTBooster,0) as Muslim_TTBooster,  
ISNULL (Muslim_IFA,0) as Muslim_IFA,ISNULL (Muslim_Delivery,0) as Muslim_Delivery,ISNULL (Muslim_All_ANC,0) as Muslim_All_ANC,ISNULL (Muslim_Any_three_ANC,0) as Muslim_Any_three_ANC,  
ISNULL (Sikh_Total_LMP,0) as Sikh_Total_LMP,ISNULL (Sikh_ANC1,0) as Sikh_ANC1,ISNULL (Sikh_ANC2,0) as Sikh_ANC2,ISNULL (Sikh_ANC3,0) as Sikh_ANC3,  
ISNULL (Sikh_ANC4,0) as Sikh_ANC4,ISNULL (Sikh_TT1,0) as Sikh_TT1,ISNULL (Sikh_TT2,0) as Sikh_TT2,ISNULL (Sikh_TTBooster,0) as Sikh_TTBooster,  
ISNULL (Sikh_IFA,0) as Sikh_IFA,ISNULL (Sikh_Delivery,0) as Sikh_Delivery,ISNULL (Sikh_All_ANC,0) as Sikh_All_ANC,ISNULL (Sikh_Any_three_ANC,0) as Sikh_Any_three_ANC,  
ISNULL (OTHERR_Total_LMP,0) as OTHERR_Total_LMP,ISNULL (OTHERR_ANC1,0) as  OTHERR_ANC1,ISNULL (OTHERR_ANC2,0) as OTHERR_ANC2,ISNULL (OTHERR_ANC3,0) as  OTHERR_ANC3,  
ISNULL (OTHERR_ANC4,0) as  OTHERR_ANC4,ISNULL (OTHERR_TT1,0) as  OTHERR_TT1,ISNULL (OTHERR_TT2,0) as  OTHERR_TT2,ISNULL (OTHERR_TTBooster,0) as  OTHERR_TTBooster,  
ISNULL (OTHERR_IFA,0) as  OTHERR_IFA,ISNULL (OTHERR_Delivery,0) as  OTHERR_Delivery,ISNULL (OTHERR_All_ANC,0) as  OTHERR_All_ANC,ISNULL (OTHERR_Any_three_ANC,0) as  OTHERR_Any_three_ANC ,  
ISNULL (HR_Total_LMP,0) as HR_Total_LMP,ISNULL (HR_ANC1,0) as  HR_ANC1,ISNULL (HR_ANC2,0) as HR_ANC2,ISNULL (HR_ANC3,0) as  HR_ANC3,  
ISNULL (HR_ANC4,0) as  HR_ANC4,ISNULL (HR_TT1,0) as  HR_TT1,ISNULL (HR_TT2,0) as  HR_TT2,ISNULL (HR_TTBooster,0) as  HR_TTBooster,  
ISNULL (HR_IFA,0) as  HR_IFA,ISNULL (HR_Delivery,0) as  HR_Delivery,ISNULL (HR_All_ANC,0) as  HR_All_ANC,ISNULL (HR_Any_three_ANC,0) as  HR_Any_three_ANC  
, '' as Del_Pub_Inst, '' as Del_Pvt_Inst, '' as Del_SBA, '' as Del_NonSBA, '' as Del_in_home,'' as Del_CSection_Pub_Inst,'' as Del_CSection_Pvt_Inst
,'' as Del_death,'' as Del_Due_ButNotReported
 from    
 (select c.State_Code as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name  
 from  TBL_DISTRICT a   
 inner join TBL_STATE b on a.StateID=b.StateID  
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code  
 where c.Financial_Year=@FinancialYr   
   
) A  
left outer join  
(  
 select  CH.State_Code,CH.District_Code  
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2     
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC   ,SUM(Any_three_ANC) as Any_three_ANC    
   
,SUM(SC_Total_LMP) as SC_Total_LMP,SUM(SC_ANC1) as SC_ANC1 ,SUM(SC_ANC2) as SC_ANC2,SUM(SC_ANC3) as SC_ANC3,SUM(SC_ANC4) as SC_ANC4,SUM(SC_TT1) as SC_TT1     
,SUM(SC_TT2) as SC_TT2,SUM(SC_TTBooster) as SC_TTBooster,SUM(SC_IFA) as SC_IFA ,SUM(SC_Delivery) as SC_Delivery,SUM(SC_All_ANC) as SC_All_ANC ,SUM(SC_Any_three_ANC) as SC_Any_three_ANC   
  
,SUM(ST_Total_LMP) as ST_Total_LMP,SUM(ST_ANC1) as ST_ANC1,SUM(ST_ANC2) as ST_ANC2,SUM(ST_ANC3) as ST_ANC3,SUM(ST_ANC4) as ST_ANC4,SUM(ST_TT1) as ST_TT1     
,SUM(ST_TT2) as ST_TT2,SUM(ST_TTBooster) as ST_TTBooster,SUM(ST_IFA) as ST_IFA  ,SUM(ST_Delivery) as ST_Delivery ,SUM(ST_All_ANC) as ST_All_ANC   ,SUM(ST_Any_three_ANC) as ST_Any_three_ANC   
  
,SUM(OTHERC_Total_LMP) as OTHERC_Total_LMP,SUM(OTHERC_ANC1) as OTHERC_ANC1 ,SUM(OTHERC_ANC2) as OTHERC_ANC2,SUM(OTHERC_ANC3) as OTHERC_ANC3     
,SUM(OTHERC_ANC4) as OTHERC_ANC4,SUM(OTHERC_TT1) as OTHERC_TT1,SUM(OTHERC_TT2) as OTHERC_TT2,SUM(OTHERC_TTBooster) as OTHERC_TTBooster  
,SUM(OTHERC_IFA) as OTHERC_IFA,SUM(OTHERC_Delivery) as OTHERC_Delivery,SUM(OTHERC_All_ANC) as OTHERC_All_ANC,SUM(OTHERC_Any_three_ANC) as OTHERC_Any_three_ANC   
  
,SUM(APL_Total_LMP) as APL_Total_LMP,SUM(APL_ANC1) as APL_ANC1,SUM(APL_ANC2) as APL_ANC2,SUM(APL_ANC3) as APL_ANC3,SUM(APL_ANC4) as APL_ANC4     
,SUM(APL_TT1) as APL_TT1,SUM(APL_TT2) as APL_TT2,SUM(APL_TTBooster) as APL_TTBooster,SUM(APL_IFA) as APL_IFA,SUM(APL_Delivery) as APL_Delivery   
,SUM(APL_All_ANC) as APL_All_ANC,SUM(APL_Any_three_ANC) as APL_Any_three_ANC   
  
,SUM(BPL_Total_LMP) as BPL_Total_LMP,SUM(BPL_ANC1) as BPL_ANC1,SUM(BPL_ANC2) as BPL_ANC2,SUM(BPL_ANC3) as BPL_ANC3,SUM(BPL_ANC4) as BPL_ANC4     
,SUM(BPL_TT1) as BPL_TT1,SUM(BPL_TT2) as BPL_TT2,SUM(BPL_TTBooster) as BPL_TTBooster,SUM(BPL_IFA) as BPL_IFA    
,SUM(BPL_Delivery) as BPL_Delivery,SUM(BPL_All_ANC) as BPL_All_ANC,SUM(BPL_Any_three_ANC) as BPL_Any_three_ANC   
  
,SUM(NotKnown_Total_LMP) as NotKnown_Total_LMP,SUM(NotKnown_ANC1) as NotKnown_ANC1,SUM(NotKnown_ANC2) as NotKnown_ANC2,SUM(NotKnown_ANC3) as NotKnown_ANC3 ,SUM(NotKnown_ANC4) as NotKnown_ANC4     
,SUM(NotKnown_TT1) as NotKnown_TT1,SUM(NotKnown_TT2) as NotKnown_TT2,SUM(NotKnown_TTBooster) as NotKnown_TTBooster,SUM(NotKnown_IFA) as NotKnown_IFA    
,SUM(NotKnown_Delivery) as NotKnown_Delivery,SUM(NotKnown_All_ANC) as NotKnown_All_ANC,SUM(NotKnown_Any_three_ANC) as NotKnown_Any_three_ANC   
  
,SUM(Christian_Total_LMP) as Christian_Total_LMP,SUM(Christian_ANC1) as Christian_ANC1,SUM(Christian_ANC2) as Christian_ANC2,SUM(Christian_ANC3) as Christian_ANC3     
,SUM(Christian_ANC4) as Christian_ANC4,SUM(Christian_TT1) as Christian_TT1,SUM(Christian_TT2) as Christian_TT2,SUM(Christian_TTBooster) as Christian_TTBooster  
,SUM(Christian_IFA) as Christian_IFA,SUM(Christian_Delivery) as Christian_Delivery,SUM(Christian_All_ANC) as Christian_All_ANC,SUM(Christian_Any_three_ANC) as Christian_Any_three_ANC   
  
,SUM(Hindu_Total_LMP) as Hindu_Total_LMP,SUM(Hindu_ANC1) as Hindu_ANC1,SUM(Hindu_ANC2) as Hindu_ANC2,SUM(Hindu_ANC3) as Hindu_ANC3     
,SUM(Hindu_ANC4) as Hindu_ANC4,SUM(Hindu_TT1) as Hindu_TT1,SUM(Hindu_TT2) as Hindu_TT2,SUM(Hindu_TTBooster) as Hindu_TTBooster  
,SUM(Hindu_IFA) as Hindu_IFA,SUM(Hindun_Delivery) as Hindun_Delivery,SUM(Hindu_All_ANC) as Hindu_All_ANC,SUM(Hindu_Any_three_ANC) as Hindu_Any_three_ANC    
   
,SUM(Muslim_Total_LMP) as Muslim_Total_LMP,SUM(Muslim_ANC1) as Muslim_ANC1,SUM(Muslim_ANC2) as Muslim_ANC2,SUM(Muslim_ANC3) as Muslim_ANC3     
,SUM(Muslim_ANC4) as Muslim_ANC4,SUM(Muslim_TT1) as Muslim_TT1,SUM(Muslim_TT2) as Muslim_TT2,SUM(Muslim_TTBooster) as Muslim_TTBooster  
,SUM(Muslim_IFA) as Muslim_IFA,SUM(Muslim_Delivery) as Muslim_Delivery,SUM(Muslim_All_ANC) as Muslim_All_ANC,SUM(Muslim_Any_three_ANC) as Muslim_Any_three_ANC    
   
,SUM(Sikh_Total_LMP) as Sikh_Total_LMP,SUM(Sikh_ANC1) as Sikh_ANC1,SUM(Sikh_ANC2) as Sikh_ANC2,SUM(Sikh_ANC3) as Sikh_ANC3,SUM(Sikh_ANC4) as Sikh_ANC4     
,SUM(Sikh_TT1) as Sikh_TT1,SUM(Sikh_TT2) as Sikh_TT2,SUM(Sikh_TTBooster) as Sikh_TTBooster,SUM(Sikh_IFA) as Sikh_IFA ,SUM(Sikh_Delivery) as Sikh_Delivery   
,SUM(Sikh_All_ANC) as Sikh_All_ANC,SUM(Sikh_Any_three_ANC) as Sikh_Any_three_ANC    
   
,SUM(OTHERR_Total_LMP) as OTHERR_Total_LMP,SUM(OTHERR_ANC1) as OTHERR_ANC1,SUM(OTHERR_ANC2) as OTHERR_ANC2,SUM(OTHERR_ANC3) as OTHERR_ANC3     
,SUM(OTHERR_ANC4) as OTHERR_ANC4 ,SUM(OTHERR_TT1) as OTHERR_TT1,SUM(OTHERR_TT2) as OTHERR_TT2,SUM(OTHERR_TTBooster) as OTHERR_TTBooster  
,SUM(OTHERR_IFA) as OTHERR_IFA,SUM(OTHERR_Delivery) as OTHERR_Delivery,SUM(OTHERR_All_ANC) as OTHERR_All_ANC,SUM(OTHERR_Any_three_ANC) as OTHERR_Any_three_ANC    
  
,SUM(HR_Total_LMP) as HR_Total_LMP,SUM(HR_ANC1) as HR_ANC1,SUM(HR_ANC2) as HR_ANC2,SUM(HR_ANC3) as HR_ANC3     
,SUM(HR_ANC4) as HR_ANC4 ,SUM(HR_TT1) as HR_TT1,SUM(HR_TT2) as HR_TT2,SUM(HR_TTBooster) as HR_TTBooster  
,SUM(HR_IFA) as HR_IFA,SUM(HR_Delivery) as HR_Delivery,SUM(HR_All_ANC) as HR_All_ANC,SUM(HR_Any_three_ANC) as HR_Any_three_ANC    
from dbo.Scheduled_Tracking_State_District_Day as CH    
where CH.State_Code =@State_Code  
and Fin_Yr=@FinancialYr   
and (Month_ID=@Month_ID or @Month_ID=0)  
and (Year_ID=@Year_ID or @Year_ID=0)  
 group by CH.State_Code,CH.District_Code  
 )   
 B on A.District_Code=B.District_Code   
end  
  
else if(@Category='District')  
begin  
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName,  
ISNULL(Total_LMP,0) as Total_LMP,ISNULL (ANC1,0) as ANC1,ISNULL (ANC2,0) as ANC2,ISNULL (ANC3,0) as ANC3,ISNULL (ANC4,0) as ANC4,  
ISNULL (TT1,0) as TT1,ISNULL (TT2,0) as TT2,ISNULL (TTBooster,0) as TTBooster,ISNULL (IFA,0) as IFA,ISNULL (Delivery,0) as Delivery,  
ISNULL (All_ANC,0) as All_ANC,ISNULL (Any_three_ANC,0) as Any_three_ANC,ISNULL (SC_Total_LMP,0) as SC_Total_LMP,ISNULL (SC_ANC1,0) as SC_ANC1,  
ISNULL (SC_ANC2,0)as SC_ANC2,ISNULL (SC_ANC3,0) as  SC_ANC3,ISNULL (SC_ANC4,0) as SC_ANC4,ISNULL (SC_TT1,0) as SC_TT1,ISNULL (SC_TT2,0)as SC_TT2,  
ISNULL (SC_TTBooster,0) as SC_TTBooster,isnull (SC_IFA,0) as SC_IFA,ISNULL (SC_Delivery,0) as SC_Delivery,ISNULL (SC_All_ANC,0) as SC_All_ANC,  
ISNULL (SC_Any_three_ANC,0) as SC_Any_three_ANC,ISNULL (ST_Total_LMP,0) as ST_Total_LMP,ISNULL (ST_ANC1,0)as  ST_ANC1,  
ISNULL (ST_ANC2,0)as ST_ANC2,ISNULL (ST_ANC3,0)as ST_ANC3,ISNULL (ST_ANC4,0)as ST_ANC4,isnull (ST_TT1,0) as ST_TT1,ISNULL(ST_TT2,0) as ST_TT2,  
ISNULL(ST_TTBooster,0) as ST_TTBooster,ISNULL(ST_IFA,0) as ST_IFA,ISNULL(ST_Delivery,0) as ST_Delivery,ISNULL(ST_All_ANC,0) as ST_All_ANC,  
ISNULL(ST_Any_three_ANC,0) as ST_Any_three_ANC,ISNULL(OTHERC_Total_LMP,0) as OTHERC_Total_LMP,ISNULL(OTHERC_ANC1,0) as OTHERC_ANC1,  
ISNULL(OTHERC_ANC2,0) as OTHERC_ANC2,ISNULL(OTHERC_ANC3,0) as OTHERC_ANC3,ISNULL(OTHERC_ANC4,0) as OTHERC_ANC4,ISNULL(OTHERC_TT1,0) as OTHERC_TT1,  
ISNULL(OTHERC_TT2,0) as OTHERC_TT2,ISNULL(OTHERC_TTBooster,0) as OTHERC_TTBooster,ISNULL(OTHERC_IFA,0) as OTHERC_IFA,ISNULL(OTHERC_Delivery,0) as OTHERC_Delivery,  
ISNULL(OTHERC_All_ANC,0) as OTHERC_All_ANC,ISNULL(OTHERC_Any_three_ANC,0) as OTHERC_Any_three_ANC,ISNULL (APL_Total_LMP,0) as APL_Total_LMP,  
ISNULL (APL_ANC1,0) as APL_ANC1,ISNULL (APL_ANC2,0) as APL_ANC2,ISNULL (APL_ANC3,0) as APL_ANC3,ISNULL (APL_ANC4,0) as APL_ANC4,ISNULL (APL_TT1,0) as APL_TT1,  
ISNULL (APL_TT2,0) as APL_TT2,ISNULL (APL_TTBooster,0) as APL_TTBooster,ISNULL (APL_IFA,0) as APL_IFA,ISNULL (APL_Delivery,0) as APL_Delivery,  
ISNULL (APL_All_ANC,0) as APL_All_ANC,ISNULL (APL_Any_three_ANC,0) as APL_Any_three_ANC,ISNULL (BPL_Total_LMP,0) as BPL_Total_LMP,  
ISNULL (BPL_ANC1,0) as BPL_ANC1,ISNULL (BPL_ANC2,0) asBPL_ANC2,ISNULL (BPL_ANC3,0) as BPL_ANC3,ISNULL (BPL_ANC4,0) as BPL_ANC4,  
ISNULL (BPL_TT1,0) as BPL_TT1,ISNULL (BPL_TT2,0) as BPL_TT2,ISNULL (BPL_TTBooster,0) as BPL_TTBooster,ISNULL (BPL_IFA,0) as BPL_IFA,  
ISNULL (BPL_Delivery,0) as BPL_Delivery,ISNULL (BPL_All_ANC,0) as BPL_All_ANC,ISNULL (BPL_Any_three_ANC,0) as BPL_Any_three_ANC,  
ISNULL (NotKnown_Total_LMP,0) as  NotKnown_Total_LMP,ISNULL (NotKnown_ANC1,0) as NotKnown_ANC1,ISNULL (NotKnown_ANC2,0) as NotKnown_ANC2,  
ISNULL (NotKnown_ANC3,0) as NotKnown_ANC3,ISNULL (NotKnown_ANC4,0) as NotKnown_ANC4,ISNULL (NotKnown_TT1,0) as NotKnown_TT1,  
ISNULL (NotKnown_TT2,0) as NotKnown_TT2,ISNULL (NotKnown_TTBooster,0) as NotKnown_TTBooster,ISNULL (NotKnown_IFA,0) as NotKnown_IFA,  
ISNULL (NotKnown_Delivery,0) as NotKnown_Delivery,ISNULL (NotKnown_All_ANC,0) as NotKnown_All_ANC,ISNULL (NotKnown_Any_three_ANC,0) as NotKnown_Any_three_ANC,  
ISNULL (Christian_Total_LMP,0) as Christian_Total_LMP,ISNULL (Christian_ANC1,0) as Christian_ANC1,ISNULL (Christian_ANC2,0) as Christian_ANC2,  
ISNULL (Christian_ANC3,0) as Christian_ANC3,ISNULL (Christian_ANC4,0) as Christian_ANC4,ISNULL (Christian_TT1,0) as Christian_TT1,  
ISNULL (Christian_TT2,0) as Christian_TT2,ISNULL (Christian_TTBooster,0) as Christian_TTBooster,ISNULL (Christian_IFA,0) as Christian_IFA,  
ISNULL (Christian_Delivery,0) as Christian_Delivery,ISNULL (Christian_All_ANC,0) as Christian_All_ANC,ISNULL (Christian_Any_three_ANC,0) as Christian_Any_three_ANC,  
ISNULL (Hindu_Total_LMP,0) as Hindu_Total_LMP,ISNULL (Hindu_ANC1,0) as Hindu_ANC1,ISNULL (Hindu_ANC2,0) as Hindu_ANC2,ISNULL (Hindu_ANC3,0) as Hindu_ANC3,  
ISNULL (Hindu_ANC4,0) as Hindu_ANC4,ISNULL (Hindu_TT1,0) as Hindu_TT1,ISNULL (Hindu_TT2,0) as Hindu_TT2,ISNULL (Hindu_TTBooster,0) as Hindu_TTBooster,  
ISNULL (Hindu_IFA,0) as Hindu_IFA,ISNULL (Hindun_Delivery,0) as Hindun_Delivery,ISNULL (Hindu_All_ANC,0) as  Hindu_All_ANC,ISNULL (Hindu_Any_three_ANC,0) as Hindu_Any_three_ANC,  
ISNULL (Muslim_Total_LMP,0) as Muslim_Total_LMP,ISNULL (Muslim_ANC1,0) as Muslim_ANC1,ISNULL (Muslim_ANC2,0) as Muslim_ANC2,ISNULL (Muslim_ANC3,0) as Muslim_ANC3,  
ISNULL (Muslim_ANC4,0) as Muslim_ANC4,ISNULL (Muslim_TT1,0) as Muslim_TT1,ISNULL (Muslim_TT2,0) as Muslim_TT2,ISNULL (Muslim_TTBooster,0) as Muslim_TTBooster,  
ISNULL (Muslim_IFA,0) as Muslim_IFA,ISNULL (Muslim_Delivery,0) as Muslim_Delivery,ISNULL (Muslim_All_ANC,0) as Muslim_All_ANC,ISNULL (Muslim_Any_three_ANC,0) as Muslim_Any_three_ANC,  
ISNULL (Sikh_Total_LMP,0) as Sikh_Total_LMP,ISNULL (Sikh_ANC1,0) as Sikh_ANC1,ISNULL (Sikh_ANC2,0) as Sikh_ANC2,ISNULL (Sikh_ANC3,0) as Sikh_ANC3,  
ISNULL (Sikh_ANC4,0) as Sikh_ANC4,ISNULL (Sikh_TT1,0) as Sikh_TT1,ISNULL (Sikh_TT2,0) as Sikh_TT2,ISNULL (Sikh_TTBooster,0) as Sikh_TTBooster,  
ISNULL (Sikh_IFA,0) as Sikh_IFA,ISNULL (Sikh_Delivery,0) as Sikh_Delivery,ISNULL (Sikh_All_ANC,0) as Sikh_All_ANC,ISNULL (Sikh_Any_three_ANC,0) as Sikh_Any_three_ANC,  
ISNULL (OTHERR_Total_LMP,0) as OTHERR_Total_LMP,ISNULL (OTHERR_ANC1,0) as  OTHERR_ANC1,ISNULL (OTHERR_ANC2,0) as OTHERR_ANC2,ISNULL (OTHERR_ANC3,0) as  OTHERR_ANC3,  
ISNULL (OTHERR_ANC4,0) as  OTHERR_ANC4,ISNULL (OTHERR_TT1,0) as  OTHERR_TT1,ISNULL (OTHERR_TT2,0) as  OTHERR_TT2,ISNULL (OTHERR_TTBooster,0) as  OTHERR_TTBooster,  
ISNULL (OTHERR_IFA,0) as  OTHERR_IFA,ISNULL (OTHERR_Delivery,0) as  OTHERR_Delivery,ISNULL (OTHERR_All_ANC,0) as  OTHERR_All_ANC,ISNULL (OTHERR_Any_three_ANC,0) as  OTHERR_Any_three_ANC ,  
ISNULL (HR_Total_LMP,0) as HR_Total_LMP,ISNULL (HR_ANC1,0) as  HR_ANC1,ISNULL (HR_ANC2,0) as HR_ANC2,ISNULL (HR_ANC3,0) as  HR_ANC3,  
ISNULL (HR_ANC4,0) as  HR_ANC4,ISNULL (HR_TT1,0) as  HR_TT1,ISNULL (HR_TT2,0) as  HR_TT2,ISNULL (HR_TTBooster,0) as  HR_TTBooster,  
ISNULL (HR_IFA,0) as  HR_IFA,ISNULL (HR_Delivery,0) as  HR_Delivery,ISNULL (HR_All_ANC,0) as  HR_All_ANC,ISNULL (HR_Any_three_ANC,0) as  HR_Any_three_ANC   
 , '' as Del_Pub_Inst, '' as Del_Pvt_Inst, '' as Del_SBA, '' as Del_NonSBA, '' as Del_in_home,'' as Del_CSection_Pub_Inst,'' as Del_CSection_Pvt_Inst
,'' as Del_death,'' as Del_Due_ButNotReported
 from    
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name   
 from TBL_HEALTH_BLOCK a  
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD  
 inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code  
 where c.Financial_Year=@FinancialYr   
 and a.DISTRICT_CD=@District_Code  
) A  
left outer join  
(  
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code   
,SUM(Total_LMP) as Total_LMP,SUM(ANC1) as ANC1,SUM(ANC2) as ANC2  ,SUM(ANC3) as ANC3,SUM(ANC4) as ANC4   ,SUM(TT1) as TT1   ,SUM(TT2) as TT2     
,SUM(TTBooster) as TTBooster ,SUM(IFA) as IFA,SUM(Delivery) as Delivery,SUM(All_ANC) as All_ANC   ,SUM(Any_three_ANC) as Any_three_ANC    
   
,SUM(SC_Total_LMP) as SC_Total_LMP,SUM(SC_ANC1) as SC_ANC1 ,SUM(SC_ANC2) as SC_ANC2,SUM(SC_ANC3) as SC_ANC3,SUM(SC_ANC4) as SC_ANC4,SUM(SC_TT1) as SC_TT1     
,SUM(SC_TT2) as SC_TT2,SUM(SC_TTBooster) as SC_TTBooster,SUM(SC_IFA) as SC_IFA ,SUM(SC_Delivery) as SC_Delivery,SUM(SC_All_ANC) as SC_All_ANC ,SUM(SC_Any_three_ANC) as SC_Any_three_ANC   
  
,SUM(ST_Total_LMP) as ST_Total_LMP,SUM(ST_ANC1) as ST_ANC1,SUM(ST_ANC2) as ST_ANC2,SUM(ST_ANC3) as ST_ANC3,SUM(ST_ANC4) as ST_ANC4,SUM(ST_TT1) as ST_TT1     
,SUM(ST_TT2) as ST_TT2,SUM(ST_TTBooster) as ST_TTBooster,SUM(ST_IFA) as ST_IFA  ,SUM(ST_Delivery) as ST_Delivery ,SUM(ST_All_ANC) as ST_All_ANC   ,SUM(ST_Any_three_ANC) as ST_Any_three_ANC   
  
,SUM(OTHERC_Total_LMP) as OTHERC_Total_LMP,SUM(OTHERC_ANC1) as OTHERC_ANC1 ,SUM(OTHERC_ANC2) as OTHERC_ANC2,SUM(OTHERC_ANC3) as OTHERC_ANC3     
,SUM(OTHERC_ANC4) as OTHERC_ANC4,SUM(OTHERC_TT1) as OTHERC_TT1,SUM(OTHERC_TT2) as OTHERC_TT2,SUM(OTHERC_TTBooster) as OTHERC_TTBooster  
,SUM(OTHERC_IFA) as OTHERC_IFA,SUM(OTHERC_Delivery) as OTHERC_Delivery,SUM(OTHERC_All_ANC) as OTHERC_All_ANC,SUM(OTHERC_Any_three_ANC) as OTHERC_Any_three_ANC   
  
,SUM(APL_Total_LMP) as APL_Total_LMP,SUM(APL_ANC1) as APL_ANC1,SUM(APL_ANC2) as APL_ANC2,SUM(APL_ANC3) as APL_ANC3,SUM(APL_ANC4) as APL_ANC4     
,SUM(APL_TT1) as APL_TT1,SUM(APL_TT2) as APL_TT2,SUM(APL_TTBooster) as APL_TTBooster,SUM(APL_IFA) as APL_IFA,SUM(APL_Delivery) as APL_Delivery   
,SUM(APL_All_ANC) as APL_All_ANC,SUM(APL_Any_three_ANC) as APL_Any_three_ANC   
  
,SUM(BPL_Total_LMP) as BPL_Total_LMP,SUM(BPL_ANC1) as BPL_ANC1,SUM(BPL_ANC2) as BPL_ANC2,SUM(BPL_ANC3) as BPL_ANC3,SUM(BPL_ANC4) as BPL_ANC4     
,SUM(BPL_TT1) as BPL_TT1,SUM(BPL_TT2) as BPL_TT2,SUM(BPL_TTBooster) as BPL_TTBooster,SUM(BPL_IFA) as BPL_IFA    
,SUM(BPL_Delivery) as BPL_Delivery,SUM(BPL_All_ANC) as BPL_All_ANC,SUM(BPL_Any_three_ANC) as BPL_Any_three_ANC   
  
,SUM(NotKnown_Total_LMP) as NotKnown_Total_LMP,SUM(NotKnown_ANC1) as NotKnown_ANC1,SUM(NotKnown_ANC2) as NotKnown_ANC2,SUM(NotKnown_ANC3) as NotKnown_ANC3 ,SUM(NotKnown_ANC4) as NotKnown_ANC4     
,SUM(NotKnown_TT1) as NotKnown_TT1,SUM(NotKnown_TT2) as NotKnown_TT2,SUM(NotKnown_TTBooster) as NotKnown_TTBooster,SUM(NotKnown_IFA) as NotKnown_IFA    
,SUM(NotKnown_Delivery) as NotKnown_Delivery,SUM(NotKnown_All_ANC) as NotKnown_All_ANC,SUM(NotKnown_Any_three_ANC) as NotKnown_Any_three_ANC   
  
,SUM(Christian_Total_LMP) as Christian_Total_LMP,SUM(Christian_ANC1) as Christian_ANC1,SUM(Christian_ANC2) as Christian_ANC2,SUM(Christian_ANC3) as Christian_ANC3     
,SUM(Christian_ANC4) as Christian_ANC4,SUM(Christian_TT1) as Christian_TT1,SUM(Christian_TT2) as Christian_TT2,SUM(Christian_TTBooster) as Christian_TTBooster  
,SUM(Christian_IFA) as Christian_IFA,SUM(Christian_Delivery) as Christian_Delivery,SUM(Christian_All_ANC) as Christian_All_ANC,SUM(Christian_Any_three_ANC) as Christian_Any_three_ANC   
  
,SUM(Hindu_Total_LMP) as Hindu_Total_LMP,SUM(Hindu_ANC1) as Hindu_ANC1,SUM(Hindu_ANC2) as Hindu_ANC2,SUM(Hindu_ANC3) as Hindu_ANC3     
,SUM(Hindu_ANC4) as Hindu_ANC4,SUM(Hindu_TT1) as Hindu_TT1,SUM(Hindu_TT2) as Hindu_TT2,SUM(Hindu_TTBooster) as Hindu_TTBooster  
,SUM(Hindu_IFA) as Hindu_IFA,SUM(Hindun_Delivery) as Hindun_Delivery,SUM(Hindu_All_ANC) as Hindu_All_ANC,SUM(Hindu_Any_three_ANC) as Hindu_Any_three_ANC    
   
,SUM(Muslim_Total_LMP) as Muslim_Total_LMP,SUM(Muslim_ANC1) as Muslim_ANC1,SUM(Muslim_ANC2) as Muslim_ANC2,SUM(Muslim_ANC3) as Muslim_ANC3     
,SUM(Muslim_ANC4) as Muslim_ANC4,SUM(Muslim_TT1) as Muslim_TT1,SUM(Muslim_TT2) as Muslim_TT2,SUM(Muslim_TTBooster) as Muslim_TTBooster  
,SUM(Muslim_IFA) as Muslim_IFA,SUM(Muslim_Delivery) as Muslim_Delivery,SUM(Muslim_All_ANC) as Muslim_All_ANC,SUM(Muslim_Any_three_ANC) as Muslim_Any_three_ANC    
   
,SUM(Sikh_Total_LMP) as Sikh_Total_LMP,SUM(Sikh_ANC1) as Sikh_ANC1,SUM(Sikh_ANC2) as Sikh_ANC2,SUM(Sikh_ANC3) as Sikh_ANC3,SUM(Sikh_ANC4) as Sikh_ANC4     
,SUM(Sikh_TT1) as Sikh_TT1,SUM(Sikh_TT2) as Sikh_TT2,SUM(Sikh_TTBooster) as Sikh_TTBooster,SUM(Sikh_IFA) as Sikh_IFA ,SUM(Sikh_Delivery) as Sikh_Delivery   
,SUM(Sikh_All_ANC) as Sikh_All_ANC,SUM(Sikh_Any_three_ANC) as Sikh_Any_three_ANC    
   
,SUM(OTHERR_Total_LMP) as OTHERR_Total_LMP,SUM(OTHERR_ANC1) as OTHERR_ANC1,SUM(OTHERR_ANC2) as OTHERR_ANC2,SUM(OTHERR_ANC3) as OTHERR_ANC3     
,SUM(OTHERR_ANC4) as OTHERR_ANC4 ,SUM(OTHERR_TT1) as OTHERR_TT1,SUM(OTHERR_TT2) as OTHERR_TT2,SUM(OTHERR_TTBooster) as OTHERR_TTBooster  
,SUM(OTHERR_IFA) as OTHERR_IFA,SUM(OTHERR_Delivery) as OTHERR_Delivery,SUM(OTHERR_All_ANC) as OTHERR_All_ANC,SUM(OTHERR_Any_three_ANC) as OTHERR_Any_three_ANC    
  
,SUM(HR_Total_LMP) as HR_Total_LMP,SUM(HR_ANC1) as HR_ANC1,SUM(HR_ANC2) as HR_ANC2,SUM(HR_ANC3) as HR_ANC3     
,SUM(HR_ANC4) as HR_ANC4 ,SUM(HR_TT1) as HR_TT1,SUM(HR_TT2) as HR_TT2,SUM(HR_TTBooster) as HR_TTBooster  
,SUM(HR_IFA) as HR_IFA,SUM(HR_Delivery) as HR_Delivery,SUM(HR_All_ANC) as HR_All_ANC,SUM(HR_Any_three_ANC) as HR_Any_three_ANC   
            
   from dbo.Scheduled_Tracking_District_Block_Day as CH    
 where CH.State_Code =@State_Code  
 and CH.District_Code=@District_Code  
 and Fin_Yr=@FinancialYr   
  and (Month_ID=@Month_ID or @Month_ID=0)  
 and (Year_ID=@Year_ID or @Year_ID=0)  
 group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code  
 )   
 B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code  
end  
  
else if(@Category='Block')
begin
select A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,
ISNULL(Total_LMP,0) as Total_LMP,
ISNULL (ANC1,0) as ANC1,
ISNULL (ANC2,0) as ANC2,
ISNULL (ANC3,0) as ANC3,
ISNULL (ANC4,0) as ANC4,
ISNULL (TT1,0) as TT1,
ISNULL (TT2,0) as TT2,
ISNULL (TTBooster,0) as TTBooster,
ISNULL (IFA,0) as IFA,
ISNULL (Delivery,0) as Delivery,
ISNULL (All_ANC,0) as All_ANC,
ISNULL (Any_three_ANC,0) as Any_three_ANC,
ISNULL (SC_Total_LMP,0) as SC_Total_LMP,
ISNULL (SC_ANC1,0) as SC_ANC1,
ISNULL (SC_ANC2,0)as SC_ANC2,
ISNULL (SC_ANC3,0) as  SC_ANC3,
ISNULL (SC_ANC4,0) as SC_ANC4,
ISNULL (SC_TT1,0) as SC_TT1,
ISNULL (SC_TT2,0)as SC_TT2,
ISNULL (SC_TTBooster,0) as SC_TTBooster,
isnull (SC_IFA,0) as SC_IFA,
ISNULL (SC_Delivery,0) as SC_Delivery,
ISNULL (SC_All_ANC,0) as SC_All_ANC,
ISNULL (SC_Any_three_ANC,0) as SC_Any_three_ANC,
ISNULL (ST_Total_LMP,0) as ST_Total_LMP,
ISNULL (ST_ANC1,0)as  ST_ANC1,
ISNULL (ST_ANC2,0)as ST_ANC2,
ISNULL (ST_ANC3,0)as ST_ANC3,
ISNULL (ST_ANC4,0)as ST_ANC4,
isnull (ST_TT1,0) as ST_TT1,
ISNULL(ST_TT2,0) as ST_TT2,
ISNULL(ST_TTBooster,0) as ST_TTBooster,
ISNULL(ST_IFA,0) as ST_IFA,
ISNULL(ST_Delivery,0) as ST_Delivery,
ISNULL(ST_All_ANC,0) as ST_All_ANC,
ISNULL(ST_Any_three_ANC,0) as ST_Any_three_ANC,
ISNULL(OTHERC_Total_LMP,0) as OTHERC_Total_LMP,
ISNULL(OTHERC_ANC1,0) as OTHERC_ANC1,
ISNULL(OTHERC_ANC2,0) as OTHERC_ANC2,
ISNULL(OTHERC_ANC3,0) as OTHERC_ANC3,
ISNULL(OTHERC_ANC4,0) as OTHERC_ANC4,
ISNULL(OTHERC_TT1,0) as OTHERC_TT1,
ISNULL(OTHERC_TT2,0) as OTHERC_TT2,
ISNULL(OTHERC_TTBooster,0) as OTHERC_TTBooster,
ISNULL(OTHERC_IFA,0) as OTHERC_IFA,
ISNULL(OTHERC_Delivery,0) as OTHERC_Delivery,
ISNULL(OTHERC_All_ANC,0) as OTHERC_All_ANC,
ISNULL(OTHERC_Any_three_ANC,0) as OTHERC_Any_three_ANC,
ISNULL (APL_Total_LMP,0) as APL_Total_LMP,
ISNULL (APL_ANC1,0) as APL_ANC1,
ISNULL (APL_ANC2,0) as APL_ANC2,
ISNULL (APL_ANC3,0) as APL_ANC3,
ISNULL (APL_ANC4,0) as APL_ANC4,
ISNULL (APL_TT1,0) as APL_TT1,
ISNULL (APL_TT2,0) as APL_TT2,
ISNULL (APL_TTBooster,0) as APL_TTBooster,
ISNULL (APL_IFA,0) as APL_IFA,
ISNULL (APL_Delivery,0) as APL_Delivery,
ISNULL (APL_All_ANC,0) as APL_All_ANC,
ISNULL (APL_Any_three_ANC,0) as APL_Any_three_ANC,
ISNULL (BPL_Total_LMP,0) as BPL_Total_LMP,
ISNULL (BPL_ANC1,0) as BPL_ANC1,
ISNULL (BPL_ANC2,0) asBPL_ANC2,
ISNULL (BPL_ANC3,0) as BPL_ANC3,
ISNULL (BPL_ANC4,0) as BPL_ANC4,
ISNULL (BPL_TT1,0) as BPL_TT1,
ISNULL (BPL_TT2,0) as BPL_TT2,
ISNULL (BPL_TTBooster,0) as BPL_TTBooster,
ISNULL (BPL_IFA,0) as BPL_IFA,
ISNULL (BPL_Delivery,0) as BPL_Delivery,
ISNULL (BPL_All_ANC,0) as BPL_All_ANC,
ISNULL (BPL_Any_three_ANC,0) as BPL_Any_three_ANC,
ISNULL (NotKnown_Total_LMP,0) as  NotKnown_Total_LMP,
ISNULL (NotKnown_ANC1,0) as NotKnown_ANC1,
ISNULL (NotKnown_ANC2,0) as NotKnown_ANC2,
ISNULL (NotKnown_ANC3,0) as NotKnown_ANC3,
ISNULL (NotKnown_ANC4,0) as NotKnown_ANC4,
ISNULL (NotKnown_TT1,0) as NotKnown_TT1,
ISNULL (NotKnown_TT2,0) as NotKnown_TT2,
ISNULL (NotKnown_TTBooster,0) as NotKnown_TTBooster,
ISNULL (NotKnown_IFA,0) as NotKnown_IFA,
ISNULL (NotKnown_Delivery,0) as NotKnown_Delivery,
ISNULL (NotKnown_All_ANC,0) as NotKnown_All_ANC,
ISNULL (NotKnown_Any_three_ANC,0) as NotKnown_Any_three_ANC,
ISNULL (Christian_Total_LMP,0) as Christian_Total_LMP,
ISNULL (Christian_ANC1,0) as Christian_ANC1,
ISNULL (Christian_ANC2,0) as Christian_ANC2,
ISNULL (Christian_ANC3,0) as Christian_ANC3,
ISNULL (Christian_ANC4,0) as Christian_ANC4,
ISNULL (Christian_TT1,0) as Christian_TT1,
ISNULL (Christian_TT2,0) as Christian_TT2,
ISNULL (Christian_TTBooster,0) as Christian_TTBooster,
ISNULL (Christian_IFA,0) as Christian_IFA,
ISNULL (Christian_Delivery,0) as Christian_Delivery,
ISNULL (Christian_All_ANC,0) as Christian_All_ANC,
ISNULL (Christian_Any_three_ANC,0) as Christian_Any_three_ANC,
ISNULL (Hindu_Total_LMP,0) as Hindu_Total_LMP,
ISNULL (Hindu_ANC1,0) as Hindu_ANC1,
ISNULL (Hindu_ANC2,0) as Hindu_ANC2,
ISNULL (Hindu_ANC3,0) as Hindu_ANC3,
ISNULL (Hindu_ANC4,0) as Hindu_ANC4,
ISNULL (Hindu_TT1,0) as Hindu_TT1,
ISNULL (Hindu_TT2,0) as Hindu_TT2,
ISNULL (Hindu_TTBooster,0) as Hindu_TTBooster,
ISNULL (Hindu_IFA,0) as Hindu_IFA,
ISNULL (Hindun_Delivery,0) as Hindun_Delivery,
ISNULL (Hindu_All_ANC,0) as  Hindu_All_ANC,
ISNULL (Hindu_Any_three_ANC,0) as Hindu_Any_three_ANC,
ISNULL (Muslim_Total_LMP,0) as Muslim_Total_LMP,
ISNULL (Muslim_ANC1,0) as Muslim_ANC1,
ISNULL (Muslim_ANC2,0) as Muslim_ANC2,
ISNULL (Muslim_ANC3,0) as Muslim_ANC3,
ISNULL (Muslim_ANC4,0) as Muslim_ANC4,
ISNULL (Muslim_TT1,0) as Muslim_TT1,
ISNULL (Muslim_TT2,0) as Muslim_TT2,
ISNULL (Muslim_TTBooster,0) as Muslim_TTBooster,
ISNULL (Muslim_IFA,0) as Muslim_IFA,
ISNULL (Muslim_Delivery,0) as Muslim_Delivery,
ISNULL (Muslim_All_ANC,0) as Muslim_All_ANC,
ISNULL (Muslim_Any_three_ANC,0) as Muslim_Any_three_ANC,
ISNULL (Sikh_Total_LMP,0) as Sikh_Total_LMP,
ISNULL (Sikh_ANC1,0) as Sikh_ANC1,
ISNULL (Sikh_ANC2,0) as Sikh_ANC2,
ISNULL (Sikh_ANC3,0) as Sikh_ANC3,
ISNULL (Sikh_ANC4,0) as Sikh_ANC4,
ISNULL (Sikh_TT1,0) as Sikh_TT1,
ISNULL (Sikh_TT2,0) as Sikh_TT2,
ISNULL (Sikh_TTBooster,0) as Sikh_TTBooster,
ISNULL (Sikh_IFA,0) as Sikh_IFA,
ISNULL (Sikh_Delivery,0) as Sikh_Delivery,
ISNULL (Sikh_All_ANC,0) as Sikh_All_ANC,
ISNULL (Sikh_Any_three_ANC,0) as Sikh_Any_three_ANC,
ISNULL (OTHERR_Total_LMP,0) as OTHERR_Total_LMP,
ISNULL (OTHERR_ANC1,0) as  OTHERR_ANC1,
ISNULL (OTHERR_ANC2,0) as OTHERR_ANC2,
ISNULL (OTHERR_ANC3,0) as  OTHERR_ANC3,
ISNULL (OTHERR_ANC4,0) as  OTHERR_ANC4,
ISNULL (OTHERR_TT1,0) as  OTHERR_TT1,
ISNULL (OTHERR_TT2,0) as  OTHERR_TT2,
ISNULL (OTHERR_TTBooster,0) as  OTHERR_TTBooster,
ISNULL (OTHERR_IFA,0) as  OTHERR_IFA,
ISNULL (OTHERR_Delivery,0) as  OTHERR_Delivery,
ISNULL (OTHERR_All_ANC,0) as  OTHERR_All_ANC,
ISNULL (OTHERR_Any_three_ANC,0) as  OTHERR_Any_three_ANC 
 , '' as Del_Pub_Inst, '' as Del_Pvt_Inst, '' as Del_SBA, '' as Del_NonSBA, '' as Del_in_home,'' as Del_CSection_Pub_Inst,'' as Del_CSection_Pvt_Inst
,'' as Del_death,'' as Del_Due_ButNotReported
 from  
 (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
     from TBL_PHC  a
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code
	 where c.Financial_Year=@FinancialYr 
	 and  a.BID=@HealthBlock_Code 
) A
left outer join
(
  --select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code 
  select State_Code,HealthBlock_Code,HealthFacility_Code  

,SUM(Total_LMP) as Total_LMP
,SUM(ANC1) as ANC1
,SUM(ANC2) as ANC2  
,SUM(ANC3) as ANC3
,SUM(ANC4) as ANC4   
,SUM(TT1) as TT1   
,SUM(TT2) as TT2   
,SUM(TTBooster) as TTBooster 
,SUM(IFA) as IFA
,SUM(Delivery) as Delivery
,SUM(All_ANC) as All_ANC   
,SUM(Any_three_ANC) as Any_three_ANC  
 
,SUM(SC_Total_LMP) as SC_Total_LMP   
,SUM(SC_ANC1) as SC_ANC1 
,SUM(SC_ANC2) as SC_ANC2
,SUM(SC_ANC3) as SC_ANC3   
,SUM(SC_ANC4) as SC_ANC4   
,SUM(SC_TT1) as SC_TT1   
,SUM(SC_TT2) as SC_TT2 
,SUM(SC_TTBooster) as SC_TTBooster
,SUM(SC_IFA) as SC_IFA  
,SUM(SC_Delivery) as SC_Delivery 
,SUM(SC_All_ANC) as SC_All_ANC   
,SUM(SC_Any_three_ANC) as SC_Any_three_ANC 

,SUM(ST_Total_LMP) as ST_Total_LMP   
,SUM(ST_ANC1) as ST_ANC1 
,SUM(ST_ANC2) as ST_ANC2
,SUM(ST_ANC3) as ST_ANC3   
,SUM(ST_ANC4) as ST_ANC4   
,SUM(ST_TT1) as ST_TT1   
,SUM(ST_TT2) as ST_TT2 
,SUM(ST_TTBooster) as ST_TTBooster
,SUM(ST_IFA) as ST_IFA  
,SUM(ST_Delivery) as ST_Delivery 
,SUM(ST_All_ANC) as ST_All_ANC   
,SUM(ST_Any_three_ANC) as ST_Any_three_ANC 

,SUM(OTHERC_Total_LMP) as OTHERC_Total_LMP   
,SUM(OTHERC_ANC1) as OTHERC_ANC1 
,SUM(OTHERC_ANC2) as OTHERC_ANC2
,SUM(OTHERC_ANC3) as OTHERC_ANC3   
,SUM(OTHERC_ANC4) as OTHERC_ANC4   
,SUM(OTHERC_TT1) as OTHERC_TT1   
,SUM(OTHERC_TT2) as OTHERC_TT2 
,SUM(OTHERC_TTBooster) as OTHERC_TTBooster
,SUM(OTHERC_IFA) as OTHERC_IFA  
,SUM(OTHERC_Delivery) as OTHERC_Delivery 
,SUM(OTHERC_All_ANC) as OTHERC_All_ANC   
,SUM(OTHERC_Any_three_ANC) as OTHERC_Any_three_ANC 

,SUM(APL_Total_LMP) as APL_Total_LMP   
,SUM(APL_ANC1) as APL_ANC1 
,SUM(APL_ANC2) as APL_ANC2
,SUM(APL_ANC3) as APL_ANC3   
,SUM(APL_ANC4) as APL_ANC4   
,SUM(APL_TT1) as APL_TT1   
,SUM(APL_TT2) as APL_TT2 
,SUM(APL_TTBooster) as APL_TTBooster
,SUM(APL_IFA) as APL_IFA  
,SUM(APL_Delivery) as APL_Delivery 
,SUM(APL_All_ANC) as APL_All_ANC   
,SUM(APL_Any_three_ANC) as APL_Any_three_ANC 

,SUM(BPL_Total_LMP) as BPL_Total_LMP   
,SUM(BPL_ANC1) as BPL_ANC1 
,SUM(BPL_ANC2) as BPL_ANC2
,SUM(BPL_ANC3) as BPL_ANC3   
,SUM(BPL_ANC4) as BPL_ANC4   
,SUM(BPL_TT1) as BPL_TT1   
,SUM(BPL_TT2) as BPL_TT2 
,SUM(BPL_TTBooster) as BPL_TTBooster
,SUM(BPL_IFA) as BPL_IFA  
,SUM(BPL_Delivery) as BPL_Delivery 
,SUM(BPL_All_ANC) as BPL_All_ANC   
,SUM(BPL_Any_three_ANC) as BPL_Any_three_ANC 

,SUM(NotKnown_Total_LMP) as NotKnown_Total_LMP   
,SUM(NotKnown_ANC1) as NotKnown_ANC1 
,SUM(NotKnown_ANC2) as NotKnown_ANC2
,SUM(NotKnown_ANC3) as NotKnown_ANC3   
,SUM(NotKnown_ANC4) as NotKnown_ANC4   
,SUM(NotKnown_TT1) as NotKnown_TT1   
,SUM(NotKnown_TT2) as NotKnown_TT2 
,SUM(NotKnown_TTBooster) as NotKnown_TTBooster
,SUM(NotKnown_IFA) as NotKnown_IFA  
,SUM(NotKnown_Delivery) as NotKnown_Delivery 
,SUM(NotKnown_All_ANC) as NotKnown_All_ANC   
,SUM(NotKnown_Any_three_ANC) as NotKnown_Any_three_ANC 

,SUM(Christian_Total_LMP) as Christian_Total_LMP   
,SUM(Christian_ANC1) as Christian_ANC1 
,SUM(Christian_ANC2) as Christian_ANC2
,SUM(Christian_ANC3) as Christian_ANC3   
,SUM(Christian_ANC4) as Christian_ANC4   
,SUM(Christian_TT1) as Christian_TT1   
,SUM(Christian_TT2) as Christian_TT2 
,SUM(Christian_TTBooster) as Christian_TTBooster
,SUM(Christian_IFA) as Christian_IFA  
,SUM(Christian_Delivery) as Christian_Delivery 
,SUM(Christian_All_ANC) as Christian_All_ANC   
,SUM(Christian_Any_three_ANC) as Christian_Any_three_ANC 

,SUM(Hindu_Total_LMP) as Hindu_Total_LMP   
,SUM(Hindu_ANC1) as Hindu_ANC1 
,SUM(Hindu_ANC2) as Hindu_ANC2
,SUM(Hindu_ANC3) as Hindu_ANC3   
,SUM(Hindu_ANC4) as Hindu_ANC4   
,SUM(Hindu_TT1) as Hindu_TT1   
,SUM(Hindu_TT2) as Hindu_TT2 
,SUM(Hindu_TTBooster) as Hindu_TTBooster
,SUM(Hindu_IFA) as Hindu_IFA  
,SUM(Hindun_Delivery) as Hindun_Delivery 
,SUM(Hindu_All_ANC) as Hindu_All_ANC   
,SUM(Hindu_Any_three_ANC) as Hindu_Any_three_ANC  
 
,SUM(Muslim_Total_LMP) as Muslim_Total_LMP   
,SUM(Muslim_ANC1) as Muslim_ANC1 
,SUM(Muslim_ANC2) as Muslim_ANC2
,SUM(Muslim_ANC3) as Muslim_ANC3   
,SUM(Muslim_ANC4) as Muslim_ANC4   
,SUM(Muslim_TT1) as Muslim_TT1   
,SUM(Muslim_TT2) as Muslim_TT2 
,SUM(Muslim_TTBooster) as Muslim_TTBooster
,SUM(Muslim_IFA) as Muslim_IFA  
,SUM(Muslim_Delivery) as Muslim_Delivery 
,SUM(Muslim_All_ANC) as Muslim_All_ANC   
,SUM(Muslim_Any_three_ANC) as Muslim_Any_three_ANC  
 
 ,SUM(Sikh_Total_LMP) as Sikh_Total_LMP   
,SUM(Sikh_ANC1) as Sikh_ANC1 
,SUM(Sikh_ANC2) as Sikh_ANC2
,SUM(Sikh_ANC3) as Sikh_ANC3   
,SUM(Sikh_ANC4) as Sikh_ANC4   
,SUM(Sikh_TT1) as Sikh_TT1   
,SUM(Sikh_TT2) as Sikh_TT2 
,SUM(Sikh_TTBooster) as Sikh_TTBooster
,SUM(Sikh_IFA) as Sikh_IFA  
,SUM(Sikh_Delivery) as Sikh_Delivery 
,SUM(Sikh_All_ANC) as Sikh_All_ANC   
,SUM(Sikh_Any_three_ANC) as Sikh_Any_three_ANC  
 
 ,SUM(OTHERR_Total_LMP) as OTHERR_Total_LMP   
,SUM(OTHERR_ANC1) as OTHERR_ANC1 
,SUM(OTHERR_ANC2) as OTHERR_ANC2
,SUM(OTHERR_ANC3) as OTHERR_ANC3   
,SUM(OTHERR_ANC4) as OTHERR_ANC4   
,SUM(OTHERR_TT1) as OTHERR_TT1   
,SUM(OTHERR_TT2) as OTHERR_TT2 
,SUM(OTHERR_TTBooster) as OTHERR_TTBooster
,SUM(OTHERR_IFA) as OTHERR_IFA  
,SUM(OTHERR_Delivery) as OTHERR_Delivery 
,SUM(OTHERR_All_ANC) as OTHERR_All_ANC   
,SUM(OTHERR_Any_three_ANC) as OTHERR_Any_three_ANC 
          
   from dbo.Scheduled_Tracking_Block_PHC_Day as CH  
 where State_Code =@State_Code
 and HealthBlock_Code =@HealthBlock_Code   
 and Fin_Yr=@FinancialYr
 and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by State_Code,HealthBlock_Code,HealthFacility_Code
  
 
-- CH.State_Code =@State_Code
-- and CH.District_Code=@District_Code
-- and Fin_Yr=@FinancialYr 
--  and (Month_ID=@Month_ID or @Month_ID=0)
-- and (Year_ID=@Year_ID or @Year_ID=0)
-- group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code
 )  B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code
end
else if(@Category='PHC')
begin
select A.HealthFacility_Code as ParentID,A.HealthFacility_Name as ParentName ,A.HealthSubFacility_Code as ChildID,A.HealthSubFacility_Name as ChildName,
ISNULL(Total_LMP,0) as Total_LMP,
ISNULL (ANC1,0) as ANC1,
ISNULL (ANC2,0) as ANC2,
ISNULL (ANC3,0) as ANC3,
ISNULL (ANC4,0) as ANC4,
ISNULL (TT1,0) as TT1,
ISNULL (TT2,0) as TT2,
ISNULL (TTBooster,0) as TTBooster,
ISNULL (IFA,0) as IFA,
ISNULL (Delivery,0) as Delivery,
ISNULL (All_ANC,0) as All_ANC,
ISNULL (Any_three_ANC,0) as Any_three_ANC,
ISNULL (SC_Total_LMP,0) as SC_Total_LMP,
ISNULL (SC_ANC1,0) as SC_ANC1,
ISNULL (SC_ANC2,0)as SC_ANC2,
ISNULL (SC_ANC3,0) as  SC_ANC3,
ISNULL (SC_ANC4,0) as SC_ANC4,
ISNULL (SC_TT1,0) as SC_TT1,
ISNULL (SC_TT2,0)as SC_TT2,
ISNULL (SC_TTBooster,0) as SC_TTBooster,
isnull (SC_IFA,0) as SC_IFA,
ISNULL (SC_Delivery,0) as SC_Delivery,
ISNULL (SC_All_ANC,0) as SC_All_ANC,
ISNULL (SC_Any_three_ANC,0) as SC_Any_three_ANC,
ISNULL (ST_Total_LMP,0) as ST_Total_LMP,
ISNULL (ST_ANC1,0)as  ST_ANC1,
ISNULL (ST_ANC2,0)as ST_ANC2,
ISNULL (ST_ANC3,0)as ST_ANC3,
ISNULL (ST_ANC4,0)as ST_ANC4,
isnull (ST_TT1,0) as ST_TT1,
ISNULL(ST_TT2,0) as ST_TT2,
ISNULL(ST_TTBooster,0) as ST_TTBooster,
ISNULL(ST_IFA,0) as ST_IFA,
ISNULL(ST_Delivery,0) as ST_Delivery,
ISNULL(ST_All_ANC,0) as ST_All_ANC,
ISNULL(ST_Any_three_ANC,0) as ST_Any_three_ANC,
ISNULL(OTHERC_Total_LMP,0) as OTHERC_Total_LMP,
ISNULL(OTHERC_ANC1,0) as OTHERC_ANC1,
ISNULL(OTHERC_ANC2,0) as OTHERC_ANC2,
ISNULL(OTHERC_ANC3,0) as OTHERC_ANC3,
ISNULL(OTHERC_ANC4,0) as OTHERC_ANC4,
ISNULL(OTHERC_TT1,0) as OTHERC_TT1,
ISNULL(OTHERC_TT2,0) as OTHERC_TT2,
ISNULL(OTHERC_TTBooster,0) as OTHERC_TTBooster,
ISNULL(OTHERC_IFA,0) as OTHERC_IFA,
ISNULL(OTHERC_Delivery,0) as OTHERC_Delivery,
ISNULL(OTHERC_All_ANC,0) as OTHERC_All_ANC,
ISNULL(OTHERC_Any_three_ANC,0) as OTHERC_Any_three_ANC,
ISNULL (APL_Total_LMP,0) as APL_Total_LMP,
ISNULL (APL_ANC1,0) as APL_ANC1,
ISNULL (APL_ANC2,0) as APL_ANC2,
ISNULL (APL_ANC3,0) as APL_ANC3,
ISNULL (APL_ANC4,0) as APL_ANC4,
ISNULL (APL_TT1,0) as APL_TT1,
ISNULL (APL_TT2,0) as APL_TT2,
ISNULL (APL_TTBooster,0) as APL_TTBooster,
ISNULL (APL_IFA,0) as APL_IFA,
ISNULL (APL_Delivery,0) as APL_Delivery,
ISNULL (APL_All_ANC,0) as APL_All_ANC,
ISNULL (APL_Any_three_ANC,0) as APL_Any_three_ANC,
ISNULL (BPL_Total_LMP,0) as BPL_Total_LMP,
ISNULL (BPL_ANC1,0) as BPL_ANC1,
ISNULL (BPL_ANC2,0) asBPL_ANC2,
ISNULL (BPL_ANC3,0) as BPL_ANC3,
ISNULL (BPL_ANC4,0) as BPL_ANC4,
ISNULL (BPL_TT1,0) as BPL_TT1,
ISNULL (BPL_TT2,0) as BPL_TT2,
ISNULL (BPL_TTBooster,0) as BPL_TTBooster,
ISNULL (BPL_IFA,0) as BPL_IFA,
ISNULL (BPL_Delivery,0) as BPL_Delivery,
ISNULL (BPL_All_ANC,0) as BPL_All_ANC,
ISNULL (BPL_Any_three_ANC,0) as BPL_Any_three_ANC,
ISNULL (NotKnown_Total_LMP,0) as  NotKnown_Total_LMP,
ISNULL (NotKnown_ANC1,0) as NotKnown_ANC1,
ISNULL (NotKnown_ANC2,0) as NotKnown_ANC2,
ISNULL (NotKnown_ANC3,0) as NotKnown_ANC3,
ISNULL (NotKnown_ANC4,0) as NotKnown_ANC4,
ISNULL (NotKnown_TT1,0) as NotKnown_TT1,
ISNULL (NotKnown_TT2,0) as NotKnown_TT2,
ISNULL (NotKnown_TTBooster,0) as NotKnown_TTBooster,
ISNULL (NotKnown_IFA,0) as NotKnown_IFA,
ISNULL (NotKnown_Delivery,0) as NotKnown_Delivery,
ISNULL (NotKnown_All_ANC,0) as NotKnown_All_ANC,
ISNULL (NotKnown_Any_three_ANC,0) as NotKnown_Any_three_ANC,
ISNULL (Christian_Total_LMP,0) as Christian_Total_LMP,
ISNULL (Christian_ANC1,0) as Christian_ANC1,
ISNULL (Christian_ANC2,0) as Christian_ANC2,
ISNULL (Christian_ANC3,0) as Christian_ANC3,
ISNULL (Christian_ANC4,0) as Christian_ANC4,
ISNULL (Christian_TT1,0) as Christian_TT1,
ISNULL (Christian_TT2,0) as Christian_TT2,
ISNULL (Christian_TTBooster,0) as Christian_TTBooster,
ISNULL (Christian_IFA,0) as Christian_IFA,
ISNULL (Christian_Delivery,0) as Christian_Delivery,
ISNULL (Christian_All_ANC,0) as Christian_All_ANC,
ISNULL (Christian_Any_three_ANC,0) as Christian_Any_three_ANC,
ISNULL (Hindu_Total_LMP,0) as Hindu_Total_LMP,
ISNULL (Hindu_ANC1,0) as Hindu_ANC1,
ISNULL (Hindu_ANC2,0) as Hindu_ANC2,
ISNULL (Hindu_ANC3,0) as Hindu_ANC3,
ISNULL (Hindu_ANC4,0) as Hindu_ANC4,
ISNULL (Hindu_TT1,0) as Hindu_TT1,
ISNULL (Hindu_TT2,0) as Hindu_TT2,
ISNULL (Hindu_TTBooster,0) as Hindu_TTBooster,
ISNULL (Hindu_IFA,0) as Hindu_IFA,
ISNULL (Hindun_Delivery,0) as Hindun_Delivery,
ISNULL (Hindu_All_ANC,0) as  Hindu_All_ANC,
ISNULL (Hindu_Any_three_ANC,0) as Hindu_Any_three_ANC,
ISNULL (Muslim_Total_LMP,0) as Muslim_Total_LMP,
ISNULL (Muslim_ANC1,0) as Muslim_ANC1,
ISNULL (Muslim_ANC2,0) as Muslim_ANC2,
ISNULL (Muslim_ANC3,0) as Muslim_ANC3,
ISNULL (Muslim_ANC4,0) as Muslim_ANC4,
ISNULL (Muslim_TT1,0) as Muslim_TT1,
ISNULL (Muslim_TT2,0) as Muslim_TT2,
ISNULL (Muslim_TTBooster,0) as Muslim_TTBooster,
ISNULL (Muslim_IFA,0) as Muslim_IFA,
ISNULL (Muslim_Delivery,0) as Muslim_Delivery,
ISNULL (Muslim_All_ANC,0) as Muslim_All_ANC,
ISNULL (Muslim_Any_three_ANC,0) as Muslim_Any_three_ANC,
ISNULL (Sikh_Total_LMP,0) as Sikh_Total_LMP,
ISNULL (Sikh_ANC1,0) as Sikh_ANC1,
ISNULL (Sikh_ANC2,0) as Sikh_ANC2,
ISNULL (Sikh_ANC3,0) as Sikh_ANC3,
ISNULL (Sikh_ANC4,0) as Sikh_ANC4,
ISNULL (Sikh_TT1,0) as Sikh_TT1,
ISNULL (Sikh_TT2,0) as Sikh_TT2,
ISNULL (Sikh_TTBooster,0) as Sikh_TTBooster,
ISNULL (Sikh_IFA,0) as Sikh_IFA,
ISNULL (Sikh_Delivery,0) as Sikh_Delivery,
ISNULL (Sikh_All_ANC,0) as Sikh_All_ANC,
ISNULL (Sikh_Any_three_ANC,0) as Sikh_Any_three_ANC,
ISNULL (OTHERR_Total_LMP,0) as OTHERR_Total_LMP,
ISNULL (OTHERR_ANC1,0) as  OTHERR_ANC1,
ISNULL (OTHERR_ANC2,0) as OTHERR_ANC2,
ISNULL (OTHERR_ANC3,0) as  OTHERR_ANC3,
ISNULL (OTHERR_ANC4,0) as  OTHERR_ANC4,
ISNULL (OTHERR_TT1,0) as  OTHERR_TT1,
ISNULL (OTHERR_TT2,0) as  OTHERR_TT2,
ISNULL (OTHERR_TTBooster,0) as  OTHERR_TTBooster,
ISNULL (OTHERR_IFA,0) as  OTHERR_IFA,
ISNULL (OTHERR_Delivery,0) as  OTHERR_Delivery,
ISNULL (OTHERR_All_ANC,0) as  OTHERR_All_ANC,
ISNULL (OTHERR_Any_three_ANC,0) as  OTHERR_Any_three_ANC
, '' as Del_Pub_Inst, '' as Del_Pvt_Inst, '' as Del_SBA, '' as Del_NonSBA, '' as Del_in_home,'' as Del_CSection_Pub_Inst,'' as Del_CSection_Pvt_Inst
,'' as Del_death,'' as Del_Due_ButNotReported  from 
 (select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
      from TBL_SUBPHC a
	  inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
      inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code
     where c.Financial_Year=@FinancialYr 
     and ( a.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)
) A
left outer join
(
 select State_Code,HealthFacility_Code,HealthSubFacility_Code
,SUM(Total_LMP) as Total_LMP
,SUM(ANC1) as ANC1
,SUM(ANC2) as ANC2  
,SUM(ANC3) as ANC3
,SUM(ANC4) as ANC4   
,SUM(TT1) as TT1   
,SUM(TT2) as TT2   
,SUM(TTBooster) as TTBooster 
,SUM(IFA) as IFA
,SUM(Delivery) as Delivery
,SUM(All_ANC) as All_ANC   
,SUM(Any_three_ANC) as Any_three_ANC  
 
,SUM(SC_Total_LMP) as SC_Total_LMP   
,SUM(SC_ANC1) as SC_ANC1 
,SUM(SC_ANC2) as SC_ANC2
,SUM(SC_ANC3) as SC_ANC3   
,SUM(SC_ANC4) as SC_ANC4   
,SUM(SC_TT1) as SC_TT1   
,SUM(SC_TT2) as SC_TT2 
,SUM(SC_TTBooster) as SC_TTBooster
,SUM(SC_IFA) as SC_IFA  
,SUM(SC_Delivery) as SC_Delivery 
,SUM(SC_All_ANC) as SC_All_ANC   
,SUM(SC_Any_three_ANC) as SC_Any_three_ANC 

,SUM(ST_Total_LMP) as ST_Total_LMP   
,SUM(ST_ANC1) as ST_ANC1 
,SUM(ST_ANC2) as ST_ANC2
,SUM(ST_ANC3) as ST_ANC3   
,SUM(ST_ANC4) as ST_ANC4   
,SUM(ST_TT1) as ST_TT1   
,SUM(ST_TT2) as ST_TT2 
,SUM(ST_TTBooster) as ST_TTBooster
,SUM(ST_IFA) as ST_IFA  
,SUM(ST_Delivery) as ST_Delivery 
,SUM(ST_All_ANC) as ST_All_ANC   
,SUM(ST_Any_three_ANC) as ST_Any_three_ANC 

,SUM(OTHERC_Total_LMP) as OTHERC_Total_LMP   
,SUM(OTHERC_ANC1) as OTHERC_ANC1 
,SUM(OTHERC_ANC2) as OTHERC_ANC2
,SUM(OTHERC_ANC3) as OTHERC_ANC3   
,SUM(OTHERC_ANC4) as OTHERC_ANC4   
,SUM(OTHERC_TT1) as OTHERC_TT1   
,SUM(OTHERC_TT2) as OTHERC_TT2 
,SUM(OTHERC_TTBooster) as OTHERC_TTBooster
,SUM(OTHERC_IFA) as OTHERC_IFA  
,SUM(OTHERC_Delivery) as OTHERC_Delivery 
,SUM(OTHERC_All_ANC) as OTHERC_All_ANC   
,SUM(OTHERC_Any_three_ANC) as OTHERC_Any_three_ANC 

,SUM(APL_Total_LMP) as APL_Total_LMP   
,SUM(APL_ANC1) as APL_ANC1 
,SUM(APL_ANC2) as APL_ANC2
,SUM(APL_ANC3) as APL_ANC3   
,SUM(APL_ANC4) as APL_ANC4   
,SUM(APL_TT1) as APL_TT1   
,SUM(APL_TT2) as APL_TT2 
,SUM(APL_TTBooster) as APL_TTBooster
,SUM(APL_IFA) as APL_IFA  
,SUM(APL_Delivery) as APL_Delivery 
,SUM(APL_All_ANC) as APL_All_ANC   
,SUM(APL_Any_three_ANC) as APL_Any_three_ANC 

,SUM(BPL_Total_LMP) as BPL_Total_LMP   
,SUM(BPL_ANC1) as BPL_ANC1 
,SUM(BPL_ANC2) as BPL_ANC2
,SUM(BPL_ANC3) as BPL_ANC3   
,SUM(BPL_ANC4) as BPL_ANC4   
,SUM(BPL_TT1) as BPL_TT1   
,SUM(BPL_TT2) as BPL_TT2 
,SUM(BPL_TTBooster) as BPL_TTBooster
,SUM(BPL_IFA) as BPL_IFA  
,SUM(BPL_Delivery) as BPL_Delivery 
,SUM(BPL_All_ANC) as BPL_All_ANC   
,SUM(BPL_Any_three_ANC) as BPL_Any_three_ANC 

,SUM(NotKnown_Total_LMP) as NotKnown_Total_LMP   
,SUM(NotKnown_ANC1) as NotKnown_ANC1 
,SUM(NotKnown_ANC2) as NotKnown_ANC2
,SUM(NotKnown_ANC3) as NotKnown_ANC3   
,SUM(NotKnown_ANC4) as NotKnown_ANC4   
,SUM(NotKnown_TT1) as NotKnown_TT1   
,SUM(NotKnown_TT2) as NotKnown_TT2 
,SUM(NotKnown_TTBooster) as NotKnown_TTBooster
,SUM(NotKnown_IFA) as NotKnown_IFA  
,SUM(NotKnown_Delivery) as NotKnown_Delivery 
,SUM(NotKnown_All_ANC) as NotKnown_All_ANC   
,SUM(NotKnown_Any_three_ANC) as NotKnown_Any_three_ANC 

,SUM(Christian_Total_LMP) as Christian_Total_LMP   
,SUM(Christian_ANC1) as Christian_ANC1 
,SUM(Christian_ANC2) as Christian_ANC2
,SUM(Christian_ANC3) as Christian_ANC3   
,SUM(Christian_ANC4) as Christian_ANC4   
,SUM(Christian_TT1) as Christian_TT1   
,SUM(Christian_TT2) as Christian_TT2 
,SUM(Christian_TTBooster) as Christian_TTBooster
,SUM(Christian_IFA) as Christian_IFA  
,SUM(Christian_Delivery) as Christian_Delivery 
,SUM(Christian_All_ANC) as Christian_All_ANC   
,SUM(Christian_Any_three_ANC) as Christian_Any_three_ANC 

,SUM(Hindu_Total_LMP) as Hindu_Total_LMP   
,SUM(Hindu_ANC1) as Hindu_ANC1 
,SUM(Hindu_ANC2) as Hindu_ANC2
,SUM(Hindu_ANC3) as Hindu_ANC3   
,SUM(Hindu_ANC4) as Hindu_ANC4   
,SUM(Hindu_TT1) as Hindu_TT1   
,SUM(Hindu_TT2) as Hindu_TT2 
,SUM(Hindu_TTBooster) as Hindu_TTBooster
,SUM(Hindu_IFA) as Hindu_IFA  
,SUM(Hindun_Delivery) as Hindun_Delivery 
,SUM(Hindu_All_ANC) as Hindu_All_ANC   
,SUM(Hindu_Any_three_ANC) as Hindu_Any_three_ANC  
 
,SUM(Muslim_Total_LMP) as Muslim_Total_LMP   
,SUM(Muslim_ANC1) as Muslim_ANC1 
,SUM(Muslim_ANC2) as Muslim_ANC2
,SUM(Muslim_ANC3) as Muslim_ANC3   
,SUM(Muslim_ANC4) as Muslim_ANC4   
,SUM(Muslim_TT1) as Muslim_TT1   
,SUM(Muslim_TT2) as Muslim_TT2 
,SUM(Muslim_TTBooster) as Muslim_TTBooster
,SUM(Muslim_IFA) as Muslim_IFA  
,SUM(Muslim_Delivery) as Muslim_Delivery 
,SUM(Muslim_All_ANC) as Muslim_All_ANC   
,SUM(Muslim_Any_three_ANC) as Muslim_Any_three_ANC  
 
 ,SUM(Sikh_Total_LMP) as Sikh_Total_LMP   
,SUM(Sikh_ANC1) as Sikh_ANC1 
,SUM(Sikh_ANC2) as Sikh_ANC2
,SUM(Sikh_ANC3) as Sikh_ANC3   
,SUM(Sikh_ANC4) as Sikh_ANC4   
,SUM(Sikh_TT1) as Sikh_TT1   
,SUM(Sikh_TT2) as Sikh_TT2 
,SUM(Sikh_TTBooster) as Sikh_TTBooster
,SUM(Sikh_IFA) as Sikh_IFA  
,SUM(Sikh_Delivery) as Sikh_Delivery 
,SUM(Sikh_All_ANC) as Sikh_All_ANC   
,SUM(Sikh_Any_three_ANC) as Sikh_Any_three_ANC  
 
 ,SUM(OTHERR_Total_LMP) as OTHERR_Total_LMP   
,SUM(OTHERR_ANC1) as OTHERR_ANC1 
,SUM(OTHERR_ANC2) as OTHERR_ANC2
,SUM(OTHERR_ANC3) as OTHERR_ANC3   
,SUM(OTHERR_ANC4) as OTHERR_ANC4   
,SUM(OTHERR_TT1) as OTHERR_TT1   
,SUM(OTHERR_TT2) as OTHERR_TT2 
,SUM(OTHERR_TTBooster) as OTHERR_TTBooster
,SUM(OTHERR_IFA) as OTHERR_IFA  
,SUM(OTHERR_Delivery) as OTHERR_Delivery 
,SUM(OTHERR_All_ANC) as OTHERR_All_ANC   
,SUM(OTHERR_Any_three_ANC) as OTHERR_Any_three_ANC
          
   from dbo.Scheduled_Tracking_PHC_SubCenter_Day as CH  
 where State_Code =@State_Code
 and HealthFacility_Code =@HealthFacility_Code   
 and Fin_Yr=@FinancialYr 
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.HealthFacility_Code,CH.HealthSubFacility_Code
 )  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code
end

else if(@Category='Subcentre')
begin
select A.HealthSubFacility_Code as ParentID,A.HealthSubFacility_Name as ParentName ,A.Village_Code as ChildID,A.Village_Name as ChildName,

ISNULL(Total_LMP,0) as Total_LMP,
ISNULL (ANC1,0) as ANC1,
ISNULL (ANC2,0) as ANC2,
ISNULL (ANC3,0) as ANC3,
ISNULL (ANC4,0) as ANC4,
ISNULL (TT1,0) as TT1,
ISNULL (TT2,0) as TT2,
ISNULL (TTBooster,0) as TTBooster,
ISNULL (IFA,0) as IFA,
ISNULL (Delivery,0) as Delivery,
ISNULL (All_ANC,0) as All_ANC,
ISNULL (Any_three_ANC,0) as Any_three_ANC,
ISNULL (SC_Total_LMP,0) as SC_Total_LMP,
ISNULL (SC_ANC1,0) as SC_ANC1,
ISNULL (SC_ANC2,0)as SC_ANC2,
ISNULL (SC_ANC3,0) as  SC_ANC3,
ISNULL (SC_ANC4,0) as SC_ANC4,
ISNULL (SC_TT1,0) as SC_TT1,
ISNULL (SC_TT2,0)as SC_TT2,
ISNULL (SC_TTBooster,0) as SC_TTBooster,
isnull (SC_IFA,0) as SC_IFA,
ISNULL (SC_Delivery,0) as SC_Delivery,
ISNULL (SC_All_ANC,0) as SC_All_ANC,
ISNULL (SC_Any_three_ANC,0) as SC_Any_three_ANC,
ISNULL (ST_Total_LMP,0) as ST_Total_LMP,
ISNULL (ST_ANC1,0)as  ST_ANC1,
ISNULL (ST_ANC2,0)as ST_ANC2,
ISNULL (ST_ANC3,0)as ST_ANC3,
ISNULL (ST_ANC4,0)as ST_ANC4,
isnull (ST_TT1,0) as ST_TT1,
ISNULL(ST_TT2,0) as ST_TT2,
ISNULL(ST_TTBooster,0) as ST_TTBooster,
ISNULL(ST_IFA,0) as ST_IFA,
ISNULL(ST_Delivery,0) as ST_Delivery,
ISNULL(ST_All_ANC,0) as ST_All_ANC,
ISNULL(ST_Any_three_ANC,0) as ST_Any_three_ANC,
ISNULL(OTHERC_Total_LMP,0) as OTHERC_Total_LMP,
ISNULL(OTHERC_ANC1,0) as OTHERC_ANC1,
ISNULL(OTHERC_ANC2,0) as OTHERC_ANC2,
ISNULL(OTHERC_ANC3,0) as OTHERC_ANC3,
ISNULL(OTHERC_ANC4,0) as OTHERC_ANC4,
ISNULL(OTHERC_TT1,0) as OTHERC_TT1,
ISNULL(OTHERC_TT2,0) as OTHERC_TT2,
ISNULL(OTHERC_TTBooster,0) as OTHERC_TTBooster,
ISNULL(OTHERC_IFA,0) as OTHERC_IFA,
ISNULL(OTHERC_Delivery,0) as OTHERC_Delivery,
ISNULL(OTHERC_All_ANC,0) as OTHERC_All_ANC,
ISNULL(OTHERC_Any_three_ANC,0) as OTHERC_Any_three_ANC,
ISNULL (APL_Total_LMP,0) as APL_Total_LMP,
ISNULL (APL_ANC1,0) as APL_ANC1,
ISNULL (APL_ANC2,0) as APL_ANC2,
ISNULL (APL_ANC3,0) as APL_ANC3,
ISNULL (APL_ANC4,0) as APL_ANC4,
ISNULL (APL_TT1,0) as APL_TT1,
ISNULL (APL_TT2,0) as APL_TT2,
ISNULL (APL_TTBooster,0) as APL_TTBooster,
ISNULL (APL_IFA,0) as APL_IFA,
ISNULL (APL_Delivery,0) as APL_Delivery,
ISNULL (APL_All_ANC,0) as APL_All_ANC,
ISNULL (APL_Any_three_ANC,0) as APL_Any_three_ANC,
ISNULL (BPL_Total_LMP,0) as BPL_Total_LMP,
ISNULL (BPL_ANC1,0) as BPL_ANC1,
ISNULL (BPL_ANC2,0) asBPL_ANC2,
ISNULL (BPL_ANC3,0) as BPL_ANC3,
ISNULL (BPL_ANC4,0) as BPL_ANC4,
ISNULL (BPL_TT1,0) as BPL_TT1,
ISNULL (BPL_TT2,0) as BPL_TT2,
ISNULL (BPL_TTBooster,0) as BPL_TTBooster,
ISNULL (BPL_IFA,0) as BPL_IFA,
ISNULL (BPL_Delivery,0) as BPL_Delivery,
ISNULL (BPL_All_ANC,0) as BPL_All_ANC,
ISNULL (BPL_Any_three_ANC,0) as BPL_Any_three_ANC,
ISNULL (NotKnown_Total_LMP,0) as  NotKnown_Total_LMP,
ISNULL (NotKnown_ANC1,0) as NotKnown_ANC1,
ISNULL (NotKnown_ANC2,0) as NotKnown_ANC2,
ISNULL (NotKnown_ANC3,0) as NotKnown_ANC3,
ISNULL (NotKnown_ANC4,0) as NotKnown_ANC4,
ISNULL (NotKnown_TT1,0) as NotKnown_TT1,
ISNULL (NotKnown_TT2,0) as NotKnown_TT2,
ISNULL (NotKnown_TTBooster,0) as NotKnown_TTBooster,
ISNULL (NotKnown_IFA,0) as NotKnown_IFA,
ISNULL (NotKnown_Delivery,0) as NotKnown_Delivery,
ISNULL (NotKnown_All_ANC,0) as NotKnown_All_ANC,
ISNULL (NotKnown_Any_three_ANC,0) as NotKnown_Any_three_ANC,
ISNULL (Christian_Total_LMP,0) as Christian_Total_LMP,
ISNULL (Christian_ANC1,0) as Christian_ANC1,
ISNULL (Christian_ANC2,0) as Christian_ANC2,
ISNULL (Christian_ANC3,0) as Christian_ANC3,
ISNULL (Christian_ANC4,0) as Christian_ANC4,
ISNULL (Christian_TT1,0) as Christian_TT1,
ISNULL (Christian_TT2,0) as Christian_TT2,
ISNULL (Christian_TTBooster,0) as Christian_TTBooster,
ISNULL (Christian_IFA,0) as Christian_IFA,
ISNULL (Christian_Delivery,0) as Christian_Delivery,
ISNULL (Christian_All_ANC,0) as Christian_All_ANC,
ISNULL (Christian_Any_three_ANC,0) as Christian_Any_three_ANC,
ISNULL (Hindu_Total_LMP,0) as Hindu_Total_LMP,
ISNULL (Hindu_ANC1,0) as Hindu_ANC1,
ISNULL (Hindu_ANC2,0) as Hindu_ANC2,
ISNULL (Hindu_ANC3,0) as Hindu_ANC3,
ISNULL (Hindu_ANC4,0) as Hindu_ANC4,
ISNULL (Hindu_TT1,0) as Hindu_TT1,
ISNULL (Hindu_TT2,0) as Hindu_TT2,
ISNULL (Hindu_TTBooster,0) as Hindu_TTBooster,
ISNULL (Hindu_IFA,0) as Hindu_IFA,
ISNULL (Hindun_Delivery,0) as Hindun_Delivery,
ISNULL (Hindu_All_ANC,0) as  Hindu_All_ANC,
ISNULL (Hindu_Any_three_ANC,0) as Hindu_Any_three_ANC,
ISNULL (Muslim_Total_LMP,0) as Muslim_Total_LMP,
ISNULL (Muslim_ANC1,0) as Muslim_ANC1,
ISNULL (Muslim_ANC2,0) as Muslim_ANC2,
ISNULL (Muslim_ANC3,0) as Muslim_ANC3,
ISNULL (Muslim_ANC4,0) as Muslim_ANC4,
ISNULL (Muslim_TT1,0) as Muslim_TT1,
ISNULL (Muslim_TT2,0) as Muslim_TT2,
ISNULL (Muslim_TTBooster,0) as Muslim_TTBooster,
ISNULL (Muslim_IFA,0) as Muslim_IFA,
ISNULL (Muslim_Delivery,0) as Muslim_Delivery,
ISNULL (Muslim_All_ANC,0) as Muslim_All_ANC,
ISNULL (Muslim_Any_three_ANC,0) as Muslim_Any_three_ANC,
ISNULL (Sikh_Total_LMP,0) as Sikh_Total_LMP,
ISNULL (Sikh_ANC1,0) as Sikh_ANC1,
ISNULL (Sikh_ANC2,0) as Sikh_ANC2,
ISNULL (Sikh_ANC3,0) as Sikh_ANC3,
ISNULL (Sikh_ANC4,0) as Sikh_ANC4,
ISNULL (Sikh_TT1,0) as Sikh_TT1,
ISNULL (Sikh_TT2,0) as Sikh_TT2,
ISNULL (Sikh_TTBooster,0) as Sikh_TTBooster,
ISNULL (Sikh_IFA,0) as Sikh_IFA,
ISNULL (Sikh_Delivery,0) as Sikh_Delivery,
ISNULL (Sikh_All_ANC,0) as Sikh_All_ANC,
ISNULL (Sikh_Any_three_ANC,0) as Sikh_Any_three_ANC,
ISNULL (OTHERR_Total_LMP,0) as OTHERR_Total_LMP,
ISNULL (OTHERR_ANC1,0) as  OTHERR_ANC1,
ISNULL (OTHERR_ANC2,0) as OTHERR_ANC2,
ISNULL (OTHERR_ANC3,0) as  OTHERR_ANC3,
ISNULL (OTHERR_ANC4,0) as  OTHERR_ANC4,
ISNULL (OTHERR_TT1,0) as  OTHERR_TT1,
ISNULL (OTHERR_TT2,0) as  OTHERR_TT2,
ISNULL (OTHERR_TTBooster,0) as  OTHERR_TTBooster,
ISNULL (OTHERR_IFA,0) as  OTHERR_IFA,
ISNULL (OTHERR_Delivery,0) as  OTHERR_Delivery,
ISNULL (OTHERR_All_ANC,0) as  OTHERR_All_ANC,
ISNULL (OTHERR_Any_three_ANC,0) as  OTHERR_Any_three_ANC
, '' as Del_Pub_Inst, '' as Del_Pvt_Inst, '' as Del_SBA, '' as Del_NonSBA, '' as Del_in_home,'' as Del_CSection_Pub_Inst,'' as Del_CSection_Pvt_Inst
,'' as Del_death,'' as Del_Due_ButNotReported  from 
 (select c.State_Code,a.SUBPHC_CD as HealthSubFacility_Code,b.SUBPHC_NAME as HealthSubFacility_Name ,a.VILLAGE_CD as Village_Code,a.VILLAGE_NAME as Village_Name
      from TBL_VILLAGE a
	  inner join TBL_SUBPHC b on a.SUBPHC_CD=b.SUBPHC_CD
      inner join  Estimated_Data_Village_Wise c on a.VILLAGE_CD=c.Village_Code
     where c.Financial_Year=@FinancialYr 
     and ( a.SubPHC_CD= @HealthSubFacility_Code or @HealthSubFacility_Code=0)----line edidted by sneha on 29072016
) A
left outer join
(
 select State_Code,HealthSubFacility_Code,Village_Code
,SUM(Total_LMP) as Total_LMP
,SUM(ANC1) as ANC1
,SUM(ANC2) as ANC2  
,SUM(ANC3) as ANC3
,SUM(ANC4) as ANC4   
,SUM(TT1) as TT1   
,SUM(TT2) as TT2   
,SUM(TTBooster) as TTBooster 
,SUM(IFA) as IFA
,SUM(Delivery) as Delivery
,SUM(All_ANC) as All_ANC   
,SUM(Any_three_ANC) as Any_three_ANC  
 
,SUM(SC_Total_LMP) as SC_Total_LMP   
,SUM(SC_ANC1) as SC_ANC1 
,SUM(SC_ANC2) as SC_ANC2
,SUM(SC_ANC3) as SC_ANC3   
,SUM(SC_ANC4) as SC_ANC4   
,SUM(SC_TT1) as SC_TT1   
,SUM(SC_TT2) as SC_TT2 
,SUM(SC_TTBooster) as SC_TTBooster
,SUM(SC_IFA) as SC_IFA  
,SUM(SC_Delivery) as SC_Delivery 
,SUM(SC_All_ANC) as SC_All_ANC   
,SUM(SC_Any_three_ANC) as SC_Any_three_ANC 

,SUM(ST_Total_LMP) as ST_Total_LMP   
,SUM(ST_ANC1) as ST_ANC1 
,SUM(ST_ANC2) as ST_ANC2
,SUM(ST_ANC3) as ST_ANC3   
,SUM(ST_ANC4) as ST_ANC4   
,SUM(ST_TT1) as ST_TT1   
,SUM(ST_TT2) as ST_TT2 
,SUM(ST_TTBooster) as ST_TTBooster
,SUM(ST_IFA) as ST_IFA  
,SUM(ST_Delivery) as ST_Delivery 
,SUM(ST_All_ANC) as ST_All_ANC   
,SUM(ST_Any_three_ANC) as ST_Any_three_ANC 

,SUM(OTHERC_Total_LMP) as OTHERC_Total_LMP   
,SUM(OTHERC_ANC1) as OTHERC_ANC1 
,SUM(OTHERC_ANC2) as OTHERC_ANC2
,SUM(OTHERC_ANC3) as OTHERC_ANC3   
,SUM(OTHERC_ANC4) as OTHERC_ANC4   
,SUM(OTHERC_TT1) as OTHERC_TT1   
,SUM(OTHERC_TT2) as OTHERC_TT2 
,SUM(OTHERC_TTBooster) as OTHERC_TTBooster
,SUM(OTHERC_IFA) as OTHERC_IFA  
,SUM(OTHERC_Delivery) as OTHERC_Delivery 
,SUM(OTHERC_All_ANC) as OTHERC_All_ANC   
,SUM(OTHERC_Any_three_ANC) as OTHERC_Any_three_ANC 

,SUM(APL_Total_LMP) as APL_Total_LMP   
,SUM(APL_ANC1) as APL_ANC1 
,SUM(APL_ANC2) as APL_ANC2
,SUM(APL_ANC3) as APL_ANC3   
,SUM(APL_ANC4) as APL_ANC4   
,SUM(APL_TT1) as APL_TT1   
,SUM(APL_TT2) as APL_TT2 
,SUM(APL_TTBooster) as APL_TTBooster
,SUM(APL_IFA) as APL_IFA  
,SUM(APL_Delivery) as APL_Delivery 
,SUM(APL_All_ANC) as APL_All_ANC   
,SUM(APL_Any_three_ANC) as APL_Any_three_ANC 

,SUM(BPL_Total_LMP) as BPL_Total_LMP   
,SUM(BPL_ANC1) as BPL_ANC1 
,SUM(BPL_ANC2) as BPL_ANC2
,SUM(BPL_ANC3) as BPL_ANC3   
,SUM(BPL_ANC4) as BPL_ANC4   
,SUM(BPL_TT1) as BPL_TT1   
,SUM(BPL_TT2) as BPL_TT2 
,SUM(BPL_TTBooster) as BPL_TTBooster
,SUM(BPL_IFA) as BPL_IFA  
,SUM(BPL_Delivery) as BPL_Delivery 
,SUM(BPL_All_ANC) as BPL_All_ANC   
,SUM(BPL_Any_three_ANC) as BPL_Any_three_ANC 

,SUM(NotKnown_Total_LMP) as NotKnown_Total_LMP   
,SUM(NotKnown_ANC1) as NotKnown_ANC1 
,SUM(NotKnown_ANC2) as NotKnown_ANC2
,SUM(NotKnown_ANC3) as NotKnown_ANC3   
,SUM(NotKnown_ANC4) as NotKnown_ANC4   
,SUM(NotKnown_TT1) as NotKnown_TT1   
,SUM(NotKnown_TT2) as NotKnown_TT2 
,SUM(NotKnown_TTBooster) as NotKnown_TTBooster
,SUM(NotKnown_IFA) as NotKnown_IFA  
,SUM(NotKnown_Delivery) as NotKnown_Delivery 
,SUM(NotKnown_All_ANC) as NotKnown_All_ANC   
,SUM(NotKnown_Any_three_ANC) as NotKnown_Any_three_ANC 

,SUM(Christian_Total_LMP) as Christian_Total_LMP   
,SUM(Christian_ANC1) as Christian_ANC1 
,SUM(Christian_ANC2) as Christian_ANC2
,SUM(Christian_ANC3) as Christian_ANC3   
,SUM(Christian_ANC4) as Christian_ANC4   
,SUM(Christian_TT1) as Christian_TT1   
,SUM(Christian_TT2) as Christian_TT2 
,SUM(Christian_TTBooster) as Christian_TTBooster
,SUM(Christian_IFA) as Christian_IFA  
,SUM(Christian_Delivery) as Christian_Delivery 
,SUM(Christian_All_ANC) as Christian_All_ANC   
,SUM(Christian_Any_three_ANC) as Christian_Any_three_ANC 

,SUM(Hindu_Total_LMP) as Hindu_Total_LMP   
,SUM(Hindu_ANC1) as Hindu_ANC1 
,SUM(Hindu_ANC2) as Hindu_ANC2
,SUM(Hindu_ANC3) as Hindu_ANC3   
,SUM(Hindu_ANC4) as Hindu_ANC4   
,SUM(Hindu_TT1) as Hindu_TT1   
,SUM(Hindu_TT2) as Hindu_TT2 
,SUM(Hindu_TTBooster) as Hindu_TTBooster
,SUM(Hindu_IFA) as Hindu_IFA  
,SUM(Hindun_Delivery) as Hindun_Delivery 
,SUM(Hindu_All_ANC) as Hindu_All_ANC   
,SUM(Hindu_Any_three_ANC) as Hindu_Any_three_ANC  
 
,SUM(Muslim_Total_LMP) as Muslim_Total_LMP   
,SUM(Muslim_ANC1) as Muslim_ANC1 
,SUM(Muslim_ANC2) as Muslim_ANC2
,SUM(Muslim_ANC3) as Muslim_ANC3   
,SUM(Muslim_ANC4) as Muslim_ANC4   
,SUM(Muslim_TT1) as Muslim_TT1   
,SUM(Muslim_TT2) as Muslim_TT2 
,SUM(Muslim_TTBooster) as Muslim_TTBooster
,SUM(Muslim_IFA) as Muslim_IFA  
,SUM(Muslim_Delivery) as Muslim_Delivery 
,SUM(Muslim_All_ANC) as Muslim_All_ANC   
,SUM(Muslim_Any_three_ANC) as Muslim_Any_three_ANC  
 
 ,SUM(Sikh_Total_LMP) as Sikh_Total_LMP   
,SUM(Sikh_ANC1) as Sikh_ANC1 
,SUM(Sikh_ANC2) as Sikh_ANC2
,SUM(Sikh_ANC3) as Sikh_ANC3   
,SUM(Sikh_ANC4) as Sikh_ANC4   
,SUM(Sikh_TT1) as Sikh_TT1   
,SUM(Sikh_TT2) as Sikh_TT2 
,SUM(Sikh_TTBooster) as Sikh_TTBooster
,SUM(Sikh_IFA) as Sikh_IFA  
,SUM(Sikh_Delivery) as Sikh_Delivery 
,SUM(Sikh_All_ANC) as Sikh_All_ANC   
,SUM(Sikh_Any_three_ANC) as Sikh_Any_three_ANC  
 
 ,SUM(OTHERR_Total_LMP) as OTHERR_Total_LMP   
,SUM(OTHERR_ANC1) as OTHERR_ANC1 
,SUM(OTHERR_ANC2) as OTHERR_ANC2
,SUM(OTHERR_ANC3) as OTHERR_ANC3   
,SUM(OTHERR_ANC4) as OTHERR_ANC4   
,SUM(OTHERR_TT1) as OTHERR_TT1   
,SUM(OTHERR_TT2) as OTHERR_TT2 
,SUM(OTHERR_TTBooster) as OTHERR_TTBooster
,SUM(OTHERR_IFA) as OTHERR_IFA  
,SUM(OTHERR_Delivery) as OTHERR_Delivery 
,SUM(OTHERR_All_ANC) as OTHERR_All_ANC   
,SUM(OTHERR_Any_three_ANC) as OTHERR_Any_three_ANC
          
   from dbo.Scheduled_Tracking_PHC_SubCenter_Village_Day as CH  
 where State_Code =@State_Code
 and HealthSubFacility_Code =@HealthSubFacility_Code   
 and Fin_Yr=@FinancialYr 
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.HealthSubFacility_Code,CH.Village_Code
 )  B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code
end
 
end  

