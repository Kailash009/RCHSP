USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_ImmuCode_MinMax_Date]    Script Date: 09/26/2024 12:37:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/*
Get_ImmuCode_MinMax_Date 0,'2011-11-25'
*/

ALTER function [dbo].[Get_ImmuCode_MinMax_Date](@State_Code int,@Immu_Code int,@Immu_Date date,@Birth_Date date)

RETURNS 
@MinMax_Date TABLE
(
	-- Add the column definitions for the TABLE variable here
	Immu_Code int,
	MinDate datetime,
	MaxDate datetime
)
AS
BEGIN
 if(@Immu_Code = 0) -- on registration  and @Immu_Date = @Birth_Date
 begin
 if exists(select * from RCH_National_Level.dbo.m_Pentavalent_StateDistrict where State_Code=@State_Code)
 begin
 insert into @MinMax_Date values(1,DATEADD(DAY,0,@Birth_Date),DATEADD(DAY,365,@Birth_Date))      --BCG
 ,(2,DATEADD(DAY,0,@Birth_Date),DATEADD(DAY,14,@Birth_Date))                                     --OPV0
 ,(3,DATEADD(day,42,@Birth_Date),dateadd(month,59,@Birth_Date))                                  --OPV1
 ,(12,DATEADD(day,0,@Birth_Date),DATEADD(day,1,@Birth_Date))                                     --HEP B-0
 ,(16,DATEADD(day,42,@Birth_Date),DATEADD(day,365,@Birth_Date))                                   --PENV-1
 ,(19,DATEADD(month,9,@Birth_Date),DATEADD(month,12,@Birth_Date))                                --MEASLES-1
 end
 else
 begin
	insert into @MinMax_Date values(1,DATEADD(DAY,0,@Birth_Date),DATEADD(DAY,365,@Birth_Date))      --BCG
 ,(2,DATEADD(DAY,0,@Birth_Date),DATEADD(DAY,14,@Birth_Date))                                     --OPV0
 ,(3,DATEADD(day,42,@Birth_Date),dateadd(month,59,@Birth_Date))                                  --OPV1
 ,(7,DATEADD(day,42,@Birth_Date),DATEADD(day,365,@Birth_Date))                                   --DPT1
 ,(12,DATEADD(day,0,@Birth_Date),DATEADD(day,1,@Birth_Date))                                     --HEP B-0
 ,(13,DATEADD(day,42,@Birth_Date),DATEADD(month,11,@Birth_Date))                                 --HEP B-1
 ,(19,DATEADD(month,9,@Birth_Date),DATEADD(month,12,@Birth_Date))                                --MEASLES-1
 end
end
if(@Immu_Code = 3)   -- OPV2
begin
	insert into @MinMax_Date values(4,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,59,@Birth_Date))
end
if(@Immu_Code = 4)   -- OPV3
begin
	insert into @MinMax_Date values(5,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,59,@Birth_Date))
end
if(@Immu_Code = 5)  -- OPV-B
begin
	if(DATEDIFF(MONTH,@Immu_Date,DATEADD(MONTH,16,@Birth_Date))>=6)
		insert into @MinMax_Date values(6,DATEADD(MONTH,16,@Birth_Date),DATEADD(MONTH,59,@Birth_Date))
		else
		insert into @MinMax_Date values(6,DATEADD(MONTH,6,@Immu_Date),DATEADD(MONTH,59,@Birth_Date))
end
if(@Immu_Code = 7)  --DPT2
begin
	insert into @MinMax_Date values(8,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,83,@Birth_Date))
end
if(@Immu_Code = 8)  --DPT3
begin
	insert into @MinMax_Date values(9,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,83,@Birth_Date))
end
if(@Immu_Code = 9)   -- DPT-B1  if gap b/w DPT3 and 16th month from birth is less than 6 month then the due date of DPT-B1 get exceeded from 16th month
begin
if(DATEDIFF(MONTH,@Immu_Date,DATEADD(MONTH,16,@Birth_Date))>=6)
		insert into @MinMax_Date values(10,DATEADD(MONTH,16,@Birth_Date),DATEADD(MONTH,83,@Birth_Date))
		else
		insert into @MinMax_Date values(10,DATEADD(MONTH,6,@Immu_Date),DATEADD(MONTH,83,@Birth_Date))
end
if(@Immu_Code = 10)   -- DPT-B2
begin
	insert into @MinMax_Date values(11,DATEADD(year,5,@Birth_Date),DATEADD(year,6,@Birth_Date))  -- Maximum of DPT-B2 doubtfull
end
if(@Immu_Code = 13)  --HEP-B2
begin
	insert into @MinMax_Date values(14,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,11,@Birth_Date))
end
if(@Immu_Code = 14)  --HEP-B3
begin
	insert into @MinMax_Date values(15,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,11,@Birth_Date))
end
if(@Immu_Code = 16)  --Pen-2
begin
	insert into @MinMax_Date values(17,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,83,@Birth_Date))
end
if(@Immu_Code = 17)  --Pen-3
begin
	insert into @MinMax_Date values(18,DATEADD(day,28,@Immu_Date),DATEADD(MONTH,83,@Birth_Date))
end
if(@Immu_Code = 19)  --VIT-1 , Measles-2
begin
insert into @MinMax_Date values(23,DATEADD(MONTH,9,@Birth_Date),DATEADD(MONTH,59,@Birth_Date))
if(DATEDIFF(MONTH,@Immu_Date,DATEADD(MONTH,16,@Birth_Date))>=1)
		insert into @MinMax_Date values(20,DATEADD(MONTH,16,@Birth_Date),DATEADD(MONTH,59,@Birth_Date))
		else
		insert into @MinMax_Date values(20,DATEADD(MONTH,1,@Immu_Date),DATEADD(MONTH,59,@Birth_Date))
end
if(@Immu_Code = 23)  --VIT-2
begin
if(DATEDIFF(MONTH,@Immu_Date,DATEADD(MONTH,18,@Birth_Date))>=6)
		insert into @MinMax_Date values(24,DATEADD(MONTH,18,@Birth_Date),DATEADD(YEAR,5,@Birth_Date))
		else
		insert into @MinMax_Date values(24,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 24)  --VIT-3
begin
	insert into @MinMax_Date values(25,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 25)  --VIT-4
begin
	insert into @MinMax_Date values(26,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 26)  --VIT-5
begin
	insert into @MinMax_Date values(27,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 27)  --VIT-6
begin
	insert into @MinMax_Date values(28,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 28)  --VIT-7
begin
	insert into @MinMax_Date values(29,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 29)  --VIT-8
begin
	insert into @MinMax_Date values(30,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
if(@Immu_Code = 30)  --VIT-9
begin
	insert into @MinMax_Date values(31,DATEADD(MONTH,6,@Immu_Date),DATEADD(YEAR,5,@Birth_Date))
end
	-- Fill the table variable with the rows for your result set
	
	RETURN 
END




