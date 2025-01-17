USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Daywise_EC_Mother_Child_HP_Asha_Register]    Script Date: 09/26/2024 11:58:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[Daywise_EC_Mother_Child_HP_Asha_Register]
(@State_Code int=0)
as
begin

insert into Daywise_EC_Mother_Child_Registered(EC_Count,Mother_Count,Child_Count,HP_Count,Asha_Count,Data_Entry_Date,Day_ID,Month_ID,Year_ID,Financial_Year)
select a.EC_Count as EC_Count,b.Mother_Count as Mother_Count,c.Child_Count as Child_Count,d.HP_Count as HP_Count,e.Asha_Count as Asha_Count,(GETDATE()-1)as Data_Entry_Date,DAY(GETDATE()-1)as Day_ID,MONTH(GETDATE()-1)as Month_ID,YEAR(GETDATE()-1)as Year_ID,
(case when MONTH(a.Created_On)>3 then YEAR(a.Created_On) else YEAR(a.Created_On)-1 end)as Financial_Year 
from
(select COUNT(Registration_no)as EC_Count,Convert(date,Created_On)as Created_On from t_eligibleCouples where YEAR(Created_On)=YEAR(GETDATE()-1) and MONTH(Created_On)=MONTH(GETDATE()-1) and DAY(Created_On)=DAY(GETDATE()-1) group by Convert(date,Created_On)) a 
left outer join
(select COUNT(Registration_no)as Mother_Count,Convert(date,Created_On)as Created_On from t_mother_registration where YEAR(Created_On)=YEAR(GETDATE()-1) and MONTH(Created_On)=MONTH(GETDATE()-1) and DAY(Created_On)=DAY(GETDATE()-1) group by Convert(date,Created_On)) b on b.Created_On=a.Created_On
left outer join
(select COUNT(Registration_no)as Child_Count,Convert(date,Created_On)as Created_On from t_children_registration where YEAR(Created_On)=YEAR(GETDATE()-1) and MONTH(Created_On)=MONTH(GETDATE()-1) and DAY(Created_On)=DAY(GETDATE()-1) group by Convert(date,Created_On)) c on c.Created_On=a.Created_On
left outer join
(select COUNT(ID)as HP_Count,Convert(date,Created_On)as Created_On from t_Ground_Staff where YEAR(Created_On)=YEAR(GETDATE()-1) and MONTH(Created_On)=MONTH(GETDATE()-1) and DAY(Created_On)=DAY(GETDATE()-1)	and Type_ID<>1 group by Convert(date,Created_On)) d on d.Created_On=a.Created_On
left outer join
(select COUNT(ID)as Asha_Count,Convert(date,Created_On)as Created_On from t_Ground_Staff where YEAR(Created_On)=YEAR(GETDATE()-1) and MONTH(Created_On)=MONTH(GETDATE()-1) and DAY(Created_On)=DAY(GETDATE()-1) and Type_ID=1 group by Convert(date,Created_On)) e on e.Created_On=a.Created_On


	


end



