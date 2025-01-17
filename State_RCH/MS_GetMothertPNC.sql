USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetMothertPNC]    Script Date: 09/26/2024 15:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*      
  
[MS_GetMothertPNC] 92,17,'R',310,'0748',1172,4816,0,11962    
[MS_GetMothertPNC] 92,17,'R',310,'0748',1172,4822,0,11953        
[MS_GetMothertPNC] 28,16,'R',236,'0717',2382,13811,20452,11953
[MS_GetMothertPNC] 28,16,'R',236,'0717',2382,13811,20452,11953,2014
[MS_GetMothertPNC] 28,16,'R',236,'0717',2382,13811,20452,11953,0,128005768226 
last modified by sneha (24052016)  
*/      
ALTER PROCEDURE [dbo].[MS_GetMothertPNC]      -- mode 8
(@State_Code int        
,@District_Code int        
,@Rural_Urban char(1)        
,@HealthBlock_Code int        
,@Taluka_Code varchar(6)        
,@HealthFacility_Code int        
,@HealthSubFacility_Code int        
,@Village_Code int 
,@ANM_ID int   
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
IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
  
	if(@Registration_no=0)
	begin      
		SET @s='select [SNo] ,[State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]  
		,[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[PNC_No],[PNC_Type],[PNC_Date],[No_of_IFA_Tabs_given_to_mother]  
		,[DangerSign_Mother],[DangerSign_Mother_Other],[DangerSign_Mother_length],[ReferralFacility_Mother],[ReferralFacilityID_Mother],[ReferralLoationOther_Mother]  
		,rtrim(ltrim(Cast([PPC] as varchar(10)))) as PPC,[OtherPPC_Method],[Mother_Death],[Place_of_death],[Mother_Death_Date],[Mother_Death_Reason],[Mother_Death_Reason_Other],[Mother_Death_Reason_length]  
		,[Remarks],[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],[Mobile_ID],[Updated_By],[Updated_On],[SourceID] from '+cast(@db as varchar)+'.dbo.t_mother_pnc      
		where State_Code= '+CAST (@State_Code as varchar)+'      
		and District_Code= '+CAST (@District_Code as varchar)+'      
		and Rural_Urban ='''+CAST (@Rural_Urban as varchar)+'''      
		and HealthBlock_Code ='+CAST (@HealthBlock_Code as varchar)+'      
		and Taluka_Code='''+CAST (@Taluka_Code as varchar)+'''      
		    
		and HealthFacility_Code= '+CAST (@HealthFacility_Code as varchar)+'      
		and HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'      
		--and (Village_Code ='+CAST (@Village_Code as varchar)+' or ' +CAST (@Village_Code as varchar)+ '=0)    
		--and ANM_ID='+CAST (@ANM_ID as varchar)+'      --Removed on 03022016 as ANM Needs data of whole village she is registered.  
		and (Financial_Year= '+CAST (@Financial_Year as varchar)+' or ' +CAST (@Financial_Year as varchar)+ '=0) -- Add Financial Year on 23022016 
		and (Registration_no='+CAST (@Registration_no as varchar)+'  or    '+CAST (@Registration_no as varchar)+'=0)
		'           
	end  
	else if(@Registration_no<>0)
	begin 
		 SET @s='select [SNo] ,[State_Code],[District_Code],[Rural_Urban],[HealthBlock_Code],[Taluka_Code],[HealthFacility_Type],[HealthFacility_Code],[HealthSubFacility_Code]  
		,[Village_Code],[Financial_Yr],[Financial_Year],[Registration_no],[ID_No],[PNC_No],[PNC_Type],[PNC_Date],[No_of_IFA_Tabs_given_to_mother]  
		,[DangerSign_Mother],[DangerSign_Mother_Other],[DangerSign_Mother_length],[ReferralFacility_Mother],[ReferralFacilityID_Mother],[ReferralLoationOther_Mother]  
		,rtrim(ltrim(Cast([PPC] as varchar(10)))) as PPC,[OtherPPC_Method],[Mother_Death],[Place_of_death],[Mother_Death_Date],[Mother_Death_Reason],[Mother_Death_Reason_Other],[Mother_Death_Reason_length]  
		,[Remarks],[ANM_ID],[ASHA_ID],[Case_no],[IP_address],[Created_By],[Created_On],[Mobile_ID],[Updated_By],[Updated_On],[SourceID] from '+cast(@db as varchar)+'.dbo.t_mother_pnc      
		where Registration_no='+CAST (@Registration_no as varchar)+''
	
	End
	--PRINT (@s)      
	EXEC(@s)  
end  
else  
begin  
select 'DB' as ID,'' as Contact_No  
end    
      
END   
------------------------------------------------------

