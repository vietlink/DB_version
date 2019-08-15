/****** Object:  Procedure [dbo].[uspGetEmployeeProject]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployeeProject] 
	-- Add the parameters for the stored procedure here	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	c.description AS client,
	p.description AS project,
	e.displayname AS name,
	cc.description AS centre,
	epr.isDeleted AS status
	FROM 
	EmployeeProject epr
	INNER JOIN Employee e ON e.ID= epr.EmployeeID
	INNER JOIN Projects p ON p.id= epr.ProjectID
	INNER JOIN CostCentres cc ON cc.id= epr.PayCostCentreID
	INNER JOIN Clients c ON p.clientid= c.id	
	
END

