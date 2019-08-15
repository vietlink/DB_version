/****** Object:  Procedure [dbo].[uspDeleteEmployeeComplianceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeeComplianceHistory](@historyId int, @eclId int, @isLast bit, @updatedBy varchar(100), @updatedDate datetime)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @hasDeletedRecord bit = 0;

	DECLARE @employeeId int = 0;
	DECLARE @listId int = 0;

	SELECT @employeeId = employeeid, @listid = listid FROM EmployeeComplianceHistory WHERE id = @historyId

	DECLARE @isPositionRequirement bit = 0;

	IF @isLast = 1 BEGIN
		SELECT @isPositionRequirement = ispositionrequirement FROM EmployeeCompetencyList WHERE id = @eclId;
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

	DECLARE @currentDateFrom datetime;
	DECLARE @currentDateTo datetime;
	DECLARE @currentIssueDate datetime;
	DECLARE @currentReference varchar(100);
	DECLARE @currentAdditionalInfo varchar(1000);
	DECLARE @currentScoreDecimal decimal(18,1);
	DECLARE @currentScoreAlpha varchar(15);
	DECLARE @currentScoreType int;
	DECLARE @currentScoreRange int;
	DECLARE @currentNoLongerDate datetime;
	DECLARE @currentIsMandatory datetime;
	DECLARE @currentHasCompliance bit;

	SELECT
		@currentDateFrom = datefrom,
		@currentDateTo = dateto,
		@currentIssueDate = issuedate,
		@currentReference = isnull(reference, ''),
		@currentAdditionalInfo = isnull(additionalinfo, ''),
		@currentScoreDecimal = scoredecimal,
		@currentScoreAlpha = isnull(scorealpha, ''),
		@currentScoreType = isnull(scoretype, 1),
		@currentScoreRange = ScoreRange,
		@currentNoLongerDate = NoLongerRequiredDate,
		@currentIsMandatory = IsMandatory,
		@currentHasCompliance = HasCompliance
	FROM
		EmployeeComplianceHistory
	WHERE
		id = @historyId

	IF @isPositionRequirement = 1 BEGIN
		UPDATE
			EmployeeComplianceHistory
		SET
			datefrom = null,
			dateto = null, 
			issuedate = null,
			reference = '',
			additionalinfo = '',
			updatedDate = @updatedDate,
			updatedBy = @updatedBy,
			scoredecimal = null,
			scorealpha = null,
			scoretype = null,
			NoLongerRequiredDate = null,
			hascompliance = 1,
			ismandatory = 1
		WHERE
			id = @historyId
	END
	ELSE BEGIN
		DELETE FROM
			EmployeeComplianceHistory
		WHERE
			id = @historyId;

		IF @isLast = 1 BEGIN
			DELETE FROM
				EmployeeCompetencyList
			WHERE
				id = @eclId;
			SET @hasDeletedRecord = 1;
		END
	END

	IF @hasDeletedRecord = 0 BEGIN
		-- update the iscurrent row
		DECLARE @currentHistoryId int = 0;

		SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (CAST(GETDATE() as date) BETWEEN datefrom AND dateto) ORDER BY dateto desc;
		IF @currentHistoryId = 0 BEGIN
			SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND nolongerrequireddate is not null ORDER BY nolongerrequireddate asc;
		END
		IF @currentHistoryId = 0 BEGIN
			SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (datefrom > CAST(GETDATE() as date)) ORDER BY datefrom asc;
		END
		IF @currentHistoryId = 0 BEGIN
			SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid AND (dateto < CAST(GETDATE() as date)) ORDER BY dateto desc;
		END
		IF @currentHistoryId = 0 BEGIN
			SELECT TOP 1 @currentHistoryId = isnull(id,0) FROM EmployeeComplianceHistory WHERE employeeid = @employeeid AND listid = @listid;
		END

		UPDATE
			EmployeeComplianceHistory
		SET 
			EmployeeCompetencyListID = NULL
		WHERE
			employeeid = @employeeid AND listid = @listid;

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

	-- Create the auditlog
	DECLARE @idResultTable TABLE (id int);
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Person Compliance', 'Delete';
	DECLARE @auditLogTypeIDDelete int;
	SELECT @auditLogTypeIDDelete = id FROM @idResultTable	

	DECLARE @positionid int = 0;
	DELETE FROM @idResultTable;
	INSERT INTO @idResultTable EXEC dbo.uspGetPositionIDByEmployeeId @employeeid
	SELECT @positionid = id FROM @idResultTable;

	DECLARE @auditLogID int = 0;

	INSERT INTO
		AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
			VALUES(@employeeid, @positionid, @eclId, @updatedBy, GETDATE(), @auditLogTypeIDDelete, @compDesc)
	SET @auditLogID = @@IDENTITY;

	IF @currentNoLongerDate IS NULL BEGIN
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateFrom, 103), ''), '', 'Date From');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateTo, 103), ''), '', 'Expire Date');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentIssueDate, 103), ''), '', 'Issue Date');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, CASE WHEN @currentIsMandatory = 1 THEN 'true' ELSE 'false' END, '', 'Is Required');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, CASE WHEN @currentHasCompliance = 1 THEN 'true' ELSE 'false' END, '', 'Has Compliance');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, @currentReference, '', 'Reference');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, @currentAdditionalInfo, '', 'Additional Info');
		IF @currentScoreType = 3 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, @currentScoreAlpha, '', 'Score');
		END
		ELSE BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, isnull(convert(varchar,convert(decimal(8,1),@currentScoreDecimal)), ''), '', 'Score');
		END
		IF @currentScoreType = 3 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, 'Free Text', '', 'Score Type');
		END
		IF @currentScoreType = 2 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, 'Out Of', '', 'Score Type');
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, isnull(convert(varchar,convert(int,@currentScoreRange)), ''), '', 'Score Range');
		END
		IF @currentScoreType = 1 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, 'Percent', '', 'Score Type');
		END
	END
	ELSE BEGIN
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, 'true', '', 'No Longer Required');
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentNoLongerDate, 103), ''), '', 'Date');
	END

END


