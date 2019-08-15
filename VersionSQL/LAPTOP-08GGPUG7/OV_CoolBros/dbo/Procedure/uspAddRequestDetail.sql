/****** Object:  Procedure [dbo].[uspAddRequestDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspAddRequestDetail](@requestId int, @dateFrom datetime, @dateTo datetime, @duration decimal(18,2), @employeeWorkHoursHeaderID int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @empId int = 0;
	SELECT @empId = EmployeeID FROM LeaveRequest WHERE ID = @requestId;

	INSERT INTO LeaveRequestDetail(LeaveRequestID, LeaveDateFrom, LeaveDateTo, Duration, EmployeeWorkHoursHeaderID)
		VALUES(@requestId, @dateFrom, @dateTo, @duration, dbo.fnGetWorkHourHeaderIDByDay(@empId, @dateFrom))
   
END

