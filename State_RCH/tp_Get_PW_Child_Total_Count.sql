USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_Get_PW_Child_Total_Count]    Script Date: 09/26/2024 15:43:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  --tp_Get_PW_Child_Total_Count 22,0,0,'','',0,0    
ALTER Proc [dbo].[tp_Get_PW_Child_Total_Count]                                                          
(                                                                                                            
@District_Code int ,   
@Block_Code int,                                                       
@Village_Code int = 0 ,                                                    
@Temp_Reg_No  int =0,                                                    
@From_Date  varchar(25)='',                                                    
@To_Date varchar(25)='',                                                    
@ANMType_ID int = 0,                                                    
@Is_MCTSRCH int =0                                                                                                           
 )                                                        
as                           
                                                                   
begin                                  
if(@Is_MCTSRCH = 0)-- for Rural                                
     begin                                                
   select 'Pregnant Woman' as Name,count(1) Total_Count,  
      sum(case when isnull(Verified_Status,0)=1 then 1 else 0 end) Total_Verified ,  
   sum(case when (isnull(Verified_Status,0)=2 or isnull(Verified_Status,0)=99) then 1 else 0 end) Total_Rejected,  
   sum(case when (isnull(Verified_Status,0)=3 and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) >= 0) then 1 else 0 end) Total_Forwared ,  
   sum(case when isnull(Verified_Status,0)=4 then 1 else 0 end) Total_Linked,  
   sum(case when (isnull(Verified_Status,0)=0 and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) >= 0) then 1 else 0 end) Total_Unverified,  
   sum(case when ((isnull(Verified_Status,0)=0 or isnull(Verified_Status,0)=3) and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) < 0) then 1 else 0 end) Forwarded_MOIC  
   from t_Citizen_Mother_Registration (nolock)   
        where (DistrictCode=@District_Code)    
       and (New_HealthBlock_Code = @Block_Code)                    
       and (New_Village_Code = @Village_Code or @Village_Code=0)              
       and (Citizen_Reg_No = @Temp_Reg_No or @Temp_Reg_No =0) and ((CONVERT(date,Created_On) between @From_Date and @To_Date) or (@From_Date = '' and @To_Date = '')) and                                                      
       (New_ANM_ID = @ANMType_ID or @ANMType_ID =0)   
       --and Created_By = 'Self' 
       and Source_Id = 0   
         union all  
       Select 'Child' as Name,count(1) Total_Count,  
      sum(case when isnull(Verified_Status,0)=1 then 1 else 0 end) Total_Verified ,  
   sum(case when (isnull(Verified_Status,0)=2 or isnull(Verified_Status,0)=99) then 1 else 0 end) Total_Rejected,  
   sum(case when (isnull(Verified_Status,0)=3 and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) >= 0) then 1 else 0 end) Total_Forwared ,  
   sum(case when isnull(Verified_Status,0)=4 then 1 else 0 end) Total_Linked,  
   sum(case when (isnull(Verified_Status,0)=0 and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) >= 0) then 1 else 0 end) Total_Unverified,  
   sum(case when ((isnull(Verified_Status,0)=0 or isnull(Verified_Status,0)=3) and DATEDIFF(day,cast(GETDATE() as date),DATEADD(DAY,2,cast(Created_On as date))) < 0) then 1 else 0 end) Forwarded_MOIC  
   from t_Citizen_Child_Registration (nolock)     
       where (DistrictCode=@District_Code)   
       and (New_HealthBlock_Code = @Block_Code)                     
       and (New_Village_Code = @Village_Code or @Village_Code=0)              
       and (Citizen_Reg_No = @Temp_Reg_No or @Temp_Reg_No =0) and ((CONVERT(date,Created_On) between @From_Date and @To_Date) or (@From_Date = '' and @To_Date = '')) and                                                      
       (New_ANM_ID = @ANMType_ID or @ANMType_ID =0)  
       --and Created_By = 'Self' 
       and Source_Id = 0                                                                                                                          
     end                                                                                                                                                             
End   
  
  
