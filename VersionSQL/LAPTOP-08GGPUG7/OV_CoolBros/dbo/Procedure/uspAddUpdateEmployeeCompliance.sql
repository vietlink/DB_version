/****** Object:  Procedure [dbo].[uspAddUpdateEmployeeCompliance]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddUpdateEmployeeCompliance](@employeeid int, @listid int, @datefrom datetime, @dateto datetime, @reference varchar(50), @createdDate datetime, @createdBy varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @positionid int = 0;
	DECLARE @auditLogTypeID int = 0;
	DECLARE @auditLogID int = 0;

	DECLARE @currentDateFrom datetime;
	DECLARE @currentDateTo datetime;
	DECLARE @currentReference varchar(50);

	DECLARE @idResultTable TABLE (id int);

	DECLARE @retHistoryID int = 0;


	INSERT INTO @idResultTable EXEC dbo.uspGetPositionIDByEmployeeId @employeeid
	SELECT @positionid = id FROM @idResultTable;
	DELETE FROM @idResultTable
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Person Compliance', 'New';
	SELECT @auditLogTypeID = id FROM @idResultTable

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
	SELECT @eclId = ID FROM EmployeeCompetencyList WHERE Employeeid = @employeeid AND CompetencyListId = @listid
    IF @eclId > 0 BEGIN
		-- Get the details for audit
		SELECT
			@currentDateFrom = datefrom,
			@currentDateTo = dateto,
			@currentReference = isnull(reference, '')
		FROM
			EmployeeCompetencyList
		WHERE
			id = @eclid;

		-- Update existing
		UPDATE
			EmployeeCompetencyList
		SET
			datefrom = @datefrom,
			dateto = @dateto,
			reference = @reference
		WHERE
			id = @eclId

		-- Update the history
		UPDATE
			EmployeeComplianceHistory
		SET
			datefrom = @datefrom,
			dateto = @dateto,
			reference = @reference
		WHERE
			EmployeeCompetencyListID = @eclId;
		
		-- create the audit log
		INSERT INTO
			AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				VALUES(@employeeid, @positionid, @eclId, @createdBy, GETDATE(), @auditLogTypeID, @compDesc)
		SET @auditLogID = @@IDENTITY;

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateFrom, 103), ''), isnull(convert(nvarchar(20), @datefrom, 103),''), 'Date From') ;
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentDateTo, 103), ''), isnull(convert(nvarchar(20), @dateTo, 103),''), 'Expire Date') ;
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, @currentReference, @reference, 'Reference');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', '', 'Score');
		
		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', '', 'Additional Info');

		INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
			VALUES(@auditLogID, 0, '', '', 'Issue Date');
			
	END
	ELSE BEGIN
		INSERT INTO EmployeeCompetencyList(employeeid, CompetencyListId, datefrom, dateto, reference)
			VALUES(@employeeid, @listid, @datefrom, @dateto, @reference);
		
		SELECT @eclId = @@IDENTITY;

		INSERT INTO EmployeeComplianceHistory(employeeid, listid, datefrom, dateto, reference, createdby, createddate, updatedby, updateddate, EmployeeCompetencyListID)
			VALUES(@employeeid, @listid, null, null, null, @createdBy, @createdDate, @createdBy, @createdDate, @eclId);
		SELECT @retHistoryID = @@IDENTITY;

		--INSERT INTO
		--	AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
		--		VALUES(@employeeid, @positionid, @eclId, @createdBy, GETDATE(), @auditLogTypeID, @compDesc)
		--SET @auditLogID = @@IDENTITY;

		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', isnull(convert(nvarchar(20), @datefrom, 103), ''), 'Date From');
		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', isnull(convert(nvarchar(20), @dateto, 103), ''), 'Expire Date');
		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', @reference, 'Reference');
		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', '', 'Score');
		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', '', 'Additional Info');
		--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		--	VALUES(@auditLogID, 0, '', '', 'Issue Date');
	END

	RETURN @retHistoryID;
END


