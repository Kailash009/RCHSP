USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_EC_REG]    Script Date: 09/26/2024 14:44:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Schedule_PHC_SubCenter_Village_Day_EC_REG]    
(    
@State_Code int=0    
)    
as    
begin    
    
--delete a from  Scheduled_PHC_SubCenter_Village_Day_EC_REG a    
--inner join t_Schedule_Date b on a.AsonDate=b.[EC_Registration_date]    
--where b.[EC_Registration_date] is not null    
truncate table t_temp_ReportMasterDate    
insert into t_temp_ReportMasterDate(Created_On,State_Code,PHC_Code,SubCentre_Code,Village_Code)    
select GETDATE(),State_Code,PHC_Code,SubCentre_Code,Village_Code     
from t_Schedule_Date_EC where Registration_date is not null and State_Code is not null     
group by State_Code,PHC_Code,SubCentre_Code,Village_Code     
    
delete a from  Scheduled_PHC_SubCenter_Village_Day_EC_REG a    
inner join t_temp_ReportMasterDate b on a.State_Code=b.State_Code and a.HealthFacility_Code=b.PHC_Code     
and a.HealthSubFacility_Code=b.SubCentre_Code and a.Village_Code=b.Village_Code    
    
    
insert into Scheduled_PHC_SubCenter_Village_Day_EC_REG([State_Code],[HealthFacility_Code],[HealthSubFacility_Code],[Village_Code]    
,[EC_Wife_Current_age_LessThen_19],[EC_Wife_Current_age_20_To_24],[EC_Wife_Current_age_25_To_29],[EC_Wife_Current_age_30_To_34]    
,[EC_Wife_Current_age_35_To_39],[EC_Wife_Current_age_40_To_44],[EC_Wife_Current_age_45_To_49],[EC_Registered],[EC_With_PhoneNo]    
,[EC_With_SelfPhoneNo],[EC_With_Address],[EC_With_Aadhaar_No],[EC_With_Bank_Details],EC_UID_Linked,EC_ACC,[EC_Registered_P],[EC_Registered_T],[ECT_With_Condom_P]    
,[ECT_With_MaleStr_P],[ECT_With_FeMaleStr_P],[ECT_With_IUCD_5yr_P],[ECT_With_IUCD_10yr_P],[ECT_With_OCP_P],[ECT_With_ECP_P],[ECT_With_Condom_T]    
,[ECT_With_MaleStr_T],[ECT_With_FeMaleStr_T],[ECT_With_IUCD_5yr_T],[ECT_With_IUCD_10yr_T],[ECT_With_OCP_T],[ECT_With_ECP_T],[ECT_With_NONE_P]    
,[ECT_With_NONE_T],[ECT_With_ANYS_P],[ECT_With_ANYS_T],[ECT_With_Condom],[ECT_With_MaleStr],[ECT_With_FeMaleStr],[ECT_With_IUCD_5yr]    
,[ECT_With_IUCD_10yr],[ECT_With_OCP],[ECT_With_ECP],[ECT_With_NONE],[ECT_With_ANYS],[EC_With_No_Children],[EC_With_One_Children]    
,[EC_With_Two_Children],[EC_With_MoreThanTwo_Children],[EC_With2andMore_Child_Sterilized],[EC_With2Child_Sterilized],[EC_With1Child_Sterilized]    
,[EC_With2andMore_Child_NonSterilized],[EC_With2Child_NonSterilized],[EC_With1Child_NonSterilized],[EC_WithPPC_MaleSterilized],[EC_WithPPC_IUCD]    
,[EC_WithPPC_STERILIZATION],[EC_WithPPC_CONDOM],[EC_Non_Sterilized_EC],[EC_With_Infertility]    
,[EC_UsingMethods]    
,EC_With_Preg_Yes,EC_With_UID_Mob,[EC_WithPPC_NONE],[EC_WithPPC_ANYS]    
,[Year_ID],[Month_ID],[Day_ID],[AsOnDate],[Fin_Yr],total_distinct_ec,Woman_RC_NUMBER,EC_HealthIdNumber,EC_cc_total,EC_cc_sent,EC_Wife_Cureent_age_15_To_49)    
    
