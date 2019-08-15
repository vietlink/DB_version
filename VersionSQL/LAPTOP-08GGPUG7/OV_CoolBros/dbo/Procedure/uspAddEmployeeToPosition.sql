/****** Object:  Procedure [dbo].[uspAddEmployeeToPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEmployeeToPosition](@posId int, @empId int, @fte decimal(18,8) = null, @primary varchar(1), @manager varchar(1), @exclCount varchar(1), @startDate datetime, @updatedBy varchar(255))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @newEmpPosId int = 0;

	DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1;

	DECLARE @unassignedEmpPosId int = 0;
	SELECT @unassignedEmpPosId = id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @unassignedId;

	IF(@unassignedEmpPosId > 0) BEGIN
		UPDATE EmployeePosition SET IsDeleted = 1 WHERE id = @unassignedEmpPosId
		UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE id = @unassignedEmpPosId
		EXEC uspRunUpdatePreference @unassignedEmpPosId, @empId, @unassignedId;
	END

	DECLARE @currentPrimaryCount int = 0;
	SELECT @currentPrimaryCount = COUNT(id) FROM EmployeePosition
		WHERE EmployeeID = @empId AND primaryposition = 'Y' AND IsDeleted = 0 AND positionid <> @posId;

	IF @primary = 'Y' AND @currentPrimaryCount >= 1 BEGIN
		UPDATE EmployeePosition SET primaryposition = 'N' WHERE EmployeeID = @empId;
	END

	IF @currentPrimaryCount < 1 BEGIN
		SET @primary = 'Y';
	END

    IF EXISTS(SELECT id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @posId) BEGIN
		UPDATE
			EmployeePosition
		SET
			IsDeleted = 0,
			Managerial = @manager,
			primaryposition = @primary,
			ExclFromSubordCount = @exclCount,
			fte = @fte
		WHERE
			positionid = @posId AND employeeid = @empId

		SELECT @newEmpPosId = id FROM EmployeePosition WHERE employeeid = @empId AND positionid = @posId
		EXEC dbo.uspCreatePositionRequirementsForEmployee @empId, @posId, ''
	END

	ELSE BEGIN
		INSERT INTO EmployeePosition(positionid, employeeid, fte, managerial, primaryposition, ExclFromSubordCount)
			VALUES(@posId, @empId, @fte, @manager, @primary, @exclCount)
		SET @newEmpPosId = @@IDENTITY; 
		EXEC dbo.uspCreatePositionRequirementsForEmployee @empId, @posId, ''
	END
	IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE employeeid = @empId AND positionid = @posId) BEGIN
	INSERT INTO
		EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
		customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
			VALUES(@newEmpPosId, @empId, @posId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
	END
	EXEC uspRunUpdatePreference @newEmpPosId, @empId, @posId;

	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM employee WHERE identifier = 'Vacant';
	SELECT @newEmpPosId = id FROM EmployeePosition WHERE positionid = @posId AND employeeId = @vacantId AND IsDeleted = 0;
	IF @empId <> @vacantId BEGIN
		UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid = @posId AND employeeid = @vacantId;
		UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE positionid = @posId AND employeeid = @vacantId;
	END
	EXEC uspRunUpdatePreference @newEmpPosId, @vacantId, @posId;

	EXEC dbo.uspSaveEmployeePositionHistory 0, @empId, 0, @posId, @startDate, NULL, @primary, @fte, '', @exclCount, @manager, null, @updatedBy

	IF @primary = 'Y' BEGIN
		EXEC dbo.uspSetCurrentPrimaryPosition @empId
	END
	ELSE BEGIN
		EXEC dbo.uspSetSecondaryPositions @empId
	END
		
END

