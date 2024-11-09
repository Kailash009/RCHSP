  
  
  
  
-- =============================================  
  
-- =============================================  
CREATE proc [dbo].[tp_InsertException]  
@PageDetail [varchar](100) ,  
@ExceptionMsg [varchar](max) ,  
@CustomError [varchar](max) ,  
@FunctionName [varchar](200) ,  
@UserID [int] ,  
@StateID [int] ,  
@ErrorTime [datetime]   
as  
  
 begin  
   
    insert into ExceptionTable(  
    [PageDetail] ,  
 [ExceptionMsg],  
 [CustomError],  
 [FunctionName] ,  
 [UserID] ,  
 [StateID] ,  
 [ErrorTime]   
 )  
 values(  
 @PageDetail ,  
 @ExceptionMsg ,  
 @CustomError ,  
 @FunctionName ,  
 @UserID,  
 @StateID ,  
 @ErrorTime   
 )  
   
 end  
  
  
  
  