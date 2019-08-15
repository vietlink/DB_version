/****** Object:  Procedure [dbo].[uspGetHeadCountTable]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetHeadCountTable](@currentMonth datetime, @yearStart datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
AS
BEGIN
	declare @divisionTable table (idDivisionTable varchar(max));
	declare @departmentTable table (idDepartmentTable varchar(max));
	declare @locationTable table (idLocationTable varchar(max));	
	declare @employeeStatusTable table (idEmployeeStatusTable varchar(max));
	declare @employeeTypeTable table (idEmployeeTypeTable varchar(max));	

	IF CHARINDEX(',', @listDivision, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listDivision, ',');	
    END
    ELSE IF LEN(@listDivision) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(idDivisionTable) VALUES(@listDivision);	
    END

	IF CHARINDEX(',', @listDepartment, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listDepartment, ',');	
    END
    ELSE IF LEN(@listDepartment) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(idDepartmentTable) VALUES(@listDepartment);	
    END

	IF CHARINDEX(';', @listLocation, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listLocation, ';');	
    END
    ELSE IF LEN(@listLocation) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(idLocationTable) VALUES(@listLocation);	
    END
	
	IF CHARINDEX(',', @listEmployeeType, 0) > 0 BEGIN
		INSERT INTO @employeeTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listEmployeeType, ',');	
    END
    ELSE IF LEN(@listEmployeeType) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeTypeTable(idEmployeeTypeTable) VALUES(@listEmployeeType);	
    END	

	IF CHARINDEX(',', @listEmployeeStatus, 0) > 0 BEGIN
		INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@listEmployeeStatus, ',');	
    END
    ELSE IF LEN(@listEmployeeStatus) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @employeeStatusTable(idEmployeeStatusTable) VALUES(@listEmployeeStatus);	
    END	
	SET NOCOUNT ON;
	DECLARE @dividerBlankYear int;
	DECLARE @dividerBlankMonth int;
	DECLARE @dividerMaleYear int;
	DECLARE @dividerMaleMonth int;
	DECLARE @dividerFemaleYear int;
	DECLARE @dividerFemaleMonth int;
	DECLARE @dividerFemalePercent int;
	DECLARE @dividerMalePercent int;
	DECLARE @dividerBlankPercent int;

	-- Blank dividers
	SELECT @dividerBlankYear = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
			Inner join Status s on esh.StatusID=s.Id
		WHERE 
			(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
			AND (s.Code!='D' AND s.Code!='T')
			AND convert(datetime, esh.StartDate) < @yearStart
			and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	SELECT @dividerBlankMonth = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
			inner join Status s on esh.StatusID= s.Id
		WHERE 
			(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND convert(datetime,esh.StartDate) BETWEEN DATEADD(month, DATEDIFF(month, 0, @currentMonth), 0) AND EOMONTH(@currentMonth)
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	-- Male dividers
	SELECT @dividerMaleYear = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID= s.Id
		WHERE 
			(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND CONVERT(datetime, esh.StartDate) < @yearStart
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	SELECT @dividerMaleMonth = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID= s.Id
		WHERE 
			(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND convert(datetime, esh.StartDate) BETWEEN DATEADD(month, DATEDIFF(month, 0, @currentMonth), 0) AND EOMONTH(@currentMonth)
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	-- Female dividers
	SELECT @dividerFemaleYear = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID= s.Id
		WHERE 
			(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND convert(datetime,esh.StartDate) < @yearStart
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	SELECT @dividerFemaleMonth = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID= s.Id
		WHERE 
			(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND convert(datetime,esh.StartDate) BETWEEN DATEADD(month, DATEDIFF(month, 0, @currentMonth), 0) AND EOMONTH(@currentMonth)
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	-- Total blank gender employees
	SELECT @dividerBlankPercent = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID=s.Id
		WHERE 
		(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (s.Code!='D' AND s.Code!='T')
		and eph.primaryposition='Y'
			AND	@currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	-- Total male gender employees
	SELECT @dividerMalePercent = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusId= s.Id
		WHERE 
			(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND	@currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	-- Total female gender employees
	SELECT @dividerFemalePercent = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id
		inner join Status s on esh.StatusID= s.Id
		WHERE 
			(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND	@currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	DECLARE @totalCount int;
	SELECT @totalCount = ISNULL(CAST(
	(
		SELECT
			COUNT(distinct e.id)
		FROM
			Employee e
			left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
		INNER JOIN
			EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
			inner join Status s on esh.StatusId= s.Id
		WHERE 
			e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
			AND (s.Code!='D' AND s.Code!='T')
			and eph.primaryposition='Y'
			AND	@currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
			and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
			AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
			AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
			AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
	) as decimal), 0.0);

	DECLARE @blankNewMonth decimal
	SET @blankNewMonth = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join Status s on esh.StatusID= s.Id
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id			
					inner join Status s on esh.StatusID=s.Id	
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth, -1) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
						AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
	)

	DECLARE @maleNewMonth decimal
	SET @maleNewMonth = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
					inner join Status s on esh.StatusID=s.Id
				
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
					inner join 
					Status s on esh.StatusID= s.Id		
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					 AND EOMONTH(@currentMonth, - 1) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
	)

	DECLARE @femaleNewMonth decimal
	SET @femaleNewMonth = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				INNER JOIN
					[status] s
				ON
					s.id = esh.StatusID
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime, esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				INNER JOIN
					[status] s
				ON
					s.id = esh.StatusID
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND e.IsPlaceholder = 0 AND EOMONTH(@currentMonth, - 1) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
	)
	--

	DECLARE @blankNewYear int;

	SET @blankNewYear = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				INNER JOIN
					[status] s
				ON
					s.id = esh.StatusID
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join Status s on esh.StatusID= s.Id
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
	)

	DECLARE @maleNewYear int;

	SET @maleNewYear = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				INNER JOIN
					[status] s
				ON
					s.id = esh.StatusID
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join Status s on esh.StatusID=s.Id
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					 AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
	)

	--

	DECLARE @femaleNewYear int;

	SET @femaleNewYear = (
		SELECT
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join Status s on esh.StatusID=s.Id
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					AND EOMONTH(@currentMonth) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and eph.primaryposition='Y'
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
		as decimal), 0.0)
		- 
		ISNULL(CAST(
			(
				SELECT
					COUNT(distinct e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join Status s on esh.StatusID= s.Id
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					 AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
					AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
					AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))

			)
		as decimal), 0.0)
	)

	SELECT
		--- Female Section ---
		@dividerFemalePercent as FemaleCount,
		CAST(CASE WHEN @dividerFemalePercent IS NOT NULL AND @totalCount > 0 THEN
			(@dividerFemalePercent * 100) / @totalCount
		ELSE
			0.0
		END as decimal) as FemalePercent,
		(
			SELECT
				ISNULL(SUM(ep.fte), 0.0)
			FROM
				Employee e
			left outer join EmployeePositionHistory ep on e.id= ep.employeeid
			left outer join position p on ep.positionid= p.id
			INNER JOIN
				EmployeeStatusHistory esh ON esh.EmployeeID = e.id	
				inner join Status s on esh.StatusId= s.Id		
			WHERE 
				(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND p.IsPlaceholder = 0 AND e.IsPlaceholder = 0
				AND (s.Code!='D' AND s.Code!='T')
				and ep.primaryposition='Y'
				and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
				AND p.IsUnassigned = 0 AND @currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
		) as FemaleFTE,
		@femaleNewMonth as FemaleNewMonth,
		(
			SELECT ISNULL((@femaleNewMonth * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
				inner join Status s on esh.statusID= s.id		
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND EOMONTH(@currentMonth, - 1) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime, esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as FemaleNewMonthPercent,
		@femaleNewYear as FemaleNewYear,
		(
			SELECT ISNULL((@femaleNewYear * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join EmployeePositionHistory eph on e.id= eph.employeeid
			left outer join position p on eph.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id	
					inner join Status s on esh.statusID= s.id				
				WHERE 
					(gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
					AND (s.Code!='D' AND s.Code!='T')
					and eph.primaryposition='Y'
					AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as FemaleNewYearPercent,

		--- Male Section ---
		@dividerMalePercent as MaleCount,
		CAST(CASE WHEN @dividerMalePercent IS NOT NULL AND @totalCount > 0 THEN
			(@dividerMalePercent * 100) / @totalCount
		ELSE
			0.0
		END as decimal) as MalePercent,
		(
			SELECT
				ISNULL(SUM(ep.fte), 0.0)
			FROM
				Employee e
			left outer join EmployeePositionHistory ep on e.id= ep.employeeid
			left outer join position p on ep.positionid= p.id
			INNER JOIN
				EmployeeStatusHistory esh ON esh.EmployeeID = e.id			
				inner join Status s on esh.StatusID= s.Id
			WHERE 
				(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND p.IsPlaceholder = 0 AND e.IsPlaceholder = 0
				AND (s.Code!='D' AND s.Code!='T')
				and ep.primaryposition='Y'
				and ep.id = (select max(id) from EmployeePositionHistory _ep where _ep.employeeid = e.id and _ep.primaryposition='Y' and @currentMonth between _ep.startdate and isnull(_ep.enddate, GETDATE()))
				AND p.IsUnassigned = 0 AND @currentMonth BETWEEN esh.StartDate AND ISNULL(esh.EndDate, '2222-01-01')
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
		) as MaleFTE,
		@MaleNewMonth as MaleNewMonth,
		(
			SELECT ISNULL((@MaleNewMonth * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join employeepositionhistory ep on e.id= ep.employeeid
					left outer join position p on ep.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join status s on esh.statusID= s.id
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and ep.primaryposition='Y'
					AND EOMONTH(@currentMonth, - 1) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as MaleNewMonthPercent,
		@MaleNewYear as MaleNewYear,
		(
			SELECT ISNULL((@MaleNewYear * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join employeepositionhistory ep on e.id= ep.employeeid
					left outer join position p on ep.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id
				inner join status s on esh.statusID= s.id
				WHERE 
					(gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and ep.primaryposition='Y'
					AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
					and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as MaleNewYearPercent,

		--- Blank Section ---
		@dividerBlankPercent as BlankCount,
		CAST(CASE WHEN @dividerBlankPercent IS NOT NULL AND @totalCount > 0 THEN
			(@dividerBlankPercent * 100) / @totalCount
		ELSE
			0.0
		END as decimal) as BlankPercent,
		(
			SELECT
				ISNULL(SUM(ep.fte), 0.0)
			FROM
				Employee e

			left outer JOIN
				EmployeePositionHistory ep
			ON
				ep.EmployeeID = e.ID
			left outer JOIN
				Position p
			ON
				ep.PositionID = p.id
			INNER JOIN
				EmployeeStatusHistory esh ON esh.EmployeeID = e.id
			INNER JOIN
				[status] s
			ON
				s.id = esh.StatusID
			WHERE 
				(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND p.IsPlaceholder = 0 AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
				and ep.primaryposition='Y'
				and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
				AND p.IsUnassigned = 0 AND @currentMonth BETWEEN convert(datetime,esh.StartDate) AND ISNULL(convert(datetime,esh.EndDate), '2222-01-01')
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
		) as BlankFTE,
		@BlankNewMonth as BlankNewMonth,
		(
			SELECT ISNULL((@BlankNewMonth * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join employeepositionhistory ep on e.id= ep.employeeid
					left outer join position p on ep.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id				
					inner join status s on esh.statusID= s.id
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					and ep.primaryposition='Y'
					AND EOMONTH(@currentMonth, - 1) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(Datetime, esh.EndDate), '2222-01-01')
					and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))
					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as BlankNewMonthPercent,
		@BlankNewYear as BlankNewYear,
		(
			SELECT ISNULL((@BlankNewYear * 100) / NULLIF(CAST(
			(
				SELECT
					COUNT(e.id)
				FROM
					Employee e
					left outer join employeepositionhistory ep on e.id= ep.employeeid and ep.primaryposition='Y'
					left outer join position p on ep.positionid= p.id
				INNER JOIN
					EmployeeStatusHistory esh ON esh.EmployeeID = e.id		
					inner join status s on esh.statusID= s.id			
				WHERE 
					(ISNULL(gender, '') = '') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
					AND DATEADD(DD, -1, DATEADD(YY,DATEDIFF(yy,0,@currentMonth),0)) BETWEEN convert(datetime, esh.StartDate) AND ISNULL(convert(datetime, esh.EndDate), '2222-01-01')
										and (ep.id = dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@currentMonth, @currentMonth, e.id)=0))

					AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3, '(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2, '(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location, '(Blank)') IN (SELECT * FROM @locationTable))
					AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
					AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))
			)
			as decimal), 0.0), 100)
		) as BlankNewYearPercent
END
