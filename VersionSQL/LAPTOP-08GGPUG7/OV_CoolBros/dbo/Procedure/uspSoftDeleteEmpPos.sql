/****** Object:  Procedure [dbo].[uspSoftDeleteEmpPos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSoftDeleteEmpPos](@idListEmp varchar(max), @idListPos varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTableEmp TABLE(rowNum int, id varchar(max));
	INSERT INTO @idTableEmp SELECT row_number() OVER (ORDER BY (SELECT 0)), splitdata FROM fnSplitString(@idListEmp, ',');
	DECLARE @idTablePos TABLE(rowNum int, id varchar(max));
	INSERT INTO @idTablePos SELECT row_number() OVER (ORDER BY (SELECT 0)), splitdata FROM fnSplitString(@idListPos, ',');

	DECLARE @mainIdTable TABLE(empId varchar(max), posId varchar(max));
	INSERT INTO @mainIdTable
	SELECT emp.id, pos.id FROM @idTableEmp emp
	INNER JOIN
	@idTablePos pos
	ON pos.rowNum = emp.rowNum

	UPDATE
		ep
	SET
		ep.IsDeleted = 1
	FROM
		EmployeePosition ep
	LEFT OUTER JOIN
		Employee e
	ON
		e.id = ep.employeeid
	LEFT OUTER JOIN
		Position p
	ON
		p.id = ep.positionid
	WHERE p.IsUnassigned <> 1 AND p.isplaceholder = 0 AND
		ep.id NOT IN
	(
		SELECT
			id
		FROM
			EmployeePosition ep
		INNER JOIN
		(
			SELECT
				e.id as empId, p.id as posId
			FROM
				@mainIdTable idT
			LEFT OUTER JOIN
				Employee e
			ON
				e.identifier = idT.empId
			LEFT OUTER JOIN
				Position p
			ON
				p.identifier = idT.posId
			WHERE p.IsUnassigned = 0
		) rs
		ON ep.employeeid = rs.empId AND ep.positionid = rs.posId
	)
END

