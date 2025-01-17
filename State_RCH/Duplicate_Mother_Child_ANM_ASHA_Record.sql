USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Duplicate_Mother_Child_ANM_ASHA_Record]    Script Date: 09/26/2024 15:26:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  [Duplicate_Mother_Child_ANM_ASHA_Record] 'Record Details',30,2,8,23,193,0,196,0,'Mother'     
--  [Duplicate_Mother_Child_ANM_ASHA_Record] 'Record Details',30,2,8,23,193,0,196,0,'Child'        
 -- [Duplicate_Mother_Child_ANM_ASHA_Record] 'Deleted Record',35,2,6,25,0,0,11,0,'Mother'                        
                  
ALTER procedure [dbo].[Duplicate_Mother_Child_ANM_ASHA_Record]                                                   
(                                             
@Type as varchar(20)='',                                             
@State_Code int=0,                                                    
@District_Code int=0 ,                             
@HealthBlock_Code int=0,                             
@HealthFacility_Code int=0  ,                          
@HealthSubFacility_Code int=0 ,                          
@Village_Code int=0  ,                          
@duprank int =0 ,                          
@Finyear int =0 ,                          
@Category as varchar(20)='Mother'                                                
)                                                    
as                                                     
begin                           
if(@Type='Duplicate Record')                          
begin                          
if(@Category='Mother')                          
begin                        
select isnull(SUBPHC_NAME_E,'NA') as SUBPHC_NAME_E,isnull(VILLAGE_NAME,'NA') as VILLAGE_NAME,Name_PW, Convert(varchar,Birth_Date,103) as Birth_Date,Name_H,'' as Address,Mobile_No,dup_rank_withoutAddr as dup_rank,Dup_count                           
from                          
(                          
select HealthSubFacility_Code,Village_Code,Name_PW, Birth_Date,Name_H,Mobile_No,dup_rank_withoutAddr,COUNT(dup_rank_withoutAddr) Dup_count  from t_mother_registration (nolock) where dup_case_withoutAddr=1     
and not(isnull(Delete_Mother,0)=1 and isnull(Dup_Mother_Delete,0)=0)                   
and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code and  HealthFacility_Code=@HealthFacility_Code                           
and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and (Financial_Year=@Finyear or @Finyear=0 )         
                         
 group by HealthSubFacility_Code,Village_Code,Name_PW,Birth_Date,Name_H,Mobile_No,dup_rank_withoutAddr                  
 having COUNT(dup_rank_withoutAddr)>=2                          
  --having SUM(Delete_Mother)=0                          
  ) a                          
left join TBL_VILLAGE (nolock)c on a.Village_Code=c.VILLAGE_CD  and  a.HealthSubFacility_Code=c.SUBPHC_CD                        
left join tbl_subphc  (nolock)b on a.HealthSubFacility_Code=b.SUBPHC_CD 
                       
order by dup_rank_withoutAddr                          
end                         
if(@Category='Child')                          
begin                   
select isnull(SUBPHC_NAME_E,'NA') as SUBPHC_NAME_E,isnull(VILLAGE_NAME,'NA') as VILLAGE_NAME,Name_Child,Name_Mother,case when A.Gender='M' then 'Male' else 'Female' end as Gender,Convert(varchar,Birth_Date,103) as Birth_Date,'' as Address,Mobile_No,dup_rank_withoutAddr as dup_rank,Dup_count                          
from                          
(                          
select HealthSubFacility_Code,Village_Code,Name_Child,Name_Mother,Gender,Birth_Date,Mobile_No,dup_rank_withoutAddr,COUNT(dup_rank_withoutAddr) Dup_count  from t_children_registration (nolock)                   
where dup_case_withoutAddr=1 and not(isnull(Delete_Mother,0)=1 and isnull(Dup_Child_Delete,0)=0)                   
 and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code and                      
HealthFacility_Code=@HealthFacility_Code                           
and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and (Financial_Year=@Finyear or @Finyear=0 )         
and isnull(Delete_Mother,0)=0 and (permanent_delete <>1 OR permanent_delete is null)                          
 group by HealthSubFacility_Code,Village_Code,Name_Child,Name_Mother,Gender,Birth_Date,Mobile_No,dup_rank_withoutAddr                          
 having COUNT(dup_rank_withoutAddr)>=2                         
  ) a                          
