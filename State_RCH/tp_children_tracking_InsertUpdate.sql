USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_children_tracking_InsertUpdate]    Script Date: 09/26/2024 12:23:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--New  
ALTER PROC [dbo].[tp_children_tracking_InsertUpdate]    
(@State_Code int,    
@District_Code int,    
@Rural_Urban char(1),    
@HealthBlock_Code int,    
@Taluka_Code varchar(6),    
@HealthFacility_Type int,    
@HealthFacility_Code int,    
@HealthSubFacility_Code int,    
@Village_Code int,    
@Registration_no bigint out,    
@Immu_code nvarchar(30)=null,    
@Immu_date date=null,    
@AEFI_Serious char(1),    
@Serious_Reason int,    
@Vac_Name nvarchar(50),    
@Vac_batch nvarchar(20),    
@Vac_expiry date =null,    
@Vac_manuf nvarchar(50),    
@ANM_ID int,    
@ASHA_ID int,    
@IP_address varchar(25),    
@Created_By int,    
@Remarks nvarchar(250),    
--@Reason_closure int=0,    
--@Death_reason int=0,    
--@Other_Death_reason nvarchar(100),    
--@Death_Date date =null,    
--@Death_Place int=0 ,    
--@Closure_Remarks int=0,    
@NonSerious_Reason nvarchar(100),    
@Fully_Immunized tinyint,    
@Received_AllVaccines tinyint,    
@Mobile_ID bigint=0,    
@Source_ID as tinyint=0,  
@msg nvarchar(200)='' out,
@Is_ILI_Symptom smallint=null,
@Is_contact_Covid smallint=null,
@Covid_test_done smallint=null,
@Covid_test_result smallint=null,
@EditDeathDate date=null      
--@Case_closure bit,    
--@Reason_closure_Other nvarchar(50)    
)    
as    
BEGIN    
SET NOCOUNT ON  
--*********** check child death and PNC/Immunization date function******************** 
DECLARE @FuncReturnMsg varchar(500)
DECLARE @DeathDate date 
Declare @ChildDeathDate Date=null
SET @DeathDate=(CASE WHEN @Serious_Reason=4 THEN @Immu_date ELSE null end)
 select @FuncReturnMsg=Msg,@ChildDeathDate=DeathDate from Check_child_Services_death (@Registration_no,@Immu_date,@DeathDate,@EditDeathDate,@Immu_code,1) 
IF(@FuncReturnMsg <> '')
BEGIN
	SET @msg=@FuncReturnMsg
	return;
END
--******************************
DECLARE @VccCode varchar(10) 
select @VccCode=ImmuCode from m_ImmunizationName where ImmuName=@Vac_Name
--******************************
if not exists(select Registration_no from t_children_tracking (nolock) where Registration_no=@Registration_no and Immu_code in (select Data from dbo.Split (@Immu_code,',')))    
 begin   
     
      
   insert into t_children_tracking(    
   State_Code,District_Code,Rural_Urban,HealthBlock_Code,Taluka_Code,HealthFacility_Type,HealthFacility_Code,HealthSubFacility_Code    
   ,Village_Code,Registration_no,Immu_code,Immu_date,AEFI_Serious,Serious_Reason,Vac_Name,Vac_batch,Vac_exp_date,Vac_manuf    
   ,ANM_ID,ASHA_ID,IP_address,Created_by,Created_On,Remarks    
       
   ,NonSerious_Reason,Fully_Immunized,Received_AllVaccines,Mobile_ID,SourceID    
   ,Is_ILI_Symptom,Is_contact_Covid,Covid_test_done,Covid_test_result    
   )    
   Select @State_Code as State_Code,@District_Code as District_Code,@Rural_Urban as Rural_Urban,@HealthBlock_Code as HealthBlock_Code,  
   @Taluka_Code as Taluka_Code,@HealthFacility_Type as HealthFacility_Type,@HealthFacility_Code as HealthFacility_Code,  
   @HealthSubFacility_Code as HealthSubFacility_Code ,@Village_Code as Village_Code,@Registration_no as Registration_no,  
   B.Data as Immu_code,@Immu_date as Immu_date,
   --@AEFI_Serious as AEFI_Serious,@Serious_Reason as Serious_Reason,@Vac_Name as Vac_Name,
   --@Vac_batch as Vac_batch,@Vac_expiry as Vac_exp_date,@Vac_manuf as Vac_manuf,  
   (case when B.Data=@VccCode then @AEFI_Serious else '3' end) as AEFI_Serious,
   (case when B.Data=@VccCode then @Serious_Reason else '0' end) as Serious_Reason,
   (case when B.Data=@VccCode then @Vac_Name else '' end) as Vac_Name,
   (case when B.Data=@VccCode then @Vac_batch else '' end) as Vac_batch,
   (case when B.Data=@VccCode then @Vac_expiry else null end) as Vac_exp_date,
   (case when B.Data=@VccCode then @Vac_manuf else '' end) as Vac_manuf,
   
   @ANM_ID as ANM_ID,@ASHA_ID as ASHA_ID,@IP_address as IP_address,  
   @Created_By as Created_by,GETDATE() as Created_On,@Remarks as Remarks,@NonSerious_Reason as NonSerious_Reason,@Fully_Immunized as Fully_Immunized,  
   @Received_AllVaccines as Received_AllVaccines,@Mobile_ID as Mobile_ID,@Source_ID as Source_ID
   , @Is_ILI_Symptom as Is_ILI_Symptom ,
   @Is_contact_Covid as Is_contact_Covid ,@Covid_test_done as Covid_test_done,@Covid_test_result as Covid_test_result     
   from t_children_registration A      
   inner join    
   (select Data,1 as N from dbo.Split (@Immu_code,','))B on 1=B.N  and a.Registration_no=@Registration_no;  
     
    update t_children_registration set Fully_Immunized=@Fully_Immunized, Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no=@Registration_no     
      
    update t_children_registration set Received_AllVaccines=@Received_AllVaccines,Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no=@Registration_no     
      
   set @msg='Record Save Successfully !!!'    
         
   update t_page_tracking_Child set Page_Code='CHT' where Registration_No=@Registration_no    
 end    
