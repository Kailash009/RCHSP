USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[tp_Get_RCH_Beneficiary_CBR]    Script Date: 09/26/2024 14:08:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec [CBR_GetRCH_Data] '8171593373','','8171817100'    
    --CBR_GetRCH_Data_CBR '','','9476018891',0
ALTER PROCEDURE [dbo].[tp_Get_RCH_Beneficiary_CBR]    
@ReferenceId BIGINT = '',    
@HealthIdNumber VARCHAR(20)='',    
@MobileNo varchar(10)='',    
@RchId bigint =0 
AS    
BEGIN    
  IF(@ReferenceId <>'')    
      BEGIN
         SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,     
         HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,    
         Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,       
         ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)     
         INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID WHERE  reference_id=@ReferenceId   
       END    
  ELSE IF(@HealthIdNumber <>'')    
      BEGIN 
	    PRINT 'HEALTHID'
         SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,     
         HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,    
         Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,       
         ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)     
         INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID WHERE  HealthIdNumber=@HealthIdNumber   
      END 
  ELSE IF(@RchId <>'' AND @RchId <>0)    
     BEGIN 
         SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,     
         HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,    
         Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,       
         ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)     
         INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID    
         WHERE  Registration_no=@RchId 
     END  
  ELSE    
     BEGIN  
       SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,     
       HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,    
       Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,       
       ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)     
       INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID    
       WHERE  Mobile_no=@MobileNo  and Mobile_no<>''
    END     
END    
    
    
