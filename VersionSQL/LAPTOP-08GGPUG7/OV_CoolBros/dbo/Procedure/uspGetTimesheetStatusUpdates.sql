/****** Object:  Procedure [dbo].[uspGetTimesheetStatusUpdates]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTimesheetStatusUpdates](@timesheetId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		tsh.*, e.displayname, ts.Description as [status]
	FROM
		TimesheetStatusHistory tsh
	INNER JOIN
		Employee e
	ON
		e.ID = ApproverEmployeeID
	INNER JOIN
		TimesheetStatus ts
	ON
		ts.ID = tsh.TimesheetStatusID
	WHERE
		tsh.TimesheetHeaderID = @timesheetId  AND ts.Code <> 'A'
	ORDER BY Date DESC
		
END

