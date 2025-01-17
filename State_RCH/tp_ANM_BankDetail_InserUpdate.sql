USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_ANM_BankDetail_InserUpdate]    Script Date: 09/26/2024 12:19:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
    
ALTER procedure [dbo].[tp_ANM_BankDetail_InserUpdate]            
(                  
@GF_ID int=0,       --Changed by Sneha 14062017         
@Aadhar_No numeric(12,0)= null,             
@AadhaarLinked bit=0,                 
@AccNo varchar(20)= null,                  
@BankID int = null,                 
@BranchName nvarchar(200)= null,                    
@IFSCCode varchar(15)= null,               
@msg varchar(200) out,            
@Mobile_no nvarchar(10),          
@IsMobileChanged int=0 ,  
@IP_address varchar(25) ='0',   --Changed by Sneha 24102017     
@UserID int=0 --Changed by Sneha 24102017   
)                  
as                
                
begin                  
              
   update t_Ground_Staff set 
   --Aadhar_No=@Aadhar_No,    done by jyoti
   AadhaarLinked=@AadhaarLinked,AccNo=@AccNo,BankID=@BankID,IFSCCode=@IFSCCode,BranchName=@BranchName,  
   --Contact_No=@Mobile_no,IsValidated=@IsMobileChanged   ,CPSMS_Flag=3,   --Changed by Sneha 14062017 
       
   Updated_On=GETDATE(),Updated_By=@UserID   --Changed by Sneha 24102017     
   ,IP_Address= @IP_address  
   where ID=@GF_ID                 
   set @msg='Record Updated Successfully'             
                
end                
                
 IF (@@ERROR <> 0)                    
 BEGIN                    
  RAISERROR ('TRANSACTION FAILED',16,-1)                    
  ROLLBACK TRANSACTION                    
                    
 END    
  
  
    