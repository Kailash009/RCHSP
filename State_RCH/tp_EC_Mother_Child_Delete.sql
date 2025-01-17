USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_EC_Mother_Child_Delete]    Script Date: 09/26/2024 15:43:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[tp_EC_Mother_Child_Delete]              
 @Registration_no bigint,              
 @ReasonForDeletion nvarchar(100),              
 @flag bit,              
 @mother_child varchar(15),            
 @USERID int,          
 @Case_no int,        
 @Module varchar(20)='',        
 @duprank int=0,    
 @Ref_RCH_Id bigint=0,    
 @IsAll bit=0    
         
             
AS              
BEGIN              
if(@Module='Duplicate Entry')        
begin        
if @mother_child='PWEC'  --Delete  ec / mpother    
begin    
    if (@IsAll=0)    
    begin    
      Update t_eligibleCouples set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =GETDATE(),      Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag,Deleted_By=@USERID 
      where Registration_no= @Registration_no  ;
                
      Update t_mother_registration set dup_case_withoutAddr=Case when @flag=0 then  1 else -1 end,
      Delete_mother = @flag,Ref_RCH_Id=Case when @flag=0 then null else @Ref_RCH_Id end,
      ReasonForDeletion =Case when @flag=0 then null else @ReasonForDeletion end,
      DeletedOn =Case when @flag=0 then null else GETDATE() end ,Updated_By= Case when @flag=1 then @USERID end ,         Updated_On=Case when @flag=1 then getdate() end ,Dup_Mother_Delete=@flag,Deleted_By=@USERID 
      where Registration_no= @Registration_no ;         
      --Update t_mother_registration set dup_case_withoutAddr=-1 where dup_rank_withoutAddr=@duprank      
      Update t_children_registration set dup_case_withoutAddr=-1,Delete_mother = @flag,
      ReasonForDeletion =@ReasonForDeletion,DeletedOn =GETDATE(),Updated_By=@USERID,Updated_On=getdate(),
      Deleted_By=@USERID where Mother_Reg_no= @Registration_no;          
         
    end    
    else    
    begin    
      Update t_mother_registration set Ref_RCH_Id= @Ref_RCH_Id where dup_rank_withoutAddr=@duprank 
      and dup_case_withoutAddr=-1  ;
      
      Update t_eligibleCouples set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,
      DeletedOn =GETDATE(),Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag,Deleted_By=@USERID 
      where Registration_no= @Registration_no ;
                 
      Update t_mother_registration set dup_case_withoutAddr=-1,Delete_mother = @flag,Ref_RCH_Id=case 
      when @Registration_no=@Ref_RCH_Id then null else @Ref_RCH_Id end,ReasonForDeletion =case 
      when @Registration_no=@Ref_RCH_Id then null else @ReasonForDeletion end,DeletedOn =case 
      when @Registration_no=@Ref_RCH_Id then null else GETDATE() end,Updated_By=@USERID,
      Updated_On=getdate(),Dup_Mother_Delete=@flag,Deleted_By=@USERID 
      where Registration_no= @Registration_no ;         
        
      Update t_mother_registration set dup_case_withoutAddr=-1 where dup_rank_withoutAddr=@duprank  ;    
 if @Registration_no<>@Ref_RCH_Id    
    
      Update t_children_registration set dup_case_withoutAddr=-1,Delete_mother = @flag,
      ReasonForDeletion =@ReasonForDeletion,DeletedOn =GETDATE(),Updated_By=@USERID,Updated_On=getdate(),
      Deleted_By=@USERID 
      where Mother_Reg_no= @Registration_no ;         
       
    end    
         
  end          
 if @mother_child='PWECUD'  --Un Delete    ec / mpother    
