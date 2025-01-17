USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[fill_RefferalLocation]    Script Date: 09/26/2024 12:00:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
fill_RefferalLocation 26,84,0,5 -- For - PHC CHC DH

fill_RefferalLocation 26,84,274,3  -- For Subcenter

fill_RefferalLocation 1,3,13,0,24

*/

ALTER proc [dbo].[fill_RefferalLocation]
(
@District_Code int=0,
@HealthBlock_Code int=0,
@HealthFacility_Code int=0,
@HealthSubFacility_Code int=0,
@Type int,
@IsOtherDistrict int=0 
)
as
begin
	 if(@Type = 24 and @IsOtherDistrict=0)  
  begin  
   select SUBPHC_NAME_E +' '+'('+d.Name_E+')' as Name,SUBPHC_CD as ID from TBL_SUBPHC sp  
   inner join District d on sp.DIST_CD=d.DCode  
   where DIST_CD=@District_Code and PHC_CD=@HealthFacility_Code --and IsActive=1  
   order by SUBPHC_NAME_E ; 
  end 
  else if(@Type = 24 and @IsOtherDistrict=1)  
  begin  
   --select SUBPHC_NAME_E +' '+'('+d.Name_E+')' as Name,SUBPHC_CD as ID from TBL_SUBPHC sp  
   --inner join District d on sp.DIST_CD=d.DCode  
   --where DIST_CD=@District_Code --and IsActive=1  
   --order by SUBPHC_NAME_E ; 

    select SUBPHC_NAME_E +' '+'('+p.PHC_NAME+')' as Name,SUBPHC_CD as ID from TBL_SUBPHC sp    
  inner join TBL_PHC p  on sp.PHC_CD=p.PHC_CD  
   where 
   sp.DIST_CD=@District_Code --and IsActive=1  
   order by sp.SUBPHC_NAME_E ; 
  end 
  	else if(@Type = 25)
	begin
		select b.Name_E as Name,a.VCode as ID from SC_Wise_Village a inner join Village b on a.VCode=b.VCode 
		where a.SID=@HealthSubFacility_Code --and a.IsActive=1
		order by b.Name_E
	end
		else if (@Type = 28)
  begin
	   select PHC_CD as ID,PHC_NAME +' '+'('+d.Name_E+')' as Name from TBL_PHC p
	   inner join District d on p.DIST_CD=d.DCode
	   where Facility_Type=5  and DIST_CD !=@District_Code
	   order by PHC_NAME
  end
  else if (@Type = 29)
  begin
	   select PHC_CD as ID,PHC_NAME +' '+'('+d.Name_E+')' as Name from TBL_PHC p
	   inner join District d on p.DIST_CD=d.DCode
	   where Facility_Type=17  and DIST_CD !=@District_Code
	   order by PHC_NAME
  end
	else
		begin
			select PHC_CD as ID,PHC_NAME  +' '+'('+d.Name_E+')' as Name from TBL_PHC p
			inner join District d on p.DIST_CD=d.DCode
			where DIST_CD=@District_Code --and BID=@HealthBlock_Code 
			and Facility_Type=@Type  --and IsActive=1
			order by PHC_NAME
		end
end


