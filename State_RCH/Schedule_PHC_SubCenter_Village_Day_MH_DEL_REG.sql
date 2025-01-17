USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_PHC_SubCenter_Village_Day_MH_DEL_REG]    Script Date: 09/26/2024 14:45:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*  
exec [Schedule_PHC_SubCenter_Village_Day_MH_DEL_REG] 01
*/  
ALTER proc [dbo].[Schedule_PHC_SubCenter_Village_Day_MH_DEL_REG]  
(  
@State_Code int=0  
)  
as  
begin  
--set nocount on
truncate table t_temp_ReportMasterDate 

insert into t_temp_ReportMasterDate(Created_On,State_Code,PHC_Code,SubCentre_Code,Village_Code)  
select   GETDATE(),State_Code,PHC_Code,SubCentre_Code,Village_Code   
from t_Schedule_Date where State_Code is not null   
group by State_Code, PHC_Code, SubCentre_Code, Village_Code

delete a from  Scheduled_PHC_SubCenter_Village_Day_MH_DEL_REG a  
inner join t_temp_ReportMasterDate b on a.Stateid=b.State_Code and a.PHC_ID=b.PHC_Code and a.[SubCentre_ID]=b.SubCentre_Code  
and a.[Village_ID]=b.Village_Code  

insert into Scheduled_PHC_SubCenter_Village_Day_MH_DEL_REG([StateID], [District_ID], [Taluka_ID], [PHC_ID], [SubCentre_ID], [Village_ID], [reg_delete_total]
,Dup_Mother_Delete,permanent_delete--tentative duplicate
,Year_ID ,Month_ID,Reg_date,Fin_Yr )  
SELECT m_StateID as State_Code       
      ,m_District_ID as District_code
      ,m_Taluka_ID as Taluka_code
      ,m_PHC_ID as Healthfacility_Code  
      ,m_SubCentre_ID as HealthSubfacility_Code  
      ,m_Village_ID as Village_code
      ,count(a.Delete_Mother) as reg_delete_total
	  ,sum(a.Dup_Mother_Delete) as Dup_Mother_Delete
	  ,sum(a.permanent_delete) as permanent_delete
       ,YEAR(a.Mother_Registration_Date)[Year_ID]  
      ,Month(a.Mother_Registration_Date)[Month_ID]  
     ,a.Mother_Registration_Date as [AsOnDate]  --,a.Mother_Reg_Fin_Yr
	 ,(Case when Month(Mother_Registration_Date)> 3 then YEAR(Mother_Registration_Date) else YEAR(Mother_Registration_Date)-1 end) as FinYr
   FROM t_mother_flat a  (nolock)
   inner join t_temp_ReportMasterDate b on  a.m_StateID=b.State_Code and a.m_PHC_ID=b.PHC_Code and a.m_SubCentre_ID=b.SubCentre_Code and a.m_Village_ID=b.Village_Code  
   where  a.Mother_Registration_Date is not null and Mother_Registration_Date<>'1990-01-01'  and delete_mother=1
  group by m_StateID,m_District_ID,m_Taluka_ID,m_PHC_ID,m_SubCentre_ID,m_Village_ID,
  YEAR(a.Mother_Registration_Date),Month(a.Mother_Registration_Date),a.Mother_Registration_Date
end  
