/****** Object:  Procedure [dbo].[uspGetLeaveApprover]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveApprover](@requestId int, @approvalLevel int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @value bit;
	DECLARE @epId int;

	IF @approvalLevel = 1
		SELECT @value = Approved1, @epId = Approver1EPID FROM LeaveRequest WHERE ID = @requestId
	IF @approvalLevel = 2
		SELECT @value = Approved2, @epId = Approver2EPID FROM LeaveRequest WHERE ID = @requestId
	IF @approvalLevel = 3
		SELECT @value = ApprovedNegative, @epId = Approver3EPID FROM LeaveRequest WHERE ID = @requestId

	SELECT @value as value, @epId as epId
END

