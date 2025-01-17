USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[DDR_EC_Mother_Child_Count]    Script Date: 09/26/2024 15:26:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

   
    
/*   
[DDR_EC_Mother_Child_Count] 17,0,0,0,0,0  
[DDR_EC_Mother_Child_Count] 17,1,0,0,0,0  
[DDR_EC_Mother_Child_Count] 17,1,2,0,0,0  
[DDR_EC_Mother_Child_Count] 17,1,2,4,0,0  
[DDR_EC_Mother_Child_Count] 17,1,2,4,53,0  
  
*/    
    
    
ALTER procedure [dbo].[DDR_EC_Mother_Child_Count]   
(  
@State_Code as int=0,  
@District_Code as int=0,  
 @HealthBlock_Code as int=0,  
 @HealthFacility_Code as int=0,  
 @HealthSubFacility_Code as int=0,  
 @Village_Code as int=0,  
 @TypeID int=0  
 )  
    
as    
begin    
SET NOCOUNT ON      
Declare @FinYr as int,@daysPast as int,@BeginDate as date,@Daysinyear int,@MonthDiff int -- up to current month  
  
if(MONTH(GETDATE()-1)<=3)    
set @FinYr=Year(GETDATE()-1)-1    
else    
set @FinYr=Year(GETDATE()-1)   
  
 set @BeginDate = CAST(@FinYr as varchar)+'-04'+'-01'  
 set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)<=0 then 1 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)  
 set @Daysinyear=(case when @FinYr%4=0 then 366 else 365 end)  
   
IF(@State_Code<>0 and @District_Code=0)   
begin      
select
--parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count,
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count,
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry   
 from (   
 (select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, State_Code,  
 Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
  from rch_reports.dbo.Estimated_Data_All_State WITH (NOLOCK)  where State_Code=@State_Code and Financial_Year=@FinYr group by State_Code) A   
  left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv,State_Code from rch_reports.dbo.Estimated_Data_All_State WITH(NOLOCK) where State_Code=@State_Code and Financial_Year=@FinYr-1 group by State_Code  )PE on a.State_Code=PE.State_Code  
 left outer join   
(select sum(total_distinct_ec) as EC_Total_Count, State_Code from Scheduled_AC_EC_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr<=@FinYr group by State_Code) B on B.State_Code=A.State_Code  
left outer join     
(select sum(PW_Registered) as Mother_Total_Count, State_Code from Scheduled_AC_PW_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr=@FinYr group by State_Code) C on C.State_Code=A.State_Code   
left outer join     
(select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, State_Code from Scheduled_AC_Child_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr=@FinYr group by State_Code) D on D.State_Code=A.State_Code   
)    
End   
ELSE IF(@State_Code=0 and @District_Code=0)   
begin      
select 
--parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count, 
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count, 
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
--,Estimated_EC,Estimated_EC_Prv, Estimated_Mother,Estimated_Infant, ((Estimated_EC-b.EC_Total_Count)/ (@Daysinyear-@daysPast)) as EC_Daily_Entry         
--, ((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast)) as PW_Daily_Entry,        
--  ((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast)) as Child_Daily_Entry 
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry   
 from (   
 (select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, State_Code,  
 Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
  from Estimated_Data_District_Wise WITH(NOLOCK) where Financial_Year=@FinYr group by State_Code) A   
  left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv,State_Code from Estimated_Data_District_Wise WITH(NOLOCK) where Financial_Year=@FinYr-1 group by State_Code  )PE on a.State_Code=PE.State_Code  
 left outer join   
(select sum(total_distinct_ec) as EC_Total_Count, State_Code from Scheduled_AC_EC_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr<=@FinYr group by State_Code) B on B.State_Code=A.State_Code  
left outer join     
(select sum(PW_Registered) as Mother_Total_Count, State_Code from Scheduled_AC_PW_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr=@FinYr group by State_Code) C on C.State_Code=A.State_Code   
left outer join     
(select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, State_Code from Scheduled_AC_Child_State_District_Month WITH(NOLOCK) where Filter_Type=1 and Fin_Yr=@FinYr group by State_Code) D on D.State_Code=A.State_Code   
)    
End  
  
