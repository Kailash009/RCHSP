USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetECResitration]    Script Date: 09/26/2024 14:42:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*                  
MS_GetECResitration_new 9,5,'R',149,'0149',153,4741,19449,5130,0 ,0,''      
  
MS_GetECResitration 87,0,'',0,'', 0,0,0,0,0,187000029525,''      
  
MS_GetECResitration 87,0,'',0,'', 0,0,0,0,0,187000070506,''    
*/          

--[MS_GetECResitration] 35,4,'R',3,'0008', 33,134,10000044,962,0,0,Null ,99,NULL,NULL,0,1,1000
ALTER Procedure [dbo].[MS_GetECResitration]   -- mode 1          
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
,@TimeStamp DateTime = Null      
,@SourceID tinyint = 0    
,@StartDateTimeStamp DateTime =null
,@EndDateTimeStamp DateTime =null
,@Flag int=0
,@PageIndex INT = null

)                  
                        
as                  
begin            
SET NOCOUNT ON           
declare @s varchar(max)  
declare @PageSize INT = 5000
IF EXISTS (SELECT * FROM UserMaster_Webservices where Status=1)            
begin              
                     
  SET @s='SELECT ROW_NUMBER() OVER
      (
            ORDER BY a.[SNo]ASC
      )AS RowNumber ,         
  a.SNo,a.State_Code,a.District_Code,a.Rural_Urban,a.HealthBlock_Code,a.Taluka_Code,a.HealthFacility_Type,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,a.Financial_Yr,a.Financial_Year,          
  a.Registration_no,a.ID_No,a.Register_srno,a.Name_wife,a.Name_husband,a.Whose_mobile,a.Landline_no,a.Mobile_no,a.Date_regis,a.Wife_current_age,a.Wife_marry_age,a.Address,a.Religion_Code,a.Caste,          
  a.Identity_type,a.Identity_number,a.Male_child_born,a.Female_child_born,a.Male_child_live,a.Female_child_live,a.Young_child_gender,a.Young_child_age_month,a.Young_child_age_year,a.Infertility_status,          
  a.Infertility_refer,a.Pregnant,a.Pregnant_test,a.Eligible,a.Status,a.ANM_ID,a.ASHA_ID,a.Case_no,a.Flag,a.IP_address,a.Created_By,a.Created_On, 0 as Aadhar_No,a.EID,a.EIDT,a.BPL_APL,0 as HusbandAadhaar_no,a.PW_AadhaarLinked,          
  a.PW_BankID,a.PW_AccNo,a.PW_IFSCCode,a.PW_BranchName,a.Husband_AadhaarLinked,a.Husband_BankID,a.Husband_AccNo,a.Husband_IFSCCode,a.Husband_BranchName,a.InactiveECReason,a.InfertilityOptions,a.InfertilityReferDH,          
  a.Updated_On,a.Updated_By,isnull(a.Delete_Mother,0)as Delete_Mother ,a.ReasonForDeletion,a.DeletedOn,a.CPSMS_Flag,a.IsHusbandFather,a.Mobile_ID,a.SourceID,a.Husband_EID,a.Husband_EIDT,(case when b.Re_Registration_Done is null then 2 else b.Re_Registration_Done end) as ReRegDone  
  ,isnull(m.Entry_Type,4) as Entry_Type,m.Birth_Date,a.Hus_current_age,a.Hus_marry_age,m.Is_PVTG
  into #Results
  from dbo.t_eligibleCouples a   WITH(NOLOCK)     join t_mother_registration m   WITH(NOLOCK)  on a.Registration_no=m.Registration_no and a.Case_no=m.Case_no  
  left outer join dbo.t_temp b  WITH(NOLOCK) on b.Registration_no=a.Registration_no and b.Case_no=a.Case_no      
  inner join TBL_District c  WITH(NOLOCK) on a.District_Code=c.DIST_CD                    
  where c.Is_ANMOL=1 and '
 If(@Flag <> 99)   -- Add by Soni for filtering portal and Anmol data District Wise.  
 Begin  
  if(@Registration_no<>0)      
  begin      
 set @s=@s + ' a.Registration_no='+CAST (@Registration_no as varchar)+''      
  end       
  else      
  begin      
 If(@Village_Code=99999999)--For SubCentre Data      
 Begin      
  set @s=@s + ' a.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+''  -- when village code is null      
 End      
 else      
 begin      
 If(@Village_Code=0)  
   Begin  
   set @s=@s + ' a.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'       
   and  a.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017       
   End  
 else  
   Begin  
   set @s=@s + ' a.Village_Code ='+CAST (@Village_Code as varchar)+''  
   End       
 End        
 if(@Financial_Year<>0)      
 begin      
  set @s=@s + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''      
 end       
 if(@TimeStamp Is Not NULL And @TimeStamp <> '')          
 begin          
  set @s=@s+' And (a.Created_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''' Or a.Updated_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''')'          
    end   
      
 if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))      
 begin      
  set @s=@s+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'            
 end

 If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.  
 Begin  
  --set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'   
  set @s=@s +' And a.SourceID=' + cast(@SourceID as varchar)   
 END 
End  
if((@PageIndex is not null and @PageSize is not null) AND (@PageIndex <>0 and @PageSize <>0) )
begin
set @s=@s + CHAR(13)+CHAR(10) + ' SELECT *,(select count(1) from #Results) as TotalRecords,'+CAST (@PageSize as varchar)+' as TotalPageSize 
      FROM #Results
      WHERE RowNumber BETWEEN('+CAST (@PageIndex as varchar)+' -1) * '+CAST (@PageSize as varchar)+' + 1 AND((( '+CAST (@PageIndex as varchar)+' -1) * '+CAST ( @PageSize as varchar)+' + 1) +'+CAST ( @PageSize as varchar)+') - 1
      DROP TABLE #Results'
 end
 else
 begin
     set @s=@s + CHAR(13)+CHAR(10) + ' SELECT *,(select count(1) from #Results) as TotalRecords,'+CAST (@PageSize as varchar)+' as TotalPageSize
      FROM #Results
      DROP TABLE #Results'
 end  
 print (@s)
 EXEC(@s)  
 End
Else if (@Flag=99)
  Begin
   set @s=@s +'a.District_Code=' + cast(@District_Code as varchar)   
  if(@Financial_Year<>0)      
 begin      
  set @s=@s + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''      
 end 
  if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))      
 begin      
  set @s=@s+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'            
 end
  If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.  
 Begin  
  --set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'   
  set @s=@s +' And a.SourceID=' + cast(@SourceID as varchar)   
 END 
if((@PageIndex is not null and @PageSize is not null) AND (@PageIndex <>0 and @PageSize <>0) )
begin
set @s=@s + CHAR(13)+CHAR(10) + ' SELECT *,(select count(1) from #Results) as TotalRecords,'+CAST (@PageSize as varchar)+' as TotalPageSize
      FROM #Results
      WHERE RowNumber BETWEEN('+CAST (@PageIndex as varchar)+' -1) * '+CAST (@PageSize as varchar)+' + 1 AND((( '+CAST (@PageIndex as varchar)+' -1) * '+CAST ( @PageSize as varchar)+' + 1) +'+CAST ( @PageSize as varchar)+') - 1
     
      DROP TABLE #Results'
 end
 else
 begin
     set @s=@s + CHAR(13)+CHAR(10) + ' SELECT *,(select count(1) from #Results) as TotalRecords,'+CAST (@PageSize as varchar)+' as TotalPageSize
      FROM #Results
      DROP TABLE #Results'
 end
 print(@s)
  EXEC(@s)
  END
End
else              
begin              
select 'DB' as ID,'' as Contact_No              
end                
end              
-----------------------------------------------  
  
  