left join TBL_VILLAGE (nolock)c on a.Village_Code=c.VILLAGE_CD  and  a.HealthSubFacility_Code=c.SUBPHC_CD                        
left join tbl_subphc  (nolock)b on a.HealthSubFacility_Code=b.SUBPHC_CD                         
order by dup_rank_withoutAddr                   
end                          
if(@Category='Health Provider')                          
begin                          
select * from t_Ground_Staff                 
end                          
end                          
if(@Type='Record Details')                          
begin                          
if(@Category='Mother')                          
begin                         
                          
select DIST_NAME_ENG as Distirct,                           
 Block_Name_E as Block,                  
 PHC_NAME as PHC,                          
 isnull(SUBPHC_NAME_E,'NA') as SubCenter,                          
 isnull(VILLAGE_NAME,'NA') as Village,A.Registration_no,a.Case_no , 
  --------------------------------------
  (SELECT Child_Name from(
SELECT DISTINCT m.Registration_no, 
    SUBSTRING(
        (
            SELECT ','+(ch.Name_Child +' ( '+ CONVERT(varchar(20),ch.Registration_no) +  ' ) ')   AS [text()],ch.Mother_Reg_no
            FROM dbo.t_children_registration ch
            WHERE ch.Registration_no = m.Registration_no
            ORDER BY ch.Registration_no
            FOR XML PATH (''), TYPE
        ).value('text()[1]','nvarchar(300)'),2, 1000) [Child_Name] FROM dbo.t_children_registration m
WHERE m.Mother_Reg_no=a.Registration_no)k)Child_Name
 --------------------------------------
 ,Name_PW,Name_H,Convert(varchar, A.Birth_Date,103) as Birth_Date,a.Mobile_No,                  
 a.Address,case when a.ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),a.ANM_ID)+')' end as ANM,                  
 case when A.ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),A.ASHA_ID)+')' end as ASHA,                          
Convert(varchar,EC_Regisration_Date,103) as EC_Regisration_Date,                          
Convert(varchar, Medical_EDD_Date,103) as Medical_EDD_Date,                          
Convert(varchar,Delivery_date,103) as Delivery_date, Delivery_Outcomes,                          
Convert(varchar,ANC1,103) as ANC1 ,                          
Convert(varchar,ANC2,103) as ANC2,                          
Convert(varchar,ANC3,103) as ANC3                          
,Convert(varchar,ANC4,103) as ANC4                          
,Convert(varchar,PNC1_Date,103) as PNC1_Date                          
,Convert(varchar,PNC2_Date,103) as PNC2_Date                          
,Convert(varchar,PNC3_Date,103) as PNC3_Date                          
,Convert(varchar,PNC4_Date,103) as PNC4_Date                          
,Convert(varchar,PNC5_Date,103) as PNC5_Date                          
,Convert(varchar,PNC6_Date,103) as PNC6_Date                          
,Convert(varchar,PNC7_Date,103) as PNC7_Date                          
,a.dup_rank_withoutAddr as dup_rank                  
,Convert(varchar,Medical_LMP_Date,103) as LMP_Date     -- changes done here                  
,isnull(ch.Registration_no,0) as Child_Reg_No                   
--,(ect.VisitDate) as EC_Visit_Date                  
,ECT_With_Method_Name                  
,Convert (varchar,Mother_Registration_Date,103) as PW_Registration_Date                  
,(select MAX (Convert(varchar, VisitDate,103)) as EC_Visit_Date from t_eligible_couple_tracking (nolock) e where a.Registration_no=e.Registration_no and a.Case_no=e.Case_no) EC_Visit_Date                       
,a.Delete_mother 
,(select COUNT(Case_no) as TotalCases from t_mother_registration (nolock) mr where mr.Registration_no=a.Registration_no) TotalCases            
from t_mother_registration (nolock)A                          
inner join  t_mother_flat (nolock)B on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no                  
--inner join  t_eligible_couple_tracking (nolock)ect on a.Registration_no = ect.Registration_no and a.Case_no = ect.Case_no  
left join (select  max(Registration_no) as Registration_no,Mother_Reg_no from t_children_registration (nolock) where Delete_Mother=0 group by Mother_Reg_no)ch on a.Registration_no=ch.Mother_Reg_no                  
--left join t_children_registration (nolock)ch on a.Registration_no=ch.Mother_Reg_no and ch.Delete_Mother=0                    
inner join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=A.District_Code                          
inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=A.HealthBlock_Code                          
inner join  TBL_PHC(nolock)PHC on PHC.PHC_CD=A.HealthFacility_Code                           
left outer join tbl_subphc  (nolock)d on d.SUBPHC_CD=A.HealthSubFacility_Code                           
left outer join TBL_VILLAGE (nolock)c on c.VILLAGE_CD=A.Village_Code and  a.HealthSubFacility_Code=c.SUBPHC_CD                  
left outer join t_Ground_Staff (nolock)an on a.ANM_ID=an.ID                  
left outer join t_Ground_Staff (nolock)ash on a.ASHA_ID=ash.ID 
                       
 where a.dup_rank_withoutAddr=@duprank and a.Case_no=1 and  isnull(a.Delete_mother,0)=0             
