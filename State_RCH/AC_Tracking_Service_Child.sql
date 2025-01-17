USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Tracking_Service_Child]    Script Date: 09/26/2024 11:54:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[AC_Tracking_Service_Child]
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

SET NOCOUNT ON         


--if(@Category='National')  
--begin  
--	exec RCH_Reports.dbo.AC_Tracking_Service_Child @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,  
--	@FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category
--end

if(@Category='State')
begin
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName,
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child
,ISNULL (Dead_Child,0)as Dead_Child
--Added By Rishi on 19 March -2019
,ISNULL(MR1,0) as MR1
,ISNULL(MR,0) as MR2
,ISNULL(PCV1,0) as PCV1
,ISNULL(PCV2,0) as PCV2
,ISNULL(PCVB,0) as PCBB
--,dbo.Deactivation_Service(0) as ImmuCode 
,'' as ImmuCode


--------------------------------------added by shital 290719---------------------------------------------------------------------

,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------

,ISNULL(IPV1,0)as IPV1,ISNULL(IPV2,0) as IPV2
,ISNULL([VIT1],0) as VIT1 
,ISNULL([VIT2] ,0) as VIT2
,ISNULL([VIT3],0) as VIT3
,ISNULL([VIT4] ,0) as VIT4
,ISNULL([VIT5],0 ) as VIT5
,ISNULL([VIT6],0 ) as VIT6
,ISNULL([VIT7],0 ) as VIT7
,ISNULL([VIT8],0) as VIT8 
,ISNULL([VIT9],0 ) as VIT9
,ISNULL([Received_All_Vac],0 ) as Complete_Immu

 from  
 (select c.State_Code as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name
	from  TBL_DISTRICT a WITH (NOLOCK) 
	inner join TBL_STATE b WITH (NOLOCK)  on a.StateID=b.StateID
	inner join Estimated_Data_District_Wise c WITH (NOLOCK)  on a.DIST_CD=c.District_Code
	where c.Financial_Year=@FinancialYr 
	
) A
left outer join
(
 select  CH.State_Code,CH.District_Code
,SUM(ISNULL(Total_Birthdate,0)) as Total_Birthdate
,SUM(ISNULL(BCG,0)) as BCG
,SUM(ISNULL(OPV0,0)) as OPV0  
,SUM(ISNULL(HEP0,0)) as HEP0
,SUM(ISNULL(DPT1,0)) as DPT1   
,SUM(ISNULL(OPV1,0)) as OPV1   
,SUM(ISNULL(HEP1,0)) as HEP1   
,SUM(ISNULL(PENTA1,0)) as PENTA1 
,SUM(ISNULL(DPT2,0)) as DPT2
,SUM(ISNULL(OPV2,0)) as OPV2
,SUM(ISNULL(HEP2,0)) as HEP2   
,SUM(ISNULL(PENTA2,0)) as PENTA2  
,SUM(ISNULL(DPT3,0)) as DPT3  
,SUM(ISNULL(OPV3,0)) as OPV3  
,SUM(ISNULL(HEP3,0)) as HEP3  
,SUM(ISNULL(PENTA3,0)) as PENTA3  
,SUM(ISNULL(Measles,0)) as Measles  
,SUM(ISNULL(AllVac,0)) as AllVac   
,SUM(ISNULL(Dead_Child,0)) as Dead_Child   
,SUM(ISNULL(Delete_Child,0)) as Delete_Child 
--Added By Rishi on 19 March -2019
,SUM(ISNULL(MR,0)) as MR
,SUM(ISNULL(MR1,0)) as MR1
,SUM(ISNULL(PCV1,0)) as PCV1
,SUM(ISNULL(PCV2,0)) as PCV2
,SUM(ISNULL(PCVB,0)) as PCVB  

------------------------------------added by shital on 290719------------------------------------------
,Sum([Rota1])as Rota1
,Sum([Rota2])as Rota2
,Sum([Rota3])as Rota3
,Sum([DPTB1])as DPTB1
,Sum([DPTB2])as DPTB2
,Sum([OPVB])as OPVB
,Sum([MEASLES2])as MEASLES2
,Sum([JE1])as JE1
,Sum([JE2])as JE2
,Sum([VITK])as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
 
,SUM([IPV1])as IPV1
,SUM([IPV2]) as IPV2
,SUM([VIT1]) as VIT1 
,SUM([VIT2] ) as VIT2
,SUM([VIT3]) as VIT3
,SUM([VIT4] ) as VIT4
,SUM([VIT5] ) as VIT5
,SUM([VIT6] ) as VIT6
,SUM([VIT7] ) as VIT7
,SUM([VIT8]) as VIT8 
,SUM([VIT9] ) as VIT9
,SUM([Received_All_Vac])as [Received_All_Vac]
  
from dbo.Scheduled_Tracking_CH_State_District_Month as CH WITH (NOLOCK)   
where CH.State_Code =@State_Code
and Fin_Yr=@FinancialYr 
and (Month_ID=@Month_ID or @Month_ID=0)
and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.District_Code
 ) 
 B on A.District_Code=B.District_Code order by A.State_Name,a.District_Name
