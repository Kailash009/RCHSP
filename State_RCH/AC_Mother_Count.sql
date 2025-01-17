USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[AC_Mother_Count]    Script Date: 09/26/2024 11:52:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
 /*            
[AC_Mother_Count] 19,0,0,0,0,0,2015,0,0,'','','State','1'            
[AC_Mother_Count] 21,1,0,0,0,0,2015,0,0,'','','District',1              
[AC_Mother_Count] 21,1,147,0,0,0,2015,0,0,'','','Block'  ,1            
[AC_Mother_Count] 21,1,147,228,0,0,2015,0,0,'','','PHC' ,1             
[AC_Mother_Count] 21,1,147,228,1668,0,2015,0,0,'','','SubCentre' ,1             
[AC_Mother_Count] 28,22,270,443,0,2015,0,0,'','','PHC'             
[AC_Mother_Count] 28,11,0,0,0,0,2015,0,0,'','','District'            
[AC_Mother_Count] 28,0,375,0,0,0,2016,0,0,'','','Block'           
[AC_Mother_Count] 28,0,0,2757,0,0,2016,0,0,'','','PHC',1            
[AC_Mother_Count] 28,0,0,375,2757,0,2016,0,0,'','','Subcentre',1          
*/            
            
ALTER procedure [dbo].[AC_Mother_Count]            
(            
@State_Code int=0,              
@District_Code int=0,              
@HealthBlock_Code int=0,              
@HealthFacility_Code int=0,              
@HealthSubFacility_Code int=0,            
@Village_Code int=0,            
@FinancialYr int,             
@Month_ID int=0 ,            
@Year_ID int=0 ,            
@FromDate date='',              
@ToDate date='' ,            
@Category varchar(20) ='District',            
@Type int =1            
)            
as            
begin            
            
declare @daysPast as int,@BeginDate as date,@Daysinyear int          
          
set @BeginDate = cast((cast(@FinancialYr as varchar(4))+'-04-01')as DATE)          
set @daysPast = (case when DATEDIFF(DAY,@BeginDate,GETDATE()-1)>366 then 365 else DATEDIFF(DAY,@BeginDate,GETDATE()-1) end)          
set @Daysinyear=(case when @FinancialYr%4=0 then 366 else 365 end)          
          
if(@Category='National')            
begin            
 exec RCH_Reports.dbo.AC_Mother_Count @State_Code,@District_Code,@HealthBlock_Code,@HealthFacility_Code,@HealthSubFacility_Code,@Village_Code,            
 @FinancialYr,@Month_ID,@Year_ID,@FromDate,@ToDate,@Category,@Type          
end          
             
if(@Category='State')              
begin              
select A.State_Code as ParentID,A.State_Name as ParentName,A.District_Code as ChildID,a.District_Name as ChildName            
            
,isnull(D.PW_Registered,0) as  PW_Registered            
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No            
,isnull(D.PW_With_Address,0) as PW_With_Address            
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details            
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo            
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo            
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester            
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk            
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic            
,isnull(A.Estimated_Mother,0) as Estimated_Mother            
,isnull(D.PW_Delivery_Due,0) as PW_Delivery_Due            
,isnull(D.PW_With_4_PNC,0) as PW_With_4_PNC            
,@daysPast as daysPast            
,@Daysinyear as DaysinYear          
,(isnull(D.PW_Registered,0)+isnull(D.PW_With_Aadhaar_No,0)+isnull(D.PW_With_Address,0)+isnull(D.PW_With_Bank_Details,0)+isnull(D.PW_With_PhoneNo,0)          
+isnull(D.PW_With_SelfPhoneNo,0)+ISNULL(D.PW_First_Trimester,0)+ISNULL(D.PW_High_Risk,0)+ISNULL(D.PW_Severe_Anaemic,0)+isnull(D.PW_Delivery_Due,0)          
+isnull(D.PW_With_4_PNC,0)) as Chk_clickable          
,isnull(D.MD_Total,0) as MD_Total        
,isnull(D.JSY_Total,0) as JSY_Total       
,isnull(D.Teen_Age_Count,0) as Teen_Age_Count   
,isnull(D.Mother_HealthIdNumber,0) as Mother_HealthIdNumber

