USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_children_registration_InsertUpdate]    Script Date: 09/26/2024 12:21:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
            
/*                  
[tp_children_registration_InsertUpdate] 27,26,'R',84,'0252',1,274,1622,32151,1,'',0,1111,0,'01-04-2011',                  
'aaaaaaa','F','01-05-2011','fddf',0,'dfdfdf','9898989898','9898989898','tttttt',1,1,1,'ffsf12',1,1,'rrwrwr',1,123,1234,'wwwww',1,''                  
                  
select * from t_children_registration where Name_Child='aaaaaaa'                  
                  
tp_children_registration_InsertUpdate 27,26,'R',84,'0252',1,274,1622,32155,'2013-14',2014,234,0,'2014-01-20','anuj','M','2014-01-05',                  
'',0,'Neha','','8836467387','navi mumbai',1,1,0,'',93360,93389,'',1915,'','deepak kumar','W',4,0,''                
              
tp_children_registration_InsertUpdate 95,11,'R',558,'0494',1,1916,10058,12407,'2015-16',2015,12,0,'02/12/2015','Test CHILD Locha','M',              
'02/12/2015','22',195003681765,'Test CHILD Locha','9878888888','Test CHILD Locha',2,1,124420,0,'10.24.102.247',0,'','NA','W'              
,4,5,'Home',0,0,null,null,null,'',4,1,'0'              
*/   
  
ALTER proc [dbo].[tp_children_registration_InsertUpdate]             
(@State_Code int,            
@District_Code int,            
@Rural_Urban char(1),            
@HealthBlock_Code int,            
@Taluka_Code varchar(6),            
@HealthFacility_Type int,            
@HealthFacility_Code int,            
@HealthSubFacility_Code int,            
@Village_Code int,            
@Financial_Yr varchar(7),            
@Financial_Year int,            
@Register_srno int,            
@Registration_no bigint out,            
@Registration_Date date,            
@Name_Child nvarchar(99),            
@Gender char(1),         
@Birth_Date date,            
@Birth_place nvarchar(99),            
@Mother_Reg_no bigint,            
@Name_Mother nvarchar(99),            
@Mobile_no nvarchar(10),            
@Address nvarchar(150),            
@Religion_code int,            
@Caste tinyint,            
@ANM_ID int,            
@ASHA_ID int,            
@IP_address varchar(25),            
@Created_By int,            
@msg nvarchar(200) out,            
@Name_Father nvarchar(99),            
@Mobile_Relates_To nvarchar(10),            
@Weight float,            
@DeliveryLocationID int,            
@Delivery_Location nvarchar(50),             
@Mobile_ID bigint=0,            
@Source_ID tinyint=0,            
@Child_EID numeric(14)=null,            
@Child_EIDT datetime=null,            
@Child_Aadhar_No numeric(12)=null,            
--@Birth_Certificate_Received bit,            
@Birth_Certificate_No nvarchar(50),            
@Status int,            
@Case_no int=0,        
@AWC varchar(14)='0',      
@Is_ILI_Symptom smallint=null,      
@Is_contact_Covid smallint=null,      
@Covid_test_done smallint=null,      
@Covid_test_result smallint=null,    
@SR_User_Flag varchar(50)='' ,  
@Pw_Link tinyint=null,  --added by ramesh             
@S_District_Code int=null,      
@S_HealthBlock_Code int=null,      
@S_Taluka_Code varchar(6)=null,      
@S_HealthFacility_Code int=null,      
@S_HealthSubFacility_Code int=null ,    
@OtherDistrict int=0 ,  
@DDE_Flag bit=0,                  
@HBIG_Date date =null, --Added by amit maurya              
@DeathDate date=null,  -- Added by Gopi rana 11052023
@Is_PVTG char(1)=null   
)                
as                
BEGIN                
SET NOCOUNT ON                
 set @msg='';                
