USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Daily_Schedule_EC_Mother_Child_HP_Asha_Register]    Script Date: 09/26/2024 12:34:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Daily_Schedule_EC_Mother_Child_HP_Asha_Register]
as
begin
Declare @s as varchar(8000),@i as int,@db as char(6)  
,@SplitStr nvarchar(500)



SELECT @SplitStr = COALESCE(@SplitStr,'') + DBName + ','  
FROM [m_State_Run] where State_Code<>99

while @SplitStr<>''
begin
	if (Charindex(',',@SplitStr)=0) 
	begin
		Select @db = @SplitStr
		Set @SplitStr =''
	end
	else
	begin
		Select @db = ltrim(rtrim(Substring(@SplitStr,1,Charindex(',',@SplitStr)-1)))
		Set @SplitStr = Substring(@SplitStr,Charindex(',',@SplitStr)+1,len(@SplitStr))
	end	

 set @s =' exec '+@db+'.dbo.Daywise_EC_Mother_Child_HP_Asha_Register'        
 --print(@s)  
 exec(@s)  

end  
end
