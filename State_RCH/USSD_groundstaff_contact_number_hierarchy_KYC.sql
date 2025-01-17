USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[USSD_groundstaff_contact_number_hierarchy_KYC]    Script Date: 09/26/2024 14:53:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* 


USSD_groundstaff_contact_number_hierarchy_KYC '7028413184'
'

*/

/* hp.name (type_name) need to be added .....its not added bcz of collation error */
ALTER procedure [dbo].[USSD_groundstaff_contact_number_hierarchy_KYC]
(
@contact_no varchar(50)


)
as
begin
 
--if exists (select * from RCH_National_Level.dbo.[t_Registration_Mobile_USSD] where [Contact_No]=@contact_no  )

--select '0' as flag,  ''+ ngst.[Name]+ ' ('+hp.Type_Name+ ':'+(case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at '+ ISNULL( sc.Name_E,'')+'?' as msg
--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' as  msg 

DECLARE @stid as int =0 , @did as int =0  , @bid as int =0  , @pid as int =0, @sid as int =0,@counterflag as int =0,@s varchar(1000),@Name nvarchar(150)=null,@IsEnglish as bit=1

DECLARE @stateName  varchar(100)


SELECT @stid=D.StateID,@did=G.District_Code,@bid=G.HealthBlock_Code ,@pid=G.HealthFacilty_Code ,@sid=G.HealthSubFacility_Code  ,@Name=G.Name
FROM t_Ground_Staff  G INNER JOIN District D on G.District_Code=D.DCode  WHERE Contact_No=@contact_no 

select @stateName =isnull((select [Group_Name]  FROM [RCH_National_Level] .[dbo].[SMS_Group] where [Group_ID]-100  = @stid),'DEMO')
--print @stateName

if(@Name like '%[A-Z]%')
set @IsEnglish=1
else
set @IsEnglish=0
--print (@stid +@did+@bid+@pid+@sid)

if(@stid<>0 and @did<>0 and @bid<>0 and @pid<>0 and @sid<>0)
begin
set @counterflag=1 -- Sc.name
end 

ELSE if(@stid<>0 and @did<>0 and @bid<>0 and @pid<>0 and @sid=0)
begin
set @counterflag=2 -- phc.name
end


ELSE if(@stid<>0 and @did<>0 and @bid<>0 and @pid=0 and @sid=0)
begin
set @counterflag=3 -- b.name
end

ELSE if(@stid<>0 and @did<>0 and @bid=0 and @pid=0 and @sid=0)
begin
set @counterflag=4 -- d.name
end

ELSE if(@stid<>0 and @did=0 and @bid=0 and @pid=0 and @sid=0)
begin
set @counterflag=5 -- state.name
end

ELSE if(@stid=0 and @did=0 and @bid=0 and @pid=0 and @sid=0)
begin
set @counterflag=6 -- msg=you are in demo db
end

print @counterflag
if(@counterflag=1)
begin
	if(@IsEnglish=1)--English
	Begin
	select '0' as flag, ''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( sc.Name_E,'')+
            + ','+ ISNULL( p.Name_E,'')+
            + CHAR(13)+ ''+ ISNULL( h.Name_E,'')+
            + ','+ ISNULL( d.Name_E,'')+
            +  CHAR(13)+ ISNULL( @stateName,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg

	from [t_Ground_Staff] ngst
	inner join RCH_National_Level .dbo.m_HealthProvider_Type  hp on hp.Type_ID  =ngst.Type_ID  
	INNER JOIN Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	 left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	 left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	 -- left outer join [State] st on  d.StateID  =st.StateID 
	--  left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  --and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1
	End
	--union 

	--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
	--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 
	else --hindi
	begin
	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(''+ ngst.[Name]+
	CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
           'Male'   ELSE
            'Female' end)+
            --+ CHAR(13)+ ''+ ISNULL( sc.Name_E,'')+
            --+ CHAR(13)+ ''+ ISNULL( d.Name_E,'')+
           + CHAR(13)+ ''+ ISNULL( sc.Name_E,'')+
            + ','+ ISNULL( p.Name_E,'')+
            + CHAR(13)+ ''+ ISNULL( h.Name_E,'')+
            + ','+ ISNULL( d.Name_E,'')+
            +  CHAR(13)+ ISNULL( @stateName,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' ) as msg

	from  [t_Ground_Staff] ngst
	INNER JOIN Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID  =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	 left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	 left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	 -- left outer join [State] st on  d.StateID  =st.StateID 
	--  left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 --and ngst.Name not like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
end

if(@counterflag=2)
begin
if(@IsEnglish =1)--english
	begin
	select '0' as flag,  ''+ 
	''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ISNULL( p.Name_E,'')+
            + CHAR(13)+ ISNULL( h.Name_E,'')+
            +','+ ISNULL( d.Name_E,'')+
            +  ','+ ISNULL( @stateName,'')+
         --   + CHAR(13)+ ''+ ISNULL( p.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg
	

	from [t_Ground_Staff] ngst
	INNER JOIN Health_PHC p on ngst.HealthFacilty_Code =p.PID
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	--  left outer join [State] st on  d.StateID  =st.StateID 
	--  left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	--  left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  -- and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
--union 

--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 
	else --hindi
	begin
	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(''+ 
	''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
          + CHAR(13)+ ISNULL( p.Name_E,'')+
            + CHAR(13)+ ISNULL( h.Name_E,'')+
            +','+ ISNULL( d.Name_E,'')+
            +  ','+ ISNULL( @stateName,'')+
            --+ CHAR(13)+ ''+ ISNULL( p.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +''  ) as msg

	from  [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	INNER JOIN Health_PHC p on ngst.HealthFacilty_Code =p.PID
	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	 left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	 -- left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	--  left outer join [State] st on  d.StateID  =st.StateID 
	--  left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	--  left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  -- and ngst.Name not like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
end

 if(@counterflag=3)
begin 
	if(@IsEnglish =1) --english
	begin
	select '0' as flag,  
	
	''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( h.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg
   

	from [t_Ground_Staff] ngst
	INNER join [Health_Block] h on ngst.HealthBlock_Code =h.BID
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	 -- left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	 -- left outer join [State] st on  d.StateID  =st.StateID 
	 -- left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	--  left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 -- and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
--union 

--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 
	else --Hindi
	begin
	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(	''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( h.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +''
    ) as msg

	from  [t_Ground_Staff] ngst
	INNER join [Health_Block] h on ngst.HealthBlock_Code =h.BID
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	 -- left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	 -- left outer join [State] st on  d.StateID  =st.StateID 
	 -- left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	--  left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 -- and ngst.Name not like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
end

if(@counterflag=4)
begin
	if(@IsEnglish =1) --english
	begin
	select '0' as flag,  
	
		''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( d.Name_E ,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg
   
	

	from [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  --left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
--union 
	else --hindi
	begin
	--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
	--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 
	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(		''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( d.Name_E ,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' ) as msg

	from  [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  --left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  --and ngst.Name not like '%[A-Z]%' 
	and ngst.Is_Active=1

	end
END

if(@counterflag=5)
begin
	if(@IsEnglish =1) --english
	begin
	select '0' as flag, 
	
			''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( st.Name_E ,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg
               


	from [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 


	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	   left outer join [State] st on  d.StateID  =st.StateID 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  --left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 -- and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
--union 
	else --Hindi
	begin
	--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
	--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 
	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(	''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( st.Name_E ,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' ) as msg

	from  [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	   left outer join [State] st on  d.StateID  =st.StateID 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  --left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 -- and ngst.Name not like '%[A-Z]%' 
	and ngst.Is_Active=1
	end
end

if(@counterflag=6)
begin
	
	select '0' as flag, 
	
		''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( st.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' as msg

	from [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37  and ngst.Name like '%[A-Z]%' 
	and ngst.Is_Active=1

union 
	

	--select '1' as flag, RCH_National_Level.dbo.UnicodeToHex(''+ ngst.[Name]+ '( '+hp.Type_Name+ (case LEn(d.StateID) when 1 then '0'+CAST(d.StateID AS varchar) else  CAST(d.StateID AS varchar) end)+'-'+cast(ngst.[ID] as varchar)+')'+CHAR(13)+'Are you working at'+ ISNULL( sc.Name_E,'')+'?' ) as msg
	--+','+ ISNULL( v.Name_E,'')  +','+ ISNULL( sc.Name_E,'') +','+ isnull(p.Name_E,'') +','+ ISNULL( h.Name_E,'') +','+ isnull(d.Name_E,'')  +','+ ISNULL( st.Name_E,'')  +' .Please press 1 or 2 ' ) as  msg 

	select '1' as flag, RCH_National_Level.dbo.UnicodeToHex( 
		''+ ngst.[Name]+
	--CHAR(13)+''+(CASE WHEN ngst.[Sex] = 'M' THEN
 --          'Male'   ELSE
 --           'Female' end)+
            + CHAR(13)+ ''+ ISNULL( st.Name_E,'')+
             CHAR(13) + hp.Type_Name+' ID: ' + cast(ngst.[ID] as varchar)
	 +CHAR(13)+'Aadhaar: '+ isnull(cast(ngst.Aadhar_No as varchar),'NA') 
               +'' ) as msg

	from  [t_Ground_Staff] ngst
		inner join RCH_National_Level .dbo.m_HealthProvider_Type hp on hp.Type_ID =ngst.Type_ID 

	--INNER JOIN t_Ground_Staff sgst on ngst.ID=sgst.ID 
	 left outer join [District] d on ngst.District_Code=d.DCode 
	  --inner join [All_Taluka] t on a.Taluka_ID =t.TCode
	  --left outer join [Health_Block] h on ngst.HealthBlock_Code =h.BID
	  --left outer join Health_PHC p on ngst.HealthFacilty_Code =p.PID
	  left outer join [State] st on  d.StateID  =st.StateID 
	  --left outer join Health_SubCentre sc  on ngst.HealthSubFacility_Code=sc.[SID]
	  --left outer join [Village] v  on ngst.HealthSubFacility_Code=v.VCode
	where ngst.[Contact_No]=@contact_no and ISNULL(d.StateID,0)<>37 and ngst.Name not like '%[A-Z]%' 

end


end


--select  ID ,Contact_No , Name from t_Ground_Staff where Name  not like '%[A-Z]%'


