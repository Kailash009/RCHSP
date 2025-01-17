USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_HealthProvider]    Script Date: 09/26/2024 15:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


    
    
    
    
/*    
    
[MS_Get_HealthProvider] 23 
    
*/    
ALTER procedure [dbo].[MS_Get_HealthProvider]  
(@State_Code int
  
)    
    
as    
    
begin    
declare @s varchar(max),@db varchar(30)    
    
if(@State_Code<=9)    
begin    
set @db ='RCH_0'+CAST(@State_Code AS VARCHAR)    
end    
else    
begin    
set @db ='RCH_'+CAST(@State_Code AS VARCHAR)    
end   

IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
    
SET @s='Select b.StateName as StateName,c.DIST_NAME_ENG as District,d.Block_Name_E as Block,e.PHC_NAME as HealthFacility
,f.SUBPHC_NAME_E as HealthSubFacility,g.VILLAGE_NAME as Village,a.ID,h.Name,h.Contact_No,a.Created_On as StartDate,a.InActive_Date as EndDate 
from '+@db+'.dbo.t_Ground_Staff_Mapping a
inner join '+@db+'.dbo.t_Ground_Staff h on a.ID=h.ID
inner join '+@db+'.dbo.TBL_State b on a.State_Code=b.StateID
inner join '+@db+'.dbo.TBL_DISTRICT c on a.District_Code=c.DIST_CD
inner join '+@db+'.dbo.TBL_HEALTH_BLOCK d on a.HealthBlock_Code=d.BLOCK_CD
inner join '+@db+'.dbo.TBL_PHC e on a.HealthFacilty_Code=e.PHC_CD
left outer join '+@db+'.dbo.TBL_SUBPHC f on a.HealthSubFacility_Code=f.SUBPHC_CD
left outer join '+@db+'.dbo.TBL_VILLAGE g on a.HealthSubFacility_Code=g.SUBPHC_CD and a.Village_Code=g.VILLAGE_CD
where h.Type_ID in (1,2)      
'    
exec(@s)    
   end  
    
  else
begin
select 'DB' as ID,'' as Contact_No
end  
    
END      
    
    
    
    
    
  

