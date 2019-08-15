/****** Object:  Procedure [dbo].[uspSaveRequestHeader]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveRequestHeader](@empId int, @typeId int, @reason varchar(1000), @contact varchar(1000),
	@timePeriod decimal(18,8), @dateFrom datetime, @dateTo datetime, @exclWeekends bit, @exclHolidays bit, @period varchar(20), @periodFrom varchar(20), @periodTo varchar(20), @exclAlreadyExists bit, @hourHeaderId int, @requestId int = 0, @submittedBy int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @pendingStatusID int = 0;
	SELECT @pendingStatusID = ID FROM LeaveStatus WHERE code = 'P';
	DECLARE @rejectedStatusID int = 0;
	SELECT @rejectedStatusID = ID FROM LeaveStatus WHERE code = 'R';
	DECLARE @approvedStatusID int = 0;
	SELECT @approvedStatusID = ID FROM LeaveStatus WHERE code = 'A';
	DECLARE @isAutoApprove bit =0;
	SELECT @isAutoApprove = ewh.NoApprovalForLeave FROM EmployeeWorkHoursHeader ewh WHERE ID= dbo.fnGetWorkHourHeaderIDByDay(@empId, @dateFrom)
	DECLARE @empPosID int = (SELECT ep.id FROM EmployeePosition ep WHERE ep.primaryposition='Y' and ep.IsDeleted=0 and ep.employeeid= @empId)
	DECLARE @retId int = @requestId;
	IF @requestId = 0 BEGIN
		INSERT INTO LeaveRequest(EmployeeID, LeaveTypeID, LeaveStatusID, ReasonForLeave, LeaveContactDetails,
			TimePeriodRequested, DateFrom, DateTo, ExclWeekends, ExclPublicHolidays, Period, PeriodFrom, PeriodTo, EmployeeWorkHoursHeaderID)
		VALUES(@empId, @typeId, @pendingStatusID, @reason, @contact, @timePeriod, @dateFrom, @dateTo, @exclWeekends, @exclHolidays, @period, @periodFrom, @periodTo, dbo.fnGetWorkHourHeaderIDByDay(@empId, @dateFrom));
		SET @retId = @@IDENTITY;
	END ELSE BEGIN
		UPDATE
			LeaveRequest
		SET
			LeaveTypeID = @typeId,
			ReasonForLeave = @reason,
			LeaveContactDetails = @contact,
			TimePeriodRequested = @timePeriod,
			DateFrom = @dateFrom,
			DateTo = @dateTo,
			ExclWeekends = @exclWeekends,
			ExclPublicHolidays = @exclHolidays,
			Period = @period,
			PeriodFrom = @periodFrom,
			PeriodTo = @periodTo,
			ExclAlreadyRequested = @exclAlreadyExists,
			LeaveStatusID = @pendingStatusID,
			Approver1EPID = null,
			Approver2EPID = null,
			Approver3EPID = null,
			approved1 = 0,
			approved2 = 0,
			ApprovedNegative = 0,
			IsCancelled = 0
		WHERE
			id = @requestId
		EXEC dbo.uspCancelTransactions @requestId
		-- Remove all of the request items, next call recreates them via code
		UPDATE LeaveRequest SET LeaveStatusID = @pendingStatusID WHERE id = @requestId AND LeaveStatusID = @rejectedStatusID
		DELETE FROM LeaveRequestDetail WHERE LeaveRequestID = @requestId;
	END

	INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, Comment, SubmittedByID)
		VALUES(@empId, @retId, GETDATE(), @pendingStatusID, @reason, @submittedBy);
	IF (@isAutoApprove=1) BEGIN
		INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, SubmittedByID)
			VALUES(@empId, @retId, DATEADD(ss, 1, GETDATE()), @approvedStatusID, @submittedBy);
		UPDATE LeaveRequest SET LeaveStatusID = @approvedStatusID, IsAutoApproved = 1, Approver1EPID= @empPosID, Approved1=1 WHERE ID = @retId AND LeaveStatusID = @pendingStatusID
		--IF (@dateFrom<=GETDATE()) BEGIN
		--	EXEC uspCreateTransactionFromHeader @retID;
		
	END
	RETURN @retId;
END
