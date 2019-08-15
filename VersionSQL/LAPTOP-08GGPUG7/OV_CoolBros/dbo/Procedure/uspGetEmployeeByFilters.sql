/****** Object:  Procedure [dbo].[uspGetEmployeeByFilters]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeByFilters] 
	-- Add the parameters for the stored procedure here
	@projectID int, @clientID int, @divisionFilterList varchar(max), @departmentFilterList varchar(max), @positionFilterList varchar(max),  @employeeStatusFilter varchar(max), @filter varchar(max), @header varchar(max), @order int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idPositionTable TABLE(idPosition varchar(max));		
	declare @employeeStatusTable table(employeeStatus varchar(max));
	--create table #employeeTable (id int, displayname varchar(50), surname varchar(50), location varchar(50), type varchar(50), status varchar(50));
	IF CHARINDEX(',', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ',');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END

	IF CHARINDEX(',', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ',');	
    END
    ELSE IF LEN(@departmentFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilterList);	
    END

	IF CHARINDEX(',', @positionFilterList, 0) > 0 BEGIN
		INSERT INTO @idPositionTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@positionFilterList, ',');	
    END
    ELSE IF LEN(@positionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idPositionTable(idPosition) VALUES(@positionFilterList);	
    END		
	IF CHARINDEX(',', @employeeStatusFilter, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@employeeStatusFilter, ',');	
    END
    ELSE IF LEN(@employeeStatusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@employeeStatusFilter);	
    END
     --Insert statements for procedure here
	SELECT * FROM (
	SELECT isnull(epr.projectid,'') AS id,
	e.displayname AS person,
	e.id AS EmpID,
	isnull(p.title,'') AS position,
	isnull(p.orgunit2,'') AS division,
	isnull(p.orgunit3,'') AS department,
	isnull(c.description,'') AS costcentre,
	isnull(epr.isDeleted,'') AS status
	FROM Employee e
	INNER JOIN EmployeePosition ep ON e.id= ep.employeeid
	INNER JOIN Position p ON p.id= ep.positionid
	INNER JOIN EmployeeProject epr ON e.id= epr.EmployeeID
	INNER JOIN Projects pr ON pr.id= epr.projectid
	INNER JOIN CostCentres c ON epr.PayCostCentreID= c.id
	WHERE 	
	((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
	AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
	AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
	AND ((SELECT COUNT(*) FROM @idPositionTable) = 0 OR p.title IN (SELECT * FROM @idPositionTable))
	AND ep.primaryposition='Y' and ep.IsDeleted=0
	AND ep.vacant='N'
	AND e.IsPlaceholder!=1	
	AND epr.projectID= @projectID 
	--AND ((c.id = @clientID AND @clientID!=0) OR (@clientID=0))
UNION
	SELECT 0 AS id,
	e.displayname AS person,
	e.id AS EmpID,
	isnull(p.title,'') AS position,
	isnull(p.orgunit2,'') AS division,
	isnull(p.orgunit3,'') AS department,
	'' AS costcentre,
	0 AS status
	FROM Employee e
	INNER JOIN EmployeePosition ep ON e.id= ep.employeeid
	INNER JOIN Position p ON p.id= ep.positionid
	--LEFT OUTER JOIN (SELECT epr.employeeid FROM EmployeeProject epr WHERE epr.projectID <> @projectID
	--AND epr.employeeid NOT IN (SELECT epr.EmployeeID FROM EmployeeProject epr WHERE epr.ProjectID = @projectID)) AS temp ON e.id= temp.employeeid
	 --EmployeeProject epr ON epr.EmployeeID=e.id AND ()
	--LEFT OUTER JOIN Projects pr ON pr.id= epr.projectid
	--LEFT OUTER JOIN CostCentres c ON c.id=epr.PayCostCentreID
	WHERE 	
	((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
	AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
	AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
	AND ((SELECT COUNT(*) FROM @idPositionTable) = 0 OR p.title IN (SELECT * FROM @idPositionTable))
	AND ep.primaryposition='Y' and ep.IsDeleted=0
	AND ep.vacant='N'
	AND e.IsPlaceholder!=1			
	AND e.id NOT IN (SELECT epr.EmployeeID FROM EmployeeProject epr WHERE epr.ProjectID = @projectID)
	) AS Result
	WHERE
	Result.person LIKE '%'+@filter+'%' OR Result.position LIKE '%'+@filter+'%' OR Result.division LIKE '%'+@filter+'%' OR Result.department LIKE '%'+@filter+'%' OR Result.costcentre LIKE '%'+@filter+'%'
	ORDER BY 
		CASE WHEN ((@order=1) AND (@header='thPerson')) THEN Result.person END ASC,
		CASE WHEN ((@order=-1) AND (@header='thPerson')) THEN Result.person END DESC,

		CASE WHEN ((@order=1) AND (@header='thPos')) THEN Result.position END ASC,
		CASE WHEN ((@order=-1) AND (@header='thPos')) THEN Result.position END DESC,

		CASE WHEN ((@order=1) AND (@header='thDiv')) THEN Result.division END ASC,
		CASE WHEN ((@order=-1) AND (@header='thDiv')) THEN Result.division END DESC,

		CASE WHEN ((@order=1) AND (@header='thDept')) THEN Result.department END ASC,
		CASE WHEN ((@order=-1) AND (@header='thDept')) THEN Result.department END DESC,

		CASE WHEN ((@order=1) AND (@header='thCentre')) THEN Result.costcentre END ASC,
		CASE WHEN ((@order=-1) AND (@header='thCentre')) THEN Result.costcentre END DESC,

		CASE WHEN ((@order=1) AND (@header='thStatus')) THEN Result.status END ASC,
		CASE WHEN ((@order=-1) AND (@header='thStatus')) THEN Result.status END DESC,

		CASE WHEN ((@order=0) AND (@header='')) THEN Result.person END 
END

