/****** Object:  Procedure [dbo].[uspUpdateEmployeeProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployeeProject] 
	-- Add the parameters for the stored procedure here
	@id int, @projectID int, @centreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE EmployeeProject 
	SET PayCostCentreID= @centreID
	WHERE EmployeeID = @id
	AND ProjectID= @projectID
END

