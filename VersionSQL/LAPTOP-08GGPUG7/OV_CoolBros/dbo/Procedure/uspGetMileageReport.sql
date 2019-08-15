/****** Object:  Procedure [dbo].[uspGetMileageReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMileageReport] 
	-- Add the parameters for the stored procedure here
	@managerID int, @employeeID int, @permission bit, @fromDate datetime, @toDate datetime, @statusList varchar(max), @isPaidInclude bit, @divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @groupBy varchar(max), @sortBy varchar(max), @empIdList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @locationTable TABLE(location varchar(max));
	DECLARE @empIdTable TABLE(_id int);
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
	

	IF CHARINDEX(',', @divisionList, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionList, ',');	
    END
    ELSE IF LEN(@divisionList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(division) VALUES(@divisionList);	
    END
	
	IF CHARINDEX(',', @departmentList, 0) > 0 BEGIN
		INSERT INTO @departmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentList, ',');	
    END
    ELSE IF LEN(@departmentList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @departmentTable(department) VALUES(@departmentList);	
    END

	IF CHARINDEX(';', @locationList, 0) > 0 BEGIN
		INSERT INTO @locationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationList, ';');	
    END
    ELSE IF LEN(@locationList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @locationTable(location) VALUES(@locationList);	
    END

	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusList);	
    END	

	IF CHARINDEX(',', @empIdList, 0) > 0 BEGIN
		INSERT INTO @empIdTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@empIdList, ',');	
    END
    ELSE IF LEN(@empIdList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empIdTable(_id) VALUES(@empIdList);	
    END	
	--IF CHARINDEX(',', @statusFilter, 0) > 0 BEGIN
	--	INSERT INTO @employeeStatusTable-- split the text by , and store in temp table
	--	SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusFilter, ',');	
 --   END
 --   ELSE IF LEN(@statusFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
	--	INSERT INTO @employeeStatusTable(employeeStatus) VALUES(@statusFilter);	
 --   END	
    -- Insert statements for procedure here
SELECT * FROM(
	SELECT e.id,
	e.displayname AS name,
	e.surname AS surname,
	isnull(p.title,'(Blank)') AS title,
	isnull(p.orgunit2,'(Blank)') as posorgunit2,
	isnull(p.orgunit3,'(Blank)') as posorgunit3,
	e.location,
	
	ecd.ExpenseDate,
	ecd.Description,
	ecd.Source,
	ecd.Destination,
	ecd.StartMileage,
	ecd.EndMileage,
	ecd.TotalMileage,
	ecd.CompanyTravelRate,
	ecd.ExpenseAmount,
	dbo.fnGetExpenseItemStatus(ecd.ID) AS status,
	es.Description AS status1,
	c.Description AS centre,
	isnull(ecd.PayCycleID,0) as PayCycleID
	FROM ExpenseClaimDetail ecd
	INNER JOIN ExpenseClaimHeader ech ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID = es.ID
	INNER JOIN CostCentres c ON ecd.CostCentreID = c.ID
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	WHERE ((e.id= @employeeID AND @employeeID!=0) OR @employeeID=0)
	--AND (((e.id IN (SELECT * FROM dbo.fnGetEmployeeIDByManagerID(@managerID)) OR e.id=@managerID) AND @managerID!=0) OR (@managerID=0) OR (@permission=1))
	AND (ecd.ExpenseDate >= @fromDate AND ecd.ExpenseDate <=@toDate)
	AND ecd.Source is not null 
	AND ((@isPaidInclude=0 AND ecd.PayCycleID is null) OR (@isPaidInclude=1))

	AND (dbo.fnGetExpenseItemStatusCode(ecd.ID) IN (SELECT * FROM @statusTable))		
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(P.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(P.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(E.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND (@empIdList='0' OR E.id IN (SELECT * FROM @empIdTable))
	) AS Result
	ORDER BY		
		CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,
		CASE WHEN @groupBy = 'location' THEN Result.location END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		
		CASE WHEN @groupBy = 'status' THEN Result.status END,		
		CASE WHEN @groupBy = 'centre' THEN Result.centre END,	
		CASE WHEN @groupBy = 'name' THEN Result.name END,	
		
		CASE WHEN @sortBy = 'amount' THEN Result.ExpenseAmount END DESC,
		CASE WHEN @sortBy = 'date_asc' THEN Result.ExpenseDate  END ASC,		
		CASE WHEN @sortBy = 'date_desc' THEN Result.ExpenseDate END DESC,		
		CASE WHEN @sortBy = 'name' THEN Result.name END,		
		CASE WHEN @sortBy = 'surname' THEN Result.surname END
				
END

