USE [PFMS_DB]
GO
/****** Object:  StoredProcedure [dbo].[Update_Village]    Script Date: 09/26/2024 14:22:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Update_Village]
      @Village Village READONLY
AS
BEGIN

SET NOCOUNT ON;
 
      MERGE INTO Village v1
      USING @Village v2
      ON v1.villageCode=v2.villageCode
      WHEN MATCHED THEN
      UPDATE SET 
v1.villageNameEnglish    =v2.villageNameEnglish
,v1.villageNameLocal	  =v2.villageNameLocal
,v1.subDistrictCode		  =v2.subDistrictCode
,v1.census2011Code		  =v2.census2011Code
,v1.effectiveDate		  =v2.effectiveDate
,v1.lastUpdated			  =v2.lastUpdated
,v1.majorVersion		  =v2.majorVersion
,v1.minorVersion		  =v2.minorVersion
,v1.transactionId		  =v2.transactionId
,v1.operationCode		  =v2.operationCode
,v1.transactionDescription=v2.transactionDescription
,v1.flagCode			  =v2.flagCode
,v1.villageStatus=v2.villageStatus
      WHEN NOT MATCHED THEN	
      INSERT VALUES(v2.villageCode,v2.villageNameEnglish,v2.villageNameLocal,v2.subDistrictCode,v2.census2011Code,v2.effectiveDate,v2.lastUpdated,v2.majorVersion,v2.minorVersion
					,v2.transactionId,v2.operationCode,v2.transactionDescription,v2.flagCode,v2.villageStatus);
END
