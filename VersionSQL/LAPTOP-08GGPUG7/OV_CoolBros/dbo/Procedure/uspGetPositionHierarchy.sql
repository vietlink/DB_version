/****** Object:  Procedure [dbo].[uspGetPositionHierarchy]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionHierarchy](@search varchar(max), @locationList varchar(max), @showDeleted bit = 0, @showVacant int = 0, @includeGroups bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--WITH PositionList AS
	--(
	--	SELECT
	--		parent.id, parent.title, parent.parentid, 1 AS positionLevel
	--	FROM
	--		Position parent
	--	WHERE
	--		parent.parentid IS NULL
	--	UNION ALL
	--	SELECT
	--		pos.id, pos.title, pos.parentid, pl.positionLevel + 1
	--	FROM
	--		Position pos
	--	INNER JOIN
	--		PositionList pl ON pos.parentid = pl.id
	--	WHERE
	--		pos.parentid IS NOT NULL AND pos.IsUnassigned = 0
	--)
	--SELECT 
	--	*
	--FROM 
	--	PositionList

	DECLARE @locationTable TABLE(location varchar(max))
	INSERT INTO @locationTable SELECT splitdata FROM fnSplitString(@locationList, ';');
	UPDATE @locationTable SET location = '' WHERE location = '(Blank)'

	SELECT
		id, location, identifier, title, (select count(id) from documents where PageType = 'position' and DataID = p.id AND IsDeleted = 0) as DocumentCount,
		(select isnull(count(ep.id), 0) from employeeposition ep inner join employee e on e.id = ep.employeeid where positionid = p.id and e.isdeleted = 0 and ep.isdeleted = 0 and e.identifier <> 'vacant') as EmployeeCount
	FROM
		Position p
	WHERE
		((@includeGroups = 0 AND isplaceholder = 0) or @includeGroups = 1)
		AND
		(title LIKE '%' + @search + '%' OR identifier like '%' + @search + '%') AND ((IsDeleted = 0 AND @showDeleted = 0) OR (IsDeleted = 1 AND @showDeleted = 1))
		AND
		(@locationList = '' OR (isnull(p.Location, '') IN (SELECT location FROM @locationTable)))
		AND
		(@showVacant = 0 OR ((select isnull(count(ep.id), 0) from employeeposition ep inner join employee e on e.id = ep.employeeid where positionid = p.id and e.isdeleted = 0 and ep.isdeleted = 0 and e.identifier <> 'vacant') = 0 AND @showVacant = 1))
	ORDER BY
		title			
END

