USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_user_Master_Select]    Script Date: 09/26/2024 14:52:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[tp_user_Master_Select] 347,'','','','','','','',0,0,0,0,'0',0,0,0,3
*/
ALTER procedure [dbo].[tp_user_Master_Select]
(@LoginID as int=0,
@Login_Name as varchar(99)='',
@FirstName as varchar(99)='',
@MiddleName as varchar(99)='',
@LastName as varchar(99)='',
@EmailID as varchar(99)='',
@UserAddress as varchar(99)='',
@PhoneNo as varchar(15)='',
@UserType as int=0,
@UserStatus as int=0,
@StateID as int=0,
@District_ID as int=0,
@Taluka_ID as varchar(6)='0',
@HealthBlock_ID as int=0,
@PHC_ID as int=0,
@SubCentre_ID as int=0,
@SectionID as int=1,
@SessionTypeID as int=1
)
as
begin
if(@SectionID=1)--CreateUser
begin
select a.UserID as LoginID,USER_NAME as LoginName,First_Name as FName,Middle_Name as MName,Last_Name as LName,EMail as EmailID,Current_Address as UserAddress
,Phone as PhoneNo,TypeID as UserType,Status as UserStatus,StateID as State_Code,District_ID as District_Code,Taluka_ID as Taluka_Code
,Healthblock_ID as HealthBlock_Code,PHC_ID as Healthfacility_Code,SubCentre_ID  as Healthsubfacility_Code,dbo.[GetUserRoleName](a.UserID) as Roles,dbo.[GetuserApps](a.UserID) as Apps ,0 as AppID,0 as RoleID
from User_Master a
where (a.UserID=@LoginID or @LoginID=0)
and (a.User_Name=@Login_Name or @Login_Name='')
and (First_Name=@FirstName or @FirstName='')
and (Middle_Name=@MiddleName or @MiddleName='')
and (Last_Name=@LastName or @LastName='')
and (EMail=@EmailID or @EmailID='')
and (Current_Address=@UserAddress or @UserAddress='')
and (Phone=@PhoneNo or @PhoneNo='')
and (TypeID=@UserType or @UserType=0)
and (Status=@UserStatus or @UserStatus=0)
and (StateID=@StateID or @StateID=0)
and (District_ID=@District_ID or @District_ID=0)
and (Taluka_ID=@Taluka_ID or @Taluka_ID='0')
and (Healthblock_ID=@HealthBlock_ID or @HealthBlock_ID=0)
and (PHC_ID=@PHC_ID or @PHC_ID=0)
and (SubCentre_ID=@SubCentre_ID or @SubCentre_ID=0)
and a.TypeID>(case when @SessionTypeID=1 then 0 when @SessionTypeID=2 then 1  else @SessionTypeID end)
and a.UserID<>(case when @SessionTypeID=2 then 1 else 0 end)
end
else if(@SectionID=2)--AssignRoles
begin
select a.UserID as LoginID,USER_NAME as LoginName,First_Name as FName,Middle_Name as MName,Last_Name as LName,EMail as EmailID,Current_Address as UserAddress
,Phone as PhoneNo,TypeID as UserType,Status as UserStatus,StateID as State_Code,District_ID as District_Code,Taluka_ID as Taluka_Code
,Healthblock_ID as HealthBlock_Code,PHC_ID as Healthfacility_Code,SubCentre_ID  as Healthsubfacility_Code ,c.RoleName as Roles,dbo.[GetuserApps](a.UserID) as Apps,0 as AppID,b.RoleID as RoleID
from User_Master a
inner join  User_AppRole b on a.UserID=b.UserID
inner join  RCH_National_Level.dbo.m_Roles c on b.RoleID=c.RoleID
where (a.UserID=@LoginID or @LoginID=0)


end
else if(@SectionID=3)--AssignApplication
begin
select a.UserID as LoginID,USER_NAME as LoginName,First_Name as FName,Middle_Name as MName,Last_Name as LName,EMail as EmailID,Current_Address as UserAddress
,Phone as PhoneNo,TypeID as UserType,Status as UserStatus,StateID as State_Code,District_ID as District_Code,Taluka_ID as Taluka_Code
,Healthblock_ID as HealthBlock_Code,PHC_ID as Healthfacility_Code,SubCentre_ID  as Healthsubfacility_Code ,dbo.[GetUserRoleName](a.UserID) as Roles,c.AppName as Apps,c.AppID,0 as RoleID
from User_Master a
inner join  User_Apps b on a.UserID=b.UserID
inner join  Application c on b.AppID=c.AppID
where (a.UserID=@LoginID or @LoginID=0)
and c.ID<=3


end

end


