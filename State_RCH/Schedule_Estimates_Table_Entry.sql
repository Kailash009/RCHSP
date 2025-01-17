USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Estimates_Table_Entry]    Script Date: 09/26/2024 14:44:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Schedule_Estimates_Table_Entry 34
*/
ALTER procedure [dbo].[Schedule_Estimates_Table_Entry]
(
@State_Code as int
)
as
begin

Declare @Finyr as varchar(10)=null
if(MONTH(GETDATE()-1)<4)
begin
set @Finyr=cast(YEAR(GETDATE()-1)-1 as varchar(4))+'-'+cast(YEAR(GETDATE()-1) as varchar(4))

end
else
begin

set @Finyr=cast(YEAR(GETDATE()-1) as varchar(4))+'-'+cast(YEAR(GETDATE())+1 as varchar(4))

end

if(DAY(getdate()-1)=1 and month(getdate()-1)=4)
begin
delete from [Estimated_Data_Village_Wise] where Financial_Year=left(@Finyr,4)
insert into [Estimated_Data_Village_Wise]([State_Code],[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name]
,[Village_Code],[Village_Name],[Estimated_Mother],[Estimated_EC],[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],Village_population
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards)
Select @State_Code as [State_Code],@Finyr,a.SID,b.SUBPHC_NAME_E,a.VCode,c.VILLAGE_NAME,0,0,0,GETDATE(),left(@Finyr,4),a.IsActive,0 ,0,0,0
from Health_SC_Village a
inner join TBL_SUBPHC b on a.SID=b.SUBPHC_CD
inner join TBL_VILLAGE c on a.VCode=c.VILLAGE_CD and a.SID=c.SUBPHC_CD
group by a.SID,b.SUBPHC_NAME_E,a.VCode,c.VILLAGE_NAME,a.IsActive


insert into Estimated_Data_SubCenter_Wise(State_Code,[Yr],HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])
select @State_Code,@Finyr,c.PHC_CD,c.PHC_NAME,a.SUBPHC_CD,a.SUBPHC_NAME_E,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_SUBPHC a  left outer  join Estimated_Data_SubCenter_Wise x  on a.PHC_CD=HealthFacility_Code and x.HealthSubFacility_Code=SUBPHC_CD  and Financial_Year=left(@Finyr,4)
inner join  TBL_PHC c on a.PHC_CD=c.PHC_CD  where x.HealthSubFacility_Code is null

insert into Estimated_Data_PHC_Wise(State_Code,[Yr],HealthBlock_Code,HealthBlock_Name,HealthFacility_Code,HealthFacility_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])
select @State_Code,@Finyr,c.BLOCK_CD,c.Block_Name_E,a.PHC_CD,a.PHC_NAME,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_PHC a left outer  join Estimated_Data_PHC_Wise x  on a.PHC_CD=HealthFacility_Code   and Financial_Year=left(@Finyr,4)
inner join  TBL_HEALTH_BLOCK c on a.BID=c.BLOCK_CD  where x.HealthFacility_Code is null

insert into Estimated_Data_block_Wise(State_Code,[Yr],District_Code,District_Name,HealthBlock_Code,HealthBlock_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])

select @State_Code,@Finyr,c.DIST_CD,c.DIST_NAME_ENG,a.BLOCK_CD,a.Block_Name_E,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_HEALTH_BLOCK a left outer  join Estimated_Data_block_Wise x  on a.BLOCK_CD=HealthBlock_Code   and Financial_Year=left(@Finyr,4)
inner join  TBL_DISTRICT c on a.DISTRICT_CD=c.DIST_CD where x.HealthBlock_Code is null

insert into [Estimated_Data_District_Wise]([State_Code],[Yr],[District_Code],[District_Name],[Estimated_Mother],[Estimated_Infant]
,[Created_Date],[Financial_Year],[IsActive],[V_Population],[Estimated_EC],[Total_Village],[Total_Profile_Entered]
,[Total_Direct_Profile],[Estimated_EC_Upwards],[Estimated_PW_Upwards],[Estimated_Infant_Upwards],[Total_ActiveVillage]
)
SELECT @State_Code,@Finyr,DIST_CD,DIST_NAME_ENG,0,0,getdate(),left(@Finyr,4),1,0,0,0,0,0,0,0,0,0
FROM TBL_DISTRICT a left outer  join [Estimated_Data_District_Wise] x  on a.DIST_CD=District_Code   and Financial_Year=left(@Finyr,4)
 where x.District_Code is null 

