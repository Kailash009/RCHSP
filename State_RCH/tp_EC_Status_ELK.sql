USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_EC_Status_ELK]    Script Date: 09/26/2024 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure[dbo].[tp_EC_Status_ELK]
(@MctsID varchar(18)='0'        
,@Registration_no bigint =0)  
as    
   SET NOCOUNT OFF;
     if exists(Select Registration_no from t_eligibleCouples_Status (nolock) where  ((Registration_no=@Registration_no or ID_No = @MctsID) and (Status = 'I' or Status = 'N')))            
        begin              
      select Status from t_eligibleCouples_Status (nolock)  where (Registration_no=@Registration_no or ID_No = @MctsID) and (Status = 'I' or Status = 'N')             
        end 
        