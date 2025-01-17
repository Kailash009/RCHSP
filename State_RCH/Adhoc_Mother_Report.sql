USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[Adhoc_Mother_Report]    Script Date: 09/26/2024 11:56:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------------------
/*
Adhoc_Mother_Report 4,1,1,15,0,0,0,0,0,0,3--with UID
Adhoc_Mother_Report 4,24,108,449,0,0,2017,0,0,4,0,0--withoutUID
Adhoc_Mother_Report 4,24,108,449,0,0,2017,0,0,4,0,0--withoutUID
Adhoc_Mother_Report 30,1,0,0,0,0,2016,0,0,2,20
*/
ALTER procedure [dbo].[Adhoc_Mother_Report]
(
@State_Code as int=0,
@District_Code as int=0,
@HealthBlock_Code as int=0,
@HealthFacility_Code as int=0,
@HealthSubFacility_Code as int=0,
@Village_Code as int=0,
@FinancialYr as int=0,
@Month_ID as int=0,
@Year_ID as int=0,
@Category_ID as int=0,--hierrachy
@Type as int=0,--LMP/EDD/Registrerd
@Filter_Type as int=0,
@Sub_Filter_Type as int=0
)
as
begin

if(@Type<>99)
begin

Select  ROW_NUMBER() OVER(ORDER BY a.Registration_No ASC) AS [Sno] ,isnull(f.SubPHC_Name_E,'Direct Entry')+CAST((case when f.SUBPHC_CD is null then '(0)' else '' end) as varchar) as [Health SubFacility]
,isnull(g.Village_name,'Direct Entry')+'('+cast(isnull(g.MDDS_Code,0) as varchar)+')' as Village
,a.Registration_No as [RCH ID],a.Name_Wife as Name,a.Name_husband as [Husband Name]--,dbo.get_masked_UID(a.PW_Aadhar_No) as Aadhaar 
,isnull(dbo.get_masked_Account(a.PW_Account_No),'') as [Account No],isnull(a.PW_Bank_Name,'') as [Bank Name],isnull(a.PW_Branch_Name,'') as [Branch Name]
,isnull(a.PW_IFSC_Code,'') as [IFSC Code]
--,(case when cast(isnull(a.PW_AadhaarLinked,0) as varchar)=0 then 'N' else 'Y' end) as [Aadhaar Linked]
,(case Whose_mobile when 'Wife' 
then (a.Mobile_no) when 'Husband' then (a.Mobile_no) else '' end)as [Self Mobile No],
ISNULL( c.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + ')/' + ISNULL( d.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + ')' as ANM_ASHA_Name                  
 from t_mother_Flat a
inner join t_mother_Flat_count b on a.Registration_no=b.Registration_no and a.case_no=b.Case_no 
left outer join TBL_SubPHC f on b.SubCentre_ID=f.SUBPHC_CD 
left outer join TBL_Village g on b.Village_ID=g.Village_CD and b.SubCentre_ID=g.SUBPHC_CD 
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ANM_ID=c.ID      
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.Mother_ASHA_ID=d.ID 
where a.Mother_Registration_Date is not null 
and (CASE @Type WHEN  1 THEN b.Mother_Reg_Fin_Yr  when 2 then b.LMP_FinYr when 3 then b.EDD_FinYr else 0 END)=@FinancialYr      
and (CASE WHEN @Type = 1 and @Year_ID<>0  THEN Year(b.Mother_Registration_Date) WHEN @Type = 2 and @Year_ID<>0  THEN b.LMP_Year WHEN @Type = 3 and @Year_ID<>0  THEN b.EDD_Yr  ELSE  0 END)=@Year_ID  
and (CASE WHEN @Type = 1 and @Month_ID<>0  and @Month_ID<=12 THEN Month(b.Mother_Registration_Date) WHEN @Type = 2 and @Month_ID<>0 and @Month_ID<=12 THEN b.LMP_month WHEN @Type = 3 and @Month_ID<>0  and @Month_ID<=12 THEN b.EDD_month  ELSE  0 END)=@Month_ID  
and (Case when @Type = 1 and @Month_ID<>0  and @Month_ID=46 then Month(b.Mother_Registration_Date) when  @Type = 2 and @Month_ID<>0  and @Month_ID=46 then b.LMP_month when  @Type = 3 and @Month_ID<>0  and @Month_ID=46 then b.EDD_month else 4 end) between 4 and 6
and (Case when @Type = 1 and @Month_ID<>0  and @Month_ID=79 then Month(b.Mother_Registration_Date) when  @Type = 2 and @Month_ID<>0  and @Month_ID=79 then b.LMP_month when  @Type = 3 and @Month_ID<>0  and @Month_ID=79 then b.EDD_month else 7 end) between 7 and 9
and (Case when @Type = 1 and @Month_ID<>0  and @Month_ID=1012 then Month(b.Mother_Registration_Date) when  @Type = 2 and @Month_ID<>0  and @Month_ID=1012 then b.LMP_month when  @Type = 3 and @Month_ID<>0  and @Month_ID=1012 then b.EDD_month else 10 end) between 10 and 12
and (Case when @Type = 1 and @Month_ID<>0  and @Month_ID=13 then Month(b.Mother_Registration_Date) when  @Type = 2 and @Month_ID<>0  and @Month_ID=13 then b.LMP_month when  @Type = 3 and @Month_ID<>0  and @Month_ID=13 then b.EDD_month
else 1 end) between 1 and 3
and Abortion_Present=0  --(added due to not displaying abortion case record)
and b.PHC_ID =@HealthFacility_Code  
and (CASE WHEN @Category_ID >=5 THEN b.SubCentre_ID else 0 END)=@HealthSubFacility_Code
and (CASE WHEN @Category_ID >=6 THEN b.Village_ID else 0 END)=@Village_Code
and (Case @Filter_Type when 2 then b.JSY_Beneficiary_Y when 3 then b.High_risk_Severe when 4 then b.Severe_Anemic_Case else 1 end)=1
and (CASE @Sub_Filter_Type 
when 3 THEN b.PW_EID_Present   
when 5 then b.PW_Acc_Present
when 6 then b.PW_Bank_Name_Present
when 7 then b.PW_Branch_Present
when 8 then b.PW_IFSC_Present
when 1 then b.PW_Aadhar_No_Present
when 2 then b.Mobile_no_Present
when 9 then b.PW_UIDLinked_Present
ELSE 1
END)=1 
and (
(Case when @Sub_Filter_Type=4 or @Sub_Filter_Type=19 then b.Whose_mobile_Wife else 1 end)=1 
or (case when @Sub_Filter_Type=4 or @Sub_Filter_Type=19 then b.Whose_mobile_Husband else 1 end)=1)
and (Case when @Sub_Filter_Type=13  then b.PW_Bank_Name_Present else 0 end)=0
and (Case when @Sub_Filter_Type=11  then b.Whose_mobile_Husband else 0 end)=0
and (Case when @Sub_Filter_Type=11  then b.Whose_mobile_Wife else 0 end)=0
and (Case when @Sub_Filter_Type=4 then b.Mobile_no_Present else 1 end)=1
and (Case when @Sub_Filter_Type=10 then b.PW_Aadhar_No_Present else 0 end)=0
and (Case when @Sub_Filter_Type=12 then b.PW_UIDLinked_Present else 0 end)=0
and (Case when @Sub_Filter_Type=17 then b.Validated_Callcentre else 0 end)=0
and (Case when @Sub_Filter_Type=15 then DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date) else 0 end)<=3
and 
(
(Case when @Sub_Filter_Type=16 then DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date) else 5 end)>3
or (Case when @Sub_Filter_Type=16 then DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date) else 5 end)<=6
)
and 
(
(Case when @Sub_Filter_Type=17 then DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date) else 7 end)>6
or (Case when @Sub_Filter_Type=17 then DATEDIFF(month,b.LMP_Date,b.Mother_Registration_Date) else 7 end)<=9
)
and (Case when @Sub_Filter_Type=18 then b.LMP_minanc4 else convert(date,GETDATE()+1) end) between convert(date,GETDATE()-1) and  convert(date,dateadd(MONTH,3,GETDATE()-1))
and (Case when @Sub_Filter_Type=18 then b.Abortion_Present else 0 end)<>1
and (Case when @Sub_Filter_Type=18 then b.Delivery_Date_Present else 0 end)<>1

