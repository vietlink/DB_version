/****** Object:  Procedure [dbo].[uspGetMyExpenseHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMyExpenseHeader] 
	-- Add the parameters for the stored procedure here
	@userID int, @fromDate datetime, @toDate datetime, @filter varchar(max), @statusList varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @statusTable TABLE (code varchar(5));
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@statusList, ',');	
    END
    ELSE IF LEN(@statusList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @statusTable(code) VALUES(@statusList ) ;	
    END
    -- Insert statements for procedure here
	SELECT ech.ID
	,ech.CreatedDate
	,ech.Description
	,isnull(ech.CreatedByUserID,0) as CreatedByUserID
	,ech.ExpenseClaimDate
	,ech.ExpenseClaimStatusID
	,dbo.fnGetExpenseSubmittedDate(ech.ID) AS SubmittedDate
	,dbo.fnGetExpenseLastSubmitter(ech.ID) AS SubmittedBy
	, ech.isLocked
	, ech.createdForuserID
	,dbo.fnGetExpenseHeaderStatus(ech.ID) as status, dbo.fnGetExpenseHeaderStatusCode(ech.ID) AS statusCode
	,dbo.fnGetSumExpenseHeader(ech.ID) as amount
	,dbo.fnGetExpenseApprover(ech.id) as approver
	,dbo.fnGetExpenseLastSubmitterID(ech.ID) AS SubmitterID,
	ech.isPartiallyApproved,
	ech.Comment,
	isnull(ech.isAutoApproved,'') AS AutoApproved,
	isnull(p.Description,'') as PayCycle
	FROM ExpenseClaimHeader ech	
	--INNER JOIN [User] u ON ech.LastEditedByUserID = u.id
	LEFT OUTER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID
	LEFT OUTER JOIN PayrollCycle p ON ech.PayCycleID = p.ID
	
	WHERE ((ech.createdForUserID = @userID AND @userID!=0) OR(@userID=0))
	AND (((ech.ExpenseClaimDate>=@fromDate) AND @fromDate is not null) OR (@fromDate is null))
	AND (((ech.ExpenseClaimDate <=@toDate) AND @toDate is not null) OR (@toDate is null))
	--AND (((@fromDate<= ech.ExpenseClaimDate AND @toDate>= ech.ExpenseClaimDate) AND (@fromDate is not null AND @toDate is not null)) OR (@fromDate is null AND @toDate is null))
	AND ((SELECT COUNT(*) FROM @statusTable) = 0 OR es.Code IN (SELECT * FROM @statusTable))
	AND ((ech.Description LIKE '%'+@filter+'%') OR (es.Description LIKE '%' +@filter+ '%') OR (dbo.fnGetExpenseLastSubmitter(ech.ID) LIKE '%'+@filter+'%'))
	GROUP BY ech.ID, ech.CreatedDate, ech.Description, ech.CreatedByUserID, ech.ExpenseClaimDate, ech.ExpenseClaimStatusID, ech.isLocked, ech.createdForuserID, es.Description, es.code, ech.isPartiallyApproved, ech.Comment, ech.isAutoApproved, p.Description	
	--, esh.ApprovedByID
	ORDER BY ech.ExpenseClaimDate DESC
	
END

