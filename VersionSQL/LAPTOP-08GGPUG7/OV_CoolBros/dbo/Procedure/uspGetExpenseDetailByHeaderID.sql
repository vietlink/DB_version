/****** Object:  Procedure [dbo].[uspGetExpenseDetailByHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseDetailByHeaderID] 
	-- Add the parameters for the stored procedure here
	@headerID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT * FROM (
    -- Insert statements for procedure here
	SELECT ecd.*,
	es.Description AS expenseStatus,
	es.Code AS statusCode,
	c.Description AS costCentre,
	ec.Description AS expenseCode,
	dbo.fnGetRecentSubmittedDateByDetailID(ecd.ID) AS submittedDate,
	dbo.fnGetExpenseDetailApproveOrRejectDate(ecd.ID) AS ApprovedDate,
	isnull(d.FileName,'') as DocumentName,
	1 AS type
	--, esh.Date AS SubmittedDate
	FROM 
	ExpenseClaimDetail ecd  
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID = es.ID
	INNER JOIN CostCentres c ON ecd.CostCentreID = c.ID
	LEFT OUTER JOIN ExpenseCode ec ON ecd.ExpenseCodeID = ec.ID
	LEFT OUTER JOIN Documents d ON ecd.DocumentID= d.ID
	--LEFT OUTER JOIN ExpenseStatusHistory esh ON ecd.ID= esh.ExpenseDetailID	
	--LEFT OUTER JOIN ExpenseStatus es_h ON esh.ExpenseStatusID= es_h.ID AND es_h.Code='S'
	WHERE ecd.ExpenseClaimHeaderID = @headerID 
	AND Source is null
UNION
	SELECT ecd.*,
	es.Description AS expenseStatus,
	es.Code AS statusCode,
	c.Description AS costCentre,
	ec.Description AS expenseCode,
	dbo.fnGetRecentSubmittedDateByDetailID(ecd.ID) AS submittedDate,
	dbo.fnGetExpenseDetailApproveOrRejectDate(ecd.ID) AS ApprovedDate,
	isnull(d.FileName,'') as DocumentName,
	0 AS type
	--,esh.Date AS SubmittedDate
	FROM 
	ExpenseClaimDetail ecd  
	INNER JOIN ExpenseStatus es ON ecd.ExpenseStatusID = es.ID
	INNER JOIN CostCentres c ON ecd.CostCentreID = c.ID
	LEFT OUTER JOIN ExpenseCode ec ON ecd.ExpenseCodeID = ec.ID
	LEFT OUTER JOIN Documents d ON ecd.DocumentID= d.ID
	--LEFT OUTER JOIN ExpenseStatusHistory esh ON ecd.ID= esh.ExpenseDetailID
	--LEFT OUTER JOIN ExpenseStatus es_h ON esh.ExpenseStatusID= es_h.ID AND es_h.Code='S'
	WHERE ecd.ExpenseClaimHeaderID = @headerID 
	AND Source is not null) as result 
	ORDER BY result.ExpenseDate 
END

