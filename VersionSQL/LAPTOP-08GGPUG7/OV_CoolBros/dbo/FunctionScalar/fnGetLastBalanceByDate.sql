/****** Object:  Function [dbo].[fnGetLastBalanceByDate]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetLastBalanceByDate](@empId int, @leaveTypeId int, @date DateTime)
RETURNS decimal(25,15)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result decimal(25,15)
	SELECT TOP 1 @result = Balance FROM LeaveAccrualTransactions
	WHERE LeaveTypeID = @leaveTypeId AND EmployeeID = @empId AND DateFrom <= @date
	ORDER BY DateFrom DESC, ID DESC

	RETURN ISNULL(@result, 0.0);

END

