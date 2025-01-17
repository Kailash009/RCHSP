USE [RCH_Reports]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Total_Registered_Count_InUp]    Script Date: 09/26/2024 12:33:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[Schedule_Total_Registered_Count_InUp]
as
begin
truncate table [RCH_Reports].[dbo].[Total_Registered]
--select * from [RCH_Reports].[dbo].[Total_Registered]
Declare @s as varchar(8000),@i as int,@db as char(6)  
,@SplitStr nvarchar(500),@StateID int



SELECT @SplitStr = COALESCE(@SplitStr,'') + DBName + ','  
FROM [m_State_Run] where State_Code<>99 order by Set_Priority
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
		Set @StateID = cast(Substring(@db,5,2) as int)
	end	
	set @i=CONVERT(int,@StateID)	
  
  set @S='insert into [RCH_Reports].[dbo].[Total_Registered]
  select A.ID,B.EC,C.MOTHER,D.CHILD from 
(select StateID as  ID,Name_E as StateName from '+@db+'.dbo.State where StateID='+cast(@i as varchar)+') A
left outer join
(select COUNT(Registration_no) as EC,StateID as StateID from '+@db+'.dbo.t_EC_Flat_Count where Case_no=1 group by  StateID) B on A.ID=B.StateID
left outer join
(select COUNT(Registration_no) as MOTHER,StateID as StateID from '+@db+'.dbo.t_mother_flat_Count where Case_no=1 and mother_Registration_Date is not null 
group by  StateID) C on A.ID=C.StateID
left outer join
(select COUNT(Registration_no) as CHILD,StateID as StateID from '+@db+'.dbo.t_Child_Flat_count 
group by  StateID) D on A.ID=D.StateID
'
      
    exec(@S)  
    --print(@S)
end

END