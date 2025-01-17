USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[SMS_SDBPS_TC_datastore]    Script Date: 09/26/2024 15:59:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[SMS_SDBPS_TC_datastore] (@StateCode as int)
AS 
BEGIN
DECLARE 
@EC_Count as int=0,@Mother_Count as int=0,@Child_Count as int=0,@ANM_Count as int=0,@ASHA_Count as int=0,@EC_Count_Current_Finyr as int=0,
@Mother_Count_Current_Finyr as int=0,@Child_Count_Current_Finyr as int=0,@EC_Count_Prev_Finyr as int=0,@Mother_Count_Prev_Finyr as int=0,
@Child_Count_Prev_Finyr as int=0,@Current_Year as int=0,@Previous_Year as int=0,@Prv_Estimate_EC_Count as int=0,@Estimate_EC_Count as int=0,@Estimate_Mother_Count as int=0,
@Estimate_Child_Count as int=0,@Percentage_EC as float=0,@Percentage_Mother as float=0,@Percentage_Child as float=0,@EC_Total_Updated_Finyr as int=0,
@Mother_Total_Updated_Finyr as int=0,@Child_Total_Updated_Finyr as int=0,@EC_Total_Added_Finyr as int=0,@Mother_Total_Added_Finyr as int=0,
@ECT_Count_Added_Finyr as int=0,@MA_Count_Added_Finyr as int=0,@MD_Count_Added_Finyr as int=0,@MPNC_Count_Added_Finyr as int=0,@CPNC_Count_Added_Finyr as int=0,@CHT_Count_Added_Finyr as int=0,
@Child_Total_Added_Finyr as int=0,@Total_Days as int=0,@Days_Past as int=0
set @Current_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1) else YEAR(getdate()-1)-1 end)
set @Previous_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1)-1 else YEAR(getdate()-1)-2 end)
set @Total_Days=(case when (@Current_Year-1)%4=0 then 366 else 365 end)
set @Days_Past=DATEDIFF(day,cast(@Current_Year as varchar)+'-04-01',CONVERT(date,getdate()))

select @StateCode=a.StateID from State  a
inner join tbl_district b on a.StateID=b.StateID 
---------------------------------------------------------Till Date---------------------------------------------------------------------
Select @ANM_Count=x.anm,@ASHA_Count=x.asha from (
select Sum(Total_ANM)+SUM(Total_ANM2)+SUM(Total_LinkWorker)+SUM(Total_MPW)+SUM(Total_GNM)+SUM(Total_CHV) as anm,SUM(Total_ASHA)as asha 
from [Scheduled_AC_GF_State_District]  ) X
Select @EC_Count=x.e from (
select Sum(total_distinct_ec)as e from Scheduled_AC_EC_State_District_Month where Filter_Type=1) X
Select @Mother_Count=x.m from (
select SUM(PW_Registered)as m from Scheduled_AC_PW_State_District_Month where Filter_Type=1 ) X
Select @Child_Count=x.c from (
select SUM(Child_P)+SUM(Child_T)as c from Scheduled_AC_Child_State_District_Month where Filter_Type=1) X
------------------------------------------------------------------Current Year----------------------------------------------------------------------------
Select @EC_Count_Current_Finyr=x.e from (
select Sum(total_distinct_ec)as e from Scheduled_AC_EC_State_District_Month where Fin_Yr=@Current_Year  and Filter_Type=1) X
Select @Mother_Count_Current_Finyr=x.m from (
select SUM(PW_Registered)as m from Scheduled_AC_PW_State_District_Month where Fin_Yr=@Current_Year  and Filter_Type=1) X
Select @Child_Count_Current_Finyr=x.c from (
select SUM(Child_P)+SUM(Child_T)as c from Scheduled_AC_Child_State_District_Month where Fin_Yr=@Current_Year  and Filter_Type=1) X
--------------------------------------------------------------------------Previous Year---------------------------------------------------------------
Select @EC_Count_Prev_Finyr=x.e from (
select Sum(total_distinct_ec)as e from Scheduled_AC_EC_State_District_Month where Fin_Yr=@Previous_Year  and Filter_Type=1) X
Select @Mother_Count_Prev_Finyr=x.m from (
select SUM(PW_Registered)as m from Scheduled_AC_PW_State_District_Month where Fin_Yr=@Previous_Year  and Filter_Type=1) X
Select @Child_Count_Prev_Finyr=x.c from (
select SUM(Child_P)+SUM(Child_T)as c from Scheduled_AC_Child_State_District_Month where Fin_Yr=@Previous_Year  and Filter_Type=1) X
---------------------------------------------------------------------------------------------------------------------------------------------------
--Select @EC_Total_Updated_Finyr=x.eu,@Mother_Total_Updated_Finyr=x.mu,@Child_Total_Updated_Finyr=x.cu,@Child_Total_Added_Finyr=x.ca,@EC_Total_Added_Finyr=x.ea,@Mother_Total_Added_Finyr=x.ma   
--,@ECT_Count_Added_Finyr=ECT_Count,@MA_Count_Added_Finyr=MA_Count,@MD_Count_Added_Finyr= MD_Count,@MPNC_Count_Added_Finyr=MPNC_Count  
--,@CPNC_Count_Added_Finyr=CPNC_Count,@CHT_Count_Added_Finyr=CHT_Count from (  
--Select SUM(EC_Total_Count)as ea,SUM(Mother_Total_Count)as ma,SUM(Child_Total_Count)as ca,SUM(EC_Total_Count_Updated)as eu,SUM(Mother_Total_Count_Updated)as mu,SUM(Child_Total_Count_Updated) as cu   
--,SUM(ECT_Count)as ECT_Count,SUM(MA_Count)as MA_Count,SUM(MD_Count)as MD_Count,SUM(MPNC_Count)as MPNC_Count,SUM(CPNC_Count) as CPNC_Count,SUM(CHT_Count)as CHT_Count   
--from RCH_Reports.dbo.Scheduled_DB_AllState__DashBoard_Count   
--where Created_Date=Convert(date,GETDATE()-1) and (StateID=@StateCode) ) X  

