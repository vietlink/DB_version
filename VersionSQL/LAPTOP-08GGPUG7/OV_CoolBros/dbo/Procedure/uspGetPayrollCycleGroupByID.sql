/****** Object:  Procedure [dbo].[uspGetPayrollCycleGroupByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleGroupByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(300), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select pg.ID, pg.Description , pg.StartDayIndex, dbo.fnConvertDayIndexToDate(pg.StartDayIndex) as Date, isnull(a.Description,'') as AccountSystem, pp.Description AS period 
		from PayrollCycleGroups pg
		INNER JOIN PayrollCyclePeriods pp ON pg.PayrollCyclePeriodsID = pp.id
		LEFT OUTER JOIN AccountsSystem a ON pg.AccountsSystemID= a.ID
		where pg.Description like '%'+@filter+'%'
		and pg.IsDeleted= @status
	end
	else begin
		SELECT pg.ID, pg.Description , pg.StartDayIndex, dbo.fnConvertDayIndexToDate(pg.StartDayIndex) as Date, pg.AccountsSystemID, pg.PayrollCyclePeriodsID from PayrollCycleGroups pg
		INNER JOIN PayrollCyclePeriods pp ON pg.PayrollCyclePeriodsID = pp.id
		LEFT OUTER JOIN AccountsSystem a ON pg.AccountsSystemID= a.ID
		where pg.ID=@id and pg.IsDeleted= @status
	end
END

