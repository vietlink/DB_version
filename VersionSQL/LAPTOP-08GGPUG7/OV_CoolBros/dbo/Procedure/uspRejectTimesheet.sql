/****** Object:  Procedure [dbo].[uspRejectTimesheet]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspRejectTimesheet](@employeeId int, @payrollCycleId int, @actionEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @statusId int = 0;
	SELECT @statusId = ID FROM TimesheetStatus WHERE Code = 'R';

	DECLARE @headerId int = 0;
	SELECT 
		@headerId = id 
	FROM
		TimesheetHeader
	WHERE
		EmployeeID = @employeeId AND PayrollCycleID = @payrollCycleId;

    UPDATE
		TimesheetHeader
	SET
		TimesheetStatusID = @statusId,
		islocked = 0,
		LastUpdated = GETDATE(),
		IsTimesheetApproved = 0,
		IsAdditionalApproved = 0
	WHERE
		ID = @headerId;

	DELETE FROM TimesheetRateAdjustmentItem WHERE TimesheetRateAdjustmentID IN (SELECT ID FROM TimesheetRateAdjustment WHERE TimesheetHeaderID = @headerId);
	DELETE FROM TimesheetRateAdjustment WHERE TimeSheetHeaderID = @headerId;

	INSERT INTO
		TimesheetStatusHistory(ApproverEmployeeID, TimesheetHeaderID, [Date], TimesheetStatusID)
	VALUES(@actionEmpId, @headerId, GETDATE(), @statusId);

	EXEC dbo.uspRemoveTimesheetTOIL @headerId
END

