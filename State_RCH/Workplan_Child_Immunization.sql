USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Workplan_Child_Immunization]    Script Date: 09/26/2024 14:59:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------
 
ALTER procedure [dbo].[Workplan_Child_Immunization]    
(    
 @YEAR int,    
 @MONTH varchar(3),    
 @STATE_CODE int =0,    
 @DISTRICT_CODE int=0,    
 @RURAL_URBAN char(1),    
 @HEALTHBLOCK_CODE int=0,    
 @TALUKA_CODE varchar(6)=0,    
 @HEALTHFACILITY_TYPE int =0,     
 @HEALTHFACILITY_CODE int=0,    
 @SUBFACILITY_CODE  int=0,    
 @VILLAGE_CODE int=0,    
 @Type_ID int=0,    
 @ANMASHA_ID int=0,    
 @Service as int    
)    
AS    
BEGIN    
     declare @Fdate as varchar(50)    
     declare @Ldate as varchar(50)    
     set @Fdate='01/'+ @MONTH+'/'+convert(varchar(4),@YEAR)    
     set @Ldate=convert(varchar,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@Fdate)+1,0)))    
         
       Select sc.Name_E as HealthSubFacility_Name,isNull(v.Name_E , 'Direct Entry') as Village_Name,CReg.Registration_no,CReg.Name_Child,  
       ISNULL(CReg.Mother_Reg_no, '' ) as Mother_Reg_no,  
       CReg.Name_Mother,CReg.Address,(CReg.Mobile_no)Mobile_no,CReg.Birth_Date,    
                         GsANM.[Name] as ANM_Name,(GsANM.[Contact_No]) as ANM_ContNo,GsASHA.[Name] as ASHA_Name  
                         ,(GsASHA.[Contact_No]) as ASHA_ContNo,    
                (Case WC.Immu_Code    
                       when 1 then 'BCG'    
                       when 2 then 'OPV-0'    
                       when 3 then 'OPV-1'    
                       when 4 then 'OPV-2'    
                       when 5 then 'OPV-3'    
                       when 6 then 'OPV-B'    
                       when 7 then 'DPT-1'    
                       when 8 then 'DPT-2'    
                       when 9 then 'DPT-3'    
                       when 10 then 'DPT-B1'    
                       when 11 then 'DPT-B2'    
                       when 12 then 'HEP B-0'    
                       when 13 then 'HEP B-1'    
                       when 14 then 'HEP B-2'    
                       when 15 then 'HEP B-3'    
                       when 16 then 'PENTAVALENT VACCINE-1'    
                       when 17 then 'PENTAVALENT VACCINE-2'    
                       when 18 then 'PENTAVALENT VACCINE-3'    
                       when 19 then 'MEASLES-1'    
                       when 20 then 'MEASLES-2'    
                       when 21 then 'JE VACCINE-1'    
                       when 22 then 'JE VACCINE-2'    
                       when 23 then 'VITAMIN A-1'    
                       when 24 then 'VITAMIN A-2'    
                       when 25 then 'VITAMIN A-3'    
                       when 26 then 'VITAMIN A-4'    
                       when 27 then 'VITAMIN A-5'    
                       when 28 then 'VITAMIN A-6'    
                       when 29 then 'VITAMIN A-7'    
                       when 30 then 'VITAMIN A-8'    
                       when 31 then 'VITAMIN A-9'    
                       end)as Services,Convert(varchar(12),WC.Immu_Date,103) as [Date],WC.SNo,WC.flag,    
Convert(varchar(12),WC.MinDate,103) as MinDate,Convert(varchar(12),WC.MaxDate,103)as MaxDate    
,WC.Immu_Code as ANC_Type  
,(case when @Village_Code<>0 and CReg.HealthSubFacility_Code  <>@SUBFACILITY_CODE  then  1 Else 
       Case when @Village_Code=0 and CReg.HealthFacility_Code <> @HealthFacility_Code   then 1  else 0 end end ) as Guest_Ben                 
 , CReg.Name_Father 
from t_children_registration as CReg (nolock)    
inner join t_workplanChild (nolock) as WC on WC.Registration_no= CReg.Registration_no    
inner join m_ImmunizationName m (nolock) on WC.Immu_code=m.ImmuCode  
left outer join t_Ground_Staff GsANM (nolock) on GsANM.ID = CReg.ANM_ID    
left outer join t_Ground_Staff GsASHA (nolock) on GsASHA.ID = CReg.ASHA_ID  
left outer join Health_SubCentre sc (nolock) on sc.[SID]= CReg.HealthSubFacility_Code  
left outer join VILLAGE v (nolock) on v.VCode=CReg.Village_Code  
where  CReg.State_Code=@State_Code    
and (( @Village_code = 0 and @SUBFACILITY_CODE = 0 and CReg.HealthFacility_Code=@HEALTHFACILITY_CODE)
       OR (@Village_code = 0 and  @SUBFACILITY_CODE != 0 and CReg.HealthSubFacility_Code=@SUBFACILITY_CODE)    
        OR (@Village_code != 0 and CReg.Village_Code  =@Village_Code ) )

--and (CReg.District_Code=@DISTRICT_CODE or @DISTRICT_CODE =0)    
--and (CReg.Taluka_Code=@TALUKA_CODE or @TALUKA_CODE =0)    
--and (CReg.HealthBlock_Code=@HEALTHBLOCK_CODE or @HEALTHBLOCK_CODE =0)    
--and (CReg.HealthFacility_Code=@HEALTHFACILITY_CODE or @HEALTHFACILITY_CODE=0)    
--and (CReg.HealthSubFacility_Code=@SUBFACILITY_CODE or @SUBFACILITY_CODE=0)    
and WC.flag=@Service    
and m.Flag=1  
and isnull(CReg.Entry_type,4)=4 and isnull(CReg.Delete_mother,0)=0  
--and (CReg.ANM_ID=@ANMASHA_ID or CReg.ASHA_ID=@ANMASHA_ID or @ANMASHA_ID=0 )    
and DATEDIFF(DAY,CONVERT(datetime,CReg.Birth_Date),Convert(Varchar(11),@Fdate,120))>365    
and (Case when   @Service=1 then MONTH(Immu_Date) else month(@Fdate) end)=month(@Fdate)  
and (Case when   @Service=1 then Year(Immu_Date) else year(@Fdate) end)=year(@Fdate)  
and (  
(Case when  @Service=0 OR @Service=2 then  convert(varchar(12),@Fdate,120) else  @Fdate end) between  WC.MinDate and WC.MaxDate   
or (Case when  @Service=0 OR @Service=2 then  convert(varchar(12),@Ldate,120) else  @Ldate end) between WC.MinDate and WC.MaxDate   
)  
and (Case when @Service=0 OR @Service=2 then  Immu_Date end) is null  
order by Guest_Ben 
       
END    
 
