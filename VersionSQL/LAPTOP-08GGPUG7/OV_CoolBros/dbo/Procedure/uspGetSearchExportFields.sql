/****** Object:  Procedure [dbo].[uspGetSearchExportFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSearchExportFields](@SelectedColumns varchar(max),@Tables varchar(1000),@positionId int)        
AS
BEGIN
DECLARE @SQL nvarchar(max)            
DECLARE @PARAMS nvarchar(1000)        
            
SET @PARAMS ='@SelectedColumns varchar(max),@Tables varchar(max)'        
SET @SQL ='DECLARE @managerSet TABLE(IsManager int,id int); INSERT INTO	@managerSet SELECT dbo.fnIsChildOfParent(5, p.id),p.id FROM	Position p select '+@SelectedColumns + ' from '+@Tables+''    
EXECUTE sp_executesql @SQL,@PARAMS,@SelectedColumns,@Tables       
END


