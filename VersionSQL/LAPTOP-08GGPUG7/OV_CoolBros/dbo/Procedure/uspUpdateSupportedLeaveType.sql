/****** Object:  Procedure [dbo].[uspUpdateSupportedLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateSupportedLeaveType](@leaveTypeId int, @supportedLeaveTypeId int, @accrueLeave bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF EXISTS (SELECT ID FROM LeaveSupportedAccrueTypes WHERE LeaveTypeID = @leaveTypeID AND SupportedLeaveTypeID = @supportedLeaveTypeId) BEGIN
    UPDATE 
		LeaveSupportedAccrueTypes
	SET
		AccrueLeave = @accrueLeave
	WHERE
		LeaveTypeID = @leaveTypeID AND SupportedLeaveTypeID = @supportedLeaveTypeId
	END
	ELSE BEGIN
		INSERT INTO
			LeaveSupportedAccrueTypes(LeaveTypeID, SupportedLeaveTypeID, AccrueLeave)
				VALUES(@leaveTypeID, @supportedLeaveTypeId, @accrueLeave);
	END
END

