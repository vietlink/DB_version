/****** Object:  Procedure [dbo].[uspGetMostRecentPayroll]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetMostRecentPayroll] 
	-- Add the parameters for the stored procedure here	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1
	p.FromDate as FromDate,
	p.ToDate as ToDate,
	p.ClosedDate as CloseDate
	from PayrollCycle p
	where p.PayrollStatusID=2
	order by p.ClosedDate desc
END

