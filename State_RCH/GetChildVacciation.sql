USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[GetChildVacciation]    Script Date: 09/26/2024 12:04:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/*          
GetChildVacciation '11/09/2012'          
*/          
ALTER PROCEDURE [dbo].[GetChildVacciation]          
(@DOB as varchar(10)          
)          
as          
Begin          
          
declare @Birthdate as datetime          
declare @BCG_Dt as Datetime          
declare @OPV0_Dt as datetime          
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
          
          
declare @BCG_Dt_M as Datetime          
declare @OPV0_Dt_M as datetime          
declare @HepatitisB1_Dt_M as datetime          
declare @DPT1_Dt_M as datetime          
declare @OPV1_Dt_M as datetime          
declare @HepatitisB2_Dt_M as datetime          
declare @DPT2_Dt_M as datetime          
declare @OPV2_Dt_M as datetime          
declare @HepatitisB3_Dt_M as datetime          
declare @DPT3_Dt_M as datetime          
declare @OPV3_Dt_M as datetime          
declare @HepatitisB4_Dt_M as datetime          
declare @Measles_Dt_M as datetime          
declare @VitA_Dose1_Dt_M as datetime          
declare @MR_Dt_M as datetime          
declare @DPTBooster_Dt_M as datetime          
declare @OPVBooster_Dt_M as datetime          
declare @VitA_Dose2_Dt_M as datetime          
declare @VitA_Dose3_Dt_M as datetime          
declare @JE1_Dt as datetime
declare @JE1_Dt_M as datetime
declare @JE2_Dt as datetime
declare @JE2_Dt_M as datetime         
declare @VitA_Dose4_Dt_M as datetime          
declare @VitA_Dose5_Dt_M as datetime          
declare @VitA_Dose6_Dt_M as datetime          
declare @VitA_Dose7_Dt_M as datetime          
declare @VitA_Dose8_Dt_M as datetime          
declare @VitA_Dose9_Dt_M as datetime          
declare @DT5_Dt_M as datetime          
declare @TT10_Dt_M as datetime          
declare @TT16_Dt_M as datetime    
declare @DPTBooster2_Dt as datetime
declare @DPTBooster2_Dt_M as datetime
          
set @Birthdate=CONVERT(datetime ,@DOB,103)           
          
set @BCG_Dt=@Birthdate          
set @BCG_Dt_M =DATEADD(day,365,@Birthdate)          
          
set @OPV0_Dt=@Birthdate          
set @OPV0_Dt_M =DATEADD(day,14,@Birthdate)          
          
set @HepatitisB1_Dt=@Birthdate          
set @HepatitisB1_Dt_M =DATEADD(day,1,@Birthdate)          
          
set @DPT1_Dt=DATEADD(day,42,@Birthdate)          
set @DPT1_Dt_M =DATEADD(day,365,@Birthdate)          
          
set @OPV1_Dt=DATEADD(day,42,@Birthdate)          
set @OPV1_Dt_M =dateadd(month,59,@Birthdate)          
          
set @HepatitisB2_Dt=DATEADD(day,42,@Birthdate)          
set @HepatitisB2_Dt_M =DATEADD(month,11,@Birthdate)          
          
set @DPT2_Dt=DATEADD(day,70,@Birthdate)-- DPT1 should be given          
set @DPT2_Dt_M =dateadd(month,83,@Birthdate)          
          
set @OPV2_Dt=DATEADD(day,70,@Birthdate)-- [OPV-1] should be given          
set @OPV2_Dt_M =dateadd(month,59,@Birthdate)          
          
set @HepatitisB3_Dt=DATEADD(day,70,@Birthdate)-- HB2 should be given          
set @HepatitisB3_Dt_M =DATEADD(month,11,@Birthdate)          
          
set @DPT3_Dt=DATEADD(day,98,@Birthdate)-- DPT2 should be given          
set @DPT3_Dt_M =dateadd(month,83,@Birthdate)          
          
          
set @OPV3_Dt=DATEADD(day,98,@Birthdate)-- OPV2 should be given          
set @OPV3_Dt_M =dateadd(month,59,@Birthdate)          
          
set @HepatitisB4_Dt=DATEADD(day,98,@Birthdate)-- HB3 should be given          
set @HepatitisB4_Dt_M =DATEADD(month,11,@Birthdate)          
          
set @Measles_Dt=dateadd(month,9,@Birthdate)          
set @Measles_Dt_M =dateadd(month,12,@Birthdate)          
          
set @VitA_Dose1_Dt=dateadd(month,9,@Birthdate)         
set @VitA_Dose1_Dt_M =dateadd(month,60,@Birthdate)          
          
set @MR_Dt=dateadd(month,16,@Birthdate)-- Measles1 Should be given and there should be a gap of one month between measles and MMR          
set @MR_Dt_M =dateadd(month,24,@Birthdate)          
          