end

else if(@Category='District')
begin
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName,
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child,ISNULL (Dead_Child,0)as Dead_Child
--Added By Rishi on 19 March -2019
,ISNULL(MR1,0) as MR1
,ISNULL(MR,0) as MR2
,ISNULL(PCV1,0) as PCV1
,ISNULL(PCV2,0) as PCV2
,ISNULL(PCVB,0) as PCBB
--,dbo.Deactivation_Service(0) as ImmuCode 
,'' as ImmuCode

--------------------------------------added by shital 290719---------------------------------------------------------------------

,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
,ISNULL(IPV1,0)as IPV1,ISNULL(IPV2,0) as IPV2
,ISNULL([VIT1],0) as VIT1 
,ISNULL([VIT2] ,0) as VIT2
,ISNULL([VIT3],0) as VIT3
,ISNULL([VIT4] ,0) as VIT4
,ISNULL([VIT5],0 ) as VIT5
,ISNULL([VIT6],0 ) as VIT6
,ISNULL([VIT7],0 ) as VIT7
,ISNULL([VIT8],0) as VIT8 
,ISNULL([VIT9],0 ) as VIT9
,ISNULL([Received_All_Vac],0 ) as Complete_Immu

 from  
 (select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name 
	from TBL_HEALTH_BLOCK a WITH (NOLOCK) 
	inner join TBL_DISTRICT b WITH (NOLOCK)  on a.DISTRICT_CD=b.DIST_CD
	inner join Estimated_Data_Block_Wise c WITH (NOLOCK)  on a.BLOCK_CD=c.HealthBlock_Code
	where c.Financial_Year=@FinancialYr 
	and a.DISTRICT_CD=@District_Code
) A
left outer join
(
 select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code 
,SUM(ISNULL(Total_Birthdate,0)) as Total_Birthdate
,SUM(ISNULL(BCG,0)) as BCG
,SUM(ISNULL(OPV0,0)) as OPV0  
,SUM(ISNULL(HEP0,0)) as HEP0
,SUM(ISNULL(DPT1,0)) as DPT1   
,SUM(ISNULL(OPV1,0)) as OPV1   
,SUM(ISNULL(HEP1,0)) as HEP1   
,SUM(ISNULL(PENTA1,0)) as PENTA1 
,SUM(ISNULL(DPT2,0)) as DPT2
,SUM(ISNULL(OPV2,0)) as OPV2
,SUM(ISNULL(HEP2,0)) as HEP2   
,SUM(ISNULL(PENTA2,0)) as PENTA2  
,SUM(ISNULL(DPT3,0)) as DPT3  
,SUM(ISNULL(OPV3,0)) as OPV3  
,SUM(ISNULL(HEP3,0)) as HEP3  
,SUM(ISNULL(PENTA3,0)) as PENTA3  
,SUM(ISNULL(Measles,0)) as Measles  
,SUM(ISNULL(AllVac,0)) as AllVac   
,SUM(ISNULL(Dead_Child,0)) as Dead_Child   
,SUM(ISNULL(Delete_Child,0)) as Delete_Child 
--Added By Rishi on 19 March -2019
,SUM(ISNULL(MR,0)) as MR
,SUM(ISNULL(MR1,0)) as MR1
,SUM(ISNULL(PCV1,0)) as PCV1
,SUM(ISNULL(PCV2,0)) as PCV2
,SUM(ISNULL(PCVB,0)) as PCVB  

------------------------------------added by shital on 290719------------------------------------------
,Sum([Rota1])as Rota1
,Sum([Rota2])as Rota2
,Sum([Rota3])as Rota3
,Sum([DPTB1])as DPTB1
,Sum([DPTB2])as DPTB2
,Sum([OPVB])as OPVB
,Sum([MEASLES2])as MEASLES2
,Sum([JE1])as JE1
,Sum([JE2])as JE2
,Sum([VITK])as VITK 

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
 
,SUM([IPV1])as IPV1
,SUM([IPV2]) as IPV2
,SUM([VIT1]) as VIT1 
,SUM([VIT2] ) as VIT2
,SUM([VIT3]) as VIT3
,SUM([VIT4] ) as VIT4
,SUM([VIT5] ) as VIT5
,SUM([VIT6] ) as VIT6
,SUM([VIT7] ) as VIT7
,SUM([VIT8]) as VIT8 
,SUM([VIT9] ) as VIT9
,SUM([Received_All_Vac])as [Received_All_Vac]  
   from dbo.Scheduled_Tracking_CH_District_Block_Month as CH WITH (NOLOCK)   
 where CH.State_Code =@State_Code
 and CH.District_Code=@District_Code
 and Fin_Yr=@FinancialYr 
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.District_Code,CH.HealthBlock_Code
 ) 
 B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code order by A.District_Name,A.HealthBlock_Name
