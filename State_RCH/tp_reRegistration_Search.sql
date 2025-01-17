USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_reRegistration_Search]    Script Date: 09/26/2024 14:51:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
ALTER proc [dbo].[tp_reRegistration_Search]          
(          
@State_Code int      
,@District_Code int =0           
,@HealthBlock_Code int =0           
,@HealthFacility_Code int =0            
,@HealthSubFacility_Code int =0           
,@Village_Code int  =0              
,@TypeReport int          
,@Financial_Year int          
,@Registration_no bigint          
,@Register_srno int          
,@Name_wife nvarchar(99)          
,@Name_husband nvarchar(99)          
,@Mobile_no varchar(10)          
,@WifeAadhaar_no numeric=0          
,@HusbandAadhaar_no numeric=0          
)          
as          
begin          
SET NOCOUNT ON           
declare @SQL varchar (max)=null           
if(@TypeReport=0)  --Elligible  Couple          
  begin            
 set @SQL ='select (case when d.Delivery_date is null then datediff(day,m.LMP_Date,GETDATE()) else 0 end) as LMP_grater_than_322days,t.SNo,t.Registration_no,b.Register_srno,Name_wife,Name_husband          
       ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile          
       ,Landline_no,b.Mobile_no,Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age            
      ,Hus_marry_age,b.[Address],b.Religion_code,b.Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live            
      ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant,Pregnant_test             
      ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes             
      ,''0'' as Edit           
      ,t.Case_no           
      ,b.Financial_Year          
      ,(case when (case when d.Delivery_Date is null then DATEADD(day,322,LMP_Date) when d.delivery_Date is not null then DATEADD(DAY,42,d.delivery_Date) end) >Convert(date,getdate()) then Convert(date,getdate())           
      else (case when d.Delivery_Date is null then DATEADD(day,322,LMP_Date) when d.delivery_Date is not null then DATEADD(DAY,42,d.delivery_Date) end) end)  as Start_Date,    
   r.HealthIdNumber,r.Entry_Type,r.Birth_Date   --added by Shashank gautam on 30-07-2024         
      from t_temp t          
       inner join t_eligibleCouples b on t.Registration_no=b.Registration_no and t.Case_no=b.Case_no          
       inner join t_mother_medical m on t.Registration_no=m.Registration_no and t.Case_no=m.Case_no          
       left outer join t_mother_delivery d on t.Registration_no=d.Registration_no and t.Case_no=d.Case_no        
    left outer join t_mother_registration r on t.Registration_no=r.Registration_no and t.Case_no=r.Case_no     --added by Shashank gautam on 30-07-2024    
       where  t.Registration_no not in(select Registration_no from t_mother_anc where Abortion_IfAny=1)                
       and isnull(t.Re_Registration_Done,0)<>1 and isnull(b.Delete_Mother,0)=0'          
             
       if(@Registration_no<>0)--added by sneha on 28112016      
  set @SQL=@SQL+' and t.Registration_no='+cast(@Registration_no as varchar(12))+''      
   else if(@WifeAadhaar_no<>0)--added by sneha on 28112016      
  set @SQL=@SQL+' and b.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+''      
   else if(@HusbandAadhaar_no<>0)--added by sneha on 28112016      
  set @SQL=@SQL+' and b.HusbandAadhaar_no='+cast(@WifeAadhaar_no as varchar(12))+''      
  else--added by sneha on 28112016      
  begin      
        
  set @SQL=@SQL+' and (b.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)      
       and (b.District_Code='+cast(@District_Code as varchar(2))+' or '+cast(@District_Code as varchar(2))+'=0)      
       and (b.HealthBlock_Code='+cast(@HealthBlock_Code as varchar(4))+' or '+cast(@HealthBlock_Code as varchar(4))+'=0)      
       and (b.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(5))+' or '+cast(@HealthFacility_Code as varchar(5))+'=0)      
       and (b.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)      
       and (b.Village_Code='+cast(@Village_Code as varchar(8))+' or '+cast(@Village_Code as varchar(8))+'=0)      
       and (b.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)          
    and (b.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)          
       and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')          
       and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')          
       and (b.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')    '      
        
  end      
         
        
   End          
   if(@TypeReport = 3) --Delivey date + 42 days          
   begin          
 set @SQL='select ''0'' as LMP_grater_than_322days,t.SNo,t.Registration_no,b.Register_srno,Name_wife,Name_husband          
       ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile          
       ,Landline_no,b.Mobile_no,Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age            
      ,Hus_marry_age,b.[Address],b.Religion_code,b.Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live            
      ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant,Pregnant_test             
      ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes             
      ,''0'' as Edit           
      ,t.Case_no           
      ,d.Financial_Year          
      ,(case when DATEADD(DAY,42,d.delivery_Date)>Convert(date,getdate()) then Convert(date,getdate()) else DATEADD(DAY,42,d.delivery_Date) end) as Start_Date,    
   r.HealthIdNumber,r.Entry_Type,r.Birth_Date  --added by Shashank gautam on 30-07-2024           
       from t_temp t          
       inner join t_eligibleCouples b on t.Registration_no=b.Registration_no and t.Case_no=b.Case_no          
       inner join t_mother_delivery d on t.Registration_no=d.Registration_no  and t.Case_no=d.Case_no          
    left outer join t_mother_registration r on t.Registration_no=r.Registration_no and t.Case_no=r.Case_no --added by Shashank gautam on 30-07-2024    
       where datediff(day,d.Delivery_date,GETDATE()) >= 42          
       and isnull(t.Re_Registration_Done,0)<>1 and isnull(b.Delete_Mother,0)=0'      
             
       if(@Registration_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and t.Registration_no='+cast(@Registration_no as varchar(12))+''      
   else if(@WifeAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+''      
   else if(@HusbandAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.HusbandAadhaar_no='+cast(@WifeAadhaar_no as varchar(12))+''      
   else--added by sneha on 28112016      
  begin      
        
   set @SQL=@SQL+' and (b.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)      
     and (b.District_Code='+cast(@District_Code as varchar(2))+' or '+cast(@District_Code as varchar(2))+'=0)      
     and (b.HealthBlock_Code='+cast(@HealthBlock_Code as varchar(4))+' or '+cast(@HealthBlock_Code as varchar(4))+'=0)      
     and (b.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(5))+' or '+cast(@HealthFacility_Code as varchar(5))+'=0)      
     and (b.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)      
     and (b.Village_Code='+cast(@Village_Code as varchar(8))+' or '+cast(@Village_Code as varchar(8))+'=0)      
     and (b.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)          
     and (b.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)          
     and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')          
     and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')          
     and (b.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')    '      
        
  end          
   end          
   if(@TypeReport = 2) --LMP date + 322 days and Delivery not Reported          
   begin          
    set @SQL='select datediff(day,m.LMP_Date,GETDATE()) as LMP_grater_than_322days,t.SNo,t.Registration_no,b.Register_srno,Name_wife,Name_husband          
       ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile          
       ,Landline_no,b.Mobile_no,Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age            
      ,Hus_marry_age,b.[Address],b.Religion_code,b.Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live            
      ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant,Pregnant_test             
      ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes             
      ,''0'' as Edit           
      ,t.Case_no           
      ,m.Financial_Year            
      ,(case when DATEADD(DAY,322,m.LMP_Date)>Convert(date,getdate()) then Convert(date,getdate()) else DATEADD(DAY,322,m.LMP_Date) end) as Start_Date,    
   r.HealthIdNumber,r.Entry_Type,r.Birth_Date           --added by Shashank gautam on 30-07-2024    
       from t_temp t          
       inner join t_eligibleCouples b on t.Registration_no=b.Registration_no and t.Case_no=b.Case_no          
       inner join t_mother_medical m on t.Registration_no=m.Registration_no and t.Case_no=m.Case_no       
    left outer join t_mother_registration r on t.Registration_no=r.Registration_no and t.Case_no=r.Case_no   --added by Shashank gautam on 30-07-2024    
       where  datediff(day,m.LMP_Date,GETDATE()) >= 322           
       and m.Registration_no not in(select Registration_no from t_mother_delivery)          
       and isnull(t.Re_Registration_Done,0)<>1 and isnull(b.Delete_Mother,0)=0'         
             
       if(@Registration_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and t.Registration_no='+cast(@Registration_no as varchar(12))+''      
   else if(@WifeAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+''      
   else if(@HusbandAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.HusbandAadhaar_no='+cast(@WifeAadhaar_no as varchar(12))+''      
   else--added by sneha on 28112016      
  begin      
        
   set @SQL=@SQL+' and (b.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)      
     and (b.District_Code='+cast(@District_Code as varchar(2))+' or '+cast(@District_Code as varchar(2))+'=0)      
     and (b.HealthBlock_Code='+cast(@HealthBlock_Code as varchar(4))+' or '+cast(@HealthBlock_Code as varchar(4))+'=0)      
     and (b.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(5))+' or '+cast(@HealthFacility_Code as varchar(5))+'=0)      
     and (b.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)      
     and (b.Village_Code='+cast(@Village_Code as varchar(8))+' or '+cast(@Village_Code as varchar(8))+'=0)      
     and (b.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)          
     and (b.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)          
     and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')          
     and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')          
     and (b.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')    '      
        
  end         
   end          
   if(@TypeReport = 1) --Abortion cases          
   begin          
    set @SQL='select ''0'' as LMP_grater_than_322days,a.Abortion_IfAny,a.Abortion_date,t.SNo,t.Registration_no,b.Register_srno,Name_wife,Name_husband          
       ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile          
       ,Landline_no,b.Mobile_no,Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age            
      ,Hus_marry_age,b.[Address],b.Religion_code,b.Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live            
      ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant,Pregnant_test             
      ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes             
      ,''0'' as Edit           
      ,t.Case_no           
      ,a.Financial_Year          
      ,a.Abortion_Date as Start_Date,    
   r.HealthIdNumber,r.Entry_Type,r.Birth_Date       --added by Shashank gautam on 30-07-2024         
       from t_temp t          
       inner join t_eligibleCouples b on t.Registration_no=b.Registration_no and t.Case_no=b.Case_no          
       inner join t_mother_anc a on t.Registration_no=a.Registration_no and t.Case_no=a.Case_no    
    left outer join t_mother_registration r on t.Registration_no=r.Registration_no and t.Case_no=r.Case_no   --added by Shashank gautam on 30-07-2024    
       where Abortion_IfAny = 1          
       and isnull(t.Re_Registration_Done,0)<>1 and isnull(b.Delete_Mother,0)=0'       
       if(@Registration_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and t.Registration_no='+cast(@Registration_no as varchar(12))+''      
    else if(@WifeAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+''      
   else if(@HusbandAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.HusbandAadhaar_no='+cast(@WifeAadhaar_no as varchar(12))+''      
   else--added by sneha on 28112016      
  begin      
        
   set @SQL=@SQL+' and (b.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)      
     and (b.District_Code='+cast(@District_Code as varchar(2))+' or '+cast(@District_Code as varchar(2))+'=0)      
     and (b.HealthBlock_Code='+cast(@HealthBlock_Code as varchar(4))+' or '+cast(@HealthBlock_Code as varchar(4))+'=0)      
     and (b.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(5))+' or '+cast(@HealthFacility_Code as varchar(5))+'=0)      
     and (b.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)      
     and (b.Village_Code='+cast(@Village_Code as varchar(8))+' or '+cast(@Village_Code as varchar(8))+'=0)      
     and (b.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)          
     and (b.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)          
     and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')          
     and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')          
     and (b.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')    '      
        
  end         
                
   end          
   if(@TypeReport = 4)          
   begin          
 set @SQL ='select (case when d.Delivery_date is null then datediff(day,m.LMP_Date,GETDATE()) else 0 end) as LMP_grater_than_322days,t.SNo,t.Registration_no,b.Register_srno,Name_wife,Name_husband          
       ,(case Whose_mobile when ''W'' then ''Wife'' when ''H'' then ''Husband'' when ''N'' then ''Neighbour'' when ''R'' then ''Relative'' when ''A'' then ''Not Applicable'' else '''' end)as Whose_mobile          
       ,Landline_no,b.Mobile_no,Date_regis,Wife_current_age,Wife_marry_age,Hus_current_age            
      ,Hus_marry_age,b.[Address],b.Religion_code,b.Caste,Male_child_born,Female_child_born,Male_child_live,Female_child_live            
      ,Young_child_gender,Young_child_age_month,Young_child_age_year,Infertility_status,Infertility_refer,Pregnant,Pregnant_test             
      ,(case Pregnant  when ''Y'' then ''Yes'' when ''N'' then ''No'' when ''D'' then ''Dont Know'' else '''' end) as PregnantYes             
      ,''0'' as Edit           
      ,t.Case_no           
      ,b.Financial_Year          
      ,(case when (case when d.Delivery_Date is null then DATEADD(day,322,LMP_Date) when d.delivery_Date is not null then DATEADD(DAY,42,d.delivery_Date) end) >Convert(date,getdate()) then Convert(date,getdate())           
      else (case when d.Delivery_Date is null then DATEADD(day,322,LMP_Date) when d.delivery_Date is not null then DATEADD(DAY,42,d.delivery_Date) end) end)  as Start_Date,    
   r.HealthIdNumber,r.Entry_Type,r.Birth_Date      --added by Shashank gautam on 30-07-2024         
      from t_temp t          
       inner join t_eligibleCouples b on t.Registration_no=b.Registration_no and t.Case_no=b.Case_no          
       inner join t_mother_medical m on t.Registration_no=m.Registration_no and t.Case_no=m.Case_no          
       left outer join t_mother_delivery d on t.Registration_no=d.Registration_no and t.Case_no=d.Case_no          
    left outer join t_mother_registration r on t.Registration_no=r.Registration_no and t.Case_no=r.Case_no    --added by Shashank gautam on 30-07-2024    
       where  isnull(t.Re_Registration_Done,0)<>1 and isnull(b.Delete_Mother,0)=0          
       and b.ID_No is not null'       
             
       if(@Registration_no<>0 )--added by sneha on 28112016      
   set @SQL=@SQL+' and t.Registration_no='+cast(@Registration_no as varchar(12))+''      
    else if(@WifeAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.Aadhar_No='+cast(@WifeAadhaar_no as varchar(12))+''      
   else if(@HusbandAadhaar_no<>0)--added by sneha on 28112016      
   set @SQL=@SQL+' and b.HusbandAadhaar_no='+cast(@WifeAadhaar_no as varchar(12))+''      
   else      
  begin--added by sneha on 28112016      
        
   set @SQL=@SQL+' and (b.State_Code='+cast(@State_code as varchar(2))+' or '+cast(@State_code as varchar(2))+'=0)      
     and (b.District_Code='+cast(@District_Code as varchar(2))+' or '+cast(@District_Code as varchar(2))+'=0)      
     and (b.HealthBlock_Code='+cast(@HealthBlock_Code as varchar(4))+' or '+cast(@HealthBlock_Code as varchar(4))+'=0)      
     and (b.HealthFacility_Code='+cast(@HealthFacility_Code as varchar(5))+' or '+cast(@HealthFacility_Code as varchar(5))+'=0)      
     and (b.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(6))+' or '+cast(@HealthSubFacility_Code as varchar(6))+'=0)      
     and (b.Village_Code='+cast(@Village_Code as varchar(8))+' or '+cast(@Village_Code as varchar(8))+'=0)      
     and (b.Financial_Year='+cast(@Financial_Year as varchar(4))+' or '+cast(@Financial_Year as varchar(4))+'=0)          
     and (b.Register_srno='+cast(@Register_srno as varchar(5))+' or '+cast(@Register_srno as varchar(5))+'=0)          
     and (Name_wife like '''+cast(@Name_wife as varchar(99))+'%'' or '''+cast(@Name_wife as varchar(99))+'''='''')          
     and (Name_husband like '''+cast(@Name_husband as varchar(99))+'%'' or '''+cast(@Name_husband as varchar(99))+'''='''')          
     and (b.Mobile_no='''+cast(@Mobile_no as varchar(10))+''' or '''+cast(@Mobile_no as varchar(10))+'''='''')    '      
        
  end          
   end          
        
   exec(@SQL)          
--print(@SQL)          
          
  End          
  
  
  
  