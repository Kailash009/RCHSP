USE [HIU_DB]
GO
/****** Object:  StoredProcedure [dbo].[sp_HIU_ConsentRequests_IU]    Script Date: 09/26/2024 14:20:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_HIU_ConsentRequests_IU]
@anm_id int=0,
@anm_name varchar(100)=null,
@state_code int=0,
@requestId VARCHAR(50)=null,
@timestamp VARCHAR(50)=null,
@consentRequest_id  varchar(50)=null,
@error varchar(MAX)=null,
@resp_requestId  varchar(50)=null
AS
BEGIN
if not exists(select 1 from HIU_ConsentRequests where resp_requestId =@resp_requestId)
begin
  INSERT INTO HIU_ConsentRequests
  (anm_id,anm_name,state_code, resp_requestId, Created_On)
  VALUES
  (@anm_id,@anm_name,@state_code, @resp_requestId, GETDATE())
END
else
begin
   update HIU_ConsentRequests set 
   requestId=@requestId,
   timestamp=@timestamp,
   error=@error
   where  resp_requestId =@resp_requestId
end
end