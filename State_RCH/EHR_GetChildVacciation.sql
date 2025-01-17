USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[EHR_GetChildVacciation]    Script Date: 09/26/2024 15:26:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*          
[EHR_GetChildVacciation] 230000000001     

[EHR_GetChildVacciation] 130000000648    
*/          
ALTER Procedure [dbo].[EHR_GetChildVacciation]          
(
@Registration_no as  bigint         
)          
as          
Begin          
          
Declare @Date datetime


declare @Birthdate as datetime          
declare @BCG_Dt as Datetime          
declare @OPV0_Dt as datetime   
declare @HepatitisB0_Dt as datetime           
declare @HepatitisB1_Dt as datetime          
declare @DPT1_Dt as datetime          
declare @OPV1_Dt as datetime          
declare @HepatitisB2_Dt as datetime          
declare @DPT2_Dt as datetime          
declare @OPV2_Dt as datetime          
declare @HepatitisB3_Dt as datetime          
declare @DPT3_Dt as datetime          
declare @OPV3_Dt as datetime          
declare @HepatitisB4_Dt as datetime          
declare @Measles_Dt as datetime          
declare @VitA_Dose1_Dt as datetime          
declare @MR_Dt as datetime          
declare @DPTBooster_Dt as datetime          
declare @OPVBooster_Dt as datetime          
declare @VitA_Dose2_Dt as datetime          
declare @VitA_Dose3_Dt as datetime          
declare @JE_Dt as datetime          
declare @VitA_Dose4_Dt as datetime          
declare @VitA_Dose5_Dt as datetime          
declare @VitA_Dose6_Dt as datetime          
declare @VitA_Dose7_Dt as datetime          
declare @VitA_Dose8_Dt as datetime          
declare @VitA_Dose9_Dt as datetime          
declare @DT5_Dt as datetime          
declare @TT10_Dt as datetime          
declare @TT16_Dt as datetime          

  select @Birthdate=Birth_Date
  ,@BCG_Dt=BCG_Dt
  ,@OPV0_Dt=OPV0_Dt
  ,@HepatitisB0_Dt=HepatitisB0_Dt
   ,@HepatitisB1_Dt=HepatitisB1_Dt
   ,@DPT1_Dt=DPT1_dt
   ,@OPV1_Dt= OPV1_Dt
   ,@HepatitisB2_Dt =  HepatitisB2_Dt     
   ,@DPT2_Dt=DPT2_dt      
   ,@OPV2_Dt=OPV2_Dt  
   ,@HepatitisB3_Dt= HepatitisB3_Dt         
   ,@DPT3_Dt=DPT3_dt
   ,@OPV3_Dt=OPV3_Dt      
   ,@Measles_Dt=Measles1_Dt        
   ,@VitA_Dose1_Dt=VitA_Dose1_Dt     
   ,@MR_Dt=MR_Dt      
   ,@DPTBooster_Dt=DPTBooster1_Dt         
   ,@OPVBooster_Dt=OPVBooster_Dt         
   ,@VitA_Dose2_Dt=VitA_Dose2_Dt       
   ,@VitA_Dose3_Dt=VitA_Dose3_Dt               
   ,@JE_Dt=JE1_dt
   ,@VitA_Dose4_Dt=VitA_Dose4_Dt
  ,@VitA_Dose5_Dt=VitA_Dose5_Dt        
   ,@VitA_Dose6_Dt=VitA_Dose6_Dt            
   ,@VitA_Dose7_Dt=VitA_Dose7_Dt            
   ,@VitA_Dose8_Dt=VitA_Dose8_Dt          
   ,@VitA_Dose9_Dt=VitA_Dose9_Dt           
   from t_child_flat where Mother_Reg_no=@Registration_no    
          
      
          
          
           
 SELECT convert(varchar(25), ServiceName_Min) as Immunization_Name ,CONVERT(varchar(20), ServiceDate_Min,107)  as Immunization_Date, (case when ServiceDate_Min IS not null  then 'Completed' else 'Not Completed' end)   as [Status]       
  FROM              
  (SELECT           
@BCG_Dt as BCG,          
@OPV0_Dt as OPV0,          
@HepatitisB1_Dt as [HepatitisB BIRTH DOSE]  ,          
@DPT1_Dt as DPT1 ,          
@OPV1_Dt as OPV1 ,          
@HepatitisB2_Dt as [Hepatitis-B1] ,          
@DPT2_Dt as DPT2 ,          
@OPV2_Dt as OPV2 ,          
@HepatitisB3_Dt as [Hepatitis-B2] ,          
@DPT3_Dt as DPT3 ,          
@OPV3_Dt as OPV3 ,          
@HepatitisB4_Dt as [Hepatitis-B3] ,          
@Measles_Dt as Measles ,          
@VitA_Dose1_Dt as [VitA Dose-1] ,                  
@DPTBooster_Dt as [DPT Booster-1] ,          
@OPVBooster_Dt as [OPV Booster] , 
--@MR_Dt as [MR Vaccination], 
--@JE_Dt as [JE Vaccination] ,              
@VitA_Dose2_Dt as [VitA Dose-2] ,          
@VitA_Dose3_Dt as [VitA Dose-3],                 
@VitA_Dose4_Dt as [VitA Dose-4] ,          
@VitA_Dose5_Dt as [VitA Dose-5] ,          
@VitA_Dose6_Dt as [VitA Dose-6],          
@VitA_Dose7_Dt as [VitA Dose-7] ,          
@VitA_Dose8_Dt as [VitA Dose-8] ,          
@VitA_Dose9_Dt as [VitA Dose-9],          
@DT5_Dt as [DPT Booster-2] ,          
@TT10_Dt as TT10 ,          
@TT16_Dt as TT16          
) p              
UNPIVOT              
(          
ServiceDate_min FOR ServiceName_min IN (          
BCG ,          
OPV0,          
[HepatitisB BIRTH DOSE] ,          
DPT1 ,          
OPV1 ,          
[Hepatitis-B1]  ,          
DPT2,          
OPV2 ,          
[Hepatitis-B2] ,          
DPT3 ,          
OPV3 ,          
[Hepatitis-B3] ,          
Measles ,
[VitA Dose-1],
[DPT Booster-1],
[OPV Booster] ,
--[MR Vaccination] , 
--[JE Vaccination],       
[VitA Dose-2] ,                  
[VitA Dose-3] ,          
[VitA Dose-4] ,          
[VitA Dose-5] ,           
[VitA Dose-6] ,                   
[VitA Dose-7] ,            
[VitA Dose-8] ,            
[VitA Dose-9] ,         
[DPT Booster-2],         
TT10 ,          
TT16           
)          
) as unpvt            
          

          
End
---------------------------------------
