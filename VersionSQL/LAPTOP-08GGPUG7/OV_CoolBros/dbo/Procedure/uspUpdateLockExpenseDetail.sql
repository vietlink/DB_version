/****** Object:  Procedure [dbo].[uspUpdateLockExpenseDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspUpdateLockExpenseDetail] 
	-- Add the parameters for the stored procedure here
	@id int ,
	@lock bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ExpenseClaimDetail
	SET IsLocked = @lock
	WHERE ID= @id
END

