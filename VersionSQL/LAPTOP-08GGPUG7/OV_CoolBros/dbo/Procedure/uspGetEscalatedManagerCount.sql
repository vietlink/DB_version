/****** Object:  Procedure [dbo].[uspGetEscalatedManagerCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEscalatedManagerCount](@managerEmpId int, @managerPosId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		COUNT(*) as [count]
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		lrd.LeaveRequestID = r.ID
	INNER JOIN
		LeaveType t
	ON
		r.LeaveTypeID = t.ID
	INNER JOIN
		LeaveStatus s
	ON
		r.LeaveStatusID = s.ID
	INNER JOIN
		EmployeeWorkHours ewh
	ON
	 	ewh.EmployeeID = r.EmployeeID AND ewh.DayCode = DATENAME(dw, r.DateFrom)
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND ep.primaryposition = 'Y'
	LEFT OUTER JOIN
		EmployeePosition epM
	ON
		epM.id = ep.ManagerID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		r.IsCancelled = 0 AND
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID
		AND ewh.[Enabled] = 1 AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom)
		AND 
		(
			(
				(t.Escalate1ID = @managerPosId OR t.Escalate2ID = @managerPosId)
				OR
				(t.Approver2 = 1 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)))
				OR
				(t.Approver2 = 2 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)))
			)

		)
	--	AND (p.ApprovalLevel = 2 OR t.overridepositionlevel = 1)
	--	AND
	--	(r.Approver2EPID IS NULL AND (t.ApprovalLevel = 2 OR (t.ApprovalLevel = 3 AND r.Approver1EPID IS NOT NULL)))
END
