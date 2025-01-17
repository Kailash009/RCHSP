USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Scheduled_HWC_Count_Statewise]    Script Date: 09/26/2024 14:47:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --select * from HWC_WISE_DATA
--exec Scheduled_HWC_Count_Statewise_temp     
ALTER   proc [dbo].[Scheduled_HWC_Count_Statewise] --Created By Aditya16052019      
AS      
declare @Query varchar(max)      
declare @Dte varchar(20)      
declare @Dte_1 varchar(20)      
declare @Month varchar(2)      
declare @year varchar(4)      
BEGIN      
SET NOCOUNT ON;      
IF OBJECT_ID('tempdb..#tbl_HWC') IS NOT NULL      
  Begin      
    drop TABLE #tbl_HWC      
  End      
    select @Dte=DATEADD(MONTH ,-1,GETDATE())      
    SELECT  @Month = MONTH(DATEADD(MONTH ,-1,GETDATE()))      
    SELECT  @year = YEAR(DATEADD(MONTH ,-1,GETDATE()))      
   --*********Check For monthly wise last date******************-----      
            
       if (@Month ='4' or @Month ='6' or @Month ='9' or @Month ='11')      
     Begin      
    SET @Dte_1 = @year+'-'+@Month+'-'+'30'      
     end      
       if (@Month ='1' or @Month ='3' or @Month ='5' or @Month ='7' or @Month ='8' or @Month ='10'or @Month ='12')      
     Begin      
   SET @Dte_1= @year+'-'+@Month+'-'+'31'      
     end       
       if (@Month ='2')      
     Begin      
    SET @Dte_1 = @year+'-'+@Month+'-'+'28'      
     end      
           
    --PRINT (@Dte_1);      
        
  select * into #tbl_HWC from      
            (      
            (select  state_code,pid,sid,S.NIN_Number as NINNUMBER, ES.estimated_mother AS 'a10' --**10**--      
    ,0 as 'a11',0 as 'a12',0 as 'a13',0 as 'a14',0 as 'a15', 0 as 'a16',0 as 'a17'      
    ,0 as 'a18',0 as 'a19',0 as 'a20A',0 as 'a20B',0 as 'a20C'      
    ,0 as 'a20D',0 AS 'a21',0 AS 'a22',0 AS 'a23'      
    from dbo.Estimated_Data_SubCenter_Wise as ES WITH (NOLOCK)      
    left outer join Health_SubCentre AS S WITH (NOLOCK)      
    on  S.SID = ES.HealthSubFacility_Code and S.pid = ES.HealthFacility_Code      
    where s.HWC='Y'  and es.Financial_Year = YEAR(@Dte))      
    UNION ALL      
   (select state_code,  pid,0 sid,S.NIN_Number,Estimated_mother AS 'a10'      
   ,0 as 'a11',0 as 'a12',0 as 'a13',0 as 'a14',0 as 'a15', 0 as 'a16',0 as 'a17'      
    ,0 as 'a18',0 as 'a19',0 as 'a20A',0 as 'a20B',0 as 'a20C'      
    ,0 as 'a20D',0 AS 'a21',0 AS 'a22' ,0 AS 'a23'      
    from dbo.Estimated_Data_PHC_Wise as EP WITH (NOLOCK)      
    left outer join Health_PHC AS S WITH (NOLOCK)      
  on  S.PID = EP.HealthFacility_Code      
    where s.HWC='Y' and ep.Financial_Year =  YEAR(@Dte))      
   )AS A       
   --------------------      
   alter table  #tbl_HWC alter column pid int not null      
   alter table  #tbl_HWC alter column sid int not null      
   alter table  #tbl_HWC add primary key (pid,sid)      
   -------------------------------------No of PW Registered for ANC-------------------------------------------11      
          ;with CTS as       
    (      
     SELECT  P.PID,P.SID      
         ,COUNT(1) '11'  FROM t_mother_flat_Count  AS t WITH (NOLOCK)      
         inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
         where  MONTH(t.Mother_Registration_Date)=month(@Dte) and year(t.Mother_Registration_Date)=year(@Dte)      
    group by P.PID,P.SID       
    )        
    update P set a11=c.[11] from cts c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID      
          
 ---------------------------------------No of PW Registered for ANC Service as per schedule month----------------12      
