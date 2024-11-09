USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_ReportDate_inup]    Script Date: 09/26/2024 14:46:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[Schedule_ReportDate_inup]
as
begin


truncate table t_Schedule_Date
insert into t_Schedule_Date([Registration_No],[Case_No],[EC_Registration_date],[Mother_Registration_date],[Mother_LMP_date],[Mother_EDD_date],Mother_Del_Date,State_Code,PHC_Code,SubCentre_Code,Village_Code)
Select [Registration_No],[Case_No],EC_Registration_date,[Mother_Registration_date],[LMP_date],[EDD_date],[Delivery_Date],StateID,PHC_ID,SubCentre_ID,Village_ID
from t_mother_flat_count where CONVERT(date, Exec_Date)=CONVERT(date, GETDATE()) 

truncate table [t_Schedule_Date_Child]
insert into [t_Schedule_Date_Child]([Registration_No],[Registration_date],[Birthdate_date],State_Code,PHC_Code,SubCentre_Code,Village_Code)
Select [Registration_No],Child_Registration_Date,Child_BirthDate_date,StateID,PHC_ID,SubCentre_ID,Village_ID
from t_child_flat_count where CONVERT(date, Exec_Date)=CONVERT(date, GETDATE()) 


truncate table [t_Schedule_Date_EC]
insert into [t_Schedule_Date_EC]([Registration_No],[case_no],[Registration_date],State_Code,PHC_Code,SubCentre_Code,Village_Code)
Select [Registration_No],Case_no,EC_Registration_Date,StateID,PHC_ID,SubCentre_ID,Village_ID
from t_EC_flat_count where CONVERT(date, Exec_Date)=CONVERT(date, GETDATE()) 





if exists (select * from UserMaster_Webservices where status=1)
begin

exec Schedule_ANMOL_ERROR_InUp
end

end








