USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_eligibleCouple_Search]    Script Date: 09/26/2024 15:55:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/* 
 tp_eligibleCouple_Search 30,1,'R',3,'0002',1,13,27,10000051,1,0,'',130000002323,0,'','','',1,'0',1,2
 tp_eligibleCouple_Search 30,1,'R',3,'0002',1,13,27,10000051,4,'',0,130000002323,0,'','','',0,'0',1,2
 tp_eligibleCouple_Search 30,1,'R',3,'0002',1,13,27,10000051,2,'',0,130000002422,0,'','','',1,'0',1,2
 
 tp_eligibleCouple_Search 28,11,'R',0,'0',0,0,0,0,1,'',0,0,0,'','','',1,'0',0,0,0,0,1,0 -- EC
  tp_eligibleCouple_Search 28,11,'R',0,'0',0,0,0,0,2,'',0,0,0,'','','',1,'0',0,0,0,0,1,'N' -- Mother
*/  
   
ALTER proc [dbo].[tp_eligibleCouple_Search]  
(  
@State_Code int  
,@District_Code int =0  
,@Rural_Urban char(1)    
,@HealthBlock_Code int =0   
,@Taluka_Code varchar(6)='0'    
,@HealthFacility_Type int =0   
,@HealthFacility_Code int =0    
,@HealthSubFacility_Code int =0   
,@Village_Code int  =0
,@TypeReport int   
,@MctsID varchar(18)=''
,@Financial_Year int
,@Registration_no bigint =0
,@Register_srno int =0
,@Name_wife nvarchar(99)=''
,@Name_husband nvarchar(99)=''
,@Mobile_no varchar(10) =''
,@Flag bit=0
,@WhoseMobile_no char(1)='0'
,@OtherDistrict_Code int =0
,@Hierachy int=2
,@WifeAadhaar_no numeric=0
,@HusbandAadhaar_no numeric=0
,@IsMCTSRCH tinyint
,@JSY_Beneficiary char(1)='S'
)  
as  
begin  
SET NOCOUNT ON  
declare @SQL varchar (max)=null, @Case_no varchar(200)

 --set @Case_no = '(select Case_no from t_page_tracking where 
	--			Case_no in(select max(Case_no) from t_page_tracking where Registration_no='+cast(@Registration_no as varchar(12)) + ') and Registration_no= '+cast(@Registration_no as varchar(12)) +')'



