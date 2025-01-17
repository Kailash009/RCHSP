USE [RCH_35]
GO
/****** Object:  StoredProcedure [dbo].[getBeneficiaryforcbrbyrchid]    Script Date: 09/26/2024 12:02:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[getBeneficiaryforcbrbyrchid]            
 (            
 @registration_no bigint,            
 @caseNo int          
 )            
 as            
 begin            
   select A.Registration_no,a.ANC_Type,ISNULL(A.TT_Date, '')TT_Date,ISNULL(A.TT_Code, '')TT_Code,ISNULL(Blood_Group, '')Blood_Group,A.ANC_Date,A.Abortion_Type,ISNULL(A.Abortion_date,'')Abortion_date,A.Maternal_Death,ISNULL(A.Death_Date,'')Death_Date
 ,A.Death_Reason          
       ,ISNULL(A.HBsAg_Test,'') HBsAg_Test        
   ,ISNULL(A.HBsAg_Result,'')   HBsAg_Result        
   ,ISNULL(A.HBsAg_Date ,'')HBsAg_Date    
from (                    
        select                     
        C.[Registration_no]              
    ,C.Case_no            
    ,[ANC_No]               
       ,TT_Date as TT_Date                    
      ,(Case TT_Code                  
        when 13 then 'TT1'                  
        when 14 then 'TT2'                  
        when 17 then 'TTB' end ) as TT_Code                
    ,case m.Blood_Group when '1' then 'A+ve'when '2' then 'B+ve'            
    when '3' then 'AB+ve'            
    when '4' then 'O+ve'            
    when '5' then 'A-ve'            
    when '6' then 'B-ve'            
    when '7' then 'AB-ve'            
     when '8' then 'O-ve'             
     END AS Blood_Group            
    ,m.LMP_Date            
     ,'ANC - '+ cast([ANC_Type] as varchar(10)) as ANC_Type                    
      , ANC_Date                     
      ,(case Abortion_date when '' then null else Abortion_date end) as Abortion_date                     
      ,(case [Abortion_Type] when '0' then '' when '5' then 'Induced' when '6' then 'Spontaneous' else '' end) as Abortion_Type                      
      ,(case [Maternal_Death] when '0' then 'No' when '1' then 'Yes' else '' end) as Maternal_Death                      
      ,[Death_Date]                      
      ,(case [Death_Reason] when '0' then '' when 'A' then 'Eclampcia' when 'B' then 'Haemorrahge' when 'C' then 'High Fever' when 'D' then 'Abortion'        when 'Z' then 'Any Other Specify' else '' end) as [Death_Reason]            
      ,m.HBSAG_Test as HBsAg_Test          
      ,m.HBSAG_Result as HBsAg_Result          
      ,m.HBSAG_Date as HBsAg_Date    
   from t_mother_anc c             
   inner join t_mother_registration r on c.Registration_no=r.registration_no and c.Case_no=r.Case_no            
   inner join t_mother_medical m on r.Registration_no=m.registration_no and r.Case_no=m.Case_no            
       where --c.State_Code=@State_Code and                   
   c. Registration_no=@Registration_no and c.Case_no=@caseNo)A            
     left outer join                      
      (select MAX(c.Max_ANC_Date) as Max_ANC_Date,max(cast([ANC_Type] as varchar(7))) as ANC_Type ,c.Registration_no,c.Case_no from                     
      (                  
      select [ANC_Date] as Max_ANC_Date,'ANC - '+ cast([ANC_Type] as varchar(1)) as ANC_Type,Registration_no,Case_no from t_mother_anc                      
      where                   
      Registration_no=@Registration_no and Case_no=@caseNo                 
       UNION                  
       select [ANC_Date] as Max_ANC_Date,'ANC - '+ cast([ANC_Type] as varchar(1)) as ANC_Type,Registration_no,Case_no from t_interstate_mother_anc                      
      where                   
      Registration_no=@Registration_no and Case_no=@caseNo                  
      )C group by Registration_no,Case_no                  
      )B on A.Registration_no=B.Registration_no and A.Case_no=b.Case_no order by a.ANC_No                   
   
   SELECT (CASE WHEN r.Registration_Date='1990-01-01' THEN 'false' else 'true' END) as 'IsPregnantWomen',
   Convert(varchar,m.LMP_Date,23 )LMP_Date FROM t_mother_registration r LEFT JOIN t_mother_medical m 
   on r.Registration_no=m.registration_no and r.Case_no=m.Case_no 
   where r.Registration_no=@registration_no and r.Case_no=@caseNo
end 