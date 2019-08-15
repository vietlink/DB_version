/****** Object:  Function [dbo].[fnGetEmployeeIDByManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
create FUNCTION [dbo].[fnGetEmployeeIDByManagerID] 
(	
	-- Add the parameters for the function here
	@managerID int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT
		e.ID
	FROM
		Employee e 
	INNER JOIN 
		EmployeePosition ep
	ON 
		e.id= ep.employeeid
	INNER JOIN
		EmployeePosition mEp
	ON
		ep.ManagerID = mEp.ID
	INNER JOIN	
		Employee mE
	ON
		mEp.EmployeeID = mE.id
	WHERE
		mE.id = @managerID AND ep.IsDeleted = 0
)

