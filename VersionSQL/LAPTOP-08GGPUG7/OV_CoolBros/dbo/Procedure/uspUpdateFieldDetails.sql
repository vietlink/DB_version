/****** Object:  Procedure [dbo].[uspUpdateFieldDetails]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateFieldDetails](@attributeId int, @value varchar(max), @dataId int)
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
	IF @tableName = 'Employee' OR @tableName = 'Position' BEGIN
		IF @value IS NULL BEGIN
			SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = NULL WHERE id = ' + CAST(@dataId as varchar)
		END
		ELSE
			SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = CAST(''' + @value + ''' as ' + @dataType + ') WHERE id = ' + CAST(@dataId as varchar)
	END

	IF @tableName = 'EmployeeContact' BEGIN
		IF @value IS NULL BEGIN
			SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = NULL WHERE employeeid = ' + CAST(@dataId as varchar)
		END
		ELSE
			SET @sql = 'UPDATE ' + @tableName + ' SET ' + @columnName + ' = CAST(''' + @value + ''' as ' + @dataType + ') WHERE employeeid = ' + CAST(@dataId as varchar)
	END
	EXECUTE sp_executesql @sql
	
END

