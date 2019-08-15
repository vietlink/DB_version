/****** Object:  Procedure [dbo].[uspGetDocumentsByDataIDType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDocumentsByDataIDType](@dataID int, @positionId int, @pageType nvarchar(20))
AS
BEGIN
	SET NOCOUNT ON;
	IF @pageType = 'Personal' BEGIN
		SELECT
			d.*, c.Description AS Competency
		FROM
			Documents d
		LEFT OUTER JOIN
			EmployeeCompetencyList ecl
		ON
			ecl.Employeeid = @dataID AND (d.PageType = 'Competency' OR d.PageType = 'Compliance') AND ecl.Id = d.DataID
		LEFT OUTER JOIN
			PositionCompetencyList pcl
		ON
			pcl.PositionId = @positionId AND (d.PageType = 'positioncompetency' OR d.PageType = 'positioncompliance') AND pcl.id = d.DataID
		LEFT OUTER JOIN
			CompetencyList cl
		ON
			ecl.CompetencyListId = cl.Id OR pcl.CompetencyListId = cl.Id
		LEFT OUTER JOIN
			Competencies c
		ON
			cl.CompetencyId = c.Id
		WHERE
			d.IsDeleted = 0 AND ((d.DataID = @dataID AND d.PageType = 'Personal') OR (ecl.Employeeid = @dataID AND (d.PageType = 'Competency' OR d.PageType = 'Compliance')) OR (pcl.PositionId = @positionId AND (d.PageType = 'PositionCompliance' OR d.PageType = 'PositionCompetency')) OR (d.PageType = 'Position' AND d.DataID = @positionId))
		ORDER BY d.PageType DESC, d.FileName ASC
	END
	ELSE IF @pageType = 'Competency' OR @pageType = 'Compliance' BEGIN
			SELECT
			d.*, c.Description AS Competency
		FROM
			Documents d
		LEFT OUTER JOIN
			EmployeeCompetencyList ecl
		ON
			d.PageType = @pageType AND ecl.Id = d.DataID
		LEFT OUTER JOIN
			CompetencyList cl
		ON
			ecl.CompetencyListId = cl.Id
		LEFT OUTER JOIN
			Competencies c
		ON
			cl.CompetencyId = c.Id
		WHERE d.IsDeleted = 0 AND d.DataID = @dataID AND d.PageType LIKE @pageType
	END
	ELSE IF @pageType = 'Position' BEGIN
		SELECT
			d.*, isnull(c.[description], '') AS Competency
		FROM
			Documents d
		LEFT OUTER JOIN
			PositionCompetencyList pcl
		ON
			d.DataID = pcl.id AND (d.PageType = 'PositionCompliance' OR d.PageType = 'PositionCompetency') AND pcl.PositionId = @dataId
		LEFT OUTER JOIN
			CompetencyList cl
		ON
			cl.id = pcl.CompetencyListId
		LEFT OUTER JOIN
			Competencies c
		ON
			c.id = cl.CompetencyId
		WHERE
			d.IsDeleted = 0 AND ((d.DataID = @dataID AND d.PageType = 'Position') OR (pcl.PositionId = @dataID AND (d.PageType = 'PositionCompetency' OR d.PageType = 'PositionCompliance')) OR (d.PageType = 'Position' AND d.DataID = @dataId))
		ORDER BY d.FileName ASC
	END
	ELSE IF @pageType = 'PositionCompetency' OR @pageType = 'PositionCompliance' BEGIN
		SELECT
			d.*, isnull(c.[description], '') AS Competency
		FROM
			Documents d
		LEFT OUTER JOIN
			PositionCompetencyList pcl
		ON
			pcl.id = @dataID
		LEFT OUTER JOIN
			CompetencyList cl
		ON
			cl.id = pcl.CompetencyListId
		LEFT OUTER JOIN
			Competencies c
		ON
			c.id = cl.CompetencyId
		WHERE d.IsDeleted = 0 AND d.DataID = @dataID AND d.PageType LIKE @pageType
	END
END

