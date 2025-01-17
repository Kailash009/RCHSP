USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_child_pnc_BindData]    Script Date: 09/26/2024 15:27:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
      
      
-- [tp_child_pnc_BindData] 27,26,'R',84,'0252',1,274,1622,32155,227000113827      
--[tp_child_pnc_BindData] 95,295003827829,1    
--last updated on 01122016 for nitish  
/*
tp_child_pnc_BindData 30,230000252049,2
*/  
ALTER proc [dbo].[tp_child_pnc_BindData]      
(      
@State_Code int        
,@InfantRegistration bigint      
,@Case_no int      
)      
as      
begin      
      
       ( select ROW_NUMBER() over (ORDER BY PNC_Type) AS SN,cp.Registration_no          
     ,PNC_No      
     --,(Case PNC_Type when 1 then '1st Day' when 2 then '3rd Day' when 3 then '7th Day' when 4 then '14th Day' when 5 then '21st Day' when 6 then '28th Day' when 7 then '42th Day' when 99 then 'DeActivated' when 0 then 'Death' end) as PNCPeriod      
     ,(Case when PNC_Type=1 then '1st Day' when PNC_Type=2 then '3rd Day' when PNC_Type=3 then '7th Day' when PNC_Type=4 then '14th Day' when PNC_Type=5 then '21st Day' when PNC_Type=6 then '28th Day' when PNC_Type=7 then '42th Day' when PNC_Type=0 and Infant_Death=1 then 'Death' when PNC_Type=0 and (Infant_Death<>1 OR Infant_Death IS null) then 'DeActivated' end) as PNCPeriod
     --,PNC_Date      
     ,(CASE PNC_Date WHEN '1990-01-01' THEN null ELSE PNC_Date END) PNC_Date
     ,InfantRegistration      
     ,Infant_Weight      
     ,dbo.[Get_Child_Danger_Sign_Name]( DangerSign_Infant) AS DangerSign_Infant      
    
     ,(case ReferralFacility_Infant when '0' then '' when '1' then 'Phc' when '2' then 'Chc' when '5' then 'District Hospital'      
     when '21' then 'Other Private Hospital' when '99' then 'Other' else '' end) as ReferralFacility_Infant       
     ,(case Infant_Death when '1' then 'Yes' when '0' then 'No' else '' end) as Infant_Death      
     ,Infant_Death_Date     
     ,cr.Entry_Type   
     ,c.Name as ANM_Name  
     ,(case when d.[Name] is null then 'Not Available' else d.[Name] end) as ASHA_Name           
     , cp.State_Code as State_Code       
     ,'t_child_pnc' as check_table  
     ,(select Convert(varchar(50),s.GroupName) + '(' + Convert(varchar(50),s.StateID) + ')' from State s WHERE cp.state_code =s.StateID) as State_Code_Name       
     ,cp.PNC_Type
     from t_child_pnc   cp      
     left outer join t_children_registration cr on cr.Registration_no=cp.InfantRegistration   
     Left outer join t_Ground_Staff c WITH (NOLOCK) on cp.ANM_ID=c.ID      
     Left outer join t_Ground_Staff d WITH (NOLOCK) on cp.ASHA_ID=d.ID 
     where --cp.State_Code=@State_Code  and   
      InfantRegistration=@InfantRegistration     
      and cp.Case_no=@Case_no        
UNION    
 select ROW_NUMBER() over (ORDER BY PNC_Type) AS SN,intcp.Registration_no          
     ,PNC_No      
     ,(Case when PNC_Type=1 then '1st Day' when PNC_Type=2 then '3rd Day' when PNC_Type=3 then '7th Day' when PNC_Type=4 then '14th Day' when PNC_Type=5 then '21st Day' when PNC_Type=6 then '28th Day' when PNC_Type=7 then '42th Day' when PNC_Type=0 and Infant_Death=1 then 'Death' when PNC_Type=0 and (Infant_Death<>1 OR Infant_Death IS null) then 'DeActivated' end) as PNCPeriod
     ,PNC_Date      
     ,InfantRegistration      
     ,Infant_Weight         
     ,dbo.[Get_Child_Danger_Sign_Name]( DangerSign_Infant) AS DangerSign_Infant      
     ,(case ReferralFacility_Infant when '0' then '' when '1' then 'Phc' when '2' then 'Chc' when '5' then 'District Hospital'      
     when '21' then 'Other Private Hospital' when '99' then 'Other' else '' end) as ReferralFacility_Infant       
     ,(case Infant_Death when '1' then 'Yes' when '0' then 'No' else '' end) as Infant_Death      
     ,Infant_Death_Date     
     ,cr.Entry_Type
     -- ,c.Name as ANM_Name  
     --,(case when d.[Name] is null then 'Not Available' else d.[Name] end) as ASHA_Name  
     ,intcp.ANM_Name   
     ,(case when intcp.ASHA_Name is null then 'Not Available' else intcp.ASHA_Name end) as ASHA_Name            
     ,intcp.User_state_code as State_Code     
      ,'t_interstate_child_pnc' as check_table     
      ,(select Convert(varchar(50),s.GroupName) + '(' + Convert(varchar(50),s.StateID) + ')' from State s WHERE intcp.User_state_code =s.StateID) as State_Code_Name    
      ,intcp.PNC_Type
      from t_interstate_child_pnc intcp      
      left outer join t_children_registration cr on cr.Registration_no=intcp.InfantRegistration         
     --Left outer join t_Ground_Staff c WITH (NOLOCK) on intcp.ANM_ID=c.ID      
     --Left outer join t_Ground_Staff d WITH (NOLOCK) on intcp.ASHA_ID=d.ID 
      where     
      InfantRegistration=@InfantRegistration     
      and intcp.Case_no=@Case_no )     
    
     order by PNC_No asc      
      
end      
      
