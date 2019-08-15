/****** Object:  Procedure [dbo].[uspGetPayrollCycleGroups]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleGroups]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT prg.*, pcp.Description as period
	FROM 
		PayRollCycleGroups prg
	INNER JOIN
		PayrollCyclePeriods pcp
	ON
		prg.PayrollCyclePeriodsID = pcp.ID
	WHERE
		prg.IsDeleted = 0
END

