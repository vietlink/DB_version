/****** Object:  Procedure [dbo].[uspDoesLeaveStartToday]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDoesLeaveStartToday](@dateTime datetime, @empId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		ISNULL(r.ID, 0) as ID
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveStatus ls
	ON
		r.LeaveStatusID = ls.ID
	WHERE
		Convert(DateTime, DATEDIFF(DAY, 0, r.DateFrom)) = @dateTime AND r.EmployeeID = @empId AND ls.Code = 'a';
END

