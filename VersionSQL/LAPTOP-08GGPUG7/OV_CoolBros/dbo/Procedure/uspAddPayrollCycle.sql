/****** Object:  Procedure [dbo].[uspAddPayrollCycle]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddPayrollCycle] 
	-- Add the parameters for the stored procedure here
	@description varchar(max), @fromDate datetime, @toDate datetime, @PayrollCyclePeriodsID int, @PayrollCycleGroupsID int, @status bit, @ReturnValue int output
	  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@status=1) begin
		update PayrollCycle
		set 				
		FromDate = @fromDate,
		ToDate = @toDate,
		PayrollCyclePeriodID = @PayrollCyclePeriodsID,
		PayrollCycleGroupID = @PayrollCycleGroupsID,
		IsDeleted = 0
		where Description = @description
		set @ReturnValue=1;
	end
	else begin
		insert into PayrollCycle(Code, PayrollCycleType, Description, FromDate, ToDate, PayrollCyclePeriodID, PayrollCycleGroupID)
		values
		(
		'',
		'',
		@description,
		@fromDate,
		@toDate,
		@PayrollCyclePeriodsID,
		@PayrollCycleGroupsID
		)
		set @ReturnValue= @@IDENTITY
	end
	
END

