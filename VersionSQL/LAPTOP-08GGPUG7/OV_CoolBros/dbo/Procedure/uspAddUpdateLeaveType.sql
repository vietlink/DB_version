/****** Object:  Procedure [dbo].[uspAddUpdateLeaveType]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[uspAddUpdateLeaveType](@id int, @code varchar(50), @description varchar(100), @backgroundColour varchar(25),
	@fontColour varchar(25), @accrueLeave bit, @leavePerYear decimal(10,5), @systemCode varchar(50), @accruePeriod int,
	@enabled bit, @paidLeave bit, @plannedLeave bit, @defaultNewPeople bit, @accrueInAdvanced bit, @accrueAfterDays int,
	@zeroBalanceDay int, @zeroBalanceMonth int, @leaveExpireDays int, @leaveBookableOptions int, @canApplyAfterDays int, @goodMin decimal(10,5),
	@goodMax decimal(10,5), @monitorMin decimal(10,5), @monitorMax decimal(10,5), @actionMin decimal(10,5), @actionMax decimal(10,5),
	@goodBackgroundColour varchar(25), @goodTextColour varchar(25), @monitorBackgroundColour varchar(25), @monitorTextColour varchar(25), @actionBackgroundColour varchar(25), @actionTextColour varchar(25),
	@sickTolleranceStartDays int, @allowDocuments bit, @zeroBalanceEnabled bit, @emailUpdates bit, @approver1 int, @approver2 int, @approver3 int, @escalate1id int, @escalate2id int, @escalate3id int, @approvalLevel int, @emailApprover bit,
	@emailReminderDays1 int, @emailText varchar(max), @allowNegative bit, @negativeTolerance decimal(10,5), @leaveClassify int, @reportDescription varchar(100), @maxAccruedBalance decimal(10,5), @minimumLeave decimal(10,5), @maximumLeave decimal(10,5),
	@overridePositionLevel bit, @paidOnTermination bit, @isApprovalRequired bit, @reasonRequired bit, @commencementShowDays decimal(10,5), @emailbacktext varchar(max))


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @leaveClassify <> 5 AND @defaultNewPeople = 1
		UPDATE LeaveType SET DefaultNewPeople = 0 WHERE id <> @id AND LeaveClassify = @leaveClassify;

    IF @id = 0 BEGIN
		INSERT INTO LeaveType(code,[description],backgroundColour,fontColour,accrueLeave,leavePerYear,systemCode,accruePeriod,enabled,paidLeave,plannedLeave,defaultNewPeople,accrueInAdvanced,accrueAfterDays,zeroBalanceDay,
		zeroBalanceMonth,leaveExpireDays,leaveBookableOptions,canApplyAfterDays,goodMin,goodMax,monitorMin,monitorMax,actionMin,actionMax,goodBackgroundColour,goodTextColour,monitorBackgroundColour,monitorTextColour,actionBackgroundColour,actionTextColour,sickTolleranceStartDays,allowDocuments, ZeroBalanceEnabled, EmailUpdates, Approver1, Approver2, Approver3, escalate1ID, escalate2ID, escalate3ID, ApprovalLevel,
		EmailApprover, EmailReminderDays1, EmailText, AllowNegative, NegativeTolerance, LeaveClassify, ReportDescription, MaxAccruedBalance, MinimumLeave, OverridePositionLevel, PaidOnTermination, RequiresCancelApproval, ReasonRequired, MaximumLeave, commencementShowDays, EmailBackText)
		VALUES(@code,@description,@backgroundColour,@fontColour,@accrueLeave,@leavePerYear,@code,@accruePeriod,@enabled,@paidLeave,@plannedLeave,@defaultNewPeople,@accrueInAdvanced,@accrueAfterDays,@zeroBalanceDay,@zeroBalanceMonth,@leaveExpireDays,@leaveBookableOptions,@canApplyAfterDays,@goodMin,@goodMax,@monitorMin,@monitorMax,@actionMin,@actionMax,@goodBackgroundColour,@goodTextColour,@monitorBackgroundColour,@monitorTextColour,@actionBackgroundColour,@actionTextColour,@sickTolleranceStartDays,@allowDocuments,@zeroBalanceEnabled, @emailUpdates,
		@approver1, @approver2, @approver3, @escalate1id, @escalate2id, @escalate3id, @approvalLevel,@emailApprover,@emailReminderDays1, @emailText, @allowNegative, @negativeTolerance, @leaveClassify, @reportDescription, @maxAccruedBalance, @minimumLeave, @overridePositionLevel, @paidOnTermination, @isApprovalRequired, @reasonRequired, @maximumLeave, @commencementShowDays, @emailbacktext)

		RETURN @@IDENTITY;
	END 
	ELSE BEGIN
		UPDATE
			LeaveType
		SET
			Code = @Code,
			[Description] = @Description,
			BackgroundColour = @BackgroundColour,
			FontColour = @FontColour,
			AccrueLeave = @AccrueLeave,
			LeavePerYear = @LeavePerYear,
			AccruePeriod = @AccruePeriod,
			[Enabled] = @Enabled,
			PaidLeave = @PaidLeave,
			PlannedLeave = @PlannedLeave,
			DefaultNewPeople = @DefaultNewPeople,
			AccrueInAdvanced = @AccrueInAdvanced,
			AccrueAfterDays = @AccrueAfterDays,
			ZeroBalanceDay = @ZeroBalanceDay,
			LeaveExpireDays = @LeaveExpireDays,
			LeaveBookableOptions = @LeaveBookableOptions,
			CanApplyAfterDays = @CanApplyAfterDays,
			GoodMin = @GoodMin,
			GoodMax = @GoodMax,
			MonitorMin = @MonitorMin,
			MonitorMax = @MonitorMax,
			ActionMin = @ActionMin,
			ActionMax = @ActionMax,
			GoodBackgroundColour = @GoodBackgroundColour,
			GoodTextColour = @GoodTextColour,
			MonitorBackgroundColour = @MonitorBackgroundColour,
			MonitorTextColour = @MonitorTextColour,
			ActionBackgroundColour = @ActionBackgroundColour,
			ActionTextColour = @ActionTextColour,
			SickTolleranceStartDays = @SickTolleranceStartDays,
			AllowDocuments = @AllowDocuments,
			ZeroBalanceEnabled = @ZeroBalanceEnabled,
			EmailUpdates = @EmailUpdates,
			ZeroBalanceMonth = @zeroBalanceMonth,
			Approver1 = @approver1,
			Approver2 = @approver2,
			Approver3 = @approver3,
			escalate1ID = @escalate1id,
			escalate2ID = @escalate2id,
			escalate3ID = @escalate3id,
			ApprovalLevel = @approvalLevel,
			EmailApprover = @emailApprover,
			EmailReminderDays1 = @emailReminderDays1,
			EmailText = @emailText,
			AllowNegative = @allowNegative,
			NegativeTolerance = @negativeTolerance,
			LeaveClassify = @leaveClassify,
			ReportDescription = @reportDescription,
			MaxAccruedBalance = @maxAccruedBalance,
			MinimumLeave = @minimumLeave,
			OverridePositionLevel = @overridePositionLevel,
			PaidOnTermination = @paidOnTermination,
			RequiresCancelApproval = @isApprovalRequired,
			ReasonRequired = @reasonRequired,
			MaximumLeave = @maximumLeave,
			commencementShowDays = @commencementShowDays,
			EmailBackText = @emailbacktext
		WHERE
			id = @id;
			
		RETURN @id;
	END
END
