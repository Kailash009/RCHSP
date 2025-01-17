USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Migrate_Potential_EC_Select]    Script Date: 09/26/2024 12:09:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*     
[Migrate_Potential_EC_Select] 21,17,310,1172,4822,20944,2014,'srcEligible'    
    
[Migrate_Potential_EC_Select] 91,18,417,1448,0,0,2011,'srcMigEligible'   

[Migrate_Potential_EC_Select] 30,1,3,13,27,10000051,2013,'srcMigEligible'   
    
*/    
ALTER proc [dbo].[Migrate_Potential_EC_Select]    
(    
 @State_Code int,    
 @District_Code int,    
 @HealthBlock_Code int,    
 @HealthFacility_Code int,    
 @HealthSubFacility_Code int,    
 @Village_Code int,    
 @Financial_Year int,    
 @Category varchar(20)    
)    
as    
begin    
 if(@Category = 'srcEligible')    
 begin    
    select      
     sc.Name_E + '(' + cast(sc.[SID] as nvarchar(7)) + ')' as SubCentre    
     ,isnull(v.Name_E,'Direct Data Entry') + '(' + cast(isnull(v.VCode,0) as varchar(7)) + ')' as Village    
     ,'' as [Registration_no]    
     ,Convert(varchar(21),[ID_No])as MCTS_ID_No    
    ,[Name_wife] as Name    
    ,[Name_husband] as Husband_Father    
    ,e.Wife_current_age as Age    
    ,e.Mobile_no as Mobile_No    
    ,(case e.[Status] when 'A' then 'Active' when 'I' then 'Inactive' end) as [Status]    
    ,(Case when e.Eligible='I' and e.Registration_no=0 then '*' else '&nbsp&nbsp' end) IsMotherEC    
    from m_eligibleCouples e    
    left outer join State s on s.StateID=e.State_Code    
    left outer join District d on d.DCode=e.District_Code    
    inner join Health_Block b on b.BID=e.HealthBlock_Code    
    inner join Health_PHC p on p.PID=e.HealthFacility_Code    
    left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code    
    left outer join Village v on v.VCode=e.Village_Code    
    where     
    e.Registration_no not in(select Registration_no from t_temp) and    
    e.State_Code=@State_Code and e.District_Code=@District_Code and     
    e.HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code    
    and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)    
    and (e.Village_Code=@Village_Code or @Village_Code=0)    
    and e.Financial_Year=@Financial_Year    
    and ID_No is not null and ID_No<>''    
    and e.Registration_no=0    
    and ISNULL(Delete_Mother,0)=0    
    order by SubCentre,Village,[Name_wife]    
 end    
 if(@Category = 'srcMigEligible')    
 begin    
   select sc.Name_E + '(' + cast(sc.[SID] as nvarchar(7)) + ')' as SubCentre,    
     isnull(v.Name_E,'Direct Data Entry') + '(' + cast(isnull(v.VCode,0) as varchar(7)) + ')' as Village    
    ,e.[Registration_no]    
    ,Convert(varchar(21),e.[ID_No])as MCTS_ID_No    
    ,[Name_wife] as Name    
    ,[Name_husband] as Husband_Father    
    ,e.Wife_current_age as Age    
    ,e.Mobile_no as Mobile_No    
    ,(case e.[Status] when 'A' then 'Active' when 'I' then 'Inactive' end) as [Status],    
    (case [Pregnant] when 'Y' then 'Yes' when 'N' then 'No' when 'D' then 'Dont Know' else '--' end)as Pregnant    
    ,(Case when e.Eligible='I' and md.Registration_no IS null then '*' else '&nbsp&nbsp' end) IsMotherEC    
    from t_eligibleCouples e
    inner join  t_temp t on t.Registration_no=e.Registration_no and t.Case_no=e.Case_no
    left outer join State s on s.StateID=e.State_Code    
    left outer join District d on d.DCode=e.District_Code    
    inner join Health_Block b on b.BID=e.HealthBlock_Code    
    inner join Health_PHC p on p.PID=e.HealthFacility_Code    
    left outer join Health_SubCentre sc on sc.SID=e.HealthSubFacility_Code    
    left outer join Village v on v.VCode=e.Village_Code    
    left outer join t_mother_delivery md on e.Registration_no=md.Registration_no and e.Case_no=md.Case_no    
    where     
    e.State_Code=@State_Code and e.District_Code=@District_Code and     
    e.HealthBlock_Code=@HealthBlock_Code and e.HealthFacility_Code=@HealthFacility_Code    
    and (e.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)    
    and (e.Village_Code=@Village_Code or @Village_Code=0)    
    and e.Financial_Year=@Financial_Year    
    and e.ID_No is not null and e.ID_No<>'' and ISNULL(Delete_Mother,0)=0    
    and Status='A' and e.Case_no=1  
    order by SubCentre,Village,[Name_wife]     end    
 if(@Category = 'srcMother')    
 begin    
    select sc.Name_E + '(' + cast(sc.[SID] as nvarchar(7)) + ')' as SubCentre    
    ,isnull(v.Name_E,'Direct Data Entry') + '(' + cast(isnull(v.VCode,0) as varchar(7)) + ')' as Village    
    ,e.[Registration_no]    
    ,Convert(varchar(21),e.[ID_No])as MCTS_ID_No    
    ,[Name_PW] as Name    
    ,[Name_H] as Husband_Father    
      ,Age,Mobile_No    
      ,'' as [Status]    
      ,'' as Pregnant    
      ,'' as IsMotherEC    
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
     
end    

