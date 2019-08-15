/****** Object:  Procedure [dbo].[uspSetSoftDeleteEmployee]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetSoftDeleteEmployee](@id int, @doSoftDelete int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @identifier varchar(255);
	DECLARE @empIsDeleted bit = 0;
	SELECT @identifier = identifier, @empIsDeleted = IsDeleted FROM Employee WHERE id = @id;

	DECLARE @activeStatusId int;
	SELECT @activeStatusId = id FROM Status WHERE code = 'a';

	UPDATE Employee SET IsDeleted = @doSoftDelete WHERE id = @id;

	-- Create a new status history
	--IF @empIsDeleted = 1 AND @doSoftDelete = 0 BEGIN
	--	UPDATE 
	--		esh
	--	SET 
	--		esh.EndDate = dateadd(day,-1, cast(getdate() as date))
	--	FROM 
	--		EmployeeStatusHistory esh
	--	INNER JOIN
	--	(
	--		SELECT
	--			e.id as EmployeeID,
	--			MAX(StartDate) as StartDate
	--		FROM 
	--			EmployeeStatusHistory esh
	--		INNER JOIN
	--			Employee e
	--		ON
	--			e.id = esh.EmployeeID
	--		WHERE 
	--			e.identifier <> 'Vacant' AND e.id = @id
	--		GROUP BY 
	--			e.id
	--	) historyRs
	--	ON 
	--		historyRs.EmployeeID = esh.EmployeeID AND historyRs.StartDate = esh.StartDate

	--	INSERT INTO
	--		EmployeeStatusHistory	
	--	SELECT
	--		e.id,
	--		@activeStatusId, 
	--		Convert(date, getdate()),
	--		NULL, 
	--		NULL,
	--		NULL,
	--		'system',
	--		Convert(date, getdate())
	--	FROM
	--		Employee e
	--	WHERE 
	--		e.identifier <> 'Vacant' AND e.id = @id
	--END

	DECLARE @positionId int = 0;
	SELECT @positionId = ID FROM Position WHERE IsPlaceholder = 1 AND identifier = @identifier

	IF @positionId > 0 BEGIN
		UPDATE Position SET IsDeleted = @doSoftDelete WHERE id = @positionId
		IF @doSoftDelete = 1 BEGIN
			DECLARE @unassignedId int = 0;
			SELECT @unassignedId = ID FROM Position WHERE IsUnassigned = 1;
			UPDATE Position SET parentid = @unassignedId WHERE id = @positionId
			--UPDATE EmployeePositionInfo SET positionparentid = @unassignedId WHERE positionparentid = @positionId
			UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE positionid = @positionId

			DECLARE @removeTable TABLE(empPosId int, posId int);
			INSERT INTO @removeTable SELECT id, positionid FROM EmployeePosition WHERE dbo.fnCheckPositionIsSubordinateorSuperior(@positionId, positionid) <> 0;
			UPDATE Position SET parentid = @unassignedId WHERE id in (SELECT posId FROM @removeTable)
			UPDATE EmployeePositionInfo SET positionparentid = @unassignedId WHERE positionid in (SELECT posId FROM @removeTable)
		END
		ELSE BEGIN
			UPDATE EmployeePosition SET IsDeleted = 0 WHERE EmployeeID = @id AND PositionID = @positionId
		END
	END
	IF @doSoftDelete = 1 BEGIN
		DECLARE @accountName varchar(255);
		SELECT @accountName = accountname FROM Employee WHERE id = @id;
		UPDATE [User] SET IsDeleted = 1 WHERE accountname = @accountName;
		DELETE FROM RoleUser WHERE userid IN (SELECT id FROM [User] WHERE accountname = @accountName)
		UPDATE EmployeePositionInfo SET IsVisible = 0 WHERE employeeid = @id
	END
END

