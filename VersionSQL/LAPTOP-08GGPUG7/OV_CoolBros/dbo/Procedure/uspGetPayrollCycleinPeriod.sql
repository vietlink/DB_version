/****** Object:  Procedure [dbo].[uspGetPayrollCycleinPeriod]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCycleinPeriod] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	select pc.id, pc.description, pc.fromdate, pc.todate, pg.id as groupID,
	rank() over( partition by pg.description order by pc.fromdate desc) as _index into #temp
	from PayrollCycle pc
	left outer join PayrollCycleGroups pg on pc.PayrollCycleGroupID= pg.ID
	left outer join PayrollCyclePeriods pp on pc.PayrollCyclePeriodID= pp.ID
	where pg.isDeleted=0 and pc.isDeleted=0
	order by pg.Description, pc.FromDate desc

	select _index-4 as startIndex, _index+12 as endIndex, groupID into #tempIndex from #temp 
	where FromDate<=convert(datetime,convert(varchar(8),getdate(),112)) and ToDate>=convert(datetime,convert(varchar(8),getdate(),112))

	select #temp.*
	--,MIN(#temp.fromdate) as minDate, MAX(#temp.todate) as toDate
	 from #temp inner join #tempIndex on #temp.groupID= #tempIndex.groupID
	where #temp._index>=#tempIndex.startIndex and #temp._index<=#tempIndex.endIndex
	order by #temp.FromDate desc
	drop table #temp
	drop table #tempIndex
END

