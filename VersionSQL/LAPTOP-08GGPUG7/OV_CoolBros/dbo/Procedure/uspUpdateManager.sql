/****** Object:  Procedure [dbo].[uspUpdateManager]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateManager](@epHistoryId int, @newManagerId int, @updatedBy varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @startDate datetime;
	DECLARE @endDate datetime;
	DECLARE @positionId int;
	DECLARE @employeeId int;
	DECLARE @currentManagerId int;

	SELECT @currentManagerId = managerId, @startDate = startdate, @enddate = enddate, @employeeId = employeeid, @positionid = positionid FROM EmployeePositionHistory WHERE id = @epHistoryId
	UPDATE EmployeePosition SET ManagerID = @newManagerId WHERE StartDate = @startDate AND isnull(EndDate, '2000-01-01') = isnull(@endDate, '2000-01-01') AND PositionID = @positionid AND Employeeid = @employeeid
    UPDATE EmployeePositionHistory SET ManagerID = @newManagerId WHERE id = @epHistoryId;

	DECLARE @currentManagerName varchar(250) = '';

	IF @currentManagerId IS NOT NULL AND @currentManagerId > 0 BEGIN
		SELECT
			@currentManagerName = e.displayname + ' - (' + p.title + ')'
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		INNER JOIN
			Position p
		ON
			p.id = ep.positionid
		WHERE
			ep.id = @currentManagerId
	END

	DECLARE @newManagerName varchar(250) = '';

	IF @newManagerId IS NOT NULL AND @newManagerId > 0 BEGIN
		SELECT
			@newManagerName = e.displayname + ' - (' + p.title + ')'
		FROM
			EmployeePosition ep
		INNER JOIN
			Employee e
		ON
			e.id = ep.employeeid
		INNER JOIN
			Position p
		ON
			p.id = ep.positionid
		WHERE
			ep.id = @newManagerId
	END

	DECLARE @idResultTable TABLE (id int);
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Employee Position', 'Edit';
	DECLARE @auditLogTypeIDEdit int;
	SELECT @auditLogTypeIDEdit = id FROM @idResultTable

	DECLARE @auditLogId int;

	INSERT INTO
		AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
			VALUES(@employeeid, @positionId, @epHistoryId, @updatedby, GETDATE(), @auditLogTypeIDEdit, '')
	SET @auditLogId = @@IDENTITY;

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, @currentManagerName, @newManagerName, 'Manager');
END


