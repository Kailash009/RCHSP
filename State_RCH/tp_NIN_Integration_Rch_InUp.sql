USE [nin_db]
GO
/****** Object:  StoredProcedure [dbo].[tp_NIN_Integration_Rch_InUp]    Script Date: 09/26/2024 14:20:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[tp_NIN_Integration_Rch_InUp]
      @tblNIN NIN_Integration_Rch_UDT READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO NIN_Integration_Rch_Data c1
      USING @tblNIN c2
      ON c1.nin_to_hfi=c2.nin_to_hfi
      WHEN MATCHED THEN
      UPDATE SET 
	  c1.block_id=c2.block_id,
	  c1.state_code_lg=c2.state_code_lg,
	  c1.taluka_id=c2.taluka_id,
	  c1.block_name=c2.block_name,
	  c1.creation_date=c2.creation_date,
	  c1.district_id=c2.district_id,
	  c1.district_name=c2.district_name,
	  c1.hfi_name=c2.hfi_name,
	  c1.hfi_type=c2.hfi_type,
	  c1.house_number=c2.house_number,
	  c1.landmark=c2.landmark,
	  c1.last_updated=c2.last_updated,
	  c1.locality=c2.locality,
	  c1.nin_updated_on=c2.nin_updated_on,
	  c1.phc_chc_type=c2.phc_chc_type,
	  c1.pincode=c2.pincode,
	  c1.region_indicator=c2.region_indicator,
	  c1.state_id=c2.state_id,
	  c1.state_name=c2.state_name,
	  c1.street=c2.street,
	  c1.taluka_name=c2.taluka_name,
	  c1.district_code_lg=c2.district_code_lg,
	  c1.taluka_code_lg=c2.taluka_code_lg
      WHEN NOT MATCHED THEN
      INSERT VALUES(
	                c2.nin_to_hfi,
	                c2.block_id,
	                c2.state_code_lg,
	                c2.taluka_id,
	                c2.block_name,
	                c2.creation_date,
	                c2.district_id,
	                c2.district_name,
	                c2.hfi_name,
	                c2.hfi_type,
	                c2.house_number,
	                c2.landmark,
	                c2.last_updated,
	                c2.locality,
	                c2.nin_updated_on,
	                c2.phc_chc_type,
	                c2.pincode,
	                c2.region_indicator,
	                c2.state_id,
	                c2.state_name,
	                c2.street,
	                c2.taluka_name,
	                c2.district_code_lg,
	                c2.taluka_code_lg
	               );
END



