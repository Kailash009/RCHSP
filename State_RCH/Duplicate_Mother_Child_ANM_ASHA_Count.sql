USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[Duplicate_Mother_Child_ANM_ASHA_Count]    Script Date: 09/26/2024 15:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
              
--[dbo].[Duplicate_Mother_Child_ANM_ASHA_Count]              
/*                
	[Duplicate_Mother_Child_ANM_ASHA_Count] 0,0,0,0,0                
	[Duplicate_Mother_Child_ANM_ASHA_Count] 2,0,0,0,0                
	[Duplicate_Mother_Child_ANM_ASHA_Count] 1,1,0,0,0                
	[Duplicate_Mother_Child_ANM_ASHA_Count] 1,1,1,0,0                
	[Duplicate_Mother_Child_ANM_ASHA_Count] 1,1,1,3,0                
               
*/                
ALTER procedure [dbo].[Duplicate_Mother_Child_ANM_ASHA_Count]                
(@District_Code as int=0,                
 @HealthBlock_Code as int=0,                
 @HealthFacility_Code as int=0,                
 @HealthSubFacility_Code as int=0,                
 @Village_Code as int=0,                
 @TypeID int=0                
 )                
                 
as                  
begin                
declare @Duplicate_Child int =100, @Duplicate_ANM_ASHA int =100,@Deleted_Child int =100, @Deleted_ANM_ASHA int =100                
IF(@District_Code=0)              
begin              
             
--select Duplicate_Mohter,@Duplicate_Child  as Duplicate_Child, @Duplicate_ANM_ASHA as Duplicate_ANM_ASHA ,isnull(Deleted_Mother,0) Deleted_Mother, @Deleted_Child as Deleted_Child , @Deleted_ANM_ASHA as Deleted_ANM_ASHA from              
--( select COUNT( distinct dup_rank_withoutAddr) Duplicate_Mohter , State_Code from t_mother_registration (nolock) where dup_case_withoutAddr=1 group by State_Code              
--) A              
--left outer join              
--(                
--select COUNT(1) as Deleted_Mother,State_Code from t_mother_registration (nolock) where Delete_Mother=1 and dup_case_withoutAddr=-1 group by State_Code              
--)B on A.State_Code=B.State_Code            
            
--dup_rank_withoutAddr          
--dup_case_withoutAddr          
           
           
           
            
select Duplicate_Mohter,Duplicate_Mother_set,isnull(Deleted_Mother,0) as Deleted_Mother,Deleted_SubSequent_Mother,Duplicate_child,Duplicate_Child_set,            
isnull(Deleted_Child,0) as Deleted_Child,isnull(Mother_Deleted_Child,0) as Mother_Deleted_Child,100 as Duplicate_ANM_ASHA,100 as Deleted_ANM_ASHA,permanent_delete_Mother,permanent_delete_SubSequent_Mother,permanent_delete_child,permanent_Mother_delete_child from              
           
  
(select sum(Dup_count) Duplicate_Mohter,COUNT(Dup_count) Duplicate_Mother_set from (  
select COUNT(dup_rank_withoutAddr) Dup_count  from t_mother_registration (nolock) where  
   not(isnull(Delete_Mother,0)=1 and isnull(Dup_Mother_Delete,0)=0)  group by dup_rank_withoutAddr  
 having COUNT(dup_rank_withoutAddr)>=2 ) a)a,  
  
 (select --COUNT( dup_rank_withoutAddr) Duplicate_Mohter,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Mother_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Mother_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Mother,            
COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 and Case_no=1 then 1 end ) as Deleted_Mother ,  
COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 and Case_no>1 then 1 end ) as Deleted_SubSequent_Mother ,      
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and Case_no>1 then 1 end ) as Deleted_SubSequent_Mother,        
Count (case when permanent_delete=1 and Case_no=1 then 1 end) as permanent_delete_Mother,        
COUNT( case when permanent_delete=1 and Case_no>1 then 1 end ) as permanent_delete_SubSequent_Mother, State_Code from t_mother_registration (nolock)              
group by State_Code)t,        
  
