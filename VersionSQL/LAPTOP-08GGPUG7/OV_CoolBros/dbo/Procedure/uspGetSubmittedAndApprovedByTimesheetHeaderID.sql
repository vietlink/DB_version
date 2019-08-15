/****** Object:  Procedure [dbo].[uspGetSubmittedAndApprovedByTimesheetHeaderID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSubmittedAndApprovedByTimesheetHeaderID](@timesheetHeaderId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @submitEmpName varchar(255);
	DECLARE @approvedEmpName varchar(255);
	DECLARE @rejectedEmpName varchar(255);
	DECLARE @additionalApprovedEmpName varchar(255);

	DECLARE @submitDate datetime;
	DECLARE @approvedDate datetime;
	DECLARE @rejectedDate datetime;
	DECLARE @additionalApprovedDate datetime;

	DECLARE @submitStatusId int = 0;
	DECLARE @approvedStatusId int = 0;
	DECLARE @rejectedStatusId int = 0;
	DECLARE @additionalStatusId int = 0;

	SELECT @submitStatusId = ID FROM TimesheetStatus WHERE Code = 's';
	SELECT @approvedStatusId = ID FROM TimesheetStatus WHERE Code = 'at';
	SELECT @rejectedStatusId = ID FROM TimesheetStatus WHERE Code = 'r';
	SELECT @additionalStatusId = ID FROM TimesheetStatus WHERE Code = 'aa';

	SELECT TOP 1 @submitEmpName = ISNULL(e.displayname, ''), @submitDate = h.[Date] FROM TimesheetStatusHistory h INNER JOIN Employee e ON e.ID = h.ApproverEmployeeID WHERE h.TimesheetHeaderID = @timesheetHeaderId AND h.TimesheetStatusID = @submitStatusId ORDER BY h.[Date] DESC
	SELECT TOP 1 @approvedEmpName = ISNULL(e.displayname, ''), @approvedDate = h.[Date] FROM TimesheetStatusHistory h INNER JOIN Employee e ON e.ID = h.ApproverEmployeeID WHERE h.TimesheetHeaderID = @timesheetHeaderId AND h.TimesheetStatusID = @approvedStatusId ORDER BY h.[Date] DESC
	SELECT TOP 1 @rejectedEmpName = ISNULL(e.displayname, ''), @rejectedDate = h.[Date] FROM TimesheetStatusHistory h INNER JOIN Employee e ON e.ID = h.ApproverEmployeeID WHERE h.TimesheetHeaderID = @timesheetHeaderId AND h.TimesheetStatusID = @rejectedStatusId ORDER BY h.[Date] DESC
	SELECT TOP 1 @additionalApprovedEmpName = ISNULL(e.displayname, ''), @additionalApprovedDate = h.[Date] FROM TimesheetStatusHistory h INNER JOIN Employee e ON e.ID = h.ApproverEmployeeID WHERE h.TimesheetHeaderID = @timesheetHeaderId AND h.TimesheetStatusID = @additionalStatusId ORDER BY h.[Date] DESC

	SELECT @submitEmpName as SubmitEmpName, @approvedEmpName as ApprovedEmpName, @rejectedEmpName as RejectedEmpName,
		@submitDate as SubmitDate, @approvedDate as ApprovedDate, @rejectedDate as RejectedDate, @additionalApprovedEmpName as additionalApprovedEmpName, @additionalApprovedDate as additionalApprovedDate
END

