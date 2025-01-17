USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_mother_HighRisk]    Script Date: 09/26/2024 14:50:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[tp_mother_HighRisk]    
(    
@Registration_no bigint=0,  
@Case_no int  
)   
 
as    
begin    
  SET NOCOUNT ON;
select Symptoms_High_Risk from t_mother_anc with (nolock) where Registration_no=@Registration_no and Case_no= @Case_no   
and Symptoms_High_Risk is not null and Symptoms_High_Risk <>'' and  Symptoms_High_Risk<>'0'  
and Symptoms_High_Risk <>'Y'    
end   
    