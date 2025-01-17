USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_KPIDashboard]    Script Date: 09/26/2024 14:04:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC Schedule_KPIDashboard

ALTER procedure [dbo].[Schedule_KPIDashboard]
as
begin
Declare @s as varchar(8000),@regno varchar(max)
SELECT @regno=coalesce(@regno+ ',','')+cast(d.registration_no as varchar(12)) from
(
select a.registration_no FROM t_mother_pnc a left join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  where 
(cast(a.Created_On as date) =  cast(getdate() as date) Or cast(a.Updated_On as date)= cast(getdate() as date)) and (b.Is_Consent_given=1 and b.HealthIdNumber is not null)
union
select a.registration_no FROM t_mother_delivery  a left join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  where 
(cast(a.Created_On as date) =  cast(getdate() as date) Or cast(a.Updated_On as date)= cast(getdate() as date)) and (b.Is_Consent_given=1 and b.HealthIdNumber is not null)
union
select a.registration_no FROM t_mother_anc a left join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  where 
(cast(a.Created_On as date) =  cast(getdate() as date) Or cast(a.Updated_On as date)= cast(getdate() as date)) and (b.Is_Consent_given=1 and b.HealthIdNumber is not null)
union
select a.registration_no FROM t_mother_registration a left join t_mother_registration b on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no  where 
(cast(a.Created_On as date) =  cast(getdate() as date) Or cast(a.Updated_On as date)= cast(getdate() as date)) and (b.Is_Consent_given=1 and b.HealthIdNumber is not null)
) d

 set @s =' exec tp_Get_Patient_Data_FHIR ' + (@regno) +''     
 exec(@S) 
end
