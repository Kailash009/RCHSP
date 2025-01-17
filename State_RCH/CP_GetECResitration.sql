USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[CP_GetECResitration]    Script Date: 09/26/2024 12:52:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
[CP_GetECResitration] 31,1,'R',1,'0001',2,0,0,138,2011,0
*/
ALTER PROCEDURE [dbo].[CP_GetECResitration]     -- mode 87
(@State_Code int=0        
,@District_Code int=0     
,@Rural_Urban char(1)='R'       
,@HealthBlock_Code int=0      
,@Taluka_Code varchar(6)='0'       
,@HealthFacility_Code int=0      
,@HealthSubFacility_Code int=0     
,@Village_Code int=0
,@ANM_ID int=0 
,@Financial_Year int=0
,@Registration_no bigint=0  
)        
              
as        
begin  
 SET NOCOUNT ON          
declare @s varchar(max),@db varchar(50)        
        
        
if(@State_Code <=9)        
begin        
set @db='RCH_0'+CAST(@State_Code AS VARCHAR)        
end        
else         
begin        
set @db='RCH_'+CAST(@State_Code AS VARCHAR)        
end        
        
IF (EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = @db ))    
begin    
SET @s='select  Registration_no as RCH_Id_No ,EC_Register_srno as EC_Registe_Srno,'''' as Health_Provider_Name,'''' as Asha_Name,
Name_wife as Women_Name,Name_husband as Husband_Name,PW_EID as PW_Enrollment_Number,PW_Aadhar_No as PW_Aadhar_Number,PW_Bank_Name as PW_Bank_Name,
PW_Account_No as PW_Account_Number,PW_Branch_Name as PW_Branch_Name,PW_IFSC_Code as PW_IFSC_Code,Hus_EID as Husband_EID,Hus_Aadhar_No as Husband_Aadhar_Number,
Hus_Bank_Name as Husband_Bank_Name,Hus_Account_No as Husband_Account_Number,Hus_Branch_Name as Husband_Branch_Name,Hus_IFSC_Code as Husband_IFSC_Code,
Whose_mobile as Whose_Mobile,Mobile_no as Mobile_Number,EC_Regisration_Date as EC_Registration_Date,Wife_current_age as Wife_Current_Age,
Wife_marry_age as Wife_Marry_Age,Hus_current_age as Husband_Current_Age,Hus_marry_age as Husband_Marry_Age, Address as Address,Religion as Religion,
Caste as Caste,'''' as BPL_APL, Male_child_born as Male_Child_Born,Female_child_born as Female_Chile_Born,Male_child_live as Male_Child_Live,
Female_child_live as Female_Child_Live,'''' as Young_Child_Age,Young_child_age_year as Young_Child_Age_Year,Young_child_age_month as YOung_Child_Age_Month,
Young_child_gender as Young_Child_Sex,Infertility_status as Infertility_Status,Infertility_refer  as EC_Infertility_Refer_To,'''' as Referral_Facility_Name
 from '+cast(@db as varchar)+'.dbo.t_mother_flat
where 
----StateID= '+CAST (@State_Code as varchar)+'        
--and District_ID= '+CAST (@District_Code as varchar)+'        
--and Rural_Urban='''+CAST (@Rural_Urban as varchar)+'''        
--and HealthBlock_ID='+CAST (@HealthBlock_Code as varchar)+'        
--and Taluka_ID='''+CAST (@Taluka_Code as varchar)+'''        
--and PHC_ID= '+CAST (@HealthFacility_Code as varchar)+'        
--and  SubCentre_ID='+CAST (@HealthSubFacility_Code as varchar)+'        
--and (Village_ID ='+CAST (@Village_Code as varchar)+' or ' +CAST (@Village_Code as varchar)+ '=0)  
--and (EC_Yr= '+CAST (@Financial_Year as varchar)+' or ' +CAST (@Financial_Year as varchar)+ '=0) -- Add Financial Year on 23022016 
--and 
(Registration_no='+CAST (@Registration_no as varchar)+')'
	
	
	
	  
End            
else    
begin    
set @s='select 0  as StateCode'
end  
--(isnull(Male_child_live,0) + isnull(Female_child_live,0) )as Total_Child_Born,

    --PRINT (@s)      
	EXEC(@s)  
end  
--------------------------******-------------------------------------------
