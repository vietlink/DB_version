/****** Object:  Procedure [dbo].[uspGetEmployeeByManagerEmpID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create PROCEDURE [dbo].[uspGetEmployeeByManagerEmpID] 
	-- Add the parameters for the stored procedure here
	@empManagerID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT *
	FROM Employee e
	LEFT OUTER JOIN EmployeePosition ep ON e.id= ep.employeeid AND ep.primaryposition='Y' AND ep.IsDeleted=0
	INNER JOIN EmployeePosition epM ON ep.ManagerID = epM.id AND epM.primaryposition='Y' AND epM.IsDeleted=0
	LEFT OUTER JOIN Employee eM ON eM.id= epM.employeeid
	WHERE eM.id= @empManagerID 
	AND e.IsPlaceholder!=1	
	AND e.displayname!='Vacant'

	ORDER BY e.displayname
END

