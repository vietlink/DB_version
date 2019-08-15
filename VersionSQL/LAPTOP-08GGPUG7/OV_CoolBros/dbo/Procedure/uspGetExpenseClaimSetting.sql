/****** Object:  Procedure [dbo].[uspGetExpenseClaimSetting]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseClaimSetting] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT e.*, isnull(p.Title + ' - (' + p.identifier + ')','') as EscalatePosition1, isnull(ec.Description,'') as defaultExpenseCode, isnull(ec1.Description,'') as nonTaxExpenseCode
	FROM ExpenseClaimSettings e
	LEFT OUTER JOIN Position p ON e.Approver1PositionID= p.id
	LEFT OUTER JOIN ExpenseCode ec ON e.DefaultExpenseCodeID= ec.ID
	LEFT OUTER JOIN ExpenseCode ec1 ON e.MileageNonTaxExpenseCodeID= ec1.ID
	--WHERE e.ID = @id
END

