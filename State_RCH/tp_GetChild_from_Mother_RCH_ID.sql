USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_GetChild_from_Mother_RCH_ID]    Script Date: 09/26/2024 15:43:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*        
tp_GetChild_from_Mother_RCH_ID 195003681768,''        
tp_GetChild_from_Mother_RCH_ID 281148300311500002 , 'Mcts_No'        
*/        
ALTER proc [dbo].[tp_GetChild_from_Mother_RCH_ID]        
(        
@Registration_no varchar(18),        
@RCH_Mcts_No varchar(16)=null        
)        
as        
begin        
 if(@RCH_Mcts_No=null or @RCH_Mcts_No='')        
 begin        
  select mr.Registration_no as Registration_no        
  ,mr.Registration_Date as Date_regis        
  ,mr.Name_PW as Name_PW  
  -- ,mr.MiddleName_wife    
  --,mr.LastName_wife     
  ,mr.Mobile_No        
  ,mr.Case_no        
  ,( case when cast(md.Delivery_date as varchar) IS not null then cast(md.Delivery_date as varchar) else '--' end) as Delivery_date     
  ,md.LiveBirth as Outcomes--Added by sweta        
  ,mii.Mother_LMP_Date as LMP_Date--Added by sweta        
  ,pt.page_code as page_code--Added by sweta        
  ,te.Date_regis as Date_regis_link--Added by sweta        
   ,mii.Infant_No as ChildRegistered--Added by sweta    
   ,md.Delivery_Time --Added by ramesh  
   ,md.ANM_ID,md.ASHA_ID  
   --,md.MPW_ID --Added by ramesh     
   ,mm.LMP_Date,mm.HBSAG_Test,mm.HBSAG_Date ,mm.HBSAG_Result --Added by Amit Maurya  
   from t_mother_registration mr         
  left outer join t_mother_delivery(nolock) md on mr.Registration_no=md.Registration_no and mr.Case_no=md.Case_no        
  --left outer join t_mother_infant mi on mr.Registration_no=mi.Registration_no and mr.Case_no=mi.Case_no       
  left outer join t_mother_infant_intermediate(nolock) mii on mr.Registration_no=mii.Registration_no and mr.Case_no=mii.Case_no--Added by sweta        
  left outer join t_page_tracking(nolock) pt on mr.Registration_no=pt.Registration_no and mr.Case_no=pt.Case_no--Added by sweta        
  left outer join t_eligibleCouples(nolock) te on mr.Registration_no=te.Registration_no and mr.Case_no=te.Case_no--Added by sweta      
  left outer join t_mother_medical(nolock) mm on mr.Registration_no=mm.Registration_no and mr.Case_no=mm.Case_no--Added by amit maurya  
  where mr.Registration_no=@Registration_no       
  and isnull(mr.Delete_Mother,0)=0      
 end        
 else        
 begin        
  select mr.Registration_no as Registration_no        
  ,mr.Registration_Date as Date_regis        
  ,mr.Name_PW as Name_PW   
  --,mr.MiddleName_wife    
 -- ,mr.LastName_wife   
  ,mr.Mobile_No           
  ,mr.Case_no    
   ,md.LiveBirth as Outcomes--Added by sweta        
  ,mii.Mother_LMP_Date as LMP_Date--Added by sweta        
  ,pt.page_code as page_code--Added by sweta        
  ,te.Date_regis as Date_regis_link--Added by sweta        
   ,mii.Infant_No as ChildRegistered--Added by sweta    
   ,md.Delivery_Time --Added by ramesh     
   ,md.ANM_ID,md.ASHA_ID  
   --,md.MPW_ID--Added by ramesh
    ,( case when cast(md.Delivery_date as varchar) IS not null then cast(md.Delivery_date as varchar) else '--' end) as Delivery_date   
   ,mm.LMP_Date,mm.HBSAG_Test,mm.HBSAG_Date ,mm.HBSAG_Result --Added by Amit Maurya  
   from t_mother_registration mr         
  left outer join t_mother_delivery(nolock) md on mr.Registration_no=md.Registration_no and mr.Case_no=md.Case_no        
  --left outer join t_mother_infant mi on mr.Registration_no=mi.Registration_no and mr.Case_no=mi.Case_no     
  left outer join t_mother_infant_intermediate(nolock) mii on mr.Registration_no=mii.Registration_no and mr.Case_no=mii.Case_no--Added by sweta        
  left outer join t_page_tracking(nolock) pt on mr.Registration_no=pt.Registration_no and mr.Case_no=pt.Case_no--Added by sweta        
  left outer join t_eligibleCouples(nolock) te on mr.Registration_no=te.Registration_no and mr.Case_no=te.Case_no--Added by sweta      
  left outer join t_mother_medical(nolock) mm on mr.Registration_no=mm.Registration_no and mr.Case_no=mm.Case_no--Added by amit maurya  
  where mr.ID_No=@Registration_no and isnull(mr.Delete_Mother,0)=0       
 end        
end   