,ISNULL(D.PW_Test_HBSAG,0) as PW_Test_HBSAG
,ISNULL(D.HBSAG_Positive,0) as HBSAG_Positive
,ISNULL(D.Total_PW_Tested_HBSAG_P,0) as Total_PW_Tested_HBSAG_P
,ISNULL(D.Pastillness_with_Test,0) as Pastillness_with_Test
,ISNULL(D.Pastillness_without_Test,0) as Pastillness_without_Test
,ISNULL(D.Del_Institutinal_HepB,0) as Del_Institutinal_HepB
,ISNULL(D.Infant_HBIG_Total,0) as Infant_HBIG_Total
                     
from            
(select b.StateID as State_Code,b.StateName as State_Name ,a.DIST_CD as District_Code,a.DIST_NAME_ENG as District_Name            
 ,c.Estimated_Mother as Estimated_Mother            
             
 from TBL_DISTRICT a            
 inner join TBL_STATE b on a.StateID=b.StateID            
 inner join Estimated_Data_District_Wise c on a.DIST_CD=c.District_Code            
 where c.Financial_Year=@FinancialYr             
 and b.StateID=@State_Code and (a.DIST_CD=@District_Code or @District_Code=0)            
)  A            
            
left outer join            
(            
 select  PW.State_Code,PW.District_Code            
,SUM(PW_Registered) as PW_Registered              
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo              
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo               
,SUM(PW_With_Address) as PW_With_Address            
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No            
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details             
,SUM(PW_First_Trimester) as PW_First_Trimester             
,SUM(PW_High_Risk) as PW_High_Risk               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic             
,SUM(PW_Delivery_Due) as PW_Delivery_Due             
,SUM(PW_With_4_PNC) as PW_With_4_PNC             
,SUM(PW_MD_Total) as MD_Total        
,SUM(PW_JSY_Total)as JSY_Total        
,SUM(Teen_Age_Count)as Teen_Age_Count   
,SUM(Mother_HealthIdNumber)as Mother_HealthIdNumber

,SUM(PW_Test_HBSAG)as PW_Test_HBSAG  
,SUM(HBSAG_Positive)as HBSAG_Positive  
,SUM(Total_PW_Tested_HBSAG_P)as Total_PW_Tested_HBSAG_P  
,SUM(Pastillness_with_Test)as Pastillness_with_Test  
,SUM(Pastillness_without_Test)as Pastillness_without_Test  
,SUM(Del_Institutinal_HepB)as Del_Institutinal_HepB  
,SUM(Infant_HBIG_Total)as Infant_HBIG_Total                          
   from Scheduled_AC_PW_State_District_Month as PW              
 where PW.State_Code =@State_Code            
 and (PW.District_Code=@District_Code or @District_Code=0)            
and (Month_ID=@Month_ID or @Month_ID=0)            
and (Year_ID=@Year_ID or @Year_ID=0)            
and (Filter_Type=@Type)            
and Fin_Yr=@FinancialYr             
 group by PW.State_Code,PW.District_Code             
 ) D on A.State_Code=D.State_Code and A.District_Code=D.District_Code  order by A.State_Name,a.District_Name          
end            
          
