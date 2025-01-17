USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Shift_Insert_HealthBlock_Taluka_Mapping]    Script Date: 09/26/2024 14:51:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Procedure [dbo].[tp_Shift_Insert_HealthBlock_Taluka_Mapping]
(@new_Tcode varchar(7)='',  
@New_BLock varchar(255),  
@New_BID int,  
@New_Dcode int,  
@User_Id int,  
@Ip_Addr varchar(25),  
@msg varchar(99) out  
)
as  
Begin  

Declare @Dcode_Tcode as int,@Old_Tcode as varchar(6)='0',@old_Dcode as int
Select @Old_Tcode=TCode,@old_Dcode=Dcode from Health_Block where BID=@New_BID
Select @Dcode_Tcode=Dcode from All_Taluka where Tcode=@new_Tcode

if(@old_Dcode=@Dcode_Tcode)
begin
set @msg='Both Block and taluka must be from Different District to use this facility'  
end
 
else if not exists(select BID from Shift_Initial_Health_Block_Taluka where BID=@New_BID and New_TCode=@new_Tcode)  
Begin  
insert into Shift_Initial_Health_Block_Taluka(BID,Name,DCode,TCode,New_DCode,New_TCode,Flag,Created_By,Created_on,IP_Address,Insert_Update,Shift_Type)  
values(@New_BID,@New_BLock,@old_Dcode,@Old_Tcode,@New_Dcode,@new_Tcode,0,@User_Id,GETDATE(),@Ip_Addr,1,30)  
set @msg='Mapping saved successfully !!'  
End  
Else  
Begin  
set @msg='Mapping already exists'  
End  
  
End  


