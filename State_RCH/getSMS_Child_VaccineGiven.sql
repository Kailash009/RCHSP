USE [RCH_28]
GO
/****** Object:  UserDefinedFunction [dbo].[getSMS_Child_VaccineGiven]    Script Date: 09/26/2024 12:39:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






ALTER FUNCTION [dbo].[getSMS_Child_VaccineGiven](@ID int,@Month varchar(3),@Year as int,@type as varchar(15))
RETURNS @retChildVaccineInformation TABLE 
(
    
    
    HP_Name nvarchar(40) NULL,
    Name nVarchar(100)  NULL ,
    Dose varchar(300),
    ID_no varchar(18),
    TypeID nvarchar(29),
    Dayspast int
    

)
AS 

BEGIN

Declare @FDate as Datetime
Declare @LDate as Datetime

set @FDate=cast('01/'+@Month+'/'+ CAST(@Year as varchar(4)) as datetime)
set @LDate=DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@FDate)+1,0))    
if(@type='')
set @type=(select type from ground_Staff where ID=@ID) 

if(@type<>'ASHA')
Begin 
        
INSERT @retChildVaccineInformation

select b.Name,a.Name+'('+right(a.yr,2)+'-'+cast(a.sno as varchar)+')' as Name,dbo.GetImmunizationDetail([dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt,@Month,CONVERT(varchar(4),@Year),4)) as child
,ID_no
, [dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt,@Month,CONVERT(varchar(4),@Year),4) as TypeID,datediff(day,Birthdate,@Fdate) as dayspast
from NRHM_Format_Child a
inner join Ground_Staff B on a.District_ID=b.District_ID 
 and A.Healthblock_ID=b.Healthblock_ID 
and A.PHC_ID=B.PHC_ID 
and A.SubCentre_ID=B.SubCentre_ID 
and A.ANM_Name=B.Name

where isnull(a.Delete_mother,0)<>1
and a.Birthdate is not null
and (isnull(a.Entry_Type,1)= 1 or a.Entry_Type=2)
and [dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt ,@Month,CONVERT(varchar(4),@Year),4)<>'00000000000000000000000000000' 
and b.ID=@ID
end

else

Begin 
        
INSERT @retChildVaccineInformation
select b.Name,a.Name+'('+right(a.yr,2)+'-'+cast(a.sno as varchar)+')' as Name,dbo.GetImmunizationDetail([dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt,@Month,CONVERT(varchar(4),@Year),4)) as child
,ID_no
, [dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt,@Month,CONVERT(varchar(4),@Year),4) as TypeID ,datediff(day,Birthdate,@Fdate) as dayspast
from NRHM_Format_Child a
inner join Ground_Staff B on a.District_ID=b.District_ID 
 and A.Healthblock_ID=b.Healthblock_ID 
and A.PHC_ID=B.PHC_ID 
and A.SubCentre_ID=B.SubCentre_ID 
and A.ASHA_Name=B.Name
where isnull(a.Delete_mother,0)<>1
and a.Birthdate is not null
and (isnull(a.Entry_Type,1)= 1 or a.Entry_Type=2)
and  [dbo].[GetImmunizationNo](Birthdate ,BCG_Dt,OPV0_Dt,HepatitisB1_Dt,DPT1_Dt,OPV1_Dt,HepatitisB2_Dt,OPV2_Dt,DPT2_Dt,HepatitisB3_Dt,OPV3_Dt,DPT3_Dt ,HepatitisB4_Dt ,Measles_Dt ,VitA_Dose1_Dt,DPTBooster_Dt,OPVBooster_Dt, MR_Dt,VitA_Dose2_Dt,VitA_Dose3_Dt,VitA_Dose9_Dt,VitA_Dose5_Dt,VitA_Dose6_Dt,VitA_Dose7_Dt,VitA_Dose8_Dt,VitA_Dose99_Dt,DT5_Dt,TT10_Dt,TT16_Dt ,JE_Dt ,@Month,CONVERT(varchar(4),@Year),4)<>'00000000000000000000000000000' 
and b.ID=@ID
end
    RETURN;
END;

/*
[dbo].[getANM_ASHA_Record](18,'589',3004,'ANM')
*/


/*


Rpt_W_Workplan_Summary_Detail_Child 2012,feb,15,0,0,0,0,'BCG_Overdue'


*/




