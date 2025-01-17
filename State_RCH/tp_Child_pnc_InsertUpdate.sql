USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Child_pnc_InsertUpdate]    Script Date: 09/26/2024 12:21:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
    
-- =============================================    
   
-- =============================================    
   
ALTER proc [dbo].[tp_Child_pnc_InsertUpdate]    
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
@InfantRegistration bigint,    
@PNC_No int,    
@PNC_Period int,    
@PNC_Date date,    
@Infant_Weight float,    
@DangerSign_Infant nvarchar(50),    
@DangerSign_Infant_Other nvarchar(50)=null,    
@DangerSign_Infant_length int,    
@ReferralFacility_Infant int,    
@ReferralFacilityID_Infant int,    
@ReferralLoationOther_Infant nvarchar(50)=null,    
@Infant_Death bit,    
@Infant_Death_Place As tinyint,    
@Infant_Death_Date date =null,    
@Infant_Death_Reason nvarchar(50),    
@Infant_Death_Reason_Other nvarchar(50)=null,    
@Infant_Death_Reason_length int,    
@Remarks nvarchar(300),    
@ANM_ID int,    
@ASHA_ID int,    
@Case_no int,    
@IP_address varchar(25),    
@Created_By int,    
@Delivery_date date,    
@Mobile_ID bigint=0,    
@Source_ID tinyint=0,    
@msg varchar(200) out,
@Interstate_Flag bit=0,
@TID bigint=0,
@ActionType varchar='I',
@EditDeathDate date=null 
)    
AS    
BEGIN    
 /* Calculate Min max Date as per PNC Type for validation*/  
  
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
            Declare @ChildDeathDate Date=null
/* Check Date Validation if error throw error message if not than check existence of infant registration and pnc_type */  
if(@PNC_Period=1)  
begin  
  if ((@PNC_Date < @minDatePNC1) or  (@PNC_Date > @maxDatePNC1))  
               begin  
                  set @msg='1st day PNC date should be between' + convert(varchar(10),@minDatePNC1,103)  + ' and ' + convert(varchar(10),@maxDatePNC1,103)                      
      return;  
      end  
end  
if(@PNC_Period=2)  
begin  
   if ((@PNC_Date < @minDatePNC3) or  (@PNC_Date > @maxDatePNC3))  
               begin  
                  set @msg='3rd day PNC date should be between' + convert(varchar(10),@minDatePNC3,103)  + ' and ' + convert(varchar(10),@maxDatePNC3,103)    
      return;  
                     
              end  
end  
if(@PNC_Period=3)  
begin  
   if (@PNC_Date < @minDatePNC7 or  @PNC_Date > @maxDatePNC7)  
               begin  
                  set @msg='7th day PNC date should be between' + convert(varchar(10),@minDatePNC7,103)  + ' and ' + convert(varchar(10),@maxDatePNC7,103)  
                    return ;  
                end  
end  
if(@PNC_Period=4)  
begin  
   if (@PNC_Date < @minDatePNC14 or  @PNC_Date > @maxDatePNC14)  
               begin  
                  set @msg='14th day PNC date should be between' + convert(varchar(10),@minDatePNC14,103)  + ' and ' + convert(varchar(10),@maxDatePNC14,103)     
       return ;  
                end  
end  
if(@PNC_Period=5)  
begin  
   if (@PNC_Date < @minDatePNC21 or  @PNC_Date > @maxDatePNC21)  
               begin  
                  set @msg='21st day PNC date should be between' + convert(varchar(10),@minDatePNC21,103)  + ' and ' + convert(varchar(10),@maxDatePNC21,103)     
                          return ;  
                end  
end  
if(@PNC_Period=6)  
begin  
   if (@PNC_Date < @minDatePNC28 or  @PNC_Date > @maxDatePNC28)  
               begin  
                  set @msg='28th day PNC date should be between' + convert(varchar(10),@minDatePNC28,103)  + ' and ' + convert(varchar(10),@maxDatePNC28,103)   
                          return ;  
                end  
end  
if(@PNC_Period=7)  
begin  
   if (@PNC_Date < @minDatePNC42 or  @PNC_Date > @maxDatePNC42)  
               begin  
                  set @msg='42th day PNC date should be between' + convert(varchar(10),@minDatePNC42,103)  + ' and ' + convert(varchar(10),@maxDatePNC42,103)    
                          return ;  
                end  