end



if(@Category='Block')
begin
select A.State_Code,A. HealthBlock_Code as ParentID ,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child,ISNULL (Dead_Child,0)as Dead_Child
--Added By Rishi on 19 March -2019
,ISNULL(MR1,0) as MR1
,ISNULL(MR,0) as MR2
,ISNULL(PCV1,0) as PCV1
,ISNULL(PCV2,0) as PCV2
,ISNULL(PCVB,0) as PCBB
--,dbo.Deactivation_Service(0) as ImmuCode 
,'' as ImmuCode

--------------------------------------added by shital 290719---------------------------------------------------------------------

,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------

,ISNULL(IPV1,0)as IPV1,ISNULL(IPV2,0) as IPV2
,ISNULL([VIT1],0) as VIT1 
,ISNULL([VIT2] ,0) as VIT2
,ISNULL([VIT3],0) as VIT3
,ISNULL([VIT4] ,0) as VIT4
,ISNULL([VIT5],0 ) as VIT5
,ISNULL([VIT6],0 ) as VIT6
,ISNULL([VIT7],0 ) as VIT7
,ISNULL([VIT8],0) as VIT8 
,ISNULL([VIT9],0 ) as VIT9
,ISNULL([Received_All_Vac],0 ) as Complete_Immu

 from  
 (select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name
     from TBL_PHC a WITH (NOLOCK) 
     inner join TBL_HEALTH_BLOCK b WITH (NOLOCK)  on a.BID=b.BLOCK_CD
     inner join Estimated_Data_PHC_Wise c WITH (NOLOCK)  on a.PHC_CD=c.HealthFacility_Code
	 where c.Financial_Year=@FinancialYr 
	 and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)
) A
left outer join
(
  --select  CH.State_Code,CH.District_Code,CH.HealthBlock_Code 
  select State_Code,HealthBlock_Code,HealthFacility_Code  

,SUM(ISNULL(Total_Birthdate,0)) as Total_Birthdate
,SUM(ISNULL(BCG,0)) as BCG
,SUM(ISNULL(OPV0,0)) as OPV0  
,SUM(ISNULL(HEP0,0)) as HEP0
,SUM(ISNULL(DPT1,0)) as DPT1   
,SUM(ISNULL(OPV1,0)) as OPV1   
,SUM(ISNULL(HEP1,0)) as HEP1   
,SUM(ISNULL(PENTA1,0)) as PENTA1 
,SUM(ISNULL(DPT2,0)) as DPT2
,SUM(ISNULL(OPV2,0)) as OPV2
,SUM(ISNULL(HEP2,0)) as HEP2   
,SUM(ISNULL(PENTA2,0)) as PENTA2  
,SUM(ISNULL(DPT3,0)) as DPT3  
,SUM(ISNULL(OPV3,0)) as OPV3  
,SUM(ISNULL(HEP3,0)) as HEP3  
,SUM(ISNULL(PENTA3,0)) as PENTA3  
,SUM(ISNULL(Measles,0)) as Measles  
,SUM(ISNULL(AllVac,0)) as AllVac   
,SUM(ISNULL(Dead_Child,0)) as Dead_Child   
,SUM(ISNULL(Delete_Child,0)) as Delete_Child 
--Added By Rishi on 19 March -2019
,SUM(ISNULL(MR,0)) as MR
,SUM(ISNULL(MR1,0)) as MR1
,SUM(ISNULL(PCV1,0)) as PCV1
,SUM(ISNULL(PCV2,0)) as PCV2
,SUM(ISNULL(PCVB,0)) as PCVB    

------------------------------------added by shital on 290719------------------------------------------
,Sum([Rota1])as Rota1
,Sum([Rota2])as Rota2
,Sum([Rota3])as Rota3
,Sum([DPTB1])as DPTB1
,Sum([DPTB2])as DPTB2
,Sum([OPVB])as OPVB
,Sum([MEASLES2])as MEASLES2
,Sum([JE1])as JE1
,Sum([JE2])as JE2
,Sum([VITK])as VITK   

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
 
,SUM([IPV1])as IPV1
,SUM([IPV2]) as IPV2
,SUM([VIT1]) as VIT1 
,SUM([VIT2] ) as VIT2
,SUM([VIT3]) as VIT3
,SUM([VIT4] ) as VIT4
,SUM([VIT5] ) as VIT5
,SUM([VIT6] ) as VIT6
,SUM([VIT7] ) as VIT7
,SUM([VIT8]) as VIT8 
,SUM([VIT9] ) as VIT9
,SUM([Received_All_Vac])as [Received_All_Vac]
   
   from dbo.Scheduled_Tracking_CH_Block_PHC_Month as CH WITH (NOLOCK)   
 where State_Code =@State_Code
 and HealthBlock_Code =@HealthBlock_Code   
 and Fin_Yr=@FinancialYr
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by State_Code,HealthBlock_Code,HealthFacility_Code

 )  B on A.HealthBlock_Code=B.HealthBlock_Code and A.HealthFacility_Code=B.HealthFacility_Code
 order by A.HealthBlock_Name,A.HealthFacility_Name 
