USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_feedback_Comment_InsertUpdate]    Script Date: 09/26/2024 15:54:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

      
--    [tp_feedback_Comment_InsertUpdate] 30,80,302019051006,1,'',6,'demo comment,Forwarded to Ministry',3,1            
            
ALTER Proc [dbo].[tp_feedback_Comment_InsertUpdate]                  
(                                                                                        
@StateID  as int=0                                                    
,@USERID int                                                                                                 
,@FeedbackID bigint=0 out                                                                                     
,@StatusID int                                                                                                              
,@msg nvarchar(200) out                                                                                                            
,@RoleID int                                                                                                 
,@Comments varchar(250) =''                                                              
,@Forward_To int                                                   
,@Case_no int                       
--,@Flag  int                                                                                                 
)                                                                                                              
as                                                                                                                       
begin                   
                                                                                                               
set @msg='';            
Declare @Sno_count int = 1, @Case_type int =0                
           
update t_feedback set StatusID=@StatusID,Forward_To=@Forward_To,Updated_By =@USERID ,Updated_On =GETDATE()                                                                                               
 where FeedbackID=@FeedbackID and State_Code=@StateID and Case_no=@Case_no                                   
        
select @Sno_count=isnull(max(SNo),0)+1 from t_feedback_comment (nolock)  
      
insert into t_feedback_comment(SNo,Feedback_ID,UserID,Comment_By,Comment_On,Comments,Case_no) values (@Sno_count,@FeedbackID,@userid,@userid,GETDATE(),@Comments,@Case_no)             
set @msg = 'Comment saved successfully !!!'               
            
end            
                
--------------------- old -------------            
                        
--Declare @Sno_count int = 0, @Case_type int =0                  
--if exists (select Feedback_ID from t_feedback_comment where Feedback_ID=@FeedbackID and UserID=@userid and Case_no=@Case_no)                  
--begin                          
-- update t_feedback_comment set Comment_On=GETDATE(),Comments=@Comments where Feedback_ID=@FeedbackID and UserID=@userid and Case_no=@Case_no                          
--end                           
--else                      
--begin                          
--select @Sno_count=ISNULL(MAX(SNo),0) from t_feedback_comment where Feedback_ID=@FeedbackID and Case_no=@Case_no                           
--select @Case_type =Case_no from t_feedback_comment where Feedback_ID=@FeedbackID                           
                          
--if(@Case_no =1 and @Sno_count <=4)                          
--begin                          
--select @Sno_count=ISNULL((MAX(SNo)),0)+1 from t_feedback_comment where Feedback_ID=@FeedbackID and Case_no=@Case_no                                  
--insert into t_feedback_comment(SNo,Feedback_ID,UserID,Comment_By,Comment_On,Comments,Case_no) values (@Sno_count,@FeedbackID,@userid,@userid,GETDATE(),@Comments,@Case_no)                    
--end                          
--else if (@Case_no = 2 and @Case_type=1)                        --begin                          
--insert into t_feedback_comment(SNo,Feedback_ID,UserID,Comment_By,Comment_On,Comments,Case_no) values (1,@FeedbackID,@userid,@userid,GETDATE(),@Comments,@Case_no)                                   
--end                   
--else if (@Case_no = 2 and @Sno_count <= 4 and @Case_type =2)                          
--begin                          
--select @Sno_count=ISNULL((MAX(SNo)),0)+1 from t_feedback_comment where Feedback_ID=@FeedbackID and Case_no=@Case_no                                 
--insert into t_feedback_comment(SNo,Feedback_ID,UserID,Comment_By,Comment_On,Comments,Case_no) values (@Sno_count,@FeedbackID,@userid,@userid,GETDATE(),@Comments,@Case_no)                                   
--end  