end



insert into Estimated_Data_Village_Wise([State_Code],[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name]
,[Village_Code],[Village_Name],[Estimated_Mother],[Estimated_EC],[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],Village_population
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards)
select @State_Code,(case when e.Finanacial_Yr IS null then @Finyr else   cast(e.Finanacial_Yr as varchar)+'-'+cast(e.Finanacial_Yr+1 as varchar) end)
,a.SID,c.SUBPHC_NAME_E,a.VCode,d.VILLAGE_NAME
,e.Estimated_PW,e.Eligible_Couples,e.Estimated_Infant,GETDATE(),(case when e.Finanacial_Yr IS null then left(@Finyr,4) else e.Finanacial_Yr end)  ,a.IsActive,e.Village_Population
,e.Eligible_Couples,e.Estimated_PW,e.Estimated_Infant 
from health_SC_village a
left outer join Estimated_Data_Village_Wise b on a.VCode=b.Village_Code and a.SID=b.HealthSubFacility_Code
inner join  TBL_SUBPHC c on a.SID=c.SUBPHC_CD 
inner join  TBL_VILLAGE d on a.VCode=d.VILLAGE_CD and a.SID=d.SUBPHC_CD
left outer join t_villagewise_registry e on a.VCode=e.Village_Code and a.SID=e.HealthSubCentre_code
where b.Village_Code is null 

insert into Estimated_Data_Village_Wise([State_Code],[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name]
,[Village_Code],[Village_Name],[Estimated_Mother],[Estimated_EC],[Estimated_Infant],[Created_Date],[Financial_Year]
,[IsActive],Village_population,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards)
select @State_Code,cast(a.Finanacial_Yr as varchar)+'-'+cast(a.Finanacial_Yr+1 as varchar),b.SUBPHC_CD,b.SUBPHC_NAME_E,0,'Direct Entry'
,a.Estimated_PW,a.Eligible_Couples,a.Estimated_Infant,GETDATE(),a.Finanacial_Yr,1,a.Village_Population 
,a.Eligible_Couples,a.Estimated_PW,a.Estimated_Infant 
from  t_villagewise_registry a 
inner join  TBL_SUBPHC b on a.HealthSubCentre_code=b.SUBPHC_CD 
left outer join Estimated_Data_Village_Wise c on a.HealthSubCentre_code=c.HealthSubFacility_Code and a.Village_code=c.Village_Code
where c.Village_Code is null 
and a.Village_code=0 and a.HealthSubCentre_code<>0


insert into Estimated_Data_SubCenter_Wise(State_Code,[Yr],HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])
select @State_Code,@Finyr,c.PHC_CD,c.PHC_NAME,a.SUBPHC_CD,a.SUBPHC_NAME_E,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_SUBPHC a
left outer join Estimated_Data_SubCenter_Wise b on a.SUBPHC_CD=b.HealthSubFacility_Code --and a.PHC_CD=b.HealthFacility_Code
inner join  TBL_PHC c on a.PHC_CD=c.PHC_CD 
where b.HealthSubFacility_Code is null 

insert into Estimated_Data_SubCenter_Wise(State_Code,[Yr],HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])
select @State_Code,cast(a.Finanacial_Yr as varchar)+'-'+cast(a.Finanacial_Yr+1 as varchar),b.PHC_CD,b.PHC_CD,0,'Direct Entry'
,a.Estimated_PW,a.Eligible_Couples,a.Estimated_Infant,GETDATE(),a.Finanacial_Yr,1,a.Village_Population ,0,0,1,a.Eligible_Couples,a.Estimated_PW
,a.Estimated_Infant,0 
from  t_villagewise_registry a 
inner join  TBL_PHC b on a.HealthFacility_code=b.PHC_CD 
left outer join Estimated_Data_SubCenter_Wise c on a.HealthSubCentre_code=c.HealthSubFacility_Code and a.HealthFacility_code=c.HealthFacility_Code
where c.HealthSubFacility_Code is null 
and a.Village_code=0 and a.HealthSubCentre_code=0
--and CONVERT(date,a.C)<>CONVERT(date,GETDATE())

