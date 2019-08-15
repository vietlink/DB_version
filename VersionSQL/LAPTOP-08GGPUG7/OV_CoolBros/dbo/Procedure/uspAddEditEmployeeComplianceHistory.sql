/****** Object:  Procedure [dbo].[uspAddEditEmployeeComplianceHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEditEmployeeComplianceHistory](@id int, @employeecompetencylistid int, @employeeid int,
	@listid int, @datefrom datetime, @dateto datetime, @reference varchar(50),
	@createddate datetime, @createdby varchar(100), @updateddate datetime, @updatedby varchar(100),
	@issueDate datetime, @additionalInfo varchar(1000), @scoreDecimal decimal(18,1), @scoreAlpha varchar(15), @scoreRange int, @scoreTypeHistory int, @isMandatory bit,
	@HasCompliance bit, @isNew bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @positionid int = 0;
	DECLARE @auditLogTypeIDNew int = 0;
	DECLARE @auditLogTypeIDEdit int = 0;
	DECLARE @auditLogID int = 0;

	DECLARE @currentDateFrom datetime;
	DECLARE @currentDateTo datetime;
	DECLARE @currentReference varchar(50);
	DECLARE @currentIssueDate datetime;
	DECLARE @currentAddInfo varchar(1000);
	DECLARE @currentScore decimal(18, 1);
	DECLARE @currentScoreAlpha varchar(50);
	DECLARE @currentIsMandatory bit;
	DECLARE @currentHasCompliance bit;
	DECLARE @idResultTable TABLE (id int);

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

	INSERT INTO @idResultTable EXEC dbo.uspGetPositionIDByEmployeeId @employeeid
	SELECT @positionid = id FROM @idResultTable;
	DELETE FROM @idResultTable
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Person Compliance', 'New';
	SELECT @auditLogTypeIDNew = id FROM @idResultTable
		DELETE FROM @idResultTable
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Person Compliance', 'Edit';
	SELECT @auditLogTypeIDEdit = id FROM @idResultTable

	-- the ECL ID passed through only comes through if its the current history, so find for auditing
	DECLARE @eclId int = 0;
	SELECT @eclId = ecl.ID FROM EmployeeCompetencyList ecl INNER JOIN CompetencyList cl ON cl.Id = ecl.CompetencyListId WHERE cl.id = @listid AND ecl.Employeeid = @employeeid

	DECLARE @scoreType int = 0;
	IF @scoreTypeHistory IS NULL BEGIN
		SELECT @scoreType = ComplianceScoreType FROM Competencies c INNER JOIN CompetencyList cl ON cl.CompetencyId = c.id WHERE cl.id = @listid
	END
	ELSE BEGIN
		SET @scoreType = @scoreTypeHistory;
	END

	DECLARE @echId int = 0;
	SELECT @echId = ID FROM EmployeeComplianceHistory WHERE id = @id
	print @echId;
    IF @echId > 0 BEGIN
		-- get the data for the audit log
		SELECT
			@currentDateFrom = datefrom,
			@currentDateTo = dateto,
			@currentReference = isnull(reference, ''),
			@currentIssueDate = issueDate,
			@currentAddInfo = isnull(additionalInfo, ''),
			@currentScore = scoredecimal,
			@currentScoreAlpha = isnull(scorealpha, ''),
			@currentIsMandatory = ismandatory,
			@currentHasCompliance = HasCompliance
		FROM
			EmployeeComplianceHistory
		WHERE
			id = @echId;

		UPDATE
			EmployeeComplianceHistory
		SET
			datefrom = @datefrom,
			dateto = @dateto, 
			reference = @reference,
			updateddate = @updateddate,
			updatedby = @updatedby,
			additionalInfo = @additionalInfo,
			scoreDecimal = @scoreDecimal,
			scoreAlpha = @scoreAlpha,
			issueDate = @issueDate,
			scorerange = @scoreRange,
			scoretype = @scoreType,
			ismandatory = @ismandatory,
			HasCompliance = @HasCompliance
		WHERE
			ID = @id;

		IF @isNew = 1 OR (@currentDateFrom IS NULL OR @currentDateTo IS NULL) BEGIN
			INSERT INTO
				AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
					VALUES(@employeeid, @positionid, @eclId, @createdBy, GETDATE(), @auditLogTypeIDNew, @compDesc)
		END
		ELSE BEGIN
		-- create the audit log
			INSERT INTO
				AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
					VALUES(@employeeid, @positionid, @eclId, @createdBy, GETDATE(), @auditLogTypeIDEdit, @compDesc)
		END
		SET @auditLogID = @@IDENTITY;

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateFrom, 103), ''), isnull(convert(nvarchar(20), @datefrom, 103), ''), 'Date From');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateTo, 103), ''), isnull(convert(nvarchar(20), @dateTo, 103), ''), 'Expire Date');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, @currentReference, @reference, 'Reference');
		
		IF @scoreType = 3 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, @currentScoreAlpha, @scoreAlpha, 'Score');
		END
		ELSE BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, isnull(convert(varchar,convert(decimal(8,1),@currentScore)), ''), isnull(convert(varchar,convert(decimal(8,1),@scoreDecimal)), ''), 'Score');
		END

		IF @isNew = 1 OR (@currentDateFrom IS NULL OR @currentDateTo IS NULL) BEGIN
			IF @scoreType = 1 BEGIN
				INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
					VALUES(@auditLogID, 0, '', 'Percent', 'Score Type');
			END

			IF @scoreType = 2 BEGIN
				INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
					VALUES(@auditLogID, 0, '', 'Out Of', 'Score Type');
			END

			IF @scoreType = 3 BEGIN
				INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
					VALUES(@auditLogID, 0, '', 'Free Text', 'Score Type');
			END
		END
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, @currentAddInfo, @additionalInfo, 'Additional Info');

		IF @isNew = 0 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, CASE WHEN @currentIsMandatory = 1 THEN 'true' ELSE 'false' END, CASE WHEN @isMandatory = 1 THEN 'true' ELSE 'false' END, 'Is Required');

			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, CASE WHEN @currentHasCompliance = 1 THEN 'true' ELSE 'false' END, CASE WHEN @HasCompliance = 1 THEN 'true' ELSE 'false' END, 'Has Compliance');
		END
		ELSE BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, '', CASE WHEN @isMandatory = 1 THEN 'true' ELSE 'false' END, 'Is Required');

			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
				VALUES(@auditLogID, 0, '', CASE WHEN @HasCompliance = 1 THEN 'true' ELSE 'false' END, 'Has Compliance');
		END
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentIssueDate, 103), ''), isnull(convert(nvarchar(20), @issueDate, 103), ''), 'Issue Date');
	END
	ELSE BEGIN
		INSERT INTO
			EmployeeComplianceHistory(employeeid, listid, datefrom, dateto, reference,
				createddate, createdby, updateddate, updatedby, employeecompetencylistid,
				additionalInfo, scoreDecimal, scoreAlpha, issueDate, scoreRange, scoreType, ismandatory, HasCompliance)
			VALUES(@employeeid, @listid, @datefrom, @dateto, @reference,
				@createddate, @createdby, @updateddate, @updatedby, NULL,
				@additionalInfo, @scoreDecimal, @scoreAlpha, @issueDate, @scoreRange, @scoreType, @ismandatory, @HasCompliance)
		SELECT @echId = @@IDENTITY;

		-- create the audit log
		INSERT INTO
			AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				VALUES(@employeeid, @positionid, @eclId, @createdBy, GETDATE(), @auditLogTypeIDNew, @compDesc)
		SET @auditLogID = @@IDENTITY;

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', isnull(convert(nvarchar(20), @datefrom, 103), ''), 'Date From');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', isnull(convert(nvarchar(20), @dateTo, 103), ''), 'Expire Date');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', @reference, 'Reference');
		
		IF @scoreType = 3 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, '', @scoreAlpha, 'Score');
		END
		ELSE BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, '', isnull(convert(varchar,convert(decimal(8,1),@scoreDecimal)), ''), 'Score');
		END

		IF @scoreType = 1 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, '', 'Percent', 'Score Type');
		END

		IF @scoreType = 2 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, '', 'Out Of', 'Score Type');
		END

		IF @scoreType = 3 BEGIN
			INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])	
				VALUES(@auditLogID, 0, '', 'Free Text', 'Score Type');
		END
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', @additionalInfo, 'Additional Info');

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', case when @isMandatory = 1 then 'true' else 'false' end, 'Is Required');

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', case when @HasCompliance = 1 then 'true' else 'false' end, 'Has Compliance');

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', isnull(convert(nvarchar(20), @issueDate, 103), ''), 'Issue Date');
	END

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


