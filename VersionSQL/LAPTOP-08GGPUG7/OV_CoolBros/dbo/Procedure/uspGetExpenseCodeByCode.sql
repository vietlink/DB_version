/****** Object:  Procedure [dbo].[uspGetExpenseCodeByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExpenseCodeByCode] 
	-- Add the parameters for the stored procedure here
	@code varchar(5), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from ExpenseCode where Code=@code and IsDeleted= @status
	
END