--------------------------------------------------------------------------------------------------------------------


Select @Estimate_EC_Count=x.e,@Estimate_Mother_Count=x.m,@Estimate_Child_Count=x.c from (
select SUM(Estimated_EC)as e,SUM(Estimated_Mother)as m,SUM(Estimated_Infant)as c   from rch_reports.dbo.Estimated_Data_All_State where 
State_Code=@StateCode and Financial_Year=@Current_Year  ) X

select @Prv_Estimate_EC_Count=sum(Estimated_EC) from rch_reports.dbo.Estimated_Data_All_State where State_Code=@StateCode and Financial_Year=@Current_Year-1   


Select @EC_Total_Updated_Finyr=x.eu,@Mother_Total_Updated_Finyr=x.mu,@Child_Total_Updated_Finyr=x.cu,@Child_Total_Added_Finyr=x.ca,@EC_Total_Added_Finyr=x.ea,@Mother_Total_Added_Finyr=x.ma
,@ECT_Count_Added_Finyr=ECT_Count,@MA_Count_Added_Finyr=MA_Count,@MD_Count_Added_Finyr= MD_Count,@MPNC_Count_Added_Finyr=MPNC_Count  
,@CPNC_Count_Added_Finyr=CPNC_Count,@CHT_Count_Added_Finyr=CHT_Count  from (
Select SUM(EC_Total_Count)as ea,SUM(Mother_Total_Count)as ma,SUM(Child_Total_Count)as ca,SUM(EC_Total_Count_Updated)as eu,SUM(Mother_Total_Count_Updated)as mu,SUM(Child_Total_Count_Updated) as cu 
,SUM(ECT_Count)as ECT_Count,SUM(MA_Count)as MA_Count,SUM(MD_Count)as MD_Count,SUM(MPNC_Count)as MPNC_Count,SUM(CPNC_Count) as CPNC_Count,SUM(CHT_Count)as CHT_Count
from Scheduled_DB_State_District_Count
where Created_Date=Convert(date,GETDATE()-1) ) X

