USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetABHARegistration]    Script Date: 09/26/2024 12:14:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[MS_GetABHARegistration] 29,9,'R',4,'0043', 538,4134,99999999,0,9999,0,NULL,1,NULL,NULL,0,1

ALTER Procedure [dbo].[MS_GetABHARegistration]    -- mode 14        
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
                     
  SET @s='select ROW_NUMBER() OVER
      (
            ORDER BY a.[SNo]ASC
      )AS RowNumber , a.State_Code,a.District_Code,a.Rural_Urban,a.HealthBlock_Code,a.Taluka_Code,a.HealthFacility_Type,a.HealthFacility_Code,a.HealthSubFacility_Code,a.Village_Code,
	  a.Registration_no,b.Case_no,a.HealthId,a.HealthIdNumber,a.Name_PW,Birth_Date,a.Address,a.Registration_Date,a.IP_address,a.Created_By,a.Created_On,a.Is_Consent_given,a.HID_linked_date,a.Name_as_ABHA,a.DOB_as_ABHA,a.Mobile_no_as_ABHA,a.Name_match_score_as_ABHA,a.Approved_ABHA_Logic,a.SourceID
   into #results
  from dbo.t_mother_registration a   WITH(NOLOCK)         
  left outer join dbo.t_eligibleCouples b  WITH(NOLOCK) on b.Registration_no=a.Registration_no and b.Case_no=a.Case_no      
  inner join TBL_District c  WITH(NOLOCK) on a.District_Code=c.DIST_CD                   
  where c.Is_ANMOL=1 and a.HealthIdNumber is not null and '
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
if(@Financial_Year<>0 and @Financial_Year <> 9999)  
 begin  
  -- set @s=@s + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''  

  --' + CASE WHEN @StateCode IS NULL THEN '1' ELSE 'a.State_Code' END + ' = ' + CASE WHEN @StateCode IS NULL THEN '1' ELSE @StateCode END + @CRLF +  
  set @s=@s +' and CASE WHEN a.Financial_Year IS NULL THEN b.Financial_Year ELSE a.Financial_Year END '+'='+ CAST (@Financial_Year as varchar)
 end 
   if(@Financial_Year = 9999)  
 begin  
  --set @s=@s + ' and (a.Financial_Year >= year(getdate())-2)'  
    set @s=@s +' and CASE WHEN a.Financial_Year IS NULL THEN b.Financial_Year ELSE a.Financial_Year END '+'>='+  cast(year(getdate())-2  as varchar(4)) 

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
  -- PRINT (@PageIndex) 
  --    PRINT (@PageSize) 
  --PRINT (@s) 
 EXEC(@s)  
 End
Else if (@Flag=99)
  Begin
   set @s=@s +'a.District_Code=' + cast(@District_Code as varchar)   
 if(@Financial_Year<>0 and @Financial_Year <> 9999)  
 begin  
  set @s=@s +' and CASE WHEN a.Financial_Year IS NULL THEN b.Financial_Year ELSE a.Financial_Year END '+'='+ CAST (@Financial_Year as varchar)
 end 
   if(@Financial_Year = 9999)  
 begin  
 set @s=@s +' and CASE WHEN a.Financial_Year IS NULL THEN b.Financial_Year ELSE a.Financial_Year END '+'>='+  cast(year(getdate())-2  as varchar(4)) 
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
  EXEC(@s)
  END
End
else              
begin              
select 'DB' as ID,'' as Contact_No              
end                
end  

