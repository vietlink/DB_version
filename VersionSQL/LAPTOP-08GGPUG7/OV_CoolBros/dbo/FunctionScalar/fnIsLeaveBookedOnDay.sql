/****** Object:  Function [dbo].[fnIsLeaveBookedOnDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnIsLeaveBookedOnDay](@date DateTime, @headerId int)
RETURNS int
AS
BEGIN
	DECLARE @id int = 0;
	SELECT 
		@id = lrd.id
	FROM
		LeaveRequestDetail lrd
	INNER JOIN
		LeaveRequest lr
	ON
		lr.ID = lrd.LeaveRequestID
	WHERE
		lrd.LeaveDateFrom = @date AND lr.EmployeeWorkHoursHeaderID = @headerId

	RETURN @id
END

