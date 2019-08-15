/****** Object:  Procedure [dbo].[uspGetEscalatedManagerPendingCount]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEscalatedManagerPendingCount](@managerEmpId int, @managerPosId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    SELECT
		Count(*) as [count]
	FROM
		LeaveRequest r
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
	 	ewh.EmployeeID = r.EmployeeID
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND primaryposition = 'Y'
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	LEFT OUTER JOIN
		EmployeePosition epM
	ON
		epM.id = ep.ManagerID
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	WHERE
		r.IsCancelled = 0 AND
		ewh.EmployeeWorkHoursHeaderID = r.EmployeeWorkHoursHeaderID AND ewh.DayCode = DATENAME(dw, r.DateFrom) AND ewh.[Enabled] = 1 AND ewh.[week] = dbo.fnGetWeekByHeaderDate(r.EmployeeWorkHoursHeaderID, r.DateFrom) AND (ls.Code = 'P' OR ls.code = 'PC')
		AND 
		(
			(	
				(
					(t.Escalate1ID = @managerPosId AND r.Approver1EPID IS NULL) OR
					(t.Escalate2ID = @managerPosId AND (t.ApprovalLevel = 1 OR p.ApprovalLevel = 1)) OR
					(t.Escalate2ID = @managerPosId AND (t.ApprovalLevel = 2 OR (t.ApprovalLevel = 3 AND r.Approver1EPID IS NOT NULL)) AND r.Approver2EPID IS NULL AND (p.ApprovalLevel = 2 OR t.OverridePositionLevel = 1))
				)
				OR
				(t.Approver2 = 1 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsByManagerID(@managerEmpId)) AND ((t.ApprovalLevel = 1 OR t.ApprovalLevel = 2) OR (t.ApprovalLevel = 3 AND r.Approver1EPID IS NOT NULL)) AND r.Approver2EPID IS NULL AND (p.ApprovalLevel = 2 OR t.OverridePositionLevel = 1))
				OR
				(t.Approver2 = 2 AND epM.ID IN (SELECT * FROM dbo.fnGetChildrenIDsBySupervisorID(@managerPosId)) AND ((t.ApprovalLevel = 1 OR t.ApprovalLevel = 2) OR (t.ApprovalLevel = 3 AND r.Approver1EPID IS NOT NULL)) AND r.Approver2EPID IS NULL AND (p.ApprovalLevel = 2 OR t.OverridePositionLevel = 1))
			)

		)
END
