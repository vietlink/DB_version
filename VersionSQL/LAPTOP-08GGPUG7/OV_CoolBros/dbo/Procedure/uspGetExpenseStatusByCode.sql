/****** Object:  Procedure [dbo].[uspGetExpenseStatusByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[uspGetExpenseStatusByCode](@code varchar(5))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT TOP 1 * FROM ExpenseStatus WHERE code = @code;
END

