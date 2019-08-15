/****** Object:  Procedure [dbo].[uspSaveEmployeePositionHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveEmployeePositionHistory](@editid int, @employeeid int, @currentPositionid int, @positionid int, @startdate datetime, @enddate datetime,
	@primaryposition varchar(1), @fte decimal(18,8), @vacant varchar(1), @exclfromsubordcount varchar(1), @managerial varchar(1), @managerid int, @updatedby varchar(100))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @auditLogTypeIDNew int;
	DECLARE @auditLogTypeIDEdit int;

	DECLARE @auditLogId int = 0;
	DECLARE @idResultTable TABLE (id int);

	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Employee Position', 'New';
	SELECT @auditLogTypeIDNew = id FROM @idResultTable
	DELETE FROM @idResultTable
	INSERT INTO @idResultTable EXEC dbo.uspGetAuditLogTypeIDByDesc 'Employee Position', 'Edit';
	SELECT @auditLogTypeIDEdit = id FROM @idResultTable

	DECLARE @managerName varchar(250) = '';

	IF @managerid IS NOT NULL AND @managerid > 0 BEGIN
		SELECT
			@managerName = e.displayname + ' - (' + p.title + ')'
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
			ep.id = @managerid
	END

	-- create audit entries

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
	SELECT @newPositionTitle = title FROM Position where id = @positionid

	IF @editId > 0 BEGIN
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
			h.id = @editid
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


    IF @editId < 1 BEGIN
		INSERT INTO EmployeePositionHistory(EmployeeId, PositionID, primaryposition, startdate, enddate, fte, vacant, exclfromsubordcount, managerial, ManagerID)
			VALUES(@employeeid, @positionid, @primaryposition, @startdate, @enddate, @fte, @vacant, @exclfromsubordcount, @managerial, @managerid)
		DECLARE @newId int = @@IDENTITY;

		INSERT INTO
			AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				VALUES(@employeeid, @currentPositionid, @newId, @updatedby, GETDATE(), @auditLogTypeIDNew, '')

		SET @auditLogId = @@IDENTITY
		
	END
	ELSE BEGIN
		UPDATE
			EmployeePositionHistory
		SET
			Positionid = @positionid,
			primaryposition = @primaryposition,
			startdate = @startdate,
			enddate = @enddate,
			fte = @fte,
			vacant = @vacant,
			exclfromsubordcount = @exclfromsubordcount,
			managerial = @managerial,
			managerid = @managerid
		WHERE
			id = @editid


		INSERT INTO
			AuditLog(EmployeeID, PositionID, DataID, CreatedBy, CreatedDate, AuditLogTypeID, ItemDesc)
				VALUES(@employeeid, @currentPositionid, @editId, @updatedby, GETDATE(), @auditLogTypeIDEdit, '')

		SET @auditLogId = @@IDENTITY
	END

	IF @primaryposition = 'Y' BEGIN
		DECLARE @priorId int = 0;
		SELECT TOP 1 @priorId = ID FROM EmployeePositionHistory WHERE Employeeid = @employeeid AND primaryposition = 'Y' AND startdate < @startdate ORDER BY startdate DESC
		IF @priorId IS NOT NULL BEGIN	
		UPDATE
			EmployeePositionHistory
		SET
			enddate = DATEADD(day,-1,@startdate)
		WHERE
			id = @priorId;
		END
	END

	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, @currentPosition, @newPositionTitle, 'Position');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, @currentManagerName, @managerName, 'Manager');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentstartdate, 103), ''), isnull(convert(nvarchar(20), @startdate, 103), ''), 'Start Date');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, isnull(convert(nvarchar(20), @currentenddate, 103), ''), isnull(convert(nvarchar(20), @enddate, 103), ''), 'End Date');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentfte is null then '' else  isnull(convert(varchar,convert(decimal(8,1),@currentFte)), '') end,  isnull(convert(varchar,convert(decimal(8,1),@fte)), ''), 'FTE');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentprimaryposition = '' then '' else case when @primaryposition = 'Y' then 'true' else 'false' end end, case when @primaryposition = 'Y' then 'true' else 'false' end, 'Primary Position');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentManagerial = '' then '' else case when @currentManagerial = 'Y' then 'true' else 'false' end end, case when @managerial = 'Y' then 'true' else 'false' end, 'Managerial');
	INSERT INTO AuditLogDetails(AuditLogID, AttributeID, OldValue, newValue, [Description])
		VALUES(@auditLogID, 0, case when @currentexclfromsubordcount = '' then '' else case when @currentexclfromsubordcount = 'y' then 'false' else 'true' end end, case when @exclfromsubordcount = 'y' then 'false' else 'true' end, 'Incl in Org Count');

END


