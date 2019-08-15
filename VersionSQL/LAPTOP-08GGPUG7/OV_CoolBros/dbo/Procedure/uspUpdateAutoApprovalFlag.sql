/****** Object:  Procedure [dbo].[uspUpdateAutoApprovalFlag]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspUpdateAutoApprovalFlag] 
	-- Add the parameters for the stored procedure here
	@id int , 
	@autoApprovalFlag bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE ExpenseClaimHeader
	SET isAutoApproved = @autoApprovalFlag
	WHERE ID= @id
END

