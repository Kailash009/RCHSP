USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_All_villege_In_State]    Script Date: 09/26/2024 15:50:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
exec [MS_All_villege_In_State] 31
**/
ALTER procedure [dbo].[MS_All_villege_In_State]
@State_code int
as
begin
SET NOCOUNT ON 
declare @s varchar(max),@db varchar(50)      
if(@State_code <=9)      
begin      
set @db='RCH_0'+CAST(@State_code AS VARCHAR)      
end      
else       
begin      
set @db='RCH_'+CAST(@State_Code AS VARCHAR)      
end  

IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
set @s='select d.StateID as StateCode,
      a.DCode as DistrictCode,
      a.VCode as VillageCode,
      a.Name_E as VillageName,
      a.MDDS_Code as MDDSCode
      from 
      '+cast(@db as varchar)+'.dbo.Cen_Village a
      inner join
      '+cast(@db as varchar)+'.dbo.District d
      on a.DCode=d.DCode
      where d.StateID='+CAST(@State_Code AS VARCHAR)+''
      
 
end

else	
begin
set @s='select 0 as StateCode'
				    
end


--print(@s) 
exec(@s)  
end

