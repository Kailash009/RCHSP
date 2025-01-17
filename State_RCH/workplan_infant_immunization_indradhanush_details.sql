USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[workplan_infant_immunization_indradhanush_details]    Script Date: 09/26/2024 14:53:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------Child (0-1)------------------------------------------------  
/*          
[workplan_infant_immunization_indradhanush_details_SHIV] 2022,3,3,0,0,0,0,2,'District',0,99,'',0
[workplan_infant_immunization_indradhanush_details] 2022,3,3,0,0,0,0,2,'District',0,99,0,0           
[workplan_infant_immunization_indradhanush_details] 2017,5,145,936,0,0,'PHC',0,98          
[workplan_infant_immunization_indradhanush_details] 2017,5,145,936,0,0,'PHC',0,97     
[workplan_infant_immunization_indradhanush_details] 2021,4,2,22,0,0,0,2,'PHC',0,97,'',0          
*/       
---------------------------------Child (0-1)------------------------------------------------   
         
ALTER proc [dbo].[workplan_infant_immunization_indradhanush_details]  
(          
 @Year varchar(4)=0                                            
,@Month varchar(2)=0    
,@District_Code varchar(2)=0    
,@HealthBlock_Code varchar(15)=0                                                                                   
,@HealthFacility_Code varchar(15) =0                                                
,@HealthSubFacility_Code varchar(15) =0                                               
,@Village_Code varchar(20)=0             
,@Period_ID varchar(1)=0              
,@Category varchar(5)='PHC'                                                                 
,@ANMASHA_ID varchar(5)=0                      
,@Service_ID varchar(5)=0                    
,@Is_ANMASHA varchar(5)=''             
,@Type_ID varchar(5)=0                  
)          
as          
begin          
Declare @Ldate as varchar(15),@Fdate as varchar(15)          
set @Fdate=cast(@year as varchar)+'-'+cast(@month as varchar)+'-01'          
set @Ldate=convert(Date,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@Fdate)+1,0)))          
Declare @Sql Varchar(Max)         
if(@Service_ID = 99  or @Service_ID=0) -- due vacc 0 to 1 year          
 begin          
  set @Sql= 'Select B.District_Name,B.HealthBlock_Name,B.PHC_NAME,B.SubCentre_Name,B.Village_Name  
  ,A.Registration_no,B.Child_Name          
  ,B.Birth_Date,B.MobileNo,B.Address,B.Mother_Reg_no,B.Name_Mother,B.ANM_Name,B.ANM_ID          
  ,B.ANM_mobile,B.ASHA_Name,B.ASHA_ID,B.ASHA_mobile,B.Services_Given,B.Services_Due,Guest_Ben,        
  B.Name_Father from          
  (SELECT  a.Registration_no          
  FROM [t_workplanChild] a (nolock)          
  inner join t_child_flat_Count b (nolock) on a.Registration_No=b.Registration_No  
  inner join TBL_HEALTH_BLOCK e1 (nolock) on b.HealthBlock_ID=e1.BLOCK_CD            
  inner join m_Month_YearMaster c (nolock) on a.MinDate <= c.DateCheck          
  where c.Month_ID='+@Month+' and c.Year_ID='+@Year+'          
  and datediff(month,Child_Birthdate_Date,'''+@Ldate+''')<=12          
  and a.MinDate<='''+@Ldate+'''           
  and a.Immu_Date is null          
  and b.Entry_Type_Active=1'
            
if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + ' and b.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + ' and b.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' and b.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' and b.Village_ID='+@Village_Code+''   
end
set @Sql = @Sql + 'group by  a.Registration_no
) A          
  inner join          
  (select   a1.DIST_NAME_ENG as District_Name,
 e1.Block_Name_E as HealthBlock_Name,
  isnull(b.PHC_NAME,''Direct Entry'') as  PHC_NAME,        
  isnull(c.SUBPHC_NAME_E,''Direct Entry'') as  SubCentre_Name                                
  ,isnull(h.VILLAGE_NAME,''Direct Entry'') as Village_Name            
  ,a.Registration_no,convert(varchar(10),a.Birth_Date,103)as Birth_Date,(a.Mobile_no) as MobileNo          
  ,a.Address,a.Mother_Reg_no,a.Name_Mother,d.Name as ANM_Name,d.ID as ANM_ID,(d.contact_no) as ANM_mobile          
  ,(case when a.ASHA_ID=0 then ''Not Available'' else f.Name end) as ASHA_Name          
  ,a.ASHA_ID,(case when a.ASHA_ID=0 then ''Not Available'' else (f.Contact_No) end) as ASHA_mobile          
  ,a.Name_Child + (Case when a.Weight <= 2.5 then ''*'' else '''' end)as Child_Name          
  ,dbo.Get_Service_Name(a.Registration_no,1,'''+@Ldate+''') as Services_Given          
  ,dbo.Get_Service_Name(a.Registration_no,0,'''+@Ldate+''') as Services_Due          
  ,(case when '+@HealthFacility_Code+' =0 and '+@HealthBlock_Code+' <> 0 and a.District_ID<>'+@District_Code+' then  1 Else  
   case when '+@HealthSubFacility_Code+'=0 and '+@HealthFacility_Code+' <> 0 and a.HealthBlock_ID<>'+@HealthBlock_Code+' then  1 Else           
   case when '+@Village_Code+'=0 and '+@HealthSubFacility_Code+'<>0 and a.PHC_ID <> '+@HealthFacility_Code+' then 1  else
   case when '+@Village_Code+'<>0 and a.SubCentre_ID <> '+@HealthSubFacility_Code+'  then  1 Else  0 end end end end) as Guest_Ben
  ,a.Name_Father        
  from t_child_flat a   (nolock)         
  inner join TBL_DISTRICT a1 (nolock) on a.District_ID=a1.DIST_CD
  inner join TBL_HEALTH_BLOCK e1 (nolock) on a.HealthBlock_ID=e1.BLOCK_CD            
  inner join TBL_PHC b (nolock) on a.PHC_ID=b.PHC_CD          
  left outer join TBL_SUBPHC c (nolock) on a.SubCentre_ID=c.SUBPHC_CD          
  left outer join t_Ground_Staff d (nolock) on a.ANM_ID=d.ID          
  left outer join t_Ground_Staff f (nolock) on a.ASHA_ID=f.ID         
  left outer join TBL_VILLAGE h (nolock) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD          
  where'
if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + '  a.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + '  a.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + '  a.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + '  a.Village_ID='+@Village_Code+''   
end
set @Sql = @Sql + 'and DATEDIFF(month,Birth_Date,'''+@Ldate+''') <=12          
  and a.Entry_Type = ''Active''            
  and a.ANM_ID=((Case when '''+@Is_ANMASHA+'''=2 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ANM_ID end))          
  and a.ASHA_ID=((Case when '''+@Is_ANMASHA+'''=1 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ASHA_ID  end))         
  )B on A.Registration_no=B.Registration_no                  
  order by Guest_Ben,B.Birth_Date '                 
 end          
 else if(@Service_ID = 98) -- due vacc 1 to 2 year           
 begin          
  set @Sql= 'Select B.District_Name,
   B.HealthBlock_Name,
   B.PHC_NAME,B.SubCentre_Name,B.Village_Name
  ,A.Registration_no,B.Child_Name          
  ,B.Birth_Date,B.MobileNo,B.Address,B.Mother_Reg_no,B.Name_Mother,B.ANM_Name,B.ANM_ID          
  ,B.ANM_mobile,B.ASHA_Name,B.ASHA_ID,B.ASHA_mobile,B.Services_Given,B.Services_Due, Guest_Ben,        
   B.Name_Father from          
  (SELECT  a.Registration_no          
  FROM [t_workplanChild] a  (nolock)          
  inner join t_child_flat_Count b (nolock) on a.Registration_No=b.Registration_No          
  inner join m_Month_YearMaster c (nolock) on a.MinDate <= c.DateCheck          
  where c.Month_ID='+@Month+' and c.Year_ID='+@Year+'         
  and datediff(month,Child_Birthdate_Date,'''+@Ldate+''') between 13 and 24          
  and a.MinDate<='''+@Ldate+'''           
  and a.Immu_Date is null          
  and b.Entry_Type_Active=1'
if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + ' and b.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + ' and b.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' and b.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' and b.Village_ID='+@Village_Code+''   
end
set @Sql = @Sql + ' group by  a.Registration_no
) A          
  inner join          
  (select   a1.DIST_NAME_ENG as District_Name,
  e1.Block_Name_E as HealthBlock_Name,
  isnull(b.PHC_NAME,''Direct Entry'') as  PHC_NAME,          
  isnull(c.SUBPHC_NAME_E,''Direct Entry'') as  SubCentre_Name                                  
  ,isnull(h.VILLAGE_NAME,''Direct Entry'') as Village_Name             
  ,a.Registration_no,convert(varchar(10),a.Birth_Date,103)as Birth_Date,(a.Mobile_no) as MobileNo          
  ,a.Address,a.Mother_Reg_no,a.Name_Mother,d.Name as ANM_Name,d.ID as ANM_ID,(d.contact_no) as ANM_mobile          
  ,(case when a.ASHA_ID=0 then ''Not Available'' else f.Name end) as ASHA_Name          
  ,a.ASHA_ID,(case when a.ASHA_ID=0 then ''Not Available'' else (f.Contact_No) end) as ASHA_mobile          
  ,a.Name_Child + (Case when a.Weight <= 2.5 then ''*'' else '''' end)as Child_Name          
  ,dbo.Get_Service_Name(a.Registration_no,1,'''+@Ldate+''') as Services_Given          
  ,dbo.Get_Service_Name(a.Registration_no,0,'''+@Ldate+''') as Services_Due          
  ,(case when '+@HealthFacility_Code+' =0 and '+@HealthBlock_Code+' <> 0 and a.District_ID<>'+@District_Code+' then  1 Else  
   case when '+@HealthSubFacility_Code+'=0 and '+@HealthFacility_Code+' <> 0 and a.HealthBlock_ID<>'+@HealthBlock_Code+' then  1 Else           
   case when '+@Village_Code+'=0 and '+@HealthSubFacility_Code+'<>0 and a.PHC_ID <> '+@HealthFacility_Code+' then 1  else
   case when '+@Village_Code+'<>0 and a.SubCentre_ID <> '+@HealthSubFacility_Code+'  then  1 Else  0 end end end end) as Guest_Ben 
 ,a.Name_Father        
  from t_child_flat a  (nolock)         
  inner join TBL_DISTRICT a1 (nolock) on a.District_ID=a1.DIST_CD    
  inner join TBL_HEALTH_BLOCK e1 (nolock) on a.HealthBlock_ID=e1.BLOCK_CD         
  inner join TBL_PHC b (nolock) on a.PHC_ID=b.PHC_CD          
  left outer join TBL_SUBPHC c (nolock) on a.SubCentre_ID=c.SUBPHC_CD          
  left outer join t_Ground_Staff d (nolock) on a.ANM_ID=d.ID         
  left outer join t_Ground_Staff f (nolock) on a.ASHA_ID=f.ID         
  left outer join TBL_VILLAGE h (nolock) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD        
  where'
if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + '  a.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + '  a.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + '  a.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + '  a.Village_ID='+@Village_Code+''   
end
set @Sql = @Sql + 'and DATEDIFF(month,Birth_Date,'''+@Ldate+''') between 13 and 24          
  and a.Entry_Type = ''Active''                      
  and a.ANM_ID=((Case when '''+@Is_ANMASHA+'''=2 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ANM_ID end))          
  and a.ASHA_ID=((Case when '''+@Is_ANMASHA+'''=1 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ASHA_ID  end) )          
  )B on a.Registration_no=b.Registration_no          
            
  order by Guest_Ben, B.Birth_Date '          
 end          
 else if(@Service_ID = 97) -- No vacc 0 to 2 year          
 begin          
  set @Sql= 'select a1.DIST_NAME_ENG as District_Name,
 e1.Block_Name_E as HealthBlock_Name,
  isnull(b.PHC_NAME,''Direct Entry'') as  PHC_NAME,     
  isnull(c.SUBPHC_NAME_E,''Direct Entry'') as  SubCentre_Name                                 
  ,isnull(h.VILLAGE_NAME,''Direct Entry'') as Village_Name     
  ,a.Registration_no,convert(varchar(10),a.Birth_Date,103)as Birth_Date,(a.Mobile_no) as MobileNo          
  ,a.Address,a.Mother_Reg_no,a.Name_Mother,d.Name as ANM_Name,d.ID as ANM_ID,(d.contact_no) as ANM_mobile          
  ,(case when a.ASHA_ID=0 then ''Not Available'' else f.Name end) as ASHA_Name          
  ,a.ASHA_ID,(case when a.ASHA_ID=0 then ''Not Available'' else (f.Contact_No) end) as ASHA_mobile          
  ,a.Name_Child + (Case when a.Weight <= 2.5 then ''*'' else '''' end)as Child_Name          
  ,dbo.Get_Service_Name(a.Registration_no,1,'''+@Ldate+''') as Services_Given          
  ,dbo.Get_Service_Name(a.Registration_no,0,'''+@Ldate+''') as Services_Due          
  ,(case when '+@HealthFacility_Code+' =0 and '+@HealthBlock_Code+' <> 0 and a.District_ID<>'+@District_Code+' then  1 Else  
   case when '+@HealthSubFacility_Code+'=0 and '+@HealthFacility_Code+' <> 0 and a.HealthBlock_ID<>'+@HealthBlock_Code+' then  1 Else           
   case when '+@Village_Code+'=0 and '+@HealthSubFacility_Code+'<>0 and a.PHC_ID <> '+@HealthFacility_Code+' then 1  else
   case when '+@Village_Code+'<>0 and a.SubCentre_ID <> '+@HealthSubFacility_Code+'  then  1 Else  0 end end end end) as Guest_Ben
 ,a.Name_Father        
  from t_child_flat a  (nolock)          
  inner join t_child_flat_Count e (nolock) on a.Registration_no=e.Registration_no 
  inner join TBL_DISTRICT a1 (nolock) on a.District_ID=a1.DIST_CD
  inner join TBL_HEALTH_BLOCK e1 (nolock) on a.HealthBlock_ID=e1.BLOCK_CD             
  inner join TBL_PHC b (nolock) on a.PHC_ID=b.PHC_CD          
  inner join TBL_SUBPHC c (nolock) on a.SubCentre_ID=c.SUBPHC_CD          
  left outer join t_Ground_Staff d (nolock) on a.ANM_ID=d.ID        
  left outer join t_Ground_Staff f (nolock) on a.ASHA_ID=f.ID          
  left outer join TBL_VILLAGE h (nolock) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD        
  where'
if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + ' e.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + ' e.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' e.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' e.Village_ID='+@Village_Code+''   
end         
set @Sql = @Sql + 'and e.Entry_Type_Active = 1                 
  and DATEDIFF(month,Birth_Date,'''+@Ldate+''')=24          
  and (BCG_Dt_Absent=1 AND opv1_Dt_ABSENT=1 and ((DPT1_dt_absent=1 and HepatitisB1_dt_Absent=1 ) or Penta1_dt_Absent=1)          
  and opv2_dt_ABSENT=1 and ((DPT2_dt_absent=1 and HepatitisB2_dt_Absent=1 ) or Penta2_dt_Absent=1)          
  and opv3_dt_ABSENT=1 and ((DPT3_dt_absent=1 and HepatitisB3_dt_Absent=1 ) or Penta3_dt_Absent=1)          
  and Measles1_Absent=1 and IPV_D1_Dt_Absent=1 and IPV_D2_Dt_Absent=1 and Rota_D1_Dt_Absent=1 and Rota_D2_Dt_Absent=1 and Rota_D3_Dt_Absent=1)          
  and a.ANM_ID=((Case when '''+@Is_ANMASHA+'''=2 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ANM_ID end))          
  and a.ASHA_ID=((Case when '''+@Is_ANMASHA+'''=1 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ASHA_ID  end) )          
  order by Guest_Ben, a.Birth_Date'          
 end          
 else -- BCG,3,4,5(OPV1,2,3),7,8,9(DPT1,2,3),13,14,15(HEP1,2,3),16,17,18(PENTA1,2,3),19(measles)--typeID=0,1(Due,Given)          
 begin          
  
 set @Sql= 'select a1.DIST_NAME_ENG as District_Name
 ,e1.Block_Name_E as HealthBlock_Name,
  isnull(b.PHC_NAME,''Direct Entry'') as  PHC_NAME,         
  isnull(c.SUBPHC_NAME_E,''Direct Entry'') as  SubCentre_Name                                     
  ,isnull(h.VILLAGE_NAME,''Direct Entry'') as Village_Name           
  ,a.Registration_no,convert(varchar(10),a.Birth_Date,103)as Birth_Date,(a.Mobile_no) as MobileNo          
  ,a.Address,a.Mother_Reg_no,a.Name_Mother,d.Name as ANM_Name,d.ID as ANM_ID,(d.contact_no) as ANM_mobile          
  ,(case when a.ASHA_ID=0 then ''Not Available'' else g.Name end) as ASHA_Name          
  ,a.ASHA_ID,(case when a.ASHA_ID=0 then ''Not Available'' else (g.Contact_No) end) as ASHA_mobile          
  ,a.Name_Child + (Case when a.Weight <= 2.5 then ''*'' else '''' end)as Child_Name          
  ,dbo.Get_Service_Name(a.Registration_no,1,'''+@Ldate+''') as Services_Given          
  ,dbo.Get_Service_Name(a.Registration_no,0,'''+@Ldate+''') as Services_Due 
  ,(case when '+@HealthFacility_Code+' =0 and '+@HealthBlock_Code+' <> 0 and a.District_ID<>'+@District_Code+' then  1 Else  
   case when '+@HealthSubFacility_Code+'=0 and '+@HealthFacility_Code+' <> 0 and a.HealthBlock_ID<>'+@HealthBlock_Code+' then  1 Else           
   case when '+@Village_Code+'=0 and '+@HealthSubFacility_Code+'<>0 and a.PHC_ID <> '+@HealthFacility_Code+' then 1  else
   case when '+@Village_Code+'<>0 and a.SubCentre_ID <> '+@HealthSubFacility_Code+'  then  1 Else  0 end end end end) as Guest_Ben
  ,a.Name_Father         
  from t_child_flat a (nolock)           
  inner join TBL_DISTRICT a1 (nolock) on a.District_ID=a1.DIST_CD
  inner join TBL_HEALTH_BLOCK e1 (nolock) on a.HealthBlock_ID=e1.BLOCK_CD            
  inner join TBL_PHC b (nolock) on a.PHC_ID=b.PHC_CD          
  inner join TBL_SUBPHC c (nolock) on a.SubCentre_ID=c.SUBPHC_CD          
  left outer join t_Ground_Staff d (nolock) on a.ANM_ID=d.ID        
  left outer join t_Ground_Staff g (nolock) on a.ASHA_ID=g.ID      
  inner join t_workplanChild f (nolock) on a.Registration_no=f.Registration_no          
  left outer join TBL_VILLAGE h (nolock) on a.Village_ID=h.VILLAGE_CD and a.SubCentre_ID=h.SUBPHC_CD       
  where'            

if(@HealthFacility_Code=0)    
begin    
set @Sql = @Sql + ' a.HealthBlock_ID='+@HealthBlock_Code+''    
end
if(@HealthSubFacility_Code=0 and @HealthFacility_Code<>0)    
begin    
set @Sql = @Sql + ' a.PHC_ID='+@HealthFacility_Code+''    
end
if(@Village_code = 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' a.SubCentre_ID='+@HealthSubFacility_Code+''    
end
if(@Village_code != 0 and @HealthSubFacility_Code != 0)    
begin    
set @Sql = @Sql + ' a.Village_ID='+@Village_Code+''   
end         
set @Sql = @Sql + ' and a.Entry_Type = ''Active''                   
  and f.MinDate<='''+@Ldate+'''         
  and DATEDIFF(month,a.Birth_Date,'''+@Ldate+''')<=12          
  and f.Immu_Code='+@Service_ID+'           
  and flag='+@Type_ID+'           
  and '+@Type_ID+' = (case when 1='+@Type_ID+' then (Case when f.Given_Month='+@Month+' and f.Given_Yr='+@Year+' THEN 1 end)  else 0 end)     -- changed by Pankaj for given(1)                
  and a.ANM_ID=((Case when '''+@Is_ANMASHA+'''=2 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ANM_ID end))          
  and a.ASHA_ID=((Case when '''+@Is_ANMASHA+'''=1 and '+@ANMASHA_ID+'<>0 then '+@ANMASHA_ID+' else a.ASHA_ID  end) )          
  order by Guest_Ben, a.Birth_Date '         
 end  
 exec (@Sql)          
end          
