USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Mother_Data]    Script Date: 09/26/2024 14:04:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
exec Mother_Data 30,'130000000073'
*/
ALTER proc [dbo].[MS_Mother_Data]
@i int,
@ID varchar(20)


as
begin


declare @db varchar(20)

if(@i<=9)
set @db='RCH_0'+CAST(@i as varchar)
else
set @db='RCH_'+CAST(@i as varchar)
declare @s varchar(500)

set @ID=CAST(@ID as bigint)

set @s='select Registration_no as ID_No,Name_PW as Name ,isnull(REPLACE(tr.Address,'' '',''''),'''') as Address,IsNull(g.Name  ,'''') as ANM_Name

 from ' + @db +'.dbo.t_mother_registration tr 
 left outer join ' + @db +'.dbo.t_Ground_Staff g on  tr.ANM_ID =g.ID 
where Registration_no=' + @ID +' 
and g.Type_ID<>1
'
exec (@s)
--print(@s)

end
