/****** Object:  Procedure [dbo].[GetPendingLeave]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Linh Ngo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetPendingLeave] 
	-- Add the parameters for the stored procedure here
	 (@managerEmpId int, @dateTo datetime, @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @leaveTypeFilter varchar(max), @sortBy varchar(max), @groupBy varchar(max))

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @leaveTypeTable TABLE(leaveType varchar(max));
	
	IF CHARINDEX(',', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ',');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END

	IF CHARINDEX(',', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ',');	
    END
    ELSE IF LEN(@departmentFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDepartmentTable(idDepartment) VALUES(@departmentFilterList);	
    END

	IF CHARINDEX(';', @locationFilterList, 0) > 0 BEGIN
		INSERT INTO @idLocationTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@locationFilterList, ';');	
    END
    ELSE IF LEN(@locationFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idLocationTable(idLocation) VALUES(@locationFilterList);	
    END

	IF CHARINDEX(';', @leaveTypeFilter, 0) > 0 BEGIN
		INSERT INTO @leaveTypeTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@leaveTypeFilter, ';');	
    END
    ELSE IF LEN(@leaveTypeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @leaveTypeTable(leaveType) VALUES(@leaveTypeFilter);	
    END	
SELECT * FROM (
	SELECT 
		r.ID as RequestID,
		r.EmployeeID as EmployeeID,		
		t.[ReportDescription] as LeaveType,
		t.Code as LeaveTypeCode,						
		s.[Description] as LeaveStatus,
		s.ShortDescription as LeaveDescription,					
		min(lrd.LeaveDateFrom) over(partition by r.id) as DateFrom,
		max (lrd.LeaveDateTo) over (partition by r.id) as DateTo,
		sum(lrd.duration) over(partition by r.id) as duration,		
		dbo.fnGetDaysFromLeaveHours(e.id, r.id) as Days,		
		e.displayname as DisplayName,
		e.surname as SurName,
		p.title as title,		
		s.Code as leavestatusshortdescription,
		p.orgunit3 as orgunit3,
		p.orgunit2 as orgunit2,
		e.location as location,
		p.ApprovalLevel as ApprovalLevel,
		r.Approver1EPID as approver1,
		r.Approver2EPID as approver2,
		r.Approver3EPID as approver3,
		temp.SubmitedDate as SubmitedDate,
		dbo.fnGetPendingApprover(ep.employeeid, ep.positionid, ep.id, p.ApprovalLevel, r.LeaveTypeID, r.Approved1, r.Approved2) as PendingApprover
	FROM
		LeaveRequest r
	INNER JOIN
		LeaveRequestDetail lrd
	ON
		r.ID=lrd.LeaveRequestID 
	INNER JOIN
		LeaveType t
	ON
		t.ID=r.LeaveTypeID  
	INNER JOIN
		LeaveStatus s
	ON
		s.ID=r.LeaveStatusID 
	INNER JOIN
		Employee e
	ON
		e.ID = r.EmployeeID
		INNER JOIN
		EmployeePosition ep
	ON
		ep.employeeid = e.id 	
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID
	--inner join EmployeePosition ep1 on r.Approver1EPID=ep1.employeeid
	--inner join Employee e1 on ep1.employeeid= e1.id
	--inner join EmployeePosition ep2 on r.Approver2EPID=ep2.employeeid
	--inner join Employee e2 on e2.id= ep2.employeeid
	--inner join EmployeePosition ep3 on r.Approver3EPID= ep3.employeeid
	--inner join Employee e3 on ep3.employeeid=e3.id
	INNER JOIN
		LeaveStatus ls
	ON
		ls.id = r.LeaveStatusID
	INNER JOIN
		(select distinct lsh.LeaveRequestID, min(lsh.Date) over(partition by lsh.LeaveRequestID) as SubmitedDate
		from LeaveStatusHistory lsh) as temp
	ON
		r.ID=temp.LeaveRequestID 
	WHERE
		ep.primaryposition='Y' and ep.isdeleted = 0 and
		r.IsCancelled = 0 AND
		DateFrom <= @dateTo AND
		(s.Code='P' or s.Code='PC')		
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR isnull(p.orgunit3,'(Blank)') IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR isnull(p.orgunit2,'(Blank)') IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR isnull(e.location,'(Blank)') IN (SELECT * FROM @idLocationTable))
		AND ((SELECT COUNT(*) FROM @leaveTypeTable) = 0 OR t.[ReportDescription] IN (SELECT * FROM @leaveTypeTable))) As result					
	ORDER BY		
		CASE WHEN @groupBy = 'orgunit2' THEN result.orgunit2 END,		
		CASE WHEN @groupBy = 'orgunit3' THEN result.orgunit3 END,
		CASE WHEN @groupBy = 'location' THEN result.location END,
		CASE WHEN @groupBy = 'pendingapprover' THEN result.PendingApprover END,
		CASE WHEN @groupBy = 'leavestatus' THEN result.leavestatusshortdescription end,
		CASE WHEN @groupBy= 'leavetype' or @sortBy='leavetype' THEN result.LeaveType END,		
		CASE WHEN @sortBy = 'orgunit2' THEN result.orgunit2 END,
		CASE WHEN @sortBy = 'orgunit3' THEN result.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN result.displayname END,
		CASE WHEN @sortBy = 'surname' THEN result.surname END,
		CASE WHEN @sortBy= 'title' THEN result.title END,				
		result.displayname	
END