print('12')      
    ;with CTS_12 as      
    (          
     SELECT  COUNT(1) as'12', P.PID,P.SID      
     FROM t_mother_flat_Count as t WITH (NOLOCK)      
     inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
     where   
	 --MONTH(t.Mother_Registration_Date)=month(@Dte) and  year(t.Mother_Registration_Date) =year(@Dte)      
   --  and (t.ANC1 IS NOT NULL OR t.ANC2 IS NOT NULL OR t.ANC3 IS NOT NULL OR t.ANC4 IS NOT NULL)
	 (MONTH(t.anc1)=month(@Dte) and year(t.anc1) = year(@dte)) or
	 (MONTH(t.anc2)=month(@Dte) and year(t.anc2) = year(@dte)) or
	 (MONTH(t.anc3)=month(@Dte) and year(t.anc3) = year(@dte)) or
	 (MONTH(t.anc4)=month(@Dte) and year(t.anc4) = year(@dte)) 
     group by P.PID,P.SID       
    )      
    update P set a12=c.[12] from CTS_12 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
 ------------------------------------------No of PW  who received full ANC -------------------------------------13      
print('13')      
    ;with CTS_13 as      
    (         
     SELECT P.PID,P.SID,COUNT(1) as '13'      
 FROM t_mother_flat_Count as t WITH (NOLOCK)      
     inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
     WHERE t.ANC1 IS NOT NULL AND t.ANC2 IS NOT NULL AND  t.ANC3 IS NOT NULL AND t.ANC4 IS NOT NULL      
     and   MONTH(t.anc4)=month(@Dte) and year(t.anc4) = year(@dte)
  --and MONTH(t.Mother_Registration_Date)=month(@Dte) and year(t.Mother_Registration_Date) =year(@Dte)      
     group by P.PID,P.SID       
    )      
    update P set a13=c.[13] from CTS_13 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
 --------------------------------------------No of High Risk PW  ----------------------------------------------------14      
