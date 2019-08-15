/****** Object:  Procedure [dbo].[uspSetExpenseClaimDocumentID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[uspSetExpenseClaimDocumentID](@detailID int, @documentId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE ExpenseClaimDetail SET DocumentID = @documentId WHERE id = @detailID;
END

