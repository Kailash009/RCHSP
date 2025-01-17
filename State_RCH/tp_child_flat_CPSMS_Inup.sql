USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_child_flat_CPSMS_Inup]    Script Date: 09/26/2024 15:44:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[tp_child_flat_CPSMS_Inup]
(@Immucode int)

as
begin
truncate table d_CPSMS


if(@Immucode=1)--BCG
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.BCG_Dt is  null

end
else if(@Immucode=2)--OPV0
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.OPV0_Dt is  null


end
else if(@Immucode=3)--OPV1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.OPV1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=4)--OPV2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.OPV2_Dt is  null


----where t.MinDate is not null

end
else if(@Immucode=5)--OPV3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.OPV3_Dt is  null


end
else if(@Immucode=6)--OPVB
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.OPVBooster_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=7)--DPT1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.DPT1_Dt is  null

--where t.MinDate is not null

end
else if(@Immucode=8)--DPT2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.DPT2_Dt is  null



--where t.MinDate is not null

end
else if(@Immucode=9)--DPT3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.DPT3_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=10)--DPTB1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.DPTBooster1_Dt is  null

--where t.MinDate is not null

end
else if(@Immucode=11)--DPTB2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.DPTBooster2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=12)--HEB0
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.HepatitisB0_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=13)--HEB1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.HepatitisB1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=14)--HEB2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.HepatitisB2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=15)--HEB3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.HepatitisB3_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=16)--Penta1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Penta1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=17)--Penta2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Penta2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=18)--Penta3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Penta3_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=19)--Measles1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Measles1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=20)--Measles2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Measles2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=21)--JE1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.JE1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=22)--JE2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.JE2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=23)--Vitamin1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=24)--Vitamin2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=25)--Vitamin3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose3_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=26)--Vitamin4
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose4_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=27)--Vitamin5
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose5_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=28)--Vitamin6
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose6_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=29)--Vitamin7
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose7_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=30)--Vitamin8
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose8_Dt is  null

--where t.MinDate is not null

end
else if(@Immucode=31)--Vitamin9
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitA_Dose9_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=33)--MR
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.MR_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=36)--Vitamin K
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.VitK_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=35)--Rota1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Rota_Virus_Dt is  null



--where t.MinDate is not null

end
else if(@Immucode=37)--Rota2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Rota_Dose2_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=38)--Rota3
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.Rota_Dose3_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=39)--IPV1
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.IPV_Dose1_Dt is  null


--where t.MinDate is not null

end
else if(@Immucode=40)--IPV2
begin
insert into d_CPSMS
select a.Registration_no,0 from t_children_tracking a
left outer join t_child_flat b on a.Registration_no=b.Registration_no 
 where Convert(date,a.Created_On)<>'2017-08-11' and a.Immu_code<>0 and a.Immu_code=@Immucode
 and b.IPV_Dose2_Dt is  null

--where t.MinDate is not null

end
else if(@Immucode=0)
begin


update t_child_flat set 
[Reason_closure]=X.Child0_Reason_closure
,[Death_reason]=X.Child0_Death_reason
,[DeathPlace]=X.Child0_DeathPlace
,[DeathDate]=X.[Child0_DeathDate]
,[Case_closure]=X.Child0_Case_closure
,[BCG_Dt]=X.Child1_Date,[BCG_ANM_ID]=X.Child1_ANM_ID,[BCG_ASHA_ID]=X.Child1_ASHA_ID,[BCG_Source_ID]=X.Child1_Source,[BCG_ImmuSource_ID]=X.[Child1_Immu_Source]
,[OPV0_Dt]=X.Child2_Date,[OPV0_ANM_ID]=X.Child2_ANM_ID,[OPV0_ASHA_ID]=X.Child2_ASHA_ID,[OPV0_Source_ID]=X.Child2_Source,[OPV0_ImmuSource_ID]=X.Child2_Immu_Source
,[OPV1_Dt]=X.Child3_Date,[OPV1_ANM_ID]=X.Child3_ANM_ID,[OPV1_ASHA_ID]=X.Child3_ASHA_ID,[OPV1_Source_ID]=X.Child3_Source,[OPV1_ImmuSource_ID]=X.Child3_Immu_Source
,[OPV2_Dt]=X.Child4_Date,[OPV2_ANM_ID]=X.Child4_ANM_ID ,[OPV2_ASHA_ID]=X.Child4_ASHA_ID,[OPV2_Source_ID]=X.Child4_Source,[OPV2_ImmuSource_ID]=X.Child4_Immu_Source
,[OPV3_Dt]=X.Child5_Date,[OPV3_ANM_ID]=X.Child5_ANM_ID,[OPV3_ASHA_ID]=X.Child5_ASHA_ID,[OPV3_Source_ID]=X.Child5_Source,[OPV3_ImmuSource_ID]=X.Child5_Immu_Source
,[OPVBooster_Dt]=X.Child6_Date,[OPVBooster_ANM_ID]=X.Child6_ANM_ID,[OPVBooster_ASHA_ID]=X.Child6_ASHA_ID,[OPVBooster_Source_ID]=X.Child6_Source,[OPVBooster_ImmuSource_ID]=X.Child6_Immu_Source
,[DPT1_Dt]=X.Child7_Date,[DPT1_ANM_ID]=X.Child7_ANM_ID,[DPT1_ASHA_ID]=X.Child7_ASHA_ID,[DPT1_Source_ID]=X.Child7_Source,[DPT1_ImmuSource_ID]=X.Child7_Immu_Source
,[DPT2_Dt]=X.Child8_Date,[DPT2_ANM_ID]=X.Child8_ANM_ID,[DPT2_ASHA_ID]=X.Child8_ASHA_ID,[DPT2_Source_ID]=X.Child8_Source,[DPT2_ImmuSource_ID]=X.Child8_Immu_Source
,[DPT3_Dt]=X.Child9_Date,[DPT3_ANM_ID]=X.Child9_ANM_ID,[DPT3_ASHA_ID]=X.Child9_ASHA_ID,[DPT3_Source_ID]=X.Child9_Source,[DPT3_ImmuSource_ID]=X.Child9_Immu_Source
,[DPTBooster1_Dt]=X.Child10_Date,[DPTBooster1_ANM_ID]=X.Child10_ANM_ID,[DPTBooster1_ASHA_ID]=X.Child10_ASHA_ID,[DPTBooster1_Source_ID]=X.Child10_Source,[DPTBooster1_ImmuSource_ID]=X.Child10_Immu_Source

,[DPTBooster2_Dt]=X.Child11_Date,[DPTBooster2_ANM_ID]=X.Child11_ANM_ID,[DPTBooster2_ASHA_ID]=X.Child11_ASHA_ID,[DPTBooster2_Source_ID]=X.Child11_Source,[DPTBooster2_ImmuSource_ID]=X.Child11_Immu_Source
,[HepatitisB0_Dt]=X.Child12_Date,[HepatitisB0_ANM_ID]=X.Child12_ANM_ID,[HepatitisB0_ASHA_ID]=X.Child12_ASHA_ID,[HepatitisB0_Source_ID]=X.Child12_Source,[HepatitisB0_ImmuSource_ID]=X.Child12_Immu_Source
,[HepatitisB1_Dt]=X.Child13_Date,[HepatitisB1_ANM_ID]=X.Child13_ANM_ID,[HepatitisB1_ASHA_ID]=X.Child13_ASHA_ID,[HepatitisB1_Source_ID]=X.Child13_Source,[HepatitisB1_ImmuSource_ID]=X.Child13_Immu_Source
,[HepatitisB2_Dt]=X.Child14_Date,[HepatitisB2_ANM_ID]=X.Child14_ANM_ID,[HepatitisB2_ASHA_ID]=X.Child14_ASHA_ID,[HepatitisB2_Source_ID]=X.Child14_Source,[HepatitisB2_ImmuSource_ID]=X.Child14_Immu_Source
,[HepatitisB3_Dt]=X.Child15_Date,[HepatitisB3_ANM_ID]=X.Child15_ANM_ID,[HepatitisB3_ASHA_ID]=X.Child15_ASHA_ID,[HepatitisB3_Source_ID]=X.Child15_Source,[HepatitisB3_ImmuSource_ID]=X.Child15_Immu_Source
,[Penta1_Dt]=X.Child16_Date,[Penta1_ANM_ID]=X.Child16_ANM_ID,[Penta1_ASHA_ID]=X.Child16_ASHA_ID,[Penta1_Source_ID]=X.Child16_Source ,[Penta1_ImmuSource_ID]=X.Child16_Immu_Source
,[Penta2_Dt]=X.Child17_Date,[Penta2_ANM_ID]=X.Child17_ANM_ID,[Penta2_ASHA_ID]=X.Child17_ASHA_ID,[Penta2_Source_ID]=X.Child17_Source ,[Penta2_ImmuSource_ID]=X.Child17_Immu_Source
,[Penta3_Dt]=X.Child18_Date,[Penta3_ANM_ID]=X.Child18_ANM_ID,[Penta3_ASHA_ID]=X.Child18_ASHA_ID,[Penta3_Source_ID]=X.Child18_Source ,[Penta3_ImmuSource_ID]=X.Child18_Immu_Source
,[Measles1_Dt]=X.Child19_Date,[Measles1_ANM_ID]=X.Child19_ANM_ID,[Measles1_ASHA_ID]=X.Child19_ASHA_ID,[Measles1_Source_ID]=X.Child19_Source ,[Measles1_ImmuSource_ID]=X.Child19_Immu_Source