--Select Distirct,Block,PHC,SubCenter,Village,a.Registration_no,a.Case_no,Name_PW,Name_H,Birth_Date,Mobile_No,                  
--a.Address, ANM,ASHA,EC_Regisration_Date,Medical_EDD_Date,Delivery_date, Delivery_Outcomes,                          
--ANC1,ANC2,ANC3,ANC4,PNC1_Date,PNC2_Date,PNC3_Date,PNC4_Date, PNC5_Date,PNC6_Date ,PNC7_Date ,dup_rank                  
--,LMP_Date,Child_Reg_No,ECT_With_Method_Name,PW_Registration_Date,EC_Visit_Date                  
--  from                   
-- (                  
-- select DIST_NAME_ENG as Distirct,                           
-- Block_Name_E as Block,                          
-- PHC_NAME as PHC,                          
-- isnull(SUBPHC_NAME_E,'NA') as SubCenter,                          
-- isnull(VILLAGE_NAME,'NA') as Village,A.Registration_no,a.Case_no,Name_PW,Name_H,Convert(varchar, A.Birth_Date,103) as Birth_Date,a.Mobile_No,                  
-- a.Address,case when a.ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),a.ANM_ID)+')' end as ANM,                  
-- case when A.ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),A.ASHA_ID)+')' end as ASHA,                       
--Convert(varchar,EC_Regisration_Date,103) as EC_Regisration_Date,                          
--Convert(varchar, Medical_EDD_Date,103) as Medical_EDD_Date,                          
--Convert(varchar,Delivery_date,103) as Delivery_date, Delivery_Outcomes,                          
--Convert(varchar,ANC1,103) as ANC1 ,                          
--Convert(varchar,ANC2,103) as ANC2,                          
--Convert(varchar,ANC3,103) as ANC3                          
--,Convert(varchar,ANC4,103) as ANC4                          
--,Convert(varchar,PNC1_Date,103) as PNC1_Date                          
--,Convert(varchar,PNC2_Date,103) as PNC2_Date                          
--,Convert(varchar,PNC3_Date,103) as PNC3_Date                          
--,Convert(varchar,PNC4_Date,103) as PNC4_Date                          
--,Convert(varchar,PNC5_Date,103) as PNC5_Date                          
--,Convert(varchar,PNC6_Date,103) as PNC6_Date                          
--,Convert(varchar,PNC7_Date,103) as PNC7_Date                          
--,a.dup_rank_withoutAddr as dup_rank                  
--,Convert(varchar,Medical_LMP_Date,103) as LMP_Date     -- changes done here                  
--,isnull(ch.Registration_no,0) as Child_Reg_No                  
--,ECT_With_Method_Name                  
--,Convert(varchar, Mother_Registration_Date,103) as PW_Registration_Date  from t_mother_registration (nolock)A                          
--inner join  t_mother_flat (nolock)B on a.Registration_no=b.Registration_no and a.Case_no=b.Case_no                  
--left join t_children_registration (nolock)ch on a.Registration_no=ch.Mother_Reg_no and ch.Delete_Mother=0                    
--inner join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=A.District_Code                          
--inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=A.HealthBlock_Code                          
--inner join  TBL_PHC(nolock)PHC on PHC.PHC_CD=A.HealthFacility_Code                           
--left outer join tbl_subphc  (nolock)d on d.SUBPHC_CD=A.HealthSubFacility_Code                           
--left outer join TBL_VILLAGE (nolock)c on c.VILLAGE_CD=A.Village_Code and  a.HealthSubFacility_Code=c.SUBPHC_CD                  
--left outer join t_Ground_Staff (nolock)an on a.ANM_ID=an.ID                  
--left outer join t_Ground_Staff (nolock)ash on a.ASHA_ID=ash.ID                         
-- where a.dup_rank_withoutAddr=110 and a.Case_no=1)A                  
--left outer join                  
--(                  
--select MAX (Convert(varchar, VisitDate,103)) as EC_Visit_Date, Registration_no,Case_no from t_eligible_couple_tracking (nolock) where Case_no=1 group by Registration_no,Case_no                   
--)B on B.Registration_no=a.Registration_no and b.Case_no=a.Case_no                        
End                    
if(@Category='Child')                          
begin                          
                          
