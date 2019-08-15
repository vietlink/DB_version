/****** Object:  Procedure [dbo].[uspGetLastLeaveRequestDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLastLeaveRequestDate](@empId int, @leaveTypeId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT MAX(DateTo) as DateTo FROM LeaveRequest WHERE EmployeeID = @empId AND LeaveTypeID = @leaveTypeId;
END

