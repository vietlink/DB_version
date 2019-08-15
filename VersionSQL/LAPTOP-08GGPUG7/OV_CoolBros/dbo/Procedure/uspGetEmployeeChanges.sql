/****** Object:  Procedure [dbo].[uspGetEmployeeChanges]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeChanges](@date datetime, @listDivision varchar(max), @listDepartment varchar(max), @listLocation varchar(max), @listEmployeeStatus varchar(max), @listEmployeeType varchar(max))
AS
BEGIN
	declare @divisionTable table (idDivisionTable varchar(max));
	declare @departmentTable table (idDepartmentTable varchar(max));
	declare @locationTable table (idLocationTable varchar(max));	
	declare @employeeStatusTable table (idEmployeeStatusTable varchar(max));
	declare @employeeTypeTable table (idEmployeeTypeTable varchar(max));	

	DECLARE @terminatedId int;
	SELECT @terminatedId = ID FROM [Status] WHERE Code = 'T'

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

	DECLARE @startOfYear DATETIME;
	SET @startOfYear = DATEADD(yy, DATEDIFF(yy,0,getdate()), 0);
	
	DECLARE @TotalCount int = 0;
	DECLARE @NewStartersMonth int = 0;
	DECLARE @TurnOverMonth int = 0;
	DECLARE @TurnOverUnplannedMonth int = 0;
	DECLARE @TurnOverRegrettableLossMonth int = 0;
	DECLARE @NewStartersYear int = 0;
	DECLARE @TurnOverYear int = 0;
	DECLARE @TurnOverUnplannedYear int = 0;
	DECLARE @TurnOverRegrettableLossYear int = 0;
	DECLARE @TotalYearStart int = 0;

	SELECT 
		@NewStartersMonth = COUNT(*)
	FROM 
		Employee e 
	LEFT OUTER JOIN
		EmployeePositionHistory eph
	ON
		e.id = eph.EmployeeID AND eph.primaryposition = 'Y' AND ((eph.startdate <= @date AND eph.enddate >= @date) OR (eph.startdate <= @date AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID = p.id
	WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND convert(datetime,commencement) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,commencement) <= @date AND [status] <> 'deleted'
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))

	SELECT 
		@TurnOverMonth = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime, esh.startdate) AND convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
		OR (convert(datetime,eph.startdate) <= convert(Datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID= p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate ) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,esh.StartDate ) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))


	SELECT 
		@TurnOverUnplannedMonth = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime, esh.startdate) AND convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
		OR (convert(datetime,eph.startdate) <= convert(Datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID= p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate ) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,esh.StartDate ) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		AND esh.terminationreason IN (SELECT l.value FROM TerminationReasons l WHERE l.[grouping] = 'unplanned')		
		
	SELECT 
		@TurnOverRegrettableLossMonth = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime, esh.startdate) AND convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
		OR (convert(datetime,eph.startdate) <= convert(Datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID= p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate ) >= DATEADD(month, DATEDIFF(month, 0, @date), 0) AND convert(datetime,esh.StartDate) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		AND (esh.RegrettableLoss = 'Y' or esh.RegrettableLoss = 'yes')


	SELECT 
		@NewStartersYear = COUNT(*)
	FROM 
		Employee e 
	LEFT OUTER JOIN
		EmployeePositionHistory eph
	ON
		e.id = eph.EmployeeID AND eph.primaryposition = 'Y' AND ((convert(datetime, eph.startdate) <= @date AND convert(datetime,eph.enddate) >= @date) OR (convert(datetime, eph.startdate) <= @date AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID = p.id
	WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND convert(datetime,commencement) >= DATEADD(yy, DATEDIFF(yy, 0, @date), 0) AND convert(datetime,commencement)<= @date AND [status] <> 'deleted'
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		
		
	SELECT 
		@TurnOverYear = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) AND convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
		OR (convert(Datetime,eph.startdate) <= convert(datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID= p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate) >= DATEADD(yy, DATEDIFF(yy, 0, @date), 0) AND convert(datetime,esh.StartDate) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))


	SELECT 
		@TurnOverUnplannedYear = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime, esh.startdate) AND convert(Datetime,eph.enddate) >= convert(datetime,esh.StartDate))
		 OR (convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID= p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate) >= DATEADD(yy, DATEDIFF(yy, 0, @date), 0) AND convert(datetime,esh.StartDate) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		AND esh.terminationreason IN (SELECT l.value FROM TerminationReasons l WHERE l.[grouping] = 'unplanned')
		
		
	SELECT 
		@TurnOverRegrettableLossYear = COUNT(*) 
	FROM 
		Employee e
	INNER JOIN
		EmployeeStatusHistory esh
	ON
		esh.EmployeeID = e.ID
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id= eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= convert(datetime,esh.startdate) AND convert(datetime,eph.enddate) >= convert(datetime,esh.StartDate)) 
		OR (convert(datetime,eph.startdate) <= convert(Datetime,esh.startdate) AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID = p.id
	WHERE 
		e.identifier <> 'Vacant' AND e.IsPlaceholder = 0
		AND (convert(datetime,esh.StartDate) >= DATEADD(yy, DATEDIFF(yy, 0, @date), 0) AND convert(datetime,esh.StartDate) <= @date)
			AND esh.StatusID=@terminatedId
		AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
		AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
		AND (esh.RegrettableLoss = 'Y' or esh.RegrettableLoss = 'yes')
		
		
	SELECT
		@TotalCount = COUNT(*) 
	FROM 
		Employee e
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id = eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((convert(datetime,eph.startdate) <= @date AND convert(datetime,eph.enddate) >= @date) OR (convert(datetime,eph.startdate) <= @date AND convert(datetime,eph.enddate) IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID = p.id
	WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND e.[status] <> 'Deleted'
	AND convert(datetime,commencement) <= EOMONTH(DateAdd(month, -1, @date)) AND (termination IS NULL OR convert(datetime,termination) >= EOMONTH(DateAdd(month, -1, @date)))
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))
	
	SELECT
		@TotalYearStart = COUNT(*) 
	FROM 
		Employee e
	LEFT OUTER JOIN
		EmployeePositionHistory eph 
	ON
		e.id = eph.EmployeeID AND eph.primaryposition = 'Y' AND
		((eph.startdate <= @date AND eph.enddate >= @date) OR (eph.startdate <= @date AND eph.enddate IS NULL))
	LEFT OUTER JOIN
		Position p 
	ON
		eph.PositionID = p.id
	WHERE e.identifier <> 'Vacant' AND e.IsPlaceholder = 0 AND e.[status] <> 'Deleted'
	AND commencement <= @startOfYear AND (termination IS NULL OR termination >= @startOfYear)
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @employeeTypeTable) = 0 OR isnull(e.type,'(Blank)') IN (SELECT * FROM @employeeTypeTable))


	SELECT @TotalCount as TotalCount,
	 @NewStartersMonth as NewStartersMonth,
	 @TurnOverMonth as TurnOverMonth ,
	 @TurnOverUnplannedMonth as TurnOverUnplannedMonth ,
	 @TurnOverRegrettableLossMonth as TurnOverRegrettableLossMonth ,
	 @NewStartersYear as NewStartersYear ,
	 @TurnOverYear as TurnOverYear,
	 @TurnOverUnplannedYear as TurnOverUnplannedYear ,
	 @TurnOverRegrettableLossYear as TurnOverRegrettableLossYear ,
	 @TotalYearStart as TotalYearStart
END
