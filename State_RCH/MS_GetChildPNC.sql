USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetChildPNC]    Script Date: 09/26/2024 12:14:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[MS_GetChildPNC]      -- mode 12      
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
,@SourceID tinyint=0   
,@StartDateTimeStamp DateTime =null    
,@EndDateTimeStamp DateTime =null    
,@Flag int=0  
,@PageIndex INT = null
  
)            
                  
as            
begin      
SET NOCOUNT ON       
declare @s varchar(max) , @N varchar(max)  
declare @PageSize INT = 5000
IF EXISTS (SELECT * FROM UserMaster_Webservices where Status=1)        
BEGIN        
SET @s='SELECT ROW_NUMBER() OVER
      (
            ORDER BY A.[Registration_no] ASC
	   
      )AS RowNumber, * INTO #Results from 
	  (
	  select a.[SNo],a.[State_Code],a.[District_Code],a.[Rural_Urban],a.[HealthBlock_Code],a.[Taluka_Code],a.[HealthFacility_Type],a.[HealthFacility_Code]      
      ,a.[HealthSubFacility_Code],a.[Village_Code],a.[Financial_Yr],a.[Financial_Year],a.[Registration_no],a.[ID_No],a.[InfantRegistration],a.[PNC_No]      
      ,a.[PNC_Type],a.[PNC_Date],a.[Infant_Weight],a.[DangerSign_Infant],a.[DangerSign_Infant_Other],a.[DangerSign_Infant_length],a.[ReferralFacility_Infant]      
      ,a.[ReferralFacilityID_Infant],a.[ReferralLoationOther_Infant],a.[Infant_Death],a.[Place_of_death],a.[Infant_Death_Date],a.[Infant_Death_Reason]      
      ,a.[Infant_Death_Reason_Other],a.[Infant_Death_Reason_length],a.[Remarks],a.[ANM_ID],a.[ASHA_ID],a.[Case_no],a.[IP_address],a.[Created_By]      
      ,a.[Created_On],a.[Mobile_ID],a.[Updated_By],a.[Updated_On],a.[SourceID]       
	   from dbo.t_child_pnc  a  WITH(NOLOCK)      
  inner join TBL_District c  WITH(NOLOCK) on a.District_Code=c.DIST_CD                   
  where c.Is_ANMOL=1 and '    
If(@Flag <> 99)   -- Add by Soni for filtering portal and Anmol data District Wise.    
BEGIN  
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
 --set @s=@s + ' a.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'       
 --and  a.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017       
 end        
 if(@Financial_Year<>0 and  @Financial_Year <> 9999)    
 begin    
  set @s=@s + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''    
 end   
   if(@Financial_Year = 9999)    
 begin    
  set @s=@s + ' and (a.Financial_Year >= year(getdate())-5)'    
 end     
 if(@TimeStamp Is Not NULL And @TimeStamp <> '')          
 begin          
  set @s=@s+' And (a.Created_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''' Or a.Updated_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''')'          
 end    
  if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))          
 begin          
  set @s=@s+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'                
 end      
 If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.17619      
     Begin      
--set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'       
     set @s=@s + ' and a.SourceID= '+CAST(@SourceID as varchar)+''        
     End             
  end        
        
  SET @N=' Union SELECT a.[SNo],d.[State_Code],a.[District_Code],a.[Rural_Urban],a.[HealthBlock_Code],a.[Taluka_Code],a.[HealthFacility_Type],a.[HealthFacility_Code]      
      ,a.[HealthSubFacility_Code],a.[Village_Code],a.[Financial_Yr],a.[Financial_Year],a.[Registration_no],a.[ID_No],a.[InfantRegistration],a.[PNC_No]      
      ,a.[PNC_Type],a.[PNC_Date],a.[Infant_Weight],a.[DangerSign_Infant],a.[DangerSign_Infant_Other],a.[DangerSign_Infant_length],a.[ReferralFacility_Infant]      
      ,a.[ReferralFacilityID_Infant],a.[ReferralLoationOther_Infant],a.[Infant_Death],a.[Place_of_death],a.[Infant_Death_Date],a.[Infant_Death_Reason]      
      ,a.[Infant_Death_Reason_Other],a.[Infant_Death_Reason_length],a.[Remarks],a.[ANM_ID],a.[ASHA_ID],a.[Case_no],a.[IP_address],a.[Created_By]      
      ,a.[Created_On],a.[Mobile_ID],a.[Updated_By],a.[Updated_On],a.[SourceID]       
	   from t_eligibleCouples d  WITH(NOLOCK)      
       inner join dbo.t_child_pnc  a  WITH(NOLOCK)  on d.Registration_no = a.Registration_no and d.Case_no =a.Case_no       
  inner join TBL_District c  WITH(NOLOCK) on d.District_Code=c.DIST_CD                   
  where c.Is_ANMOL=1 and '      
if(@Registration_no<>0)      
  begin      
 set @N=@N + ' a.Registration_no='+CAST (@Registration_no as varchar)+''      
  end       
  else      
  begin      
    If(@Village_Code=99999999)--For SubCentre Data      
 Begin      
  set @N=@N + ' d.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+''  -- when village code is null      
 End      
 else      
 begin      
 If(@Village_Code=0)      
 Begin      
   set @N=@N + ' d.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'           
    and d.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017           
 End      
 else      
    Begin      
     set @N=@N + ' d.Village_Code ='+CAST (@Village_Code as varchar)+''      
    End      
 --set @s=@s + ' a.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'       
 --and  a.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017       
 end        
 if(@Financial_Year<>0 and  @Financial_Year <> 9999)    
 begin    
  set @N=@N + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''    
 end   
   if(@Financial_Year = 9999)    
 begin    
  set @N=@N + ' and (a.Financial_Year >= year(getdate())-5)'    
 end       
 if(@TimeStamp Is Not NULL And @TimeStamp <> '')          
 begin          
  set @N=@N+' And (a.Created_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''' Or a.Updated_On >= ''' + CONVERT(Varchar(19),@TimeStamp, 120) + ''')'          
 end    
  if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))          
 begin          
  set @N=@N +' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'                
 end      
 If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.17619      
     Begin      
