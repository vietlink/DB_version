/****** Object:  Procedure [dbo].[uspGetPayrollCyclesByGroupID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCyclesByGroupID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select pc.id,
		pc.FromDate, 
		pc.ToDate,
		pc.ClosedDate,
		isnull(e.displayname,'') AS closedby,
		pp.Description AS periodName,
		pg.Description AS groupName,
		ps.Description AS status,
		pc.isDeleted 
		from PayrollCycle pc
		LEFT OUTER JOIN dbo.[User] e ON pc.ClosedByEmpID = e.id
		LEFT OUTER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.id
		LEFT OUTER JOIN PayrollCycleGroups pg ON pc.PayrollCycleGroupID= pg.ID
		INNER JOIN PayrollStatus ps ON pc.PayrollStatusID= ps.ID
		where (pg.Description like '%'+@filter+'%' OR ps.Description like '%'+@filter+'%' OR pp.Description like '%'+@filter+'%')
		and pc.IsDeleted= @status
		ORDER BY pc.id DESC
	end
	else begin
		select pc.id,
		pc.FromDate, 
		pc.ToDate,
		pc.ClosedDate,
		isnull(e.displayname,'') AS closedby,
		pp.Description AS periodName,
		pg.Description AS groupName,
		ps.Description AS status,
		pc.isDeleted
		from PayrollCycle pc
		LEFT OUTER JOIN dbo.[User] e ON pc.ClosedByEmpID = e.id
		LEFT OUTER JOIN PayrollCyclePeriods pp ON pc.PayrollCyclePeriodID = pp.id
		LEFT OUTER JOIN PayrollCycleGroups pg ON pc.PayrollCycleGroupID= pg.ID
		INNER JOIN PayrollStatus ps ON pc.PayrollStatusID= ps.ID
		where pg.ID=@id and pg.IsDeleted= @status
		ORDER BY pc.id DESC
	end
END

