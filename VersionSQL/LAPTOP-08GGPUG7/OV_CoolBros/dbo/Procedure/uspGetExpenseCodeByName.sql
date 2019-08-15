/****** Object:  Procedure [dbo].[uspGetExpenseCodeByName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetExpenseCodeByName] 
	-- Add the parameters for the stored procedure here
	@filter varchar(50), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from ExpenseCode where Description=@filter and IsDeleted= @status
	
END