end
----\\\\\

else if(@Category='PHC')
begin
select A.State_Code,A.HealthFacility_Code as ParentID,A.HealthSubFacility_Code as ChildID
,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName,
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child,ISNULL (Dead_Child,0)as Dead_Child
--Added By Rishi on 19 March -2019
,ISNULL(MR1,0) as MR1
,ISNULL(MR,0) as MR2
,ISNULL(PCV1,0) as PCV1
,ISNULL(PCV2,0) as PCV2
,ISNULL(PCVB,0) as PCBB
--,dbo.Deactivation_Service(0) as ImmuCode 
,'' as ImmuCode

--------------------------------------added by shital 290719---------------------------------------------------------------------

,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
,ISNULL(IPV1,0)as IPV1,ISNULL(IPV2,0) as IPV2
,ISNULL([VIT1],0) as VIT1 
,ISNULL([VIT2] ,0) as VIT2
,ISNULL([VIT3],0) as VIT3
,ISNULL([VIT4] ,0) as VIT4
,ISNULL([VIT5],0 ) as VIT5
,ISNULL([VIT6],0 ) as VIT6
,ISNULL([VIT7],0 ) as VIT7
,ISNULL([VIT8],0) as VIT8 
,ISNULL([VIT9],0 ) as VIT9
,ISNULL([Received_All_Vac],0 ) as Complete_Immu


