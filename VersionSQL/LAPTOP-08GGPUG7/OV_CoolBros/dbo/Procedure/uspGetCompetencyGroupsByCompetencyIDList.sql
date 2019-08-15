/****** Object:  Procedure [dbo].[uspGetCompetencyGroupsByCompetencyIDList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyGroupsByCompetencyIDList](@idList varchar(max))
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

	SELECT * FROM CompetencyGroups g
	INNER JOIN
		CompetencyTypes ct
	ON
		ct.Id = g.TypeId
	INNER JOIN
	(
		SELECT DISTINCT g.Id FROM
			CompetencyGroups g
		INNER JOIN
			CompetencyList cl
		ON
			g.Id = cl.CompetencyGroupId
		INNER JOIN
			Competencies c
		ON
			c.Id = cl.CompetencyId
		WHERE c.[Enabled] = 'Y' AND cl.Id IN (SELECT * FROM @idTable)
	) as groupSet
	ON
		g.Id = groupSet.Id
	WHERE g.[Enabled] = 'Y' AND ct.[Enabled] = 'Y'
	ORDER BY ct.SortOrder, g.SortOrder
END

