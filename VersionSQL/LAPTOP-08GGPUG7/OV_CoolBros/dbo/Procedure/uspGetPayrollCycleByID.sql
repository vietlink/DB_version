/****** Object:  Procedure [dbo].[uspGetPayrollCycleByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleByID](@id int)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
		pc.*, ps.Code AS StatusCode, ps_e.Description AS ExpenseStatusCode, ps.Description AS status, pp.Code as PeriodCode, pcg.StartDayIndex, isnull(e.displayname,'') as expensename
	FROM
		PayrollCycle pc
	INNER JOIN
		PayrollStatus ps
	ON
		ps.ID = pc.PayrollStatusID
	INNER JOIN 
		PayrollStatus ps_e
	ON
		ps_e.ID= pc.ExpensePayrollStatusID
	INNER JOIN
		PayrollCyclePeriods pp
	ON
		pp.ID = pc.PayrollCyclePeriodID
	INNER JOIN
		PayrollCycleGroups pcg
	ON
		pcg.ID = pc.PayrollCycleGroupID
	LEFT OUTER JOIN 
		Employee e
	ON
		pc.ExpenseFinalisedByEmpID= e.id
	WHERE
		pc.ID = @id;
END

