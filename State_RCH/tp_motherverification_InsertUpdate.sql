USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_motherverification_InsertUpdate]    Script Date: 09/26/2024 12:29:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[tp_motherverification_InsertUpdate]                    
(                    
     @Registration_no bigint,                                 
     @Remark nvarchar(250),                    
     @Call_Ans bit=0,                    
     @IsPhoneNoCorrect bit=0,                    
     @VerifierID int,                    
     @NoCall_Reason smallint = 0,                    
     @NoPhone_Reason smallint = 0,                    
     @State_Code smallint,                    
     @District_Code  int,                    
     @Taluka_Code varchar(6),                    
     @HealthBlock_Code int,                    
     @HealthFacility_Code int,                    
     @HealthSubFacility_Code int,                    
     @Village_Code int,            
     @Case_No int,                
     @Verify_TypeID int,  
     @USERID as int=0, 
     @Mobile_No varchar(10)   
)                     
AS                    
begin                    
                    
     if not exists (select * from t_MotherEntry_Verification where Registration_no=@Registration_no and Case_No=@Case_No and Mobile_No=@Mobile_No)                     
          begin                     
          Insert into t_MotherEntry_Verification(Registration_no,VerifyDt,Remark,Call_Ans,IsPhoneNoCorrect,                    
          VerifierID,NoCall_Reason,NoPhone_Reason,State_Code,District_Code,Taluka_Code,HealthBlock_Code,HealthFacility_Code,HealthSubFacility_Code,Village_Code,Case_No,Verify_TypeID,Mobile_No,is_verified)                     
          Select @Registration_no,GETDATE(),@Remark,@Call_Ans,@IsPhoneNoCorrect,@VerifierID,@NoCall_Reason,@NoPhone_Reason,                    
          MR.State_Code,MR.District_Code,MR.Taluka_Code,MR.HealthBlock_Code,MR.HealthFacility_Code,MR.HealthSubFacility_Code,MR.Village_Code,MR.Case_no,@Verify_TypeID,MR.Mobile_No,1 
          from t_mother_registration MR 
          left join t_MotherEntry_Verification v on MR.Registration_no=v.Registration_no and MR.Case_no =v.Case_no and MR.Mobile_No=v.Mobile_No 
		  where MR.Registration_no=@Registration_no and MR.Mobile_No=@Mobile_No and v.Case_no is null 
          end       
     else                    
          begin                    
          if exists (select * from t_MotherEntry_Verification where Registration_no=@Registration_no and Case_No=@Case_No and Call_Ans=@Call_Ans and IsPhoneNoCorrect=@IsPhoneNoCorrect and Call_Ans=1 and IsPhoneNoCorrect=1 and Mobile_No=@Mobile_No
)         
  begin                   
   update t_MotherEntry_Verification set Is_Confirm=1,Updated_On=GETDATE(),Updated_By=@USERID where Registration_no=@Registration_no and case_no=@Case_No and Mobile_No=@Mobile_No    
  end        
  else                              
  begin                    
    update t_MotherEntry_Verification set VerifyDt=GETDATE(),Remark=@Remark,Call_Ans=@Call_Ans,IsPhoneNoCorrect=@IsPhoneNoCorrect,                    
    VerifierID=@VerifierID,NoCall_Reason=@NoCall_Reason,NoPhone_Reason=@NoPhone_Reason                    
    where Registration_no=@Registration_no and case_no=@Case_No and Mobile_No=@Mobile_No                   
  end                 
 end                    
 RETURN                    
END                    
     IF (@@ERROR <> 0)                    
        BEGIN                    
             RAISERROR ('TRANSACTION FAILED',16,-1)                    
             ROLLBACK TRANSACTION                    
          END
          