and (Case when @Sub_Filter_Type=19 then b.EDD_Date else convert(date,GETDATE()+1) end) between convert(date,GETDATE()-1) and  convert(date,dateadd(MONTH,3,GETDATE()-1))
and (Case when @Sub_Filter_Type=19 then b.Abortion_Present else 0 end)<>1
and (Case when @Sub_Filter_Type=19 then b.Delivery_Date_Present else 0 end)<>1

and (Case when @Sub_Filter_Type=20 then b.PNC1_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC2_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC3_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC4_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC5_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC6_Type_Absent else 1 end)=1
and (Case when @Sub_Filter_Type=20 then b.PNC7_Type_Absent else 1 end)=1

END
else
begin


Select  ROW_NUMBER() OVER(ORDER BY a.Registration_No ASC) AS [Sno] ,isnull(f.SubPHC_Name_E,'Direct Entry')+CAST((case when f.SUBPHC_CD is null then '(0)' else '' end) as varchar) as [Health SubFacility]
,isnull(g.Village_name,'Direct Entry')+'('+cast(isnull(g.MDDS_Code,0) as varchar)+')' as Village
,a.Registration_No as [RCH ID],a.Name_Wife as Name,a.Name_husband as [Husband Name]--,dbo.get_masked_UID(a.PW_Aadhar_No) as Aadhaar 
,isnull(dbo.get_masked_Account(a.PW_Account_No),'') as [Account No],isnull(a.PW_Bank_Name,'') as [Bank Name],isnull(a.PW_Branch_Name,'') as [Branch Name]
,isnull(a.PW_IFSC_Code,'') as [IFSC Code],
--,(case when cast(isnull(a.PW_AadhaarLinked,0) as varchar)=0 then 'N' else 'Y' end) as [Aadhaar Linked],
(case Whose_mobile when 'Wife' 
then (a.Mobile_no) when 'Husband' then (a.Mobile_no) else '' end)as [Self Mobile No],a.Mother_Registration_Date as [Registration Date],
ISNULL( c.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( c.ID,0) ) + ')/' + ISNULL( d.Name,'') + '(' + CONVERT(VARCHAR(150),ISNULL( d.ID,0) ) + ')' as ANM_ASHA_Name      
from t_mother_Flat a
inner join t_mother_Flat_count b on a.Registration_no=b.Registration_no and a.case_no=b.Case_no 
left outer join TBL_SubPHC f on b.SubCentre_ID=f.SUBPHC_CD 
left outer join TBL_Village g on b.Village_ID=g.Village_CD and b.SubCentre_ID=g.SUBPHC_CD 
Left outer join t_Ground_Staff c WITH (NOLOCK) on a.Mother_ANM_ID=c.ID      
Left outer join t_Ground_Staff d WITH (NOLOCK) on a.Mother_ASHA_ID=d.ID 
inner join
(select SubCentre_ID,Village_ID,Name_wife,Name_husband,Mother_Registration_Date from t_mother_flat  
where PHC_ID=@HealthFacility_Code 
and Mother_Registration_Date is not null 
group by SubCentre_ID,Village_ID,Name_wife,Name_husband,Mother_Registration_Date
having(COUNT(*)>1)
)X on a.SubCentre_ID=X.SubCentre_ID and a.Village_ID=X.Village_ID and a.Name_wife=x.Name_wife and a.Name_husband=X.Name_husband and a.Mother_Registration_Date=X.Mother_Registration_Date
and Abortion_Present=0  --(added due to not displaying abortion case record)
order by a.name_wife,a.Name_husband,a.Mother_Registration_Date




