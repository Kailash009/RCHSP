USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_ListOfSearchPW]    Script Date: 09/26/2024 14:48:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  
  
/*  
tp_ListOfSearchPW 32,3,25,634,2412,10004737,'',0,'0',2017,0,'','',1,'0','S',0,2  
tp_ListOfSearchPW 29,2,15,222,28,1692,'',0,'0',2022,0,'','',1,'0','S',0,7  
*/  
ALTER procedure [dbo].[tp_ListOfSearchPW]      
(      
@State_Code int      
,@District_Code int =0      
,@HealthBlock_Code int =0       
,@HealthFacility_Code int =0        
,@HealthSubFacility_Code int =0       
,@Village_Code int  =0    
,@MctsID varchar(18)=''    
,@Registration_no bigint =0    
,@Mobile_no varchar(10) ='0'     
,@Financial_Year int    
,@Register_srno int =0    
,@Name_wife nvarchar(99)=''    
,@Name_husband nvarchar(99)=''    
,@Flag bit=0    
,@WhoseMobile_no char(1)='0'    
,@JSY_Beneficiary char(1)='S'    
,@IsMCTSRCH tinyint    
,@TypeReport int     
)      
as      
begin      
SET NOCOUNT ON      
declare @SQL varchar (max)=null, @Case_no varchar(200)    
if(@TypeReport = 2) --Mother Registration    
begin    
set @SQL ='select r.SNo, r.Registration_no,r.Register_srno    
,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis    
,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband    
,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile    
,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test       
,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes       
,'''' as Edit,e.Case_no,ISNULL(r.Financial_Year,0) as Financial_Year,r.Flag,r.ID_No   
,(case Page_Code  when ''MR'' then ''PG-1'' when ''MM'' then ''PG-2'' when ''MA'' then ''Mother ANC'' when ''MD'' then ''Delivery Outcome''   
  when ''MI'' then ''Mother Infant'' when ''MP'' then ''Mother PNC'' when ''IP'' then ''Infant PNC''  else '''' end) as Page_Code   
   
from t_mother_registration r (nolock)     
inner join t_eligibleCouples e (nolock) on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no    
inner join t_page_tracking pt (nolock) on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no   
left outer join TBL_SUBPHC a (nolock) on r.HealthSubFacility_Code=a.SUBPHC_CD  
where e.Eligible=''I'' and isnull(r.Delete_Mother,0)<>1 and pt.Is_Previous_Current=1  
and((Pregnant=''Y'' and Pregnant_test=''P'') or (Pregnant=''Y'' and Pregnant_test=''D'') or (Pregnant=''D'' and Pregnant_test=''P''))    
and r.Flag='+CAST(@Flag as varchar(1)) +' '   
    
