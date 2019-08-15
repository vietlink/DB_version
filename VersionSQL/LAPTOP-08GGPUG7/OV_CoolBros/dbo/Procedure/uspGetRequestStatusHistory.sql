/****** Object:  Procedure [dbo].[uspGetRequestStatusHistory]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRequestStatusHistory](@requestId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		lsh.*,
		ls.[Description] as LeaveStatus,
		ls.Code as LeaveStatusCode,
		e.Displayname,
		eApp1.Displayname as Approver1,
		eApp2.Displayname as Approver2,
		case when (p.ApprovalLevel > 1 or lt.overridepositionlevel = 1) then lt.ApprovalLevel else p.ApprovalLevel end as ApprovalLevel,
		eAction.displayname as ActionedByEmployee
	FROM
		LeaveStatusHistory lsh
	INNER JOIN
		LeaveStatus ls
	ON
		ls.ID = lsh.LeaveStatusID
	INNER JOIN
		LeaveRequest r
	ON
		r.id = lsh.LeaveRequestID
	INNER JOIN
		Employee e
	ON
		e.ID = ISNULL(lsh.SubmittedByID, r.EmployeeID)
	INNER JOIN
		EmployeePosition ep
	ON
		ep.EmployeeID = e.ID AND ep.primaryposition = 'Y' AND ep.IsDeleted = 0
	INNER JOIN
		Employee eAction
	ON
		eAction.ID = lsh.ApproverEmployeeID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN
		LeaveType lt
	ON
		lt.ID = r.LeaveTypeID
	LEFT OUTER JOIN
		EmployeePosition epApp1
	ON
		epApp1.ID = r.Approver1EPID
	LEFT OUTER JOIN
		Employee eApp1
	ON
		epApp1.EmployeeID = eApp1.ID
	LEFT OUTER JOIN
		EmployeePosition epApp2
	ON
		epApp2.ID = r.Approver2EPID
	LEFT OUTER JOIN
		Employee eApp2
	ON
		epApp2.EmployeeID = eApp2.ID
	WHERE
		r.id = @requestId

	ORDER BY [Date] DESC

END

