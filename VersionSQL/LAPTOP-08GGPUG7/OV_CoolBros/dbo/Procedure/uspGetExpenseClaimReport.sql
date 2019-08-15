/****** Object:  Procedure [dbo].[uspGetExpenseClaimReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseClaimReport] 
	-- Add the parameters for the stored procedure here
	@managerID int, @employeeID int, @permission bit, @fromDate datetime, @toDate datetime, @statusList varchar(max), @isPaidInclude bit, 
	@divisionList varchar(max), @departmentList varchar(max), @locationList varchar(max), @empStatus varchar(max),
	@groupBy varchar(max), @sortBy varchar(max), @empIdList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @locationTable TABLE(location varchar(max));
	DECLARE @empStatusTable TABLE(status varchar(max));
	DECLARE @empIdTable TABLE(_id varchar(max));
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
	
	IF CHARINDEX(',', @empStatus, 0) > 0 BEGIN
		INSERT INTO @empStatusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@empStatus, ',');	
    END
    ELSE IF LEN(@empStatus) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empStatusTable(status) VALUES(@empStatus);	
    END

	IF CHARINDEX(',', @empIdList, 0) > 0 BEGIN
		INSERT INTO @empIdTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@empIdList, ',');	
    END
    ELSE IF LEN(@empIdList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @empIdTable(_id) VALUES(@empIdList);	
    END
    -- Insert statements for procedure here
SELECT * FROM (
	SELECT ech.ID AS ExpenseHeaderID,
	ech.Description AS headerDescription,
	ech.ExpenseClaimDate AS headerClaimDate,
	dbo.fnGetSumExpenseHeader(ech.ID) as headerAmount,
	dbo.fnGetExpenseHeaderStatus(ech.id) AS headerStatus,
	es.Description AS headerStatus1,
	dbo.fnGetSumTaxExpenseHeader(ech.id) AS headerTax, 
	dbo.fnCountExpenseDetailbyHeaderID(ech.id) AS detailCount,
	ecd.Description AS detailDescription,
	ecd.ExpenseDate AS detailDate,
	ecd.ExpenseAmount AS detailAmount,
	isnull(ecd.TaxAmount,0) AS detailTax,
	dbo.fnGetExpenseClaimApprover(ep.id) as Approver ,
	--dbo.fnGetExpenseItemStatus(ecd.id) 
	es_d.Description
	--dbo.fnGetExpenseItemStatus(ecd.ID) 
	AS detailStatus,
	e.id AS empID,
	e.displayname AS name, 
	e.surname,
	ISNULL(e.location, '') AS location,
	ISNULL(p.title,'') AS title,
	ISNULL(p.orgunit2,'') AS posorgunit2,
	ISNULL(p.orgunit3,'') AS posorgunit3
	FROM 
	ExpenseClaimHeader ech
	INNER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es_d ON ecd.ExpenseStatusID= es_d.ID	
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID	
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id, ExpenseClaimSettings ecs
	WHERE ((e.id= @employeeID AND @employeeID!=0) OR @employeeID=0)
	--AND ((((e.id IN (SELECT * FROM dbo.fnGetEmployeeIDByManagerID(@managerID))) OR e.id=@managerID) AND @managerID!=0) OR (@managerID=0) OR (@permission=1))
	AND (ech.ExpenseClaimDate>= @fromDate AND ech.ExpenseClaimDate<=@toDate)	
	AND ((@isPaidInclude=0 AND ech.PayCycleID is null) OR (@isPaidInclude=1))
	AND ecd.CostCentreExpenseFlag = ecs.CostCentreReqFlag
	AND (dbo.fnGetExpenseHeaderStatusCode(ech.ID) IN (SELECT * FROM @statusTable))		
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(P.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))	
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(P.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(E.location,'(Blank)') IN (SELECT * FROM @locationTable))
	AND ((SELECT COUNT(*) FROM @empStatusTable) = 0 OR E.status IN (SELECT * FROM @empStatusTable))
	AND (@empIdList='0' OR E.id IN (SELECT * FROM @empIdTable))
	) AS Result
	--group by Result.ExpenseHeaderID, Result.headerDescription, Result.headerClaimDate, Result.headerAmount, Result.headerStatus, Result.headerTax, Result.detailDescription, Result.detailDate, Result.detailAmount,
	--Result.detailTax, Result.detailStatus, Result.empID, Result.empName, Result.empLocation, Result.posorgunit2, Result.posorgunit3, Result.detailCount, Result.Approver, Result.surname, Result.title
	ORDER BY	
		
		CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,
		CASE WHEN @groupBy = 'location' THEN Result.location END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		
		CASE WHEN @groupBy = 'headerStatus' THEN Result.headerStatus END,				
		CASE WHEN @groupBy = 'name' THEN Result.name END,	
		--case when @groupBy='select' THEN Result.ExpenseHeaderID END,
		CASE WHEN @sortBy = 'amount' THEN Result.headerAmount END DESC,
		CASE WHEN @sortBy = 'date_asc' THEN Result.headerClaimDate  END ASC,		
		CASE WHEN @sortBy = 'date_desc' THEN Result.headerClaimDate END DESC,		
		CASE WHEN @sortBy = 'name' THEN Result.name END,		
		CASE WHEN @sortBy = 'surname' THEN Result.surname END,
		Result.ExpenseHeaderID

END

