/****** Object:  Procedure [dbo].[uspGetHeaderStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetHeaderStatusHistory](@headerID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		esh.*,
		es.[Description] as ExpenseStatus,
		es.Code as ExpenseStatusCode,
		u.Displayname,
		ech.isPartiallyApproved		
	FROM
		ExpenseStatusHistory esh
	INNER JOIN
		ExpenseStatus es
	ON
		es.ID = esh.ExpenseStatusID
	INNER JOIN
		ExpenseClaimHeader ech
	ON
		ech.id = esh.ExpenseHeaderID
	INNER JOIN
		Employee u
	ON
		esh.SubmittedByID= u.id
	
	WHERE
		esh.ExpenseHeaderID = @headerID

	ORDER BY [Date] DESC

END

