/****** Object:  Procedure [dbo].[uspGetAllLeaveRequests]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllLeaveRequests](@empId int, @typeFilter varchar(1000))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @idTable TABLE(id int);
	DECLARE @otherClassify int = 5;
	IF CHARINDEX(',', @typeFilter, 0) > 0 BEGIN
		INSERT INTO @idTable -- split the text by , and store in temp table
		SELECT CAST(splitdata AS int) FROM fnSplitString(@typeFilter, ',');
	--	INSERT INTO @idTable SELECT @publicHolidayTypeID;
    END
    ELSE IF LEN(@typeFilter) > 0 BEGIN -- if text existst without a , then assume 1 id
		INSERT INTO @idTable(id) VALUES(CAST(@typeFilter AS int));
	--	INSERT INTO @idTable SELECT @publicHolidayTypeID;
    END
    SELECT
		r.EmployeeID,
		'' as Title,
		t.[Description] as LeaveType,
		t.Code as LeaveTypeCode,
		t.BackgroundColour,
		t.FontColour,
		dbo.fnGetLeaveStatus(r.id) as LeaveStatus,
		r.ReasonForLeave,
		r.LeaveContactDetails,
		isnull(r.ApproverComments, '') as ApproverComments,
		r.TimePeriodRequested,
		r.DateFrom,
		r.DateTo,
		r.ExclWeekends,
		r.ExclPublicHolidays,
		CAST(r.TimePeriodRequested as decimal(18,5)) as ActualHours,
		dbo.fnGetDaysFromLeaveHours(r.employeeid, r.ID) as Days,
		r.ID as RequestID,
		s.shortdescription as leavestatusshortdescription,
		t.ReportDescription
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
	WHERE
		r.EmployeeID = @empId
		AND ((SELECT COUNT(*) FROM @idTable) = 0 OR t.ID IN (SELECT lt2.id FROM @idTable idt INNER JOIN LeaveType lt ON lt.id = idt.id INNER JOIN LeaveType lt2 ON lt2.LeaveClassify = lt.LeaveClassify WHERE lt2.ID = idt.id OR lt2.LeaveClassify <> @otherClassify))
	ORDER BY r.DateTo DESC
		
END
