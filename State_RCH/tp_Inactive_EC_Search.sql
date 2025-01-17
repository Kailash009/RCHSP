USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Inactive_EC_Search]    Script Date: 09/26/2024 14:48:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



           --exec tp_Inactive_EC_Search 30,1,3,11,35,0,0,2018,'A',''    
ALTER proc [dbo].[tp_Inactive_EC_Search]                              
(                              
@State_Code int                                
,@District_Code int                              
,@HealthBlock_Code int                                 
,@HealthFacility_Code int                              
,@HealthSubFacility_Code int=0                              
,@Village_Code int=0                              
,@Registration_no bigint=0                              
,@Financial_Year int=0                              
,@EC_Status char='0'     
,@MctsID varchar(18)=''                     
)                              
as                              
begin                                
SET NOCOUNT ON                                
  declare @sql varchar(max)                      
set @sql='select b.Registration_no,b.ID_No,
(case when b.Registration_no IS NULL  then '''' when b.Registration_no = ''0'' then '''' 
	 else CAST(b.Registration_no as nvarchar(25)) end + CHAR(13) + 
	 case when b.ID_No IS NULL then '''' else + '' / '' + CAST(b.ID_No as nvarchar(25)) end) as MCTS_RCH_ID,
Name_wife,Name_husband,b.Wife_current_age, Mobile_no,Address,b.Date_regis,                            
(case when a.Reason=''V'' then ''Divorced''             
when a.Reason=''W'' then ''Widow''            
 when a.Reason=''D'' then ''Death''             
 when a.Reason=''M'' then ''Permanent Male Sterilization''                               
when a.Reason=''F'' then ''Permanent Female Sterilization''            
 when a.Reason=''P'' then ''Permanent Migration''             
 when a.Reason=''A'' then ''Age above 49 years''                             
when a.Reason =''N'' then ''Non Traceable''            
 when a.Reason = ''T'' then ''Temporary Migrated''             
 when a.Reason = ''E'' then ''Eligible''            
  when a.Reason = ''I'' then ''In Eligible''                    
when a.Reason=''S'' then ''Permanent Sterilization Male Failure''             
when a.Reason=''G'' then ''Permanent Sterilization Female Failure''            
 when a.Reason=''R'' then ''Returned back to the area''                     
when a.Reason=''B'' then ''Pregnancy detected after age above 49 years''            
 when a.Reason=''H'' then ''Remarriage''            
  when a.Reason=''C'' then ''Retraced''                     
 when a.Reason=''K'' then ''Returned back to the area''            
 when a.Reason=''U'' then ''Data entry error''            
 when a.Reason=''X'' then ''Data entry error''            
  else ''---Select---'' end ) as D_Reason                          
,a.Reason as Reason                           
,Inactive_Date                            
, a.Status as Status                            
,(Case when a.Status = ''A'' then ''Active EC'' when a.Status = ''I'' then ''InActive EC'' when a.Status = ''N'' then ''Not Eligible'' else ''---Select---'' end ) as D_Status                           
 from t_eligibleCouples_Status a                              
inner join t_eligibleCouples b on a.Registration_no=b.Registration_no and a.max_case_no =b.case_no                
inner join t_page_tracking c on a.Registration_no = c.Registration_no and a.MAX_Case_no = c.Case_no                              
where                  
  b.Eligible=''E'' and b.Status=''A'' and Flag=0 and isnull(Delete_Mother,0)=0 and b.Pregnant<> ''Y''';    
      
  if (@Registration_no =0 and @MctsID ='')    
  set @sql+='and (b.District_Code='+convert(varchar(10),@District_Code)+')  and (b.HealthBlock_Code='+convert(varchar(10),@HealthBlock_Code)+') and (b.HealthFacility_Code='+convert(varchar(10),@HealthFacility_Code)+' or '+convert(varchar(10),@HealthFacility_Code)+'=0) and (b.HealthSubFacility_Code='+convert(varchar(10),@HealthSubFacility_Code)+' or '+convert(varchar(10),@HealthSubFacility_Code)+'=0) and (b.Village_Code='+convert(varchar(10),@Village_Code)+' or '+convert(varchar(10),@Village_Code)+'=0) and (a.Status = '''+@EC_Status+''' or '''+@EC_Status+''' = ''0'') and (b.Financial_Year = '+convert(varchar(10),@Financial_Year)+')';                              
 else if(@Registration_no!=0)    
 set @sql += ' and (b.Registration_no='+convert(varchar(15),@Registration_no)+')';                       
 else    
 set @sql += ' and (b.ID_No='''+@MctsID+''')';     
    exec(@sql);    
    
END          
    
