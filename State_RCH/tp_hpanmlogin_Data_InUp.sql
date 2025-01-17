USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_hpanmlogin_Data_InUp]    Script Date: 09/26/2024 14:48:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[tp_hpanmlogin_Data_InUp]            
    @healthproviderid int ,   
    @healthprovidertype int,  
    @mobile_no varchar(10),  
    @state_code int,  
    @district_code int,  
    @taluka_code varchar(50),  
    @healthblock_code int,  
    @healthfacility_code int,  
    @healthsubfacility_code int,  
    @village_code int,  
    @imeiCode varchar(50),  
    @macaddress nvarchar(255) ,  
    @ip_address varchar(20) ,  
    @apkversion varchar(10) ,  
    @logindate datetime,  
    @logoutdate datetime ,  
    @apkversionupdatedate datetime,  
 @msg nvarchar(200) out  
AS            
BEGIN   
if not exists(SELECT 1 FROM t_ANM_ASHA_Mapping_Village WITH(NOLOCK) where ID=@healthproviderid and  District_Code=@District_Code  and HealthBlock_Code=@HealthBlock_Code and HealthFacility_Code=@HealthFacility_Code and HealthSubFacility_Code=@HealthSubFacility_Code and Village_Code=@Village_Code and Is_Mapped in(0,1) )      
begin     
set @msg='400'   
  RETURN;          
end   
 ELSE          
        BEGIN   
        if not exists(select 1 from  t_anmlogindetails where  healthproviderid=@healthproviderid and healthsubfacilitycode=@healthfacility_code and villagecode=@village_code and apkversion=@apkversion and logindate=@logindate)  
        begin  
        INSERT INTO [dbo].t_anmlogindetails  
           ([healthproviderid]  
           ,[healthprovidertype]  
           ,[healthprovidermobileno]  
           ,[statecode]  
           ,[districtcode]  
           ,[talukacode]  
           ,[blockcode]  
           ,[healthfacilitycode]  
           ,[healthsubfacilitycode]  
           ,[villagecode]  
           ,[imeiCode]  
           ,[macaddress]  
           ,[ipaddress]  
           ,[apkversion]  
           ,[logindate]  
           ,[logoutdate]  
           ,[apkversionupdatedate]  
           ,[isactive]  
           ,[created_on])  
             
             
     VALUES  
           (  
           @healthproviderid  
           ,@healthprovidertype  
           ,@mobile_no  
           ,@state_code  
           ,@district_code  
           ,@taluka_code  
           ,@healthblock_code  
           ,@healthfacility_code  
           ,@healthsubfacility_code  
           ,@village_code  
           ,@imeiCode  
           ,@macaddress  
           ,@ip_address  
           ,@apkversion  
           , @logindate   
           ,@logoutdate  
           ,@apkversionupdatedate  
           ,1  
           ,getdate())  
           set @msg='101'   
            RETURN;    
         RETURN;               
        end   
        else  
          begin  
           set @msg='506'   
            RETURN;    
        end       
  end   
  end     
 IF (@@ERROR <> 0)            
BEGIN     
  SET @msg='0' --Error        
         RETURN;       
     RAISERROR ('TRANSACTION FAILED',16,-1)            
     ROLLBACK TRANSACTION            
END   
  
  
  

  