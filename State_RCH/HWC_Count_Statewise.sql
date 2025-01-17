USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[HWC_Count_Statewise]    Script Date: 09/26/2024 14:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* exec HWC_Count_Statewise 0,'','01-03-2019','21-03-2019' */
ALTER  PROC [dbo].[HWC_Count_Statewise] /****Created by Aditya 19-03-2019 For HWC webservice Count ****/
(
 @State_Code int=0,
 @District_Code varchar(4)='',
 @FromDate varchar(10),
 @ToDate varchar(10)
)
As
Declare @Query varchar(8000)
Declare @Groupby varchar(8000)
Begin
   SET NOCOUNT ON;
	set @Query='select STbl.Created_Date as ExecutionDate,D.DCode as DistrictCode, D.Name_E AS DistrictName,P.PID AS HealthFacilityCode,P.Name_E AS HealthFacility,S.SID AS HealthSubFacilityCode,S.Name_E  AS HealthSubFacility,
		(Case when (STbl.SubCentre_ID=0 or STbl.SubCentre_ID IS NULL) then p.NIN_Number else s.NIN_Number END) AS NINNUMBER,
		SUM(STbl.Mother_Total_Count) AS TotalMotherReg,
		SUM(STbl.Child_Total_Count)AS TotalChildReg,
		SUM(STbl.EC_Total_Count)AS TotalECReg,
		SUM(isnull(STbl.MA_Count,0)+isnull(STbl.MD_Count,0)+isnull(STbl.MPNC_Count,0)) as TotalMotherService ,
		SUM(isnull(STbl.CHT_Count,0)+isnull(STbl.CPNC_Count,0)+isnull(STbl.CTM_Count,0))as TotalChildService,
		SUM(STbl.ECT_Count)AS TotalECService
		from Scheduled_DB_PHC_SC_Village_Count as STbl
		left outer join  Health_PHC AS P WITH (NOLOCK) ON STbl.PHC_ID =P.PID
		left outer join  Health_SubCentre AS S WITH (NOLOCK) ON STbl.SubCentre_ID=S.SID
		left outer join  District AS D  WITH (NOLOCK) ON D.DCode=P.DCode
		WHERE (CASE WHEN STbl.SubCentre_ID=0 THEN P.HWC else S.HWC END)= ''Y''
		and stbl.Created_Date between convert(date,'''+@FromDate+''',103) and convert(date,'''+@ToDate+''',103)'

	set @Groupby='group by D.Name_E,P.Name_E ,S.Name_E,p.NIN_Number,s.NIN_Number,STbl.SubCentre_ID,STbl.Created_Date,D.DCode,P.PID,S.SID --order by stbl.Created_Date,s.NIN_Number,p.NIN_Number'
	
	if(@District_Code ='') --**********For all District Data
	    Begin
			 set @Query=@Query+@Groupby
			 exec(@Query)
			 
	    End
	else --***For DistrictWise Data
	   Begin
		   set @Query =@Query+' and D.DCode='''+@District_Code+''''+ @Groupby
		   exec(@Query)
	   End
End

