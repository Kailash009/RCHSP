USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_pnc_InsertUpdate]    Script Date: 09/26/2024 14:50:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER proc [dbo].[tp_mother_pnc_InsertUpdate]    
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
@Financial_Year smallint,    
@Registration_no bigint out,    
@ID_No varchar(18)=null,    
@PNC_No int,    
@PNC_Period int,    
@PNC_Date date,    
@No_of_IFA_Tabs_given_to_mother As smallint,    
@DangerSign_Mother nvarchar(50),    
@DangerSign_Mother_Other nvarchar(50)=null,    
@DangerSign_Mother_length int,    
@ReferralFacility_Mother int,    
@ReferralFacilityID_Mother int,    
@ReferralLoationOther_Mother nvarchar(50)=null,    
@PPC char(1),    
@OtherPPC_Method nvarchar(50)=null,    
@Mother_Death bit,    
@Mother_Death_Place As tinyint,    
@Mother_Death_Date date =null,    
@Mother_Death_Reason nvarchar(50),    
@Mother_Death_Reason_Other nvarchar(50)=null,    
@Mother_Death_Reason_length int,    
@Remarks nvarchar(300),    
@ANM_ID int,    
@ASHA_ID int,    
@Case_no int,    
@IP_address varchar(25),    
@Created_By int,    
@Delivery_date date,    
@Mobile_ID bigint=0,    
@Source_ID tinyint=0,    
@msg nvarchar(200)='' out,
@Is_ILI_Symptom smallint=null,
@Is_contact_Covid smallint=null,
@Covid_test_done smallint=null,
@Covid_test_result smallint=null,
@ActionType varchar='I'  
)    
as    
BEGIN    
SET NOCOUNT ON    


            Declare @minDatePNC1 Date =DATEADD(dd,1,@Delivery_date)
            Declare @maxDatePNC1  Date =DATEADD(dd,1,@Delivery_date)
            Declare @minDatePNC3 Date= DATEADD(dd,3,@Delivery_date)
            Declare @maxDatePNC3 Date= DATEADD(dd,3,@Delivery_date)
            Declare @minDatePNC7 Date= DATEADD(dd,4,@Delivery_date)
            Declare @maxDatePNC7 Date= DATEADD(dd,10,@Delivery_date)
            Declare @minDatePNC14 Date= DATEADD(dd,11,@Delivery_date)
            Declare @maxDatePNC14 Date= DATEADD(dd,17,@Delivery_date)
            Declare @minDatePNC21 Date= DATEADD(dd,18,@Delivery_date)
            Declare @maxDatePNC21 Date=DATEADD(dd,24,@Delivery_date)
            Declare @minDatePNC28 Date= DATEADD(dd,25,@Delivery_date)
            Declare @maxDatePNC28 Date= DATEADD(dd,31,@Delivery_date)
            Declare @minDatePNC42 Date= DATEADD(dd,39,@Delivery_date)
            Declare @maxDatePNC42 Date= DATEADD(dd,45,@Delivery_date)
/* Check Date Validation if error throw error message if not than check existence of infant registration and pnc_type */
if(@PNC_Period=1)
begin
  if ((@PNC_Date < @minDatePNC1) or  (@PNC_Date > @maxDatePNC1))
   begin
      set @msg='1st Day PNC date should be between' + convert(varchar(10),@minDatePNC1,103)  + ' and ' + convert(varchar(10),@maxDatePNC1,103)                    
	  return;
   end
end
if(@PNC_Period=2)
begin
	  if ((@PNC_Date < @minDatePNC3) or  (@PNC_Date > @maxDatePNC3))
       begin
          set @msg='3rd Day PNC date should be between' + convert(varchar(10),@minDatePNC3,103)  + ' and ' + convert(varchar(10),@maxDatePNC3,103)  
		  return;
       end
end
if(@PNC_Period=3)
begin
	  if (@PNC_Date < @minDatePNC7 or  @PNC_Date > @maxDatePNC7)
       begin
          set @msg='7th Day PNC date should be between' + convert(varchar(10),@minDatePNC7,103)  + ' and ' + convert(varchar(10),@maxDatePNC7,103)
            return ;
        end
end
if(@PNC_Period=4)
begin
	  if (@PNC_Date < @minDatePNC14 or  @PNC_Date > @maxDatePNC14)
       begin
          set @msg='14th Day PNC date should be between' + convert(varchar(10),@minDatePNC14,103)  + ' and ' + convert(varchar(10),@maxDatePNC14,103)   
		   return ;
        end
