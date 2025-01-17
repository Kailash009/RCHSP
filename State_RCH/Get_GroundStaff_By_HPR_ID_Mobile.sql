USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[Get_GroundStaff_By_HPR_ID_Mobile]    Script Date: 09/26/2024 14:07:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*  
Get_GroundStaff_By_HPR_ID_Mobile 46,'71-5062-4621-3451','9476092161',35  
Get_GroundStaff_By_HPR_ID_Mobile 0,'71-5062-4621-3451','9476092161',35 

Get_GroundStaff_By_HPR_ID_Mobile 46,'71-5062-4621-3458','9476092161',35  
Get_GroundStaff_By_HPR_ID_Mobile 0,'71-5561-2382-7458','',35  
*/  
  
    
ALTER PROCEDURE [dbo].[Get_GroundStaff_By_HPR_ID_Mobile]         
 @GF_ID int=0,  
 @HPR_ID varchar(17)='',    
 @Mobile_No varchar(10)='',  
 @State_ID int
AS        
BEGIN     
    DECLARE @SqlType varchar(max)
    
    SET @SqlType='SELECT a.State_Code,b.State_Name,a.District_Code,d.District_Name,Rural_Urban, 
        HealthBlock_Code,Taluka_Code,HealthFacility_Type,  
       HealthFacilty_Code,HealthSubFacility_Code,Village_Code,Financial_Yr,Financial_Year,ID,Reg_Date,  
       Name,Contact_No,Case WHEN Sex=''F'' THEN ''Female'' WHEN Sex=''M'' THEN ''Male'' ELSE  ''Other'' END AS Sex,
	   a.Is_Active,Husband_Name,Address,IsLinked,Telecom_Operator,Temporary_ID,  
       HPRID,a.Type_ID,C.Type_Name FROM All_Ground_Staff a  (nolock)  
       Inner join RCH_National_Level.dbo.State_Master b (nolock) on a.State_Code=b.State_ID     
       Inner join RCH_National_Level.dbo.m_HealthProvider_Type c (nolock) on a.Type_ID=c.Type_ID     
       Inner join RCH_National_Level.dbo.State_dis_Detail d (nolock) on a.District_Code=d.District_ID and a.State_Code=d.StateID   
       WHERE (isnull(a.Is_Active,0)=1)    
       AND A.Type_ID not in(1,8,9)' 
	  IF(@GF_ID<>0)    
		BEGIN
		   SET @SqlType= @SqlType + ' AND ((a.HPRID='''+@HPR_ID+''')  OR  (a.ID='+CONVERT(VARCHAR(12),@GF_ID)+' AND a.State_Code='+convert(varchar(2),@State_ID)+')) '
		END
	 ELSE
	  BEGIN
          SET @SqlType= @SqlType + ' AND ((a.HPRID='''+@HPR_ID+''')  OR (a.Contact_No='''+@Mobile_No+''' AND a.State_Code='+convert(varchar(2),@State_ID)+')) '    
      END  
  EXEC(@SqlType)            
      
END 
