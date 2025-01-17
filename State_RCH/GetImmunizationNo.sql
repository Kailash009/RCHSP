USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[GetImmunizationNo]    Script Date: 09/26/2024 12:45:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







ALTER FUNCTION [dbo].[GetImmunizationNo](@DOB smalldatetime,@BCG smalldatetime,@OPV0 smalldatetime,@HepatitisB1 smalldatetime,@DPT1 smalldatetime,@OPV1 smalldatetime,@HepatitisB2 smalldatetime,@OPV2 smalldatetime,@DPT2 smalldatetime,@HepatitisB3 smalldatetime,@OPV3  smalldatetime,@DPT3 smalldatetime,@HepatitisB4 smalldatetime,@Measles smalldatetime,@VitA_Dose1 smalldatetime,@DPTBooster smalldatetime,@OPVBooster smalldatetime, @MR smalldatetime,@VitA_Dose2 smalldatetime,@VitA_Dose3 smalldatetime,@VitA_Dose4 smalldatetime,@VitA_Dose5 smalldatetime,@VitA_Dose6 smalldatetime,@VitA_Dose7 smalldatetime,@VitA_Dose8  smalldatetime,@VitA_Dose9 smalldatetime,@DT5 smalldatetime,@TT10 smalldatetime,@TT16 smalldatetime,@JE smalldatetime,@month varchar(3),@yr varchar(4),@Services_ID as int)
RETURNS varchar(29) AS


Begin
Declare @delimeter VARCHAR(3)
Declare @flag as varchar(29)

Declare @FDate as datetime
Declare @LDate as datetime
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

Declare 
@BCG_OPV0_HB1_min as datetime
,@DPT1_OPV1_HB2min as datetime
,@OPV2min as datetime 
,@DPT2min as datetime
,@HB3min as datetime
,@OPV3min as datetime
,@DPT3min as datetime
,@HB4min as datetime
,@Measlesmin as datetime
,@BCG_DPT1_max as datetime 
,@OPV0max as datetime
,@HB1max as datetime 
,@HB2_HB3_HB4_max as datetime 
,@DPT2_DPT3_max as datetime
,@OPV1_OPV2_OPV3_Measles_Vita_max as datetime
,@Vit_A1_Min as datetime
,@Measles_min as datetime
,@MMR_Vaccine_JE_min as datetime
,@DPT_B_min as datetime
,@OPV_B_min as datetime
,@Vit_A2_min as datetime 
,@Vit_A3_min as datetime 
,@Vit_A4_min as datetime 
,@Vit_A5_min as datetime 
,@Vit_A6_min as datetime 
,@Vit_A7_min as datetime 
,@Vit_A8_min as datetime 
,@Vit_A9_min as datetime 
,@DT5_min as datetime 
,@TT10_min as datetime
,@TT16_Min as datetime 
,@DPT_DPT5_max as datetime 
,@OPV_B_MMR_max as datetime 
,@Vit_TT16_max as datetime 
,@TT10_max as datetime
,@JE_Vaccine_Max as datetime 
,@DPTB as datetime
SET @delimeter = ''
set @Birthdate=CONVERT(datetime ,@DOB) 
set @FDate=cast('01/'+@month+'/'+@yr as Datetime)
set @LDate=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@FDate)+1,0))

