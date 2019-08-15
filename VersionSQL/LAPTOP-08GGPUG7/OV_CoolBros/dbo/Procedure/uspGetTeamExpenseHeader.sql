/****** Object:  Procedure [dbo].[uspGetTeamExpenseHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTeamExpenseHeader] 
	-- Add the parameters for the stored procedure here
	@managerID int, @approverPosID int,  @personID int, @empIDList varchar(max), @statusList varchar(max), @filter varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id int);
	DECLARE @statusTable TABLE (code varchar(5));
	--DECLARE @manEpID int = (SELECT ep.id FROM EmployeePosition ep WHERE ep.employeeid = @managerID AND primaryposition='Y' AND IsDeleted=0);
	IF CHARINDEX(',', @empIDList, 0) > 0 BEGIN
		INSERT INTO @idTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@empIDList, ',');	
    END
    ELSE IF LEN(@empIDList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@empIDList AS int)) ;	
    END

	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(code) VALUES(@statusList ) ;	
    END
    -- Insert statements for procedure here
	SELECT ech.ID AS id,
	ech.ExpenseClaimDate AS Date,
	ech.Description AS Description,
	ech.CreatedForUserID AS createdForUserID,
	dbo.fnGetSumExpenseHeader(ech.ID) AS Amount,
	es.Description AS Status,
	es.Code AS StatusCode,
	e.displayname AS EmpName,
	p.title AS position,
	ech.isLocked AS isLock,
	dbo.fnGetExpenseApprover(ech.id) AS approver,
	dbo.fnGetExpenseSubmittedDate(ech.ID) AS SubmittedDate,
	dbo.fnGetExpenseLastSubmitter(ech.ID) AS SubmittedBy,
	dbo.fnGetExpenseLastSubmitterID(ech.ID) AS SubmitterID,
	ech.isPartiallyApproved, 
	ech.Comment
	,isnull(pc.Description,'') AS PayCycle
	FROM ExpenseClaimHeader ech
	LEFT OUTER JOIN PayrollCycle pc ON ech.PayCycleID = pc.ID
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID
	LEFT OUTER JOIN ExpenseClaimDetail ecd ON ech.ID= ecd.ExpenseClaimHeaderID
	INNER JOIN Employee e ON ech.CreatedForUserID = e.id
	--INNER JOIN Employee e ON u.accountname = e.accountname
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	LEFT OUTER JOIN Position p ON ep.positionid = p.id
	
	WHERE 
	((SELECT COUNT(*) FROM @idTable) = 0 OR e.id IN (SELECT * FROM @idTable))
	AND 
	((SELECT COUNT(*) FROM @statusTable) = 0 OR es.Code IN (SELECT * FROM @statusTable))
	--AND (((@fromDate<= ech.ExpenseClaimDate AND @toDate>= ech.ExpenseClaimDate) AND (@fromDate is not null AND @toDate is not null)) OR (@fromDate is null AND @toDate is null))
	AND ((@approverPosID!=0) OR (@approverPosID=0 AND ( e.id IN (SELECT * FROM dbo.fnGetEmployeeIDByManagerID(@managerID)))))
	AND ((e.id = @personID AND @personID!=0) OR (@personID=0))
	AND ((ech.Description LIKE '%'+@filter+'%') OR (es.Description LIKE '%' +@filter+ '%') OR (dbo.fnGetExpenseLastSubmitter(ech.ID) LIKE '%'+@filter+'%'))
	AND ech.PayCycleID is null
	GROUP BY  ech.id, ech.ExpenseClaimDate, ech.Description, es.Description, es.Code, e.displayname, p.title, ech.isLocked, ech.CreatedForUserID, ech.isPartiallyApproved, ech.Comment
	, pc.Description
	ORDER BY ech.ExpenseClaimDate DESC

END

