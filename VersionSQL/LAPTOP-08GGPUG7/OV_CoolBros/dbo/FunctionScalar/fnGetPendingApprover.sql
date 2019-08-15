/****** Object:  Function [dbo].[fnGetPendingApprover]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================

CREATE FUNCTION [dbo].[fnGetPendingApprover](@empId int, @posId int, @epId int, @positionApprovalLevel int, @leaveTypeId int, @isApproved1 bit, @isApproved2 bit)
RETURNS varchar(255)
AS
BEGIN
	-- leave type params
	DECLARE @approvalLevel int;
	DECLARE @approver1 int;
	DECLARE @approver2 int;
	DECLARE @escalate1Id int;
	DECLARE @escalate2Id int;

	SELECT
		@approvalLevel = ApprovalLevel,
		@approver1 = Approver1,
		@approver2 = Approver2,
		@escalate1Id = Escalate1ID,
		@escalate2Id = Escalate2ID
	FROM
		LeaveType
	WHERE
		ID = @leaveTypeId

	IF @positionApprovalLevel = 1
		SET @approvalLevel = 1;
	IF @approvalLevel = 3
		SET	@approvalLevel = 2;

	DECLARE @pendingApprover varchar(255) = '';

	IF @approvalLevel = 1 OR (@approvalLevel = 2 AND @isApproved1 = 0) BEGIN
		IF @isApproved1 = 1 BEGIN
			RETURN '';
		END
	
		IF @approver1 = 1 BEGIN -- 1 = Manager
			SELECT @pendingApprover = dbo.fnGetEmployeeManagerName(@epId);
			RETURN @pendingApprover;
		END 
		ELSE IF @escalate1Id > 0 BEGIN -- id of position
			SELECT @pendingApprover = dbo.fnGetEmployeeNameByPositionID(@escalate1Id);
			RETURN @pendingApprover;
		END

		RETURN '';
	END

	IF @approvalLevel = 2 BEGIN
		IF @isApproved2 = 1 BEGIN
			RETURN '';
		END

		IF @approver2 = 1 BEGIN -- 1 = Manager of approver1
			DECLARE @manager1Id int = dbo.fnGetManagerID(@epId);
			SET @pendingApprover = dbo.fnGetEmployeeManagerName(@manager1Id);
			RETURN @pendingApprover;
		END
		ELSE IF @escalate2Id > 0 BEGIN -- id of position
			SELECT @pendingApprover = dbo.fnGetEmployeeNameByPositionID(@escalate2Id);
			RETURN @pendingApprover;
		END
	END

	RETURN '';

END

