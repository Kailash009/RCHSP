USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Eligibleusers]    Script Date: 09/26/2024 12:37:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--Select * from dbo.Get_Eligibleusers(23,7,2986)



ALTER FUNCTION [dbo].[Get_Eligibleusers](@StateCode int,@type int,@MasterID int)
RETURNS @retTCCInformation TABLE 
(
    ID int,
    SubID int,
    EligibleCount int
)
AS 

BEGIN
 if(@type=3)--District
begin
INSERT @retTCCInformation
select A.DIST_CD,0,SUM(isnull(B.EligibleuserD,0)+isnull(C.EligibleuserB,0)+isnull(D.EligibleuserP,0)+isnull(E.EligibleuserS,0)) as EligibleUSer from
(select * from Name_SubFacility a)A
left outer join
(Select COUNT(a.USERID) as EligibleuserD,District_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.District_ID<>0 and a.Healthblock_ID=0
group by District_ID
)B on A.DIST_CD=B.District_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserB,Healthblock_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.Healthblock_ID<>0 and PHC_ID=0
group by Healthblock_ID
)C on A.BLOCK_CD=C.Healthblock_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserP,PHC_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.PHC_ID<>0 and SubCentre_ID=0
group by PHC_ID
)D on A.PHC_CD=D.PHC_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserS,SubCentre_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=C.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.SubCentre_ID<>0 
group by SubCentre_ID
)E on A.SUBPHC_CD=E.SubCentre_ID
Group by A.DIST_CD
	
end
else if(@type=4)--Block
begin
INSERT @retTCCInformation
select A.BLOCK_CD,0,SUM(isnull(B.EligibleuserD,0)+isnull(C.EligibleuserB,0)+isnull(D.EligibleuserP,0)+isnull(E.EligibleuserS,0)) as EligibleUSer from
(select * from Name_SubFacility a where a.DIST_CD=@MasterID)A
left outer join
(Select COUNT(a.USERID) as EligibleuserD,District_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.District_ID<>0 and a.Healthblock_ID=0
group by District_ID
)B on A.DIST_CD=B.District_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserB,Healthblock_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.Healthblock_ID<>0 and PHC_ID=0
group by Healthblock_ID
)C on A.BLOCK_CD=C.Healthblock_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserP,PHC_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.PHC_ID<>0 and SubCentre_ID=0
group by PHC_ID
)D on A.PHC_CD=D.PHC_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserS,SubCentre_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=C.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.SubCentre_ID<>0 
group by SubCentre_ID
)E on A.SUBPHC_CD=E.SubCentre_ID
Group by A.BLOCK_CD
	
end
else if(@type=5)--PHC
begin
INSERT @retTCCInformation
select A.PHC_CD,0,SUM(isnull(B.EligibleuserD,0)+isnull(C.EligibleuserB,0)+isnull(D.EligibleuserP,0)+isnull(E.EligibleuserS,0)) as EligibleUSer from
(select * from Name_SubFacility a  where a.BLOCK_CD=@MasterID)A
left outer join
(Select COUNT(a.USERID) as EligibleuserD,District_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.District_ID<>0 and a.Healthblock_ID=0
group by District_ID
)B on A.DIST_CD=B.District_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserB,Healthblock_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.Healthblock_ID<>0 and PHC_ID=0
group by Healthblock_ID
)C on A.BLOCK_CD=C.Healthblock_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserP,PHC_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.PHC_ID<>0 and SubCentre_ID=0
group by PHC_ID
)D on A.PHC_CD=D.PHC_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserS,SubCentre_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=C.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.SubCentre_ID<>0 
group by SubCentre_ID
)E on A.SUBPHC_CD=E.SubCentre_ID
Group by A.PHC_CD
	
end
else if(@type=6)--SC
begin
INSERT @retTCCInformation
select A.SUBPHC_CD,0,SUM(isnull(B.EligibleuserD,0)+isnull(C.EligibleuserB,0)+isnull(D.EligibleuserP,0)+isnull(E.EligibleuserS,0)) as EligibleUSer from
(select * from Name_SubFacility a where a.PHC_CD=@MasterID)A
left outer join
(Select COUNT(a.USERID) as EligibleuserD,District_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.District_ID<>0 and a.Healthblock_ID=0
group by District_ID
)B on A.DIST_CD=B.District_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserB,Healthblock_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.Healthblock_ID<>0 and PHC_ID=0
group by Healthblock_ID
)C on A.BLOCK_CD=C.Healthblock_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserP,PHC_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.PHC_ID<>0 and SubCentre_ID=0
group by PHC_ID
)D on A.PHC_CD=D.PHC_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserS,SubCentre_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=C.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.SubCentre_ID<>0 
group by SubCentre_ID
)E on A.SUBPHC_CD=E.SubCentre_ID
Group by A.SUBPHC_CD


end
else if(@type=7)--Village
begin
INSERT @retTCCInformation
select A.VILLAGE_CD,A.SUBPHC_CD,SUM(isnull(B.EligibleuserD,0)+isnull(C.EligibleuserB,0)+isnull(D.EligibleuserP,0)+isnull(E.EligibleuserS,0)) as EligibleUSer from
(select * from Name_SCVillage a where a.SUBPHC_CD=@MasterID)A
left outer join
(Select COUNT(a.USERID) as EligibleuserD,District_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.District_ID<>0 and a.Healthblock_ID=0
group by District_ID
)B on A.DIST_CD=B.District_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserB,Healthblock_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.Healthblock_ID<>0 and PHC_ID=0
group by Healthblock_ID
)C on A.BLOCK_CD=C.Healthblock_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserP,PHC_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=c.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.PHC_ID<>0 and SubCentre_ID=0
group by PHC_ID
)D on A.PHC_CD=D.PHC_ID
left outer join
(Select COUNT(a.USERID) as EligibleuserS,SubCentre_ID from User_Master a 
inner join User_Apps b on a.UserID=b.UserID 
inner join User_AppRole c on a.UserID=C.UserID
where a.Status=1 and b.AppID=2 and c.RoleID=4 and a.SubCentre_ID<>0 
group by SubCentre_ID
)E on A.SUBPHC_CD=E.SubCentre_ID
Group by A.VILLAGE_CD,A.SUBPHC_CD
END
    RETURN;
END;
















