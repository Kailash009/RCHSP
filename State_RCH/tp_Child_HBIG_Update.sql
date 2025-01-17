USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Child_HBIG_Update]    Script Date: 09/26/2024 15:27:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
       
ALTER Proc [dbo].[tp_Child_HBIG_Update]         
(       
@Registration_no bigint,
@HBIG_Date date =null,
@IP_address varchar(25),          
@Updated_By int,       
@Flag int=0 out
)
AS          
BEGIN 
 IF EXISTS (SELECT Registration_No FROM t_children_registration WHERE Registration_no = @Registration_No)            
  BEGIN    
        UPDATE t_children_registration set  
	    HBIG_Date=@HBIG_Date,        
        Updated_by=@Updated_By,        
        Updated_On=GETDATE(), 
		IP_address=@IP_address
		WHERE Registration_no=@Registration_no

        SET @Flag=1  
   END
END        
IF (@@ERROR <> 0)          
BEGIN          
     RAISERROR ('TRANSACTION FAILED',16,-1)          
     ROLLBACK TRANSACTION          
END          