insert into Estimated_Data_PHC_Wise(State_Code,[Yr],HealthBlock_Code,HealthBlock_Name,HealthFacility_Code,HealthFacility_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])
select @State_Code,@Finyr,c.BLOCK_CD,c.Block_Name_E,a.PHC_CD,a.PHC_NAME,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_PHC a
--left outer join Estimated_Data_PHC_Wise b on a.BID=b.HealthBlock_Code and a.PHC_CD=b.HealthFacility_Code
left outer join Estimated_Data_PHC_Wise b on  a.PHC_CD=b.HealthFacility_Code
inner join  TBL_HEALTH_BLOCK c on a.BID=c.BLOCK_CD 
where b.HealthFacility_Code is null 
--and CONVERT(date,a.Created_On)<>CONVERT(date,GETDATE())


insert into Estimated_Data_block_Wise(State_Code,[Yr],District_Code,District_Name,HealthBlock_Code,HealthBlock_Name
,Estimated_Mother,Estimated_EC,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Total_Profile_Entered,Total_Village,Total_Direct_Profile
,Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,[Total_ActiveVillage])

select @State_Code,@Finyr,c.DIST_CD,c.DIST_NAME_ENG,a.BLOCK_CD,a.Block_Name_E,0,0,0,GETDATE(),left(@Finyr,4),1,0,0,0,0,0,0,0,0
from TBL_HEALTH_BLOCK a
left outer join Estimated_Data_block_Wise b on a.BLOCK_CD=b.HealthBlock_Code --and a.DISTRICT_CD=b.District_Code
inner join  TBL_DISTRICT c on a.DISTRICT_CD=c.DIST_CD 
where b.HealthBlock_Code is null 


insert into [RCH_Reports].[dbo].[Estimated_Data_All_State]([State_Code],[Yr],[Estimated_Mother],[Estimated_Infant],[Financial_Year],[Estimated_EC]
,[V_Population],[Total_Profile_Entered],[Total_Mapped_Village],[Total_Direct_Profile],[Total_ActiveVillage])
Select A.State_Code,cast(A.Financial_Year as varchar)+'-'+cast(A.Financial_Year+1 as varchar),0,0,A.Financial_Year,0
,A.V_population,A.Total_Profile_Entered,A.Total_Village,A.Total_Direct_Profile,A.Total_ActiveVillage from
(select State_Code as  State_Code,Financial_Year,SUM(isnull(V_population,0)) as V_population,SUM(isnull(Total_Profile_Entered,0)) as Total_Profile_Entered  
,SUM(isnull(Total_Direct_Profile,0)) as Total_Direct_Profile 
,SUM([Total_ActiveVillage]) as Total_ActiveVillage
,SUM(isnull(Total_Village,0))  as Total_Village
from Estimated_Data_District_Wise 
group by State_Code,Financial_Year)A
left outer join RCH_Reports.dbo.Estimated_Data_All_State B on A.State_Code=B.State_Code and A.Financial_Year=B.Financial_Year
where b.State_Code is null
---------------------------------------------------Added on 21022018---------------------------------------------------------------

