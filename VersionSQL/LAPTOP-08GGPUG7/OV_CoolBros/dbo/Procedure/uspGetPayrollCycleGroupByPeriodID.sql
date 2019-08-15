/****** Object:  Procedure [dbo].[uspGetPayrollCycleGroupByPeriodID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleGroupByPeriodID] 
	-- Add the parameters for the stored procedure here
	@periodID int, @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here	
		SELECT * from PayrollCycleGroups where PayrollCyclePeriodsID=@periodID and IsDeleted= @status
	
END

