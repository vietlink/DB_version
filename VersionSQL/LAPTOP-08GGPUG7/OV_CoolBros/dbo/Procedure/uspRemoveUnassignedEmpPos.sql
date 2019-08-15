/****** Object:  Procedure [dbo].[uspRemoveUnassignedEmpPos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRemoveUnassignedEmpPos](@idListEmp varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @idTableEmp TABLE(rowNum int, id varchar(max));
	INSERT INTO @idTableEmp SELECT row_number() OVER (ORDER BY (SELECT 0)), splitdata FROM fnSplitString(@idListEmp, ',');

	DECLARE @unassignedId int;
	SELECT @unassignedId = id FROM Position WHERE IsUnassigned = 1

	DELETE 
		ep
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	INNER JOIN
		Position p
	ON
		ep.positionid = @unassignedId
	WHERE
		ep.employeeid
	IN
		(
			SELECT
				id
			FROM
				Employee
			WHERE
				identifier  IN (SELECT id FROM @idTableEmp)
		)
END