set @BCG_Dt =CONVERT(datetime ,@BCG)
set @OPV0_Dt =CONVERT(datetime ,@OPV0)
set @HepatitisB1_Dt=CONVERT(datetime ,@HepatitisB1)
set @DPT1_Dt =CONVERT(datetime ,@DPT1)
set @OPV1_Dt =CONVERT(datetime ,@OPV1)
set @HepatitisB2_Dt =CONVERT(datetime ,@HepatitisB2)
set @DPT2_Dt =CONVERT(datetime ,@DPT2)
set @OPV2_Dt =CONVERT(datetime ,@OPV2)
set @HepatitisB3_Dt =CONVERT(datetime ,@HepatitisB3)
set @DPT3_Dt =CONVERT(datetime ,@DPT3)
set @OPV3_Dt =CONVERT(datetime ,@OPV3)
set @HepatitisB4_Dt =CONVERT(datetime ,@HepatitisB4)
set @Measles_Dt =CONVERT(datetime ,@Measles)
set @VitA_Dose1_Dt =CONVERT(datetime ,@VitA_Dose1)
set @Measles_Dt =CONVERT(datetime ,@Measles)
set @VitA_Dose1_Dt =CONVERT(datetime ,@VitA_Dose1)
set @MR_Dt =CONVERT(datetime ,@MR)
set @DPTBooster_Dt =CONVERT(datetime ,@DPTBooster)
set @OPVBooster_Dt =CONVERT(datetime ,@OPVBooster)
set @VitA_Dose2_Dt =CONVERT(datetime ,@VitA_Dose2)
set @VitA_Dose3_Dt =CONVERT(datetime ,@VitA_Dose3)
set @JE_Dt =CONVERT(datetime ,@JE)
set @VitA_Dose4_Dt =CONVERT(datetime ,@VitA_Dose4)
set @VitA_Dose5_Dt =CONVERT(datetime ,@VitA_Dose5)
set @VitA_Dose6_Dt =CONVERT(datetime ,@VitA_Dose6)
set @VitA_Dose7_Dt =CONVERT(datetime ,@VitA_Dose7)
set @VitA_Dose8_Dt=CONVERT(datetime ,@VitA_Dose8)
set @VitA_Dose9_Dt =CONVERT(datetime ,@VitA_Dose9)
set @DT5_Dt =CONVERT(datetime ,@DT5)
set @TT10_Dt =CONVERT(datetime ,@TT10)
set @TT16_Dt =CONVERT(datetime ,@TT16)

set @BCG_OPV0_HB1_min= @Birthdate
set @DPT1_OPV1_HB2min=DATEADD(day,42,@Birthdate)
set @OPV2min=DATEADD(day,28,@OPV1_Dt)
set @DPT2min=DATEADD(day,28,@DPT1_Dt)
set @HB3min=DATEADD(day,28,@HepatitisB2_Dt)
set @OPV3min=DATEADD(day,28,@OPV2_Dt)
set @DPT3min=DATEADD(day,28,@DPT2_Dt)
set @HB4min=DATEADD(day,28,@HepatitisB3_Dt)
set @Measlesmin=dateadd(month,9,@Birthdate)
set @Vit_A1_Min=dateadd(day,270,@Birthdate)
set @BCG_DPT1_max=DATEADD(day,365,@Birthdate)
set @OPV0max=DATEADD(day,14,@Birthdate)
set @HB1max=DATEADD(day,1,@Birthdate)
set @HB2_HB3_HB4_max=DATEADD(month,11,@Birthdate)
set @DPT2_DPT3_max=dateadd(month,83,@Birthdate)
set @OPV1_OPV2_OPV3_Measles_Vita_max=dateadd(month,59,@Birthdate)

set @Measles_min=dateadd(month,1,@Measles_Dt)
set @MMR_Vaccine_JE_min=dateadd(month,16,@Birthdate)
set @DPT_B_min=dateadd(month,6,convert(datetime, @DPT3))
set @DPTB=dateadd(month,16,@Birthdate)
set @OPV_B_min=dateadd(month,6,convert(datetime, @OPV3))
set @Vit_A2_min=dateadd(month,6,@VitA_Dose1_Dt)
set @Vit_A3_min=dateadd(month,6,@VitA_Dose2_Dt)
set @Vit_A4_min=dateadd(month,6,@VitA_Dose3_Dt)
set @Vit_A5_min=dateadd(month,6,@VitA_Dose4_Dt)
set @Vit_A6_min=dateadd(month,6,@VitA_Dose5_Dt)
set @Vit_A7_min=dateadd(month,6,@VitA_Dose6_Dt)
set @Vit_A8_min=dateadd(month,6,@VitA_Dose7_Dt)
set @Vit_A9_min=dateadd(month,6,@VitA_Dose8_Dt)
set @DT5_min=dateadd(month,60,@Birthdate)
set @TT10_min=dateadd(month,120,@Birthdate)
set @TT16_Min=dateadd(month,192,@Birthdate)

set @DPT_DPT5_max=dateadd(month,83,@Birthdate)
set @OPV_B_MMR_max=dateadd(month,59,@Birthdate)
set @Vit_TT16_max=dateadd(month,204,@Birthdate)
set @TT10_max=dateadd(month,191,@Birthdate)
set @JE_Vaccine_Max=dateadd(month,179,@Birthdate)

