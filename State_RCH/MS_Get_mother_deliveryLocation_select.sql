USE [RCH_Web_Services]
GO
/****** Object:  StoredProcedure [dbo].[MS_Get_mother_deliveryLocation_select]    Script Date: 09/26/2024 15:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
   MS_Get_mother_deliveryLocation_select 30,1,1,'0001',274,2  
*/  
  
  
-- =============================================  
ALTER PROCEDURE [dbo].[MS_Get_mother_deliveryLocation_select]  
(    
@State_Code int,  
  @District_Code int =0       
 ,@HealthBlock_Code int =0     
 ,@Taluka_Code varchar(6)='0'   
 ,@HealthFacility_Code int =0  
 ,@ExpectedDeliveryPlace_Type int =0        
)   
   
AS  
BEGIN  
  
declare @s varchar(max),@db varchar(50)  
  
  
if(@State_Code <=9)  
begin  
set @db='RCH_0'+CAST(@State_Code AS VARCHAR)  
end  
else   
begin  
set @db='RCH_'+CAST(@State_Code AS VARCHAR)  
end 

IF (EXISTS (SELECT DBName FROM m_State_Run_Webservice WHERE DBName = @db ))  
begin  
SET @s=' exec '+cast(@db as varchar)+'.dbo.tp_mother_deliveryLocation_select  ' +cast( @District_Code as varchar)+','+cast(@HealthBlock_Code as varchar)+','''
       +cast(@Taluka_Code as varchar)+''','+cast(@HealthFacility_Code as varchar)+','+cast(@ExpectedDeliveryPlace_Type  as varchar)+'' 
       --print(@s)  
       exec (@s) 
       end
else
begin
select 'DB' as ID,'' as Contact_No
end 
         
       END  
