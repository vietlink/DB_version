/****** Object:  Procedure [dbo].[uspGetEmployeeListing]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeListing](@search varchar(max), @statusList varchar(max), @typeList varchar(max), @divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @filterPlaceholders bit = 0, @sortBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	
	declare @employeeTypeTable table(employeeType varchar(max));
	declare @employeeStatusTable table(employeeStatus varchar(max));
	--create table #employeeTable (id int, displayname varchar(50), surname varchar(50), location varchar(50), type varchar(50), status varchar(50));
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

	
	IF CHARINDEX(',', @typeList, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@typeList, ',');	
    END
    ELSE IF LEN(@typeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(employeeType) VALUES(@typeList);	
    END	

	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@statusList);	
    END		

    SELECT
		e.id,
		isnull(rsEp.id, isnull(rsEp2.id, 0)) as EmpPosId,
		isnull(rsEp.positionid, isnull(rsEp2.Positionid, 0)) as positionid,
		e.DisplayName,
		e.Identifier,
		e.[Status],
		ec.workemail,
		isnull(p.title, 'Unassigned') as positiontitle,
		e.location,
		e.[type],
		p.orgunit2 as posorgunit2,
		p.orgunit3 as posorgunit3
	FROM
		Employee e
	OUTER APPLY	
		(SELECT TOP 1 * FROM EmployeePosition ep WHERE ep.employeeid = e.id and ep.IsDeleted = 0
		ORDER BY ep.primaryposition desc) rsEp
	OUTER APPLY	
		(SELECT TOP 1 * FROM EmployeePosition ep WHERE ep.employeeid = e.id and ep.primaryposition = 'y'
		ORDER BY ep.id desc) rsEp2
	LEFT OUTER JOIN
		Position p
	ON
		p.id = isnull(rsEp.positionid, rsEp2.positionid)
	INNER JOIN
		EmployeeContact ec
	ON
		ec.employeeid = e.id
	WHERE
		(displayname LIKE '%' + @search + '%' OR firstname  LIKE '%' + @search + '%' OR surname  LIKE '%' + @search + '%' OR firstnamepreferred  LIKE '%' + @search + '%' OR [status] LIKE '%' + @search + '%' OR e.Identifier LIKE '%' + @search + '%' OR p.title LIKE '%' + @search + '%')
		AND
		((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR e.type IN (SELECT * FROM @employeeTypeTable))	
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))
		AND
		((@filterPlaceholders = 0 AND e.IsPlaceholder = 0) OR (@filterPlaceholders = 1 AND e.IsPlaceholder = 1))
		--AND
		--((@onlyShowManagers = 0 OR (@onlyShowManagers = 1 AND (SELECT COUNT(eph.id) FROM EmployeePositionHistory eph INNER JOIN EmployeePosition _mep ON _mep.id = eph.ManagerID INNER JOIN Employee _me ON _me.id = _mep.employeeid  WHERE _me.id = e.id) > 0)))
	ORDER BY 
		CASE WHEN @sortBy = 'posorgunit3' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'posorgunit2' THEN p.orgunit2 END,
		CASE WHEN @sortBy = 'location' THEN e.location END,
		CASE WHEN @sortBy = 'empid' THEN e.identifier END,
		CASE WHEN @sortBy = 'name' THEN e.firstname END,
		CASE WHEN @sortBy = 'status' THEN e.status END,
		CASE WHEN @sortBy = 'surname' THEN e.surname END,
		CASE WHEN @sortBy = 'title' THEN p.title END,
		CASE WHEN @sortBy = 'type' THEN e.type END,
	Surname
END
