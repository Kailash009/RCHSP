USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[tp_Beneficiary_Registration_InUp_CBR]    Script Date: 09/26/2024 12:19:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[tp_Beneficiary_Registration_InUp_CBR] 
         @State_Code INT
        ,@District_Code INT = 0 out
        ,@Sub_District_Code VARCHAR(7) = '' out
        ,@Health_Block_Code INT = 0 out
        ,@Health_Facility_hfr_Id VARCHAR(20) = '' out
        ,@Health_Sub_Facility_hfr_Id VARCHAR(20) = '' out
        ,@Village_Code INT = 0 out
        ,@ANM_hpr_id VARCHAR(17) = ''
        ,@ASHA_hpr_id VARCHAR(17) = '' 
        ,@RCH_Id BIGINT = NULL OUT
        ,@Reference_Id BIGINT = NULL  
        ,@Request_ID VARCHAR(100) = NULL
        ,@Ben_type VARCHAR(20)
        ,@Ben_Name NVARCHAR(99)
        ,@Ben_Mobile_Number VARCHAR(10)
        ,@Ben_DoB DATE
        ,@Ben_Gender VARCHAR(10) = NULL
        ,@Registration_Date Date = NULL
        ,@Whose_Mobile CHAR(1) = NULL
        ,@Caste TINYINT = NULL
        ,@BPL_APL TINYINT = NULL
        ,@Blood_Group VARCHAR(10) = NULL
        ,@ABHA_Number VARCHAR(20) = NULL
        ,@ABHA_Address VARCHAR(75) = NULL
        ,@Is_Pregnant_Woman BIT = NULL
        ,@LMP_Date DATE = NULL
        ,@Ben_Weight INT = NULL
        ,@Address VARCHAR(150) = NULL
        ,@IP_Address VARCHAR(25)
        ,@Source int=NULL
        ,@Msg VARCHAR(200) = '' OUT
        ,@HealthFacility_Type INT=0 out
        ,@Case_no INT=0 out
		,@ABHA_linked_date datetime=NULL
