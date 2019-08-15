/****** Object:  Procedure [dbo].[uspGetSelectManagerList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSelectManagerList](@employeeid int, @positionId int, @search varchar(100), @onlyShowAbove bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @onlyShowAbove = 1 BEGIN
		WITH parents(id, title, parentid, parentLevel, identifier, location, isplaceholder, isunassigned)
		AS
			(
			SELECT
				id,
				title,
				parentid,
				0 as parentLevel,
				identifier,
				location,
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
				p.identifier,
				p.location,
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
			e.displayname, e.id as Employeeid, ep.id as epId, p.Id as Positionid, p.title, p.location, p.identifier, ep.primaryposition
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
			ep.IsDeleted = 0 AND e.IsDeleted = 0 AND p.IsPlaceholder = 0 AND p.isunassigned = 0 AND e.id <> @employeeid and p.id <> @positionId
			AND
			(p.title LIKE '%' + @search + '%' OR p.identifier like '%' + @search + '%' OR p.location like '%' + @search + '%' OR e.displayname like '%' + @search + '%')
		ORDER BY p.parentLevel DESC
	END
	ELSE BEGIN
		SELECT
			e.displayname, e.id as Employeeid, ep.id as epId, p.Id as Positionid, p.title, p.location, p.identifier, ep.primaryposition
		FROM
			Position p
		INNER JOIN
			EmployeePosition ep
		ON
			ep.Positionid = p.id
		INNER JOIN
			Employee e
		ON
			ep.employeeid = e.id
		WHERE
			ep.IsDeleted = 0 AND e.IsDeleted = 0 AND p.IsPlaceholder = 0 AND p.isunassigned = 0 AND p.IsDeleted = 0 AND e.id <> @employeeid
			AND
			(p.title LIKE '%' + @search + '%' OR p.identifier like '%' + @search + '%' OR p.location like '%' + @search + '%' OR e.displayname like '%' + @search + '%')
		ORDER BY e.surname
	END
END