(select sum(Dup_count) Duplicate_child,COUNT(Dup_count) Duplicate_Child_set from (  
select COUNT(dup_rank_withoutAddr) Dup_count  from t_children_registration (nolock) where dup_case_withoutAddr is not null  and  
   not(isnull(Delete_Mother,0)=1 and isnull(Dup_child_Delete,0)=0)  group by dup_rank_withoutAddr  
 having COUNT(dup_rank_withoutAddr)>=2 ) a)tmp1,  
  
  
(select --COUNT( dup_rank_withoutAddr) Duplicate_child,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Child_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Child,            
COUNT( case when isnull(Delete_Mother,0)=1 and isnull(dup_case_withoutAddr,0)=-1 and isnull(Dup_Child_Delete,0)=1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Child        
,COUNT( case when isnull(Delete_Mother,0)=1 and isnull(dup_case_withoutAddr,0)=-1 and isnull(Dup_Child_Delete,0)=0 and isnull(permanent_delete,0)=0 then 1 end ) as Mother_Deleted_Child        
,Count (case when isnull(Delete_Mother,0)=1 and isnull(permanent_delete,0)=1 and isnull(Dup_Child_Delete,0)=1 and isnull(dup_case_withoutAddr,0)=-1 then 1 end) as permanent_delete_child,        
Count (case when isnull(Delete_Mother,0)=1 and  isnull(permanent_delete,0)=1 and isnull(dup_case_withoutAddr,0)=-1 and isnull(Dup_Child_Delete,0)=0 then 1 end) as permanent_Mother_delete_child, State_Code        
       
from t_children_registration (nolock)  where        
 dup_case_withoutAddr is not null            
group by State_Code)tmp           
end              
ELSE IF(@District_Code<>0 and @HealthBlock_Code=0)              
begin              
             
select Duplicate_Mohter,Duplicate_Mother_set,isnull(Deleted_Mother,0) as Deleted_Mother,Deleted_SubSequent_Mother,Duplicate_child,Duplicate_Child_set,            
isnull(Deleted_Child,0) as Deleted_Child,isnull(Mother_Deleted_Child,0) as Mother_Deleted_Child,100 as Duplicate_ANM_ASHA,100 as Deleted_ANM_ASHA,permanent_delete_Mother,permanent_delete_SubSequent_Mother,permanent_delete_child,permanent_Mother_delete_child from              
            
(select sum(Dup_count) Duplicate_Mohter,COUNT(Dup_count) Duplicate_Mother_set from (  
select COUNT(dup_rank_withoutAddr) Dup_count  from t_mother_registration (nolock) where  
   not(isnull(Delete_Mother,0)=1 and isnull(Dup_Mother_Delete,0)=0) and District_Code=@District_Code  group by dup_rank_withoutAddr  
 having COUNT(dup_rank_withoutAddr)>=2 ) a)a,  
  
 (select --COUNT( dup_rank_withoutAddr) Duplicate_Mohter,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Mother_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Mother_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Mother,            
COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 and Case_no=1 then 1 end ) as Deleted_Mother ,  
COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 and Case_no>1 then 1 end ) as Deleted_SubSequent_Mother ,      
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and Case_no>1 then 1 end ) as Deleted_SubSequent_Mother,        
Count (case when permanent_delete=1 and Case_no=1 then 1 end) as permanent_delete_Mother,        
COUNT( case when permanent_delete=1 and Case_no>1 then 1 end ) as permanent_delete_SubSequent_Mother, District_Code from t_mother_registration (nolock)
where  District_Code=@District_Code              
group by District_Code)t,        
  
(select sum(Dup_count) Duplicate_child,COUNT(Dup_count) Duplicate_Child_set from (  
select COUNT(dup_rank_withoutAddr) Dup_count  from t_children_registration (nolock) where dup_case_withoutAddr is not null  and  
   not(isnull(Delete_Mother,0)=1 and isnull(Dup_child_Delete,0)=0) and District_Code=@District_Code  group by dup_rank_withoutAddr  
 having COUNT(dup_rank_withoutAddr)>=2 ) a)tmp1,  
  
  
(select --COUNT( dup_rank_withoutAddr) Duplicate_child,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Child_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Child,            
COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Child        
,COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0 and isnull(permanent_delete,0)=0 then 1 end ) as Mother_Deleted_Child        
,Count (case when Delete_Mother=1 and permanent_delete=1 and isnull(Dup_Child_Delete,0)=1 and dup_case_withoutAddr=-1 then 1 end) as permanent_delete_child,        
Count (case when Delete_Mother=1 and  permanent_delete=1 and dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0 then 1 end) as permanent_Mother_delete_child, District_Code        
       