,[Measles2_Dt]=X.Child20_Date,[Measles2_ANM_ID]=X.Child20_ANM_ID,[Measles2_ASHA_ID]=X.Child20_ASHA_ID,[Measles2_Source_ID]=X.Child20_Source ,[Measles2_ImmuSource_ID]=X.Child20_Immu_Source
,[JE1_Dt]=X.Child21_Date,[JE1_ANM_ID]=X.Child21_ANM_ID,[JE1_ASHA_ID]=X.Child21_ASHA_ID,[JE1_Source_ID]=X.Child21_Source ,[JE1_ImmuSource_ID]=X.Child21_Immu_Source
,[JE2_Dt]=X.Child22_Date,[JE2_ANM_ID]=X.Child22_ANM_ID,[JE2_ASHA_ID]=X.Child22_ASHA_ID,[JE2_Source_ID]=X.Child22_Source ,[JE2_ImmuSource_ID]=X.Child22_Immu_Source
,[VitA_Dose1_Dt]=X.Child23_Date,[VitA_Dose1_ANM_ID]=X.Child23_ANM_ID,[VitA_Dose1_ASHA_ID]=X.Child23_ASHA_ID,[VitA_Dose1_Source_ID]=X.Child23_Source ,[VitA_Dose1_ImmuSource_ID]=X.Child23_Immu_Source
,[VitA_Dose2_Dt]=X.Child24_Date,[VitA_Dose2_ANM_ID]=X.Child24_ANM_ID,[VitA_Dose2_ASHA_ID]=X.Child24_ASHA_ID,[VitA_Dose2_Source_ID]=X.Child24_Source ,[VitA_Dose2_ImmuSource_ID]=X.Child24_Immu_Source
,[VitA_Dose3_Dt]=X.Child25_Date,[VitA_Dose3_ANM_ID]=X.Child25_ANM_ID,[VitA_Dose3_ASHA_ID]=X.Child25_ASHA_ID,[VitA_Dose3_Source_ID]=X.Child25_Source ,[VitA_Dose3_ImmuSource_ID]=X.Child25_Immu_Source
,[VitA_Dose4_Dt]=X.Child26_Date,[VitA_Dose4_ANM_ID]=X.Child26_ANM_ID,[VitA_Dose4_ASHA_ID]=X.Child26_ASHA_ID,[VitA_Dose4_Source_ID]=X.Child26_Source ,[VitA_Dose4_ImmuSource_ID]=X.Child26_Immu_Source
,[VitA_Dose5_Dt]=X.Child27_Date,[VitA_Dose5_ANM_ID]=X.Child27_ANM_ID,[VitA_Dose5_ASHA_ID]=X.Child27_ASHA_ID,[VitA_Dose5_Source_ID]=X.Child27_Source ,[VitA_Dose5_ImmuSource_ID]=X.Child27_Immu_Source
,[VitA_Dose6_Dt]=X.Child28_Date,[VitA_Dose6_ANM_ID]=X.Child28_ANM_ID,[VitA_Dose6_ASHA_ID]=X.Child28_ASHA_ID,[VitA_Dose6_Source_ID]=X.Child28_Source ,[VitA_Dose6_ImmuSource_ID]=X.Child28_Immu_Source
,[VitA_Dose7_Dt]=X.Child29_Date,[VitA_Dose7_ANM_ID]=X.Child29_ANM_ID,[VitA_Dose7_ASHA_ID]=X.Child29_ASHA_ID,[VitA_Dose7_Source_ID]=X.Child29_Source ,[VitA_Dose7_ImmuSource_ID]=X.Child29_Immu_Source
,[VitA_Dose8_Dt]=X.Child30_Date,[VitA_Dose8_ANM_ID]=X.Child30_ANM_ID,[VitA_Dose8_ASHA_ID]=X.Child30_ASHA_ID,[VitA_Dose8_Source_ID]=X.Child30_Source ,[VitA_Dose8_ImmuSource_ID]=X.Child30_Immu_Source
,[VitA_Dose9_Dt]=X.Child31_Date,[VitA_Dose9_ANM_ID]=X.Child31_ANM_ID,[VitA_Dose9_ASHA_ID]=X.Child31_ASHA_ID,[VitA_Dose9_Source_ID]=X.Child31_Source ,[VitA_Dose9_ImmuSource_ID]=X.Child31_Immu_Source
,[MMR_Dt]=X.Child32_Date,[MMR_ANM_ID]=X.Child32_ANM_ID,[MMR_ASHA_ID]=X.Child32_ASHA_ID,[MMR_Source_ID]=X.Child32_Source ,[MMR_ImmuSource_ID]=X.Child32_Immu_Source
,[MR_Dt]=X.Child33_Date,[MR_ANM_ID]=X.Child33_ANM_ID,[MR_ASHA_ID]=X.Child33_ASHA_ID,[MR_Source_ID]=X.Child33_Source ,[MR_ImmuSource_ID]=X.Child33_Immu_Source
,[Typhoid_Dt]=X.Child34_Date,[Typhoid_ANM_ID]=X.Child34_ANM_ID,[Typhoid_ASHA_ID]=X.Child34_ASHA_ID,[Typhoid_Source_ID]=X.Child34_Source ,[Typhoid_ImmuSource_ID]=X.Child34_Immu_Source
,[Rota_Virus_Dt]=X.Child35_Date,[Rota_Virus_ANM_ID]=X.Child35_ANM_ID,[Rota_Virus_ASHA_ID]=X.Child35_ASHA_ID,[Rota_Virus_Source_ID]=X.Child35_Source ,[Rota_Virus_ImmuSource_ID]=X.Child35_Immu_Source
,[VitK_Dt]=X.Child36_Date,[VitK_ANM_ID]=X.Child36_ANM_ID,[VitK_ASHA_ID]=X.Child36_ASHA_ID,[VitK_Source_ID]=X.Child36_Source ,[VitK_ImmuSource_ID]=X.Child36_Immu_Source
,Rota_Dose2_Dt=X.Child37_Date,Rota_Dose2_ANM_ID=X.Child37_ANM_ID,Rota_Dose2_ASHA_ID=X.Child37_ASHA_ID,Rota_Dose2_Source_ID=X.Child37_Source ,Rota_Dose2_ImmuSource_ID=X.Child37_Immu_Source
,Rota_Dose3_Dt=X.Child38_Date,Rota_Dose3_ANM_ID=X.Child38_ANM_ID,Rota_Dose3_ASHA_ID=X.Child38_ASHA_ID,Rota_Dose3_Source_ID=X.Child38_Source ,Rota_Dose3_ImmuSource_ID=X.Child38_Immu_Source
,IPV_Dose1_Dt=X.Child39_Date,IPV_Dose1_ANM_ID=X.Child39_ANM_ID,IPV_Dose1_ASHA_ID=X.Child39_ASHA_ID,IPV_Dose1_Source_ID=X.Child39_Source ,IPV_Dose1_ImmuSource_ID=X.Child39_Immu_Source
,IPV_Dose2_Dt=X.Child40_Date,IPV_Dose2_ANM_ID=X.Child40_ANM_ID,IPV_Dose2_ASHA_ID=X.Child40_ASHA_ID,IPV_Dose2_Source_ID=X.Child40_Source ,IPV_Dose2_ImmuSource_ID=X.Child40_Immu_Source
,Exec_Date=GETDATE()
      from
      (
		select Registration_no,[Child0_Code],[Child0_Date],[Child0_Source],[Child0_AEFI_Serious],[Child0_Serious_Reason],[Child0_Reason_closure]
,[Child0_DeathDate],[Child0_DeathPlace],[Child0_Death_reason],[Child0_Case_closure],[Child0_ANM_ID],[Child0_ASHA_ID],[Child0_Immu_Source]
--BCG
,[Child1_Code],[Child1_Date],[Child1_Source],[Child1_AEFI_Serious],[Child1_Serious_Reason],[Child1_Reason_closure]
,[Child1_DeathDate],[Child1_DeathPlace],[Child1_Death_reason],[Child1_Case_closure],[Child1_ANM_ID],[Child1_ASHA_ID],[Child1_Immu_Source]
--OPV0
,[Child2_Code],[Child2_Date],[Child2_Source],[Child2_AEFI_Serious],[Child2_Serious_Reason],[Child2_Reason_closure]
,[Child2_DeathDate],[Child2_DeathPlace],[Child2_Death_reason],[Child2_Case_closure],[Child2_ANM_ID],[Child2_ASHA_ID],[Child2_Immu_Source]
--OPV1
,[Child3_Code],[Child3_Date],[Child3_Source],[Child3_AEFI_Serious],[Child3_Serious_Reason],[Child3_Reason_closure]
,[Child3_DeathDate],[Child3_DeathPlace],[Child3_Death_reason],[Child3_Case_closure],[Child3_ANM_ID],[Child3_ASHA_ID],[Child3_Immu_Source]
--OPV2
,[Child4_Code],[Child4_Date],[Child4_Source],[Child4_AEFI_Serious],[Child4_Serious_Reason],[Child4_Reason_closure]
,[Child4_DeathDate],[Child4_DeathPlace],[Child4_Death_reason],[Child4_Case_closure],[Child4_ANM_ID],[Child4_ASHA_ID],[Child4_Immu_Source]
--OPV3
,[Child5_Code],[Child5_Date],[Child5_Source],[Child5_AEFI_Serious],[Child5_Serious_Reason],[Child5_Reason_closure]
,[Child5_DeathDate],[Child5_DeathPlace],[Child5_Death_reason],[Child5_Case_closure],[Child5_ANM_ID],[Child5_ASHA_ID],[Child5_Immu_Source]
--OPVB
,[Child6_Code],[Child6_Date],[Child6_Source],[Child6_AEFI_Serious],[Child6_Serious_Reason],[Child6_Reason_closure]
,[Child6_DeathDate],[Child6_DeathPlace],[Child6_Death_reason],[Child6_Case_closure],[Child6_ANM_ID],[Child6_ASHA_ID],[Child6_Immu_Source]
--DPT1
,[Child7_Code],[Child7_Date],[Child7_Source],[Child7_AEFI_Serious],[Child7_Serious_Reason],[Child7_Reason_closure]
,[Child7_DeathDate],[Child7_DeathPlace],[Child7_Death_reason],[Child7_Case_closure],[Child7_ANM_ID],[Child7_ASHA_ID],[Child7_Immu_Source]
--DPT2
,[Child8_Code],[Child8_Date],[Child8_Source],[Child8_AEFI_Serious],[Child8_Serious_Reason],[Child8_Reason_closure]
,[Child8_DeathDate],[Child8_DeathPlace],[Child8_Death_reason],[Child8_Case_closure],[Child8_ANM_ID],[Child8_ASHA_ID],[Child8_Immu_Source]
--DPT3
,[Child9_Code],[Child9_Date],[Child9_Source],[Child9_AEFI_Serious],[Child9_Serious_Reason],[Child9_Reason_closure]
,[Child9_DeathDate],[Child9_DeathPlace],[Child9_Death_reason],[Child9_Case_closure],[Child9_ANM_ID],[Child9_ASHA_ID],[Child9_Immu_Source]
--DPTB1
,[Child10_Code],[Child10_Date],[Child10_Source],[Child10_AEFI_Serious],[Child10_Serious_Reason],[Child10_Reason_closure]
,[Child10_DeathDate],[Child10_DeathPlace],[Child10_Death_reason],[Child10_Case_closure],[Child10_ANM_ID],[Child10_ASHA_ID],[Child10_Immu_Source]
--DPTB2

,[Child11_Code],[Child11_Date],[Child11_Source],[Child11_AEFI_Serious],[Child11_Serious_Reason],[Child11_Reason_closure]
,[Child11_DeathDate],[Child11_DeathPlace],[Child11_Death_reason],[Child11_Case_closure],[Child11_ANM_ID],[Child11_ASHA_ID],[Child11_Immu_Source]
--HEP0
,[Child12_Code],[Child12_Date],[Child12_Source],[Child12_AEFI_Serious],[Child12_Serious_Reason],[Child12_Reason_closure]
,[Child12_DeathDate],[Child12_DeathPlace],[Child12_Death_reason],[Child12_Case_closure],[Child12_ANM_ID],[Child12_ASHA_ID],[Child12_Immu_Source]
--HEP1
,[Child13_Code],[Child13_Date],[Child13_Source],[Child13_AEFI_Serious],[Child13_Serious_Reason],[Child13_Reason_closure]
,[Child13_DeathDate],[Child13_DeathPlace],[Child13_Death_reason],[Child13_Case_closure],[Child13_ANM_ID],[Child13_ASHA_ID],[Child13_Immu_Source]
--HEP2
,[Child14_Code],[Child14_Date],[Child14_Source],[Child14_AEFI_Serious],[Child14_Serious_Reason],[Child14_Reason_closure]
,[Child14_DeathDate],[Child14_DeathPlace],[Child14_Death_reason],[Child14_Case_closure],[Child14_ANM_ID],[Child14_ASHA_ID],[Child14_Immu_Source]
--HEP3
,[Child15_Code],[Child15_Date],[Child15_Source],[Child15_AEFI_Serious],[Child15_Serious_Reason],[Child15_Reason_closure]
,[Child15_DeathDate],[Child15_DeathPlace],[Child15_Death_reason],[Child15_Case_closure],[Child15_ANM_ID],[Child15_ASHA_ID],[Child15_Immu_Source]
--Penta1
,[Child16_Code],[Child16_Date],[Child16_Source],[Child16_AEFI_Serious],[Child16_Serious_Reason],[Child16_Reason_closure]
,[Child16_DeathDate],[Child16_DeathPlace],[Child16_Death_reason],[Child16_Case_closure],[Child16_ANM_ID],[Child16_ASHA_ID],[Child16_Immu_Source]
--Penta2

,[Child17_Code],[Child17_Date],[Child17_Source],[Child17_AEFI_Serious],[Child17_Serious_Reason],[Child17_Reason_closure]
,[Child17_DeathDate],[Child17_DeathPlace],[Child17_Death_reason],[Child17_Case_closure],[Child17_ANM_ID],[Child17_ASHA_ID],[Child17_Immu_Source]

--Penta3
,[Child18_Code],[Child18_Date],[Child18_Source],[Child18_AEFI_Serious],[Child18_Serious_Reason],[Child18_Reason_closure]
,[Child18_DeathDate],[Child18_DeathPlace],[Child18_Death_reason],[Child18_Case_closure],[Child18_ANM_ID],[Child18_ASHA_ID],[Child18_Immu_Source]

--Measles1
,[Child19_Code],[Child19_Date],[Child19_Source],[Child19_AEFI_Serious],[Child19_Serious_Reason],[Child19_Reason_closure]
,[Child19_DeathDate],[Child19_DeathPlace],[Child19_Death_reason],[Child19_Case_closure],[Child19_ANM_ID],[Child19_ASHA_ID],[Child19_Immu_Source]

--Measles2
,[Child20_Code],[Child20_Date],[Child20_Source],[Child20_AEFI_Serious],[Child20_Serious_Reason],[Child20_Reason_closure]
,[Child20_DeathDate],[Child20_DeathPlace],[Child20_Death_reason],[Child20_Case_closure],[Child20_ANM_ID],[Child20_ASHA_ID],[Child20_Immu_Source]
--JE1
,[Child21_Code],[Child21_Date],[Child21_Source],[Child21_AEFI_Serious],[Child21_Serious_Reason],[Child21_Reason_closure]
,[Child21_DeathDate],[Child21_DeathPlace],[Child21_Death_reason],[Child21_Case_closure],[Child21_ANM_ID],[Child21_ASHA_ID],[Child21_Immu_Source]
--JE2

,[Child22_Code],[Child22_Date],[Child22_Source],[Child22_AEFI_Serious],[Child22_Serious_Reason],[Child22_Reason_closure]
,[Child22_DeathDate],[Child22_DeathPlace],[Child22_Death_reason],[Child22_Case_closure],[Child22_ANM_ID],[Child22_ASHA_ID],[Child22_Immu_Source]
--Vita1
,[Child23_Code],[Child23_Date],[Child23_Source],[Child23_AEFI_Serious],[Child23_Serious_Reason],[Child23_Reason_closure]
,[Child23_DeathDate],[Child23_DeathPlace],[Child23_Death_reason],[Child23_Case_closure],[Child23_ANM_ID],[Child23_ASHA_ID],[Child23_Immu_Source]
--Vita2
,[Child24_Code],[Child24_Date],[Child24_Source],[Child24_AEFI_Serious],[Child24_Serious_Reason],[Child24_Reason_closure]
,[Child24_DeathDate],[Child24_DeathPlace],[Child24_Death_reason],[Child24_Case_closure],[Child24_ANM_ID],[Child24_ASHA_ID],[Child24_Immu_Source]
--vita3
,[Child25_Code],[Child25_Date],[Child25_Source],[Child25_AEFI_Serious],[Child25_Serious_Reason],[Child25_Reason_closure]
,[Child25_DeathDate],[Child25_DeathPlace],[Child25_Death_reason],[Child25_Case_closure],[Child25_ANM_ID],[Child25_ASHA_ID],[Child25_Immu_Source]
--vita4
,[Child26_Code],[Child26_Date],[Child26_Source],[Child26_AEFI_Serious],[Child26_Serious_Reason],[Child26_Reason_closure]
,[Child26_DeathDate],[Child26_DeathPlace],[Child26_Death_reason],[Child26_Case_closure],[Child26_ANM_ID],[Child26_ASHA_ID],[Child26_Immu_Source]
--vita5
,[Child27_Code],[Child27_Date],[Child27_Source],[Child27_AEFI_Serious],[Child27_Serious_Reason],[Child27_Reason_closure]
,[Child27_DeathDate],[Child27_DeathPlace],[Child27_Death_reason],[Child27_Case_closure],[Child27_ANM_ID],[Child27_ASHA_ID],[Child27_Immu_Source]
--vita6
,[Child28_Code],[Child28_Date],[Child28_Source],[Child28_AEFI_Serious],[Child28_Serious_Reason],[Child28_Reason_closure]
,[Child28_DeathDate],[Child28_DeathPlace],[Child28_Death_reason],[Child28_Case_closure],[Child28_ANM_ID],[Child28_ASHA_ID],[Child28_Immu_Source]
--vita7

,[Child29_Code],[Child29_Date],[Child29_Source],[Child29_AEFI_Serious],[Child29_Serious_Reason],[Child29_Reason_closure]
,[Child29_DeathDate],[Child29_DeathPlace],[Child29_Death_reason],[Child29_Case_closure],[Child29_ANM_ID],[Child29_ASHA_ID],[Child29_Immu_Source]
--vita8
,[Child30_Code],[Child30_Date],[Child30_Source],[Child30_AEFI_Serious],[Child30_Serious_Reason],[Child30_Reason_closure]
,[Child30_DeathDate],[Child30_DeathPlace],[Child30_Death_reason],[Child30_Case_closure],[Child30_ANM_ID],[Child30_ASHA_ID],[Child30_Immu_Source]

--vita9
,[Child31_Code],[Child31_Date],[Child31_Source],[Child31_AEFI_Serious],[Child31_Serious_Reason],[Child31_Reason_closure]
,[Child31_DeathDate],[Child31_DeathPlace],[Child31_Death_reason],[Child31_Case_closure],[Child31_ANM_ID],[Child31_ASHA_ID],[Child31_Immu_Source]

--MMR
,[Child32_Code],[Child32_Date],[Child32_Source],[Child32_AEFI_Serious],[Child32_Serious_Reason],[Child32_Reason_closure]
,[Child32_DeathDate],[Child32_DeathPlace],[Child32_Death_reason],[Child32_Case_closure],[Child32_ANM_ID],[Child32_ASHA_ID],[Child32_Immu_Source]
--MR
,[Child33_Code],[Child33_Date],[Child33_Source],[Child33_AEFI_Serious],[Child33_Serious_Reason],[Child33_Reason_closure]
,[Child33_DeathDate],[Child33_DeathPlace],[Child33_Death_reason],[Child33_Case_closure],[Child33_ANM_ID],[Child33_ASHA_ID],[Child33_Immu_Source]
--Typhoid

,[Child34_Code],[Child34_Date],[Child34_Source],[Child34_AEFI_Serious],[Child34_Serious_Reason],[Child34_Reason_closure]
,[Child34_DeathDate],[Child34_DeathPlace],[Child34_Death_reason],[Child34_Case_closure],[Child34_ANM_ID],[Child34_ASHA_ID],[Child34_Immu_Source]

--RotaVirus1

,[Child35_Code],[Child35_Date],[Child35_Source],[Child35_AEFI_Serious],[Child35_Serious_Reason],[Child35_Reason_closure]
,[Child35_DeathDate],[Child35_DeathPlace],[Child35_Death_reason],[Child35_Case_closure],[Child35_ANM_ID],[Child35_ASHA_ID],[Child35_Immu_Source]

--VITAMINK

,[Child36_Code],[Child36_Date],[Child36_Source],[Child36_AEFI_Serious],[Child36_Serious_Reason],[Child36_Reason_closure]
,[Child36_DeathDate],[Child36_DeathPlace],[Child36_Death_reason],[Child36_Case_closure],[Child36_ANM_ID],[Child36_ASHA_ID],[Child36_Immu_Source]


--RotaVirus2

,[Child37_Code],[Child37_Date],[Child37_Source],[Child37_AEFI_Serious],[Child37_Serious_Reason],[Child37_Reason_closure]
,[Child37_DeathDate],[Child37_DeathPlace],[Child37_Death_reason],[Child37_Case_closure],[Child37_ANM_ID],[Child37_ASHA_ID],[Child37_Immu_Source]

--RotaVirus3

,[Child38_Code],[Child38_Date],[Child38_Source],[Child38_AEFI_Serious],[Child38_Serious_Reason],[Child38_Reason_closure]
,[Child38_DeathDate],[Child38_DeathPlace],[Child38_Death_reason],[Child38_Case_closure],[Child38_ANM_ID],[Child38_ASHA_ID],[Child38_Immu_Source]

--IPV1

,[Child39_Code],[Child39_Date],[Child39_Source],[Child39_AEFI_Serious],[Child39_Serious_Reason],[Child39_Reason_closure]
,[Child39_DeathDate],[Child39_DeathPlace],[Child39_Death_reason],[Child39_Case_closure],[Child39_ANM_ID],[Child39_ASHA_ID],[Child39_Immu_Source]

--IPV2

,[Child40_Code],[Child40_Date],[Child40_Source],[Child40_AEFI_Serious],[Child40_Serious_Reason],[Child40_Reason_closure]
,[Child40_DeathDate],[Child40_DeathPlace],[Child40_Death_reason],[Child40_Case_closure],[Child40_ANM_ID],[Child40_ASHA_ID],[Child40_Immu_Source]
from 
(
select Registration_no,'Child'+cast( Immu_code as varchar(4))+'_'+col new_col,value from
(select a.Registration_no,a.Immu_code,Immu_date,Immu_Source,AEFI_Serious,Serious_Reason,Reason_closure,DeathDate,DeathPlace,Death_reason,Case_closure ,SourceID
,ANM_ID,ASHA_ID
from t_children_tracking a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_No
where CT_Table=1
 ) t_children_tracking
cross apply
  (
    VALUES
		  
            (cast(Immu_code as nvarchar), 'Code'),
            (cast(Immu_date as nvarchar), 'Date'),
			(cast(SourceID as nvarchar), 'Source'),
			(cast(Immu_Source as nvarchar), 'Immu_Source'),
			(cast(AEFI_Serious as nvarchar), 'AEFI_Serious'),
			(cast(Serious_Reason as nvarchar), 'Serious_Reason'),
			(cast(Reason_closure as nvarchar), 'Reason_closure'),
			(cast(DeathDate as nvarchar), 'DeathDate'),
			(cast(DeathPlace as nvarchar), 'DeathPlace'),
			(cast(Death_reason as nvarchar), 'Death_reason'),
			(cast(Case_closure as nvarchar), 'Case_closure'),
			(cast(ANM_ID as nvarchar), 'ANM_ID'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID')
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
  
  --Death
 [Child0_Code],[Child0_Date],[Child0_Source],[Child0_AEFI_Serious],[Child0_Serious_Reason],[Child0_Reason_closure]
,[Child0_DeathDate],[Child0_DeathPlace],[Child0_Death_reason],[Child0_Case_closure],[Child0_ANM_ID],[Child0_ASHA_ID],[Child0_Immu_Source]
--BCG
,[Child1_Code],[Child1_Date],[Child1_Source],[Child1_AEFI_Serious],[Child1_Serious_Reason],[Child1_Reason_closure]
,[Child1_DeathDate],[Child1_DeathPlace],[Child1_Death_reason],[Child1_Case_closure],[Child1_ANM_ID],[Child1_ASHA_ID],[Child1_Immu_Source]
--OPV0
,[Child2_Code],[Child2_Date],[Child2_Source],[Child2_AEFI_Serious],[Child2_Serious_Reason],[Child2_Reason_closure]
,[Child2_DeathDate],[Child2_DeathPlace],[Child2_Death_reason],[Child2_Case_closure],[Child2_ANM_ID],[Child2_ASHA_ID],[Child2_Immu_Source]
--OPV1
,[Child3_Code],[Child3_Date],[Child3_Source],[Child3_AEFI_Serious],[Child3_Serious_Reason],[Child3_Reason_closure]
,[Child3_DeathDate],[Child3_DeathPlace],[Child3_Death_reason],[Child3_Case_closure],[Child3_ANM_ID],[Child3_ASHA_ID],[Child3_Immu_Source]
--OPV2
,[Child4_Code],[Child4_Date],[Child4_Source],[Child4_AEFI_Serious],[Child4_Serious_Reason],[Child4_Reason_closure]
,[Child4_DeathDate],[Child4_DeathPlace],[Child4_Death_reason],[Child4_Case_closure],[Child4_ANM_ID],[Child4_ASHA_ID],[Child4_Immu_Source]
--OPV3
,[Child5_Code],[Child5_Date],[Child5_Source],[Child5_AEFI_Serious],[Child5_Serious_Reason],[Child5_Reason_closure]
,[Child5_DeathDate],[Child5_DeathPlace],[Child5_Death_reason],[Child5_Case_closure],[Child5_ANM_ID],[Child5_ASHA_ID],[Child5_Immu_Source]
--OPVB
,[Child6_Code],[Child6_Date],[Child6_Source],[Child6_AEFI_Serious],[Child6_Serious_Reason],[Child6_Reason_closure]
,[Child6_DeathDate],[Child6_DeathPlace],[Child6_Death_reason],[Child6_Case_closure],[Child6_ANM_ID],[Child6_ASHA_ID],[Child6_Immu_Source]
--DPT1
,[Child7_Code],[Child7_Date],[Child7_Source],[Child7_AEFI_Serious],[Child7_Serious_Reason],[Child7_Reason_closure]
,[Child7_DeathDate],[Child7_DeathPlace],[Child7_Death_reason],[Child7_Case_closure],[Child7_ANM_ID],[Child7_ASHA_ID],[Child7_Immu_Source]
--DPT2
,[Child8_Code],[Child8_Date],[Child8_Source],[Child8_AEFI_Serious],[Child8_Serious_Reason],[Child8_Reason_closure]
,[Child8_DeathDate],[Child8_DeathPlace],[Child8_Death_reason],[Child8_Case_closure],[Child8_ANM_ID],[Child8_ASHA_ID],[Child8_Immu_Source]
--DPT3
,[Child9_Code],[Child9_Date],[Child9_Source],[Child9_AEFI_Serious],[Child9_Serious_Reason],[Child9_Reason_closure]
,[Child9_DeathDate],[Child9_DeathPlace],[Child9_Death_reason],[Child9_Case_closure],[Child9_ANM_ID],[Child9_ASHA_ID],[Child9_Immu_Source]
--DPTB1
,[Child10_Code],[Child10_Date],[Child10_Source],[Child10_AEFI_Serious],[Child10_Serious_Reason],[Child10_Reason_closure]
,[Child10_DeathDate],[Child10_DeathPlace],[Child10_Death_reason],[Child10_Case_closure],[Child10_ANM_ID],[Child10_ASHA_ID],[Child10_Immu_Source]
--DPTB2

,[Child11_Code],[Child11_Date],[Child11_Source],[Child11_AEFI_Serious],[Child11_Serious_Reason],[Child11_Reason_closure]
,[Child11_DeathDate],[Child11_DeathPlace],[Child11_Death_reason],[Child11_Case_closure],[Child11_ANM_ID],[Child11_ASHA_ID],[Child11_Immu_Source]
--HEP0
,[Child12_Code],[Child12_Date],[Child12_Source],[Child12_AEFI_Serious],[Child12_Serious_Reason],[Child12_Reason_closure]
,[Child12_DeathDate],[Child12_DeathPlace],[Child12_Death_reason],[Child12_Case_closure],[Child12_ANM_ID],[Child12_ASHA_ID],[Child12_Immu_Source]
--HEP1
,[Child13_Code],[Child13_Date],[Child13_Source],[Child13_AEFI_Serious],[Child13_Serious_Reason],[Child13_Reason_closure]
,[Child13_DeathDate],[Child13_DeathPlace],[Child13_Death_reason],[Child13_Case_closure],[Child13_ANM_ID],[Child13_ASHA_ID],[Child13_Immu_Source]
--HEP2
,[Child14_Code],[Child14_Date],[Child14_Source],[Child14_AEFI_Serious],[Child14_Serious_Reason],[Child14_Reason_closure]
,[Child14_DeathDate],[Child14_DeathPlace],[Child14_Death_reason],[Child14_Case_closure],[Child14_ANM_ID],[Child14_ASHA_ID],[Child14_Immu_Source]
--HEP3
,[Child15_Code],[Child15_Date],[Child15_Source],[Child15_AEFI_Serious],[Child15_Serious_Reason],[Child15_Reason_closure]
,[Child15_DeathDate],[Child15_DeathPlace],[Child15_Death_reason],[Child15_Case_closure],[Child15_ANM_ID],[Child15_ASHA_ID],[Child15_Immu_Source]
--Penta1
,[Child16_Code],[Child16_Date],[Child16_Source],[Child16_AEFI_Serious],[Child16_Serious_Reason],[Child16_Reason_closure]
,[Child16_DeathDate],[Child16_DeathPlace],[Child16_Death_reason],[Child16_Case_closure],[Child16_ANM_ID],[Child16_ASHA_ID],[Child16_Immu_Source]
--Penta2

,[Child17_Code],[Child17_Date],[Child17_Source],[Child17_AEFI_Serious],[Child17_Serious_Reason],[Child17_Reason_closure]
,[Child17_DeathDate],[Child17_DeathPlace],[Child17_Death_reason],[Child17_Case_closure],[Child17_ANM_ID],[Child17_ASHA_ID],[Child17_Immu_Source]

--Penta3
,[Child18_Code],[Child18_Date],[Child18_Source],[Child18_AEFI_Serious],[Child18_Serious_Reason],[Child18_Reason_closure]
,[Child18_DeathDate],[Child18_DeathPlace],[Child18_Death_reason],[Child18_Case_closure],[Child18_ANM_ID],[Child18_ASHA_ID],[Child18_Immu_Source]

--Measles1
,[Child19_Code],[Child19_Date],[Child19_Source],[Child19_AEFI_Serious],[Child19_Serious_Reason],[Child19_Reason_closure]
,[Child19_DeathDate],[Child19_DeathPlace],[Child19_Death_reason],[Child19_Case_closure],[Child19_ANM_ID],[Child19_ASHA_ID],[Child19_Immu_Source]

--Measles2
,[Child20_Code],[Child20_Date],[Child20_Source],[Child20_AEFI_Serious],[Child20_Serious_Reason],[Child20_Reason_closure]
,[Child20_DeathDate],[Child20_DeathPlace],[Child20_Death_reason],[Child20_Case_closure],[Child20_ANM_ID],[Child20_ASHA_ID],[Child20_Immu_Source]
--JE1
,[Child21_Code],[Child21_Date],[Child21_Source],[Child21_AEFI_Serious],[Child21_Serious_Reason],[Child21_Reason_closure]
,[Child21_DeathDate],[Child21_DeathPlace],[Child21_Death_reason],[Child21_Case_closure],[Child21_ANM_ID],[Child21_ASHA_ID],[Child21_Immu_Source]
--JE2

,[Child22_Code],[Child22_Date],[Child22_Source],[Child22_AEFI_Serious],[Child22_Serious_Reason],[Child22_Reason_closure]
,[Child22_DeathDate],[Child22_DeathPlace],[Child22_Death_reason],[Child22_Case_closure],[Child22_ANM_ID],[Child22_ASHA_ID],[Child22_Immu_Source]
--Vita1
,[Child23_Code],[Child23_Date],[Child23_Source],[Child23_AEFI_Serious],[Child23_Serious_Reason],[Child23_Reason_closure]
,[Child23_DeathDate],[Child23_DeathPlace],[Child23_Death_reason],[Child23_Case_closure],[Child23_ANM_ID],[Child23_ASHA_ID],[Child23_Immu_Source]
--Vita2
,[Child24_Code],[Child24_Date],[Child24_Source],[Child24_AEFI_Serious],[Child24_Serious_Reason],[Child24_Reason_closure]
,[Child24_DeathDate],[Child24_DeathPlace],[Child24_Death_reason],[Child24_Case_closure],[Child24_ANM_ID],[Child24_ASHA_ID],[Child24_Immu_Source]
--vita3
,[Child25_Code],[Child25_Date],[Child25_Source],[Child25_AEFI_Serious],[Child25_Serious_Reason],[Child25_Reason_closure]
,[Child25_DeathDate],[Child25_DeathPlace],[Child25_Death_reason],[Child25_Case_closure],[Child25_ANM_ID],[Child25_ASHA_ID],[Child25_Immu_Source]
--vita4
,[Child26_Code],[Child26_Date],[Child26_Source],[Child26_AEFI_Serious],[Child26_Serious_Reason],[Child26_Reason_closure]
,[Child26_DeathDate],[Child26_DeathPlace],[Child26_Death_reason],[Child26_Case_closure],[Child26_ANM_ID],[Child26_ASHA_ID],[Child26_Immu_Source]
--vita5
,[Child27_Code],[Child27_Date],[Child27_Source],[Child27_AEFI_Serious],[Child27_Serious_Reason],[Child27_Reason_closure]
,[Child27_DeathDate],[Child27_DeathPlace],[Child27_Death_reason],[Child27_Case_closure],[Child27_ANM_ID],[Child27_ASHA_ID],[Child27_Immu_Source]
--vita6
,[Child28_Code],[Child28_Date],[Child28_Source],[Child28_AEFI_Serious],[Child28_Serious_Reason],[Child28_Reason_closure]
,[Child28_DeathDate],[Child28_DeathPlace],[Child28_Death_reason],[Child28_Case_closure],[Child28_ANM_ID],[Child28_ASHA_ID],[Child28_Immu_Source]
--vita7

,[Child29_Code],[Child29_Date],[Child29_Source],[Child29_AEFI_Serious],[Child29_Serious_Reason],[Child29_Reason_closure]
,[Child29_DeathDate],[Child29_DeathPlace],[Child29_Death_reason],[Child29_Case_closure],[Child29_ANM_ID],[Child29_ASHA_ID],[Child29_Immu_Source]
--vita8
,[Child30_Code],[Child30_Date],[Child30_Source],[Child30_AEFI_Serious],[Child30_Serious_Reason],[Child30_Reason_closure]
,[Child30_DeathDate],[Child30_DeathPlace],[Child30_Death_reason],[Child30_Case_closure],[Child30_ANM_ID],[Child30_ASHA_ID],[Child30_Immu_Source]

--vita9
,[Child31_Code],[Child31_Date],[Child31_Source],[Child31_AEFI_Serious],[Child31_Serious_Reason],[Child31_Reason_closure]
,[Child31_DeathDate],[Child31_DeathPlace],[Child31_Death_reason],[Child31_Case_closure],[Child31_ANM_ID],[Child31_ASHA_ID],[Child31_Immu_Source]

--MMR
,[Child32_Code],[Child32_Date],[Child32_Source],[Child32_AEFI_Serious],[Child32_Serious_Reason],[Child32_Reason_closure]
,[Child32_DeathDate],[Child32_DeathPlace],[Child32_Death_reason],[Child32_Case_closure],[Child32_ANM_ID],[Child32_ASHA_ID],[Child32_Immu_Source]
--MR
,[Child33_Code],[Child33_Date],[Child33_Source],[Child33_AEFI_Serious],[Child33_Serious_Reason],[Child33_Reason_closure]
,[Child33_DeathDate],[Child33_DeathPlace],[Child33_Death_reason],[Child33_Case_closure],[Child33_ANM_ID],[Child33_ASHA_ID],[Child33_Immu_Source]
--Typhoid

,[Child34_Code],[Child34_Date],[Child34_Source],[Child34_AEFI_Serious],[Child34_Serious_Reason],[Child34_Reason_closure]
,[Child34_DeathDate],[Child34_DeathPlace],[Child34_Death_reason],[Child34_Case_closure],[Child34_ANM_ID],[Child34_ASHA_ID],[Child34_Immu_Source]

--RotaVirus

,[Child35_Code],[Child35_Date],[Child35_Source],[Child35_AEFI_Serious],[Child35_Serious_Reason],[Child35_Reason_closure]
,[Child35_DeathDate],[Child35_DeathPlace],[Child35_Death_reason],[Child35_Case_closure],[Child35_ANM_ID],[Child35_ASHA_ID],[Child35_Immu_Source]

--VITAMINK

,[Child36_Code],[Child36_Date],[Child36_Source],[Child36_AEFI_Serious],[Child36_Serious_Reason],[Child36_Reason_closure]
,[Child36_DeathDate],[Child36_DeathPlace],[Child36_Death_reason],[Child36_Case_closure],[Child36_ANM_ID],[Child36_ASHA_ID],[Child36_Immu_Source]

--RotaVirus2

,[Child37_Code],[Child37_Date],[Child37_Source],[Child37_AEFI_Serious],[Child37_Serious_Reason],[Child37_Reason_closure]
,[Child37_DeathDate],[Child37_DeathPlace],[Child37_Death_reason],[Child37_Case_closure],[Child37_ANM_ID],[Child37_ASHA_ID],[Child37_Immu_Source]


--RotaVirus3

,[Child38_Code],[Child38_Date],[Child38_Source],[Child38_AEFI_Serious],[Child38_Serious_Reason],[Child38_Reason_closure]
,[Child38_DeathDate],[Child38_DeathPlace],[Child38_Death_reason],[Child38_Case_closure],[Child38_ANM_ID],[Child38_ASHA_ID],[Child38_Immu_Source]


--IPV1

,[Child39_Code],[Child39_Date],[Child39_Source],[Child39_AEFI_Serious],[Child39_Serious_Reason],[Child39_Reason_closure]
,[Child39_DeathDate],[Child39_DeathPlace],[Child39_Death_reason],[Child39_Case_closure],[Child39_ANM_ID],[Child39_ASHA_ID],[Child39_Immu_Source]

--IPV2

,[Child40_Code],[Child40_Date],[Child40_Source],[Child40_AEFI_Serious],[Child40_Serious_Reason],[Child40_Reason_closure]
,[Child40_DeathDate],[Child40_DeathPlace],[Child40_Death_reason],[Child40_Case_closure],[Child40_ANM_ID],[Child40_ASHA_ID],[Child40_Immu_Source]
)
) piv
 ) X
where t_child_flat.Registration_no=X.Registration_no
      
      
      
      update t_child_flat set 
      [DPTBooster1_Breastfeeding]=X.Child10_Breastfeeding
      ,[DPTBooster1_Complentary_Feeding]=X.Child10_Complentary_Feeding
      ,[DPTBooster1_Complentary_Feeding_Month]=X.Child10_Month_Complentary_Feeding
      ,[DPTBooster1_Visit_Date]=X.Child10_Visit_Date
      ,[DPTBooster1_Child_Weight]=X.Child10_Child_Weight
      ,[DPTBooster1_Diarrhoea]=X.Child10_Diarrhoea
      ,[DPTBooster1_ORS_Given]=X.Child10_ORS_Given
      ,[DPTBooster1_Pneumonia]=X.Child10_Pneumonia
      ,[DPTBooster1_Antibiotics_Given]=X.Child10_Antibiotics_Given
      ,[Measles1_Breastfeeding]=X.Child19_Breastfeeding
      ,[Measles1_Complentary_Feeding]=X.Child19_Complentary_Feeding
      ,[Measles1_Complentary_Feeding_Month]=X.Child19_Month_Complentary_Feeding
      ,[Measles1_Visit_Date]=X.Child19_Visit_Date
      ,[Measles1_Child_Weight]=X.Child19_Child_Weight
      ,[Measles1_Diarrhoea]=X.Child19_Diarrhoea
      ,[Measles1_ORS_Given]=X.Child19_ORS_Given
      ,[Measles1_Pneumonia]=X.Child19_Pneumonia
      ,[Measles1_Antibiotics_Given]=X.Child19_Antibiotics_Given
      ,Exec_Date=GETDATE()
      from
      (
		select Registration_no

,[Child10_Breastfeeding],[Child10_Complentary_Feeding],[Child10_Month_Complentary_Feeding],[Child10_Visit_Date],[Child10_Child_Weight],[Child10_Diarrhoea]
,[Child10_Pneumonia],[Child10_Antibiotics_Given],[Child10_ORS_Given]
--Measles1

,[Child19_Breastfeeding],[Child19_Complentary_Feeding],[Child19_Month_Complentary_Feeding],[Child19_Visit_Date],[Child19_Child_Weight],[Child19_Diarrhoea]
,[Child19_Pneumonia],[Child19_Antibiotics_Given],[Child19_ORS_Given]

from 
(
select Registration_no,'Child'+cast( Immu_code as varchar(4))+'_'+col new_col,value from
(select a.Registration_no,Immu_code,Breastfeeding,Complentary_Feeding,Month_Complentary_Feeding,Visit_Date
,Child_Weight,Diarrhoea,ORS_Given,Pneumonia,Antibiotics_Given 
,ANM_ID,ASHA_ID
from t_children_tracking_medical a
inner join t_Schedule_Date_Child_Previous b on a.Registration_no=b.Registration_No
where b.CTM_Table=1
 ) t_children_tracking_medical
cross apply
  (
    VALUES
		  
            (cast(Breastfeeding as nvarchar), 'Breastfeeding'),
            (cast(Complentary_Feeding as nvarchar), 'Complentary_Feeding'),
			(cast(Month_Complentary_Feeding as nvarchar), 'Month_Complentary_Feeding'),
			(cast(Visit_Date as nvarchar), 'Visit_Date'),
			(cast(Child_Weight as nvarchar), 'Child_Weight'),
			(cast(Diarrhoea as nvarchar), 'Diarrhoea'),
			(cast(Pneumonia as nvarchar), 'Pneumonia'),
			(cast(Antibiotics_Given as nvarchar), 'Antibiotics_Given'),
			(cast(ORS_Given as nvarchar), 'ORS_Given')
			--(cast(ANM_ID as nvarchar), 'ANM_ID'),
			--(cast(ASHA_ID as nvarchar), 'ASHA_ID')
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
  
 --DPTB1
[Child10_Breastfeeding],[Child10_Complentary_Feeding],[Child10_Month_Complentary_Feeding],[Child10_Visit_Date],[Child10_Child_Weight],[Child10_Diarrhoea]
,[Child10_Pneumonia],[Child10_Antibiotics_Given],[Child10_ORS_Given]
--Measles1

,[Child19_Breastfeeding],[Child19_Complentary_Feeding],[Child19_Month_Complentary_Feeding],[Child19_Visit_Date],[Child19_Child_Weight],[Child19_Diarrhoea]
,[Child19_Pneumonia],[Child19_Antibiotics_Given],[Child19_ORS_Given]


)
)  piv
 ) X
where t_child_flat.Registration_no=X.Registration_no
 
      --[AEFI_Serious]
      --[AEFI_Serious_Vaccination]
      --[Serious_Reason]
-------------------------------------------Child pNC---------------------------------

update t_child_flat set  [PNC1_No]=X.PNC1_No_Infant
	 ,[PNC1_Type_Infant]=X.[PNC1_Type_Infant]
      ,[PNC1_Date_Infant]=X.[PNC1_Date_Infant]
    
      ,[PNC1_DangerSign_Infant_VAL]=X.[PNC1_DangerSign_Infant_VAL]
      ,[PNC1_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC1_DangerSign_Infant_VAL]),x.PNC1_DangerSign_Infant_Other) 
      ,[PNC1_ReferralFacility_Infant_VAL]=X.[PNC1_ReferralFacility_Infant_VAL]
      ,[PNC1_ReferralFacility_Infant]=coalesce(X.PNC1_ReferralFacilityID_Infant ,X.PNC1_ReferralFacility_Infant_Other)
	  ,PNC1_Infant_Weight=X.[PNC1_Infant_Weight]
      ,[PNC1_ANM_ID_Infant]=X.[PNC1_ANM_ID_Infant]
      ,[PNC1_ASHA_ID_Infant]=X.[PNC1_ASHA_ID_Infant]
      ,[PNC1_Created_by_Infant]=X.[PNC1_Created_by_Infant]
      ,[PNC1_Mobile_ID_Infant]=X.[PNC1_Mobile_ID_Infant]
      ,[PNC1_Source_ID_Infant]=X.[PNC1_Source_ID_Infant]
      
      ,[PNC2_No_Infant]=X.PNC2_No_Infant
	  ,[PNC2_Type_Infant]=X.[PNC2_Type_Infant]
      ,[PNC2_Date_Infant]=X.[PNC2_Date_Infant]
	  ,[PNC2_DangerSign_Infant_VAL]=X.[PNC2_DangerSign_Infant_VAL]
      ,[PNC2_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC2_DangerSign_Infant_VAL]),x.PNC2_DangerSign_Infant_Other) 
      ,[PNC2_ReferralFacility_Infant_VAL]=X.[PNC2_ReferralFacility_Infant_VAL]
      ,[PNC2_ReferralFacility_Infant]=coalesce(X.PNC2_ReferralFacilityID_Infant ,X.PNC2_ReferralFacility_Infant_Other)
      ,PNC2_Infant_Weight=X.[PNC2_Infant_Weight]
      ,[PNC2_ANM_ID_Infant]=X.[PNC2_ANM_ID_Infant]
      ,[PNC2_ASHA_ID_Infant]=X.[PNC2_ASHA_ID_Infant]
      ,[PNC2_Created_by_Infant]=X.[PNC2_Created_by_Infant]
      ,[PNC2_Mobile_ID_Infant]=X.[PNC2_Mobile_ID_Infant]
      ,[PNC2_Source_ID_Infant]=X.[PNC2_Source_ID_Infant]
      
      
      ,[PNC3_No_Infant]=X.PNC3_No_Infant
	  ,[PNC3_Type_Infant]=X.[PNC3_Type_Infant]
      ,[PNC3_Date_Infant]=X.[PNC3_Date_Infant]
      ,[PNC3_DangerSign_infant_VAL]=X.[PNC3_DangerSign_Infant_VAL]
      ,[PNC3_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC3_DangerSign_Infant_VAL]),x.PNC3_DangerSign_Infant_Other) 
      ,[PNC3_ReferralFacility_infant_VAL]=X.[PNC3_ReferralFacility_Infant_VAL]
      ,[PNC3_ReferralFacility_infant]=coalesce(X.PNC3_ReferralFacilityID_Infant ,X.PNC3_ReferralFacility_Infant_Other)
      ,PNC3_Infant_Weight=X.[PNC3_Infant_Weight]
      ,[PNC3_ANM_ID_infant]=X.[PNC3_ANM_ID_Infant]
      ,[PNC3_ASHA_ID_infant]=X.[PNC3_ASHA_ID_Infant]
      ,[PNC3_Created_by_infant]=X.[PNC3_Created_by_Infant]
      ,[PNC3_Mobile_ID_Infant]=X.[PNC3_Mobile_ID_Infant]
      ,[PNC3_Source_ID_Infant]=X.[PNC3_Source_ID_Infant]
      
      ,[PNC4_No_Infant]=X.PNC4_No_Infant
	  ,[PNC4_Type_Infant]=X.[PNC4_Type_Infant]
      ,[PNC4_Date_Infant]=X.[PNC4_Date_Infant]
	  ,[PNC4_DangerSign_Infant_VAL]=X.[PNC4_DangerSign_Infant_VAL]
      ,[PNC4_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC4_DangerSign_Infant_VAL]),x.PNC4_DangerSign_Infant_Other) 
      ,[PNC4_ReferralFacility_Infant_VAL]=X.[PNC4_ReferralFacility_Infant_VAL]
      ,[PNC4_ReferralFacility_Infant]=coalesce(X.PNC4_ReferralFacilityID_Infant ,X.PNC4_ReferralFacility_Infant_Other)
      ,PNC4_Infant_Weight=X.[PNC4_Infant_Weight]
      ,[PNC4_ANM_ID_Infant]=X.[PNC4_ANM_ID_Infant]
      ,[PNC4_ASHA_ID_Infant]=X.[PNC4_ASHA_ID_Infant]
      ,[PNC4_Created_by_Infant]=X.[PNC4_Created_by_Infant]
      ,[PNC4_Mobile_ID_Infant]=X.[PNC4_Mobile_ID_Infant]
      ,[PNC4_Source_ID_Infant]=X.[PNC4_Source_ID_Infant]
      
      ,[PNC5_No_Infant]=X.PNC5_No_Infant
	  ,[PNC5_Type_Infant]=X.[PNC5_Type_Infant]
      ,[PNC5_Date_Infant]=X.[PNC5_Date_Infant]
      ,[PNC5_DangerSign_Infant_VAL]=X.[PNC5_DangerSign_Infant_VAL]
      ,[PNC5_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC5_DangerSign_Infant_VAL]),x.PNC5_DangerSign_Infant_Other) 
      ,[PNC5_ReferralFacility_Infant_VAL]=X.[PNC5_ReferralFacility_Infant_VAL]
      ,[PNC5_ReferralFacility_Infant]=coalesce(X.PNC5_ReferralFacilityID_Infant ,X.PNC5_ReferralFacility_Infant_Other)
      ,PNC5_Infant_Weight=X.[PNC5_Infant_Weight]
      ,[PNC5_ANM_ID_Infant]=X.[PNC5_ANM_ID_Infant]
      ,[PNC5_ASHA_ID_Infant]=X.[PNC5_ASHA_ID_Infant]
      ,[PNC5_Created_by_Infant]=X.[PNC5_Created_by_Infant]
      ,[PNC5_Mobile_ID_Infant]=X.[PNC5_Mobile_ID_Infant]
      ,[PNC5_Source_ID_Infant]=X.[PNC5_Source_ID_Infant]
      
      ,[PNC6_No_Infant]=X.PNC6_No_Infant
	  ,[PNC6_Type_Infant]=X.[PNC6_Type_Infant]
      ,[PNC6_Date_Infant]=X.[PNC6_Date_Infant]
      ,[PNC6_DangerSign_Infant_VAL]=X.[PNC6_DangerSign_Infant_VAL]
      ,[PNC6_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC6_DangerSign_Infant_VAL]),X.PNC6_DangerSign_Infant_Other) 
      ,[PNC6_ReferralFacility_Infant_VAL]=X.[PNC6_ReferralFacility_Infant_VAL]
      ,[PNC6_ReferralFacility_Infant]=coalesce(X.PNC6_ReferralFacilityID_Infant ,X.PNC6_ReferralFacility_Infant_Other)
      ,PNC6_Infant_Weight=X.[PNC6_Infant_Weight]
      ,[PNC6_ANM_ID_Infant]=X.[PNC6_ANM_ID_Infant]
      ,[PNC6_ASHA_ID_Infant]=X.[PNC6_ASHA_ID_Infant]
      ,[PNC6_Created_by_Infant]=X.[PNC6_Created_by_Infant]
      ,[PNC6_Mobile_ID_Infant]=X.[PNC6_Mobile_ID_Infant]
      ,[PNC6_Source_ID_Infant]=X.[PNC6_Source_ID_Infant]
      
      ,[PNC7_No_Infant]=X.PNC7_No_Infant
	  ,[PNC7_Type_Infant]=X.[PNC7_Type_Infant]
      ,[PNC7_Date_Infant]=X.[PNC7_Date_Infant]
     
      ,[PNC7_DangerSign_Infant_VAL]=X.[PNC7_DangerSign_Infant_VAL]
      ,[PNC7_DangerSign_Infant]=coalesce(dbo.Get_Child_Danger_Sign_Name(X.[PNC7_DangerSign_Infant_VAL]),X.PNC7_DangerSign_Infant_Other) 
      ,[PNC7_ReferralFacility_Infant_VAL]=X.[PNC7_ReferralFacility_Infant_VAL]
      ,[PNC7_ReferralFacility_Infant]=coalesce(X.PNC7_ReferralFacilityID_Infant ,X.PNC7_ReferralFacility_Infant_Other)
      ,PNC7_Infant_Weight=X.[PNC7_Infant_Weight]
      ,[PNC7_ANM_ID_Infant]=X.[PNC7_ANM_ID_Infant]
      ,[PNC7_ASHA_ID_Infant]=X.[PNC7_ASHA_ID_Infant]
      ,[PNC7_Created_by_Infant]=X.[PNC7_Created_by_Infant]
      ,[PNC7_Mobile_ID_Infant]=X.[PNC7_Mobile_ID_Infant]
      ,[PNC7_Source_ID_Infant]=X.[PNC7_Source_ID_Infant]
      
    
      ,[Exec_Date]=getdate()
      from
      (
  
  select InfantRegistration,Case_no, [PNC1_No_Infant],[PNC1_Type_Infant],[PNC1_Date_Infant],[PNC1_DangerSign_Infant_VAL],[PNC1_DangerSign_Infant_Other]
  ,[PNC1_ReferralFacility_Infant_VAL]
 ,[PNC1_ReferralFacilityID_Infant]
,[PNC1_ReferralFacility_Infant_Other],[PNC1_ANM_ID_Infant],[PNC1_ASHA_ID_Infant],[PNC1_Infant_Death_Place],[PNC1_Infant_Death_Date]
,[PNC1_Infant_Death_Reason_VAL],[PNC1_Infant_Death_Reason_other],[PNC1_Created_by_Infant],[PNC1_Mobile_ID_Infant],[PNC1_Source_ID_Infant],[PNC1_Infant_Weight]

,[PNC2_No_Infant],[PNC2_Type_Infant],[PNC2_Date_Infant],[PNC2_DangerSign_Infant_VAL],[PNC2_DangerSign_Infant_Other],[PNC2_ReferralFacility_Infant_VAL]
,[PNC2_ReferralFacilityID_Infant]
,[PNC2_ReferralFacility_Infant_Other],[PNC2_ANM_ID_Infant],[PNC2_ASHA_ID_Infant],[PNC2_Infant_Death_Place],[PNC2_Infant_Death_Date]
,[PNC2_Infant_Death_Reason_VAL],[PNC2_Infant_Death_Reason_other],[PNC2_Created_by_Infant],[PNC2_Mobile_ID_Infant],[PNC2_Source_ID_Infant],[PNC2_Infant_Weight]

,[PNC3_No_Infant],[PNC3_Type_Infant],[PNC3_Date_Infant],[PNC3_DangerSign_Infant_VAL],[PNC3_DangerSign_Infant_Other],[PNC3_ReferralFacility_Infant_VAL]
,[PNC3_ReferralFacilityID_Infant]
,[PNC3_ReferralFacility_Infant_Other],[PNC3_ANM_ID_Infant],[PNC3_ASHA_ID_Infant],[PNC3_Infant_Death_Place],[PNC3_Infant_Death_Date]
,[PNC3_Infant_Death_Reason_VAL],[PNC3_Infant_Death_Reason_other],[PNC3_Created_by_Infant],[PNC3_Mobile_ID_Infant],[PNC3_Source_ID_Infant],[PNC3_Infant_Weight]

,[PNC4_No_Infant],[PNC4_Type_Infant],[PNC4_Date_Infant],[PNC4_DangerSign_Infant_VAL],[PNC4_DangerSign_Infant_Other],[PNC4_ReferralFacility_Infant_VAL]
,[PNC4_ReferralFacilityID_Infant]
,[PNC4_ReferralFacility_Infant_Other],[PNC4_ANM_ID_Infant],[PNC4_ASHA_ID_Infant],[PNC4_Infant_Death_Place],[PNC4_Infant_Death_Date]
,[PNC4_Infant_Death_Reason_VAL],[PNC4_Infant_Death_Reason_other],[PNC4_Created_by_Infant],[PNC4_Mobile_ID_Infant],[PNC4_Source_ID_Infant],[PNC4_Infant_Weight]

,[PNC5_No_Infant],[PNC5_Type_Infant],[PNC5_Date_Infant],[PNC5_DangerSign_Infant_VAL],[PNC5_DangerSign_Infant_Other],[PNC5_ReferralFacility_Infant_VAL]
,[PNC5_ReferralFacilityID_Infant]
,[PNC5_ReferralFacility_Infant_Other],[PNC5_ANM_ID_Infant],[PNC5_ASHA_ID_Infant],[PNC5_Infant_Death_Place],[PNC5_Infant_Death_Date]
,[PNC5_Infant_Death_Reason_VAL],[PNC5_Infant_Death_Reason_other],[PNC5_Created_by_Infant],[PNC5_Mobile_ID_Infant],[PNC5_Source_ID_Infant],[PNC5_Infant_Weight]

,[PNC6_No_Infant],[PNC6_Type_Infant],[PNC6_Date_Infant],[PNC6_DangerSign_Infant_VAL],[PNC6_DangerSign_Infant_Other],[PNC6_ReferralFacility_Infant_VAL]
,[PNC6_ReferralFacilityID_Infant]
,[PNC6_ReferralFacility_Infant_Other],[PNC6_ANM_ID_Infant],[PNC6_ASHA_ID_Infant],[PNC6_Infant_Death_Place],[PNC6_Infant_Death_Date]
,[PNC6_Infant_Death_Reason_VAL],[PNC6_Infant_Death_Reason_other],[PNC6_Created_by_Infant],[PNC6_Mobile_ID_Infant],[PNC6_Source_ID_Infant],[PNC6_Infant_Weight]

,[PNC7_No_Infant],[PNC7_Type_Infant],[PNC7_Date_Infant],[PNC7_DangerSign_Infant_VAL],[PNC7_DangerSign_Infant_Other],[PNC7_ReferralFacility_Infant_VAL]
,[PNC7_ReferralFacilityID_Infant]
,[PNC7_ReferralFacility_Infant_Other],[PNC7_ANM_ID_Infant],[PNC7_ASHA_ID_Infant],[PNC7_Infant_Death_Place],[PNC7_Infant_Death_Date]
,[PNC7_Infant_Death_Reason_VAL],[PNC7_Infant_Death_Reason_other],[PNC7_Created_by_Infant],[PNC7_Mobile_ID_Infant],[PNC7_Source_ID_Infant],[PNC7_Infant_Weight]
from 
(
select InfantRegistration,'PNC'+cast(PNC_No as varchar(4))+'_'+col new_col,value,Case_no from
(select InfantRegistration,Case_no,PNC_No,PNC_Type,PNC_Date,DangerSign_Infant,DangerSign_Infant_Other
,ReferralFacility_Infant,ReferralFacilityID_Infant,ReferralLoationOther_Infant,
ANM_ID,ASHA_ID,Place_of_death ,Infant_Death_Date ,Infant_Death_Reason,Infant_Death_Reason_Other,Created_By,Mobile_ID,SourceID,Infant_Weight
from t_child_pnc  a
inner join t_Schedule_Date_Child_Previous b on a.InfantRegistration=b.Registration_No
where CPNC_Table=1
) t_child_pnc
cross apply
  (
    VALUES
		  
            (cast(PNC_No as nvarchar), 'No_Infant'),
            (cast(PNC_Type as nvarchar), 'Type_Infant'),
			(cast(PNC_Date as nvarchar), 'Date_Infant'),
			(cast(DangerSign_Infant as nvarchar), 'DangerSign_Infant_VAL'),
			(cast(DangerSign_Infant_Other as nvarchar), 'DangerSign_Infant_Other'),
			(cast(ReferralFacility_Infant as nvarchar), 'ReferralFacility_Infant_VAL'),
			(cast(ReferralFacilityID_Infant as nvarchar), 'ReferralFacilityID_Infant'),
			(cast(ReferralLoationOther_Infant as nvarchar), 'ReferralFacility_Infant_Other'),
			(cast(ANM_ID as nvarchar), 'ANM_ID_Infant'),
			(cast(ASHA_ID as nvarchar), 'ASHA_ID_Infant'),
			(cast(Place_of_death as nvarchar), 'Infant_Death_Place'),
			(cast(Infant_Death_Date as nvarchar), 'Infant_Death_Date'),
			(cast(Infant_Death_Reason as nvarchar), 'Infant_Death_Reason_VAL'),
			(cast(Infant_Death_Reason_Other as nvarchar), 'Infant_Death_Reason_other'),
			(cast(Created_By as nvarchar), 'Created_by_Infant'),
			(cast(Mobile_ID as nvarchar), 'Mobile_ID_Infant'),
			(cast(SourceID as nvarchar), 'Source_ID_Infant'),
		    (cast(Infant_Weight as nvarchar),'Infant_Weight')
			
			
			  ) x (value, col)
) src
pivot
(
  max(value)
  for new_col in (
 [PNC1_No_Infant],[PNC1_Type_Infant],[PNC1_Date_Infant],[PNC1_DangerSign_Infant_VAL],[PNC1_DangerSign_Infant_Other],[PNC1_ReferralFacility_Infant_VAL]
 ,[PNC1_ReferralFacilityID_Infant]
,[PNC1_ReferralFacility_Infant_Other],[PNC1_ANM_ID_Infant],[PNC1_ASHA_ID_Infant],[PNC1_Infant_Death_Place],[PNC1_Infant_Death_Date]
,[PNC1_Infant_Death_Reason_VAL],[PNC1_Infant_Death_Reason_other],[PNC1_Created_by_Infant],[PNC1_Mobile_ID_Infant],[PNC1_Source_ID_Infant],[PNC1_Infant_Weight]

,[PNC2_No_Infant],[PNC2_Type_Infant],[PNC2_Date_Infant],[PNC2_DangerSign_Infant_VAL],[PNC2_DangerSign_Infant_Other],[PNC2_ReferralFacility_Infant_VAL]
,[PNC2_ReferralFacilityID_Infant]
,[PNC2_ReferralFacility_Infant_Other],[PNC2_ANM_ID_Infant],[PNC2_ASHA_ID_Infant],[PNC2_Infant_Death_Place],[PNC2_Infant_Death_Date]
,[PNC2_Infant_Death_Reason_VAL],[PNC2_Infant_Death_Reason_other],[PNC2_Created_by_Infant],[PNC2_Mobile_ID_Infant],[PNC2_Source_ID_Infant],[PNC2_Infant_Weight]

,[PNC3_No_Infant],[PNC3_Type_Infant],[PNC3_Date_Infant],[PNC3_DangerSign_Infant_VAL],[PNC3_DangerSign_Infant_Other],[PNC3_ReferralFacility_Infant_VAL]
,[PNC3_ReferralFacilityID_Infant]
,[PNC3_ReferralFacility_Infant_Other],[PNC3_ANM_ID_Infant],[PNC3_ASHA_ID_Infant],[PNC3_Infant_Death_Place],[PNC3_Infant_Death_Date]
,[PNC3_Infant_Death_Reason_VAL],[PNC3_Infant_Death_Reason_other],[PNC3_Created_by_Infant],[PNC3_Mobile_ID_Infant],[PNC3_Source_ID_Infant],[PNC3_Infant_Weight]

,[PNC4_No_Infant],[PNC4_Type_Infant],[PNC4_Date_Infant],[PNC4_DangerSign_Infant_VAL],[PNC4_DangerSign_Infant_Other],[PNC4_ReferralFacility_Infant_VAL]
,[PNC4_ReferralFacilityID_Infant]
,[PNC4_ReferralFacility_Infant_Other],[PNC4_ANM_ID_Infant],[PNC4_ASHA_ID_Infant],[PNC4_Infant_Death_Place],[PNC4_Infant_Death_Date]
,[PNC4_Infant_Death_Reason_VAL],[PNC4_Infant_Death_Reason_other],[PNC4_Created_by_Infant],[PNC4_Mobile_ID_Infant],[PNC4_Source_ID_Infant],[PNC4_Infant_Weight]

,[PNC5_No_Infant],[PNC5_Type_Infant],[PNC5_Date_Infant],[PNC5_DangerSign_Infant_VAL],[PNC5_DangerSign_Infant_Other],[PNC5_ReferralFacility_Infant_VAL]
,[PNC5_ReferralFacilityID_Infant]
,[PNC5_ReferralFacility_Infant_Other],[PNC5_ANM_ID_Infant],[PNC5_ASHA_ID_Infant],[PNC5_Infant_Death_Place],[PNC5_Infant_Death_Date]
,[PNC5_Infant_Death_Reason_VAL],[PNC5_Infant_Death_Reason_other],[PNC5_Created_by_Infant],[PNC5_Mobile_ID_Infant],[PNC5_Source_ID_Infant],[PNC5_Infant_Weight]

,[PNC6_No_Infant],[PNC6_Type_Infant],[PNC6_Date_Infant],[PNC6_DangerSign_Infant_VAL],[PNC6_DangerSign_Infant_Other],[PNC6_ReferralFacility_Infant_VAL]
,[PNC6_ReferralFacilityID_Infant]
,[PNC6_ReferralFacility_Infant_Other],[PNC6_ANM_ID_Infant],[PNC6_ASHA_ID_Infant],[PNC6_Infant_Death_Place],[PNC6_Infant_Death_Date]
,[PNC6_Infant_Death_Reason_VAL],[PNC6_Infant_Death_Reason_other],[PNC6_Created_by_Infant],[PNC6_Mobile_ID_Infant],[PNC6_Source_ID_Infant],[PNC6_Infant_Weight]

,[PNC7_No_Infant],[PNC7_Type_Infant],[PNC7_Date_Infant],[PNC7_DangerSign_Infant_VAL],[PNC7_DangerSign_Infant_Other],[PNC7_ReferralFacility_Infant_VAL]
,[PNC7_ReferralFacilityID_Infant]
,[PNC7_ReferralFacility_Infant_Other],[PNC7_ANM_ID_Infant],[PNC7_ASHA_ID_Infant],[PNC7_Infant_Death_Place],[PNC7_Infant_Death_Date]
,[PNC7_Infant_Death_Reason_VAL],[PNC7_Infant_Death_Reason_other],[PNC7_Created_by_Infant],[PNC7_Mobile_ID_Infant],[PNC7_Source_ID_Infant],[PNC7_Infant_Weight]
)
) piv
  
  
  ) X
  
  where t_child_flat.Registration_no=X.InfantRegistration

----and CONVERT(date, a.Exec_Date)=CONVERT(date,GETDATE())


--update [t_workplanChild] set flag=1 where Immu_Date is not null and flag is null
----update [t_workplanChild] set flag=2 where Immu_Date is null and Maxdate<CONVERT(date,GETDATE()) and CONVERT(date,Created_On)=CONVERT(date,GETDATE())
--update [t_workplanChild] set flag=0 where flag is null  and Immu_Date is null

--Delete from [t_workplanChild] where Immu_Code=7 and Immu_Date is null  
--and Registration_no in (select Registration_no from [t_workplanChild] where Immu_Code=16 and Immu_Date is not null)

--Delete from [t_workplanChild] where Immu_Code=13 and Immu_Date is null  
--and Registration_no in (select Registration_no from [t_workplanChild] where Immu_Code=16 and Immu_Date is not null)
  
--Delete from [t_workplanChild] where Immu_Code=16 and Immu_Date is null  
--and Registration_no in (select Registration_no from [t_workplanChild] where Immu_Code=7 and Immu_Date is not null)
exec tp_child_flat_Count_Inup

exec tp_Workplan_Child_Inup
end

end

