USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_Scheduled_DB_DashBoard_Count]    Script Date: 09/26/2024 15:58:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
tp_Scheduled_DB_DashBoard_Count 0,0,0,0,0,1
tp_Scheduled_DB_DashBoard_Count 30,0,0,0,0,2
tp_Scheduled_DB_DashBoard_Count 30,1,0,0,0,3
tp_Scheduled_DB_DashBoard_Count 30,1,2,0,0,4
tp_Scheduled_DB_DashBoard_Count 30,1,2,4,0,5
tp_Scheduled_DB_DashBoard_Count 30,1,2,4,53,6
*/

ALTER Procedure [dbo].[tp_Scheduled_DB_DashBoard_Count] 
(
@StateID as int=0,
@DistrictID as int=0,
@HealthBlock_Code int=0,
@HealthFacility_Code int=0,
@HealthSubFacility_Code int=0,
@TypeID int
)
as
Begin

Declare @YEar as int=0
if(month(Getdate()-1)>3)
set @YEar=Year(Getdate()-1)
else
set @YEar=Year(Getdate()-1)-1
------------------------------------------------------------------------------------------------------------------------------------------
if (@TypeID = 1)--national
begin
            --select 
            --Replace(Convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count, 
            --Replace(Convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count, 
            --Replace(convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count,
            --Replace(convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count,
            --Replace(convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count
            --from [RCH_Reports].[dbo].Scheduled_DB_AllState__DashBoard_Count
            
            ------------------------------Aletered on 03-11-2017 casue of CRM---------------------------------------------
            
            --select 
            --Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
            --Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
            --Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
            --from RCH_Reports.dbo.Scheduled_DB_National_Count
 SELECT Replace(Convert(varchar(20),(cast(SUM([EC_Count])as Money)),1),'.00','') as EC_Total_Count, 
Replace(Convert(varchar(20),(cast(SUM([Mother_Count]) as Money)),1),'.00','') as Mother_Total_Count, 
Replace(convert(varchar(20),(cast(SUM([Child_Count]) as Money)),1),'.00','') as Child_Total_Count
FROM [RCH_Reports].[dbo].[Scheduled_BR_State_District_Reg_Count] where Fin_Yr=@year
            
     
      
 end
-----------------------------------------------------------------------------------------------------------------------------------------
if (@TypeID = 2)--state
   begin 
				--select  StateID as StateID , 
				--Replace(Convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count, 
				--Replace(Convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count, 
				--Replace(Convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count,
			 --   Replace(Convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count,
				--Replace(Convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count 
				--from Scheduled_DB_State_District_Count 
				--where StateID = @StateID
				--group by StateID
            ------------------------------Aletered on 03-11-2017 casue of CRM---------------------------------------------

			--select 
   --         Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
   --         Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
   --         Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
   --         from Scheduled_Consolidated_State_Count where State_Code = @StateID
   
select Replace(Convert(varchar(20),(cast(isnull(B.EC,0) as Money)),1),'.00','') as EC_Total_Count
,Replace(Convert(varchar(20),(cast(isnull(C.PW,0) as Money)),1),'.00','') as Mother_Total_Count
,Replace(convert(varchar(20),(cast(isnull(A.Child,0) as Money)),1),'.00','') as Child_Total_Count
from 
(select State_Code,SUM(Child_0_1+Child_1_2+Child_2_3+Child_3_4+Child_4_5) as Child
from Scheduled_AC_Child_State_District_Month where Filter_Type=1 and Fin_Yr=@YEar
group by State_Code)A
left outer join
(select State_Code,sum(EC_Registered) as EC
from Scheduled_AC_EC_State_District_Month where Filter_Type=1   
and Fin_Yr=@YEar
group by State_Code
)B on A.State_Code=B.State_Code 
left outer join
(select State_Code,sum(PW_Registered) as PW
from Scheduled_AC_PW_State_District_Month 
where Filter_Type=1 and Fin_Yr=@YEar
group by State_Code)C on A.State_Code=C.State_Code 
	 
	end
----------------------------------------------------------------------------------------------------------------------------------------------
	else if (@TypeID = 3)--district
	begin
      
       --select StateID as StateID , District_ID as District_ID,
       --Replace(Convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count,
       --Replace(Convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count, 
       --Replace(Convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count,
       --Replace(Convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count, 
       --Replace(convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count
       --from Scheduled_DB_District_Block_Count
       --where District_ID = @DistrictID and (HealthBlock_ID = @HealthBlock_Code or @HealthBlock_Code=0)
       -- group by StateID, District_ID
       
       --select 
       --     Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
       --     Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
       --     Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
       --     from Scheduled_Consolidated_District_Count where District_Code = @DistrictID 
       
select Replace(Convert(varchar(20),(cast(isnull(B.EC,0) as Money)),1),'.00','') as EC_Total_Count
,Replace(Convert(varchar(20),(cast(isnull(C.PW,0) as Money)),1),'.00','') as Mother_Total_Count
,Replace(convert(varchar(20),(cast(isnull(A.Child,0) as Money)),1),'.00','') as Child_Total_Count
from 
(select District_Code,SUM(Child_0_1+Child_1_2+Child_2_3+Child_3_4+Child_4_5) as Child
from Scheduled_AC_Child_District_Block_Month 
where Filter_Type=1 and Fin_Yr=@YEar and District_Code = @DistrictID 
group by District_Code)A
left outer join
(select District_Code,sum(EC_Registered) as EC
from Scheduled_AC_EC_District_Block_Month 
where Filter_Type=1  and Fin_Yr=@YEar and District_Code = @DistrictID 
group by District_Code
)B on A.District_Code=B.District_Code 
left outer join
(select District_Code,sum(PW_Registered) as PW
from Scheduled_AC_PW_District_Block_Month 
where Filter_Type=1 and Fin_Yr=@YEar and District_Code = @DistrictID 
group by District_Code)C on A.District_Code=C.District_Code 
       
end
       -------------------------------------------------------------------------------------------------------------------------------------
       else if (@TypeID = 4)--Block
       begin
       
      --select StateID as StateID, HealthBlock_ID as HealthBlock_ID,
      -- Replace(Convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count, 
      -- Replace(Convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count,
      -- Replace(convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count, 
      -- Replace(convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count , 
      -- Replace(convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count  
      -- from Scheduled_DB_Block_PHC_Count
      --where HealthBlock_ID = @HealthBlock_Code and (PHC_ID = @HealthFacility_Code or @HealthFacility_Code=0)
      --group by StateID, HealthBlock_ID
      
       --select 
       --     Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
       --     Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
       --     Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
       --     from Scheduled_Consolidated_Block_Count where HealthBlock_Code = @HealthBlock_Code
select Replace(Convert(varchar(20),(cast(isnull(B.EC,0) as Money)),1),'.00','') as EC_Total_Count
,Replace(Convert(varchar(20),(cast(isnull(C.PW,0) as Money)),1),'.00','') as Mother_Total_Count
,Replace(convert(varchar(20),(cast(isnull(A.Child,0) as Money)),1),'.00','') as Child_Total_Count
from 
(select HealthBlock_Code,SUM(Child_0_1+Child_1_2+Child_2_3+Child_3_4+Child_4_5) as Child
from Scheduled_AC_Child_Block_PHC_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthBlock_Code = @HealthBlock_Code
group by HealthBlock_Code)A
left outer join
(select HealthBlock_Code,sum(EC_Registered) as EC
from Scheduled_AC_EC_Block_PHC_Month 
where Filter_Type=1  and Fin_Yr=@YEar and HealthBlock_Code = @HealthBlock_Code
group by HealthBlock_Code
)B on A.HealthBlock_Code=B.HealthBlock_Code 
left outer join
(select HealthBlock_Code,sum(PW_Registered) as PW
from Scheduled_AC_PW_Block_PHC_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthBlock_Code = @HealthBlock_Code 
group by HealthBlock_Code)C on A.HealthBlock_Code=C.HealthBlock_Code   
	   
	 end
	
----------------------------------------------------------------------------------------------------------------------------------------------------

    else if (@TypeID = 5)--PHC SUBCENTRE

       begin
       
      --select StateID as StateID , PHC_ID as PHC_ID ,
      --Replace(convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count,
      --Replace(convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count,
      --Replace(convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count,
      --Replace(convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count,
      --Replace(convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count
      --from Scheduled_DB_PHC_SubCenter_Count
      --where PHC_ID = @HealthFacility_Code and (SubCentre_ID = @HealthSubFacility_Code or @HealthSubFacility_Code=0)
      --group by StateID,PHC_ID
      
      --select 
      --      Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
      --      Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
      --      Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
      --      from Scheduled_Consolidated_PHC_Count where HealthFacility_Code = @HealthFacility_Code
      
      -- end 
select Replace(Convert(varchar(20),(cast(isnull(B.EC,0) as Money)),1),'.00','') as EC_Total_Count
,Replace(Convert(varchar(20),(cast(isnull(C.PW,0) as Money)),1),'.00','') as Mother_Total_Count
,Replace(convert(varchar(20),(cast(isnull(A.Child,0) as Money)),1),'.00','') as Child_Total_Count
from 
(select HealthFacility_Code,SUM(Child_0_1+Child_1_2+Child_2_3+Child_3_4+Child_4_5) as Child
from Scheduled_AC_Child_PHC_SubCenter_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthFacility_Code = @HealthFacility_Code
group by HealthFacility_Code)A
left outer join
(select HealthFacility_Code,sum(EC_Registered) as EC
from Scheduled_AC_EC_PHC_SubCenter_Month 
where Filter_Type=1  and Fin_Yr=@YEar and HealthFacility_Code = @HealthFacility_Code
group by HealthFacility_Code
)B on A.HealthFacility_Code=B.HealthFacility_Code 
left outer join
(select HealthFacility_Code,sum(PW_Registered) as PW
from Scheduled_AC_PW_PHC_SubCenter_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthFacility_Code = @HealthFacility_Code
group by HealthFacility_Code)C on A.HealthFacility_Code=C.HealthFacility_Code
end   
      
   else if (@TypeID = 6)--SUBCENTRE

   begin
   
  --select StateID as StateID , PHC_ID as PHC_ID ,
  --Replace(convert(varchar(20),(cast(SUM(EC_Total_Count) as Money)),1),'.00','') as EC_Total_Count,
  --Replace(convert(varchar(20),(cast(SUM(Mother_Total_Count) as Money)),1),'.00','') as Mother_Total_Count,
  --Replace(convert(varchar(20),(cast(SUM(Child_Total_Count) as Money)),1),'.00','') as Child_Total_Count,
  --Replace(convert(varchar(20),(cast(SUM(ANM_Total_Count) as Money)),1),'.00','') as ANM_Total_Count,
  --Replace(convert(varchar(20),(cast(SUM(ASHA_Total_Count) as Money)),1),'.00','') as ASHA_Total_Count
  --from Scheduled_DB_PHC_SubCenter_Count
  --where PHC_ID = @HealthFacility_Code and (SubCentre_ID = @HealthSubFacility_Code or @HealthSubFacility_Code=0)
  --group by StateID,PHC_ID
  
  --select 
  --      HealthSubFacility_Code,Replace(Convert(varchar(20),(cast(EC_Count as Money)),1),'.00','') as EC_Total_Count, 
  --      Replace(Convert(varchar(20),(cast(Mother_Count as Money)),1),'.00','') as Mother_Total_Count, 
  --      Replace(convert(varchar(20),(cast(Child_Count as Money)),1),'.00','') as Child_Total_Count
  --      from Scheduled_Consolidated_Subcentre_Count where HealthSubFacility_Code = @HealthSubFacility_Code
  
select Replace(Convert(varchar(20),(cast(isnull(B.EC,0) as Money)),1),'.00','') as EC_Total_Count
,Replace(Convert(varchar(20),(cast(isnull(C.PW,0) as Money)),1),'.00','') as Mother_Total_Count
,Replace(convert(varchar(20),(cast(isnull(A.Child,0) as Money)),1),'.00','') as Child_Total_Count
from 
(select HealthSubFacility_Code,SUM(Child_0_1+Child_1_2+Child_2_3+Child_3_4+Child_4_5) as Child
from Scheduled_AC_Child_PHC_SubCenter_Village_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthSubFacility_Code = @HealthSubFacility_Code
group by HealthSubFacility_Code)A
left outer join
(select HealthSubFacility_Code,sum(EC_Registered) as EC
from Scheduled_AC_EC_PHC_SubCenter_Village_Month 
where Filter_Type=1  and Fin_Yr=@YEar and HealthSubFacility_Code = @HealthSubFacility_Code
group by HealthSubFacility_Code
)B on A.HealthSubFacility_Code=B.HealthSubFacility_Code 
left outer join
(select HealthSubFacility_Code,sum(PW_Registered) as PW
from Scheduled_AC_PW_PHC_SubCenter_Village_Month 
where Filter_Type=1 and Fin_Yr=@YEar and HealthSubFacility_Code = @HealthSubFacility_Code
group by HealthSubFacility_Code)C on A.HealthSubFacility_Code=C.HealthSubFacility_Code   
  
   end 
  END