if(@Registration_no<>'' and @Registration_no<>0)    
begin    
set @SQL= @SQL + ' and  r.Registration_no='+ cast(@Registration_no as varchar(12))    
end    
else if(@MctsID<>'' and @MctsID<>'0')    
begin    
set @SQL= @SQL + ' and r.ID_No=''' + cast(@MctsID as varchar(18))+ ''''    
end    
  
else    
begin    
 set @SQL = @SQL + '  and isnull(a.PHC_CD,r.HealthFacility_Code)='+cast(@HealthFacility_Code as varchar(4))    
    
 if(@HealthSubFacility_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code=0'    
    end    
    else if(@HealthSubFacility_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))    
    end    
       
    if(@Village_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code=0'    
    end    
    else if(@Village_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code='+cast(@Village_Code as varchar(8))    
    end    
    if(@Financial_Year<>0)    
    begin    
  set @SQL = @SQL + ' and r.Financial_Year='+cast(@Financial_Year as varchar(4))    
    end    
    if(@Register_srno<>0)    
    begin    
  set @SQL = @SQL + ' and r.Register_srno='+cast(@Register_srno as varchar(4))    
    end    
     if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
  set @SQL= @SQL + ' and r.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Name_wife<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'''    
    end    
    if(@Name_husband<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'''    
    end    
    if(@WhoseMobile_no<>'0')    
    begin    
  set @SQL = @SQL + ' and r.Mobile_Relates_To = '''+cast(@WhoseMobile_no as varchar(1))+''''    
    end   
    if(@JSY_Beneficiary<>'S')  
    begin  
  set @SQL = @SQL + ' and r.JSY_Beneficiary = '''+cast(@JSY_Beneficiary as varchar(1))+''''    
    end  
       
 if(@IsMCTSRCH = 1) --MCTS      
 begin    
  set @SQL = @SQL + ' and r.ID_No is not null and r.ID_no<>'''''    
 end    
 else    
 begin    
  set @SQL = @SQL + '  and isnull(r.ID_No,'''')='''''    
 end    
   
     
  
    
end    
end    
else if(@TypeReport = 4) -- UnRegistered Mother    
begin    
set @SQL ='select r.SNo, r.Registration_no,r.Register_srno    
,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis    
,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband    
,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile    
,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test       
,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes       
,'''' as Edit,e.Case_no,ISNULL(e.Financial_Year,0) as Financial_Year,r.Flag,r.ID_No  
,(case Page_Code  when ''MR'' then ''PG-1'' when ''MM'' then ''PG-2'' when ''MA'' then ''Mother ANC'' when ''MD'' then ''Delivery Outcome''   
  when ''MI'' then ''Mother Infant'' when ''MP'' then ''Mother PNC'' when ''IP'' then ''Infant PNC''  else '''' end) as Page_Code   
  
 from t_mother_registration r (nolock)    
inner join t_eligibleCouples e (nolock) on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no    
inner join t_page_tracking pt (nolock) on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no   
left outer join TBL_SUBPHC a (nolock) on r.HealthSubFacility_Code=a.SUBPHC_CD  
where e.Eligible=''I''   
and ((Pregnant=''Y'' and Pregnant_test=''P'') or (Pregnant=''Y'' and Pregnant_test=''D'') or (Pregnant=''D'' and Pregnant_test=''P''))    
and isnull(r.Delete_Mother,0)<>1 and pt.Is_Previous_Current=1  
and r.Flag='+CAST(@Flag as varchar(1)) +' '     
    
if(@Registration_no<>'' and @Registration_no<>0)    
begin    
set @SQL= @SQL + ' r.Registration_no='+ cast(@Registration_no as varchar(12))    
end    
else if(@MctsID<>'')    
begin    
set @SQL= @SQL + ' r.ID_No='+ '''' + cast(@MctsID as varchar(18))+ ''''    
end    
else    
begin    
 set @SQL = @SQL + '  and isnull(a.PHC_CD,r.HealthFacility_Code)='+cast(@HealthFacility_Code as varchar(4))    
    
 if(@HealthSubFacility_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code=0'    
    end    
    else if(@HealthSubFacility_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))    
    end    
       
    if(@Village_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code=0'    
    end    
    else if(@Village_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code='+cast(@Village_Code as varchar(8))    
    end    
    if(@Financial_Year<>0)    
    begin    
  set @SQL = @SQL + ' and e.Financial_Year='+cast(@Financial_Year as varchar(4))    
    end    
    if(@Register_srno<>0)    
    begin    
  set @SQL = @SQL + ' and r.Register_srno='+cast(@Register_srno as varchar(4))    
    end    
     if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
  set @SQL= @SQL + ' and r.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Name_wife<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'''    
    end    
    if(@Name_husband<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'''    
    end    
    if(@WhoseMobile_no<>'0')       
     begin    
  set @SQL = @SQL + ' and r.Mobile_Relates_To = '''+cast(@WhoseMobile_no as varchar(1))+''''    
    end   
    if(@JSY_Beneficiary<>'S')  
    begin  
  set @SQL = @SQL + ' and r.JSY_Beneficiary = '''+cast(@JSY_Beneficiary as varchar(1))+''''    
    end  
       
 if(@IsMCTSRCH = 1) --MCTS      
 begin    
  set @SQL = @SQL + ' and e.ID_No is not null and e.ID_no<>'''''    
 end    
 else    
 begin    
  set @SQL = @SQL + '  and isnull(e.ID_No,'''')='''''    
 end    
          
end    
    
end    
else if(@TypeReport = 5) -- Mother Case Unclosed Records    
begin    
set @SQL ='select r.SNo, r.Registration_no,r.Register_srno    
,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis    
,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband    
,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile    
,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test       
,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes       
,'''' as Edit,e.Case_no,ISNULL(r.Financial_Year,0) as Financial_Year,r.Flag,r.ID_No  
,(case Page_Code  when ''MR'' then ''PG-1'' when ''MM'' then ''PG-2'' when ''MA'' then ''Mother ANC'' when ''MD'' then ''Delivery Outcome''   
  when ''MI'' then ''Mother Infant'' when ''MP'' then ''Mother PNC'' when ''IP'' then ''Infant PNC''  else '''' end) as Page_Code   
  
 from t_mother_registration r (nolock)   
inner join t_eligibleCouples e (nolock) on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no    
inner join t_page_tracking pt (nolock) on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no   
left outer join TBL_SUBPHC a (nolock) on r.HealthSubFacility_Code=a.SUBPHC_CD    
--where e.Eligible=''I''  and isnull(r.Delete_Mother,0)<>1 and pt.Is_Previous_Current=0    
where  isnull(r.Delete_Mother,0)<>1 and pt.Is_Previous_Current=0    
and ((Pregnant=''Y'' and Pregnant_test=''P'') or (Pregnant=''Y'' and Pregnant_test=''D'') or (Pregnant=''D'' and Pregnant_test=''P''))    
and r.Flag='+CAST(@Flag as varchar(1))+''    
    
if(@Registration_no<>'' and @Registration_no<>0)    
begin    
 set @SQL= @SQL + ' and r.Registration_no='+ cast(@Registration_no as varchar(12))    
end    
else if(@MctsID<>'')    
begin    
 set @SQL= @SQL + ' and r.ID_No='+ '''' + cast(@MctsID as varchar(18))+ ''''    
end    
   
else    
begin    
    
  set @SQL = @SQL + ' and isnull(a.PHC_CD,r.HealthFacility_Code)='+cast(@HealthFacility_Code as varchar(4))    
    if(@HealthSubFacility_Code=999999)     
    begin    
   set @SQL = @SQL + ' and r.HealthSubFacility_Code=0'    
    end    
    else if(@HealthSubFacility_Code<>0)     
    begin    
   set @SQL = @SQL + ' and r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))    
    end    
       
    if(@Village_Code=999999)     
    begin    
   set @SQL = @SQL + ' and r.Village_Code=0'    
    end    
    else if(@Village_Code<>0)     
    begin    
   set @SQL = @SQL + ' and r.Village_Code='+cast(@Village_Code as varchar(8))    
    end    
    if(@Financial_Year<>0)    
    begin    
   set @SQL = @SQL + ' and r.Financial_Year='+cast(@Financial_Year as varchar(4))    
    end    
    if(@Register_srno<>0)    
    begin    
  set @SQL = @SQL + ' and r.Register_srno='+cast(@Register_srno as varchar(4))    
    end    
     if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
   set @SQL= @SQL + ' and r.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Name_wife<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'''    
    end    
    if(@Name_husband<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'''    
    end    
    if(@WhoseMobile_no<>'0')    
    begin    
  set @SQL = @SQL + ' and r.Mobile_Relates_To = '''+cast(@WhoseMobile_no as varchar(1))+''''    
    end    
    if(@JSY_Beneficiary<>'S')    
    begin    
  set @SQL = @SQL + ' and r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''''    
    end    
       
  if(@IsMCTSRCH = 1) --MCTS      
  begin    
   set @SQL = @SQL + ' and r.ID_No is not null and r.ID_no<>'''''    
  end    
  else    
  begin    
   set @SQL = @SQL + '  and isnull(r.ID_No,'''')='''''    
  end    
    
          
end    
    
end    
else if(@TypeReport=6)--Delete mother list    
begin    
set @SQL ='select E.Registration_no,E.Registration_no as MID_no,E.Name_wife +''('' + E.Name_husband + '')'' as Name ,E.Address,E.Mobile_No as Contact_No,r.Delete_Mother,r.ReasonForDeletion  ,r.case_no,
   isnull(r.Dup_Mother_Delete,0) as   Dup_Mother_Delete,isnull(r.permanent_delete,0) as permanent_delete 
   from t_mother_registration as r (nolock)     
   inner join t_eligibleCouples as E (nolock) on e.Registration_no = r.Registration_no  and r.Case_no=e.Case_no     
   inner join t_page_tracking pt (nolock) on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no   
   left outer join TBL_SUBPHC a (nolock) on r.HealthSubFacility_Code=a.SUBPHC_CD  
   where E.Eligible=''I'' and   isnull(r.CPSMS_Flag,0)<>1    
   and ((E.Pregnant=''Y'' and E.Pregnant_test=''P'')or (E.Pregnant=''Y'' and E.Pregnant_test=''D'')or(E.Pregnant=''D'' and E.Pregnant_test=''P''))  
   and pt.Is_Previous_Current=1 and isnull(r.permanent_delete,0)=0'    
if(@Registration_no<>'' and @Registration_no<>0)    
begin    
 set @SQL= @SQL + ' and E.Registration_no='+ cast(@Registration_no as varchar(12))    
end    
else if(@MctsID<>'')    
begin    
 set @SQL= @SQL + ' and E.ID_No='+ '''' + cast(@MctsID as varchar(18))+ ''''    
end    
else    
begin    
    
    set @SQL = @SQL + ' and isnull(a.PHC_CD,r.HealthFacility_Code)='+cast(@HealthFacility_Code as varchar(4))    
    if(@HealthSubFacility_Code=999999)     
    begin    
   set @SQL = @SQL + ' and E.HealthSubFacility_Code=0'    
    end    
    else if(@HealthSubFacility_Code<>0)     
    begin    
   set @SQL = @SQL + ' and E.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))    
    end    
       
    if(@Village_Code=999999)     
    begin    
   set @SQL = @SQL + ' and E.Village_Code=0'    
    end    
    else if(@Village_Code<>0)     
    begin    
   set @SQL = @SQL + ' and E.Village_Code='+cast(@Village_Code as varchar(8))    
    end    
    if(@Financial_Year<>0)    
    begin    
   set @SQL = @SQL + ' and E.Financial_Year='+cast(@Financial_Year as varchar(4))    
    end    
    if(@Register_srno<>0)    
    begin    
  set @SQL = @SQL + ' and E.Register_srno='+cast(@Register_srno as varchar(4))    
    end    
     if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
   set @SQL= @SQL + ' and E.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
   set @SQL= @SQL + ' and E.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Name_wife<>'')    
    begin    
  set @SQL = @SQL + ' and E.Name_wife like '''+cast(@Name_wife as varchar(99))+'%'''    
    end    
    if(@Name_husband<>'')    
    begin    
  set @SQL = @SQL + ' and E.Name_husband like '''+cast(@Name_husband as varchar(99))+'%'''    
    end    
    if(@WhoseMobile_no<>'0')    
    begin    
  set @SQL = @SQL + ' and E.Whose_mobile = '''+cast(@WhoseMobile_no as varchar(1))+''''    
    end    
       
  if(@IsMCTSRCH = 1) --MCTS      
  begin    
   set @SQL = @SQL + ' and E.ID_No is not null and E.ID_no<>'''''    
  end    
  else    
  begin    
   set @SQL = @SQL + '  and isnull(E.ID_No,'''')='''''    
  end    
end    
    
end 
if(@TypeReport = 7) --ANM - ASHA INCENTIVE  
begin    
set @SQL ='select r.SNo, r.Registration_no,r.Register_srno    
,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis    
,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband    
,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile    
,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test       
,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes       
,'''' as Edit,e.Case_no,ISNULL(r.Financial_Year,0) as Financial_Year,r.Flag,r.ID_No   
,(case Page_Code  when ''MR'' then ''PG-1'' when ''MM'' then ''PG-2'' when ''MA'' then ''Mother ANC'' when ''MD'' then ''Delivery Outcome''   
  when ''MI'' then ''Mother Infant'' when ''MP'' then ''Mother PNC'' when ''IP'' then ''Infant PNC''  else '''' end) as Page_Code   
  ,r.HealthIdNumber 
 from t_mother_registration r (nolock)     
inner join t_eligibleCouples e (nolock) on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no    
inner join t_page_tracking pt (nolock) on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no   
left outer join TBL_SUBPHC a (nolock) on r.HealthSubFacility_Code=a.SUBPHC_CD  
where  isnull(r.Delete_Mother,0)=0 and pt.Is_Previous_Current=1  
and HealthIdNumber is not null  and r.Incentive_ANM_ID is null and r.incentive_ASHA_ID is null
and r.Flag='+CAST(@Flag as varchar(1)) +' '   
 
if(@Registration_no<>'' and @Registration_no<>0)    
begin    
set @SQL= @SQL + ' and  r.Registration_no='+ cast(@Registration_no as varchar(12))    
end    
else if(@MctsID<>'' and @MctsID<>'0')    
begin    
set @SQL= @SQL + ' and r.ID_No=''' + cast(@MctsID as varchar(18))+ ''''    
end    
  
else    
begin    
 set @SQL = @SQL + '  and isnull(a.PHC_CD,r.HealthFacility_Code)='+cast(@HealthFacility_Code as varchar(4))    
    
 if(@HealthSubFacility_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code=0'    
    end    
    else if(@HealthSubFacility_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))    
    end    
       
    if(@Village_Code=999999)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code=0'    
    end    
    else if(@Village_Code<>0)     
    begin    
  set @SQL = @SQL + ' and r.Village_Code='+cast(@Village_Code as varchar(8))    
    end    
    if(@Financial_Year<>0)    
    begin    
  set @SQL = @SQL + ' and r.Financial_Year='+cast(@Financial_Year as varchar(4))    
    end    
    if(@Register_srno<>0)    
    begin    
  set @SQL = @SQL + ' and r.Register_srno='+cast(@Register_srno as varchar(4))    
    end    
     if(@Mobile_no<>'' and @Mobile_no<>'0')    
    begin    
  set @SQL= @SQL + ' and r.Mobile_no='''+ cast(@Mobile_no as varchar(10))+ ''''    
    end    
    if(@Name_wife<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'''    
    end    
    if(@Name_husband<>'')    
    begin    
  set @SQL = @SQL + ' and r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'''    
    end    
    if(@WhoseMobile_no<>'0')    
    begin    
  set @SQL = @SQL + ' and r.Mobile_Relates_To = '''+cast(@WhoseMobile_no as varchar(1))+''''    
    end   
    if(@JSY_Beneficiary<>'S')  
    begin  
  set @SQL = @SQL + ' and r.JSY_Beneficiary = '''+cast(@JSY_Beneficiary as varchar(1))+''''    
    end  
       
 if(@IsMCTSRCH = 1) --MCTS      
 begin    
  set @SQL = @SQL + ' and r.ID_No is not null and r.ID_no<>'''''    
 end    
 else    
 begin    
  set @SQL = @SQL + '  and isnull(r.ID_No,'''')='''''    
 end    
   
     
  
    
end    
end  
exec (@SQL)    
--print (@SQL)      
end    
  
