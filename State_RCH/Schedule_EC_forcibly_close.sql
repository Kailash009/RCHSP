USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_EC_forcibly_close]    Script Date: 09/26/2024 14:43:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[Schedule_EC_forcibly_close]
as
begin
update e set  forcibly_close_dt=DATEADD(d,365,visitdate), forcibly_close=1   
from t_eligible_couple_tracking ect inner join t_eligibleCouples e on ect.Registration_no=e.Registration_no and ect.Case_no=e.Case_no
left join t_mother_registration r on ect.Registration_no=r.Registration_no and ect.Case_no=r.Case_no
left join t_mother_medical m on ect.Registration_no=m.Registration_no and m.Case_no=ect.Case_no
where ((ect.Pregnant='Y' and ect.Pregnant_test='P') or (ect.Pregnant='Y' and ect.Pregnant_test='D') or (ect.Pregnant='D' and ect.Pregnant_test='P'))
--and ISNULL(e.Delete_Mother,0)=0  and ISNULL(r.Delete_Mother,0)=0 and ISNULL(Entry_Type,0)<>1 -- because we can undeath or undelete the beneficiary
and LMP_Date is null and DATEADD(d,365,visitdate)<GETDATE() and isnull(forcibly_close,0)=0
end