insert into Estimated_Data_Village_Wise([State_Code] ,[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name],[Village_Code],[Village_Name]
,[Estimated_Mother],[Estimated_EC] ,[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[Village_population],[Estimated_EC_Upwards]
,[Estimated_PW_Upwards],[Estimated_Infant_Upwards])


Select @State_Code,cast(a.Yr as varchar)+'-'+cast(a.Yr+1 as varchar),A.HealthSubFacility_Code,c.SUBPHC_NAME_E,A.Village_Code,isnull(d.Name_e,'Direct Entry')
,0,0,0,getdate(),A.Yr,1,0,0,0,0   
from
(Select HealthSubFacility_Code,Village_Code,Fin_YR as Yr from Scheduled_PHC_SubCenter_Village_Day_MH_REG a where a.Fin_YR<=left(@Finyr,4)
group by HealthSubFacility_Code,Village_Code,Fin_YR) A
left outer join Estimated_Data_Village_Wise b on a.HealthSubFacility_Code=b.HealthSubFacility_Code and A.Village_Code=B.Village_Code and A.Yr=B.Financial_Year
inner join TBL_SubPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD
left outer join Village d on a.Village_Code=d.Vcode
where b.HealthSubFacility_Code is null


insert into Estimated_Data_Village_Wise([State_Code] ,[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name],[Village_Code],[Village_Name]
,[Estimated_Mother],[Estimated_EC] ,[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[Village_population],[Estimated_EC_Upwards]
,[Estimated_PW_Upwards],[Estimated_Infant_Upwards])
Select @State_Code,cast(a.Yr as varchar)+'-'+cast(a.Yr+1 as varchar),A.HealthSubFacility_Code,c.SUBPHC_NAME_E,A.Village_Code,isnull(d.Name_e,'Direct Entry')
,0,0,0,getdate(),A.Yr,1,0,0,0,0   
from
(Select HealthSubFacility_Code,Village_Code,Fin_YR as Yr from Scheduled_PHC_SubCenter_Village_Day_CH_REG a where a.Fin_YR<=left(@Finyr,4)
group by HealthSubFacility_Code,Village_Code,Fin_YR) A
left outer join Estimated_Data_Village_Wise b on a.HealthSubFacility_Code=b.HealthSubFacility_Code and A.Village_Code=B.Village_Code and A.Yr=B.Financial_Year
inner join TBL_SubPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD
left outer join Village d on a.Village_Code=d.Vcode
where b.HealthSubFacility_Code is null

insert into Estimated_Data_Village_Wise([State_Code] ,[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name],[Village_Code],[Village_Name]
,[Estimated_Mother],[Estimated_EC] ,[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[Village_population],[Estimated_EC_Upwards]
,[Estimated_PW_Upwards],[Estimated_Infant_Upwards])
Select @State_Code,cast(a.Yr as varchar)+'-'+cast(a.Yr+1 as varchar),A.HealthSubFacility_Code,c.SUBPHC_NAME_E,A.Village_Code,isnull(d.Name_e,'Direct Entry')
,0,0,0,getdate(),A.Yr,1,0,0,0,0   
from
(Select HealthSubFacility_Code,Village_Code,Fin_YR as Yr from Scheduled_PHC_SubCenter_Village_Day_CHDOB_REG a where a.Fin_YR<=left(@Finyr,4)
group by HealthSubFacility_Code,Village_Code,Fin_YR) A
left outer join Estimated_Data_Village_Wise b on a.HealthSubFacility_Code=b.HealthSubFacility_Code and A.Village_Code=B.Village_Code and A.Yr=B.Financial_Year
inner join TBL_SubPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD
left outer join Village d on a.Village_Code=d.Vcode
where b.HealthSubFacility_Code is null


insert into Estimated_Data_Village_Wise([State_Code] ,[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name],[Village_Code],[Village_Name]
,[Estimated_Mother],[Estimated_EC] ,[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[Village_population],[Estimated_EC_Upwards]
,[Estimated_PW_Upwards],[Estimated_Infant_Upwards])
Select @State_Code,cast(a.Yr as varchar)+'-'+cast(a.Yr+1 as varchar),A.HealthSubFacility_Code,c.SUBPHC_NAME_E,A.Village_Code,isnull(d.Name_e,'Direct Entry')
,0,0,0,getdate(),A.Yr,1,0,0,0,0   
from
(Select HealthSubFacility_Code,Village_Code,Fin_YR as Yr from Scheduled_PHC_SubCenter_Village_Day_LMP_REG a where a.Fin_YR<=left(@Finyr,4)
group by HealthSubFacility_Code,Village_Code,Fin_YR) A
left outer join Estimated_Data_Village_Wise b on a.HealthSubFacility_Code=b.HealthSubFacility_Code and A.Village_Code=B.Village_Code and A.Yr=B.Financial_Year
inner join TBL_SubPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD
left outer join Village d on a.Village_Code=d.Vcode
where b.HealthSubFacility_Code is null


insert into Estimated_Data_Village_Wise([State_Code] ,[Yr],[HealthSubFacility_Code],[HealthSubFacility_Name],[Village_Code],[Village_Name]
,[Estimated_Mother],[Estimated_EC] ,[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[Village_population],[Estimated_EC_Upwards]
,[Estimated_PW_Upwards],[Estimated_Infant_Upwards])
Select @State_Code,cast(a.Yr as varchar)+'-'+cast(a.Yr+1 as varchar),A.HealthSubFacility_Code,c.SUBPHC_NAME_E,A.Village_Code,isnull(d.Name_e,'Direct Entry')
,0,0,0,getdate(),A.Yr,1,0,0,0,0   
from
(Select HealthSubFacility_Code,Village_Code,Fin_YR as Yr from Scheduled_PHC_SubCenter_Village_Day_EDD_REG a where a.Fin_YR<=left(@Finyr,4)
group by HealthSubFacility_Code,Village_Code,Fin_YR) A
left outer join Estimated_Data_Village_Wise b on a.HealthSubFacility_Code=b.HealthSubFacility_Code and A.Village_Code=B.Village_Code and A.Yr=B.Financial_Year
inner join TBL_SubPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD
left outer join Village d on a.Village_Code=d.Vcode
where b.HealthSubFacility_Code is null

---------------------------------------------------Added on 14062018 as Some Direct entry are happenning which don't have profile entries i---------------------------

insert Estimated_Data_SubCenter_Wise(State_Code,Yr,HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
,Estimated_Mother,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Estimated_EC,Total_Village,Total_Direct_Profile,
Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,Total_ActiveVillage)
select (select distinct StateID from District) as StateID,cast(X.Fin_Yr as varchar)+'-'+cast(X.Fin_Yr+1 as varchar),X.healthfacility_Code,y.PHC_NAME,X.HealthSubFacility_Code,ISNULL(z.SUBPHC_NAME_E,'Direct Entry')
,0,0,GETDATE(),x.Fin_Yr,0,0,0,0,0,0,0,0,0 

from
(
select a.healthfacility_Code,a.HealthSubFacility_Code,a.Fin_Yr
from Scheduled_AC_PW_PHC_SubCenter_Month a
left outer join Estimated_Data_SubCenter_Wise b on a.healthfacility_Code=b.HealthFacility_Code and a.HealthSubFacility_Code=b.HealthSubFacility_Code and a.Fin_Yr=b.Financial_Year
where b.HealthFacility_Code is null
group by a.healthfacility_Code,a.HealthSubFacility_Code,a.Fin_Yr
)X
inner join TBL_PHC y on X.HealthFacility_Code=y.PHC_CD
left outer join TBL_SUBPHC z on x.HealthSubFacility_Code=z.SUBPHC_CD



insert Estimated_Data_SubCenter_Wise(State_Code,Yr,HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
,Estimated_Mother,Estimated_Infant,Created_Date,Financial_Year,IsActive,V_Population,Estimated_EC,Total_Village,Total_Direct_Profile,
Estimated_EC_Upwards,Estimated_PW_Upwards,Estimated_Infant_Upwards,Total_ActiveVillage)
select (select distinct StateID from District) as StateID,cast(X.Fin_Yr as varchar)+'-'+cast(X.Fin_Yr+1 as varchar),X.healthfacility_Code,y.PHC_NAME,X.HealthSubFacility_Code,ISNULL(z.SUBPHC_NAME_E,'Direct Entry')
,0,0,GETDATE(),x.Fin_Yr,0,0,0,0,0,0,0,0,0 

from
(
select a.healthfacility_Code,a.HealthSubFacility_Code,a.Fin_Yr
from Scheduled_AC_Child_PHC_SubCenter_Month a
left outer join Estimated_Data_SubCenter_Wise b on a.healthfacility_Code=b.HealthFacility_Code and a.HealthSubFacility_Code=b.HealthSubFacility_Code and a.Fin_Yr=b.Financial_Year
where b.HealthFacility_Code is null
group by a.healthfacility_Code,a.HealthSubFacility_Code,a.Fin_Yr
)X
inner join TBL_PHC y on X.HealthFacility_Code=y.PHC_CD
left outer join TBL_SUBPHC z on x.HealthSubFacility_Code=z.SUBPHC_CD


exec Update_Estimate


End

