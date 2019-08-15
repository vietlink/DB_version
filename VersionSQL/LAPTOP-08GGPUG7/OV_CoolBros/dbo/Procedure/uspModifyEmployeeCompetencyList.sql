/****** Object:  Procedure [dbo].[uspModifyEmployeeCompetencyList]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Delete where not in list>
-- =============================================
CREATE PROCEDURE [dbo].[uspModifyEmployeeCompetencyList](@employeeId int, @idList varchar(max), @isComplianceMode bit)
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
    
    DELETE ecl
	FROM
		EmployeeCompetencyList ecl
	INNER JOIN
		CompetencyList cl
	ON
		cl.id = ecl.CompetencyListId
	INNER JOIN
		Competencies c
	ON
		c.id = cl.CompetencyId
	WHERE 
		ecl.Employeeid = @employeeId AND (ecl.CompetencyListId NOT IN (SELECT * FROM @idTable))
		AND
		((@isComplianceMode = 1 AND c.[Type] = 2) OR (@isComplianceMode = 0 AND (c.[Type] = 1 OR c.[Type] = 0)))


	--IF LEN(@idList) = 0 BEGIN -- no records to add, exit out
	--	RETURN;
	--END
		
	--DECLARE @compListId int;
	
	--DECLARE idCursor CURSOR FOR	SELECT * FROM @idTable
	--OPEN idCursor;
	--FETCH NEXT FROM idCursor INTO @compListId;
	
	--WHILE @@FETCH_STATUS = 0 -- loop through all of the split IDs and insert
	--BEGIN
	--	IF NOT EXISTS (SELECT CompetencyListId FROM EmployeeCompetencyList WHERE CompetencyListId = @compListId
	--	AND Employeeid = @employeeId) BEGIN
	--		INSERT INTO EmployeeCompetencyList(Employeeid, CompetencyListId)
	--			VALUES(@employeeId, @compListId);
	--	END
	--	FETCH NEXT FROM idCursor INTO @compListId;
	--END
	
	--CLOSE idCursor;
	--DEALLOCATE idCursor;
			
	END

