USE [RCH_Reports]
GO
/****** Object:  UserDefinedFunction [dbo].[EC_Percentage_Quaterly]    Script Date: 09/26/2024 12:35:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select [dbo].[EC_Percentage_Quaterly](1200,1900,13)
--select [dbo].[EC_Percentage_Quaterly](1200,1200,100)
ALTER function [dbo].[EC_Percentage_Quaterly]
( @Estimation_Prv_Year int,
@Estimation_Current_Year int,
@Total_Registration int)
returns decimal(10,2)
as
begin
Declare @EC_Prorata as decimal(10,2)
if(@Estimation_Current_Year>@Estimation_Prv_Year and @Estimation_Current_Year > 0)
set @EC_Prorata= (@Total_Registration/(CAST((@Estimation_Current_Year-@Estimation_Prv_Year) as decimal(10,2))/4)*100)
else
set @EC_Prorata=0
return @EC_Prorata

end