else    
    
 begin    
  update t_children_tracking set    
  Immu_date=@Immu_date,    
  AEFI_Serious=@AEFI_Serious,    
  Serious_Reason=@Serious_Reason,    
  Vac_Name=@Vac_Name,    
  Vac_batch=@Vac_batch,    
  Vac_exp_date=@Vac_expiry,    
  Vac_manuf=@Vac_manuf,    
  --ANM_ID=@ANM_ID,    
  --ASHA_ID=@ASHA_ID,    
  IP_address=@IP_address,    
  Remarks=@Remarks,    
     
  NonSerious_Reason=@NonSerious_Reason,    
  Fully_Immunized =@Fully_Immunized,    
  Received_AllVaccines=@Received_AllVaccines,    
  Mobile_ID=@Mobile_ID,    
  Updated_On=getdate(),    
  Updated_By=@Created_By,
  Is_ILI_Symptom=@Is_ILI_Symptom,
  Is_contact_Covid=@Is_contact_Covid,
  Covid_test_done=@Covid_test_done,
  Covid_test_result = @Covid_test_result      
  WHERE  Registration_no=@Registration_no    
   and Immu_code in (select Data from dbo.Split (@Immu_code,','))    
       
  set @msg='Record Save Successfully !!!'     
   update t_children_registration set Fully_Immunized=@Fully_Immunized, Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no=@Registration_no     
       
   update t_children_registration set Received_AllVaccines=@Received_AllVaccines, Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no=@Registration_no     
       
   if(@Immu_code = '2')    
   begin    
    update t_mother_infant set OPV_Date=@Immu_date where Infant_Id=@Registration_no and @Immu_code='2'    
   end    
   if(@Immu_code = '1')    
   begin    
    update t_mother_infant set BCG_Date=@Immu_date where Infant_Id=@Registration_no and @Immu_code='1'    
   end    
   if(@Immu_code = '12')    
   begin    
    update t_mother_infant set HEP_B_Date=@Immu_date where Infant_Id=@Registration_no and @Immu_code='12'    
   end    
   if(@Immu_code = '36')    
   begin    
    update t_mother_infant set Vit_K_Date=@Immu_date where Infant_Id=@Registration_no and @Immu_code='36'    
   end    
       
 --RETURN    
 end   
 IF(@Serious_Reason=4)
 BEGIN 
	update t_children_registration set Entry_Type=1,Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no=@Registration_no
	UPDATE t_Children_Master set Child_Death=1,Child_Death_Date=@Immu_date where Registration_no=@Registration_no     
 END
 ELSE
 BEGIN
	IF(@ChildDeathDate is not null)
	BEGIN 
		update t_children_registration SET Entry_Type = 1, Updated_On=GETDATE() where Registration_no = @Registration_no    
		UPDATE t_Children_Master set Child_Death=1 where Registration_no=@Registration_no
	END
	ELSE
	BEGIN
		update t_children_registration SET Entry_Type = 4,Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no = @Registration_no
		UPDATE t_Children_Master set Child_Death=0,Child_Death_Date=null where Registration_no=@Registration_no 
	END
 END
 update t_Children_Master set Child_Immu_Date=@Immu_date where  Registration_no=@Registration_no     
END    
IF (@@ERROR <> 0)    
BEGIN    
     RAISERROR ('TRANSACTION FAILED',16,-1)    
     ROLLBACK TRANSACTION    
END    
  
