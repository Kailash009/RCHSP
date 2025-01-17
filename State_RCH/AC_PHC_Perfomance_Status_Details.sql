USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[AC_PHC_Perfomance_Status_Details]    Script Date: 09/26/2024 14:40:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PHC_Perfomance_Status_Details_V1 3,0,1,2018,'Del'
PHC_Perfomance_Status_Details_V1 3,0,1,2018,'ANC'
PHC_Perfomance_Status_Details_V1 3,0,1,2018,'Immu'
*/
ALTER Procedure [dbo].[AC_PHC_Perfomance_Status_Details]
(
@Parent_ID int,                    
@Child_ID int,                                                   
@Month_ID int ,                  
@Year_ID int,                                   
@Category varchar(10) =''
)
as Begin                                        
Declare @i as int=0,@monthval as int=0,@yearval as int=0                  
Declare @Ldate as date,@Fdate as Date                      
set @Fdate=cast(@Year_ID as varchar)+'-'+cast(@Month_ID as varchar)+'-01'                                    
set @Ldate=convert(Date,DATEADD(s,1,DATEADD(mm, DATEDIFF(m,0,@Fdate)+1,0)))
-----------------------Delivery Not Conducted By PHC-----------------------
if(@Category='Del')                  
begin
Select d.DIST_NAME_ENG as Parent_Name,E.Block_Name_E as Child_Name,HP.Name_E
FROM Health_PHC (nolock) HP  
left outer join t_mother_flat(nolock) MF ON MF.PHC_ID=HP.PID 
and Month(MF.Delivery_date)=@Month_ID
and YEAR(MF.Delivery_date)=@Year_ID  
left outer join TBL_DISTRICT(nolock) d on HP.DCode=d.DIST_CD 
left outer join TBL_HEALTH_BLOCK(nolock) e on HP.BID=e.BLOCK_CD 
where (HP.DCode=@Parent_ID or @Parent_ID=0) 
and (HP.BID=@Child_ID or @Child_ID=0)  
and MF.PHC_ID is null 
and HP.IsActive=1
and HP.Created_On<@Ldate
group by d.DIST_NAME_ENG,E.Block_Name_E,HP.Name_E
end
-----------------------ANC Not Conducted By PHC-----------------------------
if(@Category='ANC')                  
begin
Select d.DIST_NAME_ENG as Parent_Name,E.Block_Name_E as Child_Name,HP.Name_E from Health_PHC(nolock) HP  
left outer join 
(select distinct PHC_ID from  t_mother_flat (nolock) MF    
inner join t_workplanANCDue (nolock) f on MF.Registration_no=f.Registration_no and MF.Case_no=f.Case_no 
inner join Health_PHC(nolock) g on g.PID=MF.PHC_ID 
and (g.dcode=@Parent_ID or @Parent_ID=0) -- 
and (g.bid=@Child_ID or @Child_ID=0) --       
and  Month(f.ANC_Date)=@Month_ID and YEAR(f.ANC_Date)=@Year_ID and F.ANC_Type in (1,2,3,4))M on HP.PID=M.PHC_ID 
left outer join TBL_DISTRICT(nolock) d on HP.DCode=d.DIST_CD 
left outer join TBL_HEALTH_BLOCK(nolock) e on HP.BID=e.BLOCK_CD   
where (HP.DCode=@Parent_ID or @Parent_ID=0) 
and (HP.BID=@Child_ID or @Child_ID=0)   
and M.PHC_ID is null
and HP.IsActive=1
and HP.Created_On<@Ldate
group by d.DIST_NAME_ENG,E.Block_Name_E,HP.Name_E
end
-----------------------Child Immu Not Conducted By PHC----------------------------
if(@Category='Immu')                  
begin
Select d.DIST_NAME_ENG as Parent_Name,E.Block_Name_E as Child_Name,HP.Name_E from Health_PHC(nolock) HP  
left outer join  (select distinct PHC_ID from  t_child_flat(nolock) MF    
inner join t_workplanChild (nolock) f on MF.Registration_no=f.Registration_no  
inner join Health_PHC(nolock) g on g.PID=MF.PHC_ID 
and (g.dcode=@Parent_ID or @Parent_ID=0) -- 
and (g.bid=@Child_ID or @Child_ID=0) --     
and Month(f.Immu_Date)=@Month_ID and YEAR(f.Immu_Date)=@Year_ID  
)M  
on HP.PID=M.PHC_ID 
left outer join TBL_DISTRICT(nolock) d on HP.DCode=d.DIST_CD 
left outer join TBL_HEALTH_BLOCK(nolock) e on HP.BID=e.BLOCK_CD 
where (HP.DCode=@Parent_ID or @Parent_ID=0) 
and (HP.BID=@Child_ID or @Child_ID=0)
and M.PHC_ID is null 
and HP.IsActive=1
and HP.Created_On<@Ldate
group by d.DIST_NAME_ENG,E.Block_Name_E,HP.Name_E
end

END

