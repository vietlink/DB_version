/****** Object:  Procedure [dbo].[uspSetRequestPendingCancellation]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSetRequestPendingCancellation](@requestId int, @approverEmpId int, @comments varchar(max), @submittedByID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @pcId int = 0;
	SELECT @pcId = id FROM LeaveStatus WHERE code = 'PC';
	UPDATE LeaveRequest SET Approved1 = 0, Approved2 = 0, ApprovedNegative = 0, Approver1EPID = null, Approver2EPID = null, LeaveStatusID = @pcId
	WHERE ID = @requestId;
	exec dbo.uspCancelTransactions @requestId;
	INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, Comment, SubmittedByID)
		VALUES(@approverEmpId, @requestId, GETDATE(), @pcId, @comments, @submittedByID);

END

