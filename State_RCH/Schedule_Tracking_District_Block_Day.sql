USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_Tracking_District_Block_Day]    Script Date: 09/26/2024 14:46:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*

*/

ALTER proc [dbo].[Schedule_Tracking_District_Block_Day]

as
begin
truncate table  Scheduled_Tracking_District_Block_Day 
insert into Scheduled_Tracking_District_Block_Day(State_Code,District_Code,HealthBlock_Code,[Year_ID],[Month_ID]
,[Total_LMP],[ANC1],[ANC2],[ANC3],[ANC4],[TT1],[TT2],[TTBooster],[IFA],[Delivery],[All_ANC],[Any_three_ANC]
,[SC_Total_LMP],[SC_ANC1],[SC_ANC2],[SC_ANC3],[SC_ANC4],[SC_TT1],[SC_TT2],[SC_TTBooster],[SC_IFA],[SC_Delivery],[SC_All_ANC],[SC_Any_three_ANC]
,[ST_Total_LMP],[ST_ANC1],[ST_ANC2],[ST_ANC3],[ST_ANC4],[ST_TT1],[ST_TT2],[ST_TTBooster],[ST_IFA],[ST_Delivery],[ST_All_ANC],[ST_Any_three_ANC]
,[OTHERC_Total_LMP],[OTHERC_ANC1],[OTHERC_ANC2],[OTHERC_ANC3],[OTHERC_ANC4],[OTHERC_TT1],[OTHERC_TT2],[OTHERC_TTBooster],[OTHERC_IFA],[OTHERC_Delivery],[OTHERC_All_ANC],[OTHERC_Any_three_ANC]
,[APL_Total_LMP],[APL_ANC1],[APL_ANC2],[APL_ANC3],[APL_ANC4],[APL_TT1],[APL_TT2],[APL_TTBooster],[APL_IFA],[APL_Delivery],[APL_All_ANC],[APL_Any_three_ANC]
,[BPL_Total_LMP],[BPL_ANC1],[BPL_ANC2],[BPL_ANC3],[BPL_ANC4],[BPL_TT1],[BPL_TT2],[BPL_TTBooster],[BPL_IFA],[BPL_Delivery],[BPL_All_ANC],[BPL_Any_three_ANC]
,[NotKnown_Total_LMP],[NotKnown_ANC1],[NotKnown_ANC2],[NotKnown_ANC3],[NotKnown_ANC4],[NotKnown_TT1],[NotKnown_TT2],[NotKnown_TTBooster],[NotKnown_IFA],[NotKnown_Delivery],[NotKnown_All_ANC],[NotKnown_Any_three_ANC]
,[Christian_Total_LMP],[Christian_ANC1],[Christian_ANC2],[Christian_ANC3],[Christian_ANC4],[Christian_TT1],[Christian_TT2],[Christian_TTBooster],[Christian_IFA],[Christian_Delivery],[Christian_All_ANC],[Christian_Any_three_ANC]
,[Hindu_Total_LMP],[Hindu_ANC1],[Hindu_ANC2],[Hindu_ANC3],[Hindu_ANC4],[Hindu_TT1],[Hindu_TT2],[Hindu_TTBooster],[Hindu_IFA],[Hindun_Delivery],[Hindu_All_ANC],[Hindu_Any_three_ANC]
,[Muslim_Total_LMP],[Muslim_ANC1],[Muslim_ANC2],[Muslim_ANC3],[Muslim_ANC4],[Muslim_TT1],[Muslim_TT2],[Muslim_TTBooster],[Muslim_IFA],[Muslim_Delivery],[Muslim_All_ANC],[Muslim_Any_three_ANC]
,[Sikh_Total_LMP],[Sikh_ANC1],[Sikh_ANC2],[Sikh_ANC3],[Sikh_ANC4],[Sikh_TT1],[Sikh_TT2],[Sikh_TTBooster],[Sikh_IFA],[Sikh_Delivery],[Sikh_All_ANC],[Sikh_Any_three_ANC]
,[OTHERR_Total_LMP],[OTHERR_ANC1],[OTHERR_ANC2],[OTHERR_ANC3],[OTHERR_ANC4],[OTHERR_TT1],[OTHERR_TT2],[OTHERR_TTBooster],[OTHERR_IFA],[OTHERR_Delivery],[OTHERR_All_ANC]
,[OTHERR_Any_three_ANC],[HR_Total_LMP],[HR_ANC1],[HR_ANC2],[HR_ANC3],[HR_ANC4],[HR_TT1],[HR_TT2],[HR_TTBooster],[HR_IFA],[HR_Delivery],[HR_All_ANC],[HR_Any_three_ANC]
,[Fin_Yr],[Date_As_On])

