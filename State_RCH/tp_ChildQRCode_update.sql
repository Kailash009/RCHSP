USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_ChildQRCode_update]    Script Date: 09/26/2024 15:27:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  ALTER proc [dbo].[tp_ChildQRCode_update]          
(          
        
 @Registration_no bigint out     
 ,@Mother_Reg_no bigint        
,@Case_no int       
,@QRcode VARCHAR(20)=NULL       
,@IP_address varchar(25)          
,@Created_By int          
,@msg nvarchar(200) out          
          
)          
as          
SET NOCOUNT ON          
set @msg='';          
if exists (select Registration_no from t_children_registration WITH(NOLOCK) where Registration_no=@Registration_no )          
begin          
 update t_children_registration set QRcode=@QRcode,IP_address=@IP_address,Updated_By=@Created_By          
 ,QRcode_updated_on=GETDATE() where Registration_no=@Registration_no        
      
 set @msg = 'Record Update Successfully !!!'          
end          
else          
begin          
 set @msg = 'Record Not Exists !!!'          
end 

