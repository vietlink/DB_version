/****** Object:  Procedure [dbo].[uspSetComplianceNoLongerRequired]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetComplianceNoLongerRequired](@historyId int, @empId int, @listid int, @dateFrom datetime, @updatedBy varchar(255), @updatedDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @isPosRequirement bit = 0;
	SELECT TOP 1 @isPosRequirement = IsPositionRequirement FROM EmployeeCompetencyList WHERE Employeeid = @empId AND CompetencyListId = @listid;

	IF @historyId = 0 BEGIN
		INSERT INTO EmployeeComplianceHistory(EmployeeID, ListID, CreatedDate, CreatedBy, UpdatedDate, UpdatedBy,
			IsMandatory, IsPositionMandatory, IsPositionRequirement, HasCompliance, NoLongerRequiredDate)
		VALUES(@empId, @listId, @updatedDate, @updatedBy, @updatedDate, @updatedBy, 0, @isPosRequirement, @isPosRequirement,
			0, @dateFrom)
	END ELSE BEGIN
		UPDATE
			EmployeeComplianceHistory
		SET
			HasCompliance = 0,
			NoLongerRequiredDate = @dateFrom,
			IsMandatory = 0
		WHERE
			ID = @historyId
	END

	DECLARE @compDesc varchar(255);
	SELECT
		@compDesc = c.[description]
	FROM
		CompetencyList cl
	INNER JOIN
		Competencies c
	ON
		cl.CompetencyId = c.id
	WHERE
		cl.id = @listid;

	DECLARE @eclId int = 0;
	SELECT @eclId = ecl.ID FROM EmployeeCompetencyList ecl INNER JOIN CompetencyList cl ON cl.Id = ecl.CompetencyListId WHERE cl.id = @listid AND ecl.Employeeid = @empId

	DECLARE @auditLogTypeIDEdit int;
	DECLARE @positionid int;

	DECLARE @idResultTable TABLE (id int);
	INSERT INTO @idResultTable EXEC dbo.uspGetPositionIDByEmployeeId @empId
	SELECT @positionid = id FROM @idResultTable;
	DELETE FROM @idResultTable
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Person Compliance', 'New';
	SELECT @auditLogTypeIDEdit = id FROM @idResultTable

	INSERT INTO
		AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
			VALUES(@empId, @positionid, @eclId, @updatedBy, GETDATE(), @auditLogTypeIDEdit, @compDesc)
	DECLARE @auditLogID int;
	SET @auditLogID = @@IDENTITY;

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, '', 'true', 'No longer required');

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, '', convert(varchar, @dateFrom, 103), 'Date');

	DELETE FROM EmployeeComplianceHistory WHERE
		employeeid = @empId AND listid = @listid AND datefrom is null AND dateto is null and NoLongerRequiredDate is null

	-- update the current history item

	DECLARE @currentHistoryId int = 0;

	SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @empId AND listid = @listid AND (CAST(GETDATE() as date) BETWEEN datefrom AND dateto) ORDER BY dateto desc;
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @empId AND listid = @listid AND nolongerrequireddate is not null ORDER BY nolongerrequireddate asc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @empId AND listid = @listid AND (datefrom > CAST(GETDATE() as date)) ORDER BY datefrom asc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @empId AND listid = @listid AND (dateto < CAST(GETDATE() as date)) ORDER BY dateto desc;
	END
	IF @currentHistoryId = 0 BEGIN
		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @empId AND listid = @listid;
	END

	UPDATE
		EmployeeComplianceHistory
	SET 
		EmployeeCompetencyListID = NULL
	WHERE
		employeeid = @empId AND listid = @listid;

	UPDATE EmployeeComplianceHistory SET EmployeeCompetencyListID = @eclId WHERE id = @currentHistoryId;

	-- get the details of the current history to update the main ecl
	DECLARE @newDateFrom datetime;
	DECLARE @newDateTo datetime;
	DECLARE @newRef varchar(50);
	DECLARE @newIsMandatory bit;
	DECLARE @newHasCompliance bit;
	DECLARE @newNoLongerRequiredDate datetime;

	SELECT @newDateFrom = datefrom, @newDateTo = dateto, @newRef = reference, @newIsMandatory = ismandatory, @newHasCompliance = hasCompliance, @newNoLongerRequiredDate = nolongerrequireddate FROM EmployeeComplianceHistory WHERE id = @currentHistoryId

	-- Update the current record if specified
	IF @eclId > 0 BEGIN
		UPDATE
			EmployeeCompetencyList
		SET
			DateFrom = @newDateFrom,
			DateTo = @newDateTo,
			Reference = @newRef,
			IsMandatory = @newIsMandatory,
			HasCompliance = @newHasCompliance,
			NoLongerRequiredDate = @newNoLongerRequiredDate
		WHERE
			id = @eclId
	END
END


