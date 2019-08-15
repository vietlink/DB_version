/****** Object:  Procedure [dbo].[uspGetPeopleAboveChain]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPeopleAboveChain](@employeeid int, @positionId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH parents(id, title, parentid, parentLevel, isplaceholder, isunassigned)
	AS
		(
		SELECT
			id,
			title,
			parentid,
			0 as parentLevel,
			isplaceholder,
			isunassigned
		FROM
			Position
		WHERE id = @positionId AND IsDeleted = 0
		UNION ALL
		SELECT
			p.id,
			p.title,
			p.parentid,
			_p.parentLevel + 1,
			p.isplaceholder,
			p.isunassigned
		FROM
			Position p
		INNER JOIN
			parents _p
		ON
			p.id = _p.parentid
		WHERE
			p.IsDeleted = 0
		)

	--SELECT * from parents WHERE parentLevel <> 0 ORDER BY parentLevel desc
	SELECT
		e.displayname, p.*
	FROM
		Parents p
	INNER JOIN
		EmployeePosition ep
	ON
		ep.Positionid = p.id
	INNER JOIN
		Employee e
	ON
		ep.employeeid = e.id
	WHERE
		ep.IsDeleted = 0 AND e.IsDeleted = 0 AND p.IsPlaceholder = 0 AND p.isunassigned = 0 AND e.id <> @employeeid
	ORDER BY p.parentLevel DESC
END


