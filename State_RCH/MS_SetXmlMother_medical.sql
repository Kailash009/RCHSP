USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_SetXmlMother_medical]    Script Date: 09/26/2024 12:16:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER pROCEDURE [dbo].[MS_SetXmlMother_medical]            
(@State_Code int,@District_Code int,@Rural_Urban char(1)=R,@HealthBlock_Code int=0,@Taluka_Code varchar(6)=0000,@HealthFacility_Type int=0,@HealthFacility_Code int=0,@HealthSubFacility_Code int=0,@Village_Code int=0            
,@Financial_Yr varchar(7)=null,@Financial_Year smallint=null,@Registration_no bigint out,@LMP_Date date,@Reg_12Weeks bit=0,@EDD_Date date=null,@Blood_Group int=1            
,@Past_Illness nvarchar(50)=null,@OtherPast_Illness nvarchar(20)=null,@No_Of_Pregnancy int=0,            
@Last_Preg_Complication nvarchar(50)=null,@Last_Preg_Complication_Length int=0,@Other_Last_Complication nvarchar(20)=null,@Outcome_Last_Preg int=0            
,@L2L_Preg_Complication nvarchar(50)=null,@L2L_Preg_Complication_Length int=0 ,@Other_L2L_Complication nvarchar(20)=null,@Outcome_L2L_Preg int=0            
,@Expected_delivery_place int=0,@Place_name nvarchar(60)=null,@VDRL_Test bit,@VDRL_Date date=null            
,@VDRL_Result char(1)=null,@HIV_Test bit,@HIV_Date date=null,@ANM_ID int=0,@ASHA_ID int=0,@Case_no int=1,@IP_address varchar(25)='00.00.00.00',            
@Created_By int=0,@Mobile_ID bigint=0,@msg varchar(200)='00000' out            
,@Past_Illness_Length INT=0,@HIV_Result char(1)=null,@DeliveryLocation int=null -- 3 parameters added            
,@BloodGroup_Test tinyint -- 1 parameters added on 17-12-2014            
,@SourceID int  
,@HBSAG_Test bit=null,            
 @HBSAG_Date date=null,            
 @HBSAG_Result char(1)=null 
)            
AS            
BEGIN            
            
SET @EDD_Date=CAST (@EDD_Date AS date)            
set @VDRL_Date=CAST(@VDRL_Date as date)            
set @HIV_Date=CAST(@HIV_Date as date)            
declare @t_msg varchar(200)     
  