AS
BEGIN
        SET NOCOUNT ON
        DECLARE @str nvarchar(max) 
	    ,@District INT =0
        ,@SubDistrict VARCHAR(7)=''
        ,@Block INT=0
        ,@Facility INT=0
        ,@SubFacility int=0
        ,@Village INT=0
        ,@Facility_Type int=0
		,@tempId int=0
		,@t_msg varchar(200)=''
		,@ANM_ID int=0
		,@RegNo bigint=0,@Case int=0, @BirthYear int=0, @CompareRef bigint=0, @LinkStatus varchar(10)=''
		
		

		IF EXISTS( SELECT 1 FROM t_Ground_Staff where  HPRID=@ANM_hpr_id and Is_Active=1 )
		  BEGIN
		   select top 1  @District=amap.District_Code, @SubDistrict=amap.Taluka_Code, @Block=amap.HealthBlock_Code ,
		   @Facility_Type=amap.HealthFacility_Type,@Facility=amap.HealthFacility_Code, @SubFacility=amap.HealthSubFacility_Code,      
           @Village=isnull(amap.village_code,0),  @ANM_ID=g.ID  from dbo.t_Ground_Staff g WITH (NOLOCK)       
           inner join dbo.t_ANM_ASHA_Mapping_Village amap WITH (NOLOCK) on g.ID=amap.ID  where g.HPRID=@ANM_hpr_id order by amap.Created_On desc

		   IF(@District =0 OR @District ='')
			 BEGIN
			  SELECT  @District = District_Code ,@SubDistrict = Taluka_Code ,@Block =HealthBlock_Code
               ,@Facility = HealthFacilty_Code,@Facility_Type=HealthFacility_Type,@SubFacility = HealthSubFacility_Code
               ,@Village =Village_Code, @ANM_ID=ID FROM t_Ground_Staff where HPRID=@ANM_hpr_id   
			 END
		 end
		ELSE
		  BEGIN
		    IF (@Village_Code <> 0)
              BEGIN
			   select @District= District, @SubDistrict=SubDistrict,@Block=Block, @Facility=Facility,
                     @SubFacility=SubFacility,@Village=Village,@Facility_Type=Facility_Type 
		             FROM fn_get_CBR_hierarchy(@District_Code,@Village_Code,1)
              END
              
			ELSE IF (@Health_Sub_Facility_hfr_Id <> '' AND  @Health_Sub_Facility_hfr_Id <> '0')
              BEGIN
			    select @District= District, @SubDistrict=SubDistrict,@Block=Block, @Facility=Facility,
                     @SubFacility=SubFacility,@Village=Village,@Facility_Type=Facility_Type 
		             FROM fn_get_CBR_hierarchy(@District_Code,@Health_Sub_Facility_hfr_Id,2)
              END
			ELSE IF (@Health_Facility_hfr_Id <> '' AND  @Health_Facility_hfr_Id <> '0')
              BEGIN
			    select @District= District, @SubDistrict=SubDistrict,@Block=Block, @Facility=Facility,
                     @SubFacility=SubFacility,@Village=Village,@Facility_Type=Facility_Type 
		             FROM fn_get_CBR_hierarchy(@District_Code,@Health_Facility_hfr_Id,3)
              END
			 ELSE IF (@Health_Block_Code <> 0)
              BEGIN
			   	select @District= District, @SubDistrict=SubDistrict,@Block=Block, @Facility=Facility,
                     @SubFacility=SubFacility,@Village=Village,@Facility_Type=Facility_Type 
		             FROM fn_get_CBR_hierarchy(@District_Code,@Health_Block_Code,4)
              END
             IF (@District =0 OR @District ='' ) 
              BEGIN
                 SET @Msg = '512'--Hierarchy mismatched
                 RETURN
              END
		  END
		  
		   SELECT top(1) @RegNo=RCH_Id, @Case=r.Case_no  FROM t_Beneficiary_Registration_CBR c JOIN t_mother_registration r on c.RCH_Id=r.Registration_no WHERE c.Reference_Id = @Reference_Id
		   order by r.Case_no desc
		   
		   select @CompareRef=Reference_Id, @LinkStatus=ISNULL(RCH_link_status, '') from t_Beneficiary_Registration_CBR (NOLOCK) where   Ben_Name=@Ben_Name 
		   and Ben_Mobile_Number=@Ben_Mobile_Number and Cast(Ben_DoB as date)=Cast(@Ben_DoB as date)   
		   if(@CompareRef<>0 and @CompareRef !=@Reference_Id)
		   BEGIN
		       SET @RCH_Id=@RegNo
		        set @msg='516'  --Record already exists with same Name,  Mobile number and DoB
		  	  	RETURN
		   END   
		   ELSE
		    BEGIN
			    if(@CompareRef=@Reference_Id and @LinkStatus !='S')
			     BEGIN
			        INSERT INTO l_Beneficiary_Registration_CBR Select * from  t_Beneficiary_Registration_CBR where reference_id=@Reference_Id
					DELETE FROM t_Beneficiary_Registration_CBR where reference_id=@Reference_Id
			     END
		         if (@RegNo=0 or @RegNo='' or @RegNo is null) 
                  BEGIN
                               INSERT INTO t_Beneficiary_Registration_CBR (
                               State_Code,District_Code,Sub_District_Code,Health_Block_Code,Health_Facility_hfr_Id,Health_Sub_Facility_hfr_Id
                               ,Village_Code,ANM_hpr_id,ASHA_hpr_id,RCH_Id,Reference_Id,Request_ID,Ben_type,Ben_Name,Ben_Mobile_Number,Ben_DoB
                               ,Ben_Gender,Registration_Date,Whose_Mobile,Caste,BPL_APL,Blood_Group,ABHA_Number,ABHA_Address,Is_Pregnant_Woman
                               ,LMP_Date,Ben_Weight,Address,IP_Address, Created_on,ABHA_linked_date )
                               VALUES (@State_Code,@District_Code,@Sub_District_Code,@Health_Block_Code,@Health_Facility_hfr_Id,@Health_Sub_Facility_hfr_Id,
                                @Village_Code,@ANM_hpr_id,@ASHA_hpr_id,@RCH_Id,@Reference_Id,@Request_ID,@Ben_type,@Ben_Name,@Ben_Mobile_Number,@Ben_DoB,
                                @Ben_Gender,@Registration_Date,@Whose_Mobile,@Caste,@BPL_APL,@Blood_Group,@ABHA_Number,@ABHA_Address,@Is_Pregnant_Woman,
                                @LMP_Date,@Ben_Weight,@Address,@IP_Address,GETDATE(),@ABHA_linked_date)
                      
                                SET @BirthYear=(SELECT YEAR(@Ben_DoB))
                                EXEC tp_SaveMother_CBR @State_Code,@District,'R',@Block,@SubDistrict,@Facility_Type,@Facility,@SubFacility,@Village
                                ,@Ben_Name,@LMP_Date, @BirthYear,@Ben_DoB,@Ben_Mobile_Number,@Registration_Date,@IP_Address
                                ,@ANM_ID,0,@Reference_Id ,@t_msg out,@RCH_Id out,@Source,''
                                ,0,@ANM_ID,@Ben_type,@case_no out,@Ben_Weight,@Caste,@BPL_APL,@Blood_Group,'',3

                                IF((@RCH_Id<>0) and  (@t_msg='101') )  
						        BEGIN
						           Update t_Beneficiary_Registration_CBR SET
							       RCH_Id=@RCH_Id,
								   RCH_link_status='S',
								   RCH_link_status_dt=GETDATE()
							       where Reference_Id=@Reference_Id
							      
							       set @msg='101'  --Record save successfully 
							       SELECT @Case_no=Max(Case_no) from t_eligibleCouples where Registration_no=@RCH_Id
							       set @District_Code =@District
                                   set @Sub_District_Code =@SubDistrict
                                   set @Health_Block_Code=@Block
                                   set @Health_Facility_hfr_Id=@Facility
                                   SET @Health_Sub_Facility_hfr_Id =@SubFacility
                                   SET @Village_Code=@Village
                                   SET @HealthFacility_Type=@Facility_Type
							       RETURN
						        END
						     ELSE
						      BEGIN
							     Update t_Beneficiary_Registration_CBR SET
								 RCH_link_status='F',
								 RCH_link_status_dt=GETDATE()
							     where Reference_Id=@Reference_Id
						  	    SET @msg=@t_msg  --Record save successfully 
							    RETURN
  						     END
                         END
		         ELSE
		          BEGIN
		            SET @RCH_Id=@RegNo
		            SET @Case_no=@Case
		            set @msg='35'  --Record Already Exists
		  	  	    RETURN
		          END
			END
           
	END     
IF (@@ERROR <> 0)              
BEGIN      
     set @msg='0'        
     RAISERROR ('TRANSACTION FAILED',16,-1)              
     ROLLBACK TRANSACTION              
END 



