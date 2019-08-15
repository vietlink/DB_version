/****** Object:  Procedure [dbo].[uspAddLeaveStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddLeaveStatusHistory](@requestId int, @approverEmpId int, @code varchar(10), @comments varchar(max), @state int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @leaveStatusID int = 0;
	SELECT @leaveStatusID  = id FROM LeaveStatus WHERE code = @code;

	INSERT INTO LeaveStatusHistory(ApproverEmployeeID, LeaveRequestID, [Date], LeaveStatusID, Comment, [State])
		VALUES(@approverEmpId, @requestId, GETDATE(), @leaveStatusID, @comments, @state);
END