ELSE IF(@District_Code<>0 and @HealthBlock_Code=0)  
BEGIN  
  
select 
--parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count,
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count,   
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
-- ,Estimated_EC,Estimated_EC_Prv, Estimated_Mother,Estimated_Infant, ((Estimated_EC-b.EC_Total_Count)/ (@Daysinyear-@daysPast)) as EC_Daily_Entry         
--, ((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast)) as PW_Daily_Entry,        
--  ((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast)) as Child_Daily_Entry 
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry   
  
 from (   
(select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, District_CD as District_Code,  
Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
from Estimated_Data_Block_Wise a WITH(NOLOCK) 
  
inner join TBL_HEALTH_BLOCK b WITH(NOLOCK) on a.HEalthBlock_Code=b.BLOCk_CD where Financial_Year=@FinYr and b.District_CD=@District_Code group by District_CD) A   
 left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv,District_Code from Estimated_Data_Block_Wise WITH(NOLOCK) where Financial_Year=@FinYr-1 group by District_Code )PE on A.District_Code=PE.District_Code  
left outer join   
(  
select sum(total_distinct_ec) as EC_Total_Count, District_Code   
from Scheduled_AC_EC_District_Block_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr<=@FinYr and District_Code=@District_Code  
group by District_Code  
) B on B.District_Code=A.District_Code  
left outer join     
(  
select sum(PW_Registered) as Mother_Total_Count, District_Code   
from Scheduled_AC_PW_District_Block_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr=@FinYr   
and District_Code=@District_Code  
group by District_Code  
) C on C.District_Code=A.District_Code   
left outer join     
(  
select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, District_Code   
from Scheduled_AC_Child_District_Block_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr=@FinYr   
and District_Code=@District_Code  
group by District_Code  
) D on D.District_Code=A.District_Code   
)    
  
END   
ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code=0)  
BEGIN  
  
select 
--parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count,  
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count, 
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
--,Estimated_EC,Estimated_EC_Prv, Estimated_Mother,Estimated_Infant, ((Estimated_EC-b.EC_Total_Count)/ (@Daysinyear-@daysPast)) as EC_Daily_Entry         
--, ((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast)) as PW_Daily_Entry,        
--  ((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast)) as Child_Daily_Entry  
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry    
 from   
 (   
 (select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, BID as HEalthBlock_Code,  
Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
from Estimated_Data_PHC_Wise a WITH(NOLOCK)
inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD  
where Financial_Year=@FinYr  
and b.BID=@HEalthBlock_Code  
group by BID  
) A   
left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv, HealthBlock_Code from Estimated_Data_PHC_Wise WITH(NOLOCK) where Financial_Year=@FinYr-1 group by HealthBlock_Code )PE on A.HEalthBlock_Code=PE.HealthBlock_Code  
 left outer join   
(  
select sum(total_distinct_ec) as EC_Total_Count, HEalthBlock_Code   
from Scheduled_AC_EC_Block_PHC_Month WITH(NOLOCK) 
where Filter_Type=1 and Fin_Yr<=@FinYr   
and HEalthBlock_Code=@HEalthBlock_Code  
group by HEalthBlock_Code  
) B on B.HEalthBlock_Code=A.HEalthBlock_Code  
left outer join     
(  
select sum(PW_Registered) as Mother_Total_Count, HEalthBlock_Code   
from Scheduled_AC_PW_Block_PHC_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr=@FinYr   
and HEalthBlock_Code=@HEalthBlock_Code  
group by HEalthBlock_Code  
) C on C.HEalthBlock_Code=A.HEalthBlock_Code   
left outer join     
(select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, HEalthBlock_Code   
from Scheduled_AC_Child_Block_PHC_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr=@FinYr   
and HEalthBlock_Code=@HEalthBlock_Code  
group by HEalthBlock_Code  
) D on D.HEalthBlock_Code=A.HEalthBlock_Code   
)    
  
