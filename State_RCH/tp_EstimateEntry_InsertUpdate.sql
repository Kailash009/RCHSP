USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_EstimateEntry_InsertUpdate]    Script Date: 09/26/2024 15:53:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*
[tp_EstimateEntry_InsertUpdate] 2,0,0,0,0,0,2015,'2015-2016',6,'','',0,0,0,0,0
*/
ALTER procedure [dbo].[tp_EstimateEntry_InsertUpdate]
(
@State_Code int=0,  
@District_Code int=0,  
@HealthBlock_Code int=0,  
@HealthFacility_Code int=0,  
@HealthSubFacility_Code int=0,
@Village_Code int=0,
@FinancialYr int=0,
@Financial_Year varchar(10)='',
@EstimatesEntry_ID int=0,
@Parent_Name varchar(99)='',
@Child_Name varchar(99)='',
@Estimated_Mother int=0,
@Estimated_Infant int=0,
@Estimated_EC int=0,
@Estimated_Population int=0,
@USERID as int=0,
@IPAddress as varchar(30)='',
@msg int=0 out
)
as
begin
if(@EstimatesEntry_ID=1)--Statewise
begin

	if exists (select * from [RCH_National_Level].[dbo].[Estimated_Data_All_State] where [Financial_Year]=@FinancialYr and State_Code=@State_Code)
	begin

		update [RCH_National_Level].[dbo].[Estimated_Data_All_State] set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		 ,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population,Updated_On=getdate()  
		where [Financial_Year]=@FinancialYr and State_Code=@State_Code

		set @msg=0
	end
	else
	begin

		insert into [RCH_National_Level].[dbo].[Estimated_Data_All_State]([State_Code],[Yr],[Estimated_Mother],[Estimated_Infant],[Financial_Year],Estimated_EC,V_Population,Created_On)
		values( @State_Code,@Financial_Year,@Estimated_Mother,@Estimated_Infant,@FinancialYr,@Estimated_EC,@Estimated_Population,getdate())
		set @msg=1

	end

end
else if(@EstimatesEntry_ID=2)--Districtwise
begin

	if exists (select * from [RCH_National_Level].[dbo].[Estimated_Data_District_Wise] where [Financial_Year]=@FinancialYr and State_Code=@State_Code and District_Code=@District_Code)
	begin

		update [RCH_National_Level].[dbo].[Estimated_Data_District_Wise] set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		 ,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population  
		where [Financial_Year]=@FinancialYr and State_Code=@State_Code and District_Code=@District_Code

		set @msg=0
	end
	else
	begin

		insert into [RCH_National_Level].[dbo].[Estimated_Data_District_Wise]([State_Code],[Yr],[District_Code],[District_Name],[Estimated_Mother],[Estimated_Infant],[Created_Date],[Financial_Year],Estimated_EC,V_Population)
		values( @State_Code,@Financial_Year,@District_Code,@Child_Name,@Estimated_Mother,@Estimated_Infant,GETDATE(),@FinancialYr,@Estimated_EC,@Estimated_Population)
		set @msg=1

	end
	
	if exists (select * from Estimated_Data_District_Wise where Financial_Year=@FinancialYr and District_Code=@District_Code)
	begin

		update Estimated_Data_District_Wise set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population  
		where Financial_Year=@FinancialYr and District_Code=@District_Code

		set @msg=0
	end
	else
	begin

		insert into Estimated_Data_District_Wise([State_Code],[Yr],[District_Code],[District_Name],[Estimated_Mother],[Estimated_Infant]
		,[Created_Date],[Financial_Year],[IsActive],[V_Population],[Estimated_EC])
		values( @State_Code,@Financial_Year,@District_Code,@Child_Name,@Estimated_Mother,@Estimated_Infant,GETDATE(),@FinancialYr
		,1,@Estimated_Population,@Estimated_EC)
		set @msg=1

	end

end

