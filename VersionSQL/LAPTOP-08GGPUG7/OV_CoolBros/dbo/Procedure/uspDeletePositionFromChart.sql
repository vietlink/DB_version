/****** Object:  Procedure [dbo].[uspDeletePositionFromChart]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDeletePositionFromChart](@posId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @unassignedId int = 0;
	SELECT @unassignedId = id FROM position WHERE IsUnassigned = 1;

	--UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid = @posId;

	IF EXISTS (SELECT id FROM Position WHERE parentid IS NULL AND id = @posId) BEGIN
		UPDATE Position SET parentId = @unassignedId WHERE id = @posId;
		UPDATE Position SET parentId = null WHERE id = @unassignedId
	END

	UPDATE Position SET parentid = @unassignedId WHERE id = @posId;

	DECLARE @removeTable TABLE(empPosId int, posId int);

	INSERT INTO @removeTable SELECT id, positionid FROM EmployeePosition WHERE dbo.fnCheckPositionIsSubordinateorSuperior(@posId, positionid) <> 0;

	--UPDATE EmployeePosition SET IsDeleted = 1 WHERE positionid in (SELECT posId FROM @removeTable)
	UPDATE Position SET parentid = @unassignedId WHERE id in (SELECT posId FROM @removeTable)

	EXEC uspRunUpdatePreference

END

