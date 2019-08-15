/****** Object:  Procedure [dbo].[uspGetExpenseDetailByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseDetailByID] 
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT ecd.*, es.Code as statusCode , ISNULL(d.FileName,'') as DocumentName, ech.CreatedForUserID
	FROM 
	ExpenseClaimDetail ecd 
	inner join ExpenseStatus es on ecd.ExpenseStatusID= es.ID  
	INNER JOIN ExpenseClaimHeader ech ON ecd.ExpenseClaimHeaderID= ech.ID
	LEFT OUTER JOIN Documents d ON ecd.DocumentID= d.ID
	WHERE ecd.ID= @id
END