select DIST_NAME_ENG as Distirct,                           
 Block_Name_E as Block,                          
 PHC_NAME as PHC,             
 isnull(SUBPHC_NAME_E,'NA') as SubCenter,                          
 isnull(VILLAGE_NAME,'NA') as Village,A.Registration_no,a.Case_no , A.Name_Child,case when A.Gender='M' then 'Male' else 'Female' end as Gender,                  
 A.Mother_Reg_no,A.Name_Mother,A.Name_Father,Convert(varchar, A.Birth_Date,103) as Birth_Date,a.Mobile_No,a.Address,                  
 case when a.ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),a.ANM_ID)+')' end as ANM,                  
 case when A.ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),A.ASHA_ID)+')' end as ASHA,A.Mother_Reg_no                        
,Convert(varchar,B.PNC1_Date_Infant,103) as PNC1_Date                          
,Convert(varchar,B.PNC2_Date_Infant,103) as PNC2_Date                          
,Convert(varchar,B.PNC3_Date_Infant,103) as PNC3_Date                          
,Convert(varchar,B.PNC4_Date_Infant,103) as PNC4_Date                          
,Convert(varchar,B.PNC5_Date_Infant,103) as PNC5_Date                          
,Convert(varchar,B.PNC6_Date_Infant,103) as PNC6_Date                          
,Convert(varchar,B.PNC7_Date_Infant,103) as PNC7_Date,                  
Convert(varchar,[BCG_Dt],103) as BCG,                 Convert(varchar,[OPV0_Dt],103) as OPV0,                          
Convert(varchar,[DPT1_Dt],103) as DPT1,                          
Convert(varchar,[DPTBooster1_Dt],103) as DPTBooster1,                           
Convert(varchar,[HepatitisB0_Dt],103) as HepB1 ,                            
Convert(varchar,[Penta1_Dt],103) as Penta1,                          
Convert(varchar,[OPV1_Dt],103) as OPV1,                          
Convert(varchar,[DPT2_Dt],103) as DPT2,                          
Convert(varchar,[DPTBooster2_Dt],103) as DPTBooster2,                           
Convert(varchar,[HepatitisB1_Dt],103) as HepB2 ,                            
Convert(varchar,[Penta2_Dt],103) as Penta2,                          
Convert(varchar,[Measles1_Dt],103) as Measles1,                          
Convert(varchar,[VitA_Dose1_Dt],103) as VitaminA_Dose1,            Convert(varchar,[MR1_Dt],103) as MR1,                           
a.dup_rank_withoutAddr as dup_rank,                
a.Delete_mother,
isnull((select distinct dup_rank_withoutAddr from t_mother_registration (nolock) s where dup_rank_withoutAddr is not null and s.Registration_no=a.Mother_Reg_no),0) mother_dup_rank_withoutAddr
from t_children_registration (nolock)A                          
inner join  t_child_flat (nolock)B on a.Registration_no=b.Registration_no                  
inner join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=A.District_Code                          
inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=A.HealthBlock_Code                          
inner join  TBL_PHC(nolock)PHC on PHC.PHC_CD=A.HealthFacility_Code                           
left outer join tbl_subphc  (nolock)d on d.SUBPHC_CD=A.HealthSubFacility_Code                           
left outer join TBL_VILLAGE (nolock)c on c.VILLAGE_CD=A.Village_Code  and  a.HealthSubFacility_Code=c.SUBPHC_CD                  
left outer join t_Ground_Staff (nolock)an on a.ANM_ID=an.ID                  
left outer join t_Ground_Staff (nolock)ash on a.ASHA_ID=ash.ID                   
 where a.dup_rank_withoutAddr=@duprank and  isnull(a.Delete_mother,0)=0 
 and (a.permanent_delete <>1 OR a.permanent_delete is null)         
 --and  a.Delete_mother<>1                                                    
End                         
end                          
if(@Type='Deleted Record')                          
begin                          
if(@Category='Mother')                          
begin                          
select a.Registration_no,SUBPHC_NAME_E,VILLAGE_NAME,Name_PW, Convert(varchar,a.Birth_Date,103) as Birth_Date,Name_H,a.Address,a.Mobile_No,a.dup_rank_withoutAddr as dup_rank,a.Case_no,ch.Registration_no as Child_Reg_No,
   case Convert(varchar,a.Registration_Date,103) when '01/01/1990' then ec.Financial_Yr else a.Financial_Yr end as Financial_Yr,u.User_Name  -- chenges done here          
         
