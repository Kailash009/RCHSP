USE [RCH_24]
GO
/****** Object:  StoredProcedure [dbo].[tp_Get_Mother_HBsAG_Status]    Script Date: 09/26/2024 15:54:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  /*
	EXEC tp_Get_Mother_HBsAG_Status 129020417502,2,'Y'
*/
ALTER proc [dbo].[tp_Get_Mother_HBsAG_Status]        
(    
@Registration_no bigint,        
@Case_no int,
@IsOldCase as char(1)='N'        
)        
AS        
BEGIN     
SET NOCOUNT ON  
   DECLARE @IsPreviousHBSAGExist AS BIT=0  
   declare @data varchar(max)
   If(@Case_no>1)  
    BEGIN  
      Declare @PrevCaseNo as int  
      SET @PrevCaseNo=(@Case_no-1)  
         IF EXISTS(SELECT HBSAG_Test FROM t_mother_medical (nolock) WHERE Registration_no=@Registration_no and Case_no=@PrevCaseNo  AND HBSAG_Test=1 AND HBSAG_Result='P')          
            BEGIN          
              SET @IsPreviousHBSAGExist=1  
            END  
     END 
     
     set @data= 'SELECT m.LMP_Date,m.HBSAG_Test,m.HBSAG_Date, m.HBSAG_Result, '+convert(varchar,@IsPreviousHBSAGExist)+' AS IsPreviousHBSAGExist, pt.Page_Code 
		FROM t_mother_medical m(nolock) INNER JOIN t_page_tracking pt(nolock) on m.Registration_no=pt.Registration_no and m.Case_no=pt.Case_no
		where  m.Registration_no='+convert(varchar,@Registration_no)+' and m.Case_no='+ convert(varchar,@Case_no)+''
		
     if(@IsOldCase='N') 
     BEGIN
		set @data= @data + ' and pt.Is_Previous_Current=1'
	END
	ELSE if(@IsOldCase='Y')
	BEGIN
		set @data= @data + ' and pt.Is_Previous_Current=0'
	END
	 exec(@data)
END 



