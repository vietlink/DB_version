/****** Object:  Procedure [dbo].[uspCheckDeletableValue]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckDeletableValue] 
	-- Add the parameters for the stored procedure here
	@value int , @tableName varchar(max),
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @foreignTable table (ID int, tableName varchar(max), colName varchar(max))
	INSERT INTO @foreignTable SELECT * FROM dbo.fnGetForeignTable(@tableName);
	DECLARE @row_count int = (SELECT count(*) from @foreignTable);
	SET @ReturnValue =1;
	WHILE (@row_count > 0) BEGIN
		DECLARE @table varchar(max) = (SELECT TableName FROM @foreignTable WHERE ID = @row_count);
		DECLARE @colName varchar(max) = (SELECT ColName FROM @foreignTable WHERE ID = @row_count);
		DECLARE @sqlString nvarchar(max);
		DECLARE @count int;
		SET @sqlString = 'SET @count= (SELECT COUNT(*) FROM '+@table+' WHERE '+ @colName+' = '+cast(@value as varchar)+')';	
		exec sp_executesql @sqlString, N'@count int output', @count output;
		if (@count >0) BEGIN
			SET @ReturnValue =0 --if the value is already used, cannot hard delete
			BREAK;
		END ELSE BEGIN
			SET @row_count = @row_count -1;
		END	
	END
END

