USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_Beneficiary_Data]    Script Date: 09/26/2024 12:13:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[MS_Get_Beneficiary_Data]
(
@Type_ID as int,
@Regd_no varchar(18)
)
as
Begin
if(@Type_ID=0)  --Get Data by MCTS ID
Begin
select ID_No as ID,Name_wife as Name,Wife_current_age as Current_Age,Wife_marry_age as Marriage_Age,Name_husband as HusbandName,Hus_current_age as Husband_CurrentAge,Hus_marry_age as  Husband_MarriageAge,Address as Benficairy_Address
,Address,Case_no from t_eligibleCouples  where ID_No=@Regd_no
End

Else If(@Type_ID=1)  --Get data by RCH ID
Begin
select Registration_no as ID,Name_wife as Name,Wife_current_age as Current_Age,Wife_marry_age as Marriage_Age,Name_husband as HusbandName,Hus_current_age as Husband_CurrentAge,Hus_marry_age as  Husband_MarriageAge,Address as Benficairy_Address
,Address from t_eligibleCouples  where Registration_no=@Regd_no
End

Else if(@Type_ID=2) --Get data by MCTS Child ID
Begin
select ID_No as ID,Name_Child as Name,Name_Father as FatherName,Name_Mother as MotherName,Address as Benficairy_Address 
from t_children_registration where ID_No=@Regd_no
End

ELSE IF(@Type_ID=3) --Get data by RCH CHILD
Begin
select Registration_no as ID,Name_Child as Name,Name_Father as FatherName,Name_Mother as MotherName,Address as Benficairy_Address  
from t_children_registration where Registration_no=@Regd_no
End

End

