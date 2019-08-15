/****** Object:  Procedure [dbo].[uspNoBookedLeave]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Viet Linh
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspNoBookedLeave] 
	-- Add the parameters for the stored procedure here
	(@managerEmpId int, @dateFrom datetime, @dateTo datetime, @divisionFilterList varchar(max), @departmentFilterList varchar(max), @locationFilterList varchar(max), @sortBy varchar(max), @groupBy varchar(max))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idDepartmentTable TABLE(idDepartment varchar(max));
	DECLARE @idDivisionTable TABLE(idDivision varchar(max));
	DECLARE @idLocationTable TABLE(idLocation varchar(max));
	DECLARE @leaveTypeTable TABLE(leaveType varchar(max));
	IF CHARINDEX(';', @divisionFilterList, 0) > 0 BEGIN
		INSERT INTO @idDivisionTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@divisionFilterList, ';');	
    END
    ELSE IF LEN(@divisionFilterList) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idDivisionTable(idDivision) VALUES(@divisionFilterList);	
    END

	IF CHARINDEX(';', @departmentFilterList, 0) > 0 BEGIN
		INSERT INTO @idDepartmentTable-- split the text by , and store in temp table
		SELECT CAST(splitdata AS varchar) FROM fnSplitString(@departmentFilterList, ';');	
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

    SELECT
		e.id as EmployeeID,
		p.ID as PositionID,
		ep.ID as EpID,		
		Null as LeaveType,
		Null as LeaveTypeCode,
		NULL as BackgroundColour,
		NULL as FontColour,
		Null as LeaveID,
		Null as LeaveStatus,
		Null as LeaveStatusShortDescription,
		Null as LeaveReason,
		--r.LeaveContactDetails,
		--r.ApproverComments,
		--r.TimePeriodRequested,
		null as DateFrom,
		NULL as DateTo,
		NULL as ExclWeekends,
		NULL as ExclPublicHolidays,
		NULL as WorkHours,
		NULL as ActualHours,
		NULL as Days,
		NULL as RequestID,
		e.displayname as DisplayName,
		p.title as position,
		NULL as duration,
		null as leavestatusshortdescription,
		p.orgunit3 as department,
		p.orgunit2 as division,
		p.location as location,
		0 as BookedLeave
	FROM	
		Employee e
	INNER JOIN
		EmployeePosition ep	
	ON
		ep.employeeid = e.id and ep.isdeleted = 0
	INNER JOIN
		EmployeePosition epM
	ON
		epM.EmployeeID = @managerEmpId AND epM.id = ep.ManagerID
	INNER JOIN
		Position p
	ON
		p.ID = ep.PositionID	
	WHERE
		e.id NOT IN (select r.employeeid 
					from LeaveRequest as r INNER JOIN LeaveRequestDetail as lrd on r.id=lrd.LeaveRequestID
					where @dateFrom <= lrd.LeaveDateFrom and @dateTo>=lrd.LeaveDateFrom)
		AND ((SELECT COUNT(*) FROM @idDepartmentTable) = 0 OR p.orgunit3 IN (SELECT * FROM @idDepartmentTable))
		AND ((SELECT COUNT(*) FROM @idDivisionTable) = 0 OR p.orgunit2 IN (SELECT * FROM @idDivisionTable))
		AND ((SELECT COUNT(*) FROM @idLocationTable) = 0 OR e.location IN (SELECT * FROM @idLocationTable))		
	ORDER BY		
		CASE WHEN @groupBy = 'division' THEN p.orgunit2 END,		
		CASE WHEN @groupBy = 'department' THEN p.orgunit3 END,
		CASE WHEN @sortBy = 'displayname' THEN e.displayname END,		
		CASE WHEN @sortBy = 'division' THEN p.orgunit2 END,		
		CASE WHEN @sortBy = 'department' THEN p.orgunit3 END				
END

