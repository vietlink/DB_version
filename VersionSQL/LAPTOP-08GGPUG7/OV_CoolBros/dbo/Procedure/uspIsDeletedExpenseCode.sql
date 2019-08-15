/****** Object:  Procedure [dbo].[uspIsDeletedExpenseCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspIsDeletedExpenseCode] 
	-- Add the parameters for the stored procedure here
	@code varchar(5) , 
	@ReturnValue int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @ReturnValue= (select IsDeleted 
	from ExpenseCode
	where Code = @code)
END

