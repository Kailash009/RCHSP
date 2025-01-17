USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_InActive_MotherChild_PNC]    Script Date: 09/26/2024 15:43:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                
                        
                        
--sp_helptext tp_DeliveryDetails_update                        
                        
                          
                          
                          
ALTER PROCEDURE [dbo].[tp_InActive_MotherChild_PNC]                          
(                          
	@Registration_no bigint,                    
	@Case_no int, 
	@UserID int,                      
	@msg nvarchar(200)='' out                        
)                          
as                          
BEGIN                          
SET NOCOUNT ON                           
set @msg='';                     
 declare @msg1 varchar(50) set @msg1=''; 
 declare @msg2 varchar(50) set @msg2=''; 
 BEGIN TRAN
 BEGIN TRY
	 if exists ( select 1 from t_mother_pnc (nolock) where Registration_no=@Registration_no and Case_no=@Case_no )                    
	  begin  
		UPDATE t_mother_pnc SET PNC_Type=0,PNC_Date='1990-01-01',Updated_On=GETDATE(),Updated_By=@UserID where Registration_no=@Registration_no and Case_no=@Case_no                  
		set @msg1='Mother PNC'                    
	  end                                 
	  
	  if exists ( select 1 from t_child_pnc (nolock) where Registration_no=@Registration_no and Case_no=@Case_no )                    
	  begin  
		UPDATE t_child_pnc SET PNC_Type=0, PNC_Date='1990-01-01',Updated_On=GETDATE(),Updated_By=@UserID where Registration_no=@Registration_no and Case_no=@Case_no                  
		set @msg2='Child PNC '                    
	  end
	COMMIT TRANSACTION 
	set @msg = @msg1 + (case when @msg1<>'' and @msg2<>'' then ' and ' else '' end) + @msg2 +'has been successfully deactived.'   
	END TRY    
	BEGIN CATCH    
		  -- if error, roll back any chanegs done by any of the sql statements     
		  SELECT ERROR_NUMBER() AS ErrorNumber    
		  SELECT ERROR_MESSAGE() AS ErrorMessage     
		  ROLLBACK TRANSACTION    
	END CATCH
 END
