/****** Object:  Function [dbo].[fnGetTOILApprover]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetTOILApprover] 
(
	-- Add the parameters for the function here
	@epID int
)
RETURNS varchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(max)
	DECLARE @approver1 int = (SELECT TOP 1 TOILApprover1 FROM TimesheetSettings)
	DECLARE @approver1PosID int= (SELECT TOP 1 TOILApprover1PositionID FROM TimesheetSettings)
	-- Add the T-SQL statements to compute the return value here
	IF (@approver1=1) BEGIN
		SET @Result = dbo.fnGetEmployeeManagerName(@epID)
	END ELSE BEGIN
		SET @Result = (SELECT TOP 1
		e.Displayname
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