end 
--*********** check child death and PNC/Immunization date function******************** 
DECLARE @FuncReturnMsg varchar(500)
 select @FuncReturnMsg=Msg,@ChildDeathDate=DeathDate from Check_child_Services_death (@InfantRegistration,@PNC_Date,@Infant_Death_Date,@EditDeathDate,@PNC_No,0)  
IF(@FuncReturnMsg <> '')
BEGIN
	SET @msg=@FuncReturnMsg
	return;
END
--******************************
if(@ActionType='I')
BEGIN
if not exists(select InfantRegistration from t_child_pnc(nolock) where InfantRegistration=@InfantRegistration and PNC_Type=@PNC_Period 
			  UNION select InfantRegistration from t_Interstate_child_pnc(nolock) where InfantRegistration=@InfantRegistration and PNC_Type=@PNC_Period )    
    begin    
     --set @PNC_No = (Select isnull(max(PNC_No),0)+1 from t_child_pnc where InfantRegistration=@InfantRegistration )  
     set @PNC_No = (select MAX(Max_PNC_No) from(Select isnull(max(PNC_No),0)+1 as Max_PNC_No from t_child_pnc where InfantRegistration=@InfantRegistration 
					UNION Select isnull(max(PNC_No),0)+1 as Max_PNC_No from t_Interstate_child_pnc where InfantRegistration=@InfantRegistration)as a)   
    
  
     insert into t_child_pnc    
     (     
        [State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]    
       ,[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],ID_No,[InfantRegistration],[PNC_No],[PNC_Type],[PNC_Date],[Infant_Weight]    
       ,[DangerSign_Infant],[DangerSign_Infant_Other],[DangerSign_Infant_length],[ReferralFacility_Infant],[ReferralFacilityID_Infant],[ReferralLoationOther_Infant]    
       ,[Infant_Death],[Place_of_death],[Infant_Death_Date],[Infant_Death_Reason],[Infant_Death_Reason_Other],[Infant_Death_Reason_length],Remarks    
       ,[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],Mobile_ID,SourceID,Interstate_Flag,TID)    
      values(@State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,@HealthFacility_Code,@HealthSubFacility_Code    
      ,@Village_Code,@Financial_Yr,@Financial_Year,@Registration_no,@ID_No,@InfantRegistration,@PNC_No,@PNC_Period,@PNC_Date,@Infant_Weight,    
       @DangerSign_Infant,@DangerSign_Infant_Other,@DangerSign_Infant_length,@ReferralFacility_Infant,@ReferralFacilityID_Infant,@ReferralLoationOther_Infant,    
       @Infant_Death,@Infant_Death_Place,@Infant_Death_Date,@Infant_Death_Reason,@Infant_Death_Reason_Other,@Infant_Death_Reason_length,@Remarks,    
       @ANM_ID,@ASHA_ID,@Case_no,@IP_address,@Created_By,GETDATE(),@Mobile_ID,@Source_ID,@Interstate_Flag,@TID)    
           
       if (@PNC_Period = 0 and @Infant_Death = 1)      
      begin      
      update t_children_registration SET Entry_Type = @Infant_Death, Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no = @InfantRegistration      
          
       end      
       update t_Page_tracking Set Page_Code='IP',Execution_Date=getdate()  where Registration_no=@Registration_no and case_no=@case_no    
       set @msg='Record saved succesfully!!!'    
    
    end   
    ELSE
    set @msg='This PNC has been already given.Please select another PNC!!!'  
END

ELSE IF(@ActionType='U')
BEGIN
     update t_child_pnc set    
     PNC_Type=@PNC_Period,    
     PNC_Date=@PNC_Date,    
     Infant_Weight=@Infant_Weight,    
                    DangerSign_Infant=@DangerSign_Infant,    
                    DangerSign_Infant_Other=@DangerSign_Infant_Other,    
                    DangerSign_Infant_length=@DangerSign_Infant_length,    
                    ReferralFacility_Infant=@ReferralFacility_Infant,    
                    ReferralFacilityID_Infant=@ReferralFacilityID_Infant,    
                    ReferralLoationOther_Infant=@ReferralLoationOther_Infant,    
       Infant_Death=@Infant_Death,    
                    Place_of_death=@Infant_Death_Place,    
                    Infant_Death_Date=@Infant_Death_Date,    
                    Infant_Death_Reason=@Infant_Death_Reason,    
                    Infant_Death_Reason_Other=@Infant_Death_Reason_Other,    
                    Infant_Death_Reason_length=@Infant_Death_Reason_length,    
                    Remarks=@Remarks,    
                    ANM_ID=@ANM_ID,    
     ASHA_ID=@ASHA_ID,    
     IP_address=@IP_address,    
     Mobile_ID=@Mobile_ID,    
     --SourceID=@Source_ID,    
     Updated_On=getdate(),    
     UpDated_By=@Created_By    
     where InfantRegistration=@InfantRegistration and PNC_No=@PNC_No --and PNC_Type=@PNC_Period     
     
     IF (@PNC_Period <> 0 and @Infant_Death <> 1)      
      BEGIN   
      IF(@ChildDeathDate is not null)
		BEGIN 
			update t_children_registration SET Entry_Type = 1, Updated_On=GETDATE() where Registration_no = @InfantRegistration    
		END
		ELSE
			update t_children_registration SET Entry_Type = 4,Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no = @InfantRegistration 
      END  
      ELSE    
      BEGIN    
       update t_children_registration SET Entry_Type = @infant_Death, Updated_On=GETDATE(),Updated_By=@Created_By where Registration_no = @InfantRegistration      
             
      END      
       set @msg='Record saved succesfully!!!'    
    
