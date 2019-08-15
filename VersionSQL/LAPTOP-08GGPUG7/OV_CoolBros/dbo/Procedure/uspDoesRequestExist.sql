/****** Object:  Procedure [dbo].[uspDoesRequestExist]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDoesRequestExist](@empId int, @date datetime, @typeId int, @requestId int = 0, @isFillMode bit = 0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @duration decimal(18, 2)

	SELECT
		rd.Duration as result,
		ls.ShortDescription as [ShortStatus],
		r.ID,
		r.IsCancelled
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveRequestDetail rd
	ON
		rd.LeaveRequestID = r.ID
	INNER JOIN
		LeaveStatus ls
	ON
		r.LeaveStatusID = ls.ID AND ls.Code <> 'r'
	WHERE
		(((@requestId = r.Id AND (r.IsCancelled = 1 OR r.IsCancelled = 0)) OR r.IsCancelled = 0)) AND r.EmployeeID = @empId AND rd.LeaveDateFrom = @date-- AND r.LeaveTypeID = @typeId

END

