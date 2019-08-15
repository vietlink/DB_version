/****** Object:  Procedure [dbo].[uspSoftDeleteEmployees]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSoftDeleteEmployees](@idList varchar(max))
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id varchar(max));
	INSERT INTO @idTable SELECT splitdata FROM fnSplitString(@idList, ',');
    DECLARE @deletedStatusId int = 0;
	SELECT @deletedStatusId = id FROM Status WHERE [Description] = 'Deleted';

	UPDATE Employee SET IsDeleted = 1, [status] = 'Deleted' WHERE identifier <> 'Vacant' AND identifier NOT IN (SELECT id FROM @idTable);
	UPDATE Position SET IsDeleted = 1 WHERE Isplaceholder = 1 AND identifier NOT IN (SELECT id FROM @idTable);
	UPDATE
		ep
	SET
		ep.IsDeleted = 1
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	WHERE
		identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable);

	UPDATE
		u
	SET
		u.IsDeleted = 1
	FROM
		[User] u
	INNER JOIN
		Employee e
	ON
		e.accountname = u.accountname
	WHERE
		e.identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable);


	UPDATE 
		esh
	SET 
		esh.StatusID = @deletedStatusId
	FROM 
		EmployeeStatusHistory esh
	INNER JOIN
	(
		SELECT
			e.id as EmployeeID,
			MAX(StartDate) as StartDate
		FROM 
			EmployeeStatusHistory esh
		INNER JOIN
			Employee e
		ON
			e.id = esh.EmployeeID
		WHERE 
			e.identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable)
		GROUP BY 
			e.id
	) historyRs
	ON 
		historyRs.EmployeeID = esh.EmployeeID AND historyRs.StartDate = esh.StartDate

	-- Close the last status prior to adding the deleted
	--UPDATE 
	--	esh
	--SET 
	--	esh.EndDate = dateadd(day,-1, cast(getdate() as date))
	--FROM 
	--	EmployeeStatusHistory esh
	--INNER JOIN
	--(
	--	SELECT
	--		e.id as EmployeeID,
	--		MAX(StartDate) as StartDate
	--	FROM 
	--		EmployeeStatusHistory esh
	--	INNER JOIN
	--		Employee e
	--	ON
	--		e.id = esh.EmployeeID
	--	WHERE 
	--		e.identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable)
	--	GROUP BY 
	--		e.id
	--) historyRs
	--ON 
	--	historyRs.EmployeeID = esh.EmployeeID AND historyRs.StartDate = esh.StartDate

	-- Insert Deleted record
	--INSERT INTO
	--	EmployeeStatusHistory	
	--SELECT
	--	e.id,
	--	@deletedStatusId, 
	--	Convert(date, getdate()),
	--	NULL, 
	--	NULL,
	--	NULL,
	--	'system',
	--	Convert(date, getdate())
	--FROM
	--	Employee e
	--WHERE 
	--	e.identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable)


	DELETE FROM RoleUser WHERE userid IN (
		SELECT
			u.id
		FROM
			[User] u
		INNER JOIN
			Employee e
		ON
			e.accountname = u.accountname
		WHERE
			e.identifier <> 'Vacant' AND e.identifier NOT IN (SELECT id FROM @idTable)
	)
END

