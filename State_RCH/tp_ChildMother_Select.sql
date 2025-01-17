USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_ChildMother_Select]    Script Date: 09/26/2024 15:44:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







/*
exec [tp_child_registration_Select] 1
*/
ALTER proc [dbo].[tp_ChildMother_Select]
(
@State_Code int  
,@District_Code int  
,@Rural_Urban char(1)  
,@HealthBlock_Code int  
,@Taluka_Code varchar(6)  
,@HealthFacility_Type int  
,@HealthFacility_Code int  
,@HealthSubFacility_Code int  
,@Village_Code int
,@Registration_no bigint
)
as
begin
	SET NOCOUNT ON
	select i.Infant_Id as Child_Id
	,m.Register_srno 
	,m.Registration_no as Mother_Id
	,m.Name_PW as Mother_Name
	,m.Mobile_No as Mobile_No
	,e.Landline_no as Landline_no
	,m.[Address] as [Address]
	,m.Religion_code as Religion_code
	,m.Caste as Caste
	,e.Identity_type
	,e.Identity_number
	,m.ANM_ID
	,m.ASHA_ID
	,i.Gender_Infant
	,d.Delivery_date 
    from t_eligibleCouples as e 
    inner join t_mother_registration as m
    on e.Registration_no=m.Registration_no
    inner join t_mother_delivery as d
    on m.Registration_no=d.Registration_no
    inner join t_mother_infant as i
    on m.Registration_no=i.Registration_no
    where 
		m.State_Code=@State_Code and
		m.District_Code=@District_Code and  
		m.Rural_Urban=@Rural_Urban and 
		m.HealthBlock_Code=@HealthBlock_Code and 
		m.Taluka_Code=@Taluka_Code and   
		m.HealthFacility_Type=@HealthFacility_Type and 
		m.HealthFacility_Code=@HealthFacility_Code and   
		m.HealthSubFacility_Code=@HealthSubFacility_Code and   
		m.Village_Code=@Village_Code and
		--Financial_Year=@Financial_Year and
		m.Registration_no=@Registration_no  
	
end