else if(@Category='District')              
begin              
select A.District_Code as ParentID,A.District_Name as ParentName,A.HealthBlock_Code as ChildID,a.HealthBlock_Name as ChildName            
,isnull(D.PW_Registered,0) as  PW_Registered            
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No            
,isnull(D.PW_With_Address,0) as PW_With_Address            
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details            
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo            
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo            
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester            
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk            
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic            
,isnull(A.Estimated_Mother,0) as Estimated_Mother            
,isnull(D.PW_Delivery_Due,0) as PW_Delivery_Due            
,isnull(D.PW_With_4_PNC,0) as PW_With_4_PNC            
,@daysPast as daysPast            
,@Daysinyear as DaysinYear          
,(isnull(D.PW_Registered,0)+isnull(D.PW_With_Aadhaar_No,0)+isnull(D.PW_With_Address,0)+isnull(D.PW_With_Bank_Details,0)+isnull(D.PW_With_PhoneNo,0)          
+isnull(D.PW_With_SelfPhoneNo,0)+ISNULL(D.PW_First_Trimester,0)+ISNULL(D.PW_High_Risk,0)+ISNULL(D.PW_Severe_Anaemic,0)+isnull(D.PW_Delivery_Due,0)          
+isnull(D.PW_With_4_PNC,0)) as Chk_clickable          
,isnull(D.MD_Total,0) as MD_Total         
,isnull(D.JSY_Total,0) as JSY_Total        
,isnull(D.Teen_Age_Count,0) as Teen_Age_Count    
,isnull(D.Mother_HealthIdNumber,0) as Mother_HealthIdNumber  
,ISNULL(D.PW_Test_HBSAG,0) as PW_Test_HBSAG
,ISNULL(D.HBSAG_Positive,0) as HBSAG_Positive
,ISNULL(D.Total_PW_Tested_HBSAG_P,0) as Total_PW_Tested_HBSAG_P
,ISNULL(D.Pastillness_with_Test,0) as Pastillness_with_Test
,ISNULL(D.Pastillness_without_Test,0) as Pastillness_without_Test
,ISNULL(D.Del_Institutinal_HepB,0) as Del_Institutinal_HepB
,ISNULL(D.Infant_HBIG_Total,0) as Infant_HBIG_Total        
from            
(select b.StateID as State_Code,a.DISTRICT_CD as District_Code,b.DIST_NAME_ENG as District_Name,a.BLOCK_CD as HealthBlock_Code,a.Block_Name_E as HealthBlock_Name             
,c.Estimated_Mother as Estimated_Mother            
             
 from TBL_HEALTH_BLOCK a            
 inner join TBL_DISTRICT b on a.DISTRICT_CD=b.DIST_CD            
 inner join Estimated_Data_Block_Wise c on a.BLOCK_CD=c.HealthBlock_Code            
 where c.Financial_Year=@FinancialYr             
 and a.DISTRICT_CD=@District_Code            
)  A            
            
left outer join            
(            
 select  PW.State_Code,PW.District_Code,PW.HealthBlock_Code             
,SUM(PW_Registered) as PW_Registered              
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo              
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo               
,SUM(PW_With_Address) as PW_With_Address            
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No            
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details             
,SUM(PW_First_Trimester) as PW_First_Trimester             
,SUM(PW_High_Risk) as PW_High_Risk               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic             
,SUM(PW_Delivery_Due) as PW_Delivery_Due             
,SUM(PW_With_4_PNC) as PW_With_4_PNC             
,SUM(PW_MD_Total) as MD_Total          
,SUM(PW_JSY_Total)as JSY_Total       
,SUM(Teen_Age_Count)as Teen_Age_Count   
,SUM(Mother_HealthIdNumber)as Mother_HealthIdNumber
,SUM(PW_Test_HBSAG)as PW_Test_HBSAG  
,SUM(HBSAG_Positive)as HBSAG_Positive  
,SUM(Total_PW_Tested_HBSAG_P)as Total_PW_Tested_HBSAG_P  
,SUM(Pastillness_with_Test)as Pastillness_with_Test  
,SUM(Pastillness_without_Test)as Pastillness_without_Test  
,SUM(Del_Institutinal_HepB)as Del_Institutinal_HepB  
,SUM(Infant_HBIG_Total)as Infant_HBIG_Total                    
   from Scheduled_AC_PW_District_Block_Month as PW              
 where PW.State_Code =@State_Code            
 and PW.District_Code=@District_Code            
 and (Month_ID=@Month_ID or @Month_ID=0)            
and (Year_ID=@Year_ID or @Year_ID=0)            
and (Filter_Type=@Type)            
and Fin_Yr=@FinancialYr             
 group by PW.State_Code,PW.District_Code,PW.HealthBlock_Code             
 ) D on A.District_Code=D.District_Code and A.HealthBlock_Code=D.HealthBlock_Code order by A.District_Name,a.HealthBlock_Name          
end           
           
