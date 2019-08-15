/****** Object:  Function [dbo].[fnGetTotalBalancePerDay]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[fnGetTotalBalancePerDay] 
(
	-- Add the parameters for the function here
	@date datetime, @leaveTypeID int
)
RETURNS decimal
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result decimal

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result = sum(lat.Balance)
	from LeaveAccrualTransactions lat 
	inner join Employee e on lat.EmployeeID= e.id
	inner join EmployeePosition ep on e.id= ep.employeeid
	inner join Position p on ep.positionid=p.id
	inner join EmployeeWorkHoursHeader ewh on e.id= ewh.EmployeeID
	inner join LeaveType t on lat.LeaveTypeID=t.ID
	where lat.DateFrom=@date and lat.LeaveTypeID=@leaveTypeID
	and ep.primaryposition='Y' and ep.IsDeleted=0
	and dbo.fnGetWorkHourHeaderIDByDay(e.id, @date)=ewh.ID
	-- Return the result of the function
	RETURN @Result

END

