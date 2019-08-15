/****** Object:  Procedure [dbo].[uspGetPayrollCycleForExportingDetail]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleForExportingDetail] 
	-- Add the parameters for the stored procedure here	
	@isFinalisedInclude int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		p.ID as id,
		p.Description as description,
		p.FromDate, p.ToDate,
		p.Code as code
	from PayrollCycle p
	INNER JOIN PayrollStatus ps ON p.PayrollStatusID= ps.ID
	LEFT OUTER JOIN PayrollCycleGroups pg ON p.PayrollCycleGroupID= pg.ID
	LEFT OUTER JOIN PayrollCyclePeriods pp ON p.PayrollCyclePeriodID= pp.ID
	where p.isDeleted=0 and pg.isDeleted=0 and pp.IsDeleted=0
	and (((@isFinalisedInclude=0) and ps.Code='O') or @isFinalisedInclude=1)
END

