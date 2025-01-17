USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_MotherQRCode_update]    Script Date: 09/26/2024 14:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------  
ALTER proc [dbo].[tp_MotherQRCode_update]      
(      
    
 @Registration_no bigint out      
,@Case_no int   
,@QRcode VARCHAR(20)=NULL   
,@IP_address varchar(25)      
,@Created_By int      
,@msg nvarchar(200) out      
      
)      
as      
SET NOCOUNT ON      
set @msg='';      
if exists (select 1 from t_mother_registration (nolock) where Registration_no=@Registration_no and Case_no=@Case_no  )      
begin      
 update t_mother_registration set QRcode=@QRcode,IP_address=@IP_address,Updated_By=@Created_By      
 ,QRcode_updated_on=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no      
  
 set @msg = 'Record Update Successfully !!!'      
end      
else      
begin      
 set @msg = 'Record Not Exists !!!'      
end   
  
