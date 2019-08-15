/****** Object:  Procedure [dbo].[uspGetPayrollGroupByStatus]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollGroupByStatus] 
	-- Add the parameters for the stored procedure here
	@status int, @periodID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@status<>2) BEGIN
		SELECT *
		FROM PayrollCycleGroups 
		WHERE isDeleted =@status
		AND PayrollCyclePeriodsID=@periodID
	END 
	ELSE BEGIN
		SELECT * FROM PayrollCycleGroups WHERE PayrollCyclePeriodsID=@periodID
	END
END

