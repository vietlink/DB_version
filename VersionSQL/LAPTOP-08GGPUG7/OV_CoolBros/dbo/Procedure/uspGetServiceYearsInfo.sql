/****** Object:  Procedure [dbo].[uspGetServiceYearsInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetServiceYearsInfo](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
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

	SELECT
		(SELECT COUNT(distinct e.id) FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id 
		inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id 
		inner join Status s on esh.StatusID= s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		--AND e.IsDeleted = 0 
		AND (termination IS NULL OR termination > @date) 
		--AND (commencement >= DateAdd(YEAR, -1, @date) AND commencement <= @date)
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and DATEDIFF(day, e.commencement, @date)<365
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalCount1,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id 
		inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		--AND (commencement >= DateAdd(YEAR, -2, @date) AND commencement < DateAdd(YEAR, -1, @date))
		and @date between CONVERT(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=365 and DATEDIFF(day, e.commencement, @date)<720
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalCount2,

		(SELECT COUNT(distinct e.id) FROM 
		Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=720 and DATEDIFF(day, e.commencement, @date)<1825
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalCount3,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		--AND (commencement >= DateAdd(YEAR, -10, @date) AND commencement < DateAdd(YEAR, -5, @date))
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=1825 and DATEDIFF(day, e.commencement, @date)<3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalCount4,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=3650 
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalCount5,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'male' or gender ='m') AND e.identifier <> 'Vacant' and e.IsPlaceholder=0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)<365
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleCount1,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'male' or gender ='m') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 
		--AND e.IsDeleted = 0
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(Datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=365 and DATEDIFF(day, e.commencement, @date)<720
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleCount2,
		(SELECT COUNT(distinct e.id) 
		FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'male' or gender ='m') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=720 and DATEDIFF(day, e.commencement, @date)<1825
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleCount3,
		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'male' or gender ='m') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(Datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=1825 and DATEDIFF(day, e.commencement, @date)<3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleCount4,
		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'male' or gender ='m') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between esh.StartDate and ISNULL(esh.EndDate, GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleCount5,

		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id 
		inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'female' or gender ='f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between esh.StartDate and ISNULL(esh.EndDate, GETDATE())		
		and DATEDIFF(day, e.commencement, @date)<365
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleCount1,
		(SELECT COUNT(distinct e.id) FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'female' or gender ='f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=365 and DATEDIFF(day, e.commencement, @date)<720
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleCount2,
		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'female' or gender ='f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and eph.primaryposition='Y'
		--AND e.IsDeleted = 0 
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(Datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=720 and DATEDIFF(day, e.commencement, @date)<1825
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleCount3,
		(SELECT COUNT(distinct e.id) 
		FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'female' or gender ='f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())				
		and DATEDIFF(day, e.commencement, @date)>=1825 and DATEDIFF(day, e.commencement, @date)<3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleCount4,
		(SELECT COUNT(distinct e.id) 
		FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (gender = 'female' or gender ='f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())				
		and DATEDIFF(day, e.commencement, @date)>=3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleCount5,
		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (isnull(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())			
		and DATEDIFF(day, e.commencement, @date)<365
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherCount1,

		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (isnull(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())			
		and DATEDIFF(day, e.commencement, @date)>=365 and DATEDIFF(day, e.commencement, @date)<720
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherCount2,

		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (isnull(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())				
		and DATEDIFF(day, e.commencement, @date)>=720 and DATEDIFF(day, e.commencement, @date)<1825
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherCount3,

		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (isnull(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0
		and eph.primaryposition='Y'
		 AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())			
		and DATEDIFF(day, e.commencement, @date)>=1825 and DATEDIFF(day, e.commencement, @date)<3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherCount4,

		(SELECT COUNT(distinct e.id) FROM Employee e left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID= s.Id
		WHERE (isnull(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		--AND e.IsDeleted = 0 
		and eph.primaryposition='Y'
		AND (termination IS NULL OR termination > @date) 
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.commencement, @date)>=3650
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
				AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
				AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.Status IN (SELECT * FROM @employeeStatusTable))
				AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherCount5
END
