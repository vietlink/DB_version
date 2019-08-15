/****** Object:  Procedure [dbo].[uspGetLeaveTypesByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetLeaveTypesByDate](@empId int, @hourHeaderID int, @date Datetime, @requestId int = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @hourHeaderID = dbo.fnGetWorkHourHeaderIDByDay(@empId, @date)

	--IF @requestId <> 0 BEGIN
	--	DECLARE @dateFrom datetime;
	--	SELECT @dateFrom = DateFrom FROM LeaveRequest WHERE ID = @requestId;
	--	SET @hourHeaderID = dbo.fnGetWorkHourHeaderIDByDay(@empId, @dateFrom)
	--END

	IF @empId = 0 BEGIN
		SELECT * FROM LeaveType ORDER BY ISNULL(LeaveClassify, 99), [Description]
	END
	ELSE BEGIN
		DECLARE @commencement DateTime;
		SELECT @commencement = commencement FROM Employee WHERE ID = @empId;

		SELECT
			*
		FROM
			LeaveType 
		WHERE 
			(@date >= DATEADD (day, CanApplyAfterDays,@commencement) OR (ISNULL(CanApplyAfterDays, 0) = 0) )
			AND
			ID IN 
			(SELECT LeaveTypeID FROM EmployeeLeaveTypes WHERE EmployeeID = @empId AND [enabled] = 1 AND EmployeeWorkHoursHeaderID = @hourHeaderID) AND code <> 'P'
		 ORDER BY ISNULL(LeaveClassify, 99), [Description]
	END
END
