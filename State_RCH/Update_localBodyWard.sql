USE [PFMS_DB]
GO
/****** Object:  StoredProcedure [dbo].[Update_localBodyWard]    Script Date: 09/26/2024 14:21:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Update_localBodyWard]
      @localBodyWard localBodyWard READONLY
AS
BEGIN

SET NOCOUNT ON;
 
      MERGE INTO localBodyWard lbw1
      USING @localBodyWard lbw2
      ON lbw1.wardCode=lbw2.wardCode
      WHEN MATCHED THEN
      UPDATE SET 
 lbw1.wardNameEnglish     =lbw2.wardNameEnglish
,lbw1.wardNameLocal	  =		lbw2.wardNameLocal
,lbw1.localBodyCode		  =lbw2.localBodyCode
,lbw1.localBodyNameEnglish	 =lbw2.localBodyNameEnglish
,lbw1.effectiveDate			=lbw2.effectiveDate
,lbw1.lastUpdated		  =lbw2.lastUpdated
,lbw1.majorVersion		  =lbw2.majorVersion
,lbw1.minorVersion		  =lbw2.minorVersion
,lbw1.transactionId		  =lbw2.transactionId
,lbw1.operationCode		  =lbw2.operationCode
,lbw1.transactionDescription=lbw2.transactionDescription
,lbw1.flagCode			  =lbw2.flagCode

      WHEN NOT MATCHED THEN	
      INSERT VALUES(lbw2.wardCode,lbw2.wardNameEnglish,lbw2.wardNameLocal,lbw2.localBodyCode,lbw2.localBodyNameEnglish,lbw2.effectiveDate,lbw2.lastUpdated,lbw2.majorVersion,lbw2.minorVersion
					,lbw2.transactionId,lbw2.operationCode,lbw2.transactionDescription,lbw2.flagCode);
END
