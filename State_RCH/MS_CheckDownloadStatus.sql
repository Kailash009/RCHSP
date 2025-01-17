USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_CheckDownloadStatus]    Script Date: 09/26/2024 12:13:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[MS_CheckDownloadStatus]        
@UserID int=0,    
@MobileNo VARCHAR(12)=null    
AS        
BEGIN      
 IF(@MobileNo<>null or @MobileNo <>'')     
   BEGIN    
   IF EXISTS(SELECT id from t_ground_staff  where id=@UserID and Contact_No=@MobileNo)          
   BEGIN         
    select 1 as Status          
   END          
   ELSE        
   BEGIN        
    select 0 as Status          
   END      
 END    
 else    
  BEGIN    
   IF EXISTS(SELECT id from t_ground_staff  where id=@UserID  and OTP_flag =1)          
   BEGIN         
    select 1 as Status          
   END          
 ELSE        
   BEGIN        
    select 0 as Status          
   END        
 END    
END 

