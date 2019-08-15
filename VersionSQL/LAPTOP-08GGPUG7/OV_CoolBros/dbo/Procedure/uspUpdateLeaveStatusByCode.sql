/****** Object:  Procedure [dbo].[uspUpdateLeaveStatusByCode]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateLeaveStatusByCode](@requestId int, @approverEmpId int, @code varchar(10), @comments varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @leaveStatusId int;
	SELECT @leaveStatusId = id FROM LeaveStatus WHERE code = @code;

	IF @code <> 'C' BEGIN
		UPDATE LeaveRequest SET LeaveStatusID = @leaveStatusId, ApproverComments = @comments WHERE ID = @requestId;
	END
	IF @code = 'C' OR @code = 'PC' OR @code = 'P' BEGIN
		UPDATE LeaveRequest SET IsCancelled = 1 WHERE ID = @requestId;
		exec dbo.uspCancelTransactions @requestId;
	END
	IF @code = 'C' BEGIN
		exec dbo.uspCancelRequest @requestId, @approverEmpId, @comments, @approverEmpId, 1
	END
END

