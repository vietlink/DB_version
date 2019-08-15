/****** Object:  Procedure [dbo].[uspGetApproverCommentsByTimesheetHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetApproverCommentsByTimesheetHeaderID](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM TimesheetApproverComments WHERE TimesheetHeaderID = @headerId ORDER BY DateAdded ASC
END

