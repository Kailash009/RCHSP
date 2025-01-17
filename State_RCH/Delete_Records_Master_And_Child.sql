USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Records_Master_And_Child]    Script Date: 09/26/2024 15:26:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/*  
Delete_Records_Master_And_Child 1,5,21,17,'0',0,0,0,''  
*/  
ALTER Procedure [dbo].[Delete_Records_Master_And_Child]  
(  
@Heirarchy as int=0,  
@ID as int,  
@StateID as int,  
@District_ID as int=0,  
@Taluka_ID as varchar(6)=null,  
@HealthBlock_ID as int=0,  
@PHC_ID as int=0,  
@SubCentre_ID as int=0,  
@Msg as nvarchar(300) out  
)  
as  
Begin  
Declare @PHC_Count as int=0,  
@HB_Taluka_Count as int=0,  
@SubCentre_Count as int=0,  
@Villages_Mapped as nvarchar(10)='0',  
@Mother_Record as int=0,  
@Child_Record as int=0,  
@Ground_Staff as int=0,  
@verified_Records as int=0,  
@Db as char(2)  
,@S1 as nvarchar(500)=null  
  
if(@StateID <=9)  
set @db ='0'+CAST(@StateID as varchar)  
else  
set @db =CAST(@StateID as varchar)  
  
  
If(@Heirarchy=1)--Block  
Begin  
  
Select @HB_Taluka_Count=COUNT(TCode) from Health_Block_Taluka where BID=@ID  
Select @PHC_Count=COUNT(PHC_CD) from TBL_PHC where BID=@ID  
select @SubCentre_Count=COUNT(SUBPHC_CD) from TBL_SUBPHC where PHC_CD in (select PHC_CD from TBL_PHC where BID =@ID)  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where SID in (select SID from ComAdmin_'+@db+'.dbo.Health_SubCentre where PID in (Select PID from ComAdmin_'+@db+'.dbo.Health_PHC where BID='+CAST(@ID as varchar)+'
))'  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and HealthBlock_ID =@ID   
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and HealthBlock_ID =@ID   
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID and HealthBlock_ID =@ID   
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and HealthBlock_ID =@ID   
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0 or @PHC_Count<>0 or @SubCentre_Count<>0 or @Villages_Mapped<>'0')  
Begin  
set @Msg='It has '   
+ CAST(@HB_Taluka_Count as varchar) + ' Taluka,'  
+ CAST(@PHC_Count as varchar) + ' PHCs,'  
+ CAST(@SubCentre_Count as varchar) + ' Health SubCentres,'  
+ CAST(@Villages_Mapped as varchar) + ' Villages Mapped,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this Health Block. To Delete this Health Block delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
If(@Heirarchy=2)--Block Taluka  
Begin  
  