else if(@Category='Block')              
begin              
select A.State_Code,A. HealthBlock_Code as ParentID,A.HealthBlock_Name as ParentName  ,A.HealthFacility_Code as ChildID,A.HealthFacility_Name as ChildName            
,isnull(D.PW_Registered,0) as  PW_Registered            
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No            
,isnull(D.PW_With_Address,0) as PW_With_Address            
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details            
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo            
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo            
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester            
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk            
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic            
,isnull(A.Estimated_Mother,0) as Estimated_Mother            
,isnull(D.PW_Delivery_Due,0) as PW_Delivery_Due            
,isnull(D.PW_With_4_PNC,0) as PW_With_4_PNC            
,@daysPast as daysPast            
,@Daysinyear as DaysinYear          
,(isnull(D.PW_Registered,0)+isnull(D.PW_With_Aadhaar_No,0)+isnull(D.PW_With_Address,0)+isnull(D.PW_With_Bank_Details,0)+isnull(D.PW_With_PhoneNo,0)          
+isnull(D.PW_With_SelfPhoneNo,0)+ISNULL(D.PW_First_Trimester,0)+ISNULL(D.PW_High_Risk,0)+ISNULL(D.PW_Severe_Anaemic,0)+isnull(D.PW_Delivery_Due,0)          
+isnull(D.PW_With_4_PNC,0)) as Chk_clickable           
,isnull(D.MD_Total,0) as MD_Total        
,isnull(D.JSY_Total,0) as JSY_Total       
,isnull(D.Teen_Age_Count,0) as Teen_Age_Count   
,isnull(D.Mother_HealthIdNumber,0) as Mother_HealthIdNumber 
,ISNULL(D.PW_Test_HBSAG,0) as PW_Test_HBSAG
,ISNULL(D.HBSAG_Positive,0) as HBSAG_Positive
,ISNULL(D.Total_PW_Tested_HBSAG_P,0) as Total_PW_Tested_HBSAG_P
,ISNULL(D.Pastillness_with_Test,0) as Pastillness_with_Test
,ISNULL(D.Pastillness_without_Test,0) as Pastillness_without_Test
,ISNULL(D.Del_Institutinal_HepB,0) as Del_Institutinal_HepB
,ISNULL(D.Infant_HBIG_Total,0) as Infant_HBIG_Total             
from              
(select c.State_Code,a.BID as HealthBlock_Code,b.Block_Name_E as HealthBlock_Name ,a.PHC_CD as HealthFacility_Code,a.PHC_NAME as HealthFacility_Name            
 ,c.Estimated_Mother as Estimated_Mother            
     from TBL_PHC  a            
     inner join TBL_HEALTH_BLOCK b on a.BID=b.BLOCK_CD            
     inner join Estimated_Data_PHC_Wise c on a.PHC_CD=c.HealthFacility_Code            
  where c.Financial_Year=@FinancialYr             
  and  (a.BID=@HealthBlock_Code or @HealthBlock_Code=0)            
)  A             
            
left outer join            
(            
 select State_Code,HealthBlock_Code,HealthFacility_Code               
,SUM(PW_Registered) as PW_Registered              
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo              
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo               
,SUM(PW_With_Address) as PW_With_Address            
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No            
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details            
,SUM(PW_First_Trimester) as PW_First_Trimester             
,SUM(PW_High_Risk) as PW_High_Risk               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic             
,SUM(PW_Delivery_Due) as PW_Delivery_Due             
,SUM(PW_With_4_PNC) as PW_With_4_PNC              
,SUM(PW_MD_Total) as MD_Total         
,SUM(PW_JSY_Total)as JSY_Total      
,SUM(Teen_Age_Count)as Teen_Age_Count   
,SUM(Mother_HealthIdNumber)as Mother_HealthIdNumber
,SUM(PW_Test_HBSAG)as PW_Test_HBSAG  
,SUM(HBSAG_Positive)as HBSAG_Positive  
,SUM(Total_PW_Tested_HBSAG_P)as Total_PW_Tested_HBSAG_P  
,SUM(Pastillness_with_Test)as Pastillness_with_Test  
,SUM(Pastillness_without_Test)as Pastillness_without_Test  
,SUM(Del_Institutinal_HepB)as Del_Institutinal_HepB  
,SUM(Infant_HBIG_Total)as Infant_HBIG_Total                             
   from Scheduled_AC_PW_Block_PHC_Month as PW              
 where State_Code =@State_Code            
 and HealthBlock_Code =@HealthBlock_Code               
 and (Month_ID=@Month_ID or @Month_ID=0)            
and (Year_ID=@Year_ID or @Year_ID=0)            
and (Filter_Type=@Type)            
and Fin_Yr=@FinancialYr             
 group by State_Code,HealthBlock_Code,HealthFacility_Code               
 ) D on A.HealthBlock_Code=D.HealthBlock_Code and A.HealthFacility_Code=D.HealthFacility_Code order by A.HealthBlock_Name,A.HealthFacility_Name          
