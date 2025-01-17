USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Get_Child_ForDeletion]    Script Date: 09/26/2024 15:26:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
[Get_Child_ForDeletion] 1,'R',3,'0002',1,13,27,10000230,2013
*/
ALTER procedure [dbo].[Get_Child_ForDeletion]
(
@District_Code int,
@Rural_Urban char(1),
@HealthBlock_Code int,
@Taluka_Code varchar(6),
@HealthFacility_Type int,
@HealthFacility_Code int,
@HealthSubFacility_Code int,
@Village_Code int,
@Financial_Year smallint
,@Registration_no bigint =0
)
as
Begin

Declare @S as nvarchar(max)=null
set @S='
select Registration_no, Mother_Reg_no as MID_no,Name_Child +''('' + Name_Mother + '')'' as Name ,Address, Convert(varchar(10),Birth_Date,103) as Age,Delete_Mother,ReasonForDeletion
from t_children_registration
WHERE 
--(District_Code='+CAST(@District_Code as varchar(4))+')
--and (Rural_Urban='''+CAST(@Rural_Urban as varchar(1))+''')
--and (HealthBlock_Code='+CAST(@HealthBlock_Code as varchar(4))+')
--and (Taluka_Code='''+CAST(@Taluka_Code as varchar(4))+''')
--and (HealthFacility_Type='+CAST(@HealthFacility_Type as varchar(4))+')
--and (HealthFacility_Code='+CAST(@HealthFacility_Code as varchar(4))+')
--and (HealthSubFacility_Code='+CAST(@HealthSubFacility_Code as varchar(6))+')
--and (Village_Code='+CAST(@Village_Code as varchar(10))+' or '+CAST(@Village_Code as varchar(10))+'=0)and 
 Financial_Year='+CAST(@Financial_Year as varchar(4))+'
 and (Registration_no='+cast(@Registration_no as varchar(12))+' or '+cast(@Registration_no as varchar(12))+'=0)
'

set @S= @S + ' order by Name'
Exec(@S)
print(@S)
end




