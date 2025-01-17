USE [HIU_DB]
GO
/****** Object:  StoredProcedure [dbo].[sp_HIU_ConsentRequests_Data]    Script Date: 09/26/2024 14:19:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_HIU_ConsentRequests_Data]        
@state_code int,      
@anm_id int      
AS        
BEGIN        
  Select a.patient_id,a.patient_name, a.consent_purpose, a.hi_types, a.permission_date_from, a.permission_date_to, a.data_erase_at,a.consent_request_id, a.created_on as consent_created_on     
 ,   CASE WHEN CAST(a.data_erase_at AS DATE) < CAST(GETDATE() AS DATE) THEN 'EXPIRED'
        WHEN b.status IS NULL THEN 'REQUESTED'
        ELSE CAST(b.status AS VARCHAR)
    END AS status,
 b.consent_artefacts_id,b.created_on as consent_granted_on
 FROM  HIU_ConsentRequests a 
  left join HIU_ConsentsHiuNotify b on a.consent_request_id=b.consent_request_id
  where 
  CAST(a.data_erase_at as date)>=CAST(GETDATE() as date) and a.state_code=@state_code and a.anm_id=@anm_id and a.consent_request_id is not null       
END        