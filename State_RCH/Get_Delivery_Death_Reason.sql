USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Delivery_Death_Reason]    Script Date: 09/26/2024 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- select dbo.[Get_Delivery_Death_Reason] (99123) as Death_Reason

ALTER FUNCTION [dbo].[Get_Delivery_Death_Reason](@Death_Reason as Varchar(50))
RETURNS varchar(50) AS  
BEGIN 
	Declare  @Cnt int=0
	Declare  @i int=1
	Declare @result varchar(50) = ''	
	if (PATINDEX('%99%',@Death_Reason)<>0)
    set @Death_Reason=replace(@Death_Reason,substring(@Death_Reason,PATINDEX('%99%',@Death_Reason),2),9)
	Set @Cnt = LEN(@Death_Reason)		
	While (@Cnt>=1)
	Begin

	    set	@result += (Select Name from [RCH_National_Level].[dbo].[m_DeathCause] where ID<> '0' and ID = case when  (ltrim(rtrim(Substring(@Death_Reason,@i,1))))=9 then 99 else  (ltrim(rtrim(Substring(@Death_Reason,@i,1)))) end) + ',' ;

		set @i=@i+1
		Set @Cnt = @Cnt - 1
			
	End
	if(LEN(@Death_Reason)>0)
	
	set @result=LEFT(@result, LEN(@result) - 1)
	else
	
	set @result=null
	
	Return @result
	
END