end
if(@PNC_Period=5)
begin
	  if (@PNC_Date < @minDatePNC21 or  @PNC_Date > @maxDatePNC21)
       begin
          set @msg='21st Day PNC date should be between' + convert(varchar(10),@minDatePNC21,103)  + ' and ' + convert(varchar(10),@maxDatePNC21,103)   
		  
            return ;
        end
end
if(@PNC_Period=6)
begin
	  if (@PNC_Date < @minDatePNC28 or  @PNC_Date > @maxDatePNC28)
       begin
          set @msg='28th Day PNC date should be between' + convert(varchar(10),@minDatePNC28,103)  + ' and ' + convert(varchar(10),@maxDatePNC28,103) 
		  
            return ;
        end
end
if(@PNC_Period=7)
begin
	  if (@PNC_Date < @minDatePNC42 or  @PNC_Date > @maxDatePNC42)
       begin
          set @msg='42th Day PNC date should be between' + convert(varchar(10),@minDatePNC42,103)  + ' and ' + convert(varchar(10),@maxDatePNC42,103)  
		  
            return ;
        end
end


    
if exists(select Registration_no from t_mother_delivery where Registration_no=@Registration_no and Case_no=@Case_no)  
begin  
 if(@ActionType='I')
 BEGIN
   if not exists(select Registration_no from t_mother_pnc where Registration_no=@Registration_no and Case_no=@Case_no and  PNC_Type=@PNC_Period)    
   begin    
    set @PNC_No = (Select isnull(max(PNC_No),0)+1 from t_mother_pnc where Registration_no=@Registration_no and Case_no=@Case_no)    
    insert into t_mother_pnc    
    (     
    [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]    
   ,[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[PNC_No],[PNC_Type],[PNC_Date],[No_of_IFA_Tabs_given_to_mother]    
   ,[DangerSign_Mother],[DangerSign_Mother_Other],[DangerSign_Mother_length],[ReferralFacility_Mother],[ReferralFacilityID_Mother],[ReferralLoationOther_Mother]    
   ,[PPC],[OtherPPC_Method],[Mother_Death],[Place_of_death],[Mother_Death_Date],[Mother_Death_Reason],[Mother_Death_Reason_Other],[Mother_Death_Reason_length]    
   ,[Remarks],[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],Mobile_ID,SourceID,Is_ILI_Symptom,Is_contact_Covid,Covid_test_done,Covid_test_result)    
  values(@State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,@HealthFacility_Code,@HealthSubFacility_Code    
    ,@Village_Code,@Financial_Yr,@Financial_Year,@Registration_no,@ID_No,@PNC_No,@PNC_Period,@PNC_Date,@No_of_IFA_Tabs_given_to_mother,    
    @DangerSign_Mother,@DangerSign_Mother_Other,@DangerSign_Mother_length,@ReferralFacility_Mother,@ReferralFacilityID_Mother,@ReferralLoationOther_Mother,    
    @PPC,@OtherPPC_Method,@Mother_Death,@Mother_Death_Place,@Mother_Death_Date,@Mother_Death_Reason,@Mother_Death_Reason_Other,@Mother_Death_Reason_length,     
    @Remarks,@ANM_ID,@ASHA_ID,@Case_no,@IP_address,@Created_By,GETDATE(),@Mobile_ID,@Source_ID,@Is_ILI_Symptom ,@Is_contact_Covid,@Covid_test_done,@Covid_test_result)    
    ---------for death status---------         
     
        
    update t_page_tracking set Registration_no=@Registration_no,Page_Code='MP',Execution_Date=GETDATE() where Registration_no=@Registration_no and Case_no=@Case_no    
    set @msg='Record Save Successfully !!!' 
        
   end
   -------------------------------- 
 END
 ELSE IF(@ActionType='U')    
  BEGIN    
    update t_mother_pnc set    
    PNC_No=@PNC_No,    
    PNC_Type=@PNC_Period,    
    PNC_Date=@PNC_Date,    
    No_of_IFA_Tabs_given_to_mother=@No_of_IFA_Tabs_given_to_mother,    
    DangerSign_Mother=@DangerSign_Mother,    
    DangerSign_Mother_Other=@DangerSign_Mother_Other ,    
    DangerSign_Mother_length=@DangerSign_Mother_length,    
    ReferralFacility_Mother=@ReferralFacility_Mother,    
    ReferralFacilityID_Mother=@ReferralFacilityID_Mother,    
    ReferralLoationOther_Mother =@ReferralLoationOther_Mother,    
    PPC=@PPC,    
    OtherPPC_Method=@OtherPPC_Method,    
    Mother_Death=@Mother_Death,    
    Place_of_death=@Mother_Death_Place,    
    Mother_Death_Date=@Mother_Death_Date,    
    Mother_Death_Reason=@Mother_Death_Reason,    
    Mother_Death_Reason_Other =@Mother_Death_Reason_Other,    
    Mother_Death_Reason_length=@Mother_Death_Reason_length,    
    Remarks=@Remarks,    
    ANM_ID=@ANM_ID,    
    ASHA_ID=@ASHA_ID,    
    IP_address=@IP_address,    
    Mobile_ID=@Mobile_ID,    
    Updated_On=GETDATE(),    
    Updated_By=@Created_By,
    Is_ILI_Symptom=@Is_ILI_Symptom,
	Is_contact_Covid=@Is_contact_Covid,
	Covid_test_done=@Covid_test_done,
	Covid_test_result = @Covid_test_result     
    where Registration_no=@Registration_no and Case_no=@Case_no   and PNC_No=@PNC_No   
    set @msg='Record Save Successfully !!!'       
 END  
 ---------------------- insert for t_Danger_Sign_Mother    
 if exists(select * from t_Danger_Sign_Mother where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No)    
 begin    
	  delete from t_Danger_Sign_Mother where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No    
	  insert into t_Danger_Sign_Mother(Registration_no,ID,Case_no,PNC_No)    
	  select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @Registration_no as Registration_no) a    
	  inner join     
	  (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@DangerSign_Mother)) b on a.Registration_no=b.Registration_no    
 end    
 else    
 begin    
	  insert into t_Danger_Sign_Mother(Registration_no,ID,Case_no,PNC_No)    
	  select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @Registration_no as Registration_no) a    
	  inner join     
	  (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@DangerSign_Mother)) b on a.Registration_no=b.Registration_no    
 end    
       
    ---------------------- insert for t_Mother_Death_Reason    
  if(@Mother_Death = 1)    
  begin    
    if exists(select * from t_Mother_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No)    
    begin    
		  delete from t_Mother_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No    
		  insert into t_Mother_Death_Reason(Registration_no,ID,Case_no,PNC_No)    
		  select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @Registration_no as Registration_no) a    
		  inner join     
		  (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Mother_Death_Reason)) b on a.Registration_no=b.Registration_no    
    end    
    else    
    begin    
		  insert into t_Mother_Death_Reason(Registration_no,ID,Case_no,PNC_No)    
		  select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @Registration_no as Registration_no) a    
		  inner join     
		  (select @Registration_no as Registration_no, Data as Data from dbo.Split_MultipleValue(@Mother_Death_Reason)) b on a.Registration_no=b.Registration_no    
    end    
    
    IF exists (select * from t_death_records where Registration_no=@Registration_no and Case_no=@Case_no )    
    BEGIN    
		delete from t_death_records where Registration_no=@Registration_no and Case_no=@Case_no
		insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no)    
		select @Registration_no,GETDATE(),1,@Case_no  
    END 
    ELSE
    BEGIN
		insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no)    
		select @Registration_no,GETDATE(),1,@Case_no
    END 
    
  end 
  ELSE
    BEGIN 
		IF exists(select * from t_Mother_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No)    
		BEGIN    
			delete from t_Mother_Death_Reason where Registration_no=@Registration_no and Case_no=@Case_no and PNC_No=@PNC_No       
		END
		IF exists (select * from t_death_records where Registration_no=@Registration_no and Case_no=@Case_no )    
		BEGIN    
			delete from t_death_records where Registration_no=@Registration_no and Case_no=@Case_no  
		END 
	END       
     
   if (@PNC_Period <> 0 and @Mother_Death <> 1)  --Modified on 2017-10-08 by sneha(ref pankaj)  
   begin  
		update t_mother_registration SET Entry_Type = 4,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no = @Registration_no  and Case_no=@Case_no and Entry_Type<>4  
   end    
  else     
  begin        
	  update t_mother_registration SET Entry_Type = @Mother_Death,Updated_By=@Created_By,Updated_On=GETDATE() where Registration_no = @Registration_no  and Case_no=@Case_no        
  end   
end  
  
declare @Entry_Type int, @LENGTH int = 0, @value char(1)  
select @LENGTH=Maternal_Death from t_mother_anc where Registration_no=@Registration_no and Case_no=@Case_no and Maternal_Death=1  
select @value='G' from t_mother_delivery where Registration_no=@Registration_no and Case_no=@Case_no and Delivery_Complication like '%G%'  
select @LENGTH=Mother_Death from t_mother_pnc where Registration_no=@Registration_no and Case_no=@Case_no and Mother_Death=1  
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


