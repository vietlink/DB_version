/****** Object:  Procedure [dbo].[uspGetExpensePendingReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpensePendingReport] 
	-- Add the parameters for the stored procedure here
	@empID int, @submittedInclude bit, @divisionList varchar(max), @statusList varchar(max), @departmentList varchar(max), @locationList varchar(max), @groupBy varchar(max), @sortBy varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @divisionTable TABLE(division varchar(max));
	DECLARE @statusTable TABLE(status varchar(max));
	DECLARE @departmentTable TABLE(department varchar(max));	
	DECLARE @locationTable TABLE(location varchar(max));
	--DECLARE @employeeStatusTable TABLE(employeeStatus varchar(max));	
	

	IF CHARINDEX(',', @divisionList, 0) > 0 BEGIN
		INSERT INTO @divisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionList, ',');	
    END
    ELSE IF LEN(@divisionList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @divisionTable(division) VALUES(@divisionList);	
    END
	
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(status) VALUES(@statusList);	
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
	
    -- Insert statements for procedure here
SELECT * FROM(
	SELECT 
		e.id,
		e.displayname AS name,
		e.surname,
		e.status as empStatus,
		isnull(p.title,'') AS title,
		isnull(p.orgunit2,'') AS posorgunit2,
		isnull(p.orgunit3,'') AS posorgunit3,
		ech.ID AS expenseID,
		ech.ExpenseClaimDate AS claimdate,
		ech.Description,
		dbo.fnGetSumExpenseHeader(ech.ID) as amount,
		es.Description AS status,
		es.code AS statusCode,
		dbo.fnGetExpenseClaimApprover(ep.id) as Approver ,
		isnull(e.location,'') as location
	FROM ExpenseClaimHeader ech
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid= p.id
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID
	WHERE ((es.Code='S' AND (@submittedInclude=0)) OR (@submittedInclude=1 AND (es.Code='S' OR es.Code='P')))
	AND ((ech.CreatedForUserID= @empID AND @empID!=0) OR ((@empID=0) AND ((SELECT COUNT(*) FROM @statusTable) = 0 OR e.status IN (SELECT * FROM @statusTable))))
	AND ((SELECT COUNT(*) FROM @departmentTable) = 0 OR isnull(P.orgunit3,'(Blank)') IN (SELECT * FROM @departmentTable))	
	AND ((SELECT COUNT(*) FROM @divisionTable) = 0 OR isnull(P.orgunit2,'(Blank)') IN (SELECT * FROM @divisionTable))
	AND ((SELECT COUNT(*) FROM @locationTable) = 0 OR isnull(E.location,'(Blank)') IN (SELECT * FROM @locationTable))) AS Result
	ORDER BY		
		CASE WHEN @groupBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @groupBy = 'posorgunit3' THEN Result.posorgunit3 END,		
		CASE WHEN @groupBy = 'title' THEN Result.title END,		
		CASE WHEN @groupBy = 'status' THEN Result.status END,				
		CASE WHEN @groupBy = 'name' THEN Result.name END,	
		CASE WHEN @groupBy = 'location' THEN Result.location END,	
		CASE WHEN @groupBy = 'approver' THEN Result.Approver END,	

		CASE WHEN @sortBy = 'approver' THEN Result.Approver END,	
		CASE WHEN @sortBy = 'amount' THEN Result.amount END DESC,
		CASE WHEN @sortBy = 'posorgunit2' THEN Result.posorgunit2 END,		
		CASE WHEN @sortBy = 'posorgunit3' THEN Result.posorgunit3 END,		
		CASE WHEN @sortBy = 'location' THEN Result.location END,	
		CASE WHEN @sortBy = 'status' THEN Result.status END,				
		CASE WHEN @sortBy = 'date_asc' THEN Result.claimdate END ASC,		
		CASE WHEN @sortBy = 'date_desc' THEN Result.claimdate END DESC,		
		CASE WHEN @sortBy = 'name' THEN Result.name END,		
		CASE WHEN @sortBy = 'surname' THEN Result.surname END
END

