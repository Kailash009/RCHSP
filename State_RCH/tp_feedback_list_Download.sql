USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_feedback_list_Download]    Script Date: 09/26/2024 15:54:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- [tp_feedback_list_Download] 0,45,0,1,0,0,3
         
ALTER procedure [dbo].[tp_feedback_list_Download]                                                                       
(                                                                      
@FeedbackID bigint=0                                      
,@USERID int=0                                                                
,@NoofDays as int=0                                                              
,@StatusID int =0                                                                              
,@MainModule_ID int =0                                        
,@Feedback_Type int                       
,@RoleID int                                                                           
)                                                                      
as                                                               
begin   
SET NOCOUNT ON;    
                      
IF(@RoleID = '1' or @RoleID = '2' or @RoleID ='3')                       
BEGIN                                                                       
select FeedbackID,b.User_Name as Feedback_From
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assigned_To
,(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                      
when 6 then 'As per functionality applied' else 'Closed' end) as Status 
,m.Name as Module_Name                                           
,n.Name as Sub_Module_Name                                                                  
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type   
,a.Shrt_Desp as [Subject]   
,CONVERT(varchar,a.Created_On,103) as Created_Date
,c.User_Name as Updated_By                                                                          
,CONVERT(varchar,a.Updated_On,103) as Updated_Date  
,Content_Name as image_name                                                                                                                     
from t_feedback (nolock) a                                                                
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                                              
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                            
left outer join User_Master (nolock) b on a.Created_By =b.UserID          
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                         
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                                                    
where (FeedbackID= @FeedbackID or  @FeedbackID=0)                                                     
and (a.StatusID=@StatusID  or @StatusID=0)                                                                            
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                      
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                             
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                        
END                            
                               
ELSE IF(@RoleID = '4')                       
                           
begin                                                                
select FeedbackID,b.User_Name as Feedback_From
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assigned_To
,(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                      
when 6 then 'As per functionality applied' else 'Closed' end) as Status 
,m.Name as Module_Name                                           
,n.Name as Sub_Module_Name                                                                  
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type   
,a.Shrt_Desp as [Subject]   
,CONVERT(varchar,a.Created_On,103) as Created_Date
,c.User_Name as Updated_By                                                                          
,CONVERT(varchar,a.Updated_On,103) as Updated_Date  
,Content_Name as image_name                                                                       
from t_feedback (nolock) a                                                                
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                                              
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                            
left outer join User_Master (nolock) b on a.Created_By =b.UserID          
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                     
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                                                    
where                                                     
(FeedbackID= @FeedbackID or  @FeedbackID=0)                                                             
and (a.StatusID=@StatusID  or @StatusID=0)                  
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                      
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                             
and a.RoleID not in(1,2,3,5,6)                                                         
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                     
END                         
                       
ELSE IF(@RoleID = '5')                          
BEGIN                                                               
select FeedbackID,b.User_Name as Feedback_From
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assigned_To
,(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                      
when 6 then 'As per functionality applied' else 'Closed' end) as Status 
,m.Name as Module_Name                                           
,n.Name as Sub_Module_Name                                                                  
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type   
,a.Shrt_Desp as [Subject]  
,CONVERT(varchar,a.Created_On,103) as Created_Date
,c.User_Name as Updated_By                                                                           
,CONVERT(varchar,a.Updated_On,103) as Updated_Date  
,Content_Name as image_name                                                           
from t_feedback (nolock) a                                                                
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                        
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                            
left outer join User_Master (nolock) b on a.Created_By =b.UserID          
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                  
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                         
where                                             
(FeedbackID= @FeedbackID or  @FeedbackID=0)                                                             
and (a.StatusID=@StatusID  or @StatusID=0)                                      
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                      
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                             
and a.RoleID not in (2,3)                     
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                         
END                          
                       
ELSE IF(@RoleID = '6')                          
BEGIN                                                            
select FeedbackID,b.User_Name as Feedback_From
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assigned_To
,(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                      
when 6 then 'As per functionality applied' else 'Closed' end) as Status 
,m.Name as Module_Name                                           
,n.Name as Sub_Module_Name                                                                  
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type   
,a.Shrt_Desp as [Subject]   
,CONVERT(varchar,a.Created_On,103) as Created_Date
,c.User_Name as Updated_By                                                                       
,CONVERT(varchar,a.Updated_On,103) as Updated_Date  
,Content_Name as image_name                                                                        
from t_feedback (nolock) a                                                                
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                                              
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                            
left outer join User_Master (nolock) b on a.Created_By =b.UserID          
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                     
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                                                                     
where                                                     
(FeedbackID= @FeedbackID or  @FeedbackID=0)                          
and (a.StatusID=@StatusID  or @StatusID=0)                                     
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                      
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                             
and a.RoleID not in (1,2,3,5)             
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                         
END                          
                            
ELSE                             
BEGIN                            
                                                                     
select FeedbackID,b.User_Name as Feedback_From
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assigned_To
,(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                      
when 6 then 'As per functionality applied' else 'Closed' end) as Status 
,m.Name as Module_Name                                           
,n.Name as Sub_Module_Name                                                                  
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type   
,a.Shrt_Desp as [Subject] 
,CONVERT(varchar,a.Created_On,103) as Created_Date
,c.User_Name as Updated_By                                                                           
,CONVERT(varchar,a.Updated_On,103) as Updated_Date  
,Content_Name as image_name                                                                  
from t_feedback (nolock) a                                                                
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                       
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                            
left outer join User_Master (nolock) b on a.Created_By =b.UserID          
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                      
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                                                                      
where              
 a.Created_By=@USERID                                                                     
and (FeedbackID= @FeedbackID or  @FeedbackID=0)                                                             
and (a.StatusID=@StatusID  or @StatusID=0)                                                                            
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                      
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                          
and (a.RoleID =@RoleID or @RoleID=0)                            
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                         
                       
END                         
End  
  