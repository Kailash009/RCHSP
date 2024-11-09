USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_MH_DBPS]    Script Date: 09/26/2024 12:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER procedure [dbo].[Schedule_MH_DBPS]
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
	--set @i=CONVERT(int,@db)	
 
 set @s =' exec '+@db+'.dbo.Schedule_MH_PHC_SubCenter_Day'        
 --print(@s)  
 exec(@s)  
 set @s =' exec '+@db+'.dbo.Schedule_MH_Block_PHC_Day'        
 --print(@s)  
 exec(@s)  
 set @s =' exec '+@db+'.dbo.Schedule_MH_District_Block_Day'        
 --print(@s)  
 exec(@s)  
 set @s =' exec '+@db+'.dbo.Schedule_MH_State_District_Day'        
 --print(@s)  
 exec(@s)  

end  

exec Scheduled_MH_State_District_Day_Inup

end