--set @Percentage_Mother=round((cast(@Mother_Count_Current_Finyr as float)*100)/cast(@Estimate_Mother_Count as float),2)
--set @Percentage_Child=round((cast(@Child_Count_Current_Finyr as float)*100)/cast(@Estimate_Child_Count as float),2)
--set @Percentage_EC=round(100-((cast(@Estimate_EC_Count as float) - cast(@EC_Count as float))/cast(@Estimate_EC_Count as float))*100,2)
set @Percentage_Mother=RCH_Reports.dbo.PW_CH_ProRata_Percentage(@Estimate_Mother_Count,@Mother_Count_Current_Finyr,'Yearly',@Current_Year)
set @Percentage_Child=RCH_Reports.dbo.PW_CH_ProRata_Percentage(@Estimate_Child_Count,@Child_Count_Current_Finyr,'Yearly',@Current_Year)
set @Percentage_EC=RCH_Reports.dbo.EC_Prorata_Yearly(@Prv_Estimate_EC_Count,@Estimate_EC_Count,@EC_Count,@Current_Year)

--set @Estimate_EC_Count=(@Estimate_EC_Count/@Total_Days)*@Days_Past
set @Estimate_EC_Count=@Estimate_EC_Count
set @Estimate_Mother_Count=(@Estimate_Mother_Count/@Total_Days)*@Days_Past
set @Estimate_Child_Count=(@Estimate_Child_Count/@Total_Days)*@Days_Past
--set @Percentage_Mother=(@Mother_Count_Current_Finyr*100)/@Estimate_Mother_Count
--set @Percentage_Child=(@Child_Count_Current_Finyr*100)/@Estimate_Child_Count
--set @Percentage_EC=(@EC_Count_Current_Finyr*100)/@Estimate_EC_Count





insert into sms..daily_SMS_status(State_code,Date_of_delivery,ANM_Total_Count,ASHA_Total_Count,EC_Total_Count,PW_Total_Count,CH_Total_Count,EC_Count_Curr_Finyr,PW_Count_Curr_Finyr
,CH_Count_Curr_Finyr,EC_Count_Prev_Finyr,PW_Count_Prev_Finyr,CH_Count_Prev_Finyr,Estimate_EC_Count,Estimate_PW_Count,Estimate_CH_Count,EC_Total_Updated_day,PW_Total_Updated_day
,CH_Total_Updated_day,EC_Total_Added_day,PW_Total_Added_day,CH_Total_Added_day,per_EC,per_PW,per_CH,ECT_Total_Added_day,MA_Total_Added_day ,MD_Total_Added_day,MPNC_Total_Added_day,CPNC_Total_Added_day,CHT_Total_Added_day)

select
@StateCode State_code,
getdate() Date_of_delivery,
@ANM_Count ANM_Total_Count,
@ASHA_Count ASHA_Total_Count,
@EC_Count EC_Total_Count,
@Mother_Count PW_Total_Count,
@Child_Count CH_Total_Count,
@EC_Count_Current_Finyr EC_Count_Curr_Finyr,
@Mother_Count_Current_Finyr PW_Count_Curr_Finyr,
@Child_Count_Current_Finyr CH_Count_Curr_Finyr,
@EC_Count_Prev_Finyr EC_Count_Prev_Finyr,
@Mother_Count_Prev_Finyr PW_Count_Prev_Finyr,
@Child_Count_Prev_Finyr CH_Count_Prev_Finyr,
@Estimate_EC_Count Estimate_EC_Count,
@Estimate_Mother_Count Estimate_PW_Count,
@Estimate_Child_Count Estimate_CH_Count,
@EC_Total_Updated_Finyr EC_Total_Updated_day,
@Mother_Total_Updated_Finyr PW_Total_Updated_day,
@Child_Total_Updated_Finyr CH_Total_Updated_day,
@EC_Total_Added_Finyr EC_Total_Added_day,
@Mother_Total_Added_Finyr PW_Total_Added_day,
@Child_Total_Added_Finyr CH_Total_Added_day,
@Percentage_EC per_EC,
@Percentage_Mother per_PW,
@Percentage_Child per_CH,

@ECT_Count_Added_Finyr ECT_Total_Added_day,
@MA_Count_Added_Finyr MA_Total_Added_day,
@MD_Count_Added_Finyr MD_Total_Added_day,
@MPNC_Count_Added_Finyr MPNC_Total_Added_day,
@CPNC_Count_Added_Finyr CPNC_Total_Added_day,
@CHT_Count_Added_Finyr CHT_Total_Added_day
END