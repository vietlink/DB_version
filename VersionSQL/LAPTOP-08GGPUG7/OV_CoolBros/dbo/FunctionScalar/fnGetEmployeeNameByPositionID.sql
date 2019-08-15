/****** Object:  Function [dbo].[fnGetEmployeeNameByPositionID]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetEmployeeNameByPositionID](@posId int)
RETURNS varchar(255)
AS
BEGIN
	DECLARE @displayName varchar(255)
	SELECT TOP 1
		@displayName = e.Displayname
	FROM
		EmployeePosition ep
	INNER JOIN
		Employee e
	ON
		e.ID = ep.EmployeeID
	WHERE
		ep.PositionID = @posId AND ep.primaryposition = 'Y' AND ep.IsDeleted = 0;

	RETURN @displayName;
END

