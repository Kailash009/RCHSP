USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[SMS_state_district_block_datastore]    Script Date: 09/26/2024 15:59:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec SMS_state_district_block_datastore 29
select * from SMS..daily_SMS_status_district_block
*/
ALTER proc [dbo].[SMS_state_district_block_datastore](@State_code as int)
AS 
BEGIN
DECLARE @Current_Year as int=0,@Previous_Year as int=0

set @Current_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1) else YEAR(getdate()-1)-1 end)
set @Previous_Year=(case when MONTH (getdate()-1)>3 then YEAR(getdate()-1)-1 else YEAR(getdate()-1)-2 end)

delete from SMS..daily_SMS_status_district_block where State_code=@State_code and Date_of_delivery=cast(getdate() as date)

insert into SMS..daily_SMS_status_district_block(State_code,District_code,District_Name,HealthBlock_Code,HealthBlock_Name,Date_of_delivery,ANM_Count,ASHA_Count,EC_Count,EC_Count_Current_Finyr,EC_Count_Prev_Finy,Mother_Count,Mother_Count_Current_Finyr,Mother_Count_Prev_Finyr,Child_Count,Child_Count_Current_Finyr,Child_Count_Prev_Finyr,EC_Total_Added_Finyr,Mother_Total_Added_Finyr,Child_Total_Added_Finyr,EC_Total_Updated_Finyr,Mother_Total_Updated_Finyr,Child_Total_Updated_Finyr)
select @State_code,P.District_code,District_Name,P.HealthBlock_Code,HealthBlock_Name,getdate() Date_of_delivery,ANM_Count,ASHA_Count,EC_Count,EC_Count_Current_Finyr,EC_Count_Prev_Finy,Mother_Count,Mother_Count_Current_Finyr,Mother_Count_Prev_Finyr
,Child_Count,Child_Count_Current_Finyr,Child_Count_Prev_Finyr,EC_Total_Added_Finyr,Mother_Total_Added_Finyr,Child_Total_Added_Finyr,EC_Total_Updated_Finyr,Mother_Total_Updated_Finyr,Child_Total_Updated_Finyr from 

(select BID HealthBlock_Code,HB.Name_E HealthBlock_Name,DIS.Dcode District_code,DIS.Name_E District_Name from Health_Block HB 
inner join District DIS on HB.DCode=DIS.DCode where StateID=@State_code) P 
--inner join 
--(select DCode District_code,Name_E District_Name from District where StateID=@State_code) Q on p.District_code =q.District_code
left join 
(select HealthBlock_ID,Sum(Total_ANM)+SUM(Total_ANM2)+SUM(Total_LinkWorker)+SUM(Total_MPW)+SUM(Total_GNM)+SUM(Total_CHV) as ANM_Count,SUM(Total_ASHA)as ASHA_Count 
from Scheduled_AC_GF_District_Block group by HealthBlock_ID) A on p.HealthBlock_Code=a.HealthBlock_ID
left join 
(select HealthBlock_Code,Sum(total_distinct_ec)as EC_Count from Scheduled_AC_EC_District_Block_Month where Filter_Type=1 group by HealthBlock_Code) 
B on P.HealthBlock_Code=B.HealthBlock_Code left join 
(select HealthBlock_Code,Sum(total_distinct_ec) as EC_Count_Current_Finyr from Scheduled_AC_EC_District_Block_Month where Fin_Yr=@Current_Year and 
Filter_Type=1 group by HealthBlock_Code) C on P.HealthBlock_Code=C.HealthBlock_Code
left join
(select HealthBlock_Code,Sum(total_distinct_ec)as EC_Count_Prev_Finy from Scheduled_AC_EC_District_Block_Month where Fin_Yr=@Previous_Year and
Filter_Type=1 group by HealthBlock_Code) D on P.HealthBlock_Code=D.HealthBlock_Code
left join 
(select HealthBlock_Code,SUM(PW_Registered)as Mother_Count from Scheduled_AC_PW_District_Block_Month where Filter_Type=1  group by HealthBlock_Code)
E on P.HealthBlock_Code=E.HealthBlock_Code left join 
(select HealthBlock_Code,SUM(PW_Registered)as Mother_Count_Current_Finyr from Scheduled_AC_PW_District_Block_Month where Fin_Yr=@Current_Year and 
Filter_Type=1 group by HealthBlock_Code) F on P.HealthBlock_Code=F.HealthBlock_Code left join
(select HealthBlock_Code,SUM(PW_Registered)as Mother_Count_Prev_Finyr from Scheduled_AC_PW_District_Block_Month where Fin_Yr=@Previous_Year and 
Filter_Type=1 group by HealthBlock_Code) G on P.HealthBlock_Code=G.HealthBlock_Code left join 
(select HealthBlock_Code,SUM(Child_P)+SUM(Child_T)as Child_Count from Scheduled_AC_Child_District_Block_Month where Filter_Type=1 group by HealthBlock_Code) 
H on P.HealthBlock_Code=H.HealthBlock_Code left join 
(select HealthBlock_Code,SUM(Child_P)+SUM(Child_T)as Child_Count_Current_Finyr from Scheduled_AC_Child_District_Block_Month where Fin_Yr=@Current_Year and
Filter_Type=1 group by HealthBlock_Code) I on P.HealthBlock_Code=I.HealthBlock_Code left join 
(select HealthBlock_Code,SUM(Child_P)+SUM(Child_T)as Child_Count_Prev_Finyr from Scheduled_AC_Child_District_Block_Month where Fin_Yr=@Previous_Year and 
Filter_Type=1 group by HealthBlock_Code) J on P.HealthBlock_Code=J.HealthBlock_Code left join 
(Select HealthBlock_ID,isnull(SUM(EC_Total_Count),0) as EC_Total_Added_Finyr,isnull(SUM(Mother_Total_Count),0) as Mother_Total_Added_Finyr
,isnull(SUM(Child_Total_Count),0) as Child_Total_Added_Finyr,isnull(SUM(EC_Total_Count_Updated),0) as EC_Total_Updated_Finyr
,isnull(SUM(Mother_Total_Count_Updated),0) as Mother_Total_Updated_Finyr,isnull(SUM(Child_Total_Count_Updated),0) as Child_Total_Updated_Finyr 
from Scheduled_DB_District_Block_Count where Created_Date=Convert(date,GETDATE()-1) group by HealthBlock_ID) K on P.HealthBlock_Code=K.HealthBlock_ID
end

