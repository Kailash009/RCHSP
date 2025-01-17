USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Immunization_Master_Fill]    Script Date: 09/26/2024 14:58:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
tp_Immunization_Master_Fill 31
*/
ALTER procedure [dbo].[tp_Immunization_Master_Fill]
@State_Code int=0,
@Status int=2  --Added on 23042018
as
begin

   select ImmuCode as Immunization_Code,
		  ImmuName as Immunization_Name,
		  ImmuCodeName as Immunization_ShortName,
		  (case Flag when '1' then 'Active' when '0' then 'InActive' end)as Status
		  from m_ImmunizationName
		  where State_Code=@State_Code 
		  --and ImmuCode<>36
		  and (Flag=@Status or @Status=2)--Added on 23042018
end




