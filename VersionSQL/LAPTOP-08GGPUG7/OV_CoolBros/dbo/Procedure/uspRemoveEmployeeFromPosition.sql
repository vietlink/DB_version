/****** Object:  Procedure [dbo].[uspRemoveEmployeeFromPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveEmployeeFromPosition](@posId int, @empId int, @updatedby varchar(100) = '')
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	EXEC dbo.uspRemovePositionRequirementsForEmployee @empId, @posId, ''

	DECLARE @childCount int = 0;
	SELECT @childCount = dbo.uspCheckHasChildren((SELECT TOP 1 ISNULL(id, 0) FROM EmployeePosition WHERE positionid = @posId AND employeeid = @empId))

    DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM employee WHERE identifier = 'Vacant';
	DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1
	DECLARE @oldEmpPosId int = 0;
	DECLARE @newEmpPosId int = 0;
	print @posId;
	DECLARE @empCount int = (SELECT COUNT(id) FROM EmployeePosition WHERE positionid = @posId AND IsDeleted = 0)

	SELECT @oldEmpPosId = id FROM EmployeePosition WHERE positionid = @posId and employeeid = @empId;
	UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid = @posId and employeeid = @empId;
	UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE positionid = @posId and employeeid = @empId;
	PRINT @empCount;
	DECLARE @ThisEmpPosCount int = 0;
	SELECT @ThisEmpPosCount = COUNT(id) FROM EmployeePosition WHERE IsDeleted = 0 AND Employeeid = @empId;
	IF(@ThisEmpPosCount = 0) BEGIN
		DECLARE @unassignedEmpPosId int = 0;
		SELECT @unassignedEmpPosId = id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @unassignedId;
		IF(@unassignedEmpPosId > 0) BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE id = @unassignedEmpPosId
		END
		ELSE BEGIN
			INSERT INTO EmployeePosition(positionid, employeeid, fte, managerial, primaryposition, ExclFromSubordCount)
				VALUES(@unassignedId, @empId, 1, 'N', 'N', 'N')
			SET @unassignedEmpPosId = @@IDENTITY;
			INSERT INTO
			EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@unassignedEmpPosId, @empId, @unassignedId, 0, '', 0, '', '', '', '', '', '', 1, 0, 0, 0, '', 0)
		END

		EXEC uspRunUpdatePreference @unassignedEmpPosId, @empId, @unassignedId;
	END

	DECLARE @posCount int = 0;

	SELECT @posCount = COUNT(*)
	FROM EmployeePosition ep
	INNER JOIN Employee e
	ON e.id = ep.employeeid
	INNER JOIN
	[status] s ON s.[Description] = e.[status]
	WHERE ep.Positionid = @posId AND s.IsVisibleChart = 1 AND e.IsDeleted = 0 AND ep.IsDeleted = 0 and e.id <> @vacantId
	
	IF(@posCount = 0 /*AND @childCount > 0*/) BEGIN
		SELECT @newEmpPosId = id FROM EmployeePosition WHERE positionid = @posId and employeeid = @vacantId;
		IF(@newEmpPosId <> 0) BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE positionid = @posId and employeeid = @vacantId;
			IF EXISTS (SELECT ID FROM EmployeePositionInfo WHERE positionid = @posId and employeeid = @vacantId) BEGIN
				UPDATE EmployeePositionInfo SET IsVisible = 1  WHERE positionid = @posId and employeeid = @vacantId;
			END
			ELSE BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@newEmpPosId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 0, 0, 0, '', 0)
			END
		END
		ELSE BEGIN
			INSERT INTO EmployeePosition(positionid, employeeid, fte, managerial, primaryposition, ExclFromSubordCount)
				VALUES(@posId, @vacantId, 1, 'N', 'N', 'N')
			SET @newEmpPosId = @@IDENTITY; 
			INSERT INTO
			EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@newEmpPosId, @vacantId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 0, 0, 0, '', 0)
		END
	END
	DECLARE @totalPosCount int = 0;
	SELECT @totalPosCount = COUNT(*) FROM EmployeePosition WHERE positionid = @posId AND IsDeleted = 0;
	IF @totalPosCount = 0 BEGIN
		UPDATE Position SET parentid = @unassignedId WHERE id = @posId;
	END
	EXEC uspRunUpdatePreference @oldEmpPosId, @empId, @posId;
	IF(@newEmpPosId > 0) BEGIN
		EXEC uspRunUpdatePreference @newEmpPosId, @vacantId, @posId;
	END

	DECLARE @historyId int = 0;
	SELECT @historyId = id FROM EmployeePositionHistory WHERE employeeid = @empId AND positionid = @posId;
	IF @historyId > 0 BEGIN
		EXEC dbo.uspDeleteEmployeePositionHistory @historyId, @posId, @updatedby
	END

END

