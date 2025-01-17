USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_ANM_ASHA_Mapping_Village_InsertUpdate]    Script Date: 09/26/2024 12:19:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER proc [dbo].[tp_ANM_ASHA_Mapping_Village_InsertUpdate]
(
@State_Code int=0,
@District_Code int=0,
@Rural_Urban char(1)='R',
@Taluka_Code varchar(6)='',
@HealthBlock_Code int=0,
@HealthFacility_Type int=1,
@HealthFacility_Code int=0,
@HealthSubCentre_Code int=0,
@Village_Code int=0 out, 
@ID int,
@TYPE_ID int=0,
@Is_Mapped tinyint=0,
@USERID int,
@IPAddress varchar(30),
@msg as varchar(200) out

	
)
as
begin
if not exists (select * from t_ANM_ASHA_Mapping_Village where HealthBlock_Code=@HealthBlock_code and HealthFacility_Code=@HealthFacility_code 
 and HealthSubFacility_Code=@HealthSubCentre_code and Village_Code=@Village_Code and ID=@ID and @ID<>0)    
 begin 
    insert into t_ANM_ASHA_Mapping_Village(State_Code,District_Code,Rural_Urban,Taluka_Code,HealthBlock_Code,HealthFacility_Type,HealthFacility_Code,HealthSubFacility_Code,Village_Code,ID,[Type_ID],Created_By,Created_On,Is_Mapped)    
    values(@State_Code,@District_Code,@Rural_Urban,@Taluka_Code,@HealthBlock_code,@HealthFacility_Type,@HealthFacility_code,@HealthSubCentre_code,@Village_Code,@ID,@TYPE_ID,@USERID,GETDATE(),@Is_Mapped)
    
    update t_Ground_Staff_Mapping set Is_Mapped=@Is_Mapped where HealthBlock_Code=@HealthBlock_code and HealthFacilty_Code=@HealthFacility_code and HealthSubFacility_Code=@HealthSubCentre_code
    and Village_Code=@Village_Code and ID=@ID and [Type_ID]=@Type_ID    
	
	set @msg = 'Record Save Successfully !!!'   
 End    
 else    
 begin   
	update t_ANM_ASHA_Mapping_Village set Is_Mapped=@Is_Mapped,Updated_by=@USERID,Updated_on=GETDATE()  where HealthBlock_Code=@HealthBlock_code and HealthFacility_Code=@HealthFacility_code and HealthSubFacility_Code=@HealthSubCentre_code and Village_Code=@Village_Code and ID=@ID and @ID<>0   
    update t_Ground_Staff_Mapping set Is_Mapped=@Is_Mapped where HealthBlock_Code=@HealthBlock_code and HealthFacilty_Code=@HealthFacility_code and HealthSubFacility_Code=@HealthSubCentre_code and Village_Code=@Village_Code and ID=@ID  and @ID<>0   
	
	set @msg = 'Record Save Successfully !!!'   
end  


if not exists (select * from t_ANM_ASHA_Mapping_Village where HealthBlock_Code=@HealthBlock_code and HealthFacility_Code=@HealthFacility_code 
 and HealthSubFacility_Code=@HealthSubCentre_code and Village_Code=@Village_Code and ID=@ID and [Type_ID]=@Type_ID and @ID=0)    
 begin 
    insert into t_ANM_ASHA_Mapping_Village(State_Code,District_Code,Rural_Urban,Taluka_Code,HealthBlock_Code,HealthFacility_Type,HealthFacility_Code,HealthSubFacility_Code,Village_Code,ID,[Type_ID],Created_By,Created_On,Is_Mapped)    
    values(@State_Code,@District_Code,@Rural_Urban,@Taluka_Code,@HealthBlock_code,@HealthFacility_Type,@HealthFacility_code,@HealthSubCentre_code,@Village_Code,@ID,@TYPE_ID,@USERID,GETDATE(),@Is_Mapped)
    
  
	
	set @msg = 'Record Save Successfully !!!'   
 End    
 else    
 begin   
	update t_ANM_ASHA_Mapping_Village set Is_Mapped=@Is_Mapped,Updated_by=@USERID,Updated_on=GETDATE() 
	where HealthBlock_Code=@HealthBlock_code 
	and HealthFacility_Code=@HealthFacility_code 
	and HealthSubFacility_Code=@HealthSubCentre_code 
	and Village_Code=@Village_Code 
	and ID=@ID   
	and [Type_ID]=@Type_ID
	
	set @msg = 'Record Save Successfully !!!'   
end  
	

	
	
	
	
end






