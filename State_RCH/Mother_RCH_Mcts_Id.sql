USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Mother_RCH_Mcts_Id]    Script Date: 09/26/2024 12:13:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

                      
/*                      
[Mother_RCH_Mcts_Id] 28,0,0,0,0,0,2015,0,0,'','','State','1'                              
[Mother_RCH_Mcts_Id] 16,2,9,63,0,0,0,'PHC','160600100511400017'              
*/                      
                      
ALTER procedure [dbo].[Mother_RCH_Mcts_Id]                      
(                      
@State_Code int=0,                        
@District_Code int=0,                        
@HealthBlock_Code int=0,                        
@HealthFacility_Code int=0,                        
@HealthSubFacility_Code int=0,                      
@Village_Code int=0,                      
@FinancialYr int,                                             
@Category varchar(20) ='District',  
@Mcts_Id varchar(50) = ''                     
)                      
as                      
begin                      
                      
declare @daysPast as int,@BeginDate as date,@Daysinyear int                      
                      
--set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)                      
--set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)                      
--set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)                      
                      
      
--if(@Category='National')                        
--begin                        
-- exec RCH_Reports.dbo.AC_Child_Count @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,                        
-- @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category,@Type                      
--end   
if(@Mcts_Id<>'' and @Mcts_Id<>'0')  
begin  
     select  A.State_Code, isnull(A.HealthSubFacility_Code,0) as  ParentID,isnull(A.Village_Code,0) as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName                    
     ,isnull(A.RCH_Id,0) as RCH_Id,isnull(A.MCTS_Id,'0') as MCTS_Id,Name_wife,Name_husband from (select c.StateID as State_Code,    
     c.SubCentre_ID as HealthSubFacility_Code,c.Village_ID as Village_Code , b.SUBPHC_NAME_E as HealthSubFacility_Name,                    
     isnull(a.VILLAGE_NAME,'Direct Entry') as VILLAGE_NAME ,c.Registration_no as RCH_Id,c.ID_No as MCTS_Id                      
     ,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from t_mother_flat c                       
     left outer join   TBL_SUBPHC b on b.SUBPHC_CD=c.SubCentre_ID                    
     left outer join   TBL_VILLAGE a on a.VILLAGE_CD=c.Village_ID and a.SUBPHC_CD=c.SubCentre_ID                    
     left outer join  Health_SC_Village d on d.VCode=c.Village_ID and d.SID=c.SubCentre_ID                    
     where  ltrim(c.ID_No) = @Mcts_Id) A  
end                     
else if(@Category='State')                        
begin                         
       select c.StateID as ParentID,isnull(a.DIST_CD,0) as ChildID,b.StateName as ParentName,a.DIST_NAME_ENG as ChildName,c.Registration_no as     
       RCH_Id,c.ID_No as MCTS_Id ,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from   TBL_DISTRICT a                       
       inner join TBL_STATE b on a.StateID=b.StateID                      
       inner join  t_mother_flat c on a.DIST_CD=c.District_ID                      
       where (c.EC_Yr=@FinancialYr or 0=@FinancialYr) and len(c.ID_No)>0 and ltrim(c.ID_No) != ''      
       and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0) and (c.Facility_ID=@HealthFacility_Code or @HealthFacility_Code=0)                   
       and(SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and (c.Village_ID=@Village_Code or @Village_Code=0)                      
                      
end                      
else if(@Category='District')                        
begin                          
                            
       select b.StateID as ParentID,  isnull(b.DIST_CD,0) as District_Code,b.DIST_NAME_ENG as ParentName,isnull(a.BLOCK_CD,0) as ChildID,    
       a.Block_Name_E as ChildName, c.Registration_no as RCH_Id,c.ID_No as MCTS_Id                      
       ,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from TBL_HEALTH_BLOCK a                       
       inner join   TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD                       
       inner join  t_mother_flat c on a.BLOCK_CD=c.HealthBlock_ID                      
       where (c.EC_Yr=@FinancialYr or 0=@FinancialYr) and len(c.ID_No)>0 and ltrim(c.ID_No) != '' and (a.DISTRICT_CD=@District_Code or @District_Code=0)    
       and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0) and (c.Facility_ID=@HealthFacility_Code or @HealthFacility_Code=0)                   
       and(SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and (c.Village_ID=@Village_Code or @Village_Code=0)           
                    
end                      
                    
else if(@Category='Block')                        
begin                        
    select c.StateID as State_Code, isnull(b.BLOCK_CD,0) as ParentID,b.Block_Name_E as ParentName,isnull(a.PHC_CD,0) as ChildID,    
    a.PHC_NAME as ChildName, c.Registration_no as RCH_Id,c.ID_No as MCTS_Id                      
    ,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from TBL_PHC a                       
    inner join   TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD                       
    inner join  t_mother_flat c on a.PHC_CD=c.PHC_ID                      
    where (c.EC_Yr=@FinancialYr or 0=@FinancialYr) and len(c.ID_No)>0 and ltrim(c.ID_No) != ''     
    and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0) and (c.Facility_ID=@HealthFacility_Code or @HealthFacility_Code=0)                   
    and(SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and (c.Village_ID=@Village_Code or @Village_Code=0)                      
                       
 end                       
else if(@Category='PHC')                        
begin                        
      select isnull(c.StateID,0) as State_Code,isnull(b.PHC_CD,0) as ParentID,isnull(b.PHC_NAME,0) as ParentName,
      isnull(a.SUBPHC_CD,0) as ChildID,isnull(a.SUBPHC_NAME_E,'Direct Entry') as ChildName ,c.Registration_no as RCH_Id,
      c.ID_No as MCTS_Id,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from TBL_SUBPHC a                       
      inner join   TBL_PHC b on a.PHC_CD=b.PHC_CD                       
      inner join  t_mother_flat c on a.SUBPHC_CD=c.SubCentre_ID                      
      where (c.EC_Yr=@FinancialYr or 0=@FinancialYr) and len(c.ID_No)>0 and ltrim(c.ID_No) != ''     
      and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0) and (c.PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)                   
      and(SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and (c.Village_ID=@Village_Code or @Village_Code=0)                     
                     
 end                        
else if(@Category='SubCentre')                        
begin                     
                    
     select c.StateID as State_Code,    
     isnull(c.SubCentre_ID,0) as ParentID,isnull(c.Village_ID,0) as ChildID , isnull(b.SUBPHC_NAME_E,'') as ParentName,                    
     isnull(a.VILLAGE_NAME,'Direct Entry') as ChildName ,c.Registration_no as RCH_Id,c.ID_No as MCTS_Id                      
     ,isnull(c.Name_wife,'') as Name_wife,isnull(c.Name_husband,'') as Name_husband from t_mother_flat c                       
     left outer join   TBL_SUBPHC b on b.SUBPHC_CD=c.SubCentre_ID                    
     left outer join   TBL_VILLAGE a on a.VILLAGE_CD=c.Village_ID and a.SUBPHC_CD=c.SubCentre_ID                    
     left outer join  Health_SC_Village d on d.VCode=c.Village_ID and d.SID=c.SubCentre_ID                    
     where len(c.ID_No)>0 and ltrim(c.ID_No) != '' and (c.EC_Yr=@FinancialYr or @FinancialYr=0)    
     and (c.HealthBlock_ID=@HealthBlock_Code or @HealthBlock_Code=0) and (c.PHC_ID=@HealthFacility_Code or @HealthFacility_Code=0)                   
     and(SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0) and (c.Village_ID=@Village_Code or @Village_Code=0)                  
 end                        
                      
end
