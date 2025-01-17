USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_children_tracking_medical_BindData]    Script Date: 09/26/2024 15:43:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
/*       
[tp_children_tracking_medical_BindData] 27,26,'R',84,'0252',1,274,1622,32155,227000695812,10
[tp_children_tracking_medical_BindData] 229004699508,19      
*/      
       
ALTER proc [dbo].[tp_children_tracking_medical_BindData]        
(        
--@State_Code int          
--,@District_Code int          
--,@Rural_Urban char(1)          
--,@HealthBlock_Code int          
--,@Taluka_Code varchar(6)          
--,@HealthFacility_Type int          
--,@HealthFacility_Code int          
--,@HealthSubFacility_Code int          
--,@Village_Code int        
  @Registration_no bigint      
  ,@Immu_code int       
)        
as        
begin        
SET NOCOUNT ON        
        select         
        SNo,      
        Registration_no      
        ,Immu_code        
      --(case Immu_code when '10' then 'DPT-B1' when '19' then 'MEASLES-1' when '44' then 'MR-1' else '''' end) as Immu_code        
      ,[Visit_Date]      
      ,[Child_Weight]      
      ,(case [Diarrhoea] when '1' then 'Yes' when '2' then 'No' else '''' end) as [Diarrhoea]      
      ,(case [Pneumonia] when '1' then 'Yes' when '2' then 'No' else '''' end) as [Pneumonia]      
      ,b.Name as ANM_Name  
      ,(case when c.[Name] is null then 'Not Available' else c.[Name] end) as ASHA_Name      
     from t_children_tracking_medical a (nolock)  
     Left outer join t_Ground_Staff b WITH (NOLOCK) on a.ANM_ID=b.ID      
     Left outer join t_Ground_Staff c WITH (NOLOCK) on a.ASHA_ID=c.ID           
     where         
       --State_Code=@State_Code and        
    --District_Code=@District_Code and          
    --Rural_Urban=@Rural_Urban and         
    --HealthBlock_Code=@HealthBlock_Code and         
    --Taluka_Code=@Taluka_Code and           
    --HealthFacility_Type=@HealthFacility_Type and         
    --HealthFacility_Code=@HealthFacility_Code and           
    --HealthSubFacility_Code=@HealthSubFacility_Code and           
    --Village_Code=@Village_Code and         
    Registration_no=@Registration_no       
    and Immu_code = @Immu_code       
        
end        
        
        