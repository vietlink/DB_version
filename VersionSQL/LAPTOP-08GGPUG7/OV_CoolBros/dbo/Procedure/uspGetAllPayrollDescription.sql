/****** Object:  Procedure [dbo].[uspGetAllPayrollDescription]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllPayrollDescription] 
	-- Add the parameters for the stored procedure here	
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
	where p.isDeleted=0
	
END