else if(@EstimatesEntry_ID=3)--Blockwise
begin

	if exists (select * from [Estimated_Data_Block_Wise] where Financial_Year=@FinancialYr and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code)
	begin

		update [Estimated_Data_Block_Wise] set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population  
		where Financial_Year=@FinancialYr and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code

		set @msg=0
	end
	else
	begin

		insert into [Estimated_Data_Block_Wise]([State_Code],[Yr],[District_Code],[District_Name],[HealthBlock_Code],[HealthBlock_Name]
		,[Estimated_Mother],[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[V_Population],[Estimated_EC])
		values( @State_Code,@Financial_Year,@District_Code,@Parent_Name,@HealthBlock_Code,@Child_Name
		,@Estimated_Mother,@Estimated_Infant,GETDATE(),@FinancialYr,1,@Estimated_Population,@Estimated_EC)
		set @msg=1

	end

end
else if(@EstimatesEntry_ID=4)--PHCwise
begin

	if exists (select * from [Estimated_Data_PHC_Wise] where Financial_Year=@FinancialYr and HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code)
	begin

		update [Estimated_Data_PHC_Wise] set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population  
		where Financial_Year=@FinancialYr and HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code

		set @msg=0
	end
	else
	begin

		insert into [Estimated_Data_PHC_Wise]([State_Code],[Yr],[HealthBlock_Code],[HealthBlock_Name],[HealthFacility_Code]
      ,[HealthFacility_Name],[Estimated_Mother],[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[V_Population],[Estimated_EC])
		values( @State_Code,@Financial_Year,@HealthBlock_Code,@Parent_Name,@HealthFacility_Code,@Child_Name
		,@Estimated_Mother,@Estimated_Infant,GETDATE(),@FinancialYr,1,@Estimated_Population,@Estimated_EC)
		set @msg=1

	end

end
else if(@EstimatesEntry_ID=5)--SCwise
begin

	if exists (select * from Estimated_Data_SubCenter_Wise where Financial_Year=@FinancialYr and  HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code)
	begin

		update Estimated_Data_SubCenter_Wise set Estimated_Mother=@Estimated_Mother,Estimated_Infant=@Estimated_Infant
		,Estimated_EC=@Estimated_EC,V_Population=@Estimated_Population  
		where Financial_Year=@FinancialYr and  HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code

		set @msg=0
	end
	else
	begin

		insert into Estimated_Data_SubCenter_Wise([State_Code],[Yr],[HealthFacility_Code],[HealthFacility_Name],
		[HealthSubFacility_Code],[HealthSubFacility_Name],[Estimated_Mother],[Estimated_Infant],[Created_Date],[Financial_Year],[IsActive],[V_Population],[Estimated_EC])
		values( @State_Code,@Financial_Year,@HealthFacility_Code,@Parent_Name,@HealthSubFacility_Code,@Child_Name
		,@Estimated_Mother,@Estimated_Infant,GETDATE(),@FinancialYr,1,@Estimated_Population,@Estimated_EC)
		set @msg=1

	end

end


else if(@EstimatesEntry_ID=6)--All estimate update
begin
truncate table Estimated_Data_Block_Wise
truncate table Estimated_Data_PHC_Wise
truncate table Estimated_Data_SubCenter_Wise
truncate table Estimated_Data_Village_Wise
Declare @Finyr int,@Financiar_year as varchar(10),@EndYr as int
set @EndYr=(case when MONTH(GETDATE()-1)>3 then YEAR(GETDATE()-1) else YEAR(GETDATE()-1)-1 end)
set @FinYr=2010
while(@Finyr<=@EndYr)
begin
	update Estimated_Data_District_Wise set Estimated_EC= Estimated_Mother where Estimated_EC=0
	set @Financiar_year=CAST (@Finyr as varchar)+'-'+cast(@Finyr+1 as varchar)
	insert into Estimated_Data_Block_Wise(State_Code,Yr,District_Code,District_Name,HealthBlock_Code,HealthBlock_Name,Estimated_mother,Estimated_Infant,Created_Date
	,Financial_Year,IsActive,V_Population,Estimated_EC,Total_Village,Total_Profile_Entered)
	select b.StateID,@Financiar_year,a.DCode,b.Name_E,a.BID,a.Name_E,0,0,GETDATE()
	,@Finyr ,1,0,0,0,0
	from Health_Block a
	inner join District b on a.DCode=b.DCode
	
	insert into Estimated_Data_PHC_Wise(State_Code,Yr,HealthBlock_Code,HealthBlock_Name,HealthFacility_Code,HealthFacility_Name,Estimated_mother,Estimated_Infant,Created_Date
	,Financial_Year,IsActive,V_Population,Estimated_EC,Total_Village,Total_Profile_Entered)
	select @State_Code,@Financiar_year,a.BID,b.Name_E,a.PID,a.Name_E,0,0,GETDATE()
	,@Finyr ,1,0,0,0,0
	from Health_PHC a
	inner join Health_Block b on a.BID=b.BID
	
	insert into Estimated_Data_SubCenter_Wise(State_Code,Yr,HealthFacility_Code,HealthFacility_Name,HealthSubFacility_Code,HealthSubFacility_Name
	,Estimated_mother,Estimated_Infant,Created_Date
	,Financial_Year,IsActive,V_Population,Estimated_EC,Total_Village,Total_Profile_Entered)
	select @State_Code,@Financiar_year,b.PID,b.Name_E,a.SID,a.Name_E,0,0,GETDATE()
	,@Finyr ,1,0,0,0,0
	from Health_SubCentre a
	inner join Health_PHC b on a.PID=b.PID
	
	insert into Estimated_Data_Village_Wise(State_Code,Yr,HealthSubFacility_Code,HealthSubFacility_Name,Village_Code,Village_Name
	,Estimated_mother,Estimated_Infant,Created_Date
	,Financial_Year,IsActive,Village_population,Estimated_EC)
	select @State_Code,@Financiar_year,a.SID,b.Name_E,a.VCode,c.VILLAGE_NAME,0,0,GETDATE()
	,@Finyr ,2,0,0
	from Health_SC_Village a
	inner join Health_SubCentre b on a.SID=b.SID
	inner join TBL_VILLAGE c on a.VCode=c.VILLAGE_CD and c.SUBPHC_CD=a.SID 
	
	
	update [Estimated_Data_Village_Wise] set [Estimated_Mother]=a.Estimated_PW,Estimated_EC=a.Eligible_Couples,Estimated_Infant=a.Estimated_Infant
	,Village_population=a.Village_Population from t_villagewise_registry a
	where [Estimated_Data_Village_Wise].[HealthSubFacility_Code]=a.HealthSubCentre_code and [Estimated_Data_Village_Wise].Village_Code=a.Village_code
	and [Estimated_Data_Village_Wise].Yr=@Financiar_year
	
	
	set @Finyr=@Finyr+1
end



--update [Estimated_Data_Village_Wise] set [Estimated_Mother]=a.Estimated_PW,Estimated_EC=a.Eligible_Couples,Estimated_Infant=a.Estimated_Infant
--,Village_population=a.Village_Population from t_villagewise_registry a
--where [Estimated_Data_Village_Wise].[HealthSubFacility_Code]=a.HealthSubCentre_code and [Estimated_Data_Village_Wise].Village_Code=a.Village_code
--and [Estimated_Data_Village_Wise].Yr='2016-2017'

update Estimated_Data_Block_Wise set Estimated_EC=X.Estimated_EC
,Estimated_Mother=X.Estimated_Mother
,Estimated_Infant=X.Estimated_Infant from 
(

select A.ID,A.Estimated_EC/B.dividecount as Estimated_EC,A.Estimated_Infant/B.dividecount as Estimated_Infant,A.Estimated_Mother/B.dividecount as Estimated_Mother,A.Financial_Year from
(select District_Code as ID,Estimated_EC,Estimated_Infant,Estimated_Mother,Financial_Year 
from Estimated_Data_District_Wise)A
left outer join 
(
select count(BID) as dividecount,Dcode as ID from Health_Block where IsActive=1

group by Dcode) B on A.ID=B.ID
) X
where Estimated_Data_Block_Wise.District_Code=X.ID and Estimated_Data_Block_Wise.Financial_Year=X.Financial_Year



update Estimated_Data_PHC_Wise set Estimated_EC=X.Estimated_EC
,Estimated_Mother=X.Estimated_Mother
,Estimated_Infant=X.Estimated_Infant from 
(

select A.ID,A.Estimated_EC/B.dividecount as Estimated_EC,A.Estimated_Infant/B.dividecount as Estimated_Infant,A.Estimated_Mother/B.dividecount as Estimated_Mother,A.Financial_Year from
(select HealthBlock_Code as ID,Estimated_EC,Estimated_Infant,Estimated_Mother,Financial_Year 
from Estimated_Data_Block_Wise)A
left outer join 
(
select count(PID) as dividecount,BID as ID from Health_PHC where IsActive=1

group by BID) B on A.ID=B.ID
) X
where Estimated_Data_PHC_Wise.HealthBlock_Code=X.ID and Estimated_Data_PHC_Wise.Financial_Year=X.Financial_Year


update Estimated_Data_SubCenter_Wise set Estimated_EC=X.Estimated_EC
,Estimated_Mother=X.Estimated_Mother
,Estimated_Infant=X.Estimated_Infant from 
(

select A.ID,A.Estimated_EC/B.dividecount as Estimated_EC,A.Estimated_Infant/B.dividecount as Estimated_Infant,A.Estimated_Mother/B.dividecount as Estimated_Mother,A.Financial_Year from
(select HealthFacility_Code as ID,Estimated_EC,Estimated_Infant,Estimated_Mother,Financial_Year 
from Estimated_Data_PHC_Wise)A
left outer join 
(
select count(SID) as dividecount,PID as ID from Health_SubCentre where IsActive=1

group by PID) B on A.ID=B.ID
) X
where Estimated_Data_SubCenter_Wise.HealthFacility_Code=X.ID and Estimated_Data_SubCenter_Wise.Financial_Year=X.Financial_Year


end

end

