USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[log_inup]    Script Date: 09/26/2024 14:27:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[log_inup]

AS BEGIN
declare @msg nvarchar(MAX) 
--select * from t_mother_infant_intermediate
 BEGIN TRY
begin tran Test
--insert into generic_table_master (Table_name,pK_fieldName) values('t_mother_infant_intermediate','Registration_no, Case_no')
--  insert into generic_column_master (Field_name,TableID) values('Mother_Death',1)

create Table #t(Registration_no bigint,Case_no bigint,Mother_Death bit)
insert into #t (Registration_no,Case_no,Mother_Death)


 ( select distinct a.Registration_no,a.Case_no,e.Mother_Death from t_mother_registration  a inner join
t_mother_ANC b on  a.Registration_no = b.Registration_no and a.Case_no = b.Case_no inner join
t_mother_infant_intermediate e on a.Registration_no = e.Registration_no and a.Case_no = e.Case_no
 where e.Mother_Death = 1 and b.Maternal_Death = 0  and b.ANC_Type= 0 and isnull(entry_type,0)<>1 and isnull(a.Delete_Mother,0)<>1)
 except
 (
  select distinct a.Registration_no,a.Case_no,e.Mother_Death
from t_mother_registration  a inner join
t_mother_ANC b on  a.Registration_no = b.Registration_no and a.Case_no = b.Case_no inner join 
t_mother_Delivery c on a.Registration_no = c.Registration_no and a.Case_no = c.Case_no inner join
t_mother_infant_intermediate e on a.Registration_no = e.Registration_no and a.Case_no = e.Case_no
 where e.Mother_Death = 1 and b.Maternal_Death = 0  
 and b.ANC_Type= 0 and isnull(entry_type,0)<>1 and isnull(a.Delete_Mother,0)<>1 and isnull(death_cause,0) <>0
 )
  except
  (
    select distinct a.Registration_no,a.Case_no,e.Mother_Death
from t_mother_registration  a inner join
t_mother_ANC b on  a.Registration_no = b.Registration_no and a.Case_no = b.Case_no inner join 
t_mother_pnc d on a.Registration_no = d.Registration_no and a.Case_no = d.Case_no inner join
t_mother_infant_intermediate e on a.Registration_no = e.Registration_no and a.Case_no = e.Case_no
 where e.Mother_Death = 1 and b.Maternal_Death = 0  
  and b.ANC_Type= 0  and isnull(entry_type,0)<>1 and isnull(a.Delete_Mother,0)<>1 and d.Mother_Death =1
  )


--select distinct a.Registration_no,a.Case_no,e.Mother_Death
--from t_mother_registration  a inner join
--t_mother_ANC b on  a.Registration_no = b.Registration_no and a.Case_no = b.Case_no inner join 
--t_mother_Delivery c on a.Registration_no = c.Registration_no and a.Case_no = c.Case_no inner join
--t_mother_pnc d on a.Registration_no = d.Registration_no and a.Case_no = d.Case_no inner join
--t_mother_infant_intermediate e on a.Registration_no = e.Registration_no and a.Case_no = e.Case_no
-- where e.Mother_Death = 1 and b.Maternal_Death = 0  and d.Mother_Death = 0 and b.ANC_Type= 0 and isnull(death_cause,0) =0 and isnull(entry_type,0)<>1
 

 
 
--select * from user_master where user_name='mcts-helpdesk'--userid=114
-- -- insert into change_group(ChageDateTime,userid,Remarks) values(getdate(),'114','Manual updation')-- userid should come from user_master

insert into Generic_Log_table(GroupID,FieldID,old_value,New_value,Registration_no,Case_no)
select 1,1,Mother_Death,0,Registration_no,Case_no from #t 
--select count(1) from #t where  Mother_Death=1
--select count(1) from   t_mother_infant_intermediate i inner join #t t on i.Registration_no=t.Registration_no and i.Case_no=t.Case_no
--Begin tran;update t_mother_infant_intermediate set Mother_Death=0 from t_mother_infant_intermediate i inner join #t t on i.Registration_no=t.Registration_no and i.Case_no=t.Case_no

--commit tran
set @msg = 'Record saved successfully !!!' 

Commit tran Test
      
END TRY
BEGIN CATCH
 ROLLBACK Tran Test
END CATCH 

end
