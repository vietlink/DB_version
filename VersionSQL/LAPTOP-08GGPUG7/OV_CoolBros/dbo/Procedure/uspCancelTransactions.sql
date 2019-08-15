/****** Object:  Procedure [dbo].[uspCancelTransactions]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCancelTransactions](@headerId int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @taken decimal(25,15);
	DECLARE @dateFrom datetime;
	DECLARE @id int;
	DECLARE @leaveTypeId int;
	DECLARE @employeeId int;

	SELECT TOP 1 @id = id, @leaveTypeId = leaveTypeID, @employeeId = EmployeeID, @taken = Taken, @dateFrom = DateFrom FROM LeaveAccrualTransactions WHERE LeaveRequestID = @headerId;	
	--print 'ID = ' + cast(@id as varchar(20)) + ';LeaveType = ' + cast(@leaveTypeId as varchar(10)) + ';EmpID = ' + cast(@employeeId as varchar(20)) + ';Taken = ' + cast(@taken as varchar(30)) + ';DateFrom = ' + cast(@dateFrom as varchar(50))
	WHILE ISNULL(@id,0) > 0 BEGIN
		UPDATE 
			LeaveAccrualTransactions 
		SET
			Balance = Balance + @taken
		WHERE
			EmployeeID = @EmployeeID 
			AND LeaveTypeID = @LeaveTypeID
			AND DateFrom > @dateFrom

		DELETE FROM LeaveAccrualTransactions WHERE id = @id;
		SET @id = 0; SET @employeeId = 0; SET @taken = 0; SET @leaveTypeId = 0; SET @dateFrom = null;
	--	print 'ID = ' + cast(@id as varchar(20)) + ';LeaveType = ' + cast(@leaveTypeId as varchar(10)) + ';EmpID = ' + cast(@employeeId as varchar(20)) + ';Taken = ' + cast(@taken as varchar(30)) + ';DateFrom = ' + cast(@dateFrom as varchar(50))
		SELECT TOP 1 @id = id, @leaveTypeId = leaveTypeID, @employeeId = EmployeeID, @taken = Taken, @dateFrom = DateFrom FROM LeaveAccrualTransactions WHERE LeaveRequestID = @headerId;	
	END    
END

