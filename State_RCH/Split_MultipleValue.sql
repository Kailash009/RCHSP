USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Split_MultipleValue]    Script Date: 09/26/2024 12:40:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






 --select * from  dbo.Split_MultipleValue('')

ALTER FUNCTION [dbo].[Split_MultipleValue]
(
	@RowData nvarchar(2000)
)  
RETURNS @RtnValue table 
(
	Id int identity(1,1),
	Data nvarchar(100)
) 
AS  
BEGIN 
	Declare  @Cnt int=0
	Declare  @i int=1
	Set @Cnt = LEN(@RowData)
	
	While (@Cnt>=1)
	Begin
		
		Insert Into @RtnValue (data)
		Select 
			Data = ltrim(rtrim(Substring(@RowData,@i,1)))
		
		set @i=@i+1
		Set @Cnt = @Cnt - 1
			
	End
	

		
	Return
END



