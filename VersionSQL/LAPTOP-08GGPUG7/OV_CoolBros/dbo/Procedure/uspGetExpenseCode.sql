/****** Object:  Procedure [dbo].[uspGetExpenseCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetExpenseCode]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM ExpenseCode e
	WHERE e.IsDeleted=0 
END

