USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_anc_InsertUpdate]    Script Date: 09/26/2024 14:49:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	ALTER proc [dbo].[tp_mother_anc_InsertUpdate]                
(@State_Code int,                
@District_Code int,                
@Rural_Urban char(1),                
@HealthBlock_Code int,                
@Taluka_Code varchar(6),                
@HealthFacility_Type int,                
@HealthFacility_Code int,                
@HealthSubFacility_Code int,                
@Village_Code int,                
@Financial_Yr varchar(7),                
@Financial_Year smallint,--11                
@Registration_no bigint out,                
@ID_No varchar(18)=null,                
@ANC_No int,                
@ANC_Date date,                
@Pregnancy_Month tinyint,                
@Abortion_IfAny bit,                
@Abortion_Type tinyint,                
@Induced_Indicate_Facility As tinyint,                
@Abortion_date date=null,                
@Weight float,--10                
@BP_Systolic int,                
@BP_Distolic int,                
--@Odema_Feet bit,                
@Hb_gm float,                
@Urine_Test tinyint,                
@Urine_Albumin char(1)=null,                
@Urine_Sugar char(1)=null,                
@BloodSugar_Test tinyint,                
@Blood_Sugar_Fasting as smallint,                
@Blood_Sugar_Post_Prandial as smallint,                
@FA_Given int,--10                
@IFA_Given int,                
@Abdoman_FH nvarchar(10),                
@Abdoman_FHS nvarchar(10),                
@Abdoman_FP nvarchar(10),                
@Foetal_Movements as tinyint,                
@Symptoms_High_Risk nvarchar(50),                
@Referral_Date date=null,                
@Referral_facility char(2),                
@Referral_location nvarchar(25),                
@Maternal_Death bit,--10                
@Death_Date date=null,                
@Death_Reason nvarchar(50),                
@ANM_ID int,                
@ASHA_ID int,                
@Case_no int,                
@IP_address varchar(25),                
@Created_By int,                
@LMP date,                
@TT_Date date=null,                
@TT_Code int=0,                
@PPMC char(1),                
@Other nvarchar(50),                
@Symptoms_High_Risk_Length int,                
@Death_Reason_Length int,                
@Other_Symptoms_High_Risk nvarchar(50),                
@Other_Death_Reason nvarchar(50),                
@DeliveryLocation int,                
@FacilityPlaceANCDone int,                
@FacilityLocationIDANCDone int,                
@FacilityLocationANCDone nvarchar(50),--10                
@Mobile_ID bigint=0,                
@Source_ID tinyint=0,                
@strflag int=0,               
@msg nvarchar(200)='' out,  
@Is_ILI_Symptom smallint=null,  
@Is_contact_Covid smallint=null,  
@Covid_test_done smallint=null,  
@Covid_test_result smallint=null                  
)                
as                
BEGIN                
SET NOCOUNT ON                
                