SELECT State_Code,DISTRICT_CD ,HealthBlock_Code,[Year_ID],[Month_ID] 
,Sum([Total_LMP]),Sum([ANC1]),Sum([ANC2]),Sum([ANC3]),Sum([ANC4]),Sum([TT1]),Sum([TT2]),Sum([TTBooster]),Sum([IFA]),Sum([Delivery]),Sum([All_ANC]),Sum([Any_three_ANC]),SUM([SC_Total_LMP])
,SUM([SC_ANC1]),SUM([SC_ANC2]),SUM([SC_ANC3]),SUM([SC_ANC4]),SUM([SC_TT1]),SUM([SC_TT2]),SUM([SC_TTBooster]),SUM([SC_IFA]),SUM([SC_Delivery]),SUM([SC_All_ANC]),SUM([SC_Any_three_ANC])
,SUM([ST_Total_LMP]),SUM([ST_ANC1]),SUM([ST_ANC2]),SUM([ST_ANC3]),SUM([ST_ANC4]),SUM([ST_TT1]),SUM([ST_TT2]),SUM([ST_TTBooster]),SUM([ST_IFA]),SUM([ST_Delivery]),SUM([ST_All_ANC]),SUM([ST_Any_three_ANC])
,SUM([OTHERC_Total_LMP]),SUM([OTHERC_ANC1]),SUM([OTHERC_ANC2]),SUM([OTHERC_ANC3]),SUM([OTHERC_ANC4]),SUM([OTHERC_TT1]),SUM([OTHERC_TT2]),SUM([OTHERC_TTBooster]),SUM([OTHERC_IFA]),SUM([OTHERC_Delivery]),SUM([OTHERC_All_ANC]),SUM([OTHERC_Any_three_ANC])

,SUM([APL_Total_LMP]),SUM([APL_ANC1]),SUM([APL_ANC2]),SUM([APL_ANC3]),SUM([APL_ANC4]),SUM([APL_TT1]),SUM([APL_TT2]),SUM([APL_TTBooster]),SUM([APL_IFA]),SUM([APL_Delivery]),SUM([APL_All_ANC]),SUM([APL_Any_three_ANC])
,SUM([BPL_Total_LMP]),SUM([BPL_ANC1]),SUM([BPL_ANC2]),SUM([BPL_ANC3]),SUM([BPL_ANC4]),SUM([BPL_TT1]),SUM([BPL_TT2]),SUM([BPL_TTBooster]),SUM([BPL_IFA]),SUM([BPL_Delivery]),SUM([BPL_All_ANC]),SUM([BPL_Any_three_ANC])
,SUM([NotKnown_Total_LMP]),SUM([NotKnown_ANC1]),SUM([NotKnown_ANC2]),SUM([NotKnown_ANC3]),SUM([NotKnown_ANC4]),SUM([NotKnown_TT1]),SUM([NotKnown_TT2]),SUM([NotKnown_TTBooster]),SUM([NotKnown_IFA]),SUM([NotKnown_Delivery]),SUM([NotKnown_All_ANC]),SUM([NotKnown_Any_three_ANC])
,SUM([Christian_Total_LMP]),SUM([Christian_ANC1]),SUM([Christian_ANC2]),SUM([Christian_ANC3]),SUM([Christian_ANC4]),SUM([Christian_TT1]),SUM([Christian_TT2]),SUM([Christian_TTBooster]),SUM([Christian_IFA]),SUM([Christian_Delivery]),SUM([Christian_All_ANC]),SUM([Christian_Any_three_ANC])
,SUM([Hindu_Total_LMP]),SUM([Hindu_ANC1]),SUM([Hindu_ANC2]),SUM([Hindu_ANC3]),SUM([Hindu_ANC4]),SUM([Hindu_TT1]),SUM([Hindu_TT2]),SUM([Hindu_TTBooster]),SUM([Hindu_IFA]),SUM([Hindun_Delivery]),SUM([Hindu_All_ANC]),SUM([Hindu_Any_three_ANC])
,SUM([Muslim_Total_LMP]),SUM([Muslim_ANC1]),SUM([Muslim_ANC2]),SUM([Muslim_ANC3]),SUM([Muslim_ANC4]),SUM([Muslim_TT1]),SUM([Muslim_TT2]),SUM([Muslim_TTBooster]),SUM([Muslim_IFA]),SUM([Muslim_Delivery]),SUM([Muslim_All_ANC]),SUM([Muslim_Any_three_ANC])
,SUM([Sikh_Total_LMP]),SUM([Sikh_ANC1]),SUM([Sikh_ANC2]),SUM([Sikh_ANC3]),SUM([Sikh_ANC4]),SUM([Sikh_TT1]),SUM([Sikh_TT2]),SUM([Sikh_TTBooster]),SUM([Sikh_IFA]),SUM([Sikh_Delivery]),SUM([Sikh_All_ANC]),SUM([Sikh_Any_three_ANC])
,SUM([OTHERR_Total_LMP]),SUM([OTHERR_ANC1]),SUM([OTHERR_ANC2]),SUM([OTHERR_ANC3]),SUM([OTHERR_ANC4]),SUM([OTHERR_TT1]),SUM([OTHERR_TT2]),SUM([OTHERR_TTBooster]),SUM([OTHERR_IFA]),SUM([OTHERR_Delivery]),SUM([OTHERR_All_ANC]),SUM([OTHERR_Any_three_ANC])
,SUM([HR_Total_LMP]),SUM([HR_ANC1]),SUM([HR_ANC2]),SUM([HR_ANC3]),SUM([HR_ANC4]),SUM([HR_TT1]),SUM([HR_TT2]),SUM([HR_TTBooster]),SUM([HR_IFA]),SUM([HR_Delivery]),SUM([HR_All_ANC]),SUM([HR_Any_three_ANC])
,[Fin_Yr],getdate()
FROM Scheduled_Tracking_Block_PHC_Day a 
  inner join TBL_HEALTH_BLOCK b on a.HealthBlock_Code =b.BLOCK_CD
  
  group by State_Code,DISTRICT_CD ,HealthBlock_Code,[Year_ID],[Month_ID] ,Fin_Yr


end






