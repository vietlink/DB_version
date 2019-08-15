/****** Object:  Procedure [dbo].[uspSaveEmployeeLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveEmployeeLeaveType](@employeeId int, @leaveTypeId int, @enabled bit, @headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF EXISTS (SELECT ID FROM EmployeeLeaveTypes WHERE EmployeeID = @employeeId AND LeaveTypeID = @leaveTypeId AND EmployeeWorkHoursHeaderID = @headerId) BEGIN
		UPDATE EmployeeLeaveTypes SET [Enabled] = @enabled WHERE EmployeeID = @employeeId AND LeaveTypeID = @leaveTypeId AND EmployeeWorkHoursHeaderID = @headerId
	END
	ELSE BEGIN
		INSERT INTO EmployeeLeaveTypes(EmployeeID, LeaveTypeID, [Enabled], EmployeeWorkHoursHeaderID)
		VALUES(@employeeId, @leaveTypeId, @enabled, @headerId);
	END
END