end           
            
else if(@Category='PHC')            
begin              
select A.State_Code,A.HealthFacility_Code as  ParentID,A.HealthSubFacility_Code as ChildID,A.HealthFacility_Name as ParentName,A.HealthSubFacility_Name as ChildName            
,isnull(D.PW_Registered,0) as  PW_Registered            
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No            
,isnull(D.PW_With_Address,0) as PW_With_Address            
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details            
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo            
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo            
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester            
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk            
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic            
,isnull(A.Estimated_Mother,0) as Estimated_Mother            
,isnull(D.PW_Delivery_Due,0) as PW_Delivery_Due            
,isnull(D.PW_With_4_PNC,0) as PW_With_4_PNC          
,@daysPast as daysPast            
,@Daysinyear as DaysinYear          
,(isnull(D.PW_Registered,0)+isnull(D.PW_With_Aadhaar_No,0)+isnull(D.PW_With_Address,0)+isnull(D.PW_With_Bank_Details,0)+isnull(D.PW_With_PhoneNo,0)          
+isnull(D.PW_With_SelfPhoneNo,0)+ISNULL(D.PW_First_Trimester,0)+ISNULL(D.PW_High_Risk,0)+ISNULL(D.PW_Severe_Anaemic,0)+isnull(D.PW_Delivery_Due,0)          
+isnull(D.PW_With_4_PNC,0)) as Chk_clickable          
,isnull(D.MD_Total,0) as MD_Total        
,isnull(D.JSY_Total,0) as JSY_Total      
,isnull(D.Teen_Age_Count,0) as Teen_Age_Count    
,isnull(D.Mother_HealthIdNumber,0) as Mother_HealthIdNumber
,ISNULL(D.PW_Test_HBSAG,0) as PW_Test_HBSAG
,ISNULL(D.HBSAG_Positive,0) as HBSAG_Positive
,ISNULL(D.Total_PW_Tested_HBSAG_P,0) as Total_PW_Tested_HBSAG_P
,ISNULL(D.Pastillness_with_Test,0) as Pastillness_with_Test
,ISNULL(D.Pastillness_without_Test,0) as Pastillness_without_Test
,ISNULL(D.Del_Institutinal_HepB,0) as Del_Institutinal_HepB
,ISNULL(D.Infant_HBIG_Total,0) as Infant_HBIG_Total             
  from             
(          
 select a.State_Code,b.PHC_CD as HealthFacility_Code,b.PHC_NAME as HealthFacility_Name ,isnull(c.SUBPHC_CD,0) as HealthSubFacility_Code,isnull(c.SUBPHC_NAME_E,'Direct Entry') as HealthSubFacility_Name,isnull([Total_Village],0) as [Total_Village],isnull([Total_Profile_Entered],1)as [Total_Profile_Entered]          
 ,a.Estimated_EC as Estimated_EC          
 ,a.Estimated_Mother as Estimated_Mother          
 ,a.Estimated_Infant as Estimated_Infant          
 from Estimated_Data_SubCenter_Wise a          
 inner join TBL_PHC b on a.HealthFacility_Code=b.PHC_CD          
 left outer join TBL_SUBPHC c on a.HealthSubFacility_Code=c.SUBPHC_CD           
 where a.Financial_Year=@FinancialYr           
 and ( a.HealthFacility_Code= @HealthFacility_Code or @HealthFacility_Code=0)          
     )  A             
               
