USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[Maintain_PDS_Reverse_Log]    Script Date: 09/26/2024 14:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





ALTER Procedure [dbo].[Maintain_PDS_Reverse_Log]
(
@Request_ID nvarchar(20)=null,
@Response_ID nvarchar(20)=null,
@RES_ID nvarchar(15)=null,
@RES_NAME_ENG nvarchar(30)=null,
@hashHMACHex nvarchar(max)=null,
@JSON_String nvarchar(max)=null,
@Encripted_Data nvarchar(max)=null,
@WS_Call_Start_Datetime datetime=null,
@WS_Call_End_Datetime datetime=null,
@WS_Response_time_ms nvarchar(10)=null,
@msg nvarchar(max)=null,
@StatusCode int=0
)
as        
BEGIN 
insert into  l_PDS_ReverseData_Log
(	
Request_ID,
Response_ID,
RES_ID,
RES_NAME_ENG,
hashHMACHex,
JSON_String,
Encripted_Data,
WS_Call_Start_Datetime,
WS_Call_End_Datetim,
WS_Response_time_ms,
msg,
StatusCode
) 
values
(
@Request_ID ,
@Response_ID,
@RES_ID,
@RES_NAME_ENG,
@hashHMACHex,
@JSON_String,
@Encripted_Data,
@WS_Call_Start_Datetime,
@WS_Call_End_Datetime,
@WS_Response_time_ms,
@msg,
@StatusCode
);
END




