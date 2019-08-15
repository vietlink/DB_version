/****** Object:  Procedure [dbo].[uspModifyPositionCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyPositionCompetencyList](@positionid int, @idList varchar(max), @isComplianceMode bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Delete no longer used Ids
    DECLARE @idTable TABLE (id int);
    
    IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@idList, ',');
    END
    ELSE IF LEN(@idList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@idList AS int));
    END
    
    DELETE pcl
	FROM
		PositionCompetencyList pcl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = pcl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE 
		Positionid = @positionid AND (CompetencyListId NOT IN (SELECT * FROM @idTable))
	AND
		((@isComplianceMode = 1 AND c.[Type] = 2) OR (@isComplianceMode = 0 AND (c.[Type] = 1 OR c.[Type] = 0)))
END