left outer join            
(            
 select State_Code,HealthFacility_Code,HealthSubFacility_Code            
,SUM(PW_Registered) as PW_Registered              
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo              
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo               
,SUM(PW_With_Address) as PW_With_Address            
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No            
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details             
,SUM(PW_First_Trimester) as PW_First_Trimester             
,SUM(PW_High_Risk) as PW_High_Risk               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic               
,SUM(PW_Delivery_Due) as PW_Delivery_Due             
,SUM(PW_With_4_PNC) as PW_With_4_PNC            
,SUM(PW_MD_Total) as MD_Total         
,SUM(PW_JSY_Total)as JSY_Total        
,SUM(Teen_Age_Count)as Teen_Age_Count   
,SUM(Mother_HealthIdNumber)as Mother_HealthIdNumber
,SUM(PW_Test_HBSAG)as PW_Test_HBSAG  
,SUM(HBSAG_Positive)as HBSAG_Positive  
,SUM(Total_PW_Tested_HBSAG_P)as Total_PW_Tested_HBSAG_P  
,SUM(Pastillness_with_Test)as Pastillness_with_Test  
,SUM(Pastillness_without_Test)as Pastillness_without_Test  
,SUM(Del_Institutinal_HepB)as Del_Institutinal_HepB  
,SUM(Infant_HBIG_Total)as Infant_HBIG_Total                            
   from Scheduled_AC_PW_PHC_SubCenter_Month as PW              
 where State_Code =@State_Code            
 and HealthFacility_Code =@HealthFacility_Code               
 and (Month_ID=@Month_ID or @Month_ID=0)            
and (Year_ID=@Year_ID or @Year_ID=0)            
and (Filter_Type=@Type)            
and Fin_Yr=@FinancialYr             
 group by State_Code,HealthFacility_Code,HealthSubFacility_Code            
 ) D on A.HealthFacility_Code=D.HealthFacility_Code and A.HealthSubFacility_Code=D.HealthSubFacility_Code order by A.HealthFacility_Name,A.HealthSubFacility_Name          
end             
           
else if(@Category='SubCentre')              
begin              
select A.State_Code,A.HealthSubFacility_Code as  ParentID,A.Village_Code as ChildID,A.HealthSubFacility_Name as ParentName,A.Village_Name as ChildName            
,isnull(D.PW_Registered,0) as  PW_Registered            
,isnull(D.PW_With_Aadhaar_No,0) as  PW_With_Aadhaar_No            
,isnull(D.PW_With_Address,0) as PW_With_Address            
,isnull(D.PW_With_Bank_Details,0) as PW_With_Bank_Details            
,isnull(D.PW_With_PhoneNo,0) as PW_With_PhoneNo            
,isnull(D.PW_With_SelfPhoneNo,0) as PW_With_SelfPhoneNo            
,ISNULL(D.PW_First_Trimester,0) as PW_First_Trimester            
,ISNULL(D.PW_High_Risk,0) as PW_High_Risk            
,ISNULL(D.PW_Severe_Anaemic,0) as PW_Severe_Anaemic            
,isnull(A.Estimated_Mother,0) as Estimated_Mother            
,isnull(D.PW_Delivery_Due,0) as PW_Delivery_Due            
,isnull(D.PW_With_4_PNC,0) as PW_With_4_PNC            
,@daysPast as daysPast            
,@Daysinyear as DaysinYear           
,(isnull(D.PW_Registered,0)+isnull(D.PW_With_Aadhaar_No,0)+isnull(D.PW_With_Address,0)+isnull(D.PW_With_Bank_Details,0)+isnull(D.PW_With_PhoneNo,0)          
+isnull(D.PW_With_SelfPhoneNo,0)+ISNULL(D.PW_First_Trimester,0)+ISNULL(D.PW_High_Risk,0)+ISNULL(D.PW_Severe_Anaemic,0)+isnull(D.PW_Delivery_Due,0)          
+isnull(D.PW_With_4_PNC,0)) as Chk_clickable          
  ,isnull(D.MD_Total,0) as MD_Total         
  ,isnull(D.JSY_Total,0) as JSY_Total       
  ,isnull(D.Teen_Age_Count,0) as Teen_Age_Count   
  ,isnull(D.Mother_HealthIdNumber,0) as Mother_HealthIdNumber 
  ,ISNULL(D.PW_Test_HBSAG,0) as PW_Test_HBSAG
