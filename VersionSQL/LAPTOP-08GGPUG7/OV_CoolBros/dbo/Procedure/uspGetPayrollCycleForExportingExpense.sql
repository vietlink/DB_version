/****** Object:  Procedure [dbo].[uspGetPayrollCycleForExportingExpense]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleForExportingExpense] 
	-- Add the parameters for the stored procedure here
	@isFinalisedInclude int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE @currentIndex int= (SELECT ID FROM PayrollCycle WHERE FromDate<= GETDATE() AND ToDate>= GETDATE() AND isDeleted=0)
    -- Insert statements for procedure here
	IF (@isFinalisedInclude=0) BEGIN
		select pc.id, 
		pc.description, 
		pc.fromdate, 
		pc.todate, 
		pg.id as groupID,
		rank() over( partition by pg.description order by pc.fromdate) as _index into #temp
		from PayrollCycle pc
		left outer join PayrollCycleGroups pg on pc.PayrollCycleGroupID= pg.ID
		left outer join PayrollCyclePeriods pp on pc.PayrollCyclePeriodID= pp.ID
		INNER JOIN PayrollStatus ps ON pc.ExpensePayrollStatusID= ps.ID
		where 
		pg.isDeleted=0 and pc.isDeleted=0		
		AND ps.Code='O'
		order by pg.Description, pc.FromDate 

		select _index+4 as startIndex, groupID into #tempIndex from #temp 
		where FromDate<=convert(datetime,convert(varchar(8),getdate(),112)) and ToDate>=convert(datetime,convert(varchar(8),getdate(),112))

		select #temp.*	
		from #temp inner join #tempIndex on #temp.groupID= #tempIndex.groupID
		where #temp._index<=#tempIndex.startIndex 
		order by #temp.ToDate
		drop table #temp
		drop table #tempIndex
	END ELSE BEGIN
		select pc.id, 
		pc.description, 
		pc.fromdate, 
		pc.todate, 
		pg.id as groupID,
		rank() over( partition by pg.description order by pc.fromdate desc) as _index into #temp1
		from PayrollCycle pc
		left outer join PayrollCycleGroups pg on pc.PayrollCycleGroupID= pg.ID
		left outer join PayrollCyclePeriods pp on pc.PayrollCyclePeriodID= pp.ID
		INNER JOIN PayrollStatus ps ON pc.ExpensePayrollStatusID= ps.ID
		where 
		pg.isDeleted=0 and pc.isDeleted=0				
		order by pg.Description, pc.FromDate desc

		select _index-4 as startIndex, groupID into #tempIndex1 from #temp1
		where FromDate<=convert(datetime,convert(varchar(8),getdate(),112)) and ToDate>=convert(datetime,convert(varchar(8),getdate(),112))

		select #temp1.*	
		from #temp1 inner join #tempIndex1 on #temp1.groupID= #tempIndex1.groupID
		where #temp1._index>=#tempIndex1.startIndex 
		order by #temp1.ToDate desc
		drop table #temp1
		drop table #tempIndex1
	END
END

