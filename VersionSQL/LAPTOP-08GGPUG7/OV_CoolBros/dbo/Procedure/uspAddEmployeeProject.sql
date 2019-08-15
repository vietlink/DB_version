/****** Object:  Procedure [dbo].[uspAddEmployeeProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspAddEmployeeProject] 
	-- Add the parameters for the stored procedure here
	@empID int, @projectID int, @centreID int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO EmployeeProject ( ProjectID, EmployeeID, PayCostCentreID)
	VALUES(
	@projectID,
	@empID,
	@centreID)
END

