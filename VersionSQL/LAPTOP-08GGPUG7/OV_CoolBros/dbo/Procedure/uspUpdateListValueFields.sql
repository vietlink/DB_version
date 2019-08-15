/****** Object:  Procedure [dbo].[uspUpdateListValueFields]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateListValueFields](@attributeId int, @oldValue varchar(max), @newValue varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @tableName varchar(100);
	DECLARE @columnName varchar(100);
	DECLARE @dataType varchar(50);
	SELECT
		@columnName = columnname, 
		@tableName = tablename
	FROM
		Attribute a
	INNER JOIN
		Entity e
	ON
		e.id = a.entityid
	WHERE
		a.id = @attributeId
	
	select @dataType = DATA_TYPE from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = @tableName and COLUMN_NAME = @columnName
	IF @dataType = 'varchar' BEGIN
		SET @dataType = 'varchar(max)';
	END
	IF @dataType = 'decimal' BEGIN
		SET @dataType = 'decimal(18,8)';
	END
	DECLARE @sql nvarchar(max);
	IF @newValue IS NULL BEGIN
		SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = NULL WHERE ' + @columnName + ' = ' + '''' + @oldValue + ''''
	END
	ELSE
		SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = CAST(''' + @newValue + ''' as ' + @dataType + ') WHERE ' + @columnName + ' = ' + '''' + @oldValue + ''''

	EXECUTE sp_executesql @sql
END


