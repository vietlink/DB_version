/****** Object:  Procedure [dbo].[uspGetCommentsByTimesheetHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCommentsByTimesheetHeaderID](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * FROM TimesheetComments WHERE TimesheetHeaderID = @headerId ORDER BY DateFor ASC
END

