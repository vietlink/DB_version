/****** Object:  Procedure [dbo].[uspGetEmployeesByPositionCompetencyIDList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeesByPositionCompetencyIDList](@idList varchar(max), @positionid int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idTable TABLE(id int, rankingid int);
	DECLARE @mandatoryTable TABLE(id int);

	IF CHARINDEX(',', @idList, 0) > 0 BEGIN
		--INSERT INTO @idTable -- split the text by , and store in temp table
		DECLARE splitScan CURSOR FOR
			SELECT * FROM fnSplitString(@idList, ',');
		OPEN splitScan;
		DECLARE @splitData varchar(15);
		FETCH NEXT FROM splitScan INTO @splitData;
		WHILE @@FETCH_STATUS = 0 BEGIN
			DECLARE @sepIndex int = (SELECT CHARINDEX('*', @splitData));
			DECLARE @id varchar(10) = (SELECT SUBSTRING(@splitData, 0, @sepIndex));
			DECLARE @rankId varchar(10) = (SELECT SUBSTRING(@splitData, @sepIndex + 3, 10));
			INSERT INTO @idTable(id, rankingid)
				VALUES(@id, @rankId);
			FETCH NEXT FROM splitScan INTO @splitData;
		END

		CLOSE splitScan;
		DEALLOCATE splitScan;
    END
    ELSE IF LEN(@idList) > 0 BEGIN -- if text existst without a , then assume 1 id
		SET @sepIndex = (SELECT CHARINDEX('*', @idList));
		SET @id = (SELECT SUBSTRING(@idList, 0, @sepIndex));
		SET @rankId = (SELECT SUBSTRING(@idList, @sepIndex + 3, 10));
		
		INSERT INTO @idTable(id, rankingid)
			VALUES(@id, @rankId);
    END

	SELECT id as EmployeeId, firstname, surname FROM Employee e
		INNER JOIN
		(
			SELECT
				DISTINCT E.id AS EmployeeId
			FROM
				PositionCompetencyList pcl
			INNER JOIN
				EmployeePosition ep
			ON
				ep.positionid = @positionid
			INNER JOIN
				Employee E
			ON
				E.id = ep.Employeeid
			LEFT OUTER JOIN
				EmployeeCompetencyRankings ecr
			ON
				pcl.RankingId = ecr.Id
			INNER JOIN
				CompetencyList cl
			ON
				pcl.CompetencyListId = cl.Id
			WHERE
				cl.Id IN (SELECT Id FROM @idTable) AND E.IsDeleted = 0 AND E.Identifier <> 'VACANT' AND ep.IsDeleted = 0
		) as empSet
		ON
			e.Id = empSet.EmployeeId
		ORDER BY e.firstname, e.surname	
	END