from                          
(                          
select Registration_no, HealthSubFacility_Code,Village_Code,Name_PW, Birth_Date,Name_H,Address,Mobile_No,dup_rank_withoutAddr,Case_no,Registration_Date,Financial_Yr,Deleted_By  from t_mother_registration (nolock)                         
where dup_case_withoutAddr=-1 and Delete_Mother=1  and State_Code=@State_Code and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code and                         
HealthFacility_Code=@HealthFacility_Code and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0) and  isnull(permanent_delete,0)=0                           
) a                   
 left join t_children_registration(nolock) ch on a.Registration_no=ch.Mother_Reg_no and ch.Delete_Mother=1 and a.Case_no=ch.Case_no
 left join t_eligibleCouples ec on a.Registration_no=ec.Registration_no and a.Case_no=ec.Case_no                       
 left join TBL_VILLAGE (nolock) c on a.Village_Code=c.VILLAGE_CD  and  a.HealthSubFacility_Code=c.SUBPHC_CD           
 left join tbl_subphc  (nolock) b on a.HealthSubFacility_Code=b.SUBPHC_CD   
 left join User_Master  (nolock)u on a.Deleted_By=u.UserID                        
order by a.dup_rank_withoutAddr                          
end                     
                  
if(@Category='Child')                          
begin                          
select a.Registration_no,SUBPHC_NAME_E,VILLAGE_NAME,a.Name_Child,a.Name_Mother, case when A.Gender='M' then 'Male' else 'Female' end as Gender,
Convert(varchar,a.Birth_Date,103) as Birth_Date,a.Address,a.Mobile_No,a.dup_rank_withoutAddr as dup_rank,a.Case_no,a.Dup_Child_Delete,a.Financial_Yr,u.User_Name
from                          
(                          
select Registration_no, HealthSubFacility_Code,Village_Code,Name_Child,Name_Mother,Gender, Birth_Date,Address,Mobile_No,dup_rank_withoutAddr,Case_no,isnull(Dup_Child_Delete,0) as Dup_Child_Delete,Financial_Yr,Deleted_By from t_children_registration (nolock)  
where dup_case_withoutAddr=-1 and Delete_Mother=1  and State_Code=@State_Code and District_Code=@District_Code and HealthBlock_Code=@HealthBlock_Code and                         
HealthFacility_Code=@HealthFacility_Code and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and isnull(permanent_delete,0)=0                           
) a                       
 left join TBL_VILLAGE (nolock) c on a.Village_Code=c.VILLAGE_CD  and  a.HealthSubFacility_Code=c.SUBPHC_CD                        
 left join tbl_subphc  (nolock) b on a.HealthSubFacility_Code=b.SUBPHC_CD 
 left join User_Master  (nolock)u on a.Deleted_By=u.UserID                          
order by a.dup_rank_withoutAddr                          
end                        
end                          
if(@Type='Record Export')                          
begin                          
if(@Category='Mother')           
begin                          
                          
select DIST_NAME_ENG as Distirct,                           
 Block_Name_E as Block,                          
 PHC_NAME as PHC,                          
 SUBPHC_NAME_E as SubCenter,                          
VILLAGE_NAME as Village,                          
 a.Address,                          
convert(varchar,A.Registration_no) as RCH_ID,                          
a.Case_no as CaseNumber ,Name_wife as NameOfPW, Name_husband as NameOfHusband,                          
Convert(varchar, Birth_Date,103) as Birth_Date,a.Mobile_No as MobileNumber,                          
case when ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),ANM_ID)+')' end as ANM,                  
case when ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),ASHA_ID)+')' end as ASHA,                          
Convert(varchar,EC_Regisration_Date,103) as EC_Registration_Date,                          
CONVERT(varchar ,Mother_Registration_Date,103) as Mother_Registration_Date,                          
CONVERT(varchar,medical_LMP_Date,103) as Medical_LMP_Date,                          
Convert(varchar, Medical_EDD_Date,103) as Medical_EDD_Date,                          
 Convert(varchar,Delivery_date,103) as Delivery_date, Delivery_Outcomes,                          