----------------Infant------------


if(@Services_ID=1)--Due
begin
if(@BCG_Dt is null and (
(@FDate>=@BCG_OPV0_HB1_min and @FDate<=@BCG_DPT1_max)
or
(@LDate>=@BCG_OPV0_HB1_min and @LDate<=@BCG_DPT1_max)
or
(@BCG_OPV0_HB1_min>=@FDate and @BCG_OPV0_HB1_min<=@LDate) 
or 
(@BCG_DPT1_max>=@FDate and @BCG_DPT1_max<=@LDate)
)) ------ BCG
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB1_Dt is null and (
(@FDate>=@BCG_OPV0_HB1_min and @FDate<=@HB1max)
or
(@LDate>=@BCG_OPV0_HB1_min and @LDate<=@HB1max)
or
(@BCG_OPV0_HB1_min>=@FDate and @BCG_OPV0_HB1_min<=@LDate) 
or 
(@HB1max>=@FDate and @HB1max<=@LDate)
)) ------ HepatitisB1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV0_Dt is null and (
(@FDate>=@BCG_OPV0_HB1_min and @FDate<=@OPV0max)
or
(@LDate>=@BCG_OPV0_HB1_min and @LDate<=@OPV0max)
or
(@BCG_OPV0_HB1_min>=@FDate and @BCG_OPV0_HB1_min<=@LDate) 
or 
(@OPV0max>=@FDate and @OPV0max<=@LDate)
)) ------ OPV0_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT1_Dt is null and (
(@FDate>=@DPT1_OPV1_HB2min and @FDate<=@BCG_DPT1_max)
or
(@LDate>=@DPT1_OPV1_HB2min and @LDate<=@BCG_DPT1_max)
or
(@DPT1_OPV1_HB2min>=@FDate and @DPT1_OPV1_HB2min<=@LDate) 
or 
(@BCG_DPT1_max>=@FDate and @BCG_DPT1_max<=@LDate)
)) ------ DPT1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV1_Dt is null and (
(@FDate>=@DPT1_OPV1_HB2min and @FDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@LDate>=@DPT1_OPV1_HB2min and @LDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@DPT1_OPV1_HB2min>=@FDate and @DPT1_OPV1_HB2min<=@LDate) 
or 
(@OPV1_OPV2_OPV3_Measles_Vita_max>=@FDate and @OPV1_OPV2_OPV3_Measles_Vita_max<=@LDate)
))  ------ OPV1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB2_Dt is null and (
(@FDate>=@DPT1_OPV1_HB2min and @FDate<=@HB2_HB3_HB4_max)
or
(@LDate>=@DPT1_OPV1_HB2min and @LDate<=@HB2_HB3_HB4_max)
or
(@DPT1_OPV1_HB2min>=@FDate and @DPT1_OPV1_HB2min<=@LDate) 
or 
(@HB2_HB3_HB4_max>=@FDate and @HB2_HB3_HB4_max<=@LDate)
))------ HepatitisB2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV2_Dt is null and @OPV1_Dt is not null and (
(@FDate>=@OPV2min and @FDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@LDate>=@OPV2min and @LDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@OPV2min>=@FDate and @OPV2min<=@LDate) 
or 
(@OPV1_OPV2_OPV3_Measles_Vita_max>=@FDate and @OPV1_OPV2_OPV3_Measles_Vita_max<=@LDate)
)) ------ OPV2_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT2_Dt is null and @DPT1_Dt is not null and (
(@FDate>=@DPT2min and @FDate<=@DPT2_DPT3_max)
or
(@LDate>=@DPT2min and @LDate<=@DPT2_DPT3_max)
or
(@DPT2min>=@FDate and @DPT2min<=@LDate) 
or 
(@DPT2_DPT3_max>=@FDate and @DPT2_DPT3_max<=@LDate)
)) ------ DPT2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB3_Dt is null and @HepatitisB2_Dt is not null and (
(@FDate>=@HB3min and @FDate<=@HB2_HB3_HB4_max)
or
(@LDate>=@HB3min and @LDate<=@HB2_HB3_HB4_max)
or
(@HB3min>=@FDate and @HB3min<=@LDate) 
or 
(@HB2_HB3_HB4_max>=@FDate and @HB2_HB3_HB4_max<=@LDate)
))------HepatitisB3_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV3_Dt is null and @OPV2_Dt is not null and (
(@FDate>=@OPV3min and @FDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@LDate>=@OPV3min and @LDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@OPV3min>=@FDate and @OPV3min<=@LDate) 
or 
(@OPV1_OPV2_OPV3_Measles_Vita_max>=@FDate and @OPV1_OPV2_OPV3_Measles_Vita_max<=@LDate)
)) ------OPV3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT3_Dt is null and @DPT2_Dt is not null and (
(@FDate>=@DPT3min and @FDate<=@DPT2_DPT3_max)
or
(@LDate>=@DPT3min and @LDate<=@DPT2_DPT3_max)
or
(@DPT3min>=@FDate and @DPT3min<=@LDate) 
or 
(@DPT2_DPT3_max>=@FDate and @DPT2_DPT3_max<=@LDate)
))  ------DPT3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB4_Dt is null and @HepatitisB3_Dt is not null and (
(@FDate>=@HB4min and @FDate<=@HB2_HB3_HB4_max)
or
(@LDate>=@HB4min and @LDate<=@HB2_HB3_HB4_max)
or
(@HB4min>=@FDate and @HB4min<=@LDate) 
or 
(@HB2_HB3_HB4_max>=@FDate and @HB2_HB3_HB4_max<=@LDate)
))  ------HepatitisB4_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@Measles_Dt is null and (
(@FDate>=@Measlesmin and @FDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@LDate>=@Measlesmin and @LDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@Measlesmin>=@FDate and @Measlesmin<=@LDate) 
or 
(@OPV1_OPV2_OPV3_Measles_Vita_max>=@FDate and @OPV1_OPV2_OPV3_Measles_Vita_max<=@LDate)
))  ------Measles_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose1_Dt is null and (
(@FDate>=@Vit_A1_Min and @FDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@LDate>=@Vit_A1_Min and @LDate<=@OPV1_OPV2_OPV3_Measles_Vita_max)
or
(@Vit_A1_Min>=@FDate and @Vit_A1_Min<=@LDate) 
or 
(@OPV1_OPV2_OPV3_Measles_Vita_max>=@FDate and @OPV1_OPV2_OPV3_Measles_Vita_max<=@LDate)
))  ------VitA_Dose1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPTBooster_Dt is null and (
(@FDate>=@DPT_B_min and @FDate<=@DPT_DPT5_max)
or
(@LDate>=@DPT_B_min and @LDate<=@DPT_DPT5_max)
or
(@DPT_B_min>=@FDate and @DPT_B_min<=@LDate) 
or 
(@DPT_DPT5_max>=@FDate and @DPT_DPT5_max<=@LDate)
)
and (
(@FDate>=@DPTB and @FDate<=@DPT_DPT5_max)
or
(@LDate>=@DPTB and @LDate<=@DPT_DPT5_max)
))
--DPTBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPVBooster_Dt is null and (
(@FDate>=@OPV_B_min and @FDate<=@OPV_B_MMR_max)
or
(@LDate>=@OPV_B_min and @LDate<=@OPV_B_MMR_max)
or
(@OPV_B_min>=@FDate and @OPV_B_min<=@LDate) 
or 
(@OPV_B_MMR_max>=@FDate and @OPV_B_MMR_max<=@LDate)
)
and (
(@FDate>=@DPTB and @FDate<=@OPV_B_MMR_max)
or
(@LDate>=@DPTB and @LDate<=@OPV_B_MMR_max)
))
 ------OPVBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@MR_Dt is null and @Measles_Dt is not null and (@Measles_min<=@FDate or @Measles_min<=@LDate) and  --(@Measles_min>=@FDate And @Measles_min<=@LDate)