from  
(select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name
      from TBL_SUBPHC a WITH (NOLOCK) 
	  inner join TBL_PHC b WITH (NOLOCK) on a.PHC_CD=b.PHC_CD
      inner join  Estimated_Data_SubCenter_Wise c WITH (NOLOCK) on a.SUBPHC_CD=c.HealthSubFacility_Code and a.PHC_CD=c.HealthFacility_Code
     where c.Financial_Year=@FinancialYr 
     and ( a.PHC_CD= @HealthFacility_Code or @HealthFacility_Code=0)
) A
left outer join
(
 select State_Code,HealthFacility_Code,HealthSubFacility_Code
,SUM(ISNULL(Total_Birthdate,0)) as Total_Birthdate
,SUM(ISNULL(BCG,0)) as BCG
,SUM(ISNULL(OPV0,0)) as OPV0  
,SUM(ISNULL(HEP0,0)) as HEP0
,SUM(ISNULL(DPT1,0)) as DPT1   
,SUM(ISNULL(OPV1,0)) as OPV1   
,SUM(ISNULL(HEP1,0)) as HEP1   
,SUM(ISNULL(PENTA1,0)) as PENTA1 
,SUM(ISNULL(DPT2,0)) as DPT2
,SUM(ISNULL(OPV2,0)) as OPV2
,SUM(ISNULL(HEP2,0)) as HEP2   
,SUM(ISNULL(PENTA2,0)) as PENTA2  
,SUM(ISNULL(DPT3,0)) as DPT3  
,SUM(ISNULL(OPV3,0)) as OPV3  
,SUM(ISNULL(HEP3,0)) as HEP3  
,SUM(ISNULL(PENTA3,0)) as PENTA3  
,SUM(ISNULL(Measles,0)) as Measles  
,SUM(ISNULL(AllVac,0)) as AllVac   
,SUM(ISNULL(Dead_Child,0)) as Dead_Child   
,SUM(ISNULL(Delete_Child,0)) as Delete_Child 
--Added By Rishi on 19 March -2019
,SUM(ISNULL(MR,0)) as MR
,SUM(ISNULL(MR1,0)) as MR1
,SUM(ISNULL(PCV1,0)) as PCV1
,SUM(ISNULL(PCV2,0)) as PCV2
,SUM(ISNULL(PCVB,0)) as PCVB    

------------------------------------added by shital on 290719------------------------------------------
,Sum([Rota1])as Rota1
,Sum([Rota2])as Rota2
,Sum([Rota3])as Rota3
,Sum([DPTB1])as DPTB1
,Sum([DPTB2])as DPTB2
,Sum([OPVB])as OPVB
,Sum([MEASLES2])as MEASLES2
,Sum([JE1])as JE1
,Sum([JE2])as JE2
,Sum([VITK])as VITK 

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
 
,SUM([IPV1])as IPV1
,SUM([IPV2]) as IPV2
,SUM([VIT1]) as VIT1 
,SUM([VIT2] ) as VIT2
,SUM([VIT3]) as VIT3
,SUM([VIT4] ) as VIT4
,SUM([VIT5] ) as VIT5
,SUM([VIT6] ) as VIT6
,SUM([VIT7] ) as VIT7
,SUM([VIT8]) as VIT8 
,SUM([VIT9] ) as VIT9
,SUM([Received_All_Vac])as [Received_All_Vac] 
   
   from dbo.Scheduled_Tracking_CH_PHC_SubCenter_Month as CH  WITH (NOLOCK) 
 where State_Code =@State_Code
 and HealthFacility_Code =@HealthFacility_Code   
 and Fin_Yr=@FinancialYr 
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.HealthFacility_Code,CH.HealthSubFacility_Code
 )  B on A.HealthFacility_Code=B.HealthFacility_Code and A.HealthSubFacility_Code=B.HealthSubFacility_Code
 order by A.HealthFacility_Name,A.HealthSubFacility_Name
end

else if(@Category='Subcentre')--Added by sneha on 29072016
begin
select A.State_Code,A.HealthSubFacility_Code as ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child,ISNULL (Dead_Child,0)as Dead_Child
--Added By Rishi on 19 March -2019
,ISNULL(MR1,0) as MR1
,ISNULL(MR,0) as MR2
,ISNULL(PCV1,0) as PCV1
,ISNULL(PCV2,0) as PCV2
,ISNULL(PCVB,0) as PCBB
--,dbo.Deactivation_Service(0) as ImmuCode 
,'' as ImmuCode

--------------------------------------added by shital 290719---------------------------------------------------------------------

,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK

--------------------------------------added by Shital 18112019---------------------------------------------------------------------

,ISNULL(IPV1,0)as IPV1,ISNULL(IPV2,0) as IPV2
,ISNULL([VIT1],0) as VIT1 
,ISNULL([VIT2] ,0) as VIT2
,ISNULL([VIT3],0) as VIT3
,ISNULL([VIT4] ,0) as VIT4
,ISNULL([VIT5],0 ) as VIT5
,ISNULL([VIT6],0 ) as VIT6
,ISNULL([VIT7],0 ) as VIT7
,ISNULL([VIT8],0) as VIT8 
,ISNULL([VIT9],0 ) as VIT9
,ISNULL([Received_All_Vac],0 ) as Complete_Immu


