USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlMother_ANC]    Script Date: 09/26/2024 12:15:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[MS_SetXmlMother_ANC]                
(@State_Code int,@District_Code int,@Rural_Urban char(1),@HealthBlock_Code int,@Taluka_Code varchar(6),                
@HealthFacility_Type int,@HealthFacility_Code int,@HealthSubFacility_Code int,@Village_Code int,                
@Financial_Yr varchar(7),@Financial_Year smallint,@Registration_no bigint out,                
--,@ID_No varchar(18)=null,                
@ANC_No int,@ANC_Date date,@Pregnancy_Month tinyint,@Abortion_IfAny bit,@Abortion_Type tinyint,                
@Induced_Indicate_Facility As tinyint,@Abortion_date date=null,@Weight float,@BP_Systolic int,@BP_Distolic int,                
--@Odema_Feet bit,        
@Hb_gm float,@Urine_Test tinyint,@Urine_Albumin char(1)=null,@Urine_Sugar char(1)=null,                
@BloodSugar_Test tinyint,@Blood_Sugar_Fasting as smallint,@Blood_Sugar_Post_Prandial as smallint,@FA_Given int,                
@IFA_Given int,@Abdoman_FH nvarchar(10),@Abdoman_FHS nvarchar(10),@Abdoman_FP nvarchar(10),@Foetal_Movements as tinyint,                
@Symptoms_High_Risk nvarchar(50),@Referral_Date date=null,@Referral_facility char(2),@Referral_location nvarchar(25),                
@Maternal_Death bit,@Death_Date date=null,@Death_Reason nvarchar(50),@ANM_ID int,@ASHA_ID int,@Case_no int,                
@IP_address varchar(25),@Created_By int,@LMP date,@TT_Date date=null,@TT_Code int=0,@PPMC char(1)=''                 
,@Other nvarchar(50),@Symptoms_High_Risk_Length int,@Death_Reason_Length int,@Other_Symptoms_High_Risk nvarchar(50),@Other_Death_Reason nvarchar(50), -- 9 parameteres added                
@DeliveryLocation int,@FacilityPlaceANCDone int,@FacilityLocationIDANCDone int,@FacilityLocationANCDone nvarchar(50) -- 9 parameteres added                
,@Mobile_ID bigint=0,@msg varchar(200)='00000' out,@SourceID int)                
AS                
BEGIN                
                
declare @t_msg varchar(99)                
    IF ISNULL(@Abortion_date,'') = '' Begin Set @Abortion_date = NULL End--Added by Manas on 07122017    
  IF ISNULL(@Referral_Date,'') = '' Begin Set @Referral_Date = NULL End--Added by Manas on 07122017    
  IF ISNULL(@Death_Date,'') = '' Begin Set @Death_Date = NULL End--Added by Manas on 07122017    
  IF ISNULL(@TT_Date,'') = '' Begin Set @TT_Date = NULL End --Added by Manas on 07122017     
    
