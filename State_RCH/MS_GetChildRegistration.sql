USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[MS_GetChildRegistration]    Script Date: 09/26/2024 12:15:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



  
/*            
[MS_GetChildRegistration] 99,5,'R',16,'0013',219,1056,10005302,0,2015,0,'2016-02-19 17:46:24'          
[MS_GetChildRegistration] 99,5,'R',16,'0013',219,1056,10005302,0,2015,0,''        
    [MS_GetChildRegistration_new] 87,0,'',0,'',0,0,37131,0,2019,0,''
	[MS_GetChildRegistration_FTD] 35,4,'R',3,'0008', 33,134,10000044,962,0,0,Null ,1,NULL,NULL,0,1
*/            
ALTER Procedure [dbo].[MS_GetChildRegistration]   -- mode 9         
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
begin          
SET @s='SELECT ROW_NUMBER() OVER
      (
            ORDER BY A.[Registration_no] ASC
	   
      )AS RowNumber, * INTO #Results from 
	  (select a.[SNo],a.[State_Code],a.[District_Code],a.[Rural_Urban],a.[HealthBlock_Code],a.[Taluka_Code],a.[HealthFacility_Type],a.[HealthFacility_Code]      
      ,a.[HealthSubFacility_Code],a.[Village_Code],a.[Registration_no],a.[Register_srno],a.[Financial_Yr],a.[Financial_Year],a.[Registration_Date]      
      ,a.[Name_Child],a.[Gender],a.[Birth_Date],a.[Birth_place],a.[Mother_Reg_no],a.[Mother_ID_No],a.[ID_No],a.[Name_Mother],a.[Landline_no],a.[Mobile_no]      
      ,a.[Address],a.[Religion_code],a.[Caste],a.[Identity_type],a.[Identity_number],a.[ANM_ID],a.[ASHA_ID],a.[IP_address],a.[Created_By],a.[Created_On]      
      ,isnull(a.[Delete_mother],0)Delete_mother,a.[ReasonForDeletion],a.[DeletedOn],a.[Name_Father],a.[Mobile_Relates_To],a.[Weight],a.[Delivery_Location],a.[DeliveryLocationID]      
      ,a.[Updated_On],a.[Updated_By],a.[Mobile_ID],a.[SourceID],a.[Child_EID],a.[Child_EIDT], 0 as [Child_Aadhar_No],a.[Birth_Certificate_Received]      
      ,a.[Entry_Type],a.[Fully_Immunized],a.[Received_AllVaccines],a.[Birth_CertificateNo],a.[Case_no],a.Is_PVTG,a.HBIG_Date       
	  from t_children_registration  a   WITH(NOLOCK)         
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
 if(@Financial_Year<>0 and @Financial_Year <> 9999)  
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
  END    
  
     
   SET @N=' Union SELECT  a.[SNo],d.[State_Code],d.[District_Code],d.[Rural_Urban],d.[HealthBlock_Code],d.[Taluka_Code],d.[HealthFacility_Type],d.[HealthFacility_Code]      
      ,d.[HealthSubFacility_Code],d.[Village_Code],a.[Registration_no],a.[Register_srno],a.[Financial_Yr],a.[Financial_Year],a.[Registration_Date]      
      ,a.[Name_Child],a.[Gender],a.[Birth_Date],a.[Birth_place],a.[Mother_Reg_no],a.[Mother_ID_No],a.[ID_No],a.[Name_Mother],a.[Landline_no],a.[Mobile_no]      
      ,a.[Address],a.[Religion_code],a.[Caste],a.[Identity_type],a.[Identity_number],a.[ANM_ID],a.[ASHA_ID],a.[IP_address],a.[Created_By],a.[Created_On]      
      , isnull(a.[Delete_mother],0)Delete_mother,a.[ReasonForDeletion],a.[DeletedOn],a.[Name_Father],a.[Mobile_Relates_To],a.[Weight],a.[Delivery_Location],a.[DeliveryLocationID]      
      ,a.[Updated_On],a.[Updated_By],a.[Mobile_ID],a.[SourceID],a.[Child_EID],a.[Child_EIDT], 0 as [Child_Aadhar_No],a.[Birth_Certificate_Received]      
      ,a.[Entry_Type],a.[Fully_Immunized],a.[Received_AllVaccines],a.[Birth_CertificateNo],a.[Case_no],a.Is_PVTG,a.HBIG_Date          
      from t_eligiblecouples d  WITH(NOLOCK)  
      inner join t_children_registration  a  WITH(NOLOCK) on d.registration_no = a.mother_reg_no and d.case_no= a.case_no     
inner join TBL_District c  WITH(NOLOCK) on a.District_Code=c.DIST_CD                   
where c.Is_ANMOL=1 and isnull(a.Mother_reg_no,0) !=0  and '     
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
    and  d.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017       
 End  
 else  
    Begin  
     set @N=@N + ' d.Village_Code ='+CAST (@Village_Code as varchar)+''  
    End  
 --set @s=@s + ' a.HealthSubFacility_Code ='+CAST (@HealthSubFacility_Code as varchar)+'       
 --and  a.Village_Code ='+CAST (@Village_Code as varchar)+''  -- opened as APK is going to release on 10112017        
 end       
 if(@Financial_Year<>0 and @Financial_Year <> 9999)  
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
  set @N=@N+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'            
 end
   If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.17619  
  Begin  
--set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'   
  set @N=@N + ' and a.SourceID= '+CAST(@SourceID as varchar)+''    
   END     
  END      
     
  Set @S = @S + @N  + ') a' 
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
End
Else if (@Flag=99)
Begin
 set @s=@s +'a.District_Code=' + cast(@District_Code as varchar) 
 if(@Financial_Year<>0 and @Financial_Year <> 9999)  
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
    SET @N=' Union SELECT a.[SNo],d.[State_Code],d.[District_Code],d.[Rural_Urban],d.[HealthBlock_Code],d.[Taluka_Code],d.[HealthFacility_Type],d.[HealthFacility_Code]      
      ,d.[HealthSubFacility_Code],d.[Village_Code],a.[Registration_no],a.[Register_srno],a.[Financial_Yr],a.[Financial_Year],a.[Registration_Date]      
      ,a.[Name_Child],a.[Gender],a.[Birth_Date],a.[Birth_place],a.[Mother_Reg_no],a.[Mother_ID_No],a.[ID_No],a.[Name_Mother],a.[Landline_no],a.[Mobile_no]      
      ,a.[Address],a.[Religion_code],a.[Caste],a.[Identity_type],a.[Identity_number],a.[ANM_ID],a.[ASHA_ID],a.[IP_address],a.[Created_By],a.[Created_On]      
      , isnull(a.[Delete_mother],0)Delete_mother,a.[ReasonForDeletion],a.[DeletedOn],a.[Name_Father],a.[Mobile_Relates_To],a.[Weight],a.[Delivery_Location],a.[DeliveryLocationID]      
      ,a.[Updated_On],a.[Updated_By],a.[Mobile_ID],a.[SourceID],a.[Child_EID],a.[Child_EIDT], 0 as [Child_Aadhar_No],a.[Birth_Certificate_Received]      
      ,a.[Entry_Type],a.[Fully_Immunized],a.[Received_AllVaccines],a.[Birth_CertificateNo],a.[Case_no],a.Is_PVTG,a.HBIG_Date          
      from t_eligiblecouples d  WITH(NOLOCK)  
      inner join t_children_registration  a  WITH(NOLOCK) on d.registration_no = a.mother_reg_no and d.case_no= a.case_no     
      inner join TBL_District c  WITH(NOLOCK) on a.District_Code=c.DIST_CD                   
      where c.Is_ANMOL=1 and isnull(a.Mother_reg_no,0) !=0  and ' 
      set @n=@n +'a.District_Code=' + cast(@District_Code as varchar) 
 if(@Financial_Year<>0 and @Financial_Year <> 9999)  
 begin  
  set @n=@n + ' and a.Financial_Year= '+CAST (@Financial_Year as varchar)+''  
 end 
   if(@Financial_Year = 9999)  
 begin  
  set @n=@n + ' and (a.Financial_Year >= year(getdate())-5)'  
 end  
  if((@StartDateTimeStamp Is Not NULL And @StartDateTimeStamp <> '') and (@EndDateTimeStamp Is Not NULL And @EndDateTimeStamp<>''))      
 begin      
  set @n=@n+' And ((Convert(varchar(10),a.Created_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + ''' and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''')  Or (Convert(varchar(10),a.Updated_On,120) between ''' + CONVERT(Varchar(10),@StartDateTimeStamp, 120) + '''  and ''' + CONVERT(Varchar(10),@EndDateTimeStamp, 120) + ''' ))'            
 end
  If(@SourceID <> 1)   -- Add by Manas for filtering portal and Anmol data.  
 Begin  
  --set @s=@s +' And a.SourceID= (case ''' + cast(@SourceID as varchar)  + ''' When 1 then 0 else ''' + cast(@SourceID as varchar)  +''' END)'   
  set @n=@n +' And a.SourceID=' + cast(@SourceID as varchar)   
 END
 Set @s = @s + @n + ') a' 
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
end   
end
else        
begin        
select 'DB' as ID,'' as Contact_No        
end          
            
END  
  
  