IF ISNULL(@VDRL_Date,'') = '' Begin Set @VDRL_Date = NULL End--Added by Manas on 07122017  
IF ISNULL(@HIV_Date,'') = '' Begin Set @HIV_Date = NULL End  --Added by Manas on 07122017    
if exists(select 1 from t_mother_registration WITH(NOLOCK) where ISNULL(Delete_Mother,0)=1 and Registration_no=@Registration_no and Case_no=@Case_no)  
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
else if exists(select 1 from t_mother_registration WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no and Registration_Date<>'1990-01-01')          
 begin      
 if not exists(select 1 from t_mother_medical WITH(NOLOCK) where Registration_no=@Registration_no and Case_no=@Case_no)      
 begin      
       
  exec tp_mother_medical_InsertUpdate @State_Code ,@District_Code ,@Rural_Urban ,@HealthBlock_Code ,@Taluka_Code ,@HealthFacility_Type ,@HealthFacility_Code ,        
 @HealthSubFacility_Code ,@Village_Code ,@Financial_Yr ,@Financial_Year ,@Registration_no  ,'' ,        
 @LMP_Date ,@Reg_12Weeks ,@EDD_Date ,@Blood_Group ,@Past_Illness ,@OtherPast_Illness ,@No_Of_Pregnancy ,        
 @Last_Preg_Complication ,@Last_Preg_Complication_Length         
 ,@Other_Last_Complication ,@Outcome_Last_Preg         
 ,@L2L_Preg_Complication ,@L2L_Preg_Complication_Length         
 ,@Other_L2L_Complication ,@Outcome_L2L_Preg ,@Expected_delivery_place ,@Place_name ,        
 @VDRL_Test ,@VDRL_Date ,@VDRL_Result ,@HIV_Test ,@HIV_Date ,@ANM_ID ,@ASHA_ID ,@Case_no ,        
 @IP_address ,@Created_By,@Past_Illness_Length,@HIV_Result,@DeliveryLocation,@BloodGroup_Test ,@Mobile_ID ,3,@t_msg output,@HBSAG_Test,            
 @HBSAG_Date,            
 @HBSAG_Result     
   if(@t_msg='Record Save Successfully !!!')      
   begin      
   INSERT INTO dbo.MS_mother_medical      
   (State_Code ,District_Code ,Rural_Urban ,HealthBlock_Code ,Taluka_Code ,HealthFacility_Type ,            
   HealthFacility_Code ,HealthSubFacility_Code ,Village_Code ,Financial_Yr ,Financial_Year ,Registration_no ,LMP_Date ,Reg_12Weeks ,EDD_Date ,            
   Blood_Group ,Past_Illness ,OtherPast_Illness ,No_Of_Pregnancy ,Last_Preg_Complication ,Last_Preg_Complication_Length ,Other_Last_Complication ,Outcome_Last_Preg ,            
   L2L_Preg_Complication ,L2L_Preg_Complication_Length ,Other_L2L_Complication ,Outcome_L2L_Preg ,Expected_delivery_place ,Place_name ,VDRL_Test ,VDRL_Date ,            
   VDRL_Result ,HIV_Test ,HIV_Date ,ANM_ID ,ASHA_ID ,Case_no ,IP_address ,Created_By ,Mobile_ID,created_on,Past_Illness_Length,HIV_Result,DeliveryLocationID,BloodGroup_Test,SourceID,HBSAG_Test,HBSAG_Date ,HBSAG_Result)            
   VALUES            
  
   (            
   cast(@State_Code as varchar)      ,cast(@District_Code as varchar)      ,cast(@Rural_Urban  as varchar)     ,cast(@HealthBlock_Code as varchar)      ,cast(@Taluka_Code as varchar)            
   ,cast(@HealthFacility_Type as varchar)      ,cast(@HealthFacility_Code as varchar)      ,cast(@HealthSubFacility_Code as varchar)      ,cast(@Village_Code as varchar)            
   ,cast(@Financial_Yr as varchar)      ,cast(@Financial_Year as varchar)      ,cast(@Registration_no as varchar(12))                 
   ,cast(@LMP_Date  as varchar(15)) , cast(@Reg_12Weeks  as varchar) ,cast(@EDD_Date   as varchar) ,            
   cast(@Blood_Group  as varchar) ,cast(@Past_Illness  as varchar),cast(@OtherPast_Illness   as varchar) ,cast(@No_Of_Pregnancy  as varchar)          
   ,cast(@Last_Preg_Complication  as varchar) ,cast(@Last_Preg_Complication_Length  as varchar),cast(@Other_Last_Complication   as varchar) ,cast(@Outcome_Last_Preg as varchar) ,            
  
   cast(@L2L_Preg_Complication as varchar) ,cast(@L2L_Preg_Complication_Length   as varchar) ,cast(@Other_L2L_Complication   as varchar) ,cast(@Outcome_L2L_Preg  as varchar) ,cast(@Expected_delivery_place  as varchar) ,          
   cast(@Place_name  as varchar) ,cast(@VDRL_Test  as varchar) ,cast(@VDRL_Date  as varchar),            
   cast(@VDRL_Result  as varchar),cast(@HIV_Test  as varchar) ,cast(@HIV_Date  as varchar) ,cast(@ANM_ID  as varchar) ,cast(@ASHA_ID  as varchar) ,          
   cast(@Case_no  as varchar) ,cast(@IP_address  as varchar) ,cast(@Created_By  as varchar) ,cast(@Mobile_ID  as varchar),getdate()            
   ,cast(@Past_Illness_Length as varchar),cast(@HIV_Result as varchar),cast(@DeliveryLocation as varchar)             
   ,cast(@BloodGroup_Test as varchar) ,cast(@SourceID as varchar) ,@HBSAG_Test,            
 @HBSAG_Date,            
 @HBSAG_Result                
  
   )      
   set @msg='101'             
   end      
   else  if(@t_msg='LMP date not in the desired range with Mother registration date. LMP Date should be greater then Mother registration date - 322 days and LMP date should be less than Mother registration date - 35 days')    
   begin
      set @msg='51' --Error   
   end
   else
   begin      
   set @msg='0' --Error        
   end      
 end      
  else      
  begin      
   set @msg='45' --Alredy Exists        
  end      
end      
else      
  begin      
  set @msg='46'--Registration number and case_no not exists in Mother Registration table      
  end        
 --print(@msg)         
ENd     
END   
IF (@@ERROR <> 0)      
BEGIN      
 set @msg=0      
     RAISERROR ('ERROR',16,-1)      
     ROLLBACK TRANSACTION      
END  
