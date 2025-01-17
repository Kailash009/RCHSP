USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Maternal_Death_Day_Wise]    Script Date: 09/26/2024 12:33:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
truncate table Scheduled_Maternal_Health_Day
select * from Scheduled_Maternal_Health_Day
Schedule_Maternal_Death_Day_Wise
*/


ALTER proc [dbo].[Schedule_Maternal_Death_Day_Wise]
as
begin

delete from Scheduled_Maternal_Health_Day
insert into Scheduled_Maternal_Health_Day([State_Code],[District_Code],[Year_ID],[Month_ID],[Day_ID],[AsOnDate],[Estimated_PW_Total]
      ,[Registered_PW_Total],[Hindu_Total],[Muslim_Total],[Sikh_Total],[Christian_Total],[Jainism_Total],[Buddism_Total],[Other_Relegion_Total]
      ,[SC],[ST],[Other_Caste_Total],[APL_Total],[BPL_Total],[APLBPL_NotKnown_Total],[Del_Rep_Total],[Del_Rep_at_Home],[Del_Rep_at_Public],[Del_Rep_at_Private]
      ,[Reg_PW_HighRisk],[Reg_PW_1st_Trimester_Total],[Reg_PW_2nd_Trimester_Total],[Reg_PW_3rd_Trimester_Total]
      ,[Del_MD_Total]
      ,[Del_MD_Home_Total],[Del_MD_Public_Intitution_Total],[Del_MD_Private_Intitution_Total]
      )

select A.State_Code,A.District_Code,A.Financial_Year,M.Month_ID,M.Day_ID,M.[Date],
A.Estimated_Mother,
isnull(B.Registration_no,0)as [Registered_PW_Total],
isnull(B.Reg_Religion_Hinduism,0)as Reg_Religion_Hinduism,
isnull(B.Reg_Religion_Islam,0)as Reg_Religion_Islam,
isnull(B.Reg_Religion_sikhism,0)as Reg_Religion_sikhism,
isnull(B.Reg_Religion_Christianity,0)as Reg_Religion_Christianity,
isnull(B.Reg_Religion_Jainism,0) as Reg_Religion_Jainism,
isnull(B.Reg_Religion_Buddism,0)as Reg_Religion_Buddism,
isnull(B.Reg_Religion_Other,0)as Reg_Religion_Other,
isnull(B.Reg_Cast_SC,0)as Reg_Cast_SC,
isnull(B.Reg_Cast_ST,0)as Reg_Cast_ST,
isnull(B.Reg_Cast_Other,0)as Reg_Cast_Other,
isnull(B.Reg_APL,0)as Reg_APL,
isnull(B.Reg_BPL,0)as Reg_BPL,0 as APLBPL_NotKnown,
isnull(C.Del_Rep_Total,0)as Del_Rep_Total,
isnull(C.Del_Rep_at_Home,0)as Del_Rep_at_Home,
isnull(C.Del_Rep_at_Public,0)as Del_Rep_at_Public,
isnull(C.Del_Rep_at_Private,0)as Del_Rep_at_Private,
isnull(B.Reg_PW_HighRisk_Year,0)as Reg_PW_HighRisk_Year,
isnull(B.Reg_PW_1st_Trimester_Total,0)as Reg_PW_1st_Trimester_Total,
isnull(B.Reg_PW_2nd_Trimester_Total,0)as Reg_PW_2nd_Trimester_Total,
isnull(B.Reg_PW_3rd_Trimester_Total,0)as Reg_PW_3rd_Trimester_Total,
isnull(C.Del_Maternal_Death_Total,0)as Del_Maternal_Death_Total,
isnull(C.Del_Maternal_Death_Home,0)as Del_Maternal_Death_Home,
isnull(C.Del_Maternal_Death_Public,0)as Del_Maternal_Death_Public,
isnull(C.Del_Maternal_Death_Private,0)as Del_Maternal_Death_Private 
from
(select Day_ID,Month_ID,Year_ID,[Date],Financial_Year,1 as N from [Day]) M 
inner join
(select Estimated_Mother/365 as Estimated_Mother,State_Code,District_Code,Financial_Year,1 as N
 from RCH_National_Level.dbo.Estimated_Data_District_Wise A
 where State_Code=27) A on M.N=A.N and M.Financial_Year=A.Financial_Year
left outer join
(select State_Code,District_Code,Reg_Year,Reg_Month,Reg_Day,Financial_Year,
count(Registration_no)as Registration_no,sum(Convert(int,Reg_Religion_Hinduism))as Reg_Religion_Hinduism,sum(Convert(int,Reg_Religion_Islam))as Reg_Religion_Islam,sum(Convert(int,Reg_Religion_sikhism))as Reg_Religion_sikhism,sum(Convert(int,Reg_Religion_Christianity))as Reg_Religion_Christianity,
sum(Convert(int,Reg_Religion_Jainism))as Reg_Religion_Jainism,sum(Convert(int,Reg_Religion_Buddism))as Reg_Religion_Buddism,sum(Convert(int,Reg_Religion_Other))as Reg_Religion_Other,sum(Convert(int,Reg_Cast_SC))as Reg_Cast_SC,sum(Convert(int,Reg_Cast_ST))as Reg_Cast_ST,sum(Convert(int,Reg_Cast_Other))as Reg_Cast_Other,
sum(Convert(int,Reg_APL))as Reg_APL,sum(Convert(int,Reg_BPL))as Reg_BPL,sum(0) as APLBPL_NotKnown,SUM(Convert(int,Reg_Mother_High_Resk))as Reg_PW_HighRisk_Year,sum(Convert(int,Med_Reg_In_1st_Trimester))as Reg_PW_1st_Trimester_Total,
sum(Convert(int,Med_Reg_In_2nd_Trimester))as Reg_PW_2nd_Trimester_Total,sum(Convert(int,Med_Reg_In_3rd_Trimester)) as Reg_PW_3rd_Trimester_Total from RCH_27.dbo.t_mother_Reg_Med_Count_Service  group by 
State_Code,District_Code,Reg_Year,Reg_Month,Reg_Day,Financial_Year) B on A.State_Code=B.State_Code and A.District_Code=B.District_Code and A.Financial_Year=B.Financial_Year and M.Month_ID=B.Reg_Month and M.Day_ID=B.Reg_Day
left outer join
(select State_Code,District_Code,Reg_Financial_Year,Registration_Year,Registration_Month,Registration_Day,count(Registration_no) as Del_Rep_Total,sum(Convert(int,Del_DeliveryPlace_Home))as Del_Rep_at_Home
,sum(Convert(int,Del_DeliveryPlace_Public))as Del_Rep_at_Public,sum(Convert(int,Del_DeliveryPlace_Private)) as Del_Rep_at_Private
,count(Registration_no)as Del_Maternal_Death_Total,sum(Convert(int,Del_Maternal_Death_Home))as Del_Maternal_Death_Home
,sum(Convert(int,Del_Maternal_Death_Public))as Del_Maternal_Death_Public,sum(Convert(int,Del_Maternal_Death_Private))as Del_Maternal_Death_Private
from RCH_27.dbo.t_mother_Delivery_Count_Service  group by State_Code,District_Code,Registration_Year,Registration_Month,Reg_Financial_Year,Registration_Day) C on A.State_Code=C.State_Code and A.District_Code=C.District_Code
and A.Financial_Year=C.Reg_Financial_Year and M.Month_ID=C.Registration_Month and B.Reg_Year=C.Registration_Year and M.Day_ID=C.Registration_Day

end