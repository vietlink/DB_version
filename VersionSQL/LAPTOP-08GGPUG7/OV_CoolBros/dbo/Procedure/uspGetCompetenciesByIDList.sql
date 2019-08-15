/****** Object:  Procedure [dbo].[uspGetCompetenciesByIDList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetenciesByIDList](@idList varchar(max))
AS
BEGIN
	DECLARE @idTable TABLE(id int);
--	SET @outputTable = fnSplitString(@idList, ',');

	IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@idList, ',');
    END
    ELSE IF LEN(@idList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@idList AS int));
    END

	SELECT 
		c.*, cl.CompetencyGroupId AS GroupId
	FROM
		Competencies c
	INNER JOIN
		CompetencyList cl
	ON
		cl.CompetencyId = c.Id
	INNER JOIN
		CompetencyGroups g
	ON
		g.Id = cl.CompetencyGroupId
	INNER JOIN
		CompetencyTypes ct
	ON
		ct.Id = g.TypeId
	WHERE 
		c.[Enabled] = 'Y' AND g.[Enabled] = 'Y' AND ct.[Enabled] = 'Y' AND cl.Id IN (SELECT * FROM @idTable)
	ORDER BY
		ct.SortOrder, g.SortOrder, c.Description
END