Declare @CompareReg bigint=0               
Declare @outcome as int=0,@Infant_no as int=0,@LiveReg as int=0              
if not exists(select Registration_no from t_children_registration (nolock) where State_Code=@State_Code and Registration_no=@Registration_no )                
begin              
select @CompareReg=Registration_no from t_children_registration  (nolock) where  Name_Mother=@Name_Mother and Birth_Date=convert(date,@Birth_Date,103)               
 and Name_Child=@Name_Child  and Mobile_No=@Mobile_No                
  if (@CompareReg=0 or @CompareReg='' or @CompareReg is null)                
   Begin                
   if (@Mother_Reg_no is not null and @Mother_Reg_no<>'' and @Mother_Reg_no<>0)              
   begin              
                
     select @outcome=LiveBirth,@Infant_no=Infant_No from t_mother_infant_intermediate  (nolock) where Registration_no=@Mother_Reg_no and Case_no=@Case_no              
                 
   end              
   else              
   begin              
   set @Infant_no=0    -- outcome            
   set @outcome=1      -- infant_no            
   end              
                
             
      if(@Infant_no  < @outcome) -- @LiveReg measns infant no            
       begin             
      --declare @id int, @R_No varchar(12)             
        begin tran               
         --select  @Registration_no=Id_C+1 from m_lastId_child            
         --update m_lastId_child set Id_C=@Registration_no            
                     
          DECLARE @ID_Table table( New_ID  bigint);            
          Update m_lastId_child set Id_C = Id_C + 1 OUTPUT    inserted.Id_C into @ID_Table            
          select  @Registration_no=New_ID from @ID_Table            
                    
                    
         --SELECT @id = isnull(Id_C,0) + 1 from m_lastId_child                
         --SELECT @R_No =  '2' + left(replicate('0',2),2-len(@State_Code))+cast(@State_Code as varchar(2)) + left(replicate('0',9),9-len(@id))+cast(@id as varchar(9))                       --set @Registration_no = CAST(@R_No as bigint)                
         insert into t_children_registration(State_Code,District_Code,Rural_Urban,HealthBlock_Code,Taluka_Code,HealthFacility_Type,                
         HealthFacility_Code,HealthSubFacility_Code,Village_Code,Financial_Yr,Financial_Year,Register_srno,Registration_no,Registration_Date,                
         Name_Child,Gender,Birth_Date,Birth_place,Mother_Reg_no,Name_Mother,Mobile_no,[Address],Religion_code,Caste,                
         ANM_ID,ASHA_ID,IP_address,Created_By,Created_On,Name_Father,Mobile_Relates_To,[Weight],DeliveryLocationID,Delivery_Location                
         ,Mobile_ID,SourceID,Child_EID,Child_EIDT            
         --,Child_Aadhar_No    done by jyoti            
         --,Birth_Certificate_Received                
         ,Birth_CertificateNo,Entry_Type,Case_no,Is_ILI_Symptom,Is_contact_Covid,Covid_test_done,Covid_test_result,SR_User_Flag,  
          S_District_Code,S_HealthBlock_Code,S_Taluka_Code,S_HealthFacility_Code,S_HealthSubFacility_Code,OtherDistrict,DDE_Flag,HBIG_Date,Is_PVTG)            
                     
         values(            
         @State_Code,@District_Code,@Rural_Urban,@HealthBlock_Code,@Taluka_Code,@HealthFacility_Type,            
         @HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,@Financial_Yr,@Financial_Year,@Register_srno,@Registration_no,@Registration_Date,            
         @Name_Child,@Gender,@Birth_Date,@Birth_place,@Mother_Reg_no,@Name_Mother,@Mobile_no,@Address,@Religion_code,@Caste,            
         @ANM_ID,@ASHA_ID,@IP_address,@Created_By,GETDATE(),@Name_Father,@Mobile_Relates_To,@Weight,@DeliveryLocationID,@Delivery_Location            
         ,@Mobile_ID,@Source_ID,@Child_EID,@Child_EIDT        
         --,@Child_Aadhar_No    done by jyoti        
         --,@Birth_Certificate_Received            
         ,@Birth_Certificate_No,@Status,@Case_no,@Is_ILI_Symptom,@Is_contact_Covid,@Covid_test_done,@Covid_test_result,@SR_User_Flag,@S_District_Code,@S_HealthBlock_Code,@S_Taluka_Code,@S_HealthFacility_Code,@S_HealthSubFacility_Code,@OtherDistrict,@DDE_Flag,@HBIG_Date,@Is_PVTG)   
                 
               
             -- added by brijesh for DCRCH Count on 16022021    
      if not exists(select 1 from SMS.dbo.Live_Count_CH(nolock) where Count_Date=convert(date,GETDATE()) and State_Code=@State_Code)    
       begin    
        insert into SMS.dbo.Live_Count_CH (State_Code,CH_Count_Total,CH_Count_Year,CH_Count_Month,CH_Count_Week,CH_Count_Today)    
        select State_Code,CH_Count_Total,CH_Count_Year,CH_Count_Month,CH_Count_Week,1 as CH_Count_Today from SMS.dbo.Live_Count_CH(nolock)    
        where State_Code=@State_Code and Count_Date = convert(date,GETDATE()-1)    
       end    
       else    
        begin    
         update SMS.dbo.Live_Count_CH set CH_Count_Today += 1 where Count_Date=convert(date,GETDATE()) and State_Code=@State_Code       
        end     
                 
         update t_mother_infant_intermediate set Infant_No=Infant_No + 1 where Registration_no=@Mother_Reg_no and Case_no=@Case_no           
         insert into t_Children_Master(Registration_no,Mother_Reg_No,Mother_Case_no,Created_Date,Child_Reg_Date,Child_Deleted,Child_Death)        
         values(@Registration_no,@Mother_Reg_No,@Case_no,GETDATE(),@Registration_Date,0,4)        
         commit tran           
         --update t_Groundstaff_EC_MotherChildCount set [ChildCount]= [ChildCount]+1 where ID= @ANM_ID            
         --update t_Groundstaff_EC_MotherChildCount set [ChildCount]= [ChildCount]+1 where ID= @ASHA_ID            
         --update MS_children_registration            
         --set Registration_no=@Registration_no            
         --where Mobile_ID=@Mobile_ID             
         set @msg = 'Record Save Successfully !!!'        
      end           
      else          
      begin         
       if(@Source_ID = 3)         
          begin        
          --update MS_children_registration            
          --set Registration_no=0            
          --where Mobile_ID=@Mobile_ID             
          set @msg = 'Record already exists '          
       end        
       else         
        begin        
       set @msg = 'Number of Infant should be less than Live Birth'        
        end        
    end         
                
   End            
  Else            
   Begin            
     --update MS_children_registration set Registration_no=@CompareReg where Mobile_ID=@Mobile_ID            
     --set @msg = 'Children already exists with same Name,Mother Name,Father Name,Birth Date,Weight,Registration Date along with Registraion No.'+cast(@CompareReg as varchar(12))+'.'            
  set @msg = 'Child record already exists with the same Child Name, Mother Name, Mobile No. and Birth date for Registraion No.'+cast(@CompareReg as varchar(12))+'.'            
     set @Registration_no=@CompareReg            
   End            
 End           
 ELSE            
   BEGIN     
   select @CompareReg=Registration_no from t_children_registration  (nolock) where  Name_Mother=@Name_Mother and Birth_Date=convert(date,@Birth_Date,103)           
   and Name_Child=@Name_Child  and Mobile_No=@Mobile_No and Registration_no <> @Registration_no            
   if (@CompareReg=0 or @CompareReg='' or @CompareReg is null)       
      begin      
    update t_children_registration set            
    Financial_Yr=@Financial_Yr,            
    Financial_Year=@Financial_Year,            
    Register_srno=@Register_srno,            
    --Registration_no=@Registration_no,            
    Registration_Date=@Registration_Date,            
    Name_Child=@Name_Child,            
    Gender=@Gender,            
    Birth_Date=@Birth_Date,            
    Birth_place=@Birth_place,            
    Mother_Reg_no=@Mother_Reg_no,            
    Name_Mother=@Name_Mother,            
    Mobile_no=@Mobile_no,            
    [Address]=@Address,            
    Religion_code=@Religion_code,            
    Caste=@Caste,            
    --ANM_ID=@ANM_ID,            
    --ASHA_ID=@ASHA_ID,            
    Name_Father =@Name_Father,            
    Mobile_Relates_To=@Mobile_Relates_To,            
    [Weight]=@Weight,            
    DeliveryLocationID=@DeliveryLocationID,          
    Delivery_Location=@Delivery_Location,            
    Mobile_ID=@Mobile_ID,            
    SourceID=(case when isnull(Register_srno,0)=0 and @Register_srno<>0 then @Source_ID else SourceID end), ---  Modified On 04-07-2017           
    Updated_On=GETDATE(),            
    Updated_By=@Created_By,            
    Child_EID=@Child_EID,            
    Child_EIDT=@Child_EIDT,            
    --Child_Aadhar_No=@Child_Aadhar_No,    done by jyoti        
    --Birth_Certificate_Received=@Birth_Certificate_Received,            
    Birth_CertificateNo = @Birth_Certificate_No,            
    Entry_Type=@Status,      
    Is_ILI_Symptom=@Is_ILI_Symptom,      
    Is_contact_Covid=@Is_contact_Covid,      
    Covid_test_done=@Covid_test_done,      
    Covid_test_result = @Covid_test_result,    
    SR_User_Flag= @SR_User_Flag,  
    S_District_Code=@S_District_Code,  
    S_HealthBlock_Code=@S_HealthBlock_Code,  
    S_Taluka_Code=@S_Taluka_Code,  
    S_HealthFacility_Code=@S_HealthFacility_Code,  
    S_HealthSubFacility_Code=@S_HealthSubFacility_Code,  
    OtherDistrict=@OtherDistrict,  
 HBIG_Date=@HBIG_Date,
 Is_PVTG=@Is_PVTG  
    WHERE Registration_no=@Registration_no      
      
 --******************************  
  
