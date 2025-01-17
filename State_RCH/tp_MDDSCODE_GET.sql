USE [All_registry]
GO
/****** Object:  StoredProcedure [dbo].[tp_MDDSCODE_GET]    Script Date: 09/26/2024 14:08:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[tp_MDDSCODE_GET]  
(  
@District_ID as int=0          
,@Taluka_ID as varchar(6)=0  
,@TypeID int =0     
)  
as  
begin  
if(@TypeID=1)  
begin  
select MDDS_Code from District where DCode=@District_ID  
end  
else  
begin  
select a.MDDS_Code as MDDS_District,b.MDDS_Code as MDDS_Taluka,a.DCode,b.TCode,c.BID  from District a  
inner join All_Taluka b on a.DCode=b.DCode  
inner join Health_Block c on b.TCode=c.TCode  
 where  b.MDDS_Code=@Taluka_ID  
 end  
end  
  