,ISNULL(D.HBSAG_Positive,0) as HBSAG_Positive
,ISNULL(D.Total_PW_Tested_HBSAG_P,0) as Total_PW_Tested_HBSAG_P
,ISNULL(D.Pastillness_with_Test,0) as Pastillness_with_Test
,ISNULL(D.Pastillness_without_Test,0) as Pastillness_without_Test
,ISNULL(D.Del_Institutinal_HepB,0) as Del_Institutinal_HepB
,ISNULL(D.Infant_HBIG_Total,0) as Infant_HBIG_Total            
  from             
(          
 select c.State_Code,  c.HealthSubFacility_Code as HealthSubFacility_Code,isnull(c.Village_Code,0) as Village_Code          
 ,sp.SUBPHC_NAME_E as  HealthSubFacility_Name,isnull(vn.VILLAGE_NAME,'Direct Entry') as Village_Name          
 ,c.Estimated_EC as Estimated_EC          
 ,c.Estimated_Mother as Estimated_Mother          
 ,c.Estimated_Infant as Estimated_Infant          
 from Estimated_Data_Village_Wise  c          
 left outer join TBL_VILLAGE vn on vn.VILLAGE_CD=c.Village_Code and vn.SUBPHC_CD=c.HealthSubFacility_Code          
 left outer join TBL_SUBPHC sp on sp.SUBPHC_CD=c.HealthSubFacility_Code          
 left outer join Health_SC_Village v on v.VCode=c.Village_code and v.SID=c.HealthSubFacility_Code           
 where (sp.SUBPHC_CD=@HealthSubFacility_Code or @HealthSubFacility_Code=0)          
 and (vn.VILLAGE_CD=@Village_Code or @Village_Code=0) and c.Financial_Year=@FinancialYr          
                  
 )  A             
                
left outer join            
(            
 select State_Code,HealthSubFacility_Code,Village_Code            
,SUM(PW_Registered) as PW_Registered              
,SUM(PW_With_PhoneNo) AS PW_With_PhoneNo              
,SUM(PW_With_SelfPhoneNo) as PW_With_SelfPhoneNo               
,SUM(PW_With_Address) as PW_With_Address            
,SUM(PW_With_Aadhaar_No) as PW_With_Aadhaar_No            
,SUM(PW_With_Bank_Details) as PW_With_Bank_Details            
,SUM(PW_First_Trimester) as PW_First_Trimester             
,SUM(PW_High_Risk) as PW_High_Risk               
,SUM(PW_Severe_Anaemic) as PW_Severe_Anaemic             
,SUM(PW_Delivery_Due) as PW_Delivery_Due             
,SUM(PW_With_4_PNC) as PW_With_4_PNC              
,SUM(PW_MD_Total) as MD_Total         
,SUM(PW_JSY_Total)as JSY_Total       
,SUM(Teen_Age_Count)as Teen_Age_Count   
,SUM(Mother_HealthIdNumber)as Mother_HealthIdNumber  

,SUM(PW_Test_HBSAG)as PW_Test_HBSAG  
,SUM(HBSAG_Positive)as HBSAG_Positive  
,SUM(Total_PW_Tested_HBSAG_P)as Total_PW_Tested_HBSAG_P  
,SUM(Pastillness_with_Test)as Pastillness_with_Test  
,SUM(Pastillness_without_Test)as Pastillness_without_Test  
,SUM(Del_Institutinal_HepB)as Del_Institutinal_HepB  
,SUM(Infant_HBIG_Total)as Infant_HBIG_Total  
                          
   from Scheduled_AC_PW_PHC_SubCenter_Village_Month as PW              
 where State_Code =@State_Code            
 and HealthFacility_Code =@HealthFacility_Code             
 and HealthSubFacility_Code =@HealthSubFacility_Code                  
 and (Month_ID=@Month_ID or @Month_ID=0)            
and (Year_ID=@Year_ID or @Year_ID=0)            
and (Filter_Type=@Type)            
and Fin_Yr=@FinancialYr             
 group by State_Code,HealthSubFacility_Code,Village_Code            
 ) D on  A.HealthSubFacility_Code=D.HealthSubFacility_Code and A.Village_Code=D.Village_Code order by A.HealthSubFacility_Name,A.Village_Name          
end              
            
end       
     