END   
ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code<>0 and @HealthSubFacility_Code=0)  
BEGIN  
  
select
-- parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count,  
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count, 
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
--,Estimated_EC,Estimated_EC_Prv, Estimated_Mother,Estimated_Infant, ((Estimated_EC-b.EC_Total_Count)/ (@Daysinyear-@daysPast)) as EC_Daily_Entry         
--, ((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast)) as PW_Daily_Entry,        
--  ((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast)) as Child_Daily_Entry  
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry    
 from (   
 (  
 select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, HEalthFacility_Code,  
Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
from Estimated_Data_SubCenter_Wise WITH(NOLOCK)   
where Financial_Year=@FinYr   
and HealthFacility_Code=@HealthFacility_Code  
group by HealthFacility_Code  
) A   
left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv, HEalthFacility_Code from Estimated_Data_SubCenter_Wise WITH(NOLOCK) where Financial_Year=(@FinYr-1) group by HEalthFacility_Code )PE on A.HEalthFacility_Code=PE.HEalthFacility_Code  
 left outer join   
(select sum(total_distinct_ec) as EC_Total_Count, HEalthFacility_Code   
from Scheduled_AC_EC_PHC_SubCenter_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr<=@FinYr   
and HealthFacility_Code=@HealthFacility_Code  
group by HEalthFacility_Code  
) B on B.HEalthFacility_Code=A.HEalthFacility_Code  
left outer join     
(select sum(PW_Registered) as Mother_Total_Count, HEalthFacility_Code   
from Scheduled_AC_PW_PHC_SubCenter_Month WITH(NOLOCK) 
where Filter_Type=1 and Fin_Yr=@FinYr   
and HealthFacility_Code=@HealthFacility_Code  
group by HEalthFacility_Code  
) C on C.HEalthFacility_Code=A.HEalthFacility_Code   
left outer join     
(select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, HEalthFacility_Code   
from Scheduled_AC_Child_PHC_SubCenter_Month WITH(NOLOCK) 
where Filter_Type=1 and Fin_Yr=@FinYr   
and HealthFacility_Code=@HealthFacility_Code  
group by HEalthFacility_Code  
) D on D.HEalthFacility_Code=A.HEalthFacility_Code   
)    
  
END     
ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code<>0 and @HealthSubFacility_Code<>0 and @Village_Code=0)  
BEGIN  
  
