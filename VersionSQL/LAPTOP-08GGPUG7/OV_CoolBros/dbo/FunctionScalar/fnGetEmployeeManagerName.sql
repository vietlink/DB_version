/****** Object:  Function [dbo].[fnGetEmployeeManagerName]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmployeeManagerName](@epId int)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @displayName varchar(255);

	SELECT
		TOP 1 @displayName = e.Displayname
	FROM
		EmployeePosition ep
	INNER JOIN
		EmployeePosition mEp
	ON
		mEp.ID = ep.ManagerID
	INNER JOIN
		Employee e
	ON
		e.ID = mEp.EmployeeID
	WHERE
		ep.ID = @epID

	RETURN @displayName;
END

