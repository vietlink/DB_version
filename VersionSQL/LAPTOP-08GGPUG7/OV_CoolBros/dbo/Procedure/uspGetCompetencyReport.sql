/****** Object:  Procedure [dbo].[uspGetCompetencyReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompetencyReport] 
	-- Add the parameters for the stored procedure here
	 ( @empIDList varchar(max), @divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @statusList varchar(max), @typeList varchar(max), @competencyIDList varchar(max), @sortBy varchar(max), @groupBy varchar(max))

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @typeTable TABLE(type varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @empIDTable TABLE(empID int);
	DECLARE @competencyIDTable TABLE(competencyID int);
	
	IF CHARINDEX(',', @divisionList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionList, ',');	
    END
    ELSE IF LEN(@divisionList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionList);	
    END

	IF CHARINDEX(',', @departmentList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentList, ',');	
    END
    ELSE IF LEN(@departmentList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentList);	
    END

	IF CHARINDEX(';', @locationList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationList, ';');	
    END
    ELSE IF LEN(@locationList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationList);	
    END

	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusList);	
    END	
	IF CHARINDEX(',', @typeList, 0) > 0 BEGIN
		INSERT INTO @typeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@typeList, ',');	
    END
    ELSE IF LEN(@typeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @typeTable(type) VALUES(@typeList);	
    END	
	IF CHARINDEX(',', @empIDList, 0) > 0 BEGIN
		INSERT INTO @empIDTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@empIDList, ',');	
    END
    ELSE IF LEN(@empIDList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empIDTable(empID) VALUES(cast(@empIDList as int));	
    END	
	

	IF CHARINDEX(',', @competencyIDList, 0) > 0 BEGIN
		INSERT INTO @competencyIDTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@competencyIDList, ',');	
    END
    ELSE IF LEN(@competencyIDList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @competencyIDTable(competencyID) VALUES(cast(@competencyIDList as int));	
    END	
	print @competencyIDList;
	SELECT 
		e.id as EmpID,
		p.id as posID,
		ep.id as EmpPosID,
		e.displayname,
		isnull(p.title,'') as title,
		isnull(p.orgunit2,'') as orgunit2,
		isnull(p.orgunit3,'') as orgunit3,
		c.Description as competencyDescription,
		e.status,
		isnull(e.type,'') as type,
		case when(ecl.EmployeeCompetencyRankingId is null) then 
			case when (ecl.iHaveThis=1) then 'I have this' else 'I do not have this' end
		 else isnull(cast(ecr.RankingIndex as varchar(2))+'. '+ ecr.ShortDescription,'') end as ranking
	FROM 
	EMPLOYEE e
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid and ep.IsDeleted= 0 and ep.primaryposition='Y'
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	INNER JOIN EmployeeCompetencyList ecl ON e.id= ecl.Employeeid
	LEFT OUTER JOIN EmployeeCompetencyRankings ecr ON ecl.EmployeeCompetencyRankingId= ecr.Id	
	INNER JOIN CompetencyList cl ON cl.id= ecl.CompetencyListId
	INNER JOIN Competencies c ON c.Id= cl.CompetencyId
	INNER JOIN CompetencyGroups cg ON cl.CompetencyGroupId= cg.Id
	INNER JOIN CompetencyTypes ct ON ct.Id= cg.TypeId
	WHERE 
	ct.Code!='' 
	and c.Type!=2	
	and ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR case when isnull(p.orgunit3, '') = '' then '(Blank)' else p.orgunit3 end IN (SELECT * FROM @idDepartmentTable))
	AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR case when isnull(p.orgunit2, '') = '' then '(Blank)' else p.orgunit2 end IN (SELECT * FROM @idDivisionTable))
	AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR case when isnull(e.location, '') = '' then '(Blank)' else e.location end IN (SELECT * FROM @idLocationTable))
	AND (e.id IN (SELECT * FROM @empIDTable))
	AND ((SELECT COUNT(*) FROM @competencyIDTable) = 0 OR c.Id IN (SELECT * FROM @competencyIDTable))
	AND ((SELECT COUNT(*) FROM @statusTable) = 0 OR case when isnull(e.status, '') = '' then '(Blank)' else e.status end IN (SELECT * FROM @statusTable))
	AND ((SELECT COUNT(*) FROM @typeTable) = 0 OR case when isnull(e.type, '') = '' then '(Blank)' else e.type end IN (SELECT * FROM @typeTable))
	ORDER BY
	CASE WHEN @groupBy = 'orgunit2' THEN p.orgunit2 END,		
		CASE WHEN @groupBy = 'orgunit3' THEN p.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN e.location END,		
		CASE WHEN @groupBy = 'type' THEN e.type END,
		CASE WHEN @groupBy = 'competencyDescription' THEN c.Description END,		
		CASE WHEN @sortBy = 'orgunit2' THEN p.orgunit2 END,
		CASE WHEN @sortBy = 'orgunit3' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,
		CASE WHEN @sortBy = 'surname' THEN e.surname END,
		CASE WHEN @sortBy= 'title' THEN p.title END,				
		CASE WHEN @sortBy = 'competencyDescription' THEN c.Description END,		
		e.displayname	
END
