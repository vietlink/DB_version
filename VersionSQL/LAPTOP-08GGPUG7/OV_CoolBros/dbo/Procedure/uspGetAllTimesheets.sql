/****** Object:  Procedure [dbo].[uspGetAllTimesheets]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllTimesheets](@search varchar(255), @filterPayCycleId int, @filterEmpId int, @statusList varchar(255), @sortApproveList varchar(50), @hideApproved bit)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @statusTable TABLE(id int);
	IF CHARINDEX(',', @statusList, 0) > 0 BEGIN
		INSERT INTO @statusTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@statusList, ',');	
    END ELSE IF LEN(@statusList) > 0 BEGIN
		INSERT INTO @statusTable SELECT CAST(@statusList AS int)
	END

	DECLARE @approvedId int = 0;
	SELECT @approvedId = ID FROM TimesheetStatus WHERE Code = 'A'
	DECLARE @rejectId int = 0;
	SELECT @rejectId = ID FROM TimesheetStatus WHERE Code = 'R'
	DECLARE @submittedId int = 0;
	SELECT @submittedId = ID FROM TimesheetStatus WHERE Code = 'S'

	SELECT * FROM(
    SELECT
		ts.id, ts.islocked, ts.createdby, ts.CreatedDate, e.id as employeeid, e.displayname, p.title, pc.fromdate, pc.todate, tss.Description as [status], pc.id as payrollcycleid, approverE.displayname as ApproverName, tsh.[Date] as ApproverDate, tss.code as statuscode, submitE.displayname as SubmittedBy, tsh2.[Date] AS SubmittedDate, ts.istimesheetapproved, ts.isadditionalapproved, ts.RequiresAdditionalApproval
	FROM
		TimesheetHeader ts
	INNER JOIN
		PayrollCycle pc
	ON
		ts.PayrollCycleID = pc.id
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pc.PayrollCycleGroupID = pcg.ID
	INNER JOIN
		TimesheetStatus tss
	ON
		tss.ID = ts.TimesheetStatusID
	INNER JOIN
		Employee e
	ON
		e.ID = ts.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND ep.primaryposition = 'Y'
	INNER JOIN
		Position p
	ON
		p.ID = ep.positionid
	LEFT OUTER JOIN
		TimesheetStatusHistory tsh
	ON
		tsh.TimesheetHeaderID = ts.ID AND (tsh.TimesheetStatusID = @approvedId OR tsh.TimesheetStatusID = @rejectId) AND tsh.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = ts.ID GROUP BY _tsh.TimesheetHeaderID)
	LEFT OUTER JOIN
		Employee approverE
	ON	
		approverE.ID = tsh.ApproverEmployeeID

	LEFT OUTER JOIN
		TimesheetStatusHistory tsh2
	ON
		tsh2.TimesheetHeaderID = ts.ID AND (tsh2.TimesheetStatusID = @submittedId) AND tsh2.[Date] = (SELECT MAX([Date]) FROM TimeSheetStatusHistory _tsh WHERE _tsh.TimesheetHeaderID = ts.ID AND _tsh.TimesheetStatusID = @submittedId GROUP BY _tsh.TimesheetHeaderID)
	LEFT OUTER JOIN
		Employee submitE
	ON	
		submitE.ID = tsh2.ApproverEmployeeID

	WHERE
		(e.displayname like '%' + @search + '%' OR p.title like '%' + @search + '%')
		AND
		(@filterPayCycleId = 0 OR pc.ID = @filterPayCycleId)
		AND
		(@filterEmpId = 0 OR e.ID = @filterEmpId)
		AND
		(@statusList = '' OR ts.TimesheetStatusID IN (SELECT ID FROM @statusTable))
		AND
		(@hideApproved = 0 OR (ts.IsTimesheetApproved = 0 AND @hideApproved = 1))
	UNION ALL
	SELECT
		0 as id, 0 as islocked, '' as createdby, null as CreatedDate, ewh.EmployeeID as employeeid, e.displayname, p.title, pc.fromdate, pc.todate, 'Not Entered' as [status], pc.id as payrollcycleid, '' as ApproverName, null as ApproverDate, 'n' as statuscode,  '' as SubmittedBy, null AS SubmittedDate, 0 as istimesheetapproved, 0 as isadditionalapproved, 0 as RequiresAdditionalApproval
	FROM
		PayrollCycle pc
	INNER JOIN
		EmployeeWorkHoursHeader ewh
	ON
		ewh.PayRollCycle = pc.PayrollCycleGroupID
	INNER JOIN
		Employee e
	ON
		e.ID = ewh.EmployeeID
	INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id and ep.isdeleted = 0 AND ep.primaryposition = 'Y'
	INNER JOIN
		Position p
	ON
		p.ID = ep.positionid
	LEFT OUTER JOIN
		TimesheetHeader ts
	ON
		ts.PayrollCycleID = pc.ID AND ts.EmployeeID = e.ID
	WHERE
--		((GETDATE() BETWEEN FromDate AND ToDate) OR ToDate < GETDATE())
--		AND
		ts.ID IS NULL
		AND
		0 in (SELECT * FROM @statusTable)
		AND
		(e.displayname like '%' + @search + '%' OR p.title like '%' + @search + '%')
		AND
		(@filterPayCycleId = 0 OR pc.ID = @filterPayCycleId)
		AND
		(@filterEmpId = 0 OR e.ID = @filterEmpId)
	) as rs
	ORDER BY
		CASE WHEN @sortApproveList = 'name' THEN displayname
		WHEN @sortApproveList = 'position' THEN title
		WHEN @sortApproveList = 'status' THEN [status]
		WHEN @sortApproveList = 'submittedby' THEN CreatedBy
		WHEN @sortApproveList = 'approver' THEN ApproverName END,
		
		CASE WHEN @sortApproveList = 'dateapproved' THEN ApproverDate
		WHEN @sortApproveList = 'submitteddate' THEN CreatedDate
		WHEN @sortApproveList = 'cycle' THEN fromdate END,

		CASE WHEN @sortApproveList = 'istimesheetapproved' THEN IsTimesheetApproved
		WHEN @sortApproveList = 'isadditionalapproved' THEN IsAdditionalApproved END
		
END

