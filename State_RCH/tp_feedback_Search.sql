USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_feedback_Search]    Script Date: 09/26/2024 15:54:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

        
 --    [tp_feedback_Search] 302019052801,0,0,1,30,0,0,0          
ALTER procedure [dbo].[tp_feedback_Search]                                                                     
(                                                                    
@FeedbackID bigint=0                                    
,@USERID int=0                                                              
,@NoofDays as int=0                                                            
,@StatusID int =0                                     
,@StateID  as int=0                                       
,@MainModule_ID int =0                                      
,@Feedback_Type int                     
,@RoleID int                                                                         
)                                                                    
as                                                                       
begin                        
IF(@RoleID = '1' or @RoleID = '2' or @RoleID ='3')    --National Administrator(2)/ National User (3) showing only roleid =3                       
BEGIN                                                                     
                                                             
select FeedbackID,b.User_Name,Address,a.Email,Mobile,                            
(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                    
when 6 then 'As per functionality applied' else 'Closed' end) as Status                                                                      
,StatusID                                                                      
,Content_Description as FeedBack                                                                            
,a.MainModule_ID as Module                                                                      
,a.Module_ID as Sub_Module                                                              
,a.SubModule_ID as Sub_Module_Type                                                                                        
,m.Name as Module_Name                                         
,n.Name as Sub_Module_Name                                                                
,o.Name as Sub_Module_Ty_Name                                                                     
,CONVERT(varchar,a.Created_On,103) as Created_Date                                                                      
,CONVERT(varchar,a.Updated_On,103) as Updated_Date                
,Content_Name as image_name                                
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type                              
--,a.last_Comment As Comments                  
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assign_To         
,a.Case_no         
,(case when a.StatusID=3 and a.Flag = 0 then 0 else 1 end) as Case_No_Old                                                                  
,c.User_Name as Updated_By  --03052018        
,a.Shrt_Desp as [Subject]  -- Issue/Enhancement Summary on 01-05-18                                                                                                              
from t_feedback (nolock) a                                                              
left outer join RCH_National_Level.dbo.m_Module_Master (nolock) m on a.MainModule_ID=m.ID                                                            
left outer join RCH_National_Level.dbo.m_Modules (nolock) n on a.MainModule_ID=n.MainModule_ID  and a.Module_ID=n.ID                                                          
left outer join RCH_National_Level.dbo.m_Modules_SubModule (nolock) o on a.Module_ID=o.Module_ID  and a.SubModule_ID=o.ID                                                          
left outer join User_Master (nolock) b on a.Created_By =b.UserID        
left outer join User_Master (nolock) c on a.Updated_By =c.UserID                       
left outer join RCH_National_Level.dbo.m_Roles (nolock) r on r.RoleID=a.Forward_To                                                  
where (FeedbackID= @FeedbackID or  @FeedbackID=0)                                                   
and (a.StatusID=@StatusID  or @StatusID=0)                                     
and (a.State_Code =@StateID or @StateID=0)                                    
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                    
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                           
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                       
END                          
                             
ELSE IF(@RoleID = '4')    -- Data Entry/Block Operator (4)  Data Entry Operator with his lower case show roleid (Block, PHC,.... )                        
                         
begin                                                              
select FeedbackID,b.User_Name,Address,a.Email,Mobile,                            
(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                    
when 6 then 'As per functionality applied' else 'Closed' end) as Status                                         
,StatusID                                                                      
,Content_Description as FeedBack                                                                            
,a.MainModule_ID as Module                                                                      
,a.Module_ID as Sub_Module                                                              
,a.SubModule_ID as Sub_Module_Type                                                                                           
,m.Name as Module_Name                                         
,n.Name as Sub_Module_Name                                                                
,o.Name as Sub_Module_Ty_Name                                                                     
,CONVERT(varchar,a.Created_On,103) as Created_Date                                                            
,CONVERT(varchar,a.Updated_On,103) as Updated_Date                                                                      
,Content_Name as image_name                                
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type           
--,a.last_Comment As Comments                    
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assign_To         
,a.Case_no          
,(case when a.StatusID=3 and a.Flag = 0 then 0 else 1 end) as Case_No_Old                                                                                                                          
,c.User_Name as Updated_By  --03052018        
,a.Shrt_Desp as [Subject]  -- Issue/Enhancement Summary on 01-05-18                                                                  
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
and (a.State_Code =@StateID or @StateID=0)                 
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                    
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                           
and a.RoleID not in(1,2,3,5,6)                                                       
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                   
END                       
                     