SELECT a.StateID as State_Code    
      ,a.PHC_ID as Healthfacility_Code    
      ,a.SubCentre_ID as HealthSubfacility_Code    
      ,a.Village_ID    
      ,SUM((case when b.Wife_current_age<19 then 1 else 0 end))  [EC_Wife_Cureent_age_LessThen_19]    
      ,SUM((case when b.Wife_current_age between 20 and 24 then 1 else 0 end))  [EC_Wife_Cureent_age_20_To_24]    
      ,SUM((case when b.Wife_current_age between 25 and 29 then 1 else 0 end))[EC_Wife_Cureent_age_25_To_29]    
      ,SUM((case when b.Wife_current_age between 30 and 34 then 1 else 0 end))[EC_Wife_Cureent_age_30_To_34]    
      ,SUM((case when b.Wife_current_age between 35 and 39 then 1 else 0 end))[EC_Wife_Cureent_age_35_To_39]    
      ,SUM((case when b.Wife_current_age between 40 and 44 then 1 else 0 end))[EC_Wife_Cureent_age_40_To_44]    
      ,SUM((case when b.Wife_current_age between 45 and 49 then 1 else 0 end))[EC_Wife_Cureent_age_45_To_49]    
      ,count(a.Registration_no)[EC_Registered]          
   ,SUM(Convert(int,b.Mobile_no_Present))[EC_With_PhoneNo]          
   ,SUM((case when (b.Whose_mobile_Wife=1 or b.Whose_mobile_Husband=1) then 1 else 0 end))[EC_With_SelfPhoneNo]    
      ,SUM(Convert(int,b.Address_Present))[EC_With_Address]          
   ,SUM(Convert(int,b.PW_Aadhar_No_Present))[EC_With_Aadhaar_No]          
   ,SUM(Convert(int,b.PW_Bank_Name_Present))[EC_With_Bank_Details]    
      ,SUM(Convert(int,b.PW_UIDLinked_Present))EC_UID_Linked          
   ,SUM(Convert(int,b.PW_Acc_Present))EC_ACC          
   ,SUM(Convert(int,EC_P)) EC_P          
   ,SUM(Convert(int,EC_T)) EC_T    
      ,SUM(Convert(int,[ECT_With_Condom_P]))[ECT_With_Condom_P]    
   ,SUM(Convert(int,[ECT_With_MaleStr_P]))[ECT_With_MaleStr_P]    
   ,SUM(Convert(int,[ECT_With_FeMaleStr_P]))[ECT_With_FeMaleStr_P]    
   ,SUM(Convert(int,[ECT_With_IUCD_5yr_P]))[ECT_With_IUCD_5yr_P]    
   ,SUM(Convert(int,[ECT_With_IUCD_10yr_P]))[ECT_With_IUCD_10yr_P]    
   ,SUM(Convert(int,[ECT_With_OCP_P]))[ECT_With_OCP_P]    
   ,SUM(Convert(int,[ECT_With_ECP_P]))[ECT_With_ECP_P]    
      ,SUM(Convert(int,[ECT_With_Condom_T])) [ECT_With_Condom_T]    
   ,SUM(Convert(int,[ECT_With_MaleStr_T]))[ECT_With_MaleStr_T]     
   ,SUM(Convert(int,[ECT_With_FeMaleStr_T]))[ECT_With_FeMaleStr_T]          
      ,SUM(Convert(int,[ECT_With_IUCD_5yr_T]))[ECT_With_IUCD_5yr_T]    
   ,SUM(Convert(int,[ECT_With_IUCD_10yr_T]))[ECT_With_IUCD_10yr_T]    
   ,SUM(Convert(int,[ECT_With_OCP_T]))[ECT_With_OCP_T]    
   ,SUM(Convert(int,[ECT_With_ECP_T]))[ECT_With_ECP_T]    
   ,SUM(Convert(int,[ECT_With_NONE_P]))[ECT_With_NONE_P]    
      ,SUM(Convert(int,[ECT_With_NONE_T]))[ECT_With_NONE_T]    
   ,SUM(Convert(int,[ECT_With_ANYS_P]))[ECT_With_ANYS_P]    
   ,SUM(Convert(int,[ECT_With_ANYS_T]))[ECT_With_ANYS_T]    
   ,SUM(Convert(int,[ECT_With_Condom])) [ECT_With_Condom]    
      ,SUM(Convert(int,[ECT_With_MaleStr])) [ECT_With_MaleStr]    
   ,SUM(Convert(int,[ECT_With_FeMaleStr])) [ECT_With_FeMaleStr]    
   ,SUM(Convert(int,[ECT_With_IUCD_5yr]))  [ECT_With_IUCD_5yr]    
      ,SUM(Convert(int,[ECT_With_IUCD_10yr] )) [ECT_With_IUCD_10yr]    
   ,SUM(Convert(int,[ECT_With_OCP])) [ECT_With_OCP]    
   ,SUM(Convert(int,[ECT_With_ECP]))  [ECT_With_ECP]    
   ,SUM(Convert(int,[ECT_With_NONE]))  [ECT_With_NONE]    
   ,SUM(Convert(int,[ECT_With_ANYS])) [ECT_With_ANYS]    
   ,SUM(CONVERT(int,EC_With_Child_N))[EC_With_No_Children]    
   ,SUM(Case when EC_Child_Born=1 then 1 else 0 end ) EC_With_One_Children    
   ,SUM(Case when EC_Child_Born=2 then 1 else 0 end ) EC_With_Two_Children    
   ,SUM(Case when EC_Child_Born>2 then 1 else 0 end ) EC_With_MoreThanTwo_Children    
   ,SUM(Case when EC_Child_Born>2 and ([ECT_With_MaleStr]=1 or [ECT_With_FeMaleStr]=1)  then 1 else 0 end )[EC_With2andMore_Child_Sterilized]    
   ,SUM(Case when EC_Child_Born=2 and ([ECT_With_MaleStr]=1 or [ECT_With_FeMaleStr]=1) then 1 else 0 end )[EC_With2Child_Sterilized]    
   ,SUM(Case when EC_Child_Born=1 and ([ECT_With_MaleStr]=1 or [ECT_With_FeMaleStr]=1) then 1 else 0 end )[EC_With1Child_Sterilized]    
   ,SUM(Case when EC_Child_Born>2 and [ECT_With_MaleStr]=0 and [ECT_With_FeMaleStr]=0  then 1 else 0 end )[EC_With2andMore_Child_NonSterilized]    
      ,SUM(Case when EC_Child_Born=2 and [ECT_With_MaleStr]=0 and [ECT_With_FeMaleStr]=0 then 1 else 0 end )[EC_With2Child_NonSterilized]    
      ,SUM(Case when EC_Child_Born=1 and [ECT_With_MaleStr]=0 and [ECT_With_FeMaleStr]=0 then 1 else 0 end )[EC_With1Child_NonSterilized]    
      ,sum(Convert(int,EC_With_PPC_MSTR)) [EC_WithPPC_MaleSterilized]    
      ,sum(Convert(int,[ECT_With_PPIUCD_Within48Hr])) [EC_WithPPC_IUCD]    
      ,sum(Convert(int,[ECT_With_PPS_Within7DaysDelivery])) [EC_WithPPC_STERILIZATION]    
      ,sum(Convert(int,EC_With_PPC_CONDOM)) [EC_WithPPC_CONDOM]    
      ,SUM(Case when [ECT_With_MaleStr]=0 and [ECT_With_FeMaleStr]=0 then 1 else 0 end )[EC_Non_Sterilized_EC]    
      ,SUM(CONVERT(int,EC_Infertile_Y))[EC_With_Infertility]    
      ,SUM((case when ([ECT_With_Condom]=1 or [ECT_With_MaleStr]=1 or [ECT_With_FeMaleStr]=1 or [ECT_With_IUCD_5yr]=1 or [ECT_With_IUCD_10yr]=1 or [ECT_With_OCP]=1 or [ECT_With_ECP]=1  or [ECT_With_ANYS]=1) then 1 else 0 end))[EC_UsingMethods]    
      ,SUM(CONVERT(int,EC_Marked_Preg_Yes))EC_With_Preg_Yes    
      ,SUM((Case when PW_Aadhar_No_Present=1 and Mobile_no_Present=1 then 1 else 0 end)) EC_With_UID_Mob    
      ,sum(Convert(int,EC_With_PPC_NONE))EC_With_PPC_NONE    
      ,sum(Convert(int,EC_With_PPC_ANYS))EC_With_PPC_ANYS    
      ,a.[EC_Registration_Yr][Year_ID]    
      ,a.[EC_Registration_Month][Month_ID]    
      ,Day(a.[EC_Registration_Date])[Day_ID]    
      ,a.[EC_Registration_Date] as [AsOnDate]    
   ,(Case when a.[EC_Registration_Month]> 3 then a.[EC_Registration_Yr] else a.[EC_Registration_Yr]-1 end) as FinYr    
   ,SUM(a.distinct_ec) distinct_ec    
   ,sum(case when Woman_RC_NUMBER=1 and a.distinct_ec=1 then 1 else 0 end) as Woman_RC_NUMBER  
   --,sum(convert(int,(isnull(Mother_HealthIdNumber,0))))  as EC_HealthIdNumber    
   ,sum(case when isnull(Mother_HealthIdNumber,'0')<>'0' and a.distinct_ec=1 then 1 else 0 end) as EC_HealthIdNumber   
     , sum(case when a.distinct_ec=1 then isnull(cc_total,0) end)as EC_cc_total  
   , sum(case when a.distinct_ec=1 then  isnull(cc_sent,0) end)as EC_cc_sent  
     ,SUM((case when b.Wife_current_age between 15 and 49 and a.distinct_ec=1 then 1 else 0 end))[EC_Wife_Cureent_age_15_To_49]
  FROM t_EC_Flat_Count  a    
  inner join t_mother_flat_Count b on a.Registration_no=b.Registration_no and a.Case_no=b.case_no    
  inner join t_temp_ReportMasterDate c on a.StateID=c.State_Code and a.PHC_ID=c.PHC_Code and a.SubCentre_ID=c.SubCentre_Code and a.Village_ID=c.Village_Code    
  where a.EC_Registration_Date is not null    
  group by a.[EC_Registration_Yr],a.[EC_Registration_Month],Day(a.[EC_Registration_Date]),a.[EC_Registration_Date]    
  ,a.StateID,a.PHC_ID,a.SubCentre_ID,a.Village_ID      
      
 exec Schedule_PHC_SubCenter_Village_Day_EC_DEL_REG    
  end  
