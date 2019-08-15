/****** Object:  Procedure [dbo].[uspSetBothApprovers]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetBothApprovers](@requestId int, @approverEpId int, @value bit, @code varchar(10), @comments varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @approverEmpId int = 0;
	SELECT @approverEmpId = EmployeeID FROM EmployeePosition WHERE id = @approverEpId;
	DECLARE @leaveStatusID int = 0;
	SELECT @leaveStatusID = id FROM LeaveStatus WHERE code = @code;

	UPDATE LeaveRequest SET Approved1 = @value, Approver1EPID = @approverEpId WHERE ID = @requestId
	UPDATE LeaveRequest SET Approved2 = @value, Approver2EPID = @approverEpId WHERE ID = @requestId

	INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, Comment, [State])
		VALUES(@approverEmpId, @requestId, GETDATE(), @leaveStatusID, @comments, 2); -- 2 = approved for state

END

