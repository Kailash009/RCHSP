USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Schedule_SC_Block_PHC]    Script Date: 09/26/2024 14:46:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
/*  
  Scheduled_SC_GF_PHC_Subcenter
  
*/ 
  
ALTER Proc [dbo].[Schedule_SC_Block_PHC]  
  
AS  
BEGIN  
truncate table Scheduled_SC_Block_PHC
INSERT INTO Scheduled_SC_Block_PHC([HealthBlock_ID],[PHC_ID],[SC_Total],[SC_With_No_ANM],[SC_With_One_ANM],[SC_With_Two_ANM],[SC_With_Three_Or_More_ANM]) 
select b.BID,a.PHC_ID
,COUNT(Subcenter_ID) 
,sum(SC_With_No_ANM)  
,Sum(SC_With_One_ANM)   
,sum(SC_With_Two_ANM)  
,Sum(SC_With_Three_Or_More_ANM)  
from  Scheduled_SC_PHC_Subcenter  a
inner join TBL_PHC b on a.PHC_ID=b.PHC_CD
group by b.BID,a.PHC_ID
END
