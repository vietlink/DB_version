/****** Object:  Procedure [dbo].[uspGetPositionCompetencyEmployeeDataByIdList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPositionCompetencyEmployeeDataByIdList](@positionId int, @idList varchar(max), @mandatoryList varchar(max), @locationFilter varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id int, rankingid int);
	DECLARE @mandatoryTable TABLE(id int);
	DECLARE @locationTable TABLE(location varchar(max))

	IF LEN(@locationFilter) > 0 BEGIN
		INSERT INTO @locationTable SELECT * FROM fnSplitString(@locationFilter, ',');
	END

	IF CHARINDEX(',', @idList, 0) > 0 BEGIN
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

	DECLARE @resultTable TABLE (EmployeeId int, CompList varchar(max), SortOrder varchar(10));
	DECLARE @empScanTable TABLE(EmployeeId int, firstname varchar(50), surname varchar(50));
	INSERT INTO @empScanTable EXEC uspGetEmployeesByPositionCompetencyIDList @idList, @positionid;

	DECLARE @empScanId int;
	DECLARE empScan CURSOR FOR
	SELECT EmployeeId FROM @empScanTable;

	OPEN empScan;
	FETCH NEXT FROM empScan INTO @empScanId;
	WHILE @@FETCH_STATUS = 0 BEGIN
		DECLARE @compScanId int;
		DECLARE @compScanRankingId int;
		DECLARE @compList varchar(max) = '';
		DECLARE @colourCounter int = 0;
		DECLARE @rankCounter int = 0;
		DECLARE @type int = null;

		DECLARE compScan CURSOR FOR
		SELECT 
			idt.id, idt.rankingid, c.[Type]
		FROM
			@idTable idt
		INNER JOIN
			CompetencyList cl
		ON
			cl.Id = idt.Id
		INNER JOIN
			Competencies c
		ON
			c.Id = cl.CompetencyId
		INNER JOIN
			CompetencyGroups g
		ON
			g.Id = cl.CompetencyGroupId
		INNER JOIN
			CompetencyTypes ct
		ON
			ct.Id = g.TypeId
		WHERE c.[Enabled] = 'Y' AND g.[Enabled] = 'Y' AND ct.[Enabled] = 'Y'
		ORDER BY ct.SortOrder, g.SortOrder, c.[Description]
		
		OPEN compScan;
		FETCH NEXT FROM compScan INTO @compScanId, @compScanRankingId, @type;
		WHILE @@FETCH_STATUS = 0 BEGIN
			DECLARE @isOnMandatoryList int = 0;

			IF EXISTS (SELECT TOP 1 id FROM @mandatoryTable WHERE id = @compScanId) BEGIN
				SET @isOnMandatoryList = 1;
			END			

			DECLARE @value varchar(5) = null;
			SET @value = CASE WHEN @compList = '' THEN '' ELSE ',' END;
			DECLARE @searchRankIndex int = null;
			DECLARE @searchId int = null;
			DECLARE @iHaveThis bit = null;
			DECLARE @DateFrom datetime;
			DECLARE @DateTo datetime;
			DECLARE @IsMandatory bit;

			SELECT
				@searchId = ecl.Id,
				@searchRankIndex = ecr.RankingIndex,
				@iHaveThis = ecl.iHaveThis,
				@DateFrom = ecl.DateFrom,
				@DateTo = ecl.DateTo,
				@IsMandatory = ecl.IsMandatory
			FROM
				CompetencyList cl
			INNER JOIN
				Competencies c
			ON
				c.id = cl.CompetencyId
			LEFT OUTER JOIN
				EmployeeCompetencyList ecl
			ON
				cl.Id = ecl.CompetencyListId
			LEFT OUTER JOIN
				EmployeeCompetencyRankings ecr
			ON
				ecl.EmployeeCompetencyRankingId = ecr.Id	
			WHERE
			cl.Id = @compScanId AND ecl.Employeeid = @empScanId
			--AND 
			--	(
			--		(c.[Type] = 2 AND ecl.DateFrom <= GETDATE() AND ecl.DateTo > GETDATE())
			--		OR
			--		(c.[Type] <> 2)
			--	)

				-- @searchId will always be null for non valid compliances as the above
				-- logic factors in dates, due to this we currently have no way of telling
				-- if an expired compliance was mandatory.

			IF @type = 2 BEGIN
				IF @DateFrom IS NULL
					SET @searchId = NULL
				IF @DateFrom <= GETDATE() AND @DateTo > GETDATE()
					SET @searchId = @searchId;
				ELSE
					SET @searchId = NULL;
			END

			SET @value = @value + CASE WHEN @searchId IS NOT NULL AND @iHaveThis = 1 THEN
				CASE WHEN @isOnMandatoryList = 1 THEN
					CASE WHEN ISNULL(@searchRankIndex, 0) >= @compScanRankingId THEN
						'M' + ISNULL(CAST(@searchRankIndex as varchar), CASE WHEN @type = 0 OR @type = 2 THEN 'A' ELSE 'N' END)
					ELSE
						'MU' + ISNULL(CAST(@searchRankIndex as varchar), CASE WHEN @type = 0 OR @type = 2 THEN 'A' ELSE 'N' END)
					END
				ELSE
					CASE WHEN ISNULL(@searchRankIndex, 0) >= @compScanRankingId THEN
						'D' + ISNULL(CAST(@searchRankIndex as varchar), CASE WHEN @type = 0 OR @type = 2 THEN 'A' ELSE 'N' END)
					ELSE
						'DU' + ISNULL(CAST(@searchRankIndex as varchar), CASE WHEN @type = 0 OR @type = 2 THEN 'A' ELSE 'N' END)
					END
				END
			ELSE
				CASE WHEN @isOnMandatoryList = 1 THEN
					CASE WHEN (@searchId IS NULL AND @IsMandatory = 0 AND @type = 2) THEN
						'M-3'
					WHEN (@searchId IS NOT NULL AND @iHaveThis = 0) OR (@type = 2 AND @searchId IS NULL) THEN
						'M-2'
					ELSE
						'M-1'
					END
				ELSE
					CASE WHEN (@searchId IS NULL AND @IsMandatory = 0 AND @type = 2) THEN
						'D-3'
					WHEN (@searchId IS NOT NULL AND @iHaveThis = 0) OR (@type = 2 AND @searchId IS NULL) THEN
						'D-2'
					ELSE
						'D-1'
					END
				END
			END
			SET @compList = @compList + @value;
			SET @rankCounter = @rankCounter + ISNULL(@searchRankIndex, 0);
			SET @value = REPLACE(@value, ',', '');
			IF LEFT(@value, 2) LIKE 'DU' BEGIN
				SET @colourCounter = @colourCounter;
			END
			ELSE IF LEFT(@value, 3) LIKE 'D-1' OR LEFT(@value, 3) LIKE 'D-2' BEGIN
				SET @colourCounter = @colourCounter
			END
			ELSE IF LEFT(@value, 3) LIKE 'M-1' OR LEFT(@value, 3) LIKE 'M-2' BEGIN
				SET @colourCounter = @colourCounter
			END
			ELSE IF LEFT(@value, 1) LIKE 'D' OR LEFT(@value, 1) LIKE 'M' BEGIN
				SET @colourCounter = @colourCounter + 1;
			END
			FETCH NEXT FROM compScan INTO @compScanId, @compScanRankingId, @type;
		END
		DECLARE @SortCode varchar(10) = RIGHT('0000' + CAST(@colourCounter AS varchar(3)), 4) + ',' +
			RIGHT('0000' + CAST(@rankCounter AS varchar(3)), 4)
		INSERT INTO @resultTable(EmployeeId, CompList, SortOrder) VALUES(@empScanId, @compList, @SortCode);
		CLOSE compScan;
		DEALLOCATE compScan;
		FETCH NEXT FROM empScan INTO @empScanId;
	END
	CLOSE empScan;
	DEALLOCATE empScan;

	SELECT e.Firstname, e.Surname, rt.CompList, e.Id, e.displayname FROM Employee e
	INNER JOIN
		@resultTable rt
	ON
		rt.EmployeeId = e.Id
	WHERE
	e.IsDeleted = 0 AND
		((@locationFilter = '') OR e.location IN (SELECT * FROM @locationTable))
	ORDER BY
		rt.SortOrder DESC, e.firstname, e.surname DESC
END

