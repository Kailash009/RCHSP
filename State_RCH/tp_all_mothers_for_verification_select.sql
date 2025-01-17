USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_all_mothers_for_verification_select]    Script Date: 09/26/2024 16:00:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
     /*
         tp_all_mothers_for_verification_select 7,0,0,0,0,'All',20,0
     */
-- =============================================
ALTER PROCEDURE [dbo].[tp_all_mothers_for_verification_select]
   (
       
        @District_Code int=0,
        @HealthBlock_Code as int=0,
        @HealthFacility_Code as int=0,
        @HealthSubFacility_Code as int=0,
        @Village_Code as int =0,
        @ANM_ID as int=0,
        @Services as Varchar(25)=null,
        @Record_Count as int=0,
        @Year as int=0
   )
as 
 begin

              Declare @Sql nvarchar(max)=null
        if(@Record_Count=1000)
             begin
                  set @Sql='select Top 1000 MReg.Registration_no,MReg.Name_PW as Name,''(''+ MReg.Name_H +'')'' as HusbandName,Age,MReg.Mobile_No,
                     Convert(Varchar(10),anc.ANC_Date,103)as ANC_Date,convert(varchar(10),md.LMP_Date,103)as LMP_Date,Convert(varchar(10),del.Delivery_date,103)as Dly_Date,Convert(varchar(10),md.EDD_Date,103)as EDD_Date,anc.ANC_No as Mobile_Relates_to,'''' as DIST_NAME,'''' as PHC_NAME
                     from t_mother_registration as MReg 
                     left outer join t_mother_anc anc on anc.Registration_no = MReg.Registration_no
		             left outer join t_mother_medical md on md.Registration_no = MReg.Registration_no
		             left outer join t_mother_delivery del on del.Registration_no = MReg.Registration_no
		             Left Outer join t_MotherEntry_Verification as MV on MV.Registration_no = MReg.Registration_no 
                     where 
                    (MReg.Financial_Year='+cast(@Year as varchar)+' or '+cast(@Year as varchar)+'=0)
                     and (MReg.District_Code='+cast(@District_Code as varchar)+' or '+cast(@District_Code as varchar)+'=0)
                     and (MReg.HealthBlock_Code='+cast(@HealthBlock_Code as varchar)+' or '+cast(@HealthBlock_Code as varchar)+'=0)
                     and (MReg.HealthFacility_Code='+cast(@HealthFacility_Code as varchar)+' or '+cast(@HealthFacility_Code as varchar)+'=0)
                     and (MReg.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar)+' or '+cast(@HealthSubFacility_Code as varchar)+'=0) 
                     and ((MReg.Village_Code='+cast(@Village_Code as varchar(5))+' or '+cast(@Village_Code as varchar(5))+'=0) 
                           and(MReg.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(5))+' or '+cast(@HealthSubFacility_Code as varchar(5))+'=0))
                     and (MReg.ANM_ID='+cast(@ANM_ID as varchar)+' or '+cast(@ANM_ID as varchar)+'=0)
                     and MReg.Mobile_No<>'''' 
                     and MReg.Mobile_No is not null
                     and anc.ANC_No =1
                     and isnull(MReg.Delete_mother,0) <> 1'
              
               end

          else
               Begin
                    set @Sql='select MReg.Registration_no,MReg.Name_PW as Name,''(''+ MReg.Name_H +'')'' as HusbandName,Age,MReg.Mobile_No,
                     Convert(Varchar(10),anc.ANC_Date,103)as ANC_Date,convert(varchar(10),md.LMP_Date,103)as LMP_Date,Convert(varchar(10),del.Delivery_date,103)as Dly_Date,Convert(varchar(10),md.EDD_Date,103)as EDD_Date,anc.ANC_No as Mobile_Relates_to,'''' as DIST_NAME,'''' as PHC_NAME
                     from t_mother_registration as MReg 
                     left outer join t_mother_anc anc on anc.Registration_no = MReg.Registration_no
		             left outer join t_mother_medical md on md.Registration_no = MReg.Registration_no
		             left outer join t_mother_delivery del on del.Registration_no = MReg.Registration_no
		             Left Outer join t_MotherEntry_Verification as MV on MV.Registration_no = MReg.Registration_no 
                     where 
                    (MReg.Financial_Year='+cast(@Year as varchar)+' or '+cast(@Year as varchar)+'=0)
                     and (MReg.District_Code='+cast(@District_Code as varchar)+' or '+cast(@District_Code as varchar)+'=0)
                     and (MReg.HealthBlock_Code='+cast(@HealthBlock_Code as varchar)+' or '+cast(@HealthBlock_Code as varchar)+'=0)
                     and (MReg.HealthFacility_Code='+cast(@HealthFacility_Code as varchar)+' or '+cast(@HealthFacility_Code as varchar)+'=0)
                     and (MReg.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar)+' or '+cast(@HealthSubFacility_Code as varchar)+'=0)
                     and ((MReg.Village_Code='+cast(@Village_Code as varchar(5))+' or '+cast(@Village_Code as varchar(5))+'=0) 
                          and(MReg.HealthSubFacility_Code='+cast(@HealthSubFacility_Code as varchar(5))+' or '+cast(@HealthSubFacility_Code as varchar(5))+'=0)) 
                     and (MReg.ANM_ID='+cast(@ANM_ID as varchar)+' or '+cast(@ANM_ID as varchar)+'=0)
                     and MReg.Mobile_No<>'''' 
                     and MReg.Mobile_No is not null
                     and anc.ANC_No =1
                     and isnull(MReg.Delete_mother,0) <> 1'
                   
                  end
         --print(@SQL)
           exec(@Sql)
END