END  
IF(@infant_Death=1) 
BEGIN
   UPDATE t_Children_Master set Child_Death=1,Child_Death_Date=@Infant_Death_Date   where Registration_no=@InfantRegistration    
   IF EXISTS(select * from t_Infant_Death_Reason where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No)    
    BEGIN   
		 delete from t_Infant_Death_Reason where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No    
		 insert into t_Infant_Death_Reason(Registration_no,ID,Case_no,PNC_No)    
		 select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @InfantRegistration as Registration_no) a    
		 inner join     
		 (select @InfantRegistration as Registration_no, Data as Data from dbo.Split_MultipleValue(@Infant_Death_Reason)) b on a.Registration_no=b.Registration_no    
    END   
    ELSE    
    BEGIN  
		 insert into t_Infant_Death_Reason(Registration_no,ID,Case_no,PNC_No)    
		 select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @InfantRegistration as Registration_no) a    
		 inner join     
		 (select @InfantRegistration as Registration_no, Data as Data from dbo.Split_MultipleValue(@Infant_Death_Reason)) b on a.Registration_no=b.Registration_no    
    END  
    
    IF exists (select * from t_death_records where Registration_no=@InfantRegistration and Case_no=@Case_no )    
    BEGIN    
		delete from t_death_records where Registration_no=@InfantRegistration and Case_no=@Case_no
		insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no)    
		select @InfantRegistration,GETDATE(),2,@Case_no  
    END 
    ELSE
    BEGIN
		insert into t_death_records(Registration_no,CreatedOn,IsMotherchild,Case_no)    
		select @InfantRegistration,GETDATE(),2,@Case_no
    END 
END
ELSE  
BEGIN
	IF(@ChildDeathDate is not null)
	BEGIN
		  UPDATE t_Children_Master set Child_Death=1 where Registration_no=@InfantRegistration
	END
	ELSE
	BEGIN
		update t_Children_Master set Child_Death=0,Child_Death_Date=null,Child_PNC_No=@PNC_No,Child_LastPNC_Date=@PNC_Date   where Registration_no=@InfantRegistration
		IF exists (select * from t_death_records where Registration_no=@InfantRegistration and Case_no=@Case_no)    
		BEGIN  
			delete from t_death_records where Registration_no=@InfantRegistration and Case_no=@Case_no  
		END 
	END
	IF exists(select * from t_Infant_Death_Reason where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No)    
	BEGIN    
		delete from t_Infant_Death_Reason where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No       
	END
END
   
if exists(select * from t_Danger_Sign_Infant where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No)    
    begin    
		 delete from t_Danger_Sign_Infant where Registration_no=@InfantRegistration and Case_no=@Case_no and PNC_No=@PNC_No    
		 insert into t_Danger_Sign_Infant(Registration_no,ID,Case_no,PNC_No)    
		 select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @InfantRegistration as Registration_no) a    
		 inner join     
		 (select @InfantRegistration as Registration_no, Data as Data from dbo.Split_MultipleValue(@DangerSign_Infant)) b on a.Registration_no=b.Registration_no    
    end    
  else    
    begin    
     insert into t_Danger_Sign_Infant(Registration_no,ID,Case_no,PNC_No)    
     select a.Registration_no,b.Data,@Case_no,@PNC_No from (select @InfantRegistration as Registration_no) a    
     inner join     
     (select @InfantRegistration as Registration_no, Data as Data from dbo.Split_MultipleValue(@DangerSign_Infant)) b on a.Registration_no=b.Registration_no    
    end    
END    
  

    
