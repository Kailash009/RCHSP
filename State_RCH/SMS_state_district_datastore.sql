USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[SMS_state_district_datastore]    Script Date: 09/26/2024 15:59:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
exec SMS_state_district_datastore 29
select * from SMS..daily_SMS_status_district
*/
ALTER proc [dbo].[SMS_state_district_datastore](@State_code as int)
AS 
BEGIN
DECLARE @Current_Year as int=0,@Previous_Year as int=0

set @Current_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1) else YEAR(getdate()-1)-1 end)
set @Previous_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1)-1 else YEAR(getdate()-1)-2 end)

delete from SMS..daily_SMS_status_district where State_code=@State_code and Date_of_delivery=cast(getdate() as date)

insert into SMS..daily_SMS_status_district(State_code,District_Code,District_Name,Date_of_delivery,ANM_Count,ASHA_Count,EC_Count,EC_Count_Current_Finyr,EC_Count_Prev_Finy,Mother_Count,Mother_Count_Current_Finyr,Mother_Count_Prev_Finyr,Child_Count,Child_Count_Current_Finyr,Child_Count_Prev_Finyr,EC_Total_Added_Finyr,Mother_Total_Added_Finyr,Child_Total_Added_Finyr,EC_Total_Updated_Finyr,Mother_Total_Updated_Finyr,Child_Total_Updated_Finyr)
select @State_code,P.District_Code,District_Name,getdate() Date_of_delivery,ANM_Count,ASHA_Count,EC_Count,EC_Count_Current_Finyr,EC_Count_Prev_Finy,Mother_Count,Mother_Count_Current_Finyr,Mother_Count_Prev_Finyr
,Child_Count,Child_Count_Current_Finyr,Child_Count_Prev_Finyr,EC_Total_Added_Finyr,Mother_Total_Added_Finyr,Child_Total_Added_Finyr,EC_Total_Updated_Finyr,Mother_Total_Updated_Finyr,Child_Total_Updated_Finyr from 
(select DCode District_Code,Name_E District_Name from district where StateID=@State_code) P left join 
(select District_Code,Sum(Total_ANM)+SUM(Total_ANM2)+SUM(Total_LinkWorker)+SUM(Total_MPW)+SUM(Total_GNM)+SUM(Total_CHV) as ANM_Count,SUM(Total_ASHA)as ASHA_Count 
from Scheduled_AC_GF_State_District group by District_Code) A on P.District_Code=A.District_Code
left join 
(select District_Code,Sum(total_distinct_ec)as EC_Count from Scheduled_AC_EC_State_District_Month where Filter_Type=1 group by District_Code) 
B on P.District_Code=B.District_Code left join 
(select District_Code,Sum(total_distinct_ec) as EC_Count_Current_Finyr from Scheduled_AC_EC_State_District_Month where Fin_Yr=@Current_Year and 
Filter_Type=1 group by District_Code) C on P.District_Code=C.District_Code
left join
(select District_Code,Sum(total_distinct_ec)as EC_Count_Prev_Finy from Scheduled_AC_EC_State_District_Month where Fin_Yr=@Previous_Year and
Filter_Type=1 group by District_Code) D on P.District_Code=D.District_Code
left join 
(select District_Code,SUM(PW_Registered)as Mother_Count from Scheduled_AC_PW_State_District_Month where Filter_Type=1  group by District_Code)
E on P.District_Code=E.District_Code left join 
(select District_Code,SUM(PW_Registered)as Mother_Count_Current_Finyr from Scheduled_AC_PW_State_District_Month where Fin_Yr=@Current_Year and 
Filter_Type=1 group by District_Code) F on P.District_Code=F.District_Code left join
(select District_Code,SUM(PW_Registered)as Mother_Count_Prev_Finyr from Scheduled_AC_PW_State_District_Month where Fin_Yr=@Previous_Year and 
Filter_Type=1 group by District_Code) G on P.District_Code=G.District_Code left join 
(select District_Code,SUM(Child_P)+SUM(Child_T)as Child_Count from Scheduled_AC_Child_State_District_Month where Filter_Type=1 group by District_Code) 
H on P.District_Code=H.District_Code left join 
(select District_Code,SUM(Child_P)+SUM(Child_T)as Child_Count_Current_Finyr from Scheduled_AC_Child_State_District_Month where Fin_Yr=@Current_Year and
Filter_Type=1 group by District_Code) I on P.District_Code=I.District_Code left join 
(select District_Code,SUM(Child_P)+SUM(Child_T)as Child_Count_Prev_Finyr from Scheduled_AC_Child_State_District_Month where Fin_Yr=@Previous_Year and 
Filter_Type=1 group by District_Code) J on P.District_Code=J.District_Code left join 
(Select District_ID,isnull(SUM(EC_Total_Count),0) as EC_Total_Added_Finyr,isnull(SUM(Mother_Total_Count),0) as Mother_Total_Added_Finyr
,isnull(SUM(Child_Total_Count),0) as Child_Total_Added_Finyr,isnull(SUM(EC_Total_Count_Updated),0) as EC_Total_Updated_Finyr
,isnull(SUM(Mother_Total_Count_Updated),0) as Mother_Total_Updated_Finyr,isnull(SUM(Child_Total_Count_Updated),0) as Child_Total_Updated_Finyr 
from Scheduled_DB_State_District_Count where Created_Date=Convert(date,GETDATE()-1) group by District_ID) K on P.District_Code=K.District_ID

end

