USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_feedback_Insert_Update]    Script Date: 09/26/2024 15:54:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
 --tp_feedback_Insert_Update 99,'mcts-helpdesk','testinggg','arunabna@gmail.com','9899999999','Capture3.jpg','image/jpeg','testinggg',4,5,6,'10.26.51.104',26,1,1,'',3      
        
ALTER procedure [dbo].[tp_feedback_Insert_Update]              
(@StateID  as int=0            
,@Address varchar(150)              
,@Email varchar(50)              
,@Mobile varchar(10)                
,@Content_Name varchar(50)          
,@Content_Type varchar(10)        
,@Content_Value varbinary(max)=null            
,@Content_Description varchar(4000)         
,@FeedbackID bigint=0 out        
,@MainModule_ID int        
,@Module_ID int        
,@SubModule_ID int         
,@IP_address varchar(25)              
,@USERID int        
,@StatusID int        
,@FileUploadType int        
,@msg nvarchar(200) out        
,@RoleID varchar(15)=''                                               
,@Comments varchar(250) =''                                       
,@Feedback_Type int              
,@Forward_To int                                                     
,@Case_no int       
,@Flag  int                                                          
,@Subject varchar(50)=''      
)              
as               
begin              
          
if not exists(select 1 from  m_feedback (nolock) where Created_Date=CONVERT(date,GETDATE()))          
begin     
insert into m_feedback (Created_Date,Count_ID,Max_ID)           
 select getdate(),0,cast(@StateID  as varchar)+CONVERT(VARCHAR(10),GETDATE(),112)+'00'          
end
     
if(@FeedbackID=0)          
begin          
select @FeedbackID=Max_ID+1 from m_feedback  where Created_Date=CONVERT(date,GETDATE())         
update m_feedback set Max_ID=@FeedbackID,Count_ID=Count_ID+1 where Created_Date=CONVERT(date,GETDATE())          
end          
          
if exists (select FeedbackID from t_feedback (nolock) where FeedbackID=@FeedbackID and Case_no=@Case_no )          
begin          
update t_feedback set Address =@Address,Email =@Email,Mobile =@Mobile,IP_address =@IP_address,Updated_By =@USERID          
,Updated_On =GETDATE()        
,Content_Name =(case when @FileUploadType = 1 then @Content_Name else  Content_Name end)        
,Content_Type =(case when @FileUploadType = 1 then @Content_Type else  Content_Type end)        
,Content_Value=(case when @FileUploadType = 1 then @Content_Value  else  Content_Value end)        
,Content_Description=@Content_Description          
,MainModule_ID=@MainModule_ID,Module_ID=@Module_ID,SubModule_ID=@SubModule_ID        
,StatusID=@StatusID                                   
,Feedback_Type=@Feedback_Type                                         
,Forward_To=@Forward_To          
,Shrt_Desp=@Subject                           
where FeedbackID=@FeedbackID  and Case_no=@Case_no                                   
          
set @msg = 'Record Save Successfully !!!'  
end          
           
else          
begin          
          
insert into t_feedback(FeedbackID,UserID,Address,Email,Mobile,IP_address,Created_By,Created_On,Content_Description,Content_Value,Content_Type,Content_Name,MainModule_ID,Module_ID,SubModule_ID,StatusID,RoleID,State_Code,      
Feedback_Type,Forward_To,Case_no,Flag,Shrt_Desp      
)               
values (@FeedbackID,@USERID,@Address,@Email,@Mobile,@IP_address,@USERID,GETDATE(),@Content_Description,@Content_Value,@Content_Type,@Content_Name,@MainModule_ID,@Module_ID,@SubModule_ID,@StatusID,@RoleID,@StateID                  
,@Feedback_Type,@Forward_To,@Case_no,@Flag,@Subject      
)                 
set @msg = 'Thank you for providing Feedback.'           
end           
         
if(@Case_no<>1)      
begin      
update t_feedback set Flag=0 where FeedbackID=@FeedbackID and Case_no<>@Case_no and Flag=1      
end      
return      
end            
IF (@@ERROR <> 0)              
BEGIN              
     RAISERROR ('TRANSACTION FAILED',16,-1)              
     ROLLBACK TRANSACTION              
END 

