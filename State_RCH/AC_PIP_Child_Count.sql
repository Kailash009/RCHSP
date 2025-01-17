USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_PIP_Child_Count]    Script Date: 09/26/2024 11:52:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  /*  
AC_PIP_Status_Child 16,0,0,0,0,0,2021,0,0,'','','State'  
*/  
ALTER procedure [dbo].[AC_PIP_Child_Count]  
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
,dbo.Deactivation_Service(0) as ImmuCode   
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
,ISNULL(C.Estimated_Infant,0 ) as Estimated_Infant  
,ISNULL(z.Estimated_Infant_Total,0) as Estimated_Infant_Total  
,ISNULL(D.Child_Entry,0) as Child_Entry  
from    
 (  
 select c.State_Code as State_Code,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name,b.StateName as State_Name  
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
 B on A.District_Code=B.District_Code  
 left outer join  
(  
select a.StateID,a.DIST_CD,b.Estimated_Infant as Estimated_Infant       
 from TBL_DISTRICT a      
 left outer join Estimated_Data_District_Wise b on a.Dist_Cd=b.District_Code      
 left outer join TBL_STATE c on a.StateID=c.StateID    
 where  b.Financial_Year=@FinancialYr  
) C on A.District_Code=C.DIST_CD  
left outer join  
(  
select b.State_Code,b.Estimated_Infant as Estimated_Infant_Total      
from RCH_Reports.dbo.Estimated_Data_All_State (nolock) b       
where b.State_Code=@State_Code   
and b.Financial_Year=@FinancialYr                    
) Z on A.State_Code=Z.State_Code    
left outer join  
(  
select Sum(Infant_Registered)as Child_Entry,State_Code , District_Code     
 from Scheduled_AC_CHILD_State_District_Month     
 where Fin_Yr=@FinancialYr     
 and (Month_ID =@Month_ID or @Month_ID=0)    
 and (Year_ID =@Year_ID or @Year_ID=0)    
 and Filter_Type=1     
 group by State_Code,District_Code  
)D on D.State_Code=A.State_Code and D.District_Code=A.District_Code  
end  
  
else if(@Category='District')  
begin  
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName,  
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,  
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,  
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,  
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child  
,ISNULL (Dead_Child,0)as Dead_Child    
,ISNULL(MR1,0) as MR1  
,ISNULL(MR,0) as MR2  
,ISNULL(PCV1,0) as PCV1  
,ISNULL(PCV2,0) as PCV2  
,ISNULL(PCVB,0) as PCBB  
,dbo.Deactivation_Service(0) as ImmuCode  
,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,  
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK  
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
,ISNULL(C.Estimated_Infant,0 ) as Estimated_Infant  
,'' as Estimated_Infant_Total  
,ISNULL(D.Child_Entry,0) as Child_Entry 
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
,SUM(ISNULL(MR,0)) as MR  
,SUM(ISNULL(MR1,0)) as MR1  
,SUM(ISNULL(PCV1,0)) as PCV1  
,SUM(ISNULL(PCV2,0)) as PCV2  
,SUM(ISNULL(PCVB,0)) as PCVB     
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
 B on A.District_Code=B.District_Code and A.HealthBlock_Code=B.HealthBlock_Code  
 left outer join  
 (  
 select  b.DISTRICT_CD,b.BLOCK_CD,c.Estimated_Infant as Estimated_Infant      
 from TBL_HEALTH_BLOCK b      
 left outer join Estimated_Data_Block_Wise c on b.BLOCK_CD=c.HealthBlock_Code      
 inner join TBL_DISTRICT a on b.DISTRICT_CD=a.DIST_CD    
 where b.DISTRICT_CD=@District_Code and c.Financial_Year=@FinancialYr  
 )C on A.District_Code=C.DISTRICT_CD and A.HealthBlock_Code=C.BLOCK_CD  
 left outer join    
 (select Sum(Infant_Registered)as Child_Entry,District_Code  as  District_Code, HealthBlock_Code as  HealthBlock_Code     
 from Scheduled_AC_Child_District_Block_Month     
 where Fin_Yr=@FinancialYr     
 and (Month_ID =@Month_ID or @Month_ID=0)    
 and (Year_ID =@Year_ID or @Year_ID=0)    
 and Filter_Type=1     
 group by District_Code,HealthBlock_Code) D on D.District_Code=A.District_Code and D.HealthBlock_Code=A.HealthBlock_Code  
end  
  
  
  
if(@Category='Block')  
begin  
select A.State_Code,A. HealthBlock_Code as ParentID ,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName,  
 ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,  
 ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,  
 ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,  
 ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child  
,ISNULL (Dead_Child,0)as Dead_Child    
,ISNULL(MR1,0) as MR1  
,ISNULL(MR,0) as MR2  
,ISNULL(PCV1,0) as PCV1  
,ISNULL(PCV2,0) as PCV2  
,ISNULL(PCVB,0) as PCBB  
,dbo.Deactivation_Service(0) as ImmuCode  
,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,  
 ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK  
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
,ISNULL(C.Estimated_Infant,0 ) as Estimated_Infant  
,'' as Estimated_Infant_Total 
,ISNULL(D.Child_Entry,0) as Child_Entry  
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
 Select State_Code,HealthBlock_Code,HealthFacility_Code    
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
,SUM(ISNULL(MR,0)) as MR  
,SUM(ISNULL(MR1,0)) as MR1  
,SUM(ISNULL(PCV1,0)) as PCV1  
,SUM(ISNULL(PCV2,0)) as PCV2  
,SUM(ISNULL(PCVB,0)) as PCVB       
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
 left outer join  
 (  
 select a.BID as HealthBlock_Code,a.PHC_CD as HealthFacility_Code,      
 c.Estimated_Infant as Estimated_Infant        
 from TBL_PHC  a      
 inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD      
 inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code      
 where c.Financial_Year=@FinancialYr       
 and (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)  
 )C ON A.HealthBlock_Code=C.HealthBlock_Code and A.HealthFacility_Code=C.HealthFacility_Code  
 left outer join    
 (select Sum(Infant_Registered)as Child_Entry, HealthBlock_Code, HealthFacility_Code     
 from Scheduled_AC_Child_Block_PHC_Month     
 where Fin_Yr=@FinancialYr     
 and (Month_ID =@Month_ID or @Month_ID=0)    
 and (Year_ID =@Year_ID or @Year_ID=0)    
 and Filter_Type=1     
 group by HealthBlock_Code, HealthFacility_Code) D on D.HealthBlock_Code=A.HealthBlock_Code and D.HealthFacility_Code=A.HealthFacility_Code   
   
end  
----\\\\\  
  
else if(@Category='PHC')  
begin  
select A.State_Code,A.HealthFacility_Code as ParentID,A.HealthSubFacility_Code as ChildID  
,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName,  
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,  
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,  
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,  
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child  
,ISNULL (Dead_Child,0)as Dead_Child    
,ISNULL(MR1,0) as MR1  
,ISNULL(MR,0) as MR2  
,ISNULL(PCV1,0) as PCV1  
,ISNULL(PCV2,0) as PCV2  
,ISNULL(PCVB,0) as PCBB  
,dbo.Deactivation_Service(0) as ImmuCode  
,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,  
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK  
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
,ISNULL(C.Estimated_Infant,0 ) as Estimated_Infant  
,'' as Estimated_Infant_Total 
,ISNULL(D.Child_Entry,0) as Child_Entry  
from    
(select c.State_Code,a.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,a.SUBPHC_CD as HealthSubFacility_Code,a.SUBPHC_NAME_E as HealthSubFacility_Name  
      from TBL_SUBPHC a WITH (NOLOCK)   
   inner join TBL_PHC b WITH (NOLOCK) on a.PHC_CD=b.PHC_CD  
      inner join  Estimated_Data_SubCenter_Wise c WITH (NOLOCK) on a.SUBPHC_CD=c.HealthSubFacility_Code  
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
,SUM(ISNULL(MR,0)) as MR  
,SUM(ISNULL(MR1,0)) as MR1  
,SUM(ISNULL(PCV1,0)) as PCV1  
,SUM(ISNULL(PCV2,0)) as PCV2  
,SUM(ISNULL(PCVB,0)) as PCVB       
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
 left outer join  
 (  
  select b.PHC_CD as HealthFacility_Code ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,    
   a.Estimated_Infant as Estimated_Infant      
   from Estimated_Data_SubCenter_Wise a      
   inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD      
   left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD       
   where a.Financial_Year=@FinancialYr       
   and (a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)  
 )C on A.HealthFacility_Code=c.HealthFacility_Code and A.HealthSubFacility_Code=c.HealthSubFacility_Code  
 left outer join    
 (select Sum(Infant_Registered)as Child_Entry, HealthFacility_Code,HealthSubFacility_Code     
 from Scheduled_AC_child_PHC_SubCenter_Month     
 where Fin_Yr=@FinancialYr     
 and (Month_ID =@Month_ID or @Month_ID=0)    
 and (Year_ID =@Year_ID or @Year_ID=0)    
 and Filter_Type=1     
 group by HealthFacility_Code,HealthSubFacility_Code) D on D.HealthFacility_Code=A.HealthFacility_Code and D.HealthSubFacility_Code=A.HealthSubFacility_Code  
end  
  
else if(@Category='Subcentre')--Added by sneha on 29072016  
begin  
select A.State_Code,A.HealthSubFacility_Code as ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName,  
ISNULL(Total_Birthdate,0) as Total_Birthdate,ISNULL (BCG,0) as BCG,ISNULL (OPV0,0) as OPV0,ISNULL (HEP0,0) as HEP0,ISNULL (DPT1,0) as DPT1,  
ISNULL (OPV1,0) as OPV1,ISNULL (HEP1,0) as HEP1,ISNULL (PENTA1,0) as PENTA1,ISNULL (DPT2,0) as DPT2,ISNULL (OPV2,0) as OPV2,  
ISNULL (HEP2,0) as HEP2,ISNULL (PENTA2,0) as PENTA2,ISNULL (DPT3,0) as DPT3,ISNULL (OPV3,0) as OPV3,ISNULL (HEP3,0)as HEP3,  
ISNULL (PENTA3,0) as  PENTA3,ISNULL (Measles,0) as Measles,ISNULL (AllVac,0) as AllVac,ISNULL (Delete_Child,0)as Delete_Child  
,ISNULL (Dead_Child,0)as Dead_Child    
,ISNULL(MR1,0) as MR1  
,ISNULL(MR,0) as MR2  
,ISNULL(PCV1,0) as PCV1  
,ISNULL(PCV2,0) as PCV2  
,ISNULL(PCVB,0) as PCBB  
,dbo.Deactivation_Service(0) as ImmuCode  
,Isnull(Rota1,0) as Rota1,ISNULL(Rota2,0)as Rota2,ISNULL(Rota3,0)as Rota3,ISNULL(DPTB1,0)as DPTB1,ISNULL(DPTB2,0)as DPTB2,ISNULL(OPVB,0)as OPVB,  
ISNULL(MEASLES2,0)as MEASLES2,ISNULL(JE1,0)as JE1,ISNULL(JE2,0)as JE2,ISNULL(VITK,0)as VITK  
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
,ISNULL(C.Estimated_Infant,0 ) as Estimated_Infant  
,'' as Estimated_Infant_Total 
,ISNULL(D.Child_Entry,0) as Child_Entry  
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
,SUM(ISNULL(MR,0)) as MR  
,SUM(ISNULL(MR1,0)) as MR1  
,SUM(ISNULL(PCV1,0)) as PCV1  
,SUM(ISNULL(PCV2,0)) as PCV2  
,SUM(ISNULL(PCVB,0)) as PCVB      
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
 left outer join  
 (  
 select  c.HealthSubFacility_Code as SID,isnull(c.Village_Code,0)as VCode,     
 c.Estimated_Infant as Estimated_Infant        
 from Estimated_Data_Village_Wise  c       
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code      
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code      
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)      
 and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr  
 )C on A.HealthSubFacility_Code=C.SID and A.Village_Code=C.VCode  
 left outer join    
 (  
 select Sum(Infant_Registered)as Child_Entry,Village_Code as  Village_Code, HealthSubFacility_Code as  HealthSubFacility_Code     
 from Scheduled_AC_Child_PHC_SubCenter_Village_Month     
 where Fin_Yr=@FinancialYr     
 and (Month_ID =@Month_ID or @Month_ID=0)    
 and (Year_ID =@Year_ID or @Year_ID=0)    
 and Filter_Type=1     
 group by Village_Code,HealthSubFacility_Code  
 ) D on D.Village_Code=A.Village_Code and D.HealthSubFacility_Code=A.HealthSubFacility_Code  
end  
END  
