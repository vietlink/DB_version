/****** Object:  Procedure [dbo].[uspApproveTimesheet]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspApproveTimesheet](@employeeId int, @payrollCycleId int, @actionEmpId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @statusId int = 0;
	SELECT @statusId = ID FROM TimesheetStatus WHERE Code = 'AT';

	DECLARE @headerId int = 0;
	SELECT 
		@headerId = id 
	FROM
		TimesheetHeader
	WHERE
		EmployeeID = @employeeId AND PayrollCycleID = @payrollCycleId;

    UPDATE
		TimesheetHeader
	SET
	--	TimesheetStatusID = @statusId,
		islocked = 1,
		LastUpdated = GETDATE(),
		IsTimesheetApproved = 1
	WHERE
		ID = @headerId;

	IF dbo.fnGetTimesheetAdjustmentCount(@headerId) = 0 BEGIN
	    UPDATE
			TimesheetHeader
		SET
			IsAdditionalApproved = 1
		WHERE
			ID = @headerId;
	END

	INSERT INTO
		TimesheetStatusHistory(ApproverEmployeeID, TimesheetHeaderID, [Date], TimesheetStatusID)
	VALUES(@actionEmpId, @headerId, GETDATE(), @statusId);

	DECLARE @isAdditional bit;
	DECLARE @isApproved bit;

	SELECT @isAdditional = IsAdditionalApproved, @isApproved = IsTimesheetApproved FROM TimesheetHeader WHERE ID = @headerId;

	IF @isAdditional = 1 AND @isApproved = 1 BEGIN
		DECLARE @approvedId int = 0;
		SELECT @approvedId = ID FROM TimesheetStatus WHERE Code = 'A';

		DECLARE @additionalId int = 0;
		SELECT @additionalId = ID FROM TimesheetStatus WHERE Code = 'AA';

		DECLARE @hasChanged bit = 0;
		
		SELECT @hasChanged = ISNULL(HasBeenAdjusted, 0) FROM TimesheetStatusHistory WHERE TimesheetStatusID = @additionalId AND TimeSheetHeaderID = @headerId

		INSERT INTO
			TimesheetStatusHistory(ApproverEmployeeID, TimesheetHeaderID, [Date], TimesheetStatusID, HasBeenAdjusted)
				VALUES(@actionEmpId, @headerId, DATEADD (ss, 1, GETDATE()), @approvedId, @hasChanged);

		UPDATE
			TimesheetHeader
		SET
			TimesheetStatusID = @approvedId
		WHERE
			ID = @headerId;

		EXEC dbo.uspCreateTOILFromTimesheet @headerId;
	END
END