end

--Declare @S as varchar(max)='',@Wherclause as varchar(5000)='',@From as varchar(5000)='',@ColumnName as varchar(5000)=''

--select @ColumnName=' ROW_NUMBER() OVER(ORDER BY a.Registration_No ASC) AS [Sno]'


--set @From='from t_mother_Flat a
--inner join t_mother_Flat_count b on a.Registration_no=b.Registration_no and a.case_no=b.Case_no'

--if(@Category_ID<=2)
--begin
--set @ColumnName=@ColumnName
----+',c.Dist_Name_Eng+''(''+cast(isnull(c.MDDS_Code,0) as varchar)+'')'' as District'
--set @From=@From+' inner join TBL_District c on b.District_ID=c.DIST_CD'
--end

--if(@Category_ID<=2)
--begin
--set @ColumnName=@ColumnName+' ,d.Block_Name_E as Block,h.TAL_NAME+''(''+cast(isnull(h.MDDS_Code,0) as varchar)+'')'' as Taluka'
--set @From=@From+' inner join TBL_Health_Block d on b.HealthBlock_ID=d.Block_CD'
--set @From=@From+' inner join TBL_Taluka h on d.Taluka_CD=h.TAL_CD'
--end


--if(@Category_ID<=3)
--begin
--set @ColumnName=@ColumnName+' ,e.PHC_Name as [Health Facility]'
--set @From=@From+' inner join TBL_PHC e on b.PHC_ID=e.PHC_CD'
--end