DECLARE @ChildDeath int   
SET @ChildDeath=(CASE WHEN @Status<>1 THEN 0 ELSE 1 END)  
 IF(@ChildDeath=1)  
 BEGIN  
  update t_Children_Master set Child_Death_Date=@DeathDate,Child_Death=@ChildDeath where Registration_no=@Registration_no  
 END  
 ELSE  
 BEGIN  
  update t_Children_Master set Child_Death_Date=null,Child_Death=@ChildDeath where Registration_no=@Registration_no  
 END  
  
--******************************  
/*added for change the verification flag if mob no Change on 01/09/2021*/    
if exists(select 1 from t_ChildEntry_Verification WITH(NOLOCK) where Registration_no=@Registration_no and Mobile_no<>@Mobile_no)          
Begin          
  Update t_ChildEntry_Verification set is_verified=0,Is_Confirm=0,Updated_On=getdate(),Updated_By=@Created_By where Registration_no=@Registration_no        
End  
if exists(select 1 from t_ChildEntry_Verification WITH(NOLOCK) where Registration_no=@Registration_no and Mobile_no=@Mobile_no)          
Begin          
  Update t_ChildEntry_Verification set is_verified=1,Is_Confirm=1,Updated_On=getdate(),Updated_By=@Created_By where Registration_no=@Registration_no and Mobile_no=@Mobile_no       
