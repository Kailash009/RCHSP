USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Children_Check_Data]    Script Date: 09/26/2024 12:22:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 /*  
      tp_Children_Check_Data '229010453512'  
      --alter on 01122016 for nitish  
  */  
  
ALTER PROCEDURE [dbo].[tp_Children_Check_Data]  
(  
 @Registration bigint  
 )  
as  
BEGIN  
 SELECT CR.Register_srno as srno,CR.Registration_Date as Registration_Date,CR.Name_Child,  
 (Case CR.Gender  
  when 'M' then 'Male'  
  when 'F' then 'Female'  
  when 'T'then 'Transgender' End )As Gender,CR.Name_Mother  
  , (case when CR.Mother_ID_No IS NULL then '' else CAST(CR.Mother_ID_No as nvarchar(25)) + ' /' end + CHAR(13) +  
  case when CR.Mother_Reg_No IS NULL  then '' when CR.Mother_Reg_no = '0' then '' else CAST(CR.Mother_Reg_No as nvarchar(25)) end) as MCTS_RCH_ID  
,  
 CR.Birth_Date,( case CR.Birth_place  
        when 1 then 'PHC'  
  when 2 then 'CHC'  
  when 24 then 'Sub Center'  
  when 5 then 'District Hospital'  
  when 21 then 'PVT. Hospital'  
  when 20 then 'Accrediated PVT. Hospital'  
  when 19 then 'Other [Public] Facility'  
  when 4 then 'SubDistrict Hospital'  
  when 17 then 'Medical Colleges Hospital'  
  when 23 then 'InTransit'  
  when 22 then 'Home' 
  when 7 then 'Referral Hospital' end) as Birth_place  
 ,CR.[Weight],  
 (case CR.Religion_code  
  when 1 then 'Christian'   
  when 2 then 'Hindu'   
  when 3 then 'Muslim'   
  when 4 then 'Sikh'   
  when 99 then 'Other' end)AS Religion,  
 (Case CR.Caste   
  when 1 then 'SC'   
  when 2 then 'ST'   
  when 99 then 'Others' end)As Caste,CR.[address],CR.Financial_Yr as [Year],CT.Reason_closure,CT.Reason_closure_Other,CT.Death_reason,CT.Other_Death_reason  
  ,CT.DeathPlace,CT.DeathDate,CT.ID_No,CR.ANM_ID,CR.ASHA_ID,CR.Entry_Type,CR.Case_no,isnull(CT.Immu_code,'99') as Immu_code,CR.HBIG_Date FROM t_children_registration  as CR  
  left outer join t_children_tracking as CT on CR.Registration_no=CT.Registration_no  
 where CR.Registration_no=@Registration  
END  
  
  
  
