USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[OTP_Get_Mob_No]    Script Date: 09/26/2024 12:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  
/* 9881286941, 8805835227 -- update t_eligibleCouples set Mobile_no='9910880739' where Registration_no=130000000002  
OTP_Get_Mob_No '281149201211400121'  
OTP_Get_Mob_No '204000000001'
OTP_Get_Mob_No '292000007266' 
OTP_Get_Mob_No '281309001421100001' 
*/  
  
ALTER proc [dbo].[OTP_Get_Mob_No]  
(  
@Registration_no varchar(25)  
)  
as  
begin  
	declare @RCHnMCTS_ID_No as varchar(25),@IsMother_Child int
	if(LEN(@Registration_no) = 12)
		set @IsMother_Child = LEFT(@Registration_no, 1)
	else
		set @IsMother_Child = Substring(@Registration_no, 11,1)
	
if( @IsMother_Child = 1)
begin
	if(LEN(@Registration_no) > 12)
	begin
		set @RCHnMCTS_ID_No = 'ID_No'
		select Registration_no,Mobile_no,Mobile_Of,Case_no from m_Registration_Mobile_M where ID_No=@Registration_no 
	end
	else
	begin
		select Registration_no,Mobile_no,Mobile_Of,Case_no from m_Registration_Mobile_M where Registration_no=@Registration_no  
	end
end
else
begin
	if(LEN(@Registration_no) > 12)
	begin
		set @RCHnMCTS_ID_No = 'ID_No'
		select Registration_no,Mobile_no,Mobile_Of as Whose_mobile,0 as case_no from m_Registration_Mobile_C where ID_No=@Registration_no 
	end
	else
	begin
		select Registration_no,Mobile_no,Mobile_Of as Whose_mobile,0 as case_no from m_Registration_Mobile_C where Registration_no=@Registration_no 

	end
end	
	
end  
  
  


