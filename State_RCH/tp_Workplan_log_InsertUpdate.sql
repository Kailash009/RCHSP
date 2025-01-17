USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Workplan_log_InsertUpdate]    Script Date: 09/26/2024 12:30:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Jyoti    
-- Create date: 30/04/2019    
-- Description: Workplan log Report    
-- =============================================    
ALTER PROCEDURE [dbo].[tp_Workplan_log_InsertUpdate]     
 -- Add the parameters for the stored procedure here    
 --@Id int,     
 @State_ID int,     
 @District_code int,     
 @HealthBlock_code int, 
 @HealthFacility_Type int=0,    
 @HealthFacility_Code int,     
 @HealthSubFacility_Code int,     
 @Village_code int,     
 @LastUserID int,     
 @TypeOfService int,     
 @ANM_Asha_ID int=0,   
 @ANM_Asha_Type int=0,   
 @WorkPlan_Type int,  
 --@WorkPlan_LastHitdate datetime,     
 @WorkPlan_month int,     
 @WorkPlan_year int,     
 --@WorkPlan_hitCount int,     
 --@Create_on datetime,     
 @Created_By int=null,     
 @IP_Address nvarchar(20)=null,     
 @Modified_on datetime =null         
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
 begin    
  if exists(select * from t_Workplan_log where State_ID=@State_ID and District_Code=convert(int,@District_Code)and HealthBlock_Code=convert(int,@HealthBlock_Code)and HealthFacility_Code=convert(int,@HealthFacility_Code) and HealthFacility_Type=CONVERT(int,@HealthFacility_Type)
  and HealthSubFacility_Code=convert(int,@HealthSubFacility_Code)  and Village_Code= convert(int,@Village_Code) and TypeOfService=@TypeOfService and WorkPlan_Type=@WorkPlan_Type  and WorkPlan_month=@WorkPlan_month and WorkPlan_year=@WorkPlan_year )    
   begin    
    update t_Workplan_log set WorkPlan_hitCount=WorkPlan_hitCount+1,LastUserID=@LastUserID,WorkPlan_LastHitdate=GETDATE(),Modified_on=GETDATE(),IP_Address=@IP_Address where     
    State_ID=@State_ID and District_Code=convert(int,@District_Code)and HealthBlock_Code=convert(int,@HealthBlock_Code) and HealthFacility_Code=convert(int,@HealthFacility_Code) and HealthFacility_Type=CONVERT(int,@HealthFacility_Type) and HealthSubFacility_Code=convert(int,@HealthSubFacility_Code)      
    and Village_Code= convert(int,@Village_Code) and TypeOfService=@TypeOfService and WorkPlan_month=@WorkPlan_month and WorkPlan_year=@WorkPlan_year    
   end    
  else    
   Begin    
    INSERT INTO t_Workplan_log    
    ([State_ID],[District_code],[HealthBlock_code],[HealthFacility_Code],[HealthFacility_Type],[HealthSubFacility_Code],[Village_code],[LastUserID],[TypeOfService]    
    ,[ANM_Asha_ID],[ANM_Asha_Type],[WorkPlan_Type],[WorkPlan_LastHitdate],[WorkPlan_month],[WorkPlan_year],[WorkPlan_hitCount],[Create_on],[Created_By],[IP_Address])    
    VALUES    
    (@State_ID,@District_code,@HealthBlock_code,@HealthFacility_Code,@HealthFacility_Type,@HealthSubFacility_Code,@Village_code,@LastUserID,@TypeOfService,     
     @ANM_Asha_ID,@ANM_Asha_Type,@WorkPlan_Type,GETDATE(),@WorkPlan_month,@WorkPlan_year,1,GETDATE(),@Created_By,@IP_Address )    
   end    
 end    
END 

