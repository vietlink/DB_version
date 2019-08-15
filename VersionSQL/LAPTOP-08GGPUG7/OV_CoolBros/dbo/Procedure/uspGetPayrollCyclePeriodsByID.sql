/****** Object:  Procedure [dbo].[uspGetPayrollCyclePeriodsByID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPayrollCyclePeriodsByID] 
	-- Add the parameters for the stored procedure here
	@id int, @filter varchar(15), @status bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if (@id=0) begin
		select * from PayrollCyclePeriods
		where (Description like '%'+@filter+'%')
		and IsDeleted= @status
		ORDER BY SortOrder
	end
	else begin
		SELECT * from PayrollCyclePeriods where ID=@id and IsDeleted= @status ORDER BY SortOrder
	end
END

