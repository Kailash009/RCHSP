USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Etaal_Mother_Child_Count_DistrictWise]    Script Date: 09/26/2024 15:26:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Etaal_Mother_Child_Count_DistrictWise '04-05-2023'

ALTER Procedure [dbo].[Etaal_Mother_Child_Count_DistrictWise]
(
 @date varchar(10)
)
as 
DECLARE @Query varchar(8000) 
BEGIN
SET NOCOUNT ON;
        set @Query='SELECT (Mother_Total_Count) AS ''D020114501437'' ,(Child_Total_Count) as ''D020114501438'',  
                right(''0''+CAST(t1.StateID As varchar(2)),2)+right(''00''+cast(ISNULL(T2.MDDS_Code, ''000'') as varchar(3)),3)+''000'' as LocationCode 
                from  [dbo].Scheduled_DB_State_District_Count t1 inner join [dbo].[District] t2 on t1.District_ID=t2.DCode
                where t1.Created_Date =convert(date,'''+@date+''',103)' 
        Exec(@Query)
END


