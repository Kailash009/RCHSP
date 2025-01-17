USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_ANMId_Duplication_MobileNo]    Script Date: 09/26/2024 12:44:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[Get_ANMId_Duplication_MobileNo]
(@Mobile_No as varchar(10))
Returns varchar(100)
as
Begin
Declare @ANM_Id as varchar(100)
 select @ANM_Id=COALESCE(@ANM_Id+',','')+ cast(ID as varchar) from t_Ground_Staff With(Nolock) where Contact_No=cast(@Mobile_No as varchar) and Is_Active=1
 Return @ANM_Id  
End