If exists(select 1 from t_mother_registration WITH(NOLOCK) where ISNULL(Delete_Mother,0)=1 and Registration_no=@Registration_no and Case_no=@Case_no)  
Begin  
set @msg='501'  --Service can not be updated as Beneficiary is marked for deletion.  
return;  
End  
ELse  
Begin  
if not exists(SELECT 1 FROM [t_ANM_ASHA_Mapping_Village] WITH(NOLOCK) where ID=@ANM_ID and  District_Code=@District_Code and Taluka_Code=@Taluka_Code    
and HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code    
and Village_Code=@Village_Code and Is_Mapped in(0,1) )    
begin    
set @msg='400'    
end                
else if exists( select 1 from t_mother_medical WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)        
begin        
 if exists( select 1 from t_mother_anc WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and ANC_No=@ANC_No)        
  begin        
   set @msg='55' --Alredy Exists          
  End        
 Else        
  Begin        
  exec tp_mother_anc_InsertUpdate        
  @State_Code        
  ,@District_Code           
  ,@Rural_Urban           
  ,@HealthBlock_Code           
  ,@Taluka_Code           
  ,@HealthFacility_Type           
  ,@HealthFacility_Code           
  ,@HealthSubFacility_Code           
  ,@Village_Code           
  ,@Financial_Yr           
  ,@Financial_Year --11          
  ,@Registration_no            
  ,''        
  ,@ANC_No           
  ,@ANC_Date           
  ,@Pregnancy_Month           
  ,@Abortion_IfAny           
  ,@Abortion_Type           
  ,@Induced_Indicate_Facility           
  ,@Abortion_date           
  ,@Weight --10          
  ,@BP_Systolic           
  ,@BP_Distolic           
  --,@Odema_Feet           
  ,@Hb_gm           
  ,@Urine_Test           
  ,@Urine_Albumin           
  ,@Urine_Sugar           
  ,@BloodSugar_Test           
  ,@Blood_Sugar_Fasting           
  ,@Blood_Sugar_Post_Prandial           
  ,@FA_Given--10           
  ,@IFA_Given           
  ,@Abdoman_FH           
  ,@Abdoman_FHS           
  ,@Abdoman_FP        
  ,@Foetal_Movements          
  ,@Symptoms_High_Risk           
  ,@Referral_Date           
  ,@Referral_facility           
  ,@Referral_location           
  ,@Maternal_Death --10          
  ,@Death_Date           
  ,@Death_Reason           
  ,@ANM_ID           
  ,@ASHA_ID           
  ,@Case_no           
  ,@IP_address           
  ,@Created_By           
  ,@LMP           
  ,@TT_Date           
  ,@TT_Code --10          
  ,@PPMC           
  ,@Other           
  ,@Symptoms_High_Risk_Length           
  ,@Death_Reason_Length           
  ,@Other_Symptoms_High_Risk           
  ,@Other_Death_Reason           
  ,@DeliveryLocation           
  ,@FacilityPlaceANCDone           
  ,@FacilityLocationIDANCDone           
  ,@FacilityLocationANCDone --10          
  ,@Mobile_ID           
  ,3  
  ,0        
  ,@t_msg output         
  if(@t_msg='Record Save Successfully !!!')        
  begin        
  INSERT INTO .dbo.MS_mother_anc(State_Code ,District_Code ,Rural_Urban ,HealthBlock_Code ,Taluka_Code ,                
  HealthFacility_Type ,HealthFacility_Code ,HealthSubFacility_Code ,Village_Code ,                
  Financial_Yr ,Financial_Year ,Registration_no ,ID_No ,                
  ANC_No ,ANC_Date ,Pregnancy_Month ,Abortion_IfAny ,Abortion_Type ,                
  Induced_Indicate_Facility ,Abortion_date,Weight ,BP_Systolic ,BP_Distolic ,                
  Hb_gm ,Urine_Test ,Urine_Albumin ,Urine_Sugar ,                
  BloodSugar_Test ,Blood_Sugar_Fasting ,Blood_Sugar_Post_Prandial ,FA_Given ,                
  IFA_Given ,Abdoman_FH ,Abdoman_FHS ,Abdoman_FP,Foetal_Movements ,                
  Symptoms_High_Risk ,Referral_Date ,Referral_facility ,Referral_location ,                
  Maternal_Death ,Death_Date ,Death_Reason ,ANM_ID ,ASHA_ID ,Case_no ,                
  IP_address ,Created_By ,LMP ,TT_Date ,TT_Code ,PPMC                 
  ,Mobile_ID,Created_On ,[Other],[Symptoms_High_Risk_Length],[Death_Reason_Length]                
   ,[Other_Symptoms_High_Risk],[Other_Death_Reason],[DeliveryLocationID]                
   ,[FacilityPlaceANCDone],[FacilityLocationIDANCDone],[FacilityLocationANCDone]                
   ,SourceID                
  )                
  VALUES                
  (                
  cast(@State_Code as varchar)      ,cast(@District_Code as varchar)      ,cast(@Rural_Urban  as varchar)     ,cast(@HealthBlock_Code as varchar)      ,cast(@Taluka_Code as varchar)                
  ,cast(@HealthFacility_Type as varchar)      ,cast(@HealthFacility_Code as varchar)      ,cast(@HealthSubFacility_Code as varchar)      ,cast(@Village_Code as varchar),                
  cast(@Financial_Yr as varchar) ,cast(@Financial_Year as varchar) ,cast(@Registration_no as varchar) ,'' ,                
  cast(@ANC_No as varchar) ,cast(@ANC_Date  as varchar) ,cast(@Pregnancy_Month as varchar) ,cast(@Abortion_IfAny as varchar) ,cast(@Abortion_Type as varchar) ,                
  cast(@Induced_Indicate_Facility as varchar) ,cast(@Abortion_date  as varchar),cast(@Weight as varchar) ,cast(@BP_Systolic as varchar) ,cast(@BP_Distolic as varchar) ,                
  cast(@Hb_gm as varchar)  ,cast(@Urine_Test as varchar) ,cast(@Urine_Albumin  as varchar) ,cast(@Urine_Sugar  as varchar) ,                
  cast(@BloodSugar_Test as varchar) ,cast(@Blood_Sugar_Fasting as varchar) ,cast(@Blood_Sugar_Post_Prandial as varchar) ,cast(@FA_Given as varchar) ,                
  cast(@IFA_Given as varchar) ,cast(@Abdoman_FH as varchar) ,cast(@Abdoman_FHS  as varchar) ,cast(@Abdoman_FP  as varchar),cast(@Foetal_Movements as varchar) ,                
  cast(@Symptoms_High_Risk as varchar) ,cast(@Referral_Date  as varchar) ,cast(@Referral_facility  as varchar) ,cast(@Referral_location  as varchar) ,                
  cast(@Maternal_Death as varchar) ,cast(@Death_Date   as varchar) ,cast(@Death_Reason as varchar) ,cast(@ANM_ID as varchar) ,cast(@ASHA_ID as varchar) ,cast(@Case_no as varchar) ,                
  cast(@IP_address  as varchar) ,cast(@Created_By as varchar) ,cast(@LMP  as varchar) ,cast(@TT_Date  as varchar) ,cast(@TT_Code as varchar) ,cast(@PPMC as varchar)                
  ,cast(@Mobile_ID as varchar),getdate()                
  ,cast(@Other as varchar), cast(@Symptoms_High_Risk_Length as varchar) ,cast(@Death_Reason_Length as varchar) ,cast(@Other_Symptoms_High_Risk as varchar),cast(@Other_Death_Reason as varchar) ,                
  cast(@DeliveryLocation as varchar) ,cast(@FacilityPlaceANCDone as varchar) ,cast(@FacilityLocationIDANCDone as varchar),cast(@FacilityLocationANCDone as varchar)                
  ,cast(@SourceID as varchar)                
  )          
  set @msg='101'  --Record saved Successfully        
 end        
 else        
 begin        
   --------Changes Made by Aditya for Inavalid ANC DATE12062018------------------    
       if(@t_msg='Invalid ANC Date')  
          BEGIN  
           set @msg='148'--Invalid ANC Date  
          END 
		  else if(@t_msg='Can not insert ANC with ANC date greater than Delivery Date') 
		  BEGIN  
           set @msg='61'--Can not insert ANC with ANC date greater than Delivery Date
          END 
		  else if (@t_msg='Abortion cannot be marked as delivery details are already entered for this beneficiary')
         BEGIN  
           set @msg='62'--Abortion cannot be marked as delivery details are already entered for this beneficiary 
          END 
	   ELSE  
          BEGIN  
           set @msg='0'--Error   
          END        
------------------------------------------------------------------------------------         
       
 end        
End        
End        
else        
Begin        
 set @msg='56'--Registration number and case_no not exists in Mother Medical table        
End              
  --print(@msg)        
END  
END                
IF (@@ERROR <> 0)        
BEGIN        
 set @msg='0'        
     RAISERROR ('ERROR',16,-1)        
     ROLLBACK TRANSACTION        
END    