begin      
      if((select COUNT(1) from t_mother_registration(nolock) where dup_rank_withoutAddr=@duprank and dup_case_withoutAddr=-1)=2)    
     begin    
      Update t_eligibleCouples set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag where Registration_no= @Registration_no            
      Update t_mother_registration set dup_case_withoutAddr=case when isnull(dup_rank_withoutAddr,0)>=1 then 1 else null end,Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag 
      ,Ref_RCH_Id=null,DeletedOn=null,Deleted_By=null
      where Registration_no= @Registration_no          
      Update t_mother_registration set dup_case_withoutAddr=1,Ref_RCH_Id=null,DeletedOn=null,Deleted_By=null where dup_rank_withoutAddr=@duprank     
          
      Update t_children_registration set dup_case_withoutAddr=case when isnull(dup_rank_withoutAddr,0)>=1 then 1 else null end, Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Updated_By=@USERID,Updated_On=getdate() where Mother_Reg_no= @Registration_no          
     end    
     else    
     begin    
     update a set dup_case_withoutAddr=1,Ref_RCH_Id=null from t_mother_registration a (nolock) inner join t_mother_registration b (nolock) on a.registration_no=b.Ref_RCH_Id and a.case_no=b.case_no where b.Registration_no= @Registration_no    
     Update t_eligibleCouples set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag where Registration_no= @Registration_no            
     Update t_mother_registration set dup_case_withoutAddr=case when isnull(dup_rank_withoutAddr,0)>=1 then 1 else null end,Ref_RCH_Id=null,Delete_mother = @flag,  
     ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Deleted_By=null,Updated_By=@USERID,Updated_On=getdate(),Dup_Mother_Delete=@flag where Registration_no= @Registration_no          
      --Update t_mother_registration set dup_case_withoutAddr=1 where dup_rank_withoutAddr=@duprank        
           
      Update t_children_registration set dup_case_withoutAddr=case when isnull(dup_rank_withoutAddr,0)>=1 then 1 else null end, Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Updated_By=@USERID,Updated_On=getdate() where Mother_Reg_no= @Registration_no          
    
     end    
     
  end      
     
  if @mother_child='CH'  --Delete child    
begin          
               
      Update t_children_registration set Delete_mother = @flag,Dup_Child_Delete= @flag,Ref_RCH_Id=case 
      when @Registration_no=@Ref_RCH_Id then null else @Ref_RCH_Id end,    
      ReasonForDeletion =case when @Registration_no=@Ref_RCH_Id then null else @ReasonForDeletion end,
      DeletedOn =case when @Registration_no=@Ref_RCH_Id then null else GETDATE() end,Updated_By=@USERID,
      Updated_On=getdate(),Deleted_By=@USERID where Registration_no= @Registration_no;
                
      Update t_children_registration set dup_case_withoutAddr=-1 where dup_rank_withoutAddr=@duprank;    
  end      
   if @mother_child='CHUD'  --Un Delete child    
begin          
             
      Update t_children_registration set Delete_mother = @flag,Dup_Child_Delete= @flag,Ref_RCH_Id=null,ReasonForDeletion =@ReasonForDeletion,DeletedOn =null,Updated_By=@USERID,Updated_On=getdate() where dup_rank_withoutAddr=@duprank and (permanent_delete<>1 or permanent_delete is null)   
      Update t_children_registration set dup_case_withoutAddr=1 where dup_rank_withoutAddr=@duprank and (permanent_delete<>1 or permanent_delete is null)
  end          
end        
else        
begin        
   if @mother_child='PW'            
   begin          
      Update t_mother_registration set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =(Case when @flag=1 then GETDATE() else null end),Updated_By=@USERID,Updated_On=getdate() where Registration_no= @Registration_no and Case_no=@Case_no   and  isnull(Dup_mother_Delete,0)=0        
   end          
   else if @mother_child='EC'          
   begin        
      
      Update t_eligibleCouples set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =(Case when @flag=1 then GETDATE() else null end),Updated_By=@USERID,Updated_On=getdate() where Registration_no= @Registration_no and Case_no=@Case_no    and  isnull(Dup_mother_Delete,0)=0                
      Update t_mother_registration set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =(Case when @flag=1 then GETDATE() else null end),Updated_By=@USERID,Updated_On=getdate() where Registration_no= @Registration_no and Case_no=@Case_no     and  isnull(Dup_mother_Delete,0)=0             
   end          
   else if @mother_child='srcChild'          
   begin          
      Update t_children_registration set Delete_mother = @flag,ReasonForDeletion =@ReasonForDeletion,DeletedOn =(Case when @flag=1 then GETDATE() else null end),Updated_By=@USERID,Updated_On=getdate() where Registration_no= @Registration_no and Case_no=@Case_no  and  isnull(dup_case_withoutAddr,0)!=-1      
   end          
             
 END          
 End 