(
(@FDate>=@MMR_Vaccine_JE_min and @FDate<=@OPV_B_MMR_max)
or
(@LDate>=@MMR_Vaccine_JE_min and @LDate<=@OPV_B_MMR_max)
or
(@MMR_Vaccine_JE_min>=@FDate and @MMR_Vaccine_JE_min<=@LDate) 
or  
(@OPV_B_MMR_max>=@FDate and @OPV_B_MMR_max<=@LDate)
)) ------MR_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose2_Dt is null and @VitA_Dose1_Dt is not null  and (
(@FDate>=@Vit_A2_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A2_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A2_min>=@FDate and @Vit_A2_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose3_Dt is null and @VitA_Dose2_Dt is not null  and (
(@FDate>=@Vit_A3_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A3_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A3_min>=@FDate and @Vit_A3_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose4_Dt is null and @VitA_Dose3_Dt is not null  and (
(@FDate>=@Vit_A4_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A4_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A4_min>=@FDate and @Vit_A4_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose5_Dt is null and @VitA_Dose4_Dt is not null  and (
(@FDate>=@Vit_A5_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A5_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A5_min>=@FDate and @Vit_A5_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose6_Dt is null and @VitA_Dose5_Dt is not null  and (
(@FDate>=@Vit_A6_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A6_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A6_min>=@FDate and @Vit_A6_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose6_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose7_Dt is null and @VitA_Dose6_Dt is not null  and (
(@FDate>=@Vit_A7_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A7_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A7_min>=@FDate and @Vit_A7_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose7_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose8_Dt is null and @VitA_Dose7_Dt is not null  and (
(@FDate>=@Vit_A8_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A8_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A8_min>=@FDate and @Vit_A8_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose8_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose9_Dt is null and @VitA_Dose8_Dt is not null  and (
(@FDate>=@Vit_A9_min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@Vit_A9_min and @LDate<=@Vit_TT16_max)
or
(@Vit_A9_min>=@FDate and @Vit_A9_min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------VitA_Dose9_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DT5_Dt is null  and (
(@FDate>=@DT5_min and @FDate<=@DPT_DPT5_max)
or
(@LDate>=@DT5_min and @LDate<=@DPT_DPT5_max)
or
(@DT5_min>=@FDate and @DT5_min<=@LDate) 
or 
(@DPT_DPT5_max>=@FDate and @DPT_DPT5_max<=@LDate)
)) ------DT5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@TT10_Dt is null  and (
(@FDate>=@TT10_min and @FDate<=@TT10_max)
or
(@LDate>=@TT10_min and @LDate<=@TT10_max)
or
(@TT10_min>=@FDate and @TT10_min<=@LDate) 
or 
(@TT10_max>=@FDate and @TT10_max<=@LDate)
)) ------TT10_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@TT16_Dt is null  and (
(@FDate>=@TT16_Min and @FDate<=@Vit_TT16_max)
or
(@LDate>=@TT16_Min and @LDate<=@Vit_TT16_max)
or
(@TT16_Min>=@FDate and @TT16_Min<=@LDate) 
or 
(@Vit_TT16_max>=@FDate and @Vit_TT16_max<=@LDate)
)) ------TT16_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@JE_Dt is null  and (
(@FDate>=@MMR_Vaccine_JE_min and @FDate<=@JE_Vaccine_Max)
or
(@LDate>=@MMR_Vaccine_JE_min and @LDate<=@JE_Vaccine_Max)
or
(@MMR_Vaccine_JE_min>=@FDate and @MMR_Vaccine_JE_min<=@LDate) 
or 
(@JE_Vaccine_Max>=@FDate and @JE_Vaccine_Max<=@LDate)
)) ------JE_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
end

if (@Services_ID=2)---Given
begin
if(@BCG_Dt is not null) ------ BCG
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB1_Dt is not null) ------ HepatitisB1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV0_Dt is not null ) ------ OPV0_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT1_Dt is not null) ------ DPT1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV1_Dt is not null) ------ OPV1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB2_Dt is not null ) ------ HepatitisB2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV2_Dt is not null ) ------ OPV2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT2_Dt is not null ) ------ DPT2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB3_Dt is not null ) ------HepatitisB3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV3_Dt is not null ) ------OPV3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT3_Dt is not null ) ------DPT3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB4_Dt is not null ) ------HepatitisB4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@Measles_Dt is not null ) ------Measles_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose1_Dt is not null ) ------VitA_Dose1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@DPTBooster_Dt is not null) ------DPTBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@OPVBooster_Dt is not null) ------OPVBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@MR_Dt is not null) ------MR_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose2_Dt is not null) ------VitA_Dose2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose3_Dt is not null) ------VitA_Dose3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose4_Dt is not null) ------VitA_Dose4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose5_Dt is not null ) ------VitA_Dose5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose6_Dt is not null ) ------VitA_Dose6_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose7_Dt is not null) ------VitA_Dose7_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose8_Dt is not null) ------VitA_Dose8_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose9_Dt is not null) ------VitA_Dose9_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @DT5_Dt is not null) ------DT5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @TT10_Dt is not null) ------TT10_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @TT16_Dt is not null) ------TT16_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @JE_Dt is not null) ------JE_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
end

