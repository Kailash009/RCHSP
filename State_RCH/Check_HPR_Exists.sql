USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[Check_HPR_Exists]    Script Date: 09/26/2024 14:07:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
/*  
Check_HPR_Exists '56-0740-2674-8382',31,'','',0  
Check_HPR_Exists '71-3265-0032-1115',31,'','',0  
Check_HPR_Exists '',35,'9766891346','',0  
Check_HPR_Exists '',31,'9766891346',''  
Check_HPR_Exists '20-8742-6262-6538',35,'','',0  
*/  


ALTER PROCEDURE [dbo].[Check_HPR_Exists]       
 @HPR_ID varchar(17),  
 @State_ID int,  
 @mobileNo varchar(10)=null,  
 @Name varchar(50)=null,  
 @ID int=0  
AS      
BEGIN   
declare @SqlType varchar(max)        
   
 IF(@ID<>0 OR @ID<>'')  
 BEGIN  
   print 1  
 set @SqlType= 'SELECT ''1'' as Validated,b.State_Name as state,C.Type_Name  
 ,d.Name_E as District_Name,d.MDDS_Code as Dist_LGD,Case WHEN Sex=''F'' THEN ''Female'' WHEN Sex=''M'' THEN ''Male'' ELSE  ''Other'' END AS Sex,*   
 FROM All_Ground_Staff a  
 Inner join RCH_National_Level.dbo.State_Master b on a.State_Code=b.State_ID  
 Inner join RCH_National_Level.dbo.m_HealthProvider_Type c on a.Type_ID=c.Type_ID  
 Inner join All_District d on a.District_Code=d.DCode and d.StateID='+convert(varchar(2),@State_ID)+'  
 WHERE a.State_Code='+convert(varchar(2),@State_ID)+' AND a.ID='+convert(varchar(12),@ID)+' AND (a.Is_Active<>0 or a.Is_Active is null)'  
 END  
 ELSE IF EXISTS(SELECT * FROM All_Ground_Staff WHERE HPRID=@HPR_ID and Match_Score is not null and State_Code=@State_ID)  -- If HPRID is already mapped  
 BEGIN  
 print 2  
  set @SqlType='SELECT ''1'' as Validated,b.State_Name as state,C.Type_Name  
 ,d.Name_E as District_Name,d.MDDS_Code as Dist_LGD,Case WHEN Sex=''F'' THEN ''Female'' WHEN Sex=''M'' THEN ''Male'' ELSE  ''Other'' END AS Sex,*   
 FROM All_Ground_Staff a  
 Inner join RCH_National_Level.dbo.State_Master b on a.State_Code=b.State_ID  
 Inner join RCH_National_Level.dbo.m_HealthProvider_Type c on a.Type_ID=c.Type_ID  
 Inner join All_District d on a.District_Code=d.DCode and d.StateID='+convert(varchar(2),@State_ID)+'  
  WHERE a.State_Code='+convert(varchar(2),@State_ID)+' AND a.Match_Score is not null   
   AND (a.HPRID='''+@HPR_ID+''' or '''+@HPR_ID+'''='''')  
   AND (a.Name='''+@Name+''' or '''+@Name+'''='''')   
   AND (a.Is_Active<>0 or a.Is_Active is null)  
   AND A.Type_ID not in(1,8)'  
 IF(@mobileNo<>'')  
 BEGIN  
  set @SqlType= @SqlType + ' OR (a.Contact_No='''+@mobileNo+''' or '''+@mobileNo+'''='''') '  
 END  
 ELSE IF(@mobileNo='')  
 BEGIN  
  set @SqlType= @SqlType + ' AND (a.Contact_No='''+@mobileNo+''' or '''+@mobileNo+'''='''') '  
 END  
 END  
 ELSE   
 BEGIN  
   print 3  
  set @SqlType='SELECT '''' as Validated,b.State_Name as state,C.Type_Name  
 ,d.Name_E as District_Name,d.MDDS_Code as Dist_LGD,Case WHEN Sex=''F'' THEN ''Female'' WHEN Sex=''M'' THEN ''Male'' ELSE  ''Other'' END AS Sex,*   
 FROM All_Ground_Staff a  
 Inner join RCH_National_Level.dbo.State_Master b on a.State_Code=b.State_ID  
 Inner join RCH_National_Level.dbo.m_HealthProvider_Type c on a.Type_ID=c.Type_ID  
 Inner join All_District d on a.District_Code=d.DCode and d.StateID='+convert(varchar(2),@State_ID)+'  
  WHERE a.State_Code='+convert(varchar(2),@State_ID)+'  
  AND (a.HPRID='''+@HPR_ID+''' or '''+@HPR_ID+'''='''')  
   AND (a.Name='''+@Name+''' or '''+@Name+'''='''')  
   AND (a.Is_Active<>0 or a.Is_Active is null)  
   AND A.Type_ID not in(1,8)'  
     
 IF(@mobileNo<>''  and @HPR_ID<>'')  
 BEGIN  
  set @SqlType= @SqlType + ' OR (a.Contact_No='''+@mobileNo+''' or '''+@mobileNo+'''='''')'  
 END  
 ELSE IF(@mobileNo<>''  and @HPR_ID='')  
 BEGIN  
  set @SqlType= @SqlType + ' AND (a.Contact_No='''+@mobileNo+''' or '''+@mobileNo+'''='''')'  
 END  
 ELSE IF(@mobileNo='')  
 BEGIN  
  set @SqlType= @SqlType + ' AND (a.Contact_No='''+@mobileNo+''' or '''+@mobileNo+'''='''')'  
 END  
 END  
   
 EXEC(@SqlType)          
  PRINT(@SqlType)      
END   
  