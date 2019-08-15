/****** Object:  Procedure [dbo].[uspExpenseToAccount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspExpenseToAccount] 
	-- Add the parameters for the stored procedure here
	@id int, @sortBy varchar(max), @isFinalise int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @payrollStatus varchar(5)= (SELECT ps.Code FROM PayrollCycle pc INNER JOIN PayrollStatus ps ON pc.ExpensePayrollStatusID= ps.ID WHERE pc.ID=@id)
	DECLARE @from datetime= (SELECT pc.FromDate FROM PayrollCycle pc WHERE pc.ID=@id)
	DECLARE @to datetime= (SELECT pc.ToDate FROM PayrollCycle pc WHERE pc.ID=@id)
	DECLARE @exportAs varchar(7)= (SELECT ExportMileageClaimAs FROM ExpenseClaimSettings)
    -- Insert statements for procedure here
	SELECT e.id as empID,
	e.displayname AS name,
	isnull(e.PayrollID,'') AS PayrollID,
	isnull(e.AcctsPayableCode,'') AS vendorID,
	ech.ID AS headerID,
	ech.ExpenseClaimDate AS headerDate,
	ech.Description AS headerDescription,
	ecd.ID AS itemID,
	ecd.ExpenseDate AS itemDate,
	ecd.Description AS itemDescription,
	ecd.ExpenseAmount AS amount,
	isnull(ecd.TaxAmount,0) AS tax,
	c.Description AS costCentre,
	c.Code AS costCentreCode,
	ec.Description AS expenseCode,
	ec.Code AS expenseCodeCode,
	ecs.CurrencyCode AS currency
	FROM ExpenseClaimHeader ech 
	LEFT OUTER JOIN ExpenseClaimDetail ecd ON ech.ID= ecd.ExpenseClaimHeaderID
	INNER JOIN Employee e ON ech.CreatedForUserID= e.id
	INNER JOIN ExpenseStatus es ON ech.ExpenseClaimStatusID= es.ID
	INNER JOIN ExpenseStatus es_d ON ecd.ExpenseStatusID= es_d.ID
	INNER JOIN CostCentres c ON ecd.CostCentreID= c.ID
	INNER JOIN ExpenseCode ec ON ecd.ExpenseCodeID= ec.ID,
	ExpenseClaimSettings ecs
	WHERE es.Code='A' AND es_d.Code='A' 
	AND ((@payrollStatus='O'AND ecd.PayCycleID is null AND ech.ExpenseClaimDate<=@to) OR (@payrollStatus='C' and ecd.PayCycleID=@id))	
	--AND ((ech.ExpenseClaimDate>=@from AND @payrollStatus='C') OR @payrollStatus='O')
	AND dbo.fnGetEmpPayrollCycleInPeriod(e.id, @from, @to)=@id
	AND ((@exportAs='payroll' AND ecd.Source is null) OR @exportAs='expense')
	
	ORDER BY
	
		CASE WHEN @sortBy = 'date_asc' THEN ech.ExpenseClaimDate  END ASC,		
		CASE WHEN @sortBy = 'date_desc' THEN ech.ExpenseClaimDate END DESC,		
		CASE WHEN @sortBy = 'name' THEN e.displayname END,		
		CASE WHEN @sortBy = 'surname' THEN e.surname END
END

