USE [RCH_28]
GO
/****** Object:  StoredProcedure [dbo].[tp_ticker_Update]    Script Date: 09/26/2024 14:52:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--exec tp_ticker_Update 0,'07-08',0,'',''
ALTER PROCEDURE [dbo].[tp_ticker_Update]
(
@RptBlkUsr int=0,
@RptBlkUsrtime varchar(10)= NULL ,
@SchRptBlkUsr int=0,
@SchRptBlkUsrTime varchar(10)=NULL,
@Name nvarchar(500)=NULL
)
	
AS
BEGIN
	if(@RptBlkUsr<>0)
	update t_ticker set RptBlkUsr= @RptBlkUsr
	
	else if(@RptBlkUsrtime <>null OR @RptBlkUsrtime <>'')
	update t_ticker set RptBlkUsrTime=@RptBlkUsrtime
	
	else if(@SchRptBlkUsr<>0) 
	update t_ticker set SchRptBlkUsr=@SchRptBlkUsr
	
	else if(@SchRptBlkUsrTime <>null OR @SchRptBlkUsrTime<>'')
	Update t_ticker set SchRptBlkUsrTime=@SchRptBlkUsrTime 
	
	else if(@Name <>null OR @Name <>'' )
     Update t_ticker set Name= @Name
	
	
END

-- SELECT * FROM t_ticker





