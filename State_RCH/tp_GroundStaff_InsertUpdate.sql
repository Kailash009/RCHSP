USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_GroundStaff_InsertUpdate]    Script Date: 09/26/2024 15:55:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
  tp_GroundStaff_InsertUpdate 27,26,'R',84,'0252',1,274,1622,32155,'2012-13',2012,93353,2012-11-04,'ghjg','9874568755','F',null,null,1,2,1,1,'ttt',1,1,1915,2
*/

ALTER proc [dbo].[tp_GroundStaff_InsertUpdate]
(
@State_Code int,
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
@ID int out,
@Reg_Date date,
@Name nvarchar (150) ,
@Contact_No varchar(50),
@Sex char(1),
@Aadhar_No numeric(12,0),
@EID_No numeric(14),
@EID_Time datetime=null,
@Is_Active bit,
@Type_ID int,
@SMS_Status smallint,
@IsValidated bit,
@SMS_Reply nvarchar(max),
@IsUnicodeMob bit,
@IsActionOnSMS bit,
@Created_By int,
@flag int  -- [Insert - 1 and Update -2]
)
as
BEGIN
SET NOCOUNT ON

if(@flag = 1)  -- Insert
begin
        declare @R_Id int
        declare @RegID int 
		set @R_Id = (select MAX(ID) from t_Ground_Staff)
		set @RegID = @R_Id+1
	
		
if not exists(select ID from t_Ground_Staff where State_Code=@State_Code
			 and ID=@RegID)
		begin
						
		insert into t_Ground_Staff 
		(
		[ID],[State_Code],[District_Code]
      ,[Rural_Urban]
      ,[HealthBlock_Code]
      ,[Taluka_Code]
      ,[HealthFacility_Type]
      ,[HealthFacilty_Code]
      ,[HealthSubFacility_Code]
      ,[Village_Code]
      ,[Financial_Yr]
      ,[Financial_Year]
      ,[Reg_Date]
      ,[Name]
      ,[Contact_No]
      ,[Sex]
      ,[Aadhar_No]
      ,[EID_No]
      ,[EID_Time]
      ,[Is_Active]
      ,[Type_ID]
      ,[SMS_Status]
      ,[IsValidated]
      ,[SMS_Reply]
      ,[IsUnicodeMob]
      ,[IsActionOnSMS]
      ,[Created_By]
      ,[Created_On]
      ,CPSMS_Flag
        ) values
        
		(
	   @RegID,
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
      ,@Financial_Year
      ,@Reg_Date
      ,@Name
      ,@Contact_No
      ,@Sex
      ,@Aadhar_No
      ,@EID_No
      ,@EID_Time
      ,@Is_Active
      ,@Type_ID
      ,@SMS_Status
      ,@IsValidated
      ,@SMS_Reply
      ,@IsUnicodeMob
      ,@IsActionOnSMS
      ,@Created_By
      ,getdate()
      ,0
		)
		
         end
         set @ID = @RegID
         return @ID
 end        
if(@flag = 2) -- Update

begin		
		  update t_Ground_Staff set 
				Financial_Yr=@Financial_Yr,
				Financial_Year=@Financial_Year,
				[Name] = @Name 
				,Contact_No = @Contact_No
				,Type_ID=@Type_ID
				,Reg_Date = @Reg_Date
				,Sex = @Sex 
				,Aadhar_No = @Aadhar_No 
				,EID_No = @EID_No
				,EID_Time = @EID_Time
				,Is_Active =@Is_Active
				,SMS_Reply= @SMS_Reply 
				,IsUnicodeMob =@IsUnicodeMob 
				,IsActionOnSMS = @IsActionOnSMS
				,CPSMS_Flag=3
				,Updated_By=@Created_By--added by sneha on 16062017
				,Updated_On=GETDATE()--added by sneha on 16062017
				where  ID=@ID
				
		RETURN		
end
END
IF (@@ERROR <> 0)
BEGIN
     RAISERROR ('TRANSACTION FAILED',16,-1)
     ROLLBACK TRANSACTION
END

		









