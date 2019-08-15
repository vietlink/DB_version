/****** Object:  Procedure [dbo].[uspGetExpenseReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseReport] 
	-- Add the parameters for the stored procedure here
	@managerID int, @employeeID int, @permission bit, @fromDate datetime, @toDate datetime, @statusList varchar(max), @isPaidInclude bit, 
	@divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @costCentreList varchar(max), @expenseCodeList varchar(max), @empStatus varchar(max),
	@groupBy varchar(max), @sortBy varchar(max), @cycleID int, @empIdList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @locationTable TABLE(location varchar(max));
	DECLARE @costCentreTable TABLE(costcentre varchar(max));
	DECLARE @expenseCodeTable TABLE(expensecode varchar(max));
	DECLARE @empStatusTable TABLE(status varchar(max));
	DECLARE @empIdTable TABLE(_id varchar(max));
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
	IF (@cycleID !=0) BEGIN
		SET @fromDate = (SELECT p.FromDate FROM PayrollCycle p WHERE p.ID=@cycleID)
		SET @toDate = (SELECT p.ToDate FROM PayrollCycle p WHERE p.ID= @cycleID)
	END

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

	IF CHARINDEX(',', @empStatus, 0) > 0 BEGIN
		INSERT INTO @empStatusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@empStatus, ',');	
    END
    ELSE IF LEN(@empStatus) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empStatusTable(status) VALUES(@empStatus);	
    END	

	IF CHARINDEX(',', @costCentreList, 0) > 0 BEGIN
		INSERT INTO @costCentreTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@costCentreList, ',');	
    END
    ELSE IF LEN(@costCentreList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @costCentreTable(costcentre) VALUES(@costCentreList);	
    END	

	IF CHARINDEX(',', @expenseCodeList, 0) > 0 BEGIN
		INSERT INTO @expenseCodeTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@expenseCodeList, ',');	
    END
    ELSE IF LEN(@expenseCodeList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @expenseCodeTable(expensecode) VALUES(@expenseCodeList);	
    END	
	IF CHARINDEX(',', @empIdList, 0) > 0 BEGIN
		INSERT INTO @empIdTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@empIdList, ',');	
    END
    ELSE IF LEN(@empIdList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empIdTable(_id) VALUES(@empIdList);	
    END
    -- Insert statements for procedure here
SELECT * FROM(
	SELECT e.id,
	e.displayname AS name,
	isnull(e.surname,'') AS surname,
	isnull(e.location,'') AS location,
	isnull(p.title,'') AS title,
	isnull(p.orgunit2,'') AS posorgunit2,
	isnull(p.orgunit3,'') AS posorgunit3,
	ecd.ExpenseDate,
	ecd.Description,
	ecd.ExpenseAmount,
	ecd.TaxAmount,
	dbo.fnGetExpenseClaimApprover(ep.id) as Approver ,
	dbo.fnGetExpenseItemStatus(ecd.ID) AS status,
	(es.Description) AS status1,
	c.Description AS costCentre,
	ec.Description AS expenseCode,
	ech.id AS expenseHeaderID
	FROM ExpenseClaimDetail ecd
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID = es.ID
	INNER JOIN ExpenseClaimHeader ech ON ecd.ExpenseClaimHeaderID= ech.ID
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	INNER JOIN CostCentres c ON ecd.CostCentreID = c.ID
	INNER JOIN ExpenseCode ec ON ecd.ExpenseCodeID  = ec.ID
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid = p.id,
	ExpenseClaimSettings ecs
	WHERE ((e.id= @employeeID AND @employeeID!=0) OR @employeeID=0)
	--AND ((ech.PayCycleID= @cycleID AND @cycleID!=0) OR (@cycleID=0))
	AND (ecd.ExpenseDate >= @fromDate AND ecd.ExpenseDate <=@toDate)
	AND ecd.Source is null 
	AND ((@isPaidInclude=0 AND ech.PayCycleID is null) OR (@isPaidInclude=1))
	AND ecd.CostCentreExpenseFlag = ecs.CostCentreReqFlag
	AND (es.Code IN (SELECT * FROM @statusTable))		
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(P.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))
	AND ((SELECT COUNT(*) FROM @costCentreTable) = 0 OR c.Description IN (SELECT * FROM @costCentreTable))
	AND ((SELECT COUNT(*) FROM @expenseCodeTable) = 0 OR ec.Description IN (SELECT * FROM @expenseCodeTable))
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(P.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(E.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @empStatusTable) = 0 OR E.status IN (SELECT * FROM @empStatusTable))
	AND (@empIdList='0' OR E.id IN (SELECT * FROM @empIdTable))
	) AS Result
	ORDER BY		
		CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,
		CASE WHEN @groupBy = 'location' THEN Result.location END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		
		CASE WHEN @groupBy = 'status' THEN Result.status END,		
		CASE WHEN @groupBy = 'costCentre' THEN Result.costCentre END,	
		CASE WHEN @groupBy = 'expenseCode' THEN Result.expenseCode END,	
		CASE WHEN @groupBy = 'name' THEN Result.name END,	
		
		CASE WHEN @sortBy = 'amount' THEN Result.ExpenseAmount END DESC,
		CASE WHEN @sortBy = 'date_asc' THEN Result.ExpenseDate  END ASC,		
		CASE WHEN @sortBy = 'date_desc' THEN Result.ExpenseDate END DESC,		
		CASE WHEN @sortBy = 'name' THEN Result.name END,		
		CASE WHEN @sortBy = 'surname' THEN Result.surname END
END

