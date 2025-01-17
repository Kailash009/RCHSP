USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[Check_child_Services_death]    Script Date: 09/26/2024 12:36:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*     
	select Msg,DeathDate from Check_child_Services_death (230000257906,'2017-01-03','2017-01-03',null,1)
	select Msg,DeathDate from Check_child_Services_death (230000257906,'2017-01-03','2017-01-03',null,1)
	select Msg,DeathDate from Check_child_Services_death (230000257906,'2017-01-24','','',1,1) 
	select Msg,DeathDate from Check_child_Services_death (230000257906,'1990-01-01','2017-01-09','2017-01-09',7) 
*/   
ALTER FUNCTION [dbo].[Check_child_Services_death](@Registration_no bigint, @PNC_Date date=null, @Death_Date date=null, @EditDeath_Date date=null ,@Service_No nvarchar(30)=null, @CheckFor int)    
RETURNS @check_child_Services_dealth TABLE     
(    
    Registration_no bigint,    
    DeathDate date,    
    ChildDeathIn int,    
    Msg varchar(500)  
 )  
AS     
               
BEGIN   
DECLARE @msg as varchar(500) SET @msg=''  
DECLARE @ChildDeathDate as DATE   
DECLARE @ChildDeathIn as int   
DECLARE @MaxPNCImmu_Date date  
DECLARE @ServiceNo as int  
  
IF(@CheckFor=1)  
 SET @Service_No='0'  
  
IF((@EditDeath_Date is null OR @EditDeath_Date = '1900-01-01') AND (@Death_Date is not null AND @Death_Date <> '') AND @Service_No <> '0')-- Edit the Child service to death  
BEGIN  
 select @MaxPNCImmu_Date=MAX(PNCImmu_Date) from(  
 select PNC_Date as PNCImmu_Date from t_child_pnc (nolock) where InfantRegistration=@Registration_no and Infant_Death_Date is null and PNC_No not in(@Service_No)  
 union     
 select Immu_date as PNCImmu_Date from t_children_tracking (nolock) where Registration_no=@Registration_no and DeathDate is null and (Serious_Reason<>4 or Serious_Reason is null) 
 union  
 select Visit_Date as PNCImmu_Date from t_children_tracking_medical (nolock) where Registration_no=@Registration_no  
  )A  
END  
ELSE   
BEGIN  
 select @MaxPNCImmu_Date=MAX(PNCImmu_Date) from(  
 select PNC_Date as PNCImmu_Date from t_child_pnc (nolock) where InfantRegistration=@Registration_no and Infant_Death_Date is null    
 union     
 select Immu_date as PNCImmu_Date from t_children_tracking (nolock) where Registration_no=@Registration_no and DeathDate is null and (Serious_Reason<>4 or Serious_Reason is null)   
 union  
 select Visit_Date as PNCImmu_Date from t_children_tracking_medical (nolock) where Registration_no=@Registration_no  
  )A  
END  
  
IF((@EditDeath_Date is not null AND @EditDeath_Date <> '1900-01-01' AND @EditDeath_Date <> '') AND (@Death_Date is null OR @Death_Date = '1990-01-01' OR @Death_Date = '') AND @PNC_Date<>'1990-01-01')  
BEGIN  
   SET @ChildDeathDate=null  SET @ChildDeathIn=0   
END  
ELSE  
BEGIN  
   select @ChildDeathDate=DeathDate, @ChildDeathIn=ChildDeathIn from (  
   select Registration_no,Infant_Death_Date as DeathDate,1 as ChildDeathIn from t_child_pnc (nolock) where InfantRegistration=@Registration_no and Infant_Death_Date is not null    
   union     
   select Registration_no, ( case when Serious_Reason=4 then Immu_date else DeathDate end)DeathDate,2 as ChildDeathIn from t_children_tracking (nolock) where Registration_no=@Registration_no and (DeathDate is not null or Serious_Reason=4)  
  )A  
END  
--0 ************* Default Table Value *****************  
INSERT @check_child_Services_dealth SELECT @Registration_no,@ChildDeathDate,@ChildDeathIn,@msg  
--1 *********************************************************************************************************************************  
IF(@Death_Date is null OR @Death_Date = '1990-01-01' OR @Death_Date = '')  
BEGIN  
IF((@ChildDeathDate is not null OR @ChildDeathDate<>'') and @PNC_Date<>'1990-01-01') -- IF child has already death and give the service after death  
 BEGIN  
    IF(@EditDeath_Date is not null AND @EditDeath_Date <> '1900-01-01' AND @EditDeath_Date <> '')  
    BEGIN  
  UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=null, ChildDeathIn=@ChildDeathIn,Msg=@msg  
    END  
    ELSE IF (@PNC_Date > @ChildDeathDate)   
    BEGIN   
  SET @msg='service Date can not be greater than Death Date of Infant, This child is already mark as Death on ' +CONVERT(varchar(20),@ChildDeathDate,106)+ ''      
  UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=@ChildDeathDate, ChildDeathIn=@ChildDeathIn,Msg=@msg  
    END  
  --  ELSE  
  --UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=null, ChildDeathIn=@ChildDeathIn,Msg=@msg  
 END  
END  
--2 *********************************************************************************************************************************  
ELSE IF(@Death_Date is not null OR @Death_Date <> '' OR @Death_Date = '1990-01-01')  
BEGIN  
 IF(@EditDeath_Date is not null AND @EditDeath_Date <> '1900-01-01' AND @EditDeath_Date <> '') --IF user edit the death record  
 BEGIN  
  IF(@Death_Date<>@EditDeath_Date)  
  BEGIN  
   IF(@Death_Date < @MaxPNCImmu_Date)  
   BEGIN  
    set @msg= 'Death Date can not be less than the last service Date. Child last service date is '+ convert(varchar(20), @MaxPNCImmu_Date, 106) +' !'    
    UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=@ChildDeathDate, ChildDeathIn=@ChildDeathIn,Msg=@msg  
   END  
  END  
 END  
 ELSE IF(@EditDeath_Date is null or @EditDeath_Date='1900-01-01' OR @EditDeath_Date = '') --IF user add/edit the death for other record  
 BEGIN  
  IF(@ChildDeathDate is not null)  
  BEGIN  
   set @msg='Status is already Death for this Infant on ' +CONVERT(varchar(20),@ChildDeathDate,106)+ ' '     
   UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=@ChildDeathDate, ChildDeathIn=@ChildDeathIn,Msg=@msg  
  END  
  ELSE IF(@Death_Date < @MaxPNCImmu_Date)  
  BEGIN  
   set @msg= 'Death Date can not be less than the last service Date. Child last service date is '+ convert(varchar(20), @MaxPNCImmu_Date, 106) +' !'    
   UPDATE @check_child_Services_dealth SET Registration_no=@Registration_no,DeathDate=@ChildDeathDate, ChildDeathIn=@ChildDeathIn,Msg=@msg  
  END  
 END  
END  
 RETURN;    
END;    
    