ELSE IF(@RoleID = '5')    -- State Level User(5)and State Administrator (1)  -- / State/District Level Users and Data Entry Operator roleid (1,5,6 and 4)                        
BEGIN                                                             
select FeedbackID,b.User_Name,Address,a.Email,Mobile,                            
(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                    
when 6 then 'As per functionality applied' else 'Closed' end) as Status                                                                      
,StatusID                                                                      
,Content_Description as FeedBack                                                                            
,a.MainModule_ID as Module                                                                      
,a.Module_ID as Sub_Module                                                              
,a.SubModule_ID as Sub_Module_Type                                                                                          
,m.Name as Module_Name                                         
,n.Name as Sub_Module_Name                                                                
,o.Name as Sub_Module_Ty_Name                                                                     
,CONVERT(varchar,a.Created_On,103) as Created_Date                                                                      
,CONVERT(varchar,a.Updated_On,103) as Updated_Date                
,Content_Name as image_name                                
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type           
--,a.last_Comment As Comments                    
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assign_To         
,a.Case_no         
,(case when a.StatusID=3 and a.Flag = 0 then 0 else 1 end) as Case_No_Old         
,c.User_Name as Updated_By          
,a.Shrt_Desp as [Subject]                                                     
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
and (a.State_Code =@StateID or @StateID=0)                                    
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                    
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                           
and a.RoleID not in (2,3)                   
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                       
END                        
                     
ELSE IF(@RoleID = '6')    -- District Level User(6)  -- / District Level Users and Data Entry with all lower case Operator roleid (6,4 with block,phc,...)                        
BEGIN                                                          
select FeedbackID,b.User_Name ,Address,a.Email,Mobile,                            
(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                    
when 6 then 'As per functionality applied' else 'Closed' end) as Status                                                                      
,StatusID                                                                      
,Content_Description as FeedBack                                                                            
,a.MainModule_ID as Module                                                                      
,a.Module_ID as Sub_Module                                                              
,a.SubModule_ID as Sub_Module_Type                                                                                          
,m.Name as Module_Name                                         
,n.Name as Sub_Module_Name                                                             
,o.Name as Sub_Module_Ty_Name                                                                     
,CONVERT(varchar,a.Created_On,103) as Created_Date                                                                      
,CONVERT(varchar,a.Updated_On,103) as Updated_Date                                                                                                
,Content_Name as image_name                                
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type           
--,a.last_Comment As Comments                   
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assign_To         
,a.Case_no         
,(case when a.StatusID=3 and a.Flag = 0 then 0 else 1 end) as Case_No_Old                                                                                                                           
,c.User_Name as Updated_By          
,a.Shrt_Desp as [Subject]                                                                  
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
and (a.State_Code =@StateID or @StateID=0)                                    
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                    
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                           
and a.RoleID not in (1,2,3,5)           
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                       
END                        
                          
ELSE                           
BEGIN                          
                                                                   
select FeedbackID,b.User_Name,Address,a.Email,Mobile,                            
(case StatusID when 1  then 'Pending' when 2 then 'In Progress' when 3 then 'Closed' when 4 then 'Not clear' when 5 then 'issue not found'                                                                    
when 6 then 'As per functionality applied' else 'Closed' end) as Status                                                                      
,StatusID                                                                      
,Content_Description as FeedBack                                                                            
,a.MainModule_ID as Module                                                                      
,a.Module_ID as Sub_Module                                                          
,a.SubModule_ID as Sub_Module_Type                                                                                         
,m.Name as Module_Name                                       
,n.Name as Sub_Module_Name                                                                
,o.Name as Sub_Module_Ty_Name                                                                     
,CONVERT(varchar,a.Created_On,103) as Created_Date                                                                      
,CONVERT(varchar,a.Updated_On,103) as Updated_Date                                                                                                                                
,Content_Name as image_name                                
,(Case a.Feedback_Type when 1 then 'Issue' else 'Enhancement' end) as Feedback_Type           
--,a.last_Comment As Comments                  
,(case RoleName when 'National User' then 'Ministry' else 'Helpdesk NIC' end)  as  Assign_To         
,a.Case_no          
,(case when a.StatusID=3 and a.Flag = 0 then 0 else 1 end) as Case_No_Old                                                                                                                           
,c.User_Name as Updated_By          
,a.Shrt_Desp as [Subject]                                                               
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
and (a.State_Code =@StateID or @StateID=0)                                    
and (a.MainModule_ID=@MainModule_ID or @MainModule_ID=0)                                    
and (a.Feedback_Type=@Feedback_Type or @Feedback_Type=0)                        
and (a.RoleID =@RoleID or @RoleID=0)                          
and (Case when @NoofDays=0 then convert(date,dateadd(day,-@NoofDays,getdate())) else a.Created_On end)>=convert(date,dateadd(day,-@NoofDays,getdate()))                       
                     
END                       
End

