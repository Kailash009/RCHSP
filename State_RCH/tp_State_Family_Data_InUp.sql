USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_State_Family_Data_InUp]    Script Date: 09/26/2024 14:52:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- tp_State_Family_Data_InUp 131000008094, 242342345,242342346,'','',null,null,45,'10.25.215.110','',null            
ALTER procedure [dbo].[tp_State_Family_Data_InUp]            
       @Registration_No bigint            
      ,@Woman_StatePopulationId int =null    
           
      ,@Husband_StatePopulationId int  =null            
      ,@Woman_Name  nvarchar(99) =null            
      ,@Husband_Name nvarchar(99)=null            
      ,@Woman_CurrentAge tinyint =null            
      ,@Husband_current_age tinyint =null          
      ,@Match_Score_Analyzed tinyint =null          
      ,@Match_Score_Confirm tinyint= null          
      ,@Created_By int            
      ,@IP_Address varchar(30) =null          
      ,@Woman_ServiceData nvarchar(3000)=null          
      ,@Husband_ServiceData nvarchar(3000)=null        
      ,@WS_URLID int        
      ,@msg nvarchar(200) out            
      ,@Woman_RC_NUMBER nvarchar(99) =null        
      ,@Woman_RC_FAMILY_ID nvarchar(99) =null        
      ,@Woman_RC_MEMBER_ID nvarchar(99) =null        
      ,@Husband_RC_MEMBER_ID nvarchar(99) =null        
     ,@WomenDOB date =null        
     ,@HusbandDOB date =null        
  ---17-03-2021      
     ,@Woman_Gender char(10)=null          
      ,@Husband_Gender char(10)=null          
      ,@Mobile_Number varchar(10)=null          
      ,@Address nvarchar(max)=null          
      ,@APL_BPL nvarchar(50)=null          
      ,@Caste  nvarchar(50) =null          
      ,@Religion nvarchar(50)  =null
      ,@Husband_RC_NUMBER nvarchar(99) =null        
      ,@Husband_RC_FAMILY_ID nvarchar(99) =null           
as            
begin          
If  (@WS_URLID=1)        
Begin        
if exists(select Registration_No from t_State_Family_Data where Registration_No=@Registration_no )            
     begin          
       update t_State_Family_Data set            
       Woman_StatePopulationId = @Woman_StatePopulationId,  Husband_StatePopulationId = @Husband_StatePopulationId,            
       Woman_Name=@Woman_Name, Husband_Name=@Husband_Name, Woman_CurrentAge = @Woman_CurrentAge, Husband_CurrentAge = @Husband_current_age,Match_Score_Confirm = @Match_Score_Confirm,          
       Match_Score_Analyzed= @Match_Score_Analyzed, Woman_ServiceData= @Woman_ServiceData, Husband_ServiceData= @Husband_ServiceData,          
       Updated_On = GETDATE() ,  Updated_By= @Created_By ,   IP_Address=@IP_Address  , Service_Pulled_On=GETDATE(), State_populationdata_wsurl_id = @WS_URLID
      -- Husband_RC_NUMBER=@Husband_RC_NUMBER,Husband_FAMILY_ID=@Husband_RC_FAMILY_ID        
       where Registration_No = @Registration_No            
                 
       set @msg = 'Samagra Record Updated Successfully !!!'            
       end          
                                                     
else            
  begin            
          if  exists(select Woman_StatePopulationId from t_State_Family_Data where (Woman_StatePopulationId=@Woman_StatePopulationId) or (Husband_StatePopulationId= @Woman_StatePopulationId ))            
         begin            
                set @msg = 'Wife Person ID already exists !!!'            
                 
  RETURN            
         end            
  else if exists(select Husband_StatePopulationId from t_State_Family_Data where (Woman_StatePopulationId=@Husband_StatePopulationId) or (Husband_StatePopulationId= @Husband_StatePopulationId ))            
  begin          
     
                set @msg = 'Husband Person ID already exists !!!'            
                RETURN            
         end            
        else          
       begin            
   insert into t_State_Family_Data                
   ([Registration_No]  ,Woman_StatePopulationId  ,Husband_StatePopulationId ,          
   Woman_Name, Husband_Name, Woman_CurrentAge , Husband_CurrentAge  ,Match_Score_Confirm,            
   Match_Score_Analyzed , Woman_ServiceData, Husband_ServiceData,[Created_On] ,[Created_By] ,[IP_Address],Service_Pulled_On, State_populationdata_wsurl_id )          
       
   values                
   (@Registration_No ,@Woman_StatePopulationId ,@Husband_StatePopulationId ,          
   @Woman_Name,@Husband_Name, @Woman_CurrentAge,@Husband_current_age,@Match_Score_Confirm,      
       
   @Match_Score_Analyzed, @Woman_ServiceData,@Husband_ServiceData,GETDATE() ,@Created_By  ,@IP_Address,GETDATE(), @WS_URLID)          
   set @msg = 'Samagra Record Saved Successfully !!! '            
       
  end          
        RETURN      
           end        
end        
   
else        
Begin        
begin            
         
  if  exists(select 1 from t_State_Family_Data where (Woman_RC_NUMBER=@Woman_RC_NUMBER) and (Woman_RC_MEMBER_ID= @Woman_RC_MEMBER_ID ))            
   begin            
                set @msg = 'Member ID of this Ration Card already linked !!!'            
               RETURN            
   end        
        else        
         
   begin        
     insert into t_State_Family_Data                
   ([Registration_No],Woman_Name, Husband_Name, Woman_CurrentAge , Husband_CurrentAge   ,Woman_RC_NUMBER,Woman_RC_FAMILY_ID,Woman_RC_MEMBER_ID,Husband_RC_MEMBER_ID,Match_Score_Confirm,            
   Match_Score_Analyzed , Woman_ServiceData, Husband_ServiceData,WomenDOB,HusbandDOB,[Created_On] ,[Created_By] ,[IP_Address],Service_Pulled_On, State_populationdata_wsurl_id          
   ---17-03-2021          
    ,[Woman_Gender] ,[Husband_Gender],[Mobile_Number],[Address],[APL_BPL],[Caste],[Religion],Husband_RC_NUMBER,Husband_FAMILY_ID)        
   values                
   (@Registration_No,@Woman_Name,@Husband_Name, @Woman_CurrentAge,@Husband_current_age ,@Woman_RC_NUMBER,@Woman_RC_FAMILY_ID,@Woman_RC_MEMBER_ID,@Husband_RC_MEMBER_ID,@Match_Score_Confirm,          
   @Match_Score_Analyzed, @Woman_ServiceData,@Husband_ServiceData,@WomenDOB,@HusbandDOB,GETDATE() ,@Created_By  ,@IP_Address,GETDATE(), @WS_URLID        
     --    
--17-03-2021          
     ,@Woman_Gender,@Husband_Gender ,@Mobile_Number ,@Address,@APL_BPL,@Caste,@Religion,
     @Husband_RC_NUMBER,@Husband_RC_FAMILY_ID)      
       
 set @msg = 'Member ID along with Family ID is linked successfully !!!'            
   end        
  end          
       
end        
                   
end          
   
IF (@@ERROR <> 0)            
BEGIN            
     RAISERROR ('TRANSACTION FAILED',16,-1)            
     ROLLBACK TRANSACTION            
END