/****** Object:  Procedure [dbo].[uspCancelRequest]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCancelRequest](@requestId int, @approverEmpId int, @comments varchar(max), @submittedByID int, @preventLog bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @cancelledId int;
	SELECT @cancelledId = id FROM LeaveStatus WHERE code = 'C';

	DECLARE @leaveTypeId int;
	DECLARE @dateFrom datetime
	DECLARE @empId int;
	DECLARE @statusId int;
	SELECT @empId = EmployeeID, @leaveTypeId = LeaveTypeID, @dateFrom = DateFrom, @statusId = LeaveStatusID FROM LeaveRequest WHERE id = @requestId;
	
	exec dbo.uspCancelTransactions @requestId;

    UPDATE LeaveRequest SET IsCancelled = 1, LeaveStatusID = @cancelledId WHERE ID = @requestId
	IF @preventLog = 0 BEGIN
		INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, Comment, [State], SubmittedByID)
			VALUES(@approverEmpId, @requestId, GETDATE(), @cancelledId, @comments, 0, @submittedByID);
	END

	DECLARE @accrueLeave bit;
	DECLARE @accrueAdvanced bit;
	SELECT @accrueLeave = AccrueLeave, @accrueAdvanced = AccrueInAdvanced FROM LeaveType WHERE id = @leaveTypeId;

	DECLARE @statusCode varchar(50);
	SELECT @statusCode = Code FROM LeaveStatus WHERE ID = @statusId;
	PRINT @statusCode + 'proc2';
	IF @dateFrom <= GETDATE() AND (@statusCode = 'PC' OR @statusCode = 'A') BEGIN
		PRINT 'Regening'
		exec uspRegenAccrueData @dateFrom, @empId
	 --exec uspGenerateAccrueData @dateFrom, @empId, @accrueAdvanced
	END
END

