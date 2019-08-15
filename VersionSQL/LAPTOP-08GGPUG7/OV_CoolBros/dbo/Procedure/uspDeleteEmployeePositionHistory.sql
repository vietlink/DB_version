/****** Object:  Procedure [dbo].[uspDeleteEmployeePositionHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeleteEmployeePositionHistory](@id int, @currentPositionId int, @updatedby varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @auditLogTypeIDDelete int;

	DECLARE @auditLogId int = 0;
	DECLARE @idResultTable TABLE (id int);

	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Employee Position', 'Delete';
	SELECT @auditLogTypeIDDelete = id FROM @idResultTable

	--

	DECLARE @empId int = 0;
	DECLARE @posId int = 0;
	DECLARE @isCurrentPrimary varchar(1);
	SELECT @isCurrentPrimary = primaryposition, @empId = employeeid, @posId = positionid FROM EmployeePositionHistory WHERE id = @id;
	
	IF @isCurrentPrimary = 'Y' BEGIN
		DECLARE @previousItemId int = 0;
		SELECT @previousItemId = id FROM EmployeePositionHistory WHERE employeeid = @Empid AND id <> @id AND primaryposition = 'Y' ORDER BY StartDate ASC  
		IF @previousItemId IS NOT NULL AND @previousItemId > 0  
			UPDATE EmployeePositionHistory SET EndDate = NULL WHERE id = @previousItemId;
	END

	DECLARE @currentPosition varchar(250) = '';
	DECLARE @currentprimaryposition varchar(1) = '';
	DECLARE @currentstartdate DateTime;
	DECLARE @currentenddate DateTime;
	DECLARE @currentfte decimal(18,8);
	DECLARE @currentvacant varchar(1) = '';
	DECLARE @currentexclfromsubordcount varchar(1) = '';
	DECLARE @currentManagerial varchar(1) = '';
	DECLARE @currentManagerid int;

	DECLARE @newPositionTitle varchar(255);
	SELECT @newPositionTitle = title FROM Position where id = @posId
		
	IF @id > 0 BEGIN
		SELECT
			@currentPosition = p.title,
			@currentprimaryposition = h.primaryposition,
			@currentstartdate = h.startdate,
			@currentenddate = h.enddate,
			@currentfte = h.fte,
			@currentvacant = h.vacant,
			@currentexclfromsubordcount = h.exclfromsubordcount,
			@currentManagerial = h.Managerial,
			@currentManagerid = h.managerid
		FROM
			EmployeePositionHistory h
		INNER JOIN
			Position p
		ON
			h.Positionid = p.id
		WHERE
			h.id = @id
	END

	DECLARE @currentManagerName varchar(250) = '';

	IF @currentManagerid IS NOT NULL AND @currentManagerid > 0 BEGIN
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
			ep.id = @currentManagerid
	END

	INSERT INTO
		AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
			VALUES(@empId, @currentPositionid, @id, @updatedby, GETDATE(), @auditLogTypeIDDelete, '')
	SET @auditLogId = @@IDENTITY

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, @currentPosition, '', 'Position');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, @currentManagerName, '', 'Manager');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentstartdate, 103), ''), '', 'Start Date');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentenddate, 103), ''), ' ', 'End Date');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentfte is null then '' else  isnull(convert(varchar,convert(decimal(8,1),@currentFte)), '') end,  '', 'FTE');
	--INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
	--	VALUES(@auditLogID, 0, case when @currentVacant = '' then '' else case when @currentvacant = 'Y' then 'true' else 'false' end end, case when @vacant = 'Y' then 'true' else 'false' end, 'Vacant');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentManagerial = '' then '' else case when @currentManagerial = 'Y' then 'true' else 'false' end end, '', 'Managerial');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentexclfromsubordcount = '' then '' else case when @currentexclfromsubordcount = 'y' then 'false' else 'true' end end, '', 'Incl in Org Count');

	DELETE FROM EmployeePositionHistory WHERE id = @id;
END


