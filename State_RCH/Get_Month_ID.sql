USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Month_ID]    Script Date: 09/26/2024 12:38:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
--Select * from dbo.Get_Month_ID(2010,2011,'','')  
  
  
  
ALTER FUNCTION [dbo].[Get_Month_ID](@Financial_Year int,@Toyear int,@MinMonthID int,@MaxMonthID int)  
RETURNS @retTCCInformation TABLE   
(  
    Month_ID int,  
    Year_ID int,  
    FinYR int  
    
)  
AS   
  
BEGIN  
  
if(@MaxMonthID=0)  
begin  
  
    while(@Financial_Year<=@Toyear)  
 begin  
  INSERT @retTCCInformation  
  values(1,@Financial_Year+1,@Financial_Year),(2,@Financial_Year+1,@Financial_Year),(3,@Financial_Year+1,@Financial_Year)  
  ,(4,@Financial_Year,@Financial_Year),(5,@Financial_Year,@Financial_Year),(6,@Financial_Year,@Financial_Year),  
  (7,@Financial_Year,@Financial_Year),(8,@Financial_Year,@Financial_Year),(9,@Financial_Year,@Financial_Year),(10,@Financial_Year,@Financial_Year)  
  ,(11,@Financial_Year,@Financial_Year),(12,@Financial_Year,@Financial_Year)  
 set @Financial_Year=@Financial_Year+1  
 end  
  
end  
  
if(@MaxMonthID<>@MinMonthID)  
begin  
 if(@MaxMonthID between 1 and 3)  
 begin  
  Declare @i as int   
  set @i=@MaxMonthID  
  while(@i>=1)  
  begin  
   INSERT @retTCCInformation  
   values(@i,@Financial_Year+1,@Financial_Year)  
   set @i=@i-1  
  end  
  set @MaxMonthID=12  
 end  
  
 if(@MaxMonthID between 4 and 12)  
 begin  
  
      
  while(@MaxMonthID>=@MinMonthID)  
  begin  
   INSERT @retTCCInformation  
   values(@MaxMonthID,@Financial_Year,@Financial_Year)  
   set @MaxMonthID=@MaxMonthID-1  
  end  
  
 end  
end  
else  
begin  
   
 if(@MaxMonthID between 1 and 3)  
 begin  
   INSERT @retTCCInformation  
   values(@MaxMonthID,@Financial_Year+1,@Financial_Year)  
     
 end  
 else  
 begin  
   INSERT @retTCCInformation  
   values(@MaxMonthID,@Financial_Year,@Financial_Year)  
   
 end  
  
end  
  
  
  
    RETURN;  
END;  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