set @DPTBooster_Dt=dateadd(month,16,@Birthdate)-- DPT3 should be given and there should be a gap of 6 months between DPT3 and DPTBooster          
set @DPTBooster_Dt_M=dateadd(month,24,@Birthdate)          
          
set @OPVBooster_Dt=dateadd(month,16,@Birthdate)-- OPV3 should be given and there should be a gap of 6 months between [OPV-3] and OPVBooster          
set @OPVBooster_Dt_M =dateadd(month,24,@Birthdate)          

set @DPTBooster2_Dt=dateadd(year,5,@Birthdate)-- added new column
set @DPTBooster2_Dt_M=dateadd(year,6,@Birthdate)
        
set @VitA_Dose2_Dt=dateadd(month,18,@Birthdate)---Vit 1 dose should be given and there should be a gap of 6 months between Vit1 and Vit2          
set @VitA_Dose2_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @VitA_Dose3_Dt=dateadd(month,24,@Birthdate)---Vit 2 dose should be given and there should be a gap of 6 months between Vit2 and Vit3          
set @VitA_Dose3_Dt_M =dateadd(month,60,@Birthdate)          
          
set @JE1_Dt=dateadd(month,9,@Birthdate)          
set @JE1_Dt_M =dateadd(month,16,@Birthdate)
      
set @JE2_Dt=dateadd(month,16,@Birthdate)          
set @JE2_Dt_M =dateadd(month,24,@Birthdate)          
          
          
set @VitA_Dose4_Dt=dateadd(month,30,@Birthdate)---Vit 3 dose should be given and there should be a gap of 6 months between Vit3 and Vit4          
set @VitA_Dose4_Dt_M =dateadd(month,60,@Birthdate)          
          
set @VitA_Dose5_Dt=dateadd(month,36,@Birthdate)---Vit 4 dose should be given and there should be a gap of 6 months between Vit4 and Vit5          
set @VitA_Dose5_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @VitA_Dose6_Dt=dateadd(month,42,@Birthdate)---Vit 5 dose should be given and there should be a gap of 6 months between Vit5 and Vit6          
set @VitA_Dose6_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @VitA_Dose7_Dt=dateadd(month,48,@Birthdate)---Vit 6 dose should be given and there should be a gap of 6 months between Vit6 and Vit7          
set @VitA_Dose7_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @VitA_Dose8_Dt=dateadd(month,54,@Birthdate)---Vit 7 dose should be given and there should be a gap of 6 months between Vit7 and Vit8          
set @VitA_Dose8_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @VitA_Dose9_Dt=dateadd(month,59,@Birthdate)---Vit 8 dose should be given and there should be a gap of 6 months between Vit8 and Vit9          
set @VitA_Dose9_Dt_M =dateadd(month,60,@Birthdate)          
          
          
set @DT5_Dt=DATEADD(month,60,@Birthdate)          
set @DT5_Dt_M =dateadd(month,83,@Birthdate)          
          
          
set @TT10_Dt=DATEADD(month,120,@Birthdate)          
set @TT10_Dt_M =dateadd(month,191,@Birthdate)          
          
set @TT16_Dt=DATEADD(month,192,@Birthdate)          
set @TT16_Dt_M =dateadd(month,204,@Birthdate)          
          