if(@Services_ID=3)--OverDue
begin
if(@BCG_Dt is null and @BCG_DPT1_max<@FDate) ------ BCG
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB1_Dt is null and @HB1max>=@FDate and @HB1max<=@LDate) ------ HepatitisB1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV0_Dt is null and @OPV0max>=@FDate and @OPV0max<=@LDate) ------ OPV0_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT1_Dt is null and @BCG_DPT1_max<@FDate) ------ DPT1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV1_Dt is null and @OPV1_OPV2_OPV3_Measles_Vita_max<@FDate)  ------ OPV1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB2_Dt is null and @HB2_HB3_HB4_max<@FDate)------ HepatitisB2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV2_Dt is null and @OPV1_Dt is not null and @OPV1_OPV2_OPV3_Measles_Vita_max<@FDate) ------ OPV2_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT2_Dt is null and @DPT1_Dt is not null and @DPT2_DPT3_max<@FDate) ------ DPT2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB3_Dt is null and @HepatitisB2_Dt is not null and @HB2_HB3_HB4_max<@FDate)------HepatitisB3_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV3_Dt is null and @OPV2_Dt is not null and @OPV1_OPV2_OPV3_Measles_Vita_max<@FDate) ------OPV3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT3_Dt is null and @DPT2_Dt is not null and @DPT2_DPT3_max<@FDate)  ------DPT3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB4_Dt is null and @HepatitisB3_Dt is not null and @HB2_HB3_HB4_max<@FDate)  ------HepatitisB4_Dt

begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@Measles_Dt is null and @OPV1_OPV2_OPV3_Measles_Vita_max<@FDate)  ------Measles_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose1_Dt is null and @OPV1_OPV2_OPV3_Measles_Vita_max<@FDate)  ------VitA_Dose1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@DPTBooster_Dt is null and @DPT_DPT5_max<@FDate) ------DPTBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPVBooster_Dt is null and @OPV_B_MMR_max<@FDate) ------OPVBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@MR_Dt is null and @Measles_Dt is not null and @Measles_min<@FDate and @OPV_B_MMR_max<@FDate) ------MR_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose2_Dt is null and @VitA_Dose1_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose3_Dt is null and @VitA_Dose2_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose4_Dt is null and @VitA_Dose3_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose5_Dt is null and @VitA_Dose4_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose6_Dt is null and @VitA_Dose5_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose6_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose7_Dt is null and @VitA_Dose6_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose7_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose8_Dt is null and @VitA_Dose7_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose8_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose9_Dt is null and @VitA_Dose8_Dt is not null  and @Vit_TT16_max<@FDate) ------VitA_Dose9_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DT5_Dt is null  and @DPT_DPT5_max<@FDate) ------DT5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@TT10_Dt is null  and @TT10_max<@FDate) ------TT10_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@TT16_Dt is null  and @Vit_TT16_max<@FDate) ------TT16_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@JE_Dt is null  and @JE_Vaccine_Max<@FDate) ------JE_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

end

