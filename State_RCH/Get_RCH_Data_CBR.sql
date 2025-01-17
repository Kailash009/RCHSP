USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[Get_RCH_Data_CBR]    Script Date: 09/26/2024 14:07:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec [Get_RCH_Data_CBR] '8171593373','','8171817100'  
  
ALTER PROCEDURE [dbo].[Get_RCH_Data_CBR]  
@ReferenceId BIGINT = '',  
@HealthIdNumber VARCHAR(20)='',  
@MobileNo varchar(10)='',  
@RchId bigint =0,
@StateCode int=0
AS  
BEGIN  
  IF(  @ReferenceId <>'')  
   BEGIN  
    print 'a'  
     IF EXISTS(SELECT 1 FROM all_registration where reference_id=@ReferenceId)  
    BEGIN  
     
     SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID WHERE  reference_id=@ReferenceId 
    END  
       ELSE IF(@HealthIdNumber <>'')  
      BEGIN  
       
     IF EXISTS (SELECT 1 FROM all_registration where HealthIdNumber=@HealthIdNumber)  
      BEGIN  
         
       SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
                   HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
                   Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
                   ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
                   INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID WHERE  HealthIdNumber=@HealthIdNumber 
         end  
      else  
      begin  
        SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
                        HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
                        Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
                       ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
                     INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID WHERE  Mobile_no=@MobileNo  and Mobile_no<>''  and r.State_Code=@StateCode
      end  
    end  
    else  
    begin  
     SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
        WHERE  Mobile_no=@MobileNo  and Mobile_no<>''  and r.State_Code=@StateCode
    end  
  
end  
  else IF(@HealthIdNumber <>'')  
    BEGIN  
   
     IF EXISTS(SELECT * FROM all_registration where HealthIdNumber=@HealthIdNumber)  
       BEGIN  
  
        SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  WHERE  HealthIdNumber=@HealthIdNumber   
    END  
    ELSE IF(@ReferenceId <>'')  
   BEGIN  
    
     IF EXISTS(SELECT 1 FROM all_registration where reference_id=@ReferenceId)  
    BEGIN  
     
      SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
             ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
     WHERE  reference_id=@ReferenceId   
    END  
  end  
  else   
  begin  
    
          SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
        WHERE  Mobile_no=@MobileNo  and Mobile_no<>''   and r.State_Code=@StateCode
      end  
      
        end  
   
 else IF( @MobileNo <>'')  
     BEGIN  
   
   IF( @ReferenceId <>'')  
   BEGIN  
    
     IF EXISTS(SELECT 1 FROM all_registration where reference_id=@ReferenceId)  
    BEGIN  
     
                SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
     WHERE  reference_id=@ReferenceId  
    end  
    end  
   ELSE IF( @HealthIdNumber <>'')  
      BEGIN  
      
     IF EXISTS (SELECT 1 FROM all_registration where HealthIdNumber=@HealthIdNumber)  
      BEGIN  
                  SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
         
       WHERE  HealthIdNumber=@HealthIdNumber   
         END  
  else  
  begin  
    
                  SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
                HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
                Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
                ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
               INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
        WHERE  Mobile_no=@MobileNo  and Mobile_no<>''   and r.State_Code=@StateCode
      END  
   end  
     else  
  begin  
        SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
        WHERE  Mobile_no=@MobileNo  and Mobile_no<>''   and r.State_Code=@StateCode
  end  
    
  end  
    
    else IF(@HealthIdNumber <>'')  
    BEGIN  
   
     IF EXISTS(SELECT * FROM all_registration where HealthIdNumber=@HealthIdNumber)  
       BEGIN  
   
        SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  WHERE  HealthIdNumber=@HealthIdNumber   
    END  
    ELSE IF(@ReferenceId <>'')  
   BEGIN  
   
     IF EXISTS(SELECT 1 FROM all_registration where reference_id=@ReferenceId)  
    BEGIN  
     
      SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
             ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
     WHERE  reference_id=@ReferenceId   
    END  
  end  
  else   
  begin  
    
          SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
             HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
          ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
        WHERE  Mobile_no=@MobileNo  and Mobile_no<>''  and r.State_Code=@StateCode
      end  
      
        end  
   
 else IF( @RchId <>'')  
     BEGIN  
    
            SELECT r.State_Code,s.State_Name, District_Code,HealthBlock_Code, Taluka_Code,HealthFacility_Type, HealthFacility_Code,   
            HealthSubFacility_Code, Village_Code, Registration_no, Registration_date,Name_PW_CH, Gender, CAST(ISNULL(Birth_Date,'1900-01-01') as Date)Birth_Date,  
            Mother_Reg_no, Name_Guardian, Mobile_no,ISNULL(Religion_code,0) Religion_code, ISNULL(Caste,0)Caste,     
            ISNULL(Case_no,0)Case_no, ISNULL(BPL_APL, 0)BPL_APL, HealthIdNumber, reference_id FROM all_registration r with (NOLOCK)   
            INNER JOIN RCH_National_Level.dbo.State_Master s with (NOLOCK)  on r.State_Code=s.State_ID  
   WHERE  Registration_no=@RchId  
    
    
    
    
     END  
  end  
  
  