Select @HB_Taluka_Count=COUNT(TCode) from Health_Block_Taluka where BID=@ID and TCode =@Taluka_ID  
Select @PHC_Count=COUNT(PHC_CD) from TBL_PHC where BID=@ID and TAL_CD =@Taluka_ID  
select @SubCentre_Count=COUNT(SUBPHC_CD) from TBL_SUBPHC where PHC_CD in (select PHC_CD from TBL_PHC where BID =@ID and TAL_CD =@Taluka_ID)  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where SID in (select SID from ComAdmin_'+@db+'.dbo.Health_SubCentre where PID in (Select PID from ComAdmin_'+@db+'.dbo.Health_PHC where BID='+CAST(@ID as varchar)+'
) and Tcode='''+CAST(@Taluka_ID as varchar)+''')'  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@ID   
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@ID   
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID  and Taluka_ID =@Taluka_ID and HealthBlock_ID =@ID   
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@ID   
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0 or @PHC_Count<>0 or @SubCentre_Count<>0 or @Villages_Mapped<>'0')  
Begin  
set @Msg='It has '   
+ CAST(@HB_Taluka_Count as varchar) + ' Taluka,'  
+ CAST(@PHC_Count as varchar) + ' PHCs,'  
+ CAST(@SubCentre_Count as varchar) + ' Health SubCentres,'  
+ CAST(@Villages_Mapped as varchar) + ' Villages Mapped,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this Health Block . To Delete this Health Block Taluka mapping, delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
If(@Heirarchy=3)--PHC  
Begin  
  
  
select @SubCentre_Count=COUNT(SUBPHC_CD) from TBL_SUBPHC where PHC_CD in (select PHC_CD from TBL_PHC where PHC_CD=@ID and TAL_CD =@Taluka_ID and DIST_CD =@District_ID)  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where SID in (select SID from ComAdmin_'+@db+'.dbo.Health_SubCentre where PID in (Select PID from ComAdmin_'+@db+'.dbo.Health_PHC where PID='+CAST(@ID as varchar)+'
))'  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@ID  
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@ID  
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID  and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@ID  
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@ID  
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0 or @SubCentre_Count<>0 or @Villages_Mapped<>'0')  
Begin  
set @Msg='It has '   
+ CAST(@SubCentre_Count as varchar) + ' Health SubCentres,'  
+ CAST(@Villages_Mapped as varchar) + ' Villages Mapped,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this HealthFacility. To Delete this HealthFacility delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
If(@Heirarchy=4)--SubCentre  
Begin  
  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where SID in (select SID from ComAdmin_'+@db+'.dbo.Health_SubCentre where SID ='+CAST(@ID as varchar)+')'  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@ID  
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@ID  
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID  and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@ID  
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@ID  
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0 or @Villages_Mapped<>'0')  
Begin  
set @Msg='It has '   
+ CAST(@Villages_Mapped as varchar) + ' Villages Mapped,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this SubCentre .To Delete this SubCentre delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
If(@Heirarchy=5)--Village  
Begin  
  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where Vcode ='+CAST(@ID as varchar)+''  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@SubCentre_ID and Village_ID=@ID  
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@SubCentre_ID and Village_ID=@ID  
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID  and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@SubCentre_ID and Village_ID=@ID  
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and Taluka_ID =@Taluka_ID and HealthBlock_ID =@HealthBlock_ID  and PHC_ID =@PHC_ID and SubCentre_ID=@SubCentre_ID and Village_ID
=@ID  
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0)  
Begin   
set @Msg='It has '   
+ CAST(@Villages_Mapped as varchar) + ' SC Mapped with this Village,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this Village .To Delete this Village delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
If(@Heirarchy=6)--SubVillage  
Begin  
  
  
set @S1='select @Villages_Mapped1=COUNT(Vcode) from ComAdmin_'+@db+'.dbo.Health_SC_Village where Vcode ='+CAST(@ID as varchar)+''  
EXEC sp_executesql @S1, N'@Villages_Mapped1 varchar(10) output', @Villages_Mapped1=@Villages_Mapped output  
  
  
select @Mother_Record=COUNT(ID_no) from dbo.NRHM_Format_mother where StateID =@StateID and  District_ID=@District_ID and (Taluka_ID =@Taluka_ID or @Taluka_ID='0') and Village_ID=@ID  
select @Child_Record=COUNT(ID_no) from dbo.NRHM_Format_Child where StateID =@StateID and  District_ID=@District_ID and (Taluka_ID =@Taluka_ID or @Taluka_ID='0') and Village_ID=@ID  
select @Ground_Staff=COUNT(ID) from dbo.Ground_Staff where  District_ID=@District_ID  and (Taluka_ID =@Taluka_ID or @Taluka_ID='0') and Village_ID=@ID  
select @verified_Records=COUNT(ID_No) from dbo.MotherEntry_Verification where StateID =@StateID and  District_ID=@District_ID and (Taluka_ID =@Taluka_ID or @Taluka_ID='0') and Village_ID=@ID  
  
if(@Mother_Record<>0 or @Child_Record<>0 or @Ground_Staff<>0 or @verified_Records<>0 or @Villages_Mapped<>'0')  
Begin  
set @Msg='It has '   
+ CAST(@Villages_Mapped as varchar) + ' SC Mapped with this Village,'  
+ CAST(@Mother_Record as varchar) + ' Mothers,'  
+ CAST(@Child_Record as varchar) + ' Childrens,'  
+ CAST(@Ground_Staff as varchar) + ' HealthProviders/Asha,'  
+ CAST(@verified_Records as varchar) + ' Verified Records,'  
+'Under this Village .To Delete this Village delete its Child Records First from MCTS and then from CM.'  
  
end  
else  
begin  
set @msg='No Child Records are there in MCTS'  
end  
end  
  
  
Return  
end  




