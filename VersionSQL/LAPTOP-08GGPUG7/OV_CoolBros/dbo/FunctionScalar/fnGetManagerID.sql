/****** Object:  Function [dbo].[fnGetManagerID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetManagerID](@epId int)
RETURNS int
AS
BEGIN
	DECLARE @managerId int
	SELECT
		@managerId = mEp.ID
	FROM
		EmployeePosition ep
	INNER JOIN
		EmployeePosition mEp
	ON
		mEp.ID = ep.ManagerID
	WHERE
		ep.ID = @epID

	RETURN @managerId;
END

