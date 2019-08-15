/****** Object:  Function [dbo].[fnCheckNoAccruelLeaveBooked]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnCheckNoAccruelLeaveBooked](@date datetime, @leaveTypeId int, @empId int)
RETURNS bit
AS
BEGIN
	DECLARE @nonSupportedTypes TABLE (id int);
	DECLARE @approvedStatusId VARCHAR(50);
	SELECT @approvedStatusId = ID FROM LeaveStatus WHERE Code = 'A';

	INSERT INTO @nonSupportedTypes SELECT LeaveTypeId FROM LeaveSupportedAccrueTypes WHERE SupportedLeaveTypeID = @leaveTypeId AND AccrueLeave = 0;
	IF EXISTS (SELECT lrd.id FROM LeaveRequestDetail lrd INNER JOIN LeaveRequest r ON r.id = lrd.LeaveRequestID WHERE r.LeaveStatusID = @approvedStatusId AND lrd.LeaveDateFrom = @date AND r.IsCancelled = 0 AND r.EmployeeID = @empId AND r.LeaveTypeID IN (SELECT id FROM @nonSupportedTypes))
		RETURN 1;
	RETURN 0;
END