select p.ImmuCode,p.ImmuName ,C.ServiceDate_min,C.ServiceDate_Max from (
(select ImmuCode,ImmuName from m_ImmunizationName) p
inner join
(select A.ServiceName_Min,A.ServiceDate_min,B.ServiceDate_Max from (       
       
(SELECT row_number()over (order by ServiceName_Min) SNO, convert(varchar(30), ServiceName_Min) as ServiceName_Min , ServiceDate_Min            
  FROM              
  (SELECT           
@BCG_Dt BCG,          
@OPV0_Dt [OPV-0],          
 @HepatitisB1_Dt [HEP B-0]  ,          
 @DPT1_Dt  [DPT-1] ,          
 @OPV1_Dt [OPV-1] ,          
 @HepatitisB2_Dt [HEP B-1] ,          
@DPT2_Dt [DPT-2] ,          
 @OPV2_Dt [OPV-2] ,          
@HepatitisB3_Dt [HEP B-2] ,          
 @DPT3_Dt [DPT-3] ,          
 @OPV3_Dt [OPV-3] ,          
 @HepatitisB4_Dt [HEP B-3] ,          
@Measles_Dt [MEASLES-1] ,          
 @VitA_Dose1_Dt [VITAMIN A-1] ,
 --@MR_Dt AS MR ,                 
 @DPTBooster_Dt [DPT-B1] ,          
 @OPVBooster_Dt [OPV-B] ,
 @JE1_Dt [JE VACCINE-1],
  @JE2_Dt [JE VACCINE-2],         
@VitA_Dose2_Dt [VITAMIN A-2] ,          
@VitA_Dose3_Dt [VITAMIN A-3],                 
@VitA_Dose4_Dt [VITAMIN A-4] ,          
@VitA_Dose5_Dt [VITAMIN A-5] ,          
@VitA_Dose6_Dt [VITAMIN A-6],          
@VitA_Dose7_Dt [VITAMIN A-7] ,          
@VitA_Dose8_Dt [VITAMIN A-8] ,          
@VitA_Dose9_Dt [VITAMIN A-9],          
@DT5_Dt [DPT-B2]           
        
) p              
UNPIVOT              
(          
ServiceDate_min FOR ServiceName_min IN (          
BCG ,          
[OPV-0],          
[HEP B-0] ,          
[DPT-1] ,          
[OPV-1] ,          
 [HEP B-1]  ,          
[DPT-2],          
[OPV-2] ,          
 [HEP B-2] ,          
 [DPT-3] ,          
[OPV-3] ,          
[HEP B-3] ,          
 [MEASLES-1] ,          
[VITAMIN A-1] ,
--MR,                  
 [DPT-B1] ,          
[OPV-B] ,
[JE VACCINE-1] , 
[JE VACCINE-2] ,       
 [VITAMIN A-2] ,          
 [VITAMIN A-3],                  
[VITAMIN A-4] ,          
[VITAMIN A-5] ,          
[VITAMIN A-6] ,          
[VITAMIN A-7] ,          
 [VITAMIN A-8] ,          
[VITAMIN A-9] ,          
[DPT-B2]           
          
)          
) as unpvt  where ServiceDate_min<=GETDATE() ) A
left outer join
(  
SELECT    convert(varchar(30), ServiceName_Max) as ServiceName_Max , ServiceDate_Max            
  FROM            
(SELECT          
@BCG_Dt_M as  BCG ,          
 @OPV0_Dt_M  as [OPV-0] ,          
 @HepatitisB1_Dt_M  as [HEP B-0] ,          
 @DPT1_Dt_M as  [DPT-1] ,          
 @OPV1_Dt_M as [OPV-1] ,          
 @HepatitisB2_Dt_M  as [HEP B-1] ,          
 @DPT2_Dt_M as [DPT-2] ,          
 @OPV2_Dt_M as  [OPV-2] ,          
 @HepatitisB3_Dt_M as  [HEP B-2] ,          
 @DPT3_Dt_M as [DPT-3] ,          
 @OPV3_Dt_M as  [OPV-3] ,          
 @HepatitisB4_Dt_M as [HEP B-3] ,          
@Measles_Dt_M as [MEASLES-1] ,          
         
@VitA_Dose1_Dt_M as [VITAMIN A-1], 
--@MR_Dt_M AS MR ,    
@DPTBooster_Dt_M as [DPT-B1] ,          
@OPVBooster_Dt_M as [OPV-B] , 
@JE1_Dt_M as [JE VACCINE-1] ,
@JE2_Dt_M as [JE VACCINE-2] ,        
@VitA_Dose2_Dt_M as [VITAMIN A-2] ,          
@VitA_Dose3_Dt_M as [VITAMIN A-3] ,              
 @VitA_Dose4_Dt_M as [VITAMIN A-4] ,          
 @VitA_Dose5_Dt_M as [VITAMIN A-5] ,          
 @VitA_Dose6_Dt_M as [VITAMIN A-6] ,          
 @VitA_Dose7_Dt_M as [VITAMIN A-7] ,          
 @VitA_Dose8_Dt_M as [VITAMIN A-8] ,          
 @VitA_Dose9_Dt_M as [VITAMIN A-9] ,          
 @DT5_Dt_M as [DPT-B2]          
                  
) p              
UNPIVOT              
(          
ServiceDate_Max FOR ServiceName_Max IN (          
BCG ,          
[OPV-0],          
[HEP B-0] ,          
[DPT-1] ,          
[OPV-1] ,          
 [HEP B-1]  ,          
[DPT-2],          
[OPV-2] ,          
 [HEP B-2] ,          
 [DPT-3] ,          
[OPV-3] ,          
[HEP B-3] ,          
 [MEASLES-1] ,          
[VITAMIN A-1] ,
--MR,                  
 [DPT-B1] ,          
[OPV-B] , 
[JE VACCINE-1],         
[VITAMIN A-2] ,          
[VITAMIN A-3],                  
[VITAMIN A-4] ,          
[VITAMIN A-5] ,          
[VITAMIN A-6] ,          
[VITAMIN A-7] ,          
 [VITAMIN A-8] ,          
[VITAMIN A-9] ,          
[DPT-B2]           
--TT10 ,          
--TT16 )          
)) as unpvt1  ) B on A.ServiceName_Min=B.ServiceName_Max))C on p.ImmuName=C.ServiceName_Min)

        
          
End





