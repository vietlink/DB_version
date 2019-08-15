/****** Object:  Procedure [dbo].[uspGetRequiredPendingCancellationByRequestID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRequiredPendingCancellationByRequestID](@requestId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT ISNULL(t.RequiresCancelApproval, 0) as RequiresCancelApproval FROM LeaveRequest r
	INNER JOIN LeaveType t ON t.id = r.LeaveTypeID
	INNER JOIN LeaveStatus s on s.id = r.LeaveStatusID

	WHERE r.ID = @requestId AND s.Code = 'A'
END