--set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'       
     set @N=@N + ' and a.SourceID= '+CAST(@SourceID as varchar)+''        
     End             
 END       
  Set @s = @s + @N  + ') a'   
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
--print @s      
END  
Else if (@Flag=99)  
Begin  
 set @s=@s +'a.District_Code=' + cast(@District_Code as varchar)   
 if(@Financial_Year<>0 and  @Financial_Year <> 9999)    
 begin    
  set @s=@s + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''    
 end   
   if(@Financial_Year = 9999)    
 begin    
  set @s=@s + ' and (a.Financial_Year >= year(getdate())-5)'    
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
 SET @N=' Union SELECT a.[SNo],d.[State_Code],a.[District_Code],a.[Rural_Urban],a.[HealthBlock_Code],a.[Taluka_Code],a.[HealthFacility_Type],a.[HealthFacility_Code]      
      ,a.[HealthSubFacility_Code],a.[Village_Code],a.[Financial_Yr],a.[Financial_Year],a.[Registration_no],a.[ID_No],a.[InfantRegistration],a.[PNC_No]      
      ,a.[PNC_Type],a.[PNC_Date],a.[Infant_Weight],a.[DangerSign_Infant],a.[DangerSign_Infant_Other],a.[DangerSign_Infant_length],a.[ReferralFacility_Infant]      
      ,a.[ReferralFacilityID_Infant],a.[ReferralLoationOther_Infant],a.[Infant_Death],a.[Place_of_death],a.[Infant_Death_Date],a.[Infant_Death_Reason]      
      ,a.[Infant_Death_Reason_Other],a.[Infant_Death_Reason_length],a.[Remarks],a.[ANM_ID],a.[ASHA_ID],a.[Case_no],a.[IP_address],a.[Created_By]      
      ,a.[Created_On],a.[Mobile_ID],a.[Updated_By],a.[Updated_On],a.[SourceID]       
	   from t_eligibleCouples d  WITH(NOLOCK)      
       inner join dbo.t_child_pnc  a  WITH(NOLOCK)  on d.Registration_no = a.Registration_no and d.Case_no =a.Case_no       
  inner join TBL_District c  WITH(NOLOCK) on d.District_Code=c.DIST_CD                   
  where c.Is_ANMOL=1 and '   
  set @n=@n +'a.District_Code=' + cast(@District_Code as varchar)   
 if(@Financial_Year<>0 and  @Financial_Year <> 9999)    
 begin    
  set @n=@n + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''    
 end   
   if(@Financial_Year = 9999)    
 begin    
  set @n=@n + ' and (a.Financial_Year >= year(getdate())-5)'    
 end    
  if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))        
 begin        
  set @N=@N+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'              
 end  
  If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.    
 Begin    
  --set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'     
  set @N=@N +' And a.SourceID=' + cast(@SourceID as varchar)     
 END  
 Set @s = @s + @N + ') a'   
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
END  
else        
begin        
select 'DB' as ID,'' as Contact_No        
end           
END   
  
