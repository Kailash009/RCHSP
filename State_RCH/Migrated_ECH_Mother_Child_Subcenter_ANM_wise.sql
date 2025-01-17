USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Migrated_ECH_Mother_Child_Subcenter_ANM_wise]    Script Date: 09/26/2024 12:10:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* 
Migrated_ECH_Mother_Child_Subcenter_ANM_wise 3,6,96,339,1740,6036,2014,'srcChild'
Migrated_ECH_Mother_Child_Subcenter_ANM_wise 27,1,137,1048,5269,32528,2011,'mother'
Migrated_ECH_Mother_Child_Subcenter_ANM_wise 27,1,137,1048,5269,32528,2011,'child'

[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,3,11,0,0,2014,'ANM'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,3,11,232,0,2013,'srcMother'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,3,11,232,10000184,2013,'srcEligible'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,3,11,0,0,2014,'srcChild'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,1,1,1,21,2014,'srcEligible'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,1,1,1,21,2014,'srcMother'
[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 30,1,1,1,1,21,2014,'ANM'

[Migrated_ECH_Mother_Child_Subcenter_ANM_wise] 2,6,36,701,2193,0,2015,'srcMother'
*/
ALTER PROC [dbo].[Migrated_ECH_Mother_Child_Subcenter_ANM_wise]
(
	@State_Code int,
	@District_Code int,
	@HealthBlock_Code int,
	@HealthFacility_Code int,
	@HealthSubFacility_Code int,
	@Village_Code int,
	@Financial_Year int,
	--@ANM_ID int,
    @Category varchar(20)
)
as
begin
if(@Category = 'srcEligibleInactive')
begin
	select 
	  (select Migrated_Mother_DataAsOn from m_lastId_mother)as Data_Ason,
	   sc.Name_E as SubCentre,
	   isnull(v.Name_E,'Direct Data Entry') as Village,
	   --e.[Financial_Year]
      [Registration_no]
      ,Convert(varchar(21),[ID_No])as MCTS_ID_No
      ,[Name_wife] as Name
      ,[Name_husband] as Husband_Father
      ,e.Wife_current_age as Age
      ,e.Mobile_no as Mobile_No
      ,(g.Name + ' (' + cast([ANM_ID] as varchar) + ')') as [ANM Name(id)]
      ,(isnull(g1.Name,'ASHA Not Available') +' ('+ isnull(cast([ASHA_ID]as varchar),0) + ')')as [ASHA Name(id)],
      (case e.[Status] when 'A' then 'Active' when 'I' then 'Inactive' end) as [Status],
      (case [Pregnant] when 'Y' then 'Yes' when 'N' then 'No' when 'D' then 'Dont Know' else '--' end)as Pregnant
	  from t_eligibleCouples e
	  inner join District d on d.DCode=e.District_Code
	  inner join Health_Block b on b.BID=e.HealthBlock_Code
	  inner join Health_PHC p on p.PID=e.HealthFacility_Code
	  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
	  left outer join Village v on v.VCode=e.Village_Code
	  left outer join t_Ground_Staff g on g.ID=e.ANM_ID
	  left outer join t_Ground_Staff g1 on g1.ID=e.ASHA_ID
	  where 
	  e.Registration_no in(select Registration_no from t_temp) and
	  e.State_Code=@State_Code and e.District_Code=@District_Code and 
	  e.HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code
	  and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	  and (e.Village_Code=@Village_Code or @Village_Code=0)
	  and e.Financial_Year=@Financial_Year
	  and ID_No is not null and ID_No<>'' and ISNULL(Delete_Mother,0)=0
	  --and Eligible='E' 
	  and Status='I'
	  order by SubCentre,Village,[Name_wife]
end
if(@Category = 'srcEligible')
begin
	select 
	  (select Migrated_Mother_DataAsOn from m_lastId_mother)as Data_Ason,
	   sc.Name_E as SubCentre,
	   isnull(v.Name_E,'Direct Data Entry') as Village,
	   --e.[Financial_Year]
      [Registration_no]
      ,Convert(varchar(21),[ID_No])as MCTS_ID_No
      ,[Name_wife] as Name
      ,[Name_husband] as Husband_Father
      ,e.Wife_current_age as Age
      ,e.Mobile_no as Mobile_No
      ,(g.Name + ' (' + cast([ANM_ID] as varchar) + ')') as [ANM Name(id)]
      ,(isnull(g1.Name,'ASHA Not Available') +' ('+ isnull(cast([ASHA_ID]as varchar),0) + ')')as [ASHA Name(id)],
      (case e.[Status] when 'A' then 'Active' when 'I' then 'Inactive' end) as [Status],
      (case [Pregnant] when 'Y' then 'Yes' when 'N' then 'No' when 'D' then 'Dont Know' else '--' end)as Pregnant
	  from t_eligibleCouples e
	  inner join District d on d.DCode=e.District_Code
	  inner join Health_Block b on b.BID=e.HealthBlock_Code
	  inner join Health_PHC p on p.PID=e.HealthFacility_Code
	  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
	  left outer join Village v on v.VCode=e.Village_Code
	  left outer join t_Ground_Staff g on g.ID=e.ANM_ID
	  left outer join t_Ground_Staff g1 on g1.ID=e.ASHA_ID
	  where 
	  e.Registration_no in(select Registration_no from t_temp) and
	  e.State_Code=@State_Code and e.District_Code=@District_Code and 
	  e.HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code
	  and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	  and (e.Village_Code=@Village_Code or @Village_Code=0)
	  and e.Financial_Year=@Financial_Year
	  and ID_No is not null and ID_No<>'' and ISNULL(Delete_Mother,0)=0
	  and Status='A'
	  order by SubCentre,Village,[Name_wife]
end
if(@Category = 'srcMother')
begin
	select (select Migrated_Mother_DataAsOn from m_lastId_mother)as Data_Ason,
	   sc.Name_E as SubCentre
	   ,isnull(v.Name_E,'Direct Data Entry') as Village
	   ,e.[Registration_no],Convert(varchar(21),e.[ID_No])as MCTS_ID_No,[Name_PW] as Name,[Name_H] as Husband_Father
      ,Age
      ,e.Mobile_no as Mobile_No
      ,(Case when t.Registration_no is not null then 1 else 0 end)as delflag
      ,(g.Name + ' (' + cast(g.ID as varchar) + ')') as [ANM Name(id)]
      ,(isnull(g1.Name,'ASHA Not Available') +' ('+ isnull(cast(g1.ID as varchar),0) + ')')as [ASHA Name(id)],
      '' as [Status],
      '' as Pregnant
      from t_mother_registration e
      left outer join t_temp t on e.Registration_no=t.Registration_no
	  inner join District d on d.DCode=e.District_Code
	  inner join Health_Block b on b.BID=e.HealthBlock_Code
	  inner join Health_PHC p on p.PID=e.HealthFacility_Code
	  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
	  left outer join Village v on v.VCode=e.Village_Code
	  left outer join t_Ground_Staff g on g.ID=e.ANM_ID
	  left outer join t_Ground_Staff g1 on g1.ID=e.ASHA_ID
	     where 
	 e.State_Code=@State_Code and e.District_Code=@District_Code and 
	  e.HealthBlock_Code=@HealthBlock_Code
	 and e.HealthFacility_Code=@HealthFacility_Code
	 and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	 and (e.Village_Code=@Village_Code or @Village_Code=0)
	 and e.Financial_Year=@Financial_Year
	 and e.ID_No is not null and ISNULL(Delete_Mother,0)=0
	 and e.Registration_no not in (select Registration_no from t_temp)
	order by  SubCentre,Village,[Name_PW]
end
if(@Category = 'srcChild')
begin
	select 
	  (select Migrated_Child_DataAsOn from m_lastId)as Data_Ason,
	   sc.Name_E as SubCentre,
	   isnull(v.Name_E,'Direct Data Entry') as Village,
	  --e.[Financial_Year]
      [Registration_no]
      ,Convert(varchar(21),[Mother_ID_No])as Mother_ID_No
      ,Convert(varchar(21),[ID_No])as MCTS_ID_No
      ,e.Name_Child as Name
      ,e.Name_Mother as Mother_Name
      ,(case when LEN(e.Name_Father)>0 and e.Name_Father is not null then e.Name_Father else '--' end) as Husband_Father
      ,DATEDIFF(year,Birth_Date,Registration_Date) as Age
      ,(e.Mobile_no)Mobile_No
      ,(g.Name + ' (' + cast([ANM_ID] as varchar) + ')') as [ANM Name(id)]
      ,(isnull(g1.Name,'ASHA Not Available') +' ('+ isnull(cast([ASHA_ID]as varchar),0) + ')')as [ASHA Name(id)],
      '' as [Status],
      '' as Pregnant
      from t_children_registration e
	  inner join District d on d.DCode=e.District_Code
	  inner join Health_Block b on b.BID=e.HealthBlock_Code
	  inner join Health_PHC p on p.PID=e.HealthFacility_Code
	  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
	  left outer join Village v on v.VCode=e.Village_Code
	  left outer join t_Ground_Staff g on g.ID=e.ANM_ID
	  left join t_Ground_Staff g1 on g1.ID=e.ASHA_ID 
      where e.State_Code=@State_Code and e.District_Code=@District_Code and 
	  e.HealthBlock_Code=@HealthBlock_Code 
	  and HealthFacility_Code=@HealthFacility_Code
	  and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
	  and (e.Village_Code=@Village_Code or @Village_Code=0) 
	  and e.Financial_Year=@Financial_Year
	  and ID_No is not null and ISNULL(Delete_Mother,0)=0 order by SubCentre,Village,Name_Child
end
if(@Category = 'ANM')
	  begin
		  select (select Migrated_ANM_ASHA_DataAsOn from m_lastId)as Data_Ason,
		  sc.Name_E as SubCentre,
	      isnull(v.Name_E,'Direct Data Entry') as Village,
	      e.ID as Registration_no,
	      (case e.Type_ID when 2 then 'ANM' when 3 then 'ANM2' when 4 then 'LINK WORKER' when 5 then 'MPW' when 6 then 'GNM' when 7 then 'CHV' when 8 then 'AWW' end)as [Type_Name],
	      e.Name as Name,
	      e.Contact_No as Mobile_No,
	      (case e.Sex when 'M' then 'Male' when 'F' then 'Female' end) as Sex
		  from t_Ground_Staff e
		 inner join District d on d.DCode=e.District_Code
		  inner join Health_Block b on b.BID=e.HealthBlock_Code
		  inner join Health_PHC p on p.PID=e.HealthFacilty_Code
		  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
		  left outer join Village v on v.VCode=e.Village_Code
		  where e.State_Code=@State_Code and e.District_Code=@District_Code and 
		  e.HealthBlock_Code=@HealthBlock_Code 
		  and HealthFacilty_Code=@HealthFacility_Code
		  and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
		  and (e.Village_Code=@Village_Code or @Village_Code=0) 
		  and Is_Active=1 and Type_ID not in(1)
	  end
	  if(@Category = 'ASHA')
	  begin
		  select (select Migrated_ANM_ASHA_DataAsOn from m_lastId)as Data_Ason,
		  sc.Name_E as SubCentre,
	      isnull(v.Name_E,'Direct Data Entry') as Village,
	      e.ID as Registration_no,
	      (e.Type_ID)as [Type_Name],
	      e.Name as Name,
	      e.Contact_No as Mobile_No,
	      (case e.Sex when 'M' then 'Male' when 'F' then 'Female' end) as Sex
		  from t_Ground_Staff e
		  inner join District d on d.DCode=e.District_Code
		  inner join Health_Block b on b.BID=e.HealthBlock_Code
		  inner join Health_PHC p on p.PID=e.HealthFacilty_Code
		  left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code
		  left outer join Village v on v.VCode=e.Village_Code
		  where e.State_Code=@State_Code and e.District_Code=@District_Code and 
		  e.HealthBlock_Code=@HealthBlock_Code 
		  and HealthFacilty_Code=@HealthFacility_Code
		  and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
		  and (e.Village_Code=@Village_Code or @Village_Code=0) 
		  and Is_Active=1 and Type_ID=1
	  end
	  
end





