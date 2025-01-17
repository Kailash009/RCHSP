USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[USSD_Table_Mother_Update]    Script Date: 09/26/2024 14:53:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Script for SelectTopNRows command from SSMS  ******/

  ALTER procedure [dbo].[USSD_Table_Mother_Update]
  as
  begin
  
 if exists( select * from t_mother_anc ma
  left outer join [USSD_Table_Mother] um on ma.Registration_no=um.PW_id 
  where SourceID=1 and( (CONVERT(date,um.Ason_date,103)=CONVERT(date,ma.Created_On ,103)) or (CONVERT(date,um.Ason_date,103)=CONVERT(date,ma.Updated_On,103))  )
  )
  begin
  
  update [USSD_Table_Mother]
  set update_flag=1
  from t_mother_anc ma
where [USSD_Table_Mother].PW_id=ma.Registration_no  
  and  ma.SourceID=1 and ( (CONVERT(date,USSD_Table_Mother.Ason_date,103)=CONVERT(date,ma.Created_On ,103)) or (CONVERT(date,USSD_Table_Mother.Ason_date,103)=CONVERT(date,ma.Updated_On,103))  )
   
  
  end
  
  
  
  
  end
  
  --create procedure  
  
  
  
  
  --SELECT TOP 1000 [ID_No]
  --    ,[Service_Date]
  --    ,[Service_Type]
  --    ,[Anemia]
  --    ,[Application_Type]
  --    ,[USERID]
  --    ,[Exec_Date]
  --    ,[Updation_Count]
  --    ,[Proc_run_Date]
  --    ,[GF_ID]
  --FROM [MCR_01].[dbo].[USSD_Mother_Record_Updation]


