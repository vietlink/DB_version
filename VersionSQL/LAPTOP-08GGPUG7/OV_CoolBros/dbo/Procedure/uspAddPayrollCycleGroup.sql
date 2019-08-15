/****** Object:  Procedure [dbo].[uspAddPayrollCycleGroup]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddPayrollCycleGroup] 
	-- Add the parameters for the stored procedure here
	@description varchar(300), @PayrollCyclePeriodsID int, @status bit, @startID int, @isNull int, @accountsSystemID int, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@isNull=0) begin
		set @startID=1;
	end
	if (@status=0) begin
		update PayrollCycleGroups
		set 		
		PayrollCyclePeriodsID = @PayrollCyclePeriodsID,
		IsDeleted = @status,
		StartDayIndex = @startID,
		AccountsSystemID = @accountsSystemID
		where Description = @description
		set @ReturnValue=1;
	end
	else begin
		insert into PayrollCycleGroups(Description, PayrollCyclePeriodsID, StartDayIndex, AccountsSystemID)
		values
		(
		@description,
		@PayrollCyclePeriodsID, 
		@startID,
		@accountsSystemID
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

