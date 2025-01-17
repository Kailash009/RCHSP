USE [PFMS_DB]
GO
/****** Object:  StoredProcedure [dbo].[Update_Block]    Script Date: 09/26/2024 14:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Update_Block]
      @Block Block READONLY
AS
BEGIN

SET NOCOUNT ON;
 
      MERGE INTO Block B1
      USING @Block B2
      ON B1.blockCode=B2.blockCode
      WHEN MATCHED THEN
      UPDATE SET 
 B1.blockNameEnglish		 =B2.blockNameEnglish
,B1.blockNameLocal		 =B2.blockNameLocal
,B1.effectiveDate			     =B2.effectiveDate
,B1.lastUpdated		             =B2.lastUpdated
,B1.majorVersion		         =B2.majorVersion
,B1.minorVersion		         =B2.minorVersion
,B1.transactionId		         =B2.transactionId
,B1.operationCode		         =B2.operationCode
,B1.transactionDescription       =B2.transactionDescription
,B1.flagCode			         =B2.flagCode
,B1.totalPages			         =B2.totalPages
,B1.districts			         =B2.districts
,B1.coverage			         =B2.coverage

      WHEN NOT MATCHED THEN	
      INSERT VALUES(B2.blockCode,B2.blockNameEnglish,B2.blockNameLocal,B2.effectiveDate,B2.lastUpdated,B2.majorVersion
					,B2.minorVersion,B2.transactionId,B2.operationCode,B2.transactionDescription,B2.flagCode,B2.totalPages,B2.districts,B2.coverage);
END