Convert(varchar,ANC1,103) as ANC1 ,                          
Convert(varchar,ANC2,103) as ANC2,                    
Convert(varchar,ANC3,103) as ANC3                          
,Convert(varchar,ANC4,103) as ANC4                          
,Convert(varchar,PNC1_Date,103) as PNC1_Date                          
,Convert(varchar,PNC2_Date,103) as PNC2_Date                          
,Convert(varchar,PNC3_Date,103) as PNC3_Date                          
,Convert(varchar,PNC4_Date,103) as PNC4_Date                          
,Convert(varchar,PNC5_Date,103) as PNC5_Date                          
,Convert(varchar,PNC6_Date,103) as PNC6_Date                      
,Convert(varchar,PNC7_Date,103) as PNC7_Date                          
,ISNULL(dup_rank_withoutAddr,0) as dup_rank                          
from t_mother_flat(nolock)   A                          
inner join  (select Registration_no,dup_rank_withoutAddr, Birth_Date,ANM_ID,ASHA_ID from t_mother_registration(nolock) where Delete_Mother=0 
and (District_Code=@District_Code or  @District_Code=0) and (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) and 
(HealthFacility_Code=@HealthFacility_Code  or @HealthFacility_Code=0) and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and (Financial_Year=@Finyear or @Finyear=0) 
and dup_rank_withoutAddr in(select dup_rank_withoutAddr from t_mother_registration where Delete_Mother=0 and dup_case_withoutAddr=1 
group by dup_rank_withoutAddr,Delete_Mother having COUNT(1)>1))  B on a.Registration_no=b.Registration_no                           
inner join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=A.District_ID                          
inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=A.HealthBlock_ID                          
inner join  TBL_PHC(nolock)PHC on PHC.PHC_CD=A.PHC_ID                           
left outer join tbl_subphc  (nolock)d on A.SubCentre_ID=d.SUBPHC_CD                           
left outer join TBL_VILLAGE (nolock)c on A.Village_ID=c.VILLAGE_CD and  a.SubCentre_ID=c.SUBPHC_CD                  
left outer join t_Ground_Staff (nolock)an on ANM_ID=an.ID                  
left outer join t_Ground_Staff (nolock)ash on ASHA_ID=ash.ID                          
 order by dup_rank_withoutAddr                           
End                   
                  
if(@Category='Child')            -- Export Child                  
begin                          
                          
select DIST_NAME_ENG as Distirct,                           
 Block_Name_E as Block,                          
 PHC_NAME as PHC,                          
 SUBPHC_NAME_E as SubCenter,                          
VILLAGE_NAME as Village,                      
 a.Address,                          
convert(varchar,A.Registration_no) as RCH_ID,a.Mother_Reg_no as Mother_RCH_ID,a.Name_Child as Name_Of_Child,                          
Name_Mother , Name_Father,                          
Convert(varchar, a.Birth_Date,103) as DOB,a.Mobile_No as Mobile,a.Registration_Date,                          
case when a.ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),a.ANM_ID)+')' end as ANM,                  
case when a.ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),a.ASHA_ID)+')' end as ASHA                  
,a.Financial_Year                                 
,Convert(varchar,PNC1_Date_Infant,103) as PNC1_Date                          
,Convert(varchar,PNC2_Date_Infant,103) as PNC2_Date            
,Convert(varchar,PNC3_Date_Infant,103) as PNC3_Date                          
,Convert(varchar,PNC4_Date_Infant,103) as PNC4_Date                          
,Convert(varchar,PNC5_Date_Infant,103) as PNC5_Date                          
,Convert(varchar,PNC6_Date_Infant,103) as PNC6_Date                          
,Convert(varchar,PNC7_Date_Infant,103) as PNC7_Date,                  
Convert(varchar,[BCG_Dt],103) as BCG,                           
Convert(varchar,[OPV0_Dt],103) as OPV0,                          
Convert(varchar,[DPT1_Dt],103) as DPT1,                          
Convert(varchar,[DPTBooster1_Dt],103) as DPTBooster1,                           
Convert(varchar,[HepatitisB0_Dt],103) as HepB1 ,                            
Convert(varchar,[Penta1_Dt],103) as Penta1,                          
Convert(varchar,[OPV1_Dt],103) as OPV1,                          
Convert(varchar,[DPT2_Dt],103) as DPT2,                          
Convert(varchar,[DPTBooster2_Dt],103) as DPTBooster2,                           
Convert(varchar,[HepatitisB1_Dt],103) as HepB2 ,                            
Convert(varchar,[Penta2_Dt],103) as Penta2,                          
Convert(varchar,[Measles1_Dt],103) as Measles1,                          
Convert(varchar,[VitA_Dose1_Dt],103) as VitaminA_Dose1,                          
Convert(varchar,[MR1_Dt],103) as MR1                          
 ,ISNULL(dup_rank_withoutAddr,0) as dup_rank                         
