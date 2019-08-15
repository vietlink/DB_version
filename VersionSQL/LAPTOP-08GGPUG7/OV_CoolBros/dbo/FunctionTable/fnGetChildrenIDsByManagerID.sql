/****** Object:  Function [dbo].[fnGetChildrenIDsByManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetChildrenIDsByManagerID](@ManagerEmpID int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		ep.ID
	FROM
		EmployeePosition ep
	INNER JOIN
		EmployeePosition mEp
	ON
		ep.ManagerID = mEp.ID
	INNER JOIN	
		Employee mE
	ON
		mEp.EmployeeID = mE.id
	WHERE
		mE.id = @ManagerEmpID AND ep.IsDeleted = 0
)

