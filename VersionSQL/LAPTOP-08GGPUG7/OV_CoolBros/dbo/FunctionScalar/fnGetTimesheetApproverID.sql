/****** Object:  Function [dbo].[fnGetTimesheetApproverID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetTimesheetApproverID] 
(
	-- Add the parameters for the function here
	@epID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)
	DECLARE @approver1 int = (SELECT TOP 1 Approver1 FROM TimesheetSettings)
	DECLARE @approver1PosID int= (SELECT TOP 1 Approver1PositionID FROM TimesheetSettings)
	-- Add the T-SQL statements to compute the return value here
	IF (@approver1=1) BEGIN
		SET @Result = (SELECT
		TOP 1 e.id
	FROM
		EmployeePosition ep
	INNER JOIN
		EmployeePosition mEp
	ON
		mEp.ID = ep.ManagerID
	INNER JOIN
		Employee e
	ON
		e.ID = mEp.EmployeeID
	WHERE
		ep.ID = @epID)
	END ELSE BEGIN
		SET @Result = (SELECT TOP 1
		e.id
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e	
	ON
		e.ID = ep.EmployeeID
	WHERE
		ep.PositionID = @approver1PosID AND ep.primaryposition = 'Y' AND ep.IsDeleted = 0
		AND e.status='Active'
		AND ep.startdate<= GETDATE() AND (ep.enddate>= GETDATE() OR ep.enddate IS NULL))
	END	

	-- Return the result of the function
	RETURN @Result

END

