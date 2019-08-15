/****** Object:  Function [dbo].[fnGetFieldDetailsByIDs]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetFieldDetailsByIDs](@attributeId int, @empPosId int, @employeeId int, @positionId int)
RETURNS varchar
AS
BEGIN
	DECLARE @tableName varchar(100);
	DECLARE @columnName varchar(100);

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

	DECLARE @sql nvarchar(1000);
	DECLARE @result varchar(max);

	IF @tableName = 'Employee' BEGIN
		SET @sql = 'SELECT @result = ' + @columnName + ' as value FROM Employee WHERE id = ' + CAST(@employeeId as varchar) 
	END
	ELSE IF @tableName = 'Position' BEGIN
		SET @sql = 'SELECT @result = ' + @columnName + ' as value FROM Position WHERE id = ' + CAST(@positionId as varchar)
	END
	ELSE IF @tableName = 'EmployeeContact' BEGIN
		SET @sql = 'SELECT @result = ' + @columnName + ' as value FROM EmployeeContact WHERE employeeid = ' + CAST(@employeeId as varchar)
	END
	ELSE IF @tableName = 'EmployeePosition' BEGIN
		SET @sql = 'SELECT @result = ' + @columnName + ' as value FROM EmployeePosition WHERE id = ' + CAST(@employeeId as varchar)
	END
	EXECUTE sp_executesql @sql
	RETURN @result;

END


