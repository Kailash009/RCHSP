USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Get_GroundStaffData_ForVerification]    Script Date: 09/26/2024 12:00:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/* [dbo].[Get_GroundStaffData_ForVerification]20,0,0,0,1,1,15070*/
ALTER PROCEDURE [dbo].[Get_GroundStaffData_ForVerification]
 ( @District_ID int=0,
   @Healthblock_ID int=0,
   @HealthFacilty_ID int=0,
   @SubCentre_ID int=0,
   @TypeID int=0,
   @Is_ANM_ASHA int=0,
   @ID as int=0 
   )
	
AS
BEGIN
     if(@TypeID=1 or @TypeID=0)--For Not verified Record
       begin
           if(@Is_ANM_ASHA=1)
                begin
                     select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No],Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code where
                       Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0) 
                       and Gs.Type_ID<>1
                       and Gs.ID = @ID
                
                       
                 end
           else
                 begin
                      select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No],Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name
                       from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code
                        where Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0) 
                       and Gs.Type_ID=1
                       and Gs.ID = @ID
                       
             
                 end
          end
     if(@TypeID=2)
        begin
            if(@Is_ANM_ASHA=1)
                 begin
                     select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No],Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code 
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name
                       from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID 
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code where
                       Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0) 
                       and Gs.Type_ID<>1
                       and Gs.ID = @ID
                end
             else
                begin
                    select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No]
                       ,Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name
                        from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code where
                       Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0) 
                       and Gs.Type_ID=1
                       and Gs.ID = @ID
                 end
        end
        if(@TypeID=3)
        begin
            if(@Is_ANM_ASHA=1)
                 begin
                     select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No],Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code 
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name
                       from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID 
                       left outer join t_Ground_StaffEntry_Verification as GSEntry on GSEntry.ID=Gs.ID 
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code where
                       Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0) 
                       and ((GSEntry.NoCall_Reason in (1,2)) or (GSEntry.NoPhone_Reason in (3,4,5)))
                       and Gs.Type_ID<>1
                       and Gs.ID = @ID
                end
             else
                begin
                    select Gs.[ID],Gs.[Name],(case Gs.[Type_ID]
                       when 1 then 'ASHA'
                       when 2 then 'ANM'
                       when 3 then 'ANM2'
                       when 4 then 'lINK WORKER'
                       when 5 then 'MPW'
                       when 6 then 'GNM'
                       when 7 then 'CHV'
                       when 8 then 'AWW'end ) as Designation,
                       Gs.[Husband_Name],Gs.[Contact_No]
                       ,Gs.[Address],Gs.[Is_Active],Gs.[Aadhar_No],Gs.[EID_No],Gs.[EID_Time],GSBank.Bank_Name,
                       GsBank.Acc_No,Gs.District_Code,Gs.Rural_Urban,Gs.Taluka_Code,Gs.HealthBlock_Code,Gs.HealthFacilty_Code,Gs.HealthSubFacility_Code,Gs.Village_Code
                       ,dst.DIST_NAME as District_Name,hb.Block_Name_E as HealthBlock_Name,ph.PHC_NAME as PHC_Name,sPhc.SUBPHC_NAME as SubCentre_Name,V.VILLAGE_NAME as Village_Name
                        from t_Ground_Staff Gs 
                       left outer join t_Ground_Staff_BankDetails GSBank on GsBank.Registration_no=Gs.ID
                       left outer join t_Ground_StaffEntry_Verification as GSEntry on GSEntry.ID=Gs.ID 
                       inner join TBL_DISTRICT dst on dst.DIST_CD=Gs.District_Code
                       inner join TBL_HEALTH_BLOCK hb on hb.BLOCK_CD=Gs.HealthBlock_Code
                       inner join TBL_PHC ph on ph.PHC_CD = Gs.HealthFacilty_Code
                       left outer join TBL_SUBPHC sPhc on sPhc.SUBPHC_CD = Gs.HealthSubFacility_Code
                       left outer join TBL_VILLAGE V on V.VILLAGE_CD = Gs.Village_Code where
                       Gs.District_Code=@District_ID 
                       and (Gs.HealthBlock_Code = @Healthblock_ID or @Healthblock_ID=0)
                       and (Gs.HealthFacilty_Code=@HealthFacilty_ID or @HealthFacilty_ID=0)
                       and (Gs.HealthSubFacility_Code=@SubCentre_ID or @SubCentre_ID=0)
                        and ((GSEntry.NoCall_Reason in (1,2)) or (GSEntry.NoPhone_Reason in (3,4,5))) 
                       and Gs.Type_ID=1
                       and Gs.ID = @ID
                 end
        end
END




