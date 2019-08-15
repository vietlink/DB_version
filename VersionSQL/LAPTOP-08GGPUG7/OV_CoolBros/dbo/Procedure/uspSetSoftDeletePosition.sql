/****** Object:  Procedure [dbo].[uspSetSoftDeletePosition]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetSoftDeletePosition](@id int, @isDeleted bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE Position SET IsDeleted = @isDeleted WHERE id = @id

	IF @isDeleted = 1 BEGIN
		DECLARE @removeTable TABLE(empPosId int, posId int);
		INSERT INTO @removeTable SELECT id, positionid FROM EmployeePosition WHERE dbo.fnCheckPositionIsSubordinateorSuperior(@id, positionid) <> 0;
		DECLARE @unassignedId int = 0;
		SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1
		UPDATE Position SET parentid = @unassignedId WHERE id in (SELECT posId FROM @removeTable)
	END
END

