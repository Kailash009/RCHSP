USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MH_Religion_Caste_Class]    Script Date: 09/26/2024 12:09:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[MH_Religion_Caste_Class]  
(  
@State_Code int=0,  
@District_Code int=0,  
@HealthBlock_Code int=0,  
@HealthFacility_Code int=0,  
@HealthSubFacility_Code int=0,  
@FinancialYr int=0,  
@FromMonth int=0,  
@ToMonth int=0,
@Category varchar(20) 
,@PeriodID as int=0
,@FromYear as int=0
,@ToYear as int=0 
)  
as   
begin
if(@Category='State')
begin
select  A.State_Code as Parent_ID,A.District_Code as Child_ID,A.State_Name as Parent_Name,A.District_Name as Child_Name
,A.Estimated_Mother as Estimated_PW_Total
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total
,isnull(B.Reg_Hindu_Total,0) as Reg_Hindu_Total
,isnull(B.Reg_Muslim_Total,0) as Reg_Muslim_Total
,isnull(B.Reg_Sikh_Total,0) as Reg_Sikh_Total
,isnull(B.Reg_Christian_Total,0) as Reg_Christian_Total
,isnull(B.Reg_Other_Relegion_Total,0) as Reg_Other_Religion_Total
,isnull(B.Reg_SC,0) as Reg_SC
,isnull(B.Reg_ST,0) as Reg_ST
,isnull(B.Reg_Other_Caste_Total,0) as Reg_Other_Caste_Total
,isnull(B.Reg_APL_Total,0) as Reg_APL_Total
,isnull(B.Reg_BPL_Total,0) as Reg_BPL_Total
,isnull(B.Reg_APLBPL_NotKnown_Total,0) as Reg_APLBPL_NotKnown_Total
,X.Estimated_Mother as Est_PW_Total
from
(
select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME as District_Name
,SUM(c.Estimated_Mother) as Estimated_Mother
,SUM(c.Estimated_Infant) as Estimated_Infant
,SUM(c.Estimated_EC)  as Estimated_EC
from TBL_DISTRICT a
inner join TBL_STATE b on a.StateID=b.StateID
inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code
where c.Financial_Year between @FromYear and @ToYear
and b.StateID=@State_Code 
Group by b.StateID,b.StateName,a.DIST_CD,a.DIST_NAME
)  A
left outer join 
  (Select State_Code,SUM(Estimated_Mother) as Estimated_Mother from Rch_Reports.dbo.Estimated_Data_All_State a
	 where Financial_Year between @FromYear and @ToYear and State_Code=@State_Code
	 group by State_Code) 
	 X on A.State_Code=X.State_Code     
  left outer join  