from t_child_flat(nolock) A           
inner join  (select Registration_no,dup_rank_withoutAddr, Birth_Date,ANM_ID,ASHA_ID from t_children_registration(nolock) where dup_case_withoutAddr=1 and (District_Code=@District_Code                         
or  @District_Code=0) and (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) and (HealthFacility_Code=@HealthFacility_Code  or @HealthFacility_Code=0)                          
and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and (Financial_Year=@Finyear or @Finyear=0) )  B on a.Registration_no=b.Registration_no                         
inner join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=A.District_ID                          
inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=A.HealthBlock_ID                          
inner join  TBL_PHC(nolock)PHC on PHC.PHC_CD=A.PHC_ID                           
left outer join tbl_subphc  (nolock)d on A.SubCentre_ID=d.SUBPHC_CD                           
left outer join TBL_VILLAGE (nolock)c on A.Village_ID=c.VILLAGE_CD and  a.SubCentre_ID =c.SUBPHC_CD                  
left outer join t_Ground_Staff (nolock)an on a.ANM_ID=an.ID                  
left outer join t_Ground_Staff (nolock)ash on a.ASHA_ID=ash.ID                          
 order by dup_rank_withoutAddr                           
End                          
if(@Category='MotherLMP')        -- Not in use keep it as it is.                  
begin                        
                          