from  
(
select a.State_Code,a.HealthSubFacility_Code as HealthSubFacility_Code,b.SUBPHC_NAME as HealthSubFacility_Name ,a.Village_Code   as Village_Code,a.VILLAGE_NAME as Village_Name
from Estimated_Data_Village_Wise a WITH (NOLOCK) 
inner join TBL_SUBPHC b WITH (NOLOCK)  on a.HealthSubFacility_Code=b.SUBPHC_CD
left outer join  Village c WITH (NOLOCK)  on a.Village_Code=c.VCode 
where a.Financial_Year=@FinancialYr 
and a.HealthSubFacility_Code= @HealthSubFacility_Code

) A
left outer join
(
 select State_Code,HealthSubFacility_Code,Village_Code
,SUM(ISNULL(Total_Birthdate,0)) as Total_Birthdate
,SUM(ISNULL(BCG,0)) as BCG
,SUM(ISNULL(OPV0,0)) as OPV0  
,SUM(ISNULL(HEP0,0)) as HEP0
,SUM(ISNULL(DPT1,0)) as DPT1   
,SUM(ISNULL(OPV1,0)) as OPV1   
,SUM(ISNULL(HEP1,0)) as HEP1   
,SUM(ISNULL(PENTA1,0)) as PENTA1 
,SUM(ISNULL(DPT2,0)) as DPT2
,SUM(ISNULL(OPV2,0)) as OPV2
,SUM(ISNULL(HEP2,0)) as HEP2   
,SUM(ISNULL(PENTA2,0)) as PENTA2  
,SUM(ISNULL(DPT3,0)) as DPT3  
,SUM(ISNULL(OPV3,0)) as OPV3  
,SUM(ISNULL(HEP3,0)) as HEP3  
,SUM(ISNULL(PENTA3,0)) as PENTA3  
,SUM(ISNULL(Measles,0)) as Measles  
,SUM(ISNULL(AllVac,0)) as AllVac   
,SUM(ISNULL(Dead_Child,0)) as Dead_Child   
,SUM(ISNULL(Delete_Child,0)) as Delete_Child 
--Added By Rishi on 19 March -2019
,SUM(ISNULL(MR,0)) as MR
,SUM(ISNULL(MR1,0)) as MR1
,SUM(ISNULL(PCV1,0)) as PCV1
,SUM(ISNULL(PCV2,0)) as PCV2
,SUM(ISNULL(PCVB,0)) as PCVB   
------------------------------------added by shital on 290719------------------------------------------
,Sum([Rota1])as Rota1
,Sum([Rota2])as Rota2
,Sum([Rota3])as Rota3
,Sum([DPTB1])as DPTB1
,Sum([DPTB2])as DPTB2
,Sum([OPVB])as OPVB
,Sum([MEASLES2])as MEASLES2
,Sum([JE1])as JE1
,Sum([JE2])as JE2
,Sum([VITK])as VITK 

--------------------------------------added by Shital 18112019---------------------------------------------------------------------
 
,SUM([IPV1])as IPV1
,SUM([IPV2]) as IPV2
,SUM([VIT1]) as VIT1 
,SUM([VIT2] ) as VIT2
,SUM([VIT3]) as VIT3
,SUM([VIT4] ) as VIT4
,SUM([VIT5] ) as VIT5
,SUM([VIT6] ) as VIT6
,SUM([VIT7] ) as VIT7
,SUM([VIT8]) as VIT8 
,SUM([VIT9] ) as VIT9
,SUM([Received_All_Vac])as [Received_All_Vac]
    
   from dbo.Scheduled_Tracking_CH_PHC_SubCenter_Village_Month as CH WITH (NOLOCK)  
 where State_Code =@State_Code
 and HealthFacility_Code =@HealthFacility_Code   
 and Fin_Yr=@FinancialYr 
  and (Month_ID=@Month_ID or @Month_ID=0)
 and (Year_ID=@Year_ID or @Year_ID=0)
 group by CH.State_Code,CH.HealthSubFacility_Code,CH.Village_Code
 )  B on A.HealthSubFacility_Code=B.HealthSubFacility_Code and A.Village_Code=B.Village_Code
 order by A.HealthSubFacility_Name,A.Village_Name
end
end

