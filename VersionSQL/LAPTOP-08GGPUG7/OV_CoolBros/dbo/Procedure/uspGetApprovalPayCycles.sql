/****** Object:  Procedure [dbo].[uspGetApprovalPayCycles]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetApprovalPayCycles]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT 
		pc.*,
		pcp.[description] as periodtype,
		pcg.Description as [group]
	FROM 
		PayrollCycle pc
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = pc.PayrollCycleGroupID
	INNER JOIN
		PayrollCyclePeriods pcp
	ON
		pcp.ID = pcg.PayrollCyclePeriodsID
	 WHERE
		pc.ClosedDate IS NULL AND pc.IsDeleted = 0 AND pcg.IsDeleted = 0 AND
		(
		(pcp.code = 'w' AND FromDate <= DATEADD(week, 4, GETDATE())) 
		or
		(pcp.code = 'f' AND FromDate <= DATEADD(week, 8, GETDATE()))
		or
		(pcp.code = 'm' AND FromDate <= DATEADD(week, 16, GETDATE()))
		)
	ORDER BY pc.fromdate asc
END

