/****** Object:  Procedure [dbo].[uspGetExpenseHeaderByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseHeaderByID] 
	-- Add the parameters for the stored procedure here
	@id int, @userID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ech.ID
	,ech.CreatedDate
	,ech.Description
	,isnull (ech.CreatedByUserID,0) as CreatedByUserID
	,ech.ExpenseClaimDate
	,ech.ExpenseClaimStatusID
	,dbo.fnGetExpenseSubmittedDate(ech.ID) AS SubmittedDate
	,dbo.fnGetExpenseLastSubmitter(ech.ID) AS SubmittedBy
	, ech.isLocked
	, ech.createdForuserID
	,es.Description as status, es.Code AS statusCode
	,isnull(sum(ecd.ExpenseAmount),0) as amount
	,dbo.fnGetExpenseApprover(ech.id) as approver
	, dbo.fnGetExpenseApproverDate(ech.ID) as approvedDate
	,dbo.fnGetExpenseLastSubmitterID(ech.ID) AS SubmitterID,
	ech.isPartiallyApproved, ech.Comment, 
	p.Description AS PayCycle,
	e.displayname AS createdFor,	
	dbo.fnGetDefaultCostCentreID(ech.createdForUserID) as defaultCostCentreID,
	ech.ClaimType 
	FROM ExpenseClaimHeader ech	
	LEFT OUTER JOIN Employee u ON ech.LastEditedByUserID = u.id
	LEFT OUTER JOIN Employee e ON ech.CreatedForUserID = e.id
	LEFT OUTER JOIN ExpenseClaimDetail ecd ON ech.id= ecd.ExpenseClaimHeaderID
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID = es.ID
	LEFT OUTER JOIN PayrollCycle p ON ech.PayCycleID = p.ID
	
	--INNER JOIN ExpenseStatusHistory esh ON ech.ID= esh.ExpenseHeaderID
	--INNER JOIN ExpenseStatus es1 ON esh.ExpenseStatusID = es1.ID AND es1.Code='A'
	WHERE ((ech.createdForUserID = @userID AND @userID!=0) OR(@userID=0))
	AND ((ech.ID = @id AND @id<>0) OR (@id=0))
	GROUP BY ech.ID, ech.CreatedDate, ech.Description, ech.CreatedByUserID, ech.ExpenseClaimDate, ech.ExpenseClaimStatusID, ech.isLocked, ech.createdForuserID, es.Description, es.code, ech.isPartiallyApproved, ech.Comment, p.Description, e.displayname, ech.ClaimType
	--, esh.ApprovedByID
	ORDER BY ech.ExpenseClaimDate 
	
END

