USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_Ground_Staff_EditContact]    Script Date: 09/26/2024 15:54:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









-- tp_Ground_Staff_Select 27,4,'R',283,'0035',1,1750,8600,4310,93373

ALTER proc [dbo].[tp_Ground_Staff_EditContact]
(
 @State_Code int=0  
,@District_Code int=0  
,@Rural_Urban char(1)='R'  
,@HealthBlock_Code int =0 
,@Taluka_Code varchar(6)=null 
,@HealthFacility_Type int =0 
,@HealthFacility_Code int  =0
,@HealthSubFacility_Code int =0 
,@Village_Code int=0
,@TypeID as int=0
)
AS
BEGIN
SET NOCOUNT ON


if(@TypeID=1)--ASHA
begin

SELECT a.ID,Name,Contact_No,USSD_Flag
FROM t_Ground_Staff a 
inner join t_Ground_Staff_Mapping b on a.ID=b.ID
WHERE a.State_Code=@State_Code 
and a.District_Code=@District_Code 
and a.HealthBlock_Code=@HealthBlock_Code 
and a.HealthFacilty_Code=@HealthFacility_Code  
and (a.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
and b.Type_ID=1
and b.Is_Active=1
and isnull(b.Is_Processed,1)<>0 and Isnull(b.Process_Value,0)<>16

end
else--ANM
begin

SELECT a.ID,Name,Contact_No,USSD_Flag
FROM t_Ground_Staff a
inner join t_Ground_Staff_Mapping b on a.ID=b.ID
WHERE a.State_Code=@State_Code 
and a.District_Code=@District_Code 
and a.HealthBlock_Code=@HealthBlock_Code 
and a.HealthFacilty_Code=@HealthFacility_Code  
and (a.HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0)
and b.Type_ID not  in (1,5,8)
and b.Is_Active=1
and isnull(b.Is_Processed,1)<>0 and Isnull(b.Process_Value,0)<>16
end

END
 
 

 --select a.ID,Name,lower(Name) as vName from t_Ground_Staff_Mapping a  
 --inner join t_Ground_Staff b on a.ID=b.ID   
 --where a.HealthFacilty_Code=3347 and a.HealthSubFacility_Code=0 and a.Village_Code=0 and a.[TYPE_ID] not in (8,5,1) 
 --and a.Is_Active=1  and isnull(a.Is_Processed,1)<>0 and Isnull(a.Process_Value,0)<>16 order by Name  
 
 --select * from t_Ground_Staff_Mapping where  ID=159226 
 
 --select * from t_Ground_Staff where  ID=159226 