(
select MH.State_Code, MH.District_Code
,sum(Reg_Hindu_Total) as Reg_Hindu_Total
,sum(PW_Registered) as Registered_PW_Total 
,sum(Reg_Muslim_Total) as Reg_Muslim_Total 
,sum(Reg_Sikh_Total) as Reg_Sikh_Total
,sum(Reg_Christian_Total) as Reg_Christian_Total
,sum(Reg_Other_Relegion_Total) as Reg_Other_Relegion_Total
,sum(Reg_SC) as Reg_SC
,sum(Reg_ST) as Reg_ST
,sum(Reg_Other_Caste_Total) as Reg_Other_Caste_Total
,sum(Reg_APL_Total) as Reg_APL_Total
,sum(Reg_BPL_Total) as Reg_BPL_Total
,sum(Reg_NotKnown_Total) as Reg_APLBPL_NotKnown_Total
from Scheduled_AC_PW_State_District_Month as MH
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID  
where MH.State_Code=@State_Code
and(MH.District_Code=@District_Code or @District_Code=0)   
--and Fin_Yr between @FromYear and @ToYear   
--and ((Month_ID between @FromMonth and @ToMonth) or @FromMonth=0)
and Filter_Type=1 
group by MH.State_Code, MH.District_Code
) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code
end 
else if(@Category='District')  
begin
select A.District_Code as Parent_ID,A.HealthBlock_Code as Child_ID,A.District_Name as Parent_Name,A.HealthBlock_Name as Child_Name
,A.Estimated_Mother as Estimated_PW_Total
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total
,isnull(B.Reg_Hindu_Total,0) as Reg_Hindu_Total
,isnull(B.Reg_Muslim_Total,0) as Reg_Muslim_Total
,isnull(B.Reg_Sikh_Total,0) as Reg_Sikh_Total
,isnull(B.Reg_Christian_Total,0) as Reg_Christian_Total
,isnull(B.Reg_Other_Relegion_Total,0) as Reg_Other_Religion_Total
,isnull(B.Reg_SC,0) as Reg_SC
,isnull(B.Reg_ST,0) as Reg_ST
,isnull(B.Reg_Other_Caste_Total,0) as Reg_Other_Caste_Total
,isnull(B.Reg_APL_Total,0) as Reg_APL_Total
,isnull(B.Reg_BPL_Total,0) as Reg_BPL_Total
,isnull(B.Reg_APLBPL_NotKnown_Total,0) as Reg_APLBPL_NotKnown_Total
,'' as Est_PW_Total
from
(select a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name
,SUM(c.Estimated_Mother) as Estimated_Mother
,SUM(c.Estimated_Infant) as Estimated_Infant
,SUM(c.Estimated_EC)  as Estimated_EC
from TBL_HEALTH_BLOCK a
inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD
inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code
where c.Financial_Year between @FromYear and @ToYear
and a.DISTRICT_CD=@District_Code
Group by a.DISTRICT_CD,b.DIST_NAME_ENG,a.BLOCK_CD,a.Block_Name_E
)  A
left outer join
(
select  MH.District_Code,MH.HealthBlock_Code 
,sum(Reg_Hindu_Total) as Reg_Hindu_Total
,sum(Reg_Muslim_Total) as Reg_Muslim_Total
,sum(PW_Registered) as Registered_PW_Total  
,sum(Reg_Sikh_Total) as Reg_Sikh_Total
,sum(Reg_Christian_Total) as Reg_Christian_Total
,sum(Reg_Other_Relegion_Total) as Reg_Other_Relegion_Total
,sum(Reg_SC) as Reg_SC
,sum(Reg_ST) as Reg_ST
,sum(Reg_Other_Caste_Total) as Reg_Other_Caste_Total
,sum(Reg_APL_Total) as Reg_APL_Total
,sum(Reg_BPL_Total) as Reg_BPL_Total
,sum(Reg_NotKnown_Total) as Reg_APLBPL_NotKnown_Total
from Scheduled_AC_PW_District_Block_Month  MH 
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID 
where MH.District_Code=@District_Code   
--and Fin_Yr between @FromYear and @ToYear   
--and ((Month_ID between @FromMonth and @ToMonth) or @FromMonth=0) 
and Filter_Type=1
group by MH.District_Code,MH.HealthBlock_Code
) B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code
            
 

  
   
end
if(@Category='Block')    
     
begin    
select A. HealthBlock_Code as Parent_ID,A.HealthBlock_Name as Parent_Name,A.HealthFacility_Code as Child_ID,A.HealthFacility_Name as  Child_Name
,A.Estimated_Mother as Estimated_PW_Total
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total
,isnull(B.Reg_Hindu_Total,0) as Reg_Hindu_Total
,isnull(B.Reg_Muslim_Total,0) as Reg_Muslim_Total
,isnull(B.Reg_Sikh_Total,0) as Reg_Sikh_Total
,isnull(B.Reg_Christian_Total,0) as Reg_Christian_Total
,isnull(B.Reg_Other_Relegion_Total,0) as Reg_Other_Religion_Total
,isnull(B.Reg_SC,0) as Reg_SC
,isnull(B.Reg_ST,0) as Reg_ST
,isnull(B.Reg_Other_Caste_Total,0) as Reg_Other_Caste_Total
,isnull(B.Reg_APL_Total,0) as Reg_APL_Total
,isnull(B.Reg_BPL_Total,0) as Reg_BPL_Total
,isnull(B.Reg_APLBPL_NotKnown_Total,0) as Reg_APLBPL_NotKnown_Total
,'' as Est_PW_Total
from  
(select a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
,SUM(c.Estimated_Mother) as Estimated_Mother
,SUM(c.Estimated_Infant) as Estimated_Infant
,SUM(c.Estimated_EC)  as Estimated_EC
from TBL_PHC  a
inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD
inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code
where c.Financial_Year between @FromYear and @ToYear
 and  a.BID=@HealthBlock_Code
 group by a.BID,b.Block_Name_E,a.PHC_CD,a.PHC_NAME
)  A 
left outer join
(
select MH.HealthBlock_Code,MH.HealthFacility_Code  
,sum(Reg_Hindu_Total) as Reg_Hindu_Total
,sum(Reg_Muslim_Total) as Reg_Muslim_Total 
,sum(PW_Registered) as Registered_PW_Total 
,sum(Reg_Sikh_Total) as Reg_Sikh_Total
,sum(Reg_Christian_Total) as Reg_Christian_Total
,sum(Reg_Other_Relegion_Total) as Reg_Other_Relegion_Total
,sum(Reg_SC) as Reg_SC
,sum(Reg_ST) as Reg_ST
,sum(Reg_Other_Caste_Total) as Reg_Other_Caste_Total
,sum(Reg_APL_Total) as Reg_APL_Total
,sum(Reg_BPL_Total) as Reg_BPL_Total
,sum(Reg_NotKnown_Total) as Reg_APLBPL_NotKnown_Total
from Scheduled_AC_PW_Block_PHC_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthBlock_Code=@HealthBlock_Code
--and Fin_Yr between @FromYear and @ToYear   
--and ((Month_ID between @FromMonth and @ToMonth) or @FromMonth=0) 
and Filter_Type=1
group by MH.HealthBlock_Code,MH.HealthFacility_Code
 ) B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code 
