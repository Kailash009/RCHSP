USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[Sp_ANM_LOG_Services]    Script Date: 09/26/2024 15:49:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
exec [Sp_ANM_LOG_Services] 65,12,12,'dfhfgj'  
*/  
ALTER procedure [dbo].[Sp_ANM_LOG_Services](      
      
@ANM_ID int,       
@Total_Records int ,    
@Record_updated int,    
@Error nvarchar(max)      
)      
      
As      
begin    
      
insert into [MS_ANM_Log_Services]      
 ([ANM_ID],[Total_Records],[Record_Updated],[Error],[ExeDate])   
  values(@ANM_ID,@Total_Records,@Record_updated,@Error ,GETDATE())    
     
END 