if(@TypeReport=1)  --Elligible  Couple
	Begin
		  if(@Hierachy=1)---Inside Hiearachy
			  begin
					set @SQL ='select e.SNo, e.Registration_no,Register_srno,District_Code,Name_wife,Name_husband
					   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative''
						when ''O'' then ''Others'' when ''A'' then '' Not Applicable'' else '''' end)as Whose_mobile
					   ,Landline_no,Mobile_no,(case Date_regis when ''1990-01-01'' then null else Date_regis end) as Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age  
					  ,Hus_marry_age,[Address],Religion_code,Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live  
					  ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Eligible,Pregnant,Pregnant_test   
					  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
					  ,''0'' as Edit 
					  ,e.Case_no 
					  ,Financial_Year,ID_No    
					   from t_eligibleCouples e
					   inner join t_page_tracking pt on e.Registration_no=pt.Registration_no and e.Case_no=pt.Case_no
					   where    
					   (State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
					   and (District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
					   and (Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
					   and (HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
					   and (Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
					   and (HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
					   and (HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
					   and (HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
					   and (Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
					   and (Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
					   and (ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
					   and (e.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
					   and (Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
					   and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
					   and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
					   and (Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
					   and Eligible=''E'' and Status=''A''
					   --and (Pregnant<>''Y'' or (Pregnant_test<>''P'' and Pregnant_test<>''D''))
					   --and (Pregnant<>''D'' or Pregnant_test<>''P'')
					   --and ((Eligible=''E'' and Noneligible = ''A'') or (Eligible=''I'' and (Noneligible = ''W'' or Noneligible = ''P'' or Noneligible = ''V'')))
					   and Flag=0
					   and isnull(Delete_Mother,0)<>1
					   and (Whose_mobile='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
					   and pt.Is_Previous_Current=1
					   and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
					   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)'
					   if(@IsMCTSRCH = 1)
						begin
							set @SQL = @SQL + ' and e.ID_No is not null'
						end
						else
						begin
							set @SQL = @SQL + '  and e.ID_No  is null'
						end
			end
		else
		    begin
		          set @SQL ='select e.SNo, e.Registration_no,Register_srno,District_Code,Name_wife,Name_husband
					   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative''
						when ''O'' then ''Others'' when ''A'' then '' Not Applicable'' else '''' end)as Whose_mobile
					   ,Landline_no,Mobile_no,(case Date_regis when ''1990-01-01'' then null else Date_regis end) as Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age  
					  ,Hus_marry_age,[Address],Religion_code,Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live  
					  ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Eligible,Pregnant,Pregnant_test   
					  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
					  ,''0'' as Edit 
					  ,e.Case_no 
					  ,Financial_Year,ID_No    
					   from t_eligibleCouples e
					   inner join t_page_tracking pt on e.Registration_no=pt.Registration_no and e.Case_no=pt.Case_no
					   where    
					   (State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
					   and (e.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
					   --and (Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
					   --and (HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
					   --and (Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
					   --and (HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
					   --and (HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
					   --and (HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
					   --and (Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
					   and (Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
					   and (ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
					   and (e.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
					   and (Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
					   and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
					   and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
					   and (Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
					  
					   and Eligible=''E'' and Status=''A''
					   --and (Pregnant<>''Y'' or (Pregnant_test<>''P'' and Pregnant_test<>''D''))
					   --and (Pregnant<>''D'' or Pregnant_test<>''P'')
					   --and ((Eligible=''E'' and Noneligible = ''A'') or (Eligible=''I'' and (Noneligible = ''W'' or Noneligible = ''P'' or Noneligible = ''V'')))
					   and Flag=0
					   and isnull(Delete_Mother,0)<>1
					   and (Whose_mobile='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
					   and pt.Is_Previous_Current=1
					   and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
					   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)'
					   if(@IsMCTSRCH = 1)
						begin
							set @SQL = @SQL + ' and e.ID_No is not null'
						end
						else
						begin
							set @SQL = @SQL + '  and e.ID_No  is null'
						end
		    end
    End
         
if(@TypeReport=2)   --Mother Registration
begin
if(@Flag = 0)
begin
		set @Financial_Year = 0
end 
		begin 
		   if(@Hierachy=1)---Inside Hiearachy 
			   begin
					set @SQL ='select r.SNo, r.Registration_no,r.Register_srno
					,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis
					,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband
				   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
				   ,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test   
				  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
				  ,'''' as Edit
				   ,e.Case_no 
				   ,ISNULL(r.Financial_Year,0) as Financial_Year
				   ,r.Flag,r.ID_No     
				   from t_mother_registration r
				   inner join t_eligibleCouples e on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no
				   inner join t_page_tracking pt on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no
				   where    
				   (r.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
				   and (r.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
				   and (r.Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
				   and (r.HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
				   and (r.Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
				   and (r.HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
				   and (r.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
				   and (r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
				   and (r.Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
				   and (r.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
				   and (r.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
				   and (r.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
				   and (r.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
				   and (r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
				   and (r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
				   and (r.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
				   --and e.Pregnant=''Y''
				   and( (Pregnant=''Y'' and Pregnant_test=''P'')
				   or (Pregnant=''Y'' and Pregnant_test=''D'')
				   or (Pregnant=''D'' and Pregnant_test=''P''))
				   and e.Eligible=''I''
				   and r.Flag='+CAST(@Flag as varchar(1))+'
				   and isnull(r.Delete_Mother,0)<>1
				   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
				   and pt.Is_Previous_Current=1
				   and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
				  and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
				  and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
				  if(@IsMCTSRCH = 1)
					begin
						set @SQL = @SQL + ' and r.ID_No is not null'
					end
					else
					begin
						set @SQL = @SQL + '  and r.ID_No  is null'
					end
			end
		  else
		    begin
		        set @SQL ='select r.SNo, r.Registration_no,r.Register_srno
					,(case r.Registration_Date when ''1990-01-01'' then null else r.Registration_Date end) as Date_regis
					,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband
				   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
				   ,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test   
				  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
				  ,'''' as Edit
				   ,e.Case_no 
				   ,ISNULL(r.Financial_Year,0) as Financial_Year
				   ,r.Flag,r.ID_No     
				   from t_mother_registration r
				   inner join t_eligibleCouples e on r.Registration_no=e.Registration_no and r.Case_no=e.Case_no
				   inner join t_page_tracking pt on r.Registration_no=pt.Registration_no and r.Case_no=pt.Case_no
				   where    
				   (r.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
				   and (r.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
				   --and (r.Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
				   --and (r.HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
				   --and (r.Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
				   --and (r.HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
				   --and (r.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
				   --and (r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
				   --and (r.Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
				   and (r.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
				   and (r.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
				   and (r.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
				   and (r.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
				   and (r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
				   and (r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
				   and (r.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
				   --and (r.District_Code='+cast(@OtherDistrict_Code as varchar(2))+' or '+cast(@OtherDistrict_Code as varchar(2))+'=0)
				   --and e.Pregnant=''Y''
				   and( (Pregnant=''Y'' and Pregnant_test=''P'')
				   or (Pregnant=''Y'' and Pregnant_test=''D'')
				   or (Pregnant=''D'' and Pregnant_test=''P''))
				   and e.Eligible=''I''
				   and r.Flag='+CAST(@Flag as varchar(1))+'
				   and isnull(r.Delete_Mother,0)<>1
				   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
				   and pt.Is_Previous_Current=1
				   and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
				   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
				   and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
				   if(@IsMCTSRCH = 1)
					begin
						set @SQL = @SQL + ' and r.ID_No is not null'
					end
					else
					begin
						set @SQL = @SQL + '  and r.ID_No  is null'
					end
		    end
		end
End  
       
if(@TypeReport=4)   -- UnRegistered Mother
begin
if(@Flag = 0)
begin
		set @Financial_Year = 0
end
	begin  
	   if(@Hierachy=1) --Inside Hiearachy 
		  begin
				set @SQL ='select r.SNo, r.Registration_no,r.Register_srno
				,(case [Registration_Date] when ''1990-01-01'' then null else [Registration_Date] end) as Date_regis
				,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband
			   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
			   ,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test   
			  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
			  ,'''' as Edit
			   ,e.Case_no 
			   ,ISNULL(r.Financial_Year,0) as Financial_Year
			   ,r.Flag,r.ID_No     
			   from t_eligibleCouples as e
			   inner join t_mother_registration as r on e.Registration_no= r.Registration_no and e.Case_no=r.Case_no
			   inner join t_page_tracking pt on e.Registration_no=pt.Registration_no and e.Case_no=pt.Case_no
			   where    
			   (r.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
			   and (r.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
			   and (r.Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
			   and (r.HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
			   and (r.Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
			   and (r.HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
			   and (r.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
			   and (r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
			   and (r.Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
			   and (r.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
			   and (r.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
			   and (r.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
			   and (r.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
			   and (r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
			   and (r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
			   and (r.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
			   --and e.Pregnant=''Y''
			   and( (Pregnant=''Y'' and Pregnant_test=''P'')
			   or (Pregnant=''Y'' and Pregnant_test=''D'')
			   or (Pregnant=''D'' and Pregnant_test=''P''))
			   and e.Eligible=''I''
			   and r.Flag='+CAST(@Flag as varchar(1))+'
			   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
		       and pt.Is_Previous_Current=1
		       and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
			   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
			   and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
			   if(@IsMCTSRCH = 1)
				begin
					set @SQL = @SQL + ' and r.ID_No is not null'
				end
				else
				begin
					set @SQL = @SQL + '  and r.ID_No  is null'
				end
			  end	
	    else
	        begin
	           set @SQL ='select r.SNo, r.Registration_no,r.Register_srno
				,(case [Registration_Date] when ''1990-01-01'' then null else [Registration_Date] end) as Date_regis
				,r.District_Code,r.Name_PW as Name_wife,r.Name_H as Name_husband
			   ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
			   ,r.Mobile_No as Mobile_no,r.[Address],Pregnant,Pregnant_test   
			  ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes   
			  ,'''' as Edit
			   ,e.Case_no 
			   ,ISNULL(r.Financial_Year,0) as Financial_Year
			   ,r.Flag,r.ID_No     
			   from t_eligibleCouples as e
			   inner join t_mother_registration as r on e.Registration_no= r.Registration_no  and e.Case_no=r.Case_no
			   inner join t_page_tracking pt on e.Registration_no=pt.Registration_no and e.Case_no=pt.Case_no
			   where    
			   (r.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
			   --and (r.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
			   --and (r.Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
			   --and (r.HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
			   --and (r.Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
			   --and (r.HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
			   --and (r.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
			   --and (r.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
			   --and (r.Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
			   and (r.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
			   and (r.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
			   and (r.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
			   and (r.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
			   and (r.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
			   and (r.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
			   and (r.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
			
			   --and e.Pregnant=''Y''
			   and( (Pregnant=''Y'' and Pregnant_test=''P'')
			   or (Pregnant=''Y'' and Pregnant_test=''D'')
			   or (Pregnant=''D'' and Pregnant_test=''P''))
			   and e.Eligible=''I''
			   and r.Flag='+CAST(@Flag as varchar(1))+'
			   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
			   and pt.Is_Previous_Current=1
			   and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
			   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
			   and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
			   if(@IsMCTSRCH = 1)
				begin
					set @SQL = @SQL + ' and r.ID_No is not null'
				end
				else
				begin
					set @SQL = @SQL + '  and r.ID_No  is null'
				end
			end
	  end
End 
if(@TypeReport=5)   -- Mother Case Unclosed Records
if(@Hierachy=1)     --Inside Hiearachy
			  begin
				set @SQL = 'select (case when mr.ID_No is not null then mr.ID_No else '''' end) as ID_No,mr.Financial_Year
				,pt.Registration_no,Page_Code,pt.Case_no,mr.Registration_Date as Date_regis
				,mr.SNo,mr.Registration_no,mr.Register_srno,mr.Name_PW as Name_wife,mr.Name_H as Name_husband
				,(case mr.Mobile_Relates_To when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
				,mr.Mobile_No as Mobile_no,mr.[Address],''Yes'' as PregnantYes,'''' as Edit from t_page_tracking pt
				inner join t_mother_registration mr on pt.Registration_no=mr.Registration_no and pt.Case_no=mr.Case_no
				inner join t_eligibleCouples e on mr.Registration_no=e.Registration_no and mr.Case_no=e.Case_no
				where 
				(mr.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
					   and (mr.District_Code='+cast(@District_code as varchar(2))+' or '+cast(@District_code as varchar(2))+'=0)
					   and (mr.Rural_Urban='''+cast(@Rural_Urban as varchar(1))+''' or '''+cast(@Rural_Urban as varchar(1))+'''='''')
					   and (mr.HealthBlock_Code='+cast(@HealthBlock_code as varchar(3))+' or '+cast(@HealthBlock_code as varchar(3))+'=0)
					   and (mr.Taluka_Code='''+cast(@Taluka_code as varchar(4))+''' or '''+cast(@Taluka_code as varchar(4))+'''=''0'')
					   and (mr.HealthFacility_Type='+cast(@HealthFacility_Type as varchar(4))+' or '+cast(@HealthFacility_Type as varchar(4))+'=0)
					   and (mr.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(4))+' or '+cast(@HealthFacility_Code as varchar(4))+'=0)
					   and (mr.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)
					   and (mr.Village_Code='+cast(@Village_Code as varchar(9))+' or '+cast(@Village_Code as varchar(9))+'=0)
					   and (mr.Financial_Year=0 or 0=0) --'+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
					   and (mr.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
					   and (pt.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
					   and (mr.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
					   and (mr.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
					   and (mr.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
					   and (mr.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
					   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
				and pt.Is_Previous_Current<>1
				and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
					   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
					   and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
			  end
			  else
			  begin
				set @SQL = 'select (case when mr.ID_No is not null then mr.ID_No else '''' end) as ID_No,mr.Financial_Year
				,pt.Registration_no,Page_Code,pt.Case_no,mr.Registration_Date as Date_regis
				,mr.SNo,mr.Registration_no,mr.Register_srno,mr.Name_PW as Name_wife,mr.Name_H as Name_husband
				,(case mr.Mobile_Relates_To when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile
				,mr.Mobile_No as Mobile_no,mr.[Address],''Yes'' as PregnantYes,'''' as Edit from t_page_tracking pt
				inner join t_mother_registration mr on pt.Registration_no=mr.Registration_no and pt.Case_no=mr.Case_no
				inner join t_eligibleCouples e on mr.Registration_no=e.Registration_no and mr.Case_no=e.Case_no
				where 
				(mr.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
					   and (mr.Financial_Year=0 or 0=0) --'+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
					   and (mr.ID_No='''+cast(@MctsID as varchar(18))+''' or '''+cast(@MctsID as varchar(18))+'''='''')
					   and (pt.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
					   and (mr.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)
					   and (mr.Name_PW like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
					   and (mr.Name_H like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
					   and (mr.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')
					
					   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')
				and pt.Is_Previous_Current<>1
				and (e.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+' or '+cast(@WifeAadhaar_no as varchar(12))+'=0)
					   and (e.HusbandAadhaar_no='+cast(@HusbandAadhaar_no as varchar(12))+' or '+cast(@HusbandAadhaar_no as varchar(12))+'=0)
					   and (r.JSY_Beneficiary='''+cast(@JSY_Beneficiary as varchar(1))+''' or '''+cast(@JSY_Beneficiary as varchar(1))+'''=''S'')'
			  end
	
--if(@TypeReport=3)  ----Mother Registration for Child 
--begin  
--       set @SQL ='select 
--   r.[SNo]
--  ,r.[Register_srno] as Register_srno
--  ,r.[Financial_Yr]
--  ,r.[Financial_Year]
--  ,r.[Registration_no] as Registration_no,r.District_Code
--  ,[Name_PW] as Name_wife
--  ,[Name_H] as Name_husband
--  ,r.[Address] as Address
--  ,(case [Registration_Date] when ''1990-01-01'' then null else [Registration_Date] end) as Date_regis
--  ,r.[Mobile_No] as Mobile_no
--  ,(case [Mobile_Relates_To] when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''O'' then ''Others'' when ''A'' then ''Not Applicable'' else '''' end) as Whose_mobile
--  ,(case e.Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes 
--  ,e.Case_no 
--   from t_mother_registration as r 
--   inner join t_mother_delivery as d
--   on r.Registration_no=d.Registration_no 
--   inner join t_eligibleCouples as e
--   on r.Registration_no=e.Registration_no 
--   inner join t_mother_infant i on e.Registration_no=i.Registration_no
--   where    
--    (r.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)
    
--   and (r.Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
--   and (i.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)
--   and e.Pregnant=''Y''
--   and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')
--   and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')
--   and (r.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''') 
--   and r.Flag=1
--   and d.Delivery_date is not null
--   and (r.District_Code='+cast(@OtherDistrict_Code as varchar(2))+' or '+cast(@OtherDistrict_Code as varchar(2))+'=0)
--   and (Mobile_Relates_To='''+cast(@WhoseMobile_no as varchar(1))+''' or '''+cast(@WhoseMobile_no as varchar(1))+'''=''0'')'
--End
exec(@SQL)
--print(@SQL)
end





