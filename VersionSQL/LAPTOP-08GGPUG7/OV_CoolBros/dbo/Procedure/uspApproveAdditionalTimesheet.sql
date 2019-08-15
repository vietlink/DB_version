/****** Object:  Procedure [dbo].[uspApproveAdditionalTimesheet]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspApproveAdditionalTimesheet](@employeeId int, @payrollCycleId int, @actionEmpId int, @hasBeenAdjusted bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @statusId int = 0;
	SELECT @statusId = ID FROM TimesheetStatus WHERE Code = 'AA';

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
		IsAdditionalApproved = 1
	WHERE
		ID = @headerId;

	INSERT INTO
		TimesheetStatusHistory(ApproverEmployeeID, TimesheetHeaderID, [Date], TimesheetStatusID, HasBeenAdjusted)
	VALUES(@actionEmpId, @headerId, GETDATE(), @statusId, @hasBeenAdjusted);

	DECLARE @isAdditional bit;
	DECLARE @isApproved bit;

	SELECT @isAdditional = IsAdditionalApproved, @isApproved = IsTimesheetApproved FROM TimesheetHeader WHERE ID = @headerId;

	IF @isAdditional = 1 AND @isApproved = 1 BEGIN
		DECLARE @approvedId int = 0;
		SELECT @approvedId = ID FROM TimesheetStatus WHERE Code = 'A';
		INSERT INTO
			TimesheetStatusHistory(ApproverEmployeeID, TimesheetHeaderID, [Date], TimesheetStatusID, HasBeenAdjusted)
				VALUES(@actionEmpId, @headerId, DATEADD (ss, 1, GETDATE()), @approvedId, @hasBeenAdjusted);

		UPDATE
			TimesheetHeader
		SET
			TimesheetStatusID = @approvedId
		WHERE
			ID = @headerId;

		EXEC dbo.uspCreateTOILFromTimesheet @headerId;
	END
END

