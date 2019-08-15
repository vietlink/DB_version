/****** Object:  Procedure [dbo].[uspGetAgeInfo]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAgeInfo](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
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
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT
		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id 
		inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.dob, @date)<7765
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge1,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID left outer join Position p on eph.PositionID=p.id 
		inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and DATEDIFF(day, e.dob, @date)>=7765 and DATEDIFF(day, e.dob, @date)<10950
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge2,

		(SELECT COUNT(distinct e.id) FROM Employee e
		 left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		 left outer join Position p on eph.PositionID=p.id 
		 inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND e.IsDeleted = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=10950 and DATEDIFF(day, e.dob, @date)<14600
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge3,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		left outer JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=14600 and DATEDIFF(day, e.dob, @date)<18250
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge4, 

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=18250 and DATEDIFF(day, e.dob, @date)<21900
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge5,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=21900
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge6,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and isnull(e.dob,'')=''
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS TotalAge7,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		left outer join Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.dob, @date)<7765
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge1,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=7765 and DATEDIFF(day, e.dob, @date)<10950
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge2,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=10950 and DATEDIFF(day, e.dob, @date)<14600
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge3,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=14600 and DATEDIFF(day, e.dob, @date)<18250
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge4,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=18250 and DATEDIFF(day, e.dob, @date)<21900
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge5,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and eph.primaryposition='Y'
		and datediff(day, e.dob, @date)>=21900
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge6,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'male' or gender = 'm') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and isnull(e.dob, '')=''
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS MaleAge7,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		 WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.dob, @date)<7765
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge1,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=7765 and DATEDIFF(day, e.dob, @date)<10950
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge2,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=10950 and DATEDIFF(day, e.dob, @date)<14600
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge3,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=14600 and DATEDIFF(day, e.dob, @date)<18250
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge4,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(Datetime,esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=18250 and DATEDIFF(day, e.dob, @date)<21900
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge5,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime, esh.StartDate) and ISNULL(convert(Datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=21900
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge6,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (gender = 'female' or gender = 'f') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime,esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and isnull(e.dob, '')=''
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS FemaleAge7,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		 WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		 and @date between convert(datetime, esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and DATEDIFF(day, e.dob, @date)<7765
		and eph.primaryposition='Y'
		 and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge1,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=7765 and DATEDIFF(day, e.dob, @date)<10950
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge2,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime,esh.StartDate) and ISNULL(convert(datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=10950 and DATEDIFF(day, e.dob, @date)<14600
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge3,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(datetime, esh.StartDate) and ISNULL(convert(Datetime,esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=14600 and DATEDIFF(day, e.dob, @date)<18250
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge4,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime, esh.StartDate) and ISNULL(convert(Datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=18250 and DATEDIFF(day, e.dob, @date)<21900
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge5,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime,esh.StartDate) and ISNULL(convert(Datetime, esh.EndDate), GETDATE())		
		and datediff(day, e.dob, @date)>=21900
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge6,

		(SELECT COUNT(distinct e.id) FROM Employee e 
		LEFT OUTER JOIN EmployeePositionHistory eph on e.id=eph.EmployeeID 
		LEFT OUTER JOIN Position p on eph.PositionID=p.id inner join EmployeeStatusHistory esh on esh.EmployeeID=e.id inner join Status s on esh.StatusID=s.Id
		WHERE (ISNULL(gender,'')='') AND e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND (s.Code!='D' AND s.Code!='T')
		and @date between convert(Datetime, esh.StartDate) and ISNULL(convert(datetime,esh.EndDate), GETDATE())		
		and isnull (e.dob, '')=''
		and eph.primaryposition='Y'
		and (eph.id = dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id) or (dbo.fnGetEmpPositionIDInPeriod(@date, @date, e.id)=0))
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
		AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
		AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeStatusTable) = 0 OR e.status IN (SELECT * FROM @employeeStatusTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type, '(Blank)') IN (SELECT * FROM @employeeTypeTable))) AS OtherAge7
END