--if(@Category_ID<=4)
--begin
--set @ColumnName=@ColumnName+',isnull(f.SubPHC_Name_E,''Direct Entry'')+CAST((case when f.SUBPHC_CD is null then ''(0)'' else '''' end) as varchar) as [Health SubFacility]'
--set @From=@From+' left outer join TBL_SubPHC f on b.SubCentre_ID=f.SUBPHC_CD'
--end

--if(@Category_ID<=5)
--begin
--set @ColumnName=@ColumnName+',isnull(g.Village_name,''Direct Entry'')+''(''+cast(isnull(g.MDDS_Code,0) as varchar)+'')'' as Village'
--set @From=@From+' left outer join TBL_Village g on b.Village_ID=g.Village_CD and b.SubCentre_ID=g.SUBPHC_CD'
--end

--set @ColumnName=@ColumnName +',a.Registration_No as [RCH ID],a.Name_Wife as Name,a.Name_husband as [Husband Name],dbo.get_masked_UID(a.PW_Aadhar_No) as Aadhaar 
--,isnull(dbo.get_masked_Account(a.PW_Account_No),'''') as [Account No],isnull(a.PW_Bank_Name,'''') as [Bank Name],isnull(a.PW_Branch_Name,'''') as [Branch Name]
--,isnull(a.PW_IFSC_Code,'''') as [IFSC Code]
--,(case when cast(isnull(a.PW_AadhaarLinked,0) as varchar)=0 then ''N'' else ''Y'' end) as [Aadhaar Linked],(case Whose_mobile when ''Wife'' 
--then (a.Mobile_no) when ''Husband'' then (a.Mobile_no) else '''' end)as [Self Mobile No]
--'


--if(@District_Code<>0)
--begin
--	set @Wherclause='and b.District_ID='+cast(@District_Code as varchar)+''
--end
--if(@HealthBlock_Code<>0)--Block
--begin
--	set @Wherclause=@Wherclause+' and b.HealthBlock_ID='+cast(@HealthBlock_Code as varchar)+''
--end
--if(@HealthFacility_Code<>0)--PHC
--begin
--set @Wherclause=@Wherclause+' and  b.PHC_ID='+cast(@HealthFacility_Code as varchar)+''
--end
--if(@HealthSubFacility_Code<>0)--SC
--begin
--set @Wherclause=@Wherclause+' and  b.SubCentre_ID='+cast(@HealthSubFacility_Code as varchar)+''
--set @Wherclause=@Wherclause+' and  (b.Village_ID='+cast(@Village_Code as varchar)+' or '+cast(@Village_Code as varchar)+'=0) '

--end


--if(@FinancialYr<>0)
--begin
--set @Wherclause=@Wherclause+' and  b.Mother_Reg_Fin_Yr='+cast(@FinancialYr as varchar)+''
--end

--if(@Month_ID<>0)
--begin
--set @Wherclause=@Wherclause+' and  month(b.Mother_Registration_Date)='+cast(@Month_ID as varchar)+''
--end

--if(@Year_ID<>0)
--begin
--set @Wherclause=@Wherclause+' and  Year(b.Mother_Registration_Date)='+cast(@Year_ID as varchar)+''
--end






--if(@Filter_Type=4)-- With Self Mobile
--begin
--set @Wherclause=@Wherclause+' and  b.Mobile_no_Present=1 and (b.Whose_mobile_Wife=1 or Whose_mobile_Husband=1)'
--end

--if(@Filter_Type=5)-- With Account Number
--begin
--set @Wherclause=@Wherclause+' and  b.PW_Acc_Present=1'
--end

--if(@Filter_Type=6)--With Bank Name
--begin
--set @Wherclause=@Wherclause+' and  b.PW_Bank_Name_Present=1'
--end

--if(@Filter_Type=7)--With Branch Name
--begin
--set @Wherclause=@Wherclause+' and  b.PW_Branch_Present=1'
--end


--if(@Filter_Type=8)--With IFSC Code
--begin
--set @Wherclause=@Wherclause+' and  b.PW_IFSC_Present=1'
--end


--if(@Filter_Type=9)--With Aadhaar Linked
--begin
--set @Wherclause=@Wherclause+' and b.PW_UIDLinked_Present=1'
--end

--if(@Filter_Type=10)--Without Aadhaar
--begin
--set @Wherclause=@Wherclause+' and b.PW_Aadhar_No_Absent=1'
--end

--if(@Filter_Type=11)--Without Self Mobile
--begin
--set @Wherclause=@Wherclause+' and b.Whose_mobile_Husband=0 and b.Whose_mobile_Wife=0'
----end
--if(@Filter_Type=12)--Without Aadhaar Linked
--begin
--set @Wherclause=@Wherclause+' and b.PW_UIDLinked_Present=0'
--end

--if(@Filter_Type=13)--Without Bank Name
--begin
--set @Wherclause=@Wherclause+' and  b.PW_Bank_Name_Present=0'
--end
--if(@Filter_Type=14)--Without JSY Bank Name
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_Bank_Name_Present=0'
--end
--if(@Filter_Type=15)--JSY Bank Name
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_Bank_Name_Present=1'
--end
--if(@Filter_Type=18)--JSY Without Self Mobile
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and Whose_mobile_Wife=0 or Whose_mobile_Husband=0'
--end
--if(@Filter_Type=19)--JSY Self Mobile
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and Whose_mobile_Wife=1 or Whose_mobile_Husband=1'
--end
--if(@Filter_Type=21)--JSY Aadhaar
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_Aadhar_No_Present=1 '
--end
--if(@Filter_Type=20)--JSY Without Aadhaar
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_Aadhar_No_Present=0 '
--end
--if(@Filter_Type=16)--JSY Without Aadhaar Linked
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_UIDLinked_Present=0'
--end
--if(@Filter_Type=17)--JSY Aadhaar Linked
--begin  
--set @Wherclause=@Wherclause+' and JSY_Beneficiary_Y=1 and PW_UIDLinked_Present=1'
--end
--if(@Filter_Type=22)--High Risk Cases
--begin  
--set @Wherclause=@Wherclause+' and High_risk_Severe=1'
--end
--select @S='Select '+cast(@ColumnName as varchar(5000))+' '+ CAST(@From as varchar(5000))+' where a.Mother_Registration_Date is not null '+CAST(@Wherclause as varchar(5000))
--exec(@S)
--print(@S)
END	