with LMPDuplicate(registration_no)                      
as                      
(                      
 select registration_no from t_mother_flat(nolock) where (District_ID=@District_Code or  @District_Code=0) and (HealthBlock_ID=@HealthBlock_Code or                     
 @HealthBlock_Code=0) and (PHC_ID=@HealthFacility_Code  or @HealthFacility_Code=0)                      
and (SubCentre_ID=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                       
and (Village_ID=@Village_Code or @Village_Code=0 ) and (Mother_Yr =@Finyear or @Finyear=0 )                      
group by registration_no,medical_LMP_Date   having COUNT(1)>=1                      
)                      
select DIST_NAME_ENG as Distirct,                       
 Block_Name_E as Block,                      
 PHC_NAME as PHC,                      
 SUBPHC_NAME_E as SubCenter,                      
 VILLAGE_NAME as Village,                      
 a.Address,                      
convert(varchar,A.Registration_no) as RCH_ID,                      
a.Case_no as CaseNumber , Name_wife as NameOfPW,Name_husband as NameOfHusband,                      
Convert(varchar,Mother_BirthDate,103) as Birth_Date,a.Mobile_No as MobileNumber,                      
EC_ANM_ID AS ANM_ID,EC_ASHA_ID as ASHA_ID,                      
Convert(varchar,EC_Regisration_Date,103) as EC_Registration_Date,                      
CONVERT(varchar ,Mother_Registration_Date,103) as Mother_Registration_Date,                      
CONVERT(varchar,medical_LMP_Date,103) as Medical_LMP_Date,                      
Convert(varchar, Medical_EDD_Date,103) as Medical_EDD_Date,                      
 Convert(varchar,Delivery_date,103) as Delivery_date, Delivery_Outcomes,                      
Convert(varchar,ANC1,103) as ANC1 ,                      
Convert(varchar,ANC2,103) as ANC2,                      
Convert(varchar,ANC3,103) as ANC3                      
,Convert(varchar,ANC4,103) as ANC4                      
,Convert(varchar,PNC1_Date,103) as PNC1_Date                      
,Convert(varchar,PNC2_Date,103) as PNC2_Date                      
,Convert(varchar,PNC3_Date,103) as PNC3_Date                      
,Convert(varchar,PNC4_Date,103) as PNC4_Date                      
,Convert(varchar,PNC5_Date,103) as PNC5_Date                      
,Convert(varchar,PNC6_Date,103) as PNC6_Date                      
,Convert(varchar,PNC7_Date,103) as PNC7_Date                      
 ,0 as dup_rank                     
from t_mother_flat (nolock)A                      
inner join LMPDuplicate b                      
 on a.registration_no=b.registration_no                       
inner join                      
TBL_DISTRICT(nolock)               
dist on dist.DIST_CD=a.District_ID                      
inner join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=a.HealthBlock_ID                      
inner join  TBL_PHC(nolock) PHC on PHC.PHC_CD=a.PHC_ID                       
left outer join tbl_subphc  (nolock) on a.SubCentre_ID=tbl_subphc.SUBPHC_CD                        
left outer join TBL_VILLAGE (nolock) on a.Village_ID=TBL_VILLAGE.VILLAGE_CD and  a.SubCentre_ID=TBL_VILLAGE.SUBPHC_CD                  
--left outer join t_Ground_Staff an on a.EC_ANM_ID=an.ID                  
--left outer join t_Ground_Staff ash on a.EC_ASHA_ID=ash.ID                      
 order by a.Registration_no ,Case_no                           
End                          
if(@Category='Child')                          
begin                          
select  DIST_NAME_ENG as Distirct,                     
 Block_Name_E as Block,                          
 PHC_NAME as PHC,                          
SUBPHC_NAME_E as SubCenter,                          
VILLAGE_NAME as Village,                          
A.Address as Address,                          
A.Registration_no as RCH_ID,                          
 A.Mother_Reg_no as Mother_RCH_ID,                          
 A.Name_Child as Name_Of_Child,                          
 A.Name_Mother as Mother_Name,                          
 A.Name_Father as Father_Name,                          
 A.Mobile_no as Mobile,                          
Convert(varchar,A.Registration_Date,103) as Registration_Date,                           
CONVERT (varchar,A.Birth_Date,103) as DOB,                          
A.Financial_Year as Financial_Year,                          
case when a.ANM_ID=0 then '' else an.Name+'('+convert(varchar(10),a.ANM_ID)+')' end as ANM,                  
case when a.ASHA_ID=0 then '' else ash.Name+'('+convert(varchar(10),a.ASHA_ID)+')' end as ASHA,                          
Convert(varchar,[BCG_Dt],103) as BCG,                           
Convert(varchar,[OPV0_Dt],103) as OPV0,                          
Convert(varchar,[DPT1_Dt],103) as DPT1,                          
Convert(varchar,[DPTBooster1_Dt],103) as DPTBooster1,                           
Convert(varchar,[HepatitisB0_Dt],103) as HepB1 ,                            
Convert(varchar,[Penta1_Dt],103) as Penta1,                          
Convert(varchar,[OPV1_Dt],103) as OPV1,                          
Convert(varchar,[DPT2_Dt],103) as DPT2,                          
Convert(varchar,[DPTBooster2_Dt],103) as DPTBooster2,                           
Convert(varchar,[HepatitisB1_Dt],103) as HepB2 ,                            
Convert(varchar,[Penta2_Dt],103) as Penta2,                          
Convert(varchar,[Measles1_Dt],103) as Measles1,                          
Convert(varchar,[VitA_Dose1_Dt],103) as VitaminA_Dose1,                          
Convert(varchar,[MR1_Dt],103) as MR1,                          
dup_rank_withoutAddr as dup_rank                         
                          
 from  t_child_flat(nolock)   A                          
inner join (select Registration_no,dup_rank_withoutAddr  from t_children_registration(nolock) where dup_case_withoutAddr=1    and (District_Code=@District_Code or  @District_Code=0)                         
and (HealthBlock_Code=@HealthBlock_Code or @HealthBlock_Code=0) and (HealthFacility_Code=@HealthFacility_Code  or @HealthFacility_Code=0)                          
and (HealthSubFacility_Code=@HealthSubFacility_Code or @HealthSubFacility_Code=0 )                           
and (Village_Code=@Village_Code or @Village_Code=0 ) and (Financial_Year=@Finyear or @Finyear=0 ) ) B on a.Registration_no=b.Registration_no                            
left outer join  TBL_DISTRICT(nolock) dist on dist.DIST_CD=a.District_ID                          
left outer join  TBL_HEALTH_BLOCK(nolock)block on  block.BLOCK_CD=a.HealthBlock_ID                          
left outer join  TBL_PHC(nolock)PHC on PHC.PHC_CD=a.PHC_ID                          
left outer join  TBL_VILLAGE (nolock)c on a.Village_ID=c.VILLAGE_CD  and  a.SubCentre_ID=c.SUBPHC_CD                         
left outer join  tbl_subphc  (nolock)d on a.SubCentre_ID=d.SUBPHC_CD                  
left outer join t_Ground_Staff (nolock)an on a.ANM_ID=an.ID                  
left outer join t_Ground_Staff (nolock)ash on a.ASHA_ID=ash.ID                            
  order by dup_rank_withoutAddr                           
end                          
end                          
end 

