USE [HIU_DB]
GO
/****** Object:  StoredProcedure [dbo].[sp_helptext2]    Script Date: 09/26/2024 14:19:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================                                                                                                                                                
   -- Author:  <Author,Manoj Kumar Mahto>                                                                                                                                                
   -- Create date: <Create Date,02-April-2018>                                                                                                                                                
   -- Description: <Description,Remove Extra Line in Procedure  >                                                                                            
   -- =============================================        
ALTER PROCEDURE [dbo].[sp_helptext2] (@ProcName NVARCHAR(256))  
AS  
BEGIN  
  DECLARE @PROC_TABLE TABLE (X1  NVARCHAR(MAX))  
  DECLARE @Proc NVARCHAR(MAX)  
  DECLARE @Procedure NVARCHAR(MAX)  
  DECLARE @ProcLines TABLE (PLID INT IDENTITY(1,1), Line NVARCHAR(MAX))  
  SELECT @Procedure = 'SELECT DEFINITION FROM '+db_name()+'.SYS.SQL_MODULES WHERE OBJECT_ID = OBJECT_ID('''+@ProcName+''')'  
  insert into @PROC_TABLE (X1)  
        exec  (@Procedure)  
  SELECT @Proc=X1 from @PROC_TABLE  
  WHILE CHARINDEX(CHAR(13)+CHAR(10),@Proc) > 0  
  BEGIN  
        INSERT @ProcLines  
        SELECT LEFT(@Proc,CHARINDEX(CHAR(13)+CHAR(10),@Proc)-1)  
        SELECT @Proc = SUBSTRING(@Proc,CHARINDEX(CHAR(13)+CHAR(10),@Proc)+2,LEN(@Proc))  
  END  
 --* inserts last line  
 insert @ProcLines   
 select @Proc ;  
 --edited here. (where Line<>'')  
 SELECT Line FROM @ProcLines where Line<>'' ORDER BY PLID  
END
