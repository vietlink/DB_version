/****** Object:  Function [dbo].[fnGetLeaveIDsByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLeaveIDsByDate](@date datetime, @headerId int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		lr.id
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.ID = lrd.LeaveRequestID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = lr.LeaveStatusID
	WHERE
		lrd.LeaveDateFrom = @date AND lr.EmployeeWorkHoursHeaderID = @headerId AND (ls.Code = 'A' OR ls.Code = 'P')
)