select
-- parsename(convert(varchar(50), CAST(isnull(B.EC_Total_Count,0) as money), 1),2)as EC_Total_Count,  
--parsename(convert(varchar(50), CAST(isnull(C.Mother_Total_Count,0) as money), 1),2)as Mother_Total_Count,  
--parsename(convert(varchar(50), cast(isnull(D.Child_Total_Count,0)as money), 1),2)as Child_Total_Count,  
dbo.NumberToCurrency(isnull(B.EC_Total_Count,0)) as  EC_Total_Count,
dbo.NumberToCurrency(isnull(C.Mother_Total_Count,0)) as  Mother_Total_Count,
dbo.NumberToCurrency(isnull(D.Child_Total_Count,0)) as  Child_Total_Count, 
RCH_Reports.dbo.EC_Prorata_Yearly(isnull(Estimated_EC_Prv,0),isnull(Estimated_EC,0),isnull(EC_Total_Count,0),@FinYr)as EC_Total_ProRata,  
isnull((case when A.Estimated_Mother=0 then 0 else cast(round(((cast(round(C.Mother_Total_Count,2) as float)*100)/cast(round(A.Estimated_Mother_FinYr,2)as float)),2) as float) end),0)as Mother_Total_ProRata,  
isnull((case when A.Estimated_Infant=0 then 0 else cast(round(((cast(round(D.Child_Total_Count,2) as float)*100)/cast(round(A.Estimated_Infant_FinYr,2)as float)),2) as float) end),0)as Child_Total_ProRata  
-- ,Estimated_EC,Estimated_EC_Prv, Estimated_Mother,Estimated_Infant, ((Estimated_EC-b.EC_Total_Count)/ (@Daysinyear-@daysPast)) as EC_Daily_Entry         
--, ((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast)) as PW_Daily_Entry,        
--  ((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast)) as Child_Daily_Entry   
,dbo.NumberToCurrency(Estimated_EC) as Estimated_EC,dbo.NumberToCurrency(Estimated_EC_Prv) as Estimated_EC_Prv , dbo.NumberToCurrency(Estimated_Mother) as Estimated_Mother
,dbo.NumberToCurrency(Estimated_Infant) as Estimated_Infant 
,dbo.NumberToCurrency(((Estimated_EC-b.EC_Total_Count) / (@Daysinyear-@daysPast))) as EC_Daily_Entry         
, dbo.NumberToCurrency(((Estimated_Mother-c.Mother_Total_Count)/ (@Daysinyear-@daysPast))) as PW_Daily_Entry,        
  dbo.NumberToCurrency(((Estimated_Infant-D.Child_Total_Count)/ (@Daysinyear-@daysPast))) as Child_Daily_Entry   
 from (   
 (  
 select sum(Estimated_EC)as Estimated_EC,sum(Estimated_Mother)as Estimated_Mother,sum(Estimated_Infant)as Estimated_Infant, HEalthSubFacility_Code,  
Convert(varchar(10),(cast(SUM(Estimated_EC) as bigint)*@daysPast)/@Daysinyear) as Estimated_EC_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Mother) as bigint)*@daysPast)/@Daysinyear) as Estimated_Mother_FinYr,  
 Convert(varchar(10),(cast(SUM(Estimated_Infant) as bigint)*@daysPast)/@Daysinyear) as Estimated_Infant_FinYr  
from Estimated_Data_Village_Wise WITH(NOLOCK) where Financial_Year=@FinYr  
and HEalthSubFacility_Code=@HEalthSubFacility_Code  
group by HEalthSubFacility_Code  
) A   
left outer join(  
 select sum(Estimated_EC)as Estimated_EC_Prv, HEalthSubFacility_Code from Estimated_Data_Village_Wise WITH(NOLOCK) where Financial_Year=(@FinYr-1) group by HEalthSubFacility_Code )PE on A.HEalthSubFacility_Code=PE.HEalthSubFacility_Code  
 left outer join   
(  
select sum(total_distinct_ec) as EC_Total_Count, HEalthSubFacility_Code   
from Scheduled_AC_EC_PHC_SubCenter_Village_Month WITH(NOLOCK)
where Filter_Type=1 and Fin_Yr<=@FinYr   
and HEalthSubFacility_Code=@HEalthSubFacility_Code  
group by HEalthSubFacility_Code  
) B on B.HEalthSubFacility_Code=A.HEalthSubFacility_Code  
left outer join     
(  
select sum(PW_Registered) as Mother_Total_Count, HEalthSubFacility_Code   
from Scheduled_AC_PW_PHC_SubCenter_Village_Month WITH(NOLOCK)
where Filter_Type=1 and Fin_Yr=@FinYr   
and HEalthSubFacility_Code=@HEalthSubFacility_Code  
group by HEalthSubFacility_Code  
) C on C.HEalthSubFacility_Code=A.HEalthSubFacility_Code   
left outer join     
(  
select (SUM(Child_0_1)+SUM(Child_1_2) + SUM(Child_2_3) + SUM(Child_3_4) + sum(Child_4_5)) as Child_Total_Count, HEalthSubFacility_Code   
from Scheduled_AC_Child_PHC_SubCenter_Village_Month WITH(NOLOCK)  
where Filter_Type=1 and Fin_Yr=@FinYr  
and HEalthSubFacility_Code=@HEalthSubFacility_Code   
group by HEalthSubFacility_Code  
) D on D.HEalthSubFacility_Code=A.HEalthSubFacility_Code   
)    
  
END     
end    
    
    
  