USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_MDDS_Taluka_Mapping_Search]    Script Date: 09/26/2024 14:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*    
[tp_MDDS_Taluka_Mapping_Search] 30,1,'0',0    
tp_MDDS_Village_Mapping_Search 99,4,'0040',2    
tp_MDDS_Village_Mapping_Search 99,4,'0040',3    
[tp_MDDS_Taluka_Mapping_Search] 0,0,'0',0    
*/    
ALTER procedure [dbo].[tp_MDDS_Taluka_Mapping_Search]    
(@State_Code int=0,    
@District_Code int=0,  
@Taluka_Code as varchar(7)='0',    
@Type_Id int=0    
)    
as     
begin    
    
if(@Type_Id=1)--Mapped and not verified    
begin    
select D.DIST_NAME +'(' +CAST(HS.DCode as varchar)+')' as Master_Dist_Name ,HS.DCode as Dist_Code,  HS.TCode as Master_Code,HS.Name_E as Master_Name, HS.MDDS_Code as MDDS_Code,LG.subdistrict_name_english as MDDS_Name,    
(case when isnull(HS.MDDS_Code,0)=0 and isnull(HS.IsVerified,0)=0 then ''    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=0 then 'Updated and Not verified'    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=1 then 'Updated and Verified' else 'Updated' end) as Result     
,(case when ISNULL(HS.IsVerified,0)=0 then '' else 1 end) as Verifiedstatus    
from dbo.All_Taluka as HS WITH(NOLOCK)   
left outer join dbo.LG_Subdistrict as LG WITH(NOLOCK) on HS.MDDS_Code=LG.MDDS_Code   
left outer join TBL_DISTRICT as D WITH(NOLOCK) on D.DIST_CD=HS.DCode     
--where HS.DCode=@District_Code and (HS.TCode=@Taluka_Code or @Taluka_Code='0') 
where (HS.DCode=@District_Code or @District_Code=0) and (HS.TCode=@Taluka_Code or @Taluka_Code='0')   
and isnull(HS.MDDS_Code,0)<>0     
and isnull(HS.IsVerified,0)=0    
          
 end    
 else if(@Type_Id=2)--verified and mapped    
 begin    
select D.DIST_NAME +'(' +CAST(HS.DCode as varchar)+')' as Master_Dist_Name ,HS.DCode as Dist_Code, HS.TCode  as Master_Code,HS.Name_E as Master_Name,HS.MDDS_Code as MDDS_Code,LG.subdistrict_name_english as MDDS_Name,    
(case when isnull(HS.MDDS_Code,0)=0 and isnull(HS.IsVerified,0)=0 then ''    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=0 then 'Updated and Not verified'    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=1 then 'Updated and Verified' else 'Updated' end)   as Result    
,(case when ISNULL(HS.IsVerified,0)=0 then '' else 1 end) as Verifiedstatus    
from dbo.All_Taluka as HS WITH(NOLOCK)    
left outer join dbo.LG_Subdistrict as LG WITH(NOLOCK) on HS.MDDS_Code=LG.MDDS_Code 
left outer join TBL_DISTRICT as D WITH(NOLOCK) on D.DIST_CD=HS.DCode       
--where HS.DCode=@District_Code and (HS.TCode=@Taluka_Code or @Taluka_Code='0')  
where (HS.DCode=@District_Code or @District_Code=0) and (HS.TCode=@Taluka_Code or @Taluka_Code='0')    
  
and isnull(HS.MDDS_Code,0)<>0    
and HS.IsVerified=1    
 end    
     
else if(@Type_Id=3)--Unmapped    
begin    
  select D.DIST_NAME +'(' +CAST(HS.DCode as varchar)+')' as Master_Dist_Name, HS.DCode as Dist_Code, HS.TCode as Master_Code,HS.Name_E as Master_Name,HS.MDDS_Code as MDDS_Code,LG.subdistrict_name_english as MDDS_Name,    
(case when isnull(HS.MDDS_Code,0)=0 and isnull(HS.IsVerified,0)=0 then ''    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=0 then 'Updated and Not verified'    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=1 then 'Updated and Verified' else 'Updated' end)    as Result     
,(case when ISNULL(HS.IsVerified,0)=0 then '' else 1 end) as Verifiedstatus    
from dbo.All_Taluka as HS WITH(NOLOCK)    
left outer join dbo.LG_Subdistrict as LG WITH(NOLOCK) on HS.MDDS_Code=LG.MDDS_Code  
left outer join TBL_DISTRICT as D WITH(NOLOCK) on D.DIST_CD=HS.DCode      
where  (HS.DCode=@District_Code or @District_Code=0)  --HS.DCode=@District_Code 
and (HS.TCode=@Taluka_Code or @Taluka_Code='0')     
and isnull(HS.IsVerified,0)=0    
end    
else      
begin   --All records  
  select D.DIST_NAME +'(' +CAST(HS.DCode as varchar)+')' as Master_Dist_Name ,HS.DCode as Dist_Code,  HS.TCode as Master_Code,HS.Name_E as Master_Name,HS.MDDS_Code as MDDS_Code,LG.subdistrict_name_english as MDDS_Name,    
(case when isnull(HS.MDDS_Code,0)=0 and isnull(HS.IsVerified,0)=0 then ''    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=0 then 'Updated and Not verified'    
when isnull(HS.MDDS_Code,0)<>0 and HS.IsVerified=1 then 'Updated and Verified' else 'Updated' end)  as Result     
,(case when ISNULL(HS.IsVerified,0)=0 then '' else 1 end) as Verifiedstatus    
from dbo.All_Taluka as HS WITH(NOLOCK)    
left outer join dbo.LG_Subdistrict as LG WITH(NOLOCK)  on HS.MDDS_Code=LG.MDDS_Code
left outer join TBL_DISTRICT as D WITH(NOLOCK) on D.DIST_CD=HS.DCode    
--where HS.DCode=@District_Code and (HS.TCode=@Taluka_Code or @Taluka_Code='0')  
where (HS.DCode=@District_Code or @District_Code=0) and (HS.TCode=@Taluka_Code or @Taluka_Code='0')    
end    
           
          
end    
  
