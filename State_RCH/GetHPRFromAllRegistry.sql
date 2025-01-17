USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[GetHPRFromAllRegistry]    Script Date: 09/26/2024 14:08:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
--exec GetHPRFromAllRegistry '',  '9418650614'    
ALTER PROCEDURE [dbo].[GetHPRFromAllRegistry]           
 @HPR_ID varchar(17)= '',     
 @mobileNo varchar(10)= ''    
AS          
BEGIN     
IF(@HPR_ID <>'')        
      BEGIN    
        SELECT b.State_Name,d.District_Name,c.Type_Name, a.Type_ID     
         , a.State_Code, a.District_Code, Rural_Urban, HealthBlock_Code, Taluka_Code, HealthFacility_Type,     
   HealthFacilty_Code, HealthSubFacility_Code, Village_Code, Financial_Yr, Financial_Year,    
   ID, Reg_Date, Name, Contact_No, Sex, a.Is_Active, Husband_Name,     
   Address, HPRID, HPRID_UpdateDt,Is_HPRvalidated    
        FROM All_Ground_Staff a      
        Inner join RCH_National_Level.dbo.State_Master b on a.State_Code=b.State_ID      
        Inner join RCH_National_Level.dbo.m_HealthProvider_Type c on a.Type_ID=c.Type_ID      
  Inner join RCH_National_Level.dbo.State_dis_Detail d on a.District_Code=d.District_ID and a.State_Code=d.StateID      
        WHERE a.HPRID=@HPR_ID     
        AND (a.Is_Active<>0 or a.Is_Active is null)      
        AND A.Type_ID  in(2,3,5,6)     
      END        
 ELSE       
      BEGIN     
         SELECT b.State_Name,d.District_Name,c.Type_Name, a.Type_ID     
         , a.State_Code, a.District_Code, Rural_Urban, HealthBlock_Code, Taluka_Code, HealthFacility_Type,     
   HealthFacilty_Code, HealthSubFacility_Code, Village_Code, Financial_Yr, Financial_Year,    
   ID, Reg_Date, Name, Contact_No, Sex, a.Is_Active, Husband_Name,     
   Address, HPRID, HPRID_UpdateDt,Is_HPRvalidated    
         FROM All_Ground_Staff a      
         Inner join RCH_National_Level.dbo.State_Master b on a.State_Code=b.State_ID      
         Inner join RCH_National_Level.dbo.m_HealthProvider_Type c on a.Type_ID=c.Type_ID      
   Inner join RCH_National_Level.dbo.State_dis_Detail d on a.District_Code=d.District_ID and a.State_Code=d.StateID      
          WHERE a.Contact_No=@mobileNo    
          AND (a.Is_Active<>0 or a.Is_Active is null)      
          AND A.Type_ID  in(2,3,5,6)     
      END     
END