declare @ANC_Type int=0 , @MinANCDate date, @MaxANCDate date , @DeliveryDate date                
                  
  if(@ANC_Date between (DATEADD(DAY,30, @LMP)) and (DATEADD(DAY,91, @LMP)) )                
  begin                
    set @ANC_Type=1                
    set @MinANCDate = DATEADD(DAY,92,@LMP)                
    set @MaxANCDate = DATEADD(DAY,188,@LMP)                
                    
                
                   
    end                
  if(@ANC_Date between (DATEADD(DAY,92, @LMP)) and (DATEADD(DAY,188, @LMP)) )                
  begin                
    set @ANC_Type=2                
    set @MinANCDate = DATEADD(DAY,189,@LMP)                
    set @MaxANCDate = DATEADD(DAY,244,@LMP)                
    end             
  if(@ANC_Date between (DATEADD(DAY,189, @LMP)) and (DATEADD(DAY,244, @LMP)) )                
  begin                
    set @ANC_Type=3                
    set @MinANCDate = DATEADD(DAY,245,@LMP)                
    set @MaxANCDate = DATEADD(DAY,280,@LMP)                
    end                
  if(@ANC_Date between (DATEADD(DAY,245, @LMP)) and (DATEADD(DAY,280, @LMP)) )                
  begin                
    set @ANC_Type=4                
  end                
                   
  if(@ANC_Date='1990-01-01')---for abortaion case set anc_date '1990-01-01'                
  begin                
    set @ANC_Type= 99                
     --set @Pregnancy_Month=Datediff(week,@LMP,@Abortion_Date)             
     set @Pregnancy_Month=@Pregnancy_Month    ----done by Ramesh                
  end                
  else                
  begin                
   if(@ANC_Type=1 or @ANC_Type=2 or @ANC_Type=3 or @ANC_Type=4)                
    --set @Pregnancy_Month=Datediff(week,@LMP,@ANC_Date)             
    set @Pregnancy_Month=@Pregnancy_Month    ----done by Ramesh                
                   
  end                
                 
 --------Changes Made by Aditya for Inavalid ANC DATE12062018------------------              
  IF @ANC_Type=0              
  BEGIN              
   SET @msg ='Invalid ANC Date'              
  END              
  -------------------------------------------------------------------------------                   
      
  select @DeliveryDate = Delivery_date from t_mother_delivery (NOLOCK) where Registration_no = @Registration_no and Case_no = @Case_no  
    if (@DeliveryDate IS NOT NULL and @ANC_Date > @DeliveryDate)  
 begin  
     set @msg='Can not insert ANC with ANC date greater than Delivery Date'     
  RETURN   
 end   
    else if (@DeliveryDate IS NOT NULL and (@Abortion_date is not null or @Death_Date  is not null))  
 begin  
     set @msg='Abortion/Death cannot be marked as delivery details are already entered for this beneficiary'  --done by KailasH
  RETURN   
 end    
          
 if not exists(select Registration_no from t_mother_anc (NOLOCK) where State_Code=@State_Code                
   and Registration_no=@Registration_no and ANC_No=@ANC_No and Case_no=@Case_no )                
  begin                
   if(@ANC_Type<>0)  --check if ANC_Date fall after 280 days(when maximum limit exceeded)                
   begin                
    set @ANC_No = (Select isnull(max(ANC_No),0)+1  from t_mother_anc where State_Code=@State_Code                
    and Registration_no=@Registration_no and Case_no=@Case_no)                
                       
    insert into t_mother_anc(State_Code,District_Code,Rural_Urban,HealthBlock_Code,Taluka_Code,HealthFacility_Type,HealthFacility_Code,HealthSubFacility_Code,Village_Code                
    ,Financial_Yr,Financial_Year,Registration_no,ID_No,ANC_No,ANC_Type,ANC_Date,Pregnancy_Month,Abortion_IfAny,Abortion_Type,Induced_Indicate_Facility                
    ,[Weight],BP_Systolic,BP_Distolic                
    --,Odema_Feet                
    ,Hb_gm,Urine_Test,Urine_Albumin,Urine_Sugar,BloodSugar_Test,Blood_Sugar_Fasting,Blood_Sugar_Post_Prandial                
    ,FA_Given,IFA_Given,Abdoman_FH,Abdoman_FHS,Abdoman_FP,Foetal_Movements,Symptoms_High_Risk,Referral_Date,Referral_facility,Referral_location,Maternal_Death                
    ,Death_Date,Death_Reason,ANM_ID,ASHA_ID,Case_no,IP_address,Created_By,Created_On,Abortion_date,TT_Date,TT_Code,PPMC,Other                
    ,Symptoms_High_Risk_Length,Death_Reason_Length,Other_Symptoms_High_Risk,Other_Death_Reason,DeliveryLocationID                
    ,FacilityPlaceANCDone,FacilityLocationIDANCDone,FacilityLocationANCDone,Mobile_ID,SourceID,Is_ILI_Symptom,Is_contact_Covid,Covid_test_done,Covid_test_result)                
    values (@State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code                
    ,@Financial_Yr,@Financial_Year,@Registration_no,@ID_No,@ANC_No,@ANC_Type,@ANC_Date,@Pregnancy_Month                
    ,@Abortion_IfAny,@Abortion_Type,@Induced_Indicate_Facility,@Weight,@BP_Systolic,@BP_Distolic                
    --,@Odema_Feet                
    ,@Hb_gm                
    ,@Urine_Test,@Urine_Albumin,@Urine_Sugar,@BloodSugar_Test,@Blood_Sugar_Fasting,@Blood_Sugar_Post_Prandial                    
	,@FA_Given,@IFA_Given,@Abdoman_FH,@Abdoman_FHS,@Abdoman_FP,@Foetal_Movements,@Symptoms_High_Risk                
    ,@Referral_Date,@Referral_facility,@Referral_location,@Maternal_Death,@Death_Date,@Death_Reason                
    ,@ANM_ID,@ASHA_ID,@Case_no,@IP_address,@Created_By,GETDATE(),@Abortion_date,@TT_Date,@TT_Code,@PPMC,@Other                
    ,@Symptoms_High_Risk_Length,@Death_Reason_Length,@Other_Symptoms_High_Risk,@Other_Death_Reason,@DeliveryLocation                
    ,@FacilityPlaceANCDone,@FacilityLocationIDANCDone,@FacilityLocationANCDone,@Mobile_ID,@Source_ID,@Is_ILI_Symptom,@Is_contact_Covid,@Covid_test_done,@Covid_test_result)              
                    
                    
    update t_page_tracking set Registration_no=@Registration_no,Page_Code='MA',Execution_Date=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no                
                  
    insert into t_Symptoms_High_Risk(Registration_no,ID,Case_no,ANC_No,Created_On)                
    select a.Registration_no,b.Data,@Case_no,@ANC_No,GETDATE() from (select @Registration_no as Registration_no) a                
    inner join                 
    (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Symptoms_High_Risk)) b on a.Registration_no=b.Registration_no                
                    
    if(@Maternal_Death = 1)                
    begin                
                    
     insert into t_Death_Reason(Registration_no,ID,Case_no,ANC_No)                
     select a.Registration_no,b.Data,@Case_no,@ANC_No from (select @Registration_no as Registration_no)a                
     inner join                
     (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Death_Reason))b on a.Registration_no=b.Registration_no          
      Update t_eligibleCouples_Status set Eligible ='N' where Registration_no = @Registration_no and MAX_Case_no = @Case_no                  
    end               
                
     update [t_Hierarchy_Mother_Master] set Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where  Registration_no=@Registration_no and Case_no=@Case_no                 
     update t_mother_infant_intermediate set Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where Registration_no=@Registration_no and Case_no=@Case_no                 
     set @msg='Record Save Successfully !!!'                
   end                
                   
  end                
 else                
  begin                
                
                     
   update t_mother_anc set                 
   Financial_Yr=@Financial_Yr,                
   Financial_Year=@Financial_Year,                
   ANC_No=@ANC_No,                
   ANC_Type=@ANC_Type,                
   ANC_Date=@ANC_Date,                
   Pregnancy_Month=@Pregnancy_Month,                
   Abortion_IfAny=@Abortion_IfAny,                
   Abortion_Type=@Abortion_Type,                
   Induced_Indicate_Facility=@Induced_Indicate_Facility,                
   Weight=@Weight,                
   BP_Systolic=@BP_Systolic,                
   BP_Distolic=@BP_Distolic,                
   --Odema_Feet=@Odema_Feet,                
   Hb_gm=@Hb_gm,                
   Urine_Test=@Urine_Test,                
   Urine_Albumin=@Urine_Albumin,                
   Urine_Sugar=@Urine_Sugar,                
   BloodSugar_Test=@BloodSugar_Test,                
   Blood_Sugar_Fasting=@Blood_Sugar_Fasting,                
   Blood_Sugar_Post_Prandial=@Blood_Sugar_Post_Prandial,                
   FA_Given=@FA_Given,                
   IFA_Given=@IFA_Given,                
   Abdoman_FH=@Abdoman_FH,                
   Abdoman_FHS=@Abdoman_FHS,                
   Abdoman_FP=@Abdoman_FP,                
   Foetal_Movements=@Foetal_Movements,                
   Symptoms_High_Risk=@Symptoms_High_Risk,                
   Referral_Date=@Referral_Date,                
   Referral_facility=@Referral_facility,                
   Referral_location=@Referral_location,                
   Maternal_Death=@Maternal_Death,                
   Death_Date=@Death_Date,                
   Death_Reason=@Death_Reason,                
   ANM_ID=@ANM_ID,                
   ASHA_ID=@ASHA_ID,                
   IP_address=@IP_address,                
   Abortion_date=@Abortion_date,                
   TT_Date=@TT_Date,                
   TT_Code=@TT_Code,                
   PPMC=@PPMC,                
   Other=@Other,                
   Symptoms_High_Risk_Length=@Symptoms_High_Risk_Length,                
   Death_Reason_Length=@Death_Reason_Length,                
   Other_Symptoms_High_Risk=@Other_Symptoms_High_Risk,                
   Other_Death_Reason=@Other_Death_Reason,                
   DeliveryLocationID=@DeliveryLocation,                
   FacilityPlaceANCDone=@FacilityPlaceANCDone,                
   FacilityLocationIDANCDone=@FacilityLocationIDANCDone,                
   FacilityLocationANCDone=@FacilityLocationANCDone,                
   Mobile_ID=@Mobile_ID,                
   Updated_On=GETDATE(),                
   Updated_By=@Created_By,  
   Is_ILI_Symptom=@Is_ILI_Symptom,  
   Is_contact_Covid=@Is_contact_Covid,  
   Covid_test_done=@Covid_test_done,  
   Covid_test_result = @Covid_test_result              
   where  State_Code=@State_Code                
   and Registration_no=@Registration_no                 
   and ANC_No=@ANC_No                
   and Case_no=@Case_no             
               
   update [t_Hierarchy_Mother_Master] set Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where  Registration_no=@Registration_no and Case_no=@Case_no                 
   update t_mother_infant_intermediate set Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where Registration_no=@Registration_no and Case_no=@Case_no               
               
   set @msg='Record Save Successfully !!!'                
               
   ---------------------- insert for t_Symptoms_High_Risk                
   if exists(select * from t_Symptoms_High_Risk where Registration_no=@Registration_no and ANC_No=@ANC_No and Case_no=@Case_no)                
   begin                
    delete from t_Symptoms_High_Risk where Registration_no=@Registration_no and ANC_No=@ANC_No and Case_no=@Case_no                
    insert into t_Symptoms_High_Risk(Registration_no,ID,Case_no,ANC_No,Created_On)                
    select a.Registration_no,b.Data,@Case_no,@ANC_No,GETDATE() from (select @Registration_no as Registration_no) a                
    inner join                 
    (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Symptoms_High_Risk)) b on a.Registration_no=b.Registration_no                
   end                
   else                
   begin                
    insert into t_Symptoms_High_Risk(Registration_no,ID,Case_no,ANC_No,Created_On)                
    select a.Registration_no,b.Data,@Case_no,@ANC_No,GETDATE() from (select @Registration_no as Registration_no) a                
    inner join                 
    (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Symptoms_High_Risk)) b on a.Registration_no=b.Registration_no                
   end                
   ---------------------- insert for t_Death_Reason                
   if(@Maternal_Death = 1)                
   begin                
   if exists(select * from t_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and ANC_No=@ANC_No)                
   begin                
    delete from t_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and ANC_No=@ANC_No                
    insert into t_Death_Reason(Registration_no,ID,Case_no,ANC_No)                
    select a.Registration_no,b.Data,@Case_no,@ANC_No from (select @Registration_no as Registration_no) a                
    inner join                 
    (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Death_Reason)) b on a.Registration_no=b.Registration_no           
       Update t_eligibleCouples_Status set Eligible ='N' where Registration_no = @Registration_no and MAX_Case_no = @Case_no                
   end                
   else                
   begin                
    insert into t_Death_Reason(Registration_no,ID,Case_no,ANC_No)                
    select a.Registration_no,b.Data,@Case_no,@ANC_No from (select @Registration_no as Registration_no) a                
    inner join              
    (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Death_Reason)) b on a.Registration_no=b.Registration_no            
     Update t_eligibleCouples_Status set Eligible ='E' where Registration_no = @Registration_no and MAX_Case_no = @Case_no               
   end                
    end                 
       end                
                  
                
  if(@ANC_Type=99)                
                
                
  begin                
   if(@Abortion_IfAny =1 and @Maternal_Death=1)    --(Fresh Entry abortion & Death) or (Update ANC to Abortion and Death)            
   begin                
    update [t_Hierarchy_Mother_Master] set  Mother_ANC_Date=@ANC_Date,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_Death_Date=@Death_Date,Mother_Death=1 where Registration_no=@Registration_no and Case_no=@Case_no                
    update t_mother_infant_intermediate set  Mother_ANC_Date=@ANC_Date,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_Death_Date=@Death_Date,Mother_Death=1 where Registration_no=@Registration_no and Case_no=@Case_no                
    update t_mother_registration set Entry_Type=@Maternal_Death,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no                
               
    if not exists(select * from t_death_records (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)            
   begin            
   insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no) Values (@Registration_no,GETDATE(),1,@Case_no)                
   end              
    if not exists(select * from t_temp (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)--Sneha 16052017                
  begin                
     insert into t_temp(Registration_no,Case_no,Re_Registration_Done) Values(@Registration_no,@Case_no,0)              
  end                  
    end                
                           
   else if(@Abortion_IfAny =1 and @Maternal_Death=0)    --(Fresh Entry abortion) or (Update ANC to Abortion)            
   begin                  
  update [t_Hierarchy_Mother_Master] set  Mother_ANC_Date=@ANC_Date,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No where Registration_no=@Registration_no and Case_no=@Case_no                
  update t_mother_infant_intermediate set  Mother_ANC_Date=@ANC_Date,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No where Registration_no=@Registration_no and Case_no=@Case_no                
              
   if(@Death_Date is null) --if Abortion and Death exist in same line and user remove Death only---            
  begin            
    update [t_Hierarchy_Mother_Master] set Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where                 
     Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death = 1 --Update---            
                         
     update t_mother_infant_intermediate set  Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date where               
   Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death = 1 --Update---            
   end             
              
   if not exists(select * from t_temp where Registration_no=@Registration_no and Case_no=@Case_no)                
   begin                
                 
      insert into t_temp(Registration_no,Case_no,Re_Registration_Done) Values(@Registration_no,@Case_no,0)                
   end        
                   
   update t_mother_registration set Entry_Type=4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no and Entry_Type<>4                
                 
    if exists(select * from t_death_records (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)                
   begin             
   DELETE FROM t_death_records  Where Registration_no=@Registration_no and Case_no=@Case_no                
    end            
   end                  
                
   ELSE IF(@Abortion_IfAny =0 and @Maternal_Death=1)     --(Fresh Entry for Death) or (Update ANC to Death)            
                      
   BEGIN                
                    
     if exists(Select 1 from t_mother_infant_intermediate (nolock) where Registration_no = @Registration_no and Case_no = @Case_no and Mother_Death = 1 and Mother_Abortion_Date is not null) -- Check Insert Death & Donot Update Abortion            
      begin            
   if (@Abortion_date is null)   --if Abortion and Death exist in same line and user remove abortion only---            
     begin            
  update [t_Hierarchy_Mother_Master] set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date          
  where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Abortion_Date is not null --update--                
                   
  update t_mother_infant_intermediate set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                 
  where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Abortion_Date is not null   --update--            
      end               
   end                
            
   update [t_Hierarchy_Mother_Master] set Mother_ANC_Date=@ANC_Date,Mother_Death_Date=@Death_Date,Mother_Death=1,Mother_ANC_No=@ANC_No where Registration_no=@Registration_no and Case_no=@Case_no                 
   update t_mother_infant_intermediate set Mother_ANC_Date=@ANC_Date,Mother_Death_Date=@Death_Date,Mother_Death=1,Mother_ANC_No=@ANC_No where Registration_no=@Registration_no and Case_no=@Case_no                 
              
   update t_mother_registration set Entry_Type=1,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no            
    --and Entry_Type<>4                        
   if not exists(select * from t_death_records where Registration_no=@Registration_no and Case_no=@Case_no)                
   begin                
   insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no) Values (@Registration_no,GETDATE(),1,@Case_no)                
   end                
     --DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no              
                   
 END                 
                
  end                
                
  else                
                
  begin                
                  
                  
  /**************************************************Abortion Part*********************************************************/                
                  
  --IF(@Abortion_date IS NOT NULL)                
                  
  --begin                
  --   update [t_Hierarchy_Mother_Master] set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                  
  --where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Abortion_Date is not null                 
                  
  --      update t_mother_infant_intermediate set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                 
  --      where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Abortion_Date is not null             
                    
  --       if exists(select * from t_temp where Registration_no=@Registration_no and Case_no=@Case_no)--Sneha 16052017                
  -- begin               
  --     DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no               
                  
  -- end                     
  --      end                
                        
                        
        IF(@strflag = 1)     ----(Update Abortion to ANC in single row)            
                        
        BEGIN                
                        
        update [t_Hierarchy_Mother_Master] set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date  where                
   Registration_no=@Registration_no and Case_no=@Case_no                 
                  
        update t_mother_infant_intermediate set Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                 
        where Registration_no=@Registration_no and Case_no=@Case_no      
              
          --//****Changes by Aditya***************************************************************//               
        if not exists(select 1 from t_mother_medical WITH(NOLOCK) where Registration_no = @Registration_no and Case_no=@Case_no and  DATEADD(day,322,LMP_date) <= CONVERT(date,GETDATE()))       
           and not exists(select 1 from  t_mother_delivery WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)          
          begin      
                if exists(select 1 from t_temp WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)      
                 begin      
                   DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no       
                 end           
          end                
        END                
                        
                        
        /****************************************************************************************************************************/                
                        
                        
        /**************************************************Death Part*****************************************************************/                
                        
     --   if(@Death_Date is not null )-- insert                 
     --   begin                
     --   update [t_Hierarchy_Mother_Master] set Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                  
     --   where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death = 1                
                        
     --   update t_mother_infant_intermediate set  Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                
     --   where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death = 1              
     -- update t_mother_registration set Entry_Type=4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no and Entry_Type<>4                
     --DELETE FROM t_death_records  Where Registration_no=@Registration_no and Case_no=@Case_no                 
     --   end                
                         
        IF(@strflag = 2)    ---(Update Death to ANC in single row)            
                         
        BEGIN                 
                        
        update [t_Hierarchy_Mother_Master] set Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                  
        where Registration_no=@Registration_no and Case_no=@Case_no                 
                        
        update t_mother_infant_intermediate set  Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                
        where Registration_no=@Registration_no and Case_no=@Case_no                 
                        
  --      if exists(select * from t_temp where Registration_no=@Registration_no and Case_no=@Case_no)                
  --BEGIN                
  --     DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no               
  --END                 
              
  update t_mother_registration set Entry_Type=4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no and Entry_Type<>4                
     DELETE FROM t_death_records  Where Registration_no=@Registration_no and Case_no=@Case_no                
                           
        END                 
                        
        /**************************************************Death and Abortion Part Together*****************************************************************/                
                        
                        
        IF(@strflag = 3)    ----(Update Death and Abortion to ANC in single row)            
                        
        BEGIN                                       
        update [t_Hierarchy_Mother_Master] set Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                
  where Registration_no=@Registration_no and Case_no=@Case_no                 
                  
        update t_mother_infant_intermediate set Mother_Death_Date=@Death_Date,Mother_Death=0,Mother_Abortion_Date=@Abortion_date,Mother_ANC_No=@ANC_No,Mother_ANC_Date=@ANC_Date                 
        where Registration_no=@Registration_no and Case_no=@Case_no                 
                             
       -- if exists(select * from t_temp where Registration_no=@Registration_no and Case_no=@Case_no)                
       -- BEGIN                
       --DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no                
       -- END      
            
         if not exists(select 1 from t_mother_medical WITH(NOLOCK) where Registration_no = @Registration_no and Case_no=@Case_no and  DATEADD(day,322,LMP_date)<= CONVERT(date,GETDATE()))       
           and not exists(select 1 from  t_mother_delivery WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)          
          begin      
                if exists(select 1 from t_temp WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)      
                 begin      
                   DELETE FROM t_temp  Where Registration_no=@Registration_no and Case_no=@Case_no       
                 end           
          end                
        --END        
            
            
            
                   
                
  update t_mother_registration set Entry_Type=4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no and Entry_Type<>4                
     DELETE FROM t_death_records  Where Registration_no=@Registration_no and Case_no=@Case_no                
                        
        END                 
                     
  END                 
   declare @Entry_Type int, @LENGTH int = 0, @value char(1)            
   select @LENGTH=Maternal_Death from t_mother_anc (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Maternal_Death=1            
   select @value='G' from t_mother_delivery (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Delivery_Complication like '%G%'            
   select @LENGTH=Mother_Death from t_mother_pnc (NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death=1            
   if(@LENGTH = 1 or  @value='G')            
   begin            
    update t_mother_registration set Entry_Type=1,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no            
   end            
   else             
   begin            
  update t_mother_registration set Entry_Type=4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no            
   end              
                   
 RETURN                
END                
                  
IF (@@ERROR <> 0)                
BEGIN                
     RAISERROR ('TRANSACTION FAILED',16,-1)                
     ROLLBACK TRANSACTION                
END                
          