if (@Services_ID=4)---Workplan Given
begin
if(@BCG_Dt is not null and substring(datename(month,@BCG_Dt),1,3)=@month and year(@BCG_Dt)=@yr) ------ BCG
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB1_Dt is not null and substring(datename(month,@HepatitisB1_Dt),1,3)=@month and year(@HepatitisB1_Dt)=@yr) ------ HepatitisB1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV0_Dt is not null and substring(datename(month,@OPV0_Dt),1,3)=@month and year(@OPV0_Dt)=@yr) ------ OPV0_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT1_Dt is not null and substring(datename(month,@DPT1_Dt),1,3)=@month and year(@DPT1_Dt)=@yr) ------ DPT1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV1_Dt is not null and substring(datename(month,@OPV1_Dt),1,3)=@month and year(@OPV1_Dt)=@yr) ------ OPV1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB2_Dt is not null and substring(datename(month,@HepatitisB2_Dt),1,3)=@month and year(@HepatitisB2_Dt)=@yr) ------ HepatitisB2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV2_Dt is not null and substring(datename(month,@OPV2_Dt),1,3)=@month and year(@OPV2_Dt)=@yr) ------ OPV2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT2_Dt is not null and substring(datename(month,@DPT2_Dt),1,3)=@month and year(@DPT2_Dt)=@yr) ------ DPT2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB3_Dt is not null and substring(datename(month,@HepatitisB3_Dt),1,3)=@month and year(@HepatitisB3_Dt)=@yr) ------HepatitisB3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@OPV3_Dt is not null and substring(datename(month,@OPV3_Dt),1,3)=@month and year(@OPV3_Dt)=@yr) ------OPV3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@DPT3_Dt is not null and substring(datename(month,@DPT3_Dt),1,3)=@month and year(@DPT3_Dt)=@yr) ------DPT3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@HepatitisB4_Dt is not null and substring(datename(month,@HepatitisB4_Dt),1,3)=@month and year(@HepatitisB4_Dt)=@yr) ------HepatitisB4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@Measles_Dt is not null and substring(datename(month,@Measles_Dt),1,3)=@month and year(@Measles_Dt)=@yr) ------Measles_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end

if(@VitA_Dose1_Dt is not null and substring(datename(month,@VitA_Dose1_Dt),1,3)=@month and year(@VitA_Dose1_Dt)=@yr) ------VitA_Dose1_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@DPTBooster_Dt is not null and substring(datename(month,@DPTBooster_Dt),1,3)=@month and year(@DPTBooster_Dt)=@yr) ------DPTBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@OPVBooster_Dt is not null and substring(datename(month,@OPVBooster_Dt),1,3)=@month and year(@OPVBooster_Dt)=@yr) ------OPVBooster_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@MR_Dt is not null and substring(datename(month,@MR_Dt),1,3)=@month and year(@MR_Dt)=@yr) ------MR_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose2_Dt is not null and substring(datename(month,@VitA_Dose2_Dt),1,3)=@month and year(@VitA_Dose2_Dt)=@yr) ------VitA_Dose2_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose3_Dt is not null and substring(datename(month,@VitA_Dose3_Dt),1,3)=@month and year(@VitA_Dose3_Dt)=@yr) ------VitA_Dose3_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose4_Dt is not null and substring(datename(month,@VitA_Dose4_Dt),1,3)=@month and year(@VitA_Dose4_Dt)=@yr) ------VitA_Dose4_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose5_Dt is not null and substring(datename(month,@VitA_Dose5_Dt),1,3)=@month and year(@VitA_Dose5_Dt)=@yr) ------VitA_Dose5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose6_Dt is not null and substring(datename(month,@VitA_Dose6_Dt),1,3)=@month and year(@VitA_Dose6_Dt)=@yr) ------VitA_Dose6_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose7_Dt is not null and substring(datename(month,@VitA_Dose7_Dt),1,3)=@month and year(@VitA_Dose7_Dt)=@yr) ------VitA_Dose7_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose8_Dt is not null and substring(datename(month,@VitA_Dose8_Dt),1,3)=@month and year(@VitA_Dose8_Dt)=@yr) ------VitA_Dose8_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if(@VitA_Dose9_Dt is not null and substring(datename(month,@VitA_Dose9_Dt),1,3)=@month and year(@VitA_Dose9_Dt)=@yr) ------VitA_Dose9_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @DT5_Dt is not null and substring(datename(month,@DT5_Dt),1,3)=@month and year(@DT5_Dt)=@yr) ------DT5_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @TT10_Dt is not null and substring(datename(month,@TT10_Dt),1,3)=@month and year(@TT10_Dt)=@yr) ------TT10_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @TT16_Dt is not null and substring(datename(month,@TT16_Dt),1,3)=@month and year(@TT16_Dt)=@yr) ------TT16_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
if( @JE_Dt is not null and substring(datename(month,@JE_Dt),1,3)=@month and year(@JE_Dt)=@yr) ------JE_Dt
begin
set @flag=isnull(@flag +@delimeter+'1','1')
End
else 
begin
set @flag=isnull(@flag +@delimeter+'0','0')
end
end

Return @Flag
end


/*
select dbo.GetImmunizationNumber ('2009-09-05 00:00:00','Jul','2011')
*/