print('14')      
   ;with cts_14 as      
   (      
    select P.PID,P.SID,COUNT(1)AS '14' from t_mother_flat_Count as t WITH (NOLOCK)          
    inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where        
    t.High_risk_Severe =1 and MONTH(t.Mother_Registration_Date)=month(@Dte) AND year(t.Mother_Registration_Date) =year(@Dte)       
    group by P.PID,P.SID       
   )      
   update P set a14=c.[14] from cts_14 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
    --------------------------------------------No of High Risk PW for schduled month-------------------------------------15      
         
   ;with cts_15 as       
   (      
    select P.PID,P.SID,COUNT(1)AS '15' from t_mother_flat_Count as t WITH (NOLOCK)          
    inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where t.High_risk_Severe =1    and   
    --and  (t.ANC1 IS NOT NULL OR t.ANC2 IS NOT NULL OR t.ANC3 IS NOT NULL OR t.ANC4 IS NOT NULL)      
	((MONTH(ANC1)<>MONTH(t.Mother_Registration_Date) --and Year(ANC1)<>Year(t.Mother_Registration_Date)
	and Month (ANC1) = month(@Dte) and Year (ANC1) = Year(@Dte) ) OR
	(MONTH(ANC2)<>MONTH(t.Mother_Registration_Date)-- and Year(ANC2)<>Year(t.Mother_Registration_Date)
	and Month (ANC2) = month(@Dte) and Year (ANC2) = Year(@Dte) ) OR
	(MONTH(ANC3)<>MONTH(t.Mother_Registration_Date) --and Year(ANC3)<>Year(t.Mother_Registration_Date)
	and Month (ANC3) = month(@Dte) and Year (ANC3) = Year(@Dte) ) OR
	(MONTH(ANC4)<>MONTH(t.Mother_Registration_Date) --and Year(ANC4)<>Year(t.Mother_Registration_Date)
	and Month (ANC4) = month(@Dte) and Year (ANC4) = Year(@Dte) )) 
        
    group by P.PID,P.SID       
   )      
   update P set a15=c.[15] from cts_15 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
         
         
         
 -------------------------------------------No of Registred Child whose immunization due that month---------------------------16      
         
   ;with cts_16 as       
   (      
    select P.PID,P.SID,      
    COUNT(1)AS '16' from t_child_flat_Count AS t WITH (NOLOCK)      
    inner join t_workplanChild as w WITH (NOLOCK)      
    on t.Registration_no=w.Registration_no       
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where    w.Due_Month=month(@Dte) and w.Due_Yr=year(@Dte)      
    group by P.PID,P.SID       
   )      
   update P set a16=c.[16] from cts_16 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
      
  -----------------------------------------No of Registred Child whose immunization given that month--------------------------------17      
         
   ;with cts_17 as       
   (      
    select P.PID,P.SID,      
    COUNT(1)AS '17' from t_child_flat_Count AS t WITH (NOLOCK)      
    inner join t_workplanChild as w WITH (NOLOCK)      
    on t.Registration_no=w.Registration_no       
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where   w.Given_Month=month(@Dte) and w.Given_Yr=year(@Dte)      
    group by P.PID,P.SID       
   )      
   update P set a17=c.[17] from cts_17 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
      
 ----------------------------------------No of Registred Child up to 2 years ------------------------------------------------------18      
         
   ;with cts_18 as       
   (      
    select  P.PID,P.SID,      
    COUNT(1)as '18' from t_child_flat_Count AS t WITH (NOLOCK)      
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  datediff(day,t.Child_Birthdate_Date,@Dte_1) <=731      
    and MONTH(t.Child_Registration_Date)=month(@Dte) and   year(t.Child_Registration_Date)=year(@Dte)      
    group by P.PID,P.SID       
   )      
   update P set a18=c.[18] from cts_18 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
      
 ---------------------------------------No of Registred Child up to 2 years who received full immunization--------------------------19      
       
   ;with cts_19 as       
   (      
    select  P.PID,P.SID,      
    COUNT(1)AS '19' from t_child_flat_Count AS t WITH (NOLOCK)      
    inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  datediff(day,t.Child_Birthdate_Date,@Dte_1) <=731   and   
     t.Child_FullyImmunised_Y =1      
	 and  month (ISNULL(Measles1_Dt,MR1_Dt))=month(@Dte)  and   Year(ISNULL(Measles1_Dt,MR1_Dt))= year (@Dte)
    group by P.PID,P.SID       
   )      
   update P set a19=c.[19] from cts_19 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
      
 ---------------------------------------------------------public place------------------------------------------------------20A      
         
   ;with cts_20a as       
   (      
    select P.PID,P.SID,      
     COUNT(1) as '20A'  from t_mother_flat as t WITH (NOLOCK)         
    left outer join   RCH_National_Level.dbo.m_DeliveryPlace as N WITH (NOLOCK)       
    ON T.Delivery_Place_val = N.Id       
    inner join  #tbl_HWC P WITH (NOLOCK)  on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  MONTH(t.Delivery_date)=month(@Dte) and Year(t.Delivery_date)=year(@Dte) AND       
    -- N.id not in (27,21) 
	N.Name not in ('Accredited Private Hospital','Other Private Hospital')       
    group by P.PID,P.SID       
   )      
   update P set a20A=c.[20A] from cts_20a c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
      
 ------------------------------------------------------------------------------------------------------------------20B      
         
   ;with cts_20b as       
   (      
    select P.PID,P.SID,      
     COUNT(1) as '20B'  from t_mother_flat as t WITH (NOLOCK)         
    left outer join   RCH_National_Level.dbo.m_DeliveryPlace as N WITH (NOLOCK)       
    ON T.Delivery_Place_val = N.ID       
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  MONTH(t.Delivery_date)=month(@Dte) and Year(t.Delivery_date)=year(@Dte) AND       
     N.ID  =22      
    group by P.PID,P.SID       
   )      
   update P set a20B=c.[20B] from cts_20b c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
 ------------------------------------------------------------------------------------------------------------------20C      
         
   ;with cts_20C as       
   (      
    select P.PID,P.SID,      
     COUNT(1) as '20C'  from t_mother_flat as t WITH (NOLOCK)         
    left outer join   RCH_National_Level.dbo.m_DeliveryPlace as N WITH (NOLOCK)       
    ON T.Delivery_Place_VAl = N.id       
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  MONTH(t.Delivery_date)=month(@Dte) and Year(t.Delivery_date)=year(@Dte) AND       
     N.id = 23     
    group by P.PID,P.SID       
   )      
   update P set a20C=c.[20C] from cts_20C c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID      
 -------------------------------------------------------------------------------------------------------------------20D      
         
   ;with cts_20D as       
   (      
    select P.PID,P.SID,      
     COUNT(1) as '20D'  from t_mother_flat as t WITH (NOLOCK)         
    left outer join   RCH_National_Level.dbo.m_DeliveryPlace as N WITH (NOLOCK)       
    ON T.Delivery_Place_val = N.ID       
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where  MONTH(t.Delivery_date)=month(@Dte) and Year(t.Delivery_date)=year(@Dte) AND       
   --  N.ID  in (27,21) 
   N.Name  in ('Accredited Private Hospital','Other Private Hospital')      
    group by P.PID,P.SID       
   )      
   update P set a20D=c.[20D] from cts_20D c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
 ---------------------------------------------No of newborn under facility----------------------------------------------21      
        
      
   ;WITH cts_21 as      
   (      
    select  P.PID,P.SID,      
    COUNT(1)AS '21' from t_child_flat_Count AS t WITH (NOLOCK)      
    inner join  #tbl_HWC P WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where   month(t.Child_Registration_Date)=month(@Dte)  and  year(t.Child_Registration_Date)=year(@Dte)     
	and datediff(day,t.Child_Birthdate_Date,t.Child_Registration_Date) <=42
    group by P.PID,P.SID       
   )      
   update P set a21=c.[21] from cts_21 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
 ----------------------------------------------No of newborn who received visit for pnc------------------------------22      
         
   ;WITH cts_22 as      
   (      
      select  P.PID,P.SID,      
    COUNT(1)AS '22' from t_child_flat AS t WITH (NOLOCK)      
    inner join  #tbl_HWC P  WITH (NOLOCK) on  P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where         
    (Month(t.PNC1_Date_Infant) = Month(@Dte) and Year(t.PNC1_Date_Infant) = Year(@Dte)) OR
	( Month(t.PNC2_Date_Infant) = Month(@Dte) and Year(t.PNC2_Date_Infant) = Year(@Dte)) or 
	( Month(t.PNC3_Date_Infant) = Month(@Dte) and Year(t.PNC3_Date_Infant) = Year(@Dte) )or      
     ( Month(t.PNC4_Date_Infant) = Month(@Dte) and Year(t.PNC4_Date_Infant) = Year(@Dte) )or 
	( Month(t.PNC5_Date_Infant) = Month(@Dte) and Year(t.PNC5_Date_Infant) = Year(@Dte)) or 
	(  Month(t.PNC6_Date_Infant) = Month(@Dte) and Year(t.PNC6_Date_Infant) = Year(@Dte)) or      
     ( Month(t.PNC7_Date_Infant) = Month(@Dte) and Year(t.PNC7_Date_Infant) = Year(@Dte))   
  --and month(t.Registration_Date)=month(@Dte)  and   year(t.Registration_Date)=year(@Dte)      
    group by P.PID,P.SID       
   )      
   update P set a22=c.[22] from cts_22 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID      
       
   -----------------------------------------Total no. of registered pregnant women whose ANC is due that month----------------------------------------------------------------------------23    
    
   ;WITH cts_23 as      
   (      
    select  P.PID,P.SID,      
    COUNT(1)AS '23' from t_mother_flat_Count  AS t WITH (NOLOCK)      
    inner join t_workplanANCDue as w  WITH (NOLOCK) on w.Registration_no=t.Registration_no and  t.Case_no=w.Case_no     
    inner join  #tbl_HWC P WITH (NOLOCK) on     
    P.PID= t.PHC_ID and P.SID= t.SubCentre_ID      
    where   w.Due_Month=month(@Dte)  and  w.Due_Yr=year(@Dte) and w.ANC_Type in (1,2,3,4)       
    group by P.PID,P.SID       
   )      
   update P set a23=c.[23] from cts_23 c inner join #tbl_HWC P  on P.PID=c.PID and p.SID=c.SID       
       
       
          
  truncate table HWC_WISE_DATA      
  INSERT INTO [HWC_WISE_DATA]      
           ([State_Code]      
           ,[PHC_ID]      
           ,[SubCentre_ID]      
           ,[NIN_Number]      
           ,[Estimated_mother]      
           ,[a11]      
           ,[a12]      
           ,[a13]      
           ,[a14]      
           ,[a15]      
           ,[a16]      
           ,[a17]      
           ,[a18]      
           ,[a19]      
           ,[a20A]      
           ,[a20B]      
           ,[a20C]      
           ,[a20D]      
           ,[a21]      
           ,[a22]     
           ,[a23]     
           ,[Month_id]      
           ,[Year_id]      
           )      
   SELECT  state_code,pid,sid,NINNUMBER,a10,[a11],[a12],[a13],[a14],[a15],[a16],[a17],[a18]      
           ,[a19],[a20A],[a20B]      
           ,[a20C]      
           ,[a20D]      
           ,[a21]      
           ,[a22],[a23],@Month,@year from #tbl_HWC      
             
--exec('select * from #tbl_HWC')       
      
END      