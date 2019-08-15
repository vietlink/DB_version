/****** Object:  Procedure [dbo].[uspActivateEmployeeUnassignedPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspActivateEmployeeUnassignedPosition](@empId int, @updatedBy varchar(255) = '')
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @unassignedId int = 0;
    DECLARE @epId int = 0;
	SELECT TOP 1 @unassignedId = id FROM Position WHERE IsUnassigned = 1
	SELECT TOP 1 @epId = id FROM EmployeePosition WHERE EmployeeID = @empid AND positionid = @unassignedId

	IF @epId < 1 BEGIN
		INSERT INTO EmployeePosition(employeeid, positionid, primaryposition, vacant, IsDeleted)
			VALUES(@empId, @unassignedId, 'Y', 'N', 0);
		SET @epId = @@IDENTITY;
		INSERT INTO
			EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
			customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
				VALUES(@epId, @empId, @unassignedId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
	END
	ELSE BEGIN
		UPDATE EmployeePosition SET IsDeleted = 0, primaryposition = 'Y' WHERE id = @epId;
		IF NOT EXISTS (SELECT id FROM EmployeePositionInfo WHERE id = @epId) BEGIN
			INSERT INTO
				EmployeePositionInfo(id, employeeid, positionid, [displaynameid], displayname, employeeimageurlid, employeeimageurl, positiontitle, customfield1,
				customfield2, customfield3, customfield4, availabilitystatus, IsVisible, IsAssistant, haschildren, availabilityiconurl, positiontitleid)
					VALUES(@epId, @empId, @unassignedId, 0, '', 0, '', '', '', '', '', '', 1, 1, 0, 0, '', 0)
		END
	END
	--use termination date if set
	DECLARE @today datetime = null;
	SELECT @today = termination FROM Employee WHERE id = @empId;
	IF @today = NULL BEGIN
		SET @today = Convert(DateTime, DATEDIFF(DAY, 0, GETDATE()));
	END

	DELETE FROM EmployeePositionHistory WHERE Employeeid = @empId AND startdate >= @today
	EXEC dbo.uspSaveEmployeePositionHistory 0, @empId, 0, @unassignedId, @today, NULL, 'Y', 0, 'N', 'Y', 'N', NULL, @updatedBy
	UPDATE EmployeePositionHistory SET EndDate = DATEADD(day, -1, @today) WHERE EmployeeID = @empId AND primaryposition = 'N' AND EndDate IS NULL
	EXEC dbo.uspSetCurrentPrimaryPosition @empId, 1
	EXEC dbo.uspSetSecondaryPositions @empId, 1
	
	EXEC uspRunUpdatePreference @epId, @empId, @unassignedId;

	exec dbo.uspBuildPositionGrouplessHierarchy;
--	exec dbo.uspUpdateAllCounts;
--	exec dbo.uspSetEmptyParentEmpPos;

	
END