from t_children_registration (nolock)  where        
 dup_case_withoutAddr is not null   and District_Code=@District_Code         
group by District_Code)tmp             
end              
             
--ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code=0)              
--begin              
             
--select Duplicate_Mohter,Duplicate_Mother_set,Remaining_Duplicate_Mother,isnull(Deleted_Mother,0) as Deleted_Mother,Duplicate_child,Duplicate_Child_set,Remaining_Duplicate_Child,            
--isnull(Deleted_Child,0) as Deleted_Child,100 as Duplicate_ANM_ASHA,100 as Deleted_ANM_ASHA,permanent_delete_Mother,permanent_delete_child from              
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_Mohter,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Mother_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Mother_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Mother,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Mother ,Count (case when permanent_delete=1 then 1 end) as permanent_delete_Mother, HealthBlock_Code from t_mother_registration (nolock)   
    
      
        
             
--group by HealthBlock_Code)t,            
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_child,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Child_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Child,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Child , Count (case when permanent_delete=1 then 1 end) as permanent_delete_child,HealthBlock_Code from t_children_registration (nolock)   
    
      
        
-- where dup_case_withoutAddr is not null and dup_rank_withoutAddr is not null            
--group by HealthBlock_Code)tmp              
--end              
--ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code<>0 and @HealthSubFacility_Code=0)              
--begin              
             
--select Duplicate_Mohter,Duplicate_Mother_set,Remaining_Duplicate_Mother,isnull(Deleted_Mother,0) as Deleted_Mother,Duplicate_child,Duplicate_Child_set,Remaining_Duplicate_Child,            
--isnull(Deleted_Child,0) as Deleted_Child,100 as Duplicate_ANM_ASHA,100 as Deleted_ANM_ASHA,permanent_delete_Mother,permanent_delete_child from              
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_Mohter,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Mother_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Mother_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Mother,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Mother ,Count (case when permanent_delete=1 then 1 end) as permanent_delete_Mother, HealthFacility_Code from t_mother_registration (nolock)              
--group by HealthFacility_Code)t,            
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_child,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Child_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Child,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Child , Count (case when permanent_delete=1 then 1 end) as permanent_delete_child,HealthFacility_Code from t_children_registration (nolock)  where dup_case_withoutAddr is not null and dup_rank_withoutAddr is not null            
--group by HealthFacility_Code)tmp              
--end              
             
--ELSE IF(@District_Code<>0 and @HealthBlock_Code<>0 and @HealthFacility_Code<>0 and @HealthSubFacility_Code<>0 and @Village_Code=0)              
--begin              
             
--select Duplicate_Mohter,Duplicate_Mother_set,Remaining_Duplicate_Mother,isnull(Deleted_Mother,0) as Deleted_Mother,Duplicate_child,Duplicate_Child_set,Remaining_Duplicate_Child,            
--isnull(Deleted_Child,0) as Deleted_Child,100 as Duplicate_ANM_ASHA,100 as Deleted_ANM_ASHA,permanent_delete_Mother,permanent_delete_child from              
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_Mohter,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Mother_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Mother_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Mother,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Mother ,Count (case when permanent_delete=1 then 1 end) as permanent_delete_Mother, HealthSubFacility_Code from t_mother_registration (nolock)              
--group by HealthSubFacility_Code)t,            
            
--(select COUNT( dup_rank_withoutAddr) Duplicate_child,COUNT(  distinct dup_rank_withoutAddr) Duplicate_Child_set,COUNT( case when dup_case_withoutAddr=1 or (dup_case_withoutAddr=-1 and isnull(Dup_Child_Delete,0)=0) then dup_rank_withoutAddr end) Remaining_Duplicate_Child,            
--COUNT( case when Delete_Mother=1 and dup_case_withoutAddr=-1 and isnull(permanent_delete,0)=0 then 1 end ) as Deleted_Child ,Count (case when permanent_delete=1 then 1 end) as permanent_delete_child, HealthSubFacility_Code from t_children_registration (nolock)  where dup_case_withoutAddr is not null and dup_rank_withoutAddr is not null            
--group by HealthSubFacility_Code)tmp              
--end                  
end
