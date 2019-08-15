/****** Object:  Procedure [dbo].[uspAddEmployeeToUnassignedPosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEmployeeToUnassignedPosition](@empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @unassignedid int = 0;
	DECLARE @DefaultExclFromSubordCount varchar(1) = 'Y';

	DECLARE @vacantId int = 0;
	SELECT @vacantId = id FROM Employee WHERE identifier = 'Vacant';

	IF(@empId = @vacantId)
		RETURN

	SELECT TOP 1 @unassignedid = id, @DefaultExclFromSubordCount = DefaultExclFromSubordCount from Position where IsUnassigned = 1
	IF EXISTS (SELECT ID FROM EmployeePosition WHERE EmployeeID = @empId AND PositionID <> @unassignedid AND IsDeleted = 0) BEGIN
		RETURN;
	END
	IF EXISTS (SELECT ID FROM EmployeePosition WHERE EmployeeID = @empId AND PositionID = @unassignedid) BEGIN
		UPDATE EmployeePosition SET IsDeleted = 0, primaryposition = 'Y' WHERE EmployeeID = @empId AND PositionID = @unassignedid;
	END
	ELSE
		IF(@unassignedid = 0 OR @unassignedid IS NULL) BEGIN
			INSERT INTO Position (title, description, type, isassistant, orgunit1, orgunit2, orgunit3, identifier, iFlag, IsVisibleChart, IsUnassigned, parentid, DefaultExclFromSubordCount)
				VALUES('Unassigned', '', '', 'N', '', '', '', '', 1, 0, 1, 1, @DefaultExclFromSubordCount);
		END
		SELECT TOP 1 @unassignedid = id from Position where IsUnassigned = 1
		IF NOT EXISTS (SELECT TOP 1 id FROM EmployeePosition WHERE employeeid = @empid AND IsDeleted = 0)
		BEGIN
			INSERT INTO EmployeePosition(employeeid, positionid, vacant, primaryposition, ExclFromSubordCount)
				VALUES(@empid, @unassignedid, 'N', 'Y', @DefaultExclFromSubordCount);
		END
	END

