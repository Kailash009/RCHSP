USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligiblecouple_tracking_Select]    Script Date: 09/26/2024 15:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[tp_mother_infant_Select] 1,2  
ALTER proc [dbo].[tp_eligiblecouple_tracking_Select]   
(  
@State_Code int    
--,@District_Code int    
--,@Rural_Urban char(1)    
--,@HealthBlock_Code int    
--,@Taluka_Code varchar(6)    
--,@HealthFacility_Type int    
--,@HealthFacility_Code int    
--,@HealthSubFacility_Code int    
--,@Village_Code int  
,@Registration_no bigint
,@Case_no int 
,@VisitDate date  
)  
as  
begin  
SET NOCOUNT ON  
SELECT t.State_Code  
,t.District_Code  
,t.Rural_Urban  
,t.HealthBlock_Code  
,t.Taluka_Code  
,t.HealthFacility_Type  
,t.HealthFacility_Code  
,t.HealthSubFacility_Code  
,t.Village_Code  
,t.Financial_Yr  
,t.Financial_Year  
,t.VisitDate  
,t.Visit_No  
,t.Method  
,t.Other  
,t.Pregnant  
,t.Pregnant_test  
,t.ANM_ID  
,t.ASHA_ID  
,t.Case_no  
,t.SourceID
,t.Method_recd_date   
from t_eligible_couple_tracking as t WITH(NOLOCK)    
inner join t_eligibleCouples as e WITH(NOLOCK) on e.Registration_no=t.Registration_no and e.Case_no=t.Case_no   
where   
t.State_Code=@State_Code and  
t.Registration_no=@Registration_no and
t.Case_no = @Case_no and
t.VisitDate=@VisitDate  

end  

               