End             
-- ****************************** If the child is already marked as duplicate ***********************************************  
    DECLARE @dup_rank_withoutAddr int=0, @dup_rank_withoutAddr_Count int =0  
    SELECT @dup_rank_withoutAddr=isnull(dup_rank_withoutAddr,0) from t_children_registration (nolock) where Registration_no=@Registration_no   
   
    IF(@dup_rank_withoutAddr<>0)    
    BEGIN  
    select @dup_rank_withoutAddr_Count=COUNT(dup_rank_withoutAddr) from t_children_registration where dup_rank_withoutAddr=@dup_rank_withoutAddr group by dup_rank_withoutAddr having COUNT(dup_rank_withoutAddr)=2  
      
        IF EXISTS(SELECT 1 from t_children_registration (nolock) where dup_rank_withoutAddr = @dup_rank_withoutAddr AND (Name_Mother<>@Name_Mother OR Birth_Date<>convert(date,@Birth_Date,103) OR Name_Child<>@Name_Child  OR Mobile_No <> @Mobile_No))  
   BEGIN  
      IF(@dup_rank_withoutAddr_Count <>0)  
    UPDATE t_children_registration SET dup_rank_withoutAddr=null,dup_case=null,dup_rank=null WHERE dup_rank_withoutAddr=@dup_rank_withoutAddr  
   ELSE  
    UPDATE t_children_registration SET dup_rank_withoutAddr=null,dup_case=null,dup_rank=null WHERE Registration_no=@Registration_no  
   END  
    END  
--***************************************************************************************************************************               
         
   --update MS_children_registration              
   --  set Registration_no=@Registration_no              
   --  where Mobile_ID=@Mobile_ID               
     if(@Pw_Link=2)--added by ramesh  
     begin  
  update t_children_registration set            
  Case_no=@Case_no,--added by ramesh   
  linked_by=  @Created_By,    
  linked_on= GETDATE(),  
  PW_Linked=@Pw_Link   WHERE Registration_no=@Registration_no     
  set @msg = 'Mother linked Successfully.RCH ID of mother is ' + cast(@Mother_Reg_no as varchar(12))  
     end  
     else          
     set @msg = 'Record Save Successfully !!!'               
     End        
   else      
   begin      
     --update MS_children_registration set Registration_no=@CompareReg where Mobile_ID=@Mobile_ID            
     --set @msg = 'Children already exists with same Name,Mother Name,Father Name,Birth Date,Weight,Registration Date along with Registraion No.'+cast(@CompareReg as varchar(12))+'.'            
 -- set @msg = 'Child already exist with same Child Name, Mother Name, Mobile No. and Birth date for Registraion No.'+cast(@CompareReg as varchar(12))+'.'            
     set @msg = 'Child record already exists with the same Child Name, Mother Name, Mobile No. and Birth date for Registraion No.'+cast(@CompareReg as varchar(12))+'.'            
     set @Registration_no=@CompareReg       
  end      
   end           
           
   if not exists(select * from t_page_tracking_Child where Registration_no=@Registration_no)   --Added on         
   begin        
           
  insert into t_page_tracking_Child(Registration_no,Page_Code,Execution_date)        
  values(@Registration_no,'CH',GETDATE())        
   end        
 --set @msg = 'Record Save Successfully !!!'            
RETURN            
END            
IF (@@ERROR <> 0)            
BEGIN            
     RAISERROR ('TRANSACTION FAILED',16,-1)            
     ROLLBACK TRANSACTION            
END  
  