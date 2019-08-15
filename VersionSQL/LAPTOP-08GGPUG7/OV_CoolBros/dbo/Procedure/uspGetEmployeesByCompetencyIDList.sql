/****** Object:  Procedure [dbo].[uspGetEmployeesByCompetencyIDList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeesByCompetencyIDList](@idList varchar(max), @mandatoryList varchar(max), @positionId int, @excludePosition bit)
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

	IF CHARINDEX(',', @mandatoryList, 0) > 0 BEGIN
		INSERT INTO @mandatoryTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@mandatoryList, ',');
    END
    ELSE IF LEN(@mandatoryList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @mandatoryTable(id) VALUES(CAST(@mandatoryList AS int));
    END

	IF (SELECT COUNT(id) FROM @mandatoryTable) = 0 BEGIN
		SELECT id as EmployeeId, firstname, surname FROM Employee e
		INNER JOIN
		(
			SELECT
				DISTINCT ecl.EmployeeId AS EmployeeId
			FROM
				EmployeeCompetencyList ecl
			INNER JOIN
				Employee E
			ON
				E.id = ecl.Employeeid
			LEFT OUTER JOIN
				EmployeeCompetencyRankings ecr
			ON
				ecl.EmployeeCompetencyRankingId = ecr.Id
			INNER JOIN
				CompetencyList cl
			ON
				ecl.CompetencyListId = cl.Id
			LEFT OUTER JOIN
				EmployeePosition ep
			ON
				ep.employeeid = e.id AND ep.positionid = @positionId
			WHERE
				ecl.iHaveThis = 1 AND
				((@excludePosition = 1 AND ep.id IS NULL) OR (@excludePosition = 0)) AND
				cl.Id IN (SELECT Id FROM @idTable) AND E.IsDeleted = 0 AND E.Identifier <> 'VACANT'
		) as empSet
		ON
			e.Id = empSet.EmployeeId
		ORDER BY e.firstname, e.surname	
	END
	ELSE
		SELECT id as EmployeeId, firstname, surname FROM Employee e
		INNER JOIN
		(
			SELECT
				COUNT(ecl.EmployeeId) as Count, ecl.Employeeid
			FROM
				EmployeeCompetencyList ecl
			INNER JOIN
				Employee E
			ON
				E.id = ecl.Employeeid
			LEFT OUTER JOIN
				EmployeeCompetencyRankings ecr
			ON
				ecl.EmployeeCompetencyRankingId = ecr.Id
			INNER JOIN
				CompetencyList cl
			ON
				ecl.CompetencyListId = cl.Id
			INNER JOIN
				Competencies c
			ON
				c.id = cl.CompetencyId
							LEFT OUTER JOIN
				EmployeePosition ep
			ON
				ep.employeeid = e.id AND ep.positionid = @positionId
			INNER JOIN
				@mandatoryTable mt
			ON
				mt.id = cl.id
			INNER JOIN
				@idTable idt
			ON
				idt.id = mt.id
			WHERE
				ecl.iHaveThis = 1 AND
				((@excludePosition = 1 AND ep.id IS NULL) OR (@excludePosition = 0)) AND
				(SELECT COUNT(*) FROM @mandatoryTable WHERE id = cl.Id AND ISNULL(ecr.RankingIndex, 0) >= idt.rankingid) > 0
				AND E.IsDeleted = 0
				AND 
				(
					(c.[Type] = 2 AND ecl.DateFrom <= GETDATE() AND ecl.DateTo > GETDATE())
					OR
					(c.[Type] <> 2)
				)
			GROUP BY ecl.EmployeeId
		) as empSet
		ON
			e.Id = empSet.EmployeeId
		WHERE empSet.Count = (SELECT Count(id) FROM @mandatoryTable)
		ORDER BY e.firstname, e.surname	
	END

--(CASE WHEN LEN(@mandatoryList) > 0 THEN (SELECT * FROM @mandatoryTable) ELSE (SELECT * FROM @idTable) END)