end   
if(@Category='PHC')    
     
begin    
 select A.HealthFacility_Code as Parent_ID,A.HealthSubFacility_Code as Child_ID,A.HealthFacility_Name as Parent_Name,A.HealthSubFacility_Name as Child_Name
,A.Estimated_Mother as Estimated_PW_Total
,isnull(B.Registered_PW_Total,0) as Registered_PW_Total
,isnull(B.Reg_Hindu_Total,0) as Reg_Hindu_Total
,isnull(B.Reg_Muslim_Total,0) as Reg_Muslim_Total
,isnull(B.Reg_Sikh_Total,0) as Reg_Sikh_Total
,isnull(B.Reg_Christian_Total,0) as Reg_Christian_Total
,isnull(B.Reg_Other_Relegion_Total,0) as Reg_Other_Religion_Total
,isnull(B.Reg_SC,0) as Reg_SC
,isnull(B.Reg_ST,0) as Reg_ST
,isnull(B.Reg_Other_Caste_Total,0) as Reg_Other_Caste_Total
,isnull(B.Reg_APL_Total,0) as Reg_APL_Total
,isnull(B.Reg_BPL_Total,0) as Reg_BPL_Total
,isnull(B.Reg_APLBPL_NotKnown_Total,0) as Reg_APLBPL_NotKnown_Total
,'' as Est_PW_Total
from 
(select a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
,SUM(c.Estimated_Mother) as Estimated_Mother
,SUM(c.Estimated_Infant) as Estimated_Infant
,SUM(c.Estimated_EC)  as Estimated_EC
from TBL_SUBPHC a
inner join TBL_PHC b on a.PHC_CD=b.PHC_CD
inner join  Estimated_Data_SubCenter_Wise c on a.SUBPHC_CD=c.HealthSubFacility_Code
where c.Financial_Year between @FromYear and @ToYear
and a.PHC_CD=@HealthFacility_Code
Group by a.PHC_CD,b.PHC_NAME,a.SUBPHC_CD,a.SUBPHC_NAME_E
)  A 
left outer join 
(  
select MH.HealthFacility_Code,MH.HealthSubFacility_Code 
,sum(Reg_Hindu_Total) as Reg_Hindu_Total
,sum(Reg_Muslim_Total) as Reg_Muslim_Total 
,sum(PW_Registered) as Registered_PW_Total 
,sum(Reg_Sikh_Total) as Reg_Sikh_Total
,sum(Reg_Christian_Total) as Reg_Christian_Total
,sum(Reg_Other_Relegion_Total) as Reg_Other_Relegion_Total
,sum(Reg_SC) as Reg_SC
,sum(Reg_ST) as Reg_ST
,sum(Reg_Other_Caste_Total) as Reg_Other_Caste_Total
,sum(Reg_APL_Total) as Reg_APL_Total
,sum(Reg_BPL_Total) as Reg_BPL_Total
,sum(Reg_NotKnown_Total) as Reg_APLBPL_NotKnown_Total
from Scheduled_AC_PW_PHC_SubCenter_Month as MH  
inner join dbo.Get_Month_ID(@FromYear,@ToYear,@FromMonth,@ToMonth) b on MH.Fin_Yr=b.FinYR and MH.Year_ID=b.Year_ID and MH.Month_ID=b.Month_ID
where MH.HealthFacility_Code=@HealthFacility_Code  
--and Fin_Yr between @FromYear and @ToYear   
--and ((Month_ID between @FromMonth and @ToMonth) or @FromMonth=0) 
and Filter_Type=1
group by MH.HealthFacility_Code,MH.HealthSubFacility_Code
) B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code 
end  

   
end  



