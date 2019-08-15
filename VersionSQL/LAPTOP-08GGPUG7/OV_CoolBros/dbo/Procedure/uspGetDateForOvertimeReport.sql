/****** Object:  Procedure [dbo].[uspGetDateForOvertimeReport]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDateForOvertimeReport] 
	-- Add the parameters for the stored procedure here
	@paycycleGroupID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT pc.ID,
	pc.FromDate,
	pc.ToDate
	FROM PayrollCycle pc
	INNER JOIN PayrollCycleGroups pg ON pc.PayrollCycleGroupID = pg.ID
	INNER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.ID
	WHERE pc.PayrollCycleGroupID=@paycycleGroupID
	AND pc.FromDate<= convert(datetime,convert(varchar(8),getdate(),112))
	and pc.isDeleted=0 and pg.isDeleted=0 and pp.IsDeleted=0
	ORDER BY pc.FromDate DESC
END

